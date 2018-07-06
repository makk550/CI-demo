public class CA_TAQ_Org_Edit_override {
    
    private final TAQ_Organization__c ta;

    public CA_TAQ_Org_Edit_override(ApexPages.StandardController controller) {
        this.ta=(TAQ_Organization__c)controller.getrecord();
    }
    
    public pageReference editPage(){
        PageReference p=new PageReference('/'+ta.id+'/e?retURL=%2F'+Label.TAQ_Org_Object_Code+'/o&nooverride=1');
        return p;
    }

    static testMethod void CA_TAQ_Org_New_override_test(){  
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
        ttr.Organization__c='DIRECT';
        ttr2.Object_Name__c='TAQ Organization';
        insert ttr2;
        
        CA_TAQ_Trigger_class objta=new CA_TAQ_Trigger_class();
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
        User[] u=[select PMFKey__c from User where isActive=true limit 9];
        TAQ_Organization__c ta =new TAQ_Organization__c();
        ta.Employee_Name__c='test,user';
        ta.Process_Step__c='';
        ta.Cost_Center_Desc__c=cc.id;
        ta.JobTitle__c=job.id;
        ta.IC_Currency__c=cur.id;
        ta.Manager_Name__c='test,mgr';
        ta.Manager_PMF_Key__c=u[1].PMFKey__c;
        ta.PMFKey__c=u[0].PMFKey__c;
        ta.Position_Id__c='testpos1';
  //FY13      ta.Role_Effective_Date__c=d.toStartOfMonth();
        ta.Role__c='AD/AM';
        ta.Organization__c='DIRECT';
        //FY13 ta.Market__c='test';
        ta.Region__c='EMEA';
        ta.Area__c='testa';
        ta.Territory__c='nordics';
        ta.Country__c='United States';
        ta.Plan_Type__c='test';
        ta.Distribute_Plan__c='NO';
        ta.Plan_Type__c='LOA';
        //ta.ownerid=userinfo.getuserid();
        ta.ownerid=u[0].id;
        SystemIdUtility.skipTAQ_Organization = true;
        insert ta;
        ApexPages.StandardController c=new ApexPages.StandardController(ta);
        CA_TAQ_Org_Edit_override tstovr= new CA_TAQ_Org_Edit_override(c);
        tstovr.editPage();
    }
}