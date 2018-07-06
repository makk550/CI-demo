@isTest
public class testMethods_TrialRequest
{
  public static testmethod void testTrialRequest()
  {
     testOpportunityTriggersClass.createNewOpportunity();
      
      
      
        Opportunity opp = [select id,RecordType.Name,AccountId from Opportunity limit 1];
     if(opp != null)
     {
          
         Trial_Request__c trialRequest = new Trial_Request__c();
         trialRequest.Account_Name__c = opp.AccountId;
         trialRequest.Opp_Name__c = opp.Id;
         trialRequest.Request_Type__c = 'Trial Request';
         trialRequest.Request_Status__c = 'New';
         trialRequest.Record_Type__c = opp.RecordType.Name;
         insert  trialRequest;
         
         //trialRequest.Request_Status__c = 'Accepted'; 
         trialRequest.OwnerId = UserInfo.getUserId() ;
         update trialRequest;
         
         
        
         
         
     }   
        
   }
}