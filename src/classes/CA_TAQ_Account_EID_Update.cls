public class CA_TAQ_Account_EID_Update {
/*FY 13
    private final TAQ_Account__c ta;
    
    public CA_TAQ_Account_EID_Update(ApexPages.StandardController controller) {
        this.ta=(TAQ_Account__c)controller.getrecord();
    }
    
    public pageReference generateEid(){
        String eid;
        String EnterpriseId;
        if(ta.Region__c=='EMEA')
            eid='EM';
        else if(ta.Region__c=='NA')
            eid='NA';
        else if(ta.Region__c=='LA')
            eid='LA';
        else if(ta.Region__c=='APJ')
            eid='AP';    
        
        try{     
            Account[] a=[Select Enterprise_ID__c from Account where Enterprise_ID__c like :eid+'%' order by Enterprise_ID__c desc limit 1];
            
            system.debug('last available id is '+a[0].Enterprise_ID__c);
            String eno=a[0].Enterprise_ID__c;
            
            Integer no=integer.valueof(eno.substring(2,eno.length()));       
            no=++no;
            String n=''+no;
            
            if(n.length()==5)
                EnterpriseId=eid+''+no;
            else if(n.length()==4)    
                EnterpriseId=eid+'0'+no;
            else if(n.length()==3)    
                EnterpriseId=eid+'00'+no;
            else if(n.length()==2)    
                EnterpriseId=eid+'000'+no;
            else if(n.length()==1)    
                EnterpriseId=eid+'0000'+no;
            else
                EnterpriseId=eid+''+no;
        
            if(ta.Enterprise_Id__c==null){
                ta.Enterprise_Id__c=EnterpriseId;
                update ta;
                   
            }
            
            PageReference p=new PageReference('/'+ta.id);
            return p;
        }
        catch(Exception e){
            system.debug('Exception : '+e);
            PageReference p=new PageReference('/'+ta.id);
            return p;
        }
    }
    static testMethod void CA_TAQ_Account_EID_Update_test(){  
        List<TAQ_Organization__c> u = [select PMFKey__c from TAQ_Organization__c where PMFKey__c<>null limit 10];
        TAQ_Account__c newacc=new TAQ_Account__c();
        newacc.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
        newacc.Sales_Director_PMF_Key__c= u[1].PMFKey__c;
        newacc.Approval_Process_Status__c='';
        newacc.name='test acc';
        //newacc.Enterprise_Id__c= 'test id';
        newacc.Enterprise_Account_Name__c='test acc name';
        newacc.Market__c='testm';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Class__c='Class 4';
        newacc.Account_Type__c='AAM';
        newacc.NCV_Quota_Products__c=100;
        newacc.NCV_Quota_Services__c=100;
        newacc.NCV_Quota_Education__c=100;
        insert newacc;
        ApexPages.StandardController c=new ApexPages.StandardController(newacc);
        CA_TAQ_Account_EID_Update tst=new CA_TAQ_Account_EID_Update(c);
        tst.generateEid();
        
        TAQ_Account__c newacc2=new TAQ_Account__c();
        newacc2.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
        newacc2.Sales_Director_PMF_Key__c= u[1].PMFKey__c;
        newacc2.Approval_Process_Status__c='';
        newacc2.name='test acc';
        //newacc.Enterprise_Id__c= 'test id';
        newacc2.Enterprise_Account_Name__c='test acc name';
        newacc2.Market__c='testm';
        newacc2.Region__c='testr';
        newacc2.Area__c='testa';
        newacc2.Territory__c='testt';
        newacc2.Country__c='testc';
        newacc2.Account_Class__c='Class 4';
        newacc2.Account_Type__c='AAM';
        newacc2.NCV_Quota_Products__c=100;
        newacc2.NCV_Quota_Services__c=100;
        newacc2.NCV_Quota_Education__c=100;
        insert newacc2;
        ApexPages.StandardController c2=new ApexPages.StandardController(newacc2);
        CA_TAQ_Account_EID_Update tst2=new CA_TAQ_Account_EID_Update(c2);
        tst2.generateEid();
        
        TAQ_Account__c newacc3=new TAQ_Account__c();
        newacc3.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
        newacc3.Sales_Director_PMF_Key__c= u[1].PMFKey__c;
        newacc3.Approval_Process_Status__c='';
        newacc3.name='test acc';
        //newacc.Enterprise_Id__c= 'test id';
        newacc3.Enterprise_Account_Name__c='test acc name';
        newacc3.Market__c='testm';
        newacc3.Region__c='NA';
        newacc3.Area__c='testa';
        newacc3.Territory__c='testt';
        newacc3.Country__c='testc';
        newacc3.Account_Class__c='Class 4';
        newacc3.Account_Type__c='AAM';
        newacc3.NCV_Quota_Products__c=100;
        newacc3.NCV_Quota_Services__c=100;
        newacc3.NCV_Quota_Education__c=100;
        insert newacc3;
        ApexPages.StandardController c3=new ApexPages.StandardController(newacc3);
        CA_TAQ_Account_EID_Update tst3=new CA_TAQ_Account_EID_Update(c3);
        tst3.generateEid();
        
        TAQ_Account__c newacc4=new TAQ_Account__c();
        newacc4.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
        newacc4.Sales_Director_PMF_Key__c= u[1].PMFKey__c;
        newacc4.Approval_Process_Status__c='';
        newacc4.name='test acc';
        //newacc.Enterprise_Id__c= 'test id';
        newacc4.Enterprise_Account_Name__c='test acc name';
        newacc4.Market__c='testm';
        newacc4.Region__c='LA';
        newacc4.Area__c='testa';
        newacc4.Territory__c='testt';
        newacc4.Country__c='testc';
        newacc4.Account_Class__c='Class 4';
        newacc4.Account_Type__c='AAM';
        newacc4.NCV_Quota_Products__c=100;
        newacc4.NCV_Quota_Services__c=100;
        newacc4.NCV_Quota_Education__c=100;
        insert newacc4;
        ApexPages.StandardController c4=new ApexPages.StandardController(newacc4);
        CA_TAQ_Account_EID_Update tst4=new CA_TAQ_Account_EID_Update(c4);
        tst4.generateEid();
    
        TAQ_Account__c newacc5=new TAQ_Account__c();
        newacc5.Account_Owner_PMF_Key__c= u[0].PMFKey__c;
        newacc5.Sales_Director_PMF_Key__c= u[1].PMFKey__c;
        newacc5.Approval_Process_Status__c='';
        newacc5.name='test acc';
        //newacc.Enterprise_Id__c= 'test id';
        newacc5.Enterprise_Account_Name__c='test acc name';
        newacc5.Market__c='testm';
        newacc5.Region__c='APJ';
        newacc5.Area__c='testa';
        newacc5.Territory__c='testt';
        newacc5.Country__c='testc';
        newacc5.Account_Class__c='Class 4';
        newacc5.Account_Type__c='AAM';
        newacc5.NCV_Quota_Products__c=100;
        newacc5.NCV_Quota_Services__c=100;
        newacc5.NCV_Quota_Education__c=100;
        insert newacc5;
        ApexPages.StandardController c5=new ApexPages.StandardController(newacc5);
        CA_TAQ_Account_EID_Update tst5=new CA_TAQ_Account_EID_Update(c5);
        tst5.generateEid();
        
    }
  */
}