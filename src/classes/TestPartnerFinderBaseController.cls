@IsTest
private class TestPartnerFinderBaseController {
	
	private class ConcretePartnerFinderBaseController extends PartnerFinderBaseController{}
	
    private static testmethod void testOption1HttpParameter(){
    	PartnerFinderBaseController controller = new ConcretePartnerFinderBaseController();
        System.assertNotEquals('es', controller.getPreferredLanguageCode());  
        ApexPages.currentPage().getParameters().put('l','XXXXXXXX');
        System.assertNotEquals('es', controller.getPreferredLanguageCode());  
        ApexPages.currentPage().getParameters().put('l','es');
        System.assertEquals('es', controller.getPreferredLanguageCode()); 
    }

}