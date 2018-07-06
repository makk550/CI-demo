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
@isTest
private class TrialReqestTest {

    static testMethod void myUnitTest() {

        RecordType accrec = [select ID,Name from RecordType where Name='Account Team Covered Account' and SObjectType='Account'];
        
        Account createacc = new Account(Name='Acc 1',GEO__c='NA',RecordTypeId=accrec.id,Customer_Category__c='Enterprise',Enterprise_ID__c='ACC001',Enterprise_Account_Name__c='Ent Acc');
        insert createacc;
            
        //Account acc = [select Id from account where GEO__c='NA' and recordtypeid=:RecordTypeId limit 1];
        Opportunity opp = [select Id from opportunity limit 1];
        Trial_Request__c trial =  new Trial_Request__c();
        trial.Request_Status__c = 'New';
        trial.OwnerId = Userinfo.getUserId();
        trial.Account_Name__c = createacc.Id;
        trial.Opp_Name__c = opp.Id;
        trial.Opp_Name__c = opp.Id;
        trial.Products_Added__c = 1;
        insert trial;
        
        
        pocMaterial__c pocMaterial = new pocMaterial__c();
        pocMaterial.quantity__c = 2;
        pocMaterial.POC_Request__c = trial.Id;
        insert pocMaterial ;
        
        trial.Request_Status__c = 'Accepted';
        update trial;

        trial.Request_Status__c = 'Approved';
        update trial;
    }
}