public class TestSLOMilestonesDataSetup {
    public static void createTestDataforMilestones(){
        List<SLO_Milestones__c> sloList=new List<SLO_Milestones__c>();        
        SLO_Milestones__c xx=new SLO_Milestones__c();
        xx.Name='Severity1';
        xx.Due_Date_SLO__c='60';
        xx.SLO_Milestone_1__c='30';
        xx.SLO_Milestone_2__c='45';
        xx.SLO_Milestone_3__c='54';
        xx.SLO_Milestone_4__c='45';
        xx.Type__c='1';
        sloList.add(xx);
        
        SLO_Milestones__c xx2=new SLO_Milestones__c();
        xx2.Name='Severity2';
        xx2.Due_Date_SLO__c='2';
        xx2.SLO_Milestone_1__c='60';
        xx2.SLO_Milestone_2__c='90';
        xx2.SLO_Milestone_3__c='108';
        xx2.SLO_Milestone_4__c='105';
        xx2.Type__c='2';
        sloList.add(xx2);
        
        SLO_Milestones__c xx3=new SLO_Milestones__c();
        xx3.Name='Severity3';
        xx3.Due_Date_SLO__c='4';
        xx3.SLO_Milestone_1__c='120';
        xx3.SLO_Milestone_2__c='180';
        xx3.SLO_Milestone_3__c='216';
        xx3.SLO_Milestone_4__c='225';
        xx3.Type__c='3';
        sloList.add(xx3);
        
        SLO_Milestones__c xx4=new SLO_Milestones__c();
        xx4.Name='Severity4';
        xx4.Due_Date_SLO__c='480';
        xx4.SLO_Milestone_1__c='240';
        xx4.SLO_Milestone_2__c='360';
        xx4.SLO_Milestone_3__c='432';
        xx4.SLO_Milestone_4__c='465';
        xx4.Type__c='4';
        sloList.add(xx4);    
        insert sloList; 
        
    }
    
    public static v_support_offerings__x createContractOfferingsExternalData(){
		v_support_offerings__x mockedRequest = new v_support_offerings__x();
        mockedRequest.ca_product_name__c='ACF2';
        mockedRequest.clarity_key__c='ABCD';
        mockedRequest.contract_line_num__c='10';
        mockedRequest.dse_pmf_key__c='GOVAD01';
        mockedRequest.dse_role__c='P';
        mockedRequest.offering_cd__c='ESS GOLD';
        mockedRequest.offering_end_dtm__c=System.now();
        mockedRequest.offering_start_dtm__c=System.now();
        mockedRequest.sap_contract_num__c=10;
        mockedRequest.tops_site_id__c='105246';
        
        return mockedRequest;
    }
    
    public static cbr_Calculated_Certification__x createCertificationExternalData(){
    	cbr_Calculated_Certification__x mockedRequest  = new cbr_Calculated_Certification__x();       
        mockedRequest.badge__c='Sales/Tech Sales Validation';
        mockedRequest.ca_product_code__c='PD0074';
        mockedRequest.ca_product_description__c='This is added for testing';
        mockedRequest.ca_product_name__c='CLARITY ON PREMISE';
        mockedRequest.certified__c='Yes';
        mockedRequest.certified_status_code__c=100;
        mockedRequest.certified_status_text__c='Active';
        mockedRequest.completion_percentage__c=100;
        mockedRequest.ldap_id__c='232902';
        mockedRequest.modify_date__c=System.now();
        mockedRequest.resource_type__c='Support';
        mockedRequest.valid_from__c=System.now();
        mockedRequest.valid_to__c =System.now();
    	mockedRequest.ExternalId = 'test1';        
        return mockedRequest;
    }
    

    
}