@IsTest
public class ConsoleSearchUtilityTest {
    public static testMethod void testCode(){
        ConsoleSearchUtility consoleSearchUtility=new ConsoleSearchUtility();
        consoleSearchUtility.getSiteEntitlementsDetails();
        consoleSearchUtility.gotoTarget();
        consoleSearchUtility.MDMSearch();
    } 
}