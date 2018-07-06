@isTest (SeeAllData = true)
public class BusinessTransactionMonitoring_Site{

 private static Site_Association__c testSite ; 
  private static Site_Association__c excludedSite;
  private static CA_Product_Controller__c testCAProduct ; 
  private static Contact testContact ; 
  private static User supportUser ; 
 
  public static User createSupportUser(){
         Profile adminProfile = [select Id from Profile where Name = 'Support L1' limit 1];
         supportUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
         return supportUser ;
  }
  
  static testmethod void testInsertSiteAssociation () {
     system.runAs(createSupportUser()){
         Account testAccount = new Account() ; 
     testAccount.Name = 'HONG KONG GOVERNMENT'; 
     testAccount.Enterprise_ID__c = 'AR51855';
     testAccount.BillingStreet = 'Admiralty Ctr';
     testAccount.BillingCountry = 'HK';
     testAccount.BillingCity = 'ADMIRALTY';
     insert testAccount ; 
     
      
     testSite = new Site_Association__c();
     testSite.Name = 'FINANCIAL SERVICES & THE TREASURY BUREA';
     testSite.Enterprise_ID__c =  testAccount.Id; 
     testSite.SC_SITE_Sanctioned_Party__c = 'No';
     testSite.SC_TOPS_ID__c = '1788689'; 
     testSite.State__c = 'california';
     testSite.Country_picklist__c ='US - UNITED STATES';
     insert testSite ;        
     }   
  }
 
}