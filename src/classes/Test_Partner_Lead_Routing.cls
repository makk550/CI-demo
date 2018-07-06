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
Apex Trigger Name   : Partner_Lead_Routing
Version             : 1.0
Date Created        : 30-April-2012
Function            : Test Class for the Partner_Lead_Routing Trigger
                                                                
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
* Diti Mansata          30/04/2012              Initial Creation
**************************************************************************************************/
@isTest(SeeAllData=true)
private class Test_Partner_Lead_Routing{

static testmethod void Partner_Lead_Routing(){

Profile p = [select id from Profile where Name = 'System Administrator' ];
     
      User usr = new User(Alias = 'Dummy', Email='standarduser@ca.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', Profileid=p.Id ,TimeZoneSidKey='America/Los_Angeles',Eligible_to_receive_leads__c = TRUE,
      UserName='DummyUser@testorg.com');
      
      Insert Usr;

Account testAcc=new Account(Name='Test Account',Sales_Region__c='NA_CORPORATE',Service_Provider__c = TRUE,
                            Alliance__c = TRUE,Lead_Champion__c=usr.ID,Velocity_Seller__c =TRUE,Solution_Provider__c = TRUE,
                            RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
insert(testAcc);

Partner_Lead_Routing_Rules__c plrr1=new Partner_Lead_Routing_Rules__c();
plrr1.NCV_Driver__c='RM Other';
plrr1.Territory_Region__c='NA_CORPORATE';
plrr1.Rule_Start_Date__c = system.today()-1;
plrr1.Rule_Expiration_Date__c = system.today()+1;
plrr1.RTM__c = 'Alliance';
plrr1.Segment__c=Label.SegmentVal3;
insert(plrr1);

Partner_Lead_Routing_Rules__c plrr2=new Partner_Lead_Routing_Rules__c();
plrr2.NCV_Driver__c='RM Other';
plrr2.Territory_Region__c='NA_CORPORATE';
plrr2.Rule_Start_Date__c = system.today()-1;
plrr2.Rule_Expiration_Date__c = system.today()+1;
plrr2.RTM__c = 'Service Provider';
insert(plrr2);

Partner_Lead_Routing_Rules__c plrr3=new Partner_Lead_Routing_Rules__c();
plrr3.NCV_Driver__c='RM Other';
plrr3.Territory_Region__c='NA_CORPORATE';
plrr3.Rule_Start_Date__c = system.today()-1;
plrr3.Rule_Expiration_Date__c = system.today()+1;
plrr3.RTM__c = 'Solution Provider';
plrr3.Segment__c=Label.SegmentVal3;
insert(plrr3);

Lead testLead= new Lead();
testLead.Reseller_Status__c = 'Accepted';
testLead.Reseller_Initiated__c=true;
testLead.LastName='MTester';
testLead.Status='Open';
testLead.Company='Test Company';
testLead.MKT_BU_Category__c = 'Other';
testLead.MKT_Solution_Set__c = 'RM Other';
testLead.RTM__c = 'Solution Provider'; 
testLead.Segment__c=Label.SegmentVal3;
insert testLead;




Lead testLead1= new Lead();
testLead1.Reseller_Status__c = 'Accepted';
testLead1.Reseller_Initiated__c=true;
testLead1.LastName='MTester';
testLead1.Status='Open';
testLead1.Company='Test Company';
testLead1.MKT_Solution_Set__c = 'RM Other';
testLead1.Segment__c=Label.SegmentVal3;
insert testLead1;

testLead1.isSubmitPartner__c=true;
update testLead1;

}
}