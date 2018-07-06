@istest
public class MassLeadsAssignTest {

    // test method for the MassLeadsAssign class
    static testMethod void testMassLeadsAssign() {
    
        // create the test leads
        Lead ld = new Lead();
        ld.Company = 'CM';
        ld.LastName = 'Test';
        ld.Status = 'Untouched';
        insert ld;
        
        // set the page reference
        PageReference pg = new PageReference('/apex/MassLeadsAssignPage?fcf=&leads='+ld.Id);
        Test.setCurrentPage(pg);
        
        // Instantiate the Controller class
        MassLeadsAssignClass massControllerObj = new MassLeadsAssignClass();
        // start the test
        Test.startTest();      
        massControllerObj.init();
        massControllerObj.getRenderPanel();
        massControllerObj.getAccessErrStyle();
        massControllerObj.getLeadIds();
        massControllerObj.saveAction();
        massControllerObj.getErrorLeads();
        massControllerObj.getErrorTableDisplay();
        massControllerObj.returnToLeadsList();
        //MassLeadsAssignClass.dirProfileIds.add(UserInfo.getProfileId());  
        massControllerObj.identifyPageVisibility();
        massControllerObj.userEligible = false;
        massControllerObj.getAccessErrStyle();
        //stop the test
        Test.stopTest();
            
    }

}