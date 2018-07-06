@isTest (SeeAllData = true)
public class BusinessTransactionMonitoring_CloseCase{

  private static User supportUser ; 
 
  public static User createSupportUser(){
         Profile adminProfile = [select Id from Profile where Name = 'Support L1' limit 1];
         supportUser = [select Id from User where  isActive = true AND ProfileId = :adminProfile.Id limit 1];
         return supportUser ;
  }
 
  
  static testmethod void testCloseCase () {
      system.runAs(createSupportUser()){         
          Case testCase = [select id , status from Case where status = 'Verify' limit 1] ;
          testCase.status = 'Closed';
          testCase.Category__c = 'Documentation';
          testCase.Subcategory__c = 'Clarification'; 
          testCase.Reason ='Defect';
          testCase.Resolution__c ='waiting 9.6';
          test.starttest();
          //update testCase ;
          test.stoptest();
      }   
  }
 

}