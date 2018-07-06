@RestResource(urlMapping='/updateDiagnosticFileStatus/*')
global class updateCADiagnosticFileStatus {
    public static responsePayload responsePayloadObj;
    
    global class requestPayload{
        global List<diagnosticFiles> diagnosticFiles;
    }
    
    global class diagnosticFiles{
        global String Id;
    }
    
    global class responsePayload{
        global String message;
    }
    
    @HttpPut
    global static void updateFileStatus(requestPayload diagnosticFileRequestPayload){
        String jsonRequest = JSON.serialize(diagnosticFileRequestPayload);
        RestResponse restResponse = RestContext.response;
        responsePayloadObj = new responsePayload();
        String jsonResponse = null;
        if(diagnosticFileRequestPayload<>null){
            if(diagnosticFileRequestPayload.diagnosticFiles<>null && diagnosticFileRequestPayload.diagnosticFiles.size()>0){
                Set<String> diagnosticRecordId = new Set<String>();
                for(Integer i=0;i<diagnosticFileRequestPayload.diagnosticFiles.size();i++){
                    if(String.isNotBlank(diagnosticFileRequestPayload.diagnosticFiles[i].Id)){
                        diagnosticRecordId.add(diagnosticFileRequestPayload.diagnosticFiles[i].Id);
                    }
                }
                
                List<CA_Diagnostics__c> listOfCADiagnostic = [Select id, Status__c from CA_Diagnostics__c where Id IN:diagnosticRecordId AND Status__c!= 'Unavailable'];
                
                if(listOfCADiagnostic<>null && listOfCADiagnostic.size()>0){
                    List<CA_Diagnostics__c> updateCADiagnosticList = new List<CA_Diagnostics__c>();
                    for(CA_Diagnostics__c diagnosticObj:listOfCADiagnostic){
                        diagnosticObj.Status__c = 'Unavailable';
                        updateCADiagnosticList.add(diagnosticObj);
                    }
                    
                    if(updateCADiagnosticList<>null && updateCADiagnosticList.size()>0){
                        try{
                            Database.update(updateCADiagnosticList);
                            responsePayloadObj.message = 'Successfully updated';
                            jsonResponse = JSON.serialize(responsePayloadObj);
                            restResponse.responseBody = blob.valueOf(jsonResponse);
                            return;
                        }Catch(DMLException e){
                            system.debug('DML Exception: '+e.getMessage());
                            responsePayloadObj.message = 'DML Exception: '+e.getMessage();
                            jsonResponse = JSON.serialize(responsePayloadObj);
                            restResponse.responseBody = blob.valueOf(jsonResponse);
                            return;
                        }
                        
                    }
                }else{
                    responsePayloadObj.message = 'No records found!!';
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }
            }else{
                responsePayloadObj.message = 'List has no records. Please pass the records';
                jsonResponse = JSON.serialize(responsePayloadObj);
                restResponse.responseBody = blob.valueOf(jsonResponse);
                return;
            }
        }else{
            responsePayloadObj.message = 'Please send the valida request';
            jsonResponse = JSON.serialize(responsePayloadObj);
            restResponse.responseBody = blob.valueOf(jsonResponse);
            return;
        }
    }
}