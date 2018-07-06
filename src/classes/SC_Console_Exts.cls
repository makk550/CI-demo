public without sharing class  SC_Console_Exts {
    public String siteName{get; set;}
    public String sfdcId{get; set;}
    public String siteId{get; set;}
    public String caAccountId{get; set;}
    public String street{get; set;}
    public String city{get; set;}
    public String postalCode{get; set;}
    public String state{get; set;}
    public String country{get; set;}
    public List<SelectOption> countryList {get;set;}
    public String siteAssociationStreet {get;set;}
    public String siteAssociationCity {get;set;} 
    public String siteAssociationPostalCode {get;set;}
    public String siteAssociationState {get;set;}
    public boolean showResults{get; set;}
    public boolean hideLinks{set;get;}
    public boolean showForm{set;get;}
    public String objectId{set;get;}
  //added for populating search fields
    public String newSiteFlow {get;set;}
    
    public Site_Association__c siteAssc;
    public SC_Console_Exts(ApexPages.StandardController controller) {
        //hideLinks = true;
        //showForm = false;
        showResults = false;
        street = '';
        city='';
        siteId='';
        postalCode='';
        state='';
        countryList = new List<SelectOption>();
        siteAssociationStreet = '';
        siteAssociationState = '';
        siteAssociationCity = ''; 
        siteAssociationPostalCode = '';
        siteAssc = (Site_Association__c)controller.getRecord();
        Schema.sObjectType objType = Site_Association__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        System.debug('+++++++++++++++'+objDescribe.keyPrefix);
        objectId = '/'+objDescribe.keyPrefix+'/o'; 
        System.debug('++++++++objectId+++++++'+objectId);
        countryList.add(new SelectOption('--None--','--None--'));
        Schema.DescribeFieldResult fieldResult = Site_Association__c.Country_picklist__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry picklist : ple){
         countryList.add(new SelectOption(picklist.getLabel(),picklist.getValue()));
         newSiteFlow ='';
        } 
    }
    public SC_Console_Exts(){}
    public void MDMSearch(){
        
    }
    public PageReference selectRadio(){
        return Page.SC_MDM_Site_Search; 
    }
    public PageReference selected(){
         
        String redir = '/';
        if(siteId != null) {

           List <Site_Association__c> siteNavigate = [Select s.SC_TOPS_ID__c, s.Id From Site_Association__c  s where s.SAP_Site_ID__c = :siteId limit 1];
              if(siteNavigate!=null && siteNavigate.size()>0){
                redir = redir+siteNavigate[0].Id;
             
            }
            else{
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Site Not Found');
                 ApexPages.addMessage(myMsg);
                 return null;
            }
             
        }
        else {
        
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Selected Record dont have valid  SiteID .');
            ApexPages.addMessage(myMsg);
            return null;
        }
            system.debug('redir url ----'+redir);
            PageReference pr = new PageReference(redir);
           return pr ; 

    }
    
    public void search(){
    
        System.debug('********************++++++++++++++++++++');
        if(siteName !=null && country !=null && siteName!='' && country !='--None--' ){
            String endpoint= Label.MDMSiteSearchQA;
            if(ApexPages.currentPage().getHeaders().get('Host').left(2).equalsignorecase('na')){
                endpoint = Label.MDMSiteSearchProd;
            }
           String UserName= Label.EAIConsumerUserNameService;
            HttpRequest req = new HttpRequest(); 
            req.setMethod('POST');
            req.setHeader('content-type', 'text/xml');
            //req.setHeader('Authorization', 'Basic U1BMVXNlcjpzcGwkYXV0aG9yMXplZA==');
            req.setHeader('Authorization', 'Basic RUFJOjM0MQ==');
            req.setHeader('consumerUsername',UserName);
            req.setEndpoint(endpoint);    
           
                      
            Xmlstreamwriter xsw = new Xmlstreamwriter();
            xsw.writeStartElement(null,'searchRequest', null);
                xsw.writeStartElement(null,'source',null);
                    xsw.writeStartElement(null,'name',null);
                        xsw.writeCharacters(siteName);
                    xsw.writeEndElement();
                    if(street!=null){
                        xsw.writeStartElement(null,'street',null);
                            xsw.writeCharacters(street);
                        xsw.writeEndElement();
                    }
                    if(city!=null){
                        xsw.writeStartElement(null,'city',null);
                            xsw.writeCharacters(city);
                        xsw.writeEndElement();
                    }
                    if(state!=null){
                        xsw.writeStartElement(null,'region',null);
                            xsw.writeCharacters(state);
                        xsw.writeEndElement();
                    }
                    if(country!=null){
                        xsw.writeStartElement(null,'country',null);
                            xsw.writeCharacters(country.substring(0,2));
                        xsw.writeEndElement();
                    }
                    if(postalcode!=null){
                        xsw.writeStartElement(null,'postalCode',null);
                            xsw.writeCharacters(postalcode);
                        xsw.writeEndElement();
                    }
                xsw.writeEndElement();
                xsw.writeStartElement(null,'strategies',null);
                    xsw.writeStartElement(null,'strategy',null);
                        xsw.writeAttribute(null,null,'name','SAP-Name-Address-TOPS');
                    xsw.writeEndElement();
                xsw.writeEndElement();
                xsw.writeStartElement(null,'mdmStrategyName',null);
                        xsw.writeCharacters('Match_SC_Customer');
                xsw.writeEndElement();  
            xsw.writeEndElement();
            System.debug('____dunsReq'+xsw.getXmlString());
            req.setBody(xsw.getXmlString()); 
            req.setTimeout(60000);             
            Http http = new Http();
            String respBody ='';
            try {
                HTTPResponse res = http.send(req);
              
              //  System.debug(res.getBody());
                if(res.getStatusCode() == 200) {
                     System.debug('**************'+res.getBody());
                    respBody = res.getBody();
                    results = parseResponse(new XMLStreamReader(respBody));
                                    
                }
             } catch (Exception e) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'There has been an error. Please contact System Adminintrator');
                ApexPages.addMessage(myMsg);
             }
        
            showResults = true;
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please enter Name and Country');
            ApexPages.addMessage(myMsg);
        }  
    }
    public List<SC_Console_Exts_Inner> results{get; set;}
    public List<SC_Console_Exts_Inner> parseResponse(XmlStreamReader reader) {
        List<SC_Console_Exts_Inner> innerList= new List<SC_Console_Exts_Inner>();
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('Match' == reader.getLocalName()) {
                    SC_Console_Exts_Inner innerObj = parseInner(reader);
                    innerList.add(innerObj);
                }
            }
            reader.next();
        }
        return innerList;
    }
   
    SC_Console_Exts_Inner parseInner(XmlStreamReader reader) {
        SC_Console_Exts_Inner innerObj = new SC_Console_Exts_Inner();
        innerObj.score = Integer.valueOf(reader.getAttributeValue(null, 'score'));
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                if ('Match' == reader.getLocalName()) {
                    break;  
                }
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                
                if ('name' == reader.getLocalName()) {
                innerObj.name = getValueFromTag(reader);
            }
            else if ('city' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.city = getValueFromTag(reader);
            } else if ('country' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.country = getValueFromTag(reader);
            } else if ('dunsNumber' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.dunsNumber = getValueFromTag(reader);
            } else if ('regionName' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.state = getValueFromTag(reader);
            } else if ('postalCode' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.postalCode = getValueFromTag(reader);
            } else if ('street' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.street = getValueFromTag(reader);
            } else if ('accountId' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.caAccountId = getValueFromTag(reader);
            } else if ('id' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.siteId = getValueFromTag(reader);
            }else if ('system' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.systemName= getValueFromTag(reader);
            }else if ('sfdcId' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.sfdcId= getValueFromTag(reader);
            }else if ('externalId' == reader.getLocalName()) {
                // If you find any other opening tag, extract the string value
                innerObj.topsSiteId= getValueFromTag(reader);
            }                                                    
            }
            reader.next();
        }
        return innerObj;
    }
    public string getValueFromTag(XMLStreamReader reader) {
        String DataValue;
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                DataValue = reader.getText();
            }
            reader.next();
        }
        return DataValue;
    }
    
    public class SC_Console_Exts_Inner{
        public Boolean selected{get; set;}
        public String name{get; set;}
        public Integer score{get; set;}
        public String dunsNumber{get; set;}
        public String city{get; set;}
        public String country{get; set;}
        public String systemName{get; set;}
        public String sfdcId{get; set;}
        public String siteId{get; set;}
        public String caAccountId{get; set;}
        public String state{get; set;}
        public String postalcode{get; set;}
        public string street{get; set;}
        public string topsSiteId{get; set;}
    }

}