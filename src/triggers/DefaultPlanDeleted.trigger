trigger DefaultPlanDeleted on Account_Plan__c (before delete) {
    for(Account_Plan__c ap:Trigger.Old)
    {
        if(ap.Default_Plan__c)
        {
            ap.addError('Default Account Plan can not be deleted!');
        } 
    }
}