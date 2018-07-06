@istest
public class MassLeadsAssignLookupTest {
    
    // test method for the account lookup functionality
    static testMethod void testMassLeadsAssignAccLookup() {
    
        String recordTypeId = [Select r.Id, r.Name from RecordType r where r.Name = 'Reseller/Distributor Account'].Id;

        //create the test account
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.Account_Status__c = 'Approved';
        acc.Sales_Region__c = 'EMEA';
        acc.Sales_Area__c = 'France';
        acc.Region_Country__c = 'FR';
        //acc.Enterprise_Customer_Name__c = 'ECN';
        acc.Enterprise_ID__c = 'EID';
        acc.BillingState = 'NY';        
        acc.Enterprise_Account_Name__c = 'Acc'; 
        acc.RecordTypeId = recordTypeId;
        acc.Reseller_Disti_Regional_ID__c = '12';
        acc.Reseller_Distributor_Name__c = 'rdName';        
        insert acc;             
        
        // create the test leads
        Lead ld = new Lead();
        ld.Company = 'CM';
        ld.LastName = 'Test';
        ld.Status = 'Untouched';
        insert ld;
        
        // set the page reference for accounts lookup
        PageReference pg = new PageReference('/apex/MassLeadsAssignLookup?obj=Acc');
        Test.setCurrentPage(pg);
        
        // Instantiate the Controller class
        MassLeadsAssignLookup massLookupControllerObj = new MassLeadsAssignLookup();
        MassLeadsAssignLookup.recordLimit = 1;
        // start the test
        Test.startTest();      
        massLookupControllerObj.init();
        massLookupControllerObj.getCol1Header();
        massLookupControllerObj.getCol1Visibility();
        massLookupControllerObj.getCol2Header();
        massLookupControllerObj.getCol2Visibility();
        massLookupControllerObj.getCol3Header();
        massLookupControllerObj.getCol3Visibility();
        massLookupControllerObj.getCol4Header();
        massLookupControllerObj.getCol4Visibility();
        massLookupControllerObj.getCol5Header();
        massLookupControllerObj.getCol5Visibility();
        massLookupControllerObj.getCol6Header();
        massLookupControllerObj.getCol6Visibility();
        massLookupControllerObj.getCol7Visibility();
        massLookupControllerObj.getCol7Header();
        massLookupControllerObj.getCol8Visibility();
        massLookupControllerObj.getCol8Header();
        massLookupControllerObj.getSearchAlertStr();
        massLookupControllerObj.getSearchResList();        
        
        //stop the test
        Test.stopTest();                            
    }
    
    // test method for the contact lookup functionality
    static testMethod void testMassLeadsAssignContLookup() {
    
        String recordTypeId = [Select r.Id, r.Name from RecordType r where r.Name = 'Reseller/Distributor Account'].Id;
    
        //create the test account
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.Account_Status__c = 'Approved';
        acc.Sales_Region__c = 'EMEA';
        acc.Sales_Area__c = 'France';
        acc.Region_Country__c = 'FR';
        //acc.Enterprise_Customer_Name__c = 'ECN';
        acc.Enterprise_ID__c = 'EID';
        acc.Enterprise_Account_Name__c = 'Acc'; 
        acc.RecordTypeId = recordTypeId;
        acc.BillingState = 'NY';
        acc.Reseller_Disti_Regional_ID__c = '12';
        acc.Reseller_Distributor_Name__c = 'rdName';                
        insert acc; 

        //create the test contact
        Contact c = new Contact();
        c.LastName = 'Jerry';
        c.AccountId = acc.Id;
        c.Language_Preference__c = 'English';
        insert c;   

        //create the test contact
        Contact c1 = new Contact();
        c1.LastName = 'Carl';
        c1.AccountId = acc.Id;
        c1.Language_Preference__c = 'English';
        insert c1;  
                
        //start the test
        Test.startTest();
        
        // set the page reference for contacts lookup
        PageReference pg1 = new PageReference('/apex/MassLeadsAssignLookup?obj=cont&acctId='+acc.Id);
        Test.setCurrentPage(pg1);
        
        // Instantiate the Controller class
        MassLeadsAssignLookup massLookupControllerObj1 = new MassLeadsAssignLookup();
        MassLeadsAssignLookup.recordLimit = 1;
        massLookupControllerObj1.init();
        //stop the test
        Test.stopTest();
    }   
    
    // test method for the partner site functionality
    static testMethod void testMassLeadsAssignPSiteLookup() {
    
        String recordTypeId = [Select r.Id, r.Name from RecordType r where r.Name = 'Reseller/Distributor Account'].Id;
    
        //create the test account
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.Account_Status__c = 'Approved';
        acc.Sales_Region__c = 'EMEA';
        acc.Sales_Area__c = 'France';
        acc.Region_Country__c = 'FR';
        //acc.Enterprise_Customer_Name__c = 'ECN';
        acc.Enterprise_ID__c = 'EID';
        acc.Enterprise_Account_Name__c = 'Acc'; 
        acc.RecordTypeId = recordTypeId;
        acc.BillingState = 'NY';
        acc.Reseller_Disti_Regional_ID__c = '12';
        acc.Reseller_Distributor_Name__c = 'rdName';                
        insert acc; 

        //start the test
        Test.startTest();
        
        // set the page reference for contacts lookup
        PageReference pg2 = new PageReference('/apex/MassLeadsAssignLookup?obj=pSite&acctId='+acc.Id);
        Test.setCurrentPage(pg2);
        
        // Instantiate the Controller class
        MassLeadsAssignLookup massLookupControllerObj2 = new MassLeadsAssignLookup();
        MassLeadsAssignLookup.recordLimit = 1;
        massLookupControllerObj2.init();
        massLookupControllerObj2.searchAction();
        massLookupControllerObj2.setColumnHeaders();
        massLookupControllerObj2.createSearchStr('a*');
        massLookupControllerObj2.createSearchStr('*');
        massLookupControllerObj2.resetVariables();

        //stop the test
        Test.stopTest();
    }
}