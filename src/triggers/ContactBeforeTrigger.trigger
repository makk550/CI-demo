/* Name         : ContactBeforeTrigger
 * Events       : before Insert ,before update,before delete,After Insert,after update
 * Description  : Trigger functionality on Contact
 --------------------------------------------------------------------------------------
 Modified Date              Modified by                     Description
 19 June 2018               Souravmoy Gorai                 Contact Inquiry US508296

 --------------------------------------------------------------------------------------
 */

trigger ContactBeforeTrigger on Contact (before Insert ,before update,before delete,After Insert,after update) 
{
    RecordTypes_Setting__c preOppRec = RecordTypes_Setting__c.getValues('Pre Opportunity');
    string preOppRecType;
    if(preOppRec!=null)
        preOppRecType = preOppRec.RecordType_Id__c;

    if(Trigger.isbefore && Trigger.isUpdate)
    {
        for (Contact c : Trigger.new)
        {
            Contact oldContact = (Contact)Trigger.OldMap.get(c.id);  
            Contact newContact = (Contact)Trigger.NewMap.get(c.id); 
            //populating the Inactive data field AR3749 ALLHA02
            if(oldContact.Reason_for_Inactive__c==null && newContact.Reason_for_Inactive__c!=null){
                newContact.Inactive_Date__c=System.now();
            }
            if(oldContact.Reason_for_Inactive__c!=null && newContact.Reason_for_Inactive__c==null){
                newContact.Inactive_Date__c=null;
            }
            
            if(Label.Marketo_ProfileIds.contains(userinfo.getProfileId().substring(0,15))){
                
                String oldLDAPId = oldContact.SC_CONTACT_LDAPID__c;
                if(oldLDAPId != null && oldLDAPId.trim() != '')
                {
                    c.email = oldContact.email;
                    c.FirstName = oldContact.FirstName;
                    c.LastName = oldContact.LastName;
                    c.Phone = oldContact.Phone;
                }
            }
        }
    }


    // Contact Inquiry
    // Description  : Opportunities would get created when the Contact Engagement is true.
    // Events       : after update
    // Author       : AMILI01 & GORSO02
    
    if(Trigger.isBefore && Trigger.isUpdate) {

        if(!ContactTriggerUtility.bypassoppcreation){
            //ContactTriggerUtility.bypassoppcreation=true;  
           
            set<id> accids=new set<id>();
            Set<Id> conIdSet = new Set<Id>();
            set<string> gbu100driver=new set<string>();
            List<opportunity> ExistingOppsList=new list<opportunity>();
            Map<id,opportunity> ExistingOppsMap=new Map<id,opportunity>();
            Map<id,opportunity> OppInsertMap=new  Map<id,opportunity>();
            Map<id,OpportunityContactRole> OppConRoleMap=new  Map<id,OpportunityContactRole>();
            Map<id,string> AccnamesMap=new Map<id,string>();
            list<account> AccNamesList=new List<account>();
            Map<string,set<id>> ContactRolesMap=new Map<string,set<id>>();
            
            for (Contact c : Trigger.new){
                if(Trigger.oldMap.get(c.id).Contact_Engagement__c==false && c.Contact_Engagement__c==true && c.GBU_Driver__c != null && c.AccountId!=null){
                    accids.add(c.AccountId);
                    conIdSet.add(c.Id);
                    gbu100driver.add(c.GBU_Driver__c);
                   
                }
            }
                    
            
            // get list of opportunities for the contact and gbu drivers
            //Map<Id,Set<Id>> extConOppsIdMap = ContactTriggerUtility.getPrevOpps(conIdSet,gbu100driver);
            
            if(accids != null && gbu100driver != null && accids.size()>0 && gbu100driver.size()>0 ){
                 
            	//get the contact roles to avoid creation of duplicates roles on opportunity
                if(conIdSet!= null && conIdSet.size()>0){
            		ContactRolesMap= ContactTriggerUtility.getContactRoles(conIdSet,gbu100driver);
                    System.debug('+++ ContactRolesMap size +++'+ContactRolesMap.size());
                }
                
                //get existing opps if contact from same account is trying to create opp of same gbu driver then add the contact to existing opp 
                //rather than create new opp for same account and gbu driver
                ExistingOppsList= ContactTriggerUtility.getExistingOpps(accids,gbu100driver);
                
                if(ExistingOppsList != null && ExistingOppsList.size()>0){
                	for(Opportunity etopp:ExistingOppsList){
                    	ExistingOppsMap.put(etopp.Accountid,etopp);
                	}
                }
                
                AccNamesList=ContactTriggerUtility.getAccNames(accids);
            	for(account acc:AccNamesList){
                	AccnamesMap.put(acc.id,acc.name);
            	}
			    
                //contact enagegment is true create opp and add contact as primary contact role on opp ('avoiding duplicates')
            	for (Contact c : Trigger.new){
                if(Trigger.oldMap.get(c.id).Contact_Engagement__c==false && c.Contact_Engagement__c==true && c.GBU_Driver__c != null){
                   /* if(extConOppsIdMap.containsKey(c.Id)) {
                        // Do Nothing
                    }
                    else   */    
                    if(ExistingOppsMap.containsKey(c.AccountId) && c.GBU_Driver__c==ExistingOppsMap.get(c.AccountId).GBU_Driver_100__c){
                        string key=ExistingOppsMap.get(c.AccountId).id+'_'+ExistingOppsMap.get(c.AccountId).GBU_Driver_100__c;
                        System.debug('+++ key in trigg +++'+key);
                        if(ContactRolesMap != NULL && ContactRolesMap.size()>0 && ContactRolesMap.containsKey(key)){
                            System.debug('+++ key is present in Contact map +++');
                            if(!ContactRolesMap.get(key).contains(c.id)){
                                OpportunityContactRole pl=new OpportunityContactRole(Contactid=c.id,opportunityid=ExistingOppsMap.get(c.AccountId).id,Role='Influencer');
                        		OppConRoleMap.put(c.id,pl);
                                System.debug('+++ contact role not existing .. +++');
                            }
                        }
                        else{ 
                        OpportunityContactRole pl=new OpportunityContactRole(Contactid=c.id,opportunityid=ExistingOppsMap.get(c.AccountId).id,Role='Influencer');
                        OppConRoleMap.put(c.id,pl);
                        System.debug('+++ existing opp +++');
                        }
                    }
                    else{  //name=c.FirstName+' '+c.LastName
                        string oppname=AccnamesMap.get(c.AccountId)+'-'+c.GBU_Driver__c+'-'+c.LastName+'-OPP';
                        Opportunity opp=new Opportunity(recordTypeId=preOppRecType,ownerid=label.Generic_OwnerID,name=oppname,StageName=label.Stage_0_Name,CloseDate=date.today().addMonths(3),Accountid= c.AccountId,Type=label.SalesPlay_Opp_Type,Transaction_Type__c=label.SalesPlay_Opp_Type,Source__c=label.Salesplay_Source,GBU_Driver_100__c=c.GBU_Driver__c,Contact_Is_Source__c=true,
                                                        MQLDatelatest__c = c.MQLDate__c, SALDate__c = c.SALDate__c,
                                                        BUDriver__c = c.GBU__c, Country__c = c.Country_Picklist__c);                // New fields added for Stage 0 opportunity - by GORSO02
                        OppInsertMap.put(c.id,opp);
                        System.debug('+++ new opp +++');
                        System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++---opp id--'+opp.id+'----name--'+opp.name);
                        //OpportunityContactRole pl=new OpportunityContactRole(Contactid=c.id,opportunityid=opp.id);
                        OpportunityContactRole pl=new OpportunityContactRole(Contactid=c.id,IsPrimary=true,opportunityid=opp.id,Role='Influencer');
                        OppConRoleMap.put(c.id,pl);
                        
                    }
                    
                    c.Contact_Engagement__c = false;        // Reset the contact engagement to false
                }
            }
            
            
            
            	if((OppInsertMap!= null && OppInsertMap.size()>0 )||( OppConRoleMap!= null && OppConRoleMap.size()>0)){
                System.debug('+++ calling opps and contact roles +++');
                 ContactTriggerUtility.OppsAndContactRoles(OppInsertMap,OppConRoleMap);             
            }
            
          
            }  
        }
        
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        if(!ContactTriggerUtility.bypassoppcreation){
            ContactTriggerUtility.bypassoppcreation=true;  
            ContactTriggerUtility.InsertOpp_ContRoles();
        }
    }
    
    // POC -end
    
    
    //Blocking non-admins from deleting the contact AR3749 ALLHA02
    if(trigger.isBefore && trigger.isDelete){
        
        for(Contact c: Trigger.old){
            if(Label.Email_to_case_missing_contact.contains(String.valueOf(c.id).subString(0,15)) 
               && !Label.Admin_Profile_Label.contains(userinfo.getProfileId().subString(0,15))){
                   c.addError('You are not authorized to delete this contact. Please contact your system administrator.');
               }
            
        }
        
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        
        for(Contact c: Trigger.new){
            if(Label.Email_to_case_missing_contact.contains(String.valueOf(c.id).subString(0,15)) 
               && !Label.Admin_Profile_Label.contains(userinfo.getProfileId().subString(0,15))){
                   c.addError('You are not authorized to update this contact. Please contact your system administrator.');
               }
        }
    }
    //ponse01-----start---------- for Contact Inteligence
    if(Trigger.IsBefore && Trigger.isInsert){
        List<Contact> Currentconlist=New List<Contact>();
        List<Contact> dupconlist=New List<Contact>();
        set<string> currentemailset=New set<string>();
        List<Profile> salescloudprofiles=New List<Profile>(); 
        //List<Profile> servicecloudprofiles=New List<Profile>();  
        
        boolean salesclouduser=false;
        //boolean serviceclouduser=false;
        
        string  currentuserProfileid=userinfo.getProfileId(); 
        List<CI_Profiles__c> allprofiles=CI_Profiles__c.getAll().values();
        
        Set<string> salesprofilename=new Set<string>();
        // Set<string> serviceprofilename=new Set<string>();
        
        
        for(CI_Profiles__c CIprofile:allprofiles){
            if(CIprofile.Name.containsIgnorecase('Sales')||CIprofile.Name.containsIgnorecase('Service')){             
                salesprofilename.add(CIprofile.Profile_Name__c);   
            }
        }
        if(salesprofilename.size()>0) 
            salescloudprofiles=[select id,Name from Profile where name IN:salesprofilename];
        
        
        for(Profile p:salescloudprofiles){
            if(p.id==currentuserProfileid){
                salesclouduser=true;
                break;
            }
        }
        
        
        for (Contact c : Trigger.new)
        {
            system.debug('boolean check=='+c.ThroughDupeCheck__c);
            system.debug('salesclouduser=='+salesclouduser);
            
            if(c.ThroughDupeCheck__c=='True' && salesclouduser==true){
                system.debug('entered in to boolean check');
                if(c.Email!=Null){
                    system.debug('entered in to email check');
                    currentemailset.add(c.Email);
                    
                }
            }
        }
        system.debug('currentemailmap----'+currentemailset);
        if(currentemailset.size()>0){
            Currentconlist=[select id,Name,Email from Contact where Email IN:currentemailset];
            system.debug('Currentconlist----'+Currentconlist);
        }
        
        System.debug('======'+Currentconlist.size());
        if(Currentconlist.size()>0){
            for (Contact con : Trigger.new)
            {
                System.debug('======con'+con);
                
                
                con.addError('Duplicate contacts Exist Please create Contact relationship ');
                
                
            }
        }
        
        
        
        
    }

    if(Trigger.isAfter && Trigger.isInsert){
        
        List<Contact_Relationship__c> conrelationlist=New List<Contact_Relationship__c>();
        for (Contact c : Trigger.new)
        {
            if(c.StrengthOfRelationship__c !=Null){
                Contact_Relationship__c cr= New Contact_Relationship__c();
                
                cr.Active__c=True; 
                cr.CA_User__c=Userinfo.getuserid();
                cr.Contact__c=c.id;
                cr.CARelationshipType__c=c.CARelationshipType__c;
                cr.StrengthOfRelationship__c= c.StrengthOfRelationship__c;
                cr.Contact_Role__c=c.ContactRole__c;
                // cr.Account__c= c.Accountid;
                // cr.Emails__c= c.Email;
                //  cr.LastName__c = c.LastName;
                
                conrelationlist.add(cr);
            }
        }
        if(conrelationlist.size()>0){
            Insert conrelationlist;
            system.debug('inserted con relation id==='+conrelationlist[0].id);
        }
        
    }
    
    
    //ponse01-----Ends----------
    
    
}