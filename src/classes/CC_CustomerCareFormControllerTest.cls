@isTest(seeAllData=true)
public class CC_CustomerCareFormControllerTest {
    
    @isTest
    static void testMethod1(){
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();
        obj.getcontactMethods();
        obj.getCountries();
        obj.getStates();
        obj.getYesNoOptions();
        obj.getRequestTypes();
        obj.getLicensingTypes();
        CC_CustomerCareFormController.fetchCountriesFromWebService();
        obj.fetchStatesForCountryFromWebService('10554');
        obj.cancel();
        obj.save();        
    }
    
   /* @isTest
    static void buildStateBusinessHours(){
        State_BusinessHours__c stb = new State_BusinessHours__c();
        stb.Name = 'New York';
        stb.Country__c = 'US - UNITED STATES';
        stb.Current_BusinessHours__c = 'US - UNITED STATES Eastern Time (America/New_York)';
        stb.Next_BusinessHours__c = 'US - UNITED STATES Eastern Time (America/New_York)';
        stb.State_Code__c = 'NY';
        insert stb;
    } */
    
    @isTest //(SeeAllData = true)
    static void testMethod_CALicensing_ALP(){        
        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        
             
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_CA_Licensing;
        
        obj.licensing_type = System.Label.CCF_ALP_Keys;
        obj.product_name = 'test';
        obj.release = 'test';
        obj.lic_your_question = 'test'; 
        obj.hasAttachmentsToAdd = 'Yes';
        Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob;
        obj.attachmentRec = attach;
        obj.attachmentsNameList.add(attach.Name);
        
        Test.startTest();  
        obj.save(); 
        obj.setNotificationOnPage();
        obj.attachFilesToCase(attach,obj.caseNumber);
        Test.stopTest();
    }
    
    @isTest
    static void testMethod_CALicensing_LMP(){        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_CA_Licensing;
        
        obj.licensing_type = System.Label.CCF_LMP_Keys;
        obj.product_name = 'test';
        obj.release = 'test';
        obj.lic_your_question = 'test';        
        obj.save();
    }
    
    @isTest
    static void testMethod_CALicensing_OtherKeys(){        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_CA_Licensing;
        
        obj.licensing_type = System.Label.CCF_All_Other_Keys;
        obj.product_name = 'test';
        obj.release = 'test';
        obj.lic_your_question = 'test';        
        obj.save();
    }
    
    @isTest
    static void testMethod_GeneralQuestion(){        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_General_Questions;
        obj.general_your_question = 'test';        
        obj.save();
    }
    
    @isTest
    static void testMethod_CASupportPortal(){        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_CA_Support_Portal;
        obj.portal_your_question = 'test';        
        obj.save();
    }
    
    @isTest
    static void testMethod_CAPartnerReq(){        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_CA_Partner_Request;
        obj.caPartReq_your_question = 'test'; 
        obj.is_partner_registered = 'Yes';
        obj.emailAddress_used = 'test@te.com';
        obj.organizationId = 'test';
        obj.best_method_of_contact = 'email';
        obj.save();
    }
    
    @isTest
    static void testMethod_CAEducationSupport(){        
        Test.setMock(HttpCalloutMock.class, new CC_CustomerFormControllerMock());        
        CC_CustomerCareFormController obj = new CC_CustomerCareFormController();  
        PageReference pageRef = Page.CustomerCareForm;
        Test.setCurrentPageReference(pageRef);         
        ApexPages.currentPage().getParameters().put('g-recaptcha-response','true');
        obj.siteId = '105246';
        obj.firstName = 'test';
        obj.lastName = 'test';
        obj.company = 'test';
        obj.addressText = 'test';
        obj.country = 'India';
        obj.city = 'Hyd';
        obj.state_province = 'AP';
        obj.postal_zip_code = '47658';
        obj.telePhNo = '5677980980';
        obj.extension = '6568';
        obj.email_address = 'test@test.com';
        obj.request_type = System.Label.CCF_CA_Education_Support;
        obj.caEduSup_your_question = 'test'; 
        obj.course_name = 'test';
        obj.course_number = 'test1234';
        obj.date_of_class = 'test';
        obj.class_location = 'test';
        obj.operating_system = 'Windows';
        obj.browser = 'test';
        obj.java_version = 'test';
        obj.contact_instruction = 'test';
        obj.save();
    }
    
}