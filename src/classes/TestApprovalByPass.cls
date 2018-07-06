@isTest //(SeeAllData=true)
public class TestApprovalByPass{
    public static testMethod void testApproval(){
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        
        User u1 = new User(Alias = 'kurviqq', Email='kurvi01@ca.com', 
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='kurvi01_test@ca.com');
        insert u1;
        
        User u = new User(Alias = 'kurjaqq', Email='kurja02@ca.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='kurja02_test@ca.com',ManagerId=u1.Id);
        insert u;
          
        
               
        testOpportunityTriggersClass.createNewOppWithNoTriggers();
        Opportunity opp = [select id from Opportunity limit 1];
    
        scpq__SciQuote__c  SQ;
        Quote_Product_Report__c QPR;
        Product_Material__c PM;
        //System.runAs(u){  
        	 user u3=new user(id='00530000003rQuJ');
        system.runAs(u3){
        
            Group g = new Group(Name='Approval ByPass');
            insert g;
            
            GroupMember GM = new GroupMember(GroupId=g.Id,UserOrGroupId=u.Id);
            insert GM;
        }
            ApexPages.StandardController controller;
            ApprovalByPass AB = new ApprovalByPass(controller);
            ddrRuleRecordTestClass.insertDdrRule();
            test.startTest();
            SQ = new scpq__SciQuote__c (NAME='Test',CURRENCYISOCODE='USD',SCPQ__OPPORTUNITYID__C=opp.Id,
                SCPQ__ORDERHEADERKEY__C='22222',scpq__SciLastModifiedDate__c=system.today(),CA_CPQ_QUOTE_STATUS__C='Draft',
                CA_CPQ_QUOTE_TOTAL__C=4866.66,CA_ADJUSTED_ELIGIBLE_NCV__C=4866.66,CA_BILL_TO_ID__C='48656',
                CA_BILL_TO_NAME__C='NIKE INC',CA_BILLING_CONTACT_NAME__C='Lee Anderson',CA_BOOKING_COUNTRY__C='US',
                CA_CONTRACTED_RENEWAL__C='No',CA_CUSTOMER_NAME_SOLD_TO__C='NIKE INC',CA_DEAL_FINANCED__C='no',
                CA_DIRECT_INDIRECT__C='Direct',CA_GSA_PRICING_FLAG__C=True,CA_NEW_TRR__C=2430,CA_QUOTE_TYPE__C='New Product',
                CA_SALES_AREA__C='West',CA_TOTAL_LIC_SUB_OFF_LIST__C=50,CA_TOTAL_LIST_LICENSE_SUBS_FEE__C=9733.32,
                CA_TOTAL_PROPOSED_LIC_SUB_FEE__C=4866.66,CA_CPQ_PRODUCT_TOTAL__C=4866.66,CA_PAYMENT_SCHEDULE__C='Quarterly',
                CA_USING_QUICK_CONTRACT__C=True,NET_PAYMENT_TERMS__C='Net 30',SUBSCRIPTION_PAYMENT__C=4866.66);
            insert SQ;
             
            PM = new Product_Material__c(Name='NCUEBM990',CURRENCYISOCODE='USD',EXPIRED__C=false,
                MATERIAL_TEXT__C='NIMSOFT CLD EX MIN BSC MTR',OPERATIONAL_BU_CODE__C='30',
                OPERATIONAL_BU__C='OPERATIONAL_BU__C',PLATFORM_CATEGORY__C='SAAS',PLATFORM__C='5');
            insert PM;
            QPR = new Quote_Product_Report__c(CURRENCYISOCODE='USD',BUS_TRANSACTION_TYPE__C='New Product',
                LIC_SUB_OFF_LIST__C=50,LICENSE_TYPE__C='Duration Based Subscription',MAINFRAME_DISTRIBUTED__C='Distributed',
                PROPOSED_LIC_SUB_FEE__C=4866.66,TOTAL_PROPOSED_PRICE__C=4866.66,TOTAL_QUANTITY__C=5,
                AUTH_USE_MODEL__C='Duration Based Subscription',BUSINESS_UNIT__C='NIMSOFT',LICENSE_METRIC__C='Basic Monitor',
                LIST_LICENSE_SUBS_FEE__C=9733.32,NEW_ADDITIONAL_QUANTITY__C=5,Sterling_Quote__c=SQ.Id,
                PRODUCT_MATERIAL__C=PM.Id,CA_PRICING_GROUP__C='SAAS',QUICK_QUOTE__C=True,EAI_PRODUCT_MATERIAL__C='NCUEBM990');
            insert QPR;
            
            
            
      
        SQ.Approver1__c = u.Id;
        SQ.Approver2__c = u.Id;
        SQ.Approver3__c = u.Id;
        SQ.Approver4__c = u.Id;
        SQ.Approver5__c = u.Id;
        SQ.Approver6__c = u.Id;
        SQ.Approver7__c = u.Id;
        SQ.Approver8__c = u.Id;
        SQ.Approver9__c = u.Id;
        SQ.Approver10__c = u.Id;
        SQ.CA_CPQ_Quote_Status__c = 'Request Approval';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        update SQ;
        ApprovalByPass.updateStatus(SQ.Id);
        System.debug('++++++SQ.Approver1__c+++++'+SQ.Approver1__c);
        System.debug('++++++SQ.CA_CPQ_Quote_Status__c++++++++'+SQ.CA_CPQ_Quote_Status__c);
        
        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setObjectId(SQ.Id); 
        submitRequest.setNextApproverIds(new Id[] {UserInfo.getUserId()}); 
        SystemIdUtility.skipSterlingQuoteProcessor = true;      
        Approval.ProcessResult result = Approval.process(submitRequest);
        ApprovalByPass.updateStatus(SQ.Id);
        
        
        
        
       
        SterlingQuotePendingApprovers SQPA = new SterlingQuotePendingApprovers();
        String schedule = '0 0 23 * * ?';
        try{
            system.schedule('Nightly Update', schedule, SQPA);
        }catch(Exception e){
        }
        test.stopTest();
        
     // }
        
         
    }
}