//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class CC_SamlJitHandler implements Auth.SamlJitHandler {

  @TestVisible
  private User jitUser {get; set;}
  @TestVisible
  private Contact jitContact {get; set;}

  private SamlAssertionHelper assertionHelper {get; set;}
  private String federationIdentifier {get; set;}
  private Id communityId {get; set;}

  @TestVisible
  private DmlHandler dmlHandler {
    get {
      if (dmlHandler == null) {
        dmlHandler = new DmlHandler();
      }
      return dmlHandler;
    }
    set;
  }

  @TestVisible
  private Id caseArchivalAccountId {
    get { return Label.AccountForCaseArchival; }
  }

  @TestVisible
  private Id fallbackAccountId {
    get { return CC_Settings.communityUserDefaultAccountId; }
  }

  // Called by Salesforce when an existing user is NOT found by FederationIdentifier
  // We return a user object in this case
  global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
    System.debug('SAML JIT Handler - Create User');
    User u = new User();
    captureInputs(u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
    handleJit();
    return this.jitUser;
  }

  // Called by Salesforce when an existing user is found by FederationIdentifier
  // We must explicitly update the user object in this case
  global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
    System.debug('SAML JIT Handler - Update User: ' + userId);
    User u = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId];
    captureInputs(u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
    handleJit();
  }

  @TestVisible
  private void captureInputs(User user, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
    this.jitUser = user;
    this.assertionHelper = new SamlAssertionHelper(attributes);
    this.federationIdentifier = federationIdentifier;
    this.communityId = communityId;
    System.debug('Federation Identifier: ' + federationIdentifier);
  }

  @TestVisible
  private void handleJit() {
    if(this.communityId == null) {
      throw new JitException('This handler can only be used for the customer community');
    }

    handleContact();
    handleUser();

    commitData();
  }

  @TestVisible
  private void handleContact() {
    Contact c = resolveContact();
    // new contact fields
    if (c.Id == null) {
      c.Email = assertionHelper.getEmail();
      c.FirstName = assertionHelper.getFirstName();
      c.LastName = assertionHelper.getLastName();
    }
    // update contact fields
    c.SC_CONTACT_LDAPID__c = assertionHelper.getConnectUserID(); // FIXME: LDAP ID is unique. This will cause errors another contact exists with same LDAP ID
    c.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c = assertionHelper.getConnectSiteID();
    c.SC_CONTACT_In_Active__c = false;
    
    String country = assertionHelper.getPostalCountry();
    if(!CC_Utils.isEmpty(country)) {
      c.Country_Picklist__C = country;
    }
    String state = assertionHelper.getPostalState();
    if(!CC_Utils.isEmpty(state)) {
      c.Mailing_State_Prov_Local__c = state;
    }

    String language = assertionHelper.getLanguage();
    if(!CC_Utils.isEmpty(language)) {
      c.Language_Preference__c = language;
    }

    this.jitContact = c;
  }

  @TestVisible
  private Contact resolveContact(){
    Contact resolvedContact;
    Contact[] foundContacts = new Contact[]{};
    Id accountId;
    String ldapId = assertionHelper.getConnectUserID();    

    // FIXME: LDAP ID is a unique field on the contact. We should probably change the User's contact to one that matches by LDAP ID if possible.
    if(this.jitUser.ContactId != null) {
      foundContacts = [SELECT Id, AccountId FROM Contact 
                        WHERE Id=:this.jitUser.ContactId];
    }

    if (foundContacts.size() == 0) {
      // find contact by ldap id
      foundContacts = [SELECT Id, AccountId FROM Contact 
                        WHERE SC_CONTACT_LDAPID__c = :ldapId LIMIT 1];
    }

    if (foundContacts.size() == 0) {
      // find contact by first, last, email, with no ldap id under the corresponding account
      String firstName = assertionHelper.getFirstName();
      String lastName = assertionHelper.getLastName();
      String email = assertionHelper.getEmail();
      accountId = resolveAccount();
      foundContacts = [SELECT Id, Is_Partner_Acc__c, AccountId FROM Contact 
                        WHERE FirstName = :firstName AND LastName = :lastName AND Email = :email 
                        AND SC_CONTACT_LDAPID__c = null AND AccountId = :accountId 
                        ORDER BY LastModifiedDate DESC LIMIT 1];
        
        // If the contact is not yet found, retry with same logic as above, but this time without the Account constraint.                
        if(foundContacts.size() == 0) {    
          foundContacts = [SELECT Id, Is_Partner_Acc__c, AccountId FROM Contact 
                            WHERE FirstName = :firstName AND LastName = :lastName AND Email = :email 
                            AND SC_CONTACT_LDAPID__c = null ORDER BY LastModifiedDate DESC];    
        }                        
    }
    
    if (foundContacts.size() == 0) {
      resolvedContact = new Contact(AccountId = accountId);
      System.debug('Creating new contact');
    } else {
      if(foundContacts.size() > 1){
        // In this case try to pick the partner contact, if there is one
        for(Contact tmpCont : foundContacts){
            if(tmpCont.Is_Partner_Acc__c=='true'){
                resolvedContact = tmpCont;
                break;
            }
        }
      }
      if(resolvedContact == null){
        resolvedContact = foundContacts[0];
      }
      System.debug('Resolved Contact: ' + resolvedContact.Id);
    }
    return resolvedContact;
  }

  @TestVisible
  private Id resolveAccount() {
    Id accountId;
    // use caseArchivalAccountId for internal users
    if (isInternalUser()) { 
      accountId = caseArchivalAccountId;
    }

    // Find site association using ldap default site id
    // find account by site_association.Enterprise_ID
    if (accountId == null) {
      String siteId = assertionHelper.getConnectSiteID();
      Site_Association__c[] sites = [SELECT Enterprise_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c = :siteId];
      if (sites.size() > 0) {
        String possibleAccountId = sites[0].Enterprise_ID__c;
        Account[] foundAccounts = [SELECT Id FROM Account WHERE Id = :possibleAccountId];
        if (foundAccounts.size() > 0) {
          accountId = (Id)possibleAccountId;
        }
      }
    }
    
    // fallback account id
    if (accountId == null) { 
      accountId = fallbackAccountId;
    }

    return accountId;
  }

  @TestVisible
  private void handleUser() {
    User u = this.jitUser;
    // new user fields
    if (u.Id == null) {
      defaultCurrentUserValues(u);
      u.Username = assertionHelper.getUsername();
      u.CommunityNickname = assertionHelper.getUsername();
      u.FederationIdentifier = this.federationIdentifier;
      String alias = assertionHelper.getFirstName().substring(0, 1) + assertionHelper.getLastName();
      if(alias.length() > 8) {
        alias = alias.substring(0, 8);
      }
      u.Alias = alias;

      //If you are updating Contact or Account object fields, you cannot update the following User fields at the same time: IsActive, ForecastEnabled, ProfileId, UserRoleId
      if(isInternalUser())
      {
        u.ProfileId = assertionHelper.getInternalProfileId();
      }
      else
      {
        u.ProfileId = assertionHelper.getExternalProfileId();
      }
    }
    // update user fields
    u.Email = assertionHelper.getEmail();
    u.FirstName = assertionHelper.getFirstName();
    u.LastName = assertionHelper.getLastName();
    //u.LDAP_Id__c = assertionHelper.getConnectUserID(); // do not update, this is a unique field and it will cause errors
    u.LDAP_Date_Format__C = assertionHelper.getDateFormat();
    u.LDAP_Time_Format__c = assertionHelper.getTimeFormat();
    u.Case_Validation_Bypass__c = true;
    String ldapTimezone = assertionHelper.getConnectTimezone();
    String tzSidKey = CC_Utils.resolveLdapTimezone(ldapTimezone);
    if (tzSidKey != null) {
      u.TimeZoneSidKey = tzSidKey;
    }
    u.LDAP_Roles__c = assertionHelper.getUserLDAPRoles();
    u.LDAP_Basic_Impl_Open_Case__c=assertionHelper.getBusinessCategory();  
  }

  private void defaultCurrentUserValues(User u) {
    String uid = UserInfo.getUserId();
    User currentUser = [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
    u.LocaleSidKey = currentUser.LocaleSidKey;
    u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
    u.EmailEncodingKey = currentUser.EmailEncodingKey;
    u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
  }

  // External Users have numnberic Connect IDs
  // Internal Users have PMF Key as Conenct ID
  private Pattern isnumbers = Pattern.Compile('^[0-9]+$');
  @TestVisible
  private Boolean isInternalUser() {
    String ldapId = assertionHelper.getConnectUserID();
    Matcher customerMatch = isnumbers.matcher(ldapId);
    return !customerMatch.matches();
  }

  private void commitData() {
    dmlHandler.jitContact = this.jitContact;
    dmlHandler.jitUser = this.jitUser;
    dmlHandler.commitData();
  }

  private class JitException extends Exception{}

  public virtual class DmlHandler {
    public User jitUser {get;set;}
    public Contact jitContact {get;set;}

    public virtual void commitData() {
      upsert jitContact;
      if (jitUser.Id == null) {
        jitUser.ContactId = jitContact.Id;
      }
      if (jitUser.Id != null) {
        update jitUser;
      }
    }
  }

  private class SamlAssertionHelper {
    CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
    private Map<String, String> assertions;
    public SamlAssertionHelper(Map<String, String> assertions) {
      this.assertions = assertions;
      for (String key : assertions.keyset()) {
        log.debug(key + ': ' + assertions.get(key));
      }
    }

    public String getUsername() {
      return getSamlAssertion('Username');
    }


    public String getInternalProfileId() {
        return CC_Settings.communityUserProfileId; // do not use attribute ProfileId
    }

    public String getExternalProfileId() {
        return CC_Settings.communityExternalUserProfileId; 
    }

    public String getEmail() {
      return getSamlAssertion('Email');
    }

    public String getFirstName() {
      return getSamlAssertion('FirstName');
    }

    public String getLastName() {
      return getSamlAssertion('LastName');
    }

    public String getConnectUserID() {
      return getSamlAssertion('ConnectUserID');
    }

    public String getConnectSiteID() {
      return getSamlAssertion('ConnectSiteID');
    }

    public String getConnectTimezone() {
      return getSamlAssertion('ConnectTimezone');
    }

    public String getPostalCountry() {
      String postalCountry = CC_Utils.resolveLdapCountry(getSamlAssertion('uCountry'));
      return postalCountry;
    }

    public String getPostalState() {
      return getSamlAssertion('ConnectPostalState');
    }
    public String getDateFormat(){
      return getSamlAssertion('ConnectDateFormat');
    }
    public String getTimeFormat(){
      return getSamlAssertion('ConnectTimeFormat');
    }
    public String getLanguage(){
      String language = CC_Utils.resolveLdapLanguage(getSamlAssertion('ConnectUserLanguage'));
      return language;
    }

    public String getUserLDAPRoles() {
      String connectMemberOf = getSamlAssertion('connectmemberof');
      String cnValues = ldapRoles.buildValueString(connectMemberOf);
      return cnValues;
    }
    //business category(can open case)  
     public String getBusinessCategory() {
      return getSamlAssertion('BusinessCategory');
    }

    private String getSamlAssertion(String key) {
      if (this.assertions.containsKey(key)) {
        return this.assertions.get(key);
      }
      return null;
    }
  }
}