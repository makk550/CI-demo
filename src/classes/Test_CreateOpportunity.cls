@isTest
public class Test_CreateOpportunity {   
    //samap01 7/31/2017
  
    public static void insertRecordtypes()    
     {
          lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
            RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Commercial Account');
            lstrec.add(rec1);
            RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFP', Name='CA Enterprise Account');
            lstrec.add(rec2);
            RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Account Team Covered Account');
            lstrec.add(rec3);
            RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFR', Name='Reseller/Distributor Account');
            lstrec.add(rec4);
          RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55o', Name='Territory Covered Account');
            lstrec.add(rec5);
              RecordTypes_Setting__c rec7 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55j', Name='SMB');
            lstrec.add(rec7);
                    RecordTypes_Setting__c rec8 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFD', Name='Deal Registration');
            lstrec.add(rec8); 
            RecordTypes_Setting__c rec9 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFP', Name='Partner Opportunity');
            lstrec.add(rec9); 
              RecordTypes_Setting__c rec19 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaNO', Name='New Opportunity');
            lstrec.add(rec19); 
             RecordTypes_Setting__c rec11 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFN', Name='Acquisition');
            lstrec.add(rec11);          
                   
            insert lstrec;
     }
    
    public static User createPartnerUser(){   
         insertRecordtypes();    //samap01 7/31/2017
        Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        
        User partnerUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        
        try{
            insert partnerUser;
        }
        catch(exception e){
            
        }
        return partnerUser;        
    }

    public static User createPartnerUserBasedOnGEO(string geo, string countryName){        
        insertRecordtypes(); //samap01
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner User with Sales Tools'];
                
        Account ac = new Account();
        ac.Name = 'TestAccount'+geo;
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c=geo;
        ac.Enterprise_ID__c = '1234test';       
        ac.Enterprise_Account_Name__c = 'TestAccount'+geo;
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = '1234';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon'+geo,AccountId = ac.Id);
        insert con; 
        
        User partnerUser = new User(alias = geo, email=geo+'@noemail.com',emailencodingkey='UTF-8',
                                    lastname='ln'+geo, languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country=countryName,IsActive =true,ContactId = con.Id,
                                    timezonesidkey='America/Los_Angeles', username=geo+'@noemail.com',firstName= 'fn'+geo);
        
        try{
            insert partnerUser;
        }
        catch(exception e){
            
        }
        return partnerUser;        

    }
    
    public static User createPartnerUserDisti(){        
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner User with Sales Tools'];
        insertRecordtypes(); //samap01        
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        ac.Solution_Provider_Type__c = 'Distributor';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        
        User partnerUser = new User(alias = 'test123D', email='test123Disti@gsmail.com',emailencodingkey='UTF-8',
                                    lastname='TestingDisti', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,ContactId = con.Id,
                                    timezonesidkey='America/Los_Angeles', username='testerDisti@noemail.com',firstName= 'testDisti');
        
        try{
            insert partnerUser;
        }
        catch(exception e){
            
        }
        return partnerUser;        
    }
    
    public static Opportunity createTestOpp(String oppType){
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        String currencyIsoCode = 'USD';
       // insertRecordtypes(); //samap01
        Id recid = SystemIdUtility.getResellerDistRecordTypeId();        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();    //samap01   //RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c; 
        System.debug('SMBRecTypeId:'+SMBRecTypeId);
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
        //Test.Starttest();
        insert resellerAcct; 
       
        System.debug('resellerAcct:'+resellerAcct.Id);
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct; 
        // Test.Stoptest(); 
        System.debug('smbAcct:'+smbAcct.Id);
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Oppty';
        if(oppType == '2 Tier') opp.What_is_your_Role__c = 'Reseller';
      
        
        opp.Did_the_deal_originate_from_a_campaign__c = 'Yes';
        opp.AccountId = smbAcct.Id;
        opp.Reseller__c= resellerAcct.Id;
        opp.Closedate = System.today();
        opp.StageName = Label.Opp_Stage_10_Percent;
        opp.CurrencyIsoCode = currencyIsoCode;
        opp.RecordTypeId = recopp.Id;
        opp.Type =  oppType;//'1 Tier';
        insert opp;
        System.debug('opp:'+opp.Id);
        return opp;
    }  
    
    public static PriceBook2 getPriceBook2(){
      Pricebook2 customPB = new Pricebook2 (name = 'Test Price bookOP', Description = 'desc', isactive = true);
      insert customPB;
      // Id = Test.getStandardPricebookId();
       Pricebook2 pbook = [select id from Pricebook2 where isactive = true  limit 1];       
       return pbook;
    }
    
    public static List<Product2> createProducts(){
        List<Product2> prodList = new List<Product2>();        
        prodList.add(new Product2(Name = 'Test Product1', Market_Focus_Area__c = 'SA', Family = 'Product', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));
        prodList.add(new Product2(Name = 'Test Product10', Market_Focus_Area__c = 'VSA', Family = 'Support', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));
        prodList.add(new Product2(Name = 'Test Product13', Market_Focus_Area__c = 'PPM', Family = 'Services', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));
        prodList.add(new Product2(Name = 'Test Product19', Market_Focus_Area__c = 'SEC', Family = 'Education', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));
        prodList.add(new Product2(Name = 'Test Product17', Market_Focus_Area__c = 'MAINFRAME', Family = 'Renewal', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));        
        prodList.add(new Product2(Name = 'Test Product16', Market_Focus_Area__c = 'MAINFRAME', Family = 'Renewal', ProductCode = 'testProdCode1',Commissionable_BU__c='AC' ,Upfront_Revenue_Eligible__c='No'));  
         prodList.add(new Product2(Name = 'Test Product15', Market_Focus_Area__c = 'MAINFRAME', Family = 'Time', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));        
        prodList.add(new Product2(Name = 'Test Product14', Market_Focus_Area__c = 'MAINFRAME', Family = 'Time', ProductCode = 'testProdCode1',Commissionable_BU__c='AC' ,Upfront_Revenue_Eligible__c='No'));  
       
         prodList.add(new Product2(Name = 'Test Product11', Market_Focus_Area__c = 'MAINFRAME', Family = 'Mainframe Capacity', ProductCode = 'testProdCode1',Commissionable_BU__c='AC'));        
        prodList.add(new Product2(Name = 'Test Product12', Market_Focus_Area__c = 'MAINFRAME', Family = 'Mainframe Capacity', ProductCode = 'testProdCode1',Commissionable_BU__c='AC' ,Upfront_Revenue_Eligible__c='No'));  
       
    
        insert prodList;
        return prodList;
  }
    
    public static List<Pricebookentry> createPriceBookEntryList(){
        String currencyIsoCode = 'USD';
        Id pbeId= Test.getStandardPricebookId();
        Pricebook2 customPB = Test_CreateOpportunity.getPriceBook2();
        List<Product2> productList = Test_CreateOpportunity.createProducts();
        
        List<Pricebookentry> priceBookEntryList = new List<Pricebookentry>();        
        priceBookEntryList.add( new Pricebookentry(
            pricebook2Id = pbeId,//customPB.Id,
            Product2Id = productList[0].Id,
            UnitPrice = 0.0,
            Isactive = true,
            CurrencyIsoCode = CurrencyIsoCode,
            UseStandardPrice = false));
        
        priceBookEntryList.add( new Pricebookentry(
            pricebook2Id = pbeId,//customPB.Id,
            Product2Id = productList[1].Id,
            UnitPrice = 0.0,
            Isactive = true,
            CurrencyIsoCode = CurrencyIsoCode,
            UseStandardPrice = false));
        
        priceBookEntryList.add( new Pricebookentry(
            pricebook2Id = pbeId,//customPB.Id,
            Product2Id = productList[2].Id,
            UnitPrice = 0.0,
            Isactive = true,
            CurrencyIsoCode = CurrencyIsoCode,
            UseStandardPrice = false));
        
        priceBookEntryList.add( new Pricebookentry(
            pricebook2Id = pbeId,//customPB.Id,
            Product2Id = productList[3].Id,
            UnitPrice = 0.0,
            Isactive = true,
            CurrencyIsoCode = CurrencyIsoCode,
            UseStandardPrice = false));
        
        priceBookEntryList.add( new Pricebookentry(
            pricebook2Id = pbeId,//customPB.Id,
            Product2Id = productList[4].Id,
            UnitPrice = 0.0,
            Isactive = true,
            CurrencyIsoCode = CurrencyIsoCode,
            UseStandardPrice = false));
        //samap01
        priceBookEntryList.add( new Pricebookentry(
            pricebook2Id = pbeId,//customPB.Id,
            Product2Id = productList[5].Id,
            UnitPrice = 0.0,
            Isactive = true,
            CurrencyIsoCode = CurrencyIsoCode,
            UseStandardPrice = false));
          
        insert priceBookEntryList;
         System.debug('priceBookEntryList:'+priceBookEntryList);
         return priceBookEntryList;
    }
    
    public static List<OpportunityLineItem> createOpportunityLineItemList(Id oppId){
        
        List<PricebookEntry> priceBookEntryList = Test_CreateOpportunity.createPriceBookEntryList();       
        
        List<OpportunityLineItem> optyLineItemList = new List<OpportunityLineItem>();
        
        optyLineItemList.add(new OpportunityLineItem(OPPORTUNITYID = oppId,QUANTITY = 1,
                                                     PRICEBOOKENTRYID = priceBookEntryList[0].Id,
                                                     UNITPRICE = 6000000,                               
                                                     BUSINESS_TYPE__C = 'Capacity',Deal_Registration__c = 'Yes'
                                                    ));
        optyLineItemList.add(new OpportunityLineItem(OPPORTUNITYID = oppId,QUANTITY = 1,
                                                     PRICEBOOKENTRYID = priceBookEntryList[1].Id,
                                                     UNITPRICE = 6000000,                               
                                                     BUSINESS_TYPE__C = 'Capacity',Deal_Program_Eligibility_Status__c = 'Sepearte Program',
                                                      Partner_Term__c =36
                                                    ));
        optyLineItemList.add(new OpportunityLineItem(OPPORTUNITYID = oppId,QUANTITY = 1,
                                                     PRICEBOOKENTRYID = priceBookEntryList[2].Id,
                                                     UNITPRICE = 6000000,                               
                                                     BUSINESS_TYPE__C = 'Capacity',
                                                      Partner_Term__c =24
                                                    ));
        optyLineItemList.add(new OpportunityLineItem(OPPORTUNITYID = oppId,QUANTITY = 1,
                                                     PRICEBOOKENTRYID = priceBookEntryList[3].Id,
                                                     UNITPRICE = 6000000,                               
                                                     BUSINESS_TYPE__C = 'Capacity',
                                                      Partner_Term__c =24                                                   ));
        optyLineItemList.add(new OpportunityLineItem(OPPORTUNITYID = oppId,QUANTITY = 1,
                                                     PRICEBOOKENTRYID = priceBookEntryList[4].Id,
                                                     UNITPRICE = 6000000,                               
                                                     BUSINESS_TYPE__C = 'Capacity',
                                                     Partner_Term__c =48
                                                    ));        
        insert optyLineItemList;
        System.debug('optyLineItemList:'+optyLineItemList);
        return optyLineItemList;
    }
    
    static testMethod void testOpplineRemoteActions_PRM(){
        User pUser = Test_CreateOpportunity.createPartnerUser();
        System.runAs(pUser){
           
            Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');
           
            System.debug('Opportunity :'+opp);
            //Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);
        }
           
    }

     public static Opportunity createTestOpppartner(String oppType){
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        String currencyIsoCode = 'USD';
       // insertRecordtypes(); //samap01
        Id recid = SystemIdUtility.getResellerDistRecordTypeId();        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();    //samap01   //RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c; 
        System.debug('SMBRecTypeId:'+SMBRecTypeId);
        Contact con=new Contact();
         con.lastname='Test Con';
         con.Email='s@b.com';
         insert con;
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
        //Test.Starttest();
        insert resellerAcct; 
        Account  xspacc= new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc3',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');
        System.debug('resellerAcct:'+resellerAcct.Id);
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct; 
        // Test.Stoptest(); 
        System.debug('smbAcct:'+smbAcct.Id);
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
         System.debug('recopp---'+recopp);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Oppty';
        if(oppType == 'Resell with a distributor') opp.What_is_your_Role__c = 'Reseller';
        if(oppType == 'Resell with a distributor'){
            opp.Type='2 Tier';
        }else if(oppType == 'Resell without a distributor'){
            opp.Type='1 Tier';
        }else if(oppType == 'Service Provider/Licensee'){
            opp.Type='xSP';
            opp.Service_Provider_Client__c=xspacc.id;
            opp.Cloud_Platform__c='Cloud Service Delivery Platform';
        }
        
        opp.Did_the_deal_originate_from_a_campaign__c = 'Yes';
        opp.AccountId = smbAcct.Id;
         opp.End_User_Contact__c=con.Id;
        opp.Reseller__c= resellerAcct.Id;
        opp.Closedate = System.today();
        opp.StageName = Label.Opp_Stage_10_Percent;
        opp.CurrencyIsoCode = currencyIsoCode;
        opp.RecordTypeId = recopp.Id;
        //opp.Type =  oppType;//'1 Tier';
        insert opp;
        System.debug('opp:'+opp.Id);
        return opp;
    }
    public static Opportunity createTestOpppartnerEXT(String oppType){
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        String currencyIsoCode = 'USD';
       // insertRecordtypes(); //samap01
        Id recid = SystemIdUtility.getResellerDistRecordTypeId();        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();    //samap01   //RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c; 
        System.debug('SMBRecTypeId:'+SMBRecTypeId);
        Contact con=new Contact();
         con.lastname='Test Con';
         con.Email='s@b.com';
         insert con;
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
        //Test.Starttest();
        insert resellerAcct; 
        Account  xspacc= new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc3',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,Service_Provider__c = true,
                                           Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                           Service_Provider_CAM_PMFKey__c = 'ABCDE01',Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');
        System.debug('resellerAcct:'+resellerAcct.Id);
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct; 
        // Test.Stoptest(); 
        System.debug('smbAcct:'+smbAcct.Id);
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
         System.debug('recopp---'+recopp);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Oppty';
        if(oppType == 'Resell with a distributor') opp.What_is_your_Role__c = 'Reseller';
        if(oppType == 'Resell with a distributor'){
            opp.Type='2 Tier';
        }else if(oppType == 'Resell without a distributor'){
            opp.Type='1 Tier';
        }else if(oppType == 'Service Provider/Licensee'){
            opp.Type='xSP';
            opp.Service_Provider_Client__c=xspacc.id;
            opp.Cloud_Platform__c='Cloud Service Delivery Platform';
        }
        
        opp.Did_the_deal_originate_from_a_campaign__c = 'Yes';
        opp.AccountId = smbAcct.Id;
         opp.End_User_Contact__c=con.Id;
        opp.Reseller__c= resellerAcct.Id;
        opp.Closedate = System.today();
        opp.StageName = Label.Opp_Stage_10_Percent;
        opp.CurrencyIsoCode = currencyIsoCode;
        opp.RecordTypeId = recopp.Id;
        //opp.Type =  oppType;//'1 Tier';
        //insert opp;
        System.debug('opp:'+opp.Id);
        return opp;
    } 
    
}