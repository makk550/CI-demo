@RestResource(urlMapping='/projectSiteAssociationService/*')
global class projectSiteAssociationService{
    
    public static responsePayload responsePayloadObj;
    public static projectSiteResponsePayload projectSiteResponsePayloadObj;
    
    global class requestPayload{
        global String title;
        global String description;
        global String siteId;
        global String connectId;
        global String projectId;
    }

    global class responsePayload{
        global projectSiteResponsePayload projectSiteResponsePayload;
    }
    global class projectSiteResponsePayload{
        global String acknowledgement;
        global String projectId;
    }
    
    @HttpPost
    global static void insertAndUpdateProjectSiteAssocationRecord(requestPayload projectSiteRequestPayload){
        String jsonRequest = JSON.serialize(projectSiteRequestPayload);
        RestResponse restResponse = RestContext.response;
        responsePayloadObj = new responsePayload();
        String jsonResponse = null;
        projectSiteResponsePayloadObj = new projectSiteResponsePayload();
        if(projectSiteRequestPayload<>null){
            if(String.isBlank(projectSiteRequestPayload.projectId))
            {
                
                if(String.isBlank(projectSiteRequestPayload.title)){
                    projectSiteResponsePayloadObj.acknowledgement = 'Please enter the valid title';
                    responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;    
                }
                
                if(String.isBlank(projectSiteRequestPayload.description)){
                    projectSiteResponsePayloadObj.acknowledgement = 'Please enter the valid description';
                    responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;
                }
                
                
                if(String.isBlank(projectSiteRequestPayload.connectId)){
                    projectSiteResponsePayloadObj.acknowledgement = 'Please enter the valid connect ID';
                    responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;    
                }
                
                if(String.isBlank(projectSiteRequestPayload.siteId)){
                    projectSiteResponsePayloadObj.acknowledgement = 'Please enter the valid Site Id';
                    responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return;    
                }else{
                    List<Site_Association__c> listOfSiteAssociation = [Select id, SC_TOPS_ID__c from Site_Association__c where SC_TOPS_ID__c=:projectSiteRequestPayload.siteId limit 1];
                    
                    if(listOfSiteAssociation<>null && listOfSiteAssociation.size()>0){
                        Project_Site_Association__c projectSiteObj = new Project_Site_Association__c();
                        projectSiteObj.Name = projectSiteRequestPayload.title;
                        projectSiteObj.Description__c = projectSiteRequestPayload.description;
                        projectSiteObj.Site_Association__c = listOfSiteAssociation[0].Id;
                        projectSiteObj.Connect_ID__c = projectSiteRequestPayload.connectId;
                        projectSiteObj.Project_ID__c = '0';
                        
                        try{
                           Database.Insert(projectSiteObj); 
                        }Catch(DMLException e){system.debug('INSERTION ERROR');projectSiteResponsePayloadObj.acknowledgement = 'DML operation failed';responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;jsonResponse = JSON.serialize(responsePayloadObj);restResponse.responseBody = blob.valueOf(jsonResponse);return;}
                        
                        if(String.isNotBlank(projectSiteObj.Id)){
                            List<Project_Site_Association__c> listOfProjectSite = [Select Id, Project_ID__c from Project_Site_Association__c where id=:projectSiteObj.Id limit 1];
                            
                            if(listOfProjectSite<>null && listOfProjectSite.size()>0){
                                projectSiteResponsePayloadObj.acknowledgement = 'Success';
                                projectSiteResponsePayloadObj.projectId = listOfProjectSite[0].Project_ID__c;
                                responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                                jsonResponse = JSON.serialize(responsePayloadObj);
                                restResponse.responseBody = blob.valueOf(jsonResponse);
                                return; 
                            }
                        }
                    }else{
                        projectSiteResponsePayloadObj.acknowledgement = 'Site Id doesn\'t exist';
                        responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                        jsonResponse = JSON.serialize(responsePayloadObj);
                        restResponse.responseBody = blob.valueOf(jsonResponse);
                        return;
                    }
                }
            }
            else
            {
                projectSiteResponsePayloadObj.projectId = projectSiteRequestPayload.projectId;
                if(String.isBlank(projectSiteRequestPayload.title) && String.isBlank(projectSiteRequestPayload.description))
                {
                    projectSiteResponsePayloadObj.acknowledgement = 'Please enter title or description';
                    responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                    return; 
                }          
                try{                   
                Project_Site_Association__c projectSiteObj = [Select id,Name,Description__c,Project_ID__c from Project_Site_Association__c where Project_ID__c=:projectSiteRequestPayload.projectId limit 1];
                if(projectSiteObj<>null)
                {
                    if(String.isNotBlank(projectSiteRequestPayload.title))
                    {
                       projectSiteObj.Name = projectSiteRequestPayload.Title;
                    }
                
                    if(String.isNotBlank(projectSiteRequestPayload.description))
                    {
                    
                        projectSiteObj.Description__c = projectSiteRequestPayload.Description;
                    }
                    Database.Update(projectSiteObj); 
                    projectSiteResponsePayloadObj.acknowledgement = 'Project details updated successfully ';
                    responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
                    jsonResponse = JSON.serialize(responsePayloadObj);
                    restResponse.responseBody = blob.valueOf(jsonResponse);
                }
            }
            Catch(Exception e){system.debug('No Project found or UPDATE ERROR');projectSiteResponsePayloadObj.acknowledgement = 'No project found or DML update operation failed';responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;jsonResponse = JSON.serialize(responsePayloadObj);restResponse.responseBody = blob.valueOf(jsonResponse);return;}
          }

        }
        else{
            projectSiteResponsePayloadObj.acknowledgement = 'Please enter the valid request payload';
            responsePayloadObj.projectSiteResponsePayload = projectSiteResponsePayloadObj;
            jsonResponse = JSON.serialize(responsePayloadObj);
            restResponse.responseBody = blob.valueOf(jsonResponse);
            return;
        }
    }
}