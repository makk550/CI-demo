@isTest(seeAllData=true)
public class AutoCreateDDR_Test{
    Static Account testAccnt = new Account();
    Static Opportunity testOppty=new Opportunity();
    Static Opportunity testOppty1=new Opportunity();
    Static Opportunity testOppty2=new Opportunity();
    Static scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
    Static scpq__SciQuote__c  sterlingQuote1=new scpq__SciQuote__c();
    Static scpq__SciQuote__c  sterlingQuote3=new scpq__SciQuote__c();
    Static scpq__SciQuote__c  RenewalQuote=new scpq__SciQuote__c();
    Static scpq__SciQuote__c  RenewalQuote1=new scpq__SciQuote__c();
    Static scpq__SciQuote__c  RenewalQuote2=new scpq__SciQuote__c();
    Static Quote_Product_Report__c QPR=new Quote_Product_Report__c();
    Static PaymentPlan__c payplan=new PaymentPlan__c();
    Static Quote_Product_Report__c subscriptionQPR=new Quote_Product_Report__c();
    Static Quote_Product_Report__c perpetualQPR=new Quote_Product_Report__c();
    Static scpq__SciQuote__c QuoteRec=new scpq__SciQuote__c();
    Static scpq__SciQuote__c renewalQuoteRec=new scpq__SciQuote__c();
    Static Quote_Product_Report__c RenewalQPRPerpetual=new Quote_Product_Report__c();
    Static Quote_Product_Report__c RenewalQPRSubs=new Quote_Product_Report__c();
    Static Quote_Product_Report__c CASWqpr=new Quote_Product_Report__c();
    static DDR_Rules__c ddrRec=new DDR_Rules__c();

    Static PaymentPlan__c RenewalpaymentRec=new PaymentPlan__c();
 @isTest
 public static void autoCreateDDrTest(){
      DDR_Rules__c ddrRules = [SELECT New_Product_Using_Quick_Contract_Rule__c,Agile_RenewalPricing_Group_and_Term_Rule__c,Renewal_Pricing_Group__c,
                                    New_Product_Account_Segment_Rule__c, New_Product_Account_Segment__c,RenewalGroup_Term_in_months_is_less_than__c,
                                    New_Product_CPQ_Quote_Type_Rule__c, New_Product_CPQ_Quote_Type__c,
                                    New_Product_LA_Quote_Total_Rule__c, New_Product_Max_Quote_Total_For_LA__c,
                                    New_Product_EMEA_Quote_Total_Rule__c, New_Product_Max_Quote_Total_For_EMEA__c,
                                    New_Product_Max_Quote_Total_For_PSCAN__c,PSCAN_Quote_Total_per_annum_is_greater_t__c,
                                    Renewal2_Max_Quote_Total_Annum_For_PSCAN__c,Renewal3_Max_Quote_Total_Annum_For_PSCAN__c,
                                    Renewal_Max_Quote_Total_Annum_For_PSCAN__c,Renewal2_PSCAN_Quote_Total_Annum_Rule__c,
                                    Renewal3_PSCAN_Qcuote_Total_Annum_Rule__c,Renewal_PSCAN_Quote_Total_Annum_Rule__c,
                                    PSCAN_Quote_Total_Rule__c,PSCAN_Renewal_Quote_Total_Per_Annum_Rule__c,
                                    New_Product_NA_Quote_Total_Rule__c, New_Product_Max_Quote_Total_For_NA__c,
                               		Renewal_Product_Swap_Rule__c,
                             		NewProduct_Product_Swap_Rule__c,
                                    New_Product_Pricing_Group_Term_Rule__c, New_Product_Pricing_Group__c, New_Product_Pricing_Group_Term__c,
                                    New_Product_Term_Rule__c, New_Product_Maximum_Contract_Term__c,
                                    New_Product_Net_Payment_Term_Rule__c, New_Product_Net_Payment_Terms__c,
                                    New_Product_Payment_Schedule_Rule__c, New_Product_Payment_Schedule__c,
                                    New_Product_LT_Combo_Rule_1__c, New_Product_LT1_for_LT_Combo_1__c, New_Product_LT2_for_LT_Combo_1__c, New_Product_BTT_for_LT_Combo_1__c,
                                    New_Product_LT_Combo_Rule_2__c, New_Product_LT1_for_LT_Combo_2__c, New_Product_LT2_for_LT_Combo_2__c, New_Product_BTT_for_LT_Combo_2__c,
                                    New_Product_LT_Combo_Rule_3__c, New_Product_LT1_for_LT_Combo_3__c, New_Product_LT2_for_LT_Combo_3__c, New_Product_BTT_for_LT_Combo_3__c,
                                    New_Product_BTT_for_LT_Combo_4__c,New_Product_LT1_for_LT_Combo_4__c,New_Product_LT2_for_LT_Combo_4__c,New_Product_LT_Combo_Rule_4__c,
                                    New_Product_PS_and_LT_Rule__c, New_Product_PS_for_PS_and_LT__c, New_Product_LT_for_PS_and_LT__c, New_Product_BTT_for_PS_and_LT__c,
                                    New_Product_PS_and_LT_2_Rule__c, New_Product_PS_for_PS_and_LT_2__c, New_Product_LT_for_PS_and_LT_2__c, New_Product_BTT_for_PS_and_LT_2__c,
                                    New_Product_Quick_Quote_Line_Item_Rule__c,EMEA_Agile_Quote_Rule__c,
                                    New_Product_Auto_Calc_State_Renewal_Rule__c, New_Product_ACSR_LT_Exceptions__c, New_Product_ACSR_BTT_Exceptions__c,
                                    NA1_Quote_Total_Per_Annum_Rule__c,NA_Quote_Total_per_annum_is_greater_than__c,
                                    Agile_NP_Pricing_Group_Term_Rule__c,PGroup_Term_in_months_is_less_than__c,Agile_NP__c,AgileNP__c,
                                    AgileContract_Term_Rule__c,AgileContract_Term_In_Years_greater_than__c,
                                    Agile_New_product_term_12__c,Agile_New_product_term_24__c,Agile_New_product_term_36__c,
                                    Agile_Payment_Schedule_Rule__c,Agile1_Payment_Schedule_is__c,Agile_Payment_Schedule_is__c,
                                    New_Product_Auth_Use_Model_Rule__c, New_Product_Auth_Use_Model__c,
                                    Agile_Renewal_TERM_12__c,Agile_Renewal_TERM_24__c,Agile_Renewal_Term_36__c,
                                    Renewal_Using_Quick_Contract_Rule__c,LA_Agile_Quote_Rules__c,APJ_Agile_Quote_Rule__c,
                                    Renewal_LA_Quote_Total_Annum_Rule__c, Renewal_Max_Quote_Total_Annum_For_LA__c,
                                    Renewal_EMEA_Quote_Total_Annum_Rule__c, Renewal_Max_Quote_Total_Annum_For_EMEA__c,
                                    Renewal_NA_Quote_Total_Annum_Rule__c, Renewal_Max_Quote_Total_Annum_For_NA__c,
                                    Renewal_Term_Rule__c, Renewal_Maximum_Contract_Term__c,
                                    Renewal_Net_Payment_Term_Rule__c, Renewal_Net_Payment_Terms__c,
                                    Renewal_Business_Transaction_Type_Rule__c, Renewal_Business_Transaction_Type__c,
                                    Renewal2_Using_Quick_Contract_Rule__c,
                                    Renewal2_LA_Quote_Total_Annum_Rule__c, Renewal2_Max_Quote_Total_Annum_For_LA__c,
                                    Renewal2_EMEA_Quote_Total_Annum_Rule__c, Renewal2_Max_Quote_Total_Annum_For_EMEA__c,
                                    Renewal2_NA_Quote_Total_Annum_Rule__c, Renewal2_Max_Quote_Total_Annum_For_NA__c,
                                    Renewal2_Term_Rule__c, Renewal2_Maximum_Contract_Term__c,
                                    Renewal2_Net_Payment_Term_Rule__c, Renewal2_Net_Payment_Terms__c,
                                    Renewal2_Business_Transaction_Type_Rule__c, Renewal2_Business_Transaction_Type__c,
                                    Renewal3_Using_Quick_Contract_Rule__c,
                                    Renewal3_Business_Transaction_Type_Rule__c, Renewal3_Business_Transaction_Type__c,
                                    Renewal3_Net_Payment_Term_Rule__c, Renewal3_Net_Payment_Terms__c,Renewal5_Business_Transaction_Type__c,
                                    Renewal4_Using_Quick_Contract_Rule__c,
                                    Renewal_Term_GT_36_Rule__c,//Added for Education QQ  
                                    Renewal_Term_GT_36__c,                                  
                                    Renewal_QuoteTotal_Annum_GT300K_NA_Rule__c,
                                    Renewal_Quote_Total_Annum_GT_300K_NA__c,
                                    New_Product_CA_Education_Combo_Rule__c,
                                    New_Product_CAEducation_With_PM_Rule__c,
                                    New_Product_CAEducation_PMethod_With_PM__c,
                                    CA_Education_Public_Sector_Rule__c,
                                    CA_Education_Pricing_Group__c,
                                    CA_Education_Bus_Trans_Type__c,
                                    Renewal4_Business_Transaction_Type__c,
                                    NON_CA_Education_Bus_Trans_Types__c,
                                    Renewal_APJ_Quote_Total_Annum_Rule__c, //Added for APAC
                                    Renewal2_APJ_Quote_Total_Annum_Rule__c,
                                    Renewal_Max_Quote_Total_Annum_For_APJ__c,
                                    Renewal2_Max_Quote_Total_Annum_For_APJ__c,
                                    New_Product_Morethan_1_SKUs__c,New_Product_Quote_Term__c,
                                    New_Product_Quote_Term2__c,New_Product_Quote_Type__c,
                                    New_Product_Stated_Renewal_Fee__c,New_Product_Stated_Renewal_Fee_Input__c,
                                    New_Product_Term_Input1__c,New_Product_Term_Input2__c,
                                    New_Product_Net_Term_Input__c,New_Product_Net_Payment_Term__c,
                                    New_Product_Number_of_Users__c,New_Product_UserCount_Input__c,
                                    New_Product_Payment_Schedule_Input_1__c,New_Product_Payment_Schedule_Input_2__c,
                                    New_Product_Payment_Schedule_Input_3__c,New_Product_License_Type_Input_1__c,
                                    New_Product_License_Type_Input_2__c,New_Product_License_Type_Input_3__c,
                                    New_Product_Payment_Schedule_1__c,New_Product_Payment_Schedule_2__c,
                                    New_Product_Payment_Schedule_3__c ,
                                    Renewal3_NA_Qcuote_Total_Annum_Rule__c ,
                                    Renewal3_Max_Quote_Total_Annum_For_NA__c ,
                                    Renewal3_EMEA_Rule__c ,
                                    Renewal3_LA_Rule__c ,
                                    Renewal3_APJ_Rule__c ,
                                    Renewal3_Term_Rule__c ,
                                    Renewal3_Maximum_Contract_Term__c ,
                                    Renewal4_Term_Rule__c ,
                                    Renewal4_Maximum_Contract_Term__c,
                                    New_Product_IndirectAdvantageSKUs__c,
                                    Ramp_Bridge_Order__c,Agile_NP_PG_Bus_Trans_and_Term_12_Rule__c,
                                    Agile_New_Product_Term_Less_Than_12__c,Agile_NP_PG_Not_SaaS__c,Agile_New_Product_term_rule_months__c,
                                    Agile_NP_Bus_Trans_Not_Dist_Capc__c,Agile_NP_Bus_Tran_Not_12_24_36__c,
                                    Agile_NP_Pricing_Not_12_24_36__c,Renewal_Bus_Trans_When_Not_12_24_36__c,
                                    Renewal_Ramp_Indicator_Rule__c,Agile_Renewal_Term_rule_3_years__c,Renewal_Agile_Quick_Contract__c                           
                             FROM DDR_Rules__c 
                             LIMIT 1];
     //ddrRules.New_Product_Morethan_1_SKUs__c=true;
     //update ddrRules;
     User userRec= [select id from user where ContactId = null and isactive = true and PMFKey__c != null  limit 1];
        userRec.Email = 'test@ca.com';
        userRec.Title = 'SAPXI';
        
        //Account testAccnt = new Account();
/*        testAccnt.Name = 'Test Account';
        testAccnt.OwnerId = userRec.Id;
        testAccnt.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();   
        insert testAccnt;        */
  
       ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
       ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
       SystemIdUtility.skipAccount = true;
        Account resellerAcct = new Account(RecordTypeId=ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
                insert resellerAcct;                
                
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
                insert smbAcct;
                      
        //Opportunity testOppty=new Opportunity();
        testOppty.AccountId=smbAcct.Id;
        testOppty.Name='testOpp';        
        testOppty.StageName='10%-Unqualified Opp.';
        testOppty.CloseDate=System.today();
        testOppty.Inside_Outside__c='Outside';
        testOppty.Initial_Billing__c=1200;        
        testOppty.Type='FM4';
        testOppty.Deal_Review__c='YELLOW, Needs Work!';        
        testOppty.Solution_Playbook_Triggers__c='Agile CLoud Delivery';
        testOppty.Reseller__c=resellerAcct.Id;
        testOppty.OwnerId =UserInfo.getUserId();
        SystemIdUtility.skipOpportunityTriggers = true;
        insert testOppty;
        testOppty1.AccountId=smbAcct.Id;
        testOppty1.Name='testOpp';        
        testOppty1.StageName='10%-Unqualified Opp.';
        testOppty1.CloseDate=System.today();
        testOppty1.Inside_Outside__c='Outside';
        testOppty1.Initial_Billing__c=1200;        
        testOppty1.Type='1 Tier';
        testOppty1.Deal_Review__c='YELLOW, Needs Work!';        
        testOppty1.Solution_Playbook_Triggers__c='Agile CLoud Delivery';
        testOppty1.Reseller__c=resellerAcct.Id;
        testOppty1.OwnerId =UserInfo.getUserId();
        SystemIdUtility.skipOpportunityTriggers = true;
        insert testOppty1;
     
        testOppty2.AccountId=smbAcct.Id;
        testOppty2.Name='testOpp';        
        testOppty2.StageName='10%-Unqualified Opp.';
        testOppty2.CloseDate=System.today();
        testOppty2.Inside_Outside__c='Outside';
        testOppty2.Initial_Billing__c=1200;        
        testOppty2.Type='Services';
        testOppty2.Deal_Review__c='YELLOW, Needs Work!';        
        testOppty2.Solution_Playbook_Triggers__c='Agile CLoud Delivery';
        testOppty2.Reseller__c=resellerAcct.Id;
        testOppty2.OwnerId =UserInfo.getUserId();
        SystemIdUtility.skipOpportunityTriggers = true;
        insert testOppty2;
     
     
     
      
        //scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
        sterlingQuote.scpq__OpportunityId__c=testOppty.Id;
        sterlingQuote.Name='Sterlingquote1';
        sterlingQuote.Ramp_Bridge_Order__c=false;
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
        sterlingQuote.Agile_Central_Clauses__c='ELA';
        sterlingQuote.Services_Payment__c=666;
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert sterlingQuote;
        sterlingQuote.Bill_To_Phone__c='9977777';
        sterlingQuote.CA_Using_Quick_Contract__c=true;
        update sterlingQuote;
     
        sterlingQuote3.scpq__OpportunityId__c=testOppty2.Id;
        sterlingQuote3.Name='Sterlingquote1';
        sterlingQuote3.Ramp_Bridge_Order__c=false;
        sterlingQuote3.Is_this_an_Agile_Central_Transaction__c='Light';
        sterlingQuote3.scpq__Status__c='Approved';
        sterlingQuote3.CA_Quote_Type__c='Services';
        sterlingQuote3.CA_Commissionable_Area__c='Medium Touch';
        sterlingQuote3.Sold_To_Address__c='fffff';
        sterlingQuote3.CA_CPQ_Quote_Total__c=5000;     
        sterlingQuote3.CA_Sold_To_ID__c='344234';
        sterlingQuote3.CA_Customer_Name_Sold_To__c='adasda';
        sterlingQuote3.CA_Technical_Contact_Name__c='Test tech contact name';
        sterlingQuote3.CA_Bill_To_ID__c='56757';
        sterlingQuote3.CA_Bill_To_Name__c='xxxx';
        sterlingQuote3.CA_Billing_Contact_Name__c='qqq';
        sterlingQuote3.CA_Ship_To_ID__c='22';
        sterlingQuote3.CA_Ship_To_Name__c='rrrr';
        sterlingQuote3.CA_Shipping_Contact_Name__c='wwww';
        sterlingQuote3.CA_Service_Provider_ID__c='eeeeeee';
        sterlingQuote3.CA_Service_Provider_Name__c='hhhhh';
        sterlingQuote3.CA_End_User_Contact_Name__c='iiiii';
        sterlingQuote3.CA_End_User_ID__c='oooo';
        sterlingQuote3.CA_End_User_Name__c='nnnnn';
        sterlingQuote3.CA_Direct_Indirect__c='direct';
        sterlingQuote3.CA_Sales_Area__c='vvvvv';
        sterlingQuote3.CurrencyIsoCode='USD';
        sterlingQuote3.CA_Services_Included__c='ttttttt';
        sterlingQuote3.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        sterlingQuote3.CA_Total_Old_TRR__c=6666666;
        sterlingQuote3.CA_Revenue_Per_Day_Percentage__c=98;
        sterlingQuote3.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        sterlingQuote3.CA_Contracted_Renewal__c='444';
        sterlingQuote3.CA_Purchase_Order_Number__c='5555';
        sterlingQuote3.CA_Effective_Date__c=System.today();
        sterlingQuote3.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote3.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote3.scpq__OrderHeaderKey__c='cc333'; 
        sterlingQuote3.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote3.Ship_To_Address__c='dddd';
        sterlingQuote3.Sold_To_Address__c='dddd,CN';
        sterlingQuote3.Bill_To_Address__c='dddd';
        sterlingQuote3.Agile_Central_Clauses__c='ELA';
        sterlingQuote3.Services_Payment__c=666;
        sterlingQuote3.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote3.Technical_Contact_Phone__c='9999977777';
        sterlingQuote3.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote3.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert sterlingQuote3;
        sterlingQuote3.Bill_To_Phone__c='9977777';
        sterlingQuote3.CA_Using_Quick_Contract__c=true;
        update sterlingQuote3;
         
        sterlingQuote1.scpq__OpportunityId__c=testOppty1.Id;
        sterlingQuote1.Name='Sterlingquote1';
        sterlingQuote1.Ramp_Bridge_Order__c=false;
        sterlingQuote1.Is_this_an_Agile_Central_Transaction__c='Light';
        sterlingQuote1.scpq__Status__c='Approved';
        sterlingQuote1.CA_Quote_Type__c='New Product';
        sterlingQuote1.CA_Commissionable_Area__c='Medium Touch';
        sterlingQuote1.Sold_To_Address__c='fffff';
        sterlingQuote1.CA_CPQ_Quote_Total__c=5000;     
        sterlingQuote1.CA_Sold_To_ID__c='344234';
        sterlingQuote1.CA_Customer_Name_Sold_To__c='adasda';
        sterlingQuote1.CA_Technical_Contact_Name__c='Test tech contact name';
        sterlingQuote1.CA_Bill_To_ID__c='56757';
        sterlingQuote1.CA_Bill_To_Name__c='xxxx';
        sterlingQuote1.CA_Billing_Contact_Name__c='qqq';
        sterlingQuote1.CA_Ship_To_ID__c='22';
        sterlingQuote1.CA_Ship_To_Name__c='rrrr';
        sterlingQuote1.CA_Shipping_Contact_Name__c='wwww';
        sterlingQuote1.CA_Service_Provider_ID__c='eeeeeee';
        sterlingQuote1.CA_Service_Provider_Name__c='hhhhh';
        sterlingQuote1.CA_End_User_Contact_Name__c='iiiii';
        sterlingQuote1.CA_End_User_ID__c='oooo';
        sterlingQuote1.CA_End_User_Name__c='nnnnn';
        sterlingQuote1.CA_Direct_Indirect__c='direct';
        sterlingQuote1.CA_Sales_Area__c='vvvvv';
        sterlingQuote1.CurrencyIsoCode='USD';
        sterlingQuote1.CA_Services_Included__c='ttttttt';
        sterlingQuote1.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        sterlingQuote1.CA_Total_Old_TRR__c=6666666;
        sterlingQuote1.CA_Revenue_Per_Day_Percentage__c=98;
        sterlingQuote1.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        sterlingQuote1.CA_Contracted_Renewal__c='444';
        sterlingQuote1.CA_Purchase_Order_Number__c='5555';
        sterlingQuote1.CA_Effective_Date__c=System.today();
        sterlingQuote1.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote1.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote1.scpq__OrderHeaderKey__c='c333333'; 
        sterlingQuote1.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote1.Ship_To_Address__c='dddd';
        sterlingQuote1.Sold_To_Address__c='dddd,CN';
        sterlingQuote1.Bill_To_Address__c='dddd';
        sterlingQuote1.Agile_Central_Clauses__c='ELA';
        sterlingQuote1.Services_Payment__c=666;
        sterlingQuote1.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote1.Technical_Contact_Phone__c='9999977777';
        sterlingQuote1.Bill_To_Phone__c='9999977777';
        sterlingQuote1.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote1.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert sterlingQuote1;
        sterlingQuote1.Bill_To_Phone__c='9977777';
        sterlingQuote1.CA_Using_Quick_Contract__c=true;
        update sterlingQuote1;
     
        RenewalQuote.scpq__OpportunityId__c=testOppty1.Id;
        RenewalQuote.Name='Sterlingquote1';
        RenewalQuote.Ramp_Bridge_Order__c=false;
        RenewalQuote.Is_this_an_Agile_Central_Transaction__c='No';
        RenewalQuote.scpq__Status__c='Approved';
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
        RenewalQuote.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        RenewalQuote.scpq__OrderHeaderKey__c='cc3333'; 
        RenewalQuote.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        RenewalQuote.Ship_To_Address__c='dddd';
        RenewalQuote.Sold_To_Address__c='dddd,CN';
        RenewalQuote.Bill_To_Address__c='dddd';
        RenewalQuote.Agile_Central_Clauses__c='ELA';
        RenewalQuote.Services_Payment__c=666;
        RenewalQuote.Technical_Contact_Email_Address__c='test@test.com';
        RenewalQuote.Technical_Contact_Phone__c='9999977777';
        RenewalQuote.Bill_To_Phone__c='9999977777';
        RenewalQuote.Bill_To_Email_Address__c='test@test.com';        
        RenewalQuote.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert RenewalQuote;
        RenewalQuote.Bill_To_Phone__c='9977777';
        RenewalQuote.CA_Using_Quick_Contract__c=true;
        RenewalQuote.CA_Commissionable_Area__c='Medium Touch Agile Central';
        update RenewalQuote;
     
         RenewalQuote1.scpq__OpportunityId__c=testOppty1.Id;
        RenewalQuote1.Name='Sterlingquote1';
        RenewalQuote1.Ramp_Bridge_Order__c=false;
        RenewalQuote1.Is_this_an_Agile_Central_Transaction__c='Light';
        RenewalQuote1.scpq__Status__c='Approved';
        RenewalQuote1.CA_Quote_Type__c='Renewal';
        RenewalQuote1.CA_Commissionable_Area__c='Agile Central';
        RenewalQuote1.Sold_To_Address__c='fffff';
        RenewalQuote1.CA_CPQ_Quote_Total__c=5000;     
        RenewalQuote1.CA_Sold_To_ID__c='344234';
        RenewalQuote1.CA_Customer_Name_Sold_To__c='adasda';
        RenewalQuote1.CA_Technical_Contact_Name__c='Test tech contact name';
        RenewalQuote1.CA_Bill_To_ID__c='56757';
        RenewalQuote1.CA_Bill_To_Name__c='xxxx';
        RenewalQuote1.CA_Billing_Contact_Name__c='qqq';
        RenewalQuote1.CA_Ship_To_ID__c='22';
        RenewalQuote1.CA_Ship_To_Name__c='rrrr';
        RenewalQuote1.CA_Shipping_Contact_Name__c='wwww';
        RenewalQuote1.CA_Service_Provider_ID__c='eeeeeee';
        RenewalQuote1.CA_Service_Provider_Name__c='hhhhh';
        RenewalQuote1.CA_End_User_Contact_Name__c='iiiii';
        RenewalQuote1.CA_End_User_ID__c='oooo';
        RenewalQuote1.CA_End_User_Name__c='nnnnn';
        RenewalQuote1.CA_Direct_Indirect__c='direct';
        RenewalQuote1.CA_Sales_Area__c='vvvvv';
        RenewalQuote1.CurrencyIsoCode='USD';
        RenewalQuote1.CA_Services_Included__c='ttttttt';
        RenewalQuote1.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        RenewalQuote1.CA_Total_Old_TRR__c=6666666;
        RenewalQuote1.CA_Revenue_Per_Day_Percentage__c=98;
        //RenewalQuote1.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        RenewalQuote1.CA_Contracted_Renewal__c='444';
        RenewalQuote1.CA_Purchase_Order_Number__c='5555';
        RenewalQuote1.CA_Effective_Date__c=System.today();
        RenewalQuote1.CA_Contract_End_Date__c=System.today()+120;
        RenewalQuote1.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        RenewalQuote1.scpq__OrderHeaderKey__c='cc333333'; 
        RenewalQuote1.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        RenewalQuote1.Ship_To_Address__c='dddd';
        RenewalQuote1.Sold_To_Address__c='dddd,CN';
        RenewalQuote1.Bill_To_Address__c='dddd';
        RenewalQuote1.Agile_Central_Clauses__c='ELA';
        RenewalQuote1.Services_Payment__c=666;
        RenewalQuote1.Technical_Contact_Email_Address__c='test@test.com';
        RenewalQuote1.Technical_Contact_Phone__c='9999977777';
        RenewalQuote1.Bill_To_Phone__c='9999977777';
        RenewalQuote1.Bill_To_Email_Address__c='test@test.com';        
        RenewalQuote1.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert RenewalQuote1;
        RenewalQuote1.Bill_To_Phone__c='9977777';
        RenewalQuote1.CA_Using_Quick_Contract__c=true;
        RenewalQuote1.CA_Commissionable_Area__c='Indirect Medium Touch';
        update RenewalQuote1;
     
        RenewalQuote2.scpq__OpportunityId__c=testOppty1.Id;
        RenewalQuote2.Name='Sterlingquote1';
        RenewalQuote2.Ramp_Bridge_Order__c=false;
        RenewalQuote2.Is_this_an_Agile_Central_Transaction__c='Light';
        RenewalQuote2.scpq__Status__c='Approved';
        RenewalQuote2.CA_Quote_Type__c='Renewal';
        RenewalQuote2.CA_Commissionable_Area__c='Agile Central';
        RenewalQuote2.Sold_To_Address__c='fffff';
        RenewalQuote2.CA_CPQ_Quote_Total__c=5000;     
        RenewalQuote2.CA_Sold_To_ID__c='344234';
        RenewalQuote2.CA_Customer_Name_Sold_To__c='adasda';
        RenewalQuote2.CA_Technical_Contact_Name__c='Test tech contact name';
        RenewalQuote2.CA_Bill_To_ID__c='56757';
        RenewalQuote2.CA_Bill_To_Name__c='xxxx';
        RenewalQuote2.CA_Billing_Contact_Name__c='qqq';
        RenewalQuote2.CA_Ship_To_ID__c='22';
        RenewalQuote2.CA_Ship_To_Name__c='rrrr';
        RenewalQuote2.CA_Shipping_Contact_Name__c='wwww';
        RenewalQuote2.CA_Service_Provider_ID__c='eeeeeee';
        RenewalQuote2.CA_Service_Provider_Name__c='hhhhh';
        RenewalQuote2.CA_End_User_Contact_Name__c='iiiii';
        RenewalQuote2.CA_End_User_ID__c='oooo';
        RenewalQuote2.CA_End_User_Name__c='nnnnn';
        RenewalQuote2.CA_Direct_Indirect__c='direct';
        RenewalQuote2.CA_Sales_Area__c='vvvvv';
        RenewalQuote2.CurrencyIsoCode='USD';
        RenewalQuote2.CA_Services_Included__c='ttttttt';
        RenewalQuote2.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        RenewalQuote2.CA_Total_Old_TRR__c=6666666;
        RenewalQuote2.CA_Revenue_Per_Day_Percentage__c=98;
        //RenewalQuote1.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        RenewalQuote2.CA_Contracted_Renewal__c='444';
        RenewalQuote2.CA_Purchase_Order_Number__c='5555';
        RenewalQuote2.CA_Effective_Date__c=System.today();
        RenewalQuote2.CA_Contract_End_Date__c=System.today()+120;
        RenewalQuote2.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        RenewalQuote2.scpq__OrderHeaderKey__c='cc33333'; 
        RenewalQuote2.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        RenewalQuote2.Ship_To_Address__c='dddd';
        RenewalQuote2.Sold_To_Address__c='dddd,CN';
        RenewalQuote2.Bill_To_Address__c='dddd';
        RenewalQuote2.Agile_Central_Clauses__c='ELA';
        RenewalQuote2.Services_Payment__c=666;
        RenewalQuote2.Technical_Contact_Email_Address__c='test@test.com';
        RenewalQuote2.Technical_Contact_Phone__c='9999977777';
        RenewalQuote2.Bill_To_Phone__c='9999977777';
        RenewalQuote2.Bill_To_Email_Address__c='test@test.com';        
        RenewalQuote2.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert RenewalQuote2;
        RenewalQuote2.Bill_To_Phone__c='9977777';
        RenewalQuote2.CA_Using_Quick_Contract__c=true;
        RenewalQuote2.CA_Commissionable_Area__c='High Touch Fast Track';
        update RenewalQuote2;
        
                            
        QuoteRec= [SELECT Id,Name,CA_Quote_Type__c FROM scpq__SciQuote__c WHERE Id =:sterlingQuote.Id]; 
        
        
        System.debug('#####renewalQuoteRec'+renewalQuoteRec);
        System.debug('#####renewalQuoteRec.CA_Quote_Type__c'+renewalQuoteRec.CA_Quote_Type__c);
         
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
        QPR.CA_Pricing_Group__c='SaaS';
        insert QPR;  
 
Map<String, Decimal> isoCodeToConversionRate = new Map<String, Decimal>();
    for(CurrencyType ct : [SELECT IsoCode, ConversionRate FROM CurrencyType])
        isoCodeToConversionRate.put(ct.IsoCode, ct.ConversionRate);
       Test.startTest();
        AutoCreateDDR autoCreate=new AutoCreateDDR();
        AutoCreateDDR.createDDR(sterlingQuote,sterlingQuote);
        AutoCreateDDR.createDDR(sterlingQuote3,sterlingQuote3);
        Quote_Approval_History__c approvalHistroy=AutoCreateDDR.createQuoteApprovalHistory(sterlingQuote);
        AutoCreateDDR.quoteShouldBeAutoApproved(sterlingQuote,approvalHistroy);
        AutoCreateDDR.quoteRequiresDDR(sterlingQuote,sterlingQuote,isoCodeToConversionRate,ddrRules);
        AutoCreateDDR.quoteRequiresDDR(sterlingQuote1,sterlingQuote1,isoCodeToConversionRate,ddrRules);
        AutoCreateDDR.quoteRequiresDDR(RenewalQuote,sterlingQuote,isoCodeToConversionRate,ddrRules);
        AutoCreateDDR.quoteRequiresDDR(RenewalQuote1,sterlingQuote,isoCodeToConversionRate,ddrRules);
        AutoCreateDDR.quoteRequiresDDR(RenewalQuote2,sterlingQuote,isoCodeToConversionRate,ddrRules);
        AutoCreateDDR.preDDRCheck(sterlingQuote,sterlingQuote);
     Test.stopTest();

   
 
 }

}