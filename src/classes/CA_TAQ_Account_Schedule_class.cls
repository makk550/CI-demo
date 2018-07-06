/** This class contains the code to call the class that execute as part of batch process
*   This class has to be scheduled to run once a day or according to the requirement.
**/

global class CA_TAQ_Account_Schedule_class implements Schedulable{
   
   global void execute(SchedulableContext sc)
   {} 
   /* 
    public static boolean isTestVar=false;

    global void execute(SchedulableContext sc){
 
        
        CA_TAQ_Batch_Accounts_check updAccts = new CA_TAQ_Batch_Accounts_check();

        //set the query to find out the differences
        if(isTestVar==false)
            updAccts.query='Select a.Id,owner.PMFKey__c, (Select Account_Owner_PMF_Key__c,CSA_PMF_key__c,'+
                         +'Enterprise_Id__c,Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,'+
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
                         +'SS_VSA_PMFKey__c,GPS_PMFKey__c,'+
                         +'SAM_PMFKey__c from TAQAccounts__r where (Approval_Status__c=\'Approved\' or Approval_Status__c=\'Migrated\') '+
                         +' and Process_Step__c<>\'Account Release\' and  Process_Step__c<>\'Account Merge\' '+
                         +'),'+
                         +'(Select actm.UserId From '+
                         +'AccountTeamMembers actm where TeamMemberRole like \'TAQ-%\') '+
                         +'From Account a WHERE ('+
                         +'RecordType.Name=\'CA Enterprise Account\' OR '+
                         +'RecordType.Name=\'Reseller/Distributor Account\') AND id in (select View_Acc_Record__c from TAQ_Account__c '+
                         +'where View_Acc_Record__c<>null and  (Approval_Status__c=\'Approved\' or Approval_Status__c=\'Migrated\') '+
                         +' and Process_Step__c<>\'Account Release\' and  Process_Step__c<>\'Account Merge\' )';
                         
        else if(isTestVar==true)
            updAccts.query='Select a.Id,owner.PMFKey__c, (Select Account_Owner_PMF_Key__c,CSA_PMF_key__c,'+
                         +'Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,'+
                         +'SS_PPM_PMFKey__c,SS_SA_PMFKey__c,SS_SEC_PMFKey__c,'+
                         +'SS_VSA_PMFKey__c,GPS_PMFKey__c,'+
                         +'SAM_PMFKey__c from TAQAccounts__r where (Approval_Status__c=\'Approved\' or Approval_Status__c=\'Migrated\') '+
                         +' and Process_Step__c<>\'Account Release\' and  Process_Step__c<>\'Account Merge\' '+
                         +'),'+
                         +'(Select actm.UserId From '+
                         +'AccountTeamMembers actm where TeamMemberRole like \'TAQ-%\') '+
                         +'From Account a WHERE '+
                         +'RecordType.Name=\'CA Enterprise Account\' OR '+
                         +'RecordType.Name=\'Reseller/Distributor Account\' and name=\'idc test batch acc\' limit 1';

    
        system.debug('DBG: QUERY TO BE EXECUTED: '+updAccts.query);
        //set the email to notify the user after the batch job is finished.
        //updAccts.email='jagan.gorre@accenture.com';
        
        //setting the batch size to 25 and start executing
        ID batchprocessid = Database.executeBatch(updAccts,1);

    }
    private static testMethod void CA_TAQ_Account_Schedule_class_test(){
        Test.startTest();
        String TestTime = '0 0 0 3 9 ? 2022';
        CA_TAQ_Account_Schedule_class.isTestVar=true;
        CA_TAQ_Account_Schedule_class objSch=new CA_TAQ_Account_Schedule_class();
        
        String jobId = System.schedule('testBasicScheduledApex',
        TestTime, new CA_TAQ_Account_Schedule_class());

        //CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
        //FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();
    }
    
    private static testMethod void CA_TAQ_Batch_Account_check_test(){
        User[] u=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 9];
        
        CA_TAQ_Trigger_class objta=new CA_TAQ_Trigger_class();
        TAQ_Rules__c ttr=new TAQ_Rules__c();
        ttr.Queue_Name__c='TAQ EMEA Approver';
        ttr.Send_To__c='Requestor';
        ttr.Region__c='EMEA';
        ttr.Area__c='testa';
        ttr.Organization__c='DIRECT';
        ttr.Object_Name__c='TAQ Organization';
        
        insert ttr;
          
        TAQ_Rules__c ttr2=new TAQ_Rules__c();
        ttr2.Queue_Name__c='TAQ EMEA Approver';
        ttr2.Send_To__c='Approver';
        ttr2.Region__c='EMEA';
        ttr2.Area__c='testa';
        ttr2.Organization__c='DIRECT';
        ttr2.Object_Name__c='TAQ Organization';
        insert ttr2;
        
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
        Date d = date.today();
        TAQ_Cost_Center__c cc=new TAQ_Cost_Center__c(name='test cost');
        cc.Cost_Center_Number__c='test num';
        cc.Region__c='test';
        insert cc;
        
        TAQ_Job_Info__c job=new TAQ_Job_Info__c(name='test job');
        job.Job_Code__c='test';
        job.Region__c='test';
        insert job;
        
        TAQ_Currency_Conversion__c cur=new TAQ_Currency_Conversion__c(name='test currency');
        cur.Currency_conversion_Rate__c=25.0;
        insert cur;
        
        TAQ_Organization__c ta =new TAQ_Organization__c();
        ta.Employee_Name__c='test,user';
        ta.Process_Step__c='Employee Change';
        ta.Cost_Center_Desc__c=cc.id;
        ta.JobTitle__c=job.id;
        ta.IC_Currency__c=cur.id;
        ta.Manager_Name__c='test,mgr';
        ta.Manager_PMF_Key__c=u[1].PMFKey__c;
        ta.PMFKey__c=u[0].PMFKey__c;
        ta.Position_Id__c='testbatchpos1';
        ta.Role_Effective_Date__c=d.toStartOfMonth();
        ta.Role__c='AD/AM';
        ta.Organization__c='DIRECT';
        ta.Market__c='test';
        ta.Region__c='EMEA';
        ta.Area__c='testa';
        ta.Territory__c='nordics';
        ta.Country__c='United States';
        ta.Plan_Type__c='test';
        ta.Distribute_Plan__c='NO';
        ta.Plan_Type__c='LOA';
        ta.ownerid=userinfo.getuserid();
        
        ta.Cost_Center_Desc_For_Data_Load__c='test cost';
        ta.Job_Title_For_Data_Load__c='test job';
        ta.Quota_Currency_For_Data_Load__c='test currency';
        ta.IC_Currency_For_Data_Load__c='test currency';
        
        ta.Organization_for_Data_Load__c='DIRECT';
        ta.Area_for_Data_Load__c='testa';
        ta.Territory_For_Data_Load__c='nordics';
        ta.Country_for_Data_Load__c='United States';
        ta.Market_for_Data_Load__c='test';
        ta.Approval_Process_Status__c='Migrated';
        ta.Employee_Status__c='Active';
        ta.Position_ID_Status__c='Active';
        insert ta;
        
         
        User[] u1=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 10];
        List<User> lu=new List<User>();
        for(Integer i=0;i<u1.size();i++){
            if(u1[i].AE_SE_PMFKey__c==null){
                u1[i].AE_SE_PMFKey__c='itstpmf';
                lu.add(u1[i]);
            }    
        }
        if(lu.size()>0) update lu;
        User testusr=[select PMFKey__c from User where isActive=true limit 1];
        testusr.PMFKey__c='itstpmf';
        update testusr;
          
//        /** TAQ Account Related Testing
     
          
        // create a test account 1st
        Id recid=[select id from RecordType where name='CA Enterprise Account' limit 1].id;
        Account acc1 = new Account();
        acc1.Name = 'idc test batch acc';
        acc1.BillingState = 'NY';
        acc1.recordTypeid=recid;
        insert acc1;
       
        AccountTeamMember Teammemberad=new AccountTeamMember();
        Teammemberad.AccountId=acc1.id;
        Teammemberad.UserId=u[1].id;
        Teammemberad.TeamMemberRole = 'TAQ-SS_PPM';
        insert Teammemberad;
       
        List<TAQ_Organization__c> tOrgs = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 10];
        TAQ_Account__c newacc5=new TAQ_Account__c();
            
        newacc5.name='test batch acc';
        newacc5.View_Acc_Record__c=acc1.id;
        newacc5.Enterprise_Id__c='EA0520';
        newacc5.Enterprise_Account_Name__c='idc test acc';
        newacc5.Market__c='testm';
        newacc5.Region__c='EMEA';
        newacc5.Area__c='testa';
        newacc5.Territory__c='testt';
        newacc5.Country__c='testc';
        newacc5.Account_Type__c='test type';
        newacc5.Account_Class__c='Class 4';
            
        newacc5.Industry_Vertical__c='test ind';
        newacc5.Stock_Ticker__c='test tick';
        newacc5.Comments__c='testcom';
            
        newacc5.Top_100_A_C_Y_N__c='Y';
                
        newacc5.Account_Owner_PMF_Key__c= tOrgs[0].PMFKey__c;
            
        newacc5.Account_Owner_Effective_Date__c = d.toStartOfMonth();
        newacc5.Sales_Director_PMF_Key__c= tOrgs[1].PMFKey__c;
            
        newacc5.SM_Effective_Date__c= d.toStartOfMonth();
    
        newacc5.Regional_Alliance_Director_PMF_Key__c=tOrgs[2].PMFKey__c;
        newacc5.Regional_Alliance_Director_Eff_Date__c=d.toStartOfMonth();
    
        newacc5.CSA_PMF_key__c=tOrgs[3].PMFKey__c;
            
        system.debug('start of the day isssss  '+d.toStartOfMonth());
        newacc5.CSA_Effective_Date__c=d.toStartOfMonth();
            
        newacc5.SAM_PMFKey__c=tOrgs[4].PMFKey__c;
        newacc5.SAM_Effective_Date__c=d.toStartOfMonth();
                
        newacc5.SS_VSA_Effective_Date__c=d.toStartOfMonth();     
        newacc5.SS_VSA_PMFKey__c=tOrgs[5].PMFKey__c;
        newacc5.SS_PPM_PMFKey__c=tOrgs[6].PMFKey__c;
        newacc5.SS_PPM_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_MF_PMFKey__c=tOrgs[7].PMFKey__c;
        newacc5.SS_MF_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_SEC_PMFKey__c=tOrgs[8].PMFKey__c;
        newacc5.SS_SEC_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_SA_PMFKey__c=tOrgs[8].PMFKey__c;
        newacc5.SS_SA_Effective_Date__c=d.toStartOfMonth();
        newacc5.GPS_PMFKey__c=tOrgs[9].PMFKey__c;
        newacc5.GPS_Effective_Date__c=d.toStartOfMonth();
        newacc5.NCV_Quota_Products__c=500.00;
        newacc5.NCV_Quota_Services__c=12.00;
        newacc5.NCV_Quota_Education__c=120.00;
        
        newacc5.SAP_ID__c='test sid';
        newacc5.SAP_ID_Additional__c='test id';
            
        newacc5.Area_for_Data_Load__c='testa';
        newacc5.Territory_For_Data_Load__c='nordics';
        newacc5.Country_for_Data_Load__c='United States';
        newacc5.Market_for_Data_Load__c='test';
        newacc5.Approval_Process_Status__c='Approved';
        newacc5.Approval_Status__c='Approved';    
        insert newacc5;
            
        Test.StartTest();
        CA_TAQ_Batch_Accounts_check updAccts = new CA_TAQ_Batch_Accounts_check();

        //set the query to find out the differences
        updAccts.query='Select a.Id,owner.PMFKey__c, (Select Account_Owner_PMF_Key__c,CSA_PMF_key__c,'+
                         +'Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,'+
                         +'SS_PPM_PMFKey__c,SS_SA_PMFKey__c,SS_SEC_PMFKey__c,'+
                         +'SS_VSA_PMFKey__c,GPS_PMFKey__c,'+
                         +'SAM_PMFKey__c from TAQAccounts__r where Approval_Status__c=\'Approved\''+
                         +' and Process_Step__c<>\'Account Release\' and  Process_Step__c<>\'Account Merge\' '+
                         +'),'+
                         +'(Select actm.UserId From '+
                         +'AccountTeamMembers actm where TeamMemberRole like \'TAQ-%\') '+
                         +'From Account a WHERE ('+
                         +'RecordType.Name=\'CA Enterprise Account\' OR '+
                         +'RecordType.Name=\'Reseller/Distributor Account\') and name=\'idc test batch acc\' limit 1';

        //set the email to notify the user after the batch job is finished.
        updAccts.email='jagan.gorre@accenture.com';
        
        //setting the batch size to 25 and start executing
        ID batchprocessid = Database.executeBatch(updAccts,1);
        Test.stopTest();
    }
    
    private static testMethod void CA_TAQ_Batch_Account_check_test2(){
    
        User[] u=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 9];
        CA_TAQ_Trigger_class objta=new CA_TAQ_Trigger_class();
        TAQ_Rules__c ttr=new TAQ_Rules__c();
        ttr.Queue_Name__c='TAQ EMEA Approver';
        ttr.Send_To__c='Requestor';
        ttr.Region__c='EMEA';
        ttr.Area__c='testa';
        ttr.Organization__c='DIRECT';
        ttr.Object_Name__c='TAQ Organization';
        
        insert ttr;
          
        TAQ_Rules__c ttr2=new TAQ_Rules__c();
        ttr2.Queue_Name__c='TAQ EMEA Approver';
        ttr2.Send_To__c='Approver';
        ttr2.Region__c='EMEA';
        ttr2.Area__c='testa';
        ttr2.Organization__c='DIRECT';
        ttr2.Object_Name__c='TAQ Organization';
        insert ttr2;
        
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
        
        TAQ_Cost_Center__c cc=new TAQ_Cost_Center__c(name='test cost');
        cc.Cost_Center_Number__c='test num';
        cc.Region__c='test';
        insert cc;
        
        TAQ_Job_Info__c job=new TAQ_Job_Info__c(name='test job');
        job.Job_Code__c='test';
        job.Region__c='test';
        insert job;
        
        TAQ_Currency_Conversion__c cur=new TAQ_Currency_Conversion__c(name='test currency');
        cur.Currency_conversion_Rate__c=25.0;
        insert cur;
        Date d = date.today();
        TAQ_Organization__c ta =new TAQ_Organization__c();
        ta.Employee_Name__c='test,user';
        ta.Process_Step__c='Employee Change';
        ta.Cost_Center_Desc__c=cc.id;
        ta.JobTitle__c=job.id;
        ta.IC_Currency__c=cur.id;
        ta.Manager_Name__c='test,mgr';
        ta.Manager_PMF_Key__c=u[1].PMFKey__c;
        ta.PMFKey__c=u[0].PMFKey__c;
        ta.Position_Id__c='testbatchpos1';
        ta.Role_Effective_Date__c=d.toStartOfMonth();
        ta.Role__c='AD/AM';
        ta.Organization__c='DIRECT';
        ta.Market__c='test';
        ta.Region__c='EMEA';
        ta.Area__c='testa';
        ta.Territory__c='nordics';
        ta.Country__c='United States';
        ta.Plan_Type__c='test';
        ta.Distribute_Plan__c='NO';
        ta.Plan_Type__c='LOA';
        ta.ownerid=userinfo.getuserid();
        
        ta.Cost_Center_Desc_For_Data_Load__c='test cost';
        ta.Job_Title_For_Data_Load__c='test job';
        ta.Quota_Currency_For_Data_Load__c='test currency';
        ta.IC_Currency_For_Data_Load__c='test currency';
        
        ta.Organization_for_Data_Load__c='DIRECT';
        ta.Area_for_Data_Load__c='testa';
        ta.Territory_For_Data_Load__c='nordics';
        ta.Country_for_Data_Load__c='United States';
        ta.Market_for_Data_Load__c='test';
        ta.Approval_Process_Status__c='Migrated';
        ta.Employee_Status__c='Active';
        ta.Position_ID_Status__c='Active';
        insert ta;
        
         
        User[] u1=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 10];
        List<User> lu=new List<User>();
        for(Integer i=0;i<u1.size();i++){
            if(u1[i].AE_SE_PMFKey__c==null){
                u1[i].AE_SE_PMFKey__c='itstpmf';
                lu.add(u1[i]);
            }    
        }
        if(lu.size()>0) update lu;
        User testusr=[select PMFKey__c from User where isActive=true limit 1];
        testusr.PMFKey__c='itstpmf';
        update testusr;
          
        ///** TAQ Account Related Testing
     
          
        // create a test account 1st
        Id recid=[select id from RecordType where name='CA Enterprise Account' limit 1].id;
        Account acc1 = new Account();
        acc1.Name = 'idc test batch acc';
        acc1.BillingState = 'NY';
        acc1.recordTypeid=recid;
        insert acc1;
       
        AccountTeamMember Teammemberad=new AccountTeamMember();
        Teammemberad.AccountId=acc1.id;
        Teammemberad.UserId=u[1].id;
        Teammemberad.TeamMemberRole = 'TAQ-SS_PPM';
        insert Teammemberad;
       

        List<TAQ_Organization__c> tOrgs = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 10];
        TAQ_Account__c newacc5=new TAQ_Account__c();
            
        newacc5.name='test batch acc';
        newacc5.View_Acc_Record__c=acc1.id;
        newacc5.Enterprise_Id__c='EA0520';
        newacc5.Enterprise_Account_Name__c='idc test acc';
        newacc5.Market__c='testm';
        newacc5.Region__c='EMEA';
        newacc5.Area__c='testa';
        newacc5.Territory__c='testt';
        newacc5.Country__c='testc';
        newacc5.Account_Type__c='test type';
        newacc5.Account_Class__c='Class 4';
            
        newacc5.Industry_Vertical__c='test ind';
        newacc5.Stock_Ticker__c='test tick';
        newacc5.Comments__c='testcom';
            
        newacc5.Top_100_A_C_Y_N__c='Y';
                
        newacc5.Account_Owner_Effective_Date__c = d.toStartOfMonth();
        newacc5.SM_Effective_Date__c= d.toStartOfMonth();
        newacc5.CSA_Effective_Date__c=d.toStartOfMonth();
        newacc5.SAM_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_VSA_Effective_Date__c=d.toStartOfMonth();     
        newacc5.SS_PPM_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_MF_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_SEC_Effective_Date__c=d.toStartOfMonth();
        newacc5.SS_SA_Effective_Date__c=d.toStartOfMonth();
        newacc5.GPS_Effective_Date__c=d.toStartOfMonth();
        
        newacc5.NCV_Quota_Products__c=500.00;
        newacc5.NCV_Quota_Services__c=12.00;
        newacc5.NCV_Quota_Education__c=120.00;
        
        newacc5.SAP_ID__c='test sid';
        newacc5.SAP_ID_Additional__c='test id';
            
        newacc5.Area_for_Data_Load__c='testa';
        newacc5.Territory_For_Data_Load__c='nordics';
        newacc5.Country_for_Data_Load__c='United States';
        newacc5.Market_for_Data_Load__c='test';
        newacc5.Approval_Process_Status__c='Approved';
        newacc5.Approval_Status__c='Approved';    
        
        newacc5.Account_Owner_PMF_Key__c= tOrgs[0].PMFKey__c;
        newacc5.Sales_Director_PMF_Key__c= tOrgs[1].PMFKey__c;
        newacc5.CSA_PMF_key__c=tOrgs[2].PMFKey__c;
        newacc5.SAM_PMFKey__c=tOrgs[3].PMFKey__c;
        newacc5.SS_VSA_PMFKey__c=tOrgs[4].PMFKey__c;
        newacc5.SS_PPM_PMFKey__c=tOrgs[5].PMFKey__c;
        newacc5.SS_MF_PMFKey__c=tOrgs[6].PMFKey__c;
        newacc5.SS_SEC_PMFKey__c=tOrgs[7].PMFKey__c;
        newacc5.SS_SA_PMFKey__c=tOrgs[8].PMFKey__c;
        newacc5.GPS_PMFKey__c=tOrgs[9].PMFKey__c;
        insert newacc5;
        
        Test.StartTest();
        CA_TAQ_Batch_Accounts_check updAccts = new CA_TAQ_Batch_Accounts_check();

        //set the query to find out the differences
        updAccts.query='Select a.Id,owner.PMFKEY__c, (Select Account_Owner_PMF_Key__c,CSA_PMF_key__c,'+
                         +'Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,'+
                         +'SS_PPM_PMFKey__c,SS_SA_PMFKey__c,SS_SEC_PMFKey__c,'+
                         +'SS_VSA_PMFKey__c,GPS_PMFKey__c,'+
                         +'SAM_PMFKey__c from TAQAccounts__r where Approval_Status__c=\'Approved\''+
                         +' and Process_Step__c<>\'Account Release\' and  Process_Step__c<>\'Account Merge\' '+
                         +'),'+
                         +'(Select actm.UserId From '+
                         +'AccountTeamMembers actm where TeamMemberRole like \'TAQ-%\') '+
                         +'From Account a WHERE ('+
                         +'RecordType.Name=\'CA Enterprise Account\' OR '+
                         +'RecordType.Name=\'Reseller/Distributor Account\') and name=\'idc test batch acc\' limit 1';

        //set the email to notify the user after the batch job is finished.
        updAccts.email='jagan.gorre@accenture.com';
        
        //setting the batch size to 25 and start executing
        ID batchprocessid = Database.executeBatch(updAccts,1);
        Test.stopTest();
    }
*/

}