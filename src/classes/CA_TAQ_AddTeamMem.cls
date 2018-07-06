/**
* Description :  This trigger contain automated actions to change the record owner to corresponding queue once
*                a record is approved/rejected/send for approval.
*                This trigger invokes commitActions method from CA_TAQ_Trigger_class to
*                perform various actions of Open Headcount/New Hire/Employee change/Term Transfer Processes.
*               
* Author       : Jagan Babu Gorre
* Company      : Accenture
* Client       : Computer Associates
* Last Update  : March 2010
  FY 13 Update : Apex Class CA_TAQ_createTAQAccApprRec is created to re-work the functionality of following methods:
                 * addMembers * copyAccRecords  and would be used from FY13 onwards            
**/

public class CA_TAQ_AddTeamMem{

    public static boolean isflag=true;
    public static boolean isflag2=true;
    public static boolean isflag3=true;
    public static boolean isflag4=true;
    public static boolean isflag5=true;
    public static boolean isSystemUtilityFlag=false;
/*
    /** Following two methods addMembers and deleteMembers are part of Account Update process ** /

    public void addMembers(TAQ_Account__c ta,Account a){
    
     if(isflag){
        isflag=false;
        List<AccountTeamMember> actlist=new List<AccountTeamMember>();
        List<String> aeseKeys = new List<String>();
        Set<String> userkeyset=new Set<String>();
        Set<String> stpmfkey=new set<String>();
        Set<Id> stUsrids=new set<Id>();
        /** Take all the pmfs keys in a set 
        *   If PMF Key is valid (7-digits) then use the PMF key.
        *   If PMF Key isn't valid (e.g. Position ID), then take PMF key from 
        *   corresponding manager pmf key field (Hidden)
        ** /
        //PRM sprint 3 changes start
                               
        if(ta.Velocity_Seller_CAM_PMFKey__c<>null && ta.Velocity_Seller_CAM_PMFKey__c.length()==7)            
               stpmfkey.add(ta.Velocity_Seller_CAM_PMFKey__c.toUpperCase());
                                
        if(ta.Alliance_CAM_PMFKey__c<>null && ta.Alliance_CAM_PMFKey__c.length()==7)            
          stpmfkey.add(ta.Alliance_CAM_PMFKey__c.toUpperCase());
         
        if(ta.Service_Provider_CAM_PMFKey__c<>null && ta.Service_Provider_CAM_PMFKey__c.length()==7)            
          stpmfkey.add(ta.Service_Provider_CAM_PMFKey__c.toUpperCase()); 
        
        if(ta.Solution_Provider_CAM_PMFKey__c<>null && ta.Solution_Provider_CAM_PMFKey__c.length()==7)            
          stpmfkey.add(ta.Solution_Provider_CAM_PMFKey__c.toUpperCase());
        
        
       //PRM sprint 3 changes end
   
        Map<String,User> userMap = new Map<String,User>();
    
        /** Loop through the query and insert values in to a map ** /
        for(User u:[SELECT PMFKey__c,id,AE_SE_PMFKey__c from User WHERE PMFKey__c in :stpmfkey and isActive=true ]) {
            userMap.put(u.PMFKey__c.toUpperCase(),u);
            stUsrids.add(u.id);    
        }
        userkeyset=userMap.keyset();    
        
       //PRM sprint 3 changes start
       
       if(ta.Velocity_Seller_CAM_PMFKey__c<>null && userkeyset.contains(ta.Velocity_Seller_CAM_PMFKey__c.toUpperCase())){ 
          AccountTeamMember Teammemberad=new AccountTeamMember();                    
          Teammemberad.AccountId=a.id;                    
          Teammemberad.UserId=userMap.get(ta.Velocity_Seller_CAM_PMFKey__c.toUpperCase()).id;                    
          Teammemberad.TeamMemberRole = 'TAQ-PARTN RESELLER';                    
          actlist.add(Teammemberad);               
        } 
        
       if(ta.Alliance_CAM_PMFKey__c<>null && userkeyset.contains(ta.Alliance_CAM_PMFKey__c.toUpperCase())){ 
       
          AccountTeamMember Teammemberad=new AccountTeamMember();                    
          Teammemberad.AccountId=a.id;                    
          Teammemberad.UserId=userMap.get(ta.Alliance_CAM_PMFKey__c.toUpperCase()).id;                    
          Teammemberad.TeamMemberRole = 'TAQ-PARTN ALLIANCE';                    
          actlist.add(Teammemberad);                                             
        }      
        
      if(ta.Service_Provider_CAM_PMFKey__c<>null && userkeyset.contains(ta.Service_Provider_CAM_PMFKey__c.toUpperCase())){ 
          AccountTeamMember Teammemberad=new AccountTeamMember();                    
          Teammemberad.AccountId=a.id;                    
          Teammemberad.UserId=userMap.get(ta.Service_Provider_CAM_PMFKey__c.toUpperCase()).id;                    
          Teammemberad.TeamMemberRole = 'TAQ-PARTN SERPROV';                    
          actlist.add(Teammemberad);               
        }
    
      if(ta.Solution_Provider_CAM_PMFKey__c<>null && userkeyset.contains(ta.Solution_Provider_CAM_PMFKey__c.toUpperCase())){ 
          AccountTeamMember Teammemberad=new AccountTeamMember();                    
          Teammemberad.AccountId=a.id;                    
          Teammemberad.UserId=userMap.get(ta.Solution_Provider_CAM_PMFKey__c.toUpperCase()).id;                    
          Teammemberad.TeamMemberRole = 'TAQ-PARTN SOLPROV';                    
          actlist.add(Teammemberad);               
        }
    
             
       //PRM sprint 3 changes end
                
        /* Add AE/SE Shadows to Account Team* /
        User [] aeses=[SELECT id from User WHERE PMFKey__c IN :aeseKeys and isActive=true LIMIT 10];
        
        for(integer i=0;i<aeses.size();i++){
                AccountTeamMember Teammemberae=new AccountTeamMember();
                Teammemberae.AccountId=a.id;
                Teammemberae.UserId=aeses[i].id;
                Teammemberae.TeamMemberRole = 'TAQ-AE/SE';
                actlist.add(Teammemberae);
                
                stUsrids.add(aeses[i].id);
        }
    
    //    system.debug('list size:'+actlist.size());

      //   System.debug('actlist'+actlist + 'a.id'+ a.id);
        
        try{
            if(actlist.size()>0)
                insert actlist;//insert account team members
            /** Account Sharing Code ** /
            List<AccountShare> newShare = new List<AccountShare>();   
            Set<AccountShare> tmSet=new Set<AccountShare>();
            
            // Steve's debug code
            /*AccountShare ash=[Select a.UserOrGroupId, a.RowCause, a.OpportunityAccessLevel, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.ContactAccessLevel, a.CaseAccessLevel, a.AccountId, a.AccountAccessLevel From AccountShare a WHERE id='00rQ000000XJc6QIAT'];
            ash.AccountAccessLevel='Edit';
            ash.OpportunityAccessLevel='Edit';
            ash.CaseAccessLevel='Edit';
            
            update ash;* /
            
            //commented by Heena on 1/7/2010 as part of Defect # 49125 in PRM R2 regression testing
            /*
             for(Integer newcnt=0;newcnt<actlist.size();newcnt++){
             
                //if(actlist[newcnt].UserId<>userMap.get(ta.Account_Owner_PMF_Key__c.toUpperCase()).id){
                    AccountShare ash=new AccountShare();
                    ash.UserOrGroupId=actlist[newcnt].UserId;
                    ash.AccountId=actlist[newcnt].Accountid;
                    ash.AccountAccessLevel='Edit';
                    ash.OpportunityAccessLevel='Edit';
                    //ash.CaseAccessLevel='Edit';
                    //ash.ContactAccessLevel='Read';
                    if(!tmSet.contains(ash)){
                        newShare.add(ash);    
                        tmSet.addAll(newShare);
                    }
                    
                    system.debug('DEBUG ACC TEAM :'+ash);
                    
                    try {
                        insert ash;
                    } catch(Exception e){
                        system.debug('Exception in adding Team members:' + e + '-' + ash);  // Exception expected for account owner
                    }
                //}
            } * /
            /* DANVA01 ********************************************************************** /
           for(Integer newcnt=0;newcnt<actlist.size();newcnt++){
             
                //if(actlist[newcnt].UserId<>userMap.get(ta.Account_Owner_PMF_Key__c.toUpperCase()).id){
                    AccountShare ash=new AccountShare();
                    ash.UserOrGroupId=actlist[newcnt].UserId;
                    ash.AccountId=actlist[newcnt].Accountid;
                  //   system.debug('actlist.TeamMemberRole :'+  actlist[newcnt].TeamMemberRole );

                    if(actlist[newcnt].TeamMemberRole == 'TAQ-CST-CSM')
                    {
                        ash.AccountAccessLevel='Edit';
                        ash.OpportunityAccessLevel='Read';
                    }
                    else               
                      {
                        ash.AccountAccessLevel='Edit';
                        ash.OpportunityAccessLevel='Edit';
                      }
                    //ash.CaseAccessLevel='Edit';
                    //ash.ContactAccessLevel='Read';
                    if(!tmSet.contains(ash)){
                        newShare.add(ash);    
                        tmSet.addAll(newShare);
                    }                    
               //     system.debug('DEBUG ACC TEAM :'+ash);   
            }
        //    system.debug('DEBUG Entire ACC TEAM :'+newShare);
            Database.SaveResult[] lsr;
            if(newShare.size()>0)
                lsr = Database.insert(newShare,false);
            //insert newShare;
            for(Database.SaveResult sr : lsr){
                if(!sr.isSuccess()){
                // Get the first save result error.
                Database.Error err = sr.getErrors()[0];
            //    system.debug('insert failed with message: '+err.getMessage()+ 'for '+sr);
                }
            }
            
        }
        catch(Exception e){
           system.debug('Exception in adding Team members:'+e);
        }
            
    }
    }
    
     public void deleteMembers(TAQ_Account__c ta,Account a){
         if(isflag2){
             isflag2=false;
             List<AccountTeamMember> lteam=new List<AccountTeamMember>();
             lteam=[select AccountId,UserId,TeamMemberRole from AccountTeamMember where AccountId=:a.id and TeamMemberRole like 'TAQ-%'];
        //     system.debug('lteam size'+lteam.size());
             
             delete lteam;
         }
     }

    /***      
    *   Method to set values for all fields in TAQ Account based on the Account selected in Mini Form.
    *** / 
    
    public void SetMiniLayoutValues(TAQ_Account__c ta,Id eaid){
    
     if(isflag3){
        isflag3=false;
        TAQ_Account__c tacc=[select /*FY13 Market__c,* / Region__c,
                Area__c,Territory__c,Country__c,Account_Type__c,
                Split__c,Split_Type__c,
                Is_Primary_Account__c,
                //FY13- Account_Owner_Effective_Date__c,
                Physical_City__c,
                Physical_State_Province__c,Physical_Street__c,Physical_Zip_Postal_Code__c,
                //FY13- Account_Owner_Name__c,Sales_Director_Name__c,
                //FY13- SM_Effective_Date__c,     
                //FY13- Account_Owner_PMF_Key__c,Sales_Director_PMF_Key__c,           
                //FY13-Regional_Alliance_Director_PMF_Key__c,
                //FY13-Regional_Alliance_Director_Eff_Date__c,
                //FY13- GAD_AD_PMFKey__c,GAD_AD_Effective_Date__c,CSA_PMF_key__c,CST_CSA_PMFKey__c,CST_CSA_Effective_Date__c,CSA_Effective_Date__c,SAM_PMFKey__c,
                //FY13-SAM_Effective_Date__c,SS_VSA_Effective_Date__c,SS_VSA_PMFKey__c,
                //FY13-SS_PPM_PMFKey__c,SS_PPM_Effective_Date__c,
                //FY13-SS_MF_PMFKey__c,SS_MF_Effective_Date__c,SS_SEC_PMFKey__c,
                //FY13-SS_SEC_Effective_Date__c,SS_SA_PMFKey__c,
                //FY13-SS_SA_Effective_Date__c,GPS_PMFKey__c, GPS_Effective_Date__c, NCV_Quota_Products__c,
                //FY13- NCV_Quota_Services__c,NCV_Quota_Education__c,Enterprise_Id__c,
                //FY13-NCV_Quota_Total__c,SAP_ID__c,SAP_ID_Additional__c,
                  View_Acc_Record__c,Program_Level__c from TAQ_Account__c where id=:eaid];
    
        TAQ_Account__c ta2=tacc.clone(false,true);
        
        //FY13-ta.Market__c=tacc.Market__c;
        ta.Region__c=tacc.Region__c;
        ta.Area__c=tacc.Area__c;
        ta.Territory__c=tacc.Territory__c;
        ta.Country__c=tacc.Country__c;
        ta.Account_Type__c=tacc.Account_Type__c;
        //FY13-ta.Account_Class__c=tacc.Account_Class__c;
        //FY13-ta.Account_Owner_PMF_Key__c=tacc.Account_Owner_PMF_Key__c;
        //FY13-ta.Sales_Director_PMF_Key__c=tacc.Sales_Director_PMF_Key__c;
        //FY13-ta.Top_100_A_C_Y_N__c=tacc.Top_100_A_C_Y_N__c;
        ta.Split__c=tacc.Split__c;
        ta.Split_Type__c=tacc.Split_Type__c;
        ta.Is_Primary_Account__c=tacc.Is_Primary_Account__c;
        //FY13-ta.Account_Owner_Name__c=tacc.Account_Owner_Name__c;
        //FY13-ta.Account_Owner_Effective_Date__c=tacc.Account_Owner_Effective_Date__c;
        //FY13-ta.Sales_Director_Name__c=tacc.Sales_Director_Name__c;
        //FY13-ta.SM_Effective_Date__c=tacc.SM_Effective_Date__c;
        ta.Enterprise_Id__c=tacc.Enterprise_Id__c;
       /* //FY13 start-ta.Regional_Alliance_Director_PMF_Key__c=tacc.Regional_Alliance_Director_PMF_Key__c;
        ta.Regional_Alliance_Director_Eff_Date__c=tacc.Regional_Alliance_Director_Eff_Date__c;
        ta.CSA_PMF_key__c=tacc.CSA_PMF_key__c;
        ta.CST_CSA_PMFKey__c =tacc.CST_CSA_PMFKey__c;    //added by danva01
        ta.CST_CSA_Effective_Date__c = tacc.CST_CSA_Effective_Date__c;  //added by danva01
        ta.GAD_AD_PMFKey__c =tacc.GAD_AD_PMFKey__c;    //added by danva01
        ta.GAD_AD_Effective_Date__c = tacc.GAD_AD_Effective_Date__c; //added by danva01

        ta.CSA_Effective_Date__c=tacc.CSA_Effective_Date__c;
        ta.SAM_PMFKey__c=tacc.SAM_PMFKey__c;
        ta.SAM_Effective_Date__c=tacc.SAM_Effective_Date__c;
        ta.SS_VSA_Effective_Date__c=tacc.SS_VSA_Effective_Date__c;     
        ta.SS_VSA_PMFKey__c=tacc.SS_VSA_PMFKey__c;
        ta.SS_PPM_PMFKey__c=tacc.SS_PPM_PMFKey__c;
        ta.SS_PPM_Effective_Date__c=tacc.SS_PPM_Effective_Date__c;
        ta.SS_MF_PMFKey__c=tacc.SS_MF_PMFKey__c;
        ta.SS_MF_Effective_Date__c=tacc.SS_MF_Effective_Date__c;
        ta.SS_SEC_PMFKey__c=tacc.SS_SEC_PMFKey__c;
        ta.SS_SEC_Effective_Date__c=tacc.SS_SEC_Effective_Date__c;
        ta.SS_SA_PMFKey__c=tacc.SS_SA_PMFKey__c;
        ta.SS_SA_Effective_Date__c=tacc.SS_SA_Effective_Date__c;
        ta.GPS_PMFKey__c=tacc.GPS_PMFKey__c;
        ta.GPS_Effective_Date__c=tacc.GPS_Effective_Date__c;
        ta.NCV_Quota_Products__c=tacc.NCV_Quota_Products__c;
        ta.NCV_Quota_Services__c=tacc.NCV_Quota_Services__c;
        ta.NCV_Quota_Education__c=tacc.NCV_Quota_Education__c; 
       // ta.NCV_Quota_Total__c=tacc.NCV_Quota_Total__c;
        ta.SAP_ID__c=tacc.SAP_ID__c;
        ta.SAP_ID_Additional__c=tacc.SAP_ID_Additional__c; * / //FY13 End
        
        ta.Physical_City__c=tacc.Physical_City__c;
        ta.Physical_State_Province__c=tacc.Physical_State_Province__c;
        ta.Physical_Street__c=tacc.Physical_Street__c;
        ta.Physical_Zip_Postal_Code__c=tacc.Physical_Zip_Postal_Code__c;
        
        //FY13 - ta.Account_Owner_PMF_Key__c=tacc.Account_Owner_PMF_Key__c;
        //FY13 - ta.Sales_Director_PMF_Key__c=tacc.Sales_Director_PMF_Key__c;
        ta.View_Acc_Record__c=tacc.View_Acc_Record__c;
        ta.Program_Level__c=tacc.Program_Level__c;
     }   
    } 
    
    /***    
    *   Method to perfrom different actions of Account Add/Update/Release/Merge.
    *** / 
    public void AccTriggerActions_old(TAQ_Account__c ta,Id uid){
     
     if(isflag4)
     {
       isflag4=false;
       Id Accownrid=uid;
       /** Account update process ** /  
       if(ta.Process_Step__c=='Account Update'&& ta.Enterprise_ID__c==null)//reseller account
       {
            //String oldProgramLevel;//commented by Heena as per Shrini's Request during PRM R2 UAT defetc fixing on 12/9/2010 
            //***Changes Made by Accenture  -->>PRM-TAQ-R2 ,reqd-607'
            system.debug('************ta.View_Acc_Record__c'+ta.View_Acc_Record__c);
      
             Account[] a1=[select id,Program_Level__c from Account where id=:ta.View_Acc_Record__c];
            
         //   system.debug('result of query Account Update  **For Reseller'+a1);
          
            if(a1.size()>0){
                //oldProgramLevel=a1[0].Program_Level__c;//commented by Heena as per Shrini's Request during PRM R2 UAT defetc fixing on 12/9/2010 
                   Account a=new Account(id=a1[0].id);
                try{
                   a1[0].GEO__c=ta.Region__c;
                   if(ta.Reseller_Name__c !=null)
                   a1[0].Name=ta.Reseller_Name__c;
                   else
                   a1[0].Name=ta.Name;
                   
                   a1[0].Reseller_Distributor_Name__c=ta.Name;
                   a1[0].Reseller_Disti_Regional_ID__c=ta.Reseller_ID__c;
                   a1[0].Sales_Area__c=ta.Area__c;
                   a1[0].Sales_Region__c=ta.Territory__c;
                   //a1[0].Customer_Category__c=ta.Account_Type__c;
                   a1[0].Customer_Category__c=SystemIdUtility.getAccountType();
                   a1[0].Website=ta.Website__c;                        
                  //FY13 -  a1[0].Account_Class__c=ta.Account_Class__c;
                   //a1[0].NCV_Target_Products__c=ta.NCV_Quota_Products__c;
                   //a1[0].NCV_Target_Services_Education__c=ta.NCV_Quota_Services__c;
                   if(Accownrid<>null)
                       a1[0].Ownerid=Accownrid;
                  
                  //FY13 -  a1[0].Market__c=ta.Market__c;    
                   a1[0].DUNS_Number__c = ta.DUNS_Number__c;
                   a1[0].Business_Name__c = ta.Business_Name__c;
                   if(ta.Country__c<>null) {
                       a1[0].Country_Picklist__c=ta.Country__c;
                       a1[0].Region_Country__c=ta.Country__c.substring(0,2);
                   }
                   a1[0].NameLocal=ta.Account_Name_Local__c;
                   a1[0].Account_Name_Local_2_Phonetic__c=ta.Account_Name_Local_2_Phonetic__c;
                   a1[0].Account_Name_Local_3__c=ta.Account_Name_Local_3__c;
                   a1[0].Physical_Country_Local__c=ta.Physical_Country_Local__c;
                   a1[0].Physical_State_Prov_Local__c=ta.Physical_State_Prov_Local__c;
                   a1[0].Physical_City_Local__c=ta.Physical_City_Local__c;
                   a1[0].Physical_Street_Local__c=ta.Physical_Street_Local__c;
                   a1[0].Physical_Zip_Local__c=ta.Physical_Zip_Local__c;
                   a1[0].Provide_Partner_Kit__c=ta.Provide_Partner_Kit__c;
                  a1[0].Agreement__c=ta.Agreement__c;
                  a1[0].Contract_Start_Date__c=ta.Contract_Start_Date__c;
                  a1[0].Business_Plan__c=ta.Business_Plan__c;
                  a1[0].Business_Plan_Start_Date__c=ta.Business_Plan_Start_Date__c;
                  a1[0].Partner_Enablement_Addendum__c=ta.Partner_Enablement_Addendum__c;
                  a1[0].Agreement_Number__c=ta.Agreement_Number__c;
                  a1[0].Agreement_Attached__c=ta.Agreement_Attached__c;
                  a1[0].Contract_End_Date__c=ta.Agreement_End_Date__c;
                  a1[0].Business_Plan_Attached__c=ta.Business_Plan_Attached__c;
                  a1[0].Business_Plan_End_Date__c=ta.Business_Plan_End_Date__c;
                  a1[0].PDS_Addendum_Attached__c=ta.PDS_Addendum_Attached__c;
                  a1[0].Partner_Enablement_Addendum_Attached__c=ta.Partner_Enablement_Addendum_Attached__c;
                  a1[0].PDS_Addendum__c=ta.PDS_Addendum__c;
                  a1[0].Contract_Start_Date__c=ta.Agreement_Start_Date__c;
                  //commented by Heena as per Shrini's Request during PRM R2 UAT defetc fixing on 12/9/2010                  
                  /*
                  if(a1[0].Program_Level__c <> ta.Program_Level__c)
                  a1[0].Program_Level__c=ta.Program_Level__c;
                  else
                  oldProgramLevel='';
                  * / 
                  a1[0].Account_Type1__c=ta.Account_Type1__c;
                  a1[0].Account_Type__c=ta.Account_Type__c;
                //FY13 -   a1[0].Account_Type3__c=ta.Account_Type3__c;
                  //a1[0].Secondary_Designation__c=ta.Reseller_Type__c;
                  a1[0].Secondary_Designation_Reseller__c=ta.Reseller_Type__c;
                  //Commented below line as part of Sprint 4
                  //a1[0].Reseller_Type__c=SystemIdUtility.getResellerType();
                  a1[0].Primary_Designation_Reseller__c=SystemIdUtility.getPrimaryDesignationReseller();
                  a1[0].Account_Status__c=ta.Approval_Status__c;
                   
                   a1[0].Billingcity=ta.Physical_City__c;
                   a1[0].billingstate=ta.Physical_State_Province__c;
                   a1[0].billingstreet=ta.Physical_Street__c;
                   a1[0].billingpostalcode=ta.Physical_Zip_Postal_Code__c;
                   //Reseller Section
                     a1[0].Contract_Type__c=ta.Contract_Type__c;
                     a1[0].Contract_Start_Date_Reseller__c=ta.Contract_Start_Date__c;
                     a1[0].Contract_Expiration_Date__c=ta.Contract_Expiration_Date__c;
                   //Added for Redq.1386 by Accenture,on 16th Dec.
                  /*if(ta.CPMS_Id__c!='')
                   a1[0].CPMS_ID__c=ta.CPMS_Id__c;* / //commented by Heena as part of Defect 48892 in PRM R2
                   
                   
                   //PRM Sprint 3 code start
                   a1[0].Eligible_for_MDF__c=ta.Eligible_for_MDF__c;                   
                   a1[0].Alliance__c=ta.Alliance__c;
                   a1[0].Alliance_Type__c=ta.Alliance_Type__c;
                   a1[0].Alliance_Program_Level__c=ta.Alliance_Program_Level__c;
                   a1[0].Alliance_Designation__c=ta.Alliance_Designation__c;
                   a1[0].Alliance_CAM_PMFKey__c=ta.Alliance_CAM_PMFKey__c;
                                     
                   a1[0].Solution_Provider__c=ta.Solution_Provider__c;
                   a1[0].Solution_Provider_Type__c=ta.Solution_Provider_Type__c;
                   a1[0].Solution_Provider_Program_Level__c = ta.Solution_Provider_Program_Level__c;
                   a1[0].Solution_Provider_Designation__c = ta.Solution_Provider_Designation__c;
                   a1[0].Solution_Provider_CAM_PMFKey__c=ta.Solution_Provider_CAM_PMFKey__c;
                   a1[0].PDS_Addendum__c=ta.PDS_Addendum__c;
                   a1[0].PDS_Addendum_Attached__c=ta.PDS_Addendum_Attached__c;
                   
                   a1[0].Service_Provider__c=ta.Service_Provider__c;
                   a1[0].Service_Provider_Type__c=ta.Service_Provider_Type__c;
                   a1[0].Service_Provider_Program_Level__c = ta.Service_Provider_Program_Level__c;
                   a1[0].Service_Provider_Designation__c=ta.Service_Provider_Designation__c;
                   a1[0].Service_Provider_CAM_PMFKey__c=ta.Service_Provider_CAM_PMFKey__c;
                   
                   
                   a1[0].Velocity_Seller__c=ta.Velocity_Seller__c;                  
                   a1[0].Velocity_Seller_Type__c=ta.Velocity_Seller_Type__c;
                   a1[0].Velocity_Seller_Program_Level__c=ta.Velocity_Seller_Program_Level__c;
                   a1[0].Velocity_Seller_CAM_PMFKey__c=ta.Velocity_Seller_CAM_PMFKey__c;
                   a1[0].Velocity_Seller_Designation__c = ta.Velocity_Seller_Designation__c ;
                  
                   a1[0].Termination_Date__c=ta.Termination_Date__c;
                   a1[0].Termination_reason__c=ta.Termination_reason__c;
                   a1[0].Credit_Check_completion_date__c=ta.Credit_Check_completion_date__c;
                   a1[0].Security_Check_completion_date__c=ta.Security_Check_completion_date__c;  
                   
                   if(ta.Alliance__c || ta.Solution_Provider__c || ta.Service_Provider__c){
                    a1[0].Reseller_Type__c='Value';
                   } else{
                    a1[0].Reseller_Type__c='RMDM';
                   }
                                   
                   //PRM Sprint 3 code End 
                   
                    
                    //    System.debug('___________________________________-'+a1);        
            }catch(Exception e)
            {
            system.debug('Error Occur while mapping taq fields to std. account field during Account Update..'+e);
            }
                   try
                   {
                   DataBase.Saveresult Sr=DataBase.update( a1[0]);
                   /*System.debug('result---------------------'+Sr);
                   for(Database.Error err: Sr.getErrors())
                        {
                        ta.addError('Error in updating--'+err.getMessage()+'--------Status Code----'+err.getStatusCode());  
                        }* /
                        createOrUpdtAgrmnt(ta);
                   }
                   catch(DmlException ex)
                   {
                   ta.addError('Error:'+ex.getDmlMessage(0));//uncommented by Heena                   
                   //commented by Heena as per Shrini's Request during PRM R2 UAT defetc fixing on 12/9/2010 
                   /*if(oldProgramLevel!='')
                   ta.addError('Error:'+ex.getDmlMessage(0)+'Program Level:-'+oldProgramLevel);
                   else
                   ta.addError('Error:'+ex.getDmlMessage(0));* /
                   
                   }
                   
                  /** Update the Account Team Member of Standard Account** /              
                   deleteMembers(ta,a1[0]);
                   addMembers(ta,a1[0]);
              }
              else {
                  ta.addError('The Reseller Account Name is not an existing standard Account');
              }
            
            
            
            }
      
       
       if(ta.Process_Step__c=='Account Add' && ta.View_Acc_Record__c==null && ta.Enterprise_ID__c==null)//For Reseller Account Add Process
       {
        //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-606'
          //  system.debug('Reseller Id In Add Condition'+ ta.Reseller_ID__c);
                   
           Account a=new Account(name=ta.name);
          try
          {
               a.recordtypeid=SystemIdUtility.getResellerDistRecordTypeId();
               a.Reseller_Distributor_Name__c=ta.name;
               a.Reseller_Disti_Regional_ID__c=ta.Reseller_ID__c;
               
               //a.Customer_Category__c=ta.Account_Type__c;
               //changes made for sprint 4
               //start
              if(ta.Solution_Provider_Type__c == 'Distributor' || ta.Velocity_Seller_Type__c == 'Distributor')
              {
                 a.Customer_Category__c = 'Distributor';
              }else{
                a.Customer_Category__c=SystemIdUtility.getAccountType();
              }
               //  a.Customer_Category__c=SystemIdUtility.getAccountType();
               //end
             
               a.Website=ta.Website__c;                        
               //FY13 - a.Account_Class__c=ta.Account_Class__c;
               //a.NCV_Target_Products__c=ta.NCV_Quota_Products__c;
               //a.NCV_Target_Services_Education__c=ta.NCV_Quota_Services__c;
               
               a.GEO__c=ta.Region__c;
               a.Sales_Area__c=ta.Area__c;
               a.Sales_Region__c=ta.Territory__c;
               //FY13 - a.Market__c=ta.Market__c;
               
               a.NameLocal=ta.Account_Name_Local__c;
               a.Account_Name_Local_2_Phonetic__c=ta.Account_Name_Local_2_Phonetic__c;
               a.Account_Name_Local_3__c=ta.Account_Name_Local_3__c;
               a.Physical_Country_Local__c=ta.Physical_Country_Local__c;
               a.Physical_State_Prov_Local__c=ta.Physical_State_Prov_Local__c;
               a.Physical_City_Local__c=ta.Physical_City_Local__c;
               a.Physical_Street_Local__c=ta.Physical_Street_Local__c;
               a.Physical_Zip_Local__c=ta.Physical_Zip_Local__c;
               a.Provide_Partner_Kit__c=ta.Provide_Partner_Kit__c;
               a.Agreement__c=ta.Agreement__c;
               a.Contract_Start_Date__c=ta.Contract_Start_Date__c;
               a.Business_Plan__c=ta.Business_Plan__c;
               a.Business_Plan_Start_Date__c=ta.Business_Plan_Start_Date__c;
               a.Partner_Enablement_Addendum__c=ta.Partner_Enablement_Addendum__c;
               a.Agreement_Number__c=ta.Agreement_Number__c;
               a.Agreement_Attached__c=ta.Agreement_Attached__c;
               a.Contract_End_Date__c=ta.Agreement_End_Date__c;
               a.Business_Plan_Attached__c=ta.Business_Plan_Attached__c;
               a.Business_Plan_End_Date__c=ta.Business_Plan_End_Date__c;
               a.PDS_Addendum_Attached__c=ta.PDS_Addendum_Attached__c;
               a.Partner_Enablement_Addendum_Attached__c=ta.Partner_Enablement_Addendum_Attached__c;
               a.PDS_Addendum__c=ta.PDS_Addendum__c;
               a.Contract_Start_Date__c=ta.Agreement_Start_Date__c;
               a.Program_Level__c=ta.Program_Level__c;
               a.Account_Type1__c=ta.Account_Type1__c;
               a.Account_Type__c=ta.Account_Type__c;
              
               //FY13 - a.Account_Type3__c=ta.Account_Type3__c;
            //   system.debug('ta.Account_Type3__c:-------'+ta.Account_Type3__c);
             //  system.debug('a.Account_Type3__c:--------'+a.Account_Type3__c);
              // a.Secondary_Designation__c=ta.Reseller_Type__c;
               a.Secondary_Designation_Reseller__c=ta.Reseller_Type__c;
               
               //commented on sprint 4
               //a.Reseller_Type__c=SystemIdUtility.getResellerType();
               a.Primary_Designation_Reseller__c=SystemIdUtility.getPrimaryDesignationReseller();
               a.Account_Status__c=ta.Approval_Status__c;
               
               a.Billingcity=ta.Physical_City__c;
               a.billingstate=ta.Physical_State_Province__c;
               a.billingstreet=ta.Physical_Street__c;
               a.billingpostalcode=ta.Physical_Zip_Postal_Code__c;
    
               //PRM Sprint 3 code start              
                a.Eligible_for_MDF__c=ta.Eligible_for_MDF__c;
                a.Alliance__c=ta.Alliance__c;
                a.Alliance_Type__c=ta.Alliance_Type__c;
                a.Alliance_Program_Level__c=ta.Alliance_Program_Level__c;
                a.Alliance_Designation__c=ta.Alliance_Designation__c;
                a.Alliance_CAM_PMFKey__c=ta.Alliance_CAM_PMFKey__c;
                
                a.Solution_Provider__c=ta.Solution_Provider__c;
                a.Solution_Provider_Type__c=ta.Solution_Provider_Type__c;
                a.Solution_Provider_Program_Level__c = ta.Solution_Provider_Program_Level__c;
                a.Solution_Provider_Designation__c = ta.Solution_Provider_Designation__c;
                a.Solution_Provider_CAM_PMFKey__c=ta.Solution_Provider_CAM_PMFKey__c;
                a.PDS_Addendum__c=ta.PDS_Addendum__c;
                a.PDS_Addendum_Attached__c=ta.PDS_Addendum_Attached__c;
                                           
                a.Service_Provider__c=ta.Service_Provider__c;
                a.Service_Provider_Type__c=ta.Service_Provider_Type__c;
                a.Service_Provider_Program_Level__c = ta.Service_Provider_Program_Level__c;
                a.Service_Provider_Designation__c=ta.Service_Provider_Designation__c;
                a.Service_Provider_CAM_PMFKey__c=ta.Service_Provider_CAM_PMFKey__c;
               
                a.Velocity_Seller__c=ta.Velocity_Seller__c;
                a.Velocity_Seller_Type__c=ta.Velocity_Seller_Type__c; 
                a.Velocity_Seller_Program_Level__c=ta.Velocity_Seller_Program_Level__c;
                a.Velocity_Seller_Designation__c = ta.Velocity_Seller_Designation__c ;
                a.Velocity_Seller_CAM_PMFKey__c=ta.Velocity_Seller_CAM_PMFKey__c;
                
                               
                a.Termination_Date__c=ta.Termination_Date__c;
                a.Termination_reason__c=ta.Termination_reason__c;            
                a.Credit_Check_completion_date__c=ta.Credit_Check_completion_date__c;
                a.Security_Check_completion_date__c=ta.Security_Check_completion_date__c;
                if(ta.Alliance__c || ta.Solution_Provider__c || ta.Service_Provider__c){
                   a.Reseller_Type__c='Value';
                } else{
                   a.Reseller_Type__c='RMDM';
                }                
                //PRM Sprint 3 code End
    
              //a.IsPartner=true;
              //Reseller Section
               a.Contract_Type__c=ta.Contract_Type__c;
               a.Contract_Start_Date_Reseller__c=ta.Contract_Start_Date__c;
               a.Contract_Expiration_Date__c=ta.Contract_Expiration_Date__c;
              //Added for Redq.1386 by Accenture,on 16th Dec.
               if(ta.CPMS_Id__c!='')
               a.CPMS_ID__c=ta.CPMS_Id__c;
                   if(Accownrid<>null)
                       a.Ownerid=Accownrid;
                   if(ta.Country__c<>null) 
                   {
                       a.Country_Picklist__c=ta.Country__c;
                       a.Region_Country__c=ta.Country__c.substring(0,2);
                   }
                   
                   
                       DataBase.Saveresult Sr=DataBase.insert(a);
                       
               ta.View_Acc_Record__c=a.id;
               a.DUNS_Number__c = ta.DUNS_Number__c;
               a.Business_Name__c = ta.Business_Name__c;
               createOrUpdtAgrmnt(ta); //PRM sprint 3
           //    system.debug('ta.View_Acc_Record__c:--------------'+ta.View_Acc_Record__c);
               if(ta.Account_Name_Change__c=='' || ta.Account_Name_Change__c==null)
                 ta.Account_Name_Change__c=ta.Name;
              // if(!isSystemUtilityFlag)
               //update ta;
               addMembers(ta,a);
    
           //    System.debug('________________.....___________________-'+a); 
          }catch(DmlException ex)
          {
            ta.addError('Error:'+ex.getDmlMessage(0));
            system.debug('Error Occurs While mapping fields to standered accountduring Account Add.'+ex);
          }
         }          
       /** Account Release/Merge process ** / 
       if((ta.Process_Step__c=='Account Release' || ta.Process_Step__c=='Account Merge') && ta.Approval_Process_Status__c<>'Updated'){
           ta.ownerid=Label.GSOPS_Queue_Id;
       }
      }
   }

   //PRM Sprint 3 code Start
    /***    
    *   Method to perfrom Creation and Updates on Agreement Object .
    *** /
   public void createOrUpdtAgrmnt(TAQ_Account__c taqAcc){

      //   system.debug('**********Update Agreement ');
         map<String,Route_To_Market__c> m = new map<String,Route_To_Market__c>();
         List<Route_To_Market__c> agrmnt = [SELECT id,Name,RTM__c FROM Route_To_Market__c where Account__c =: taqAcc.View_Acc_Record__c ];
          
         for(Route_To_Market__c a :agrmnt ){
             m.put(a.RTM__c,a );
         }
         if(taqAcc.Alliance__c  == true){
            if(m.containsKey('Alliance')){
               Route_To_Market__c agrmntrec = m.get('Alliance');     
               agrmntrec.Name = taqAcc.Name+'-Alliance';
               agrmntrec.RTM__c = 'Alliance';
               agrmntrec.RTM_Type__c =taqAcc.Alliance_Type__c ; 
               agrmntrec.Program_Level__c =  taqAcc.Alliance_Program_Level__c ;
               agrmntrec.CAM_PMFKey__c = taqAcc.Alliance_CAM_PMFKey__c ;
               agrmntrec.Designation__c  =  taqAcc.Alliance_Designation__c ;
               update agrmntrec ;
            }else{
               Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-Alliance',RTM__c = 'Alliance',RTM_Type__c =taqAcc.Alliance_Type__c,Program_Level__c =  taqAcc.Alliance_Program_Level__c,CAM_PMFKey__c = taqAcc.Alliance_CAM_PMFKey__c,Designation__c  =  taqAcc.Alliance_Designation__c);
               insert agg ;
              }
         }else{
              if(m.containsKey('Alliance')){
                 Route_To_Market__c agrmntrec = m.get('Alliance');
                 delete agrmntrec;
              }
         }
         if(taqAcc.Service_Provider__c == true){

           if(m.containsKey('Service Provider')){
              Route_To_Market__c agrmntrec = m.get('Service Provider');
              agrmntrec.RTM__c = 'Service Provider' ;
              agrmntrec.Name = taqAcc.Name+'-Service Provider';
              agrmntrec.Program_Level__c =  taqAcc.Service_Provider_Program_Level__c ;
              agrmntrec.RTM_Type__c =taqAcc.Service_Provider_Type__c; 
              agrmntrec.CAM_PMFKey__c = taqAcc.Service_Provider_CAM_PMFKey__c;
              agrmntrec.Designation__c  =  taqAcc.Service_Provider_Designation__c ;
              
              update agrmntrec ;
           }else{
              Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-Service Provider',RTM__c = 'Service Provider',RTM_Type__c =taqAcc.Service_Provider_Type__c,Program_Level__c =  taqAcc.Service_Provider_Program_Level__c,CAM_PMFKey__c = taqAcc.Service_Provider_CAM_PMFKey__c,Designation__c  =  taqAcc.Service_Provider_Designation__c);
              insert agg ;
            }
         }else{
              if(m.containsKey('Service Provider')){
                 Route_To_Market__c agrmntrec = m.get('Service Provider');
                 delete agrmntrec;
              }
         }

         if(taqAcc.Solution_Provider__c == true){
            if(m.containsKey('Solution Provider')){

               Route_To_Market__c agrmntrec = m.get('Solution Provider');
               agrmntrec.Name = taqAcc.Name+'-Solution Provider';
               agrmntrec.RTM__c = 'Solution Provider' ;               
               agrmntrec.RTM_Type__c =taqAcc.Solution_Provider_Type__c ; 
               agrmntrec.Program_Level__c =  taqAcc.Solution_Provider_Program_Level__c ;
               agrmntrec.CAM_PMFKey__c = taqAcc.Solution_Provider_CAM_PMFKey__c ;
               agrmntrec.Designation__c  =  taqAcc.Solution_Provider_Designation__c ;
               update agrmntrec ; 
            }else{
              Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-Solution Provider',RTM__c = 'Solution Provider',RTM_Type__c =taqAcc.Solution_Provider_Type__c,Program_Level__c =  taqAcc.Solution_Provider_Program_Level__c,CAM_PMFKey__c = taqAcc.Solution_Provider_CAM_PMFKey__c,Designation__c  =  taqAcc.Solution_Provider_Designation__c);
              insert agg ;         
             }              
         }
         else{
              if(m.containsKey('Solution Provider')){
                 Route_To_Market__c agrmntrec = m.get('Solution Provider');
                 delete agrmntrec;
              }
         }

    
    }
     //PRM Sprint 3 code End
*/

public void SetMiniLayoutValues(TAQ_Account__c ta,Id eaid){
    
     if(isflag3){
        isflag3=false;
        TAQ_Account__c tacc=[select /*FY13 Market__c,*/ Region__c,
                Area__c,Territory__c,Country__c,Account_Type__c,
                Split__c,Split_Type__c,
                Is_Primary_Account__c,
                //FY13- Account_Owner_Effective_Date__c,
                Physical_City__c,
                Physical_State_Province__c,Physical_Street__c,Physical_Zip_Postal_Code__c,
                //FY13- Account_Owner_Name__c,Sales_Director_Name__c,
                //FY13- SM_Effective_Date__c,     
                //FY13- Account_Owner_PMF_Key__c,Sales_Director_PMF_Key__c,           
                //FY13-Regional_Alliance_Director_PMF_Key__c,
                //FY13-Regional_Alliance_Director_Eff_Date__c,
                //FY13- GAD_AD_PMFKey__c,GAD_AD_Effective_Date__c,CSA_PMF_key__c,CST_CSA_PMFKey__c,CST_CSA_Effective_Date__c,CSA_Effective_Date__c,SAM_PMFKey__c,
                //FY13-SAM_Effective_Date__c,SS_VSA_Effective_Date__c,SS_VSA_PMFKey__c,
                //FY13-SS_PPM_PMFKey__c,SS_PPM_Effective_Date__c,
                //FY13-SS_MF_PMFKey__c,SS_MF_Effective_Date__c,SS_SEC_PMFKey__c,
                //FY13-SS_SEC_Effective_Date__c,SS_SA_PMFKey__c,
                //FY13-SS_SA_Effective_Date__c,GPS_PMFKey__c, GPS_Effective_Date__c, NCV_Quota_Products__c,
                //FY13- NCV_Quota_Services__c,NCV_Quota_Education__c,Enterprise_Id__c,
                //FY13-NCV_Quota_Total__c,SAP_ID__c,SAP_ID_Additional__c,
                  View_Acc_Record__c,Enterprise_Id__c,Program_Level__c from TAQ_Account__c where id=:eaid];
    
        TAQ_Account__c ta2=tacc.clone(false,true);
        
        //FY13-ta.Market__c=tacc.Market__c;
        ta.Region__c=tacc.Region__c;
        ta.Area__c=tacc.Area__c;
        ta.Territory__c=tacc.Territory__c;
        ta.Country__c=tacc.Country__c;
        ta.Account_Type__c=tacc.Account_Type__c;
        //FY13-ta.Account_Class__c=tacc.Account_Class__c;
        //FY13-ta.Account_Owner_PMF_Key__c=tacc.Account_Owner_PMF_Key__c;
        //FY13-ta.Sales_Director_PMF_Key__c=tacc.Sales_Director_PMF_Key__c;
        //FY13-ta.Top_100_A_C_Y_N__c=tacc.Top_100_A_C_Y_N__c;
        ta.Split__c=tacc.Split__c;
        ta.Split_Type__c=tacc.Split_Type__c;
        ta.Is_Primary_Account__c=tacc.Is_Primary_Account__c;
        //FY13-ta.Account_Owner_Name__c=tacc.Account_Owner_Name__c;
        //FY13-ta.Account_Owner_Effective_Date__c=tacc.Account_Owner_Effective_Date__c;
        //FY13-ta.Sales_Director_Name__c=tacc.Sales_Director_Name__c;
        //FY13-ta.SM_Effective_Date__c=tacc.SM_Effective_Date__c;
        ta.Enterprise_Id__c=tacc.Enterprise_Id__c;
       /* FY13 start-ta.Regional_Alliance_Director_PMF_Key__c=tacc.Regional_Alliance_Director_PMF_Key__c;
        ta.Regional_Alliance_Director_Eff_Date__c=tacc.Regional_Alliance_Director_Eff_Date__c;
        ta.CSA_PMF_key__c=tacc.CSA_PMF_key__c;
        ta.CST_CSA_PMFKey__c =tacc.CST_CSA_PMFKey__c;    //added by danva01
        ta.CST_CSA_Effective_Date__c = tacc.CST_CSA_Effective_Date__c;  //added by danva01
        ta.GAD_AD_PMFKey__c =tacc.GAD_AD_PMFKey__c;    //added by danva01
        ta.GAD_AD_Effective_Date__c = tacc.GAD_AD_Effective_Date__c; //added by danva01

        ta.CSA_Effective_Date__c=tacc.CSA_Effective_Date__c;
        ta.SAM_PMFKey__c=tacc.SAM_PMFKey__c;
        ta.SAM_Effective_Date__c=tacc.SAM_Effective_Date__c;
        ta.SS_VSA_Effective_Date__c=tacc.SS_VSA_Effective_Date__c;     
        ta.SS_VSA_PMFKey__c=tacc.SS_VSA_PMFKey__c;
        ta.SS_PPM_PMFKey__c=tacc.SS_PPM_PMFKey__c;
        ta.SS_PPM_Effective_Date__c=tacc.SS_PPM_Effective_Date__c;
        ta.SS_MF_PMFKey__c=tacc.SS_MF_PMFKey__c;
        ta.SS_MF_Effective_Date__c=tacc.SS_MF_Effective_Date__c;
        ta.SS_SEC_PMFKey__c=tacc.SS_SEC_PMFKey__c;
        ta.SS_SEC_Effective_Date__c=tacc.SS_SEC_Effective_Date__c;
        ta.SS_SA_PMFKey__c=tacc.SS_SA_PMFKey__c;
        ta.SS_SA_Effective_Date__c=tacc.SS_SA_Effective_Date__c;
        ta.GPS_PMFKey__c=tacc.GPS_PMFKey__c;
        ta.GPS_Effective_Date__c=tacc.GPS_Effective_Date__c;
        ta.NCV_Quota_Products__c=tacc.NCV_Quota_Products__c;
        ta.NCV_Quota_Services__c=tacc.NCV_Quota_Services__c;
        ta.NCV_Quota_Education__c=tacc.NCV_Quota_Education__c; 
       // ta.NCV_Quota_Total__c=tacc.NCV_Quota_Total__c;
        ta.SAP_ID__c=tacc.SAP_ID__c;
        ta.SAP_ID_Additional__c=tacc.SAP_ID_Additional__c; */ //FY13 End
        
        ta.Physical_City__c=tacc.Physical_City__c;
        ta.Physical_State_Province__c=tacc.Physical_State_Province__c;
        ta.Physical_Street__c=tacc.Physical_Street__c;
        ta.Physical_Zip_Postal_Code__c=tacc.Physical_Zip_Postal_Code__c;
        
        //FY13 - ta.Account_Owner_PMF_Key__c=tacc.Account_Owner_PMF_Key__c;
        //FY13 - ta.Sales_Director_PMF_Key__c=tacc.Sales_Director_PMF_Key__c;
        ta.View_Acc_Record__c=tacc.View_Acc_Record__c;
        ta.Program_Level__c=tacc.Program_Level__c;
     }   
    }


}