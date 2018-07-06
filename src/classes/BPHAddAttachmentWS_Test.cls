@isTest(SeeAllData=true)
public with sharing class BPHAddAttachmentWS_Test {

	static testMethod void BPHAddAttachmentWS_testMethod(){
		
		Business_Plan_New__c bp = BusinessPlanNewTest.populateTestData();		
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/services/apexrest/addBPVersion/';
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('bpId', bp.Id); 
        gen.writeEndObject();
        gen.writeEndArray(); 
        String jsonstring = gen.getAsString();
        req.httpMethod = 'POST';
  		req.requestBody = Blob.valueof(jsonstring);
    	RestContext.request = req;
   		RestContext.response= res;  
		BPHAddAttachmentWS.doPost(String.valueOf(bp.Id));				
	}	

}