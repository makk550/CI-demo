/*
 * Test Class = masterTrackerTestClass
 * Updated by - BAJPI01
 * Coverage = 98%
*/ 
public class masterTrackerAddComponentsController{
    
    
    private Master_Tracker_Custom_Settings__c trackerRecord;
    private Integer defaultSize = 1;
    private String rectypeid;
    
    public List<MasterTracker__c> trackerRecordList{get;set;}
    public Boolean fsb1{get;set;}
    public Boolean fsb2{get;set;}
    public Boolean fsb3{get;set;}
    public Boolean fsb4{get;set;}
    public Boolean fsb5{get;set;}
    public Boolean renderTypeSelection {get;set;}
    public Boolean renderComponentSection {get;set;}
    public Boolean renderCodeConfigSection {get;set;}
    public Boolean renderDataLoadSection {get;set;}
    public List<SelectOption> typeList {get;set;}
    public string RcdTy {get;set;} 
    
    public Boolean RT_CodeConfig=false;
    public Boolean RT_DataLoad=false;
   
   
    public masterTrackerAddComponentsController(){       
        
        renderTypeSelection = true;
        renderComponentSection = false;
        renderCodeConfigSection = false;
        renderDataLoadSection = false;
        
        typeList = new List<SelectOption>();
        typeList.add(new SelectOption('Code/Config','Code/Config'));
        typeList.add(new SelectOption('Data Load','Data Load'));
        
            
        
        
        trackerRecord = Master_Tracker_Custom_Settings__c.getOrgDefaults();
        if(trackerRecord!=null){
            fsb1 = trackerRecord.FSB1__c;
            fsb2 = trackerRecord.FSB2__c;
            fsb3 = trackerRecord.FSB3__c;
            fsb4 = trackerRecord.FSB4__c;
            fsb5 = trackerRecord.FSB5__c;
        }
    }
    
    public void initialize(){
        trackerRecordList = new List<MasterTracker__c>();
        
        For(Integer i=0;i<defaultSize;i++){
            MasterTracker__c temp = new MasterTracker__c();
            temp.Type_of_Change__c = RcdTy;
            temp.RecordTypeId = rectypeid;
            if(RcdTy == 'Data Load'){
                temp.Type__c = 'Custom Object';
            }
            
            trackerRecordList.add(temp);             
        }
    }
    
     public void addmore_rows(){
        MasterTracker__c temp = new MasterTracker__c();      
        temp  = trackerRecordList.get(trackerRecordList.size() - 1).clone(false,true,false,false);        
        trackerRecordList.add(temp);
    }
    
    public pageReference remove_rows(){
        Integer size = trackerRecordList.size();
        if(size==1)
            return null;
        else{
            trackerRecordList.remove(size-1);
            return null;
        }
    }
    
    public void onSave(){
        
        updateTracker();
    }
        
    public void updateTracker(){
        Database.SaveResult[] saveList;
        ApexPages.getMessages().clear();
        Boolean errorExists = false;
        //missing fields are captured in the trigger, please do not remove try catch
        try{
            saveList = Database.insert(trackerRecordList,true);
            for(Database.SaveResult sr:saveList){
                if(!sr.isSuccess()){
                    errorExists = true;
                }
            }
            if(errorExists==false){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Components were added to the tracker.'));
                initialize();
            }
        }
        catch(Exception e){
            system.debug(e.getTypeName());
            system.debug('----e-----'+e);
            
	        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
        }
        
        
    }
    
    public void continueType(){
        
        renderTypeSelection = false;
        
        renderComponentSection = true;
        
        if(RcdTy == 'Code/Config'){
            RT_CodeConfig=true;
            renderCodeConfigSection = true;
            renderDataLoadSection = false;
            rectypeid = Schema.SObjectType.MasterTracker__c.getRecordTypeInfosByName().get('Code/Config').getRecordTypeId();
        }
        else if(RcdTy == 'Data Load'){
            RT_DataLoad=true;
            renderDataLoadSection = true;
            renderCodeConfigSection = false;
            //system.debug('----test----'+Schema.SObjectType.MasterTracker__c.getRecordTypeInfosByName().get('Date Load').getRecordTypeId());
            rectypeid = Schema.SObjectType.MasterTracker__c.getRecordTypeInfosByName().get('Date Load').getRecordTypeId();
        }
        
        initialize();
    }
   
}