/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@IsTest
public class AccountPlanTest {
    private static final Id ACCOUNT_COMMERCIAL_RECORDTYPEID   = '01230000000GaFYAA0';
    static Account_Plan3__c populateTestData()
    {
        //TODO: change this to create a new test user
        User usr;
        Account a; 
        Account_Plan3__c ap;
        //SAMAP01 -US367308
        //record type id for Reseller/Distributor accounts.
       insertRecordtypes();           
        
        Id testuserId = Userinfo.getUserId();
        //Id testuserId = usr.ID;
        
        // Account acc = new Account(aggregate_account__c = 'No' , spf__approved_for_partner_finder__c = false , not_eligible_for_shark_tank_leads__c = false , recordtypeid = '01230000001L55eAAC' , hq__c = false , is_primary_account__c = true , reference_account__c = false , account_plan_sync__c = false , mvp_account__c = false , account_owner_name__c = 'Daniel Zeidler' , agreement_attached__c = false , customer_success_story_attached__c = false , solution_provider__c = false , geo__c = 'NA' , currencyisocode = 'USD' , comments__c = 'line1\nline2' , aocv__c = 0.000 , territory_country_text__c = 'EA_MIDATLANTIC' , velocity_seller__c = false , solution_provider_type__c = 'Reseller' , name = 'Dan Inc' , ela__c = false , eligible_for_mdf__c = false , received_last_lead__c = false , partner_agreement_attached__c = false , region_country__c = 'US' , partner_enablement_addendum_attached__c = false , segment__c = 'Large-New' , company_overview__c = 'This is an awesome company,\nI really mean it,\nits going to be a fortune 100 company one day!' , send_site_request__c = false , sales_requests_not_to_call_account__c = false , alliance__c = false , region_text__c = 'NA' , business_plan_attached__c = false , customer_pricesheet__c = false , partner_spotlight_attached__c = false , spf__partner_finder_recommended_flag__c = false , area_text__c = 'EAST' , service_provider__c = false , account_status__c = 'New' , ocv__c = 0.000 , press_release_attached__c = false , coverage_model__c = 'Account Team' , solution_catalog_submission_attached__c = false , sales_region__c = 'EA_MIDATLANTIC' , d_b_hq__c = false , check_account_access__c = false , isexcludedfromrealign = false , dla_attached__c = false , sales_area__c = 'EAST' , country_picklist__c = 'US - UNITED STATES' , sent_to_mdm__c = false , auto_assignment_enabled__c = false , billingcountry = 'US' , pds_addendum_attached__c = false , site_request_flag__c = false , create_opp_grid__c = false);
        //acc.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        Account acc = new Account(Name='test account',RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='Islandia'; 
        insert acc;            
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('CA Contact Record Type').RecordTypeId;
        Contact con = new Contact(renewal__c = false , senior_executive_sales_leader__c = false , functional_role__c = 'CEO/President' , recordtypeid = contactRecordTypeId, portal_champion__c = false , hasoptedoutofemail = false , do_not_contact_flag__c = false , hvn__c = false , lastname = 'Zeidler' , mailingcountry = 'US' , title = 'Applications Developer' , marketing_mailing_opt_in_out__c = false , firstname = 'Bob' , language_preference__c = 'English' , salutation = 'Lord' , job_level_group__c = 'Executive Level' , do_not_email__c = false , partner_satisfaction_survey_opt_in_out__c = false , primary__c = false , hasoptedoutoffax = false , country_picklist__c = 'US - UNITED STATES' , email = 'bob@bob.bob' , donotcall = false , confirmed_pilot_user__c = false , currencyisocode = 'USD' , technical__c = false , accountid = acc.Id , marketing__c = false , exists_in_sap__c = false , c_suite_senior_executive__c = false);
        //con.HVN__c =true;
        //con.HVN_ID__c ='a000000AL0K6AAL';
        
        insert con;
        
        Id eventRecordTypeId = Schema.SObjectType.Event.RecordTypeInfosByName.get('Sales Event').RecordTypeId;
        List<Event> eventList = new List<Event>();
        eventList.add(new Event(isvisibleinselfservice = false , durationinminutes = 60 , activitydate = Date.valueOf('2013-01-17 00:00:00') , type = 'Meeting' , description = 'Lunch meeting with Melinda' , recordtypeid = eventRecordTypeId , reminderdatetime = DateTime.valueOf('2013-01-16 17:00:00') , temp_startdatetime__c = DateTime.valueOf('2013-01-15 21:56:54') , activitydatetime = DateTime.valueOf('2013-01-17 17:00:00') , startdatetime = DateTime.valueOf('2013-01-17 17:00:00') , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2013-01-15 21:56:54') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' ,  subject = 'Lunch Meeting' , showas = 'Busy' , isreminderset = false , isalldayevent = false , enddatetime = DateTime.valueOf('2013-01-17 18:00:00') , isprivate = false));
        eventList.add(new Event(isvisibleinselfservice = false , durationinminutes = 60 , activitydate = Date.valueOf('2013-01-20 00:00:00') , description = 'Meeting with Tony Davis' , recordtypeid = eventRecordTypeId , reminderdatetime = DateTime.valueOf('2013-01-20 20:45:00') , temp_startdatetime__c = DateTime.valueOf('2013-01-02 20:46:16') , activitydatetime = DateTime.valueOf('2013-01-20 21:00:00') , startdatetime = DateTime.valueOf('2013-01-20 21:00:00') , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2013-01-02 20:46:16') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' ,  subject = 'Enterprise Reliability Workshop' , showas = 'Busy' , isreminderset = false , isalldayevent = false , enddatetime = DateTime.valueOf('2013-01-20 22:00:00') , isprivate = false));
        eventList.add(new Event(isvisibleinselfservice = false , durationinminutes = 60 , activitydate = Date.valueOf('2013-07-16 00:00:00') , recordtypeid = eventRecordTypeId , reminderdatetime = DateTime.valueOf('2013-07-16 16:45:00') , temp_startdatetime__c = DateTime.valueOf('2013-07-16 16:51:30') , activitydatetime = DateTime.valueOf('2013-07-16 17:00:00') , startdatetime = DateTime.valueOf('2013-07-16 17:00:00') , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2013-07-16 16:51:30') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' , subject = 'temp event' , showas = 'Busy' , isreminderset = false , isalldayevent = false , enddatetime = DateTime.valueOf('2013-07-16 18:00:00') , isprivate = false));
        eventList.add(new Event(isvisibleinselfservice = false , durationinminutes = 60 , activitydate = Date.valueOf('2013-07-16 00:00:00') , description = 'this is just a test' , recordtypeid = eventRecordTypeId , reminderdatetime = DateTime.valueOf('2013-07-16 15:45:00') , temp_startdatetime__c = DateTime.valueOf('2013-07-16 15:55:48') , activitydatetime = DateTime.valueOf('2013-07-16 16:00:00') , startdatetime = DateTime.valueOf('2013-07-16 16:00:00') , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2013-07-16 15:55:48') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' ,  subject = 'Presales Event' , showas = 'Busy' , isreminderset = false , isalldayevent = false , enddatetime = DateTime.valueOf('2013-07-16 17:00:00') , isprivate = false));
        eventList.add(new Event(isvisibleinselfservice = false , durationinminutes = 60 , activitydate = Date.valueOf('2013-08-14 00:00:00') , recordtypeid = eventRecordTypeId , reminderdatetime = DateTime.valueOf('2013-08-14 15:45:00') , temp_startdatetime__c = DateTime.valueOf('2013-08-14 15:24:25') , activitydatetime = DateTime.valueOf('2013-08-14 16:00:00') , startdatetime = DateTime.valueOf('2013-08-14 16:00:00') , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2013-08-14 15:24:25') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' , subject = 'Call' , showas = 'Busy' , isreminderset = false , isalldayevent = false , enddatetime = DateTime.valueOf('2013-08-14 17:00:00') , isprivate = false));
        eventList.add(new Event(isvisibleinselfservice = false , durationinminutes = 60 , activitydate = Date.valueOf('2014-01-28 00:00:00') , type = 'Call' , description = 'Set up Customer Review for Feb 5, 2013' , recordtypeid = eventRecordTypeId , reminderdatetime = DateTime.valueOf('2013-01-28 18:45:00') , temp_startdatetime__c = DateTime.valueOf('2013-01-02 18:52:07') , activitydatetime = DateTime.valueOf('2014-01-28 19:00:00') , startdatetime = DateTime.valueOf('2014-01-28 19:00:00') , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2013-01-02 18:52:07') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' , subject = 'Call' , showas = 'Busy' , isreminderset = false , isalldayevent = false , enddatetime = DateTime.valueOf('2014-01-28 20:00:00') , isprivate = false));       
        insert eventList;
        
        Id taskRecordTypeId = Schema.SObjectType.Task.RecordTypeInfosByName.get('General Task').RecordTypeId;
        List<Task> taskList = new List<Task>();
        taskList.add(new Task(isvisibleinselfservice = false , type = 'Other' , priority = 'High' , recordtypeid = taskRecordTypeId , reminderdatetime = DateTime.valueOf('2012-12-27 13:00:00') , temp_startdatetime__c = DateTime.valueOf('2012-12-27 21:26:59') , status = 'In Progress' , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2012-12-27 21:26:59') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' , subject = 'team meeting' , isreminderset = false));
        taskList.add(new Task(isvisibleinselfservice = false , priority = 'High' , recordtypeid = taskRecordTypeId , reminderdatetime = DateTime.valueOf('2012-12-31 13:00:00') , temp_startdatetime__c = DateTime.valueOf('2012-12-31 18:04:28') , status = 'In Progress' , ownerid = testuserId , temp_enddatetime__c = DateTime.valueOf('2012-12-31 18:04:28') , isrecurrence = false , whatid = acc.Id , currencyisocode = 'USD' , subject = 'Q4 EBC Visit' ,  isreminderset = false));
        insert taskList;
        
        ap = new Account_Plan3__c(Annual_Spend_to_Date__c=10000 ,Plan_Finalize_Budget_Begin_Date__c='January' ,Plan_Finalize_Budget_End__c='May' ,Sign_off_Begin_Date__c='February' ,Sign_off_End_Date__c='June' ,Overall_Account_Strategy__c='test' ,Key_Account_Objectives__c='test' ,External_Business_Climate_Trends__c='test' ,Stated_Business_Priorities__c='test' , Underlying_Business_Initiatives_1__c='test 1', Underlying_Business_Initiatives_type_1__c='Current',Corresponding_IT_Initiatives_1__c='test 1',Corresponding_IT_Initiatives_Type_1__c='Current', account_plan_approver__c=testuserId, CA_Executive_Sponsor_2__c =testuserId , underlying_business_initiatives_type_4__c = 'Current'  , tactic_1__c = 'asdf' , resource_owner_1__c = testuserId , sales_coverage_business_unit_3__c = 'All' , timing_1__c = Date.valueOf('2013-08-12 00:00:00') , underlying_business_initiatives_type_2__c = 'Current' , underlying_business_initiatives_type_3__c = 'Current' , account_plan_status__c = 'Draft' , account__c = acc.id , fiscal_year__c = 'FY13' , timing_end_date_1__c = Date.valueOf('2013-08-12 00:00:00') , corresponding_it_initiatives_type_5__c = 'Current' , corresponding_it_initiatives_type_4__c = 'Current' , corresponding_it_initiatives_type_3__c = 'Current' , sales_coverage_business_unit_2__c = 'All' , currencyisocode = 'USD' ,  name = 'Asurion Corporation - Account Plan Summary' , sales_coverage_business_unit_1__c = 'All' , sales_coverage_business_unit_4__c = 'All' , underlying_business_initiatives_type_5__c = 'Current' , status_1__c = 'Yellow' , sales_coverage_business_unit_5__c = 'All' , key_account_relationship_1__c = con.Id);
        ap.selected_tasks__c = eventList[0].Id + ',' + taskList[0].Id;
        ap.Upcoming_Events__c = eventList[0].Id + ',' + taskList[0].Id;
        ap.Recent_CA_Executive_Interactions__c = eventList[0].Id + ',' + taskList[0].Id;
        //SAMAP01 -US367308
        ap.CA_Executive_Sponsors__c ='005a000000AL0K6AAL';
        ap.Key_Account_Relationship_1__c = con.Id;
        ap.Key_Account_Relationship_2__c = con.Id;
        ap.Key_Account_Relationship_3__c = con.Id;
        ap.Key_Account_Relationship_4__c = con.Id;
      	ap.Overall_Account_Strategy__c ='Expand CA relationships in account';
        insert ap;      
        return ap;
       
    }
 public static void insertRecordtypes()    
     {
          lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
            RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Commercial Account');
            lstrec.add(rec1);
            RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFP', Name='CA Enterprise Account');
            lstrec.add(rec2);
            RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Account Team Covered Account');
            lstrec.add(rec3);
            RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFR', Name='Reseller/Distributor Account');
            lstrec.add(rec4);
            insert lstrec;
     }
    static testMethod void testAccountPlan() 
    {
        Account_Plan3__c ap = populateTestData();
        ApexPages.StandardController sc = new ApexPages.standardController(ap);
        AccountPlanControllerExtension e = new AccountPlanControllerExtension(sc);
        e.New_Event_URL = 'test data';
        e.Activities = new List<AccountPlanControllerExtension.ActivityWrapper>();
        e.pageNumber = 10;
        e.activityType = 'test data';
        e.apapprover = '01p90000006uk2w';
        e.aplanapprover = '01p90000006uk2w';
        //e.activityLookupNumber = 'test data';
        e.paginatedEvents = new List<List<AccountPlanControllerExtension.ActivityWrapper>>();
        e.paginatedTasks = new List<List<AccountPlanControllerExtension.ActivityWrapper>>();
        e.eSize = 10;
        e.contIdChosen = 'test data';  
        Account acc = new Account(Name='test account',RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='Islandia'; 
        insert acc;    
        
        ApexPages.StandardController scc = new ApexPages.standardController(acc);
        e.ec = new Ext_Cill(scc);  
        e.displayPopup = false; 
      
        AccountPlanControllerExtension.ActivityWrapper obj1 = new AccountPlanControllerExtension.ActivityWrapper();
            obj1.isTask = false;
            obj1.aTask = new Task();
        	obj1.aTask.ActivityDate=  date.today();
            obj1.anEvent = new Event();
            obj1.selected = false;
            obj1.selected2 = false;
            obj1.selected3 = false;       
   			string formateddate = obj1.getFormattedDate();        		          
          
        e.checkForRedirect();
        
        //Opps
        e.getCustomerRenewals();
        e.getTopOpps();
        
        // Activities
        e.getSelectedActivities();
        e.getSelectedActivities2();
        e.getSelectedActivities3();
        e.cancelActivityLookup();
        
        //Activity Navigation
        e.doPrevious();
        e.getHasPrevious();
        e.getTotalPages();
        e.doNext();
        e.getHasNext();
        e.switchView();
                
        
        //parsing functions
        e.getExternalBusinessClimateTrends();
        e.getStatedBusinessPriorities();
        e.getKeyPastProjects();
        e.getCurrentProjects();
        
        //deprecated methods
        e.getDummy();
        e.closePopup();
        e.closeAndSavePopup();
        e.showPopup();
        e.getUserList();
        e.addUserRow();
        e.contIdChosen = '1';
        e.deleteExecUser();
        AccountPlanControllerExtension.getPicklistValues(ap, 'Plan_Finalize_Budget_Begin_Date__c');
        
        //Save
        e.Save();
    }
    
    static testmethod void testActivityView()
    {
        Account_Plan3__c ap = populateTestData();
        ApexPages.StandardController sc = new ApexPages.standardController(ap);
        AccountPlanControllerExtension e = new AccountPlanControllerExtension(sc);
        
        ApexPages.currentPage().getParameters().put('lookupNum','1');        
        e.getEventView();
        e.getTaskView();        
        e.saveActivities();
        
        
        ApexPages.currentPage().getParameters().put('lookupNum','2');
        AccountPlanControllerExtension e1 = new AccountPlanControllerExtension(sc);
        e1.getEventView();
        e1.getTaskView();        
        e1.saveActivities(); 
        
        
        ApexPages.currentPage().getParameters().put('lookupNum','3'); 
        AccountPlanControllerExtension e2 = new AccountPlanControllerExtension(sc);       
        e2.getEventView();
        e2.getTaskView();        
        e2.saveActivities();
        
        
        
    }
    
    static testmethod void testAccountPlanApprover()
    {
        Account_Plan3__c ap = populateTestData();
        ApexPages.StandardController sc = new ApexPages.standardController(ap);
        AccountPlanApproverControllerExtension e3 = new AccountPlanApproverControllerExtension(sc);
        
        e3.saveapprover();
    }
    
    static testmethod void testApproval()
    {
        Account_Plan3__c ap = populateTestData();
        ap.Account_Plan_Status__c = 'Pending Approval';
        update ap;
        
        ap.Account_Plan_Status__c = 'Approved';
        update ap;
    }
    
    static testmethod void myTestGenericHistoryComponentController() {
        
        //record type id for Reseller/Distributor accounts.
       insertRecordtypes() ;
        //create controller
        GenericHistoryComponentController controller = new GenericHistoryComponentController();
        //null myObject
        system.assert(controller.getObjectHistory().size() == 0);
        Account acc = new Account(Name='test account',RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='Islandia'; 
        insert acc;
        
        acc.BillingStreet='Test';
        Update acc;
        
        acc.BillingStreet='Street1';
        Update acc;
        
        //Account allows for history in related lists in visualforce, 
        // this is simply a standard object being used to get code coverage so you can use the component for other custom and standard objects.
        AggregateResult[] aggResList = [select AccountId, Count(ID) from AccountHistory Group By AccountId Having Count(ID) > 1 Limit 1];
        // System.assert(aggResList.size() > 0,'Test requires at least 1 Account with 2+ Account Field History rows');
        
        //Set myObject
        If(aggResList.size()>0)
        {
            controller.myObject = [select id from Account where id=: (ID)aggResList[0].get('accountId')];               
            system.assert(controller.getObjectHistory().size() > 0); 
        }
        
    }
    
   
}