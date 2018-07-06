@IsTest
public class CC_TestUtils {

  public static CA_Product_Controller__c testProduct { get {
    if (testProduct == null) {
      testProduct = [SELECT Id, Name FROM CA_Product_Controller__c WHERE Name = 'Jive Turkey' LIMIT 1];
    }
    return testProduct;
    } set; }

    public static Product_Area__c testProductArea { get {
      if (testProductArea == null) {
        testProductArea = [SELECT Id, Name FROM Product_Area__c WHERE Name = 'Jive Turkey' LIMIT 1];
      }
      return testProductArea;
      } set; }

    public static Site_Association__c testSite { get {
      if (testSite == null) {
        testSite = [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SAP_Site_ID__c = '12345' LIMIT 1];
      }
      return testSite;
      } set; }
    
    public static void setUpTestAWSToken(){
         //Added for AWS Token custom setting
        insert new aws_security_token__c(Name = 'awstoken', token_str1__c = 'tokenstr1' ,token_str2__c = 'tokenstr2',token_str3__c = 'tokenstr3', token_str4__c = 'tokenstr4' );
    }

      public static void setupTestDataToInsertCase() {
        insert new Provisional_Site_Number__c(Name = 'Last Site No', Prov_Site_Number__c = 1);
        Site_Association__c site = buildNewSite('12345');
        SLO_Milestones__c severityMilestone = new SLO_Milestones__c(Name = 'Severity3', Due_Date_SLO__c = '0');

        insert new SObject[] {
          site,
          severityMilestone
        };
        CC_TestUtils.testProduct = createProduct('Jive Turkey');
        CC_TestUtils.testSite = site;
        Set<Id> siteIDSet = new Set<Id>();
        siteIDSet.add(site.Id);
        CC_ngTurkeyController.entitledSitesofUser = siteIDSet;
      }

      public static Site_Association__c buildNewSite(String siteId) {
        if (Provisional_Site_Number__c.getInstance('Last Site No') == null) {
          insert new Provisional_Site_Number__c(Name = 'Last Site No', Prov_Site_Number__c = 1);
        }
        Account dummyAcc = buildAccount('MuhCount');
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true; 
        insert dummyAcc;
        system.debug('@@@@'+dummyAcc.id);
        return new Site_Association__c(Name = 'Site ' + siteId, SC_TOPS_ID__c = CC_Utils.padSiteId(siteId), SC_SITE_Source__c = 'Not Support', SAP_Site_ID__c=siteId, SC_Site_Sanctioned_Party__c = 'NO', L7_Last_Updated_for_Informatica__c = DateTime.now(), Enterprise_ID__c = dummyAcc.Id);
      }

      public static Case buildCase(Id contactId, String status){
        return new Case(
          Business_Impact__c = 'Business_Impact__c',
          CA_Product_Controller__c = testProduct.Id,
          Product_Area__c = testProductArea.Id,
          ContactId = contactId,
          Description = 'Description',
          Severity__c = '3',
          Subject = 'Subject',
          Site_Association__c = testSite.Id,
          Status = status,
          Next_Action_Due_Date__c = Datetime.now().addDays(1),
          Next_Action__c = 'Pending CA',
          Last_Assigned_Date__c = Date.today(),
          Last_Assigned_DateTime__c = DateTime.now()
          );
      }

      public static User buildUser(){
       Profile p = [SELECT id FROM profile WHERE name = '1.0 CA Sys Admin Commit & PR'];
       return new User(
        LastName = 'test', 
        Email = 'pokemon@ca.com', 
        CommunityNickname = 'test community',  
        TimeZoneSidKey = 'America/Los_Angeles', 
        LocaleSidKey = 'en_US', 
        UserName='pokemon@ca.com', 
        Alias = 'testu',
        EmailEncodingKey = 'UTF-8',
        ProfileId = p.Id,
        LanguageLocaleKey = 'en_US',
        LDAP_Roles__c = 'sc_test'
        );
     }

     public static Account buildAccount(String name) {
      SystemIdUtility.skipAccount = true;
      SystemIdUtility.skipProductTriggers = true;
      SystemIdUtility.skipAccountOnMIPSUpdate = true;
      return new Account(
        Name = name,
        Enterprise_ID__c = 'AR51855',
        BillingStreet = 'Admiralty Ctr',
        BillingCountry = 'HK',
        BillingCity = 'ADMIRALTY'
        );
    }

    public static CA_Product_Controller__c createProduct(String productName) {
      CA_Product_Controller__c product = new CA_Product_Controller__c(Name=productName);
      insert product;
      CA_Product_Component__c component = new CA_Product_Component__c(
        Name = 'Default ' + productName + ' Component',
        CA_Product_Controller__c = product.Id,
        Default_Component_for_this_CA_Product__c = true,
        component_expiration_date__c = null
        );
      insert component;
      Product_Area__c productArea = new Product_Area__c(Name=productName,CA_Product__c = product.Id,Default_Group_Component__c= component.Id);
      insert productArea;
      Product_Material__c prodMaterial = new Product_Material__c(Name='PMCID99000',CA_Product_Controller__c = product.Id);
      insert prodMaterial;

      return product;
    }

    private static Integer nextSeed = 1;
    public static Id fakeId(SObjectType sot) {
      return fakeId(sot, ++nextSeed);
    }
    public static Id fakeNo(SObjectType sot) {
      return fakeId(sot, ++nextSeed);
    }
    public static Id fakeId(SObjectType sot, Integer seed) {
      String result = String.valueOf(seed);
      Id fakeId = sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result + 'AAA';
      return fakeId;
    }

    public static void enableUserDml() {
      uas__UCSSettings__c uas = new uas__UCSSettings__c(
        uas__Enabled__c = false,
        uas__AccountId__c = CC_TestUtils.fakeId(Account.SObjectType)
        );
      insert uas;
    }
  }