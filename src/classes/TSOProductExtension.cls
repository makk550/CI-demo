public class TSOProductExtension {

    private TSO_Request_Product_Selection__c tsoProduct;
    private TSO_Request__c tsoRequest;
    private Event tsoEvent;
    
    private TSO_Event_Product_Selection__c evtProduct;
    private Event event;
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    
// the values of the selected items
    public string selectedLevel1 {get; set;}
    public string selectedLevel2 {get; set;}
    public string selectedLevel3 {get; set;}
    public Boolean disableBU {get; set;}
    public Boolean disableProd {get; set;}
    public Boolean isInAddMode {get; set;}
    public Boolean showForm {get; set;}
    public Boolean isEvent {get; set;}
    public string productId {get; set;}
    public string requestId {get; set;}
    public string requestName {get; set;}
    public string eventId {get; set;}
    public string opportunityName {get; set;}
    public string opportunityId {get; set;}
    public string sRecordTypeName {get; set;}
    public string strSRC {get; set;}
    public string s2 {get; set;}
    public string s3 {get; set;}
    public string s4 {get; set;}
    public string s5 {get; set;}
    public string s6 {get; set;}
    public string s7 {get; set;}
    public string s8 {get; set;}
    public string s9 {get; set;}
    public string s10 {get; set;}
    public string s11 {get; set;}
    
   
    static testMethod void myUnitTest() {
     //try{
        Product2 testProduct = new Product2(Name='Test Product1',Market_Focus_Area__c='Mainframe',family='Product');
        insert testProduct;
        Id productId = testProduct.id;
        TSO_Request__c tsoRequestNew = new TSO_Request__c();
        tsoRequestNew.Duration_Hours__c = 40;
        tsoRequestNew.Start_Date_Time__c = System.now();
        tsoRequestNew.End_Date__c = System.now()+1;
        tsoRequestNew.Opportunity__c = [select id from opportunity limit 1].id;
        tsoRequestNew.Selected_Product_Ids__c = productId + ',';
        insert tsoRequestNew;
        TSO_Request_Product_Selection__c newReqProd = new TSO_Request_Product_Selection__c();
        newReqProd.ProductId__c = productId;
        newReqProd.TSO_Request_ID__c = tsoRequestNew.id;
      //  insert newReqProd; 

        //TSO Event Scheduling test coverage.
        RecordType[] recacc = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name in ('Account Team Covered Account')];//('Reseller/Distributor Account','CA Enterprise Account')];
        Account acc1 = new Account(Name='TestAcc1',Geo__c='NA',RecordTypeId=recacc[0].Id,Enterprise_Id__c='NAACC001',Enterprise_Account_Name__c='EAcc',Customer_Category__c='Reseller',Commercial_ID__c =   '12',Commercial_Account_Name__c = 'caName');
        Account acc2 = new Account(Name='TestAcc2',Geo__c='NA',RecordTypeId=recacc[0].Id,Enterprise_Id__c='NAACC001',Enterprise_Account_Name__c='EAcc',Customer_Category__c='Enterprise',Commercial_ID__c =     '12',Commercial_Account_Name__c = 'caName');
        Account[] acc = new Account[]{acc1,acc2};
        insert acc;
        Product2 prd1 = new Product2(Name='Product1',Market_Focus_Area__c='Mainframe',family='Product');
        Product2 prd2 = new Product2(Name='Product2',Market_Focus_Area__c='Mainframe',family='Product');
        Product2 prd3 = new Product2(Name='Product2',Market_Focus_Area__c='Mainframe',family='Product');
        Product2[] prd = new Product2[]{prd1,prd2,prd3};
        insert prd;
        //RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='IND-Value'];
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        //Opportunity opp = new Opportunity(RecordTypeID=recopp.Id,AccountId=acc[0].Id,CloseDate=System.today()+2,Name='TestOpp',Transaction_Type__c='Current FY Time',New_Deal_Term_months__c = 2,StageName='10%-Qualified Renewal',Ent_Comm_Account__c=acc[1].Id); 
        Opportunity opp = new Opportunity(RecordTypeID=recopp.Id,AccountId=acc[1].Id,Reseller__c=acc[1].Id,CloseDate=System.today()+2,Name='TestOpp',New_Deal_Term_months__c = 2,StageName='10%-Qualified Renewal');
        insert opp; 
        TSO_Request__c tsoreq = new TSO_Request__c(Coordinator_Name__c=UserInfo.getUserId(),End_Date__c=System.now()+2,Start_Date_Time__c=System.now(),Duration_Hours__c=48,Request_Type__c='Trial/POC',Location_Information__c='Loc 1',Opportunity__c=opp.Id);
        insert tsoreq;
        TSO_Request_Product_Selection__c tsoprd1 = new TSO_Request_Product_Selection__c(ProductId__c=prd[0].Id,TSO_Request_ID__c=tsoreq.Id);
        TSO_Request_Product_Selection__c tsoprd2 = new TSO_Request_Product_Selection__c(ProductId__c=prd[1].Id,TSO_Request_ID__c=tsoreq.Id);
        TSO_Request_Product_Selection__c tsoprd3 = new TSO_Request_Product_Selection__c(ProductId__c=prd[2].Id,TSO_Request_ID__c=tsoreq.Id);
        TSO_Request_Product_Selection__c[] tsoprd = new TSO_Request_Product_Selection__c[]{tsoprd1,tsoprd2,tsoprd3}; 
        insert tsoprd;
        System.debug('tsoprd '+tsoprd);
        RecordType eventrec = [select Id from RecordType where IsActive=true and SObjectType='Event' limit 1 ]; //and Name='TSO Event'
        //Event everec = new Event(DurationInMinutes=10,ActivityDateTime=System.now(),RecordTypeId=eventrec.Id,TSO_Request_Id__c=tsoreq.Id,OwnerId=UserInfo.getUserId());
        Event everec = new Event(DurationInMinutes=10,ActivityDateTime=System.now(),RecordTypeId=eventrec.Id,OwnerId=UserInfo.getUserId());
        insert everec;
        
        
        ApexPages.StandardController QController = new ApexPages.StandardController(newReqProd);
        TSOProductExtension ext = new TSOProductExtension(QController);

        //ext.sRecordTypeName = 'Renewal'; 
        ext.sRecordTypeName = 'New Opportunity';
        List<SelectOption> level1ItemsTEST = ext.level1Items;
        //ext.sRecordTypeName = 'Med Touch Renewal'; 
        ext.sRecordTypeName = 'New Opportunity';
        level1ItemsTEST = ext.level1Items;
        //ext.sRecordTypeName = 'Indirect'; 
        ext.sRecordTypeName = 'New Opportunity';
        level1ItemsTEST = ext.level1Items;
        ext.sRecordTypeName = ''; 
        level1ItemsTEST = ext.level1Items;
        ext.selectedLevel1 = 'testing';
        level1ItemsTEST = ext.level2Items;
        level1ItemsTEST = ext.level3Items;
        ext.doSave();
        ext.doCancel();

        ext.requestId = tsoRequestNew.id + '';
        ext.productId = newReqProd.id + '';

        ext.strSRC = 'request';
        ext.showTheForm();
        ext.initProduct();

        Event newEvt = new Event();
        newEvt.ActivityDateTime = System.now();
        newEvt.DurationInMinutes = 40;
        newEvt.Subject = 'TSO EVENT';
        //newEvt.Additional_Request_Details__c = 'This is testing by developer.';
        insert newEvt;

        TSO_Event_Product_Selection__c newEvtProd = new TSO_Event_Product_Selection__c();
        newEvtProd.ProductId__c = [select id from product2 limit 1].id;
        newEvtProd.Event_Id__c = everec.id + '';
        insert newEvtProd; 

        ext.requestId = everec.id + '';
        ext.productId = newEvtProd.id + '';
        ext.strSRC = 'event';
        ext.isEvent = true;
        ext.initProduct();
        ext.doSave();
      /* }
       Catch(Exception e){
        
        System.debug('Exception***************'+e);
       } */
    }
       
    public TSOProductExtension(ApexPages.StandardController stdController) {
        if(ApexPages.currentPage().getParameters().get('retURL')!=null)
            requestId = ApexPages.currentPage().getParameters().get('retURL').replace('/','');

        productId = ApexPages.currentPage().getParameters().get('id');
        strSRC = ApexPages.currentPage().getParameters().get('src');
        isEvent = false;

        initProduct();        

        if(productId==requestId && tsoProduct!=null)
            requestId = tsoProduct.TSO_Request_ID__c;
        else if(productId==eventId && evtProduct!=null)
            eventId = evtProduct.Event_ID__c;
            
        System.debug('requestId='+requestId);
        System.debug('eventId='+eventId);

        if(isEvent){
            List<TSO_Event_Product_Selection__c> prods = [Select Event_Id__c, OwnerId, Name, Id From TSO_Event_Product_Selection__c where Event_Id__c=:eventId];
            if(productId==null && prods!=null && prods.size()>=3)
                showForm = false;
            else
                showForm = true;
        }else{            
            List<TSO_Request_Product_Selection__c> prods = [Select TSO_Request_ID__c, OwnerId, Name, LastActivityDate, IsDeleted, Id From TSO_Request_Product_Selection__c where TSO_Request_ID__c=:requestId];
            if(productId==null && prods!=null && prods.size()>=3)
                showForm = false;
            else
                showForm = true;
        }
        
        if(showForm){
            showTheForm();
        }
    }

    public void showTheForm(){
        //List<TSO_Request__c> tsoRequestList = [Select TSO_Scheduled__c, TSO_Individual_Requested_3__c, TSO_Individual_Requested_2__c, TSO_Individual_Requested_1__c, SystemModstamp, Start_Date_Time__c, Solution_Set_3__c, Solution_Set_2__c, Solution_Set_1__c, Request_Type__c, Request_Status__c, RecordTypeId, Product_3_lookup__c, Product_3__c, Product_3_Leg__c, Product_2_lookup__c, Product_2__c, Product_2_Leg__c, Product_1_lookup__c, Product_1__c, Product_1_Leg__c, Partner_Name__c, Partner_ID__c, OwnerId, Opportunity__c, Opportunity__r.Name, Opportunity_Type_3__c, Opportunity_Type_2__c, Opportunity_Type_1__c, Name, Market_Focus_Area_3__c, Market_Focus_Area_2__c, Market_Focus_Area_1__c, Location_Information__c, Lead__c, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, Ent_Comm_Account__c, End_Date__c, Duration_Sri__c, Duration_Hours__c, CurrencyIsoCode, CreatedDate, CreatedById, Coordinator_Name__c, BU_Category_3__c, BU_Category_2__c, BU_Category_1__c, Additional_Request_Details__c, Account__c, Account_Customer_Category__c From TSO_Request__c where id=:requestId];
        List<TSO_Request__c> tsoRequestList = [Select Opportunity__c, Opportunity__r.Name, Name, Id From TSO_Request__c where id=:requestId];
        if(!tsoRequestList.isEmpty()){
            tsoRequest = tsoRequestList[0];
            if(tsoRequest!=null){
                requestName = tsoRequest.Name;
                opportunityName = tsoRequest.Opportunity__r.Name;
                opportunityId = tsoRequest.Opportunity__c;
            }
        }
        else
        {
            List<Event> tsoEventList = [Select WhatId,What.Name, Id From Event where id=:requestId];
            if(!tsoEventList.isEmpty()){
            tsoEvent = tsoEventList[0];
            if(tsoEvent!=null){
                //requestName = tsoRequest.Name;
                opportunityName = tsoEvent.What.Name;
                opportunityId = tsoEvent.WhatId;
            }
        }
        }
    }

    public void initProduct(){
        if(strSRC!=null && strSRC=='event'){
            isEvent = true;
            eventId = requestId;
            
            if(eventId.length()>15)
              eventId = eventId.substring(0, 15);            

            if(productId!=null && productId.length()>15)
              productId= productId.substring(0, 15);            
        }
        
        try{
            if(isEvent){
                evtProduct= [Select ProductId__c, ProductFamily__c, Business_Unit__c, Event_Id__c, Id From TSO_Event_Product_Selection__c where id=:productId];
                if(evtProduct!=null){
                    selectedLevel1 = evtProduct.ProductFamily__c;
                    selectedLevel2 = evtProduct.Business_Unit__c;
                    selectedLevel3 = evtProduct.ProductId__c;
                }
            }else{
                tsoProduct = [Select TSO_Request_ID__c, ProductId__c, ProductFamily__c, OwnerId, Name, LastActivityDate, IsDeleted, Id, Business_Unit__c From TSO_Request_Product_Selection__c where id=:productId];
                if(tsoProduct!=null){
                    selectedLevel1 = tsoProduct.ProductFamily__c;
                    selectedLevel2 = tsoProduct.Business_Unit__c;
                    selectedLevel3 = tsoProduct.ProductId__c;
                }
            }
        }catch(Exception e){}
    }

    public PageReference doSave(){
        string retURL = ApexPages.currentPage().getParameters().get('retURL');
        if(retURL==null)
            retURL = '/';

        PageReference p = new PageReference(retURL);

        if( selectedLevel1!=null && selectedLevel1!='' && selectedLevel2!=null && 
            selectedLevel2!='' && selectedLevel3!=null && selectedLevel3!=''){        

            if(isEvent){
                if(ApexPages.currentPage().getParameters().get('id')!=null){
                    evtProduct.ProductId__c = selectedLevel3;
                    update evtProduct;
                }else{
                    TSO_Event_Product_Selection__c newProduct = new TSO_Event_Product_Selection__c();
                    newProduct.ProductId__c = selectedLevel3;
                    newProduct.Event_ID__c = eventId;
                    insert newProduct;
                }
            }else{
                if(ApexPages.currentPage().getParameters().get('id')!=null){
                    tsoProduct.ProductId__c = selectedLevel3;
                    update tsoProduct;
                }else{
                    TSO_Request_Product_Selection__c newProduct = new TSO_Request_Product_Selection__c();
                    //newProduct.Name = selectedLevel3; 
                    newProduct.ProductId__c = selectedLevel3;
                    newProduct.TSO_Request_ID__c = requestId; //tsoRequest.Id;
                    insert newProduct;
                }
            }
            p.setRedirect(true);
        }else{
            return null;
        }
        
        return p;
    }

    public PageReference doCancel(){
        string retURL = ApexPages.currentPage().getParameters().get('retURL');
        if(retURL==null)
            retURL = '/';

        PageReference p = new PageReference(retURL);
        p.setRedirect(true);
        return p;
    }

    public List<SelectOption> level1Items {
        get {
            System.debug('tsoRequest='+tsoRequest);
            System.debug('tsoEvent='+tsoEvent);
            List<SelectOption> options = new List<SelectOption>();
            if(tsoRequest!=null && tsoRequest.Opportunity__c!=null){                
                Opportunity opp = [Select Pricebook2Id, Pricebook2.Name,RecordTypeId,RecordType.Name from Opportunity where Id=:tsoRequest.Opportunity__c];
                sRecordTypeName = opp.RecordType.Name;
                                      
            }
            else if(tsoEvent!=null && tsoEvent.WhatId!=null)
            {
                Opportunity opp = [Select Pricebook2Id, Pricebook2.Name,RecordTypeId,RecordType.Name from Opportunity where Id=:tsoEvent.WhatId];
                sRecordTypeName = opp.RecordType.Name;
            }
            options.add(new SelectOption('','Select Value'));
            /*if(sRecordTypeName == 'Renewal') { 
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
                options.add(new SelectOption('Services Labor Pool','Services Labor Pool'));
            } else if(sRecordTypeName == 'Med Touch Renewal') { 
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
                options.add(new SelectOption('Services Labor Pool','Services Labor Pool'));
            } else if(sRecordTypeName == 'Indirect') { 
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
                options.add(new SelectOption('Services Labor Pool','Services Labor Pool'));
            } else { 
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
            }
            */
            if(sRecordTypeName == 'New Opportunity')
            {
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
                options.add(new SelectOption('Education','Education'));
                options.add(new SelectOption('Support','Support'));
                options.add(new SelectOption('Time','Time'));
                options.add(new SelectOption('Mainframe Capacity','Mainframe Capacity'));
            }
            else
            {
                options.add(new SelectOption('Product','Product'));
                options.add(new SelectOption('Services','Services'));
                options.add(new SelectOption('Education','Education'));
            }
            return options;           
        }
        set;
    }

    public List<SelectOption> level2Items {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select Value'));

            if (selectedLevel1 != NULL && selectedLevel1 != '' && selectedLevel1 != 'Select Value') {
                disableBU = false;

                Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();
                List<Schema.PicklistEntry> entries = F.getPicklistValues();

                for(Schema.PicklistEntry entry : entries){
                    if(selectedLevel1 == 'Time')
                    {
                        if(entry.getValue() == 'Future FY Time' || entry.getValue() == 'Current FY Time')
                            options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }
                    else if(selectedLevel1 == 'Mainframe Capacity')
                    {
                        if(entry.getValue() == 'Mainframe Capacity')
                            options.add(new SelectOption(entry.getLabel(),entry.getValue()));    
                    }
                    else if(selectedLevel1 == 'Product' || selectedLevel1 == 'Services' || selectedLevel1 == 'Education' || selectedLevel1 == 'Support')
                    {
                        if(entry.getValue() != 'Future FY Time' && entry.getValue() != 'Current FY Time' && entry.getValue() != 'Mainframe Capacity')
                            options.add(new SelectOption(entry.getLabel(),entry.getValue()));
                    }   
                }            
            }else{
                disableBU = true;
            }

            return options;           
        }
        set;
    }    
    
    public List<SelectOption> level3Items {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','Select Value'));

            if((selectedLevel1 != NULL && selectedLevel1 != '' && selectedLevel1 != 'Select Value') && (selectedLevel2 != NULL && selectedLevel2 != '' && selectedLevel2 != 'Select Value')){               
                List<Product2> products = [select Name,Id from Product2 where Market_Focus_Area__c=:selectedLevel2 and family=:selectedLevel1 and IsActive=true order by Name];
                for(Product2 prod:products){
                    //options.add(new SelectOption(prod.Name,prod.Name));
                    options.add(new SelectOption(prod.Id,prod.Name));
                }
            }           
            return options;           
        }
        set;
    }
}