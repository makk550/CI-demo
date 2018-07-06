@isTest(SeeAllData=true)
private class SplitPreProcessBatchTest {
    static testMethod void myUnitTest1() {
     user u1=new user(id='00530000003rQuJ');
    
   system.runas(u1){
         
        createProducts();
       
        createAccount();
        Test.startTest();
       
        createOpp();
        createOLI();
        createOTM();
        
        List<OpportunityTeamMember> otms = getOTMs();
        otms.add(otm);
              
        SplitPreProcessBatch b = new SplitPreProcessBatch();
        b.start(null);
        b.execute(null, otms);
        b.execute(null);
        b.finish(null);
        }
         Test.stopTest();
    }  

    public static Opportunity opp;
    public static Account act;
    public static Pricebook2 pb;
    public static Product2 p;
    public static PricebookEntry pbe;
    public static OpportunityLineItem oli;
    public static OpportunityTeamMember otm;

    public static void createProducts()
    {
        pb = [select id from Pricebook2 where IsStandard = true limit 1];
        
        p = new Product2();
        p.name = 'TestProduct1';
        p.IsActive = true;
        insert p;  
        
        pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Pricebook2Id = pb.Id;
        pbe.Product2Id = p.Id;
        pbe.UnitPrice = 10000;
        pbe.UseStandardPrice = false;
        insert pbe;
    }
    
    public static void createAccount()
    {
        try
        {
            act = new Account();
            act.Name = 'Test'; 
            insert act;
        }
        catch(Exception e)
        {
            System.debug(e);
        }       
    }
    
    public static void createOpp()
    {
        try
        {
            opp = new Opportunity();
            opp.Name = 'Test';
            opp.AccountId = act.Id;
            opp.CloseDate = Date.today();
            opp.StageName = getStageNames()[0];
            insert opp;
        }
        catch(Exception e)
        {
            System.debug(e);
        }                
    }

    public static void createOLI()
    {
        oli = new OpportunityLineItem();
        oli.PricebookEntryId = pbe.Id;
        oli.OpportunityId    = opp.Id;
        oli.Quantity = 1;
        oli.UnitPrice = pbe.UnitPrice; 
        insert oli;
    }
    
    public static void createOTM()
    {
        otm = new OpportunityTeamMember();      
        otm.UserId = UserInfo.getUserId();
        otm.OpportunityId = opp.Id;
        insert otm;
    }

    public static List<String> getStageNames()
    {
        List<String> stagesList = new List<String>();
        for(OpportunityStage os: [Select MasterLabel, IsClosed, IsWon, SortOrder 
                                    From OpportunityStage 
                                    WHERE IsActive = true
                                    ORDER BY SortOrder
                                    ]) {
            stagesList.add(os.MasterLabel);
        }
        return stagesList;      
    }
    
    public static List<OpportunityTeamMember> getOTMs()
    {
        String soql = 'select Id, User.PMFKey__c, UserId, TAQWhy__c, split0__LastSplitDate__c, ';
        soql = soql + 'TAQOA__c, TAQATA__c, ';
        soql = soql + 'TAQWhen__c, TAQAddl__c, ';
        soql = soql + 'TAQATA__r.TAQ_Account_Approved__r.Is_Latest_Record__c, TAQOA__r.Is_Latest_Record__c, ';
        soql = soql + 'OpportunityId, Opportunity.Id, Opportunity.AccountId, LastModifiedDate, Opportunity.LastModifiedDate, LastModifiedById, LastModifiedBy.Name ';
        soql = soql + ' from OpportunityTeamMember ';
        soql = soql + 'WHERE LastModifiedDate >= LAST_YEAR ';
        soql = soql + 'AND User.IsActive=true ';
        soql = soql + 'AND (';
        soql = soql + 'TAQATA__c = null OR ';
        soql = soql + 'TAQOA__c = null';
        soql = soql + ') ';
        soql = soql + 'order by OpportunityId LIMIT 1000';
        return Database.query(soql);        
    }       
}