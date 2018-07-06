/*
Class Name : VisualforceSCIQuoteIdentifyCPQUser
Created Date: 04/12/2011
Created By : Accenture
Requirment: The requirement is to add a intermediary visualforce page, which will check if the user is first from a
            country contained in the CPQ allowed country list (CPQ_Pilot_Exempt__c custum settings) 
            and then if the user is in the public group – CPQ pilot users, before directing them to a visualforce page. 
Comments : class is used to identify that logged in user belong 'cpq pilot users' and
           User country must be in allowed country list which are values of CPQ_Pilot_Exempt__c custom settings
*/
public class VisualforceSCIQuoteIdentifyCPQUser{
   /**
    * isValidCPQUser(): Method used to validate logged in user 
    *  
    *
    * @param 
    * @return Boolean 
    * @throws 
    * 
    */
  public static Boolean isValidCPQUser(){
      Set<String> allowedCountry = new Set<String>();
      for(CPQ_Pilot_Exempt__c pilotExempt:CPQ_Pilot_Exempt__c.getAll().values()){
         allowedCountry.add(pilotExempt.Name);
      }
      
      //find that user belongs to pilot group, YES if value is more than 1
      Integer isUserGroupUser = [Select count() from GroupMember where UserOrGroupId=: userinfo.getUserId() and group.name = 'cpq pilot users'];
      
      //find that user's country belongs to allowed list, YES if value is more than 1
      Integer isValidUsetCnt = [select count() from user where Id=:Userinfo.getUserId() and country in:allowedCountry];
      return (isUserGroupUser > 0 || isValidUsetCnt > 0);
  }
    
}