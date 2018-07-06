trigger CA_ApprovalRequestHistoryTrigger on Apttus_Approval__Approval_Request_History__c (before insert) {
    
    Set<Id> agrIds = new Set<Id>();
    String sLabel = '';
    String assId = '';
    system.debug('Trigger.New Values::::'+Trigger.New);
    for(Apttus_Approval__Approval_Request_History__c aprh : Trigger.New) {
        agrIds.add(aprh.Apttus_Approval__Related_Agreement__c);
    }
    
    for(Apttus_Approval__Approval_Request__c appReq : [Select Id, Apttus_Approval__StepLabel__c, Apttus_Approval__Assigned_To_Id__c, CA_Approver_Specific_Comments__c from Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Agreement__c =: agrIds]){
        for(Apttus_Approval__Approval_Request_History__c aprh : Trigger.New) {
            if(aprh.Apttus_Approval__StepLabel__c == appReq.Apttus_Approval__StepLabel__c && aprh.Apttus_Approval__Assigned_To_Id__c == appReq.Apttus_Approval__Assigned_To_Id__c)
                aprh.CA_Approver_Specific_Comments__c = appReq.CA_Approver_Specific_Comments__c;
        }
    }
    
    system.debug('After Approval Cooments Update::::'+Trigger.New);
}