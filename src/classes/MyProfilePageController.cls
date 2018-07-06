/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
public class MyProfilePageController {

    private User user;
    private boolean isEdit = false;
    
    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }
    
    public Boolean getIsEdit() {
        return isEdit;
    }
    
    public void edit() {
        isEdit=true;
    }    
    
    public void save() {
        if (user.contact != null) {              
            setContactFields(user.contact);
        }
        
        try {
            update user;
            if (user.contact != null) { 
                update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference changePassword() {
        return Page.ChangePassword;
    }
    
    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }
    
    private void setContactFields(Contact c) {
        c.title = user.title;
        c.firstname = user.firstname;
        c.lastname = user.lastname;
        c.email = user.email;
        c.phone = user.phone;
        c.mobilephone = user.mobilephone;
        c.fax = user.fax;
        c.mailingstreet = user.street;
        c.mailingcity = user.city;
        c.mailingstate = user.state;
        c.mailingpostalcode = user.postalcode;
        c.mailingcountry = user.country;
    }

    static testMethod void testSave() {         
        // Modify the test to query for a portal user that exists in your org
        //User existingPortalUser = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND ContactId <> NULL and isActive = true LIMIT 1 ];
        //Partner User w/Sales Tools/Funds Mgmt
        User existingPortalUser;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        String randFax;
        System.runAs ( thisUser ) {
            List<Account> accntList = new List<Account>();
            Account ac = new Account();
            ac.Name = 'Test Account';
            ac.BillingState = 'NY';   
            ac.Customer_Category__c = 'Enterprise';
            //ac.Account_Status__c = 'Approved';        
            ac.GEO__c='NA';
            
            ac.Enterprise_ID__c = '1234te';
            
            
            ac.Enterprise_Account_Name__c = 'rdName';
            ac.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();
            ac.Commercial_ID__c = 'asdf';
            //ac.Sales_Area__c =''
            accntList.add(ac);
            Account ac1 = new Account();
            ac1.Name = 'Test Account';
            ac1.BillingState = 'NY';   
            ac1.Customer_Category__c = 'Enterprise';
            //ac1.Account_Status__c = 'Approved';       
            ac1.GEO__c='LA';
            ac1.Enterprise_ID__c = '1234te';
            ac1.Enterprise_Account_Name__c = 'rdName1';
            ac1.Commercial_ID__c = 'asdf';
            ac1.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();
    
            accntList.add(ac1);
            insert accntList;
            
            List<Contact> contactsList = new List<contact>();
            Contact testContact = new Contact();
            testContact.FirstName = 'test';
            testContact.LastName = 'contact';
            testContact.email = 'testvi@ca.com';
            testContact.AccountId = ac1.Id;  
            contactsList.add(testContact);  
            
            Contact testContact1 = new Contact();
            testContact1.FirstName = 'test';
            testContact1.LastName = 'contact1';
            testContact.email = 'testvi1@ca.com';
            testContact1.AccountId = ac1.Id;  
            contactsList.add(testContact1);
            
            Contact testContact2 = new Contact();
            testContact2.FirstName = 'test';
            testContact2.LastName = 'contact2';
            testContact.email = 'testvi2@ca.com';
            testContact2.AccountId = ac1.Id;  
            contactsList.add(testContact2);
            
            Contact testContact3 = new Contact();
            testContact3.FirstName = 'test';
            testContact3.LastName = 'contact3';
            testContact.email = 'testvi3@ca.com';
            testContact3.AccountId = ac1.Id;  
            contactsList.add(testContact3);
            
              
            insert contactsList;
            
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Basic User' Limit 1];
            UserRole r = [SELECT Id FROM UserRole Limit 1];
            
            List<User> usersList = new List<User>();
            User u1 = new User(alias = 'TVI', email='testvi1@ca.com',
                emailencodingkey='UTF-8', lastname='Test1',firstname='f1',
                languagelocalekey='en_US',
                localesidkey='en_US', profileid = portalProfile.Id,// userroleid = r.id,
                timezonesidkey='America/Los_Angeles',
                username='testvi@ca.com',ContactId=testContact.Id);
            usersList.add(u1);
            
            User u2 = new User(alias = 'TVI1', email='testvi2@ca.com',
                emailencodingkey='UTF-8', lastname='Test2',firstname='f2',
                languagelocalekey='en_US',
                localesidkey='en_US', profileid = portalProfile.Id, //userroleid = r.id,
                timezonesidkey='America/Los_Angeles',
                username='testvi1@ca.com',ContactId=testContact1.Id);
            usersList.add(u2);
            
            User u3 = new User(alias = 'TVI2', email='testvi3@ca.com', 
                emailencodingkey='UTF-8', lastname='Test3',firstname='f3',
                languagelocalekey='en_US',
                localesidkey='en_US', profileid = portalProfile.Id, //userroleid = r.id,
                timezonesidkey='America/Los_Angeles',
                username='testvi2@ca.com',ContactId=testContact2.Id);
            usersList.add(u3);
            
            User u4 = new User(alias = 'TVI3', email='testvi4@ca.com',
                emailencodingkey='UTF-8', lastname='Test4',firstname='f4',
                languagelocalekey='en_US',
                localesidkey='en_US', profileid = portalProfile.Id,// userroleid = r.id,
                timezonesidkey='America/Los_Angeles',
                username='testvi3@ca.com',ContactId=testContact3.Id);
           usersList.add(u4);
           insert usersList;
           existingPortalUser = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND ContactId <> NULL and isActive = true LIMIT 1 ];
           System.assert(existingPortalUser != null, 'This test depends on an existing test portal user to run'); 
           randFax = Math.rint(Math.random() * 1000) + '5551234';
       }
      
        System.runAs(existingPortalUser) {
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            
            System.assert(controller.isEdit == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.isEdit == true);
                        
            controller.cancel();
            System.assert(controller.isEdit == false);
            
            controller.getUser().Fax = randFax;
            controller.save();
            System.assert(controller.isEdit == false);
                        
        }
        
        // verify that the user and contact were updated
        existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
        System.assert(existingPortalUser.fax == randFax);
        //System.assert(existingPortalUser.Contact.fax == randFax);
    }

}