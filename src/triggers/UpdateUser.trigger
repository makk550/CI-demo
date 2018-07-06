trigger UpdateUser on User (before insert,before update, after update) {

    if(trigger.isbefore && (trigger.isInsert || trigger.isUpdate)){
    
                if(trigger.isInsert){
                     for (User u : trigger.new){
                      if(u.DM_Portal_User__c=='True'){   
                          u.Education_Access__c= False;  
                      } 
                       if(u.ContactId!=null && (u.DefaultCurrencyIsoCode==Null||u.DefaultCurrencyIsoCode==''))
                          u.DefaultCurrencyIsoCode='USD'; 
                        
                     }
                    
                }
                    String SandboxName = null;
                  String URLTemp ='https://ca.my.salesforce.com';
              if(URL.getSalesforceBaseUrl().toExternalForm() != URLTemp){
                        String CurrentUrl = URL.getSalesforceBaseUrl().toExternalForm();
                        if(CurrentUrl.contains('ca--')){
                            //System.debug(CurrentUrl.substringAfter('ca--'));
                            String Suburl =CurrentUrl.substringAfter('ca--');
                            List<String> UrlList =Suburl.split('\\.');
                            if(UrlList.size() >0){
                                SandboxName = UrlList[0];
                            }
                            
                        }
                        
               }
               else{
                        System.debug('This is Production');
               }
              if(SandboxName != null){
                        for(User usr : trigger.new){
                            if(usr.UserType == 'PowerPartner' && usr.username.contains('.com')){
                               // String.removeStart(toRemove)
                                if(usr.username.substringAfterLast('.com')!=null){
                                        String endsandboxname=usr.username.substringAfterLast('.com');
                                        usr.Username=usr.username.removeEnd(endsandboxname);
                                  }
                                 usr.Username = usr.Username + '.' +SandboxName;
                            }
                    }
               }
                
    }
    
    
    
    /*
    ***   TAP Approver Criteria:
    sendEMail when a User is Deactivated with the following relational criteria:
    User Deactivation Email needs ONLY to go out When a User being deactivated is
    an 'Approver' [User]    in any 'TAP Approval__c' record 
     (see TAP Approvals' tab in SFDC)  to see 'Approver' user lookup
     ***
     */
     
//making sure logic is executed afterUpdate operation
    if(trigger.isUpdate && trigger.isAfter){    
        set<id> Userids = new set<id>(); 
        
  //revised from    string userid; 
        set<id> deactivatedUsers = new set<id>();
        
  //  included Map
        map<id,string> mapdeactivatedUsers = new map<id,string>();
        
  //checks all updated Users       
        for(User usr:trigger.new){
        
  //check if User is deActivated or Not   
        if(usr.isActive==false && trigger.oldMap.get(usr.id).isActive==true) 
  
  //if User is deActivated then a collection is here in Userids
                   Userids.add(usr.id);
        } 
        
  //if collection is empty or not   
        if(UserIds.size()>0){
        
  //getting all records from TAP_Approver__c that are related to 1 or all of the deActivated User(s)
            list<TAP_Approver__c> tapApprovers=[select id,Approver__c ,Approver__r.Name from TAP_Approver__c where Approver__c in :Userids];
            
  //loop through all the tApprover:tapApprover and fill deActivated User collection
            for(TAP_Approver__c tApprover:tapApprovers){  
                    
 //revised   from    'userid=tApprover.Approver__c;'
             deactivatedUsers.add(tApprover.Approver__c);
                    
 // renders deActivated User
             mapdeactivatedUsers.put(tApprover.Approver__c,tApprover.Approver__r.Name);
            }
        }
        
  //If a deActivated tApprover:tapApprover  is in the collection, take following action
        if(deactivatedUsers.size()>0){
            list<Messaging.SingleEmailMessage> messages=new list<Messaging.SingleEmailMessage>();
            
  //Populates User Ids from GroupMembers in SFDC
            string GroupName=UserDeactivationEmailRecipients__c.getValues('ToGroupName').value__c;
            set<string> usrids=new set<string>();
            for(GroupMember GM:[select id,UserOrGroupid from GroupMember where group.name=:GroupName]){
                usrids.ADD(GM.UserOrGroupId);
            }
            
  //Populates Email Addresses associated with the Group   
            list<string> tomailids=new list<string>();
            for(user usr:[select email from user where id in:usrids and IsActive=True ]){   //samap01 -US338744 - Send Email to valid active users                    
                tomailids.add(usr.email);
            } 
            
 
            String emailbodylabel = Label.Deactivated_TAP_Approver_Email_Body;
            String emailsubject = Label.Deactivated_TAP_Approver_Subject;

            List<User> deactivatedUsersToEmail = [SELECT id, name, pmfkey__c, title, manager.name, username FROM User WHERE id in:deActivatedUsers];
      
              for(User theUser: deactivatedUsersToEmail){
                     String templateid=Label.DeActivated_TAP_Approver_Subject; 
                     String strBody = emailbodylabel.Replace('#TAPUSER',theUser.Name);
                     strBody = strBody.Replace('#USERNAME', theUser.Username);
                     strBody = strBody.Replace('#PMFKEY', theUser.PMFKey__c);
                     strBody = strBody.Replace('#ID', theUser.Id);
                     strBody = strBody.Replace('#TITLE', theUser.Title);
                     strBody = strBody.Replace('#MANAGER', theUser.Manager.Name);
         
                     if(templateid!=null && templateid!=''){ 

                             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                             mail.setSubject(emailsubject);
                             mail.sethtmlBody(strBody);
                             mail.setToAddresses(tomailids);  
                             mail.setSaveAsActivity(false);   
                             
                        messages.add(mail);
                     }
              
             }
               if(messages.size()>0)
                    Messaging.sendEmail(messages);
        }
    }
    
}