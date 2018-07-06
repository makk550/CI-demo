@isTest
private class LiveAgentPreChatFormControllerTest {

    
    public static testMethod void  testgetSiteId(){
        RecordType rt = [Select id from RecordType where  SobjectType='Account' and name='Support Account' limit 1];
        RecordTypes_Setting__c rc = new RecordTypes_Setting__c();
        rc.Name ='SMB';
        rc.SObject_Name__c = 'Account';
        rc.RecordType_Id__c = rt.id;
        insert rc;
        
        RecordTypes_Setting__c rc1 = new RecordTypes_Setting__c();
        rc1.Name ='Account Team Covered Account';
        rc1.SObject_Name__c = 'Account';
        rc1.RecordType_Id__c = rt.id;
        insert rc1;
        
        RecordTypes_Setting__c rc2 = new RecordTypes_Setting__c();
        rc2.Name ='Territory Covered Account';
        rc2.SObject_Name__c = 'Account';
        rc2.RecordType_Id__c = rt.id;
        insert rc2;
        
        RecordTypes_Setting__c rc3 = new RecordTypes_Setting__c();
        rc3.Name ='Commercial Account';
        rc3.SObject_Name__c = 'Account';
        rc3.RecordType_Id__c = rt.id;
        insert rc3;
        
        RecordTypes_Setting__c rc4 = new RecordTypes_Setting__c();
        rc4.Name ='CA Enterprise Account';
        rc4.SObject_Name__c = 'Account';
        rc4.RecordType_Id__c = rt.id;
        insert rc4;
        
         RecordTypes_Setting__c rc5 = new RecordTypes_Setting__c();
        rc5.Name ='Account Team Covered Account';
        rc5.SObject_Name__c = 'Account';
        rc5.RecordType_Id__c = rt.id;
        insert rc5;
        
         RecordTypes_Setting__c rc6 = new RecordTypes_Setting__c();
        rc6.Name ='Reseller/Distributor Account';
        rc6.SObject_Name__c = 'Account';
        rc6.RecordType_Id__c = rt.id;
        insert rc6;
        
            
            
        Account acc = new Account();
        acc.Name = 'Generic Support Account';
        acc.BillingState = 'NY';
        acc.BillingStreet='Arlington';
        acc.BillingCity='NY';
        acc.BillingCountry='US';
        acc.RecordTypeId = rt.Id;
        insert acc;
       Country_ISO__c ci = new Country_ISO__c();
        ci.Name ='US - UNITED STATES';
        ci.Code__c = 'USA';
        insert ci;
        
        Country_Support_Region__c csr= new Country_Support_Region__c();
        csr.name= 'US';
        csr.Country__c = 'US - UNITED STATES';
        csr.Region__c = 'NA';
        insert csr;
        
        
        Site_Association__c sc = new Site_Association__c();
        
        sc.Name = 'CA TECHNOLOGIES';
        sc.City__c = 'ISLANDIA';
        sc.SC_TOPS_ID__c = '105246';
        sc.ProviSite__c = 105246;
        sc.Country_Picklist__c = 'US - UNITED STATES';
        sc.SC_SITE_Source__c = 'Support';
        //sc.Enterprise_ID__c = acc.Id;
        //sc.Country_ISO_code__c = 'AD';
        insert sc;
        Test.startTest();
            System.debug('***sc.SC_TOPS_ID__c in test clas****'+sc.SC_TOPS_ID__c);
            System.debug('***sc.idc in test clas****'+sc.id);
            for (Site_Association__c s : [SELECT id, SC_TOPS_ID__c FROM Site_Association__c ]){
                System.debug('***All sc ids ****'+s.id + s.SC_TOPS_ID__c);
            }
            String id = LiveAgentPreChatFormController.getSiteId( sc.SC_TOPS_ID__c);
            LiveAgentPreChatFormController.getSiteId( null);
            System.debug('id************'+id);
        Test.stopTest();
    }
    public static testMethod void  testgetProductId(){
        List<CA_Product_Controller__c> listOfCPC = new List<CA_Product_Controller__c>();
        CA_Product_Controller__c cpc = new CA_Product_Controller__c();
        cpc.Name = 'ACCUCHECK';
        listOfCPC.add(cpc);
        CA_Product_Controller__c cpc1 = new CA_Product_Controller__c();
        cpc1.Name = 'GLOBAL SERVICE CENTER';
        listOfCPC.add(cpc1);
        insert listOfCPC;
        
        Test.startTest();
            LiveAgentPreChatFormController.getProductId('ACCUCHECK');
        LiveAgentPreChatFormController.getProductId(null);
        Test.stopTest();
    }
        
     public static testMethod void  testgetCAProductController(){
         CA_Product_Controller__c cpc = new CA_Product_Controller__c();
         cpc.Name = 'ACCUCHECK';
         insert cpc;
         
         List<Product_Material__c> listOfPM = new List<Product_Material__c>();    
         Product_Material__c pm = new Product_Material__c();
         pm.Name = 'ACCUCHECK';
         pm.CA_Product_Controller__c = cpc.Id;
         listOfPM.add(pm);
         Product_Material__c pm1 = new Product_Material__c();
         pm1.Name = 'GSCSPT99000';
         pm1.CA_Product_Controller__c = cpc.Id;
         listOfPM.add(pm1);
         insert listOfPM;         
         
         Test.startTest();
            LiveAgentPreChatFormController.getCAProductController('ACCUCHECK');
         LiveAgentPreChatFormController.getCAProductController(null);
        Test.stopTest();
     }
    
    public static testMethod void testgetCAProductComponent(){
        CA_Product_Controller__c cp = new CA_Product_Controller__c();
         cp.Name = 'ACCUCHECK';
         insert cp;
        
        CA_Product_Component__c cpc  = new CA_Product_Component__c();
        cpc.CA_Product_Controller__c = cp.Id;
        cpc.Name = 'ACCUCHECK';
        cpc.Default_Component_for_CA_Product__c = true;
        cpc.component_expiration_date__c = system.today().addDays(3);
        insert cpc;
        
        Product_Material__c pm = new Product_Material__c();
         pm.Name = 'ACCUCHECK';
         pm.CA_Product_Controller__c = cp.Id;
         insert pm;
        
        Test.startTest();
            LiveAgentPreChatFormController.getCAProductComponent(cp.Id,pm.Id,'');
            //LiveAgentPreChatFormController.getCAProductComponent(null,null);
        Test.stopTest();
    }
     public static testMethod void testgetContactId(){
          Contact c = new Contact();
          c.LastName = 'last';
          c.FirstName = 'first';
          c.email = 'shata07@ca.com';
          c.SC_CONTACT_LDAPID__c = '9829';          
          insert c;
          Test.startTest();
         LiveAgentPreChatFormController.getContactId('9829');
         LiveAgentPreChatFormController.getContactId('ABSCDEF');
         LiveAgentPreChatFormController.getContactId(null);
        Test.stopTest();
     }
  
}