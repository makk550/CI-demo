/*
 * Test Class = masterTrackerTestClass
 * Updated by - BAJPI01
 * Coverage = 94%
*/ 
public class masterTrackerViewEditController {
    
    private Master_Tracker_Custom_Settings__c trackerRecordsettings;
    private List<MasterTracker__c> mtRecordstoUpdate;
    
    private List<MasterTracker__c> trackerRecords;
    public Boolean fsb1{get;set;}
    public Boolean fsb2{get;set;}
    public Boolean fsb3{get;set;}
    public Boolean fsb4{get;set;}
    public Boolean fsb5{get;set;}
    public boolean allchecked{get;set;}
	public List<trackerwrapper> trackerRecordList{get;set;}
    public Boolean renderTypeSelection {get;set;}
    public Boolean renderComponentSection {get;set;}
    public Boolean renderCodeConfigSection {get;set;}
    public Boolean renderDataLoadSection {get;set;}
    public List<SelectOption> typeList {get;set;}
    public string RcdTy {get;set;} 
    
    public Boolean RT_CodeConfig=false;
    public Boolean RT_DataLoad=false;
    
    
    public masterTrackerViewEditController(){
        
        renderTypeSelection = true;
        renderComponentSection = false;
        renderCodeConfigSection = false;
        renderDataLoadSection = false;
        
        typeList = new List<SelectOption>();
        typeList.add(new SelectOption('Code/Config','Code/Config'));
        typeList.add(new SelectOption('Data Load','Data Load'));
        
        
        
    }

    public void init(){
        allchecked = false;
        trackerRecordList = new List<trackerwrapper>();
        trackerRecords = new List<MasterTracker__c>();
        mtRecordstoUpdate = new List<MasterTracker__c>();
        
        trackerRecords = [select Story_Req_SD__c,DevBoxName__c,DateAddedtoTracker__c,
                          InFSB1__c,InFSB2__c,InFSB3__c,InFSB4__c,InFSB5__c,NeworExisting__c,Type__c,ComponentLabelName__c,
                          ComponentAPIName__c,ObjectName__c,BSA__c,Developer__c,ChangeSet_Name__c,Release_Date__c,
                          ChangeSetPopulationDeadline__c,Conflict__c,ReleaseName__c,Type_of_Change__c
                          from MasterTracker__c where Release_Date__c>=:system.today() and (BSA__c=:Userinfo.getuserId() OR 
                          Developer__c=:Userinfo.getuserId()) AND Type_of_Change__c=:RcdTy order by Release_Date__c,BSA__c,Developer__c];
        
        trackerRecordsettings = Master_Tracker_Custom_Settings__c.getOrgDefaults();
        if(trackerRecordsettings!=null){
            fsb1 = trackerRecordsettings.FSB1__c;
            fsb2 = trackerRecordsettings.FSB2__c;
            fsb3 = trackerRecordsettings.FSB3__c;
            fsb4 = trackerRecordsettings.FSB4__c;
            fsb5 = trackerRecordsettings.FSB5__c;
        }
        if(trackerRecords!=null && trackerRecords.size()>0){
            for(MasterTracker__c records:trackerRecords){
                trackerRecordList.add(new trackerwrapper(records));
            }
        }
    }

    
    //this method checks all the line items.
    public void checkalllineitems(){
        if(allchecked==true){
            for(trackerwrapper wraprecords:trackerRecordList){
                wraprecords.checkedornot = true;
            }
        }
        else if(allchecked==false){
            for(trackerwrapper wraprecords:trackerRecordList){
                wraprecords.checkedornot = false;
            }
        }
    }
    
    public void onSave(){
        
        Database.SaveResult[] saveList;
        ApexPages.getMessages().clear();
        Boolean errorExists = false;
        
        mtRecordstoUpdate.clear();        
        
        for(trackerwrapper wraprecords:trackerRecordList){
            if(wraprecords.checkedornot==true)
                mtRecordstoUpdate.add(wraprecords.mt);
        }
        
        if(mtRecordstoUpdate!=null && mtRecordstoUpdate.size()>0){
            //missing fields are captured in the trigger, please do not remove try catch
            try{
                saveList = Database.update(mtRecordstoUpdate,true);
                for(Database.SaveResult sr:saveList){
                    if(!sr.isSuccess()){
                        errorExists = true;
                    }
                }
                if(errorExists==false){
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Components were updated.'));
                    init();
                }
            }
            catch(Exception e){
                system.debug(e.getTypeName());
                system.debug('----e-----'+e);
                
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a component to update.'));
        }
    }
    
   
    public void onDelete(){
        mtRecordstoUpdate.clear();        
        
        for(trackerwrapper wraprecords:trackerRecordList){
            if(wraprecords.checkedornot==true)
                mtRecordstoUpdate.add(wraprecords.mt);
        }
        if(mtRecordstoUpdate!=null && mtRecordstoUpdate.size()>0){
            delete mtRecordstoUpdate;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Components were deleted.'));
            init();
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a component to delete.'));
        }
    }
    
    	public class trackerwrapper{
		Public MasterTracker__c mt{get;set;}
		Public Boolean checkedornot{get;set;}
		public trackerwrapper(MasterTracker__c mt){            
            this.mt=mt;
        } 
	}
    
    public void continueType(){
        
        renderTypeSelection = false;
        
        renderComponentSection = true;
        
        if(RcdTy == 'Code/Config'){
            RT_CodeConfig=true;
            renderCodeConfigSection = true;
        }
        else if(RcdTy == 'Data Load'){
            RT_DataLoad=true;
            renderDataLoadSection = true;
            renderCodeConfigSection = false;
        }
        
        init();
    }
	
}