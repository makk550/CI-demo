@isTest
private class AutoPartnerAssignmentTests {
 
    // basic test scenario
    static testMethod void testPreferredPartnerAssignmentScenario1() {
                    
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true; 
                
        //String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        RecordTypes_Setting__c indLeadRecType = RecordTypes_Setting__c.getValues('CA Indirect Lead');
        String RecordTypeId = indLeadRecType.RecordType_Id__c;
                
        Account testAcc = new Account();
        testAcc.Name = 'testAcc';
        testAcc.Lead_Rating__c = 'B';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        testAcc.Reseller_Type__c = 'ISBU';
        testAcc.CPMS_ID__c = '1900';
        testAcc.BillingState = 'NY';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        testAcc.Commercial_ID__c =  '12';
        testAcc.Commercial_Account_Name__c = 'caName';
            
        insert testAcc;
        
        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
        
        Lead testLead = new Lead();
        testLead.LastName = 'John';
        testLead.FirstName = 'Kerry Mac';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.Lead_Rating__c = 'B';
        testLead.GEO__C = 'NA';
        testLead.Preferred_Reseller__c = '1900';
        testLead.RecordTypeId = RecordTypeId;
        testLead.MKT_BU_Category__c = 'ISBU';
        testLead.MKT_Solution_Set__c ='ISBU OTHER';
        //testLead.Product__c = 'Volume';
        //testLead.Opportunity_Deal_Type__c = 'IND-RMDM';
        
        insert testLead;
        
        Test.startTest();
        Test.stopTest();
    }
    
    // test scenario sans contact
    static testMethod void testPreferredPartnerAssignmentScenario2() {
                    
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true;
        
        //String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;

        RecordTypes_Setting__c indLeadRecType = RecordTypes_Setting__c.getValues('CA Indirect Lead');
        String RecordTypeId = indLeadRecType.RecordType_Id__c;
                        
        Account testAcc = new Account();
        testAcc.Name = 'testAcc';
        testAcc.Lead_Rating__c = 'B';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.CPMS_ID__c = '1900';
        testAcc.BillingState = 'NY';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        testAcc.Commercial_ID__c =  '12';
        testAcc.Commercial_Account_Name__c = 'caName';
            
        insert testAcc;
        
        Lead testLead = new Lead();
        testLead.LastName = 'John';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.Lead_Rating__c = 'B';
        testLead.GEO__C = 'NA';
        testLead.Preferred_Reseller__c = '1900';
        testLead.RecordTypeId = RecordTypeId;
        testLead.Product__c = 'Value';
        testLead.MKT_BU_Category__c = 'MAINFRAME';
        testLead.MKT_Solution_Set__c ='DB2 TOOLS';
        insert testLead;
        
        Test.startTest();
        Test.stopTest();
    }
    
    // test scenario for auto assignment
    static testMethod void testPreferredPartnerAssignmentScenario3() {      
            
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true;
        
        String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        String RecordTypeId2 = [Select Id from RecordType where Name = 'Reseller/Distributor Account'].Id;
        
        Account testAcc = new Account();
        testAcc.Name = 'testAcc';
        testAcc.RecordTypeId = RecordTypeId2;
        testAcc.Lead_Rating__c = 'B';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        testAcc.Program_Level__c = 'Platinum';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.Auto_Assignment_Enabled__c = true;
        testAcc.BillingState = 'NY';
        testAcc.CPMS_ID__c = '1900';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        insert testAcc;

        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
        
        Lead testLead = new Lead();
        testLead.LastName = 'John';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.GEO__C = 'NA';
        testLead.RecordTypeId = RecordTypeId;
        testLead.Product__c = 'Value';
        testLead.MKT_BU_Category__c = 'MAINFRAME';
        testLead.MKT_Solution_Set__c ='DB2 TOOLS';
        insert testLead;
        
        Test.startTest();
        Test.stopTest();
    }
    
    // test scenario for mass leads creation
    static testMethod void testPreferredPartnerAssignmentScenario4() {
    
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true;        
        String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        String RecordTypeId2 = [Select Id from RecordType where Name = 'Reseller/Distributor Account'].Id;
        
        Account testAcc = new Account();
        testAcc.Name = 'testAcc';
        testAcc.RecordTypeId = RecordTypeId2;
        testAcc.NCV_Driver__c = 'DCA';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.Auto_Assignment_Enabled__c = true;
        testAcc.Sales_Region__c = 'India';
        testAcc.BillingState = 'NY';
        testAcc.CPMS_ID__c = '1900';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        insert testAcc;

        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
        
        List<Lead> ldList = new List<Lead>();
        
        //mass creation of leads
        for(integer j=0;j<5;j++)
        {           
            Lead testLead = new Lead();
            testLead.LastName = 'Mary '+j;
            testLead.FirstName = 'Kerry';
            testLead.Company = 'XYZ';
            testLead.Status = 'Contacted';
            testLead.Lead_Rating__c = 'B';
            testLead.GEO__C = 'NA';
            testLead.RecordTypeId = RecordTypeId;
            testLead.Product__c = 'Value';
            testLead.MKT_BU_Category__c = 'MAINFRAME';
            testLead.MKT_Solution_Set__c ='DB2 TOOLS';
            ldList.add(testLead);           
        }

        for(integer j=0;j<5;j++)
        {           
            Lead testLead = new Lead();
            testLead.LastName = 'Sary '+j;
            testLead.FirstName = 'Marco';
            testLead.Company = 'XYZ';
            testLead.Status = 'Contacted';
            testLead.MKT_Solution_Set__c = 'DCIM';
            testLead.GEO__C = 'APJ';
            testLead.MKT_Territory__c = 'India';
            testLead.Product__c = 'Volume';
            testLead.MKT_BU_Category__c = 'RMDM';
            testLead.MKT_Solution_Set__c ='RM OTHER';           
            testLead.RecordTypeId = RecordTypeId;
            ldList.add(testLead);           
        }

                
        insert ldList;
        
        Test.startTest();
        Test.stopTest();
    }
    
    // test scenario for auto assignment
    static testMethod void testPreferredPartnerAssignmentScenario5() {
        
        String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        String RecordTypeId2 = [Select Id from RecordType where Name = 'Reseller/Distributor Account'].Id;
    
    
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true;        
    
        Account testAcc = new Account();
        testAcc.Name = 'testAcc';
        testAcc.RecordTypeId = RecordTypeId2;
        testAcc.Lead_Rating__c = 'B';
        testAcc.CPMS_ID__c = '1900';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.Auto_Assignment_Enabled__c = true;
        testAcc.BillingState = 'NY';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        insert testAcc;

        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
        
        Lead testLead = new Lead();
        testLead.LastName = 'JohnL';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.GEO__C = 'NA';
        testLead.Product__c = 'Value';
        testLead.MKT_BU_Category__c = 'MAINFRAME';
        testLead.MKT_Solution_Set__c ='DB2 TOOLS';      
        testLead.RecordTypeId = RecordTypeId;
        insert testLead;
        
        Test.startTest();
        Test.stopTest();
    }
    
    // test scenario for auto assignment, contains more than 1 matching account
    static testMethod void testPreferredPartnerAssignmentScenario6() {
        
        String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        String RecordTypeId2 = [Select Id from RecordType where Name = 'Reseller/Distributor Account'].Id;
    
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true;    
        
    
        Account testAcc = new Account();
        testAcc.Name = 'testAcc1';
        testAcc.RecordTypeId = RecordTypeId2;
        testAcc.Lead_Rating__c = 'B';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.Auto_Assignment_Enabled__c = true;
        testAcc.BillingState = 'NY';
        testAcc.CPMS_ID__c = '1900';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        insert testAcc;

        Account testAcc1 = new Account();
        testAcc1.Name = 'testAcc2';
        testAcc1.RecordTypeId = RecordTypeId2;
        testAcc1.Lead_Rating__c = 'B';
        testAcc1.Customer_Category__c = 'Reseller';
        testAcc1.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc1.Reseller_Type__c = 'Value';
        testAcc1.Auto_Assignment_Enabled__c = true;
        testAcc1.BillingState = 'NY';
        testAcc1.CPMS_ID__c = '1900';
        testAcc1.Reseller_Disti_Regional_ID__c = '12';
        testAcc1.Reseller_Distributor_Name__c = 'rdName';
        insert testAcc1;

        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
        
        Lead testLead = new Lead();
        testLead.LastName = 'JohnX';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.GEO__C = 'NA';
        testLead.Lead_Rating__c = 'B';
        testLead.RecordTypeId = RecordTypeId;
        testLead.MKT_BU_Category__c = 'ISBU';
        testLead.MKT_Solution_Set__c ='ISBU OTHER';
        try{        
        insert testLead;
        }catch(Exception e){}
        Test.startTest();
        Test.stopTest();
    }   

    // test scenario for auto assignment, contains more than 1 matching account but none available
    static testMethod void testPreferredPartnerAssignmentScenario7() {
        
        String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        String RecordTypeId2 = [Select Id from RecordType where Name = 'Reseller/Distributor Account'].Id;
    
        // creating a test partner assignment rule, just incase if there are no preconfigured rules already
        Indirect_BU_Partner_Assignment_Mapping__c pam = new Indirect_BU_Partner_Assignment_Mapping__c();
        pam.Name = 'testRule1';
        pam.Aligned_CAM__c = true;
        pam.Auto_Assign_Partner__c = true;
        pam.Auto_Assign_Preferred_Partner__c = true;
        pam.Lead_Rating__c = 'B';
        pam.MKT_BU__c = 'Value';
        pam.MKT_NCV_Driver__c = true;
        pam.Program_Level__c = 'Platinum';
        pam.Region__c = 'NA';
        pam.Territory__c = true;    
        
    
        Account testAcc = new Account();
        testAcc.Name = 'testAcc1';
        testAcc.RecordTypeId = RecordTypeId2;
        testAcc.Lead_Rating__c = 'B';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.Auto_Assignment_Enabled__c = true;
        testAcc.Received_Last_Lead__c = true;
        testAcc.BillingState = 'NY';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        testAcc.CPMS_ID__c = '1900';
        insert testAcc;

        Account testAcc1 = new Account();
        testAcc1.Name = 'testAcc2';
        testAcc1.RecordTypeId = RecordTypeId2;
        testAcc1.Lead_Rating__c = 'B';
        testAcc1.Customer_Category__c = 'Reseller';
        testAcc1.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc1.Reseller_Type__c = 'Value';
        testAcc1.Auto_Assignment_Enabled__c = true;
        testAcc1.Received_Last_Lead__c = false;
        testAcc1.BillingState = 'NY';
        testAcc1.Reseller_Disti_Regional_ID__c = '12';
        testAcc1.Reseller_Distributor_Name__c = 'rdName';
        testAcc1.CPMS_ID__c = '1900';
        insert testAcc1;

        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
        
        Lead testLead = new Lead();
        testLead.LastName = 'JohnZ';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.GEO__C = 'NA';
        testLead.Lead_Rating__c = 'B';
        testLead.RecordTypeId = RecordTypeId;
        testLead.Product__c = 'Value';
        testLead.MKT_BU_Category__c = 'MAINFRAME';
        testLead.MKT_Solution_Set__c ='DB2 TOOLS';      
        insert testLead;
        
        AutoPartnerAssignment apa = new AutoPartnerAssignment(null);
        Test.startTest();
        apa.sendEmail();
        Test.stopTest();
    }
    
    // test scenario for auto assignment - country,NCV driver match
    static testMethod void testPreferredPartnerAssignmentScenario8() {
        
        String RecordTypeId = [Select Id from RecordType where Name = 'CA Indirect Lead'].Id;
        
        String RecordTypeId2 = [Select Id from RecordType where Name = 'Reseller/Distributor Account'].Id;

        Account testAcc = new Account();
        testAcc.Name = 'testAcc1';
        testAcc.RecordTypeId = RecordTypeId2;
        testAcc.Lead_Rating__c = 'B';
        testAcc.Customer_Category__c = 'Reseller';
        testAcc.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc.Reseller_Type__c = 'Value';
        testAcc.Auto_Assignment_Enabled__c = true;
        testAcc.BillingState = 'NY';
        testAcc.Reseller_Disti_Regional_ID__c = '12';
        testAcc.Reseller_Distributor_Name__c = 'rdName';
        testAcc.Lead_Country__c = 'US - United States';
        testAcc.Lead_Territory__c = 'France';
        testAcc.NCV_Driver__c = 'Mainframe';
        testAcc.Lead_Rating__c = 'B';
        testAcc.CPMS_ID__c = '1900';
        insert testAcc;
        
        Account testAcc1 = new Account();
        testAcc1.Name = 'testAcc1';
        testAcc1.RecordTypeId = RecordTypeId2;
        testAcc1.Lead_Rating__c = 'B';
        testAcc1.Customer_Category__c = 'Reseller';
        testAcc1.Account_Status__c = 'Approved';
        //testAcc.Program_Level__c = 'Platinum';
        testAcc1.Reseller_Type__c = 'RMDM';
        testAcc1.Auto_Assignment_Enabled__c = true;
        testAcc1.BillingState = 'NY';
        testAcc1.Reseller_Disti_Regional_ID__c = '12';
        testAcc1.Reseller_Distributor_Name__c = 'rdName';
        testAcc1.Lead_Country__c = 'US - United States';
        testAcc1.Lead_Territory__c = 'India';
        testAcc1.NCV_Driver__c = 'Mainframe';
        testAcc1.Lead_Rating__c = 'B';
        testAcc1.CPMS_ID__c = '1900';
        insert testAcc1;


        Contact testCont = new Contact();
        testCont.LastName = 'John';
        testCont.FirstName = 'Kerry';
        testCont.AccountId = testAcc.Id;
        testCont.Primary__c = true;
        insert testCont;
    
        List<Contact> contList = [Select Name from Contact where AccountId = : testAcc1.Id];
        
        System.debug(logginglevel.Debug,'From test class : '+contList+' , '+testAcc1.Id);   
    
        Lead testLead = new Lead();
        testLead.LastName = 'JohnBMW';
        testLead.FirstName = 'Kerry';
        testLead.Company = 'XYZ';
        testLead.Status = 'Contacted';
        testLead.GEO__C = 'NA';
        testLead.RecordTypeId = RecordTypeId;
        testLead.Product__c = 'Value';
        testLead.MKT_BU_Category__c = 'MAINFRAME';
        testLead.MKT_Solution_Set__c ='Mainframe';
        testLead.Country = 'US';
        testLead.MKT_Territory__c = 'France';
        testLead.Lead_Rating__c = 'B';      
        insert testLead;

        Lead testLead1 = new Lead();
        testLead1.LastName = 'JohnBMW1';
        testLead1.FirstName = 'Kerry1';
        testLead1.Company = 'XYZ1';
        testLead1.Status = 'Contacted';
        testLead1.GEO__C = 'APJ';
        testLead1.RecordTypeId = RecordTypeId;
        testLead1.Product__c = 'Volume';
        testLead1.MKT_BU_Category__c = 'RMDM';
        testLead1.MKT_Solution_Set__c ='RM OTHER';
        testLead1.Country = 'US';
        testLead1.MKT_Territory__c = 'India';
        testLead1.Lead_Rating__c = 'B';     
        insert testLead1;
    }   
}