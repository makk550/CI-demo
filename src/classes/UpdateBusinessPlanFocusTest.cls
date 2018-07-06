@isTest(seeAllData=true)
public class UpdateBusinessPlanFocusTest{
    public static testMethod void BusinessPlanTest(){
        //ID COMM = [Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
        RecordTypes_Setting__c SMB_RT = RecordTypes_Setting__c.getValues('SMB');
        Account acc = new Account();
        acc.Name = 'reselleracc';
        acc.BillingState = 'NY';
        acc.Region_Country__c = 'JP';
        acc.Alliance__c = true;
        acc.Alliance_Program_Level__c = 'Advanced';
        acc.Service_Provider__c = false;
        acc.Service_Provider_Program_level__c = 'Advanced';
        acc.Solution_Provider__c = true;
        acc.Solution_Provider_Program_Level__c = 'Advanced';
        acc.Velocity_Seller__c = true;
        acc.Velocity_Seller_Program_Level__c = 'Advanced';
        acc.Commercial_Id__c = 'asdf';
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='New York';
        acc.recordtypeid=SMB_RT.RecordType_Id__c;     
        acc.Reseller_Disti_Regional_ID__c = 'Test';   
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.accountid = acc.id;
        opp.Reseller__c= acc.id;
        opp.name = 'test';
        opp.stagename = Label.Opp_Stage_10_Percent;
        opp.CloseDate = date.today();
        opp.Type = '1 Tier';
        opp.Partner_Engagement__c = 'test';
        opp.StageName = Label.Opp_Stage_10_Percent;
        SystemIdUtility.skipOpportunityTriggers = true;
        insert opp;
        
        
        
        Set<Id> OppIdSet = new Set<Id>();
        OppIdSet.add(opp.Id);
        //UpdateBusinessPlanFocus UBPF = new UpdateBusinessPlanFocus();
        
        
        Product2 prd1 = new Product2(Name='2E',Family='Product',Product_Group__c='2E',Market_Focus_Area__c='SECURITY',IsActive=true);
        insert prd1;
        
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry pbe = new PricebookEntry(Product2Id=prd1.Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        insert pbe; 
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id);
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        insert oli1;
        
        
        Route_To_Market__c rtm = new Route_To_Market__c();
        rtm.Account__c = acc.Id;
        rtm.RTM__c = 'Solution Provider';
        insert rtm;
        
        Product_Alignment__c  objPAl1 = new Product_Alignment__c(Product_Group__c='Capacity Manager',Product_Group_MPL__c='TestSiteMinder1',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        Product_Alignment__c  objPAl2 = new Product_Alignment__c(Product_Group__c='2E',Product_Group_MPL__c='TestSiteMinder2',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        List<Product_Alignment__c> lstprodalignment = new List<Product_Alignment__c>();
        
        lstprodalignment.add(objPAl1);
        lstprodalignment.add(objPAl2);
        insert lstprodalignment;
        
        UpdateBusinessPlanFocus.LogicTriggeredFromOpportunity(OppIdSet);
        opp.Type = 'MSP';
        opp.Cloud_Platform__c = 'Internal Use';
        update opp;
        UpdateBusinessPlanFocus.LogicTriggeredFromOpportunity(OppIdSet);
        
        opp.Type = 'DM';
        opp.Cloud_Platform__c = 'Internal Use';
        update opp;
        UpdateBusinessPlanFocus.LogicTriggeredFromOpportunity(OppIdSet);
        Set<Id> OppLineItemIdSet = new Set<Id>();
        OppLineItemIdSet.add(oli1.Id);
        UpdateBusinessPlanFocus.LogicTriggeredFromOpportunityLineItem(OppLineItemIdSet);
        Set<Id> SolutionProviderAccountIdSet = new Set<Id>();
        SolutionProviderAccountIdSet.add(opp.Reseller__c);
        Map<String,Boolean> ProdGroup_BPFValue_Map = new Map<String,Boolean>();
        ProdGroup_BPFValue_Map.put('Capacity Manager',true);
        ProdGroup_BPFValue_Map.put('2E',true);
        UpdateBusinessPlanFocus.LogicTriggeredFromProductAlignment(SolutionProviderAccountIdSet,null,null,ProdGroup_BPFValue_Map);
        Set<Id> ServiceProviderAccountIdSet = new Set<Id>();
        ServiceProviderAccountIdSet.add(opp.Reseller__c);
        UpdateBusinessPlanFocus.LogicTriggeredFromProductAlignment(null,ServiceProviderAccountIdSet,null,ProdGroup_BPFValue_Map);
        Set<Id> DataManagementAccountIdSet = new Set<Id>();
        DataManagementAccountIdSet.add(opp.Reseller__c);
        UpdateBusinessPlanFocus.LogicTriggeredFromProductAlignment(null,null,DataManagementAccountIdSet,ProdGroup_BPFValue_Map);
        
    }
    public static testMethod void testBusinessPlanBatch1(){
        RecordTypes_Setting__c SMB_RT = RecordTypes_Setting__c.getValues('SMB');
        Account acc = new Account();
        acc.Name = 'reselleracc';
        acc.BillingState = 'NY';
        acc.Region_Country__c = 'JP';
        acc.Alliance__c = true;
        acc.Alliance_Program_Level__c = 'Advanced';
        acc.Service_Provider__c = false;
        acc.Service_Provider_Program_level__c = 'Advanced';
        acc.Solution_Provider__c = true;
        acc.Solution_Provider_Program_Level__c = 'Advanced';
        acc.Velocity_Seller__c = true;
        acc.Velocity_Seller_Program_Level__c = 'Advanced';
        acc.Commercial_Id__c = 'asdf';
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='New York';
        acc.recordtypeid=SMB_RT.RecordType_Id__c;     
        acc.Reseller_Disti_Regional_ID__c = 'Test';   
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.accountid = acc.id;
        opp.Reseller__c= acc.id;
        opp.name = 'test';
        opp.stagename = Label.Opp_Stage_10_Percent;
        opp.CloseDate = date.today();
        opp.Type = '1 Tier';
        opp.Partner_Engagement__c = 'test';
        opp.StageName = Label.Opp_Stage_10_Percent;
        SystemIdUtility.skipOpportunityTriggers = true;
        insert opp;
        
        
        
        Set<Id> OppIdSet = new Set<Id>();
        OppIdSet.add(opp.Id);
        //UpdateBusinessPlanFocus UBPF = new UpdateBusinessPlanFocus();
        
        
        Product2 prd1 = new Product2(Name='2E',Family='Product',Product_Group__c='2E',Market_Focus_Area__c='SECURITY',IsActive=true);
        insert prd1;
        
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry pbe = new PricebookEntry(Product2Id=prd1.Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        insert pbe; 
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id);
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        insert oli1;
        
        
        Route_To_Market__c rtm = new Route_To_Market__c();
        rtm.Account__c = acc.Id;
        rtm.RTM__c = 'Solution Provider';
        insert rtm;
        
        Product_Alignment__c  objPAl1 = new Product_Alignment__c(Product_Group__c='Capacity Manager',Product_Group_MPL__c='TestSiteMinder1',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        Product_Alignment__c  objPAl2 = new Product_Alignment__c(Product_Group__c='2E',Product_Group_MPL__c='TestSiteMinder2',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        List<Product_Alignment__c> lstprodalignment = new List<Product_Alignment__c>();
        
        lstprodalignment.add(objPAl1);
        lstprodalignment.add(objPAl2);
        insert lstprodalignment;
        
        UpdateBusinessPlanFocusBatch UBPF = new UpdateBusinessPlanFocusBatch();
        Set<Id> ProdIdSet = new Set<Id>();
        ProdIdSet.add(prd1.Id);
        UBPF.SetOfIds.addAll(ProdIdSet);
        System.debug('+++++UBPF.SetOfIds++++++'+UBPF.SetOfIds);
        UBPF.Query = 'select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where PriceBookEntry.Product2Id IN: SetOfIds';              
        ID batchprocessid = Database.executeBatch(UBPF);
    }
    public static testMethod void testBusinessPlanBatch2(){
        RecordTypes_Setting__c SMB_RT = RecordTypes_Setting__c.getValues('SMB');
        Account acc = new Account();
        acc.Name = 'reselleracc';
        acc.BillingState = 'NY';
        acc.Region_Country__c = 'JP';
        acc.Alliance__c = true;
        acc.Alliance_Program_Level__c = 'Advanced';
        acc.Service_Provider__c = false;
        acc.Service_Provider_Program_level__c = 'Advanced';
        acc.Solution_Provider__c = true;
        acc.Solution_Provider_Program_Level__c = 'Advanced';
        acc.Velocity_Seller__c = true;
        acc.Velocity_Seller_Program_Level__c = 'Advanced';
        acc.Commercial_Id__c = 'asdf';
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='New York';
        acc.recordtypeid=SMB_RT.RecordType_Id__c;     
        acc.Reseller_Disti_Regional_ID__c = 'Test';   
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.accountid = acc.id;
        opp.Reseller__c= acc.id;
        opp.name = 'test';
        opp.stagename = Label.Opp_Stage_10_Percent;
        opp.CloseDate = date.today();
        opp.Type = '1 Tier';
        opp.Partner_Engagement__c = 'test';
        opp.StageName = Label.Opp_Stage_10_Percent;
        SystemIdUtility.skipOpportunityTriggers = true;
        insert opp;
        
        
        
        Set<Id> OppIdSet = new Set<Id>();
        OppIdSet.add(opp.Id);
        //UpdateBusinessPlanFocus UBPF = new UpdateBusinessPlanFocus();
        
        
        Product2 prd1 = new Product2(Name='2E',Family='Product',Product_Group__c='2E',Market_Focus_Area__c='SECURITY',IsActive=true);
        insert prd1;
        
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry pbe = new PricebookEntry(Product2Id=prd1.Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        insert pbe; 
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id);
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        insert oli1;
        
        
        Route_To_Market__c rtm = new Route_To_Market__c();
        rtm.Account__c = acc.Id;
        rtm.RTM__c = 'Service Provider';
        insert rtm;
        
        Product_Alignment__c  objPAl1 = new Product_Alignment__c(Product_Group__c='Capacity Manager',Product_Group_MPL__c='TestSiteMinder1',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        Product_Alignment__c  objPAl2 = new Product_Alignment__c(Product_Group__c='2E',Product_Group_MPL__c='TestSiteMinder2',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        List<Product_Alignment__c> lstprodalignment = new List<Product_Alignment__c>();
        
        lstprodalignment.add(objPAl1);
        lstprodalignment.add(objPAl2);
        insert lstprodalignment;
        
        //UpdateBusinessPlanFocus.LogicTriggeredFromOpportunity(OppIdSet);
        opp.Type = 'MSP';
        opp.Cloud_Platform__c = 'Internal Use';
        update opp;
        
       
        UpdateBusinessPlanFocusBatch UBPF = new UpdateBusinessPlanFocusBatch();
        Set<Id> ProdIdSet = new Set<Id>();
        ProdIdSet.add(prd1.Id);
        UBPF.SetOfIds.addAll(ProdIdSet);
        System.debug('+++++UBPF.SetOfIds++++++'+UBPF.SetOfIds);
        UBPF.Query = 'select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where PriceBookEntry.Product2Id IN: SetOfIds';              
        ID batchprocessid = Database.executeBatch(UBPF);
    }
    public static testMethod void testBusinessPlanBatch3(){
        RecordTypes_Setting__c SMB_RT = RecordTypes_Setting__c.getValues('SMB');
        Account acc = new Account();
        acc.Name = 'reselleracc';
        acc.BillingState = 'NY';
        acc.Region_Country__c = 'JP';
        acc.Alliance__c = true;
        acc.Alliance_Program_Level__c = 'Advanced';
        acc.Service_Provider__c = false;
        acc.Service_Provider_Program_level__c = 'Advanced';
        acc.Solution_Provider__c = true;
        acc.Solution_Provider_Program_Level__c = 'Advanced';
        acc.Velocity_Seller__c = true;
        acc.Velocity_Seller_Program_Level__c = 'Advanced';
        acc.Commercial_Id__c = 'asdf';
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='New York';
        acc.recordtypeid=SMB_RT.RecordType_Id__c;     
        acc.Reseller_Disti_Regional_ID__c = 'Test';   
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.accountid = acc.id;
        opp.Reseller__c= acc.id;
        opp.name = 'test';
        opp.stagename = Label.Opp_Stage_10_Percent;
        opp.CloseDate = date.today();
        opp.Type = '1 Tier';
        opp.Partner_Engagement__c = 'test';
        opp.StageName = Label.Opp_Stage_10_Percent;
        SystemIdUtility.skipOpportunityTriggers = true;
        insert opp;
        
        
        
        Set<Id> OppIdSet = new Set<Id>();
        OppIdSet.add(opp.Id);
        //UpdateBusinessPlanFocus UBPF = new UpdateBusinessPlanFocus();
        
        
        Product2 prd1 = new Product2(Name='2E',Family='Product',Product_Group__c='2E',Market_Focus_Area__c='SECURITY',IsActive=true);
        insert prd1;
        
        Pricebook2 pb = new Pricebook2();
        pb = [Select Id from Pricebook2 where IsStandard=true];
        
        PricebookEntry pbe = new PricebookEntry(Product2Id=prd1.Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
        insert pbe; 
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id);
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        insert oli1;
        
        
        Route_To_Market__c rtm = new Route_To_Market__c();
        rtm.Account__c = acc.Id;
        rtm.RTM__c = 'DM';
        insert rtm;
        
        Product_Alignment__c  objPAl1 = new Product_Alignment__c(Product_Group__c='Capacity Manager',Product_Group_MPL__c='TestSiteMinder1',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        Product_Alignment__c  objPAl2 = new Product_Alignment__c(Product_Group__c='2E',Product_Group_MPL__c='TestSiteMinder2',Route_To_Market__c=rtm.Id,Business_Plan__c=true,Related_Account__c=acc.id);
        List<Product_Alignment__c> lstprodalignment = new List<Product_Alignment__c>();
        
        lstprodalignment.add(objPAl1);
        lstprodalignment.add(objPAl2);
        insert lstprodalignment;
      
        opp.Type = 'DM';
        opp.Cloud_Platform__c = 'Internal Use';
        update opp;
        
       
        UpdateBusinessPlanFocusBatch UBPF = new UpdateBusinessPlanFocusBatch();
        Set<Id> ProdIdSet = new Set<Id>();
        ProdIdSet.add(prd1.Id);
        UBPF.SetOfIds.addAll(ProdIdSet);
        System.debug('+++++UBPF.SetOfIds++++++'+UBPF.SetOfIds);
        UBPF.Query = 'select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where PriceBookEntry.Product2Id IN: SetOfIds';              
        ID batchprocessid = Database.executeBatch(UBPF);
    }
   
    
}