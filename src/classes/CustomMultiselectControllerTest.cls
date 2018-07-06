@isTest
private class CustomMultiselectControllerTest {
    static testMethod void testMultiselectController() {
        CustomMultiselectController c = new CustomMultiselectController();
        
        c.leftOptions = new List<SelectOption>();
        c.rightOptions = new List<SelectOption>();

        c.leftOptionsHidden = 'A&a&b&b&C&c';
        c.rightOptionsHidden = '';
        
        System.assertEquals(c.leftOptions.size(), 3);
        System.assertEquals(c.rightOptions.size(), 0);
    }
}