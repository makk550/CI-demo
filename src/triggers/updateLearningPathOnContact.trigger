trigger updateLearningPathOnContact on Accreditation__c (after insert, after update) {

  // Trigger to update learaning path code on contact.
  Map<String,String> mapAccrContact = new Map<String,String>();    
  Map<Id,String> mapContact = new Map<Id,String>();    
  
  List<Accreditation__c> accreditation = Trigger.new;
  Set<String> conId = new Set<String>();
  
  // Add learning path cod to a map with contact name as key.
  for (Accreditation__c accr : Trigger.new)   
  {         
    mapContact.put(accr.Contact_Name__r.id,accr.Learning_Code_Path__c);
    conId.add(accr.contact_Name__c);
  }
  
  //get all the contacts related to accreditations.
  List<contact> lstcontact = [select Id,Learning_Path_Code__c from contact where id =: conId Limit:(Limits.getLimitQueryRows() - Limits.getQueryRows())];
  List<contact> lstContactToBeUpdated =new   List<contact>();
  //assign the learning path to the contact's learning path.
  for(Contact con : lstcontact)
  {
    if(mapContact.size() > 0)
    {
     if(con.Learning_Path_Code__c != null)
      {
    //   con.Learning_Path_Code__c= mapContact.get(con.Id);
    //   lstContactToBeUpdated.add(con);
      }
    }
  }
 
   if(lstContactToBeUpdated.size() > 0)      
       update lstContactToBeUpdated; 
}