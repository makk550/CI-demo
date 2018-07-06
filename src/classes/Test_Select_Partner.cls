/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 
 /*************************************************************************************************
Apex Class Name     : Select_Partner
Version             : 1.0
Date Created        : 30-April-2012
Function            : Test Class for the Select_Partner Trigger
                                                                
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
* Diti Mansata         30/04/2012              Initial Creation
**************************************************************************************************/
@IsTest(SeeAllData=true)
public class Test_Select_Partner {
 
       public Account a {get;set;}
       public Contact c {get;set;}
       public User u {get;set;}
       public User newUser {get;set;}
       public String selectedProfileId {get;set;}
       public Boolean isDisabled {get;set;}
       public Boolean isNewUserFound {get;set;}
       public Boolean clickedButton {get;set;}
       
       //Constructor
       public Test_Select_Partner() {
            a = new Account();
            c = new Contact();
            u = new User();
            newUser= new User();
            isDisabled=false;   
            System.debug('inside constructor');
            isNewUserFound=false;
            clickedButton = false;
        }
        
       public PageReference checkForNewUser(){
        try{
            System.debug('isNewUserFound: ' + isNewUserFound);
          if(isNewUserFound==true)
            return null;
          
          System.debug('checking for new user with username:' + u.username);
          User usr = [select id, name, username from User where username= :u.username LIMIT 1];
          if(usr!=null && usr.username == u.username){
             newUser = usr;
             isNewUserFound = true;
             System.debug('great news - found user with userId: ' + newUser.id);
             System.debug('isNewUserFound: ' + isNewUserFound);
          }
          return null;
        }catch(Exception ex){
            System.debug('...didnt find user yet...');
            return null;
        }
       }    
       
       //Controller method invoked from the VF page button
       public PageReference createPortaluser(){
        try{
            clickedButton = true;
            //Create the Account
            Id accountId = createAccount();
            System.debug('successfully created account');
            
            //Create the Contact associated to the previously created Contact
            Id contactId = createContact(accountId);
            
            //Since the user is created asynchronously, we want to do some data validation to ensure the proper fields are populated
            if(selectedProfileId == null || u.username==null){
                if(selectedProfileId==null){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Profile is required: Please select a profile to associate new user');
                    ApexPages.addMessage(myMsg);
                }
                if(u.username==null){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Username is required: Please a username for the new user');
                   ApexPages.addMessage(myMsg);
                }
                return null;
            }
            
            //Create the User
            //NOTE - Must invoke a @future method to be able to create Account, Contacts, and Users in the same Apex Transaction
           createUser((String)contactId, c.Email, c.FirstName, c.lastname,u.Username,selectedProfileId);
                        
            //Display success message to VF page
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Successfully created Portal Contact & User records.');
            ApexPages.addMessage(myMsg);
             isDisabled=true;
            return null;
        }catch(Exception ex){
            //Display error message to VF page
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
       }
       
    //Method to create the Account 
    public Id createAccount(){
         a.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
         insert a;
         System.debug('successfully created test account with Id:' + a.id);
         return a.id;
    }
    
    //Method to create the Contact
    public Id createContact(Id acctId){
        c.accountid=acctId;
        insert c;
        System.debug('successfully created test contact with Id:' + c.id);
        return c.id;
    }
    
    //Async method, using @future, to create the User record and associate it to the previously created Contact
    //This uses @future because you can not have mixed DML operations for standard objects (Account, Contact) and Setup objects(User)
    public id createUser(String contactId, String email, String firstName, String lastName, String userName, String profileId) {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        
        
        User u = new User(alias = 'standt', email=email, 
            emailencodingkey='UTF-8', lastname=lastname, languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profileId, contactId=contactId,
            timezonesidkey='America/Los_Angeles', username=username);
        
            
        u.setOptions(dmo);
        insert u;
                
                
Lead testLead= new Lead();
 testLead.LastName='MTester';
            testLead.Status='Open';
            testLead.Company='Test Company';
            testLead.OwnerID=u.id;
          
system.runas(u){
            insert testLead;
            
            }
            testLead.Reseller_Status__c = 'Rejected';
            testLead.OwnerID=UserInfo.getUserId(); 
            update testLead;       
     return u.id;
 }           
            


    public List<SelectOption> getCustomerPortalProfiles() {
        //Execute query to get all profiles associated to Customer Portal
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%'];
        List<SelectOption> options = new List<SelectOption>();
        for(Profile p: profiles)
              options.add(new SelectOption(p.id,p.name));
        return options;
    }
    
    public PageReference reset(){
        PageReference newpage = new PageReference('/apex/create');
        newpage.getParameters().clear();
        newpage.setRedirect(true);
        return newpage;
    }
    
    /* REQUIRED TEST METHODS */
    static testMethod void createCustomerPortalUserTest() {
        Test_Select_Partner cpTest = new Test_Select_Partner();
        List<SelectOption> profileOptions = cpTest.getCustomerPortalProfiles();
        cpTest.a= new Account(name='TestMethod Account Name');
        cpTest.c = new Contact(firstName='TestFirstName', lastName='TestLastName', email='test@testorg.com');
        cpTest.u = new User(username='testusername@abc.com');
        Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%'];
        cpTest.selectedProfileId = profiles[0].id;
        
        Test.startTest();
            cpTest.checkForNewUser();
            PageReference testPageRef= cpTest.createPortaluser();
            
        Test.stopTest();
        PageReference testPageRef2 = cpTest.reset();
        cpTest.checkForNewUser();
        
    }
       
    
}