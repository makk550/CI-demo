@isTest (SeeAllData = true)
public class BusinessTransactionMonitoring_UpdateCase{
  private static User supportUser ; 
 
  public static User createSupportUser(){
         Profile adminProfile = [select Id from Profile where Name = 'Support L1' limit 1];
         supportUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
         return supportUser ;
  }
  
  static testmethod void testUpdateCase () {
     system.runAs(createSupportUser()){
         Case testCase = [select Id , status from case where status = 'Open' and Site_Association__c !=null and CA_Product_Controller__c!=null and CA_Product_Component__c!=null and contactId !=null limit 1 ];
         testCase.status = 'Verify' ; 
         testCase.Category__c='Administrative';
         testCase.Subcategory__c='Services';   
         
         testCase.Reason='Defect - New';
         testCase.Resolution__c='Test';
         update testCase ; 
     }   
  }
 

}