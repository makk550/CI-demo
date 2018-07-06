@isTest(seeAllData = true)

public class testDE_ConverLead_cls{
   public static testMethod void testMeth_leadConvert(){
    RecordType r1t = [select id from recordtype where name='Reseller/Distributor Account' and sObjectType='Account' limit 1];
    Account acc = new Account();
    acc.Name = 'Test Name';
    acc.RecordTypeId = r1t.Id;
    insert acc;
    
    Contact c = new Contact();
    c.FirstName = 'test';
    c.LastName = 'contact';      
    c.AccountId = acc.Id;
    insert c;
       //create partner account
    Account acc1 = new Account();
    acc1.Name = 'Partner Name';
    acc1.RecordTypeId = r1t.Id;
    insert acc1;
    Contact c1 = new Contact();
    c1.FirstName = 'test';
    c1.LastName = 'Partner';      
    c1.AccountId = acc1.Id;
    insert c1;
    Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community Login User']; 
    User u = new User(Alias = 'testadt', Email='standardusertest12@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Partner', FirstName='test',LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertest12@testorg.com',ContactId = c1.Id);
     insert u;
       //create Distributor account
    Account acc2 = new Account();
    acc2.Name = 'Distributor Name';
    acc2.RecordTypeId = r1t.Id;
    insert acc2;
    Contact c2 = new Contact();
    c2.FirstName = 'test';
    c2.LastName = 'Distributor';      
    c2.AccountId = acc2.Id;
    insert c2;
    User u1 = new User(Alias = 'Distrte', Email='Distributorusertest12@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Distributor', FirstName='test',LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='Distributorusertest12@testorg.com',ContactId = c2.Id);
      insert u1;
    RecordType rt = [select id from recordtype where name='CA Global Lead' and sObjectType='Lead' limit 1];
    Lead l = new Lead();
       l.FirstName = 'Lead';
       l.LastName = 'test123';
       l.Status = 'New';
       l.Meeting_Rating__c = 'N/A';
       l.Street = 'bay';
       l.City = 'jacksonville';
       l.State = 'FL - Florida';
       l.Country = 'US - United States';
       l.Company = 'Test Name';
       l.EAID__c = acc.Enterprise_ID__c;
       //l.Commercial_Account__c = acc.id;
       if(rt.Id != null)
                l.RecordTypeId= rt.id;
       insert l;
       
       ApexPages.StandardController stdCtrl = new ApexPages.StandardController(l);
       DE_ConverLead_cls classObj = new DE_ConverLead_cls(stdCtrl);
       classObj.isOpportunityCreate = True;
       classObj.setSendNotificationEmail = false;
       Lead data1 = new Lead();
       data1.Transaction_Type__c = '2 Tier';
       
       classObj.leadlst = data1;
       
       Lead data2 = new Lead();
       data2.Distributor__c=acc2.Id;
       data2.Reseller__c=acc1.Id;
       data2.Reseller_Contact_Name__c=c1.Id;
       data2.Distributor_Contact__c=c2.Id;
       data2.Account_Contact__c=acc.Id;
       classObj.lds = data2;
       PageReference pageRef4 = classObj.checkContacts();
       data2.Reseller__c=null;
       classObj.lds = data2;
       PageReference pageRef5 = classObj.checkContacts();
       classObj.hideSectionOnChange();
       data1.Transaction_Type__c = '1 Tier';
       classObj.leadlst = data1;
       data2.Reseller__c=null;
       classObj.lds = data2;
       PageReference pageRef6 = classObj.checkContacts();
       classObj.hideSectionOnChange();
       data1.Transaction_Type__c = 'ERWIN';
       classObj.leadlst = data1;
        data2.Transaction_Type__c = 'ERWIN';
       classObj.leadlst = data2;
       
       classObj.hideSectionOnChange();
       data1.Transaction_Type__c = 'OEM';
       classObj.leadlst = data1;
          data2.Transaction_Type__c = 'OEM';
       classObj.leadlst = data2;
       
       classObj.hideSectionOnChange();
       data1.Transaction_Type__c = 'Direct';
       classObj.leadlst = data1;
          data2.Transaction_Type__c = 'DIRECT';
       classObj.leadlst = data2;
       classObj.hideSectionOnChange();
       data1.Transaction_Type__c = 'None';
       classObj.leadlst = data1;
         data2.Transaction_Type__c = 'None';
       classObj.leadlst = data2;
       classObj.hideSectionOnChange();
        
       data1.Transaction_Type__c = 'xSP';
       data2.Service_Provider_Platform__c = null;
       classObj.leadlst = data1;
       classObj.lds = data2;
       classObj.hideSectionOnChange();
       PageReference pageRef7 = classObj.checkContacts();
       
       List<SelectOption> lstoptiosn = classObj.getConvertedStatusList();
       PageReference pageRef1 = classObj.ConvertLeadRecord_1();
       PageReference pageRef2 = classObj.cancelMeth();       
       PageReference pageRef3 = classObj.CheckIsConverted();
       l.Commercial_Account__c = acc.id;
       update l;
       
       
   }
}