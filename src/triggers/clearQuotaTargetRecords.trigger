trigger clearQuotaTargetRecords on Quota_Target__c (after update){
set<Id> quotaTargetIds=new set<Id>();
set<Id> quotatargetTaqOrgIds=new set<Id>();
set<Id> quotaTargetTaqAccIds=new set<Id>();
List<Quota_Target__c> quotaTargetRec=new List<Quota_Target__c>();
for(integer i=0;i<Trigger.new.size();i++){
    if(Trigger.new[i].Area__c!=Trigger.old[i].Area__c || Trigger.new[i].Business_Unit__c!=Trigger.old[i].Business_Unit__c ||Trigger.new[i].Country__c!=Trigger.old[i].Country__c || Trigger.new[i].Definition__c!=Trigger.old[i].Definition__c || Trigger.new[i].Market__c!=Trigger.old[i].Market__c || Trigger.new[i].Region__c!=Trigger.old[i].Region__c || Trigger.new[i].Target_Type__c!=Trigger.old[i].Target_Type__c || Trigger.new[i].Territory__c!=Trigger.old[i].Territory__c)
        quotaTargetIds.add(Trigger.new[i].Id);
}

quotaTargetRec=[select id from Quota_Target__c where Id in :quotaTargetIds];
for(Quota_Target__c qTarget:quotaTargetRec){
    qTarget.Actual_Account_Calc__c=null;
    qTarget.AD_AM_AAM_Quota_Calc_Active__c=null;
    qTarget.AD_AM_AAM_Quota_Calc_Open__c=null;
    qTarget.AD_AM_AAM_Quota_Calc_Total__c=null;
    qTarget.SD_Quota_Calc__c=null;
    qTarget.SSS_SS_SSA_Quota_Calc_Active__c=null;
    qTarget.SSS_SS_SSA_Quota_Calc_Open__c=null;
    qTarget.SSS_SS_SSA_Quota_Calc_Total__c=null;
    qTarget.SVP_Quota_Calc__c=null;
    qTarget.VP_Quota_Calc__c=null;
}
update quotaTargetRec;
}