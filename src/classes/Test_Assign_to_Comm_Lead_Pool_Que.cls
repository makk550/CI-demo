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
Apex Class Name     : Test_Assign_to_Common_Lead_Pool_Queue
Version             : 1.0
Date Created        : 25-April-2012
Function            : Test Class for theAssign_to_Common_Lead_Pool_Queue Trigger
                                                                
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
* Diti Mansata          26/04/2012              Initial Creation
**************************************************************************************************/
@isTest(SeeAllData=true)
private class Test_Assign_to_Comm_Lead_Pool_Que{

   static testMethod void Test_Assign_to_Com_Lead_Pool_Que() {
      List<User> Usr_lst = new List<User> ();  
      // Create the Instance of the Group Object //
      Group Grp = new Group (Name = 'Common Partner Lead Pool', Type = 'Queue');
      Insert Grp;
      
      QueueSobject Que = new QueueSobject (SobjectType = 'Lead',QueueId = Grp.Id);
      Insert Que;
      
      
        
            
        
      
      
      Profile pr = [select id from Profile where Name = 'System Administrator' ];
     
      User usr = new User(Alias = 'Dummy', Email='standarduser@ca.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', Profileid=pr.Id ,TimeZoneSidKey='America/Los_Angeles',Eligible_to_receive_leads__c = TRUE,
      UserName='DummyUser@testorg.com');
      
      Insert Usr;
    
        
     // Create the instance of the Account//
         List<Account> TestAcc_lst = new List<Account> ();
         List<Contact> TestCon_lst = new List<Contact> ();
         List<RecordTypes_Setting__c> RTS_lst = new List <RecordTypes_Setting__c> ();
      
     // Create the Custom Setting Instance//
      if ( RecordTypes_Setting__c.getInstance('SMB') == null){
           RTS_lst.add(new RecordTypes_Setting__c (Name = 'SMB',RecordType_Id__c ='012V0000000Ckjl',SObject_Name__c='Account'));
         }
      if ( RecordTypes_Setting__c.getInstance('Account Team Covered Account') == null){
           RTS_lst.add(new RecordTypes_Setting__c (Name = 'Account Team Covered Account',RecordType_Id__c ='012V0000000Ckjb',SObject_Name__c='Account'));
         }
      if ( RecordTypes_Setting__c.getInstance('Account Team Covered Account') == null){
           RTS_lst.add(new RecordTypes_Setting__c (Name = 'Territory Covered Account',RecordType_Id__c ='012V0000000Ckjg',SObject_Name__c='Account'));
         } 
      if ( RecordTypes_Setting__c.getInstance('CA Enterprise Account') == null){
           RTS_lst.add(new RecordTypes_Setting__c (Name = 'CA Enterprise Account',RecordType_Id__c ='01230000000DNfM',SObject_Name__c='Account'));
         }      
     system.runas(Usr){
         insert RTS_lst;
     }
    
    
        
    for (Integer i =0;i<5;i++){
        if (Math.Mod(i,2) == 0) 
         TestAcc_lst.add(new Account(Name = 'TestAcc'+i,Solution_Provider_Program_Level__c = 'Advance', Lead_Champion__c = Usr.Id,Solution_Provider__c =true,Not_eligible_for_Shark_tank_Leads__c = true,RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId()));
         
        else {
         TestAcc_lst.add(new Account(Name = 'TestAcc'+i,Solution_Provider_Program_Level__c = 'Advance',Lead_Champion__c = Usr.Id,Solution_Provider__c =true,Not_eligible_for_Shark_tank_Leads__c = false,RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId()));
         
        }
     }
    system.runas(Usr){
        
        Insert(TestAcc_lst);
        
         
     } 
     
      
      for (Integer i =0;i<5;i++){
        if (Math.Mod(i,2) == 0) 
         TestCon_lst.add(new Contact (LastName = 'TestCon'+i,Account = TestAcc_lst[i]));
        else{
          TestCon_lst.add(new Contact(LastName = 'TestCon'+i,Account = TestAcc_lst[i]));
        }
     }
     system.runas(Usr){
      try {
      Insert(TestCon_lst);
     } Catch (Exception E) {
      system.debug('Contact Cant be inserted ****************************' + E);
      }
     }
     
     Usr.Eligible_to_receive_leads__c = true;
     Usr.Contact = TestCon_lst[0];
     
     update Usr;
     
     Usr.Eligible_to_receive_leads__c = false;
     //Usr.ContactID = TestCon_lst[0].ID;
     
     update Usr;
     
          
     /*
      // Create the Instance of the Users//
      Usr_lst.add(new User(FirstName = 'Testusr',Eligible_to_receive_leads__c = true)) ;
      Usr_lst.add(new User(FirstName = 'Testusr1',Eligible_to_receive_leads__c = true));
      Usr_lst.add(new User(FirstName = 'Testusr2',Eligible_to_receive_leads__c = true));
      try{
        insert Usr_lst;
       } Catch (Exception E){
         System.debug('Insert cant be performed --->' + E);
       }   
    */
    }
 }