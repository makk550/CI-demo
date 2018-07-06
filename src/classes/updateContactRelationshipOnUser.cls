global class updateContactRelationshipOnUser {
    
    @future      
    public static void updatecontactuser(Set<Id> inactiveuser){
        List<Contact_Relationship__c> contuserlist = new List<Contact_Relationship__c>();
        List<id> cont = new List<Id>();
        List<Contact> conlist = new List<Contact>();
        List<String> pmfs = new List<String>();
        if(inactiveuser.size()>0){
            contuserlist = [Select id,Active__c,CA_User_PMFKEY__c,Contact__c from Contact_Relationship__c where
                              CA_User__c in:inactiveuser and Active__c=true];
        }
        if(contuserlist.size()>0){
            for(Contact_Relationship__c cr:contuserlist){
                cr.Active__c = false;
                system.debug('---cont id---'+cr.Contact__c);
                cont.add(cr.Contact__c);
                pmfs.add(cr.CA_User_PMFKEY__c);
            }
            update contuserlist;
        }
    }
}