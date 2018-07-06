/**
* Description :This trigger contain automated actions to change the record owner to corresponding queue once
*              a record is approved/rejected/send for approval.
*              This trigger invokes commitActions method from CA_TAQ_Trigger_class to
*          perform various actions of Open Headcount/New Hire/Employee change/Term Transfer Processes.
*               
* Author       : Jagan Babu Gorre
* Company      : Accenture
* Client       : Computer Associates
* Last Update  : March 2010
**/


trigger CA_TAQ_Org_Approval on TAQ_Organization__c (before insert,before update,after insert){
    if(SystemIdUtility.skipTAQ_Organization) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;

    //Added by Saba FY12
    /*    if(FutureProcessor_TAQ.skiporgtriggers) //This trigger is being called from future method for subordinate manager info updation - FutureProcessor_TAQ.UpdateSubordinate
               return; */
    //CRM sprint 4 - TAQ Reject start  1
   Map<id, TAQ_Organization__c> mapRejected = new Map<id,TAQ_Organization__c>();
   //CRM sprint 4 - TAQ Reject end   1 
  set<string> region = new set<string>(); 
  set<string> org = new set<string>();
  set<string> area = new set<string>();
  set<string> bu = new set<string>();



if(trigger.isBefore && trigger.isUpdate){
    for(TAQ_Organization__c ta: trigger.New)
        if(ta.Approval_Process_Status__c != null)
            CA_TAQ_Account_Approval_Class.SELECTED_STATUS.put(ta.Id,ta.Approval_Process_Status__c);
}



for(TAQ_Organization__c ta: trigger.New)
{
    region.add(ta.Region__c);
    org.add(ta.Organization__c);
    area.add(ta.Area__c);
    bu.add(ta.Business_Unit__c);
     
}




     
   Map<string,string> mapPositionId = new Map<string,string>(); 
   Map<string,date> mapdate = new Map<string,date>(); 
   Map<string,string> mapName = new Map<string,string>(); 
   List<TAQ_Organization__c> apprOrgRec = new List<TAQ_Organization__c>();
   List<TAQ_Organization__c> commitActionList = new List<TAQ_Organization__c>();
   
 
   
       
    try{
    
    Map<String,id> recTypMap = new Map<String,id>();    
    
    if (Trigger.new[0].Approval_Process_Status__c=='Migrated'){
        for(RecordType rec:[SELECT name, id FROM RecordType WHERE SobjectType='TAQ_Organization__c'])
            recTypMap.put(rec.name.toUpperCase(), rec.id);  
    }
        
        
       
      
    
   /* Map<Id,TAQ_Rules__c> mapRules = new map<Id,TAQ_Rules__c>( [select Object_Name__c,Region__c,Organization__c,Area__c, Business_Unit__c, Owner_Name_Id__c,Send_To__c
                                        from TAQ_Rules__c    where (Region__c in :region  or Region__c=NULL)
                                        and (Organization__c IN :org  or Organization__c=NULL)
                                        and (Area__c IN: area or Area__c=NULL)
                                        and (Business_Unit__c IN :bu or Business_Unit__c=NULL)
                                        and Object_Name__c='TAQ Organization' 
                                        ORDER BY Region__c DESC NULLS LAST,
                                        Organization__c DESC NULLS LAST,
                                        Area__c DESC NULLS LAST,
                                        Business_Unit__c DESC NULLS LAST]);*/
                                        
   // TAQ_Rules__c[] tarules= mapRules.values();
    
    
    List<TAQ_Rules__c> orderedRules =  [select Object_Name__c,Region__c,Organization__c,Area__c, Business_Unit__c, Owner_Name_Id__c,Send_To__c
                                        from TAQ_Rules__c    where (Region__c in :region  or Region__c=NULL)
                                        and (Organization__c IN :org  or Organization__c=NULL)
                                        and (Area__c IN: area or Area__c=NULL)
                                        and (Business_Unit__c IN :bu or Business_Unit__c=NULL)
                                        and Object_Name__c='TAQ Organization' 
                                        ORDER BY Region__c DESC NULLS LAST,
                                        Organization__c DESC NULLS LAST,
                                        Area__c DESC NULLS LAST,
                                        Business_Unit__c DESC NULLS LAST]; 
                                        
     Map<Id,TAQ_Rules__c> mapRules = new Map<Id,TAQ_Rules__c>();
                           
        for(TAQ_Rules__c t: orderedRules)
        {
               mapRules.put(t.Id,t);
        }                                           
   
           //OPTIMIZED CODE.
             List<String> icCurrStr = new List<String>();
              List<String> jobTitStr = new List<String>();
              List<String> cosCenStr = new List<String>();
              
              for(TAQ_Organization__c taa: trigger.new){
                 icCurrStr.add(taa.IC_Currency_For_Data_Load__c);
                 jobTitStr.add(taa.Job_Title_For_Data_Load__c);
                 cosCenStr.add(taa.Cost_Center_Desc_For_Data_Load__c);
              }
              
              
              List<TAQ_Currency_Conversion__c> icCur = [ select id from TAQ_Currency_Conversion__c where name in: icCurrStr]; 
              List<TAQ_Job_Info__c> jobTit = [select id from TAQ_Job_Info__c  where name in: jobTitStr];
              List<TAQ_Cost_Center__c> costCent = [select id from TAQ_Cost_Center__c where name in: cosCenStr];
              
              map<String,TAQ_Currency_Conversion__c> currConvMap = new Map<String,TAQ_Currency_Conversion__c>();  
              map<String,TAQ_Job_Info__c> jobInfoMap = new Map<String,TAQ_Job_Info__c>();  
              map<String,TAQ_Cost_Center__c> costCentMap = new Map<String,TAQ_Cost_Center__c>();  
              
              for(TAQ_Currency_Conversion__c t: icCur){
                currConvMap.put(t.Name,t);
              }
              for(TAQ_Job_Info__c t: jobTit){
                jobInfoMap.put(t.Name,t);
              }
              for(TAQ_Cost_Center__c t: costCent){
                costCentMap.put(t.Name,t);
              }
  
  
  
  
      
    for(TAQ_Organization__c ta: Trigger.new){
    
        if(trigger.isBefore){    
        
         /** If the record is Approved and came back to requestor and if the
                *   requestor modified the record and save it with out selecting 
                *   "Send For Approval" then Approval Status 2 will become as "Modified". 
                *   changes made by Heena as part of Req 804 SFDC CRM 7.1 Begins
                **/
        if(ta.Approval_Process_Status__c==null && SystemIdUtility.isneeded==true){//---*****---           
            ta.Approval_Status__c = 'Approved';            
            commitActionList.add(ta);  
            apprOrgRec.add(ta);           
        }else if(ta.Approval_Process_Status__c==null && (ta.Approval_Status__c == 'Approved' || ta.Approval_Status__c == 'Migrated' 
          || ta.Approval_Status__c == 'Rejected' || ta.Approval_Status__c == 'Updated' || ta.Approval_Status__c == 'Send For Approval') ){       
            //TO BYPASS SAVED - NOT APPROVED WHEN TAQ ORG QUOTA RECORDS ARE CREATED.
             if(!(CA_TAQ_Account_Approval_Class.SELECTED_STATUS.containsKey(ta.id) && (CA_TAQ_Account_Approval_Class.SELECTED_STATUS.get(ta.id) == 'Rejected' || CA_TAQ_Account_Approval_Class.SELECTED_STATUS.get(ta.id) == 'FROM ORG QUOTA'))) {           
                   ta.Approval_Status__c = 'Saved - Not Approved';
             }   
                       
        }  
        // Changes made by Heena as part of Req 804 SFDC CRM 7.1 Ends         
        // Determine if the action is from SFDC UI or data load
        if(ta.Approval_Process_Status__c=='Submitted' 
            || ta.Approval_Process_Status__c=='Approved'
            || ta.Approval_Process_Status__c=='Rejected'
            || ta.Approval_Process_Status__c=='Approved-Updated'
            || ta.Approval_Process_Status__c=='Updated'
            || ta.Approval_Process_Status__c=='Send For Approval' )   {  
                
                if(ta.Distribute_Plan__c==null && ta.Approval_Process_Status__c=='Approved-Updated')
                    ta.Distribute_Plan__c='Yes';
                
                
                /*** Changing Owner to the Requestor Queue once record is Approved **/

                if(ta.Approval_Process_Status__c=='Approved' || ta.Approval_Process_Status__c=='Rejected')
                {
                                    
                    TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
                    TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch (ta, orderedRules,false);
                    ta.Is_Error_in_Rule__c=(tr==null);
                    if(tr!=null)
                    {
                         ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;//(ta.Region__c+'||'+ta.Organization__c+'||'+ta.Area__c+'||'+ta.Business_Unit__c).Owner_Name_Id__c;
                        if(ta.Approval_Process_Status__c=='Rejected' )
                        {
                            ta.Approval_Process_Status__c='';    
                            ta.Record_Sent_To_Approver__c=false;
                            ta.Approval_Status__c='Rejected'; 
                             MapRejected.put(ta.id,ta);
       
                        }
                       
                   }
                }
                
               /** Invoking method from separate class to perform Actions once record is Approved **/                
    
                if(ta.Approval_Process_Status__c=='Approved-Updated'){   
                    ta.Approval_Status__c='Approved';
                    if(ta.Is_Error_in_Rule__c==false)
                    {                 
                        ta.Record_Sent_To_Approver__c=false;
                        ta.Approval_Process_Status__c='';
                    }
                    else
                        ta.Approval_Process_Status__c='Approved';
                        
              //      CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
              //      objcopy.commitActions(ta);  
              
                  commitActionList.add(ta);  
                  apprOrgRec.add(ta);
                    if((ta.Employee_Status__c=='Transfer-within' || ta.Employee_Status__c=='Transfer-Out' || ta.Employee_Status__c=='Terminated') && ta.Process_Step__c=='Term / Transfer' && ta.Position_ID_Status__c<>'Closed')
                    {   
                       if(ta.pmfkey__C <> null) 
                        {   mapPositionId.put(ta.pmfkey__C.toUpperCase(),ta.position_id__c);
                            mapName.put(ta.pmfkey__C.toUpperCase(),'Open_' + ta.position_id__c);
                            mapDate.put(ta.pmfkey__C.toUpperCase(), ta.Employee_Status_Date__c);
                        }
                    }
                    
                    if(ta.Process_Step__c=='New Hire')
                    {   
                       if(ta.position_id__C <> null) 
                        {   mapPositionId.put(ta.position_id__c.toUpperCase(), ta.pmfkey__C);
                            mapName.put(ta.position_id__c.toUpperCase(), ta.Employee_Name__c);
                            mapDate.put(ta.position_id__c.toUpperCase(), ta.Employee_Status_Date__c);
                        }
                    }
                    
                    
                }
                /*** Changing Owner to the Approver Queue once record is Send For Approval **/                
     
                if(ta.Approval_Process_Status__c=='Send For Approval'){  
                    
          
                    TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
                    TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch (ta, orderedRules,true);
                    ta.Is_Error_in_Rule__c= (tr==null);  
                     
                     if((tr!=null))//(taqRulesMap_App.containsKey(ta.Region__c+'||'+ta.Organization__c+'||'+ta.Area__c+'||'+ta.Business_Unit__c))
                     {
                        ta.Record_Sent_To_Approver__c=true;
                        ta.Approval_Process_Status__c='';
                        ta.Approval_Status__c='Send For Approval';
                        ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;
                       }
              
                                   
                    
                }
                
            }        
            else if(ta.Approval_Process_Status__c=='Migrated') {
                // Somehow, the dependent picklists are not populated correctly by data loader
                // Here is a workaround    
                if(ta.Organization_for_Data_Load__c<>null)
                    ta.Organization__c = ta.Organization_for_Data_Load__c;
                if(ta.Area_for_Data_Load__c<>null)
                    ta.Area__c = ta.Area_for_Data_Load__c;
                if(ta.Territory_For_Data_Load__c<>null)
                    ta.Territory__c = ta.Territory_For_Data_Load__c;
                if(ta.Country_for_Data_Load__c<>null)
                    ta.Country__c = ta.Country_for_Data_Load__c;
               
                
                /** Populate IC Currency, Quota Currency, Job Title and Cost center Desc 
                *   based on the values of IC Currency for Data Load, Quota Currency for data load
                *   Job Title for data load and Cost Center Desc for Data.
                **/
                
     
           
            
               if(currConvMap.containsKey(ta.IC_Currency_For_Data_Load__c))                 
                    ta.IC_Currency__c=currConvMap.get(ta.IC_Currency_For_Data_Load__c).id;
                if(jobInfoMap.containsKey(ta.IC_Currency_For_Data_Load__c))
                    ta.Cost_Center_Desc__c=jobInfoMap.get(ta.IC_Currency_For_Data_Load__c).id;
                if(costCentMap.containsKey(ta.IC_Currency_For_Data_Load__c))
                    ta.JobTitle__c=costCentMap.get(ta.IC_Currency_For_Data_Load__c).id;
               
            
            
                
                if(ta.Record_Type_for_Data_Load__c<>null)
                    ta.RecordTypeId = recTypMap.get(ta.Record_Type_for_Data_Load__c.toUpperCase());
                                    
                // Logic for actions from data load
               // Set status values on UI
                ta.Approval_Status__c='Migrated';
                ta.Approval_Process_Status__c='';
   
              TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
               TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch (ta, orderedRules,false);
               ta.Is_Error_in_Rule__c=(tr==null);   
               if(tr!=null)//(taqRulesMap_Req.containsKey(ta.Region__c+'||'+ta.Organization__c+'||'+ta.Area__c+'||'+ta.Business_Unit__c))
               {
               
                    ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;
               }
    
                 if (trigger.isUpdate) 
                {
                //FY13    CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
                   apprOrgRec.add(ta);//INSTEAD OF ABOVE LINE.
                } 
                
                
            }
  
    }
   
   if(trigger.isAfter){
             if(ta.Approval_Status__c=='Migrated'){
                //FY13        CA_TAQ_Trigger_class.isflag5=true;
                // objcopy.copyOrgRecords(ta);
                apprOrgRec.add(ta); //INSTEAD OF ABOVE LINE.
               }
        }
      
    } //END OF FOR LOOP.
    if(trigger.isBefore && trigger.isUpdate){
        TAQ_OrgActions objcopy=new TAQ_OrgActions();
        if(SystemIdUtility.skipTAQTrigger == false ) // added by Rao 
          objcopy.commitActions(commitActionList); 
          objcopy.copyOrgRecords(apprOrgRec);
      }  
      
    }               
    catch(Exception e){
       system.debug('Exception is '+e);
    } 
          
   
  //CRM Sprint 4 - TAQ Reject - START 3
     if(mapRejected.keyset().size() > 0) //for Reverting the Rejected records Requirement
     {
         if(trigger.isUpdate && trigger.isBefore)
         {
          CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
          mapRejected = objcopy.massCopyTAQOrg(mapRejected);
          for(taq_organization__c t:trigger.New)
              if(mapRejected.keyset().contains(t.id))
                  t= mapRejected.get(t.id);    
         }
     }
    

  //CRM Sprint 4 - TAQ Reject - END  3
  /*FY13- FutureProcessor_TAQ commented out.
   if(mapdate.keyset().size() > 0 && SystemIdUtility.isFutureUpdate != true)
       FutureProcessor_TAQ.UpdateSubordinate(mappositionid,mapdate, mapName); 
   */    
        //FY13-TAQ AutoCreationPositionID
   /* Auto Creation of Position ID Commented out.- TADKR01 - 03-Apr-2012.   
      
    List<TAQ_Organization_Approved__c> orgAppr = [SELECT Id, TAQ_Organization__c, Organization__c, Business_Unit__c, Territory__c, Area__c, Job_Title__c, Region__c, Manager_PMFKey__c from TAQ_Organization_Approved__c where TAQ_Organization__c in: trigger.new ORDER BY CreatedDate ASC];  
    Map<Id,TAQ_Organization_Approved__c> orgApprMap = new Map<Id,TAQ_Organization_Approved__c>();
    
    for(TAQ_Organization_Approved__c orgA: orgAppr){
        if(orgA.TAQ_Organization__c != null)
        {
            orgApprMap.put(orgA.TAQ_Organization__c,orgA);
        }
    } 
      
    if(trigger.isbefore)
    {
      
        TAQ_AutoCreation_PosID cls = new TAQ_AutoCreation_PosID();
      
        List<TAQ_Organization__c> taqlist = new List<TAQ_Organization__c>();
      
        for(TAQ_Organization__c taqrec: trigger.new)
        {
            if((taqrec.process_step__c == 'Open HeadCount' || taqrec.process_step__c == 'New Hire' || taqrec.process_step__c == 'Employee Change'))
            {
                 if(trigger.isUpdate)                  
                 {
                     if((orgApprMap.containsKey(taqrec.Id)&&(orgApprMap.get(taqrec.Id).Organization__c <> taqrec.Organization__c || orgApprMap.get(taqrec.Id).Business_Unit__c <> taqrec.Business_Unit__c || orgApprMap.get(taqrec.Id).Territory__c <> taqrec.Territory__c || orgApprMap.get(taqrec.Id).Area__c <> taqrec.Area__c || orgApprMap.get(taqrec.Id).Job_Title__c <> taqrec.JobTitle__c || orgApprMap.get(taqrec.Id).Region__c <> taqrec.Region__c || orgApprMap.get(taqrec.Id).Manager_PMFKey__c <> taqrec.Manager_PMF_Key__c)) || taqrec.position_id__c == null){
                            taqlist.add(taqrec);
                     }  
                 }
                 else if(trigger.isInsert){
                     if(taqrec.Position_Id__c == null || taqrec.Position_Id__c.trim() == '')
                         taqlist.add(taqrec);
                 }  
            }   
        }
       System.debug('______BEFORE CLASS');   
        Map<integer,String> mapJobPosID = cls.getAbbrevations(taqlist);
     System.debug('______AFTER CLASS'); 
        integer i =0;
        for(TAQ_Organization__c taq: trigger.new)        
        {
            if((taq.process_step__c == 'Open HeadCount' || taq.process_step__c == 'New Hire' || taq.process_step__c == 'Employee Change'))
            {  
              
                 if(trigger.isUpdate)
                 {
                    // if( ||  )
                     if((orgApprMap.containsKey(taq.Id)&&(orgApprMap.get(taq.Id).Organization__c <> taq.Organization__c || orgApprMap.get(taq.Id).Business_Unit__c <> taq.Business_Unit__c || orgApprMap.get(taq.Id).Territory__c <> taq.Territory__c || orgApprMap.get(taq.Id).Area__c <> taq.Area__c || orgApprMap.get(taq.Id).Job_Title__c <> taq.JobTitle__c || orgApprMap.get(taq.Id).Region__c <> taq.Region__c || orgApprMap.get(taq.Id).Manager_PMFKey__c <> taq.Manager_PMF_Key__c))||(taq.position_id__c == null)){
                         string posid = mapJobPosID.get(i);
                         if(posid <> null && posid <> '')
                            taq.position_id__C = posid;
                     }      
                 }
                 else if(trigger.isInsert){
                   if(taq.Position_Id__c == null || taq.position_id__c.trim()==''){
                       string posid = mapJobPosID.get(i);
                       if(posid <> null && posid <> '')
                         taq.position_id__C = posid;
                   }   
                 } 
             }
            i++;
        } 
   
    } */


}









/* FY13 - OPTIMIZED
trigger CA_TAQ_Org_Approval on TAQ_Organization__c (before insert,before update,after insert) {

    //Added by Saba FY12
        if(FutureProcessor_TAQ.skiporgtriggers) //This trigger is being called from future method for subordinate manager info updation - FutureProcessor_TAQ.UpdateSubordinate
               return;
    //CRM sprint 4 - TAQ Reject start  1
   Map<id, TAQ_Organization__c> mapRejected = new Map<id,TAQ_Organization__c>();
   //CRM sprint 4 - TAQ Reject end   1 
     
   Map<string,string> mapPositionId = new Map<string,string>(); 
   Map<string,date> mapdate = new Map<string,date>(); 
   Map<string,string> mapName = new Map<string,string>(); 
   
   //CRM sprint 4 - Open Position Id Update - Start 
    Map<id,string> mapOpenUpdated = new Map<id,string>();

    if(Trigger.isUpdate && Trigger.isBefore)
    {   
      
        for(TAQ_Organization__c ta: Trigger.New)
        {
           If((ta.Approval_Process_Status__c == 'Approved') && ta.Position_ID_Status__c == 'Open'  && (ta.Process_Step__c=='Open Headcount' || ta.Process_Step__c=='Employee Change'))
           {
             string posid = ta.Position_ID__c;
             if(posid <> null) {posid = posid.toUpperCase();}
             system.debug('>>>>>++++++' + mapOpenUpdated);

             mapOpenUpdated.put(ta.id,posid);
           }
        }

        if(mapOpenUpdated.keyset().size() >0) //for OpenPositionId Requirement
        {
            FutureProcessor_TAQ.UpdatePositionIdOfAccounts(mapOpenUpdated);
        }   
    } 
   //CRM sprint 4 - Open Position Id Update - End
   
       
    try{
    
    Map<String,id> recTypMap = new Map<String,id>();    
    
    if (Trigger.new[0].Approval_Process_Status__c=='Migrated') {
        for(RecordType rec:[SELECT name, id FROM RecordType WHERE SobjectType='TAQ_Organization__c'])
            recTypMap.put(rec.name.toUpperCase(), rec.id);  
    }
        
    for(TAQ_Organization__c ta: Trigger.new){
    
        if(trigger.isBefore){    
            
        System.debug('DBG-IsBefore');      
        System.Debug('-------------BSW----------'+ta);    
        /** If the record is Approved and came back to requestor and if the
                *   requestor modified the record and save it with out selecting 
                *   "Send For Approval" then Approval Status 2 will become as "Modified". 
                *   changes made by Heena as part of Req 804 SFDC CRM 7.1 Begins
                ** /
        if(ta.Approval_Process_Status__c==null && (ta.Approval_Status__c == 'Approved' || ta.Approval_Status__c == 'Migrated' 
          || ta.Approval_Status__c == 'Rejected' || ta.Approval_Status__c == 'Updated' || ta.Approval_Status__c == 'Send For Approval') ){       
              ta.Approval_Status__c = 'Saved - Not Approved';
        }  
        // Changes made by Heena as part of Req 804 SFDC CRM 7.1 Ends         
        // Determine if the action is from SFDC UI or data load
        if(ta.Approval_Process_Status__c=='Submitted' 
            || ta.Approval_Process_Status__c=='Approved'
            || ta.Approval_Process_Status__c=='Rejected'
            || ta.Approval_Process_Status__c=='Approved-Updated'
            || ta.Approval_Process_Status__c=='Updated'
            || ta.Approval_Process_Status__c=='Send For Approval' )   {  
             System.debug('>>>>>>>>>>>Saba Test 1');         
                
                if(ta.Distribute_Plan__c==null && ta.Approval_Process_Status__c=='Approved-Updated')
                    ta.Distribute_Plan__c='Yes';
                
                
                /*** Changing Owner to the Requestor Queue once record is Approved ** /

                if(ta.Approval_Process_Status__c=='Approved' || ta.Approval_Process_Status__c=='Rejected'){                    

                    TAQ_Rules__c[] tr= [select Region__c,Organization__c,Area__c,Org_Type__c, Business_Unit__c, Owner_Name_Id__c
                                        from TAQ_Rules__c 
                                        where (Region__c=:ta.Region__c or Region__c=NULL)
                                        and (Organization__c=:ta.Organization__c or Organization__c=NULL)
                                        and (Area__c=:ta.Area__c or Area__c=NULL)
                                        and (Org_Type__c=:ta.Org_Type__c or Org_Type__c=NULL)
                                        and (Business_Unit__c=:ta.Business_Unit__c or Business_Unit__c=NULL)
                                        and Object_Name__c='TAQ Organization' 
                                        and Send_To__c='Requestor'
                                        ORDER BY Region__c DESC NULLS LAST,
                                        Organization__c DESC NULLS LAST,
                                        Area__c DESC NULLS LAST,
                                        Org_Type__c DESC NULLS LAST,
                                        Business_Unit__c DESC NULLS LAST LIMIT 1        ];
                    
                    if(tr.size()>0){
                        ta.Is_Error_in_Rule__c=false;   
                        
                        ta.ownerid=tr[0].Owner_Name_Id__c;
                        if(ta.Approval_Process_Status__c=='Rejected' )
                        {
                            ta.Approval_Process_Status__c='';    
                            ta.Record_Sent_To_Approver__c=false;
                            ta.Approval_Status__c='Rejected'; 
                             //CRM Sprint 4 start 2
                               MapRejected.put(ta.id,ta);
                             //CRM Sprint 4 end 2
                        }
                    }
                    else
                        ta.Is_Error_in_Rule__c=true;
                    
                    system.debug('query result for rules :'+tr);
                                 System.debug('>>>>>>>>>>>Saba Test 2');
                }
                
                System.Debug('------------BSW  77----------'+ta);
                /** Invoking method from separate class to perform Actions once record is Approved ** /                
    
                if(ta.Approval_Process_Status__c=='Approved-Updated'){   
                    ta.Approval_Status__c='Approved';
                    if(ta.Is_Error_in_Rule__c==false){                 
                        ta.Record_Sent_To_Approver__c=false;
                        ta.Approval_Process_Status__c='';
                    }
                    else
                        ta.Approval_Process_Status__c='Approved';
                        
                    CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
                    System.Debug('------------BSW  before class----------'+ta);
                    
                     //System.debug('>>>>>>>>>>>Saba Test 5');
                    objcopy.commitActions(ta);    
                    //System.debug('>>>>>>>>>>>Saba Test 5');
                 
                    if((ta.Employee_Status__c=='Transfer-within' || ta.Employee_Status__c=='Transfer-Out' || ta.Employee_Status__c=='Terminated') && ta.Process_Step__c=='Term / Transfer' && ta.Position_ID_Status__c<>'Closed')
                    {   
                       if(ta.pmfkey__C <> null) 
                        {   mapPositionId.put(ta.pmfkey__C.toUpperCase(),ta.position_id__c);
                            mapName.put(ta.pmfkey__C.toUpperCase(),'Open_' + ta.position_id__c);
                            mapDate.put(ta.pmfkey__C.toUpperCase(), ta.Employee_Status_Date__c);
                        }
                    }
                    
                    if(ta.Process_Step__c=='New Hire')
                    {   
                       if(ta.position_id__C <> null) 
                        {   mapPositionId.put(ta.position_id__c.toUpperCase(), ta.pmfkey__C);
                            mapName.put(ta.position_id__c.toUpperCase(), ta.Employee_Name__c);
                            mapDate.put(ta.position_id__c.toUpperCase(), ta.Employee_Status_Date__c);
                        }
                    }
                    
                    
                }
                /*** Changing Owner to the Approver Queue once record is Send For Approval ** /                
     
                if(ta.Approval_Process_Status__c=='Send For Approval'){  
                    
                    TAQ_Rules__c[] tr= [select Region__c,Organization__c,Area__c,Org_Type__c, Business_Unit__c, Owner_Name_Id__c
                                        from TAQ_Rules__c 
                                        where (Region__c=:ta.Region__c or Region__c=NULL)
                                        and (Organization__c=:ta.Organization__c or Organization__c=NULL)
                                        and (Area__c=:ta.Area__c or Area__c=NULL)
                                        and (Org_Type__c=:ta.Org_Type__c or Org_Type__c=NULL)
                                        and (Business_Unit__c=:ta.Business_Unit__c or Business_Unit__c=NULL)
                                        and Object_Name__c='TAQ Organization' 
                                        and Send_To__c='Approver'
                                        ORDER BY Region__c DESC NULLS LAST,
                                        Organization__c DESC NULLS LAST,
                                        Area__c DESC NULLS LAST,
                                        Org_Type__c DESC NULLS LAST,
                                        Business_Unit__c DESC NULLS LAST LIMIT 1       ];
                    
                    if(tr.size()>0){
                        ta.Record_Sent_To_Approver__c=true;
                        ta.Approval_Process_Status__c='';
                        ta.Approval_Status__c='Send For Approval';
                        ta.Is_Error_in_Rule__c=false;    
                        ta.ownerid=tr[0].Owner_Name_Id__c;
                        

                    }
                    else
                        ta.Is_Error_in_Rule__c=true;
                        
                                     System.debug('>>>>>>>>>>>Saba Test 3');
                    
                }
                
            }        
            else if(ta.Approval_Process_Status__c=='Migrated') {
                // Somehow, the dependent picklists are not populated correctly by data loader
                // Here is a workaround    
                if(ta.Organization_for_Data_Load__c<>null)
                    ta.Organization__c = ta.Organization_for_Data_Load__c;
                if(ta.Area_for_Data_Load__c<>null)
                    ta.Area__c = ta.Area_for_Data_Load__c;
                if(ta.Territory_For_Data_Load__c<>null)
                    ta.Territory__c = ta.Territory_For_Data_Load__c;
                if(ta.Country_for_Data_Load__c<>null)
                    ta.Country__c = ta.Country_for_Data_Load__c;
                if(ta.Market_for_Data_Load__c<>null)
                    ta.Market__c = ta.Market_for_Data_Load__c;    
                
                /** Populate IC Currency, Quota Currency, Job Title and Cost center Desc 
                *   based on the values of IC Currency for Data Load, Quota Currency for data load
                *   Job Title for data load and Cost Center Desc for Data.
                ** /
                
                List<TAQ_Currency_Conversion__c> icCur=new List<TAQ_Currency_Conversion__c>();
                List<TAQ_Currency_Conversion__c> quotaCur=new List<TAQ_Currency_Conversion__c>();
                List<TAQ_Job_Info__c> jobTit=new List<TAQ_Job_Info__c>();
                List<TAQ_Cost_Center__c> costCent=new List<TAQ_Cost_Center__c>();
                
                if(ta.IC_Currency_For_Data_Load__c<>null)
                    icCur=[ select id from TAQ_Currency_Conversion__c
                                                   where name=:ta.IC_Currency_For_Data_Load__c limit 1]; 
                if(ta.Quota_Currency_For_Data_Load__c<>null)                                   
                    quotaCur=[ select id from TAQ_Currency_Conversion__c
                                                   where name=:ta.Quota_Currency_For_Data_Load__c limit 1]; 
                                                   
                if(ta.Job_Title_For_Data_Load__c<>null)                                   
                    jobTit=[select id from TAQ_Job_Info__c
                                                   where name=:ta.Job_Title_For_Data_Load__c limit 1];
                                                   
                if(ta.Cost_Center_Desc_For_Data_Load__c<>null)                                   
                    costCent=[select id from TAQ_Cost_Center__c
                                                   where name=:ta.Cost_Center_Desc_For_Data_Load__c limit 1];
                
                if(icCur.size()>0)                 
                    ta.IC_Currency__c=icCur[0].id;
                if(costCent.size()>0)
                    ta.Cost_Center_Desc__c=costCent[0].id;
                if(quotaCur.size()>0)
                    ta.Quota_Currency__c=quotaCur[0].id;
                if(jobTit.size()>0)
                    ta.JobTitle__c=jobTit[0].id;
                
                
                
                if(ta.Record_Type_for_Data_Load__c<>null)
                    ta.RecordTypeId = recTypMap.get(ta.Record_Type_for_Data_Load__c.toUpperCase());
                                    
                // Logic for actions from data load
            
                system.debug('Data load with Migrated Status:'+ta);
                    
                // Set status values on UI
                ta.Approval_Status__c='Migrated';
                ta.Approval_Process_Status__c='';
                
                
                TAQ_Rules__c[] tr= [select Region__c,Organization__c,Area__c,Org_Type__c, Business_Unit__c, Owner_Name_Id__c
                                        from TAQ_Rules__c 
                                        where (Region__c=:ta.Region__c or Region__c=NULL)
                                        and (Organization__c=:ta.Organization__c or Organization__c=NULL)
                                        and (Area__c=:ta.Area__c or Area__c=NULL)
                                        and (Org_Type__c=:ta.Org_Type__c or Org_Type__c=NULL)
                                        and (Business_Unit__c=:ta.Business_Unit__c or Business_Unit__c=NULL)
                                        and Object_Name__c='TAQ Organization' 
                                        and Send_To__c='Requestor'
                                        ORDER BY Region__c DESC NULLS LAST,
                                        Organization__c DESC NULLS LAST,
                                        Area__c DESC NULLS LAST,
                                        Org_Type__c DESC NULLS LAST,
                                        Business_Unit__c DESC NULLS LAST LIMIT 1       ];
                    
                if(tr.size()>0){
                    ta.Is_Error_in_Rule__c=false;    
                    ta.ownerid=tr[0].Owner_Name_Id__c;
                  

                       
                }
                else
                    ta.Is_Error_in_Rule__c=true;
                    
                if (trigger.isUpdate) 
                {
                    CA_TAQ_Trigger_class.isflag5=true;
                    CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
                    objcopy.copyOrgRecords(ta);
                }
                
                
            }
          }
          // Following condition will execute only when the records are migrated
          // through data loader.
          
          else if(trigger.isAfter){
              System.debug('DBG-IsAfter');
              if(ta.Approval_Status__c=='Migrated'){
                System.debug('DBG-IsAfter-Copy approved records');
                CA_TAQ_Trigger_class.isflag5=true;
                CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
                objcopy.copyOrgRecords(ta); 
              }
          }
        }
    
    }                
    catch(Exception e){
        system.debug('Exception is '+e);
                
    } 
          
   
  //CRM Sprint 4 - TAQ Reject - START 3
     if(mapRejected.keyset().size() > 0) //for Reverting the Rejected records Requirement
     {
         if(trigger.isUpdate && trigger.isBefore)
         {
          CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
          mapRejected = objcopy.massCopyTAQOrg(mapRejected);
          for(taq_organization__c t:trigger.New)
              if(mapRejected.keyset().contains(t.id))
                  t= mapRejected.get(t.id);    
         }
     }
    

  //CRM Sprint 4 - TAQ Reject - END  3
  
   if(mapdate.keyset().size() > 0 && SystemIdUtility.isFutureUpdate != true)
       FutureProcessor_TAQ.UpdateSubordinate(mappositionid,mapdate, mapName); 

}*/