@isTest
public class CA_QuoteProductLineItemTriggerHandlerTst {
    public static testMethod void QuoteProductLineItemTriggerHandler(){
        
        testOpportunityTriggersClass.createNewOpportunity();
        ddrRuleRecordTestClass.insertDdrRule();
        
        Opportunity opp = [select id from opportunity limit 1]; 

        
    
        scpq__SciQuote__c  SQ;
        scpq__SciQuote__c  SQ1;
        Quote_Product_Report__c QPR;
        Quote_Product_Report__c QPR1;
        Product_Material__c PM;
        Product_Material__c PM1;
        test.startTest();
        SQ = new scpq__SciQuote__c (NAME='Test',CURRENCYISOCODE='USD',SCPQ__OPPORTUNITYID__C=opp.Id,
                CA_CPQ_Quote_Number__c='Y100199999',SCPQ__ORDERHEADERKEY__C='22222',scpq__SciLastModifiedDate__c=system.today(),CA_CPQ_QUOTE_STATUS__C='Draft',
                CA_CPQ_QUOTE_TOTAL__C=4866.66,CA_ADJUSTED_ELIGIBLE_NCV__C=4866.66,CA_BILL_TO_ID__C='48656',
                CA_BILL_TO_NAME__C='NIKE INC',CA_BILLING_CONTACT_NAME__C='Lee Anderson',CA_BOOKING_COUNTRY__C='US',
                CA_CONTRACTED_RENEWAL__C='No',CA_CUSTOMER_NAME_SOLD_TO__C='NIKE INC',CA_DEAL_FINANCED__C='no',
                CA_DIRECT_INDIRECT__C='Direct',CA_GSA_PRICING_FLAG__C=True,CA_NEW_TRR__C=2430,CA_QUOTE_TYPE__C='New Product',
                CA_SALES_AREA__C='West',CA_TOTAL_LIC_SUB_OFF_LIST__C=50,CA_TOTAL_LIST_LICENSE_SUBS_FEE__C=9733.32,
                CA_TOTAL_PROPOSED_LIC_SUB_FEE__C=4866.66,CA_CPQ_PRODUCT_TOTAL__C=4866.66,CA_PAYMENT_SCHEDULE__C='Quarterly',
                CA_USING_QUICK_CONTRACT__C=True,NET_PAYMENT_TERMS__C='Net 30',SUBSCRIPTION_PAYMENT__C=4866.66);
            insert SQ;
       
        SQ1 = new scpq__SciQuote__c (NAME='Test1',CURRENCYISOCODE='USD',SCPQ__OPPORTUNITYID__C=opp.Id,
                CA_CPQ_Quote_Number__c='Y100199100',SCPQ__ORDERHEADERKEY__C='33333',scpq__SciLastModifiedDate__c=system.today(),CA_CPQ_QUOTE_STATUS__C='Draft',
                CA_CPQ_QUOTE_TOTAL__C=4866.66,CA_ADJUSTED_ELIGIBLE_NCV__C=4866.66,CA_BILL_TO_ID__C='48656',
                CA_BILL_TO_NAME__C='NIKE INC',CA_BILLING_CONTACT_NAME__C='Lee Anderson',CA_BOOKING_COUNTRY__C='US',
                CA_CONTRACTED_RENEWAL__C='No',CA_CUSTOMER_NAME_SOLD_TO__C='NIKE INC',CA_DEAL_FINANCED__C='no',
                CA_DIRECT_INDIRECT__C='Direct',CA_GSA_PRICING_FLAG__C=True,CA_NEW_TRR__C=2430,CA_QUOTE_TYPE__C='New Product',
                CA_SALES_AREA__C='West',CA_TOTAL_LIC_SUB_OFF_LIST__C=50,CA_TOTAL_LIST_LICENSE_SUBS_FEE__C=9733.32,
                CA_TOTAL_PROPOSED_LIC_SUB_FEE__C=4866.66,CA_CPQ_PRODUCT_TOTAL__C=4866.66,CA_PAYMENT_SCHEDULE__C='Quarterly',
                CA_USING_QUICK_CONTRACT__C=True,NET_PAYMENT_TERMS__C='Net 30',SUBSCRIPTION_PAYMENT__C=4866.66);
            insert SQ1;
        

            Schema.DescribeSObjectResult apttusresult = Schema.SObjectType.Apttus__APTS_Agreement__c;        
            Map<String,Schema.RecordTypeInfo> apttusRecType = apttusresult.getRecordTypeInfosByName(); 
        system.debug('----'+apttusRecType);
        Id agrRec = apttusRecType.get('Transaction').getRecordTypeId();


         
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.Apttus__Contract_End_Date__c=System.today() +30;
        agr1.Apttus__Perpetual__c=false;
        agr1.RecordTypeId = agrRec;
        agr1.CA_Opportunity__c = opp.id;
        agr1.Sterling_Quote__c = SQ.id;
        agr1.CA_Additional_Quote_Numbers__c=SQ1.CA_CPQ_Quote_Number__c;
        agr1.CA_Sales_Type__c = 'Direct';
        agr1.CA_Geo__c = 'NA';
        agr1.CA_Operating_Area__c = 'Public Sector/Canada';
        agr1.CA_Sales_Region__c = 'PS_CANADA';
        agr1.CA_Classified_Contract__c = 'Yes';
        agr1.CA_Language__c = 'English';
        //agr1.CA_Additional_Quote_Numbers__c = ;     
            
        
                    
       insert agr1;
        
        
                PM = new Product_Material__c(Name='NCUEBM990',CURRENCYISOCODE='USD',EXPIRED__C=false,
                MATERIAL_TEXT__C='NIMSOFT CLD EX MIN BSC MTR',OPERATIONAL_BU_CODE__C='30',
                OPERATIONAL_BU__C='OPERATIONAL_BU__C',PLATFORM_CATEGORY__C='SAAS',PLATFORM__C='5');
            insert PM;
        
        QPR = new Quote_Product_Report__c(CURRENCYISOCODE='USD',BUS_TRANSACTION_TYPE__C='New Product',
                LICENSE_TYPE__C='Duration Based Subscription',MAINFRAME_DISTRIBUTED__C='Distributed',
                PROPOSED_LIC_SUB_FEE__C=4866.66,TOTAL_PROPOSED_PRICE__C=4866.66,TOTAL_QUANTITY__C=5,
                AUTH_USE_MODEL__C='Duration Based Subscription',BUSINESS_UNIT__C='NIMSOFT',LICENSE_METRIC__C='Basic Monitor',
                LIST_LICENSE_SUBS_FEE__C=9733.32,NEW_ADDITIONAL_QUANTITY__C=5,Sterling_Quote__c=SQ.Id,
                PRODUCT_MATERIAL__C=PM.Id,CA_PRICING_GROUP__C='SAAS',QUICK_QUOTE__C=True,EAI_PRODUCT_MATERIAL__C='NCUEBM990',
                Target_Disc_Percent__c='10',Sales_Mgmt_Approval_Percent__c='30',Floor_Disc_Percent__c='70',Lic_Sub_off_List__c=0.8,
                Operating_System__c='MULTI-PLATFORM')    ;
        insert QPR;
        QPR1=new Quote_Product_Report__c(CURRENCYISOCODE='USD',BUS_TRANSACTION_TYPE__C='New Product',
                LICENSE_TYPE__C='Duration Based Subscription',MAINFRAME_DISTRIBUTED__C='Distributed',
                PROPOSED_LIC_SUB_FEE__C=4866.66,TOTAL_PROPOSED_PRICE__C=4866.66,TOTAL_QUANTITY__C=5,
                AUTH_USE_MODEL__C='Duration Based Subscription',BUSINESS_UNIT__C='NIMSOFT',LICENSE_METRIC__C='Basic Monitor',
                LIST_LICENSE_SUBS_FEE__C=9733.32,NEW_ADDITIONAL_QUANTITY__C=5,Sterling_Quote__c=SQ1.Id,
                PRODUCT_MATERIAL__C=PM.Id,CA_PRICING_GROUP__C='SAAS',QUICK_QUOTE__C=True,EAI_PRODUCT_MATERIAL__C='NCUEBM990',
                Target_Disc_Percent__c='10',Sales_Mgmt_Approval_Percent__c='30',Floor_Disc_Percent__c='70',Lic_Sub_off_List__c=0.8
                )    ;
       insert QPR1;
        test.stopTest();
        
    }
}