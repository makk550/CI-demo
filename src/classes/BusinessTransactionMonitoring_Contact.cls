@isTest (SeeAllData = true)
public class BusinessTransactionMonitoring_Contact{
  private static User supportUser ; 
 
  public static User createSupportUser(){
         Profile adminProfile = [select Id from Profile where Name = 'Support L1' limit 1];
         supportUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
         return supportUser ;
  } 
  static testmethod void testInsertContact() {
     system.runAs(createSupportUser()){
       Contact testContact = new Contact();
       testContact.LastName = 'Darcy' ;
       testContact.FirstName = 'Brian' ; 
       testContact.Email = 'Brian@test.com';
       testContact.Country_Picklist__c = 'US - UNITED STATES'; 
       insert testContact ;         
     }   
  }
}