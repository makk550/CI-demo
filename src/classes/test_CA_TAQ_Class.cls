/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
**/
 
@istest(seeAllData=true)
private class test_CA_TAQ_Class{
    
    /*
     static testMethod void myUnitTest1() {
        CA_TAQ_Trigger_class objta=new CA_TAQ_Trigger_class();
       
        
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
        ta.Position_Id__c='testpos1';
        ta.Role__c='AD/AM';
        ta.Organization__c='DIRECT';
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
        ta.IC_Currency_For_Data_Load__c='test currency';
        
        ta.Organization_for_Data_Load__c='DIRECT';
        ta.Area_for_Data_Load__c='testa';
        ta.Territory_For_Data_Load__c='nordics';
        ta.Country_for_Data_Load__c='United States';
        ta.Approval_Process_Status__c='Migrated';
        ta.Employee_Status__c='Active';
        ta.Position_ID_Status__c='Active';
        insert ta;


        TAQ_Organization__c ta2 =new TAQ_Organization__c();
        ta2.Process_Step__c='';
        ta2.Cost_Center_Desc__c=cc.id;
        ta2.JobTitle__c=job.id;
        ta2.IC_Currency__c=cur.id;
        ta2.Manager_Name__c='test,mgr';
        ta2.Manager_PMF_Key__c=ta.PMFKey__c;
        ta2.PMFKey__c=ta.Manager_PMF_Key__c;
        ta2.Position_Id__c='testpos2';
        ta2.Role__c='AD/AM';
        ta2.Organization__c='DIRECT';
        
        ta2.Region__c='EMEA';
        ta2.Organization__c='DIRECT';
        ta2.Area__c='testa';
        ta2.Territory__c='nordics';
        ta2.Country__c='United States';
        ta2.Plan_Type__c='test';
        ta2.Distribute_Plan__c='NO';
        ta2.Plan_Type__c='LOA';
        ta2.ownerid=userinfo.getuserid();
        ta2.Employee_Status__c='Active';
        ta2.Position_ID_Status__c='Active';
        insert ta2;

        TAQ_Organization__c ta3 =new TAQ_Organization__c();
        ta3.Process_Step__c='';
        ta3.Cost_Center_Desc__c=cc.id;
        ta3.JobTitle__c=job.id;
        ta3.IC_Currency__c=cur.id;
        ta3.Manager_Name__c='test,mgr';
        ta3.Manager_PMF_Key__c=ta.Position_Id__c;
        ta3.PMFKey__c=ta.PMFKey__c;
        ta3.Position_Id__c='testpos1';
        ta3.Role__c='AD/AM';
        ta3.Organization__c='DIRECT';
       
        ta3.Region__c='EMEA';
        ta3.Area__c='testa';
        ta3.Territory__c='nordics';
        ta3.Country__c='United States';
        ta3.Plan_Type__c='test';
        ta3.Distribute_Plan__c='NO';
        ta3.Plan_Type__c='LOA';
        ta3.Employee_Status__c='Active';
        ta3.Position_ID_Status__c='Active';
        
        insert ta3;
    
        ta.Approval_Process_Status__c='Approved';
        ta.Process_Step__c='New Hire';
        ta.PMFKey__c='test2 pmf';
        ta.Is_Terminated__c=true;
        ta.Employee_Status_Date__c=d.toStartOfMonth();
        ta.Employee_Status__c='Open';
        ta.IC_Amount__c=25.00;
        ta.Manager_Effective_Date__c=d.toStartOfMonth();
        ta.PlanType_Effective_Date__c=d.toStartOfMonth();
        ta.Position_ID_Status__c='Open';
        ta.Distribute_Plan__c=null;
        update ta;
   
    }
    
    */
    
   
     
    static testMethod void myUnitTest2() {
    
        List<TAQ_Organization__c> tOrgs = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 19];
        //User[] u=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 9];
        TAQ_Organization_Approved__c tAppr = [select Id from TAQ_Organization_Approved__c LIMIT 1];
          tAppr.TAQ_Organization__c = tOrgs[0].id;
          tAppr.Is_Latest_Record__c=true;
          update tAppr;
        
        
        Map<id,TAQ_Organization__c> mapRejected = new Map<id,TAQ_Organization__c>();
          mapRejected.put(tOrgs[0].id,tOrgs[0]);
          CA_TAQ_Trigger_class objta=new CA_TAQ_Trigger_class();
          objta.massCopyTAQOrg(mapRejected);
        
          User[] u1=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 19];
          List<User> lu=new List<User>();
          for(Integer i=0;i<u1.size();i++){
              if(u1[i].AE_SE_PMFKey__c==null){
                  u1[i].AE_SE_PMFKey__c='itstpmf';
                  lu.add(u1[i]);
              }    
          }
          //if(lu.size()>0) update lu;
          //User testusr=[select PMFKey__c from User where isActive=true limit 1];
          //testusr.PMFKey__c='itstpmf';
          //update testusr;
          
        Date d = date.today();
        
        /** TAQ Account Related Testing**/
     
          
          // create a test account 1st
            Account acc1 = new Account();
            acc1.Name = 'idc test acc';
            acc1.BillingState = 'NY';
            acc1.BillingStreet='Arlington';
            acc1.BillingCity='NY';
            acc1.BillingCountry='US';
            insert acc1;
       
       TAQ_Account__c newacc5=new TAQ_Account__c();
          try{  
            newacc5.name='test acc';
            newacc5.View_Acc_Record__c=acc1.id;
            newacc5.Enterprise_Id__c='EA0520';
            newacc5.Enterprise_Account_Name__c='idc test acc';
           newacc5.Enterprise_Id__c = '12345';
            newacc5.Region__c='EMEA';
            newacc5.Area__c='testa';
            newacc5.Territory__c='testt';
            newacc5.Country__c='testc';
            newacc5.Account_Type__c='test type';
            newacc5.Industry_Vertical__c='test ind';
            newacc5.Stock_Ticker__c='test tick';
            newacc5.Comments__c='testcom';
            newacc5.Area_for_Data_Load__c='testa';
            newacc5.Territory_For_Data_Load__c='nordics';
            newacc5.Country_for_Data_Load__c='United States';
            newacc5.Approval_Process_Status__c='Migrated';
            
            newacc5.Sell_To_Education__c = 100;
        newacc5.Sell_To_Mainframe_Capacity__c = 100;
        newacc5.Sell_To_Mainframe_Time__c = 100;
        newacc5.Sell_To_Product__c = 100;
        newacc5.Sell_To_Services__c = 100;
        
            
            insert newacc5;
           
            
            TAQ_Account_Approved__c taa = [select id from TAQ_Account_Approved__c limit 1];
            taa.TAQ_Account__c = newacc5.id;
            taa.Is_Latest_Record__c=true;
            taa.Is_Original__c=true;
            update taa;
             List<TAQ_Account__c> taqAccs = new List<TAQ_Account__c>();
            taqAccs.add(newacc5); 
            CA_TAQ_createTAQAccApprRec crt = new CA_TAQ_createTAQAccApprRec();
            crt.createTAQAccApprRec(taqAccs);
            Map<id,TAQ_Account__c> mapAccRejected = new Map<id,TAQ_Account__c>();
            mapAccRejected.put(newacc5.id, newacc5);
            CA_TAQ_Trigger_class objta1=new CA_TAQ_Trigger_class();
            CA_TAQ_Trigger_class.isflagRejected = true;
          objta1.massCopyTAQAcc(mapAccRejected);
            }catch(Exception e){
            
            }
             
            CA_TAQ_AddTeamMem tobj=new CA_TAQ_AddTeamMem();
        tobj.SetMiniLayoutValues(newacc5,newacc5.id);
        
        /* tobj.addMembers(newacc5,acc1);
            tobj.deleteMembers(newacc5,acc1);
            
            CA_TAQ_AddTeamMem.isflag=true;
            CA_TAQ_AddTeamMem.isflag2=true;
            CA_TAQ_AddTeamMem.isflag3=true;
            CA_TAQ_AddTeamMem.isflag4=true;
            try{
              newacc5.Approval_Process_Status__c='Updated';
                update newacc5;
             }catch(Exception e){
             
             }   
                tobj.addMembers(newacc5,acc1);
                 
            CA_TAQ_AddTeamMem.isflag=true;
            CA_TAQ_AddTeamMem.isflag2=true;
            CA_TAQ_AddTeamMem.isflag3=true;
            CA_TAQ_AddTeamMem.isflag4=true;
            */
    }
    
     static testMethod void myUnitTest3() {
     try{
       CA_TAQ_Trigger_class objta=new CA_TAQ_Trigger_class();
       test_TAQ_genericRecCreator.createTAQOrgRec();
       test_TAQ_genericRecCreator.createTAQAccRec();
     }
     catch(Exception e){
       System.debug('Exception' + e);
     }  
         
     }
    static testMethod void myUnitTest_PositionRefTrigger() {
    
       try{
          TAQ_Organization_Approved__c tAppr = [select Id from TAQ_Organization_Approved__c LIMIT 1];
          
          TAQ_Org_Quota_Approved__c obj1 = new TAQ_Org_Quota_Approved__c();
          obj1.TAQ_Organization_Approved__c = tAppr.Id;
          obj1.Name = 'test Org Quota';
          insert obj1;
       }catch(Exception e){
       }
        
        Profile profile = [SELECT id, name FROM Profile limit 1];
        UserRole role = [SELECT id, name FROM UserRole limit 1];
        
        TAQ_REF_Position__c refPos1 = new TAQ_REF_Position__c();
        refPos1.Profile_Name__c = profile.name;
        refPos1.Role_Name__c = role.name;
        refPos1.Name = 'TEST_POSITION1';
        refPos1.Supervisor_Position_Id__c = 'TEST_SUPERVISOR_POSITION1';
        insert refPos1;
        
        TAQ_REF_Position__c refPos2 = new TAQ_REF_Position__c();
        refPos2.Profile_Name__c = 'TEST PROFILE NAME (NOT REAL)';
        refPos2.Role_Name__c = 'TEST ROLE NAME (NOT REAL)';
        refPos2.Name = 'TEST_POSITION1';
        refPos2.Supervisor_Position_Id__c = 'TEST_SUPERVISOR_POSITION1';
        insert refPos2;
     }
   
     
}