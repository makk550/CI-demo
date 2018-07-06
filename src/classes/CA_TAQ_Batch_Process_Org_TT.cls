/** Batch Process For TAQ Organization New Hire and Employee Change**/
global class CA_TAQ_Batch_Process_Org_TT{}

//FY13 - removed the batch functionality
/*
global class CA_TAQ_Batch_Process_Org_TT implements Database.Batchable<sObject>,Database.Stateful{
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
        if(pmfky<>null)
            if(orgAppMap.get(pmfky).PlanType_Effective_Date__c<>null)
                return orgAppMap.get(pmfky).PlanType_Effective_Date__c;
            else
                return planTypeDate;
        else
            return planTypeDate;
    } 
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    
        
        for(sObject s : scope){
    
            // whatever pmfkey is there we will collect in OrgKey variable
            String OrgKey=null;
            try{
                Set<Id> Accids=new Set<Id>();
                
                TAQ_Account__c ta = (TAQ_Account__c)s;
                
                //Check all the pmf keys keys of Current Account. 
                
                if(ta.Account_Owner_PMF_Key__c != null && orgAppMap.containsKey(ta.Account_Owner_PMF_Key__c.toUpperCase())){       
                    
                    OrgKey=ta.Account_Owner_PMF_Key__c.toUpperCase(); 
                    OrgListwithAcc.add(orgAppMap.get(ta.Account_Owner_PMF_Key__c.toUpperCase()));
                    
                    ta.Account_Owner_Effective_Date__c  =getEffDate(ta.Account_Owner_PMF_Key__c.toUpperCase());
                    ta.Account_Owner_Manager_PMFKey__c=orgAppMap.get(ta.Account_Owner_PMF_Key__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.Account_Owner_PMF_Key__c=orgAppMap.get(ta.Account_Owner_PMF_Key__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_AO_PMFKey_changed__c=true; 
                    
                    
                } 
                if(ta.Sales_Director_PMF_Key__c != null && orgAppMap.containsKey(ta.Sales_Director_PMF_Key__c.toUpperCase())){       
                    
                    OrgKey=ta.Sales_Director_PMF_Key__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.Sales_Director_PMF_Key__c.toUpperCase()));
                    
                    ta.SM_Effective_Date__c  = getEffDate(ta.Sales_Director_PMF_Key__c.toUpperCase());
                    ta.Sales_Director_Manager_PMFKey__c=orgAppMap.get(ta.Sales_Director_PMF_Key__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.Sales_Director_PMF_Key__c=orgAppMap.get(ta.Sales_Director_PMF_Key__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SD_PMFKey_changed__c=true;
                    
                    
                }
                if(ta.CSA_PMF_Key__c != null && orgAppMap.containsKey(ta.CSA_PMF_Key__c.toUpperCase())){       
                
                    OrgKey=ta.CSA_PMF_Key__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.CSA_PMF_Key__c.toUpperCase()));
                    
                    ta.CSA_Effective_Date__c  = getEffDate(ta.CSA_PMF_Key__c.toUpperCase());
                    ta.CSA_Manager_PMFKey__c=orgAppMap.get(ta.CSA_PMF_Key__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.CSA_PMF_key__c=orgAppMap.get(ta.CSA_PMF_Key__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_CSA_PMFKey_changed__c=true;
                    
                    
                }
                if(ta.SS_MF_PMFKey__c != null &&  orgAppMap.containsKey(ta.SS_MF_PMFKey__c.toUpperCase())){       
    
                    OrgKey=ta.SS_MF_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.SS_MF_PMFKey__c.toUpperCase()));
                    
                    ta.SS_MF_Effective_Date__c  = getEffDate(ta.SS_MF_PMFKey__c.toUpperCase());
                    ta.SS_MF_Manager_PMFKey__c=orgAppMap.get(ta.SS_MF_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.SS_MF_PMFKey__c=orgAppMap.get(ta.SS_MF_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SS_MF_PMFKey_changed__c=true;
                    
                    
                }
                if(ta.SS_PPM_PMFKey__c != null && orgAppMap.containsKey(ta.SS_PPM_PMFKey__c.toUpperCase())){       
                    OrgKey=ta.SS_PPM_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.SS_PPM_PMFKey__c.toUpperCase()));
                    
                    ta.SS_PPM_Effective_Date__c  = getEffDate(ta.SS_PPM_PMFKey__c.toUpperCase());
                    ta.SS_PPM_Manager_PMFKey__c=orgAppMap.get(ta.SS_PPM_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.SS_PPM_PMFKey__c=orgAppMap.get(ta.SS_PPM_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SS_PPM_PMFKey_changed__c=true;
                    
                    
                }
                if(ta.SS_SA_PMFKey__c != null && orgAppMap.containsKey(ta.SS_SA_PMFKey__c.toUpperCase() )){   
                    
                    OrgKey=ta.SS_SA_PMFKey__c.toUpperCase();  
                    OrgListwithAcc.add(orgAppMap.get(ta.SS_SA_PMFKey__c.toUpperCase()));
                      
                    ta.SS_SA_Effective_Date__c  = getEffDate(ta.SS_SA_PMFKey__c.toUpperCase());
                    ta.SS_SA_Manager_PMFKey__c=orgAppMap.get(ta.SS_SA_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.SS_SA_PMFKey__c=orgAppMap.get(ta.SS_SA_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SS_SA_PMFKey_changed__c=true;
                    
                    
                }
                if( ta.SS_SEC_PMFKey__c != null && orgAppMap.containsKey(ta.SS_SEC_PMFKey__c.toUpperCase())){       
                
                    OrgKey=ta.SS_SEC_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.SS_SEC_PMFKey__c.toUpperCase()));
                    
                    ta.SS_SEC_Effective_Date__c  = getEffDate(ta.SS_SEC_PMFKey__c.toUpperCase());
                    ta.SS_SEC_Manager_PMFKey__c=orgAppMap.get(ta.SS_SEC_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.SS_SEC_PMFKey__c=orgAppMap.get(ta.SS_SEC_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SS_SEC_PMFKey_changed__c=true;
                    
                }
                
                if(ta.SS_VSA_PMFKey__c != null && orgAppMap.containsKey(ta.SS_VSA_PMFKey__c.toUpperCase())){       
                
                    OrgKey=ta.SS_VSA_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.SS_VSA_PMFKey__c.toUpperCase()));
                    
                    ta.SS_VSA_Effective_Date__c  = getEffDate(ta.SS_VSA_PMFKey__c.toUpperCase());
                    ta.SS_VSA_Manager_PMFKey__c=orgAppMap.get(ta.SS_VSA_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.SS_VSA_PMFKey__c=orgAppMap.get(ta.SS_VSA_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SS_VSA_PMFKey_changed__c=true;
                    
                    
                }
                if(ta.Regional_Alliance_Director_PMF_Key__c != null && orgAppMap.containsKey(ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase())){       
                
                    OrgKey=ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase()));
                    
                    ta.Regional_Alliance_Director_Eff_Date__c  = getEffDate(ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase());
                    ta.Regional_Alliance_Director_PMF_Key__c=orgAppMap.get(ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase()).position_id__c;
                    
                }
                if(ta.Reseller_Account_Director_PMFKey__c != null && orgAppMap.containsKey(ta.Reseller_Account_Director_PMFKey__c.toUpperCase())){       
                    OrgKey=ta.Reseller_Account_Director_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.Reseller_Account_Director_PMFKey__c.toUpperCase()));
                    
                    ta.Reseller_Account_Director_Effective_Date__c  = getEffDate(ta.Reseller_Account_Director_PMFKey__c.toUpperCase());
                    ta.Reseller_Account_Director_PMFKey__c=orgAppMap.get(ta.Reseller_Account_Director_PMFKey__c.toUpperCase()).position_id__c;
                    
                    
                }
                if( ta.SAM_PMFKey__c != null && orgAppMap.containsKey(ta.SAM_PMFKey__c.toUpperCase())){       
    
                    OrgKey=ta.SAM_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.SAM_PMFKey__c.toUpperCase()));
                    
                    ta.SAM_Effective_Date__c  = getEffDate(ta.SAM_PMFKey__c.toUpperCase());
                    ta.SAM_Manager_PMFKey__c=orgAppMap.get(ta.SAM_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.SAM_PMFKey__c=orgAppMap.get(ta.SAM_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_SAM_PMFKey_changed__c=true;
                    
                }
                if(ta.GPS_PMFKey__c != null && orgAppMap.containsKey(ta.GPS_PMFKey__c.toUpperCase())){       
                    
                    OrgKey=ta.GPS_PMFKey__c.toUpperCase();
                    OrgListwithAcc.add(orgAppMap.get(ta.GPS_PMFKey__c.toUpperCase()));
                    
                    ta.GPS_Effective_Date__c  = getEffDate(ta.GPS_PMFKey__c.toUpperCase());
                    ta.GPS_Manager_PMFKey__c=orgAppMap.get(ta.GPS_PMFKey__c.toUpperCase()).Manager_PMFKey__c.toUpperCase();
                    ta.GPS_PMFKey__c=orgAppMap.get(ta.GPS_PMFKey__c.toUpperCase()).position_id__c;
                    
                    //ta.Is_GPS_PMFkey_changed__c=true;
                    
                }
                
                /** Based on OrgKey variable we will collect the TAQ Org from Map and 
                *   fill another StatMap with the corresponding TAQ Org as key and Reprocess as value
                ** /
                system.debug('Approval Status 2: '+ta.Approval_Status__c);
                system.debug('Complete Set of org app with accounts. '+OrgListwithAcc);
                system.debug('corresponding TAQ Org......'+orgAppMap.get(OrgKey));
                
                if(OrgKey<>null){
                    system.debug('DBG::OrgKey value..'+OrgKey);
                    // Heena - added status 'Saved - Not Approved' as part of Req 804
                    if(ta.Approval_Status__c == 'Send For Approval' || ta.Approval_Status__c =='Saved - Not Approved')
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
                //For any exception we will update as 'Reprocess' for corresponding TAQ Org
                if(OrgKey<>null){
                    StatMap.put(orgAppMap.get(OrgKey),'Reprocess');
                  }
               // TAQ_SendTestEmails.SendMail('CA_TAQ_Schedule_Org_TT', e);    
                system.debug('Error occured '+e);
            }    
            
        }
        
        
      
    }

    /** Sending mail to the specified email id after finishing the batch job ** /
    
    global void finish(Database.BatchableContext BC){
       
       /** After updation of all TAQ Accounts and the Std Account team members
        *   Updated the Org Approved Records with the Success Status;
        ** /
           
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
        
        String stat='Success-TAQ Updated-TT';
        String stat2='Success-TAQ None Updated-TT';
        for (Integer i = 0; i < listTa.size(); i++){
            
            if(OrgkeySt.contains(listTa[i]))
                listTa[i].Batch_Process_Status_TT__c = 'Reprocess';
            else if(OrgListwithAcc.contains(listTa[i]))
                listTa[i].Batch_Process_Status_TT__c = stat;
            else 
                listTa[i].Batch_Process_Status_TT__c = stat2;
             
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
}
*/