public with sharing class CILL_popupController {
    public string prodid{get;set;}
    public  string acpname{get;set;}
    public  string csuname{get;set;}
    public  string prodgroup{get;set;}
    public  string prodname{get;set;}
    public  string accid{get;set;}
    Map<string,string> mapSV = new Map<string,string>();
    public class ACL_SuppVersion
    {
        public Active_Contract_Line_Item__c acli{get;set;}
        public string suppv{get;set;}

        public ACL_SuppVersion( string s, Active_Contract_Line_Item__c vacli)
        {
            suppv=s;
            acli=vacli;
        }

    }
   
     
    public cill_popupController()
    {
        accid = ApexPages.CurrentPage().getPArameters().get('accid');
        prodname = ApexPages.CurrentPage().getPArameters().get('prodname');
        

    
        prodid = ApexPages.CurrentPage().getPArameters().get('prodid');
        acpname =  ApexPages.CurrentPage().getPArameters().get('acpname');
        csuname = ApexPages.CurrentPage().getPArameters().get('csuname');
        prodgroup = ApexPages.CurrentPage().getPArameters().get('prodgroup');
   
        if(setCon <> null)
        {
            setCon.setPageSize(20); 
            set<string> siteids = new set<string>();
            for(Active_Contract_Line_Item__c acli: (List<Active_Contract_Line_Item__c>) setCon.getRecords())
            {
                String siteid =acli.Ship_To_ID__c; 
                String sys= acli.SYSTEM_ORIGIN__C;
                
                if(sys <> null) sys = sys.toUppercase();
                if(siteid <> null) siteid = siteid.toUppercase();
                siteids.add(siteid);
                
            }

               Support_Tickets__c[] s;
               if(siteids.size() > 0 && accid <> null && accid  <> '' && prodname <> null && prodname <> '' ) 
                   s = [Select id, Site__c,Product_Version__c from Support_Tickets__c where account__c =: accid and Product_Name__c =: prodname 
               and Site__c in:siteids order by  Product_Version__c desc limit 1];
               if(s!=null && s.size() > 0)
               {
                   for(Support_Tickets__c st: s)
                        mapSV.put(st.site__c.toUpperCase(),st.Product_Version__c);

                }
        }
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) 
            {
               if(prodid <> null)
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [Select CILL_Licensed_Quantity_2__c, Metric_Quantity__c, Ship_To_ID__c, SYSTEM_ORIGIN__C ,Contract_Product__r.Product__r.Name, Product_Material__r.Name,  
                 Contract_Product__r.Active_Contract__r.sap_tops__c, Contract_Product__r.Active_Contract__r.name, Contract_Start_Date__c, Contract_End_Date__c, Licensed_Quantity__c, Calculated_AOCV_USD__c,
                 License_Type_Text__c, Platform__c, Contract_Product__r.Contact__r.Name FROm   Active_Contract_Line_Item__c 
                 where
                 Contract_Product__r.Product__c = : prodid 
                 AND 
                 Contract_Product__r.Active_Contract__r.Contract_End_Date__c >= : Date.Today() 
                 AND 
                 Contract_Product__r.Active_Contract__r.Account__c = : accid 
                 Limit :(Limits.getLimitQueryLocatorRows() - Limits.getQueryLocatorRows())
                
                ]));
            }
            return setCon;
        }
        set;
    }
    
    
    
    public List<ACL_SuppVersion> getACL()
    {    
        List<ACL_SuppVersion> lst = new List<ACL_SuppVersion>();
         if(setCon  <> null)
        {
            for(Active_Contract_Line_Item__c acli:(List<Active_Contract_Line_Item__c>) setCon.getRecords())
            {
                String siteid =acli.Ship_To_ID__c; 
                String sys= acli.SYSTEM_ORIGIN__C;
                
                if(sys <> null) sys = sys.toUppercase();
                if(siteid <> null) siteid = siteid.toUppercase();
                
                ACL_SuppVersion a = new ACL_SuppVersion(mapSV.get(siteid), acli);

                lst.add(a);
            }


        }
        return lst; 
             
     }   
     
     @isTest(SeeAllData=true)
        static void testCILL() 
   {
               List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='NA';
        
        ac.Enterprise_ID__c = '1234te';
        
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        //ac.Sales_Area__c =''
        accntList.add(ac);
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.BillingState = 'NY';   
        ac1.Customer_Category__c = 'Enterprise';
        //ac1.Account_Status__c = 'Approved';       
        ac1.GEO__c='LA';
        ac1.Enterprise_ID__c = '1234te';
        ac1.Enterprise_Account_Name__c = 'rdName1';
        ac1.Commercial_ID__c = 'asdf';
        ac1.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();
        accntList.add(ac1);
        insert accntList;
          
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;  
          
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(
        name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id,Contract_End_Date__c=Date.Today()+1);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac1.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'Specific Product',Product_Group__c = 'Test1',csu2__c = 'Test1', CSU_Driver__c = 'Test1');
        prodList.add(prod);  
        
        insert prodList;
        
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='LT');
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('10/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd2);
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd3);
        Active_Contract_Product__c actvContPrd4= new Active_Contract_Product__c(name='TestACP4',Active_Contract__c=activeContract2.Id,
        Product__c=prod.Id,Dismantle_Date__c =date.parse('11/20/2013'),Pre_Segmentation__c ='MT');
        activeContractProdList.add(actvContPrd4);
        insert activeContractProdList;
        
        List<Active_Contract_Line_Item__c> actLineItemsList = new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acp = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 30000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd.Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp2 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd2.Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp3 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 35000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000, Contract_Product__c =actvContPrd3.Id, ACL_Status__c = 'invalid');
        Active_Contract_Line_Item__c acp4 = new Active_Contract_Line_Item__c(
        AOCV__c = 300000,Raw_Maint_Calc_LC__c = 40000,
        OCV__c = 200000,
        ATTRF_CRV__c = 14000,Contract_Product__c =actvContPrd4.Id, ACL_Status__c = 'invalid');
        
        actLineItemsList.add(acp);
        actLineItemsList.add(acp2);
        actLineItemsList.add(acp3);
        actLineItemsList.add(acp4);
        insert actLineItemsList;
   
   
   
     
         active_contract_line_item__C acli = [Select contract_product__r.Product__r.Product_Group__c, contract_product__r.Product__c, contract_product__r.Product__r.csu2__c, contract_product__r.active_contract__r.account__c  from active_contract_line_item__C where contract_product__r.active_contract__r.account__c <> null
            AND Contract_Product__r.Active_Contract__r.Contract_End_Date__c >= : Date.Today()  limit 1];
         Account acc = [Select Id from Account where Id = :acli.contract_product__r.active_contract__r.account__c LIMIT 1];
    
         ApexPages.StandardController std = new ApexPages.StandardController(acc);
         ApexPages.CurrentPage().getPArameters().put('id',acc.Id);
         
         Ext_Cill ext = new Ext_Cill(std);
         ext.acc = acc;
         ext.accid = acc.id;
        // ext.initValues();
         ext.saveInfo();
         List<SelectOption> lst = ext.getlstCSU();
         ext.refreshPage();
         ext.filterItems();
         ext.resetItems();
         ext.prods = new List<string>();
         ext.prods.add(acli.contract_product__r.Product__c);
         ext.filterItems();
         ext.csu  = new List<string>();
         ext.csu.add(acli.contract_product__r.Product__r.csu2__c);
         ext.filterItems();
         ext.prodgroup  = new List<string>();
         ext.prodgroup.add(acli.contract_product__r.Product__r.Product_Group__c);
         ext.filterItems();
         ext.prods = null;
         ext.filterItems();
         ext.csu = null;
         ext.filterItems();
         ext.getCSUsize();
         ext.getprodgroupsize();
         ext.getprodsize();
        
       
        CILL_popupController popup = new CILL_popupController();                 
        popup.prodid = acli.contract_product__r.Product__c;
        popup.accid = acc.id;
        popup.getACL();
        ApexPages.StandardSetController setCon = popup.setCon;   

        test.startTest();
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        ID rectypeid = [Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
        ID rectypeid1 = [Select r.Name, r.Id From RecordType r where r.Name='SMB' limit 1].Id;
        
        Account acc2 = new Account(RecordTypeId= rectypeid, Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert acc2;                
        
        Account acc1 = new Account(RecordTypeId= rectypeid1, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert acc1;                
        
        Opportunity opp = new Opportunity(AccountId=acc1.Id,Reseller__c=acc2.Id,Name='Opp',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);        
        insert opp;        
        Opportunity opp2 = new Opportunity(AccountId=acc1.Id,Reseller__c=acc2.Id,Name='Opp2',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);        
        insert opp2;        
        
       //To complete coverage
       Account_Visit__c acv = new Account_Visit__c(Visit1From__c = Date.Today(), Customer_Attendees__c = 'testtestsetsetsetse', Company_Name__c = acc2.id,Opp_Ids__c= (opp.id+':' + '12345'+'='+opp2.id+':' + '12345'));
       insert acv;
        test.stopTest();
         
        
   }
}