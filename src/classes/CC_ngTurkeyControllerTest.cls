@IsTest
private class CC_ngTurkeyControllerTest {

 @IsTest
  static void currentUser_should_get_current_user() {
    User currentUser = CC_ngTurkeyController.currentUser;
    String ldapId = CC_ngTurkeyController.userLDAPID;
    String fname = CC_ngTurkeyController.userFirstName;

    Test.startTest();
    currentUser.LDAP_Roles__c = 'Enterprise User';
    update currentUser;
    Test.stopTest();

    String cnValues = CC_ngTurkeyController.cnValues;
    System.assertEquals(UserInfo.getUserId(), currentUser.Id);
  }

  @IsTest
  static void should_get_env() {
    Boolean  isProd = CC_ngTurkeyController.isProd;
    Boolean isQA = CC_ngTurkeyController.isQA;
    System.assertNotEquals(null,isProd);
    System.assertNotEquals(null,isQA);
  }
    
    
  @IsTest
  static void should_fetchCaseByNumber() {
     CC_ngTurkeyController.fetchCaseByNumber('123456');
  }

/*    @IsTest
  static void should_get_user_Details() {
    String ldapId = CC_ngTurkeyController.userLDAPID;
    String fname = CC_ngTurkeyController.userFirstName;

    String cnValues = CC_ngTurkeyController.cnValues;
  }*/

  @IsTest
  static void userContext_should_get_json_string(){
    CC_ngTurkeyController.currentUser = new User(
      Id = CC_TestUtils.fakeId(User.SObjectType), 
      FirstName = 'Howard',
      LastName = 'TheDuck',
      Contact = new Contact(
        Id = CC_TestUtils.fakeId(Contact.SObjectType),
        SC_CONTACT_LDAP_DEFAULT_SITE_ID__c = '12345',
        SC_CONTACT_LDAPID__c = 'abcde'
        ),
      LDAP_Date_Format__c = 'dateFormat',
      LDAP_Time_Format__c = 'timeFormat'
      );
    Map<String, Object> userContext = (Map<String, Object>)JSON.deserializeUntyped(CC_ngTurkeyController.userContext);

    System.assert(userContext.containsKey('userId'));
    System.assertEquals(CC_ngTurkeyController.currentUser.Id,userContext.get('userId'));
    System.assert(userContext.containsKey('firstName'));
    System.assertEquals(CC_ngTurkeyController.currentUser.FirstName,userContext.get('firstName'));
    System.assert(userContext.containsKey('lastName'));
    System.assertEquals(CC_ngTurkeyController.currentUser.LastName,userContext.get('lastName'));
    System.assert(userContext.containsKey('contactId'));
    System.assertEquals(CC_ngTurkeyController.currentUser.Contact.Id,userContext.get('contactId'));
    System.assert(userContext.containsKey('defaultSiteId'));
    System.assertEquals(CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c,userContext.get('defaultSiteId'));
    System.assert(userContext.containsKey('connectId'));
    System.assertEquals(CC_ngTurkeyController.currentUser.Contact.SC_CONTACT_LDAPID__c,userContext.get('connectId'));
    System.assert(userContext.containsKey('dateTimeFormat'));
    System.assertEquals('dateFormat timeFormat',userContext.get('dateTimeFormat'));
    //System.assert(userContext.containsKey('csoBaseUrl'));
    System.assertEquals(CC_Settings.csoUrl, CC_ngTurkeyController.csoBaseUrl);
    System.assert(userContext.containsKey('timezoneOffsetInMillis'));
    System.assert(userContext.get('timezoneOffsetInMillis') instanceof Long);
    System.assertEquals(CC_Settings.careUrl, CC_ngTurkeyController.careURL);
    System.assertEquals(CC_Settings.globalScapeUrl, CC_ngTurkeyController.globalScapeUrl);
    System.assertEquals(CC_Settings.debugEnabled, CC_ngTurkeyController.debugEnabled);
    System.assertEquals(CC_Settings.csoShowSolutionURL, CC_ngTurkeyController.showSolURL);
    System.assertEquals(CC_Settings.cftp_url,CC_ngTurkeyController.cftpUrl);
    System.assertEquals(CC_Settings.cftp_Enabled,CC_ngTurkeyController.cftpEnabled); 
    System.assertEquals(CC_Settings.gs_Enabled,CC_ngTurkeyController.gsEnabled);
  }

  @IsTest
  static void fetchSitesAndProducts_should_fetch_sites_and_products() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    String siteId = 'siteId';
    String connectId = 'connectId';
    Id contactId = CC_TestUtils.fakeId(Contact.SObjectType);
    List<CC_ngTurkeyService.AllSites> allsitesList = new List<CC_ngTurkeyService.AllSites>();
      //Site_Association__c siterec= CC_TestUtils.buildNewSite(CC_TestUtils.fakeId(Site_Association__c.sObjectType));// CC_TestUtils.fakeId(Site_Association__c.sObjectType);
      CC_ngTurkeyService.AllSites allsitesRec = new CC_ngTurkeyService.AllSites('Site1', CC_TestUtils.fakeId(Site_Association__c.sObjectType), '12345','Normal Site');
      allsitesList.add(allsitesRec);
    turkeySvcMock.callLogger.recordCall(
      'fetchSitesAndProducts', 
      new Map<String, Object>{'siteId' => siteId, 'connectId' => connectId}, 
      new CC_ngTurkeyService.SiteProductAssociation[] {
        new CC_ngTurkeyService.SiteProductAssociation(
          allsitesList,
          new CA_Product_Controller__c(),
          new Product_Area__c()
          )
        });

    User currentUser = new User(Contact = new Contact(Id = contactId, SC_CONTACT_LDAP_DEFAULT_SITE_ID__c = siteId, SC_CONTACT_LDAPID__c = connectId));
    CC_ngTurkeyController.currentUser = currentUser;

    // When
    Test.startTest();
    CC_ngTurkeyService.SiteProductAssociation[] spas = (CC_ngTurkeyService.SiteProductAssociation[])CC_ngTurkeyController.fetchSitesAndProducts();
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
    System.assertEquals(1, spas.size());
  }

    @IsTest
  static void fetchRecentProduct_should_fetch_recent_product_area_from_cases() {
    // Given
    Id fakeProductId = CC_TestUtils.fakeId(CA_Product_Controller__c.SObjectType);
    Id fakeProductAreaId = CC_TestUtils.fakeId(Product_Area__c.SObjectType);
    CA_Product_Controller__c  caTestProd = CC_TestUtils.createProduct('TestProductController');
    List<Id> productIdList = new List<Id>();
    productIdList.add(caTestProd.Id);
    productIdList.add(fakeProductId);
    
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    turkeySvcMock.callLogger.recordCall(
      'fetchRecentProductArea', 
      null, 
      new Product_Area__c(Id = fakeProductAreaId)
    );

     buildCase();
     Product_Area__c lastUsedProductArea;
     //Id  productIdUsedOnCase;

    // When
    Test.startTest();
    lastUsedProductArea = (Product_Area__c)CC_ngTurkeyController.fetchRecentProductArea(productIdList);
    Test.stopTest();

    // Then
    System.assertEquals(lastUsedProductArea.Id, fakeProductAreaId);
    turkeySvcMock.callLogger.verify();
  }   

  @IsTest
  static void fetchMyCases_should_fetch_my_cases() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    turkeySvcMock.callLogger.recordCall(
      'fetchMyCases', 
      null, 
      new Case[] {
        buildCase(),
        buildCase(),
        buildCase()
        });

    // When
    Test.startTest();
    Case[] cases = CC_ngTurkeyController.fetchMyCases();
    Test.stopTest();

        // Then
    System.assertEquals(3, cases.size(), cases);
    turkeySvcMock.callLogger.verify();
            
  }

    @IsTest
  static void should_get_pendingCaseNumber() {
      CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
      Case aCase = buildCase();
      aCase.Next_Action__c = System.label.Pending_Customer ;

      Test.startTest();
      String s = CC_ngTurkeyController.pendingCaseNumber;
      Test.stopTest();
      System.assertNotEquals(null,s);
  }

  @IsTest
  static void fetchCasesByCriteria_should_fetch_cases_by_criteria() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    turkeySvcMock.callLogger.recordCall('fetchEntitledSitesofUser', null, new Set<Id>() );
    turkeySvcMock.callLogger.recordCall(
      'fetchCasesByCriteria', 
      null, 
      new Case[] {
        buildCase(),
        buildCase(),
        buildCase()
        });
    Id fakeSiteId = CC_TestUtils.fakeId(Site_Association__c.SObjectType);

    DateTime dt = DateTime.newInstance(2016, 6, 1, 0, 0, 0);
    String dateString = dt.formatGmt('yyyy-MM-dd\'T\'hh:mm:ss.sssZ');

    Map<String, Object> searchParams = new Map<String, Object>{
      'title' => 'title'
      ,'contactEmail' => 'contactEmail'
      ,'status' => 'status'
      ,'severity' => 1
      ,'product' => fakeSiteId
      ,'createdDateFrom' => dateString
      ,'createdDateTo' => dateString
      ,'lastModifiedDateFrom' => dateString
      ,'lastModifiedDateTo' => dateString
    };

    // When
    Test.startTest();
    Case[] cases = CC_ngTurkeyController.fetchCasesByCriteria(searchParams);
    Test.stopTest();

    // Then
    System.assertEquals(3, cases.size(), cases);
    turkeySvcMock.callLogger.verify();
    CC_ngTurkeyService.CaseSearchCriteria criteria = (CC_ngTurkeyService.CaseSearchCriteria)turkeySvcMock.callLogger.getCall('fetchCasesByCriteria').params.get('criteria');
    System.assertEquals(null, criteria.caseNumber);
    System.assertEquals(searchParams.get('title'), criteria.title);
    System.assertEquals(searchParams.get('contactEmail'), criteria.contactEmail);
    System.assertEquals(searchParams.get('status'), criteria.status);
    System.assertEquals(String.valueOf(searchParams.get('severity')), criteria.severity);
    System.assertEquals(searchParams.get('product'), criteria.product);
    //System.assertEquals(dt, criteria.createdDateFrom);
    //System.assertEquals(dt, criteria.createdDateTo);
    //System.assertEquals(dt, criteria.lastModifiedDateFrom);
    //System.assertEquals(dt, criteria.lastModifiedDateTo);
  }

  @IsTest
  static void search_criteria_does_not_fuck_up_dates() {
      String inDate = '2017-02-07T23:59:59';
      
      //this.createdDateTo:2017-02-07 18:29:59
      CC_ngTurkeyService.CaseSearchCriteria scriteria = CC_ngTurkeyController.dataToSearchCriteria(new Map<String, Object>{
          'createdDateTo' => inDate
              });
      String normalizedDateString  = inDate.replace('T', ' ');
      DateTime dt = DateTime.valueOf(normalizedDateString);
      String formattedDateTime = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT'); 
      formattedDateTime = formattedDateTime.replace(' ','T');
      formattedDateTime = formattedDateTime+'Z';
      System.assertEquals(  'CreatedDate <= '+formattedDateTime, scriteria.buildClauses(true)[0]);
  }

  @IsTest
  static void fetchCasesByCriteria_should_fetch_cases_by_criteria_case_number_only() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    turkeySvcMock.callLogger.recordCall('fetchEntitledSitesofUser', null, new Set<Id>() );    
    turkeySvcMock.callLogger.recordCall(
      'fetchCasesByCriteria', 
      null, 
      new Case[] {
        buildCase(),
        buildCase(),
        buildCase()
        });
    Id fakeSiteId = CC_TestUtils.fakeId(Site_Association__c.SObjectType);
    Datetime now = DateTime.now();
    Map<String, Object> searchParams = new Map<String, Object>{
      'caseNumber' => 'caseNumber'
      ,'title' => 'title'
      ,'contactEmail' => 'contactEmail'
      ,'status' => 'status'
      ,'severity' => 'severity'
      ,'product' => fakeSiteId
      ,'createdDateFrom' => now
      ,'createdDateTo' => now
      ,'lastModifiedDateFrom' => now
      ,'lastModifiedDateTo' => now
    };

    // When
    Test.startTest();
    Case[] cases = CC_ngTurkeyController.fetchCasesByCriteria(searchParams);
    Test.stopTest();

    // Then
    System.assertEquals(3, cases.size(), cases);
    turkeySvcMock.callLogger.verify();
    CC_ngTurkeyService.CaseSearchCriteria criteria = (CC_ngTurkeyService.CaseSearchCriteria)turkeySvcMock.callLogger.getCall('fetchCasesByCriteria').params.get('criteria');
    System.assertEquals(searchParams.get('caseNumber'), criteria.caseNumber);
    System.assertEquals(null, criteria.title);
    System.assertEquals(null, criteria.contactEmail);
    System.assertEquals(null, criteria.status);
    System.assertEquals(null, criteria.severity);
    System.assertEquals(null, criteria.product);
    System.assertEquals(null, criteria.createdDateFrom);
    System.assertEquals(null, criteria.createdDateTo);
    System.assertEquals(null, criteria.lastModifiedDateFrom);
    System.assertEquals(null, criteria.lastModifiedDateTo);
  }

  @IsTest
  static void fetchCase_should_fetch_case_by_id_with_owner_details() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    CC_TestUtils.setUpTestAWSToken();
    Id fakeUserId = CC_TestUtils.fakeId(User.SObjectType);
    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType);
    String tmp = '\"attributes\":{\"type\":\"Case\",\"url\":\"/services/data/v38.0/sobjects/Case/'+fakeCaseId+'\"},\"Id\":\"'+fakeCaseId+'\",\"OwnerId\":\"'+fakeUserId+'\"';
    turkeySvcMock.callLogger.recordCall(
      'fetchCaseById', 
      new Map<String, Object>{'caseId' => fakeCaseId}, 
      new Case(Id = fakeCaseId, OwnerId = fakeUserId));
    turkeySvcMock.callLogger.recordCall(
      'fetchCaseActivitiesById', 
      new Map<String, Object>{'caseId' => fakeCaseId}, 
      tmp);      
    turkeySvcMock.callLogger.recordCall(
      'fetchCaTechniciansForCases', 
      null, 
      new User[] {new User(Id = fakeUserId)});

    // When
    Test.startTest();
    Map<String, Object> jsonCase = CC_ngTurkeyController.fetchCase(fakeCaseId);
    Test.stopTest();

    // Then
    System.assert( jsonCase != null );
    System.assert( jsonCase.get('Id') == fakeCaseId );
    System.assert( jsonCase.get('OwnerId') == fakeUserId );
    System.assert( jsonCase.containsKey('Owner') );
    System.assert( ((Map<String, Object>)jsonCase.get('Owner')).get('Id') == fakeUserId );

    //Case[] casesParam = (Case[])turkeySvcMock.callLogger.getCall('fetchCaTechniciansForCases').params.get('cases');
    //System.assertEquals(fakeUserId, casesParam[0].OwnerId);
    //turkeySvcMock.callLogger.verify();
  } 

 
  @IsTest
  static void should_fetch_Sites(){
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    String siteId = 'siteId';
    String connectId = 'connectId';
    Id contactId = CC_TestUtils.fakeId(Contact.SObjectType);
    turkeySvcMock.callLogger.recordCall(
      'fetchSites', null,null
      //new Map<String, Object>{'siteId' => siteId, 'connectId' => connectId}, null
      //new CC_ngTurkeyService.AllSites('Site1', CC_TestUtils.fakeId(Site_Association__c.sObjectType), '12345','Normal Site')
    );
    Test.startTest();
    CC_ngTurkeyController.fetchSites();
    Test.stopTest();
  }
    
    
  @IsTest
  static void findSupportArticles_should_fetch_support_articles() {
    // Given
    CC_SearchItServiceMock searchItMock = buildSearchItMock();
    String title = 'title';
    Id productId = CC_TestUtils.fakeId(CA_Product_Controller__c.SObjectType);
    CC_SearchItService.SearchItResults searchItResults = new CC_SearchItService.SearchItResults(null, null, null, null);
    searchItMock.callLogger.recordCall(
      'doSearch',
      new Map<String, Object>{ 'title' => title, 'productId' => productId },
      searchItResults
      );
    Map<String, String> data = new Map<String, String>{
      'title' => title,
      'productId' => productId
    };

    // When
    CC_SearchItService.SearchItResults results = CC_ngTurkeyController.findSupportArticles(data);

    // Then
    searchItMock.callLogger.verify();
    System.assertEquals(searchItResults, results);
  } 

  @IsTest
  static void createCase_should_create_clean_case() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    Case aCase = buildCase();

    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType);
    Case returnCase = aCase.clone();
    returnCase.Id = fakeCaseId;
    turkeySvcMock.callLogger.recordCall('createCase', null, returnCase);
    turkeySvcMock.callLogger.recordCall('addCaseComment', null, new CC_ngTurkeyController.CaseCommentType());
    turkeySvcMock.callLogger.recordCall('fetchEntitledSitesofUser', null, new Set<Id>() );
    Test.setMock(HttpCalloutMock.class, new CC_AWSMock());
    //turkeySvcMock.callLogger.recordCall('hasAccesstoThisSiteandProductFromEER', null, true );    
    //turkeySvcMock.callLogger.recordCall('hasAccesstoThisSiteandProductFromEER', new Map<String, Object>{ 'connectId' => aCase.ContactId,'fetchedCase' => null,'siteId' => null }, true );
   
    User currentUser = new User(Contact = new Contact(Id = CC_TestUtils.fakeId(Contact.SObjectType)));
    CC_ngTurkeyController.currentUser = currentUser;

    // When
    Map<String, Object> caseData = new Map<String, Object>{
      'businessImpact' => aCase.Business_Impact__c
      ,'description' => aCase.Description
      ,'severity' => aCase.Severity__c
      ,'title' => aCase.Subject
      ,'siteId' => aCase.Site_Association__c
      ,'productId' => aCase.CA_Product_Controller__c
      ,'productName' => 'My Product'
      ,'release' => 'N/A'
      ,'servicePack' => 'N/A'
      ,'operatingSystem' => 'N/A'
    };
    Test.startTest();
    Id result = CC_ngTurkeyController.createCase(caseData);
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
    Case caseParam = (Case)turkeySvcMock.callLogger.getCall('createCase').params.get('aCase');
    System.assertEquals(aCase.Business_Impact__c, caseParam.Business_Impact__c);
    System.assertEquals(aCase.Description, caseParam.Description);
    System.assertEquals(aCase.Severity__c, caseParam.Severity__c);
    System.assertEquals(aCase.Subject, caseParam.Subject);
    System.assertEquals(aCase.Site_Association__c, caseParam.Site_Association__c);
    System.assertEquals(aCase.CA_Product_Controller__c, caseParam.CA_Product_Controller__c);
    System.assertEquals(currentUser.Contact.Id, caseParam.ContactId);
    System.assertEquals(null, caseParam.Id);

    CC_ngTurkeyController.CaseCommentType caseCommentParam = (CC_ngTurkeyController.CaseCommentType)turkeySvcMock.callLogger.getCall('addCaseComment').params.get('CaseCommentType');
    //System.assertEquals(null, caseCommentParam.Id);
    //System.assertEquals('Product: My Product, Release: N/A, Service Pack: N/A, Operating System: N/A', caseCommentParam.CommentBody);
    CC_Layer7ServiceTest.inserAwsToken();
    CC_ngTurkeyController.fetchSolutions(caseParam.caseNumber);
    
  }

   @IsTest
  static void createCase_should_throw_community_exception_on_error() {
    //CC_ngTurkeyController.CommunityException caught;
    Exception caught;
    try {
      CC_ngTurkeyController.createCase(null);
      } /*catch (CC_ngTurkeyController.CommunityException cex) {
        caught = cex;
      } */
      catch (Exception cex){
          caught = cex;
      }
      System.assertNotEquals(null, caught);
    }

    @IsTest
    static void createCaseComment_should_create_case_comment() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType);
    CaseComment comment = new CaseComment(ParentId = fakeCaseId, CommentBody = 'Comment',isPublished= true);
    CaseComment commentClone = comment.clone();
    commentClone.Id = CC_TestUtils.fakeId(CaseComment.SObjectType);
    CC_ngTurkeyController.CaseCommentType ct= new CC_ngTurkeyController.CaseCommentType();
    ct.ParentId=fakeCaseId;
    ct.CommentBody='Case Comment';
    ct.ID=CC_TestUtils.fakeId(CaseComment.SObjectType);
    turkeySvcMock.callLogger.recordCall('addCaseComment', new Map<String, Object> {'caseComment' => comment}, ct);

    Map<String, String> commentData = new Map<String, String>{
      'caseId' => (String)fakeCaseId,
      'comment' => 'Comment',
      'isInternal'=> 'true'
    };
    // When
    Test.startTest();
    CC_ngTurkeyController.CaseCommentType result = CC_ngTurkeyController.createCaseComment(commentData);
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
    System.assertEquals(ct.Id, result.Id);
  }

  @IsTest
  static void closeCase_should_close_case() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType);
    String commentBody = 'commentBody';
    turkeySvcMock.callLogger.recordCall('closeCase', new Map<String, Object> {'caseId' => fakeCaseId, 'commentBody' => commentBody}, null);

    // When
    Test.startTest();
    CC_ngTurkeyController.closeCase(new Map<String, String> {'caseId' => fakeCaseId, 'comment' => commentBody});
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
  }

  @IsTest
  static void reopenCase_should_reopen_case() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType);
    String commentBody = 'commentBody';
    turkeySvcMock.callLogger.recordCall('reopenCase', new Map<String, Object> {'caseId' => fakeCaseId, 'commentBody' => commentBody}, null);

    // When
    Test.startTest();
    CC_ngTurkeyController.reopenCase(new Map<String, String> {'caseId' => fakeCaseId, 'comment' => commentBody});
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
  }

  @IsTest
  static void updateConfAtth_should_call_updateConfAtth_on_turkey_service() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType); 
    String controllerStat = 'true';
    Boolean serviceStat = !Boolean.valueOf(controllerStat);
    turkeySvcMock.callLogger.recordCall('updateConfAtth', new Map<String, Object> {'caseId' => fakeCaseId, 'stat' => serviceStat}, null);

    // When
    Test.startTest();
    CC_ngTurkeyController.updateConfAtth(new Map<String, String> {'caseId' => fakeCaseId, 'stat' => controllerStat});
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
  }

  @IsTest
  static void changeSeverity_should_change_severity() {
    // Given
    CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
    Id fakeCaseId = CC_TestUtils.fakeId(Case.SObjectType);
    String severity = '2';
    String commentBody = 'commentBody';
    turkeySvcMock.callLogger.recordCall('changeSeverity', new Map<String, Object> {'caseId' => fakeCaseId, 'newSeverity' => severity, 'commentBody' => commentBody}, null);

    // When
    Test.startTest();
    CC_ngTurkeyController.changeSeverity(new Map<String, String> {'caseId' => fakeCaseId, 'newSeverity' => severity, 'comment' => commentBody});
    Test.stopTest();

    // Then
    turkeySvcMock.callLogger.verify();
  }

  @IsTest
  static void it_should_redirect_to_accessDenied_page_if_role_not_allowed(){
    CC_TestUtils.enableUserDml();
    User u = CC_TestUtils.buildUser();
    insert u;
    CC_Settings.allowAccessRoles = new Set<String>{'role 2', 'another role'};
    CC_ngTurkeyController controller = new CC_ngTurkeyController();
    System.runAs(u){
      PageReference expected = Page.CC_AccessDenied;
      PageReference reference = controller.redirect();
      System.assertEquals(expected.getUrl() ,reference.getUrl());
    }
  }

  @IsTest
  static void it_should_go_to_turkey_page_if_role_is_allowed(){
    CC_TestUtils.enableUserDml();
    User u = CC_TestUtils.buildUser();
    insert u;
    CC_Settings.allowAccessRoles = new Set<String>{'sc_test', 'another role'};
    CC_ngTurkeyController controller = new CC_ngTurkeyController();
    System.runAs(u){
      CC_ngTurkeyController.currentUser = null;
      PageReference reference = controller.redirect();
      System.assertEquals(null,reference);
    }
  }

  @IsTest
  static void redirect_should_handle_null_roles(){
    CC_ngTurkeyController controller = new CC_ngTurkeyController();
    CC_ngTurkeyController.currentUser = new User();
    PageReference reference = controller.redirect();
    PageReference expected = Page.CC_AccessDenied;
    System.assertEquals(expected.getUrl() ,reference.getUrl());
  }

  @IsTest
  static void should_fetchLiveChatDetails(){     
      CA_Product_Controller__c testProduct = CC_TestUtils.createProduct('TestProductController');
      Test.startTest();
      String productButtonId = CC_ngTurkeyController.fetchLiveChatDetails('TestProductController');
      Test.stopTest();
      if(testProduct.Product_Button__c != null)
          System.assertNotEquals(null,productButtonId);
  }

  @IsTest
  static void should_fetchLiveChatDeploymentScriptDetails(){
        LiveAgentDeployment__c laDeploymentDetails = new LiveAgentDeployment__c();
        laDeploymentDetails.Name = 'Test LA Deployment Details ';
        laDeploymentDetails.ClientCode__c = '572a00000004aAi';
        laDeploymentDetails.ClientKey__c = '00De0000005F05F' ;
        laDeploymentDetails.LiveagentSctiptUrl__c = 'https://c.la2c1cs.salesforceliveagent.com/content/g/js/39.0/deployment.js' ;
        laDeploymentDetails.LiveChatJsUrl__c = 'https://d.la2c1cs.salesforceliveagent.com/chat';
        insert laDeploymentDetails;
        Test.startTest();
       LiveAgentDeployment__c lad = CC_ngTurkeyController.fetchLiveChatDeploymentScriptDetails();
       Test.stopTest();
       System.assertNotEquals(null,lad);
  } 

  @IsTest
  static void should_invokeL7GSService(){
        String siteId = '105246';
        String caseNumber = '123456';
        String tmp = 'OK..200';  
        Id contactId = CC_TestUtils.fakeId(Contact.SObjectType);
      
      CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
        turkeySvcMock.callLogger.recordCall(
        'invokeL7GSService', 
        new Map<String, Object>{'siteId' => siteId, 'caseNumber' => caseNumber}, 
        tmp
     );     
      
        Test.startTest();
          String response =  CC_ngTurkeyController.invokeL7GSService (siteId, caseNumber);
          //System.debug('response:'+response);
        Test.stopTest();
      System.assertNotEquals(null,response);
  }
  
    @IsTest
  static void should_getIsRECapabale(){
        String prodName = 'test';
        boolean tmp = true;  
        Id contactId = CC_TestUtils.fakeId(Contact.SObjectType);      
      CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
        turkeySvcMock.callLogger.recordCall(
        'getIsRECapabale', 
        new Map<String, Object>{'prodName' => prodName}, 
        tmp
     );
        Test.startTest();
          boolean response =  CC_ngTurkeyController.getIsRECapabale(prodName);
        Test.stopTest();
      System.assertNotEquals(null,response);
  }
    
   /* @IsTest
  static void should_getProductAreas(){
        String productName = 'test';
      List<Object> tmp = new  List<Object>();
      tmp.add(new Product_Area__c(name = 'test'));
        Id contactId = CC_TestUtils.fakeId(Contact.SObjectType);    
      Id prodAreaId = CC_TestUtils.fakeId(Product_Area__c.SObjectType);
      CC_ngTurkeyServiceMock turkeySvcMock = buildTurkeyMock();
        turkeySvcMock.callLogger.recordCall(
        'getProductAreas', 
        new Map<String, Object>{'productName' => productName}, 
         new Product_Area__c[] {new Product_Area__c(Id = prodAreaId)}
     );
        Test.startTest();
          List<Object> response =  CC_ngTurkeyController.getProductAreas(productName);
          System.debug('response:'+response);
        Test.stopTest();
      System.assertNotEquals(null,response);
  }*/
    
     @IsTest
    static void test_fetchHelpTextLinks(){
        String s = CC_ngTurkeyController.fetchHelpTextLinks; 
        System.assertNotEquals(null,s);
    }

    
   @IsTest
    static void test_prepareErrorLogRecord(){
        CC_ngTurkeyController.prepareErrorLogRecord('testErrorMessage', 'test Path', true); 
    }
    
    @IsTest
    static void test_insertCCErrorLog(){
        CC_ngTurkeyController.insertCCErrorLog('testErrorMessage', 'test Path');
    } 
private static void mockFetchCase(CC_ngTurkeyServiceMock turkeySvcMock, Id fakeCaseId) {
    Id fakeUserId = CC_TestUtils.fakeId(User.SObjectType);
    turkeySvcMock.callLogger.recordCall(
      'fetchCaseById', 
      new Map<String, Object>{'caseId' => fakeCaseId}, 
      new Case(Id = fakeCaseId, OwnerId = fakeUserId));
    turkeySvcMock.callLogger.recordCall(
      'fetchCaTechniciansForCases', 
      null, 
      new User[] {new User(Id = fakeUserId)});
  }

  private static Case buildCase() {
    return new Case(
      Id = CC_TestUtils.fakeId(Case.SObjectType),
      Business_Impact__c = 'Business_Impact__c',
      Description = 'Description',
      Severity__c = '3',
      Subject = 'Subject',
      Site_Association__c = CC_TestUtils.fakeId(Site_Association__c.SObjectType),
      CA_Product_Controller__c = CC_TestUtils.fakeId(CA_Product_Controller__c.SObjectType),
      Title__c = 'Title__c'
      );
  }

  private static CC_ngTurkeyServiceMock buildTurkeyMock() {
    CC_ngTurkeyServiceMock turkeySvcMock = new CC_ngTurkeyServiceMock();
    CC_ngTurkeyController.turkeySvc = turkeySvcMock;
    return turkeySvcMock;
  }

  private static CC_SearchItServiceMock buildSearchItMock() {
    CC_SearchItServiceMock mock = new CC_SearchItServiceMock();
    CC_ngTurkeyController.searchItSvc = mock;
    return mock;
  }
}