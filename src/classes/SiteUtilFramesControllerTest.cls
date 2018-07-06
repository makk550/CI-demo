@IsTest(seeAllData=true)
public class SiteUtilFramesControllerTest {
    static testmethod void testingUtilFramesControllerService(){
        
        List<SiteUtilServicesDataWrapper.Data> offeringDetailsWrapperList=new List<SiteUtilServicesDataWrapper.Data>();
        SiteUtilServicesDataWrapper.Error OfferingErrorDetailsWrapper=new SiteUtilServicesDataWrapper.Error();
        String topsSiteID='105246';
         Boolean isDetailsPresent;
        Boolean isRecordsPerPage;
        String  startRecNum='1';
        Boolean executeFlow=true;
        String caProductName='CA Product';
        String serviceName='';
        String[] values=null;
        String getAccessToken='';
        String entitlementOfferingCodeSelected;
        String nonContractOfferingBusinessId=null;
        String contractOfferingBusinessId=null;
        
        Test.startTest();
  
        Account testAccount = new Account();
        testAccount.Name = 'TestAutoAssignOffering'; 
        testAccount.Enterprise_ID__c = '7777777777';
        testAccount.BillingStreet='Street';
        testAccount.BillingCountry='US';
        testAccount.BillingCity='Islandia'; 
        insert testAccount ; 
        
        Site_Association__c testSiteAssociation = new Site_Association__c();
        testSiteAssociation.Name = '0003 ADITYA TECHNOLOGIES, INCM';
        testSiteAssociation.SAP_Site_ID__c = '280125';
        testSiteAssociation.SC_SITE_Sanctioned_Party__c = 'NO';
        testSiteAssociation.Enterprise_ID__c = testAccount.Id;
        testSiteAssociation.SC_TOPS_ID__c = '1299636';
        testSiteAssociation.Country_picklist__c= 'US - UNITED STATES';
        testSiteAssociation.State__c='New York';
        testSiteAssociation.ProviSite__c = 1;
        insert testSiteAssociation ;
        
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='CA Product';
        insert prodCtl;
        
        Offering_Business_Rules__C offeringBusinessRulesObj=new Offering_Business_Rules__C();
        offeringBusinessRulesObj.Offering_Code__c='U1001';
        offeringBusinessRulesObj.Precedence__c = '99';
        Database.insert(offeringBusinessRulesObj,false);
        
        Non_Contract_Offering_Business_Rules__c nonContractOffering = new Non_Contract_Offering_Business_Rules__c();
        nonContractOffering.Site_Association__c=testSiteAssociation.Id;
        nonContractOffering.CA_Product_Controller__c = prodCtl.Id;
        nonContractOffering.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        nonContractOffering.Start_Date__c = Date.today();
        nonContractOffering.End_Date__c = Date.today().addDays(2);   
        Database.SaveResult result = Database.insert(nonContractOffering, false);
        
        
        PageReference pageRef = Page.SiteUtilSupportServicesDetails;
        pageRef.getParameters().put('id', testSiteAssociation.id);
        Test.setCurrentPage(pageRef);
        for(Integer i=1;i<11;i++){   
            SiteUtilServicesDataWrapper.Data serviceDetailsWrapper=new SiteUtilServicesDataWrapper.Data();
            serviceDetailsWrapper.topsProdDesc='WKLD AUTOMTN';
            serviceDetailsWrapper.topsPRNum='ATASVV99000'+i;
            serviceDetailsWrapper.assignedEngineer='Aditya000'+i;
            serviceDetailsWrapper.cAProductName='CA Product';
            serviceDetailsWrapper.offeringStartDT=System.now()+'';
            serviceDetailsWrapper.offeringEndDT=System.now()+'';
            serviceDetailsWrapper.offeringCode='U100'+i;
            serviceDetailsWrapper.topSiteID=i+'';          
            offeringDetailsWrapperList.add(serviceDetailsWrapper);   
            serviceDetailsWrapper.compareTo(serviceDetailsWrapper);
        }
        serviceName='EntitlementService';
        values=new String[3];
        values=SiteUtilServicesHandler.buildServiceInput(topsSiteID, caProductName, startRecNum, serviceName);
        serviceName='SupportingOffering';
        values=new String[4];
        values=SiteUtilServicesHandler.buildServiceInput(topsSiteID, caProductName, startRecNum, serviceName);       
        SiteUtilServicesCallout siteUtilServicesCallout=new SiteUtilServicesCallout();
         Layer7UtilCallout layer7Callout=new Layer7UtilCallout();
        siteUtilServicesCallout.buildGetRequestInput(values, serviceName);
        try{
           values=SiteUtilServicesHandler.buildServiceInput(null,null,null,null); 
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        }
        try{
           String val=SiteUtilServicesHandler.getServiceDetails(null,null,null,null); 
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        }
        try{
           SiteUtilServicesDataWrapper serviceDetailsWrapper=SiteUtilServicesHandler.getServiceResponseList(null); 
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        }
        try{
           String val=SiteUtilServicesHandler.invokeService(null); 
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        } 
        try{
          List<SiteUtilServicesDataWrapper.Data> serviceDetailsWrapper=SiteUtilServicesHandler.getDataWrapperList(null); 
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        } 
        serviceName='EntitlementService';
        values=new String[3];
        values=SiteUtilServicesHandler.buildServiceInput(topsSiteID, caProductName, startRecNum, serviceName);
        siteUtilServicesCallout.buildGetRequestInput(values, serviceName);
        try {
            siteUtilServicesCallout.invokeServiceAPI(null,serviceName);           
        }catch(SiteUtilServicesCustomException e) {
             System.assertEquals(null,e.message);
        }
        serviceName='SupportingOffering';
        values=new String[3];
        values=SiteUtilServicesHandler.buildServiceInput(topsSiteID, caProductName, startRecNum, serviceName);
        siteUtilServicesCallout.buildGetRequestInput(values, serviceName);
        try {
            layer7Callout.getAccessToken();           
        }catch(SiteUtilServicesCustomException e) {
             System.assertEquals(null,e.message);
        }
        try{
             layer7Callout.getStoredToken();
        }        
        catch(SiteUtilServicesCustomException e) {
             System.assertEquals(null,e.message);
        }
        try{
             layer7Callout.saveorUpdateToken('');
        }catch(SiteUtilServicesCustomException e){
             System.assertNotEquals(null,e.message);
        }      
                 
        String response='{'+
            '\"access_token\": \"e1ddf7da-2950-4aca-bc7d-84ac070aa0b4\", '+
            '\"token_type\": \"Bearer\",'+
            '\"expires_in\": \"3600\",'+
            '\"scope\": \"oob\"'+
            '}' ;   
        System.assertNotEquals('e1ddf7da-2950-4aca-bc7d-84ac070aa0b4', layer7Callout.getActualTokenFormat(response));
              response='{'+            
            '\"error\": \"invalid_request\", '+
            '\"error_description\": \"Invalid grant_type\"'+          
            '}' ;    
        serviceName='EntitlementService';
        String getOnFlyccessToken='e1ddf7da-2950-4aca-bc7d-84ac070aa0b4';
         try{
            layer7Callout.invokeLayer7ServiceForTokenExpiry(null,response, getOnFlyccessToken);
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        }
        try{
            layer7Callout.processLayer7Services(null);
        }catch(SiteUtilServicesCustomException e){
            System.assertEquals(null,e.message);
        }
        SiteUtilServicesCustomException except=new SiteUtilServicesCustomException();
        except.SiteUtilServicesCustomException('message');           
         SiteUtilFramesController siteXX=new SiteUtilFramesController();   
        siteXX.executeDetails();
        siteXX.executePaginationFlow(topsSiteID, startRecNum);        
        ApexPages.StandardController sc = new ApexPages.StandardController(testSiteAssociation);
        ApexPages.currentPage().getParameters().put(System.Label.OfferingCaseFieldIdSitePage,'0003 ADITYA TECHNOLOGIES, INCM');      
        siteXX=new SiteUtilFramesController(sc);
        System.assertNotEquals('1299636',siteXX.topsSiteID);         
        siteXX.getMore();
        siteXX.getPrevious();
        siteXX.gottodirectCasePage();
        String searchTerm='CA';
        SiteUtilFramesController.searchSiteList(searchTerm);
        searchTerm='105246';
        SiteUtilFramesController.searchSiteList(searchTerm);  
        
         SiteUtilFramesController.testFlagHandler=true;
        siteXX.executePaginationFlow(topsSiteID, startRecNum); 
        SiteUtilFramesController.testFlagWrapper=true;
        siteXX.executePaginationFlow(topsSiteID, startRecNum); 
        SiteUtilFramesController.testFlagService=true;
        siteXX.executePaginationFlow(topsSiteID, startRecNum);   
        siteXX.executePaginationFlow(null, null);
        siteXX.executeOfferingServiceDetails();
        siteXX.resetValues();        
        Test.stopTest();
    }
 }