/**
Description: Avoid duplicates based on PMFKey and GEO.
Created By:Yedra01
**/
trigger noDuplicatePMFKey on TAQ_Organization__c(before insert, before update) {
    Map < String, TAQ_Organization__c > PMFKeyMap = new Map < String, TAQ_Organization__c > ();
    Set < string > PMFKeySet = new Set < string > ();
    set < id > Taqids = new set < id > ();
    for (TAQ_Organization__c TAQ: trigger.new) {
        if (trigger.isinsert || (trigger.isupdate&&(TAQ.PMFKey__c!=Trigger.oldmap.get(TAQ.id).PMFKey__c||TAQ.Employee_Status__c!=Trigger.oldmap.get(TAQ.id).Employee_Status__c)))
            if (TAQ.PMFKey__c != null && TAQ.Employee_Status__c=='Active')
                PMFKeySet.add(TAQ.PMFKey__c);

    }

    //Soql Query for extracting PMFKeys only status is "Active" 
    for (TAQ_Organization__c taqo: [select id, PMFKey__c, Region__c from TAQ_Organization__c where PMFKey__c in : PMFKeySet and Employee_Status__c = : 'Active'
            limit 50000
        ])
        PMFKeyMap.put(taqo.PMFKey__c, taqo);

    //throwing error if pmfkey existing in with same GEO
    for (TAQ_Organization__c TAQ: trigger.new)
        if (trigger.isinsert || (trigger.isupdate&&(TAQ.PMFKey__c!=Trigger.oldmap.get(TAQ.id).PMFKey__c||TAQ.Employee_Status__c!=Trigger.oldmap.get(TAQ.id).Employee_Status__c)))
            if (TAQ.PMFKey__c != null && PMFKeyMap.get(TAQ.PMFKey__c) != null)
                if (trigger.isinsert || (trigger.isupdate && PMFKeyMap.get(TAQ.PMFKey__c).id != TAQ.id))
                    TAQ.adderror('PMFKey already has active record.');



}