trigger NotifyPartner on Partner_User_Data__c (after Update, after insert) {

  for (Partner_User_Data__c partnUsr : Trigger.new){
  	
  	
     if((Trigger.Isupdate & partnUsr.LDAP_Id__c !=null && Trigger.oldMap.get(partnUsr.Id).LDAP_Id__c==null && 
         partnUsr.E_mail__c!=null)  || (Trigger.IsInsert & partnUsr.LDAP_Id__c !=null) ){
     
       PRM_Email_Notifications.sendEmailByCapability('On-Boarding',partnUsr.id,userInfo.getlocale(),'Partner User Approval');
     }
  }

}