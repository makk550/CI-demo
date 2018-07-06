trigger PartnerUserLog_bibu on Partner_User_Log__c (before insert, before update) {   
    
  List<Partner_User_Log__c> listOfPartUserLog = new List<Partner_User_Log__c>();   
  for(Partner_User_Log__c p: Trigger.new){
    if(p.Type__c == 'New' || p.Type__c == 'Update')
      listOfPartUserLog.add(p);
  }
  Int_PopulateAccountDataOnPartnerUserLog.populateAccountDataOnPartnerUserLog(listOfPartUserLog);
}