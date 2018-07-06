@isTest
public class AdminUiContrlTest{

    @isTest
    static void testWithProductInstanceNumber(){        
       Test.setCurrentPage(Page.AdminUiPage);       
       Test.startTest(); 
           ApexPages.currentPage().getParameters().put('prodId','46577');
           //ApexPages.currentPage().getParameters().put('contractNumber','0040248388');
           //ApexPages.currentPage().getParameters().put('subscriptionName','Trial-kate.mason@ca.com');
           AdminUiContrl controller = new AdminUiContrl();
            controller.massAction();
            controller.redirectBack();
       
       Test.stopTest();
       
       system.assertEquals(2,controller.adminUIList.size(),'Asserting the Wrapper Collection to be Zero');
    }
    
     @isTest
    static void testWithContractNumber(){        
       Test.setCurrentPage(Page.AdminUiPage);       
       Test.startTest(); 
          // ApexPages.currentPage().getParameters().put('prodId','46577');
           ApexPages.currentPage().getParameters().put('contractNumber','0040248388');
          // ApexPages.currentPage().getParameters().put('subscriptionName','Trial-kate.mason@ca.com');
           AdminUiContrl controller = new AdminUiContrl();
            controller.massAction();
            controller.redirectBack();
       
       Test.stopTest();
       
       system.assertEquals(2,controller.adminUIList.size(),'Asserting the Wrapper Collection to be Zero');
    }
      @isTest
    static void testWithSubscribtionName(){        
       Test.setCurrentPage(Page.AdminUiPage);       
       Test.startTest(); 
          // ApexPages.currentPage().getParameters().put('prodId','46577');
           //ApexPages.currentPage().getParameters().put('contractNumber','0040248388');
           ApexPages.currentPage().getParameters().put('subscriptionName','Trial-kate.mason@ca.com');
           AdminUiContrl controller = new AdminUiContrl();
            controller.massAction();
            controller.redirectBack();
       
       Test.stopTest();
       
       system.assertEquals(2,controller.adminUIList.size(),'Asserting the Wrapper Collection to be Zero');
    }


    @isTest
    static void testWithExistingContact(){       
        Contact testContact = createContact();    
            createProvisionalRequest(testContact); 
                    
        Test.startTest();
            Test.setCurrentPage(Page.AdminUIPage); 
            ApexPages.currentPage().getParameters().put('cemail',testContact.email);
            ApexPages.currentPage().getParameters().put('id',testContact.Id);
            
            AdminUiContrl controller = new AdminUiContrl();
            ApexPages.currentPage().getParameters().put('recordIdtoEdit',controller.adminUIList[0].Id);
            controller.edit();
            controller.massAction();
            controller.redirectBack();
            
            controller.adminUIList[0].fulfillment_status__c = 'fulfillment Completed';
            controller.adminUIList[0].status__c = 'active';
            
            ApexPages.currentPage().getParameters().put('recordIdtosave',controller.adminUIList[0].Id);
            
            controller.save();
            
        Test.stopTest();
        system.assertEquals(2,controller.adminUIList.size(),'Asserting the Wrapper Collection to be one');
    }
    
    static Contact createContact(){
    
        //Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true,GU_DUNS_NUMBER__c='791312069',GU_NAME__c='test tree');
        //acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        Account acc = CC_TestUtils.buildAccount('test account');
        insert acc;
        
        Contact con = new Contact();
        con.email = 'test@abc.com';
        con.firstName = 'Test';
        con.lastName = 'Contact';
        con.accountId = acc.Id;
        con.Click_Through_AC_Trial_Form__c = true;
        
        insert con;
        return con;
    }
    
    static Provisioning_Request__c createProvisionalRequest(Contact con){
    
        /*Provisioning_Request__c provReq = new Provisioning_Request__c();
        provReq.RequestType__c ='Trials';
        provReq.Technical_Contact__c = con.Id;
        provReq.Expiration_Date__c = Date.newInstance(2016,9,23);
        provReq.Start_Date__c = Date.newInstance(2016,9,13);
        provReq.Status__c = 'New';
        insert provReq;*/
        Provisioning_Request__c provReq = new Provisioning_Request__c();
        provReq.RequestType__c ='Trials';
        provReq.Comments__c = 'Sample Provisioning';
        provReq.Technical_Contact__c = con.Id;
        provReq.Expiration_Date__c = Date.newInstance(2016,9,23);
        provReq.Start_Date__c = Date.newInstance(2016,9,13);
        provReq.Status__c = 'New';
        insert provReq;
        return provReq;
    }
}