@isTest(SeeAllData=true)
private class ExecutiveProfileTest {
  
  static Executive_Profile__c populateTestData()
  {
    Id testuserId = Userinfo.getUserId();
    
    Account acc = new Account(aggregate_account__c = 'No' , spf__approved_for_partner_finder__c = false , not_eligible_for_shark_tank_leads__c = false , recordtypeid = '01230000001L55eAAC' , hq__c = false , is_primary_account__c = true , reference_account__c = false ,
     account_plan_sync__c = false , mvp_account__c = false , account_owner_name__c = 'Daniel Zeidler' ,
      agreement_attached__c = false , customer_success_story_attached__c = false , solution_provider__c = false ,
       geo__c = 'NA' , currencyisocode = 'USD' , comments__c = 'line1\nline2' , aocv__c = 0.000 ,
        territory_country_text__c = 'EA_MIDATLANTIC' , velocity_seller__c = false ,
         solution_provider_type__c = 'Reseller' , name = 'Dan Inc' , ela__c = false , 
         eligible_for_mdf__c = false , received_last_lead__c = false , partner_agreement_attached__c = false , 
         region_country__c = 'US' , partner_enablement_addendum_attached__c = false , segment__c = 'Large-New' , 
         company_overview__c = 'This is an awesome company,\nI really mean it,\nits going to be a fortune 100 company one day!' , send_site_request__c = false , 
         sales_requests_not_to_call_account__c = false , alliance__c = false , region_text__c = 'NA' , 
         business_plan_attached__c = false , customer_pricesheet__c = false , 
         partner_spotlight_attached__c = false , spf__partner_finder_recommended_flag__c = false ,
          area_text__c = 'EAST' , service_provider__c = false , account_status__c = 'New' ,
           ocv__c = 0.000 , press_release_attached__c = false , coverage_model__c = 'Account Team' , 
           solution_catalog_submission_attached__c = false , sales_region__c = 'EA_MIDATLANTIC' , 
           d_b_hq__c = false , check_account_access__c = false , isexcludedfromrealign = false , 
           dla_attached__c = false , sales_area__c = 'EAST' , country_picklist__c = 'US - UNITED STATES' , 
           sent_to_mdm__c = false , auto_assignment_enabled__c = false , billingcountry = 'US' , 
           pds_addendum_attached__c = false , site_request_flag__c = false , create_opp_grid__c = false);
           acc.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
    acc.BillingStreet='Street';
    acc.BillingCountry='US';
    acc.BillingCity='Islandia';         
    insert acc;
    
/*        Account acc = new Account();
        acc.Name = 'testAcc1';
        acc.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acc.Country_Picklist__c = 'INDIA';
        acc.GEO__c = 'NA';
        acc.Account_Status__c = 'Approved';
        acc.Aggregate_Account__c = 'Yes';
        acc.Customer_Category__c = 'Commercial';
        acc.Commercial_Account_Name__c = 'commAcc';
        acc.Commercial_ID__c = 'commId';
        acc.Global_ID__c = 'globId';
        acc.Global_Name__c = 'globName';
        insert acc;    */
    
    Contact con = new Contact(renewal__c = false , senior_executive_sales_leader__c = false , 
    functional_role__c = 'CEO/President' ,  recordtypeid = '01230000000DRC4AAO' ,
     portal_champion__c = false , hasoptedoutofemail = false , do_not_contact_flag__c = false , hvn__c = false, 
     lastname = 'Zeidler' , mailingcountry = 'US' , title = 'Applications Developer' , 
     marketing_mailing_opt_in_out__c = false , firstname = 'Bob' , language_preference__c = 'English' , 
     salutation = 'Lord' , job_level_group__c = 'Executive Level' , do_not_email__c = false , 
     partner_satisfaction_survey_opt_in_out__c = false , primary__c = false , hasoptedoutoffax = false ,
      country_picklist__c = 'US - UNITED STATES' , email = 'bob@bob.bob' , donotcall = false , 
      confirmed_pilot_user__c = false , currencyisocode = 'USD' , technical__c = false ,
       accountid = acc.Id , marketing__c = false , exists_in_sap__c = false , c_suite_senior_executive__c = false);
    insert con;
    
    HVN__c hvn = new HVN__c();
    hvn.Contact__c = con.id;
    hvn.name='Bob Zeidler';
    hvn.ADDITIONAL_INFORMATION__C='Additional';
    hvn.awards_recognition__c='Above and Beyond';
    hvn.BIRTHDAY_MONTH__C='January';
    hvn.BIRTHDAY_YEAR__C='1';
    hvn.book_preference__c='Arts;Biographies & Memoirs';
    hvn.can_contact_accept_gifts__c=false;
    hvn.college_fraternity_sorority__c='F';
    hvn.community_involvement__c='Charity';
    hvn.contact_nickname__c='Bob';
    hvn.culinary_preference__c='Bagels';
    hvn.family_information__c='Big Family';
    hvn.favorite_charity__c='charity';
    hvn.hobbies__c='Bicycling';
    hvn.hobbies_other__c='swimming';
    hvn.holiday_celebrations__c='Christmas';
    hvn.military_service__c='Military';
    hvn.music_style__c='Blues';
    hvn.primary_hvn_owner__c=Userinfo.getUserId();
    hvn.role__c='decision maker';
    hvn.sports__c='basketball';
    hvn.sport_other__c='carroms';
    hvn.subscription__c='info week';
    hvn.subscription_other__c='CIO Mag';
    hvn.tv_genre__c='Action';
    hvn.favorite_tv_show__c='News';
    hvn.RELATIONSHIP_STATUS__C='Achieved High Value Contact Status/Strong Relationship1';
    
    insert hvn;
    
    con.HVN_ID__c=hvn.id;
    con.HVN__c=true;
    update con;


    Executive_Profile__c ep = new Executive_Profile__c();
    ep.Meeting_Date__c=System.today();
    ep.Location__c='Manhattan';
    ep.CA_Spend_Current__c=123456;
    ep.CA_Spend_History__c=98765;
    ep.Meeting_Type__c='EBC';
    ep.Event_Name__c='Meeting';
    ep.Customer__c=con.id;
    ep.Meeting_Status__c='Complete';
    ep.CA_Products_Not_In_Use__c='ABC';
    ep.Invitation_Reason__c='xyz';
    ep.Meeting_Reason__c='qwer';
    ep.CA_Executive_Relationships__c='dfgh';
    ep.Briefing_Reason__c='asdfa';
    ep.Action_Items__c='asdfasdf';
    ep.Approval_Status__c='Draft';
    insert ep;
    
    return ep;
  }
  
  static void submitforApp(Executive_Profile__c ep)
  {
      ep.Approval_Status__c='Pending Approval';
      update ep;
  }
    static testMethod void testEP() 
    {
      Executive_Profile__c ep = populateTestData();
      ApexPages.StandardController sc = new ApexPages.standardController(ep);
      ExecProfControllerExtension e = new ExecProfControllerExtension (sc);
      
      e.getTopOpps();
      e.getAccountLogoURL();
      e.getHVNPhotoURL();
      e.getimgURL();
      e.insertLogoDoc();
      submitforApp(ep);
    }
}