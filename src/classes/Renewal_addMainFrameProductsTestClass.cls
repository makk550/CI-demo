/*
 * Test Class for Renewal_addMainFrameProducts Class.
 * Created by BAJPI01
 * Coverage - 77%
 * Updated by SAMTU01
 * Uses testCreateAccOppandLineItemClass class to create account, opportunity and line items, without using seealldata = true, but skips triggers.
 */
@isTest
public class Renewal_addMainFrameProductsTestClass {
    
    static testMethod void Renewal_addMainFrameProductsTest()
    {
        Opportunity opp;
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        Set<Opportunity> OppSet = oppAndLineItemMap.keySet();
        for(Opportunity tempOpp:Oppset){
            Opp = tempOpp;
        }
        List<OpportunityLineItem> OppItmList = oppAndLineItemMap.get(Opp);
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c='AB');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
		
		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200, Stretch__c=1000, License__c='Subscription',Business_Type__c = 'MF Capacity',
                                  raw_maintenance__c=1.00,License_Classification_Override__c='UMF');
        
        insert oli;
			        
        system.debug('----size----'+OppItmList.size());
        
        PageReference pageRef = Page.renewal_addMainFrameProducts;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('oppid',opp.Id);
        pageRef.getParameters().put('producttype','Renewal');
        pageRef.getParameters().put('retURL',opp.Id);
        ApexPages.StandardController testPage = new ApexPages.StandardController(Opp);
        Renewal_addMainFrameProducts  renewalmainframecontroller = new Renewal_addMainFrameProducts(testPage);
        Test.startTest();
       
        List<SelectOption> licenseclassify = renewalmainframecontroller.LicenseClassification;
        List<SelectOption> licenseclassifyoveride = LicenseClassificationMapper.LicenseClassificationOverride();
        renewalmainframecontroller.haserror = true;
        renewalmainframecontroller.saveproducts();
        renewalmainframecontroller.haserror = false;
        renewalmainframecontroller.opportunity.Stretch_Deal_Term_Months__c = 0;
        renewalmainframecontroller.saveproducts();
        renewalmainframecontroller.opportunity.Reason_duration_is_1_year__c = null;
        renewalmainframecontroller.opportunity.New_Deal_Term_Months__c = 10;
        renewalmainframecontroller.saveproducts();
        renewalmainframecontroller.opportunity.New_Deal_Term_Months__c = 14;
        renewalmainframecontroller.saveproducts();
      
        Test.stopTest();
    }
    
    static testMethod void renewaladdmainframetest(){
        Opportunity opp;
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        Set<Opportunity> OppSet = oppAndLineItemMap.keySet();
        for(Opportunity tempOpp:Oppset){
            Opp = tempOpp;
        }
        List<OpportunityLineItem> OppItmList = oppAndLineItemMap.get(Opp);
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'Mainframe Capacity', IsActive = true, family='Mainframe Capacity',Market_Focus_Area__c = 'Mainframe Capacity',Commissionable_BU__c='AB');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
			        
        system.debug('----size----'+OppItmList.size());
        
        PageReference pageRef = Page.renewal_addMainFrameProducts;
        Test.setCurrentPage(pageRef);
        
        pageRef.getParameters().put('oppid',opp.Id);
        pageRef.getParameters().put('producttype','Renewal');
        pageRef.getParameters().put('retURL',opp.Id);
        ApexPages.StandardController testPage = new ApexPages.StandardController(Opp);
        Renewal_addMainFrameProducts  renewalmainframecontroller = new Renewal_addMainFrameProducts(testPage);
        Test.startTest();
          List<SelectOption> licenseclassify = renewalmainframecontroller.LicenseClassification;
        List<SelectOption> licenseclassifyoveride = LicenseClassificationMapper.LicenseClassificationOverride();
        renewalmainframecontroller.saveproducts();
        renewalmainframecontroller.opportunity.Reason_duration_is_1_year__c=null;
        renewalmainframecontroller.saveproducts();
        renewalmainframecontroller.getDaysBetweenLineItem();
        renewalmainframecontroller.oppLineItem.Start_Date__c = null;
        renewalmainframecontroller.getDaysBetweenLineItem();
        renewalmainframecontroller.oppLineItem.Start_Date__c = system.today();
        renewalmainframecontroller.oppLineItem.End_Date__c = system.today();
        renewalmainframecontroller.oppLineItem.License__C ='Subscription';
        renewalmainframecontroller.getDaysBetweenLineItem();
        renewalmainframecontroller.oppLineItem.UnitPrice = 1000;
        renewalmainframecontroller.oppLineItem.Start_Date__c = system.today()+1;
        renewalmainframecontroller.oppLineItem.End_Date__c = system.today()+10;
        //renewalmainframecontroller.oppLineItem.Term_Month__c=9;
        renewalmainframecontroller.oppLineItem.Stretch_License_Fee__c = 100;
        renewalmainframecontroller.oppLineItem.Stretch_Total_Maintenance__c = 100;
        renewalmainframecontroller.performStretchCalc();
        renewalmainframecontroller.oppLineItem.UF_License_Fee__c = 700;
        renewalmainframecontroller.oppLineItem.Total_Maintenance__c = 1000;
        renewalmainframecontroller.performSalesPriceCalc();
        
        renewalmainframecontroller.getDaysBetweenLineItem();
        List<SelectOption> options = renewalmainframecontroller.LicenseType;
 	 	List<SelectOption> licclass = renewalmainframecontroller.LicenseClassificationOverride;
        List<SelectOption> licclass1 = renewalmainframecontroller.LicenseClassification;
        List<SelectOption> bustypelist = renewalmainframecontroller.BusinessTypeList;
        Test.stopTest();
    }
}