trigger updateBudget_FundRequest on SFDC_MDF__c (after insert, after update, after delete) {

    /*
     * Recalculates The FundRequest Amount on the Budget on insert, update, delete of a fund request.
     * Only those FundRequest are considered which are approved (approved__c = true)
     *
     */ 

    List<SFDC_Budget__c> budgetList = new List<SFDC_Budget__c>();
    Set<Id> budgetSet = new Set<Id>();
    
    //list of fund request - code added by Siddharth
    List<SFDC_MDF__c > listOfMDFRequests = new List<SFDC_MDF__c >();
    MDF_GrantAccessToApprovers classVar = new MDF_GrantAccessToApprovers();
        
    if (Trigger.isDelete) {
        //for delete
        for (SFDC_MDF__c changedMDF : Trigger.old) {
            if (changedMDF.Budget__c != null) {
                //budgetList.add(BudgetUtil.getUpdatedBudget(changedMDF));
                budgetSet.add(changedMDF.Budget__c);
            }
        }
        
    } else {
        if (Trigger.isUpdate) {
            for (Integer i = 0; i < Trigger.size; i++) {
                SFDC_MDF__c oldMDF = Trigger.old[i];
                SFDC_MDF__c newMDF = Trigger.new[i];
                Id oldBudgetId = oldMDF.Budget__c;
                Id newBudgetId = newMDF.Budget__c;
                System.debug(oldBudgetId);
                if (oldBudgetId != null) {
                    if (newBudgetId == null || oldBudgetId != newBudgetId) {
                        //budget removed/changed - need to update old budget
                        budgetSet.add(oldBudgetId);
                    }
                }   
               
                //code added by Siddharth in R2 for giving access to approvers of Fund Request.
                if(oldMDF.MDF_Request_Approval_Status__c!= 'Submitted' && newMDF.MDF_Request_Approval_Status__c=='Submitted')
                    listOfMDFRequests.add(newMDF);
                if(oldMDF.MDF_Request_Approval_Status__c== 'Submitted' && newMDF.MDF_Request_Approval_Status__c=='First Approval')
                    listOfMDFRequests.add(newMDF);
                if(oldMDF.MDF_Request_Approval_Status__c== 'First Approval' && newMDF.MDF_Request_Approval_Status__c=='Second Approval')
                    listOfMDFRequests.add(newMDF);
                //end of if conditions added by Siddharth 
                
            }
            //code added by Siddharth in R2- calling the class to give access to the approvers
            if(listOfMDFRequests!=null && listOfMDFRequests.size()>0)
                classVar.giveAccessToMDFRequestApprovers(listOfMDFRequests);
  
        }

        for (SFDC_MDF__c changedMDF : Trigger.new) {
            if (changedMDF.Budget__c != null) {
                budgetSet.add(changedMDF.Budget__c);
            } 
        }
    }
    budgetList = BudgetUtil.getBudgetList(budgetSet);

    //update the budget objects
    if (budgetList.size() > 0) {
        try {
            BudgetUtil.updateList(budgetList);
        } catch (Exception e) {
            String message = 'An error occured while Updating Budget: ';
            message += '\nMessage: ' + e.getMessage();
            message += '\nCause: ' + e.getCause();
            System.debug(message);
            budgetList.get(0).addError(message);
        }
    }
    
    //-----------------Ponse01 starts-------------------------------
  
    if(Trigger.isupdate && Trigger.isAfter){
     Map<string,string> Approvedlanguagetemplatemap=New Map<string,string>();
        Map<string,string> declinedlanguagetemplatemap=New Map<string,string>();
        Map<string,string> Submittedlanguagetemplatemap=New Map<string,string>();
        
         Map<String, MDF_Language_Setting__c> mapStatusCodeCustomSetting = MDF_Language_Setting__c.getAll();
            system.debug('---------'+mapStatusCodeCustomSetting);
        if(mapStatusCodeCustomSetting!=null){
            for(MDF_Language_Setting__c mandatoryRoles : mapStatusCodeCustomSetting.values()){
                if(mandatoryRoles.Recordtype__c=='FR_Approved'){
                    Approvedlanguagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
                }
                if(mandatoryRoles.Recordtype__c=='FR_Declined'){
                    declinedlanguagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
                }
                if(mandatoryRoles.Recordtype__c=='FR_Submitted'){
                    Submittedlanguagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
                }
            }
        }
            
    Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> ();
     map<id,SFDC_MDF__c> partnerFRMap=New map<id,SFDC_MDF__c>();
     set<id> partnerFRid=New set<id>();
     set<id> partnerFRownerid=New set<id>();
    
     set<string> partnerfunentaccountid=New set<string>();
        map<string,id> budgetidaccountmap=New map<string,id>();
        map<id,string> budgetidstatusmap=New map<id,string>();
        
    for(SFDC_MDF__c fr:Trigger.New){
    if(Trigger.oldmap.get(fr.id).Status__c!= Trigger.newMap.get( fr.id ).Status__c && (fr.Status__c=='Approved' || fr.Status__c=='Rejected' || fr.Status__c=='Submitted')){
  
        budgetidstatusmap.put(fr.Id,fr.Status__c);
    partnerFRownerid.add(fr.ownerid);
        if(fr.Account__c!=null)
		    string accidss=String.valueOf(fr.Account__c).substring(0, 15);
    budgetidaccountmap.put(fr.ownerid,fr.id);
           
    }
    
    }
   
    system.debug('partnerfunentaccountid----'+partnerfunentaccountid);
    system.debug('budgetidaccountmap----'+budgetidaccountmap);
    if(partnerFRownerid.size()>0){
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforceatca@ca.com'];
     for(User ur:[select id,Name,toLabel(LanguageLocaleKey),profileid,email,profile.name,contactid,Related_Partner_Account__c from User
                        where id IN:partnerFRownerid and IsActive=True]){
                            system.debug('=====in for users=====');
                            if(budgetidaccountmap.containsKey(ur.id) && budgetidstatusmap.containsKey(budgetidaccountmap.get(ur.id))){
              				Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            //message.toAddresses = new String[] { 'sesidhar.ponnada@ca.com'};
                          message.setToAddresses(new String[] {ur.Email});
                            message.setTargetObjectId(ur.Id);
                                
                            message.setWhatId(budgetidaccountmap.get(ur.id));
                                if(budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Submitted'){
                                    if ( owea.size() > 0 ) {
    										message.setOrgWideEmailAddressId(owea.get(0).Id);
									}
                                }
                            system.debug('budgetidstatusmap----'+budgetidstatusmap.get(budgetidaccountmap.get(ur.id)));
                           if(Approvedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Approved'){
                                
                                message.setTemplateId(Approvedlanguagetemplatemap.get(ur.LanguageLocaleKey));
                            }else if(declinedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Rejected'){
                            
                                message.setTemplateId(declinedlanguagetemplatemap.get(ur.LanguageLocaleKey));
                            }else if(!declinedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Rejected'){
                            
                                message.setTemplateId(declinedlanguagetemplatemap.get('English'));
                            }else if(!Approvedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Approved'){
                                
                                message.setTemplateId(Approvedlanguagetemplatemap.get('English'));
                            }
                                
                                if(Submittedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Submitted'){
                                     message.setTemplateId(Submittedlanguagetemplatemap.get(ur.LanguageLocaleKey));
                                }
                                else if(!Submittedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Submitted'){
                                     message.setTemplateId(Submittedlanguagetemplatemap.get('English'));
                                }
                                
                            message.saveAsActivity = false;
                            messages.add(message);
                          }
        }
        if(messages.size()>0){
        
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: '
                          + results[0].errors[0].message);
                    }
        
        
        }
    }
 }
    //--------------Ponse01 Ends-----------------
}