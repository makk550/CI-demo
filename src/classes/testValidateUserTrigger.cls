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
private class testValidateUserTrigger {
    static testMethod void myUnitTest() 
    {
        // TO DO: implement unit test
        Profile p = [select id from profile where name='1.0 CA Sys Admin Commit & PR'];
        User testUser=[Select Id from User where ProfileId=:p.Id and IsActive=true limit 1];
        System.runAs(testUser) {
        	//create Commit_Org_Downtime__c
        	Commit_Org_Downtime__c coDownTime=new Commit_Org_Downtime__c(Name='Test Commit Org',Downtime_External_Id__c='test123');
        	insert coDownTime;
        	
        	//create Commit_Org_Downtime_Admin__c
        	Commit_Org_Downtime_Admin__c coDownTimeAdmin=new Commit_Org_Downtime_Admin__c(Commit_Org_Downtime__c=coDownTime.Id,User__c=testUser.Id);
        	insert coDownTimeAdmin;
        	
        	//create Commit_Org_Downtime_Datetime__c
        	Commit_Org_Downtime_Datetime__c coDownTimeDateTim=new Commit_Org_Downtime_Datetime__c(Commit_Org_Downtime__c=coDownTime.Id, 
        	End_Datetime__c=System.now(), Start_Datetime__c=System.now());
        	insert coDownTimeDateTim;
        }       
    }
}