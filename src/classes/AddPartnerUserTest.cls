@isTest(seealldata=true)
private class AddPartnerUserTest {
    private static void init() {
        User testUser = new User();
        Contact testContact = new Contact();
        testUser = [SELECT ID FROM User LIMIT 1];
        testContact = [SELECT ID FROM Contact LIMIT 1];
        ApexPages.StandardController con = new ApexPages.StandardController(testUser);        
    }
    
    static testMethod void testCreateUser() {
       // init();     
       //SELECT AccountId,CreatedDate,Is_Partner_Acc__c FROM Contact WHERE Is_Partner_Acc__c = 'true' ORDER BY AccountId DESC NULLS LAST LIMIT 2          
         Account acc = new Account();
        //acc =[SELECT Id FROM Account WHERE IsPartner = true LIMIT 1];
        Contact contactacct =[SELECT AccountId,ID FROM Contact WHERE Is_Partner_Acc__c = 'true' LIMIT 1];
        Contact con=new Contact();        
        con.LastName='trail';
        con.FirstName='try';
        con.email='trytest@gg.com';
        con.Country_Picklist__c='DZ - ALGERIA';
        //con.Is_Partner_Acc__c ='true';
        con.AccountId=contactacct.AccountId;
        insert con;
        Test.startTest();
        //Test positive scenario
        String outPut = AddPartnerUser.createPartnerUser(con.id,con.email,con.FirstName);    
        //test existing record
        String outPut1 = AddPartnerUser.createPartnerUser(con.id,con.email,con.FirstName);
        //test blank Email
        String outPut2 = AddPartnerUser.createPartnerUser(con.id,'',con.FirstName);
        //test blank firstname 
        String outPut8 = AddPartnerUser.createPartnerUser(con.id,con.email,'');
          //test blank firstname 
        String outPut3 = AddPartnerUser.createPartnerUser(con.id,'','');          
        Test.stopTest();
        
    }
    
      static testMethod void Userexists() {
        // init();               
        Contact con= new contact();
        Con =   [Select id,Lastname,FirstName,email,Country_Picklist__c from Contact LIMIT 1];
        //test negative 
        User user = [SELECT email,firstname FROM User Limit 1 ];
         Test.startTest();
        String outPut6 = AddPartnerUser.createPartnerUser(con.id,user.email,user.FirstName);
      
        //String outPut = AddPartnerUser.createPartnerUser(con.id,con.email,con.FirstName);       
        Test.stopTest();
        
    }
    
    static testMethod void testContactexists()
    {
        Test.startTest();
         //test partner account blank
        Contact Contacts =[SELECT  ID,email,firstname,AccountId
                           FROM Contact where Is_Partner_Acc__c ='false' LIMIT 1];
        
        //test existing Is_Partner_Acc__c ='false' LI
        String outPut5 = AddPartnerUser.createPartnerUser(contacts.id,contacts.email,contacts.FirstName);
        Test.stopTest();
        
    }
    static testMethod void testLocaleDE() {
        // init();           
         Account acc = new Account();
        acc =[SELECT Id FROM Account WHERE IsPartner = true LIMIT 1];
        Contact con=new Contact();        
        con.LastName='testname';
        con.FirstName='test';
        con.email='aparna.samala@gg.com';
        con.Country_Picklist__c='DZ - ALGERIA';
        con.AccountId=acc.Id;
        //con.Is_Partner_Acc__c='true';
        insert con;            
        Test.startTest();
        String outPut = AddPartnerUser.createPartnerUser(con.id,con.email,con.FirstName);       
        Test.stopTest();
        
    }
    
    
    static testMethod void testLocale() {
        // init();           
       
        Test.startTest();
       
        String outPut1 = AddPartnerUser.GetLdapLocalKey('es','es');
          String outPut2 = AddPartnerUser.GetLdapLocalKey('co','es');
          String outPut3 = AddPartnerUser.GetLdapLocalKey('de','se');
            String outPut4 = AddPartnerUser.GetLdapLocalKey('fr','fr');
             String outPut5 = AddPartnerUser.GetLdapLocalKey('tr','fr');            
          String outPut6 = AddPartnerUser.GetLdapLocalKey('gb','en');
           String outPut7 = AddPartnerUser.GetLdapLocalKey('en','pt');
           String outPut8 = AddPartnerUser.GetLdapLocalKey('ja','ja');
          String outPut9 = AddPartnerUser.GetLdapLocalKey('ch','de');
           String outPut10 = AddPartnerUser.GetLdapLocalKey('us','zh');
         String outPut11 = AddPartnerUser.GetLdapLocalKey('de','de');
        Test.stopTest();
        
    }
   
   
}