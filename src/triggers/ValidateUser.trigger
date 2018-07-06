trigger ValidateUser on Commit_Org_Downtime_Datetime__c (before insert, before update) {

    Boolean authFlag = false;
    Commit_Org_Downtime_Admin__c[] q = [select User__c, Commit_Org_Downtime__r.Id from Commit_Org_Downtime_Admin__c where User__c = :(UserInfo.getUserId())];

    for (Commit_Org_Downtime_Datetime__c t : Trigger.new) {
        authFlag = false;
        for (Commit_Org_Downtime_Admin__c r : q) {
            if (r.Commit_Org_Downtime__c == t.Commit_Org_Downtime__c) {
                authFlag = true;
            }
        }
        if (!authFlag) {
            t.addError('You are not authorized.');
        }
    }

}