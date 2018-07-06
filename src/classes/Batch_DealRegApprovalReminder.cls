global class Batch_DealRegApprovalReminder implements Database.Batchable<sObject>,Schedulable{

    String query = '';
    String wherecaluse = '';
    list<String> OppList  = new List<String>();
    list<ProcessInstanceWorkitem> ListProInsWrkItem  = new List<ProcessInstanceWorkitem>();
    list<Opportunity> ListOpps  = new List<Opportunity>();
    map<string,string> OppWrkItemMap = new map<string,string>();
    map<string,opportunity> OppIdMap = new map<string,opportunity>();
    map<string,User> UsrWrkItemMap = new map<string,User>();
    //public static String CRON_EXP = '0 0 13 * * ?';
    String[] toAddresses = new list<string>() ; 
    List<User> toUsers = new List<User>();
    List<String> toUsersID = new List<string>();
    /* global static String scheduleIt() {
        Batch_DealRegApprovalReminder sm = new Batch_DealRegApprovalReminder();
        return System.schedule('Deal Reg Approval Daily Reminder', CRON_EXP, sm);
    }*/
    global void execute(SchedulableContext ctx) 
    {    
         String CRON_EXP = '0 0 13 * * ?';
         system.debug('execute method batch apex');
        //Added for Test method call
        // if (!Test.isRunningTest()) { 
          system.debug('test inside');
          database.executeBatch(new Batch_DealRegApprovalReminder(),200);
        // }
         //System.schedule('DealRegApprovalReminder_JOB', '0 0 13 * * ?', new Batch_DealRegApprovalReminder());
    }
    
    global Database.Querylocator start(Database.BatchableContext BC)
    {   
        String query;
        for(opportunity opp : [Select id,Deal_Registration_Name__c,Deal_Program__c,Reseller__c,Reseller_Contact__c,Account.Name,Amount,CloseDate,Reseller_Product_Name__c from opportunity where RecordTypeId = '01230000000yspg' and Deal_Approval_Status__c != 'Deal Approved' and Deal_Approval_Status__c != 'Deal Rejected' and Deal_Approval_Status__c != 'Deal Recalled' ]){
          OppList.add(opp.id);
        }
        
        query = 'Select p.Id, p.ProcessInstanceId, p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, p.ActorId, p.OriginalActorId, p.CreatedById from ProcessInstanceWorkitem p';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {    
        
        
        
    }
    global void finish(Database.BatchableContext BC){
     //Batch_DealRegApprovalReminder controller = new Batch_DealRegApprovalReminder () ; 
     //System.schedule('DealRegApprovalReminder_JOB', '0 0 13 * * ?', controller);
     OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'salesforceatca@ca.com'];
     
	 for(opportunity opp : [Select id,Name,Deal_Registration_Name__c,Deal_Program__c,Reseller__r.Name,Reseller_Contact__r.Name,Account.Name,Amount,CloseDate,Reseller_Product_Name__c from opportunity where RecordTypeId = '01230000000yspg' and Deal_Approval_Status__c != 'Deal Approved' and Deal_Approval_Status__c != 'Deal Rejected' and Deal_Approval_Status__c != 'Deal Recalled' ]){
          OppList.add(opp.id);
          ListOpps.add(opp);
        }
        ListProInsWrkItem = [Select p.Id, p.ProcessInstanceId, p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, p.ActorId, p.OriginalActorId, p.CreatedById,ElapsedTimeInDays from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId in :OppList];
        system.debug('list count '+ListProInsWrkItem.size());
        for(ProcessInstanceWorkitem PIW : ListProInsWrkItem){
            for(Opportunity opps:ListOpps){
                if(PIW.ProcessInstance.TargetObjectId == opps.id){
                    OppWrkItemMap.put(PIW.ProcessInstance.TargetObjectId,opps.id);
                    toUsersID.add(PIW.ActorId);
                    system.debug('OppWrkItemMap+'+OppWrkItemMap);
                    OppIdMap.put(opps.id,opps);
                }
            }
        }
        for(User usr : [select id,email,Name from User where id in :toUsersID]){
            toAddresses.add(usr.email);
            UsrWrkItemMap.put(usr.id,usr);
        }
        List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
        for(ProcessInstanceWorkitem PIW : ListProInsWrkItem){
            toAddresses.clear();
            toAddresses.add(UsrWrkItemMap.get(PIW.ActorId).email);
            String closeDate = OppIdMap.get(PIW.ProcessInstance.TargetObjectId).CloseDate.format();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(PIW.ActorId);
            if ( owea.size() > 0 )mail.setOrgWideEmailAddressId(owea.get(0).Id);
            mail.setSubject('REMINDER : CA Deal Registration - Pending Approval : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Account.Name);
            //String messageBody = '<html><body>Dear '+UsrWrkItemMap.get(PIW.ActorId).Name+',<br/><br/> A New Deal registration has been awaiting your approval for more than 24 hours.<br/><br/>Please access the Deal Registration : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PIW.ProcessInstance.TargetObjectId+'">Link</a> and Approve or Reject.<br/><br/>Deal Details :<br/><br/>Deal Registration Name : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Name+'<br/>Deal Program : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Deal_Program__c+'<br/>Partner : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Reseller__r.Name+'<br/>Partner Contact : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Reseller_Contact__r.Name+'<br/>End User : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Account.Name+'<br/>Deal Value : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Amount+'<br/>Expected Close Date : '+closeDate+'<br/>Products : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Reseller_Product_Name__c+'<br/></body>  </html>';
            //String messageBody = '<html><body>Dear '+UsrWrkItemMap.get(PIW.ActorId).Name+',<br/><br/> This to notify you that a deal registration record has been created and needs your approval.<br/><br/>Please review and approve the record below.<br/><br/><br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PIW.ProcessInstance.TargetObjectId+'">Deal Reg Approval Record</a> <br/><br/>Thank you, <br/>CA Technologies, Global Partner Program Team</body>  </html>';
            String messageBody = '<html><body>Dear '+UsrWrkItemMap.get(PIW.ActorId).Name+',<br/><br/> A New Deal registration has been awaiting your approval for more than 24 hours.<br/><br/>Please access the Deal Registration : <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+PIW.ProcessInstance.TargetObjectId+'">'+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Name+'</a> and Approve or Reject.<br/><br/>Deal Details :<br/><br/>Deal Registration Name : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Name+'<br/>Deal Program : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Deal_Program__c+'<br/>Partner : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Reseller__r.Name+'<br/>Partner Contact : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Reseller_Contact__r.Name+'<br/>End User : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Account.Name+'<br/>Deal Value : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Amount+'<br/>Expected Close Date : '+closeDate+'<br/>Products : '+OppIdMap.get(PIW.ProcessInstance.TargetObjectId).Reseller_Product_Name__c+'<br/></body>  </html>';
            mail.setHtmlBody(messageBody);
            system.debug('toAddresses+'+toAddresses);
            mail.setSaveAsActivity(false);
            email.add(mail);
        }
        system.debug('email '+ email.size());
       
        Messaging.sendEmail(email);
    }
    


}