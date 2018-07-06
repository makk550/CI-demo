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
Apex Class Name     : Populate_Last_Accepted_Lead_Date
Version             : 1.0
Date Created        : 30-April-2012
Function            : Test Class for the Populate_Last_Accepted_Lead_Date Trigger
                                                                
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
* Diti Mansata         30/04/2012              Initial Creation
**************************************************************************************************/
@IsTest(SeeAllData=true)
private class Test_Populate_Last_Accepted_Lead_Date{

static testmethod void Populate_Last_Accepted_Lead_Date(){

createUser();
       
         
}
 //@future 
 static void createUser() {
       
        Profile p = [select id from profile where name='System Administrator'];
  Profile[] profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%'];
Account a=new Account(Name='Test',RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
insert a;
    
Contact c=new Contact();
c.LastName='TestCont';
c.accountid=a.ID;
insert c;
Database.DMLOptions dmo = new Database.DMLOptions();
dmo.EmailHeader.triggerUserEmail = true;
        
User u = new User(alias = 'utest', email='test@ca.com',contactId=c.id,
      emailencodingkey='UTF-8', lastname='Unit Test', 
      languagelocalekey='en_US',
      localesidkey='en_GB', profileid = profiles[0].id,
      timezonesidkey='Europe/London', 
      username='untest@ca.com');
        
            
        u.setOptions(dmo);
        insert u;
        
        Lead testLead= new Lead();
        testLead.Reseller_Status__c = 'Accepted';
        testLead.Reseller_Initiated__c=true;
        testLead.LastName='MTester';
        testLead.Status='Open';
        testLead.Company='Test Company';
        //testLead.OwnerID=u.id;
        
        system.runas(u){

Group g = new Group(Type='Queue', Name=QueueCust__c.getInstance('Common Partner Lead Pool').Name);
insert g;

            insert testLead;
            
            }  
        
        
        }
}