/*
 * Test class created by BAJPI01.
 * For Class - quoteRequestController
 * Coverage - 96%
*/
@isTest
public class quoteRequestControllerTest {
    
    public static testMethod void createTestDataQuoteRequest(){
        
        testOpportunityTriggersClass.createTestData();
        
        Opportunity Opp = [select id from Opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'No Opportunity Exists.');
        
        PageReference tpageRef = Page.newQuoteRequest;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('oppId', opp.id);
        quoteRequestController quoteReqCtrl = new quoteRequestController();
        
        quoteReqCtrl.applySelection();
        ApexPages.Message[] pageMsgs = ApexPages.getMessages();
        Boolean pgMsg = false;
        for(Apexpages.Message msg:pageMsgs){
            if (msg.getDetail().contains('Please select a value'))
                pgMsg = true;
        }
        system.assert(pgMsg);
        
        quoteReqCtrl.selectedQuoteType = 'NCV Quote';
        quoteReqCtrl.applySelection();
        
        Quote_Request__c quoteReq = [select id from Quote_Request__c limit 1];
        system.assertNotEquals(null, quoteReq.id, 'Quote Request did not get inserted.');
        
        quoteReqCtrl.Cancel();
    }

}