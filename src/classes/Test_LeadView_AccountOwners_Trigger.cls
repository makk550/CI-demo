/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_LeadView_AccountOwners_Trigger {

    static testMethod void testLeadView_AccountOwnersTrigger() 
    {
    	String CAGlobalLeadrecordTypeName = 'CA Global Lead';
    	Schema.DescribeSObjectResult leadRTDescribe = Schema.SObjectType.Lead;    
	    Map<String,Schema.RecordTypeInfo> leadRecTypeMap = leadRTDescribe.getRecordTypeInfosByName(); 
	    Id CAGlobalLeadRecordTypeId = leadRecTypeMap.get(CAGlobalLeadrecordTypeName).getRecordTypeId(); 
        String EAID = 'test1111';
        String EAID1 = 'test2222';
        List<Lead> leadList = new List<Lead>();
        List<Account> accountList = new List<Account>();
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Customer_Category__c = 'Partner';
        a.Account_Status__c = 'Submitted';
        a.Country_Picklist__c = 'US - UNITED STATES';
        a.Distributor_Type__c = 'Value';
        a.Enterprise_ID__c = EAID;
        a.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accountList.add(a);
        
        Account a1 = new Account();
        a1.Name = 'Test Account1';
        a1.Customer_Category__c = 'Partner';
        a1.Account_Status__c = 'Submitted';
        a1.Country_Picklist__c = 'US - UNITED STATES';
        a1.Distributor_Type__c = 'Value';
        a1.Enterprise_ID__c = EAID1;
        a1.RecordTypeId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
        accountList.add(a1);
        
        Database.Saveresult[] res = Database.insert(accountList);
        
    	
    	Lead l = new Lead();
    	l.lastName = 'Test Lead';
    	l.status = 'Untouched';
    	l.Company = 'CA';
    	l.EAID__c = EAID;
    	l.RecordTypeId = CAGlobalLeadRecordTypeId;
    	l.Commercial_Account__c = res[0].getId();
    	leadList.add(l);
    	
    	Lead l1 = new Lead();
    	l1.lastName = 'Test Lead1';
    	l1.status = 'Untouched';
    	l1.Company = 'CA';
    	l1.EAID__c = '';
    	l1.RecordTypeId = CAGlobalLeadRecordTypeId;
    	l1.Commercial_Account__c = res[1].getId();
    	leadList.add(l1);
    	
    	insert leadList;
    	
    	Lead updateLead = [SELECT Id, EAID__c from Lead WHERE Id =: leadList[0].Id];
    	updateLead.EAID__c = EAID1;
    	update updateLead;
    	
    }
}