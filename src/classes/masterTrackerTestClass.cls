/*
 * Test class for mastertracker classes (6 classes).
 * masterTrackerAddComponentsController,masterTrackerEmailClass,
 * masterTrackerReleaseDetailScheduler,masterTrackerSanboxSettingsController,
 * masterTrackerViewAllController,masterTrackerViewEditController,
 * MasterTrackerTrigger and MastertrackerTriggerHandler
 * Updated by - BAJPI01
*/ 

@isTest
public class masterTrackerTestClass {
    
    public static void createTestUsers(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        system.assertNotEquals(null, p, 'Profile should not be null');
        
        List<User> userlist = new List<User>();
        
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardtrackerDevuser@gmail.com');
        userlist.add(u);

        
        User u1 = new User(Alias = 'standt', Email='standarduser@gmail.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardtrackerBSAuser@gmail.com');
        userlist.add(u1);
        
        insert userlist;		//creating users.
        
        system.assertNotEquals(null, userlist[0].id, 'User should be inserted.');
        system.assertNotEquals(null, userlist[1].id, 'User should be inserted.');
        
        //inserting master tracker custom settings record.
        Master_Tracker_Custom_Settings__c mt = Master_Tracker_Custom_Settings__c.getOrgDefaults();
        mt.FSB1__c=true;
        mt.FSB2__c=true;
        mt.FSB3__c=false;
        mt.FSB4__c=false;
        mt.FSB5__c=false;
        
        insert mt;
        
        //inserting Master_Tracker_Email_Alert_Settings__c records.
        List<Master_Tracker_Email_Alert_Settings__c> mtemailList = new List<Master_Tracker_Email_Alert_Settings__c>();
        Master_Tracker_Email_Alert_Settings__c mtemail = new Master_Tracker_Email_Alert_Settings__c();
        mtemail.Name = '1';
        mtemail.Object_Name__c = 'Product2';
        mtemail.Type__c = 'Apex Trigger';
        mtemailList.add(mtEmail);

        
        Master_Tracker_Email_Alert_Settings__c mtemail2 = new Master_Tracker_Email_Alert_Settings__c();
        mtemail2.Name = '2';
        mtemail2.Object_Name__c = 'Product2';
        mtemail2.Type__c = 'Custom Field';
        mtemail2.Custom_Field_API__c = 'testField__c';
        mtemailList.add(mtEmail2);
        
        Master_Tracker_Email_Alert_Settings__c mtemail3 = new Master_Tracker_Email_Alert_Settings__c();
        mtemail3.Name = '3';
        mtemail3.Object_Name__c = 'Opportunity';
        mtemail3.Type__c = 'Custom Field';
        mtemail3.Custom_Field_API__c = 'All';
        mtemailList.add(mtEmail3);
        
        insert mtemailList;
		
        //inserting Master_Tracker_Data_Load_Email_Alert__c settings record
		Master_Tracker_Data_Load_Email_Alert__c mtDataEmail = new Master_Tracker_Data_Load_Email_Alert__c();
		mtDataEmail.Name = 'product2';
		insert mtDataEmail;        
        
        //creating release detail record
        ReleaseDetails__c releasedetail = new ReleaseDetails__c();
        releasedetail.CO_Number__c='200-001234';
        releasedetail.IsActive__c=true;
        releasedetail.Name='Future Release 1';
        releasedetail.ReleaseDate__c=system.today()+5;
        releasedetail.ChangeSet_Name__c='Future Release Changeset V1';
        insert releasedetail;
        system.assertNotEquals(null, releasedetail.id, 'Release Detail should be inserted.');
        
    }
    
    //test class to test the MasterTrackerSandboxSettings controller
    @isTest
    static void masterTrackerSandboxSettingTestMethod(){
        
        createTestUsers();
        
        PageReference pageRef = Page.MasterTrackerSandboxSettings;
        Test.setCurrentPage(pageRef);
        masterTrackerSanboxSettingsController contrl = new masterTrackerSanboxSettingsController();
        contrl.fsb1=true;
        contrl.onSave();
        
    }
    
    
    //test class to test the masterTrackeraddComponents controller
     @isTest
    static void masterTrackeraddComponentsTestMethod(){
        
        createTestUsers();
        
        
        ReleaseDetails__c releasedetail = [select id from ReleaseDetails__c where IsActive__c=true limit 1];
        system.assertNotEquals(null, releasedetail, 'Release Detail should not be null.');
        
        User u = [select id from user limit 1];
        system.assertNotEquals(null, u, 'User should not be null.');
        
        MasterTracker__c masterTrackerRecord = new MasterTracker__c();
		masterTrackerRecord.Type_of_Change__c='Code/Config';
        try{
            insert masterTrackerRecord;		//inserting without any data, to get errors, put it in try catch to catch exceptions.
        }
        catch(exception e){
            system.debug('expected exception---- '+e);
        }
        masterTrackerRecord.ReleaseName__c=releasedetail.id;
        masterTrackerRecord.Story_Req_SD__c='US100000';
        masterTrackerRecord.DevBoxName__c='devbox';
        masterTrackerRecord.NeworExisting__c='Existing';
        masterTrackerRecord.Type__c='Page Layout';
        masterTrackerRecord.ComponentLabelName__c='masterTrackerLayout';
        masterTrackerRecord.ComponentAPIName__c='masterTrackerLayout';
        masterTrackerRecord.ObjectName__c='product';
        masterTrackerRecord.BSA__c=u.id;
        masterTrackerRecord.Developer__c=u.id;
		try{
            insert masterTrackerRecord;		//will get an exception again as Object name should be API Name
        }
        catch(exception e){
            system.debug('expected exception---- '+e);
        }
		masterTrackerRecord.ObjectName__c='product2';
        insert masterTrackerRecord;			//will insert now.
        system.assertNotEquals(null, masterTrackerRecord.id, 'Master Tracker Record should be inserted.');
        
        PageReference pageRef = Page.masterTrackerAddComponents;
        Test.setCurrentPage(pageRef);
        masterTrackerAddComponentsController contrl = new masterTrackerAddComponentsController();
        contrl.RcdTy = 'Code/Config';
        contrl.continueType();		//to initiate the page, with type selected
        contrl.remove_rows();		//testing remove rows
        contrl.addmore_rows();		//testing add rows
        contrl.remove_rows();		//testing remove rows
        contrl.onSave();			//save will give errors as details are not populated
        contrl.trackerRecordList[0].Type_of_Change__c='Code/Config';
        contrl.trackerRecordList[0].ReleaseName__c=releasedetail.id;
        contrl.trackerRecordList[0].Story_Req_SD__c='US123456';
        contrl.trackerRecordList[0].DevBoxName__c='devbox';
        contrl.trackerRecordList[0].NeworExisting__c='New';
        contrl.trackerRecordList[0].Type__c='Apex Class';
        contrl.trackerRecordList[0].ComponentLabelName__c='masterTrackerTestClass';
        contrl.trackerRecordList[0].ComponentAPIName__c='masterTrackerTestClass';
        contrl.trackerRecordList[0].BSA__c=u.id;
        contrl.trackerRecordList[0].Developer__c=u.id;
        contrl.onSave();			//will save the record
        contrl.trackerRecordList[0].Type_of_Change__c='Code/Config';
        contrl.trackerRecordList[0].ReleaseName__c=releasedetail.id;
        contrl.trackerRecordList[0].Story_Req_SD__c='US123451';
        contrl.trackerRecordList[0].DevBoxName__c='devbox';
        contrl.trackerRecordList[0].NeworExisting__c='New';
        contrl.trackerRecordList[0].Type__c='Apex Class';
        contrl.trackerRecordList[0].ComponentLabelName__c='masterTrackerTestClass';
        contrl.trackerRecordList[0].ComponentAPIName__c='masterTrackerTestClass';
        contrl.trackerRecordList[0].BSA__c=u.id;
        contrl.trackerRecordList[0].Developer__c=u.id;
        contrl.onSave();		//will save the record and show conflict
        contrl.RcdTy = 'Data Load';
        contrl.continueType();		//to initiate the page, with type selected
        contrl.onSave();
        contrl.trackerRecordList[0].ReleaseName__c=releasedetail.id;
        contrl.trackerRecordList[0].Story_Req_SD__c='US123452';
        contrl.trackerRecordList[0].Type__c='Custom Object';
        contrl.trackerRecordList[0].ObjectName__c='Opportunity';
        contrl.trackerRecordList[0].BSA__c=u.id;
        contrl.onSave();		//to insert a data load record
        
        //testing masterTrackerViewAllController
        PageReference pageRef2 = Page.masterTrackerViewAll;
        Test.setCurrentPage(pageRef2);
        masterTrackerViewAllController contrl2 = new masterTrackerViewAllController();
        contrl2.gettrackerRecordList();
        
        
    }

     @isTest
    static void masterTrackerViewEditComponentsTestMethod(){
        
        createTestUsers();
        
        ReleaseDetails__c releasedetail = [select id from ReleaseDetails__c where IsActive__c=true limit 1];
        system.assertNotEquals(null, releasedetail, 'Release Detail should not be null.');
        
        List<MasterTracker__c> mastertracklist = new List<MasterTracker__c>();
        MasterTracker__c masterTrackerRecord = new MasterTracker__c();
        masterTrackerRecord.Type_of_Change__c = 'Code/Config';
        masterTrackerRecord.ReleaseName__c=releasedetail.id;
        masterTrackerRecord.Story_Req_SD__c='US100000';
        masterTrackerRecord.DevBoxName__c='devbox';
        masterTrackerRecord.NeworExisting__c='Existing';
        masterTrackerRecord.Type__c='Custom Field';
        masterTrackerRecord.ComponentLabelName__c='Test Field';
        masterTrackerRecord.ComponentAPIName__c='TestField__c';
        masterTrackerRecord.ObjectName__c = 'Product2';
        masterTrackerRecord.BSA__c=UserInfo.getUserId();
        masterTrackerRecord.Developer__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord);
        
        MasterTracker__c masterTrackerRecord2 = new MasterTracker__c();
        masterTrackerRecord2.Type_of_Change__c = 'Data Load';
        masterTrackerRecord2.ReleaseName__c=releasedetail.id;
        masterTrackerRecord2.Story_Req_SD__c='US100000';
        masterTrackerRecord2.Type__c='Custom Object';
        masterTrackerRecord2.ObjectName__c = 'Product2';
        masterTrackerRecord2.BSA__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord2);
        
        insert mastertracklist;
        
        
        PageReference pageRef = Page.masterTrackerViewEdit;
        Test.setCurrentPage(pageRef);
        masterTrackerViewEditController contrl = new masterTrackerViewEditController();
        contrl.RcdTy = 'Code/Config';
        contrl.continueType();
        contrl.checkalllineitems();
        contrl.allchecked=true;
        contrl.checkalllineitems();
        contrl.trackerRecordList[0].mt.ComponentAPIName__c='masterTrackerEmailClasses';
        contrl.onSave();
        contrl.allchecked=true;
        contrl.checkalllineitems();
        contrl.onDelete();
        contrl.RcdTy = 'Data Load';
        contrl.continueType();
        contrl.checkalllineitems();
        contrl.allchecked=true;
        contrl.checkalllineitems();
        contrl.onSave();
        contrl.allchecked=true;
        contrl.checkalllineitems();
        contrl.onDelete();
        
    }
    
    @isTest
    static void releaseDetailSchedulerTest(){
        
        List<ReleaseDetails__c> releaseDetailList = new List<ReleaseDetails__c>();
        
        ReleaseDetails__c fututreReleaseDetail = new ReleaseDetails__c();
        fututreReleaseDetail.CO_Number__c='200-001234';
        fututreReleaseDetail.IsActive__c=false;
        fututreReleaseDetail.Name='Future Release 1';
        fututreReleaseDetail.ReleaseDate__c=system.today()+5;
        fututreReleaseDetail.ChangeSet_Name__c='Future Release Changeset V1';
        releaseDetailList.add(fututreReleaseDetail);
        
        ReleaseDetails__c pastReleaseDetail = new ReleaseDetails__c();
        pastReleaseDetail.CO_Number__c='200-001231';
        pastReleaseDetail.IsActive__c=true;
        pastReleaseDetail.Name='Past Release 1';
        pastReleaseDetail.ReleaseDate__c=system.today()-5;
        pastReleaseDetail.ChangeSet_Name__c='Past Release Changeset V1';
        releaseDetailList.add(pastReleaseDetail);
        
        insert releaseDetailList;
        
        masterTrackerReleaseDetailScheduler mt = new masterTrackerReleaseDetailScheduler();
		mt.updateReleaseDetails();
        
    }
    
    static testmethod void testTriggerHandlerAndEmail(){
        
        createTestUsers();
        
        ReleaseDetails__c releasedetail = [select id from ReleaseDetails__c where IsActive__c=true limit 1];
        system.assertNotEquals(null, releasedetail, 'Release Detail should not be null.');
        
        List<MasterTracker__c> mastertracklist = new List<MasterTracker__c>();
        MasterTracker__c masterTrackerRecord = new MasterTracker__c();
        masterTrackerRecord.Type_of_Change__c = 'Code/Config';
        masterTrackerRecord.ReleaseName__c=releasedetail.id;
        masterTrackerRecord.Story_Req_SD__c='US100000';
        masterTrackerRecord.DevBoxName__c='devbox';
        masterTrackerRecord.NeworExisting__c='Existing';
        masterTrackerRecord.Type__c='Custom Field';
        masterTrackerRecord.ComponentLabelName__c='Test Field';
        masterTrackerRecord.ComponentAPIName__c='TestField__c';
        masterTrackerRecord.ObjectName__c = 'Product2';
        masterTrackerRecord.BSA__c=UserInfo.getUserId();
        masterTrackerRecord.Developer__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord);
        
        MasterTracker__c masterTrackerRecord2 = new MasterTracker__c();
        masterTrackerRecord2.Type_of_Change__c = 'Code/Config';
        masterTrackerRecord2.ReleaseName__c=releasedetail.id;
        masterTrackerRecord2.Story_Req_SD__c='US100002';
        masterTrackerRecord2.DevBoxName__c='devbox';
        masterTrackerRecord2.NeworExisting__c='Existing';
        masterTrackerRecord2.Type__c='Custom Field';
        masterTrackerRecord2.ComponentLabelName__c='Test Field';
        masterTrackerRecord2.ComponentAPIName__c='TestField__c';
        masterTrackerRecord2.ObjectName__c = 'Product2';
        masterTrackerRecord2.BSA__c=UserInfo.getUserId();
        masterTrackerRecord2.Developer__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord2);
        
        insert mastertracklist;
        
        List<MasterTracker__c> mtList = [select id,ReleaseName__c,ComponentLabelName__c,ComponentAPIName__c from MasterTracker__c
                                         where Type_of_Change__c =:'Code/Config' limit 1];
        if(mtList!=null && mtList.size()>0){
            mtList[0].ReleaseName__c = null;
            try{
                update mtList;
            }
            catch(exception e){
                
            }
            mtList[0].ReleaseName__c = releasedetail.id;
            masterTrackerRecord2.ComponentLabelName__c='Test Field';
        	masterTrackerRecord2.ComponentAPIName__c='TestField';
            try{
                update mtList;
            }
            catch(exception e){
                
            }       
        }
        delete mastertracklist[0];		//will fire the conflict removed email alert.
        
        MasterTracker__c masterTrackerRecord3 = new MasterTracker__c();
        masterTrackerRecord3.Type_of_Change__c = 'Data Load';
        masterTrackerRecord3.ReleaseName__c=releasedetail.id;
        masterTrackerRecord3.Story_Req_SD__c='US100000';
        masterTrackerRecord3.Type__c='Custom Object';
        masterTrackerRecord3.ObjectName__c = 'Product2';
        masterTrackerRecord3.BSA__c=UserInfo.getUserId();
        insert masterTrackerRecord3;
        
        masterTrackerRecord3 = [select id,ReleaseName__c from MasterTracker__c where Type_of_Change__c =:'Data Load' limit 1];
        masterTrackerRecord3.ReleaseName__c = null;
        try{
            update masterTrackerRecord3;
        }
        catch(exception e){
            
        }
        delete masterTrackerRecord3;
        
        
        
    }
    
    static testmethod void testTriggerHandlerMethod2(){
        
        createTestUsers();
        
        ReleaseDetails__c releasedetail = [select id from ReleaseDetails__c where IsActive__c=true limit 1];
        system.assertNotEquals(null, releasedetail, 'Release Detail should not be null.');
        
        List<MasterTracker__c> mastertracklist = new List<MasterTracker__c>();
        MasterTracker__c masterTrackerRecord = new MasterTracker__c();
        masterTrackerRecord.Type_of_Change__c = 'Code/Config';
        masterTrackerRecord.ReleaseName__c=releasedetail.id;
        masterTrackerRecord.Story_Req_SD__c='US100000';
        masterTrackerRecord.DevBoxName__c='devbox';
        masterTrackerRecord.NeworExisting__c='Existing';
        masterTrackerRecord.Type__c='Apex Trigger';
        masterTrackerRecord.ComponentLabelName__c='Testtrigger';
        masterTrackerRecord.ComponentAPIName__c='Testtrigger';
        masterTrackerRecord.ObjectName__c = 'Product2';
        masterTrackerRecord.BSA__c=UserInfo.getUserId();
        masterTrackerRecord.Developer__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord);
        
        MasterTracker__c masterTrackerRecord2 = new MasterTracker__c();
        masterTrackerRecord2.Type_of_Change__c = 'Code/Config';
        masterTrackerRecord2.ReleaseName__c=releasedetail.id;
        masterTrackerRecord2.Story_Req_SD__c='US100002';
        masterTrackerRecord2.DevBoxName__c='devbox';
        masterTrackerRecord2.NeworExisting__c='Existing';
        masterTrackerRecord2.Type__c='Custom Field';
        masterTrackerRecord2.ComponentLabelName__c='Test Field';
        masterTrackerRecord2.ComponentAPIName__c='TestField__c';
        masterTrackerRecord2.ObjectName__c = 'Opportunity';
        masterTrackerRecord2.BSA__c=UserInfo.getUserId();
        masterTrackerRecord2.Developer__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord2);
        
        MasterTracker__c masterTrackerRecord3 = new MasterTracker__c();
        masterTrackerRecord3.Type_of_Change__c = 'Code/Config';
        masterTrackerRecord3.ReleaseName__c=releasedetail.id;
        masterTrackerRecord3.Story_Req_SD__c='US100001';
        masterTrackerRecord3.DevBoxName__c='devbox';
        masterTrackerRecord3.NeworExisting__c='Existing';
        masterTrackerRecord3.Type__c='Apex Trigger';
        masterTrackerRecord3.ComponentLabelName__c='Testtrigger';
        masterTrackerRecord3.ComponentAPIName__c='Testtrigger';
        masterTrackerRecord3.ObjectName__c = 'Product2';
        masterTrackerRecord3.BSA__c=UserInfo.getUserId();
        masterTrackerRecord3.Developer__c=UserInfo.getUserId();
        mastertracklist.add(masterTrackerRecord3);
        
        insert mastertracklist;
        
        List<MasterTracker__c> mtList = [select id from MasterTracker__c where Type_of_Change__c=:'Code/Config'
                                        AND Type__c=:'Apex Trigger' limit 1];
        if(mtList!=null && mtList.size()>0)
            delete mtList;
        
        
        
        
        
    }

}