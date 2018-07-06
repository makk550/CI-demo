/** Batch Process For TAQ Organization New Hire and Employee Change**/

global class CA_TAQ_Batch_Process_Org_NH_EC {}
//FY 13 - Removed the batches
/*

global class CA_TAQ_Batch_Process_Org_NH_EC implements Database.Batchable<sObject>,Database.Stateful{
    public String query;
    public String email;
    public Map<String,TAQ_Organization_Approved__c> orgAppMap=new Map<String,TAQ_Organization_Approved__c>();
    public List<TAQ_Organization_Approved__c> listTa=new List<TAQ_Organization_Approved__c>();
    public Map<TAQ_Organization_Approved__c,String> StatMap=new Map<TAQ_Organization_Approved__c,String>();
    public Set<TAQ_Organization_Approved__c> OrgListwithAcc=new Set<TAQ_Organization_Approved__c>();
    
    Id toUserId;
    Id fromUserId;

    global database.querylocator start(Database.BatchableContext BC){
        system.debug('Batch Start. Query='+query);
        return Database.getQueryLocator(query);
    }

    public Date getEffDate(String pmfky){
        Date d=system.today();
        Date planTypeDate=d.toStartOfMonth();
    /*    if(pmfky<>null)
            if(orgAppMap.get(pmfky).PlanType_Effective_Date__c<>null)
                return orgAppMap.get(pmfky).PlanType_Effective_Date__c;
            else
                return planTypeDate;
        else* /
            return planTypeDate;
    } 
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    
        
        for(sObject s : scope){
            // whatever pmfkey is there we will collect in OrgKey variable
            String OrgKey=null;
            try {
                Set<Id> Accids=new Set<Id>();
                
                TAQ_Account__c ta = (TAQ_Account__c)s;
                
                //Check all the pmf keys keys of Current Account. 
                
           
               
                if(OrgKey<>null){
                    system.debug('Corresponding TAQ ORG Approved: '+orgAppMap.get(OrgKey));
                    // Heena - added status 'Saved - Not Approved' as part of Req 804
                    if(ta.Approval_Status__c == 'Send For Approval' || ta.Approval_Status__c == 'Saved - Not Approved')
                        StatMap.put(orgAppMap.get(OrgKey),'Reprocess');
                    
                }
                //only if the current record status is not Send for approval then 
                // we will update the current record with approved status
                // Heena - added status 'Saved - Not Approved' as part of Req 804
                if(ta.Approval_Status__c <> 'Send For Approval' || ta.Approval_Status__c <> 'Saved - Not Approved'){
                    ta.Process_Step__c = 'Account Update';
                    ta.Approval_Process_Status__c = 'Approved';
                    
                    update ta;   
                }
                
                //Update Std Account Team Members
                /*if(ta.Reseller_Account_Director_PMFKey__c==null){
                    Account stda=[select id,ownerid from Account where id =:ta.View_Acc_Record__c ];
                
                    AccountTeamMember[] lteam=[select AccountId,UserId,TeamMemberRole from AccountTeamMember where AccountId =: stda.id and TeamMemberRole like 'TAQ-%'];
                    delete lteam;
                    CA_TAQ_AddTeamMem.isflag=true;
                    CA_TAQ_AddTeamMem objTeam=new CA_TAQ_AddTeamMem();
                    objTeam.addMembers(ta,stda);
                }* /
            
            }
            catch(Exception e){
                system.debug('Error occured..'+e);
               // TAQ_SendTestEmails.SendMail('CA_TAQ_Batch_Process_Org_NH_EC', e); 
                //For any exception we will update as 'Reprocess' for corresponding TAQ Org
                if(OrgKey<>null){
                    StatMap.put(orgAppMap.get(OrgKey),'Reprocess');
                }
            }
        
        }
      
    }

    /** Sending mail to the specified email id after finishing the batch job ** /
    
    global void finish(Database.BatchableContext BC){
        
        /** 
            Finally we will check for each TAQ Org Approved if it is there in Stat map
            if it is there then we will update that org status as Reprocess else success
        ** /
        
        Set<TAQ_Organization_Approved__c> OrgkeySt=new Set<TAQ_Organization_Approved__c>();
    
        if(StatMap.size()>0)
            OrgkeySt=StatMap.keySet();
            
        system.debug('All TAQ Org Approved records: '+listTa);
        system.debug('TAQ Orgs to be reprocessed: '+StatMap);
        system.debug('Complete Set of org app with accounts. '+OrgListwithAcc);
        system.debug('Complete Org Map: '+orgAppMap);
            
        String stat='Success-TAQ Updated-NH/EC';
        String stat2='Success-TAQ None Updated-NH/EC';
        for (Integer i = 0; i < listTa.size(); i++){
            
            if(OrgkeySt.contains(listTa[i]))
                listTa[i].Batch_Process_Status_NH__c = 'Reprocess';
            else if(OrgListwithAcc.contains(listTa[i]))
                listTa[i].Batch_Process_Status_NH__c = stat;
            else 
                listTa[i].Batch_Process_Status_NH__c = stat2;
        }
        if(listTa.size()>0){
            TAQOrgAdmin.inFutureContext=true;
            update listTa;
        }
        /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('durgaprasad.ayinala@accenture.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');

        mail.setPlainTextBody('Batch Process has completed');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        * /
    }
} */