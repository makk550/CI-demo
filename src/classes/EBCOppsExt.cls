public class EBCOppsExt{

    private Account account;
    public string AccountId {set; get;}
    public List<Opportunity> opps {set; get;}
    Set<String> oppStages = new Set<String>{Label.Opp_Stage_Closed_Won,Label.Opp_Stage_Closed_Lost};
  
    
   

    
    public EBCOppsExt(ApexPages.StandardController stdController) {
        this.account= (Account)stdController.getRecord();
        if(account!=null){
            AccountId = account.Id;
            opps = [select Id, IsClosed, Opportunity_Number__c, name, StageName, closedate, amount from opportunity where accountid=:AccountId and Sales_Milestone_Search__c NOT IN:oppStages order by name];
                    }
    }
   
    @isTest(SeeAllData=true)
    public static void EBCOppsExt_test() {
               
        Account acc2 = new Account(Name='Test_Acc1',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert acc2;                
        
        //Opportunity opp = [Select Id, AccountId from Opportunity where AccountId != null LIMIT 1];
        //Account acc = [Select Id from Account where Id = :opp.AccountId LIMIT 1];
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc2);
        EBCOppsExt c = new EBCOppsExt(stdController); 
    }
}