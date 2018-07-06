public class JiraProjectKeysScheduler {

    public void execute(){
		JIRA_Configuration__c jiraConfiguration;
        HttpRequest request = new HttpRequest();
        if(JIRA_Configuration__c.getAll().get('Default') != null){
        	jiraConfiguration = JIRA_Configuration__c.getAll().get('Default');
            request.setMethod('GET'); 
        	request.setEndpoint(jiraConfiguration.JIRA_Keys_Endpoint__c); 
       		Http http = new Http();
       		HTTPResponse response;
            
            if (Test.isRunningTest()){
                JiraCalloutMock mock = new JiraCalloutMock();
                response =  mock.getResponse(request);
            }else{
                response = http.send(request);
            }
            
        	insertJiraProjectKeys(response.getBody());
    	}
    }

    private void insertJiraProjectKeys(string jsonStr){
        Boolean flag;
        List<String> stringList = new List<String>();
        List<Object> jsonMapList = (List<Object>)Json.deserializeUntyped(jsonStr);
        List<JIRA_Project_Key__c> jiraProjctKeyList = new List<JIRA_Project_Key__c>();
        List<JIRA_Project_Key__c> jiraProjctKeyListFromSF = [select JIRA_Project_Key__c from JIRA_Project_Key__c];
        for(Object jsonMapObject : jsonMapList){
            flag = true;
     		Map<String,Object> mapObject = (Map<string,Object>)jsonMapObject;
            for(JIRA_Project_Key__c jiraProjectKey : jiraProjctKeyListFromSF){
                if(jiraProjectKey.JIRA_Project_Key__c == (String)mapObject.get('jira_key')){
                    flag = false;
                } 
            }
            if(flag){
               jiraProjctKeyList.add(new JIRA_Project_Key__c(JIRA_Project_ID__c = (String)mapObject.get('jira_id'), JIRA_Project_Key__c = (String)mapObject.get('jira_key'), Name = (String)mapObject.get('name'))); 
            }
		}
        insert jiraProjctKeyList;
     }
}