/*
 * Test Class for OppLineitem_View_Edit_controller Class.
 * Created by BAJPI01
 * Coverage - 78%
 * Updated by SAMTU01
 */
@isTest
public class OppLineItem_View_Edit_Controller_Test {
    
    static testmethod void testOppLineItemViewEditProduct(){
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

        for(integer i=0;i<3;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',License__c='SAAS',
                                                              raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
            OppItmList.add(oli);
            OpportunityLineItem olitem = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'New',License__c='Upfront',
                                                             raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
             OppItmList.add(olitem);
            i=i++;
        }
        insert OppItmList;
        
        
        Product2 prod2 = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity');
        insert prod2;

        
        PricebookEntry pbemf = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbemf;
		
		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbemf.Id, UnitPrice = 200,Business_Type__c = 'MF Capacity',
                                  raw_maintenance__c=1.00,License__c ='Subscription');
        
        insert oli;

        
        PageReference opplinewpage1 = Page.OppLineitem_View_Edit;
        opplinewpage1.getParameters().put('retURL',opp.Id);
        opplinewpage1.getParameters().put('id',OppItmList[0].Id);
        Test.setCurrentPage(opplinewpage1);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(OppItmList[0]);
        OppLineitem_View_Edit_controller opplicontroller1 = new OppLineitem_View_Edit_controller(stdcon1);
        opplicontroller1.updateproduct();
		opplicontroller1.resetIsOverrideChecked();
		//opplicontroller1.CalcSalesPrice();
		opplicontroller1.calculateUFLicenseFee();
        opplicontroller1.dodelete();
        opplicontroller1.docancel();
        opplicontroller1.CalcSalesPrice();
        opplicontroller1.getMonthsBetween();
        
        opplicontroller1.stretchduration = 12;
        opplicontroller1.license='Testing';
        List<SelectOption> lictype = opplicontroller1.LicenseType;//SAMTU01
        List<SelectOption> licclass = opplicontroller1.LicenseClassification;//SAMTU01
        List<SelectOption> licclassoverride = opplicontroller1.LicenseClassificationOverride;//SAMTU01
        List<SelectOption> bustypelist = opplicontroller1.BusinessTypeList;//SAMTU01
        opplicontroller1.calculateStretch();
        opplicontroller1.StretchFeeCalc();
    }
    
    static testmethod void testOppLineItemViewEditMainframe(){
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

        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod2 = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c ='MF');
        insert prod2;

        
        PricebookEntry pbemf = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbemf;
		
		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbemf.Id, UnitPrice = 200,Business_Type__c = 'MF Capacity',
                                  raw_maintenance__c=1.00);
        
        insert oli;

        
        PageReference opplinewpage1 = Page.OppLineitem_View_Edit;
        opplinewpage1.getParameters().put('retURL',opp.Id);
        opplinewpage1.getParameters().put('id',oli.Id);
        Test.setCurrentPage(opplinewpage1);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(oli);
        OppLineitem_View_Edit_controller opplicontroller1 = new OppLineitem_View_Edit_controller(stdcon1);
        opplicontroller1.updateproduct();
		opplicontroller1.resetIsOverrideChecked();
		//opplicontroller1.CalcSalesPrice();
		opplicontroller1.calculateUFLicenseFee();
        opplicontroller1.dodelete();
        opplicontroller1.docancel();
        opplicontroller1.getDaysBetweenLineItem();
    }
    
    static testmethod void testOppLineItemViewEditServicesOfferings(){
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
        
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod2 = new Product2(Name = 'Services', IsActive = true, family='Services',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c ='MF');
        insert prod2;

        
        PricebookEntry pbemf = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 1000, IsActive = true);
        insert pbemf;
		
		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbemf.Id, UnitPrice = 200,
                                  raw_maintenance__c=1.00);
        
        insert oli;
        
        Product2 prod3 = new Product2(Name = 'Support', IsActive = true, family='Support',Market_Focus_Area__c = 'Agile Central',Commissionable_BU__c ='AC');
        insert prod3;

        
        PricebookEntry pbeSupport = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id, UnitPrice = 1000, IsActive = true);
        insert pbeSupport;
		
		OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbeSupport.Id, UnitPrice = 200,Business_Type__c = 'New',
                                  raw_maintenance__c=1.00);
        
        insert oli2;
        
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbeSupport.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                  raw_maintenance__c=1.00,Start_Date__c=Date.today(), End_Date__c=Date.today().addMonths(12));
        
        insert oli4;

        
        PageReference opplinewpage1 = Page.OppLineitem_View_Edit;
        opplinewpage1.getParameters().put('retURL',opp.Id);
        opplinewpage1.getParameters().put('id',oli.Id);
        Test.setCurrentPage(opplinewpage1);
        ApexPages.StandardController stdcon1 = new ApexPages.StandardController(oli);
        OppLineitem_View_Edit_controller opplicontroller1 = new OppLineitem_View_Edit_controller(stdcon1);
        
        opplicontroller1.getDaysBetweenLineItem();
        
         

        
        PageReference opplinewpage2 = Page.OppLineitem_View_Edit;
        opplinewpage2.getParameters().put('retURL',opp.Id);
        opplinewpage2.getParameters().put('id',oli2.Id);
        Test.setCurrentPage(opplinewpage2);
        ApexPages.StandardController stdcon2 = new ApexPages.StandardController(oli2);
        OppLineitem_View_Edit_controller opplicontroller2 = new OppLineitem_View_Edit_controller(stdcon2);
        
        Product2 prod4 = new Product2(Name = 'Education', IsActive = true, family='Education',Market_Focus_Area__c = 'Agile Central',Commissionable_BU__c ='AC');
        insert prod4;

        
        PricebookEntry pbeEducation = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod4.Id, UnitPrice = 1000, IsActive = true);
        insert pbeEducation;
		
		OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbeEducation.Id, UnitPrice = 200,Business_Type__c = 'New',
                                  raw_maintenance__c=1.00);
        
        insert oli3;

        
        PageReference opplinewpage3 = Page.OppLineitem_View_Edit;
        opplinewpage3.getParameters().put('retURL',opp.Id);
        opplinewpage3.getParameters().put('id',oli3.Id);
        Test.setCurrentPage(opplinewpage3);
        ApexPages.StandardController stdcon3 = new ApexPages.StandardController(oli3);
        OppLineitem_View_Edit_controller opplicontroller3 = new OppLineitem_View_Edit_controller(stdcon3);
        
    }

}