/*
 * Test Class = masterTrackerTestClass
 * Updated by - BAJPI01
 * Coverage = 92%
*/ 
public class masterTrackerSanboxSettingsController {
    
    public Boolean fsb1{get;set;}
    public Boolean fsb2{get;set;}
    public Boolean fsb3{get;set;}
    public Boolean fsb4{get;set;}
    public Boolean fsb5{get;set;}
    public Boolean renderRecord{get;set;}
    Master_Tracker_Custom_Settings__c trackerRecord;
    
    public masterTrackerSanboxSettingsController(){
        trackerRecord = Master_Tracker_Custom_Settings__c.getOrgDefaults();
        if(trackerRecord!=null){
            fsb1 = trackerRecord.FSB1__c;
            fsb2 = trackerRecord.FSB2__c;
            fsb3 = trackerRecord.FSB3__c;
            fsb4 = trackerRecord.FSB4__c;
            fsb5 = trackerRecord.FSB5__c;
            renderRecord = true;
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no instance available for the custom setting.'));
            renderRecord = false;
        }
        
    }
    
    public pagereference onSave(){
        
        trackerRecord.FSB1__c = fsb1;
        trackerRecord.FSB2__c = fsb2;
        trackerRecord.FSB3__c = fsb3;
        trackerRecord.FSB4__c = fsb4;
        trackerRecord.FSB5__c = fsb5;
        update trackerRecord;
        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'The settings have been saved.'));
        return null;
    }

}