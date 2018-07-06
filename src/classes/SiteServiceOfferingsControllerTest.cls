@IsTest(seeAllData=true)
public class SiteServiceOfferingsControllerTest {
    static testmethod void testingSupportOfferingService(){
        
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
        
        Test.startTest();
  
        Account testAccount = new Account();
        testAccount.Name = 'TestAutoAssignOffering'; 
        testAccount.Enterprise_ID__c = '7777777777';
        testAccount.BillingStreet='Street';
        testAccount.BillingCountry='US';
        testAccount.BillingCity='Islandia'; 
        insert testAccount ; 

        Account testAccount2 = new Account();
        testAccount2.Name = 'TestAutoAssignOffering2'; 
        testAccount2.Enterprise_ID__c = '7777777778';
        testAccount2.BillingStreet='Street';
        testAccount2.BillingCountry='US';
        testAccount2.BillingCity='California'; 
        insert testAccount2 ;        
        
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
       
        //**** NCR Changes
        CA_Product_Controller__c prodCtl = new CA_Product_Controller__c();
        prodCtl.name='CA Product';
        insert prodCtl;        

        Offering_Business_Rules__C offeringBusinessRulesObj=new Offering_Business_Rules__C();
        offeringBusinessRulesObj.Offering_Code__c='ESSGOLD';
        insert offeringBusinessRulesObj;

        Non_Contract_Offering_Business_Rules__c nonContractOffering = new Non_Contract_Offering_Business_Rules__c();
        nonContractOffering.Site_Association__c=testSiteAssociation.Id;
        nonContractOffering.CA_Product_Controller__c = prodCtl.Id;
        nonContractOffering.Offering_Business_Rules__c = offeringBusinessRulesObj.Id;
        nonContractOffering.Start_Date__c = Date.today();
        nonContractOffering.End_Date__c = Date.today().addDays(2);        
        insert nonContractOffering;

        //**** NCR Changes
        
        PageReference pageRef = Page.SiteServiceOfferingsDetails;
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
       			siteUtilServicesCallout.invokeServiceAPI(null,serviceName);           
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
        serviceName='SupportingOffering';
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
         SiteServiceOfferingsController siteXX=new SiteServiceOfferingsController();       
        siteXX.executeDetails();
        siteXX.executePaginationFlow(topsSiteID, startRecNum);        
        ApexPages.StandardController sc = new ApexPages.StandardController(testSiteAssociation);
        siteXX=new SiteServiceOfferingsController(sc);
        System.assertEquals('1299636',siteXX.topsSiteID); 
        SiteServiceOfferingsController.testFlagHandler=true;
        siteXX.executePaginationFlow(topsSiteID, startRecNum); 
        SiteServiceOfferingsController.testFlagWrapper=true;
        siteXX.executePaginationFlow(topsSiteID, startRecNum);
        SiteServiceOfferingsController.testFlagService=true;
        siteXX.executePaginationFlow(topsSiteID, startRecNum); 

        SiteServiceOfferingsController siteXX2=new SiteServiceOfferingsController(sc);
        sitexx2.executeFlow = true;
        siteXX2.executeDetails();
        siteXX2.precendenceList();

         delete nonContractOffering;
         siteXX2.executeDetails();

        Test.stopTest();
    }
 }