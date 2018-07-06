@isTest(SeeAllData=true)
    public class TAQ_OrgActionstest
    {
        public static testmethod void orgActionsTest()
        {
         TAQ_Cost_Center__c cc=new TAQ_Cost_Center__c(name='Dummy',Cost_Center_Number__c='test num',Region__c='test');
         insert cc;
        
        TAQ_Job_Info__c job=new TAQ_Job_Info__c(name='test job',Job_Code__c='test',Region__c='test');
        insert job;
      
        TAQ_Currency_Conversion__c cur=new TAQ_Currency_Conversion__c(name='test currency',Currency_conversion_Rate__c=25.0);
        insert cur;
        
        User[] u=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true and PMFKey__c != null limit 10];
        List<TAQ_Organization__c> taolist = [select PMFKey__c from TAQ_Organization__c where Position_ID_Status__c  =:'Active'];
        
        Map<String, TAQ_Organization__c> mapta = new Map<String, TAQ_Organization__c>();
        for(TAQ_Organization__c ta: taolist)
        mapta.put(ta.PMFKey__c , ta);
        
        Date d = date.today();
        TAQ_Organization__c taqOrg_1 =new TAQ_Organization__c( Process_Step__c='Open Headcount',Cost_Center_Desc__c=cc.id,JobTitle__c=job.id,IC_Currency__c=cur.id,
        Manager_Name__c='test,mgr',Manager_PMF_Key__c=u[1].PMFKey__c,Organization__c='DIRECT',Role__c='AD/AM',Region__c='NA',Area__c='testa',Territory__c='nordics',
        Country__c='United States',Distribute_Plan__c='NO',Plan_Type__c='LOA',ownerid=userinfo.getuserid(),Cost_Center_Desc_For_Data_Load__c='test cost',
        Job_Title_For_Data_Load__c='test job',IC_Currency_For_Data_Load__c='test currency',Organization_for_Data_Load__c='DIRECT',Area_for_Data_Load__c='testa',Territory_For_Data_Load__c='nordics',
        Country_for_Data_Load__c='United States',PlanType_Effective_Date__c = System.today().toStartOfMonth(),position_id__c = 'sss');
        insert taqOrg_1;
        
       TAQ_Organization_Approved__c taqOrgApproved_1 = new TAQ_Organization_Approved__c();
               taqOrgApproved_1.Employee_Name__c = 'test emp';
               taqOrgApproved_1.Is_Latest_Record__c = true ; 
               taqOrgApproved_1.TAQ_Organization__c = taqOrg_1.Id;
               insert taqOrgApproved_1 ;
       
        TAQ_Org_Quota__c quota_1 = new TAQ_Org_Quota__c();
        quota_1.TAQ_Organization__c = taqOrg_1.Id;
        quota_1.Region__c = 'NA';
        quota_1.CSU_BU__c = 'DM; MFC';
        quota_1.Territory__c = 'SPO';
        quota_1.Quota_Type__c = 'TMFC';
        quota_1.Plan_Type__c = 'LOA';
        quota_1.Country__c = 'CA - CANADA';
        insert quota_1;
       
               
      TAQ_Organization__c taqOrg_2 =new TAQ_Organization__c(Process_Step__c='Open Headcount',Cost_Center_Desc__c=cc.id,JobTitle__c=job.id,IC_Currency__c=cur.id,
        Manager_Name__c='test,mgr',Manager_PMF_Key__c=u[2].PMFKey__c,Organization__c='DIRECT',Role__c='AD/AM',Region__c='NA',Area__c='testa',Territory__c='nordics',
        Country__c='United States',Distribute_Plan__c='NO',Plan_Type__c='LOA',ownerid=userinfo.getuserid(),Cost_Center_Desc_For_Data_Load__c='test cost',
        Job_Title_For_Data_Load__c='test job',IC_Currency_For_Data_Load__c='test currency',Organization_for_Data_Load__c='DIRECT',Area_for_Data_Load__c='testa',Territory_For_Data_Load__c='nordics',
        Country_for_Data_Load__c='United States',PlanType_Effective_Date__c = System.today().toStartOfMonth(),position_id__c = 'sss');
        insert taqOrg_2;
        
       TAQ_Organization_Approved__c taqOrgApproved_2 = new TAQ_Organization_Approved__c();
               taqOrgApproved_2.Employee_Name__c = 'test emp';
               taqOrgApproved_2.Is_Latest_Record__c = true ; 
               taqOrgApproved_2.TAQ_Organization__c = taqOrg_2.Id;
               insert taqOrgApproved_2 ;
               
      TAQ_Org_Quota__c quota_2 = new TAQ_Org_Quota__c();
        quota_2.TAQ_Organization__c = taqOrg_2.Id;
        quota_2.Region__c = 'NA';
        quota_2.CSU_BU__c = 'DM; MFC';
        quota_2.Territory__c = 'SPO';
        quota_2.Quota_Type__c = 'TMFC';
        quota_2.Plan_Type__c = 'LOA';
        quota_2.Country__c = 'CA - CANADA';
        insert quota_2;
               
          TAQ_Organization__c taqOrg_3 =new TAQ_Organization__c( Process_Step__c='Open Headcount',Cost_Center_Desc__c=cc.id,JobTitle__c=job.id,IC_Currency__c=cur.id,
        Manager_Name__c='test,mgr',Manager_PMF_Key__c=u[3].PMFKey__c,Organization__c='DIRECT',Role__c='AD/AM',Region__c='NA',Area__c='testa',Territory__c='nordics',
        Country__c='United States',Distribute_Plan__c='NO',Plan_Type__c='LOA',ownerid=userinfo.getuserid(),Cost_Center_Desc_For_Data_Load__c='test cost',
        Job_Title_For_Data_Load__c='test job',IC_Currency_For_Data_Load__c='test currency',Organization_for_Data_Load__c='DIRECT',Area_for_Data_Load__c='testa',Territory_For_Data_Load__c='nordics',
        Country_for_Data_Load__c='United States',PlanType_Effective_Date__c = System.today().toStartOfMonth(),position_id__c = 'sss');
        insert taqOrg_3;
        
       TAQ_Organization_Approved__c taqOrgApproved_3 = new TAQ_Organization_Approved__c();
               taqOrgApproved_3.Employee_Name__c = 'test emp';
               taqOrgApproved_3.Is_Latest_Record__c = true ; 
               taqOrgApproved_3.TAQ_Organization__c = taqOrg_3.Id;
               insert taqOrgApproved_3 ;
               
        TAQ_Org_Quota__c quota_3 = new TAQ_Org_Quota__c();
        quota_3.TAQ_Organization__c = taqOrg_3.Id;
        quota_3.Region__c = 'NA';
        quota_3.CSU_BU__c = 'DM; MFC';
        quota_3.Territory__c = 'SPO';
        quota_3.Quota_Type__c = 'TMFC';
        quota_3.Plan_Type__c = 'LOA';
        quota_3.Country__c = 'CA - CANADA';
        insert quota_3;
        
        if(mapta.get(u[6].PMFKey__c)==null)
        {
        taqOrg_1.Process_Step__c='New Hire';
        taqOrg_1.Employee_Name__c ='test, Emp';
        taqOrg_1.PMFKey__c = u[6].PMFKey__c;
        taqOrg_1.Position_ID_Status__c = 'Active';
        taqOrg_1.Employee_Status__c ='Active';
        taqOrg_1.Employee_Status_Date__c = System.today().toStartOfMonth();
        update taqOrg_1;
        }
        
        else
        {
        taqOrg_1.Process_Step__c='New Hire';
        taqOrg_1.Employee_Name__c ='test, Emp';
        taqOrg_1.PMFKey__c = 'GODVA01';
        taqOrg_1.Position_ID_Status__c = 'Active';
        taqOrg_1.Employee_Status__c ='Active';
        taqOrg_1.Employee_Status_Date__c = System.today().toStartOfMonth();
        update taqOrg_1;
        }
        
        taqOrg_1.Process_Step__c='Employee Change';
        update taqOrg_1;
        
        if(mapta.get(u[4].PMFKey__c)==null)
        {
         taqOrg_2.Process_Step__c='New Hire';
         taqOrg_2.Employee_Name__c ='test, Emp';
         taqOrg_2.PMFKey__c = u[4].PMFKey__c;
         taqOrg_2.Position_ID_Status__c = 'Active';
         taqOrg_2.Employee_Status_Date__c = System.today().toStartOfMonth();
         update taqOrg_2;
         }
         
         else{
         taqOrg_2.Process_Step__c='New Hire';
         taqOrg_2.Employee_Name__c ='test, Emp';
         taqOrg_2.PMFKey__c = 'GOENE02';
         taqOrg_2.Position_ID_Status__c = 'Active';
         taqOrg_2.Employee_Status_Date__c = System.today().toStartOfMonth();
         update taqOrg_2;
         }
         
        if(mapta.get(u[5].PMFKey__c)==null)
        {
         taqOrg_3.Process_Step__c='Term / Transfer';
         taqOrg_3.Employee_Status__c='Transfer-within';
         taqOrg_3.Employee_Name__c ='test, Emp';
         taqOrg_3.PMFKey__c = u[5].PMFKey__c;
         taqOrg_3.Position_ID_Status__c = 'Active';
         taqOrg_3.Employee_Status_Date__c = System.today().toStartOfMonth();
         update taqOrg_3;
         
         }
         
         else{
         taqOrg_3.Process_Step__c='Term / Transfer';
         taqOrg_3.Employee_Status__c='Transfer-within';
         taqOrg_3.Employee_Name__c ='test, Emp';
         taqOrg_3.PMFKey__c = 'YEDRA01';
         taqOrg_3.Position_ID_Status__c = 'Active';
         taqOrg_3.Employee_Status_Date__c = System.today().toStartOfMonth();
         update taqOrg_3;
         }
         
         TAQ_OrgActions sample = new TAQ_OrgActions();
         List<TAQ_Organization__c> temp = new List<TAQ_Organization__c>();
         temp.add(taqOrg_1);
         temp.add(taqOrg_2);
         temp.add(taqOrg_3);
         
         Test.startTest();
         sample.commitActions(temp);
         sample.copyOrgRecords(temp);    
         Test.stopTest();
        
        }
    }