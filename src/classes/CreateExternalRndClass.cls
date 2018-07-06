public with sharing class CreateExternalRndClass {
    private  External_RnD__c externalRnD ;
    private String validationStatus ;
    private String solutionDistribution;
    private String solutionStatus;
    public Boolean updateStarCase=false;
    private Id recordTypeId ;    
    public Static ValidateExternalRnDMock mock ;  
    public Boolean showButton {get;set;}
    public String name {get;set;}
        // The extension constructor initializes the private member
        // variable externalRnD by using the getRecord method from the standard
        // controller.
        public CreateExternalRndClass(ApexPages.StandardController stdController) {
            this.externalRnD = (External_RnD__c)stdController.getRecord();
            recordTypeId = externalRnD.RecordTypeId;        
            if(externalRnD.Id!=null){       
                name = [select name from External_RnD__c where Id = : externalRnD.id].name ;        
            }
        }
    public pageReference Validate(){
    system.debug('***********hello');
        try{
             if(((externalRnD.External_System__c=='Star') &&  (externalRnD.Type__c == 'Problem' || externalRnD.Type__c == 'Solution'))){
                if(externalRnD.Component_ID__c==null || externalRnD.Component_ID__c=='' ){
                    ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'Enter Component Id ');
                    ApexPages.addmessage(errMsg); 
                    return null;
                }
                if ((externalRnD.Type__c == 'Solution' ) && (externalRnD.Component_Release__c ==null || externalRnD.Component_Release__c=='')){             
                    ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'Enter Component Release');
                    ApexPages.addmessage(errMsg); 
                    return null;    
                }
                String endpoint =  buildEndpoint();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                system.debug('============'+endpoint);
                req.setMethod('GET');
                Http http = new Http();
                HTTPResponse res;
                if(!Test.isRunningTest()){
                     res = http.send(req);
                }
                else{
                     
                    res = mock.respond(req);
                }
                system.debug('#######33response'+res.getBody());
                XmlStreamReader reader = new XmlStreamReader(res.getBody());
                while(reader.hasNext()) {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) {
                        if ('ValidateProbSolData' == reader.getLocalName()) {
                            solutionDistribution=reader.getAttributeValue(null, 'solutionDistribution');
                            solutionStatus= reader.getAttributeValue(null, 'solutionStatus');
                            validationStatus =  reader.getAttributeValue(null, 'validationStatus'); 
                            externalRnD.Validate__c = validationStatus;
                            
                        }
                    }
                    reader.next();
                } 
                
                system.debug('@@@@@@@@@ solution distribution'+solutionDistribution+'solutionstatus'+solutionStatus);
                if(solutionDistribution!=null && solutionStatus!=null)
                {
                solutionDistribution=solutionDistribution.trim();
                solutionStatus=solutionStatus.trim();
                system.debug('&&&&&&& in null check');
                if(!((solutionDistribution.equalsIgnoreCase('AVAILABLE'))&&(solutionStatus.equalsIgnoreCase('CONFIRMED')))){
                updateStarCase=true;
                system.debug('^^^^in solutiondistributionif condition');
                }
                }
                
                if(!validationStatus.equalsIgnoreCase('validated')){
                            ApexPages.Message validateMsg = new ApexPages.Message(ApexPages.Severity.warning, validationStatus);
                            ApexPages.Message showMsg = new ApexPages.Message(ApexPages.Severity.warning, 'Click on Continue to Proceed');
                            ApexPages.addmessage(validateMsg); 
                            ApexPages.addmessage(showMsg); 
                            showButton = true;  
                            return null;
                        }
                else{
                         return save();
                    }                
                }
            else{
                    return save();
                }    
            }catch(Exception e){
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Fatal, 'There has been an error. Please try again or contact your system administrator');
                ApexPages.addmessage(errMsg); 
            return null;
            
        }
    }
    public pageReference save(){
        system.debug('%%%%%%%%in save');
        upsert externalRnD ; 
        if(updateStarCase){
        updateStarCase(externalRnD.id);
        system.debug('$$$$$$$$$$$$call to isx2');
        }
        return  New PageReference('/'+externalRnD.Id);
    }
    @Future(callout=true)
    public static void updateStarCase(ID externalid)
    { 
    try{
        String endpoint= Label.StarUpdateISX2;
        integer min=0;
        External_RnD__c externalRnD = [select Component_ID__c,Component_Release__c,Reference_ID__c,Solution_Type__c from External_RnD__c where id=:externalid];
        Star_Cases__c starcasetemp = new Star_Cases__c(); 
        List<Star_Cases__c> starcases = Star_Cases__c.getall().values();
        min=(integer)starcases[0].count__c;
        for(Star_Cases__c starcase : starcases){
            if(min>=starcase.count__c){
            min=(integer)starcase.count__c;
            starcasetemp=starcase;
            }   
        }
        if(externalRnD.Component_ID__c==NULL)
        externalRnD.Component_ID__c='';
        if(externalRnD.Component_Release__c==NULL)
        externalRnD.Component_Release__c='';
        if(externalRnD.Reference_ID__c==NULL)
        externalRnD.Reference_ID__c='';
        if(externalRnD.Solution_Type__c==NULL)
        externalRnD.Solution_Type__c='';
        System.debug('++++++++case number'+starcasetemp.name+'           count '+starcasetemp.count__c);
        Http h = new Http();        
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint(endpoint);
        req1.setMethod('PUT');
        req1.setHeader('content-type', 'text/xml');
        req1.setHeader('consumerApp', 'CSO');
        req1.setHeader('consumerUsername', 'IntegrationEAICSO');
        req1.setBody('<?xml version="1.0" encoding="utf-8"?><updateCaseRequest><caseNumber>'+starcasetemp.name+'</caseNumber><pmfKey>STAR</pmfKey><relatedSolution><product>'+externalRnD.Component_ID__c+'</product><release>'+externalRnD.Component_Release__c+'</release><number>'+externalRnD.Reference_ID__c+'</number><type>'+externalRnD.Solution_Type__c+'</type></relatedSolution></updateCaseRequest>');
        system.debug('<?xml version="1.0" encoding="utf-8"?><updateCaseRequest><caseNumber>'+starcasetemp.name+'</caseNumber><pmfKey>STAR</pmfKey><relatedSolution><product>'+externalRnD.Component_ID__c+'</product><release>'+externalRnD.Component_Release__c+'</release><number>'+externalRnD.Reference_ID__c+'</number><type>'+externalRnD.Solution_Type__c+'</type></relatedSolution></updateCaseRequest>');
        HTTPResponse res1 = h.send(req1);
        System.debug(' response body'+ res1.getBody()+res1);
        starcasetemp.count__c++;
        update starcasetemp;
        }catch(Exception e){
        system.debug('exception is '+e);
        }
        
    }
    public pageReference redirect(){  
        System.debug('Inside redirect');      
        RecordType [] recordTypeList = [select id from RecordType where name = 'Saas Ops Incident'];        
        String caseName = ApexPages.currentPage().getParameters().get(Label.External_Request_Case_LookupId);  
        system.debug('####externalRnD'+externalRnD.Id);      
        if (recordTypeId == recordTypeList[0].Id){      
            if(externalRnD.Id!=null){       
                return  new PageReference('/'+externalRnD.Id+'/e?nooverride=1');        
            }       
            else{       
                return  new PageReference('/a7g/e?/retURL=%2Fa7g%2Fo&RecordType='+recordTypeId+'&nooverride=1'+'&'+Label.External_Request_Case_LookupId+'='+caseName+'&'+Label.External_Request_Case_LookupId+'_lkid='+externalRnD.case__c);        
            }       
        }       
        else return null;       
    }       
    public pageReference newComment(){      
        return  new PageReference('/apex/ExternalRequestComment?retURL=%2F'+externalRnD.Id+'&sfdc.override=1&CF'+Label.External_Request_Comment_LookUp_Id+'_lkid='+externalRnD.Id+'&CF'+Label.External_Request_Comment_LookUp_Id+'='+name);     
    }
    
    private string buildEndpoint(){
        String endpoint= Label.ValidateExternalRnDQA;
        String referenceId ;
        String componentId ;
        if(ApexPages.currentPage().getHeaders().get('Host').contains('na')){
            endpoint = Label.ValidateExternalRnDProd;
        }
        if(externalRnD.Type__c == 'Problem'){
                endpoint+= 'Problem';
        }
        else{
                endpoint+= 'Solution';
        }   
        referenceId = EncodingUtil.urlEncode(externalRnD.Reference_ID__c,'UTF-8') ;
        componentId = EncodingUtil.urlEncode(externalRnD.Component_ID__c,'UTF-8') ;
        endpoint+='&referenceID='+referenceId+'&componentID='+componentId;      
             if(externalRnD.Component_Release__c!=null && externalRnD.Component_Release__c!=''){
                    endpoint+= '&componentRelease='+externalRnD.Component_Release__c;
             }  
             if(externalRnD.Solution_Type__c!=null && externalRnD.Solution_Type__c!='NULL'  ){
                endpoint+= '&solutionType='+externalRnD.Solution_Type__c;
             }   
        return endpoint;
        
    }
    
}