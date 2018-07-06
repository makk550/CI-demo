public class CA_TAQ_Acc_New_override {

    private final TAQ_Account__c ta;
    
    public CA_TAQ_Acc_New_override(ApexPages.StandardController controller) {
         this.ta=(TAQ_Account__c)controller.getrecord();
    }

    public pageReference newAcc(){

        //PageReference p=new PageReference('/'+Label.TAQ_Acc_Object_Code+'/e?nooverride=1&saveURL=/'+Label.TAQ_Acc_Object_Code+'/o&retURL=/'+Label.TAQ_Acc_Object_Code+'/o');
        
        PageReference currentp=new PageReference(ApexPages.CurrentPage().getUrl());
        Map<String,String> params = ApexPages.currentPage().getParameters();
        PageReference p=new PageReference('/'+Label.TAQ_Acc_Object_Code+'/e');
        
        // Code modified by Mrudula -jadmr01 for DataEnrichmnet
        p.getParameters().put('RecordType',currentp.getParameters().get('RecordType'));
        p.getParameters().put('nooverride','1');
        p.getParameters().put('saveURL',Label.TAQ_Acc_Object_Code+'/o');
        p.getParameters().put('retURL',Label.TAQ_Acc_Object_Code+'/o');
        p.getParameters().put('Name',params.get('Name'));
        if(params.get('00N30000004yn2P') != null && params.get('00N30000004yn2P')!=''){
         if(!params.get('00N30000004yn2P').equals('null'))
        p.getParameters().put('00N30000004yn2P',params.get('00N30000004yn2P'));
        }
        if(params.get('00N30000004yn2O') != null && params.get('00N30000004yn2O')!=''){
         if(!params.get('00N30000004yn2O').equals('null'))
        p.getParameters().put('00N30000004yn2O',params.get('00N30000004yn2O'));
        }
        if(params.get('00N30000004yn2Q') != null  && params.get('00N30000004yn2Q')!=''){
         if(!params.get('00N30000004yn2Q').equals('null'))
        p.getParameters().put('00N30000004yn2Q',params.get('00N30000004yn2Q'));
        }
        if(params.get('00Na000000Allhc') != null  && params.get('00Na000000Allhc')!=''){
        if(!params.get('00Na000000Allhc').equals('null'))
        p.getParameters().put('00Na000000Allhc',params.get('00Na000000Allhc')); 
        }
        if(params.get('00N30000004yn2M') != null && params.get('00N30000004yn2M')!=''){
         if(!params.get('00N30000004yn2M').equals('null'))
        p.getParameters().put('00N30000004yn2M',params.get('00N30000004yn2M'));   
        }
        if(params.get('00Na000000Allhe') != null && params.get('00Na000000Allhe')!=''){
         if(!params.get('00Na000000Allhe').equals('null'))
        p.getParameters().put('00Na000000Allhe',params.get('00Na000000Allhe'));   
        }
        if(params.get('00N30000004yn1p')!=null)
        p.getParameters().put('00N30000004yn1p',params.get('00N30000004yn1p'));
        if(params.get('00N300000074BLk')!=null)
        p.getParameters().put('00N300000074BLk',params.get('00N300000074BLk'));
        if(params.get('00N30000004yn2b')!=null)
        p.getParameters().put('00N30000004yn2b',params.get('00N30000004yn2b'));
        if(params.get('00N30000004yn1a')!=null)
        p.getParameters().put('00N30000004yn1a',params.get('00N30000004yn1a'));
        if(params.get('00N30000004yn3K')!=null)
        p.getParameters().put('00N30000004yn3K',params.get('00N30000004yn3K'));
        if(params.get('00N30000004yn1k')!=null)
        p.getParameters().put('00N30000004yn1k',params.get('00N30000004yn1k'));
        if(params.get('00N300000074BLj')!=null)
        p.getParameters().put('00N300000074BLj',params.get('00N300000074BLj'));
        if(params.get('00N300000074BLl')!=null)
        p.getParameters().put('00N300000074BLl',params.get('00N300000074BLl'));
        if(params.get('00Na000000Allhg')!=null)
        p.getParameters().put('00Na000000Allhg',params.get('00Na000000Allhg'));
        if(params.get('00Na000000Allhd')!=null)
        p.getParameters().put('00Na000000Allhd',params.get('00Na000000Allhd'));
        
            
       return p;
        
    }
    
    static testMethod void CA_TAQ_Acc_New_override_test(){
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
     // FY13    newacc.Market__c='testm';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Type__c='test type';
     // FY13  newacc.Account_Class__c='Class 4';
        //newacc.Rubric_Class__c='test rub';
        newacc.Industry_Vertical__c='test ind';
        newacc.Stock_Ticker__c='test tick';
        newacc.Comments__c='testcom';
     // FY13   newacc.Top_100_A_C_Y_N__c='Y';
        newacc.ownerid=userinfo.getuserid();    
     //FY13
     /*   newacc.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
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
       newacc.Sell_To_Education__c = 100;
        newacc.Sell_To_Mainframe_Capacity__c = 100;
        newacc.Sell_To_Mainframe_Time__c = 100;
        newacc.Sell_To_Product__c = 100;
        newacc.Sell_To_Services__c = 100;
        
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
        newacc.Approval_Process_Status__c='Approved';
        try{
         update newacc;
         ApexPages.StandardController c=new ApexPages.StandardController(newacc);
         CA_TAQ_Acc_New_override tstovr=new CA_TAQ_Acc_New_override(c); 
         tstovr.newAcc();
        }
        catch(Exception e){
          System.debug('Exception' + e);
        }
     }
}