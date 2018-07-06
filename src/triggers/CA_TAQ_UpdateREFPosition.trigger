trigger CA_TAQ_UpdateREFPosition on TAQ_REF_Position__c (before insert, before update) {
    for(TAQ_REF_Position__c pos:trigger.new){
        Profile [] profiles = [SELECT id, name FROM Profile WHERE name= :pos.Profile_Name__c limit 1];
        UserRole [] roles = [SELECT id, name FROM UserRole WHERE name= :pos.Role_Name__c limit 1];
    
        if (profiles.size()>0)
            pos.Profile_Id__c=profiles[0].id;
        else 
            pos.Profile_Id__c=null;
            
        if (roles.size()>0)
            pos.Role_Id__c=roles[0].id;
        else
            pos.Role_Id__c=null;
    }
}