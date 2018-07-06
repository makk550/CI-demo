/*
 * Test Class for OppLineItemController Class.
 * Created by BAJPI01
 * Coverage - 76%
 * Updated by SAMTU01
 */
@isTest
public class OppLineItemControllerTest {
    
    static testmethod void testOppLineItemMethodProduct(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        insert a;
         
        
        Opportunity opp = new Opportunity(RecordTypeId=recopp,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = 'test' , 
                                          CloseDate = Date.today(),
                                          New_Deal_Term_months__c = 12, 
                                          Stretch_Deal_Term_Months__c = 8,
                                          Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
                                          Business_Type__c = 'High Touch',
                                          Projected_Renewal__c = 12345.0,
                                          Start_Date__c = Date.today(),
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        
        
        List<OpportunityLineItem> OppItmList =new List<OpportunityLineItem>();
        for(integer i=0;i<10;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                              raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
            OppItmList.add(oli);
            i=i++;
        }
        for(integer i=0;i<3;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',License__c='SAAS',
                                                              raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
            OppItmList.add(oli);
            i=i++;
        }
    for(integer i=0;i<2;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',License__c='Upfront',
                                                              raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
            OppItmList.add(oli);
            i=i++;
        }
        insert OppItmList;
        
        
        Product2 prod2 = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c ='MF');
        insert prod2;

        
        PricebookEntry pbemf = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbemf;
    
    OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbemf.Id, UnitPrice = 200,Business_Type__c = 'MF Capacity',
                                  raw_maintenance__c=1.00);
        
        insert oli;


        
        OpportunityLineItem oli1_1 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id,Term_Month__c=13,UnitPrice=6,Business_Type__c = 'New',License__c='SAAS');
        OpportunityLineItem oli1_2 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id,Term_Month__c=14,UnitPrice=6,Business_Type__c = 'Upfront',License__c='Upfront');
        
        PageReference opplinewpage1 = Page.OppLineItempage;
        opplinewpage1.getParameters().put('producttype','Product');
        opplinewpage1.getParameters().put('oppid',opp.Id);
        Test.setCurrentPage(opplinewpage1);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(oli1_1);
        OppLineItemcontroller opplicontroller1 = new OppLineItemcontroller(stdcon1);
        
        opplicontroller1.addmore_prds();
        opplicontroller1.saveproducts();
        opplicontroller1.pos = 0;
        opplicontroller1.resetIsOverrideChecked();
    opplicontroller1.CalcSalesPrice();
    //opplicontroller1.calculateUFLicenseFee_partner();
        opplicontroller1.getMonthsBetween();
             
    
          
     ApexPages.StandardController stdcon2 = new ApexPages.StandardController(oli1_2);
        OppLineItemcontroller opplicontroller2 = new OppLineItemcontroller(stdcon2);
        
        opplicontroller2.addmore_prds();
        opplicontroller2.saveproducts();
        opplicontroller2.pos = 1;
        opplicontroller2.resetIsOverrideChecked();
        
        opplicontroller1.calculateUFLicenseFee();
        opplicontroller2.calculateUFLicenseFee();
        //opplicontroller1.calculateUFLicenseFee_partner(); 
        opplicontroller1.recalculate();
        
        OpportunityLineItem[] oliUpsert = new OpportunityLineItem[]{oli1_1,oli1_2};
        upsert oliUpsert;
        
        PageReference opplinewpage2 = Page.OppLineItempage;
        opplinewpage2.getParameters().put('producttype','Renewal');
        opplinewpage2.getParameters().put('oppid',opp.Id);
        Test.setCurrentPage(opplinewpage2);
        ApexPages.StandardController stdcon3 = new ApexPages.StandardController(oli1_2);
        OppLineItemcontroller opplicontroller3 = new OppLineItemcontroller(stdcon3);
       // opplicontroller3.addmore_ren();
       // opplicontroller3.saveproducts();
        
    }
  
    static testmethod void testOppLineItemMethodLessThan3Prod(){
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        insert a;
        
        Opportunity opp = new Opportunity(RecordTypeId=recopp,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = 'test' , 
                                          CloseDate = Date.today(),
                                          New_Deal_Term_months__c = 12, 
                                          Stretch_Deal_Term_Months__c = 8,
                                          Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
                                          Business_Type__c = 'High Touch',
                                          Projected_Renewal__c = 12345.0,
                                          Start_Date__c = Date.today(),
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        
        List<OpportunityLineItem> OppItmList =new List<OpportunityLineItem>();
    for(integer i=0;i<1;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',License__c='SAAS',
                                                              raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
            OppItmList.add(oli);
            i=i++;
        }
        insert OppItmList;
        
        
        Product2 prod2 = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c ='MF');
        insert prod2;

        
        PricebookEntry pbemf = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbemf;
    
    OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbemf.Id, UnitPrice = 200,Business_Type__c = 'MF Capacity',
                                  raw_maintenance__c=1.00);
        
        insert oli;


        
        OpportunityLineItem oli1_1 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe.Id,Term_Month__c=13,UnitPrice=6,Business_Type__c = 'New',License__c='SAAS');

        
        PageReference opplinewpage1 = Page.OppLineItempage;
        opplinewpage1.getParameters().put('producttype','Product');
        opplinewpage1.getParameters().put('oppid',opp.Id);
        Test.setCurrentPage(opplinewpage1);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(oli1_1);
        OppLineItemcontroller opplicontroller1 = new OppLineItemcontroller(stdcon1);
        opplicontroller1.lineCounter =0; //SAMAP01
        opplicontroller1.addmore_prds();
        opplicontroller1.saveproducts();
        opplicontroller1.pos = 0;
        opplicontroller1.resetIsOverrideChecked();
    opplicontroller1.CalcSalesPrice();
   // opplicontroller1.calculateUFLicenseFee_partner();//SAMTU01
        opplicontroller1.getMonthsBetween();
        opplicontroller1.calculateUFLicenseFee();
        opplicontroller1.recalculate();
       List<SelectOption> licclass = opplicontroller1.LicenseClassification;//SAMTU01
         List<SelectOption> licclassoverride = opplicontroller1.LicenseClassificationOverride;//SAMTU01
        opplicontroller1.calculateStretch();//SAMTU01
        opplicontroller1.fetchfamily();//SAMTU01
        opplicontroller1.alrt=true;
        OpportunityLineItem[] oliUpsert = new OpportunityLineItem[]{oli1_1};
        upsert oliUpsert;
        
    }
    
}