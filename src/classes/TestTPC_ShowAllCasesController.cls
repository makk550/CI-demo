@isTest(SEEALLDATA=TRUE)
public class TestTPC_ShowAllCasesController {
    public static testMethod void TPC_ShowAllCasesControllerTest(){
        TestTPC_CreateCaseExtension.TPC_CreateCaseExtensionTest();
        User commUser = [Select id from User where email='esachin@salesforce.com' LIMIT 1];
        system.runAs(commUser) {
            TPC_ShowAllCasesController ctrl = new TPC_ShowAllCasesController();
            ctrl.getCases();
            ctrl.refresh();
            System.debug(ctrl.hasNext);
            System.debug(ctrl.hasPrevious);
            System.debug(ctrl.pageNumber);
            ctrl.first();
            ctrl.last();
            ctrl.previous();
            ctrl.next();
            ctrl.FilterCase();
            ctrl.sortToggle();
            
        }
    }

}