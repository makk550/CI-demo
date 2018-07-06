@isTest(seeAllData = true)

public class testExt_LeadConvert{
    
    public static testMethod Account createTestSMBAccount(){
        Account testAccount = new Account(name = 'TestAccount');
        testAccount.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
        testAccount.BillingStreet='Street';
        testAccount.BillingCountry='US';
        testAccount.BillingCity='Islandia'; 
        testAccount.Account_Status__c = 'New';
        testAccount.Commercial_ID__c = 'test';
        insert testAccount;
        return testAccount;        
    }
    
   public static testMethod void testMeth_leadConvert(){
    RecordType r1t = [select id from recordtype where name='Reseller/Distributor Account' and sObjectType='Account' limit 1];
    
    Account acc = new Account();
       /*
        //MANAR08
        Account testAccouont = new Account(name = 'TestAccount');
       testAccouont.RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId();
       insert testAccouont; */
   
       RecordType rt = [select id from recordtype where name='CA Global Lead' and sObjectType='Lead' limit 1];
       Lead l = new Lead();
       l.FirstName = 'test lead';
       l.LastName = 'test lead';
       l.Status = 'Pursuing';
       l.Meeting_Rating__c = 'N/A';
       l.Company = 'CA';
       
       if(rt.Id != null)
                l.RecordTypeId= rt.id;
       insert l;
       
       ApexPages.StandardController stdCtrl = new ApexPages.StandardController(l);
       ext_leadConvert classObj = new ext_leadConvert(stdCtrl);
       classObj.switchBlock();
       classObj.cancelMeth();    
       classObj.getPartnerRTMList();
       classObj.reasonValues() ; 
       classObj.selectedPartnerEngagement = 'Fulfillment-Only';
       classObj.reasonValues() ; 
       //classObj.hdnAccountId = [select id from account where recordtype.name='SMB' limit 1].id;
       classObj.hdnAccountId = createTestSMBAccount().id;
       classObj.selctedPartnerRTM = 'Service Provider';
      
       classObj.getPartnerRTMTypeList();
       classObj.selctedPartnerRTMType = 'CSP';
       classObj.checkContacts();
       Contact c = new Contact();
       c.FirstName = l.FirstName;
       c.LastName = l.LastName;
       c.AccountId = classObj.hdnAccountId;
       c.Email = 'asdasdasde@asbg.com';
       insert c;
       classObj.selctedcontact = c.Id;
       //classObj.checkContacts();
       classObj.createContact();
       classObj.selctedPartnerRTM = 'Reseller';
       classObj.createContact();
       //classObj.executeConvertLead();
       
       
     /*   Lead l1 = new Lead();
       l1.FirstName = 'test lead1';
       l1.LastName = 'test lead1';
       l1.Status = 'Pursuing';
       l1.Meeting_Rating__c = 'N/A';
       l1.Company = 'CA';
       
       if(rt.Id != null)
                l1.RecordTypeId= rt.id;
       insert l1;
       
       ApexPages.StandardController stdCtrl1 = new ApexPages.StandardController(l1);
       ext_leadConvert classObj1 = new ext_leadConvert(stdCtrl1);
      
       classObj1.switchBlock();
       classObj1.cancelMeth();    
        classObj1.getPartnerRTMList();
        classObj1.hdnAccountId = [select id from account where recordtype.name='SMB' limit 1].id;
        classObj1.selctedPartnerRTM = 'Solution Provider';
      
       classObj1.getPartnerRTMTypeList();
         classObj1.selctedPartnerRTMType = 'Distributor';
        //  classObj1.checkContacts();
         Contact c1 = new Contact();
         c1.FirstName = l.FirstName;
         c1.LastName = l.LastName;
         c1.AccountId = classObj.hdnAccountId;
         c1.Email = 'asdasdasde@asbg.com';
        insert c1;
       classObj1.selctedcontact = c1.Id;
       classObj1.checkContacts();
       classObj1.createContact();
       
       classObj1.executeConvertLead();
       */
       
       
       
       
   }
    public static testMethod void testMeth_leadConvert2(){
           test.starttest();
  user u1=new user(id='00530000003rQuJ');
    
   system.runas(u1){
       RecordType r1t = [select id from recordtype where name='Reseller/Distributor Account' and sObjectType='Account' limit 1];
    
    Account acc = new Account();
    
   
   
       RecordType rt = [select id from recordtype where name='CA Global Lead' and sObjectType='Lead' limit 1];
       Lead l = new Lead();
       l.FirstName = 'test lead';
       l.LastName = 'test lead';
       l.Status = 'Pursuing';
       l.Meeting_Rating__c = 'N/A';
       l.Company = 'CA';
       
       if(rt.Id != null)
                l.RecordTypeId= rt.id;
       insert l;
       
       ApexPages.StandardController stdCtrl = new ApexPages.StandardController(l);
       ext_leadConvert classObj = new ext_leadConvert(stdCtrl);
       classObj.switchBlock();
       classObj.cancelMeth();    
       classObj.getPartnerRTMList();
       classObj.reasonValues() ; 
       classObj.selectedPartnerEngagement = 'Fulfillment-Only';
       classObj.reasonValues() ; 
       //classObj.hdnAccountId = [select id from account where recordtype.name='SMB' limit 1].id;
       classObj.hdnAccountId = createTestSMBAccount().id;
       classObj.selctedPartnerRTM = 'Solution Provider';
      
       classObj.getPartnerRTMTypeList();
       classObj.selctedPartnerRTMType = 'Reseller';
       classObj.checkContacts();
       Contact c = new Contact();
       c.FirstName = l.FirstName;
       c.LastName = l.LastName;
       c.AccountId = classObj.hdnAccountId;
       c.Email = 'asdasdasde@asbg.com';
       insert c;
       classObj.selctedcontact = c.Id;
       //classObj.checkContacts();
       classObj.createContact();
        test.stoptest();  
       }
    }
    public static testMethod void testMeth_leadConvert3(){
       RecordType r1t = [select id from recordtype where name='Reseller/Distributor Account' and sObjectType='Account' limit 1];
    
       Account acc = new Account();
    
   
   
       RecordType rt = [select id from recordtype where name='CA Global Lead' and sObjectType='Lead' limit 1];
       Lead l = new Lead();
       l.FirstName = 'test lead';
       l.LastName = 'test lead';
       l.Status = 'Pursuing';
       l.Meeting_Rating__c = 'N/A';
       l.Company = 'CA';
       
       if(rt.Id != null)
                l.RecordTypeId= rt.id;
       insert l;
       
       ApexPages.StandardController stdCtrl = new ApexPages.StandardController(l);
       ext_leadConvert classObj = new ext_leadConvert(stdCtrl);
       classObj.switchBlock();
       classObj.cancelMeth();    
       classObj.getPartnerRTMList();
       classObj.reasonValues() ; 
       classObj.selectedPartnerEngagement = 'Fulfillment-Only';
       classObj.reasonValues() ; 
       //classObj.hdnAccountId = [select id from account where recordtype.name='SMB' limit 1].id;
       classObj.hdnAccountId = createTestSMBAccount().id;
      
       classObj.getPartnerRTMTypeList();
       classObj.selctedPartnerRTMType = 'Reseller';
       classObj.checkContacts();
       Contact c = new Contact();
       c.FirstName = l.FirstName;
       c.LastName = l.LastName;
       c.AccountId = classObj.hdnAccountId;
       c.Email = 'asdasdasde@asbg.com';
       insert c;
       classObj.selctedcontact = c.Id;
       //classObj.checkContacts();
       classObj.createContact();  
    }
     public static testMethod void testMeth_leadConvert4(){
       RecordType r1t = [select id from recordtype where name='Reseller/Distributor Account' and sObjectType='Account' limit 1];
    
       Account acc = new Account();
    
   
   
       RecordType rt = [select id from recordtype where name='CA Global Lead' and sObjectType='Lead' limit 1];
       Lead l = new Lead();
       l.FirstName = 'test lead';
       l.LastName = 'test lead';
       l.Status = 'Pursuing';
       l.Meeting_Rating__c = 'N/A';
       l.Company = 'CA';
       
       if(rt.Id != null)
                l.RecordTypeId= rt.id;
       insert l;
         
        
       Lead l1 = new Lead();
       //l1.FirstName = 'test lead';
       l1.LastName = 'test lead';
       l1.Status = 'Pursuing';
       l1.Meeting_Rating__c = 'N/A';
       l1.Company = 'CA';
       
       if(rt.Id != null)
                l1.RecordTypeId= rt.id;
       insert l1;
       
       ApexPages.StandardController stdCtrl = new ApexPages.StandardController(l);
       ext_leadConvert classObj = new ext_leadConvert(stdCtrl);
         
         ApexPages.StandardController stdCtrl1 = new ApexPages.StandardController(l1);
       ext_leadConvert classObj2 = new ext_leadConvert(stdCtrl1);
         ext_leadConvert classObj1 = new ext_leadConvert();
       
         classObj.switchBlock();
       classObj.cancelMeth();    
       classObj.getPartnerRTMList();
       classObj.reasonValues() ; 
       classObj.selectedPartnerEngagement = 'Fulfillment-Only';
       classObj.reasonValues() ; 
       //classObj.hdnAccountId = [select id from account where recordtype.name='SMB' limit 1].id;
       classObj.hdnAccountId = createTestSMBAccount().id;
      
       classObj.getPartnerRTMTypeList();
       classObj.selctedPartnerRTMType = 'SAAS Aggregators';
       classObj.checkContacts();
       Contact c = new Contact();
       c.FirstName = l.FirstName;
       c.LastName = l.LastName;
       c.AccountId = classObj.hdnAccountId;
       c.Email = 'asdasdasde@asbg.com';
       insert c;
       classObj.selctedcontact = c.Id;
       //classObj.checkContacts();
       classObj.createContact();  
    }
    
}