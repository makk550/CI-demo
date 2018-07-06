@isTest             //   (seeAllData=true)
Public class PresalesformControllerTest{
    
    public static testMethod void testforForm(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = new Map<Opportunity,List<OpportunityLineItem>>();
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='we', recordtypeid =com);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'USA';
        a.GEO__c= 'NA';
        a.Sales_Area__c= 'America';
        a.Sales_Region__c= 'America';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        a.BillingCountry = 'USA';
        insert a;

        Opportunity opp = new Opportunity(RecordTypeId=recopp,AccountId = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = 'test' , 
                                          CloseDate = Date.today(),
                                          New_Deal_Term_months__c = 12, 
                                          Stretch_Deal_Term_Months__c = 8,
                                          Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
                                          Business_Type__c = 'High Touch',
                                          Projected_Renewal__c = 12345.0,
                                          Start_Date__c = Date.today(),
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Commissionable_BU__c='AC');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                          raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
        insert oli;
        QueuesObject q1 ;
        Group g1;
        System.runAs ( new User(Id = UserInfo.getUserId()) ){
            g1 = new Group(Name='group name', type='Queue');
            insert g1;
            
            q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Presales_Request__c');
            insert q1;
        }
       
        PreSales_Director_Queues__c presalDirect=new PreSales_Director_Queues__c();
        presalDirect.Name='Presales Queue NA AC';
        presalDirect.GEO__c='NA';
        presalDirect.CBU__c='AC';
        presalDirect.Queue_Id__c=g1.id;
        insert presalDirect;
        
        PreSales_Director_Queues__c presalDirect1=new PreSales_Director_Queues__c();
        presalDirect1.Name='Presales Queue NA Mismatch';
        presalDirect1.GEO__c='NA';
        presalDirect1.CBU__c='';
        presalDirect1.Queue_Id__c=q1.id;
        insert presalDirect1;
        
        PreSales_Director_Queues__c presalDirect2=new PreSales_Director_Queues__c();
        presalDirect2.Name='Presales Queue APJ Mismatch';
        presalDirect2.GEO__c='APJ';
        presalDirect2.CBU__c='';
        presalDirect2.Queue_Id__c=q1.id;
        insert presalDirect2;
        
        PreSales_Director_Queues__c presalDirect3=new PreSales_Director_Queues__c();
        presalDirect3.Name='Presales_Queue_EMEA_Other';
        presalDirect3.GEO__c='EMEA';
        presalDirect3.CBU__c='';
        presalDirect3.Queue_Id__c=q1.id;
        insert presalDirect3;
        
       
        
        //List<OpportunityLineItem> oliList =  Test_CreateOpportunity.createOpportunityLineItemList(opp.Id); 
        
        
        Test.setCurrentPageReference(new PageReference('Page.PreSales_Request_Form')); 
        System.currentPageReference().getParameters().put('id', opp.id);
        id preSalesPendingId=Schema.SObjectType.Presales_Request__c.getRecordTypeInfosByName().get('Presales Pending Fulfillment').getRecordTypeId();
   RecordTypes_Setting__c recordTyp3=new RecordTypes_Setting__c();
        recordTyp3.RecordType_Id__c=preSalesPendingId;                                    
        recordTyp3.Name='Presales Pending Fulfillment';
        recordTyp3.SObject_Name__c='Presales Request';
        insert recordTyp3;
        
        
        PreSalesFormController preSalesForm=new PreSalesFormController();
        
        preSalesForm.selectedProduct='AC';
        preSalesForm.prsal.Start_Date__c=Date.newInstance(2017, 3, 24);
        preSalesForm.prsal.Activity__c='Roadmap';
        preSalesForm.prsal.Duration__c=28;
        preSalesForm.prsal.opportunity__c=opp.id; 
        preSalesForm.prsal.GEO__c='NA';
        preSalesForm.prsal.Commission_BU__c='AC';
        preSalesForm.prsal.Request_Status__c='Pending Fulfillment ';
        preSalesForm.prsal.Action__c = 'New';
        // preSalesForm.prsal.RecordTypeId=preSalesPendingId;
       
        string qsobjid = PreSalesFormController.queueIds(preSalesForm.prsal).Queue_Id__c;
        //QueueSObject qsobj = [select QueueId from QueueSObject where id=:qsobjid];
        //system.debug('qsobjid'+qsobjid);
        
        
        //preSalesForm.prsal.OwnerId=qsobj.QueueID;
        //system.debug('preSalesForm.prsal.OwnerId'+preSalesForm.prsal.OwnerId);
        //insert  preSalesForm.prsal;
        
        set<id> groupIds=new set<id>();
        //Create Parent Group
        Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Regular'; 
        Insert grp; 
        groupIds.add(grp.id);
        //Create Sub group
        Group subGrp  = new Group();
        subGrp.name = 'Test Group2';
        subGrp.Type = 'Regular'; 
        Insert subGrp; 
        groupIds.add(subGrp.id);
        
        preSalesForm.getProductAssociateCBU();
        preSalesForm.cancel();
        preSalesForm.submitForm();
        PreSalesFormController.GetUserIdsFromGroup(groupIds);
        PreSalesFormController.queueIds(preSalesForm.prsal);
        
        Opportunity opp2 = new Opportunity(RecordTypeId=recopp,AccountId = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = 'test' , 
                                          CloseDate = Date.today(),
                                          New_Deal_Term_months__c = 12, 
                                          Stretch_Deal_Term_Months__c = 8,
                                          Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
                                          Business_Type__c = 'High Touch',
                                          Projected_Renewal__c = 12345.0,
                                          Start_Date__c = Date.today(),
                                          End_Date__c = Date.today().addMonths(12));
        insert opp2;
        
        
        
        PageReference pageRefPreSales = Page.PreSales_Request_Form;
        Test.setCurrentPage(pageRefPreSales);
        ApexPages.currentPage().getParameters().put('id', opp2.id);
        PreSalesFormController preSalesController = new PreSalesFormController();
        preSalesController.submitForm();
        
       
        
    }
    
    
    
    
}