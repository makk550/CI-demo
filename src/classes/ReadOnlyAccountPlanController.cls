public class ReadOnlyAccountPlanController {
    public boolean showAccountPlanPanel {get; set;}  
    public boolean ShowAccountPlanNotFoundPanel {get; set;}  
    public string errorMessage{get; set;} 
    public Account_Plan__c ap{get; set;}
    public Account account{get; set;}
    
    public ReadOnlyAccountPlanController(ApexPages.StandardController stdController) {
        this.account = (Account)stdController.getRecord();
    }
    public ReadOnlyAccountPlanController()
    {}
    public PageReference init() { 
        //initialize variables 
        showAccountPlanPanel=false; 
        ShowAccountPlanNotFoundPanel=false; 
        errorMessage=null;
        ap=null;
        
        //get the account id from the query string          
        //string accountId=ApexPages.currentPage().getParameters().get('accId'); 
        
        //check if the user has supplied an account Id 
        if(account==null)
        {
            errorMessage='No Account Information Found!';
            ShowAccountPlanNotFoundPanel=true;
        }
        //check if the account id supplied is valid
        else
        {
            List<Account_Plan__c> accountPlans=[Select Id,Name,Customer_s_Contact_Consulted_For_Plan__c,Customer_s_Contact_Consulted_For_Plan__r.Name,ELA_Renewal_Date__c,
            Customer_s_Budget_Cycle_End_Date__c,Key_Business_Problems__c,Key_Client_Sponsor__c,Key_Client_Sponsor__r.Name, Account_Goals__c,Customer_s_competitive_landscape__c,
            Customer_Competitive_Strategy__c,Identified_IT_projects_w_IT_Init__c,Identify_Customer_s_Mission_critical_app__c,Key_Company_Directives__c,
            Key_Trends_Risks_Regulatory_Issues__c,Plan_FY_NCV_Product_Sales_Goal__c,Plan_FY_Renewal_Revenue_Goals__c,Plan_FY_Services_Sales_Goal__c,
            Plan_Status__c,Potential_Barriers__c,Where_Will_CA_Provide_the_Most_Value__c,Default_Plan__c                
            from Account_Plan__c where Account__c=:account.Id];
            //no account plan associated to account
            if(accountPlans.size()==0)
            {
                errorMessage='No Account Plan Information Found!';
                ShowAccountPlanNotFoundPanel=true;
            }
            else if(accountPlans.size()==1)
            {
                ap=accountPlans[0];
                showAccountPlanPanel=true;
            }
            else
            {
                Integer defaultPlanCount=0;
                for(Account_Plan__c aaccPlan:accountPlans)
                {
                    if(aaccPlan.Default_Plan__c==true)
                    {
                        defaultPlanCount++;
                        ap=aaccPlan;
                    }
                }
                if(defaultPlanCount==0)
                {
                    errorMessage='No Account Plan is Set As Default!';
                    ShowAccountPlanNotFoundPanel=true;
                }
                else if(defaultPlanCount==1)
                {
                    showAccountPlanPanel=true;
                }
                else
                {
                    errorMessage='Multiple Account Plans Set As Default!';
                    ShowAccountPlanNotFoundPanel=true;
                }
            }            
        }
        
        return null;
    }
    //**************************** test methods start here **************************************//
    static testMethod void testNullAccScenario() { 
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        Test.startTest();
        curApController.init();
        Test.stopTest();
    }   

    static testMethod void testInvalidAccScenario() {               
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        Test.startTest();
        curApController.init();
        Test.stopTest();            
    }
        
    static testMethod void testSingleAccScenario() {        
        // create a test account
        Account acc = new Account();
        acc.Name = 'testAcc';
        acc.BillingState = 'NY';
        acc.Commercial_Id__c = 'test';
                acc.BillingStreet = 'Arlington';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'VA';
        insert acc;
        
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        curApController.account=acc;
        Test.startTest();
        curApController.init();
        Test.stopTest();            
    }
    
    static testMethod void testSingleMatchAPScenario() {
        // create a test account 1st
        Account acc1 = new Account();
        acc1.Name = 'testAcc';
        acc1.BillingState = 'NY';
        acc1.Commercial_Id__c = 'test';
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;

        // create a test account plan
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'Acc Plan';
        ap.Account__c = acc1.Id; 
        ap.Plan_Status__c = 'Draft';
        insert ap;
        
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        curApController.account=acc1;
        Test.startTest();
        curApController.init();
        Test.stopTest();            
    }
    
    static testMethod void testMultiMatchAPScenario1() {
        // create a test account 1st
        Account acc1 = new Account();
        acc1.Name = 'testAcc';
        acc1.BillingState = 'NY';
        acc1.Commercial_Id__c = 'test';
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;

        

        // create a test account plan
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'Acc Plan';
        ap.Account__c = acc1.Id; 
        ap.Plan_Status__c = 'Draft';
        insert ap;

        // create another test account plan
        Account_Plan__c ap1 = new Account_Plan__c();
        ap1.Name = 'Acc Plan';
        ap1.Account__c = acc1.Id; 
        ap1.Plan_Status__c = 'Draft';
        insert ap1;
        
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        curApController.account=acc1;
        Test.startTest();
        curApController.init();
        Test.stopTest();            
        }
    
        static testMethod void testMultiMatchAPScenario2() {
        // create a test account 1st
        Account acc1 = new Account();
        acc1.Name = 'testAcc';
        acc1.BillingState = 'NY';
        acc1.Commercial_Id__c = 'test';
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;

        // create a test account plan
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'Acc Plan';
        ap.Account__c = acc1.Id; 
        ap.Plan_Status__c = 'Draft';
        ap.Default_Plan__c = true;
        insert ap;

        // create another test account plan
        Account_Plan__c ap1 = new Account_Plan__c();
        ap1.Name = 'Acc Plan';
        ap1.Account__c = acc1.Id; 
        ap1.Plan_Status__c = 'Draft';
        ap1.Default_Plan__c = true;
        insert ap1;
        
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        Test.startTest();
        curApController.init();
        Test.stopTest();            
    }
        static testMethod void testMultiMatchAPScenario3() {
        // create a test account 1st
        Account acc1 = new Account();
        acc1.Name = 'testAcc';
        acc1.BillingState = 'NY';
        acc1.Commercial_Id__c = 'test';
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;

        // create a test account plan
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'Acc Plan';
        ap.Account__c = acc1.Id; 
        ap.Plan_Status__c = 'Draft';
        insert ap;

        // create another test account plan
        Account_Plan__c ap1 = new Account_Plan__c();
        ap1.Name = 'Acc Plan';
        ap1.Account__c = acc1.Id; 
        ap1.Plan_Status__c = 'Draft';
        ap1.Default_Plan__c = true;
        insert ap1;
        
        PageReference page = new PageReference('/apex/ReadOnlyAccountPlan');
        Test.setCurrentPage(page);
        
        // create a new instace    
        ReadOnlyAccountPlanController curApController = new ReadOnlyAccountPlanController();
        curApController.account=acc1;
        Test.startTest();
        curApController.init();
        Test.stopTest();            
    }
}