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
Apex Class Name     : Test_Lead_Not_Null
Version             : 1.0
Date Created        : 05-May-2012
Function            : Test Class for the Test Lead Not Null Trigger
                                                                
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
* Diti Mansata         05/05/2012              Initial Creation
**************************************************************************************************/
@isTest(seeAllData = true)
private class Test_Test_Lead_Not_Null{

   static testMethod void Test_Test_Lead_Not_Null() {
         Profile p = [select id from Profile where Name = 'System Administrator' ];
        User usr = new User(Alias = 'Dummy', Email='standarduser@gmail.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', Profileid=p.Id ,TimeZoneSidKey='America/Los_Angeles',Eligible_to_receive_leads__c = TRUE,
      UserName='DummyUser@testorg.com');
      
      Insert Usr;

          Account testAcc=new Account(Name='Test Account',Lead_Champion__c = usr.id,Alliance_Program_Level__c='Premier',Alliance_type__c ='Technology Partner',
          Alliance_CAM_PMFKey__c = 'TEST01',Alliance_Designation__c = 'OEM',Alliance__c = true, Last_Accepted_Lead_Date__c = system.today(),
          RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
        
        insert(testAcc);
        
         Account testAcc2=new Account(Name='Test Account2',Last_Accepted_Lead_Date__c = system.today()-1,
          RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
        insert(testAcc2);
        
        
        Campaign c= new Campaign(Name='test camp');
        
        insert c;
      
        List<Lead> leadList = new List<Lead>();
        Partner_Lead_Routing_Rules__c plrr=new Partner_Lead_Routing_Rules__c();
        plrr.Campaign__c=c.id;
        plrr.Account__c=testAcc.id;
        plrr.Rule_Start_Date__c=system.today()-1;
         plrr.Rule_Expiration_Date__c=system.today()+1;
        insert(plrr);
        
        Lead testLead= new Lead();
        testLead.Reseller_Status__c = 'Accepted';
        testLead.Reseller_Initiated__c=true;
        testLead.LastName='MTester';
        testLead.Status='Open';
        testLead.Company='Test Company';
        testLead.MKT_BU_Category__c = 'Other';
        testLead.MKT_Solution_Set__c = 'RM Other';
        
        insert testLead;        

      
       Campaign c2= new Campaign(Name='test cam2');
        insert c2;
        
        Partner_Lead_Routing_Rules__c plrr2=new Partner_Lead_Routing_Rules__c();
        plrr2.Campaign__c=c2.id;
        plrr2.Account__c=testAcc.id;
        plrr2.Account_2__c=testAcc2.id;
        plrr2.Rule_Start_Date__c=system.today()-1;
         plrr2.Rule_Expiration_Date__c=system.today()+1;
         plrr2.BU__c = 'Alliance';
         plrr2.Tie_Breaker_Rule__c = 'Shark Tank';
        insert(plrr2);
      
      
        Lead testLead2= new Lead();
        testLead2.Reseller_Status__c = 'Accepted';
        testLead2.Reseller_Initiated__c=true;
        testLead2.LastName='MTester';
        testLead2.Status='Open';
        testLead2.Company='Test Company';
        testLead2.MKT_BU_Category__c = 'Other';
        testLead2.MKT_Solution_Set__c = 'RM Other';
        
        insert testLead2;

        Campaign c2a= new Campaign(Name='test cam2a');
        insert c2a;
      
       Partner_Lead_Routing_Rules__c plrr2a=new Partner_Lead_Routing_Rules__c();
        plrr2a.Campaign__c=c2a.id;
        plrr2a.Account__c=testAcc2.id;
        plrr2a.Account_2__c=testAcc.id;
        plrr2a.Rule_Start_Date__c=system.today()-20;
         plrr2a.Rule_Expiration_Date__c=system.today();
        plrr2.BU__c = 'Mainframe';
        plrr2.NCV_Driver__c = 'Chorus';
        plrr2a.Tie_Breaker_Rule__c = 'Score';
        insert(plrr2a);
      test.starttest();
      
          Lead testLead2a= new Lead();
        testLead2a.Reseller_Status__c = 'Accepted';
        testLead2a.Reseller_Initiated__c=true;
        testLead2a.LastName='MTester';
        testLead2a.Status='Open';
        testLead2a.Company='Test Company';
       testLead2a.MKT_BU_Category__c = 'Mainframe';
        testLead2a.MKT_Solution_Set__c = 'Chorus';
           
        insert testLead2a;


        Campaign c2b= new Campaign(Name='test cam2b');
        insert c2b;
      
       Partner_Lead_Routing_Rules__c plrr2b=new Partner_Lead_Routing_Rules__c();
        plrr2b.Campaign__c=c2b.id;
        plrr2b.Account__c=testAcc.id;
        plrr2b.Account_2__c=testAcc2.id;
        plrr2b.Rule_Start_Date__c=system.today()-20;
         plrr2b.Rule_Expiration_Date__c=system.today();
        plrr2b.BU__c = 'Mainframe Capacity';
        plrr2b.NCV_Driver__c = 'MF Other';
        plrr2b.Tie_Breaker_Rule__c = 'Round Robin';
        insert(plrr2b);
      
      
          Lead testLead2b= new Lead();
        testLead2b.Reseller_Status__c = 'Accepted';
        testLead2b.Reseller_Initiated__c=true;
        testLead2b.LastName='MTester';
        testLead2b.Status='Open';
        testLead2b.Company='Test Company';
       testLead2b.MKT_BU_Category__c = 'Mainframe Capacity';
        testLead2b.MKT_Solution_Set__c = 'MF Other';
           testLead2b.ownerid = usr.id;
        insert testLead2b;

       
     List<CampaignMember> cMemList = new List<CampaignMember>();
     
              
      CampaignMember cm=new CampaignMember();
      cm.LeadID=testLead2b.Id;
      cm.CampaignId=c2b.id;
    cMemList.add(cm);
    
                  
      CampaignMember cm1=new CampaignMember();
      cm1.LeadID=testLead2a.Id;
      cm1.CampaignId=c2a.id;
    cMemList.add(cm1);
    
          CampaignMember cm2=new CampaignMember();
      cm2.LeadID=testLead2.Id;
      cm2.CampaignId=c2b.id;
    cMemList.add(cm2);

      insert cMemList;
      test.stoptest();
      }
}