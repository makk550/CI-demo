@IsTest
private class CC_SamlJitHandlerTest {
  private static final Id samlSsoProviderId = null;
  private static final Id communityId = CC_TestUtils.fakeId(Network.SObjectType);
  private static final Id portalId = null; 
  private static final String federationIdentifier = 'wasabi02@ca.com';
  private static final Map<String, String> attributes = new Map<String, String>{
    'Email' => 'wasabi@wasa.bi',
    'FirstName' => 'Wasa',
    'LastName' => 'BiWithLongLastName',
    'ConnectTimezone' => '(GMT+09:00)Osaka,Sapporo,Tokyo',
    'Username' => 'wasabi02@ca.com',
    'ConnectUserID' => 'wasabi02',
    'ConnectSiteID' => '12345',
    'uCountry' => 'US',
    'ConnectUserLanguage' => 'ENG',
    'connectmemberof' => 'cn=SCONNECT_CA_USER_TEST,ou=Connect Authority,o=Computer Associates,c=US^cn=SConnect_Impleng_Test, ou=Connect Authority,o=Computer Associates,c=US'
  };
  private static final String assertion = '';
  private static final String tokyoTimezone = CC_Utils.resolveLdapTimezone(attributes.get('ConnectTimezone'));

	@isTest
  static void createUser_should_create_new_user_and_contact() {
    insert CC_TestUtils.buildNewSite('12345');
    CC_SamlJitHandler jitHandler = buildJitHandler(null);
    MockDmlHandler mockDmlHandler = (MockDmlHandler)jitHandler.dmlHandler;

    // When
    User resultUser = jitHandler.createUser(samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);

    // Then
    System.assertEquals(true, mockDmlHandler.commitDataCalled);
    System.assertNotEquals(null, resultUser);
    System.assertEquals(null, resultUser.Id);
    Contact resultContact = mockDmlHandler.jitContact;
    System.assertEquals(null, resultContact.Id);
  }

  @isTest
  static void updateUser_should_update_user_and_contact() {
    // Given
    Id userId = [SELECT Id, ContactId FROM User WHERE IsActive = true AND ContactId != null LIMIT 1].Id;
    CC_SamlJitHandler jitHandler = buildJitHandler(null);
    MockDmlHandler mockDmlHandler = (MockDmlHandler)jitHandler.dmlHandler;

    // When
    jitHandler.updateUser(userId, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);

    // Then
    System.assertEquals(true, mockDmlHandler.commitDataCalled);
    User resultUser = mockDmlHandler.jitUser;
    System.assertNotEquals(null, resultUser);
    System.assertEquals(userId, resultUser.Id);
    Contact resultContact = mockDmlHandler.jitContact;
    System.assertNotEquals(null, resultContact);
  }

  @IsTest
  static void handleContact_should_populate_new_contact_for_insert() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(new User());

    // When
    jitHandler.handleContact();

    // Then
    Contact result = jitHandler.jitContact;
    System.assertEquals(null, result.Id);
    System.assertEquals(attributes.get('Email'), result.Email);
    System.assertEquals(attributes.get('FirstName'), result.FirstName);
    System.assertEquals(attributes.get('LastName'), result.LastName);
    System.assertEquals(attributes.get('ConnectUserID'), result.SC_CONTACT_LDAPID__c);
    System.assertEquals(attributes.get('ConnectSiteID'), result.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c);
    System.assertEquals(false, result.SC_CONTACT_In_Active__c);
    System.assert(result.Country_Picklist__c.startsWith('US'));
    System.assertEquals('English', result.Language_Preference__c);
  }

  @IsTest
  static void handleContact_should_populate_existing_contact_for_update() {
    // Given
    Contact c = buildContact();
    insert c;
    User u = new User(ContactId = c.Id);
    CC_SamlJitHandler jitHandler = buildJitHandler(u);


    // When
    jitHandler.handleContact();

    // Then
    Contact result = jitHandler.jitContact;
    System.assertEquals(c.Id, result.Id);
    System.assertEquals(null, result.Email);
    System.assertEquals(null, result.FirstName);
    System.assertEquals(null, result.LastName);
    System.assertEquals(attributes.get('ConnectUserID'), result.SC_CONTACT_LDAPID__c);
    System.assertEquals(attributes.get('ConnectSiteID'), result.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c);
    System.assertEquals(false, result.SC_CONTACT_In_Active__c);
    System.assert(result.Country_Picklist__c.startsWith('US'));
    System.assertEquals('English', result.Language_Preference__c);
  }

  @IsTest
  static void handleUser_should_populate_new_user_for_insert() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(new User());
    String expectedRoles = 'SCONNECT_CA_USER_TEST;SConnect_Impleng_Test';

    // When
    jitHandler.handleUser();

    // Then
    User result = jitHandler.jitUser;
    System.assertEquals(null, result.Id);
    System.assertNotEquals(null, result.LocaleSidKey);
    System.assertNotEquals(null, result.LanguageLocaleKey);
    System.assertNotEquals(null, result.EmailEncodingKey);
    System.assertEquals(attributes.get('Username'), result.Username);
    System.assertEquals(attributes.get('Username'), result.CommunityNickname);
    System.assertEquals(federationIdentifier, result.FederationIdentifier);
    System.assertEquals('WBiWithL', result.Alias);
    System.assertEquals(CC_Settings.communityUserProfileId, result.ProfileId);
    System.assertEquals(attributes.get('Email'), result.Email);
    System.assertEquals(attributes.get('FirstName'), result.FirstName);
    System.assertEquals(attributes.get('LastName'), result.LastName);
    System.assertEquals(attributes.get('ConnectDateFormat'), result.LDAP_Date_Format__c);
    System.assertEquals(attributes.get('ConnectTimeFormat'), result.LDAP_Time_Format__c);
    System.assertEquals(tokyoTimezone, result.TimeZoneSidKey);
    System.assertEquals(expectedRoles, result.LDAP_Roles__c);
  }

  @IsTest
  static void handleUser_should_populate_existing_user_for_update() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(new User(Id = UserInfo.getUserId()));
    String expectedRoles = 'SCONNECT_CA_USER_TEST;SConnect_Impleng_Test';

    // When
    jitHandler.handleUser();

    // Then
    User result = jitHandler.jitUser;
    System.assertEquals(UserInfo.getUserId(), result.Id);
    System.assertEquals(null, result.LocaleSidKey);
    System.assertEquals(null, result.EmailEncodingKey);
    System.assertEquals(null, result.Username);
    System.assertEquals(null, result.CommunityNickname);
    System.assertEquals(null, result.FederationIdentifier);
    System.assertEquals(null, result.Alias);
    System.assertEquals(null, result.ProfileId);
    System.assertEquals(attributes.get('Email'), result.Email);
    System.assertEquals(attributes.get('FirstName'), result.FirstName);
    System.assertEquals(attributes.get('LastName'), result.LastName);
    System.assertEquals(attributes.get('ConnectDateFormat'), result.LDAP_Date_Format__c);
    System.assertEquals(attributes.get('ConnectTimeFormat'), result.LDAP_Time_Format__c);
    System.assertEquals(tokyoTimezone, result.TimeZoneSidKey);
    System.assertEquals(expectedRoles, result.LDAP_Roles__c);
  }

  @IsTest
  static void resolveContact_should_find_contact_by_user_contact_id() {
    // Given
    Contact c = buildContact();
    insert c;
    User u = new User(ContactId = c.Id);
    CC_SamlJitHandler jitHandler = buildJitHandler(u);

    // When
    Test.startTest();
    Contact result = jitHandler.resolveContact();
    Test.stopTest();

    // Then
    System.assertEquals(c.Id, result.Id);
  }

  @IsTest
  static void resolveContact_should_find_contact_by_ldap_id() {
    // Given
    User u = new User();
    CC_SamlJitHandler jitHandler = buildJitHandler(u);

    Contact c = buildContact();
    c.SC_CONTACT_LDAPID__c = attributes.get('ConnectUserID');
    insert c;

    // When
    Test.startTest();
    Contact result = jitHandler.resolveContact();
    Test.stopTest();

    // Then
    System.assertEquals(c.Id, result.Id);
  }

  @IsTest
  static void resolveContact_should_find_contact_by_name_email_account() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(null);
    Map<String, String> newAttributes = new Map<String, String>{
      'FirstName' => 'George',
      'LastName' => 'Jungle',
      'Email' => 'gjungle@yahoo.com',
      'ConnectUserID' => '12345',
      'ConnectSiteID' => '12345'
    };
    jitHandler.captureInputs(new User(), samlSsoProviderId, communityId, portalId, federationIdentifier, newAttributes, assertion);
    System.assertEquals(false, jitHandler.isInternalUser());

    Account acct = CC_TestUtils.buildAccount('Test Acct');
    insert acct;
    CC_Settings.communityUserDefaultAccountId = acct.Id;
    System.assertEquals(acct.Id, jitHandler.resolveAccount());

    Contact c = buildContact();
    c.FirstName = newAttributes.get('FirstName');
    c.LastName = newAttributes.get('LastName');
    c.Email = newAttributes.get('Email');
    c.AccountId = acct.Id;
    insert c;

    // When
    Test.startTest();
    Contact result = jitHandler.resolveContact();
    Test.stopTest();

    // Then
    System.assertEquals(c.Id, result.Id, result);
  }

  @IsTest
  static void resolveContact_should_resolve_new_contact() {
    // Given
    User u = new User();
    CC_SamlJitHandler jitHandler = buildJitHandler(u);

    // When
    Test.startTest();
    Contact result = jitHandler.resolveContact();
    Test.stopTest();

    // Then
    System.assertEquals(null, result.Id);
  }

  @IsTest
  static void resolveAccount_should_resolve_account_for_internal_user() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(null);
    Map<String, String> newAttributes = new Map<String, String>{
      'ConnectUserID' => 'abcde'
    };
    jitHandler.captureInputs(new User(), samlSsoProviderId, communityId, portalId, federationIdentifier, newAttributes, assertion);
    System.assertEquals(true, jitHandler.isInternalUser());

    // When
    Id result = jitHandler.resolveAccount();

    // Then
    System.assertEquals(jitHandler.caseArchivalAccountId, result);
  }

  @IsTest
  static void resolveAccount_should_resolve_account_by_connect_site_id() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(null);
    Account account = CC_TestUtils.buildAccount('Test Account');
    insert account;
    Site_Association__c site = CC_TestUtils.buildNewSite('12345');
    site.Enterprise_ID__c = account.Id;
    insert site;
    Map<String, String> newAttributes = new Map<String, String>{
      'ConnectUserID' => '12345',
      'ConnectSiteID' => site.SC_TOPS_ID__c
    };
    jitHandler.captureInputs(new User(), samlSsoProviderId, communityId, portalId, federationIdentifier, newAttributes, assertion);
    System.assertEquals(false, jitHandler.isInternalUser());

    // When
    Id result = jitHandler.resolveAccount();

    // Then
    System.assertEquals(account.Id, result);
  }

  @IsTest
  static void resolveAccount_should_resolve_fallback_account() {
    // Given
    CC_SamlJitHandler jitHandler = buildJitHandler(null);
    Map<String, String> newAttributes = new Map<String, String> {
      'ConnectUserID' => '12345',
      'ConnectSiteID' => '12345'
    };
    jitHandler.captureInputs(new User(), samlSsoProviderId, communityId, portalId, federationIdentifier, newAttributes, assertion);
    System.assertEquals(false, jitHandler.isInternalUser());

    // When
    Id result = jitHandler.resolveAccount();

    // Then
    System.assertEquals(jitHandler.fallbackAccountId, result);
  }

  @IsTest
  static void dmlHandler_test_create_user_and_contact() {
    // Given
    CC_SamlJitHandler.DmlHandler dmlHandler = new CC_SamlJitHandler.DmlHandler();
    dmlHandler.jitContact = buildContact();
    dmlHandler.jitUser = new User();

    // When
    dmlHandler.commitData();

    // Then
    System.assertNotEquals(null, dmlHandler.jitContact.Id);
    System.assertEquals(null, dmlHandler.jitUser.Id);
    System.assertEquals(dmlHandler.jitContact.Id, dmlHandler.jitUser.ContactId);
  }

  @IsTest
  static void dmlHandler_test_update_user() {
    // Given
    CC_SamlJitHandler.DmlHandler dmlHandler = new CC_SamlJitHandler.DmlHandler();
    Contact c = buildContact();
    insert c;
    dmlHandler.jitContact = new Contact(Id = c.Id, FirstName = c.FirstName + 'update');
    User u = [SELECT Id, FirstName FROM User WHERE Id = :UserInfo.getUserId()];
    dmlHandler.jitUser = new User(Id = u.Id, FirstName = u.FirstName+'update');

    CC_TestUtils.enableUserDml();

    // When
    dmlHandler.commitData();

    // Then
    Contact cResult = [SELECT FirstName FROM Contact WHERE Id = :c.Id];
    System.assertEquals(dmlHandler.jitContact.FirstName, cResult.FirstName);
    User uResult = [SELECT FirstName FROM User WHERE Id = :u.Id];
    System.assertEquals(dmlHandler.jitUser.FirstName, uResult.FirstName);
  }

  private static CC_SamlJitHandler buildJitHandler(User u) {
    CC_SamlJitHandler jitHandler = new CC_SamlJitHandler();
    jitHandler.dmlHandler = new MockDmlHandler();
    jitHandler.captureInputs(u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
    return jitHandler;
  }

  private static Contact buildContact(){
    return new Contact(FirstName = 'Fred', LastName = 'Flintstone', Email = 'fflintstone@ca.com');
  }

  private class MockDmlHandler extends CC_SamlJitHandler.DmlHandler {
    public Boolean commitDataCalled { get; set; }
    public override void commitData() {
      commitDataCalled = true;
    }
  }
}