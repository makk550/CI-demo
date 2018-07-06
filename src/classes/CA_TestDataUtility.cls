/** * File Name: CA_TestDataUtility
* Description : To create the Test data for different salesforce Objects.
* * @author : Garima Shukla
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
public Class CA_TestDataUtility{
//public static List<Account> listOfAccToInsert = new List<Account>();
public static Account acc1 = new Account();
public Static Opportunity opp1 = new Opportunity();
public static List<Opportunity> listOfOppToInsert = new List<Opportunity>();
public static List<Quote_Product_Report__c> quoteLineItemToInsert= new List<Quote_Product_Report__c>();
public Static List<Site_Association__c> listOfsiteAssToInsert = new List<Site_Association__c>();
public Static List<Apttus__APTS_Agreement__c> agreeToInsert = new List<Apttus__APTS_Agreement__c>();
public Static List<Apttus__APTS_Agreement__c> agreeToInsert1 = new List<Apttus__APTS_Agreement__c>();
public Static List<Approver__c> approverToInsert = new List<Approver__c>();
public Static scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
    public Static Account createAccountData(){
    
    RecordType accRec = [Select id,Name,DeveloperName from RecordType where RecordType.DeveloperName = 'Support_Account'];
     //RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Support Account');
     //Id accRec = rec.RecordType_Id__c;
    //Account acc1 = new Account();
    acc1.Name = 'Test Account';
    acc1.Customer_Category__c = 'AAM';
    acc1.Enterprise_ID__c = '7777777777';
    acc1.BillingStreet='Street';
    acc1.BillingCountry='US - UNITED STATES';
    acc1.BillingCity='Islandia';
    acc1.RecordtypeId = accRec.id;
    acc1.Country_Picklist__c = 'US - UNITED STATES';
    insert acc1;
    return acc1;
   
    }
    public Static List<Opportunity> createOpportunityData(){
      
        //Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opp';
        opp1.Account = acc1;
        opp1.CloseDate = System.today()+10;
        opp1.Transaction_Type__c = 'Direct';
        opp1.Contract_Type__c = 'SAAS';
        opp1.Inside_Outside__c = 'Outside';
        opp1.StageName = Label.Opp_Stage_10_Percent;
        listOfOppToInsert.add(opp1);
        insert listOfOppToInsert;            
        return listOfOppToInsert;
    }
    public Static List<Quote_Product_Report__c> createQuoteLineItemData(){
       
        Quote_Product_Report__c quoteLineItem1 = new Quote_Product_Report__c ();
        quoteLineItem1.Name = 'ABC001';
        quoteLineItem1.Opportunity__c = listOfOppToInsert [0].id;
        quoteLineItemToInsert.add(quoteLineItem1);
        
        if(quoteLineItemToInsert.size()>0){
            insert quoteLineItemToInsert;
        }
        return quoteLineItemToInsert;
    }
    public Static void createSterlinQuoteData(){
    
    }
    public Static List<Site_Association__c> createSiteAssociationData(){
    
        
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
        site1.Enterprise_ID__c = acc1.id;
        site1.Site_Status__c = 'Approved';
        site1.SC_SITE_Source__c = 'Sales';
        //site1.SAP_Site_ID__c = '8686700';
        //site1.SC_TOPS_ID__c = '8686700';
        
        if(listOfsiteAssToInsert.size()>0){
            insert listOfsiteAssToInsert ;
        }
        return listOfsiteAssToInsert;   
    }
    public Static List<Apttus__APTS_Agreement__c> createAgreementData(){
        RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
        
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agr1.CA_Agreement_Type__c = 'Order Form' ;
        agr1.RecordTypeId = agrRec.id;
        agr1.Tops_Site_Id_Sold_To_Id__c = listOfsiteAssToInsert[0].id;
        agr1.CA_Opportunity__c = listOfOppToInsert [0].id;
        agr1.CA_Agreement_Sub_Type__c = 'Education';
        agr1.CA_Sales_Type__c = 'Direct';
        agreeToInsert.add(agr1);
        
        Apttus__APTS_Agreement__c agr2 = new Apttus__APTS_Agreement__c();
        agr2.Name = 'Test Agreement';
        agr2.Apttus__Contract_Start_Date__c = System.today();
        agr2.CA_Agreement_Type__c = 'Order Form' ;
        agr2.RecordTypeId = agrRec.id;
        agr2.Tops_Site_Id_Sold_To_Id__c = listOfsiteAssToInsert[0].id;
        agr2.CA_Opportunity__c = listOfOppToInsert [0].id;
        agr2.CA_Agreement_Sub_Type__c = 'Education';
        agr2.CA_Sales_Type__c = 'Direct';
        agreeToInsert.add(agr2);
        
        if(agreeToInsert.size()>0){
            insert agreeToInsert;
        }
        return agreeToInsert ;
    }
    public Static List<Apttus__APTS_Agreement__c> createPlainAgreementData(){
        Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
        agr1.Name = 'Test Agreement';
        agr1.Apttus__Contract_Start_Date__c = System.today();
        agreeToInsert1.add(agr1);
        
        if(agreeToInsert1.size()>0){
            insert agreeToInsert1;
        }
        return agreeToInsert1 ;
    
    }
     public Static List<Approver__c> createApproverData(){
     createPlainAgreementData();
     List<User> userList = [select Name,IsActive,Id,Profile.Name from User where Profile.Name = 'Global Presales' and IsActive = true limit 10];
     Approver__c app = new Approver__c();
     app.CA_Agreement__c = agreeToInsert1[0].id; 
     app.CA_Level__c = '1';
     app.CA_Approver_1__c = userList[0].id ;
     app.CA_Approver_1_Comments__c = 'APProver 1 - level 1 Comments';
     app.CA_Approver_2__c = userList[1].id ;
     app.CA_Approver_2_Comments__c = 'APProver 2 - level 1 Comments';
     approverToInsert.add(app);
     
     /*Approver__c app1 = new Approver__c();
     app1.CA_Agreement__c = agreeToInsert1[0].id; 
     app1.CA_Level__c = '1';
     app1.CA_Approver_2__c = userList[1].id ;
     app1.CA_Approver_2_Comments__c = 'APProver 2 - level 1 Comments';
     approverToInsert.add(app1);*/
     
     Approver__c app2 = new Approver__c();
     app2.CA_Agreement__c = agreeToInsert1[0].id; 
     app2.CA_Level__c = '2';
     app2.CA_Approver_1__c = userList[3].id ;
     app2.CA_Approver_1_Comments__c = 'APProver 1 - level 2 Comments';
     app2.CA_Approver_2__c = userList[4].id ;
     app2.CA_Approver_2_Comments__c = 'APProver 2- level 2 Comments';
     approverToInsert.add(app2);
     
    /* Approver__c app3 = new Approver__c();
     app3.CA_Agreement__c = agreeToInsert1[0].id; 
     app3.CA_Level__c = '2';
     app3.CA_Approver_2__c = userList[4].id ;
     app3.CA_Approver_2_Comments__c = 'APProver 2- level 2 Comments';
     approverToInsert.add(app3);*/
     
     Approver__c app4 = new Approver__c();
     app4.CA_Agreement__c = agreeToInsert1[0].id; 
     app4.CA_Level__c = '3';
     app4.CA_Approver_1__c = userList[5].id ;
     app4.CA_Approver_1_Comments__c = 'APProver 1 - level 3 Comments';
     app4.CA_Approver_2__c = userList[4].id ;
     app4.CA_Approver_2_Comments__c = 'APProver 2- level 2 Comments';
     approverToInsert.add(app4);
     
     Approver__c app3 = new Approver__c();
     app3.CA_Agreement__c = agreeToInsert1[0].id; 
     app3.CA_Level__c = '4';
     app4.CA_Approver_1__c = userList[6].id ;
     app4.CA_Approver_1_Comments__c = 'APProver 1 - level 4 Comments';
     app3.CA_Approver_2__c = userList[7].id ;
     app3.CA_Approver_2_Comments__c = 'APProver 2- level 4 Comments';
     approverToInsert.add(app3);   
     
     
     insert approverToInsert;
     return approverToInsert ;
     
     }
     public static scpq__SciQuote__c  createSterlingQuote(){
        
        sterlingQuote.scpq__OpportunityId__c=listOfOppToInsert[0].Id;
        sterlingQuote.Name='Sterlingquote1';
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
        sterlingQuote.Ship_To_Address__c='dddd,aaa,xxx';
        sterlingQuote.Sold_To_Address__c='dddd,CN';
        sterlingQuote.Bill_To_Address__c='dddd,vfg,tyu,ert';
        sterlingQuote.Services_Payment__c=666;
         //sterlingQuote.Sold_To_Address_Lcl__c='test,test';
        sterlingQuote.Bill_To_Address_Lcl__c='test,test';
        sterlingQuote.Ship_To_Address_Lcl__c='test,test';
       
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        insert sterlingQuote;       
        return sterlingQuote;
     
     }
    
}