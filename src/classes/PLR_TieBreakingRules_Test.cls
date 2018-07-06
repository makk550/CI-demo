@isTest
private class PLR_TieBreakingRules_Test
{
    private static testMethod void Test_applyTieBreakingRules() 
    {
        // Initial settings
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        
        // Create record types
        lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
        RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Commercial Account');
        lstrec.add(rec1);
        RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFP', Name='CA Enterprise Account');
        lstrec.add(rec2);
        RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Account Team Covered Account');
        lstrec.add(rec3);
        RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFR', Name='Reseller/Distributor Account');
        lstrec.add(rec4);
        RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55o', Name='Territory Covered Account');
        lstrec.add(rec5);
        RecordTypes_Setting__c rec7 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55j', Name='SMB');
        lstrec.add(rec7);
        RecordTypes_Setting__c rec8 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFD', Name='Deal Registration');
        lstrec.add(rec8); 
        RecordTypes_Setting__c rec9 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFP', Name='Partner Opportunity');
        lstrec.add(rec9); 
        RecordTypes_Setting__c rec19 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaNO', Name='New Opportunity');
        lstrec.add(rec19); 
        RecordTypes_Setting__c rec11 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFN', Name='Acquisition');
        lstrec.add(rec11);          
        
        insert lstrec;


    // Create Queue group to use as Lead owner
        Group grp=new Group(Type = 'Queue',Name = 'Partner Lead Distribution');
        insert grp;  
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'Lead');
        
        // Set the user
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            insert mappingObject;
        }
    
    // Create accounts and add them to a list        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        List<account> AccountList = new List<account>();
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        account a = new account(name ='Test Account', recordtypeid =res);
        
        a.Region_Country__c='TBR_Test_Region_Country';
        
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='TBR_Test_Acc_Name'  ;
        a.Commercial_ID__c= 'TBR_Test_Comm_ID';
        a.Country_Picklist__c= 'USA';
        a.GEO__c= 'NA';
        a.Sales_Area__c= 'North_East';
        a.Sales_Region__c= 'North_America';
        a.Segment__c='TBR_Test_Acc_Segment';
        insert a;
        
        AccountList.add(a);
        
        system.assertNotEquals(null, a.id, 'Account not inserted');
        
        account a2 = new account(name ='Test Account2', recordtypeid =res);
        
        a2.Region_Country__c='TBR_Test_Region_Country';
        
        a2.customer_Category__c= 'Reseller';
        a2.hq__c= true;
        a2.Commercial_Account_Name__c='TBR_Test_Acc_Name'  ;
        a2.Commercial_ID__c= 'TBR_Test_Comm_ID';
        a2.Country_Picklist__c= 'USA';
        a2.GEO__c= 'NA';
        a2.Sales_Area__c= 'North_East';
        a2.Sales_Region__c= 'North_America';
        a2.Segment__c='TBR_Test_Acc_Segment';
        insert a2;
        
        AccountList.add(a2);
        
        system.assertNotEquals(null, a2.id, 'Account not inserted');
        System.Assert(AccountList != null && !AccountList.isEmpty());
                
    // Create an opportunity object with stageName = '100% - Contract Signed'
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();   
         
        id comopp = oppRecType.get('Deal Registration').getRecordTypeId();

        Opportunity opp = new Opportunity(Name = 'TBR_Test_opp1', recordtypeid=comopp);
        opp.AccountId = a.Id ; 
        opp.Reseller__c = a.Id ; 
        opp.CloseDate = system.today();
        opp.ReasonField__c = 'Luck';
        opp.stageName = '100% - Contract Signed';
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        opp.Created_from_Lead__c = 'TRUE';
        insert opp;
         
        Opportunity opp2 = new Opportunity(Name = 'TBR_Test_opp2', recordtypeid=comopp);
        opp2.AccountId = a2.Id ; 
        opp2.Reseller__c = a2.Id ; 
        opp2.CloseDate = system.today();
        opp2.ReasonField__c = 'Luck';
        opp2.stageName = '100% - Contract Signed';
        opp2.Type = 'Direct';
        opp2.Inside_Outside__c = 'Inside';
        opp2.Contract_Type__c = 'ELA';
        opp2.CurrencyIsoCode = 'USD';
        opp2.Created_from_Lead__c = 'TRUE';
        insert opp2;
         
        // Create the Lead objects and assign them to a list
        Schema.DescribeSObjectResult leadresult = Schema.SObjectType.Lead;        
        Map<String,Schema.RecordTypeInfo> leadRecType = leadresult.getRecordTypeInfosByName(); 
        Id CaIndirectLeadrecType = leadRecType.get('CA Indirect Lead').getRecordTypeId();
        
        RecordTypes_Setting__c rec = new RecordTypes_Setting__c();
        rec.SObject_Name__c = 'Lead';
        rec.RecordType_Id__c = String.valueOf(CaIndirectLeadrecType);
        rec.Name = 'CA Indirect Lead';
        insert rec;
        
        List<Lead> LeadList = new List<Lead>();
        
        for(Integer i = 0 ; i<2 ; i++) 
        {
            lead ld=new Lead(lastName = 'TBR_Test_LName'+i ,
                             Company = 'TBR_Test_Lead_Company',
                             RecordTypeId=CaIndirectLeadrecType,
                             EAID__c='L098704', 
                             Commercial_Account__c=a.id, 
                             mkto71_Lead_Score__c=45, 
                             CSU_Driver__c='API Gateway',
                             OwnerId=grp.id);
            
        	insert ld;
            LeadList.add(ld);
        }
//        insert LeadList ;

        System.Assert(LeadList != null && !LeadList.isEmpty());

        // Declare a map of leads to accounts
        Map<id,List<id>> LeadToAccountsMap = new Map<id,List<id>>();
        Map<id,id> Result2=new Map<id,id>();
        
        // Populate the map with accounts to each lead
        integer i = 0;
        for(Lead ld : LeadList)
        {
            integer count = 0;
            List<id> AccIdList = new List<id>();
            while(i < AccountList.size() && count < 4)
            {
                AccIdList.add(AccountList[i].id);
                i++;
                count++;
                                   
            }
            
            LeadToAccountsMap.put(ld.id, AccIdList);
            if( i == AccountList.size())
                break;
        }
       
        System.Assert(LeadToAccountsMap != null && !LeadToAccountsMap.isEmpty());
        
        // invoke applyTieBreakingRules()
        PLR_TieBreakingRules TieBrkRule = new PLR_TieBreakingRules();
        Map<id,id> ResultsMap = TieBrkRule.applyTieBreakingRules(LeadToAccountsMap); 
/* Removing this change in the test class. The test class was actually doing its job here to find the problem in the main class. 
 * I fixed  the main class to make sure always returns something in the ResultsMap.
 * So if the historical data is not available for applying the tie breaking rule then a partner is picked 
 * by default in order to break the tie.
        Map<id,id> ResultsMap2 = TieBrkRule.applyFinalTieBreakingRule(LeadToAccountsMap);    
        
        if(ResultsMap.isEmpty()){
            for(id ld_id:LeadToAccountsMap.keySet()){
                Result2.put(ld_id,LeadToAccountsMap.get(ld_id)[0]);
            }
           ResultsMap= Result2;
        }
*/        
        // The results map must be populated
        Boolean rmap=false,rempty=false;
        if(ResultsMap != null)
            rmap=true;
        
        if(!ResultsMap.isEmpty())
            rempty=true;
        
        System.Assert(rmap);
        System.Assert( rempty);
        System.Assert(ResultsMap != null && !ResultsMap.isEmpty());

        if ( ResultsMap != null && !ResultsMap.isEmpty() )
        {
            // The same number of lead IDs must be in both maps
            System.Assert(ResultsMap.keySet().size() == LeadToAccountsMap.keySet().size());
            
            // All the Lead IDs of the result map must contain all the leads IDs of the input map
            System.Assert(ResultsMap.keySet().containsAll(LeadToAccountsMap.keySet()));
             
            // All Lead IDs must have an associated Account ID.
            System.Assert(ResultsMap.keySet().size() == ResultsMap.values().size());
        }
        
        // invoke applyHistoricalCloseRateRule()
        Map<id, List<id>> HistTieResultsMap = TieBrkRule.applyHistoricalCloseRateRule(LeadToAccountsMap);

        if ( HistTieResultsMap != null && !HistTieResultsMap.isEmpty() )
        {
            // The same number of lead IDs must be in both maps
            System.Assert(HistTieResultsMap.keySet().size() == LeadToAccountsMap.keySet().size());
            
            // All the Lead IDs of the result map must contain all the leads IDs of the input map
            System.Assert(HistTieResultsMap.keySet().containsAll(LeadToAccountsMap.keySet()));
             
            // All Lead IDs must have an associated Account ID.
            System.Assert(HistTieResultsMap.keySet().size() == HistTieResultsMap.values().size());
        }

        // invoke applyFinalTieBreakingRule()
        ResultsMap = TieBrkRule.applyFinalTieBreakingRule(LeadToAccountsMap);
        
        // The results map must be populated
        System.Assert(ResultsMap != null && !ResultsMap.isEmpty());

        if ( ResultsMap != null && !ResultsMap.isEmpty() )
        {
            // The same number of lead IDs must be in both maps
            System.Assert(ResultsMap.keySet().size() == LeadToAccountsMap.keySet().size());
            
            // All the Lead IDs of the result map must contain all the leads IDs of the input map
            System.Assert(ResultsMap.keySet().containsAll(LeadToAccountsMap.keySet()));
             
            // All Lead IDs must have an associated Account ID.
            System.Assert(ResultsMap.keySet().size() == ResultsMap.values().size());
        }
        
        // invoke applyFinalTieBreakingRule()
        ResultsMap = TieBrkRule.applyFinalTieBreakingRule(HistTieResultsMap);
        
        // The results map must be populated
        System.Assert(ResultsMap != null && !ResultsMap.isEmpty());

        if ( ResultsMap != null && !ResultsMap.isEmpty() )
        {
            // The same number of lead IDs must be in both maps
            System.Assert(ResultsMap.keySet().size() == LeadToAccountsMap.keySet().size());
            
            // All the Lead IDs of the result map must contain all the leads IDs of the input map
            System.Assert(ResultsMap.keySet().containsAll(LeadToAccountsMap.keySet()));
             
            // All Lead IDs must have an associated Account ID.
            System.Assert(ResultsMap.keySet().size() == ResultsMap.values().size());
        }
        
        Map<id,List<id>> LeadToAccountsMapNoAccounts = new Map<id,List<id>>();
        for(Lead ld : LeadList)
        {
            List<id> AccIdList = new List<id>();
            
            LeadToAccountsMapNoAccounts.put(ld.id, AccIdList);
        }
       
        ResultsMap = TieBrkRule.applyTieBreakingRules(LeadToAccountsMapNoAccounts); 

        // The results map must be empty in this case
        System.Assert(ResultsMap == null || ResultsMap.isEmpty());

        // invoke applyHistoricalCloseRateRule()
        HistTieResultsMap = TieBrkRule.applyHistoricalCloseRateRule(LeadToAccountsMapNoAccounts);

        // The results map must be empty in this case
        System.Assert(HistTieResultsMap == null || HistTieResultsMap.isEmpty());

        // invoke applyFinalTieBreakingRule()
        ResultsMap = TieBrkRule.applyFinalTieBreakingRule(LeadToAccountsMapNoAccounts);
        
        // The results map must be populated
        System.Assert(ResultsMap == null || ResultsMap.isEmpty());

        // Clear the input map and test the error condition on all three methods
        LeadToAccountsMap.clear();
        
        ResultsMap = TieBrkRule.applyTieBreakingRules(LeadToAccountsMap);        
        System.Assert(ResultsMap == null || ResultsMap.isEmpty());
        
        HistTieResultsMap = TieBrkRule.applyHistoricalCloseRateRule(LeadToAccountsMap);        
        System.Assert(ResultsMap == null || ResultsMap.isEmpty());

        ResultsMap = TieBrkRule.applyFinalTieBreakingRule(LeadToAccountsMap);        
        System.Assert(ResultsMap == null || ResultsMap.isEmpty());        
    }
}