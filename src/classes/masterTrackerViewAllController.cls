/*
 * Test Class = masterTrackerTestClass
 * Updated by - BAJPI01
 * Coverage = 100%
*/ 
public class masterTrackerViewAllController {

    
    Public List<MasterTracker__c> trackerRecordList;
    
    public masterTrackerViewAllController(){

    }
    
    

    Public List<MasterTracker__c> gettrackerRecordList(){
        List<MasterTracker__c> mtrecordslist= [select Story_Req_SD__c,DevBoxName__c,DateAddedtoTracker__c,InFSB1__c,InFSB2__c,InFSB3__c,InFSB4__c,InFSB5__c,
                             NeworExisting__c,Type__c,ComponentLabelName__c,ComponentAPIName__c,ObjectName__c,BSA__c,Developer__c,
                             ChangeSet_Name__c,ReleaseName__c,Release_Date__c,ChangeSetPopulationDeadline__c,Conflict__c,Type_of_Change__c
                             from MasterTracker__c where Release_Date__c>=:system.today() order by Release_Date__c,BSA__c,Developer__c];
        return mtrecordslist;
    }

}