@isTest(SeeAllData=true)
public class TestBPDataFactory {
	
	public static id PopulateTestAccount() {
		Id testuserId = Userinfo.getUserId();
        
        Account acc = new Account(aggregate_account__c = 'No' , spf__approved_for_partner_finder__c = false , not_eligible_for_shark_tank_leads__c = false , recordtypeid = '01230000001L55eAAC' , hq__c = false , is_primary_account__c = true , reference_account__c = false ,
         account_plan_sync__c = false , mvp_account__c = false , account_owner_name__c = 'Daniel Zeidler' ,
          agreement_attached__c = false , customer_success_story_attached__c = false , solution_provider__c = false ,
           geo__c = 'NA' , currencyisocode = 'USD' , comments__c = 'line1\nline2' , aocv__c = 0.000 ,
            territory_country_text__c = 'EA_MIDATLANTIC' , velocity_seller__c = false ,
             solution_provider_type__c = 'Reseller' , name = 'Dan Inc' , ela__c = false , 
             eligible_for_mdf__c = false , received_last_lead__c = false , partner_agreement_attached__c = false , 
             region_country__c = 'US' , partner_enablement_addendum_attached__c = false ,  
             company_overview__c = 'This is an awesome company,\nI really mean it,\nits going to be a fortune 100 company one day!' , send_site_request__c = false , 
             sales_requests_not_to_call_account__c = false , alliance__c = false , region_text__c = 'NA' , 
             business_plan_attached__c = false , customer_pricesheet__c = false , 
             partner_spotlight_attached__c = false , spf__partner_finder_recommended_flag__c = false ,
              area_text__c = 'EAST' , service_provider__c = false , account_status__c = 'New' ,
               ocv__c = 0.000 , press_release_attached__c = false ,  
               solution_catalog_submission_attached__c = false , sales_region__c = 'EA_MIDATLANTIC' , 
               d_b_hq__c = false , check_account_access__c = false , isexcludedfromrealign = false , 
               dla_attached__c = false , sales_area__c = 'EAST' , country_picklist__c = 'US - UNITED STATES' , 
               sent_to_mdm__c = false , auto_assignment_enabled__c = false , billingcountry = 'US' , 
               pds_addendum_attached__c = false , site_request_flag__c = false , create_opp_grid__c = false);//segment__c = 'Large-New' ,coverage_model__c = 'Account Team' ,
               
               acc.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='Islandia';         
        insert acc;
        
        TAQ_Account__c myTaq = new TAQ_Account__c();
        myTaq.View_Acc_Record__c = acc.Id;
        myTaq.country_picklist__c = 'US - UNITED STATES';    
        insert myTaq;
        
        return acc.id;
	}
	
	 public static ID PopulateTestBP(ID AccountId)
    {
        Business_Plan_New__c bp = new Business_Plan_New__c();
        bp.Account__c=AccountId;
        bp.Alliance__c=true;
        bp.Service_Provider__c=true;
        bp.Solution_Provider__c=true;
        bp.Data_Management__c=true;
        bp.DM_Program_Level__c='true';
        bp.Plan_Fiscal_Year__c='FY 2015';
        bp.CA_Business_Plan_Owner__c='005300000045UXA';
        bp.NA__c=true;
        bp.EMEA__c=true;
        bp.LA__c=true;
        bp.APJ__c=true;
        
        insert bp;
        
        return bp.Id;
    }

    public static void PopulateTestAttachments(ID bpId)
    {
        List<Attachment> attList = new List<Attachment>();
          
          Attachment attach = new Attachment();
         
          attach.Body = blob.valueOf('TestString');
          attach.Name = 'test1.pdf';
          attach.description = 'Business Plan Approval Process Generated Attachments - Do not change Description';
          attach.IsPrivate = false;
          attach.ParentId = bpId;
          attList.add(attach);
          
          attach = new Attachment();
          attach.Body = blob.valueOf('TestString');
          attach.Name = 'test2.pdf';
          attach.IsPrivate = false;
          attach.ParentId = bpId;
          attList.add(attach);
          
         insert attList;
    }
	
}