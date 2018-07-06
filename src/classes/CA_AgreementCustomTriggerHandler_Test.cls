@isTest
private Class CA_AgreementCustomTriggerHandler_Test{
       
   
    
    private static testMethod void testMethod1(){
	 SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        
        testOpportunityTriggersClass.createNewOpportunity();
        ddrRuleRecordTestClass.insertDdrRule();
        
        opportunity opp1 = [select id from opportunity limit 1];
        
        Account smbAcct = [select id from Account limit 1];

        
    Site_Association__c site1 = new Site_Association__c();
    site1.Name = 'Test Site Association';
    site1.Street__c = '195 Broadway';
    site1.City__c = 'New York';
    site1.State__c = 'NY';
    site1.Postal_Code__c ='10008';
    site1.Country_Picklist__c= 'US - UNITED STATES';
    site1.Support_Region__c= 'NA';
    site1.SC_SITE_Preferred_Language__c = 'ENGLISH';
    site1.SC_SITE_Sanctioned_Party__c = 'NO';
    site1.Enterprise_ID__c = smbAcct.id;
    site1.Site_Status__c = 'Approved';
    site1.SC_SITE_Source__c = 'Sales';
    site1.SAP_Site_ID__c = '8686700';
    site1.SC_TOPS_ID__c = '8686700';
    site1.ProviSite__c = 22;
    insert site1; 
        
        List<scpq__SciQuote__c> listOfster = new List<scpq__SciQuote__c>();
        scpq__SciQuote__c  sterlingQuote2=new scpq__SciQuote__c();
        sterlingQuote2.scpq__OpportunityId__c=opp1.Id;
        sterlingQuote2.Name='Sterlingquote1';
        sterlingQuote2.scpq__Status__c='Approved';
        sterlingQuote2.CA_Quote_Type__c='New Product';
        sterlingQuote2.CA_Commissionable_Area__c='Medium Touch';
        sterlingQuote2.CA_CPQ_Quote_Number__c='Y1';
        //sterlingQuote.Sold_To_Address__c='fffff,TestCity,Test Country,Test region,test geo,test state,test zip';
        sterlingQuote2.CA_CPQ_Quote_Total__c=5000;     
        sterlingQuote2.CA_Sold_To_ID__c='344234';
        sterlingQuote2.CA_Customer_Name_Sold_To__c='adasda';
        sterlingQuote2.CA_Technical_Contact_Name__c='Test tech contact name';
        sterlingQuote2.CA_Bill_To_ID__c='56757';
        sterlingQuote2.CA_Bill_To_Name__c='xxxx';
        sterlingQuote2.CA_Billing_Contact_Name__c='qqq';
        sterlingQuote2.CA_Ship_To_ID__c='22';
        sterlingQuote2.CA_Ship_To_Name__c='rrrr';
        sterlingQuote2.CA_Shipping_Contact_Name__c='wwww';
        sterlingQuote2.CA_Service_Provider_ID__c='eeeeeee';
        sterlingQuote2.CA_Service_Provider_Name__c='hhhhh';
        sterlingQuote2.CA_End_User_Contact_Name__c='iiiii';
        sterlingQuote2.CA_End_User_ID__c='oooo';
        sterlingQuote2.CA_End_User_Name__c='nnnnn';
        sterlingQuote2.CA_Direct_Indirect__c='direct';
        sterlingQuote2.CA_Sales_Area__c='vvvvv';
        sterlingQuote2.CurrencyIsoCode='USD';
        sterlingQuote2.CA_Services_Included__c='ttttttt';
        sterlingQuote2.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        sterlingQuote2.CA_Total_Old_TRR__c=6666666;
        sterlingQuote2.CA_Revenue_Per_Day_Percentage__c=98;
        sterlingQuote2.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS'; //YEDRA01 for AR:2994
        sterlingQuote2.CA_Contracted_Renewal__c='444';
        sterlingQuote2.CA_Purchase_Order_Number__c='5555';
        sterlingQuote2.CA_Effective_Date__c=System.today();
        sterlingQuote2.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote2.CA_CPQ_Quote_Status__c='Approved';
        
        sterlingQuote2.scpq__OrderHeaderKey__c='cccc8765858'; 
        sterlingQuote2.scpq__SciLastModifiedDate__c=System.Today();
        
        sterlingQuote2.Ship_To_Address__c='dddd,aaa,xxx,yyy,yyy,yyyy,uuu';
        sterlingQuote2.Sold_To_Address__c='dddd,CN,test,test,test,test';
        sterlingQuote2.Bill_To_Address__c='dddd,vfg,tyu,ert,ttt,gh,hy';
        sterlingQuote2.Services_Payment__c=666;
        sterlingQuote2.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote2.CA_Distributor_Address__c='test,test,test';
        sterlingQuote2.CA_Distributor_Address_Lcl__c='test,test,test';
        sterlingQuote2.Bill_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote2.Ship_To_Address_Lcl__c='test,test,test,test,test,test';       
        sterlingQuote2.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote2.Technical_Contact_Phone__c='9999977777';
        sterlingQuote2.Bill_To_Phone__c='9999977777';
        sterlingQuote2.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote2.Order_Form__c='66666';
        sterlingQuote2.CA_CPQ_Quote_Number__c = 'Y123678';
        SystemIdUtility.skipSterlingQuoteProcessor = true;       
        listOfster.add(sterlingQuote2); 
        
        
            
        scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
        sterlingQuote.scpq__OpportunityId__c=opp1.Id;
        sterlingQuote.Name='Sterlingquote1';
        sterlingQuote.scpq__Status__c='Approved';
        sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch';
        //sterlingQuote.Sold_To_Address__c='fffff,TestCity,Test Country,Test region,test geo,test state,test zip';
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
        //sterlingQuote.Region__c='NA';
        sterlingQuote.CA_Sales_Area__c='NA_PS/CAN';
       // sterlingQuote.Territory__c='PS_CANADA';
      //  sterlingQuote.Sub_Territory__c='PS_CAN_FED-EAST';
        sterlingQuote.CurrencyIsoCode='USD';
        sterlingQuote.CA_Services_Included__c='ttttttt';
        sterlingQuote.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        sterlingQuote.CA_Total_Old_TRR__c=6666666;
        sterlingQuote.CA_Revenue_Per_Day_Percentage__c=98;
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS'; /*YEDRA01 for AR:2994*/
        sterlingQuote.CA_Contracted_Renewal__c='444';
        sterlingQuote.CA_Purchase_Order_Number__c='5555';
        sterlingQuote.CA_Effective_Date__c=System.today();
        sterlingQuote.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote.scpq__OrderHeaderKey__c='cccc333333'; 
        sterlingQuote.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.Ship_To_Address__c='dddd,aaa,xxx,yyy,yyy,yyyy,uuu';
        sterlingQuote.CA_Partner_Address__c='test,test,test,test,test';
        sterlingQuote.CA_End_User_Address__c='test,test,test,test,test';
        sterlingQuote.CA_Distributor_Address__c='test,test,test,test,test';
        sterlingQuote.Sold_To_Address__c='dddd,CN,test,test,test,test';
        sterlingQuote.Bill_To_Address__c='dddd,vfg,tyu,ert,ttt,gh,hy';
        sterlingQuote.Services_Payment__c=666;
        sterlingQuote.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote.Bill_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote.Ship_To_Address_Lcl__c='test,test,test,test,test,test'; 
        sterlingQuote.CA_Partner_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote.CA_Distributor_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote.CA_End_User_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        sterlingQuote.CA_CPQ_Quote_Number__c = 'Y123400';
        SystemIdUtility.skipSterlingQuoteProcessor = true;        
        //insert sterlingQuote;      
        listOfster.add(sterlingQuote);
       Test.startTest();
        insert listOfster;
        Test.stopTest();
        
        List<PaymentPlan__c> listOfpp = new List<PaymentPlan__c>();
        PaymentPlan__c pp = new PaymentPlan__c();
        pp.Sterling_Quote__c = sterlingQuote.id;
        pp.Total_Payments__c=123456789;
        pp.Name = 'Test pay Plan';
        listOfpp.add(pp);        
        PaymentPlan__c pp1 = new PaymentPlan__c();
        pp1.Sterling_Quote__c = sterlingQuote.id;
        pp1.Name = 'Test pay Plan';
        listOfpp.add(pp1);  
        
        PaymentPlan__c pp2 = new PaymentPlan__c();
        pp2.Sterling_Quote__c = listOfster[0].id;
        pp2.Name = 'Test pay Plan11';
        pp.Total_Payments__c=123456789;
        listOfpp.add(pp2);        
        PaymentPlan__c pp11 = new PaymentPlan__c();
        pp11.Sterling_Quote__c = listOfster[1].id;
        pp11.Name = 'Test pay Plan122';
        listOfpp.add(pp11);     
        insert listOfpp ;
        
        List<Quote_Product_Report__c> listOfpr = new List<Quote_Product_Report__c >();
        Quote_Product_Report__c pr = new Quote_Product_Report__c();
        pr.Name = '08080801AA';
        pr.Sterling_Quote__c = sterlingQuote.id;
        pr.Bus_Transaction_Type__c='Time';
        pr.Auth_Use_Model__c='Special Metric';
       // pr.Special_Metric_Usage_Qty_Existing__c=1.0;
        listOfpr.add(pr);        
        Quote_Product_Report__c pr1 = new Quote_Product_Report__c();
        pr1.Name = '08080801AA';
        pr1.Sterling_Quote__c = sterlingQuote.id;
        pr1.Expense_Amount_Included__c=1111.0;
        pr1.Bus_Transaction_Type__c='Time';
        pr1.Existing_Quantity__c=1.0;
        listOfpr.add(pr1);
        
        Quote_Product_Report__c pr2 = new Quote_Product_Report__c();
        pr2.Name = '98969682fff';
        pr2.Sterling_Quote__c = listOfster[0].id;
        pr2.Expense_Amount_Included__c=1111.0;
         pr2.Bus_Transaction_Type__c='New Product';
        pr2.Auth_Use_Model__c='Special Metric';
       // pr2.SpecialMetricUsageQtyNewAdditional__c=1.0;
        listOfpr.add(pr2);
        
        Quote_Product_Report__c pr3 = new Quote_Product_Report__c();
        pr3.Name = '90980hhhhhh';
        pr3.Sterling_Quote__c = listOfster[0].id;
        pr3.Expense_Amount_Included__c=1111.0;
         pr3.Bus_Transaction_Type__c='New Product';
        pr3.New_Additional_Quantity__c=1.0;
        listOfpr.add(pr3);
        insert listOfpr;
        
        List<Apttus__APTS_Agreement__c> listOfAgr = new List<Apttus__APTS_Agreement__c>();
        RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.Apttus__Contract_End_Date__c=System.today() +30;
        agr1.Apttus__Perpetual__c=false;
        agr1.Is_Agreement_Generated__c = true;
        agr1.CurrencyIsoCode='USD';
        agr1.RecordTypeId = agrRec.id;
        agr1.CA_Opportunity__c = opp1.id;
        agr1.Sterling_Quote__c = sterlingQuote.id;
       // agr1.CA_Additional_Quote_Numbers__c=sterlingQuote2.CA_CPQ_Quote_Number__c+';'+'Y123678;Y123667';
        agr1.CA_Sales_Type__c = 'Direct';
        agr1.CA_Geo__c = 'NA';
        agr1.CA_Operating_Area__c = 'NA_PS/CAN';
        agr1.CA_Sales_Region__c = 'PS_CANADA';
        agr1.CA_Sales_Territory__c='PS_CAN_FED-EAST';
      //  agr1.CA_Classified_Contract__c = 'No';
        agr1.CA_Language__c = 'English';
        //agr1.CA_Legal_Entity_Address__c = '6 Eden Park Drive, North Ryde, New South Wales 2113, Australia';
        agr1.CA_Additional_Quote_Numbers__c = 'Y123678;Y123667';
        listOfAgr.add(agr1);
        
        Apttus__APTS_Agreement__c agr11 = new Apttus__APTS_Agreement__c();
        agr11.Name = 'Test Agreement';
        
        agr11.Apttus__Status_Category__c = Label.In_Approval;
        agr11.Apttus__Status__c = Label.Pending_Approval;
       // agr11.Agreement_Approver__c='AAAAAAAAAAAAAAAAAA';
        //agr11.Agreement_Approver2__c='BBBBBBBBBBBBBBBBBB';
        //agr11.Agreement_Approver3__c='CCCCCCCCCCCCCCCCCC';
        //agr11.Agreement_Approver4__c='DDDDDDDDDDDDDDDDDD';
        agr11.Apttus__Contract_Start_Date__c = System.today();
        agr11.RecordTypeId = agrRec.id;
        agr11.CA_Opportunity__c = opp1.id;
        agr11.CA_Language__c ='Japanese';
        agr11.Sterling_Quote__c = sterlingQuote.id;
       // agr11.Is_Agreement_Generated__c = true;
       // agr11.CA_Record_Type_Name__c='NDA';
        //agr11.CA_NDA_Flag__c='Standard NDA';
        agr11.Tops_Site_Id_Sold_To_Id__c = site1.id;
        listOfAgr.add(agr11);
        
        Apttus__APTS_Agreement__c agr21 = new Apttus__APTS_Agreement__c();
        agr21.Name = 'Test Agreement';
        agr21.Apttus__Contract_Start_Date__c = System.today();
        //agr21.CA_Agreement_Type__c = 'Order Form' ;
        agr21.RecordTypeId = agrRec.id;
           agr11.Tops_Site_Id_Sold_To_Id__c = site1.id;
        //agr21.SF_Quote__c = sbquote.id;
        agr21.CA_Opportunity__c = opp1.id;
        listOfAgr.add(agr21);
        Product2 prod = new Product2(Name = 'CA Agile Central Unlimited Edition ELA SAAS',
                                     IsActive = true,Family='Product',
                                     Market_Focus_Area__c='Agile Central',
                                     Solution_Sets__c = 'Agile Central',
                                     CSU1__c = 'Agile Central',
                                     CSU2__c = 'Agile Central',
                                     CSU_Driver__c = 'Agile Central',
                                     Hyperion_Budget_Planning__c = 'Agile Central',
                                     Salesforce_CPQ_Product__c = true,
                                     SBQQ__QuantityEditable__c = true,
                                     SBQQ__DefaultQuantity__c = 1,
                                     SBQQ__DescriptionLocked__c = true,
                                     Material_ID__c = 'AGELA199000',
                                     Material_Status__c = 'GA',
                                     Material_Status_Code__c = 'Z5',
                                     Operational_BU__c = 'AGILE CENTRAL',
                                     Operational_BU_Code__c = '39',
                                     Platform_Category__c = 'SAAS',
                                     Platform_Category_Code__c = '5',
                                     Hosting_Type__c = 'Hosted',
                                     License_Type__c = 'SAAS',
                                     License__c = 'SAAS',
                                     Maintenance_Product__c = 'No',
                                     Source_System__c = 'TOPS',
                                     Auth_Use_Mode__c = 'D',
                                     CA_License_Type__c = 'Subscription',
                                     Pricing_Group__c = 'Saas',
                                     Commissionable_BU__c ='AC',
                                     ProductCode = 'AGELA1990',
                                    SBQQ__Component__c = true);
        insert prod;
        SBQQ__Quote__c sbquote = new SBQQ__Quote__c(SBQQ__Opportunity2__c = opp1.id,
                                                  SBQQ__Primary__c = true,
                                                 SBQQ__Type__c = 'Quote',
                                                 SBQQ__Status__c = 'Draft');
        insert sbquote;
        SBQQ__QuoteLine__c qli2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=sbquote.Id,SBQQ__Product__c=prod.Id,
                                                         SBQQ__Quantity__c=10, SBQQ__ListPrice__c = 1000,
                                                        Business_Type__c = 'New',End_Date_Price_Rule__c=Date.valueOf('2017-03-11')); 
        insert qli2;
        Payment_Plan__c p1= new Payment_Plan__c(Amount__c=100.0,Quote__c=sbquote.Id);
        // RecordType agrrec1 = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
    Apttus__APTS_Agreement__c agr31 = new Apttus__APTS_Agreement__c();
        agr31.Name = 'Test Agreement';
        agr31.Apttus__Contract_Start_Date__c = System.today();
        //agr21.CA_Agreement_Type__c = 'Order Form' ;
        agr31.RecordTypeId = agrRec.id;
          agr31.SF_Quote__c = sbquote.id;
       // insert agr31;
        listOfAgr.add(agr31);
        insert listOfAgr;  
        
        Apttus_Approval__Approval_Request__c appreq=new Apttus_Approval__Approval_Request__c();
        appreq.Apttus_Approval__Related_Agreement__c=agr11.id;
        appReq.Apttus_Approval__StepLabel__c =Label.Level_1;
       // appReq.Apttus_Approval__Assigned_To_Id__c='AAAAAAAAAAAAAAAAAA';
        
        
        //Started by Umang
        //POB Master Record creation
        POB_Master__c pm1 = new POB_Master__c(Name='Test', POB_Category__c='Right to Return',
                                              POB_Name__c='Cancellation Credit',POB_Description__c ='Testing');
        insert pm1;
        
        //Agreement POB:
        List<Agreement_POB__c> lstPOBList = new List<Agreement_POB__c>();
        Id recordTypeId = Schema.SObjectType.Agreement_POB__c.getRecordTypeInfosByName().get('New Record Type').getRecordTypeId();
        Agreement_POB__c pob1 = new Agreement_POB__c(Name='Test1', Agreement__c=agr11.Id, RecordTypeId=recordTypeId,
                                CommentsLong__c='Test', Credit_Amount__c=100000, Credit_Amount_Percent__c= 10.00,
                                Expiration_Date__c=System.today(), POB_Category__c=pm1.id);
        lstPOBList.add(pob1);
        
        Agreement_POB__c pob2 = new Agreement_POB__c(Name='Test1', Agreement__c=agr1.Id, RecordTypeId=recordTypeId,
                                CommentsLong__c='Test', Credit_Amount__c=100000, Credit_Amount_Percent__c= 10.00,
                                Expiration_Date__c=System.today(), POB_Category__c=pm1.id);
        lstPOBList.add(pob2);
        
        insert lstPOBList;
        //Ended by Umang
        
        String getCSValue = agr1.CA_Geo__c+'-'+agr1.CA_Sales_Territory__c+'-'+agr1.CA_Language__c.substring(0,2);
        CLM_CA_Legal_Entities__c cs = CLM_CA_Legal_Entities__c.getInstance(getCSValue);
        
       agr1.Sterling_Quote__c = listOfster[0].id;
        agr1.CA_Additional_Quote_Numbers__c = 'Y123678';
        agr1.Apttus__Parent_Agreement__c = agr11.id;
        agr11.Sterling_Quote__c = null;
        update listOfAgr;
        
        
         delete listOfpp ;
         delete listOfpr;
         
         
        PageReference pageRef = Page.AgreementHierarchyTree;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('currentId1', agr1.id);
        AgreementStructure ags = new AgreementStructure();
        ags.formatObjectStructure(agr1.id);
        
        delete  listOfAgr;
    }

}