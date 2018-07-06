@isTest
private class testScheduleEventController
{
    static testmethod void testEvents()
    {
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    

        Product2 prd1 = new Product2(Name='Product1',Market_Focus_Area__c='Mainframe',family='Product');
        Product2 prd2 = new Product2(Name='Product2',Market_Focus_Area__c='Mainframe',family='Product');
        Product2 prd3 = new Product2(Name='Product2',Market_Focus_Area__c='Mainframe',family='Product');
        Product2[] prd = new Product2[]{prd1,prd2,prd3};
        insert prd;
        //RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='IND-Value'];
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        //Opportunity opp = new Opportunity(RecordTypeID=recopp.Id,AccountId=acc[0].Id,CloseDate=System.today()+2,Name='TestOpp',Transaction_Type__c='Current FY Time',New_Deal_Term_months__c = 2,StageName='10%-Qualified Renewal',Ent_Comm_Account__c=acc[1].Id); 
        Opportunity opp = new Opportunity(RecordTypeID=recopp.Id,AccountId=smbAcct.Id,Reseller__c=resellerAcct.Id,CloseDate=System.today()+2,Name='TestOpp',New_Deal_Term_months__c = 2,StageName='10%-Qualified Renewal');
        insert opp; 
        TSO_Request__c tsoreq = new TSO_Request__c(Coordinator_Name__c=UserInfo.getUserId(),End_Date__c=System.now()+2,Start_Date_Time__c=System.now(),Duration_Hours__c=48,Request_Type__c='Trial/POC',Location_Information__c='Loc 1',Opportunity__c=opp.Id,Additional_Request_Details__c='This is a test');
        insert tsoreq;
        TSO_Request_Product_Selection__c tsoprd1 = new TSO_Request_Product_Selection__c(ProductId__c=prd[0].Id,TSO_Request_ID__c=tsoreq.Id);
        TSO_Request_Product_Selection__c tsoprd2 = new TSO_Request_Product_Selection__c(ProductId__c=prd[1].Id,TSO_Request_ID__c=tsoreq.Id);
        TSO_Request_Product_Selection__c tsoprd3 = new TSO_Request_Product_Selection__c(ProductId__c=prd[2].Id,TSO_Request_ID__c=tsoreq.Id);
        TSO_Request_Product_Selection__c[] tsoprd = new TSO_Request_Product_Selection__c[]{tsoprd1,tsoprd2,tsoprd3}; 
        insert tsoprd;
        System.debug('tsoprd '+tsoprd);
        RecordType eventrec = [select Id from RecordType where IsActive=true and SObjectType='Event' limit 1 ]; //and Name='TSO Event'
        //Event everec = new Event(StartDateTime=System.now(),EndDateTime=System.now()+1,RecordTypeId=eventrec.Id,TSO_Request_Id__c=tsoreq.Id,OwnerId=UserInfo.getUserId());
        Event everec = new Event(StartDateTime=System.now(),EndDateTime=System.now()+1,RecordTypeId=eventrec.Id,OwnerId=UserInfo.getUserId());
        //DurationInMinutes=10,ActivityDateTime=System.now(),
        insert everec;
        everec.Start_Date_Time__c = null;        
        everec.End_Date__c = null;
        update everec;
        everec.EndDateTime = System.now()+3;
        update everec;
        everec.StartDateTime= System.now()+1;
        update everec;
        PageReference evepage = Page.TSO_ScheduleEvent_New;
        evepage.getParameters().put('tsoid',tsoreq.Id);
        evepage.getParameters().put('newid',everec.Id);
        
        Test.setCurrentPage(evepage);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(everec);
        TSO_ScheduleEventcontroller_New evecontroller = new TSO_ScheduleEventcontroller_New(stdcon1);
        List<SelectOption> lstlevel1 = evecontroller.level1Items;
        List<SelectOption> lstlevel2 = evecontroller.level2Items;
        List<SelectOption> lstlevel3 = evecontroller.level3Items;
        List<SelectOption> secBU = evecontroller.secondBU;
        List<SelectOption> secProd = evecontroller.secondProducts;
        List<SelectOption> thirdBU = evecontroller.thirdBU;
        List<SelectOption> thirdProd = evecontroller.thirdProducts;
        
        evecontroller.saveEvent();
      
          
    }
}