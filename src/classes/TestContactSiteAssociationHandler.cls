/*
 * Test class for ContactSiteAssociationHandler and ContactSiteAssociationGateway
*/
@isTest(SeeAllData = true) 
public class TestContactSiteAssociationHandler{
    
    /*
     * Method to handle insert of duplicate Contact Site Association Records
    */
    static testMethod void testCreateDupContactSiteAssociation(){
    	    	
    	
    	Profile adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO'];
        User testUser = [select Id from User where  isActive = true and ProfileId = :adminProfile.ID limit 1];
        system.runAs(testUser){
        	
	        Account testAccount = new Account();
		  	testAccount.Name = 'IBM'; 
		  	testAccount.Enterprise_ID__c = '7777777777';
		  	testAccount.BillingStreet='Street';
	        testAccount.BillingCountry='US';
	        testAccount.BillingCity='Islandia'; 
		  	insert testAccount ; 
		  	Site_Association__c testSiteAssociation = new Site_Association__c();
		  	testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
		  	testSiteAssociation.SAP_Site_ID__c = '280125';
		  	testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
		  	testSiteAssociation.Enterprise_ID__c = testAccount.Id;
		  	testSiteAssociation.SC_TOPS_ID__c = '1233';
		  	testSiteAssociation.Country_picklist__c ='US - UNITED STATES';
            testSiteAssociation.State__c = 'california';
		  	insert testSiteAssociation ;
		  	Contact testContact = new Contact();
		  	testContact.FirstName ='test';
		  	testContact.LastName ='contact';
		  	insert testContact ;
		  	Contacts_Site_Association__c csa = new Contacts_Site_Association__c();
		  	csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
		  	csa.SC_CSA_CONTACTS__c = testContact.Id; 
		  	insert csa; 
		  	try{
			    csa = new Contacts_Site_Association__c();
			  	csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
			  	csa.SC_CSA_CONTACTS__c = testContact.Id; 
			  	insert csa;
		  	}catch(Exception e){
		  		
		  	}
		    testAccount = new Account();
		  	testAccount.Name = 'IBM'; 
		  	testAccount.BillingStreet='Street';
	        testAccount.BillingCountry='US';
	        testAccount.BillingCity='Islandia'; 
		  	insert testAccount ; 
		    testSiteAssociation = new Site_Association__c();
		  	testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
		  	testSiteAssociation.SAP_Site_ID__c = '280125';
		  	testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
		  	testSiteAssociation.SC_TOPS_ID__c = '123';
		  	testSiteAssociation.Country_picklist__c ='US - UNITED STATES';
            testSiteAssociation.State__c = 'california';
		  	insert testSiteAssociation ;
	        
	        List<Contact> contactList = new List<Contact>();
		  	List<Contacts_Site_Association__c> csaList = new List<Contacts_Site_Association__c>();
		  	
		  	for (Integer i=0 ;i<100;i++){
		  		 testContact = new Contact();
		  	     testContact.FirstName ='test';
		  		 testContact.LastName ='contact';
		  		 contactList.add(testContact) ;
		  	}
		  	insert contactList ; 
		  	for(Integer i = 0 ;i <100 ; i++){
		  	    csa = new Contacts_Site_Association__c();
		  		csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
		  		csa.SC_CSA_CONTACTS__c = testContact.Id; 
		  		csa.SC_CSA_Source__c = 'Support';
		  		csaList.add(csa);
		  	}
		  	try{
		    	insert csaList;  
		  	}catch(Exception e){
		  		
		  	}   
        } 		
    }
    /*
     * Method to handle update duplicate Contact Site Association Records
    */
     static testMethod void testUpdateDupContactSiteAssociation(){
     		
    	Profile adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO'];
        User testUser = [select Id from User where  isActive = true and ProfileId = :adminProfile.ID limit 1];
        system.runAs(testUser){
	    	Account testAccount = new Account();
		  	testAccount.Name = 'IBM'; 
		  	testAccount.Enterprise_ID__c = '7777777777';
		  	testAccount.BillingStreet='Street';
	        testAccount.BillingCountry='US';
	        testAccount.BillingCity='Islandia'; 
		  	insert testAccount ; 
		  	Site_Association__c testSiteAssociation = new Site_Association__c();
		  	testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
		  	testSiteAssociation.SAP_Site_ID__c = '280125';
		  	testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
		  	testSiteAssociation.Enterprise_ID__c = testAccount.Id;
		  	testSiteAssociation.SC_TOPS_ID__c = '1223';
		  	testSiteAssociation.Country_picklist__c ='US - UNITED STATES';
            testSiteAssociation.State__c = 'california';
		  	insert testSiteAssociation ;
		  	Contact testContact = new Contact();
		  	testContact.FirstName ='test';
		  	testContact.LastName ='contact';
		  	insert testContact ;
		  	Contacts_Site_Association__c csa = new Contacts_Site_Association__c();
		  	csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
		  	csa.SC_CSA_CONTACTS__c = testContact.Id; 
		  	csa.SC_CSA_Source__c = 'Support';
		  	insert csa; 
		  	
		  	testSiteAssociation = new Site_Association__c();
		  	testSiteAssociation.Name = '0003 MESSAGE TECHNOLOGIES, INCM';
		  	testSiteAssociation.SAP_Site_ID__c = '280124';
		  	testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
		  	testSiteAssociation.Enterprise_ID__c = testAccount.Id;
		  	testSiteAssociation.SC_TOPS_ID__c = '133';
		    testSiteAssociation.Country_picklist__c ='US - UNITED STATES';
            testSiteAssociation.State__c = 'california';
		  	insert testSiteAssociation ;
		  	try{
		  		csa.SC_CSA_SITE__c = testSiteAssociation.Id ;
		  		update csa;
		  	} 
		  	catch(Exception e){
		  		
		  	}
		  	csa.SC_CSA_Source__c = 'Sales' ;
		    update csa;
		    delete csa ; 
        }
    }
}