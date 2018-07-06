public with sharing class AccountOverviewExt {

    public string planId {set; get;}
    public string AccountId {set; get;}
    public string AccName {set; get;}
    public List<OpportunityGridBean> lstOpportunityGrid;
    private List<Opportunity> openOpps {set; get;}
    private List<OpportunityLineItem> lineItems  {set; get;}
    private List<CA_License__c> caLicenses  {set; get;}
    private Opportunity_Plan__c plan;
    public list<Opportunity_Plan_Detail__c> upcomingOpps {set; get;}
    public boolean hasErrors {set; get;}
    Map<String,Integer> uniqueDrivers = new Map<String,Integer>();
     //raosu03 
    private List<SelectOption> statusValues= new List<SelectOption>(); 
    public string Status {set;get;}
    public string Ent_id{set;get;}

    public AccountOverviewExt(ApexPages.StandardController stdController) {
        this.plan = (Opportunity_Plan__c)stdController.getRecord();
        planId = plan.id;
        AccountId = plan.Account__c;
        Account acc_temp = [select Name, Enterprise_ID__c from Account where id=:plan.Account__c];
        AccName = acc_temp.Name;
        Ent_id = acc_temp.Enterprise_Id__c;
        
        initOppGrid();
        hasErrors = false;      
    }

    public List<OpportunityGridBean> getlstOpportunityGrid(){
        return lstOpportunityGrid;
    }

    private void initAllLists(){

        openOpps = [Select Id from Opportunity where (AccountId=:AccountId or Account.ParentId=:AccountId or Account.Enterprise_id__c =: Ent_id)  and IsClosed=false];

        lineItems = [Select OpportunityId,PricebookEntry.Product2.Solution_Sets__c  From OpportunityLineItem 
                    where (Opportunity.AccountId=:AccountId or Opportunity.Account.ParentId=:AccountId or Opportunity.Account.Enterprise_id__c=:Ent_id) and Opportunity.IsClosed=false];
             
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

        lstOpportunityGrid = new List<OpportunityGridBean>();
        integer OpenOppsCount = 0;
        for(Opportunity_Plan_Detail__c pd:upcomingOpps){
            OpportunityGridBean bean =  new OpportunityGridBean(pd,openOpps,lineItems,caLicenses);

            if(uniqueOpps.containsKey(pd.NCV_Driver_Info__r.NCV_Driver__c.toUpperCase())){
                String oppIdstmp = uniqueOpps.get(pd.NCV_Driver_Info__r.NCV_Driver__c.toUpperCase());
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
            strKey = NCVDriver.toUpperCase();
            strValue = strOppId;
            if(!uniqueOpps.containsKey(strKey)){
                uniqueOpps.put(strKey, strValue);
            }else{
                strValueTmp = uniqueOpps.get(strKey);
                if(!strValueTmp.contains(strValue)){
                    strValue = strValue + ', ' + strValueTmp;
                    uniqueOpps.put(strKey, strValue);
                }
            }
        }
    }
    
    public PageReference save() {
        try{
            update plan;
            return null;
        }
        catch (DmlException de){
            System.debug('Data exception:'+ de.getMessage());
            if(de.getDmlStatusCode(0)=='INSUFFICIENT_ACCESS_OR_READONLY'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges, you must have edit rights on the account to edit the CILL.');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.addMessages(de);
            }
            hasErrors = true;
            return null;
        }        
    }
    
    static testmethod void testAccountOverviewExt(){
        //Account acc = [select id,Name from account limit 1];
        RecordType[] recacc = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name in ('Territory Covered Account')];//('Reseller/Distributor Account','CA Enterprise Account')];
        Account acc = new Account(Name='TestAcc1',Geo__c='NA',RecordTypeId=recacc[0].Id,Enterprise_Id__c='NAACC001',Enterprise_Account_Name__c='EAcc',Customer_Category__c='Reseller',Commercial_ID__c =   '12',Commercial_Account_Name__c = 'caName');
        
        insert acc;
        Opportunity_Plan__c newPlan = new Opportunity_Plan__c();
        newPlan.Account__c = acc.Id;
        newPlan.Name = acc.Name;
        insert newPlan;
        ApexPages.StandardController QController = new ApexPages.StandardController(newPlan);
        AccountOverviewExt qe = new AccountOverviewExt(QController);
        qe.getlstOpportunityGrid();
        qe.save();
        qe.getTopCompetitor();
    }    
    
    //raosu03:- Add to read the TopCompetitor PickList values without '-None-'
    public List<SelectOption> getTopCompetitor()
    {
      Schema.DescribeFieldResult F = Opportunity_Plan__c.Top_Competitor__c.getDescribe();
      List<Schema.PicklistEntry> P = F.getPicklistValues();
      for(Schema.PicklistEntry pEntry :p)
      {
            statusValues.add( new SelectOption(pEntry.getValue(),pEntry .getLabel()));
             if(pEntry.isDefaultValue() )
                 Status = pEntry.getValue();       
      }
      return statusValues;
    }
    
}