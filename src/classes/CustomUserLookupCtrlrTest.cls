@isTest
private class CustomUserLookupCtrlrTest {

 static testMethod void testCustomUserLookupCtrlr() {
CustomUserLookupCtrlr c = new CustomUserLookupCtrlr();

c.SearchAccounts();
c.showSearchScreen();
c.formatName('Test');

}
}