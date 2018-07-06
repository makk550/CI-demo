@isTest(SeeAllData=true)
public class TestMyUserLicense {
   public static testMethod void testMethodMyUserLicense (){
       test.startTest();
       MyUserLicense l= new MyUserLicense();
       l.getUL();
       test.stopTest();
    }
    
}