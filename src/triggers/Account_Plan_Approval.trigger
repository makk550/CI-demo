trigger Account_Plan_Approval on Account_Plan3__c (before update) 
{
    List<Account> accountsToUpdate = new List<Account>();
    for(Account_Plan3__c ap : Trigger.new)
    {
        if(Trigger.oldmap.get(ap.Id).Account_Plan_Status__c != 'Approved' && ap.Account_Plan_Status__c == 'Approved')
            ap.Approved_By__c = UserInfo.getUserId();
            
        if(Trigger.oldmap.get(ap.Id).Account_Plan_Status__c != 'Pending Approval' && ap.Account_Plan_Status__c == 'Pending Approval')
            ap.Submitted_By__c = UserInfo.getUserId();
            
        if(Trigger.oldmap.get(ap.Id).Internal_Account_Plan_Status__c != ap.Internal_Account_Plan_Status__c)
            accountsToUpdate.add(new Account(Id=ap.Account__c, Account_Plan_Status__c = ap.Internal_Account_Plan_Status__c));
    }
    
    update accountsToUpdate;       
}