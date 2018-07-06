@isTest
private class deactivatedApproverUser_Test
{

      static testmethod void testTrigger(){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            list<user> userList=new list<user>();
            User u1 = new User(Alias = 'standt', Email='standarduser@gmail.com',isactive=true, 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser12312@testorg.com', 
                Pmfkey__c='testU1', Title='Test', ManagerId=UserInfo.getUserId());
            User u2 = new User(Alias = 'standt', Email='standarduser@gmail.com',isactive=true, 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123334@testorg.com', 
                Pmfkey__c='testU2', Title='Test', ManagerId=UserInfo.getUserId());            
                
             userList.add(u1);
             userList.add(u2);
           insert userList;
           
                
            list<UserDeactivationEmailRecipients__c> UserDeactivationEmailRecipients=new list<UserDeactivationEmailRecipients__c>();

            UserDeactivationEmailRecipients__c item1=new UserDeactivationEmailRecipients__c();            
            item1.name='ToGroupName';
            item1.value__c='Notify TAP Approver DeActivation';
            UserDeactivationEmailRecipients.add(item1);
            

            insert UserDeactivationEmailRecipients;
            TAP_Approver__c  t=new TAP_Approver__c();
            t.Approver__c =u2.id;
            insert t;
            
           System.runAs(u1) {  
            
            u2.isActive=false;
            update u2;
           }
            
      }
  
 }