@isTest //(SeeAllData=true)
private class QuoteOrderFormMainPageCtrllrTest {

    static Account testAccnt = new Account();
    static Opportunity testOppty=new Opportunity();
    static scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
    static scpq__SciQuote__c  RenewalQuote=new scpq__SciQuote__c();
    static Quote_Product_Report__c QPR=new Quote_Product_Report__c();
    static PaymentPlan__c payplan=new PaymentPlan__c();
    static Quote_Product_Report__c subscriptionQPR=new Quote_Product_Report__c();
    static Quote_Product_Report__c perpetualQPR=new Quote_Product_Report__c();
    static scpq__SciQuote__c QuoteRec=new scpq__SciQuote__c();
    static scpq__SciQuote__c renewalQuoteRec=new scpq__SciQuote__c();
    static Quote_Product_Report__c RenewalQPRPerpetual=new Quote_Product_Report__c();
    static Quote_Product_Report__c RenewalQPRSubs=new Quote_Product_Report__c();
    static Quote_Product_Report__c CASWqpr=new Quote_Product_Report__c();
    static List<Quote_Product_Report__c> qprlist = new List<Quote_Product_Report__c>();
    static PaymentPlan__c RenewalpaymentRec=new PaymentPlan__c();

    

    static void createTestOpportunity() {
        testOpportunityTriggersClass.createNewOpportunity();
    }

    static void createTestSterlingQuote() {
        //scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
        testOppty = [select id from Opportunity limit 1];
        system.assertNotEquals(null, testOppty.id, 'Opportunity not inserted');
        sterlingQuote.scpq__OpportunityId__c=testOppty.Id;
        sterlingQuote.Name='Sterlingquote1';
        sterlingQuote.Ramp_Bridge_Order__c=false;
        sterlingQuote.CA_CPQ_Quote_Number__c = 'testquote';
        sterlingQuote.Is_this_an_Agile_Central_Transaction__c='Light';
        sterlingQuote.scpq__Status__c='Approved';
        sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch';
        sterlingQuote.Sold_To_Address__c='fffff';
        sterlingQuote.CA_CPQ_Quote_Total__c=5000;     
        sterlingQuote.CA_Sold_To_ID__c='344234';
        sterlingQuote.CA_Customer_Name_Sold_To__c='adasda';
        sterlingQuote.CA_Technical_Contact_Name__c='Test tech contact name';
        sterlingQuote.CA_Bill_To_ID__c='56757';
        sterlingQuote.CA_Bill_To_Name__c='xxxx';
        sterlingQuote.CA_Billing_Contact_Name__c='qqq';
        sterlingQuote.CA_Ship_To_ID__c='22';
        sterlingQuote.CA_Ship_To_Name__c='rrrr';
        sterlingQuote.CA_Shipping_Contact_Name__c='wwww';
        sterlingQuote.CA_Service_Provider_ID__c='eeeeeee';
        sterlingQuote.CA_Service_Provider_Name__c='hhhhh';
        sterlingQuote.CA_End_User_Contact_Name__c='iiiii';
        sterlingQuote.CA_End_User_ID__c='oooo';
        sterlingQuote.CA_End_User_Name__c='nnnnn';
        sterlingQuote.CA_Direct_Indirect__c='direct';
        sterlingQuote.CA_Sales_Area__c='vvvvv';
        sterlingQuote.CurrencyIsoCode='USD';
        sterlingQuote.CA_Services_Included__c='ttttttt';
        sterlingQuote.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        sterlingQuote.CA_Total_Old_TRR__c=6666666;
        sterlingQuote.CA_Revenue_Per_Day_Percentage__c=98;
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        sterlingQuote.CA_Contracted_Renewal__c='444';
        sterlingQuote.CA_Purchase_Order_Number__c='5555';
        sterlingQuote.CA_Effective_Date__c=System.today();
        sterlingQuote.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote.scpq__OrderHeaderKey__c='cccc333333'; 
        sterlingQuote.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.Ship_To_Address__c='dddd';
        sterlingQuote.Sold_To_Address__c='dddd,CN';
        sterlingQuote.Bill_To_Address__c='dddd';
        sterlingQuote.Services_Payment__c=666;
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert sterlingQuote;
    }

    static void createTestQPR() {
        //Quote_Product_Report__c QPR=new Quote_Product_Report__c();
        QPR.Name='Test QPR';
        QPR.Bus_Transaction_Type__c='Services/Education';
        QPR.CurrencyIsoCode='USD';
        QPR.Effective_Date__c=System.Today();
        QPR.End_Date__c=System.Today()+100;
        QPR.Sterling_Quote__c=sterlingQuote.Id; 
        QPR.Product_Name__c='Test QPR';
        QPR.Operating_System__c='Linux';
        QPR.License_Metric__c='2354325';
        QPR.ESD__c=true;
        QPR.GA__c=true;
        QPR.Royalty_Product__c=false;        
        QPR.Upfront_capable__c=true;
        QPR.GSA__c=true;
        QPR.No_Charge_Product__c='No';
        QPR.Reason_for_no_charge__c='abc';
        QPR.Old_Auth_Use_Model__c='xxxxx';
        QPR.Auth_Use_Model__c='zzzzzzzzzzz';     
        QPR.License_Type__c='Subscription';
        QPR.Business_Unit__c='Services/Education';
        QPR.Mainframe_Distributed__c='Mainframe';
        QPR.Existing_Quantity__c=1200;
        QPR.New_Additional_Quantity__c=1200;
        QPR.Total_Quantity__c=2400; 
        QPR.Old_SAP_Contract_Number__c='12fg88';
        QPR.Old_SAP_Contract_Line_Number__c=55555;
        QPR.Per_Unit_List_Price__c=5600;
        QPR.List_License_Subs_Fee__c=4000;
        QPR.Contracted_Maintenance_Price__c=10000;
        QPR.AutoCalc_Stated_Renewal__c='yes';        
        QPR.Shipping_Required__c='yes';
        QPR.Proposed_Lic_Sub_Fee__c=10000;
        QPR.Proposed_Maint_Fee__c=10000;
        QPR.Monthy_Production_fee__c=10000;
        QPR.Variables__c='eeeee'; 
        qprlist.add(QPR);
    }

    static void createTestSubscriptionQPR() {
        //Quote_Product_Report__c subscriptionQPR=new Quote_Product_Report__c();
        subscriptionQPR.Name='Test SubscriptionQPR';
        subscriptionQPR.Bus_Transaction_Type__c='Services/Education';
        SubscriptionQPR.CurrencyIsoCode='USD';
        SubscriptionQPR.Effective_Date__c=System.Today();
        SubscriptionQPR.End_Date__c=System.Today()+100;
        SubscriptionQPR.Sterling_Quote__c=sterlingQuote.Id; 
        SubscriptionQPR.Product_Name__c='Test SubscriptionQPR';
        SubscriptionQPR.Operating_System__c='Linux';
        SubscriptionQPR.License_Metric__c='2354325';
        SubscriptionQPR.ESD__c=true;
        SubscriptionQPR.GA__c=true;
        SubscriptionQPR.Royalty_Product__c=false;        
        SubscriptionQPR.Upfront_capable__c=true;
        SubscriptionQPR.GSA__c=true;
        SubscriptionQPR.No_Charge_Product__c='No';
        SubscriptionQPR.Reason_for_no_charge__c='abc';
        SubscriptionQPR.Old_Auth_Use_Model__c='xxxxx';
        SubscriptionQPR.Auth_Use_Model__c='zzzzzzzzzzz';     
        SubscriptionQPR.License_Type__c='Subscription';
        SubscriptionQPR.Business_Unit__c='Services/Education';
        SubscriptionQPR.Mainframe_Distributed__c='Mainframe';
        SubscriptionQPR.Existing_Quantity__c=1200;
        SubscriptionQPR.New_Additional_Quantity__c=1200;
        SubscriptionQPR.Total_Quantity__c=2400; 
        SubscriptionQPR.Old_SAP_Contract_Number__c='12fg88';
        SubscriptionQPR.Old_SAP_Contract_Line_Number__c=55555;
        SubscriptionQPR.Per_Unit_List_Price__c=5600;
        SubscriptionQPR.List_License_Subs_Fee__c=4000;
        SubscriptionQPR.Contracted_Maintenance_Price__c=10000;
        SubscriptionQPR.AutoCalc_Stated_Renewal__c='yes';        
        SubscriptionQPR.Shipping_Required__c='yes';
        SubscriptionQPR.Proposed_Lic_Sub_Fee__c=10000;
        SubscriptionQPR.Proposed_Maint_Fee__c=10000;
        SubscriptionQPR.Monthy_Production_fee__c=10000;
        SubscriptionQPR.Variables__c='eeeee';
        qprlist.add(SubscriptionQPR);
    }

    static void createTestRenewalQuote() {
        RenewalQuote.scpq__OpportunityId__c=testOppty.Id;
        RenewalQuote.Name='RenewalQuote1';
        //RenewalQuote.scpq__Status__c='Approved';
        RenewalQuote.CA_Quote_Type__c='Renewal';        
        RenewalQuote.Sold_To_Address__c='fffff';
        RenewalQuote.CA_CPQ_Quote_Total__c=5000;     
        RenewalQuote.CA_Sold_To_ID__c='344234';
        RenewalQuote.CA_Customer_Name_Sold_To__c='adasda';
        RenewalQuote.CA_Technical_Contact_Name__c='Test tech contact name';
        RenewalQuote.CA_Bill_To_ID__c='56757';
        RenewalQuote.CA_Bill_To_Name__c='xxxx';
        RenewalQuote.CA_Billing_Contact_Name__c='qqq';
        RenewalQuote.CA_Ship_To_ID__c='22';
        RenewalQuote.CA_Ship_To_Name__c='rrrr';
        RenewalQuote.CA_Shipping_Contact_Name__c='wwww';
        RenewalQuote.CA_Service_Provider_ID__c='eeeeeee';
        RenewalQuote.CA_Service_Provider_Name__c='hhhhh';
        RenewalQuote.CA_End_User_Contact_Name__c='iiiii';
        RenewalQuote.CA_End_User_ID__c='oooo';
        RenewalQuote.CA_End_User_Name__c='nnnnn';
        RenewalQuote.CA_Direct_Indirect__c='direct';
        RenewalQuote.CA_Sales_Area__c='vvvvv';
        RenewalQuote.CurrencyIsoCode='USD';
        RenewalQuote.CA_Services_Included__c='ttttttt';
        RenewalQuote.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        RenewalQuote.CA_Total_Old_TRR__c=6666666;
        RenewalQuote.CA_Revenue_Per_Day_Percentage__c=98;       
        RenewalQuote.CA_Contracted_Renewal__c='444';
        RenewalQuote.CA_Purchase_Order_Number__c='5555';
        RenewalQuote.CA_Effective_Date__c=System.today();
        RenewalQuote.CA_Contract_End_Date__c=System.today()+120;
        RenewalQuote.scpq__OrderHeaderKey__c='ciiirrrr33'; 
        RenewalQuote.scpq__SciLastModifiedDate__c=System.Today();
        RenewalQuote.Ship_To_Address__c='dddd';
        RenewalQuote.Sold_To_Address__c='dddd,CN';
        RenewalQuote.Bill_To_Address__c='dddd';
        RenewalQuote.Services_Payment__c=666;
        RenewalQuote.Technical_Contact_Email_Address__c='test@test.com';
        RenewalQuote.Technical_Contact_Phone__c='9999977777';
        RenewalQuote.Bill_To_Phone__c='9999977777';
        RenewalQuote.Bill_To_Email_Address__c='test@test.com';        
        RenewalQuote.Order_Form__c='66666';
        RenewalQuote.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        insert RenewalQuote;
    }

    static void createTestRenewalQPRSubs() {
        RenewalQPRSubs.Name='Test RenewalQPRSubs';
        RenewalQPRSubs.Bus_Transaction_Type__c='Services/Education';
        RenewalQPRSubs.CurrencyIsoCode='USD';
        RenewalQPRSubs.Effective_Date__c=System.Today();
        RenewalQPRSubs.End_Date__c=System.Today()+100;
        RenewalQPRSubs.Sterling_Quote__c=RenewalQuote.Id; 
        RenewalQPRSubs.Product_Name__c='Test RenewalQPRSubs';
        RenewalQPRSubs.Operating_System__c='Linux';
        RenewalQPRSubs.License_Metric__c='2354325';
        RenewalQPRSubs.ESD__c=true;
        RenewalQPRSubs.GA__c=true;
        RenewalQPRSubs.Royalty_Product__c=false;        
        RenewalQPRSubs.Upfront_capable__c=true;
        RenewalQPRSubs.GSA__c=true;
        RenewalQPRSubs.No_Charge_Product__c='No';
        RenewalQPRSubs.Reason_for_no_charge__c='abc';
        RenewalQPRSubs.Old_Auth_Use_Model__c='xxxxx';
        RenewalQPRSubs.Auth_Use_Model__c='zzzzzzzzzzz';     
        RenewalQPRSubs.License_Type__c='Subscription';
        RenewalQPRSubs.Business_Unit__c='Services/Education';
        RenewalQPRSubs.Mainframe_Distributed__c='Mainframe';
        RenewalQPRSubs.Existing_Quantity__c=1200;
        RenewalQPRSubs.New_Additional_Quantity__c=1200;
        RenewalQPRSubs.Total_Quantity__c=2400; 
        RenewalQPRSubs.Old_SAP_Contract_Number__c='12fg88';
        RenewalQPRSubs.Old_SAP_Contract_Line_Number__c=55555;
        RenewalQPRSubs.Per_Unit_List_Price__c=5600;
        RenewalQPRSubs.List_License_Subs_Fee__c=4000;
        RenewalQPRSubs.Contracted_Maintenance_Price__c=10000;
        RenewalQPRSubs.AutoCalc_Stated_Renewal__c='yes';        
        RenewalQPRSubs.Shipping_Required__c='yes';
        RenewalQPRSubs.Proposed_Lic_Sub_Fee__c=10000;
        RenewalQPRSubs.Proposed_Maint_Fee__c=10000;
        RenewalQPRSubs.Monthy_Production_fee__c=10000;
        RenewalQPRSubs.Variables__c='eeeee';
        qprlist.add(RenewalQPRSubs);
    }

    static void createTestRenewalQPRPerpetual() {
        RenewalQPRPerpetual.Name='Test RenewalQPRPerpetual';
        RenewalQPRPerpetual.Bus_Transaction_Type__c='Services/Education';
        RenewalQPRPerpetual.CurrencyIsoCode='USD';
        RenewalQPRPerpetual.Effective_Date__c=System.Today();
        RenewalQPRPerpetual.End_Date__c=System.Today()+100;
        RenewalQPRPerpetual.Sterling_Quote__c=RenewalQuote.Id; 
        RenewalQPRPerpetual.Product_Name__c='Test RenewalQPRPerpetual';
        RenewalQPRPerpetual.Operating_System__c='Linux';
        RenewalQPRPerpetual.License_Metric__c='2354325';
        RenewalQPRPerpetual.ESD__c=true;
        RenewalQPRPerpetual.GA__c=true;
        RenewalQPRPerpetual.Royalty_Product__c=false;        
        RenewalQPRPerpetual.Upfront_capable__c=true;
        RenewalQPRPerpetual.GSA__c=true;
        RenewalQPRPerpetual.No_Charge_Product__c='No';
        RenewalQPRPerpetual.Reason_for_no_charge__c='abc';
        RenewalQPRPerpetual.Old_Auth_Use_Model__c='xxxxx';
        RenewalQPRPerpetual.Auth_Use_Model__c='zzzzzzzzzzz';     
        RenewalQPRPerpetual.License_Type__c='Perpetual';
        RenewalQPRPerpetual.Business_Unit__c='Services/Education';
        RenewalQPRPerpetual.Mainframe_Distributed__c='Mainframe';
        RenewalQPRPerpetual.Existing_Quantity__c=1200;
        RenewalQPRPerpetual.New_Additional_Quantity__c=1200;
        RenewalQPRPerpetual.Total_Quantity__c=2400; 
        RenewalQPRPerpetual.Old_SAP_Contract_Number__c='12fg88';
        RenewalQPRPerpetual.Old_SAP_Contract_Line_Number__c=55555;
        RenewalQPRPerpetual.Per_Unit_List_Price__c=5600;
        RenewalQPRPerpetual.List_License_Subs_Fee__c=4000;
        RenewalQPRPerpetual.Contracted_Maintenance_Price__c=10000;
        RenewalQPRPerpetual.AutoCalc_Stated_Renewal__c='yes';        
        RenewalQPRPerpetual.Shipping_Required__c='yes';
        RenewalQPRPerpetual.Proposed_Lic_Sub_Fee__c=10000;
        RenewalQPRPerpetual.Proposed_Maint_Fee__c=10000;
        RenewalQPRPerpetual.Monthy_Production_fee__c=10000;
        RenewalQPRPerpetual.Variables__c='eeeee';             
        qprlist.add(RenewalQPRPerpetual);
    }

    static void createTestPayPlan() {
        payplan.name='Payment plan 2013';
        payplan.Committed_Payment__c=20000;
        payplan.Payment_Date__c=System.today()+75;
        payplan.License_Payment__c=3500;
        payplan.Maintenance_Payment__c=3500;
        payplan.Payment_Total__c=7000;
        payplan.Services_Payment__c=0;
        payplan.Sterling_Quote__c=sterlingQuote.Id;
        payplan.Subscription_Payment__c=0;
        payplan.CurrencyIsoCode='USD';      
        insert payplan;
    }

    static void createTestRenewalPaymentRecord() {
        RenewalpaymentRec.name='Payment plan 2013';
        RenewalpaymentRec.Committed_Payment__c=20000;
        RenewalpaymentRec.Payment_Date__c=System.today()+75;
        RenewalpaymentRec.License_Payment__c=3500;
        RenewalpaymentRec.Maintenance_Payment__c=3500;
        RenewalpaymentRec.Payment_Total__c=7000;
        RenewalpaymentRec.Services_Payment__c=0;
        RenewalpaymentRec.Sterling_Quote__c=RenewalQuote.Id;
        RenewalpaymentRec.Subscription_Payment__c=0;
        RenewalpaymentRec.CurrencyIsoCode='USD';      
        insert RenewalpaymentRec;
    }

    static void CreateTestdata() {
        user u1=new user(id='00530000003rQuJ');
        system.runAs(u1) {


            createTestOpportunity();
            createTestSterlingQuote();
            createTestQPR();
            createTestSubscriptionQPR();
            
            
            

            //Quote_Product_Report__c perpetualQPR=new Quote_Product_Report__c();
           /* perpetualQPR.Name='Test perpetualQPR';
            perpetualQPR.Bus_Transaction_Type__c='Services/Education';
            perpetualQPR.CurrencyIsoCode='USD';
            perpetualQPR.Effective_Date__c=System.Today();
            perpetualQPR.End_Date__c=System.Today()+100;
            perpetualQPR.Sterling_Quote__c=sterlingQuote.Id; 
            perpetualQPR.Product_Name__c='Test perpetualQPR';
            perpetualQPR.Operating_System__c='Linux';
            perpetualQPR.License_Metric__c='2354325';
            perpetualQPR.ESD__c=true;
            perpetualQPR.GA__c=true;
            perpetualQPR.Royalty_Product__c=false;        
            perpetualQPR.Upfront_capable__c=true;
            perpetualQPR.GSA__c=true;
            perpetualQPR.No_Charge_Product__c='No';
            perpetualQPR.Reason_for_no_charge__c='abc';
            perpetualQPR.Old_Auth_Use_Model__c='xxxxx';
            perpetualQPR.Auth_Use_Model__c='zzzzzzzzzzz';     
            perpetualQPR.License_Type__c='Perpetual';
            perpetualQPR.Business_Unit__c='Services/Education';
            perpetualQPR.Mainframe_Distributed__c='Mainframe';
            perpetualQPR.Existing_Quantity__c=1200;
            perpetualQPR.New_Additional_Quantity__c=1200;
            perpetualQPR.Total_Quantity__c=2400; 
            perpetualQPR.Old_SAP_Contract_Number__c='12fg88';
            perpetualQPR.Old_SAP_Contract_Line_Number__c=55555;
            perpetualQPR.Per_Unit_List_Price__c=5600;
            perpetualQPR.List_License_Subs_Fee__c=4000;
            perpetualQPR.Contracted_Maintenance_Price__c=10000;
            perpetualQPR.AutoCalc_Stated_Renewal__c='yes';        
            perpetualQPR.Shipping_Required__c='yes';
            perpetualQPR.Proposed_Lic_Sub_Fee__c=10000;
            perpetualQPR.Proposed_Maint_Fee__c=10000;
            perpetualQPR.Monthy_Production_fee__c=10000;
            perpetualQPR.Variables__c='eeeee';
            qprlist.add(perpetualQPR);
              
      

            CASWqpr.Name='Test perpetualQPR';
            CASWqpr.Bus_Transaction_Type__c='Time';
            CASWqpr.CurrencyIsoCode='USD';
            CASWqpr.Effective_Date__c=System.Today();
            CASWqpr.End_Date__c=System.Today()+100;
            CASWqpr.Sterling_Quote__c=sterlingQuote.Id; 
            CASWqpr.Product_Name__c='Test non perpetualQPR';
            CASWqpr.Operating_System__c='Linux';
            CASWqpr.License_Metric__c='2354325';
            CASWqpr.ESD__c=true;
            CASWqpr.GA__c=true;
            CASWqpr.Royalty_Product__c=false;        
            CASWqpr.Upfront_capable__c=true;
            CASWqpr.GSA__c=true;
            CASWqpr.No_Charge_Product__c='No';
            CASWqpr.Reason_for_no_charge__c='abc';
            CASWqpr.Old_Auth_Use_Model__c='xxxxx';
            CASWqpr.Auth_Use_Model__c='zzzzzzzzzzz';     
            //CASWqpr.License_Type__c='Perpetual';
            CASWqpr.Business_Unit__c='Time';
            CASWqpr.Mainframe_Distributed__c='Mainframe';
            CASWqpr.Existing_Quantity__c=1200;
            CASWqpr.New_Additional_Quantity__c=1200;
            CASWqpr.Total_Quantity__c=2400; 
            CASWqpr.Old_SAP_Contract_Number__c='12fg88';
            CASWqpr.Old_SAP_Contract_Line_Number__c=55555;
            CASWqpr.Per_Unit_List_Price__c=5600;
            CASWqpr.List_License_Subs_Fee__c=4000;
            CASWqpr.Contracted_Maintenance_Price__c=10000;
            CASWqpr.AutoCalc_Stated_Renewal__c='yes';        
            CASWqpr.Shipping_Required__c='yes';
            CASWqpr.Proposed_Lic_Sub_Fee__c=10000;
            CASWqpr.Proposed_Maint_Fee__c=10000;
            CASWqpr.Monthy_Production_fee__c=10000;
            CASWqpr.Variables__c='eeeee';
            qprlist.add(CASWqpr);
            */

            test.startTest();
            createTestPayPlan();
            
            createTestRenewalQuote();
            

            createTestRenewalQPRSubs();
            
            createTestRenewalQPRPerpetual();
            insert qprlist;
            
            createTestRenewalPaymentRecord();
            test.stopTest();
        }
    }


    static testMethod void quoteTemplatesTest() {


        CreateTestdata();

        PageReference pageRef1 = new pageReference('/apex/QuoteOrderFormMainPage?id='+sterlingQuote.Id+'&lic=Customer On-Premises Subscription License&lang=de&vernum=1&orderFormNo=wer123&territory=India');
        Test.setCurrentPageReference(pageRef1);
        QuoteOrderFormMainPageCtrllr myPageCon= new QuoteOrderFormMainPageCtrllr();
        myPageCon.notApproved=false;
        myPageCon.languageOption='en';
        myPageCon.LicenseNotSelected=false;
        myPageCon.getDisplayOptionsBlock();
        myPageCon.getLicenseType();
        myPageCon.setLicenseType('Customer On-Premises Subscription License');
        myPageCon.getLicenseTypes();
        myPageCon.getLanguageOptions();     
        myPageCon.getSterlingQuote();
        myPageCon.getCAEntityError();
        myPageCon.getLangCode();
        myPageCon.getVFPageName();
        myPageCon.getURLToTemplateDoc();
        myPageCon.PriliminaryCheck();  
        myPageCon.getCommissionableAreaErr();
        myPageCon.getCASWInfoBol();  
        myPageCon.getSrvcEduBol();
        myPageCon.getOrderFormNoBol();
        myPageCon.getTerritoryConuntryBol();
        myPageCon.RedirectToTemplate();
        myPageCon.getShowContactSection();
    }

    static testMethod void quoteTemplatesTest2() {


        CreateTestdata();


        PageReference pageRef2 = new pageReference('/apex/QuoteOrderFormMainPage?id='+sterlingQuote.Id+'&lic=Customer On-Premises Perpetual License&lang=de&vernum=1&orderFormNo=wer123&territory=India');
        Test.setCurrentPageReference(pageRef2);
        QuoteOrderFormMainPageCtrllr myPageCon2= new QuoteOrderFormMainPageCtrllr();
        myPageCon2.notApproved=false;
        myPageCon2.languageOption='en';
        myPageCon2.LicenseNotSelected=false;
        myPageCon2.getDisplayOptionsBlock();
        myPageCon2.getLicenseType();
        myPageCon2.setLicenseType('Customer On-Premises Perpetual License');
        myPageCon2.getLicenseTypes();
        myPageCon2.getLanguageOptions();     
        myPageCon2.getSterlingQuote();
        myPageCon2.getCAEntityError();
        myPageCon2.getLangCode();
        myPageCon2.getVFPageName();
        //myPageCon2.ApprovalCheck();
        myPageCon2.PriliminaryCheck();  
        myPageCon2.RedirectToTemplate();
    }

    static testMethod void quoteTemplatesTest3() {


        CreateTestdata();



        PageReference pageRef3 = new pageReference('/apex/QuoteOrderFormMainPage?id='+sterlingQuote.Id+'&lic=Customer On-Demand Subscription License&lang=de&vernum=1&orderFormNo=wer123&territory=India');
        Test.setCurrentPageReference(pageRef3);
        QuoteOrderFormMainPageCtrllr myPageCon3= new QuoteOrderFormMainPageCtrllr();
        myPageCon3.notApproved=false;
        myPageCon3.languageOption='en';
        myPageCon3.LicenseNotSelected=false;
        myPageCon3.getDisplayOptionsBlock();
        myPageCon3.getLicenseType();
        myPageCon3.setLicenseType('Customer On-Demand Subscription License');
        myPageCon3.getLicenseTypes();
        myPageCon3.getLanguageOptions();     
        myPageCon3.getSterlingQuote();
        myPageCon3.getCAEntityError();
        myPageCon3.getLangCode();
        myPageCon3.getVFPageName();
        // myPageCon3.ApprovalCheck();
        myPageCon3.PriliminaryCheck();  
        myPageCon3.RedirectToTemplate();
    }


    static testMethod void quoteTemplatesTest4() {


        CreateTestdata();


        PageReference pageRef4= new pageReference('/apex/QuoteOrderFormMainPage?id='+sterlingQuote.Id);
        Test.setCurrentPageReference(pageRef4);
        QuoteOrderFormMainPageCtrllr myPageCon4= new QuoteOrderFormMainPageCtrllr();
        myPageCon4.notApproved=false;
        myPageCon4.languageOption='en';
        myPageCon4.LicenseNotSelected=false;
        myPageCon4.getDisplayOptionsBlock();
        myPageCon4.getLicenseType();
        myPageCon4.setLicenseType('MSP On-Premises Subscription License');
        myPageCon4.getLicenseTypes();
        myPageCon4.getLanguageOptions();     
        myPageCon4.getSterlingQuote();
        myPageCon4.getCAEntityError();
        myPageCon4.getLangCode();
        myPageCon4.getVFPageName();
        // myPageCon4.ApprovalCheck();
        myPageCon4.PriliminaryCheck();  
        myPageCon4.RedirectToTemplate();
    }

    static testMethod void quoteTemplatesTest5() {


        CreateTestdata();



        PageReference pageRef5= new pageReference('/apex/QuoteOrderFormMainPage?id='+sterlingQuote.Id);
        Test.setCurrentPageReference(pageRef5);
        QuoteOrderFormMainPageCtrllr myPageCon5= new QuoteOrderFormMainPageCtrllr();
        myPageCon5.notApproved=false;
        myPageCon5.languageOption='en';
        myPageCon5.LicenseNotSelected=false;
        myPageCon5.getDisplayOptionsBlock();
        myPageCon5.getLicenseType();
        myPageCon5.setLicenseType('MSP On-Premises Perpetual License');
        myPageCon5.getLicenseTypes();
        myPageCon5.getLanguageOptions();     
        myPageCon5.getSterlingQuote();
        myPageCon5.getCAEntityError();
        myPageCon5.getLangCode();
        myPageCon5.getVFPageName();
        //myPageCon5.ApprovalCheck();
        myPageCon5.PriliminaryCheck();  
        myPageCon5.RedirectToTemplate();
    }


    static testMethod void quoteTemplatesTest6() {


        CreateTestdata();


        PageReference pageRef6= new pageReference('/apex/QuoteOrderFormMainPage?id='+sterlingQuote.Id);
        Test.setCurrentPageReference(pageRef6);
        QuoteOrderFormMainPageCtrllr myPageCon6= new QuoteOrderFormMainPageCtrllr();
        myPageCon6.notApproved=false;
        myPageCon6.languageOption='en';
        myPageCon6.LicenseNotSelected=false;
        myPageCon6.getDisplayOptionsBlock();
        myPageCon6.getLicenseType();
        myPageCon6.setLicenseType('MSP On-Demand Subscription License');
        myPageCon6.getLicenseTypes();
        myPageCon6.getLanguageOptions();     
        myPageCon6.getSterlingQuote();
        myPageCon6.getCAEntityError();
        myPageCon6.getLangCode();
        myPageCon6.getVFPageName();
        //myPageCon6.ApprovalCheck();
        myPageCon6.PriliminaryCheck();  
        myPageCon6.RedirectToTemplate();
    }

    static testMethod  void quoteTemplatesTest7() {


        CreateTestdata();


        PageReference pageRef7= new pageReference('/apex/QuoteOrderFormMainPage?id='+RenewalQuote.Id);
        Test.setCurrentPageReference(pageRef7);
        QuoteOrderFormMainPageCtrllr myPageCon7= new QuoteOrderFormMainPageCtrllr();                
        myPageCon7.notApproved=false;
        myPageCon7.languageOption='en';
        myPageCon7.LicenseNotSelected=false;
        myPageCon7.getDisplayOptionsBlock();
        myPageCon7.getLicenseType();
        myPageCon7.setLicenseType('CA Product Renewal');
        myPageCon7.getLicenseTypes();
        myPageCon7.getLanguageOptions();     
        myPageCon7.getSterlingQuote();
        myPageCon7.getCAEntityError();
        myPageCon7.getLangCode();
        myPageCon7.getVFPageName();
        //myPageCon7.ApprovalCheck();
        myPageCon7.PriliminaryCheck();  
        myPageCon7.RedirectToTemplate();

    }

    static testMethod void quoteTemplatesTest8() {


        CreateTestdata();



        PageReference pageRef8= new pageReference('/apex/QuoteOrderFormMainPage?id='+RenewalQuote.Id);
        Test.setCurrentPageReference(pageRef8);
        QuoteOrderFormMainPageCtrllr myPageCon8= new QuoteOrderFormMainPageCtrllr();
        myPageCon8.notApproved=false;
        myPageCon8.languageOption='en';
        myPageCon8.LicenseNotSelected=false;
        myPageCon8.getDisplayOptionsBlock();
        myPageCon8.getLicenseType();
        myPageCon8.setLicenseType('Maintenance Renewal on Nimsoft Perpetual License');
        myPageCon8.getLicenseTypes();
        myPageCon8.getLanguageOptions();     
        myPageCon8.getSterlingQuote();
        myPageCon8.getCAEntityError();
        myPageCon8.getLangCode();
        myPageCon8.getVFPageName();
        //myPageCon8.ApprovalCheck();
        myPageCon8.PriliminaryCheck();  
        myPageCon8.RedirectToTemplate();
    }

    static testMethod void quoteTemplatesTest9() {


        CreateTestdata();


        PageReference pageRef9= new pageReference('/apex/QuoteOrderFormMainPage?id='+RenewalQuote.Id);
        Test.setCurrentPageReference(pageRef9);
        QuoteOrderFormMainPageCtrllr myPageCon9= new QuoteOrderFormMainPageCtrllr();
        myPageCon9.notApproved=false;
        myPageCon9.languageOption='en';
        myPageCon9.LicenseNotSelected=false;
        myPageCon9.getDisplayOptionsBlock();
        myPageCon9.getLicenseType();
        myPageCon9.setLicenseType('Renewal of Nimsoft Subscription License');
        myPageCon9.getLicenseTypes();
        myPageCon9.getLanguageOptions();     
        myPageCon9.getSterlingQuote();
        myPageCon9.getCAEntityError();
        myPageCon9.getLangCode();
        myPageCon9.getVFPageName();
        //myPageCon9.ApprovalCheck();
        myPageCon9.PriliminaryCheck();  
        myPageCon9.RedirectToTemplate();

        myPageCon9.getShowTax();
        myPageCon9.getshippingMethods();
        myPageCon9.gethasEligibleSKU();
        myPageCon9.getVariablesQuotePdctLnItemList();
        myPageCon9.getShipQuotePdctLnItemList();

    } 

    
}