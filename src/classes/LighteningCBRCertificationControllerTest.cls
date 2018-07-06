@IsTest(SeeAllData=false)
public class LighteningCBRCertificationControllerTest {
static testmethod void testingLighteningCBRCertificationService(){
	
    List<CBR_Certifications_LPAC__c> certCustomObjList = new List<CBR_Certifications_LPAC__c>();
    List<cbr_Calculated_Certification__x> cbrList;
        String noOfRecords;
        Boolean isDetailsPresent;
        Test.startTest();
    PageReference pageRef = Page.LighteningCBRCertificationDetails;
        Test.setCurrentPage(pageRef);
    cbr_Calculated_Certification__x mockedRequest  = TestSLOMilestonesDataSetup.createCertificationExternalData();
    
    	
    CBR_Certifications_LPAC__c certTempRec = new CBR_Certifications_LPAC__c();
    certTempRec.ldap_id__c = '2810504';
	certTempRec.UniqueCBRIdentifier__c = 'test1';    
    
    CBR_Certifications_LPAC__c certTempRec1 = new CBR_Certifications_LPAC__c();
    certTempRec1.ldap_id__c = 'HENJA04';
	certTempRec1.UniqueCBRIdentifier__c = 'test2';    
    certCustomObjList.add(certTempRec);
    certCustomObjList.add(certTempRec1);
    
    insert certCustomObjList;    
    
    
    LighteningCBRCertificationController lighteningCBRCertificationObj =new LighteningCBRCertificationController();
    lighteningCBRCertificationObj.getcbrcertlist();
    lighteningCBRCertificationObj.refresh();
    lighteningCBRCertificationObj.displayRecord();
    
    /*
    lighteningCBRCertificationObj.cbrList = certCustomObjList;
     system.assertEquals(2,lighteningCBRCertificationObj.cbrList.size());
     System.assertEquals('2',lighteningCBRCertificationObj.noOfRecords); 
     lighteningCBRCertificationObj.isDetailsPresent = true;
     System.assert(true, lighteningCBRCertificationObj.isDetailsPresent);
     lighteningCBRCertificationObj.getcbrcertlist();*/
    Test.stopTest();
     
      
   
   
    
    
}
}