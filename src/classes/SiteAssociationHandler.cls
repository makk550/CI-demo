public with sharing class SiteAssociationHandler implements ITrigger{
public static boolean inFutureContext = false;
    public SiteAssociationHandler(){
    }
        
       
    
     @future(callout=true)
      public static void doSanctionedPartyCheck(Id SiteAssociationId){
      
        inFutureContext = false;
         String SanctionedPartyStatus;
        Site_Association__c SA = [select name,SC_SITE_Sanctioned_Party__c,Enterprise_ID__c,Enterprise_ID__r.Enterprise_ID__c,Postal_Code__c,country_picklist__c,City__c,DUNS_Name__c from Site_Association__c where Id=:SiteAssociationId];  
        try{         
            String endPoint = label.SC_Sanction_Party_End_Point;
            if(SA.country_picklist__c != null && SA.country_picklist__c != '')
                endPoint+='country='+Country_ISO__c.getInstance(SA.country_picklist__c).code__c;
            if(SA.Postal_Code__c != null && SA.Postal_Code__c != '')
                endPoint+='&zip='+EncodingUtil.urlEncode(SA.Postal_Code__c, 'UTF-8');               
            if(SA.City__c != null && SA.City__c != '')
                endPoint+='&city='+EncodingUtil.urlEncode(SA.City__c, 'UTF-8');
            if(SA.Name != null && SA.Name != '')
                endPoint+='&name1='+EncodingUtil.urlEncode(SA.Name, 'UTF-8');
            if(SA.Enterprise_ID__c != null && (SA.Enterprise_ID__r.Enterprise_ID__c != null || SA.Enterprise_ID__r.Enterprise_ID__c != ''))
                endPoint+='&partnerid=SVCL'+SA.Enterprise_ID__r.Enterprise_ID__c;                 //KUMGA08 CR:300-327927

            endPoint+='&systemid='+label.SC_Sanction_Party_System_Id+'&format=xml';
            /*
            Pattern nonWordChar = Pattern.compile('\\s');
            endPoint = nonWordChar.matcher(endPoint).replaceAll('+');
            */
            System.debug('+++++endPoint+++++'+endPoint);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            req.setTimeOut(60000);
            String authorizationHeader = 'Basic '+Label.SC_Authorization_Header;
            req.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            HTTPResponse res = http.send(req);
             
            System.debug(' response body'+ res.getBody());
            Dom.Document doc = res.getBodyDocument();
            
            //Retrieve the root element for this document.
            Dom.XMLNode rootElement = doc.getRootElement();         
            Dom.XmlNode[] childrenOfRootElement = rootElement.getChildren();
            Dom.XmlNode[] childrenOfItem;
            for(Dom.XmlNode d : childrenOfRootElement){
                System.debug('+++XML Nodes++'+d.getChildren());
                childrenOfItem = d.getChildren();
            }
            for(Dom.XmlNode d : childrenOfItem){
                if(d.getName().equalsIgnoreCase('MATCHSTATUS')){
                    /*if(d.getText().equalsIgnoreCase('BLOCKED'))
                        SanctionedPartyStatus = 'YES';*/
                    if(d.getText().equalsIgnoreCase('Success'))
                        SanctionedPartyStatus = 'NO';
                    else if(d.getText().equalsIgnoreCase('Error'))
                        SanctionedPartyStatus = 'GTS ERROR';
                    else
                        SanctionedPartyStatus = 'NOT VALIDATED';//Added By Sreehari for DE133457 Fix
                    break;
                }
            }            
            SA.SC_SITE_Sanctioned_Party__c = SanctionedPartyStatus;
            inFutureContext=true;
            System.debug('Just before updating...');
              update SA;
            System.debug('Just after updating...');
          
        }catch(Exception e){     
            System.debug('Exception Message from Catch - ' + e.getMessage());       
            SA.SC_SITE_Sanctioned_Party__c = 'GTS ERROR';
            //SA.SC_SITE_Sanctioned_Party__c = 'NOT VALIDATED';
          inFutureContext=true;
            update SA;
        }
     
    }
            
    
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore() {
       
    }
    public void bulkAfter() {
    }
         
    public void beforeInsert(SObject so) {

    }

    public void beforeUpdate(SObject oldSo, SObject so) {
        
    }
    /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so){  
        

    }

     

    public void afterInsert(SObject so){

    }
  

    public void afterUpdate(SObject oldSo, SObject so){

    }
    public void afterDelete(SObject so){

    }
    /**
     * andFinally
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally(){ 

    }

  
}