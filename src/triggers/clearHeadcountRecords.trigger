trigger clearHeadcountRecords on HeadCount_Target__c (after update){
set<Id> headCountIds=new set<Id>();
List<HeadCount_Target__c> headCountRec=new List<HeadCount_Target__c>();
for(integer i=0;i<Trigger.new.size();i++){
    if(Trigger.new[i].Market__c!=Trigger.old[i].Market__c || Trigger.new[i].Region__c!=Trigger.old[i].Region__c ||Trigger.new[i].Org_Type__c!=Trigger.old[i].Org_Type__c || Trigger.new[i].Budget_Area__c!=Trigger.old[i].Budget_Area__c)
        headCountIds.add(Trigger.new[i].Id);
}
headCountRec=[select id from HeadCount_Target__c where Id in :headCountIds];
for(HeadCount_Target__c hTarget:headCountRec){
    hTarget.Head_Count_Active__c=null;
    hTarget.Head_Count_Open__c=null;
    hTarget.Head_Count_Total_Active_Open__c=null;
}
update headCountRec;
}