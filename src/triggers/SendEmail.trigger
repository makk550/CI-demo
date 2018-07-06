trigger SendEmail on Partner_Registration__c (after Insert) {

 for (Partner_Registration__c u : Trigger.new){
 
     String langCode=Language_Keys__c.getValues(u.Preferred_language__c)!=null ? Language_Keys__c.getValues(u.Preferred_language__c).Language_Key__c:'en_US';
     if(u.Company_business_model__c != System.Label.POB_partner_referral){
         PRM_Email_Notifications.sendEmailByCapability('On-Boarding',u.Id,langCode,'Partner Registration');
     }else{
         if(u.Company_business_model__c == System.Label.POB_partner_referral){
             PRM_Email_Notifications.sendEmailByCapability('On-Boarding',u.Id,langCode,'Referral Partner Registration');
         }
     }
         

 }  

}