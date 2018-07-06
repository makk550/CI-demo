@istest
public class test_TAQ_genericRecCreator{
   public static testMethod void createTAQAccRec() {
  RecordType r = [SELECT name, id, SobjectType FROM RecordType WHERE (SobjectType='TAQ_Account__c' OR SobjectType='Account') AND Name like 'Partner%' LIMIT 1];
         TAQ_Account__c newacc=new TAQ_Account__c();
        newacc.name='test acc';
        newacc.process_step__c='Account Add';
        newacc.Enterprise_Account_Name__c='test acc name';
        newacc.Reseller_ID__c='test id';
        newacc.Reseller_Name__c='test res';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Type__c='test type';
        newacc.Industry_Vertical__c='test ind';
        newacc.Stock_Ticker__c='test tick';
        newacc.Comments__c='testcom';
        newacc.ownerid=userinfo.getuserid();    
        newacc.Sell_To_Education__c = 100;
        newacc.Sell_To_Mainframe_Capacity__c = 100;
        newacc.Sell_To_Mainframe_Time__c = 100;
        newacc.Sell_To_Product__c = 100;
        newacc.Sell_To_Services__c = 100;
        
        
        newacc.Enterprise_Id__c='EA0520';
        insert newacc;
        TAQ_Account_Team__c t = new TAQ_Account_Team__c();
        t.Is_Account_Owner__c = true;
        t.Percentage__c = 22;
        t.PMFKey__c = 'tadkr01';
        Date d1 = System.today();
        t.Effective_Date__c = d1.toStartOfMonth();
        t.TAQ_Account__c = newacc.Id;
        t.primary_secondary__C = 'secondary';
        t.role__c= 'asd';
        insert t;
        newacc.Approval_Process_Status__c='Approved';
       try{ 
        update newacc;
        
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
          
          // create a test account 1st
            Account acc1 = new Account();
            acc1.Name = 'idc test acc';
            acc1.BillingState = 'NY';
            acc1.BillingStreet='Arlington';
            acc1.BillingCity='NY';
            acc1.BillingCountry='US';
            insert acc1;
            
            Account acc2 = new Account();
            acc2.Name = 'test acc';
            acc2.BillingState = 'NY';
            acc2.BillingStreet='Arlington';
            acc2.BillingCity='NY';
            acc2.BillingCountry='US';
            insert acc2;
           }
          catch(Exception e){
           System.debug('Exception' + e);
          }
   }
   public static testMethod void createTAQOrgRec(){
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
        
        User[] u=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 9];
        
        
        Date d = date.today();
        TAQ_Organization__c ta =new TAQ_Organization__c();
        ta.Process_Step__c='Open Headcount';
        ta.Cost_Center_Desc__c=cc.id;
        ta.JobTitle__c=job.id;
        ta.IC_Currency__c=cur.id;
        ta.Manager_Name__c='test,mgr';
        ta.Manager_PMF_Key__c=u[1].PMFKey__c;
        ta.Role__c='AD/AM';
        ta.Organization__c='DIRECT';
        ta.Region__c='NA';
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
        ta.PlanType_Effective_Date__c = System.today().toStartOfMonth();
        ta.position_id__c = 'sss';
        insert ta;
        overlay_codes__c ovc = new Overlay_Codes__c();
            ovc.name = 'test ovc';
            ovc.quota_bu__c = 'DM; MFC';
            ovc.Quota_Territory_Country__c = 'SPO';
            ovc.Plan_Type__c = 'LOA';
            ovc.Quota_Country__c = 'CA - CANADA';
            ovc.Quota_Type__c = 'TMFC';
       insert ovc;
        TAQ_Org_Quota__c quota = new TAQ_Org_Quota__c();
        quota.TAQ_Organization__c = ta.Id;
        quota.Region__c = 'NA';
        quota.CSU_BU__c = 'DM; MFC';
        quota.Territory__c = 'SPO';
        quota.Quota_Type__c = 'TMFC';
        quota.Plan_Type__c = 'LOA';
        quota.Country__c = null;
        insert quota;
        quota.Country__c = 'CA - CANADA';
        update quota;
          ta.Approval_process_Status__C = 'Approved';
         update ta;
   

    }
}