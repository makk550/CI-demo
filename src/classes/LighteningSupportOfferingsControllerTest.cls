@IsTest(SeeAllData=false)
public class LighteningSupportOfferingsControllerTest {
    static testmethod void testingSupportOfferingService(){
        List<v_support_offerings__x> offeringsList; 
        String totalCount;
        Boolean isDetailsPresent;
        Test.startTest();
        PageReference pageRef = Page.LighteningSupportOfferingsDetails;
        Test.setCurrentPage(pageRef);
        v_support_offerings__x mockedRequest = TestSLOMilestonesDataSetup.createContractOfferingsExternalData();
     
        LighteningSupportOfferingsController lighteningOffering=new LighteningSupportOfferingsController();    
        LighteningSupportOfferingsController.mockedRequests.add(mockedRequest); 
        lighteningOffering.getSupportOfferings();         
        lighteningOffering.offeringsList=LighteningSupportOfferingsController.mockedRequests;
        System.assertEquals(1, lighteningOffering.offeringsList.size()); 
        lighteningOffering.totalCount=String.valueOf(lighteningOffering.offeringsList.size());
        System.assertEquals('1',lighteningOffering.totalCount);
        lighteningOffering.isDetailsPresent=true;
        System.assert(true, lighteningOffering.isDetailsPresent);
        Test.stopTest();
    }
}