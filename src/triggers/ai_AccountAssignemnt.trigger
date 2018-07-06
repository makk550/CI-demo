/************************************************************************************************
* Modified By 		 Date           User Story      Details
* SAMAP01       	02/07/2018      US450545 		GPOC: For the existing integrations from EAI to and from SFDC
* SAMAP01			02/22/2018		US450556		GPOC: Revised Technical Implementation, Flow to Support CAT webservice initiating provisioning process
* SAMAP01 			02/22/2018		US479879		GPOC: Cancelled POC -Read only
* **********************************************************************************************/
trigger ai_AccountAssignemnt on Trial_Request__c (after insert, after update, before update) {
    
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration )
        return;
    
    for(Trial_Request__c req:Trigger.new){
        
        try{
            
            Trial_Request__c updateReq = [select Id, Opp_Name__r.Id, account__c,Record_Type__c, originalOppoMilestone__c from Trial_Request__c where id=:req.Id];
            Trial_Request__c oldPoc = Trigger.oldMap.get(req.Id);                
            if(Trigger.isAfter && Trigger.isUpdate ) 
            {
                if ((req.Request_Status__c != oldPoc.Request_Status__c) && (req.Request_Status__c == 'Extension Approved'
                                                                            || req.Request_Status__c == 'Cancelled'  ||   req.Request_Status__c == 'Request Approved' ))
                {
                    string useremail = UserInfo.getUserEmail();
                    System.debug('*** From trigger - Before calling PocUpdate for POC EcommerceOutboundClass.SendPocUpdate****');
                    EcommerceOutboundClass.SendPocUpdate(req.Id,useremail,oldPoc.Request_Status__c); //samap01 -US450545 pass userid
                    System.debug('*** From trigger - after calling PocUpdate for POC EcommerceOutboundClass.SendPocUpdate****');
                    
                }
            }
            
            system.debug('samap01 req.Request_Status__c'+req.Request_Status__c);
            if((Trigger.isAfter && Trigger.isUpdate ) || (Trigger.isAfter && Trigger.isInsert))
            {
                if(req.Request_Status__c =='New' || req.Request_Status__c == 'Request for Approval'  ) //||   req.Request_Status__c =='Update Request for Approval')
                {
                    System.debug('*** From trigger - Update LDAP Id for the contact if it doesnt exist'); 
                    EcommerceOutboundClass.UpdateLdapId(req.Id);
                }
            }
            
            //SAMAP01 -US479879  
            if(Trigger.isBefore && Trigger.isUpdate)
            {
                
                if( req.Request_Status__c == 'Cancelled' || req.Request_Status__c == 'Expired')
                {
                    string newRecordTypeID = Schema.SObjectType.Trial_Request__c.getRecordTypeInfosByName().get('GPOC Cancelled').getRecordTypeId();
                    req.RecordTypeId = newRecordTypeID;
                    System.debug('samap01 newRecordTypeID'+ newRecordTypeID );
                    
                }
                else if(req.Request_Status__c == 'Request Approved' || req.Request_Status__c == 'Completed' ||req.Request_Status__c == 'Available' )
                {
                    string newRecordTypeID = Schema.SObjectType.Trial_Request__c.getRecordTypeInfosByName().get('GPOC Edit').getRecordTypeId();
                    req.RecordTypeId = newRecordTypeID;
                    
                    System.debug('samap01 newRecordTypeID'+ newRecordTypeID );
                }
                else
                {
                    string newRecordTypeID = Schema.SObjectType.Trial_Request__c.getRecordTypeInfosByName().get('GPOC Standard').getRecordTypeId();
                    req.RecordTypeId = newRecordTypeID;
                    //  updatetrials.add(updateReq);
                    System.debug('samap01 newRecordTypeID'+ newRecordTypeID );             
                }
            }
            
            
            
            if(updateReq.account__c == null){
                
                System.debug('Account is null so going to try to update');
                
                Opportunity opp =[SELECT Id, Account.Id, Sales_Milestone_Search__c FROM Opportunity WHERE Id =:updateReq.Opp_Name__r.Id limit 1];
                
                System.debug('Got opportunity');
                
                Account acct = [SELECT Id FROM Account WHERE Id =: opp.Account.Id limit 1];
                
                System.debug('Got Account');
                
                
                if(updateReq.originalOppoMilestone__c == null || updateReq.originalOppoMilestone__c == ''){
                    updateReq.originalOppoMilestone__c= opp.Sales_Milestone_Search__c;
                }
                
                updateReq.account__c = acct.Id;
                update updateReq;
                
                
                System.debug('ai_AccountAssignemnt success');
                
            }
            else{
                System.debug('Account is not null so not going to try to update');
            }
            
            //Trial_Request__c tr = new Trial_Request__c(id= req.Id);
            //tr.account__c = acct.Id;
            //update tr;
            
        }
        catch(Exception ex){
            System.debug('ai_AccountAssignemnt failure' + ex);
        }
    }
    
    
}