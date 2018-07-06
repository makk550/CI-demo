trigger Account_Plan_Update_Acc on Account_Plan3__c (after insert)
{
    List<Account> accs = new List<Account>();
    for(Account_Plan3__c ap : Trigger.new)
        accs.add(new Account(Id=ap.Account__c, Account_Plan__c = ap.Id));
        
    update accs;
}