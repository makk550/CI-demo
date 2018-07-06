@IsTest
private class TestPartnerDetailsController { 
 
    private static testmethod void testBasicDetailFields(){
        TestData.ensureVariableExists(
           Configuration.KEY_DETAIL_SCREEN_COMPANY_BASIC_FIELDS,
           'Account.Industry=>Rating|Partner_Location__c.Is_Primary__c|Account.AnnualRevenue'
        );
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 1);
        PageUtils.put('id',thePartner.id);
    	
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
        
        System.assertNotEquals(null,controller.partnerDetailFieldsBasic);
        System.assertEquals(2,controller.partnerDetailFieldsBasic.size());

        System.assertEquals('Account',controller.partnerDetailFieldsBasic.get(0).objectName);
        System.assertEquals('Industry',controller.partnerDetailFieldsBasic.get(0).name);

        System.assertEquals('Account',controller.partnerDetailFieldsBasic.get(1).objectName);
        System.assertEquals('AnnualRevenue',controller.partnerDetailFieldsBasic.get(1).name);
    }
    
    private static testmethod void executeProperties(){
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(controller.ACCESS_DENIED, 'ACCESS_DENIED'); 
        System.assertEquals(controller.EMPTY_ID_PARAM , 'EMPTY_ID_PARAM');
        System.assertEquals(controller.RECORD_NOT_FOUND , 'RECORD_NOT_FOUND');
        System.assertEquals(controller.DELETE_FAILED , 'DELETE_FAILED');
    }
    
    private static testmethod void executeViewPartnerWithoutCustomFields(){
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_BASIC , '');
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_OVERVIEW, '');
        executeViewPartner();
    }
    
    private static testmethod void executeViewPartnerWithCustomFields(){
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_BASIC , 'Account.Fax|Account.Description');
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_OVERVIEW, 'Account.Industry|Account.AccountNumber');
        executeViewPartner();
    }

    

    private static testmethod void executeViewLocationWithoutCustomFields(){
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_BASIC , '');
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_EDIT , '');
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_OVERVIEW, '');
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_LOCATION, '');
        executeViewLocation();
    }

    
    private static testmethod void executeTermsAndConditions(){
        setVariable(PartnerSearchConstants.CONFIG_KEY_TERMS_AND_CONDITIONS_URL , 'www.salesforce.com');
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 25);
        PageReference pageRef = Page.PartnerDetails;
        Test.setCurrentPage(pageRef);
        PageUtils.put('id',locations[0].id);  
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
       // System.assertEquals(false, controller.T);
        System.assertEquals('www.salesforce.com', controller.getTermsAndConditionsURL());
        System.assertEquals(controller.updateTermsAndContitionsStatus()!=null,true);
        System.debug(controller.isIE);
    }
    
    private static testmethod void executePublishUnpublishPartner(){
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 25);
        PageReference pageRef = Page.PartnerDetails;
        Test.setCurrentPage(pageRef);
        PageUtils.put('id',locations[0].id);  
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
        Test.setCurrentPage(pageRef);
        PageUtils.put('publish','No');
        System.assertEquals(null,controller.updatePublishStatus());  
        System.assertEquals(true,controller.getMessages().size()>0);
        PageUtils.put('publish','Yes');
        System.assertEquals(null,controller.updatePublishStatus()); 
        System.assertEquals(true,controller.getMessages().size()>0);
    } 
    
    private static testmethod void executeEmptySearch(){
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 25);
        PageReference pageRef = Page.PartnerDetails;
        Test.setCurrentPage(pageRef);
        PageUtils.put('id',locations[0].id); 
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
        //System.assertEquals(null,controller.search());
    }
    
    private static testmethod void executeError(){
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
    }
    
    private static testmethod void executeDeleteLocation(){
        setVariable(PartnerSearchConstants.CONFIG_KEY_TERMS_AND_CONDITIONS_URL , 'www.salesforce.com');
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 25);
        PageReference pageRef = Page.PartnerDetails;
        Test.setCurrentPage(pageRef);
        PageUtils.put('id',locations[0].id);  
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
        controller.deleteLocationId = locations[1].Id;
        System.assertEquals(true , null==controller.deleteLocation());
    }
    
    
   	private static testMethod void executeSetVariable(){
     	setVariable('','');
     	setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_SEARCHABLE_ADVANCED , '');
    }
    
    private static testmethod void executeViewLocationWithCustomFields(){
        //setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_BASIC , 'Account.Multiselect_Test__c');
        //setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_EDIT , 'Account.Multiselect_Test__c');
        //setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_OVERVIEW, 'Account.Multiselect_Test__c');
        setVariable(PartnerSearchConstants.CONFIG_KEY_FIELDS_DETAIL_LOCATION, 'Partner_Location__c.Website__c|Partner_Location__c.Street__c');
        executeViewLocation();
    }

    private static testmethod void executeViewLocation(){
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 25);
        PageReference pageRef = Page.PartnerDetails;
        Test.setCurrentPage(pageRef);
        
        PageUtils.put('id',locations[0].id);  
        PageUtils.put('pagesize','10');
        
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertEquals(null,controller.doOnLoad());
        
        List<FormField> editFields= controller.getEditFields();
        controller.setEditFields(editFields);
        System.assertEquals(false,controller.errorOccurred);
        System.assertNotEquals(null,controller.saveDetail());
        
        System.assertEquals(true,controller.getMessages().size()>0);
        
        System.assertNotEquals(null,controller.cancelDetail());
        setTestEmail(controller);
        System.assertNotEquals(null,controller.sendContactEmail());
        System.assertEquals(true,controller.getMessages().size()>0);
        System.assertNotEquals(null,controller.cancelContactEmail());
         
        controller.locationPaginator.setRecords(new List<Partner_Location__c>{locations[0]});
        
        controller.getSearchStateParams();
    }
    
    private static void setTestEmail(PartnerDetailsController controller){
        controller.senderEmailAddress='testemailsender@test.org';
        controller.senderEmailBody='test email!';
        controller.senderEmailSubject='test subject!';
        controller.senderEmailFullName='test sender';   
        System.assert(true);
    }
   
    private static void setVariable(String key, String value){
        if(StringUtils.isBlank(key)){
            return;
        }
        if(StringUtils.isBlank(value)){
            List<Configuration_Variable__c> variables = [select id from Configuration_Variable__c where name=:key];
            if(variables != null && variables.size() == 1){
                delete variables.get(0);    
            }
        } else {
            Configuration_Variable__c variable = new Configuration_Variable__c(name=key,value__c=value);
            upsert variable name;
        }
        System.assert(true);
    }

    private static void executeViewPartner(){
        Account thePartner = TestData.createTestPartner();
        List<Partner_Location__c> locations = TestData.createTestPartnerLocations(thePartner, 25);
        PageReference pageRef = Page.PartnerDetails;
        Test.setCurrentPage(pageRef);
        
        PageUtils.put('id',thePartner.id);
          
        PartnerDetailsController controller = new PartnerDetailsController();
        System.assertNotEquals(null,controller.getMessages());
        System.assertEquals(0,controller.getMessages().size());
        controller.clickTab();
        controller.updatePublishStatus();

        //System.runAs(partner){
            System.assertEquals(null,controller.doOnLoad());
        //}
        List<FormField> editFields= controller.getEditFields();
        controller.setEditFields(editFields);
        controller.saveDetail();
        controller.cancelDetail();
        //controller.search();
        setTestEmail(controller);
        controller.sendContactEmail();
        controller.handlePageChange(locations);
        PageUtils.put('locId',locations[2].Id);
        controller.deleteLocation();
    }
}