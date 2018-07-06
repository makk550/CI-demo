@isTest(seeAllData=false)
private class ValidatingUniqueCertificationTest {
    
  /*  static testmethod void testingOfferingFeatures(){
        Test.startTest();
        Contact testContact = new Contact();
        testContact.FirstName ='testAuto';
        testContact.LastName ='contact';
        insert testContact ;
        
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='Test';
        insert prodCtl;

        CA_Product_Controller__c prodCtl2 = new CA_Product_Controller__c();
        prodCtl2.name='Test2';
        insert prodCtl2;
         
        Certifications__c cert1=new Certifications__c();
        cert1.Contact__c=testContact.ID;
        cert1.CA_Product__c=prodCtl.ID;
        cert1.Certification_Start_Date__c=Date.today();
        cert1.Certification_End_Date__c= Date.today().addDays(1);
        insert cert1;
        
        Certifications__c cert2=new Certifications__c();
        cert2.Contact__c=testContact.ID;
        cert2.CA_Product__c=prodCtl.ID;
        cert2.Certification_Start_Date__c=Date.today();
        cert2.Certification_End_Date__c= Date.today().addDays(1);
        Database.SaveResult result = Database.insert(cert2, false);
        System.assertEquals('There is already a certification entry for this contact and product',result.getErrors()[0].getMessage());        


         Certifications__c cert3=new Certifications__c();
        cert3.Contact__c=testContact.ID;
        cert3.CA_Product__c=prodCtl2.ID;
        cert3.Certification_Start_Date__c=Date.today();
        cert3.Certification_End_Date__c= Date.today().addDays(1);
        insert cert3;       

        cert3.CA_Product__c = prodCtl.ID;
        Database.SaveResult result1 = Database.update(cert3, false);
        System.assertEquals('There is already a certification entry for this contact and product',result1.getErrors()[0].getMessage());       
        Test.stopTest();
    }*/
    
}