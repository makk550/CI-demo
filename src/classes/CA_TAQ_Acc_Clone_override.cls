public class CA_TAQ_Acc_Clone_override 
{
private final TAQ_Account__c ta;
    public CA_TAQ_Acc_Clone_override(ApexPages.StandardController controller) {
        this.ta=(TAQ_Account__c)controller.getrecord();
    }
    
     public pageReference editPage(){    
     
         //PageReference p=new PageReference('/'+ta.id+'/e?clone=1&retURL=%2F'+Label.TAQ_Acc_Object_Code+'/o&nooverride=1');    
         
        PageReference currentp=new PageReference(ApexPages.CurrentPage().getUrl());
        
        PageReference p=new PageReference('/'+ta.id+'/e');
        p.getParameters().put('RecordType',currentp.getParameters().get('RecordType'));
        p.getParameters().put('clone','1');
        p.getParameters().put('nooverride','1');
        p.getParameters().put('saveURL',Label.TAQ_Acc_Object_Code+'/o');
        p.getParameters().put('retURL',Label.TAQ_Acc_Object_Code+'/o');
        return p;    
         
     }
    
    static testMethod void CA_TAQ_Acc_Edit_override_test(){
        Date d=system.today();
        PageReference pr = new PageReference('https://cs3.salesforce.com/apex/');
        pr.getParameters().put('RecordType', '01pQ0000000CtIC');
        Test.setCurrentPageReference(pr);
        
        //User[] u=[select id,PMFKey__c from user where isActive=true limit 10];
        List<TAQ_Organization__c> u = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 10];
        TAQ_Account__c newacc=new TAQ_Account__c();
    //    newacc.Approval_Process_Status__c='Approved';
        newacc.name='test acc';
        //newacc.Enterprise_Id__c= 'test id';
        newacc.Enterprise_Account_Name__c='test acc name';
        newacc.Reseller_ID__c='test id';
        newacc.Reseller_Name__c='test res';
    // Commented FY13      newacc.Market__c='testm';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Type__c='test type';
   //Commented FY13     newacc.Account_Class__c='Class 4';
        //newacc.Rubric_Class__c='test rub';
        newacc.Industry_Vertical__c='test ind';
        newacc.Stock_Ticker__c='test tick';
        newacc.Comments__c='testcom';
   //Commented FY13     newacc.Top_100_A_C_Y_N__c='Y';
        newacc.ownerid=userinfo.getuserid();    
   //Commented FY13
   /*
        newacc.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
        //newacc.Account_Owner_Name__c= u[0].id;
        newacc.Account_Owner_Effective_Date__c = d.toStartOfMonth();
        newacc.Sales_Director_PMF_Key__c= u[1].PMFKey__c;
        //newacc.Sales_Director_Name__c= u[1].id;
        newacc.SM_Effective_Date__c= d.toStartOfMonth();

        newacc.CSA_PMF_key__c=u[1].PMFKey__c;
        
        system.debug('start of the day isssss  '+d.toStartOfMonth());
        newacc.CSA_Effective_Date__c=d.toStartOfMonth();
        
        newacc.SAM_PMFKey__c=u[5].PMFKey__c;
        newacc.SAM_Effective_Date__c=d.toStartOfMonth();
            
        newacc.SS_VSA_Effective_Date__c=d.toStartOfMonth();     
        newacc.SS_VSA_PMFKey__c=u[6].PMFKey__c;
        newacc.SS_PPM_PMFKey__c=u[7].PMFKey__c;
        newacc.SS_PPM_Effective_Date__c=d.toStartOfMonth();
        newacc.SS_MF_PMFKey__c=u[8].PMFKey__c;
        newacc.SS_MF_Effective_Date__c=d.toStartOfMonth();

        newacc.SS_SEC_Effective_Date__c=d.toStartOfMonth();
        newacc.SS_SA_PMFKey__c=u[9].PMFKey__c;
        newacc.SS_SA_Effective_Date__c=d.toStartOfMonth();
        newacc.NCV_Quota_Products__c=500.00;
        newacc.NCV_Quota_Services__c=12.00;
        newacc.NCV_Quota_Education__c=120.00;
       // newacc.NCV_Quota_Total__c=150.00;
        newacc.SAP_ID__c='test sid';
        newacc.SAP_ID_Additional__c='test id';
        */
        
        newacc.Enterprise_Id__c='EA0520';
        insert newacc;
        
           TAQ_Account_Team__c t = new TAQ_Account_Team__c();
        t.Is_Account_Owner__c = true;
        t.Percentage__c = 22;
        t.PMFKey__c = 'tadkr01';
        Date d1 = System.today();
        t.Effective_Date__c = d1.toStartOfMonth();
        t.TAQ_Account__c = newacc.Id;
        t.role__c = 'asd';
        t.effective_Date__c= system.today();
        t.primary_secondary__c = 'secondary';
        t.percentage__c = 20;
        insert t;
        newacc.Sell_To_Education__c = 1;
        newacc.Sell_To_Mainframe_Capacity__c = 1;
        newacc.Sell_To_Mainframe_Time__c = 1;
        newacc.Sell_To_Product__c = 1;
        newacc.Sell_To_Services__c = 1;
        try{
          newacc.Approval_Process_Status__c='Approved';       
          update newacc;        
          ApexPages.StandardController c=new ApexPages.StandardController(newacc);
          CA_TAQ_Acc_Clone_override tstovr=new CA_TAQ_Acc_Clone_override(c); 
          tstovr.editPage();
        }
        catch(Exception e){
          System.debug('Exception'+e);
        }
    }
}