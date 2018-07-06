trigger EP_Approval on Executive_Profile__c (before update) 
{
    for(Executive_Profile__c ep : Trigger.new)
        if(Trigger.oldmap.get(ep.Id).Approval_Status__c != 'Pending Approval' && ep.Approval_Status__c == 'Pending Approval')
            ep.Submitted_By__c = UserInfo.getUserId();
            
}