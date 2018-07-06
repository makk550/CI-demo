// test coverage class for the lead conversion & opp. updation related
// triggers and apex code.
@istest
public class AutoLeadConversionTests {

    // scenario : insert lead without populate commercial / volume customer accounts
    @isTest(SeeAllData=true)
    static void testScenario1_AggMapping() { 

        
        //create a test commercial acc.
        Account acct = new Account();
        acct.Name = 'testAcc1';
        acct.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acct.Country_Picklist__c = 'INDIA';
        acct.GEO__c = 'NA';
        acct.Account_Status__c = 'Approved';
        acct.Aggregate_Account__c = 'Yes';
        acct.Customer_Category__c = 'Commercial';
        acct.Commercial_Account_Name__c = 'commAcc';
        acct.Commercial_ID__c = 'commId';
        acct.Global_ID__c = 'globId';
        acct.Global_Name__c = 'globName';
        insert acct;
        
        //create a test reseller acc.
        Account acct1 = new Account();
        acct1.Name = 'testAcc2';
        acct1.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        acct1.Country_Picklist__c = 'INDIA';
        acct1.GEO__c = 'NA';
        acct1.Account_Status__c = 'Approved';
        acct1.Aggregate_Account__c = 'Yes';
        acct1.Customer_Category__c = 'Reseller';
        acct1.Reseller_Disti_Regional_ID__c = 'id1';
        acct1.Reseller_Distributor_Name__c = 'rdName';
        acct1.Reseller_Type__c = 'RMDM';
        acct1.CPMS_ID__c = '100';
        insert acct1;
        
        
        //populate agg. acct map with test data
        Aggregate_Account_Map__c aggAccMap = new Aggregate_Account_Map__c();
        aggAccMap.Aggregate_Account__c = acct.Id;
        aggAccMap.Region__c = 'NA';
        aggAccMap.BU__c = 'RMDM';
        insert aggAccMap;   
                    
        Test.startTest();
                    
        //create the lead
        Lead ld = new Lead();
        ld.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld.LastName = 'Kelly-2222';
        ld.Company = 'Microsoft';
        ld.Status = 'Contacted';
        ld.GEO__c = 'NA';
        ld.MKT_BU_Category__c = 'RMDM';
        ld.Product__c = 'Volume';
        ld.Reseller__c = acct1.Id;
        ld.Reseller_Milestone__c = '10% - Discovery & Assessment';
        //Req 537 Starts 
        //Following code added for Code coverage of Update_OpportunityOnLeadConversion_trigger
        //Products list added to lead
        //IDC Pune Balasaheb Wani 
        Product2[] Prds=[Select Id from Product2 where IsActive =true  Limit 5 ];
        System.debug('Products List======'+Prds);
        ld.Product__c=Prds[0].Id+':12='+Prds[1].Id+':24='+Prds[2].Id+':45';
        //Req 537 ENDS******************
        try{insert ld;
            }
        catch(exception e)
        {
        }    
        Test.stopTest();
        
    }

    // scenario : insert lead with volume customer populated
    @isTest(SeeAllData=true)
    static void testScenario2_VolumeCustomer() {
        //create a test commercial acc.
        Account acct = new Account();
        acct.Name = 'testAcc3';
        acct.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acct.Country_Picklist__c = 'INDIA';
        acct.GEO__c = 'NA';
        acct.Account_Status__c = 'Approved';
        acct.Aggregate_Account__c = 'Yes';
        acct.Customer_Category__c = 'Commercial';
        acct.Commercial_Account_Name__c = 'commAcc';
        acct.Commercial_ID__c = 'commId';
        acct.Global_ID__c = 'globId';
        acct.Global_Name__c = 'globName';
        insert acct;

        //create a test reseller acc.
        Account acct1 = new Account();
        acct1.Name = 'testAcc4';
        acct1.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        acct1.Country_Picklist__c = 'INDIA';
        acct1.GEO__c = 'NA';
        acct1.Account_Status__c = 'Approved';
        acct1.Aggregate_Account__c = 'Yes';
        acct1.Customer_Category__c = 'Reseller';
        acct1.Reseller_Disti_Regional_ID__c = 'id1';
        acct1.Reseller_Distributor_Name__c = 'rdName';
        acct1.Reseller_Type__c = 'RMDM';
        acct1.CPMS_ID__c = '100';
        insert acct1;

        
        //create a test volume customer
        Volume_Customer__c vc = new Volume_Customer__c();
        vc.Account__c = acct.Id;
        vc.State__c = 'NY - New York';
        vc.Name = 'VC Name';
        insert vc;
        
        Test.startTest();
                    
        //create a volume lead
        Lead ld = new Lead();
        ld.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld.LastName = 'John';
        ld.Company = 'Microsoft';
        ld.Status = 'Contacted';
        ld.GEO__c = 'NA';
        ld.MKT_BU_Category__c = 'RMDM';
        ld.Product__c = 'Volume';
        ld.Reseller__c = acct1.Id;
        ld.Volume_Customer__c = vc.Id;
        ld.Reseller_Milestone__c = '10% - Discovery & Assessment'; 
        try{    
        insert ld;
        }
        catch(exception e)
        {
        }
        System.debug(logginglevel.Debug,'test print 1 : '+ld.BU__c+','+vc.Name);

        Test.stopTest();

        
    }   

    // scenario : insert lead with volume customer populated
    @isTest(SeeAllData=true)
    static void testScenario3_VolumeCustomer() {
                
        //Query the necessary recordTypeIds
        List<RecordType> RecordTypeIds = [Select Id,Name from RecordType where Name = 'CA Indirect Lead' or Name = 'Reseller/Distributor Account'];
        Id indirLeadRecType;
        Id resellerDistAcctRecType;
        for(RecordType rt:RecordTypeIds) {
            if(rt.Name == 'CA Indirect Lead')
                indirLeadRecType = rt.Id;
            else if(rt.Name == 'Reseller/Distributor Account')
                resellerDistAcctRecType = rt.Id;    
        }   
        
        //create a test commercial acc.
        Account acct = new Account();
        acct.Name = 'testAcc3';
        acct.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acct.Country_Picklist__c = 'INDIA';
        acct.GEO__c = 'NA';
        acct.Account_Status__c = 'Approved';
        acct.Aggregate_Account__c = 'No';
        acct.Customer_Category__c = 'Commercial';
        acct.Commercial_Account_Name__c = 'commAcc';
        acct.Commercial_ID__c = 'commId';
        acct.Global_ID__c = 'globId';
        acct.Global_Name__c = 'globName';
        insert acct;

        //create a test reseller acc.
        Account acct1 = new Account();
        acct1.Name = 'testAcc4';
        acct1.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        acct1.Country_Picklist__c = 'INDIA';
        acct1.GEO__c = 'NA';
        acct1.Account_Status__c = 'Approved';
        acct1.Aggregate_Account__c = 'Yes';
        acct1.Customer_Category__c = 'Reseller';
        acct1.Reseller_Disti_Regional_ID__c = 'id1';
        acct1.Reseller_Distributor_Name__c = 'rdName';
        acct1.Reseller_Type__c = 'Value';
        acct1.CPMS_ID__c = '100';
        acct1.Primary_Designation_Reseller__c = 'Tets';
        insert acct1;
        
        //create a test contact
        Contact c = new Contact();
        c.LastName = 'Jerry';
        c.AccountId = acct.Id;  
        insert c;
        
        Test.startTest();
                    
        //create a commercial lead
        Lead ld1 = new Lead();
        ld1.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld1.LastName = 'Kerry';
        ld1.Company = 'Google Inc.';
        ld1.Status = 'Contacted';
        ld1.GEO__c = 'NA';
        ld1.MKT_BU_Category__c = 'Automation';
        ld1.Product__c = 'Value';
        ld1.Account_Contact__c = c.Id;
        ld1.Reseller__c = acct1.Id;
        ld1.Commercial_Account__c = acct.Id;
        ld1.Reseller_Milestone__c = '10% - Discovery & Assessment';    
        try{
        insert ld1;
        }
        catch(exception e)
        {
        }
        Test.stopTest();
        
    }   

    // scenario : Lead with only email address populated
    @isTest(SeeAllData=true)
    static void testScenario4_VolumeCustomer() {
        //Query the necessary recordTypeIds
        List<RecordType> RecordTypeIds = [Select Id,Name from RecordType where Name = 'CA Indirect Lead' or Name = 'Reseller/Distributor Account'];
        Id indirLeadRecType;
        Id resellerDistAcctRecType;
        for(RecordType rt:RecordTypeIds) {
            if(rt.Name == 'CA Indirect Lead')
                indirLeadRecType = rt.Id;
            else if(rt.Name == 'Reseller/Distributor Account')
                resellerDistAcctRecType = rt.Id;    
        }   
        
        //create a test commercial acc.
        Account acct = new Account();
        acct.Name = 'testAcc3';
        acct.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acct.Country_Picklist__c = 'INDIA';
        acct.GEO__c = 'NA';
        acct.Account_Status__c = 'Approved';
        acct.Aggregate_Account__c = 'Yes';
        acct.Customer_Category__c = 'Commercial';
        acct.Commercial_Account_Name__c = 'commAcc';
        acct.Commercial_ID__c = 'commId';
        acct.Global_ID__c = 'globId';
        acct.Global_Name__c = 'globName';
        insert acct;

        //create a test reseller acc.
        Account acct1 = new Account();
        acct1.Name = 'testAcc4';
        acct1.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        acct1.Country_Picklist__c = 'INDIA';
        acct1.GEO__c = 'NA';
        acct1.Account_Status__c = 'Approved';
        acct1.Aggregate_Account__c = 'Yes';
        acct1.Customer_Category__c = 'Reseller';
        acct1.Reseller_Disti_Regional_ID__c = 'id1';
        acct1.Reseller_Distributor_Name__c = 'rdName';
        acct1.Reseller_Type__c = 'RMDM';
        acct1.CPMS_ID__c = '100';
        insert acct1;

        //create a test volume customer
        Volume_Customer__c vc = new Volume_Customer__c();
        vc.Account__c = acct.Id;
        vc.State__c = 'NY - New York';
        vc.Name = 'VC Name';
        insert vc;
        
        //create a test contact
        Contact c = new Contact();
        c.LastName = 'Jerry';
        c.AccountId = acct.Id;
        c.Email = 'test@sfdc.com';
        c.Volume_Customer__c = vc.Id;   
        insert c;
        
        Test.startTest();
                    
        //create a commercial lead
        Lead ld1 = new Lead();
        ld1.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld1.LastName = 'Kerry';
        ld1.Company = 'Google Inc.';
        ld1.Status = 'Contacted';
        ld1.GEO__c = 'NA';
        ld1.MKT_BU_Category__c = 'Automation';
        ld1.Product__c = 'Volume';
        ld1.Reseller__c = acct1.Id;
        ld1.Email = 'test@sfdc.com';
        ld1.MKT_BU_Category__c = 'RMDM';
        ld1.Reseller_Milestone__c = '10% - Discovery & Assessment';     
        try{
        insert ld1;
        }
        catch(exception e)
        {
        }

        Test.stopTest();
    }   

    // scenario : Aggregate account driven scenarios
    @isTest(SeeAllData=true)
    static void testScenario5_AggMapping() { 

        //Query the necessary recordTypeIds
        List<RecordType> RecordTypeIds = [Select Id,Name from RecordType where Name = 'CA Indirect Lead' or Name = 'Reseller/Distributor Account'];
        Id indirLeadRecType;
        Id resellerDistAcctRecType;
        for(RecordType rt:RecordTypeIds) {
            if(rt.Name == 'CA Indirect Lead')
                indirLeadRecType = rt.Id;
            else if(rt.Name == 'Reseller/Distributor Account')
                resellerDistAcctRecType = rt.Id;    
        }   
        
        List<Account> lstAccount = new List<Account>();
        
        //create a test commercial acc.
        Account acct = new Account();
        acct.Name = 'testAcc1';
        acct.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        acct.Country_Picklist__c = 'INDIA';
        acct.GEO__c = 'NA';
        acct.Account_Status__c = 'Approved';
        acct.Aggregate_Account__c = 'Yes';
        acct.Customer_Category__c = 'Commercial';
        acct.Commercial_Account_Name__c = 'commAcc';
        acct.Commercial_ID__c = 'commId';
        acct.Global_ID__c = 'globId';
        acct.Global_Name__c = 'globName';
        //insert acct;
        lstAccount.add(acct);
        
        //create a test reseller acc.
        Account acct1 = new Account();
        acct1.Name = 'testAcc2';
        acct1.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        acct1.Country_Picklist__c = 'INDIA';
        acct1.GEO__c = 'NA';
        acct1.Account_Status__c = 'Approved';
        acct1.Aggregate_Account__c = 'Yes';
        acct1.Customer_Category__c = 'Reseller';
        acct1.Reseller_Disti_Regional_ID__c = 'id1';
        acct1.Reseller_Distributor_Name__c = 'rdName';
        acct1.CPMS_ID__c = '100';
        acct1.Reseller_Type__c = 'RMDM';
        //insert acct1;
        lstAccount.add(acct1);
      
        //create a test reseller acc.
        Account acct2 = new Account();
        acct2.Name = 'testAcc2';
        acct2.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        acct2.Country_Picklist__c = 'INDIA';
        acct2.GEO__c = 'NA';
        acct2.Account_Status__c = 'Approved';
        acct2.Aggregate_Account__c = 'Yes';
        acct2.Customer_Category__c = 'Reseller';
        acct2.Reseller_Disti_Regional_ID__c = 'id1';
        acct2.Reseller_Distributor_Name__c = 'rdName';
        acct2.CPMS_ID__c = '100';
        acct2.Reseller_Type__c = 'ISBU';
        //insert acct2;
        lstAccount.add(acct2);
        
        
        insert   lstAccount;
        
        List<Aggregate_Account_Map__c> lstAggAccMap = new List<Aggregate_Account_Map__c>();
        
        //populate agg. acct map that has matching state
        Aggregate_Account_Map__c aggAccMap = new Aggregate_Account_Map__c();
        aggAccMap.Aggregate_Account__c = acct.Id;
        aggAccMap.Region__c = 'NA';
        aggAccMap.BU__c = 'RMDM';
        aggAccMap.State__c = 'Alaska';
        //insert aggAccMap;   
        lstAggAccMap.add(aggAccMap);
        
        //populate agg. acct map that has matching country
        Aggregate_Account_Map__c aggAccMap1 = new Aggregate_Account_Map__c();
        aggAccMap1.Aggregate_Account__c = acct.Id;
        aggAccMap1.Region__c = 'NA';
        aggAccMap1.BU__c = 'RMDM';
        aggAccMap1.Country__c = 'US';
        //insert aggAccMap1;  
        lstAggAccMap.add(aggAccMap1);
        
        
        //populate agg. acct map that has matching area
        Aggregate_Account_Map__c aggAccMap2 = new Aggregate_Account_Map__c();
        aggAccMap2.Aggregate_Account__c = acct.Id;
        aggAccMap2.Region__c = 'NA';
        aggAccMap2.BU__c = 'RMDM';
        aggAccMap2.MKT_Territory__c = 'Greater China';
        //insert aggAccMap2;  
         lstAggAccMap.add(aggAccMap2);
         
        //populate a agg. acct map with no state/country/territory
        Aggregate_Account_Map__c aggAccMap3 = new Aggregate_Account_Map__c();
        aggAccMap3.Aggregate_Account__c = acct.Id;
        aggAccMap3.Region__c = 'ISBU';
        aggAccMap3.BU__c = 'APJ';       
        //insert aggAccMap3;  
         lstAggAccMap.add(aggAccMap3);  
                    
        insert  lstAggAccMap;
                    
        Test.startTest();
        
        List<Lead> lstLead = new List<Lead>();
        
                    
        //create lead 1
        Lead ld = new Lead();
        ld.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld.LastName = 'Chelly';
        ld.Company = 'Microsoft';
        ld.Status = 'Contacted';
        ld.GEO__c = 'NA';
        ld.State = 'Alaska';
        ld.MKT_BU_Category__c = 'RMDM';
        ld.Product__c = 'Volume';
        ld.Reseller__c = acct1.Id;
        ld.Reseller_Milestone__c = '10% - Discovery & Assessment';
        try{      
           // insert ld;
            lstLead.add(ld); 
        }
        catch(exception e)
        {
        
        }
        //create lead 2
        Lead ld2 = new Lead();
        ld2.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld2.LastName = 'Bala';
        ld2.Company = 'Microsoft';
        ld2.Status = 'Contacted';
        ld2.GEO__c = 'NA';
        ld2.MKT_BU_Category__c = 'RMDM';
        ld2.Country = 'US';
        ld2.Product__c = 'Volume';
        ld2.Reseller__c = acct1.Id;
        ld2.Reseller_Milestone__c = '10% - Discovery & Assessment';  
        try{
        //insert ld2;
        lstLead.add(ld2); 
        }
        catch(exception e)
        {
        }

        //create lead 3
        Lead ld3 = new Lead();
        ld3.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld3.LastName = 'Suzanne';
        ld3.Company = 'Microsoft';
        ld3.Status = 'Contacted';
        ld3.GEO__c = 'NA';
        ld3.MKT_BU_Category__c = 'RMDM';
        ld3.MKT_Territory__c = 'Greater China';
        ld3.Product__c = 'Volume';
        ld3.Reseller__c = acct1.Id;
        ld3.Reseller_Milestone__c = '10% - Discovery & Assessment';     
        try{
        //insert ld3;
        lstLead.add(ld3); 
        }
        catch(exception e)
        {
        }
        
        //create lead 4
        Lead ld4 = new Lead();
        ld4.RecordTypeId = SystemIdUtility.getInDirLeadRecordTypeId();
        ld4.LastName = 'Mark';
        ld4.Company = 'Microsoft';
        ld4.Status = 'Contacted';
        ld4.GEO__c = 'APJ';
        ld4.MKT_BU_Category__c = 'ISBU';
        ld4.MKT_Territory__c = 'Greater China';
        ld4.Product__c = 'Volume';
        ld4.Reseller__c = acct2.Id;
        ld4.Reseller_Milestone__c = '10% - Discovery & Assessment';
        try{
            //insert ld4;
            lstLead.add(ld4); 
            }
        catch(exception e)
        {
        }    
        Test.stopTest();        
    }
}