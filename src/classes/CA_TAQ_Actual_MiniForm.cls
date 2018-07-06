public class CA_TAQ_Actual_MiniForm {

    String reqTyp=system.currentPageReference().getParameters().get('reqType');
    String eid=system.currentPageReference().getParameters().get('EID');
    String rid=system.currentPageReference().getParameters().get('RID');
    String aid=system.currentPageReference().getParameters().get('AID');
    public boolean isDetailStep{get;set;}
    public boolean isParent{get;set;}
    public boolean isPartner{get;set;}
    public boolean isAccAdd{get;set;}
    public boolean isAccUpdate{get;set;}
    public boolean isAccUpdateForPartner{get;set;}
    public boolean isAccRelease{get;set;}
    public boolean isDisabled{get;set;}
    public boolean isAccReleaseForPartner{get;set;}
    public boolean isAccMerge{get;set;}
    public boolean isAccMergeForPartner{get;set;}
    public boolean isError{get;set;}
    public boolean isAccAddUpdate{get;set;}
    public TAQ_Account__c taqAccount{get;set;}
    /*public List<SelectOption> regionvals;
    public List<SelectOption> marketvals;
    public List<SelectOption> convals;
    public List<SelectOption> tervals;
    public List<SelectOption> areavals;*/
    /*Schema.PicklistEntry SelectedRegion;
    Schema.PicklistEntry SelectedMarket;
    Schema.PicklistEntry SelectedArea;
    Schema.PicklistEntry SelectedCountry;
    Schema.PicklistEntry SelectedTerritory;*/
    public String selOption;
    String err;
    user u;
    Account acc;
    
    public CA_TAQ_Actual_MiniForm(ApexPages.StandardController c) {
        try{ 
            isDetailStep=false; 
            isParent=true;  
            isDisabled=false;          
            taqAccount= new TAQ_Account__c();          
            if(eid<>null){
                isAccAdd=false;
                isAccUpdate=true;
                isAccUpdateForPartner=false;
               
                isError=false;
                isPartner=false;
                isAccAddUpdate=true;                
                 //String id=[select id,Account_Ownership_Change__c,Sales_Director_Name_Change__c from TAQ_Account__c where Enterprise_Id__c=:eid and Is_Primary_Account__c=true limit 1].id;
                taqAccount=[select id,Approval_Status__c,
                //FY13 - Account_Ownership_Change__c,Sales_Director_Name_Change__c,Sales_Director_Name__c,Sales_Director_PMF_Key__c,Market__c,Account_Class__c,
                 Region__c,Territory__c,Area__c,Physical_Street__c,Country__c,Physical_City__c, Partner_Enablement_Addendum_Attached__c,
                 Physical_State_Province__c,URL__c,Physical_Zip_Postal_Code__c,Account_Type__c,Name,Account_Name_Change__c,Enterprise_Account__c
                 from TAQ_Account__c where Enterprise_Id__c=:eid and Is_Primary_Account__c=true and View_Acc_Record__c=:aid limit 1]; 
                 acc=[select ownerid from account where Enterprise_ID__c=:eid and id=:aid limit 1];
             //    system.debug('-------taqAccount-----'+taqAccount);
             /* FY13    if(taqAccount.Sales_Director_PMF_Key__c.length()==7){
                 u=[select id  from user where PMFKey__c =:taqAccount.Sales_Director_PMF_Key__c or name =:taqAccount.Sales_Director_Name__c  limit 1];
                 if(u<>null)
                 taqAccount.Sales_Director_Name_Change__c=u.id; 
                 } */
                 taqAccount.Account_Name_Change__c=taqAccount.name;
               //FY 13-  taqAccount.Account_Ownership_Change__c=acc.ownerid;
                if(taqAccount.Approval_Status__c=='Send For Approval'){
                    err='You cannot update the current Account as it is under the process of Approval.';
                    isError=true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err);
                    ApexPages.addMessage(myMsg);                   
                }                 
            }else if(rid<>null)
                {
                //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-643'
                isAccAdd=false;
                isAccUpdate=true;
                isError=false;
                isAccUpdateForPartner=true;
                isAccReleaseForPartner=true;
                isAccMergeForPartner=true;
               //  system.debug('View_Acc_Record__c'+aid);
                //String id=[select id,Account_Ownership_Change__c,Sales_Director_Name_Change__c from TAQ_Account__c where Enterprise_Id__c=:eid and Is_Primary_Account__c=true limit 1].id;
                taqAccount=[select Id, Approval_Status__c,
                //FY 13- Account_Ownership_Change__c,Sales_Director_Name_Change__c,Sales_Director_Name__c,Sales_Director_PMF_Key__c, Market__c, Account_Class__c,
                Region__c,Territory__c,Area__c,Physical_Street__c,Country__c,Physical_City__c,CPMS_Id__c,
                Physical_State_Province__c,URL__c,Physical_Zip_Postal_Code__c,Program_Level__c,Reseller_Type__c,Eligible_for_MDF__c,PDS_Addendum__c,PDS_Addendum_Attached__c,
                Account_Type__c,Name,Account_Name_Change__c,Website__c,Alliance__c,Solution_Provider__c,
                Service_Provider__c,Velocity_Seller__c,Alliance_Type__c,Solution_Provider_Type__c,Service_Provider_Type__c,Velocity_Seller_Type__c,
                Alliance_CAM_PMFKey__c,Solution_Provider_CAM_PMFKey__c,Service_Provider_CAM_PMFKey__c,Velocity_Seller_CAM_PMFKey__c,
                Alliance_Program_Level__c,Solution_Provider_Program_Level__c,Service_Provider_Program_Level__c,Velocity_Seller_Program_Level__c,Alliance_Designation__c,
                Solution_Provider_Designation__c,Service_Provider_Designation__c,Velocity_Seller_Designation__c,View_Acc_Record__r.Customer_Category__c,Reseller_ID__c
                from TAQ_Account__c where Reseller_ID__c=:rid and View_Acc_Record__c=:aid limit 1]; 
                
           
                
                
                acc=[select ownerid from account where Reseller_Disti_Regional_ID__c=:rid and id=:aid ];
                // u=[select id  from user where PMFKey__c =:taqAccount.Sales_Director_PMF_Key__c];
               // taqAccount.Account_Ownership_Change__c=acc.ownerid;   
              
                // taqAccount.Sales_Director_Name_Change__c=u.id;             
                //if(taqAccount.Account_Name_Change__c=='' || taqAccount.Account_Name_Change__c==null)
                // taqAccount.Account_Name_Change__c=taqAccount.Name;
             //   System.Debug('#######RID is in else----------------'+taqAccount);  
                             
                if(taqAccount.Approval_Status__c=='Send For Approval'){
                    err='You cannot update the current Account as it is under the process of Approval.';
                    isError=true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,err);
                    ApexPages.addMessage(myMsg);                   
                }                  
            }
            //else{
            //Commented by Saba as this was resulting in display of additional none values
               /* taqAccount.Area__c='--None--';
                taqAccount.Territory__c='--None--';
                taqAccount.Region__c='--None--';
                taqAccount.Country__c='--None--';
                taqAccount.Market__c='--None--';
               */ 
           // }            
        }
        catch(Exception e){
            String ex='There is No Corresponding TAQ Account';
            isError=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,ex+e);
            ApexPages.addMessage(myMsg);
        }
    }

    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
             Set<String> profileid=new Set<String>();
             Set<String> recordtypeAccessProfileid=new Set<String>();
             for(TAQ_Miniform_Access__c taq:TAQ_Miniform_Access__c.getAll().values())
                  profileid.add(taq.id__c); 
             for(TAQ_Miniform_RecordTypeAccess__c taq:TAQ_Miniform_RecordTypeAccess__c.getAll().values())
                  recordtypeAccessProfileid.add(taq.id__c); 
        if(taqAccount.Process_Step__c==null){
            if(taqAccount.Approval_Status__c<>'Send For Approval'){        
                    options.add(new SelectOption('Account Update','Account Update'));
                    //Commented as suggested by John Paulik
                    //if(!profileid.contains(UserInfo.getProfileId().substring(0,15))){
                        options.add(new SelectOption('Account Release','Account Release'));
                        options.add(new SelectOption('Account Merge','Account Merge'));
                   //}
                }
        }
        else{ 
                        //added in R2 by Heena to restrict access to Enterprise form for GEM CAM profiles
                   /* if(!recordtypeAccessProfileid.contains(UserInfo.getProfileId().substring(0,15))){              
                        options.add(new SelectOption('Enterprise Account','Enterprise Account'));
                    }*/
                options.add(new SelectOption('Partner Account','Partner Account'));            
        }
        return options;
    }

    public String getSelected(){
        return selOption;
    }
    public void setSelected(String opt){
        this.selOption=opt;        
    }
    /*
     public List<SelectOption> getareavals(){
        if(areavals==null){
         areavals = new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult =  TAQ_Account__c.Area__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         String excludeOption=taqAccount.Area__c;
         if(taqAccount.Area__c!=null)
            areavals.add(new SelectOption(taqAccount.Area__c,taqAccount.Area__c));
         else
            areavals.add(new SelectOption('--None--','--None--'));
         for( Schema.PicklistEntry f : ple){
            if(f.getValue()!=excludeOption)
             areavals.add(new SelectOption(f.getLabel(), f.getValue()));
         } 
     }          
         return areavals;
    
    }
    
    
    public List<SelectOption> gettervals(){
        if(tervals==null){
           tervals = new List<SelectOption>();
             Schema.DescribeFieldResult fieldResult =  TAQ_Account__c.territory__c.getDescribe();
             List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
             String excludeOption=taqAccount.Territory__c;
             if(taqAccount.Territory__c!=null)
                tervals.add(new SelectOption(taqAccount.Territory__c,taqAccount.Territory__c));
             else
                tervals.add(new SelectOption('--None--','--None--'));
             for( Schema.PicklistEntry f : ple){
                if(f.getValue()!=excludeOption)
                 tervals.add(new SelectOption(f.getLabel(), f.getValue()));
             } 
        }              
         return tervals;
    
    }
    
    
    public List<SelectOption> getconvals(){
        if(convals==null){
        convals = new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult =  TAQ_Account__c.Country__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         String excludeOption=taqAccount.Country__c;
         if(taqAccount.Country__c!=null)
            convals.add(new SelectOption(taqAccount.Country__c,taqAccount.Country__c));
         else
            convals.add(new SelectOption('--None--','--None--'));
         for( Schema.PicklistEntry f : ple){
            if(f.getValue()!=excludeOption)
             convals.add(new SelectOption(f.getLabel(), f.getValue()));
         }  
        }             
         return convals;
    
    }
    public List<SelectOption> getmarketvals(){
        if(marketvals==null){
       marketvals = new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult =  TAQ_Account__c.Market__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         String excludeOption=taqAccount.Market__c;
         if(taqAccount.Market__c!=null)
            marketvals.add(new SelectOption(taqAccount.Market__c,taqAccount.Market__c));
         else
            marketvals.add(new SelectOption('--None--','--None--'));
         for( Schema.PicklistEntry f : ple){
            if(f.getValue()!=excludeOption)
             marketvals.add(new SelectOption(f.getLabel(), f.getValue()));
         } 
        }            
         return marketvals;
    
    }
    public List<SelectOption> getregionvals(){
        if(regionvals==null){
         regionvals = new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult =  TAQ_Account__c.Region__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         String excludeOption=taqAccount.Region__c;
         if(taqAccount.Region__c!=null)
            regionvals.add(new SelectOption(taqAccount.Region__c,taqAccount.Region__c));
         else
            regionvals.add(new SelectOption('--None--','--None--'));
         for( Schema.PicklistEntry f : ple){
            if(f.getValue()!=excludeOption)
             regionvals.add(new SelectOption(f.getLabel(), f.getValue()));
         }    
         }              
         return regionvals;
    }
    public void setregionvals(List<SelectOption> options){regionvals=options; }
    public void getmarketvals(List<SelectOption> options){marketvals=options;}
    public void setconvals(List<SelectOption> options){convals=options;}
    public void settervals(List<SelectOption> options){tervals=options;}
    public void setareavals(List<SelectOption> options){areavals=options;}
    */
    //Heena added function for validation of Partner Account Owner PMF Key Defect 47885 in PRM R2
    //Changes by Heena Begin
    private string getEmployeeName(string strPmfKey){
        List<TAQ_Organization__c> lstOrgs = [select PMFKey__c,Employee_name__c from TAQ_Organization__c where PMFKey__c =:strPmfKey];
       if(lstOrgs.size()>0){
       if(lstOrgs[0].Employee_name__c != null)
        return lstOrgs[0].Employee_name__c;
       else
        return 'error';
       }
       else
        return 'error';         
    }
    //Changes by Heena End
    
    public PageReference saveForm() {
        try{
 system.debug('I am in *******------');
        if(eid==null && rid==null){
                
            /*if(t.Region__c=='--None--' ||t.Area__c=='--None--' || t.Territory__c=='--None--' || t.Market__c=='--None--' || t.Country__c=='--None--' ){
            String er='Please select Region/Area/Territory/Country/Market';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,er);
            ApexPages.addMessage(myMsg);
            return null;
            }*/        
            taqAccount.Is_Change_Request__c=true;
            taqAccount.Process_Step__c='Account Add';            
            if(isParent)
                taqAccount.recordtypeid=[select id from recordtype where name='Enterprise Account' and SobjectType='TAQ_Account__c'].id;
            else 
                taqAccount.recordtypeid=[select id from recordtype where name='Partner Account' and SobjectType='TAQ_Account__c'].id;            
            system.debug('taqAccount.Name*******------'+taqAccount.Name);
               if(taqAccount.Account_Name_Change__c=='' || taqAccount.Account_Name_Change__c==null)
                 taqAccount.Account_Name_Change__c=taqAccount.Name;
                //Heena added validation for Partner Account Owner PMF Key Defect 47885 in PRM R2
                //Changes by Heena Begin
                if(!isParent)
                {
                        String strEmployeeName;
                        if(taqAccount.Reseller_Account_Director_PMFKey__c!=null){
                    strEmployeeName = getEmployeeName(taqAccount.Reseller_Account_Director_PMFKey__c);
                    if(strEmployeeName=='error'){
                        String er='No employee exists with the provided PMFKey - ' + taqAccount.Reseller_Account_Director_PMFKey__c + '. Please enter a valid PMFKey.';
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,er);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                    else
                        taqAccount.Reseller_Account_Director_PMFKey__c = taqAccount.Reseller_Account_Director_PMFKey__c.toUpperCase();
                        } 
                }
                //Changes by Heena End
            insert taqAccount;
        }
        else{    
            taqAccount.Is_Change_Request__c=true;
            taqAccount.Process_Step__c=seloption;
         //FY 13
           /* Map<Id,User> userMp=new Map<Id,User>(); 
            Set<Id> stId=new Set<Id>();            
            if(u<>null && taqAccount.Sales_Director_Name_Change__c<>null && taqAccount.Sales_Director_Name_Change__c<>u.id) 
            stId.add(taqAccount.Sales_Director_Name_Change__c);            
            if(taqAccount.Account_Ownership_Change__c<>null && taqAccount.Sales_Director_Name_Change__c<> acc.ownerid)
            stId.add(taqAccount.Account_Ownership_Change__c);            
            system.debug('Ids in the set......'+stId);
            if(stId.size()>0) 
            for(User u:[select id,PMFKey__c from User where id in :stId]){
            userMp.put(u.id,u); 
            system.debug('......u.PMFKey__c......'+u.PMFKey__c);
            }
            */ 
                        
            if(taqAccount.Account_Name_Change__c<>null && taqAccount.name!=taqAccount.Account_Name_Change__c) 
            taqAccount.name=taqAccount.Account_Name_Change__c;            
            
            //FY 13
           /* if(u <> null && taqAccount.Sales_Director_Name_Change__c<>null  && taqAccount.Sales_Director_Name_Change__c<>u.id) 
            taqAccount.Sales_Director_PMF_Key__c=userMp.get(taqAccount.Sales_Director_Name_Change__c).PMFKey__c;            
            if(taqAccount.Account_Ownership_Change__c<>null && taqAccount.Sales_Director_Name_Change__c<> acc.ownerid && eid!=null)
            taqAccount.Account_Owner_PMF_Key__c=userMp.get(taqAccount.Account_Ownership_Change__c).PMFKey__c;            
            */
            System.Debug('EID is ELSE----------------'+taqAccount);
            update taqAccount;
        }
    
    PageReference p=new PageReference('/001/o');
    return p;
    }catch(DmlException ex)
          {
            taqAccount.addError('Error:'+ex.getDmlMessage(0));
            system.debug('Exception '+ex);
            return null;
          }
    catch(Exception e){
        system.debug('Exception :'+e + 'country='+ taqAccount.Country__c+ ' area='+ taqAccount.area__c);
        isDisabled=true;
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,''+e);
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,''+e);
        ApexPages.addMessage(myMsg);        
        return null;
    }
    }
    
   public PageReference nextStep() {
        isDetailStep=true;
        isParent=false;
        isAccAdd=false;
        isPartner=false;
        isAccRelease=false;
        isAccMerge=false;
        isAccUpdate=false;
        isAccAddUpdate=false;
        isAccUpdateForPartner=false;
        //isAccReleaseForEnterprise=false;
        isAccReleaseForPartner=false;
        //isAccMergeForMergeForEnterprise=false;
        isAccMergeForPartner=false;
        System.debug('isDetailStep='+isDetailStep);
        //taqAccount.Process_Step__c=seloption;
        System.debug('seloption='+seloption);
        if(seloption=='Partner Account'){
            isParent=false;
            isAccAdd=true;
            isAccAddUpdate=true;
            isPartner=true;
        }
        else if(seloption=='Enterprise Account'){
            isParent=true;
            isAccAdd=true;
            isAccAddUpdate=true;
            isPartner=false;
        }
        else if(seloption=='Account Update'){
            isAccUpdate=true;
            isAccAddUpdate=true;
            isPartner=false;
            if(rid!=null)
            isAccUpdateForPartner=true;
        }
        else if(seloption=='Account Release'){
            isAccRelease=true;
            isPartner=false;
            if(rid!=null)
            isAccReleaseForPartner=true;
            }
        else if(seloption=='Account Merge'){
            isPartner=false;
            isAccMerge=true;
             if(rid!=null)
            isAccMergeForPartner=true;
        }
            
        System.debug('isParent='+isParent);
        return null;
    }
    public PageReference onLoad() {   
        isDetailStep=false;
        if(reqTyp=='Account Add'){
            isAccAdd=true;
            //isDetailStep=false;
            taqAccount.Process_Step__c=reqTyp;
            taqAccount.Approval_Process_Status__c='Send For Approval';
            //isParent=true;
        }
        else{
            isAccAdd=false;
            //isDetailStep=false;
            isAccUpdate=true;
            isAccUpdateForPartner=true;
            taqAccount.Process_Step__c=null;
            taqAccount.Approval_Process_Status__c='Send For Approval';
        }
        return null;
    }
   
      @isTest
    private static void CA_TAQ_Mini_Form_Select_Class_test() {
     try{
        Date d=system.today();
        TAQ_Rules__c ttr3=new TAQ_Rules__c();
        ttr3.Queue_Name__c='TAQ EMEA Approver';
        ttr3.Send_To__c='Requestor';
        ttr3.Region__c='EMEA';
        ttr3.Area__c='testa';
        ttr3.Organization__c='DIRECT';
        ttr3.Object_Name__c='TAQ Account';
        ttr3.Record_Type_Name__c='Enterprise Account';
        insert ttr3;
        }catch(Exception e){
        }
   /*  try{
        Date d=system.today();
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
        
        TAQ_Rules__c ttr5=new TAQ_Rules__c();
        
        ttr5.Send_To__c='Approver';
        ttr5.Region__c='EMEA';
        ttr5.Area__c='testa';
        ttr5.Organization__c='DIRECT';
        ttr5.Object_Name__c='TAQ Account';
        insert ttr5;
        
          User[] u=[select id,Name,PMFKey__c from user where isActive=true AND PMFKey__c<> NULL limit 9];
          TAQ_Organization__c[] lstOrgs = [select PMFKey__c,Name,Employee_name__c from TAQ_Organization__c where PMFKey__c <> NULL limit 2];
            TAQ_Organization__c u1= lstOrgs[0];
          Account acc1 = new Account();
           acc1.Name = 'idc test acc';
           acc1.BillingState = 'NY';
           acc1.Enterprise_Id__c = 'AP02400';
           acc1.ownerid = userinfo.getuserid();
         
         insert acc1;
         
        TAQ_Account__c newacc=new TAQ_Account__c();
   //     newacc.Approval_Process_Status__c='Approved';
        newacc.name='test acc';
        newacc.Enterprise_Account_Name__c='test acc name';
       // newacc.Reseller_ID__c='test id';
        newacc.Reseller_Name__c='test res';
       //FY 13 - newacc.Market__c='testm';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Type__c='test type';
      //FY 13 -  newacc.Account_Class__c='Class 4';
       
        newacc.Industry_Vertical__c='test ind';
        newacc.Stock_Ticker__c='test tick';
        newacc.Comments__c='testcom';
   //FY13-    newacc.Top_100_A_C_Y_N__c='Y';
        newacc.ownerid=userinfo.getuserid();    
     /* //FY 13
        newacc.Account_Owner_PMF_Key__c= 'morle04';//u[0].pmfkey__c;
        newacc.Account_Owner_Effective_Date__c = d.toStartOfMonth();
        newacc.Sales_Director_PMF_Key__c= u1.pmfkey__c;
        newacc.SM_Effective_Date__c= d.toStartOfMonth();
        newacc.Sales_Director_Name__c = u1.Employee_name__c ;
         
        newacc.NCV_Quota_Products__c=500.00;
        newacc.NCV_Quota_Services__c=12.00;
        newacc.NCV_Quota_Education__c=120.00;
        newacc.SAP_ID__c='test sid';
        newacc.SAP_ID_Additional__c='test id';
      * /
        
        newacc.Account_Name_Change__c='test acc1';
      /*FY 13 
        newacc.Sales_Director_Name_Change__c=u[1].id;
        newacc.Account_Ownership_Change__c=u[0].id;
        newacc.Account_Class_Change__c='test ac';
        newacc.Area_Change__c='test a'; * /
        
        newacc.Territory_Change__c='test ter';
        newacc.Enterprise_Id__c='AP02400';
        newacc.Approval_Status__c = 'Send For Approval' ;
        newacc.Is_Primary_Account__c=true ;
        newacc.View_Acc_Record__c = acc1.Id ; 
        
        
        
        insert newacc;
        TAQ_Account_Team__c t = new TAQ_Account_Team__c();
        t.Is_Account_Owner__c = true;
        t.Percentage__c = 22;
        t.PMFKey__c = 'tadkr01';
        Date d1 = System.today();
        t.Effective_Date__c = d1.toStartOfMonth();
        t.TAQ_Account__c = newacc.Id;
        insert t;
         newacc.Sell_To_Education__c = 1;
        newacc.Sell_To_Mainframe_Capacity__c = 1;
        newacc.Sell_To_Mainframe_Time__c = 1;
        newacc.Sell_To_Product__c = 1;
        newacc.Sell_To_Services__c = 1;
        newacc.Approval_Process_Status__c='Approved';
        
      
        update newacc;        
        ApexPages.StandardController c=new ApexPages.StandardController(newacc);
        CA_TAQ_Actual_MiniForm tse=new CA_TAQ_Actual_MiniForm(c);
        tse.isAccAdd=false;
        tse.isAccUpdate=true;
        tse.isError=false;
        tse.isAccUpdateForPartner=true;
        tse.isAccReleaseForPartner=true;
        tse.isAccMergeForPartner=true;
             
        tse.onLoad();
        tse.taqAccount.Process_Step__c='Account Add';
        tse.getOptions();
        tse.taqAccount.Process_Step__c=null;
        tse.getOptions();
        tse.getSelected();
        tse.setSelected('Account Update');
        tse.nextStep();
        tse.saveForm();
        /*List<SelectOption> temp=tse.gettervals();
        tse.settervals(temp);
        temp=tse.getconvals();
        tse.setconvals(temp);        
        temp=tse.getmarketvals();
        tse.getmarketvals(temp);        
        temp=tse.getregionvals();
        tse.setregionvals(temp);        
        temp=tse.getareavals();
        tse.setareavals(temp);* /
        
        //system.currentPageReference().getParameters().put('reqType','Account Update');
        system.currentPageReference().getParameters().put('EID','NA0101');
        ApexPages.StandardController c1=new ApexPages.StandardController(newacc);
        CA_TAQ_Actual_MiniForm tse1=new CA_TAQ_Actual_MiniForm(c1); 
        tse1.setSelected('Partner Account');    
        tse1.nextStep();   
        tse1.saveForm();
        
        system.currentPageReference().getParameters().put('reqType','Account Add');
        //system.currentPageReference().getParameters().put('EID','TESTING0101');
        ApexPages.StandardController c2=new ApexPages.StandardController(newacc);
        CA_TAQ_Actual_MiniForm tse2=new CA_TAQ_Actual_MiniForm(c2);
        tse2.onLoad();
        tse1.setSelected('Account Merge');
        tse1.nextStep();
        tse1.setSelected('Account Release');    
        tse1.nextStep(); 
        tse1.setSelected('Enterprise Account');
        tse1.nextStep(); 
        tse2.saveForm();
        newacc.Country__c='--None--';
        update newacc;
        //system.currentPageReference().getParameters().put('reqType','Account Update');
        system.currentPageReference().getParameters().put('EID','NA0101');
        ApexPages.StandardController c3=new ApexPages.StandardController(newacc);
        CA_TAQ_Actual_MiniForm tse3=new CA_TAQ_Actual_MiniForm(c3);
        tse3.saveForm();
        
        
         
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
        
        TAQ_Organization__c ta = new TAQ_Organization__c();
  // ta.Process_Step__c='Employee Change';
        ta.Process_Step__c='Open Headcount';
        ta.Cost_Center_Desc__c=cc.id;
        ta.JobTitle__c=job.id;
        ta.IC_Currency__c=cur.id;
        ta.Manager_Name__c='test,mgr';
        ta.Manager_PMF_Key__c=u1.PMFKey__c;
    //    ta.PMFKey__c=u1.PMFKey__c;
        ta.Position_Id__c='testpos1';
    //FY13    ta.Role_Effective_Date__c=d.toStartOfMonth();
        ta.Role__c='AD/AM';
        ta.Organization__c='DIRECT';
     // FY 13   ta.Market__c='test';
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
  //FY13      ta.Quota_Currency_For_Data_Load__c='test currency';
        ta.IC_Currency_For_Data_Load__c='test currency';
        ta.PlanType_Effective_Date__c = d1.toStartofMonth();
        ta.Organization_for_Data_Load__c='DIRECT';
        ta.Area_for_Data_Load__c='testa';
        ta.Territory_For_Data_Load__c='nordics';
        ta.Country_for_Data_Load__c='United States';
    //Fy13    ta.Market_for_Data_Load__c='test';
        ta.Approval_Process_Status__c='Send For Approval';
   //     ta.Employee_name__c='test emp';
   //     ta.Employee_Status__c='Active';
   //    ta.Position_ID_Status__c='Active';
         insert ta;
        ta.Approval_Process_Status__c='Approved';
     //   update ta;
        ta.Process_Step__c = 'New Hire';
        ta.PMFKey__c = u1.PMFKey__c;
         ta.Employee_name__c='test, emp';
        ta.Approval_Process_Status__c='Approved';
        ta.Employee_Status_Date__c = System.today().toStartofMonth();
        ta.Position_ID_Status__c='Open';
        ta.Employee_Status__c='Open';
        update ta;
        
        
        if(ta.PMFKey__c!=null)
            tse2.getEmployeeName(ta.PMFKey__c);
     
      
        newacc.Account_Name_Change__c = newacc.name;
  //FY13  newacc.Account_Ownership_Change__c = acc1.ownerid;
    
        newacc.Is_Primary_Account__c = true ;
    
  //   TADKR01-Commented as SOQL Queries limit exceeded.
     //  update newacc ;
  //     Account acc =[select ownerid from account where Enterprise_Id__c='AP02400' limit 1];
     
//     FY 13  
     /*  if(newacc.Sales_Director_PMF_Key__c.length()==7){
        User usr=[select id from user where PMFKey__c =:newacc.Sales_Director_PMF_Key__c or name =:newacc.Sales_Director_Name__c ];
        if(usr.Id<>null)
        newacc.Sales_Director_Name_Change__c = usr.id;
      }
      * /
       
        test.startTest();
        update newacc ;
         tse2.isAccAdd=false;
       tse2.isAccUpdate=true;
       tse2.isError=false;
       tse2.isAccUpdateForPartner=true;
       tse2.isAccReleaseForPartner=true;
       tse2.isAccMergeForPartner=true;
        test.stopTest();
      }

        catch(Exception e){
          System.debug('Exception' + e);
        }  
        */
    }


 

   


}