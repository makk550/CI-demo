/**
* Description :This global schedule class contains a web service method
*              to handle TAQ Account record updates based on the process steps of the
*              Approved Org records. 
* 
**/
global class CA_TAQ_Schedule_Org_TT {} //FY13 commented
/*
global class CA_TAQ_Schedule_Org_TT implements schedulable{
    public static boolean isTestVar=false;
        
    global void execute (SchedulableContext sc){
    
            SystemIdUtility.isFutureUpdate = true;
            CA_TAQ_Schedule_Org_TT.updateTAQAcc_TT();
    }
 
    webservice static void updateTAQAcc_TT(){
     
        Map<String,TAQ_Organization_Approved__c> orgAppMap=new Map<String,TAQ_Organization_Approved__c>();
        
        TAQ_Organization_Approved__c[] ta = 
                [SELECT Batch_Process_Status_TT__c,id,PMFKey__c,position_id__c, process_status__c, process_message__c,
                 process_step__c, createdDate,PlanType_Effective_Date__c,Manager_PMFKey__c
                   FROM TAQ_Organization_Approved__c
                    WHERE  process_step__c = 'Term / Transfer' 
                          AND
                              process_status__c = 'Success' 
                          AND Is_Latest_Record__c=true
                          AND (Batch_Process_Status_TT__c = null 
                          or Batch_Process_Status_TT__c = 'Failure-TAQ Not Updated-TT'
                           or Batch_Process_Status_TT__c = 'Reprocess'
                          )
                          LIMIT 10];  
        try{                    
            
            if (ta.size()>0) {
                
                for(integer i=0;i<ta.size();i++){
                    orgAppMap.put(ta[i].PMFKey__c,ta[i]);
                }
                CA_TAQ_Schedule_Org_TT.changeAccoutPMFKeys(ta,orgAppMap);
            
                /**Below code will execute only for the Test Method.
                *  This will throw the exception 
                ** /
                if(isTestVar==true)
                    TAQ_Organization_Approved__c ExTa = [select id from TAQ_Organization_Approved__c where name='exception test'];
                
                //CA_TAQ_Schedule_Org_TT.updateStatus(ta,msg,stat);
            }
            
        }
        catch(Exception e){
            system.debug(e);
            String msg='Exception Occured while updating';
            String stat='Failure-TAQ Not Updated-NH/EC';
          //  TAQ_SendTestEmails.SendMail('CA_TAQ_Schedule_Org_TT', e);    
            CA_TAQ_Schedule_Org_TT.updateStatus(ta,msg,stat);
        }
        
   }

    global static void updateStatus( TAQ_Organization_Approved__c[] t, string status, string message){
         
         for (Integer i = 0; i < t.size(); i++){
             //t[0].process_message__c = message;
             t[0].Batch_Process_Status_TT__c = status;
         }
         if(t.size()>0){
         TAQOrgAdmin.inFutureContext=true;
         update t;
         }
     }
     
   
    
    public static void changeAccoutPMFKeys(TAQ_Organization_Approved__c[] ListTa,Map<String,TAQ_Organization_Approved__c> orgAppMap){
        
        set<String> pmfkeyset=new set<String>();
        pmfkeyset.addAll(orgAppMap.keySet());
        
        List<String> pmflist=new List<String>();
        for(String s:pmfkeyset)
            pmflist.add('\''+s+'\'');
        
        set<Id> Accids=new set<Id>();
        Map<Id,TAQ_Account__c> accMap=new Map<Id,TAQ_Account__c>();
        
        /** Below is the code to call the Batch Process ** /
        
        CA_TAQ_Batch_Process_Org_TT updateAccs=new CA_TAQ_Batch_Process_Org_TT();
        
        if(isTestVar==false)
            updateAccs.query='Select Approval_Status__c,Account_Owner_PMF_Key__c,CSA_PMF_key__c,'+
                         +'View_Acc_Record__c,Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,'+
                         +'Account_Owner_Manager_PMFKey__c,'+
                         +'Sales_Director_Manager_PMFKey__c,'+
                         +'GPS_Manager_PMFKey__c,'+
                         +'CSA_Manager_PMFKey__c,'+
                         +'SS_PPM_Manager_PMFKey__c,'+
                         +'SS_MF_Manager_PMFKey__c,'+
                         +'SAM_Manager_PMFKey__c,'+
                         +'SS_VSA_Manager_PMFKey__c,'+
                         +'SS_SEC_Manager_PMFKey__c,'+
                         +'SS_SA_Manager_PMFKey__c,'+
                         +'Regional_Alliance_Director_PMF_Key__c,'+
                         +'SS_PPM_PMFKey__c,SS_SA_PMFKey__c,SS_SEC_PMFKey__c,'+
                         +'SS_VSA_PMFKey__c,GPS_PMFKey__c,Reseller_Account_Director_PMFKey__c,'+
                         +'SAM_PMFKey__c from TAQ_Account__c where (Approval_Status__c=\'Approved\' or Approval_Status__c=\'Migrated\' or Approval_Status__c=\'Send For Approval\')'+
                         +' and Process_Step__c<>\'Account Release\' and  Process_Step__c<>\'Account Merge\' '+
                         +' and (Account_Owner_PMF_Key__c in '+pmflist+' or '+ 
                         +' Sales_Director_PMF_Key__c in '+pmflist+' or  '+ 
                         +' SS_MF_PMFKey__c  in '+pmflist+'  or  '+ 
                         +' SS_PPM_PMFKey__c in '+pmflist+'  or '+ 
                         +' SS_SA_PMFKey__c in '+pmflist+'  or '+ 
                         +' SS_SEC_PMFKey__c in '+pmflist+'  or '+ 
                         +' SS_VSA_PMFKey__c in '+pmflist+'  or '+ 
                         +' CSA_PMF_key__c in '+pmflist+'  or '+ 
                         +' GPS_PMFKey__c in '+pmflist+'  or '+ 
                         +' Regional_Alliance_Director_PMF_Key__c in '+pmflist+' or '+ 
                         +' Reseller_Account_Director_PMFKey__c in '+pmflist+' or '+ 
                         +' SAM_PMFKey__c in '+pmflist+')';
          else if(isTestVar==true)
                updateAccs.query='Select Account_Owner_PMF_Key__c,CSA_PMF_key__c,'+
                         +'View_Acc_Record__c,Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,'+
                         +'Account_Owner_Manager_PMFKey__c,'+
                         +'Sales_Director_Manager_PMFKey__c,'+
                         +'GPS_Manager_PMFKey__c,'+
                         +'CSA_Manager_PMFKey__c,'+
                         +'SS_PPM_Manager_PMFKey__c,'+
                         +'SS_MF_Manager_PMFKey__c,'+
                         +'SAM_Manager_PMFKey__c,'+
                         +'SS_VSA_Manager_PMFKey__c,'+
                         +'SS_SEC_Manager_PMFKey__c,'+
                         +'SS_SA_Manager_PMFKey__c,'+
                         +'Regional_Alliance_Director_PMF_Key__c,'+
                         +'SS_PPM_PMFKey__c,SS_SA_PMFKey__c,SS_SEC_PMFKey__c,'+
                         +'SS_VSA_PMFKey__c,GPS_PMFKey__c,Reseller_Account_Director_PMFKey__c,'+
                         +'SAM_PMFKey__c from TAQ_Account__c where name=\'test batch acc5\' limit 1';
                
          
          //updateAccs.email='jagan.gorre@accenture.com';
          updateAccs.orgAppMap=orgAppMap;
          updateAccs.listTa.addAll(ListTa);
          ID batchprocessid = Database.executeBatch(updateAccs,1);  
    
    }
    
        
    /** Test Methods ** /
    @isTest
    private static void NHOrgSchedulerTest() {
        
        User[] u=[select id,PMFKey__c,profileId,userRoleId  from User where isActive=true and PMFKey__c<>null limit 1];
        
        //Create Dummy Records for TAQ Org Approved and TAQ Ref position
        Date d=system.today();        
        TAQ_REF_Position__c testRp =new TAQ_REF_Position__c();
        testRp.name='TEST POS';
        testRp.profile_id__c=u[0].profileId;
        testRp.role_id__c=u[0].userRoleId;
        testRp.profile_name__c='test profile';
        testRp.role_name__c='test role';
        insert testRp; 
        List<TAQ_Organization_Approved__c> lstta=new List<TAQ_Organization_Approved__c>();                                         
        
        TAQ_Organization_Approved__c ta=new TAQ_Organization_Approved__c();
        ta.PMFKey__c='test pmf';
        ta.PlanType_Effective_Date__c=d.toStartOfMonth();
        ta.position_id__c='batch test pos';
        ta.process_status__c = 'Success';
        ta.process_message__c='';
        ta.process_step__c= 'Term / Transfer';
        ta.employee_status__c = 'Transfer';
        ta.Plan_Type__c='TEST PLAN';
        ta.Organization__c='DIRECT';
        ta.Is_Latest_Record__c=true;
        ta.Batch_Process_Status_TT__c = null; 
        ta.Manager_PMFKey__c=u[0].PMFKey__c;
        insert ta;

        lstta.add(ta);
        TAQ_Rules__c ttr3=new TAQ_Rules__c();
        ttr3.Queue_Name__c='TAQ EMEA Approver';
        ttr3.Send_To__c='Requestor';
        ttr3.Region__c='EMEA';
        ttr3.Area__c='testa';
        ttr3.Organization__c='DIRECT';
        ttr3.Object_Name__c='TAQ Account';
        ttr3.Record_Type_Name__c='Enterprise Account';
        insert ttr3;
          
        TAQ_Rules__c ttr4=new TAQ_Rules__c();
        ttr4.Queue_Name__c='TAQ EMEA Approver';
        ttr4.Send_To__c='Approver';
        ttr4.Region__c='EMEA';
        ttr4.Area__c='testa';
        ttr4.Organization__c='DIRECT';
        ttr4.Object_Name__c='TAQ Account';
        insert ttr4;
        
            
        // create a test account 1st
        Id recid=[select id from RecordType where name='CA Enterprise Account' limit 1].id;
        Account acc1 = new Account();
        acc1.Name = 'idc test batch acc';
        acc1.BillingState = 'NY';
        acc1.recordTypeid=recid;
        insert acc1;
        AccountTeamMember Teammemberad=new AccountTeamMember();
        Teammemberad.AccountId=acc1.id;
        Teammemberad.UserId=u[0].id;
        Teammemberad.TeamMemberRole = 'TAQ-SS_PPM';
        insert Teammemberad;
       
        
        List<TAQ_Organization__c> tOrgs = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 10];
        TAQ_Account__c newacc=new TAQ_Account__c();
        
        newacc.Approval_Status__c='Approved';
        newacc.Process_Step__c='Account Ad';
        newacc.name='test batch acc5';
        newacc.Enterprise_Account_Name__c='test acc name';
        newacc.Reseller_ID__c='test id';
        newacc.Reseller_Name__c='test res';
        newacc.Market__c='testm';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Type__c='test type';
        newacc.Account_Class__c='Class 4';
       
        newacc.Industry_Vertical__c='test ind';
        newacc.Stock_Ticker__c='test tick';
        newacc.Comments__c='testcom';
        newacc.Top_100_A_C_Y_N__c='Y';
        newacc.ownerid=userinfo.getuserid();    
        newacc.Account_Owner_PMF_Key__c= tOrgs[0].PMFKey__c;
        newacc.Account_Owner_Effective_Date__c = d.toStartOfMonth();
        newacc.Sales_Director_PMF_Key__c= tOrgs[0].PMFKey__c;
        newacc.SM_Effective_Date__c= d.toStartOfMonth();
        newacc.Regional_Alliance_Director_PMF_Key__c=tOrgs[0].PMFKey__c;
        newacc.Regional_Alliance_Director_Eff_Date__c=d.toStartOfMonth();
        newacc.CSA_PMF_key__c=tOrgs[0].PMFKey__c;
            
        newacc.CSA_Effective_Date__c=d.toStartOfMonth();
        newacc.SAM_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.SAM_Effective_Date__c=d.toStartOfMonth();
        newacc.SS_VSA_Effective_Date__c=d.toStartOfMonth();     
        newacc.SS_VSA_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.SS_PPM_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.SS_PPM_Effective_Date__c=d.toStartOfMonth();
        newacc.SS_MF_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.SS_MF_Effective_Date__c=d.toStartOfMonth();
        newacc.SS_SEC_Effective_Date__c=d.toStartOfMonth();
        newacc.SS_SA_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.SS_SA_Effective_Date__c=d.toStartOfMonth();
        newacc.Reseller_Account_Director_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.GPS_PMFKey__c=tOrgs[0].PMFKey__c;
        newacc.SS_SEC_PMFKey__c=tOrgs[0].PMFKey__c;
        
        newacc.NCV_Quota_Products__c=500.00;
        newacc.NCV_Quota_Services__c=12.00;
        newacc.NCV_Quota_Education__c=120.00;
        newacc.SAP_ID__c='test sid';
        newacc.SAP_ID_Additional__c='test id';
        newacc.Enterprise_Id__c='EA0520';
        newacc.view_acc_record__c=acc1.id;
        insert newacc;
        
        Test.StartTest();
        CA_TAQ_Schedule_Org_TT.isTestVar=true;
        
        CA_TAQ_Schedule_Org_TT.updateTAQAcc_TT();
        CA_TAQ_Schedule_Org_TT.updateStatus( lstta, 'Success','Updated');
        Test.stopTest();
        
    }
    private static testMethod void NHOrgSchedulerTest2(){
        Test.startTest();
        String TestTime = '0 0 0 3 9 ? 2022';
        CA_TAQ_Schedule_Org_TT.isTestVar=true;
        CA_TAQ_Schedule_Org_TT objSch=new CA_TAQ_Schedule_Org_TT();
        
        String jobId = System.schedule('testBasicScheduledApex',
        TestTime, new CA_TAQ_Schedule_Org_TT());

        Test.stopTest();
    }
    
    
} */