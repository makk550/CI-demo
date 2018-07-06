@RestResource(urlMapping='/closedCases-for-folderDeletion')
global class ClosedCasesForFolderDeletion {
    
    global class ClosedCasesResponse {
        global String status;
        global List<String> caseFolderPath; 
    }
    
    global class UpdateDeletedFolderRequest {
        global List<String> caseFolderPath;
    }
    
    global class UpdateDeletedFolderResponse {
        global String status;
    }    
    
    @HttpGet
    global static void fetchClosedCases() {
        String jsonResponse = null;
        RestResponse restResponse = RestContext.response;
        restResponse.addHeader('Content-Type', 'application/json');
        ClosedCasesResponse closedCases = new ClosedCasesResponse();
        List<String> siteCasePath = new List<String>();  
        try{            
            DateTime last30Days = System.today().addDays(Integer.valueOf(System.Label.CFTP_30Days)); //(-29); DateTime last30Days = System.today().addDays(Integer.valueOf(System.Label.CFTP_30Days));  
            System.debug('last30Days:'+last30Days);
            DateTime last35Days = System.today().addDays(Integer.valueOf(System.Label.CFTP_35Days)); //-35 
            System.debug('last35Days:'+last35Days);
            List<Case> last30to35DaysClosedCaseList = [select id,Tops_Support_Site_ID__c, caseNumber, Project_Id__c, Case_Type__c from Case 
                                                       where 
                                                       Status = 'Closed' 
                                                       and SFTP_Directory_Deleted__c = false
                                                       and ClosedDate >= :last35Days and ClosedDate <= :last30Days limit 1000                                   
                                                      ];
            
            System.debug('last30to35DaysClosedCaseList.size():'+last30to35DaysClosedCaseList.size());
            if( last30to35DaysClosedCaseList != null && last30to35DaysClosedCaseList.size() > 0 ){
                for(Case c : last30to35DaysClosedCaseList) {
                    if(c.Case_Type__C == 'Project'){
                        siteCasePath.add(CC_Utils.padSiteIdforGS(c.Project_Id__c)+'/'+c.caseNumber);
                    } else {
                        siteCasePath.add(CC_Utils.padSiteIdforGS(c.Tops_Support_Site_ID__c)+'/'+c.caseNumber);
                    }
                }            
            }
            System.debug('siteCasePath:'+siteCasePath); 
            closedCases.status = 'success';       
            closedCases.caseFolderPath = siteCasePath;
            System.debug('closedCases:'+closedCases);
            jsonResponse = JSON.serialize(closedCases);
            System.debug('jsonResponse:'+jsonResponse);           
            restResponse.responseBody = blob.valueOf(jsonResponse);
            return;
        } catch(Exception e){
            System.debug('Exception:'+ e);
            System.debug('Exception Stacktrace:'+ e.getStackTraceString());
            closedCases.status = 'failure';       
            closedCases.caseFolderPath = null ;
            System.debug('closedCases:'+closedCases);
            jsonResponse = JSON.serialize(closedCases);
            restResponse.responseBody = blob.valueOf(jsonResponse);            
            insert prepareErrorLog(e, null, null, 'GET : /closedCases-for-folderDeletion');
            
            return;    
        }
        
    }
    
    public static CrushFTP_SFDC_Logs__c prepareErrorLog(Exception e,String request, String responseBody,String event) {        
        CrushFTP_SFDC_Logs__c obj = new CrushFTP_SFDC_Logs__c();
        obj.Event__c = event;
        obj.Request__c = request;
        obj.Response_Error__c = '';
        if( e != null){
            obj.Response_Error__c = 'Exception Message:' + e.getMessage(); 
        }
        if(responseBody != null){
            obj.Response_Error__c = 'response:' + responseBody ;
        }    
        System.debug('CrushFTP_SFDC_Logs__c record:'+obj);
        return obj;
    }   
    
    
    @HttpPut
    global static void updateIsFolderDeleted(List<String> caseFolderPath){ //UpdateDeletedFolderRequest requestParam
        String jsonResponse = null;
        RestResponse restResponse = RestContext.response;
        restResponse.addHeader('Content-Type', 'application/json');
        try{
            if(caseFolderPath != null){
                Set<String> caseNumbersSet = new Set<String>();
                for(String eachPath : caseFolderPath){
                    if( eachPath != null ){
                        eachPath = eachPath.substringAfter('/') ;
                        caseNumbersSet.add(eachPath);
                    }
                }
                if(caseNumbersSet.size() > 0){                                
                    BatchToUpdateCaseFolderDeletion batchObj = new  BatchToUpdateCaseFolderDeletion(caseNumbersSet);              
                    Database.executebatch(batchObj,Integer.valueOf(System.label.batchSizeToUpdateWhenFolderisDeleted));
                }            
            }
           
            UpdateDeletedFolderResponse response = new UpdateDeletedFolderResponse();
            response.status= 'success';
            jsonResponse = JSON.serialize(response);
            restResponse.responseBody = blob.valueOf(jsonResponse);       
            return;
            
        } catch(Exception e){
            
            System.debug('Exception:'+ e);
            System.debug('Exception Stacktrace:'+ e.getStackTraceString());
            
            UpdateDeletedFolderResponse response = new UpdateDeletedFolderResponse();
            response.status= 'failure';
            jsonResponse = JSON.serialize(response);
            restResponse.responseBody = blob.valueOf(jsonResponse);
            
            insert prepareErrorLog(e, String.join(caseFolderPath, ','), jsonResponse , 'PUT : /closedCases-for-folderDeletion');
            return;
        }
       
        
    }
    
}