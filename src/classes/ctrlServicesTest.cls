@isTest(seeAllData=true)
private class ctrlServicesTest{
@isTest(seeAllData=true)    
 static void runTestCases() 
    { 
     Profile p = [SELECT Id FROM profile WHERE name='Standard User']; 
         User u2 = new User(alias = 'sabaTest', email='sabaTest22@ca.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', username='sabaTest22@ca.com');
                System.runAs(u2) {
                Id recId = SystemIdUtility.getAccountTeamAcctRecordTypeId();
                account acc = new account(name = 'wells', recordtypeid = recId);
                insert acc;
                ApexPages.currentPage().getParameters().put('accid',acc.id);
               // ctrlServices cls = new ctrlServices();
                //cls.acc = acc.id;
                //cls.pages = 2;
                //cls.nextpage();
                //cls.prevpage();
                //cls.getListItems();
                //cls.templookup.Account_Name__c=acc.id;
               /* cls.refreshValues();
                Pagereference page=cls.GetServicesInfo();
                page=cls.SetAccountInfo();*/
            }
    }
   @isTest(seeAllData=true) 
   static void runTestCases_CSP_AddOpportunities() 
    { 
         Profile p = [SELECT Id FROM profile WHERE name='Standard User']; 
         User u2 = new User(alias = 'sabaTest', email='sabaTest22@ca.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', username='sabaTest22@ca.com');
                System.runAs(u2) {
                
                Id recId1 = SystemIdUtility.getResellerDistRecordTypeId();
                
                Id recId_opp = [Select id from Recordtype where name like '%new opp%' and SobjectType ='Opportunity'].Id;
               
                account acc = new account(name = 'wells', recordtypeid = recid1);
                insert acc;
                
                Id recId = SystemIdUtility.getAccountTeamAcctRecordTypeId();

                account acc1 = new account(name = 'wells', recordtypeid = recid);
                insert acc1;
                
                Opportunity opp = new Opportunity(recordtypeid=recId_opp, name='test Opp', StageName ='10%- Initial Request', 
                closedate = Date.today().addDays(30), amount=100);
                opp.AccountId = acc1.Id;
                opp.Reseller__c= acc.Id;
                Opportunity opp2 = new Opportunity(recordtypeid=recId_opp, name='test Opp2', StageName ='10%- Initial Request', 
                closedate = Date.today().addDays(30), amount=200);
                opp2.AccountId = acc1.Id;
                opp2.Reseller__c= acc.Id;
                insert new Opportunity[]{opp,opp2};
                
                Customer_Success_Program__c csp = new Customer_Success_Program__c(Account__c = acc1.id, CSP_Name__c ='test CSP',
                Customer_Delivery_Completed__c  = date.today(), CVD_Name__c = 'Advanced Authentication',
                CVP_Status__c= '20% Customer Approved ', CSP_Related_Opportunity_s__c = opp.id,
                Program_Type__c='Customer Value Discussion Program (CVD)',
                Target_Report_Completion_Date__c=date.today(),Target_Start_Date__c=date.today());
                insert csp;
                
                //CSP_Opportunity__c cspOpp = new CSP_Opportunity__c(Opportunity__c = opp.id, Customer_Success_Program__c = csp.id);
                //insert cspOpp;
                
                Pagereference pg = Page.Add_RemoveOpportunity;
                pg.getParameters().put('id',acc.id);
                pg.getParameters().put('csp',csp.id);
                Test.setCurrentPage(pg);
                ApexPages.StandardController stdController = new ApexPages.StandardController(acc); 
                CSP_AddOpportunities cls = new CSP_AddOpportunities(stdController);
                cls.lstOpps.add(new CSP_AddOpportunities.WrapOpps(opp2, true));
                cls.saveOpps();
                cls.SkipSelection();
                cls.ApplySelection();
                
            }
        } 
   @isTest(SeeAllData=true)
   static void runTestCases_Ext_CSP_AddProd() 
    { 
         Profile p = [SELECT Id FROM profile WHERE name='Standard User']; 
         User u2 = new User(alias = 'sabaTest', email='sabaTest22@ca.com', 
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', username='sabaTest22@ca.com');
                System.runAs(u2) {
                //Id recId = SystemIdUtility.getAccountTeamAcctRecordTypeId();//Commented THAAN04_PRM5.5Release
                //Added this to get Reseller/Distributor Account record type ID as Reseller__c Account can be only of this type
                Id recId = SystemIdUtility.getResellerDistRecordTypeId();
                Id recId_opp = [Select id from Recordtype where name like '%new opp%' and SobjectType ='Opportunity'].Id;
                
                account acc = new account(name = 'wells', recordtypeid = recid);
                insert acc;
                 
                Id recId1 = SystemIdUtility.getAccountTeamAcctRecordTypeId();
                account acc1 = new account(name = 'wells', recordtypeid = recid1);
                insert acc1;
                
                Opportunity opp = new Opportunity(recordtypeid=recId_opp, name='test Opp', StageName ='10%- Initial Request', 
                closedate = Date.today().addDays(30), amount=100);
                opp.AccountId = acc1.Id;
                opp.Reseller__c= acc.Id;
                Opportunity opp2 = new Opportunity(recordtypeid=recId_opp, name='test Opp2', StageName ='10%- Initial Request', 
                closedate = Date.today().addDays(30), amount=200);
                opp2.AccountId = acc1.Id;
                opp2.Reseller__c= acc.Id;
                insert new Opportunity[]{opp,opp2};
                
                Customer_Success_Program__c csp = new Customer_Success_Program__c(Account__c = acc1.id, CSP_Name__c ='test CSP',
                Customer_Delivery_Completed__c  = date.today(), CVD_Name__c = 'Advanced Authentication',
                CVP_Status__c= '20% Customer Approved ', CSP_Related_Opportunity_s__c = opp.id,
                Program_Type__c='Customer Value Discussion Program (CVD)',
                Target_Report_Completion_Date__c=date.today(),Target_Start_Date__c=date.today());
                insert csp;
                
                Product2 prod = new Product2(name ='test Prod');
                Product2 prod2 = new Product2(name ='test Prod');
                insert new Product2[]{prod,prod2};
                
                CSP_Product__c cp = new CSP_Product__c(Product__c = prod.id, Customer_Success_Program__c = csp.id);
                insert cp;
                
                Product_material__C pm = new Product_Material__c(Platform_Category__c='Mainframe',Operational_BU__c='Mainframe', 
                Material_Text__c='test Mat', name ='Mat001', product__c=prod.id);
                insert pm;
                
                
                Pagereference pg = Page.CSP_AddProducts;
                pg.getParameters().put('id',cp.id);
                pg.getParameters().put('cspid',csp.id);
                pg.getParameters().put('retURL',csp.id);
                Test.setCurrentPage(pg);
                ApexPages.StandardController stdController = new ApexPages.StandardController(acc); 
                Ext_CSP_AddProd cls = new Ext_CSP_AddProd(stdController);
                cls.Back();
                cls.refreshValues();
                cls.AddMaterial();
                cls.AddProd();  
                cls.cp.product__c = prod2.id;
                cls.AddProd();
                cls.UpdateProd();
            }       
    
    }
}