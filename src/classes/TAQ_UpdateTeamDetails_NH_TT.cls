Global Class TAQ_UpdateTeamDetails_NH_TT{

   public static boolean isExecuting = false;
        

   public TAQ_Rules__c GetRuleMatch (TAQ_Organization__c ta, List<TAQ_Rules__c> lstRule,Boolean isApprover)
   {

    string Send_To; 
    if(!isApprover)
    {
        Send_To='Requestor';
    }
    else
        Send_To='Approver';
        
    for(TAQ_Rules__c tr: lstRule)
    {
        if((tr.Region__c==ta.Region__c || tr.Region__c==NULL)
         && (tr.Organization__c==ta.Organization__c || tr.Organization__c==NULL)                                        
                                        && (tr.Area__c==ta.Area__c || tr.Area__c==NULL)
                                        && (tr.Business_Unit__c==ta.Business_Unit__c || tr.Business_Unit__c==NULL)
                                        && (tr.Object_Name__c=='TAQ Organization')
                                         && (tr.Send_To__c==Send_To))
           {                          
                    return tr;
            }
                                         
        
    }
        return null;
   }
   
    public TAQ_Rules__c GetRuleMatch_taqAcc (TAQ_Account__c ta, List<TAQ_Rules__c> lstRule,Boolean isApprover)
   {

   System.debug('**********************GetRuleMatch_taqAcc');
    string Send_To;
    if(!isApprover)
    {
        Send_To='Requestor';
    }
    else
        Send_To='Approver';
   
    for(TAQ_Rules__c tr: lstRule) 
    {
        
        if(tr.Record_Type_ID__c == ta.RecordTypeId && ta.Approval_Process_Status__c=='Send For Approval' 
               && ta.Process_Step__c=='Account Add' && ta.Partner_On_boarding__c== tr.Partner_On_boarding__c && ta.Partner_On_Boarding__c==true && ((ta.Referral_Partner__c == true && tr.Referral_Partner__c == ta.Referral_Partner__c && ta.Solution_Provider_Type__c != 'Reseller')||(ta.Referral_Partner__c == false && tr.Referral_Partner__c == ta.Referral_Partner__c) ||(ta.Referral_Partner__c == true && tr.Referral_Partner__c != ta.Referral_Partner__c && ta.Solution_Provider_Type__c == 'Reseller'))){
            System.debug('*** IF -1**'+tr);
            return tr;
        }
        
        
        else if( ((tr.Record_Type_ID__c == ta.RecordTypeId) || (tr.Record_Type_ID__c==NULL)) && 
        
        
       (  Send_To=='Requestor'?true: ((( tr.DM_Account__c <> null ? (tr.DM_Account__c ? 'True' :'False') :'False' )== (ta.DM_Only_Account__c <> null?ta.DM_Only_Account__c:'False')) || (tr.DM_Account__c==NULL)) ) &&
       
        ( ( Send_To=='Requestor' && ( ta.Process_Step__c =='Account Merge' || ta.Process_Step__c =='Account Release') )?  tr.TAQ_Account_Released__c :true)&&
        ((tr.Region__c==ta.Region__c) || (tr.Region__c==NULL))  &&
        ((tr.Area__c==ta.Area__c) || (tr.Area__c==NULL))  && 
        (tr.Object_Name__c=='TAQ Account')  &&
        (tr.Send_To__c==Send_To) && ((ta.Referral_Partner__c == true && tr.Referral_Partner__c == ta.Referral_Partner__c && ta.Solution_Provider_Type__c != 'Reseller')||(ta.Referral_Partner__c == false && tr.Referral_Partner__c == ta.Referral_Partner__c) ||(ta.Referral_Partner__c == true && tr.Referral_Partner__c != ta.Referral_Partner__c && ta.Solution_Provider_Type__c == 'Reseller')))
        {  System.debug('*** IF -2**'+tr);
           return tr;
        }
                                         
        
    }
        return null;
   }
  
  
  
   @future
   public static void updateTeamDetailsFuture(Map<string,string> mPMF_Position, Map<string,Date> mPMF_EffectiveDate , set<id> taqOrgIds , Map<string,string> pmfManagerMap, Map<string,string> positionManagerMap){
   
     List<TAQ_Account_Team__c> updateTeamList = fetchAccountTeamRecords(mPMF_Position);
     
     updateTeamDetails(updateTeamList, mPMF_Position, mPMF_EffectiveDate,taqOrgIds , pmfManagerMap, positionManagerMap);
     

    }
    
   public static List<TAQ_Account_Team__c> fetchAccountTeamRecords(Map<string,string> mPMF_Position)
   {
     //  return [SELECT Id,PMFKey__c,TAQ_Account__c,TAQ_Account__r.Process_Step__c from TAQ_Account_Team__c where PMFKey__c in: mPMF_Position.keyset() and TAQ_Account__r.Process_Step__c <> 'Account Merge' and  TAQ_Account__r.Process_Step__c <> 'Account Release' ];
     RETURN [SELECT User__c,taq_account__r.recordtypeid,taq_account__r.Process_Step__c,taq_account__r.Approval_Process_Status__c,taq_account__r.Approval_Status__c,  taq_account__c,taq_account__r.View_Acc_Record__c,  PMFKey__c, Is_Account_Owner__c from TAQ_Account_Team__c where PMFKey__c in: mPMF_Position.keyset()  and taq_account__r.Process_Step__c != 'Account Release' and taq_account__r.Process_Step__c != 'Account Merge' ]; 
   } 
    
             
   public static void updateTeamDetails(List<TAQ_Account_Team__c> updateTeamList, Map<string,string> mPMF_Position, Map<string,Date> mPMF_EffectiveDate, set<id> taqOrgIds, Map<String,String> pmfManagerMap, Map<string,string> positionManagerMap)
   {
   
   TAQ_Account_Team__c tc = new TAQ_Account_Team__c();
      system.debug('positio -pmfkey --> ' + mPMF_Position);
   /* To check number of batch jobs currently running */
       Integer numberofbatches = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')];
              if (numberofbatches < 5)
              { 
                    system.debug('adfasdfadsfda -->');
                    batchTAQAccountTeam btTAQAccTeam = new batchTAQAccountTeam(updateTeamList, mPMF_Position , mPMF_EffectiveDate,taqOrgIds, pmfManagerMap, positionManagerMap);
                    
                    Id BatchNumber = database.executeBatch(btTAQAccTeam,10); 
                                        system.debug('BatchNumber -->' + BatchNumber );
                    try
                    {                        
                        List<TAQ_Organization__c> listTaqOrg = new List<TAQ_Organization__c>();
                         listTaqOrg = [select id,position_id__c,Position_ID_Status__c,Employee_Status__c,Employee_Status_Date__c from TAQ_organization__c where id in: taqOrgIds];
                                                                system.debug('listTaqOrg -->' + listTaqOrg );
                        if(listTaqOrg != null)  
                        {
                         for(TAQ_Organization__c t: listTaqOrg)
                             {
                                t.Batch_Number__c = BatchNumber;                                                               
                             }
                            SystemIdUtility.skipTAQ_Organization = true ;        
                                update listTaqOrg ; 
                            SystemIdUtility.skipTAQ_Organization = false ; 
                        }
                    }
                    catch(Exception ex)
                    {
                    system.debug('Exception when retrieving TAQ ORg.');
                    }  
                                                
             }             
             else
             {
                 tc.addError('Records cannot be processed now .Please try after somtime.');
             }
     } 

     @future
     public static void updateSubordinateTAQOrgRecords(Set<String> terminatedPMFKeys,Set<String> newHirePositionIds,Map<string,string> mPMF_Position,Map<String,String> pmfManagerName,Map<String,String> positionIdsmap){
        System.debug('Flag =' +Opportunity_ContactRole_Class.skipTAQBatch);
         if(Opportunity_ContactRole_Class.skipTAQBatch == true) return;
        
         System.debug('____INSIDE METH444');
         /*if(positionIdsmap.keySet()!=null){
             try{    
               List<TAQ_Account_team__c> accteamlist = [SELECT PMFKey__c from TAQ_Account_Team__c where PMFKey__c in: positionIdsmap.keySet()];
               for(TAQ_Account_team__c t: accteamlist){
                 t.PMFKey__c = positionIdsMap.get(t.PMFKey__c);
               }
              database.update(accteamlist);
           }catch(Exception e){
             System.debug('____Exception while updating account team mem'+e.getMessage());
           }
         }*/
        List<TAQ_Organization__c> TAQOrgUpdate_TT = new List<TAQ_Organization__c>();
        List<TAQ_Organization__c> TAQOrgUpdate_NH = new List<TAQ_Organization__c>();
        List<TAQ_Organization__c> subordinatesList;
        List<TAQ_Organization__c> subordinatesListNH;
        
        if(terminatedPMFKeys!=null){
            subordinatesList = [select Manager_PMF_Key__c,Manager_Name__c,Record_Sent_To_Approver__c,Approval_Process_Status__c,Approval_Status__c from TAQ_Organization__c where Manager_PMF_Key__c IN: terminatedPMFKeys AND Process_Step__c!='Term / Transfer'];
            
            if(subordinatesList.size()>0){
                for(TAQ_Organization__c TO:subordinatesList){
                    if(mPMF_Position.containsKey(TO.Manager_PMF_Key__c.toUpperCase())){
                        TO.Manager_PMF_Key__c = mPMF_Position.get(TO.Manager_PMF_Key__c.toUpperCase());
                        TO.Manager_Name__c = 'Open_' + TO.Manager_PMF_Key__c;
                        TO.Approval_Process_Status__c = '';
                        TO.Approval_Status__c = 'Approved';
                        TO.Employee_Status_Date__c = System.today();
                        TAQ_OrgActions.MGR_PMFCHANGECHECK_REQ = false;       
                        System.debug('____111q');                 
                        TAQOrgUpdate_TT.add(TO);
                    }
                } 
            }
        }
       
        
        if(newHirePositionIds!=null){
            subordinatesListNH = [select Manager_PMF_Key__c,Manager_Name__c,Approval_Process_Status__c,Approval_Status__c from TAQ_Organization__c where Manager_PMF_Key__c IN: newHirePositionIds AND Process_Step__c!='Term / Transfer'];
            System.debug('__subordinatesListNH :'+subordinatesListNH );
            if(subordinatesListNH.size() > 0){
                for(TAQ_Organization__c TO:subordinatesListNH){
                   
                    if(mPMF_Position.containsKey(TO.Manager_PMF_Key__c.toUpperCase())){     
                        System.debug('__Manager PMF on NH:'+mPMF_Position.get(TO.Manager_PMF_Key__c.toUpperCase()));
                            TO.Manager_PMF_Key__c = mPMF_Position.get(TO.Manager_PMF_Key__c.toUpperCase());                            
                            if(pmfManagerName.containsKey(TO.Manager_PMF_Key__c.toUpperCase())){
                                TO.Manager_Name__c = pmfManagerName.get(TO.Manager_PMF_Key__c.toUpperCase());
                            }                            
                            TO.Approval_Process_Status__c = '';
                            TO.Approval_Status__c = 'Approved';
                            TO.Employee_Status_Date__c = System.today();
                            TAQ_OrgActions.MGR_PMFCHANGECHECK_REQ = false;
                            System.debug('___222q');
                            TAQOrgUpdate_NH.add(TO);
                    }
                }
                
            }
        }
        if(TAQOrgUpdate_TT.size()>0 || TAQOrgUpdate_NH.size()>0){
            SystemIdUtility.isneeded=true;
            SystemIdUtility.isFutureUpdate = true;
            try{
                Database.SaveResult[] lsr, lsr1;
                if(TAQOrgUpdate_TT!=null && TAQOrgUpdate_TT.size()>0)
                lsr = database.update(TAQOrgUpdate_TT,false);
                if(TAQOrgUpdate_NH!=null && TAQOrgUpdate_NH.size()>0)
                lsr1 = database.update(TAQOrgUpdate_NH,false);
                TAQ_OrgActions.MGR_PMFCHANGECHECK_REQ = true;
                for(Database.SaveResult sr:lsr){
                     if(!sr.isSuccess())
                         System.debug('____YYYY_____'+sr.getErrors()[0]);
                    Opportunity_ContactRole_Class.skipTAQBatch = true;
                }
                for(Database.SaveResult sr:lsr1){
                     if(!sr.isSuccess())
                         System.debug('____YYYY_____'+sr.getErrors()[0]);
                    Opportunity_ContactRole_Class.skipTAQBatch = true;
}
                
            }catch(Exception e){
                System.debug('++++++Exception++++++'+e);
                Opportunity_ContactRole_Class.skipTAQBatch = false;
            }
        }       
     } 
   
}