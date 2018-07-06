public with sharing class OpportunityPlanController {

    private Opportunity_Plan__c opl;
    public string AccId {set; get;}
    public string PlanId {set; get;}
    public string AccName {set; get;}
    
    private list<NCV_Driver_Info__c> drivers = new list<NCV_Driver_Info__c>();
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public OpportunityPlanController(ApexPages.StandardController stdController) {
        this.opl = (Opportunity_Plan__c)stdController.getRecord();
        PlanId = ApexPages.currentPage().getParameters().get('id');
        System.debug('OpportunityPlanController() called');

        if(AccName==null || AccName==''){
            list<Opportunity_Plan__c> lstPlansTmp = [Select Id,Account__c,Account__r.Name From Opportunity_Plan__c where id=:PlanId and IsDeleted=false];
            System.debug('lstPlansTmp: ' + lstPlansTmp.size());
            if(!lstPlansTmp.isEmpty()){
                AccId = lstPlansTmp[0].Account__c;
                AccName = lstPlansTmp[0].Account__r.Name;
            }
        }
    }
    
    public PageReference initPlan(){
        System.debug('initPlan() called');
        if(AccId==null)
            AccId = ApexPages.currentPage().getParameters().get('AccId');
        
        if(AccName==null)
            AccName = ApexPages.currentPage().getParameters().get('AccName');

        return setTheFormValues();
    }

    public PageReference setTheFormValues(){
        System.debug('setTheFormValues() called');
        if(PlanId==null && AccId!=null){
            list<Opportunity_Plan__c> lstPlans = [Select Id,Account__c,Account__r.Name From Opportunity_Plan__c where Account__c=:AccId and IsDeleted=false];

            if(lstPlans.isEmpty()){
                Opportunity_Plan__c newPlan = new Opportunity_Plan__c();
                newPlan.Account__c = AccId;
                newPlan.Name = ApexPages.currentPage().getParameters().get('AccName');
                insert newPlan;
                PlanId = newPlan.Id;
                this.opl = newPlan;
            }else{
                this.opl = lstPlans[0];
                PlanId = lstPlans[0].Id;
                AccId =  lstPlans[0].Account__c;
                AccName =  lstPlans[0].Account__r.Name;
            }
            
            PageReference OpportunityPlan = Page.OpportunityPlan;
            OpportunityPlan.getParameters().put('id', PlanId);
            OpportunityPlan.getParameters().put('AccId', AccId);
            OpportunityPlan.getParameters().put('AccName', EncodingUtil.urlEncode(AccName, 'UTF-8'));
                
            OpportunityPlan.setRedirect(true);
            return OpportunityPlan; 
        }else{
            
        }
        return null;        
    }
    public list<NCV_Driver_Info__c> getDrivers() {

        System.debug('getDrivers() called');
        
        Set<String> uniqueDriversSet = new Set<String>();
        for(NCV_Driver_Info__c driver:[Select NCV_Driver__c, Business_Unit__c From NCV_Driver_Info__c where Is_Active__c=true and IsDeleted=false order by BU_Sort_Order__c]){
            if(!uniqueDriversSet.contains(driver.Business_Unit__c)){
                uniqueDriversSet.add(driver.Business_Unit__c);
                drivers.add(driver);
                
            }
        }
        return drivers;
    }


    static testMethod void testOpportunityPlanController() {

        //Account acc = [select id,Name from account limit 1];
        RecordType[] recacc = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name in ('Account Team Covered Account')];//('Reseller/Distributor Account','CA Enterprise Account')];
        Account acc = new Account(Name='TestAcc1',Geo__c='NA',RecordTypeId=recacc[0].Id,Enterprise_Id__c='NAACC001',Enterprise_Account_Name__c='EAcc',Customer_Category__c='Reseller',Commercial_ID__c =   '12',Commercial_Account_Name__c = 'caName');
        
        insert acc;
        Opportunity_Plan__c newPlan = new Opportunity_Plan__c();
        newPlan.Account__c = acc.Id;
        newPlan.Name = acc.Name;
        insert newPlan;
                
        ApexPages.StandardController QController = new ApexPages.StandardController(newPlan);
        OpportunityPlanController qe = new OpportunityPlanController(QController);
        qe.AccId = acc.Id;
        qe.PlanId = newPlan.id;
        qe.AccName = acc.Name;
        qe.setTheFormValues();
        qe.initPlan();
        qe.getDrivers();
        qe = new OpportunityPlanController(QController);
        qe.AccId = acc.Id;
        qe.PlanId = null;
        qe.setTheFormValues();

        try{
        qe = new OpportunityPlanController(QController);
        qe.AccId = '000000000000000000';
        qe.PlanId = null;
        qe.setTheFormValues();
        }catch(Exception e){}
    }
}