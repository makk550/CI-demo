public with sharing class BUDriverDetailsController {

    public list<NCV_Driver_Info__c> drivers {set; get;}
    public list<CA_License__c> licenses {set; get;}
    public boolean isTest {set; get;}
    public string AccId {set; get;}
    public string EntId {set; get;}
    public string ncvId {set; get;}
    public string planId {set; get;}
    public string planDetailId {set; get;}
    public string Bu {set; get;}
    public string strDriver {set; get;}
//    public boolean showSaveButton {set; get;}
    public boolean hasLicenses {set; get;}
    public boolean hasErrors {set; get;}
    public Integer oppCount {set; get;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    private  Opportunity_Plan_Detail__c opl;
    public BUDriverDetailsController(ApexPages.StandardController stdController) {
        isTest  = false;
        this.opl = (Opportunity_Plan_Detail__c)stdController.getRecord();
        //initCompIcon(); 
           planDetailId = ApexPages.currentPage().getParameters().get('id');
        AccId = ApexPages.currentPage().getParameters().get('AccId');
       try{ EntId = [Select Enterprise_id__c from Account where id = :AccId ].Enterprise_id__c;
       }
       catch(exception ex)
       {
        entid = 'NA-test';
       }
        ncvId = ApexPages.currentPage().getParameters().get('ncvId');
        planId = ApexPages.currentPage().getParameters().get('planId');
        Bu = ApexPages.currentPage().getParameters().get('BU');
        strDriver = ApexPages.currentPage().getParameters().get('Driver');
        initDrivers();
//        if(opl!=null && opl.Id!=null)
//            showSaveButton = true;
//        else
//            showSaveButton = false;
            
        if(planDetailId!=null){
            initLicenses();
        }
        initOppCount();
        hasErrors = false;    
     
    }
    
    public string CompetitorLicenseIcon = '';
        
    public string getCompetitorLicenseIcon(){
        CompetitorLicenseIcon = 'grey';
        if(opl!=null){
            String strComp1 = opl.Competitor_Name_1__c;
            String strComp2 = opl.Competitor_Name_2__c;
            
            if((strComp1==null || strComp1.toUpperCase()=='CHOOSE ONE') && (strComp2==null  || strComp2.toUpperCase()=='CHOOSE ONE')){
                CompetitorLicenseIcon = 'grey';        
            }else if(strComp1=='No Competitor' && (strComp2==null || strComp2=='Choose one' || strComp2=='No Competitor')){
                CompetitorLicenseIcon = 'green';        
            }else if( 
                    (strComp1!=null || strComp1!='No Competitor' || strComp1 !='Choose one' ) || 
                    (strComp2!=null || strComp2!='No Competitor' ||  strComp2 !='Choose one')
                    ){
                CompetitorLicenseIcon = 'red';        
            }
        }
        return CompetitorLicenseIcon;
    }
        
    private void initOppCount(){
    
        List<Opportunity> openOpps;
        if(SystemIdUtility.isTest)
                openOpps = [Select Id from Opportunity where (AccountId=:AccId OR Account.ParentId =: AccId or Account.Enterprise_id__c =:EntId) and IsClosed=false limit 10];
        else
                openOpps = [Select Id from Opportunity where (AccountId=:AccId OR Account.ParentId =: AccId or Account.Enterprise_id__c =:EntId) and IsClosed=false];
       
        List<OpportunityLineItem> lineItems ;
        if(SystemIdUtility.isTest)
                lineItems = [Select Opportunity.AccountId,  PricebookEntry.Product2.Solution_Sets__c  From OpportunityLineItem 
                where Opportunity.AccountId=:AccId OR Opportunity.Account.ParentId =: AccId limit 10];
        else
                lineItems = [Select Opportunity.AccountId,  PricebookEntry.Product2.Solution_Sets__c  From OpportunityLineItem 
                where (Opportunity.AccountId=:AccId OR Opportunity.Account.ParentId =: AccId or opportunity.Account.Enterprise_id__c =:EntId) and Opportunity.IsClosed=false ];
    
        oppCount = 0;
        for(Opportunity opp:openOpps){
            Map<String,String> uniqueDrivers = new Map<String,String>();
            for(OpportunityLineItem LineItem:lineItems){
                if(opp.Id==LineItem.OpportunityId){
                    if(strDriver==LineItem.PricebookEntry.Product2.Solution_Sets__c){
                        if(!uniqueDrivers.containsKey(strDriver)){
                            uniqueDrivers.put(strDriver, strDriver);
                            oppCount++;
                        }
                    }
                }
            }
        }
        
    }
    
    public void initLicenses(){
    
        if(isTest == true)
            licenses = [Select Site_ID__c, Material_Code__c, Contract_Number__c, Contract_Version__c, 
            Support_Version__c, Contract_Start__c, Contract_End__c, License_Type__c, Renewal_Date__c, Quantity__c, Purchase_Price__c, Purchase_Date__c, Product_Version__c, Product_Name__c, 
            OwnerId, Opportunity_Plan_Detail__c, Operation_System__c, Name, NCV_Driver__c, Material_ID__c, Latest_Version__c, 
            Latest_Product_Version__c, IsDeleted, Id From CA_License__c where Opportunity_Plan_Detail__c=:planDetailId limit 10];
        else
            licenses = [Select Site_ID__c, Material_Code__c, Contract_Number__c, Contract_Version__c, 
            Support_Version__c, Contract_Start__c, Contract_End__c, License_Type__c, Renewal_Date__c, Quantity__c, Purchase_Price__c, Purchase_Date__c, Product_Version__c, Product_Name__c, 
            OwnerId, Opportunity_Plan_Detail__c, Operation_System__c, Name, NCV_Driver__c, Material_ID__c, Latest_Version__c, 
            Latest_Product_Version__c, IsDeleted, Id From CA_License__c where Opportunity_Plan_Detail__c=:planDetailId];
            
        if(licenses.isEmpty())
            hasLicenses = false;
        else
            hasLicenses = true;
    }
    
    public PageReference initPlanDetails(){
        ncvId = ApexPages.currentPage().getParameters().get('ncvId');
        planId = ApexPages.currentPage().getParameters().get('planId');     
        planDetailId = ApexPages.currentPage().getParameters().get('id');
        AccId = ApexPages.currentPage().getParameters().get('AccId');
        return setTheFormValues();
    }
    
    public PageReference setTheFormValues(){

        if(planDetailId==null && ncvId!=null && planId!=null){
            list<Opportunity_Plan_Detail__c> lstPlanDetail = [Select Detractor_Contact1__c, Detractor_Contact2__c, Supporter_Contact1__c, Supporter_Contact2__c, Renewal_Date_2__c, Renewal_Date_1__c, 
                Opportunity__c, Competitor__c, Opportunity_Question_1__c, Competitor_License1__c, Competitor_License2__c, Opportunity_Plan__c, Name, NCV_Driver_Info__c, IsDeleted, Id, Detractor2__c, 
                Detractor1__c, Competitor_Question_2__c, Competitor_Question_1__c, Competitor_Name_2__c, Competitor_Name_1__c, 
                CA_License_Question_3__c, CA_License_Question_2__c, CA_License_Question_1__c, Competitor_Product1__c, Competitor_Product2__c 
                From Opportunity_Plan_Detail__c
                where NCV_Driver_Info__c=:ncvId and Opportunity_Plan__c=:planId];

            if(lstPlanDetail.isEmpty()){
                Opportunity_Plan_Detail__c newPlanDetail = new Opportunity_Plan_Detail__c();
                newPlanDetail.NCV_Driver_Info__c = ncvId;
                newPlanDetail.Opportunity_Plan__c = planId;
                insert newPlanDetail;
                planDetailId = newPlanDetail.Id;
                this.opl = newPlanDetail;
            }else{
                this.opl = lstPlanDetail[0];
                planDetailId = lstPlanDetail[0].Id;
            }
            
            PageReference BUDriverDetails = Page.BUDriverDetails;
            BUDriverDetails.getParameters().put('id', planDetailId);
            BUDriverDetails.getParameters().put('BU', Bu);
            BUDriverDetails.getParameters().put('ncvId', ncvId);
            BUDriverDetails.getParameters().put('planId', planId);
            BUDriverDetails.getParameters().put('Driver', strDriver);
            BUDriverDetails.getParameters().put('AccId', AccId);
            BUDriverDetails.setRedirect(true);
            return BUDriverDetails; 
        }else{
            return null;
        }
    }
    
    public PageReference save() {
        try{
            update opl;
            //initCompIcon();
        }
        catch (DmlException de){
            System.debug('Data exception:'+ de.getMessage());
            if(de.getDmlStatusCode(0)=='INSUFFICIENT_ACCESS_OR_READONLY'){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges, you must have edit rights on the account to edit the CILL.');
                ApexPages.addMessage(myMsg);
//            }else{
//                ApexPages.addMessages(de);
                hasErrors = true;
            }
//            hasErrors = true;
            return null;
        }
        return null;
    }

     //anssa01:- Add to read the TopCompetitor PickList values without '-None-'
    public List<SelectOption> getCompetitor1()
    {
      List<SelectOption> statusValues = new List<SelectOption>(); 
      Schema.DescribeFieldResult F = Opportunity_Plan_Detail__c.Competitor_Name_1__c.getDescribe();
      List<Schema.PicklistEntry> P = F.getPicklistValues();
      for(Schema.PicklistEntry pEntry :p)
      {
            statusValues.add( new SelectOption(pEntry.getValue(),pEntry .getLabel()));
      }
      return statusValues;
    }
    public List<SelectOption> getCompetitor2()
    {
      List<SelectOption> statusValues = new List<SelectOption>(); 
      Schema.DescribeFieldResult F = Opportunity_Plan_Detail__c.Competitor_Name_2__c.getDescribe();
      List<Schema.PicklistEntry> P = F.getPicklistValues();
      for(Schema.PicklistEntry pEntry :p)
      {
            statusValues.add( new SelectOption(pEntry.getValue(),pEntry .getLabel()));
      }
      return statusValues;
    }
  
    private void initDrivers() {
        drivers = new list<NCV_Driver_Info__c>();
        Set<String> uniqueDriversSet = new Set<String>();
        for(NCV_Driver_Info__c driver:[Select Id,NCV_Driver__c, Business_Unit__c From NCV_Driver_Info__c where Is_Active__c=true and IsDeleted=false and Business_Unit__c=:Bu]){
            if(!uniqueDriversSet.contains(driver.NCV_Driver__c)){
                uniqueDriversSet.add(driver.NCV_Driver__c);
                drivers.add(driver);
            }
        }
    }
    

    static testMethod void testBUDriverDetailsController() {
        
       // Account acc = [select id,Name from account limit 1];
       RecordType[] recacc = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name in ('Account Team Covered Account')];//('Reseller/Distributor Account','CA Enterprise Account')];
        Account acc = new Account(Name='TestAcc1',Geo__c='NA',RecordTypeId=recacc[0].Id,Enterprise_Id__c='NAACC001',Enterprise_Account_Name__c='EAcc',Customer_Category__c='Reseller',Commercial_ID__c =   '12',Commercial_Account_Name__c = 'caName');
        
        insert acc;
        Opportunity_Plan__c newPlan = new Opportunity_Plan__c();
        newPlan.Account__c = acc.Id;
        newPlan.Name = acc.Name;
        insert newPlan;

        NCV_Driver_Info__c driver  =  new NCV_Driver_Info__c();
        driver.NCV_Driver__c = 'Autosystest';
        driver.Business_Unit__c = 'Automation';
        insert driver;
        
        Opportunity_Plan_Detail__c newPlanDetail = new Opportunity_Plan_Detail__c();
        newPlanDetail.NCV_Driver_Info__c = driver.Id;
        newPlanDetail.Opportunity_Plan__c = newPlan.Id;
        insert newPlanDetail;
        
        SystemIdUtility.isTest = true;                 
              
       
        ApexPages.StandardController QController = new ApexPages.StandardController(newPlanDetail);
        
        BUDriverDetailsController qe= new BUDriverDetailsController(QController);
        qe.setTheFormValues();
        qe.isTest = true;
        qe.initOppCount();
        qe.AccId = acc.Id;
        qe.PlanId = newPlan.id;
        qe.ncvId = driver.Id;
        qe.setTheFormValues();
        qe.initPlanDetails();
        qe.initLicenses();
        qe.getCompetitorLicenseIcon();
        qe.getCompetitor1();
        qe.getCompetitor2();
        qe.save();
        try{
        qe = new BUDriverDetailsController(QController);
        qe.AccId = acc.Id;
        qe.PlanId = newPlan.id;
        qe.ncvId = '000000000000000000';
        qe.setTheFormValues();        
        }catch(Exception e){}        
    }
        
}