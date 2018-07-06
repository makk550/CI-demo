@istest
public class Test_ContactintelligenceController {
    
    public static testMethod void testMyController() {
        Contact Con= new contact();
        
        list<Contact> Currentconlist = new list<Contact>();
        list<Contact> duplicateconlist = new list<Contact>();
        
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='Customer Success'];
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com',
                          EmailEncodingKey='UTF-8',PMFKey__c='VATNI02', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        CI_Profiles__c setting = new CI_Profiles__c();
        setting.Name = 'Sale';
        setting.Profile_Name__c = 'Customer Success';
        insert setting;
        if(p.Name == setting.Profile_Name__c )
            system.runAs(u)  {      
                test.startTest();
                
                
                con.LastName='test123124424';
                con.FirstName='lasttest123123123';
                con.email='test@test3123131231.com';
                
                insert con;
                
                
                
                
                Contact Con1= new contact();
                Con1.LastName='test123';
                Con1.FirstName='lasttest11111';
                Con1.email='test123466@test.com';
                insert con1;
                
                
                ApexPages.StandardController sc = new ApexPages.StandardController(con);
                ContactinteligenceController testAccPlan = new ContactinteligenceController(sc);
                testAccPlan.ifserviceclouduser();
                testAccPlan.searchforduplicatecons();
                testAccPlan.SearchContact();
                testAccPlan.back();
                testAccPlan.createnewcon();
                testAccPlan.getrelationshipvalues();
                
                testAccPlan.nextPage();
                test.stopTest();
                
            }
    }
    public static testMethod void testMyController2() {
        Contact Con= new contact();
        
        list<Contact> Currentconlist = new list<Contact>();
        list<Contact> duplicateconlist = new list<Contact>();
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Support L1'];
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com',
                          EmailEncodingKey='UTF-8',PMFKey__c='VATNI02', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        system.runAs(u){
            
            
            
            Set<string> Scprofileset;
            
            String servicecloudprofilenames = Label.CI_servicecloudprofiles;
            String[] SCprofilelist = servicecloudprofilenames.split(';');
            list<Profile>   servicecloudprofiles=[select id,Name from Profile where name IN:Scprofileset];
            CI_Profiles__c setting = new CI_Profiles__c();
            setting.Name = 'Service';
            setting.Profile_Name__c = 'Support L1';
            insert setting;
            con.LastName='test123124424';
            con.FirstName='lasttest123123123';
            con.email='test@test3123131231.com';
            insert con;
            
            ApexPages.StandardController sc = new ApexPages.StandardController(con);
            ContactinteligenceController testAccPlan = new ContactinteligenceController(sc);
            
            testAccPlan.con.LastName='test123124424';
            testAccPlan.con.FirstName='lasttest123123123';
            testAccPlan.con.email='test@test3123131231.com';
            //testAccPlan.duplicatewrapper.email='nihall@test.com';
            testAccPlan.conmail='test@test.com';
            testAccPlan.conlname='tt';
            testAccPlan.confname='ttt';
            testAccPlan.conacc='tttttt';
            //testAccPlan.duplicatewrapper();
            testAccPlan.searchforduplicatecons();
            testAccPlan.SearchContact();
            testAccPlan.back();
            testAccPlan.createnewcon();
            testAccPlan.getrelationshipvalues();
            testAccPlan.ifserviceclouduser();
            testAccPlan.nextPage();
            testAccPlan.validateAccountSearch();
            
        }
    } 
    
    public static testMethod void testMyController3() {  
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Support L1'];
        User u = new User(Alias = 'standt', Email='standarduser@gmail.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
                
        Contact Con= new contact();
        con.LastName='test123124424';
        con.FirstName='lasttest123123123';
        con.lastname='test tets tet';
        con.email='test@test3123131231.com';
        
        insert con;
        Contact Con1= new contact();
        con1.LastName='test123124424';
        con1.FirstName='lasttest123123123';
        con1.lastname='test tets tet';
        con1.email='test@test3123131231.com';
        insert con1;
        
        Contact_Relationship__c CR1 = new Contact_Relationship__c();
        cr1.CARelationshipType__c='ghasgdaj';
        cr1.Contact_Role__c='';
        cr1.Contact__c=con.id; 
        insert cr1;
       
        Contact_Relationship__c CR2 = new Contact_Relationship__c();
         cr2.CARelationshipType__c='ghasgdaj';
        cr2.Contact_Role__c='sdfsdfsdf';
        cr2.StrengthOfRelationship__c='';
        cr2.Contact__c=con1.id; 
        insert cr2;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        ContactinteligenceController testAccPlan = new ContactinteligenceController(sc);
        //  testAccPlan.Contact_Relationship__c conrelation = new Contact_Relationship__c();
        testAccPlan.contactSelected= string.valueOf(con.id);
        
            testAccPlan.nextPage(); 
        testAccPlan.relationtype=cr1.CARelationshipType__c;
        testAccPlan.StrengthOfR=cr1.Contact_Role__c;
        testAccPlan.nextPage(); 
       testAccPlan.relationtype=cr2.CARelationshipType__c;
        testAccPlan.StrengthOfR=cr2.Contact_Role__c;
        testAccPlan.conRole= cr2.StrengthOfRelationship__c;
        testAccPlan.nextPage(); 
         
    }
      
    

    
}