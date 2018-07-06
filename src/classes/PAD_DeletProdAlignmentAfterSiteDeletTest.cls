/**
Class Name: PAD_DeletProdAlignmentAfterSiteDeletTest
Date: 1/3/2010
Project/Requirement: CA PRM R2/PLM
Author: Accenture
Description: This class is test class for PAD_DeletProdAlignmentAfterSiteDelet
*/

@isTest
private class PAD_DeletProdAlignmentAfterSiteDeletTest {
    
    	
	    static testMethod void testDeletSite(){  
	    
	    String partnerAccRecTypeId;
	    
	    //Inserting Partner and commnercial accounts
	    //getting account record types by using schema
	    Map<String,Schema.RecordTypeInfo> mapRecTypeInfoAcc = new Map<String,Schema.RecordTypeInfo>();
	    //retrive account object record types
	    mapRecTypeInfoAcc = Schema.SObjectType.Account.getRecordTypeInfosByName();
	    //get Ids of record type by passing name of record type.
	    Schema.RecordTypeInfo recTypeInfoPartner = mapRecTypeInfoAcc.get('Reseller/Distributor Account');
	    Schema.RecordTypeInfo recTypeInfoCommercial = mapRecTypeInfoAcc.get('SMB');
	    partnerAccRecTypeId = recTypeInfoPartner.getRecordTypeId();
	
		//Insert reseller account. 
		Account testPartnerAccount = new Account();
		testPartnerAccount.Name= 'Test Account';
		testPartnerAccount.Customer_Category__c='Reseller';
		testPartnerAccount.RecordTypeId=partnerAccRecTypeId;
		insert testPartnerAccount;
		
		//insert Associate Site
		Associated_Site__c testSite = new Associated_Site__c();
		testSite.Account__c=testPartnerAccount.Id;
		testSite.Name= 'test Site';
		insert testSite;
		
		Route_To_Market__c rtm = new Route_To_Market__c();
		rtm.Account__c = testPartnerAccount.Id;
		insert rtm;
		//insert Product Alignment
		Product_Alignment__c testProdAlignment = new Product_Alignment__c ();
		testProdAlignment.Related_Account__c = testPartnerAccount.Id;
		testProdAlignment.Associated_Site__c =  testSite.Id;
		testProdAlignment.Route_To_Market__c = rtm.Id;
		insert testProdAlignment;
		
		delete testSite;
	 }	
		
}