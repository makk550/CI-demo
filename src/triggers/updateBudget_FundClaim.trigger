trigger updateBudget_FundClaim on SFDC_MDF_Claim__c (after insert, after update, after delete, after undelete) {

    /*
     * Recalculates The FundClaim Amount on the Budget on insert, update, delete of a fund claim.
     * Only those FundClaims are considered which are approved (approved__c = true)
     *
     */ 
    List<SFDC_Budget__c> budgetList = new List<SFDC_Budget__c>();
    Set<Id> budgetSet = new Set<Id>();
    
    //list of fund Claim - code added by Siddharth
    List<SFDC_MDF_Claim__c> listOfMDFClaims = new List<SFDC_MDF_Claim__c>();
    MDF_GrantAccessToApprovers classVar = new MDF_GrantAccessToApprovers();

    if (Trigger.isDelete) {
        //for delete
        for (SFDC_MDF_Claim__c changedMDFClaim : Trigger.old) {
            if (changedMDFClaim.Budget__c != null)
                budgetSet.add(changedMDFClaim.Budget__c);
        }
        
    } else {
        if (Trigger.isUpdate) {
            for (Integer i = 0; i < Trigger.size; i++) {
                SFDC_MDF_Claim__c oldMDFClaim = Trigger.old[i];
                SFDC_MDF_Claim__c newMDFClaim = Trigger.new[i];
                Id oldBudgetId = oldMDFClaim.Budget__c;
                Id newBudgetId = newMDFClaim.Budget__c;
                if (oldBudgetId != null) {
                    if (newBudgetId == null || oldBudgetId != newBudgetId) {
                        //budget removed - need to update old budget
                        budgetSet.add(oldBudgetId);
                    }
                } 
                
                //code added by Siddharth in R2 for giving access to approvers of Fund Claim.
                if(oldMDFClaim.MDF_Claim_Approval_Status__c!= 'Submitted' && newMDFClaim.MDF_Claim_Approval_Status__c=='Submitted')
                    listOfMDFClaims.add(newMDFClaim );
                if(oldMDFClaim.MDF_Claim_Approval_Status__c== 'Submitted' && newMDFClaim.MDF_Claim_Approval_Status__c=='First Approval')
                    listOfMDFClaims.add(newMDFClaim );
                if(oldMDFClaim.MDF_Claim_Approval_Status__c== 'First Approval' && newMDFClaim.MDF_Claim_Approval_Status__c=='Second Approval')
                    listOfMDFClaims.add(newMDFClaim );
                System.debug('------- delegated approver'+newMDFClaim.Approver_1__r.DelegatedApproverId);
                //end of if conditions added by Siddharth
                  
            }
            
            //code added by Siddharth in R2- calling the class to give access to the approvers
            if(listOfMDFClaims!=null && listOfMDFClaims.size()>0)
                classVar.giveAccessToMDFClaimApprovers(listOfMDFClaims);
           
        }
        
        for (SFDC_MDF_Claim__c changedMDFClaim : Trigger.new) {
            if (changedMDFClaim.Budget__c != null)
                budgetSet.add(changedMDFClaim.Budget__c);
        }
    }
    budgetList = BudgetUtil.getBudgetList(budgetSet);

    //update the budget objects
    if (budgetList.size() > 0) {
        try {
           BudgetUtil.updateList(budgetList);
        } catch (DmlException e) {
            String message = 'An error occured while Updating Budget: ';
            message += '\nMessage: ' + e.getMessage();
            message += '\nCause: ' + e.getCause();
            System.debug(message);
            budgetList.get(0).addError(message);
        }
    }
    
    //--------------------------------ponse01 starts--------------------------------------
   
        if(Trigger.isupdate && Trigger.isAfter){
        //string appremail='';
                 Map<string,string> Approvedlanguagetemplatemap=New Map<string,string>();
        Map<string,string> declinedlanguagetemplatemap=New Map<string,string>();
         Map<String, MDF_Language_Setting__c> mapStatusCodeCustomSetting = MDF_Language_Setting__c.getAll();
            system.debug('---------'+mapStatusCodeCustomSetting);
            if(mapStatusCodeCustomSetting!=null){
                for(MDF_Language_Setting__c mandatoryRoles : mapStatusCodeCustomSetting.values()){
                    if(mandatoryRoles.Recordtype__c=='FC_Approved'){
                        Approvedlanguagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
                    }
                    if(mandatoryRoles.Recordtype__c=='FC_Declined'){
                        declinedlanguagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
                    }
                    
                }
            }
            
             Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> ();
            set<id> partnerFCownerid=New set<id>();
            set<id> partnerFid=New set<id>();
            map<string,id> budgetidaccountmap=New map<string,id>();
            map<string,id> budgetidrequestmap=New map<string,id>();
            
            map<id,string> budgetidstatusmap=New map<id,string>();
            for(SFDC_MDF_Claim__c fc:Trigger.New){
            
                if(Trigger.oldmap.get(fc.id).Status__c!= Trigger.newMap.get( fc.id ).Status__c && (fc.Status__c=='Approved' || fc.Status__c=='Rejected')){
                
                    budgetidstatusmap.put(fc.id,fc.Status__c);
                    budgetidrequestmap.put(fc.Budget__c,fc.id);
                    partnerFid.add(fc.Budget__c);
                    partnerFCownerid.add(fc.CreatedByid);
                    budgetidaccountmap.put(fc.CreatedByid, fc.Id);
                }
            }
            if(partnerFid.size()>0){
            for(SFDC_Budget__c sb:[select id,Fund_Program__c,Account__c,Fund_Program__r.Fund_Request_Level_1_Approver__r.email from SFDC_Budget__c where id IN:partnerFid]){
                partnerFCownerid.add(sb.Fund_Program__r.Fund_Request_Level_1_Approver__c);
                
               // appremail=sb.Fund_Program__r.Fund_Request_Level_1_Approver__r.email;
            }
            }
            if(partnerFCownerid.size()>0){
                
                for(User ur:[select id,Name,toLabel(LanguageLocaleKey),profileid,email,profile.name,contactid,Related_Partner_Account__c from User
                        where id IN:partnerFCownerid and IsActive=True]){
                            system.debug('=====in for users=====');
            		 if(budgetidaccountmap.Containskey(ur.id) && budgetidstatusmap.Containskey(budgetidaccountmap.get(ur.id))){
              Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                           // message.toAddresses = new String[] { 'sesidhar.ponnada@ca.com'};
                          message.setToAddresses(new String[] {ur.Email});
                            message.setTargetObjectId(ur.Id);
                           
                            system.debug('---budgetidaccountmap----'+budgetidaccountmap.get(ur.id));
                            system.debug('---budgetidstatusmap----'+budgetidstatusmap.get(budgetidaccountmap.get(ur.id)));
                              message.setWhatId(budgetidaccountmap.get(ur.id));
                           if(Approvedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Approved'){
                                
                                message.setTemplateId(Approvedlanguagetemplatemap.get(ur.LanguageLocaleKey));
                            }else if(declinedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Rejected'){
                            
                                message.setTemplateId(declinedlanguagetemplatemap.get(ur.LanguageLocaleKey));
                            }else if(!declinedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Rejected'){
                            
                                message.setTemplateId(declinedlanguagetemplatemap.get('English'));
                            }else if(!Approvedlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && budgetidstatusmap.get(budgetidaccountmap.get(ur.id))=='Approved'){
                                
                                message.setTemplateId(Approvedlanguagetemplatemap.get('English'));
                            }
                            message.saveAsActivity = false;
                            messages.add(message);
                     }  
        }
                if(messages.size()>0){
        
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }
            }
        
        }

    //--------------------------------ponse01 Ends--------------------------------------
}