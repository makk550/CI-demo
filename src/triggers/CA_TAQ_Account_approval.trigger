/**
* Description  : This trigger contain different automated actions like update of Account owner
*                pmf key and Sales director pmf key, changing owner to corresponding queue once
*                a record is approved/rejected/send for approval.
*                This trigger invokes AccTriggerActions method from CA_TAQ_AddTeamMem class to
*                perform various actions of Account Add/Update/Release/Merge Processes.
*               
* Author       : Jagan Babu Gorre
* Company      : Accenture
* Client       : Computer Associates
* Last Update  : March 2010
**/

trigger CA_TAQ_Account_approval on TAQ_Account__c (before insert,before update) {
//Added by Saba FY12
//if(FutureProcessor_TAQ.skiptriggers) //This trigger is being called from future method for AE/SE updations, hence not required to run
//    return;
    
 //INTRODUCED TO BREAK THE INFINITE LOOP EXECUTION OF THE TRIGGER.    
   if(CA_TAQ_Account_Approval_Class.EXEC_COUNT > 3)
       return;
   
   //CREATED TO TRACK INITIAL SELECTED TAQ ACCOUNT APPROVAL STATUS - CR:192923781 - TADKR01    
   if(CA_TAQ_Account_Approval_Class.mapApprovalStatus.size()==0){
       for(TAQ_Account__c tAcc: trigger.new){
                 system.debug('tAcc.Approval_Process_Status__ci8n7yh'+tAcc.Approval_Process_Status__c);
                 //DE
                 if(tAcc.Approval_Process_Status__c == 'Pending Review')
                 {
                    tAcc.Approval_Process_Status__c = 'Approved';                   
                    tAcc.chkPendingReview__c  = true;
                 }
                 else
                 {
                    system.debug('chkPendingReview__ci7klyu'+tacc.chkPendingReview__c);
                   tAcc.chkPendingReview__c  = false;
                 }
                 CA_TAQ_Account_Approval_Class.mapApprovalStatus.put(tAcc.Id,tAcc.Approval_Process_Status__c);                 
       }
   }

   if(SystemIdUtility.skipTAQ_Account) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
        

    Schema.DescribeSObjectResult result = TAQ_Account__c.SobjectType.getDescribe();
    List<Schema.RecordTypeInfo> rectypes = result.getRecordTypeInfos();


     Map<Id,String> profileMap = new Map<Id,String>();

        for(Schema.RecordTypeInfo rt:recTypes)
            profileMap.put(rt.getRecordTypeId(),rt.getName());
    //FY14-- CR:193238687 -- PRE APPROVAL NEEDED BY ADMINS FOR REGIONAL ACCOUNTS.
   if(trigger.isBefore && trigger.isInsert){
       
        
          for(TAQ_Account__c tAcc: trigger.new){
           if(profileMap.containsKey(tAcc.RecordTypeId) &&  !profileMap.get(tAcc.RecordTypeId).contains('Partner'))  
              tAcc.is_Admin_Approved__c = false;
              
          if((!profileMap.get(tAcc.RecordTypeId).contains('Partner')) && (tAcc.Approval_Process_Status__c == 'Approved' || tAcc.Approval_Process_Status__c == 'Rejected'))   
              tAcc.addError('Please Send this Account Add Request for Approval');
          }      
   }
   
   if(trigger.isBefore && trigger.isUpdate){
        for(TAQ_Account__c tAcc: trigger.new){
            if(tAcc.Is_Admin_Approved__c == false && tAcc.Approval_Status__c != 'Send For Approval' && tAcc.Approval_Status__c != 'Saved - Not Approved' && (!profileMap.get(tAcc.RecordTypeId).contains('Partner')) && (tAcc.Approval_Process_Status__c == 'Approved' || tAcc.Approval_Process_Status__c == 'Rejected'))
                tAcc.addError('Please Send this Account Add Request for Approval');
        }       
   }



   //FY14- CR:194325558.
   if(trigger.isBefore && trigger.isUpdate){
        Boolean old_multiYearAcc = false;
        Boolean new_multiYearAcc = false;
        
        Boolean old_isPrimaryAcc = false;
        Boolean new_isPrimaryAcc = false;
        
        Decimal old_split = 0.00;
        Decimal new_split = 0.00;
        
        String old_splitType = null;
        String new_splitType = null;
        
        Id old_PrimaryAccount  = null;
        Id new_PrimaryAccount  = null;        
        for(TAQ_Account__c eachRec: trigger.new){
            old_multiYearAcc = trigger.oldMap.get(eachRec.Id).Is_this_a_multi_year_account__c;
            new_multiYearAcc = eachRec.Is_this_a_multi_year_account__c;
            
            old_isPrimaryAcc = trigger.oldMap.get(eachRec.Id).Is_Primary_Account__c;
            new_isPrimaryAcc = eachRec.Is_Primary_Account__c;
            
            old_split = trigger.oldMap.get(eachRec.Id).Split__c;
            new_split = eachRec.Split__c;
            
            old_splitType = trigger.oldMap.get(eachRec.Id).Split_Type__c;
            new_splitType = eachRec.Split_Type__c;
            
            old_PrimaryAccount = trigger.oldMap.get(eachRec.Id).Primary_Account__c;
            new_PrimaryAccount = eachRec.Primary_Account__c;            
            
            if(eachRec.Coverage_Model__c == Label.CovModelVal2 && 
                (old_multiYearAcc  != new_multiYearAcc ||
                 old_isPrimaryAcc  != new_isPrimaryAcc ||
                 old_split         != new_split        ||
                 old_splitType     != new_splitType    ||
                 old_PrimaryAccount!= new_PrimaryAccount
                )  
              ){
                eachRec.addError('For Territory Coverage model,Following fields should not be modified. 1.is this a multi year account? 2.Split Primary Account 3. Primary Account 4.Split 5.Split Type');
            }
        }
   }

try{          
    
    Map<Id,String> recTypeMap = new map<Id,String>();
    Map<string,id> recTypMap = new map<string,id>();

    for(Schema.RecordTypeInfo r: rectypes){
       rectypeMap.put(r.getRecordTypeId(),r.getName());
       recTypMap.put(r.getName().toUpperCase(),r.getRecordTypeId()); 
    }
   
   // TO RUN TAQ_RULES QUERY. 
   set<string> region = new set<string>(); 
   set<string> recordtype = new set<string>();
   set<string> area = new set<string>();
   

   for(TAQ_Account__c ta: trigger.New)
   {
    System.debug('______AAA111AAA_____'+ta.Id+'____'+ta.Approval_Status__c);
   region.add(ta.Region__c);
    area.add(ta.Area__c);
    recordtype.add(ta.RecordTypeId);
    //CR 300-163539: Assigning the country code to the physical country on insert/update
    ta.Physical_Country__c = ta.Country_Picklist__c.substring(0, 2);
   }
   
 /*   Map<Id,TAQ_Rules__c> mapRules = new map<Id,TAQ_Rules__c>( [select Owner_Name_Id__c 
                                        from TAQ_Rules__c    where (Record_Type_ID__c IN: recordtype or Record_Type_ID__c=NULL)
                                        and (Region__c in :region  or Region__c=NULL)
                                        and (Area__c IN: area or Area__c=NULL)
                                        and Object_Name__c='TAQ Account']);*/
                                        
   List<TAQ_Rules__c> orderedRules = [select Record_Type_ID__c,Partner_On_boarding__c,Referral_Partner__c,Object_Name__c,Region__c,Organization__c,Area__c, Business_Unit__c, Owner_Name_Id__c,Send_To__c,DM_Account__c,TAQ_Account_Released__c
                                        from TAQ_Rules__c    where (Record_Type_ID__c IN: recordtype or Record_Type_ID__c=NULL)
                                        and (Region__c in :region  or Region__c=NULL)
                                        and (Area__c IN: area or Area__c=NULL)
                                        and Object_Name__c='TAQ Account' 
                                        ORDER BY  
                                         Record_Type_ID__c NULLS LAST,
                                         DM_Account__c DESC NULLS LAST,
                                        Region__c DESC NULLS LAST,
                                        Area__c DESC NULLS LAST];
                                        
        Map<Id,TAQ_Rules__c> mapRules = new Map<Id,TAQ_Rules__c>();
                           
        for(TAQ_Rules__c t: orderedRules){
               mapRules.put(t.Id,t);
        }              
      
  //  TAQ_Rules__c[] tarules= mapRules.values();
    
    
    
    Set<String> stpmfky=new Set<String>();
    Set<String> stname=new Set<String>();
    Set<String> stPosids=new Set<String>();
    
    Map<String,TAQ_Account__c> mpeids=new Map<String,TAQ_Account__c>();
    CA_TAQ_Account_Approval_Class obj_CA_TAQ_Account_Approval_Class = new CA_TAQ_Account_Approval_Class();
    //This is to validate CAM Pmf keys on PArtner Account.
    obj_CA_TAQ_Account_Approval_Class.validatePMFKeys(Trigger.new);
    
    //MapTa is used to store manager pmf keys form TAQ organization
    //MapUsr is used to store names and id for any pmf key
            
    //fy12 cahnges.
    
    // mapRejected is used for copy the rejected record.
    // Added by raipa02 09/11/11 for sprint 4
    Map<id,TAQ_Account__c> mapRejected=new Map<id,TAQ_Account__c>();   
                     
    set<String> entAccPMFKeys = new set<String>(); 
    Map<String,String> orgmap = NEW Map<String,String>();
            
    Map<String,TAQ_Organization__c> MapTa=new Map<String,TAQ_Organization__c>();
    Map<String,User> MapUsr=new Map<String,User>();

    Id userid;
    Boolean isMigrate=false;
    RecordType recType;
   
    //saba 2/24/2012 FY13 - start
    Set<id> setTAQAccIds = new Set<id>();
    Map<id,string> mTAQAccOwnerPMFkey = new Map<id,string>();  
    system.debug('CA_TAQ_Account_Approval_Class.mapApprovalStatus.size()'+CA_TAQ_Account_Approval_Class.mapApprovalStatus.size());
    if(Trigger.isUpdate)
      {
          for(TAQ_Account__C t: Trigger.New)
          {
              system.debug('t.Approval_Process_Status__cio8yu'+t.Approval_Process_Status__c);
              if(t.Approval_Process_Status__c == 'Approved-Updated')
                {    
                      setTAQAccIds.add(t.id);
                }   


          }
          Set<string> setTAQAccountOwnerManagerPMFkeys = new Set<string>(); //4/3/2012 - GET MANAGERS
          Set<string> setTAQAccountOwnerManagers = new Set<string>(); //4/3/2012 - GET MANAGERS
          Set<id> setTAQAccountIdwithManager = new Set<id>(); //4/3/2012 - GET MANAGERS
          
          
          for(TAQ_Account_Team__c tatm: [Select TAQ_Account__c, pmfkey__c from TAQ_Account_Team__c where TAQ_Account__c in : setTAQAccIds and Is_Account_Owner__c = true AND pmfkey__c <> null])  
          {
                  mTAQAccOwnerPMFkey.put(tatm.TAQ_Account__c,tatm.pmfkey__c.toUpperCase());
                  if(tatm.pmfkey__c.toUpperCase().Length() > 7)  //IMPLIES THAT THIS IS A POSITION ID
                     { setTAQAccountOwnerManagerPMFkeys.add(tatm.pmfkey__c.toUpperCase());
                       setTAQAccountIdwithManager.add(tatm.TAQ_Account__c);   
                     }
                   
          } 
          
          Map<string,string> mapPositionIdManagerPMF = new Map<string,string>();
          if(setTAQAccountOwnerManagers.size() > 0)
          {
                 for(TAQ_Organization_approved__c toa:[select id, position_id__c, Manager_PMFKey__c from TAQ_Organization_approved__c where position_id__c in: setTAQAccountOwnerManagerPMFkeys and Is_Latest_Record__c = true ])
                 {
                     mapPositionIdManagerPMF.put(toa.position_id__c.toUpperCase(), toa.Manager_PMFKey__c.toUpperCase()); 
                 }
                 
                 for(id tid: setTAQAccountIdwithManager)
                 {
                     string posid = mTAQAccOwnerPMFkey.get(tid);
                     if(posid <> null && mapPositionIdManagerPMF.keyset().contains(posid.toUpperCase()))
                     {
                         mTAQAccOwnerPMFkey.put(tid,mapPositionIdManagerPMF.get(tid));
                     }
                 }
          }
          
            System.debug('____890____'+mTAQAccOwnerPMFkey.keySet());

          User genericOwner = new User(Id=Label.Generic_Owner);
          System.debug('///genericOwner' + genericOwner.Id);

          for(TAQ_Account__C t: Trigger.New)
          { System.debug('____891____'+t.id);
              if(t.Approval_Process_Status__c == 'Approved-Updated' && recTypeMap.get(t.RecordtypeId).contains('Regional')){
                //sunji03: FY19 Account segment change
                // if(mTAQAccOwnerPMFkey.get(t.id) == null && t.Segment__c == 'Platinum'){
                if(mTAQAccOwnerPMFkey.get(t.id) == null && (t.Segment__c == Label.SegmentVal1 || t.Segment__c == Label.SegmentVal4)){ //T1 becomes Platinum & Gold.
                    System.debug('____892____');
                    
                    /* US483878 Begin LEEAN04 
                    
                      t.addError('Please add Account Owner in the Account Team Member before Approving');
                    
                    US483878 Begin LEEAN04 */
                  
                  }
                  else if((!mTAQAccOwnerPMFkey.containsKey(t.id) || mTAQAccOwnerPMFkey.get(t.id) == null) && (t.Coverage_Model__c == Label.CovModelVal2 || t.Coverage_Model__c == Label.CovModelVal1)){
                    System.debug('____893____');    
                     if(genericOwner.Id != NULL){
                            System.debug('____894____');
                        mTAQAccOwnerPMFkey.put(t.id,genericOwner.Id);
                            System.debug('____895____');
                     }
                     else{
                            System.debug('____896____');
                            
                            /* US483878 Begin LEEAN04 
                            
                            t.addError('Please activate Generic Owner User (OR) Please add Account Owner in the Account Team Member before Approving'); 
                        
                            US483878 Begin LEEAN04 */
                        
                     }      
                  }    
              }      
          }
          System.debug('____897____'+mTAQAccOwnerPMFkey);
          system.debug('CA_TAQ_Account_Approval_Class.mapApprovalStatus.size()fedf'+CA_TAQ_Account_Approval_Class.mapApprovalStatus.size());
       }
   //saba 2/24/2012 FY13 - end
        
   
    for(TAQ_Account__c t: Trigger.new){
        //PRM-TAQ-R2,by Accenture,for Reseller Account.
        if(t.Reseller_Account_Director_PMFKey__c<>null){   
        
            if(t.Reseller_Account_Director_PMFKey__c.length()==7 || t.Reseller_Account_Director_PMFKey__c == 'APJPARTN')
                stpmfky.add(t.Reseller_Account_Director_PMFKey__c.toUpperCase());
            else if(t.Reseller_Account_Director_PMFKey__c.toUpperCase() != 'NONE')
                stPosids.add(t.Reseller_Account_Director_PMFKey__c);
        }
        
          
        if(t.Is_Primary_Account__c==false)
             stname.add(t.name);   
        
        if(t.Approval_Process_Status__c=='Migrated')     
            isMigrate=true;
            
        // PRM sprint 4 changes.
        if(recTypeMap.get(t.RecordtypeId).contains('Partner'))  //t.RecordTypeId =='01230000000cogV'
        {
            if(t.Region__c=='NA')
               t.Reseller_Account_Director_PMFKey__c='NAPARTN';
            if(t.Region__c=='EMEA')
               t.Reseller_Account_Director_PMFKey__c='EMPARTN';
            if(t.Region__c=='LA')
               t.Reseller_Account_Director_PMFKey__c='LAPARTN';
            if(t.Region__c=='Asia-Pacific')
               t.Reseller_Account_Director_PMFKey__c='APPARTN';
            if(t.Region__c=='Japan')
               t.Reseller_Account_Director_PMFKey__c='JPPARTN';
            if(t.Region__c=='APJ')//FY14- DUE TO NEW VALUE(APJ) IN GEO FIELD - CR:194731178(SUPERCARE)
               t.Reseller_Account_Director_PMFKey__c='APJPARTN';
            if(t.Region__c=='WW')
               t.Reseller_Account_Director_PMFKey__c='WWPARTN';
            if(t.Region__c=='PS/CAN') //for FY19 US455987
               t.Reseller_Account_Director_PMFKey__c='PSCANPARTN';

            
            mTAQAccOwnerPMFkey.put(t.id,t.Reseller_Account_Director_PMFKey__c); //For Creating standard Account

        }     
            
        
    }
    
    
   // Following query will execute only if any of the accounts is split account
    if(stname.size()>0){
        for(TAQ_Account__c a: [select name,Enterprise_Id__c from TAQ_Account__c where name in:stname and Is_Primary_Account__c=true and Enterprise_Id__c<>null])
            mpeids.put(a.name,a);
        system.debug('DBG-mpeids:'+mpeids);
    }
    //system.debug('length of PMFKey');
    
    //Following queries will execute for all records where AO pmf key or SD pmf key is populated    

    /** If entered string is a posid then query manager pmfkeys from TAQ org 
    *   and then query the user object based on this manager pmfkeys.
    **/
    if(stPosids.size() >0)
        for(string st:stPosids)            
         if(stPosids.size()>0)
           for(TAQ_Organization__c t:[select Position_Id__c,Manager_PMF_Key__c from TAQ_Organization__c where Position_Id__c in :stPosids and Position_Id__c!='None']){
             stpmfky.add(t.Manager_PMF_Key__c.toUpperCase());
             MapTa.put(t.Position_Id__c,t);
     }

    if(stpmfky.size()>0)
        for(User u:[select id,name,PMFKey__c from User where PMFKey__c in:stpmfky and isActive=true])
            MapUsr.put(u.PMFKey__c.toUpperCase(),u);

            
   List<TAQ_Account__c> allApprovedAcc = new List<TAQ_Account__c>(); 
   for(TAQ_Account__c ta: Trigger.new){
           
           
           System.debug('(((((((((((((((((())))))))))))))))))'+ ta.View_Acc_Record__c);
           system.debug('ta.Approval_Process_Status__c == Pending Review'+ta.Approval_Process_Status__c);
           system.debug('ta.chkPendingReview__c8io7y'+ta.chkPendingReview__c);
        // Somehow, the dependent picklists are not populated correctly by data loader
        // Here is a workaround
        
         if(ta.Approval_Process_Status__c == 'Pending Review' || ta.chkPendingReview__c == true)
              {
                 system.debug('ta.chkPendingReview__c == trueo978ujh'+ta.Approval_Process_Status__c+ta.chkPendingReview__c);
                 ta.Approval_Process_Status__c = 'Approved';                 
                 ta.chkPendingReview__c = true; 
              }
        
        
        if(isMigrate) {     
            if(ta.Area_for_Data_Load__c<>null)
                ta.Area__c = ta.Area_for_Data_Load__c;
            if(ta.Territory_For_Data_Load__c<>null)
                ta.Territory__c = ta.Territory_For_Data_Load__c;
            if(ta.Country_for_Data_Load__c<>null)
                ta.Country__c = ta.Country_for_Data_Load__c;
    //FY13  if(ta.Market_for_Data_Load__c<>null)
    //FY13            ta.Market__c = ta.Market_for_Data_Load__c;
        }
          
            /** For Split Account take Enterprise Id from primary Account **/
            if(ta.Is_Primary_Account__c==false && ta.Enterprise_Id__c == null)
                ta.Enterprise_Id__c=mpeids.get(ta.name).Enterprise_Id__c;
            
            /** If the account is primary account then make Enterprise Account Name same as Account Name **/
            
           // if(ta.Is_Primary_Account__c==true)
           /* Added by Pawan Rai for Spring 3 requirement on 08/09/2011*/
             
              if((ta.Is_Primary_Account__c==true)&& (recTypemap.get(ta.recordtypeid).contains('Regional')))
               ta.Enterprise_Account_Name__c=ta.name;
            
              if(recTypemap.get(ta.recordtypeid).contains('Partner'))
               ta.Enterprise_Account_Name__c=ta.name;
            /** Auto Populate of Account owner Name and Salesdirector Name from corresponding PMF keys **/  
       
           //PRM-TAQ-R2,by Accenture,For Reseller Account.
           if(ta.Reseller_Account_Director_PMFKey__c<>null && (ta.Reseller_Account_Director_PMFKey__c.length()==7 || ta.Reseller_Account_Director_PMFKey__c =='APJPARTN') && MapUsr.containsKey(ta.Reseller_Account_Director_PMFKey__c.toUpperCase())){
               userid=MapUsr.get(ta.Reseller_Account_Director_PMFKey__c.toUpperCase()).id;  //used during Account add/Update process
           }
           else if(ta.Reseller_Account_Director_PMFKey__c<>null && ta.Reseller_Account_Director_PMFKey__c.length()<>7 && ta.Reseller_Account_Director_PMFKey__c != 'APJPARTN' && MapTa.containsKey(ta.Reseller_Account_Director_PMFKey__c) && MapUsr.containsKey(MapTa.get(ta.Reseller_Account_Director_PMFKey__c).Manager_PMF_Key__c.toUpperCase())){
               userid=MapUsr.get(MapTa.get(ta.Reseller_Account_Director_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).id;  //used during Account add/Update process

           }
        
        /** If the record is Approved and came back to requestor and if the
        *   requestor modified the record and save it with out selecting 
        *   "Send For Approval" then Approval Status 2 will become as "Modified".
        *   changes made by Heena as part of Req 804 SFDC CRM 7.1 Begins               
        **/
          System.debug('______AAA______'+ allApprovedAcc);
          if(ta.chkPendingReview__c == true)
          {
            system.debug('ta.chkPendingReview__c == o987true'+ta.chkPendingReview__c);
            system.debug('ta.Approval_Process_Status__c =8767'+ta.Approval_Process_Status__c);
            
            ta.Approval_Process_Status__c = 'Approved';  
            ta.Approval_Status__c = 'Approved';
            allApprovedAcc.add(ta);
          }
          
        
          System.debug('______AAA______'+ allApprovedAcc);
        if(SystemIdUtility.isneeded){//---*****---
            system.debug('SystemIdUtility.isneeded)');
            ta.Approval_Status__c = 'Approved';
            ta.Approval_Process_Status__c=null;
            allApprovedAcc.add(ta);
        }else if(ta.Approval_Process_Status__c==null && (ta.Approval_Status__c == 'Approved' || ta.Approval_Status__c == 'Migrated'
            || ta.Approval_Status__c == 'Updated' || ta.Approval_Status__c == 'Rejected'  || ta.Approval_Status__c == 'Send For Approval')){
             
                   if(!(CA_TAQ_Account_Approval_Class.mapApprovalStatus.containsKey(ta.id) &&
                      CA_TAQ_Account_Approval_Class.mapApprovalStatus.get(ta.id) !=null)){
                         ta.Approval_Status__c = 'Saved - Not Approved';
                   }
                 
               }
       //VINU:Trail Management
       Id CISUser = UserInfo.getUserId();
       string strUserID = string.valueOf(CISUser);
       string CisInt = label.Cis_Integration_User;            
               
       system.debug('ta.Approval_Process_Status__cr34r34r3'+ta.Approval_Process_Status__c);
       If((ta.Approval_Process_Status__c=='' || ta.Approval_Process_Status__c==null) && CISUser == CisInt){
        system.debug('Approvalprocess=empty');
        ta.OwnerId = QueueCust__c.getInstance('TAQ Add Account Approver').Queue_ID__c;
       }
       //End - Trail Management
        
       //FY14-CR:193238687 -PRE APPROVAL NEEDED BY ADMINS.
       //if(ta.Approval_Process_Status__c=='Send For Approval' && ta.Is_Admin_Approved__c == false){
       //CR 300-163533: adding this condition as for Pending Review the owner must be in the TAQ Add Account Approver queue
       if((ta.Approval_Process_Status__c=='Send For Approval' || (ta.Approval_Process_Status__c == 'Approved' && ta.chkPendingReview__c == true)) && ta.Is_Admin_Approved__c == false){
             
             system.debug('kjsdyhvmjn');
             ta.OwnerId = QueueCust__c.getInstance('TAQ Add Account Approver').Queue_ID__c;
             ta.Approval_Process_Status__c = '';
             ta.Approval_Status__c = 'Send For Approval';
       }
       else if(ta.Approval_Process_Status__c=='Approved' && ta.Is_Admin_Approved__c == false){
        system.debug('ni876yigfudv');
             ta.Is_Admin_Approved__c = true;
       }
       else if(ta.Approval_Process_Status__c=='Rejected' && ta.Is_Admin_Approved__c == false){
        system.debug('kljh777yugu');
             ta.OwnerId=  QueueCust__c.getInstance('TAQ Release and Merge Account Owners').Queue_ID__c; 
             ta.Approval_Process_Status__c = '';
             ta.Approval_Status__c = 'Rejected';
       }
                        
                     
             
            
        // Changes made by Heena as part of Req 804 SFDC CRM 7.1 Ends 
        // Determine if the action is from SFDC UI or data load
        if((ta.Approval_Process_Status__c=='Submitted' 
            || ta.Approval_Process_Status__c=='Approved'
            || ta.Approval_Process_Status__c=='Rejected'
            || ta.Approval_Process_Status__c=='Approved-Updated'
            || ta.Approval_Process_Status__c=='Updated'
            || ta.Approval_Process_Status__c=='Send For Approval') 
            && ta.Is_Admin_Approved__c == true
            ) {
        
            // Workflow logic for actions from SFDC UI
                      
            system.debug('DBG RecordTypeId:'+ta.RecordTypeId);
            
            /*** Changing Owner to the Requestor Queue once record is Approved **/
       
            if((ta.Approval_Process_Status__c=='Approved' && ta.chkPendingReview__c == false) || ta.Approval_Process_Status__c=='Rejected' || ta.Approval_Process_Status__c=='Updated')
                {                    
                    /* OPTIMIZED AS BELOW          
                    TAQ_Rules__c[] tr=    
                    */
                  try{
                    TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
                    System.debug('_______________method call 1'+ta.Region__c+ta.Id);
                    TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch_taqAcc (ta,orderedRules,false);
                    ta.Is_Error_in_Rule__c=(tr==null);
                    if(tr!=null)
                    {
                         ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;//(ta.Region__c+'||'+ta.Organization__c+'||'+ta.Area__c+'||'+ta.Business_Unit__c).Owner_Name_Id__c;
                       if(ta.Approval_Process_Status__c=='Updated' || ta.Approval_Process_Status__c=='Rejected' ){
                        if(ta.Approval_Process_Status__c=='Rejected' )
                        {
                            system.debug('kuhkv000:');
                            ta.Approval_Process_Status__c='';    
                            ta.Approval_Status__c='Rejected'; 
                             MapRejected.put(ta.id,ta);
                        }
                        else
                        {
                            ta.Approval_Status__c = 'Updated';   
                        }
                        ta.Approval_Process_Status__c=''; 
                        ta.Send_For_Approval__c=false; 
                       } 
                   }
                  }catch(Exception e){
                    System.debug('___Exception in trigger CA_TAQ_Account_Approval while assigning to approver queue');
                  }                                                            
            }

            
            
            CA_TAQ_AddTeamMem objta=new CA_TAQ_AddTeamMem();
            
            /** Changing Owner to the Approver Queue once record is Send For Approval **/                       
            
            /** For normal layout, consider Region,Area directly from the same record.
            *   For mini form layout (except account add), consider Region,Area from Enterprise Account Selected. 
            **/     
            
            if(ta.Approval_Process_Status__c=='Send For Approval' && (ta.Enterprise_Account__c==null || ta.Process_Step__c=='Account Add')){  
                system.debug('Send For Approval00909988');
                TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
                  System.debug('_______________method call 2');
                    TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch_taqAcc (ta, orderedRules,true);
                    ta.Is_Error_in_Rule__c= (tr==null);  
                    
                    if((tr!=null))
                    {
                    ta.Send_For_Approval__c=true;         
                    ta.Approval_Process_Status__c='';
                    ta.Approval_Status__c = 'Send For Approval';   
                    ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;
                    ta.Is_Error_in_Rule__c=false;    
                    }
                    
                
            }    
            else if(ta.Approval_Process_Status__c=='Send For Approval' && ta.Enterprise_Account__c<>null){  
                system.debug('nullval00909988');
                objta.SetMiniLayoutValues(ta,ta.Enterprise_Account__c);               

                
                TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
                  System.debug('_______________method call 3');
                    TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch_taqAcc (ta, orderedRules,true);
                    ta.Is_Error_in_Rule__c= (tr==null);  
                 if((tr!=null))
                    {
                    ta.Send_For_Approval__c=true;         
                    ta.Approval_Process_Status__c='';
                    ta.Approval_Status__c = 'Send For Approval';   
                    ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;
                    ta.Is_Error_in_Rule__c=false;    
                    }
                
            }            
            if(ta.Approval_Process_Status__c=='Approved-Updated' )
            { 
                system.debug('Approved-Updated00909988');
                ta.Approval_Status__c = 'Approved';
                allApprovedAcc.add(ta); //FY13 addition 
               
 
                if((ta.Account_Type1__c != 'Partner Account'&& ta.Account_Type1__c != null ) && ta.Is_Primary_Account__c==true&&ta.Enterprise_Id__c==null)
                { 
                    /* ta.Reseller_ID__c=null;
                       ta.Enterprise_Id__c = ta.Enterprise_Account_ID_Auto__c;
                   //FY13 - Changed the logic for  Enterprise Id Generation
                    if(ta.Region__c <> null && ta.Region__c <> '')
                         ta.Enterprise_Id__c = ta.Region__c.substring(0,1).ToUpperCase() + 'R' +ta.Enterprise_Id__c;
                    if(ta.Region__c == 'EMan'){
                        ta.Enterprise_Id__c = 'AP'+ta.Enterprise_Id__c;//Heena changed JP to AP for defect 47136 in SFDC 7.1
                    }else if(ta.Region__c == 'WW'){
                        ta.Enterprise_Id__c = 'WW'+ta.Enterprise_Id__c;//SABA - SFDC 7.2} */
                }
          
                
                 
           //Changes done by Accenture for reqd:-607 in PRM-TAQ-R2 
           if(ta.Enterprise_Id__c!=null)
               ta.Reseller_ID__c=null;
                
                
                if(ta.Process_Step__c<>'Account Release' && ta.Process_Step__c<>'Account Merge' && ta.Is_Error_in_Rule__c==false ){ 
                    ta.Send_For_Approval__c=false; 
                }
                if(ta.Is_Error_in_Rule__c==false)
                    ta.Approval_Process_Status__c='';
                else
                    ta.Approval_Process_Status__c='Approved';
                    
                system.debug('ta.namell:'+ta.name); 
            }               
        } else if(ta.Approval_Process_Status__c=='Migrated') {
            // Logic for actions from data load
            system.debug('ta.Approval_Process_Status__c==987987');
            //system.debug('Data load with Migrated Status'+ta.Reseller_Account_ID_Auto__c);
            
            if(ta.Record_Type_for_Data_Load__c<>null)
                    ta.RecordTypeId = recTypMap.get(ta.Record_Type_for_Data_Load__c.toUpperCase());

            ta.Approval_Status__c='Migrated'; 
          //PRM-TAQ-R2,For Migration Mode.
            if(ta.Reseller_ID__c==null)
            ta.Approval_Process_Status__c='Migrated';
            else
            ta.Approval_Process_Status__c='';

             TAQ_UpdateTeamDetails_NH_TT oTAQ_UpdateTeamDetails_NH_TT = new TAQ_UpdateTeamDetails_NH_TT();
                   System.debug('_______________method call 4');
                    TAQ_Rules__c tr=oTAQ_UpdateTeamDetails_NH_TT.GetRuleMatch_taqAcc (ta, orderedRules,false);
                    ta.Is_Error_in_Rule__c= (tr==null);  
                
                     if((tr!=null))
                    {
                        ta.ownerid=mapRules.get(tr.id).Owner_Name_Id__c;
                        ta.Is_Error_in_Rule__c=false; 
                    }
                         
        }

        
    }
  

   //Create TAQ Approved Record and Standard Account Record
   
   if(trigger.isUpdate && allApprovedAcc.size() > 0)
   { 
      
      obj_CA_TAQ_Account_Approval_Class.createUpdateStdAccount(allApprovedAcc,mTAQAccOwnerPMFkey);

       List<TAQ_Account__c> taqApprIds = new list<TAQ_Account__c>();
       for(TAQ_Account__c t: allApprovedAcc) 
      {        
        if(t.chkPendingReview__c == false)
           taqApprIds.add(t);
        else
           t.Approval_Process_Status__c = 'Pending Review';
           system.debug('t.Approval_Process_Status__c0908u7j');                               
      }    

      obj_CA_TAQ_Account_Approval_Class.createTAQAccApprRec(taqApprIds);  //ByPassed objta.copyAccRecords(ta) method as part of FY13 - BR012. TADKR01
   }


    //VINU: Trial Management

    Id CISUser = UserInfo.getUserId();
    string strUserID = string.valueOf(CISUser);
    string CisInt = label.Cis_Integration_User;
    
    Map<id,string> CisIntegrationUser = new Map<id,string>();      
    CisIntegrationUser.put(CISUser,strUserID);
        
    for(TAQ_Account__c ta: Trigger.new){
            allApprovedAcc.add(ta);
            system.debug('CISUser22222'+CISUser);
    }
    
    if((trigger.isinsert) && (allApprovedAcc.size() > 0) && (CISUser == CisInt) ){
        
      obj_CA_TAQ_Account_Approval_Class.createUpdateStdAccount(allApprovedAcc,CisIntegrationUser);
      
      List<TAQ_Account__c> taqApprIds = new list<TAQ_Account__c>();
              for(TAQ_Account__c t: allApprovedAcc) 
              {        
                system.debug('t.chkPendingReview__c:'+t.chkPendingReview__c);
                if(t.chkPendingReview__c == false)
                   {
                   //taqApprIds.add(t);
                   t.Approval_Process_Status__c = 'Pending Review';
                   t.Approval_Status__c = 'Approved';
                   t.chkPendingReview__c = true;
                   t.Source__c = 'Trial';
                   }
                else
                {
                   //t.Approval_Process_Status__c = 'Pending Review';
                   system.debug('t.Approval_Process_Status__c:'+t.Approval_Process_Status__c);
                }                               
              }     
    obj_CA_TAQ_Account_Approval_Class.createTAQAccApprRec(taqApprIds);  //ByPassed objta.copyAccRecords(ta) method as part of FY13 - BR012. TADKR01
    }
    // End of Trial Management
    //FY13 end

    //Added by raipa02 on 09/11/11 for CRM Sprint 4. 
     if(mapRejected.keyset().size() > 0) //for Reverting the Rejected records Requirement
     {
         if(trigger.isUpdate && trigger.isBefore)
         {
          CA_TAQ_Trigger_class objcopy=new CA_TAQ_Trigger_class();
          mapRejected = objcopy.massCopyTAQAcc(mapRejected);
          for(taq_account__c t:trigger.New)
              if(mapRejected.keyset().contains(t.id))
                { 
                  t= mapRejected.get(t.id);   
                   
                 }     
         }
     }
    

  //CRM Sprint 4 ENd    
   
}
catch(Exception e){
    system.debug('Exception : '+e);
}


//Merge/Release
   if(trigger.isUpdate )
   {
       for(TAQ_Account__c t:trigger.New)
       {
       
           if((t.Process_Step__c=='Account Release' || t.Process_Step__c=='Account Merge') &&t.Approval_Status__c == 'Updated')
                t.ownerid=Label.GSOPS_Queue_Id;
       
       }   
   }
          

   // RE-DESIGNED ENTERPRISE ID GENERATION-TADKR01.
   List<TAQ_Account_ID_Counter__c> taqCounters = new List<TAQ_Account_ID_Counter__c>();
     try{ 
        taqCounters = [SELECT Name,Is_Partner_Counter__c,Counter__c FROM TAQ_Account_ID_Counter__c];
     }catch(Exception e){
        System.debug('_____Exception occured due to unavailablity of TAQ Account Id Counter record');
     }
   
    if(taqCounters.size()>0){
      Map<String,Map<Boolean,TAQ_Account_Id_Counter__c>> countersMap = new Map<String,Map<Boolean,TAQ_Account_Id_Counter__c>>();
      
      for(TAQ_Account_Id_Counter__c c:taqCounters){
        if(countersMap.containsKey(c.Name))
            countersMap.get(c.Name).put(c.Is_Partner_Counter__c,c);
        else{
            countersMap.put(c.Name,new Map<Boolean,TAQ_Account_Id_Counter__c>());
            countersMap.get(c.Name).put(c.Is_Partner_Counter__c,c);
        }
      }
        String TAQ_Region = NULL;
        String Region_Prefix = NULL;
        Map<Id,TAQ_Account_Id_Counter__c> updateCounters = new Map<Id,TAQ_Account_Id_Counter__c>();
        for(TAQ_Account__c t: Trigger.new){
            TAQ_Region = t.Region__c;
            //sunji03 - FY19 adding a new GEO PS/CAN, which is also using NA counter
            if (TAQ_Region == 'PS/CAN')
              TAQ_Region = 'NA';

            //FOR NON-PARTNER TAQ ACCOUNTS.
            if(countersMap.containsKey(TAQ_Region) && countersMap.get(TAQ_Region).containsKey(false) && (t.Approval_Process_Status__c=='Approved' || t.Approval_Status__c == 'Approved') && t.Process_Step__c=='Account Add' && profileMap.containsKey(t.recordtypeId) && (!profileMap.get(t.recordtypeId).contains('Partner')) && t.CA_Account_ID_Unique__c == NULL){
                countersMap.get(TAQ_Region).get(false).Counter__c+=1;
                
                Region_Prefix = countersMap.get(TAQ_Region).get(false).Name.Substring(0,1);
                
                if (t.Is_Primary_Account__c == true) t.CA_Account_ID_Unique__c = Region_Prefix + String.valueOf(countersMap.get(TAQ_Region).get(false).Counter__c).leftpad(6,'0');
                
                t.Enterprise_Id__c =  Region_Prefix + String.valueOf(countersMap.get(TAQ_Region).get(false).Counter__c).leftpad(6,'0'); 
            
                updateCounters.put(countersMap.get(TAQ_Region).get(false).Id,countersMap.get(TAQ_Region).get(false));
            }
            
           //FOR PARTNER TAQ ACCOUNTS.  
           if(((!CA_TAQ_Account_Approval_Class.PROCESSED_PARTNER_TAQ_IDS.contains(t.Name))  && (t.Approval_Process_Status__c=='Approved' || t.Approval_Status__c == 'Approved'))
              && countersMap.containsKey(TAQ_Region) && countersMap.get(TAQ_Region).containsKey(true)
              && (t.Approval_Process_Status__c=='Approved' || t.Approval_Status__c == 'Approved') 
              && t.Process_Step__c=='Account Add' && profileMap.containsKey(t.recordtypeId) 
              && (profileMap.get(t.recordtypeId).contains('Partner'))){                 
                countersMap.get(TAQ_Region).get(true).Counter__c+=1;
                
                Region_Prefix = 'P' + countersMap.get(TAQ_Region).get(false).Name.Substring(0,1);
                
                t.Reseller_Id__c =  Region_Prefix+String.valueOf(countersMap.get(TAQ_Region).get(true).Counter__c).leftpad(5,'0'); 
                
                updateCounters.put(countersMap.get(TAQ_Region).get(false).Id,countersMap.get(TAQ_Region).get(true));
                
                CA_TAQ_Account_Approval_Class.PROCESSED_PARTNER_TAQ_IDS.add(t.Name);
            }
        }   
        
        if(updateCounters.size()>0) update updateCounters.values();
    }
   
   
   //INTRODUCED TO BREAK THE INFINITE LOOP EXECUTION OF THE TRIGGER. 
     CA_TAQ_Account_Approval_Class.EXEC_COUNT++;

}