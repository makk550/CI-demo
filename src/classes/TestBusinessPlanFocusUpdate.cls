@isTest(SeeAllData=true)
public class TestBusinessPlanFocusUpdate{

    
    public static testMethod void testUpdateBusinessPlan() {
        
        
       Id testuserId = Userinfo.getUserId();
    
       Account acc = new Account(aggregate_account__c = 'No' , spf__approved_for_partner_finder__c = false , not_eligible_for_shark_tank_leads__c = false , recordtypeid = '01230000001L55eAAC' , hq__c = false , is_primary_account__c = true , reference_account__c = false ,
       account_plan_sync__c = false , mvp_account__c = false , account_owner_name__c = 'Daniel Zeidler' ,
       agreement_attached__c = false , customer_success_story_attached__c = false , solution_provider__c = true ,
       geo__c = 'NA' , currencyisocode = 'USD' , comments__c = 'line1\nline2' , aocv__c = 0.000 ,
       territory_country_text__c = 'EA_MIDATLANTIC' , velocity_seller__c = true ,
       solution_provider_type__c = 'Reseller' , name = 'Dan Inc' , ela__c = false , 
       eligible_for_mdf__c = false , received_last_lead__c = false , partner_agreement_attached__c = false , 
       region_country__c = 'US' , partner_enablement_addendum_attached__c = false , 
       company_overview__c = 'This is an awesome company,\nI really mean it,\nits going to be a fortune 100 company one day!' , send_site_request__c = false , 
       sales_requests_not_to_call_account__c = false , alliance__c = true , region_text__c = 'NA' , 
       business_plan_attached__c = false , customer_pricesheet__c = false , 
       partner_spotlight_attached__c = false , spf__partner_finder_recommended_flag__c = false ,
       area_text__c = 'EAST' , service_provider__c = true , account_status__c = 'New' ,
       ocv__c = 0.000 , press_release_attached__c = false ,  
       solution_catalog_submission_attached__c = false , sales_region__c = 'EA_MIDATLANTIC' , 
       d_b_hq__c = false , check_account_access__c = false , isexcludedfromrealign = false , 
       dla_attached__c = false , sales_area__c = 'EAST' , country_picklist__c = 'US - UNITED STATES' , 
       sent_to_mdm__c = false , auto_assignment_enabled__c = false , billingcountry = 'US' , 
       pds_addendum_attached__c = false , site_request_flag__c = false , create_opp_grid__c = false);// segment__c = 'Large-New' ,coverage_model__c = 'Account Team' ,
       acc.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
       acc.BillingStreet='Street';
       acc.BillingCountry='US';
       acc.BillingCity='Islandia';         
       insert acc;
       
       Product_Alignment__c productAligment1 = new   Product_Alignment__c();
       
       productAligment1.Product_Group__c = 'Client Automation';
       productAligment1.Related_Account__c = acc.Id;
       insert productAligment1;
       TAQ_Account__c myTaq = new TAQ_Account__c();
       myTaq.View_Acc_Record__c = acc.Id;
       insert myTaq;
       Business_Plan_New__c businessPlan = new Business_Plan_New__c();
       businessPlan.Account__c = acc.Id;
       businessPlan.Status__c = 'insert';
       businessPlan.CA_Business_Plan_Owner__c = UserInfo.getUserId();
       insert businessPlan;
        
       
       List<BP_Solutions__c> bSolList = new List<BP_Solutions__c>();
       BP_Solutions__c bSol1 = new BP_Solutions__c();
       bSol1.Business_Plan__c = businessPlan.Id;
       bSol1.RTM__c ='Alliance';
       bSolList.add(bSol1);
       BP_Solutions__c bSol2 = new BP_Solutions__c();
       bSol2.Business_Plan__c = businessPlan.Id;
       bSol2.RTM__c ='Solution Provider';
       bSol2.Product_Group__c = 'Client Automation';
       bSolList.add(bSol2);
       BP_Solutions__c bSol3 = new BP_Solutions__c();
       bSol3.Business_Plan__c = businessPlan.Id;
       bSol3.RTM__c ='Service Provider';
       bSolList.add(bSol3);
       BP_Solutions__c bSol4 = new BP_Solutions__c();
       bSol4.Business_Plan__c = businessPlan.Id;
       bSol4.Product_Group__c = 'Client Automation';
       bSolList.add(bSol4);
       BP_Solutions__c bSol5 = new BP_Solutions__c();
       bSol5.Business_Plan__c = businessPlan.Id;
       bSolList.add(bSol5);
       insert bSolList;
        businessPlan.Status__c ='Approved';
      System.debug('==businessPlan======'+businessPlan);  
      // update businessPlan ;                                                
       
     
       
    }
}