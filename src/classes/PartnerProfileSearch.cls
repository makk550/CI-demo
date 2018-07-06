public with sharing class PartnerProfileSearch {
    
    public PartnerProfileAccountSearchRequest req  {get;set;}
    public List<PartnerProfileAccounts> res{get;set;}
    // Status - after parsing the response
    public String requestStatus {get;set;}
    // Error - either in the call out or in the response
    public String requestErrorDetail{get;set;}
    
    
    public PartnerProfileSearch()
    {
        req = new PartnerProfileAccountSearchRequest();
        res = new List<PartnerProfileAccounts>();
    }
    
    
    public void callEAIPartnerPofileService() {
    
        Boolean istest = true;
        
        HttpRequest req = new HttpRequest();
        HTTPResponse resp = new HTTPResponse();
        
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml');
        req.setHeader('consumerApp', 'SFDC'); 
        System.debug('End point'+System.Label.PartnerProfileAccountSearch);
        req.setEndpoint(System.Label.PartnerProfileAccountSearch); // https://eaisvc.ca.com/mdm/accounts/r.v1, http://esbseqqa.ca.com/mdm/accounts/upsert/r.v1/,https://esbqafs.ca.com/mdm/accounts/search/r.v1?test
        //consumerApp	SFDC
        //consumerUsername	<pmfkey>	(optional)
        req.setBody(generateXML());
        System.debug('Print req body'+req.getBody());
        req.setTimeout(120000);
        
        Http http = new Http();
        String respBody = null;
        
        if(istest)
        {
        System.debug('Calling service');  
            try {
            resp = http.send(req);
           System.debug('Print resp body'+ resp.getBody());
            } catch (Exception e) {
            	System.debug('Exception e1'+e.getMessage());
                try {
                resp = http.send(req);
                System.debug('Print resp body'+ resp.getBody());
                } 
                catch(Exception e1) {
                System.debug('Exception e2'+e.getMessage());
                 requestErrorDetail = 'The system was unable to process your request, please try again.'; 
                 
                    }
            }
        
        
        }
        else
        {
            resp.setStatusCode(200);
            resp.setBody(getSamplePartnerProfileSearchResult());
            System.debug('Print DUMMY resp body'+ resp.getBody());
        }
        
        if(resp.getStatusCode() == 200)
        {
           
            parseXML(resp);
            System.debug('Inside Call service'+ res);
            System.debug('Inside Call service'+ requestStatus);
            System.debug('Inside Call service'+ requestErrorDetail);
        }
        else
        {
            
            requestErrorDetail = 'Account Search Web Service Call responded with the StatusCode '+resp.getStatusCode()+'. No results found in MDM for the selected Duns. '; 
        }
       
    }
    
    public String generateXML()
    {
        String inputRequest ='';
        Xmlstreamwriter xsw = new Xmlstreamwriter();
        xsw.writeStartDocument('utf-8','1.0');
        xsw.writeStartElement(null, 'accountSearchRequest', null);
        
        xsw.writeStartElement(null, 'source', null);
        
        xsw.writeStartElement(null, 'name', null);
        xsw.writeCharacters(req.name);
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'country', null);
        xsw.writeCharacters(req.country);
        xsw.writeEndElement();
        
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'dunsHitLimit', null);
        xsw.writeCharacters(String.valueOf(req.dunsHitLimit));
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'dunsMinConfidenceLevel', null);
        xsw.writeCharacters(String.valueOf(req.dunsMinConfidenceLevel));
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'thresholdValue', null);
        xsw.writeCharacters(String.valueOf(req.thresholdValue));
        xsw.writeEndElement();
         
        xsw.writeStartElement(null, 'weightages', null);
        
        xsw.writeStartElement(null,'accountName',null);
        xsw.writeCharacters(String.valueOf(req.accountNameWeight));
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'sites', null);
        xsw.writeCharacters(String.valueOf(req.sitesNameWeight));
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'duns', null);
        xsw.writeCharacters(String.valueOf(req.dunsNameWeight));
        xsw.writeEndElement();
       
        xsw.writeEndElement();
        
        xsw.writeStartElement(null, 'strategies', null);
        xsw.writeStartElement(null, 'strategy', null);
        xsw.writeAttribute(null, null, 'name', 'PartnerSearch');
        xsw.writeEndElement();
        xsw.writeEndElement();
        
        xsw.writeEndElement();
        xsw.writeEndDocument();
        System.debug('____dunsReq' + xsw.getXmlString());
        
        inputRequest = xsw.getXmlString();
        xsw.close();
        return inputRequest;
    } 
    
    public void parseXML(HTTPResponse response)
    {
    	//
    	try {
        System.debug('parseXML');
        Integer i=0;
        Dom.Document doc = response.getBodyDocument();
        System.debug('Parse xml doc'+ doc.toXmlString() );
        
        Dom.XMLNode  xmlaccountSearchResponse = doc.getRootElement();
        System.debug('Parse xml root '+ xmlaccountSearchResponse.getName()  );
        
        
        if(xmlaccountSearchResponse != null)
        {
            if(xmlaccountSearchResponse.getChildElement('status',null)!= null)
            {
                requestStatus = xmlaccountSearchResponse.getChildElement('status',null).getText();
                System.debug('Parse xml status '+ requestStatus  );
            }
            if(xmlaccountSearchResponse.getChildElement('errordetail',null)!= null)
            {
                requestErrorDetail = xmlaccountSearchResponse.getChildElement('errordetail',null).getText();
                System.debug('Parse xml error '+ requestErrorDetail  );
            }
            // Account Results from MDM
            if(xmlaccountSearchResponse.getChildElement('searchResults',null)!= null)
            {
                Dom.XMLNode searchResults = xmlaccountSearchResponse.getChildElement('searchResults',null);
                for(Dom.XMLNode account : searchResults.getChildElements())
                {
                    System.debug('Parse xml Searchresult account '+ account.getName()  );
                    PartnerProfileAccounts p = new PartnerProfileAccounts();
                    
                       
                        if(account.getChildElement('name',null)!= null)
                        p.name = account.getChildElement('name',null).getText();
                        if(account.getChildElement('street',null)!= null)
                        p.street = account.getChildElement('street',null).getText();
                        if(account.getChildElement('city',null)!= null)
                        p.city = account.getChildElement('city',null).getText();
                        if(account.getChildElement('state',null)!= null)
                        p.state = account.getChildElement('state',null).getText();
                        if(account.getChildElement('country',null)!= null)
                        p.country = account.getChildElement('country',null).getText();
                        
                        if(account.getChildElement('postalCode',null)!= null)
                        p.postalcode = account.getChildElement('postalCode',null).getText();
                        if(account.getChildElement('website',null)!= null)
                        p.website = account.getChildElement('website',null).getText();
                        
                        if(account.getChildElement('accountId',null)!= null)
                        p.accountid = account.getChildElement('accountId',null).getText();
                        if(account.getChildElement('accountType',null)!= null)
                        p.accounttype = account.getChildElement('accountType',null).getText();
                        if(account.getChildElement('dunsNumber',null)!= null)
                        p.dunsNumber = account.getChildElement('dunsNumber',null).getText();
                        if(account.getChildElement('globalUltimateParent',null)!= null)
                        p.globalUltimateParent = account.getChildElement('globalUltimateParent',null).getText();
                        if(account.getChildElement('score',null)!= null)
                        p.score = Integer.valueOf(account.getChildElement('score',null).getText());
                        if(account.getChildElement('strategy',null)!= null)
                        p.strategy = account.getChildElement('strategy',null).getText();
                        p.ExistingPartner = true;
                        p.labelNumber = i;
                        
                    
                    res.add(p);
                    i++;
                }
            }
            // Account Results from  D&B
            if(xmlaccountSearchResponse.getChildElement('dnbResultsNotInMDM',null)!= null)
            {
                Dom.XMLNode searchResults = xmlaccountSearchResponse.getChildElement('dnbResultsNotInMDM',null);
                
                for(DOM.Xmlnode account: searchResults.getChildElements())
                {
                 System.debug('Parse xml DUNS Searchresult account '+ account.getName()  );
                PartnerProfileAccounts p = new PartnerProfileAccounts();
                
                        if(account.getChildElement('name',null)!= null)
                        p.name = account.getChildElement('name',null).getText();
                        if(account.getChildElement('street',null)!= null)
                        p.street = account.getChildElement('street',null).getText();
                        if(account.getChildElement('city',null)!= null)
                        p.city = account.getChildElement('city',null).getText();
                        if(account.getChildElement('state',null)!= null)
                        p.state = account.getChildElement('state',null).getText();
                        if(account.getChildElement('country',null)!= null)
                        p.country = account.getChildElement('country',null).getText();
                        //p.country = 'JP - JAPAN';
                        if(account.getChildElement('postalCode',null)!= null)
                        p.postalcode = account.getChildElement('postalCode',null).getText();
                        p.ExistingPartner = false;
                        p.labelNumber = i;
                
                res.add(p);
                i++;
            }
            }
            
            
        }
        
    	}
    	catch(Exception e)
    	{
    		System.debug('Error in Parsing XML '+e.getMessage());
    	}
        
    }
    
    String getSamplePartnerProfileSearchResult()
   {
        String xml = '<?xml version="1.0" encoding="utf-8"?>';
        
        xml += '<accountSearchResponse> <status>OK</status><errordetail /><searchResults>';
        xml +='<account><name>SCM</name><street>1 Ca Plz</street><city>Islandia</city> <state>NY</state><postalCode>11788</postalCode><country>US</country> <accountId>PL01697</accountId><score>900</score><strategy>DUNS</strategy></account>';
        xml+='<account><name>Apple </name><street>200 Brodway St</street><city>NYC</city><state>NY</state><postalCode>10001</postalCode> <country>US</country> <accountId>PE17040</accountId><score>300</score><strategy>DUNS</strategy></account></searchResults>';
        xml += '<dnbResultsNotInMDM> <account><name>IBM</name><street>200 Brodway St</street><city>NYC</city><state>NY</state><postalCode>10001</postalCode><country>US</country><duns>568</duns></account></dnbResultsNotInMDM>';
        xml += '<accountSearchRequest> <source><name>Microsoft</name><street /><!--Optional:--><city>Islandia</city><!--Optional:--><state>NY</state> <!--Optional:--><postalCode /><!--Optional:--><country>US</country></source><!--Optional:--><!--Default to 5--><dunsHitLimit />';
        xml +='<!--Optional:--><thresholdValues><threshold name="AccountName" weight="1" /><threshold name="Sites" weight="2" /><threshold name="DUNS" weight="7" /></thresholdValues><strategies><strategy name="PartnerSearch" /> </strategies></accountSearchRequest></accountSearchResponse>';

    return xml;
   }
   
   public void populateAddress(List<PartnerProfileAccounts> r)
   {
   		if(r!= null)
   		for(PartnerProfileAccounts r1: r)
   		{
   			if(r1.street != null && r1.street != '') r1.address = r1.address + r1.street+',';
   			if(r1.city != null && r1.city != '') r1.address = r1.address +r1.city+',';
   			if(r1.state != null && r1.state != '') r1.address = r1.address + r1.state +',';
   			if(r1.country != null && r1.country != '') r1.address = r1.address  +r1.country;
   			
   			if(r1.address.endsWith(',')) r1.address = r1.address.substring(0,r1.address.length()-1);
   			
   		}
   		
   		System.debug('Inside populateAddress'+ r);
   		
   }
   
   public Class PartnerProfileAccounts
   {
        public String name{get;set;}
        public String street{get;set;}
        public String city{get;set;}
        public String state {get;set;}
        public String country {get;set;}
        public String address {get;set;}
        public String postalcode {get;set;}
        public String website{get;set;}
        public String accountid {get;set;}
        public String accounttype{get;set;}
        public String dunsNumber{get;set;}
        public String globalUltimateParent{get;set;}
        public Integer Score {get;set;}
        public String strategy{get;set;}
        public Boolean ExistingPartner{get;set;}
        public Boolean isChecked{get;set;}
        public Integer labelNumber{get;set;}
        public PartnerProfileAccounts()
        {
            name = street =city =postalcode=state=country=address=accountid=strategy=website=accounttype=dunsNumber=globalUltimateParent='';
            Score =0;
            labelNumber=-1;
            ExistingPartner = isChecked= false;
        }
        public PartnerProfileAccounts(String name,String street,String city,String state,String country,String website,String postalcode,String accountid,String accounttype,String dunsNumber,Integer Score,String strategy, String globalUltimateParent,Integer labelNumber)
        {
            this.name = name;
            this.street = street;
            this.city = city;
            this.postalcode = postalcode;
            this.state = state;
            this.country = country;
            this.accountid= accountid;
            this.Score= Score;
            this.strategy= strategy;
            this.website = website;
            this.accounttype = accounttype;
            this.dunsNumber = dunsNumber;
            this.globalUltimateParent =globalUltimateParent;
            this.labelNumber = labelNumber;
            ExistingPartner = false;
            address ='';
            
        }
        
   }
   
   public class PartnerProfileAccountSearchRequest
   {
        public String name {get;set;}
        public String country {get;set;}
        
        public Integer dunsHitLimit {get;set;}
        public Integer dunsMinConfidenceLevel{get;set;}
        public String strategy{get;set;}
        
        public Integer accountNameWeight{get;set;}
        public Integer sitesNameWeight{get;set;}
        public Integer dunsNameWeight{get;set;}
        public Integer thresholdValue{get;set;}
        
        PartnerProfileAccountSearchRequest()
        {
            dunsHitLimit = 5;
            accountNameWeight= 1;
            sitesNameWeight= 2;
            dunsNameWeight = 7;
            strategy = 'PartnerSearch';
            thresholdValue= 3000;
            dunsMinConfidenceLevel=1;
            
            
            
        }
        
        
     
   }

}