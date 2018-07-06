public class OpportunityGridExt {

    private final Account account;
    public string AccountId {get; set;}
    public string EntId {get; set;}
    
    public string primAccountId {get; set;}
    public boolean isSecAcc {get; set;}
     
    public string planId {set; get;}
    public List<OpportunityGridBean> lstOpportunityGrid;
    private List<Opportunity> openOpps {set; get;}
    private List<OpportunityLineItem> lineItems  {set; get;}
    private List<CA_License__c> caLicenses  {set; get;}
    private Opportunity_Plan__c plan;
    public list<Opportunity_Plan_Detail__c> upcomingOpps {set; get;}

    public List<OpportunityGridBean> getlstOpportunityGrid(){
        return lstOpportunityGrid;
    }

    private void initAllLists(){

        openOpps = [Select Id from Opportunity where (AccountId=:AccountId or Account.ParentId=:AccountId or Account.Enterprise_Id__c =:EntId ) and IsClosed=false];

        lineItems = [Select OpportunityId,PricebookEntry.Product2.Solution_Sets__c  From OpportunityLineItem 
                    where (Opportunity.AccountId=:AccountId or Opportunity.Account.ParentId =:AccountId  or Opportunity.Account.Enterprise_Id__c =:EntId) and Opportunity.IsClosed=false];
             
        caLicenses = [Select Contract_Start__c, Contract_End__c, Contract_Version__c, Support_Version__c, Renewal_Date__c, Quantity__c, Purchase_Price__c, Purchase_Date__c, Product_Version__c, Product_Name__c, 
                    Opportunity_Plan_Detail__r.Opportunity_Plan__c, Opportunity_Plan_Detail__c, Operation_System__c, Name, NCV_Driver__c, 
                    Material_ID__c, Latest_Version__c, Latest_Product_Version__c,Opportunity_Plan_Detail__r.Opportunity_Plan__r.Account__c
                    From CA_License__c where Opportunity_Plan_Detail__r.Opportunity_Plan__r.Account__c=:AccountId];

        initOpenOppsCount();
    }
    
    private void initOppGrid(){
        upcomingOpps = [Select Opportunity_Plan__r.Account__c, Supporter_Contact2__c, Supporter_Contact1__c, Renewal_Date_2__c, 
        Renewal_Date_1__c, Opportunity__c, Opportunity_Question_1__c, Opportunity_Plan__c, Name, NCV_Driver_Info__r.NCV_Driver__c, NCV_Driver_Info__c,
        NCV_Driver_Info__r.Business_Unit__c, Id, Detractor_Contact2__c, Detractor_Contact1__c,  
        Competitor__c, Competitor_Question_2__c, Competitor_Question_1__c, Competitor_Name_2__c, Competitor_Name_1__c, Competitor_License2__c, 
        Competitor_License1__c, CA_License_Question_3__c, CA_License_Question_2__c, CA_License_Question_1__c, CA_License_Key_Contact__c 
        From Opportunity_Plan_Detail__c where Opportunity_Plan__c=:planId and isdeleted=false and NCV_Driver_Info__r.Is_Active__c=true order by NCV_Driver_Info__r.BU_Sort_Order__c];

        initAllLists();
        
        System.debug('upcomingOpps.size(): ' + upcomingOpps.size());

        lstOpportunityGrid = new List<OpportunityGridBean>();
        for(Opportunity_Plan_Detail__c pd:upcomingOpps){
            OpportunityGridBean bean =  new OpportunityGridBean(pd,openOpps,lineItems,caLicenses);

            if(uniqueOpps.containsKey(pd.NCV_Driver_Info__r.NCV_Driver__c.toUppercase())){
                String oppIdstmp = uniqueOpps.get(pd.NCV_Driver_Info__r.NCV_Driver__c.toUppercase());
                if(oppIdstmp!=null){
                    String[] oppIds = oppIdstmp.split(',');
                    if(oppIds!=null){
                        bean.OpenOppsCount = oppIds.size();
                    }
                }
            }else{
                bean.OpenOppsCount = 0;
            }

            if(bean.OpenOppsCount>0)
                bean.Opportunity = 'Yes';
            else
                bean.Opportunity = 'No';
            
            lstOpportunityGrid.add(bean);
        }       
    }
    
    Map<String,String> uniqueOpps = new Map<String,String>();
    private void initOpenOppsCount(){
        string NCVDriver = '';
        Integer OpenOppsCount = 0;
        string strOppId = '';
        string strKey = '';
        string strValue = '';
        string strValueTmp = '';
        for(OpportunityLineItem LineItem:lineItems){
            NCVDriver  = LineItem.PricebookEntry.Product2.Solution_Sets__c;
            strOppId = LineItem.OpportunityId;
            if(NCVDriver <> null)
                strKey = NCVDriver.toUppercase();
            strValue = strOppId;
            if(strkey <> '')
            {
            if(!uniqueOpps.containsKey(strKey)){
                uniqueOpps.put(strKey, strValue);
            }
            else
            {
                strValueTmp = uniqueOpps.get(strKey);
                if(!strValueTmp.contains(strValue)){
                    strValue = strValue + ', ' + strValueTmp;
                    uniqueOpps.put(strKey, strValue);
                }
            }
            }
        }
    }

    
    public PageReference save() {
        update plan;
        return null;
    }


    public OpportunityGridExt(ApexPages.StandardController stdController)
    {
        this.account = (Account)stdController.getRecord();

        AccountId = ApexPages.currentPage().getParameters().get('id'); //'00UQ0000001ZW6Y'; //
        if(AccountId==null)
           AccountId = account.Id;
        EntId = [Select Enterprise_ID__c from account where id=: accountId].Enterprise_ID__c;    
        getPrimAcc();
            
    }

   public void getPrimAcc() {
       isSecAcc =false;    
       Account acc=[select Enterprise_ID__c,Is_Primary_Account__c from Account where id=:AccountId limit 1 ];
        if(acc!=null && !acc.Is_Primary_Account__c && acc.Enterprise_ID__c!=null && acc.Enterprise_ID__c.trim()!=''){                  
               System.debug('Enterpriseid****'+ acc.Enterprise_ID__c);
               Account[] primAcc = [select id from Account where Enterprise_ID__c =:acc.Enterprise_ID__c and Is_Primary_Account__c = true ];
               if(primAcc!=null && primAcc.size()>0){
                isSecAcc =true;
                primAccountId = primAcc[0].Id;
                
               }              
            }
    }

    public PageReference initPlan(){
        List<Opportunity_Plan__c> lstPlans = [Select id,Account__c from Opportunity_Plan__c where Account__c=:AccountId limit 1];
        if(lstPlans.isEmpty()){
            Opportunity_Plan__c newPlan = new Opportunity_Plan__c();
            newPlan.Account__c = AccountId;
            newPlan.Name = account.Name;
            insert newPlan;
            planId = newPlan.Id;
            plan = newPlan;
        }else{
            plan = lstPlans[0];
            planId = lstPlans[0].Id;
        }
        initOppGrid();
        return null;
    }

   @isTest(SeeAllData=true)
    static void testOpportunityGridExt(){
    SystemIdUtility.skipOpportunityTriggers = true;
SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        Account newAcc = new Account();
        newAcc.Name = 'sample for testcase1';
        newAcc.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();
        newAcc.Customer_Category__c = 'Enterprise';
        newAcc.Commercial_Id__c = 'asdf';
        insert newAcc; 
        
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    
        
        Opportunity opp = new Opportunity();
        opp.Name = 'sample for testcase1';
        opp.AccountId = smbAcct.Id;
        opp.Reseller__c= newAcc.Id;
        //opp.RecordTypeId = SystemIdUtility.getIndirectVALUERecordTypeId();
       // opp.Ent_Comm_Account__c = [Select id from account where recordtypeid=:SystemIdUtility.getCommAcctRecordTypeId() limit 1].id;
        opp.StageName = Label.Opp_Stage_10_Percent;
        opp.CloseDate = Date.today();
        opp.CurrencyIsoCode = 'USD';
        insert opp;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.id;
        oli.PricebookEntryId = [select id from PricebookEntry where isactive=true and CurrencyIsoCode=:opp.CurrencyIsoCode limit 1].id;
        
        insert oli;
        
        Opportunity_Plan__c op = new Opportunity_Plan__c();
        op.Account__c = newAcc.Id;
        op.Name = newAcc.Name;
        insert op;
        
        NCV_Driver_Info__c driver  =  new NCV_Driver_Info__c();
        driver.NCV_Driver__c = 'Autosystest';
        driver.Business_Unit__c = 'Automation';
        insert driver;
                
        Opportunity_Plan_Detail__c opd = new Opportunity_Plan_Detail__c();
        opd.NCV_Driver_Info__c = driver.id;
        opd.Opportunity_Plan__c = op.Id;
        opd.Competitor_Question_1__c = '1';
        opd.Competitor_Name_1__c = 'sample';
        insert opd;
        
        CA_License__c newLicense = new CA_License__c();
        newLicense.Name = 'sample';
        newLicense.Opportunity_Plan_Detail__c = opd.Id;
        newLicense.Product_Version__c = '1';
        newLicense.Latest_Product_Version__c = '2';
        newLicense.Renewal_Date__c = Date.today();
        insert newLicense;

        ApexPages.StandardController QController = new ApexPages.StandardController(newAcc);
        OpportunityGridExt qe = new OpportunityGridExt(QController);
        qe.AccountId = newAcc.Id;
        qe.planId = op.Id;
        //Commented by danva01
        //qe.initPlan();
        //qe.getlstOpportunityGrid();
        //qe.save();

        delete newLicense;
        newLicense = new CA_License__c();
        newLicense.Name = 'sample2';
        newLicense.Opportunity_Plan_Detail__c = opd.Id;
        newLicense.Product_Version__c = null;
        newLicense.Latest_Product_Version__c = null;
        insert newLicense;        

       // qe.initPlan();

        newAcc = new Account();
        newAcc.Name = 'sample for testcase2';
        newAcc.Commercial_Id__c = 'test';
        newAcc.BillingStreet = 'Arlington';
        newAcc.BillingCountry = 'US';
        newAcc.BillingCity = 'VA'; 
        insert newAcc;
        QController = new ApexPages.StandardController(newAcc);
        qe = new OpportunityGridExt(QController);
        qe.EntId = 'na-ABcd01';
        qe.initPlan();

        OpportunityGridBean bean =  new OpportunityGridBean(opd,new List<Opportunity>(),
                                new List<OpportunityLineItem>(),
                                new List<CA_License__c>());
        bean.getlicenses();
    }    
    

}