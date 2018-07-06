@isTest
private Class CA_SterlingQuoteTriggerHandler_Test{
        private static testMethod void testMethod1(){
        
        
        testOpportunityTriggersClass.createNewOpportunity();
        ddrRuleRecordTestClass.insertDdrRule();
        
        Opportunity opp1 = [select id from opportunity limit 1];

        List<scpq__SciQuote__c> listOfquote = new List<scpq__SciQuote__c >();
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
        sterlingQuote.CA_Sales_Area__c='vvvvv';
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
        sterlingQuote.Sold_To_Address__c='dddd,CN,test,test,test,test';
        sterlingQuote.Bill_To_Address__c='dddd,vfg,tyu,ert,ttt,gh,hy';
        sterlingQuote.Services_Payment__c=666;
        sterlingQuote.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote.Bill_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote.Ship_To_Address_Lcl__c='test,test,test,test,test,test';       
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        sterlingQuote.CA_CPQ_Quote_Number__c = 'Y123400';
        SystemIdUtility.skipSterlingQuoteProcessor = true;        
        listOfquote.add(sterlingQuote);
        
        //Adding quote
        scpq__SciQuote__c  sterlingQuote1=new scpq__SciQuote__c();
        sterlingQuote1.scpq__OpportunityId__c=opp1.Id;
        sterlingQuote1.Name='Sterlingquote1';
        sterlingQuote1.scpq__Status__c='Approved';
        sterlingQuote1.CA_Quote_Type__c='New Product';
        sterlingQuote1.CA_Commissionable_Area__c='Medium Touch';
        //sterlingQuote.Sold_To_Address__c='fffff,TestCity,Test Country,Test region,test geo,test state,test zip';
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
        sterlingQuote1.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS'; /*YEDRA01 for AR:2994*/
        sterlingQuote1.CA_Contracted_Renewal__c='444';
        sterlingQuote1.CA_Purchase_Order_Number__c='5555';
        sterlingQuote1.CA_Effective_Date__c=System.today();
        sterlingQuote1.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote1.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote1.scpq__OrderHeaderKey__c='cccc333334'; 
        sterlingQuote1.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote1.Ship_To_Address__c='dddd,aaa,xxx,yyy,yyy,yyyy,uuu';
        sterlingQuote1.Sold_To_Address__c='dddd,CN,test,test,test,test';
        sterlingQuote1.Bill_To_Address__c='dddd,vfg,tyu,ert,ttt,gh,hy';
        sterlingQuote1.Services_Payment__c=666;
        sterlingQuote1.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote1.Bill_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote1.Ship_To_Address_Lcl__c='test,test,test,test,test,test';       
        sterlingQuote1.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote1.Technical_Contact_Phone__c='9999977777';
        sterlingQuote1.Bill_To_Phone__c='9999977777';
        sterlingQuote1.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote1.Order_Form__c='66666';
        sterlingQuote1.CA_CPQ_Quote_Number__c = 'Y123401';   
             listOfquote.add(sterlingQuote1);
            insert listOfquote;
      
        
        RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        //List<User> listOfuser = [Select id,Name,isActive from User where isActive = true limit 4];
        List<Apttus__APTS_Agreement__c> listofagr=new List<Apttus__APTS_Agreement__c>(); 
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.Apttus__Contract_End_Date__c=System.today() +30;
        agr1.RecordTypeId = agrRec.id;
        agr1.CA_Opportunity__c = opp1.id;
        agr1.Sterling_Quote__c = sterlingQuote.id;
        listofagr.add(agr1);
          //List<Apttus__APTS_Agreement__c> listofagr=new List<Apttus__APTS_Agreement__c>(); 
        Apttus__APTS_Agreement__c agr2 = new Apttus__APTS_Agreement__c();
        agr2.Name = 'Test Agreement1';
        agr2.Apttus__Contract_Start_Date__c = System.today();
        agr2.Apttus__Contract_End_Date__c=System.today() +20;
        agr2.RecordTypeId = agrRec.id;
        agr2.CA_Opportunity__c = opp1.id;
        agr2.Sterling_Quote__c = sterlingQuote1.id;  
           listofagr.add(agr2);
            insert listofagr;
         sterlingQuote.CA_Partner_Address__c='test,test,test,test,test';
        sterlingQuote.CA_End_User_Address__c='test,test,test,test,test';
        sterlingQuote.CA_Distributor_Address__c='test,test,test,test,test';
        sterlingQuote.Sold_To_Address_Lcl__c='test1,test1,test,test,test,test'; 
        sterlingQuote.Ship_To_Address__c='dddd1,aaa,xxx,yyy,yyy,yyyy,uuu';
        sterlingQuote.Sold_To_Address__c='dddd1,CN,test,test,test,test';
        sterlingQuote.Bill_To_Address__c='dddd1,vfg,tyu,ert,ttt,gh,hy';
        //sterlingQuote.Services_Payment__c=666;
        //sterlingQuote.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote.Bill_To_Address_Lcl__c='test1,test,test,test,test,test';
        sterlingQuote.Ship_To_Address_Lcl__c='test1,test,test,test,test,test'; 
         sterlingQuote.CA_Partner_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote.CA_Distributor_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote.CA_End_User_Address_Lcl__c='test,test,test,test,test'; 
            update sterlingQuote;
            
          sterlingQuote1.CA_Partner_Address__c='test,test,test,test,test';
        sterlingQuote1.CA_End_User_Address__c='test,test,test,test,test';
        sterlingQuote1.CA_Distributor_Address__c='test,test,test,test,test';
        sterlingQuote1.Sold_To_Address_Lcl__c='test1,test1,test,test,test,test'; 
        sterlingQuote1.Ship_To_Address__c='dddd1,aaa,xxx,yyy,yyy,yyyy,uuu';
        sterlingQuote1.Sold_To_Address__c='dddd1,CN,test,test,test,test';
        sterlingQuote1.Bill_To_Address__c='dddd1,vfg,tyu,ert,ttt,gh,hy';
        //sterlingQuote.Services_Payment__c=666;
        //sterlingQuote.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote1.Bill_To_Address_Lcl__c='test1,test,test,test,test,test';
        sterlingQuote1.Ship_To_Address_Lcl__c='test1,test,test,test,test,test'; 
         sterlingQuote1.CA_Partner_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote1.CA_Distributor_Address_Lcl__c='test,test,test,test,test';
        sterlingQuote1.CA_End_User_Address_Lcl__c='test,test,test,test,test';   
        update sterlingQuote1;
        
        sterlingQuote.Sold_To_Address_Lcl__c=''; 
        sterlingQuote.Ship_To_Address__c='';
        sterlingQuote.Sold_To_Address__c='';
        sterlingQuote.Bill_To_Address__c='';
        //sterlingQuote.Services_Payment__c=666;
        //sterlingQuote.Sold_To_Address_Lcl__c='test,test,test,test,test,test';
        sterlingQuote.Bill_To_Address_Lcl__c='';
        sterlingQuote.Ship_To_Address_Lcl__c='';  
        update sterlingQuote;
        }   
}