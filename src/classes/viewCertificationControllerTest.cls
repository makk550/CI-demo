@IsTest(SeeAllData=false)
public class viewCertificationControllerTest {
static testmethod void testingviewCertificationService(){
    List<CBR_Certifications_LPAC__c> certCustomObjList = new List<CBR_Certifications_LPAC__c>();
    List<cbr_Calculated_Certification__x> cbrViewList;
        String totalCount;

        Boolean isDetailsPresent;

        Test.startTest();

    Profile adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR']; 
    //00e30000000oou3AAA
    //User
    //00e30000000oou3AAA
    // private static User supportUser ; 
    User u = new User(Alias = 'test123', Email='test123@ca.com', 
                         EmailEncodingKey='UTF-8', LastName='Testgsb', LanguageLocaleKey='en_US', 
                         LocaleSidKey='en_US', ProfileId = adminProfile.Id, 
                         TimeZoneSidKey='America/Los_Angeles', UserName='certTest@ca.com');
            insert u;
    PageReference pageRef = Page.viewcertification;
    pageRef.getParameters().put('id',u.id);
    Test.setCurrentPage(pageRef);
    CBR_Certifications_LPAC__c certTempRec = new CBR_Certifications_LPAC__c();
    certTempRec.Employee_Name__c = 'Testgsb';
    certTempRec.badge__c = 'Sales/Tech Sales Validation';   
    certTempRec.ca_product_name__c = 'CLARITY ON PREMISE';
    certTempRec.certified_status_text__c ='Active';
    certTempRec.certified__c ='Yes';
   // certTempRec.status_reason__c = '';
    certTempRec.valid_from__c  = system.now();
    certTempRec.valid_to__c  = system.now();
    
     CBR_Certifications_LPAC__c certTempRec1 = new CBR_Certifications_LPAC__c(); 
    
     certTempRec1.Employee_Name__c = '';
    certTempRec1.badge__c = '';   
    certTempRec1.ca_product_name__c = '';
    certTempRec.certified_status_text__c ='';
    certTempRec1.certified__c ='';
   // certTempRec1.status_reason__c = '';
    certTempRec1.valid_from__c  = system.now();
    certTempRec1.valid_to__c  = system.now();
    
    certCustomObjList.add(certTempRec);
    certCustomObjList.add(certTempRec1);
    
     insert certCustomObjList;    
    
     viewCertificationController viewcertobj = new viewCertificationController();
     viewcertobj.cbrListView = certCustomObjList;
     system.assertEquals(2,viewcertobj.cbrListView.size());
      viewcertobj.totalCount=String.valueOf(viewcertobj.cbrListView.size());
       System.assertEquals('2',viewcertobj.totalCount); 
    viewcertobj.isDetailsPresent = true;
    System.assert(true, viewcertobj.isDetailsPresent);
    viewcertobj.getviewCertificationDetails();
  
  
    Test.stopTest();
     
}
}