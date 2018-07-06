/*
 * Test Class for:  sbOppLineItemEditController
 * Coverage: 
 * 
*/
@isTest
public class sbOppLineItemEditControllerTest {

    public static testMethod void testView(){
        testCreateQuoteAndQuoteLine.createTestData();
        
        
        OpportunityLineItem oli =[select id,OpportunityId,Product2Id,License__c,Business_Type__c,UnitPrice,
                                  Quantity,CurrencyISOCode,Stretch__c,Start_Date__c,End_Date__c,Term_Month__c,
                                  Stretch_Duration__c,UF_License_Fee__c,Total_Maintenance__c,
                                  Stretch_License_Fee__c,Stretch_Total_Maintenance__c from OpportunityLineItem limit 1];
        system.assertNotEquals(null, oli.id, 'line item not inserted');
        
        PageReference tpageRef = Page.sbOppLineItemEditPage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id', oli.id);
        ApexPages.currentPage().getParameters().put('&sfdc.override', '1');
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oli);
        sbOppLineItemEditController sbLineItemCtrl = new sbOppLineItemEditController(stdCtrl);
        sbLineItemCtrl.onEdit();
        sbLineItemCtrl.onCancel();
        test.startTest();
        ApexPages.currentPage().getParameters().put('id', '');
        ApexPages.currentPage().getParameters().put('&sfdc.override', '1');
        ApexPages.StandardController stdCtrl2 = new ApexPages.StandardController(oli);
        sbOppLineItemEditController sbLineItemCtrl2 = new sbOppLineItemEditController(stdCtrl2);
        test.stopTest();
    }
    
    
    public static testMethod void testEdit(){
        testCreateQuoteAndQuoteLine.createTestData();
        
        Opportunity opp = [select id from opportunity limit 1];
        
        OpportunityLineItem oli =[select id,OpportunityId,Product2Id,License__c,Business_Type__c,UnitPrice,
                                  Quantity,CurrencyISOCode,Stretch__c,Start_Date__c,End_Date__c,Term_Month__c,
                                  Stretch_Duration__c,UF_License_Fee__c,Total_Maintenance__c,
                                  Stretch_License_Fee__c,Stretch_Total_Maintenance__c from OpportunityLineItem limit 1];
        system.assertNotEquals(null, oli.id, 'line item not inserted');
        
        PageReference tpageRef = Page.sbOppLineItemEditPage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id', oli.id);
        ApexPages.currentPage().getParameters().put('&sfdc.override', '1');
        ApexPages.currentPage().getParameters().put('&retURL', '/'+opp.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oli);
        sbOppLineItemEditController sbLineItemCtrl = new sbOppLineItemEditController(stdCtrl);
		test.startTest();
        oli.Stretch__c = 1111111;
        sbLineItemCtrl.stretchChangeMethod();
        //sunji03 FY19, this method is removed
        //sbLineItemCtrl.arrStretchChangeMethod();
        sbLineItemCtrl.stretchDurationChangeMethod();
        
        sbLineItemCtrl.onSave();
        test.stopTest();
    }
    
     public static testMethod void testEditMethod2(){
        testCreateQuoteAndQuoteLine.createTestData();
        
        Opportunity opp = [select id from opportunity limit 1];
        
        OpportunityLineItem oli =[select id,OpportunityId,Product2Id,License__c,Business_Type__c,UnitPrice,
                                  Quantity,CurrencyISOCode,Stretch__c,Start_Date__c,End_Date__c,Term_Month__c,
                                  Stretch_Duration__c,UF_License_Fee__c,Total_Maintenance__c,
                                  Stretch_License_Fee__c,Stretch_Total_Maintenance__c from OpportunityLineItem limit 1];
        system.assertNotEquals(null, oli.id, 'line item not inserted');
        oli.Stretch__c = 0;
        PageReference tpageRef = Page.sbOppLineItemEditPage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id', oli.id);
        ApexPages.currentPage().getParameters().put('&sfdc.override', '1');
        ApexPages.currentPage().getParameters().put('&retURL', '/'+opp.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oli);
        sbOppLineItemEditController sbLineItemCtrl = new sbOppLineItemEditController(stdCtrl);

        sbLineItemCtrl.stretchChangeMethod();
       
    }
    
     public static testMethod void testStretchDurationChange(){
        testCreateQuoteAndQuoteLine.createTestData();
        
        Opportunity opp = [select id from opportunity limit 1];
        
        OpportunityLineItem oli =[select id,OpportunityId,Product2Id,License__c,Business_Type__c,UnitPrice,
                                  Quantity,CurrencyISOCode,Stretch__c,Start_Date__c,End_Date__c,Term_Month__c,
                                  Stretch_Duration__c,UF_License_Fee__c,Total_Maintenance__c,
                                  Stretch_License_Fee__c,Stretch_Total_Maintenance__c from OpportunityLineItem limit 1];
        system.assertNotEquals(null, oli.id, 'line item not inserted');
        oli.Stretch_Duration__c = 2;
         oli.Stretch__c = 12;
        PageReference tpageRef = Page.sbOppLineItemEditPage;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('id', oli.id);
        ApexPages.currentPage().getParameters().put('&sfdc.override', '1');
        ApexPages.currentPage().getParameters().put('&retURL', '/'+opp.id);
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oli);
        sbOppLineItemEditController sbLineItemCtrl = new sbOppLineItemEditController(stdCtrl);
        //sunji03 FY19, this method is removed
		//sbLineItemCtrl.arrStretchChangeMethod();
        sbLineItemCtrl.stretchDurationChangeMethod();
       
    }
    
    
}