@isTest (SeeAllData = true)
public class BusinessTransactionMonitoring_CreateCase{

  private static Site_Association__c testSite ; 
  private static CA_Product_Controller__c testCAProduct ; 
  private static CA_Product_Component__c testCAComponent ; 
  private static Contact testContact ; 
  private static User supportUser ; 
 
  public static User createSupportUser(){
         Profile adminProfile = [select Id from Profile where Name = 'Support L1' limit 1];
         supportUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
         return supportUser ;
  }
  public static  void createTestData () { 
      
     testContact = [select Id from contact where Email !=null limit 1];
     testSite = [select Id from Site_Association__c where  SC_SITE_Sanctioned_Party__c = 'No' and SC_SITE_Source__c = 'Support' limit 1];
     testCAProduct = [select Id from CA_Product_Controller__c where  Name = 'APPLICATION PERFORMANCE MANAGEMENT' limit 1]; 
     testCAComponent = [select Id from CA_Product_Component__c where CA_Product_Controller__c = :testCAProduct.Id limit 1]; 
  }  
  
  static testmethod void testInsertCase () {
     system.runAs(createSupportUser()){
        createTestData();         
        Test.StartTest();
        Case testCase = new Case();
        testCase.Site_Association__c = testSite.Id ;
        testCase.subject = 'Test Subject' ; 
        testCase.Description = 'Test Description' ; 
        testCase.ContactId = testContact.Id ; 
        testCase.CA_Product_Controller__c = testCAProduct.Id; 
        testCase.CA_Product_Component__c = testCAComponent.Id;
        testCase.Next_Action__c ='Pending CA';
        testCase.Next_Action_Due_Date__c = System.Today()+1;
        testCase.Origin = 'Phone Call';
        insert testCase; 
        Test.StopTest();
     }   
  }
 

}