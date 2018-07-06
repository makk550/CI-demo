/*
 * Test Class = Contact_Relationship_RelatedList_Test
 * Coverage = 95%
 * Updated by - PATSA27
*/ 

trigger Update_Contact on Contact_Relationship__c(before insert, before update, after insert, after update, after delete){
    Set<id> activeconid = new Set<id>(); //active contact
    Set<id> deletedactiveconid = new Set<id>(); //deleted active contact
    Set<id> inactiveconid = new Set<id>(); //inactive contact
    Set<id> conid = new Set<id>();
    Map<id,List<String>> contactusermap = new Map<id,List<String>>(); //active user map
    Map<id,List<String>> deletedcontactusermap = new Map<id,List<String>>(); //deleted active user map
    Map<id,List<String>> inactivecontactusermap = new Map<id,List<String>>(); //inactive user map
    Map<id,Contact> contactCRMfieldmap = new Map<Id,Contact>();
    Map<id,Integer> contactusercountmap = new Map<Id,Integer>();
    Boolean isactivedelete = false;
    Integer usercount;
    Contact contactCRM;
    String contactCRMfield;
    List<Contact> contlist = new List<Contact>();
    
    if(Trigger.isBefore && Trigger.isInsert){
        for(Contact_Relationship__c crm:trigger.new){
            If(crm.CA_User__c==null){
                crm.CA_User__c = UserInfo.getUserId();
            }
        }
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert||Trigger.isUpdate){
            system.debug('--entered before update/insert--');
            for(Contact_Relationship__c crm:trigger.new){
                if(crm.active__c==true && crm.CA_User__c!=null){
                    system.debug('--entered here--');
                    activeconid.add(crm.ContactId__c);
                }
            }
            if(activeconid.size()>0){
                system.debug('--fetching--'+activeconid.size()); 
                contactCRMfieldmap = new Map<Id,Contact>([Select id,Contact_Relationship_PMFKEYS__c from contact where id=:activeconid]);
            }
            if(contactCRMfieldmap.size()>0){
                system.debug('---checking limit---');
                for(Id c:contactCRMfieldmap.keySet()){
                    contactCRM = contactCRMfieldmap.get(c);
                    if(contactCRM.Contact_Relationship_PMFKEYS__c!=null){
                       usercount = contactCRM.Contact_Relationship_PMFKEYS__c.length()/8;
                    }
                    if(String.isEmpty(contactCRM.Contact_Relationship_PMFKEYS__c)){
                        usercount = 0;
                    }
                    contactusercountmap.put(c,usercount);
                }
            }
            for(Contact_Relationship__c crm:trigger.new){
                if(contactusercountmap.containsKey(crm.ContactId__c) && crm.Active__c==true){
                    Integer count = contactusercountmap.get(crm.ContactId__c);
                    if(count>=31){
                        crm.adderror('The limit for ACTIVE users for this contact has been reached');
                    }
                    else{
                        count++;
                        contactusercountmap.put(crm.ContactId__c,count);
                    }
                }
            }
        }
    }
        
    
    if(Trigger.isAfter){
        if(Trigger.isInsert||Trigger.isUpdate){
            for(Contact_Relationship__c crm:trigger.new){
                if(crm.active__c==true && String.isNotBlank(crm.CA_User_PMFKEY__c)){
                    activeconid.add(crm.ContactId__c);
                    if(contactusermap.get(crm.ContactId__c)!=null){
                        system.debug('Populating map 2nd time');
                        contactusermap.get(crm.ContactId__c).add(crm.CA_User_PMFKEY__c); 
                    }
                    else{
                        List<String> userpmfset = new List<String>();
                        userpmfset.add(crm.CA_User_PMFKEY__c);
                        system.debug('Populating map 1st time');
                        contactusermap.put(crm.ContactId__c,userpmfset);
                    }
                }
                else if(crm.active__c==false && String.isNotBlank(crm.CA_User_PMFKEY__c)){
                    inactiveconid.add(crm.ContactId__c);
                    if(inactivecontactusermap.get(crm.ContactId__c)!=null){
                        system.debug('Populating map 2nd time');
                        inactivecontactusermap.get(crm.ContactId__c).add(crm.CA_User_PMFKEY__c); 
                    }
                    else{
                        List<String> userpmfset = new List<String>();
                        userpmfset.add(crm.CA_User_PMFKEY__c);
                        system.debug('Populating map 1st time');
                        inactivecontactusermap.put(crm.ContactId__c,userpmfset);
                    }
                }
            }
            conid.addAll(inactiveconid);
            conid.addAll(activeconid);
            if(conid.size()>0){
                contlist = [Select id,Contact_Relationship_PMFKEYS__c from contact where id=:conid];
            }
            if(contlist.size()>0){
                for(Contact c:contlist){
                    if(String.isBlank(c.Contact_Relationship_PMFKEYS__c)){
                        if(contactusermap.containsKey(c.id)){
                            List<String> userpmf = contactusermap.get(c.id);
                            if(userpmf.size()>0){
                                c.Contact_Relationship_PMFKEYS__c=userpmf[0]+';';
                            }
                        }
                    }
                    else{
                        if(contactusermap.containsKey(c.id)){
                            List<String> userpmf = contactusermap.get(c.id); 
                            if(userpmf.size()>0){
                                for(String s:userpmf){
                                    if(!c.Contact_Relationship_PMFKEYS__c.contains(s)){
                                        c.Contact_Relationship_PMFKEYS__c+= s+';';
                                        system.debug('after addition-----------'+c.Contact_Relationship_PMFKEYS__c);
                                    }
                                }
                            }
                        }
                        if(inactivecontactusermap.containsKey(c.id)){
                            List<String> inactiveuserpmf = inactivecontactusermap.get(c.id);
                            if(inactiveuserpmf.size()>0){
                                for(String s:inactiveuserpmf){
                                    if(c.Contact_Relationship_PMFKEYS__c.contains(s)){
                                        
                                        s=s+';';
                                        c.Contact_Relationship_PMFKEYS__c= c.Contact_Relationship_PMFKEYS__c.remove(s);
                                        system.debug('after removal-----------'+c.Contact_Relationship_PMFKEYS__c);
                                    }
                                }
                            }
                        }
                    }
                }
                    
                //try{
                    update contlist;
                /*}
                catch(exception e){
                    system.debug('--------cause------'+e.getCause());
                    system.debug('-----message-----'+e.getMessage());
                    system.debug('-----line-----'+e.getLineNumber());
                    system.debug('-stack--'+e.getStackTraceString());
                }*/
                
            }
        } 
        if(Trigger.isDelete){
            for(Contact_Relationship__c crm:trigger.old){
                if(crm.Active__c==true){
                    deletedactiveconid.add(crm.ContactId__c);
                    if(deletedcontactusermap.get(crm.ContactId__c)!=null){
                        system.debug('Populating map 2nd time');
                        deletedcontactusermap.get(crm.ContactId__c).add(crm.CA_User_PMFKEY__c); 
                    }
                    else{
                        List<String> userpmfset = new List<String>();
                        userpmfset.add(crm.CA_User_PMFKEY__c);
                        system.debug('Populating map 1st time');
                        deletedcontactusermap.put(crm.ContactId__c,userpmfset);
                    }
                }
            }
            if(deletedactiveconid.size()>0){
                contlist = [Select id,Contact_Relationship_PMFKEYS__c from contact where id=:deletedactiveconid];
            }
            if(contlist.size()>0){
                for(Contact c:contlist){
                    if(!String.isBlank(c.Contact_Relationship_PMFKEYS__c)){
                        if(deletedcontactusermap.containsKey(c.id)){
                            List<String> userpmf = deletedcontactusermap.get(c.id); 
                            if(userpmf.size()>0){
                                for(String s:userpmf){
                                    if(c.Contact_Relationship_PMFKEYS__c.contains(s)){
                                        isactivedelete = true;
                                        s=s+';';
                                        c.Contact_Relationship_PMFKEYS__c= c.Contact_Relationship_PMFKEYS__c.remove(s);
                                        system.debug('after removal-----------'+c.Contact_Relationship_PMFKEYS__c);
                                    }
                                }
                            }
                        }
                    }
                }
                if(isactivedelete==true)
                    update contlist;
            }
        }
    }
}