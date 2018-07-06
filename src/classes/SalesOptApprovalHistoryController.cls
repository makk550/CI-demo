public class SalesOptApprovalHistoryController{
    public String entityId {get;set;}
    public String entityName {get;set;}
    public String responseText {get;set;}
    
    public String getDetails()
    {
      if (entityId != null && entityName=='ExecProf') {
        Executive_Profile__c profile= [Select Id, Customer__c, Name, (Select TargetObjectId, SystemModstamp, StepStatus, 
            RemindersSent, ProcessInstanceId, OriginalActorId, IsPending, IsDeleted, Id, CreatedDate,
            CreatedById, Comments, ActorId From ProcessSteps order by SystemModstamp desc limit 1) from Executive_Profile__c where Id = :entityId];  
        ProcessInstanceHistory execProfHistory = profile.ProcessSteps;
        String comments = execProfHistory.Comments;      
        if(comments==null)
        {
            comments = '';
        }              
        Contact customer = [SELECT Id, Name, AccountId FROM Contact WHERE Id = :profile.Customer__c][0];
        String returnText = 'Contact Name: ' + customer.Name;
        returnText = returnText + '<br/>';
        returnText = returnText + 'Executive Profile Name: ' + profile.Name + '<br/>';
        returnText = returnText + 'Executive Profile Link: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + profile.Id + '<br/><br/>';
        
        returnText = returnText + responseText + ' Comment : ' + comments;   
        
        return returnText;
      }
      else if(entityId != null && entityName=='AccPlan')
      {
        Account_Plan3__c plan= [Select Id, Name, Account__c, (Select TargetObjectId, SystemModstamp, StepStatus, 
            RemindersSent, ProcessInstanceId, OriginalActorId, IsPending, IsDeleted, Id, CreatedDate,
            CreatedById, Comments, ActorId From ProcessSteps order by SystemModstamp desc limit 1) from Account_Plan3__c where Id = :entityId];  
        ProcessInstanceHistory planHistory= plan.ProcessSteps;
        String comments = planHistory.Comments;     
        if(comments==null)
        {
            comments = '';
        }                
        Account myAccount = [SELECT Id, Name FROM Account WHERE Id = :plan.Account__c][0];        
        String returnText = 'Account Name: ' + myAccount.Name + '<br/>';
        returnText = returnText + 'Account Plan Name: ' + plan.Name + '<br/>';
        returnText = returnText + 'Account Plan Link: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + plan.Id + '<br/><br/>';
        
        returnText = returnText + responseText + ' Comment : ' + comments;   
        
        return returnText;      
      }  
      return '';
    } 

}