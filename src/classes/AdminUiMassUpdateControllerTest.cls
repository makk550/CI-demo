@isTest
public class AdminUiMassUpdateControllerTest {
    
     @isTest
    static void testWithProductInstanceNumber(){        
       Test.setCurrentPage(Page.AdminUiPage);       
       Test.startTest(); 
           ApexPages.currentPage().getParameters().put('prodId','46577');
           //ApexPages.currentPage().getParameters().put('contractNumber','0040248388');
           //ApexPages.currentPage().getParameters().put('subscriptionName','Trial-kate.mason@ca.com');
           AdminUiMassUpdateController controller = new AdminUiMassUpdateController();
           controller.fuilfilmentStatus='Fulfillment ready';
           controller.selectStatus='Fulfillment Status';
            controller.Save();
            controller.Cancel();
            controller.getStatus();
            List < SelectOption >  listOpt=controller.listStatus;
       
       Test.stopTest();
       
    }
    
     @isTest
    static void testWithContractNumber(){        
       Test.setCurrentPage(Page.AdminUiPage);       
       Test.startTest(); 
          // ApexPages.currentPage().getParameters().put('prodId','46577');
           ApexPages.currentPage().getParameters().put('contractNumber','0040248388');
          // ApexPages.currentPage().getParameters().put('subscriptionName','Trial-kate.mason@ca.com');
          AdminUiMassUpdateController controller = new AdminUiMassUpdateController();
            controller.Save();
            controller.Cancel();


       Test.stopTest();
       
    }
      @isTest
    static void testWithSubscribtionName(){        
       Test.setCurrentPage(Page.AdminUiPage);       
       Test.startTest(); 
          // ApexPages.currentPage().getParameters().put('prodId','46577');
           //ApexPages.currentPage().getParameters().put('contractNumber','0040248388');
           ApexPages.currentPage().getParameters().put('subscriptionName','Trial-kate.mason@ca.com');
          AdminUiMassUpdateController controller = new AdminUiMassUpdateController();
            controller.Save();
            controller.Cancel();


       
       Test.stopTest();
       
    }


    @isTest
    static void testWithExistingContact(){       
        Contact testContact = createContact();    
            createProvisionalRequest(testContact); 
                    
        Test.startTest();
            Test.setCurrentPage(Page.AdminUIPage); 
            ApexPages.currentPage().getParameters().put('cemail',testContact.email);
            ApexPages.currentPage().getParameters().put('id',testContact.Id);
                  AdminUiMassUpdateController controller = new AdminUiMassUpdateController();
                          controller.prodctInstanceId='70625';
                          controller.ObjectId='41720079659';
                          controller.productInstaceDetail='Trial - kate.mason@ca.com';
                          controller.datCenter='NA1';
                          controller.Status='Active';
                          controller.selectStatus='Fulfillment Status';    
                          controller.fuilfilmentStatus='Fulfillment ready';
         
            controller.Save();
            controller.Cancel();

          
            
            
        Test.stopTest();
    }
    
      @isTest
    static void testWithExistingContact1(){       
        Contact testContact = createContact();    
            createProvisionalRequest(testContact); 
                    
        Test.startTest();
            Test.setCurrentPage(Page.AdminUIPage); 
            ApexPages.currentPage().getParameters().put('cemail',testContact.email);
            ApexPages.currentPage().getParameters().put('id',testContact.Id);
                  AdminUiMassUpdateController controller = new AdminUiMassUpdateController();
                          controller.prodctInstanceId='70625';
                          controller.ObjectId='41720079659';
                          controller.productInstaceDetail='Trial - kate.mason@ca.com';
                          controller.datCenter='NA1';
                          controller.Status='Active';
                          controller.selectStatus='Status';    
                          controller.Status='Active';
         
            controller.Save();
            controller.Cancel();

          
            
            
        Test.stopTest();
    }
    
    
    static Contact createContact(){
    
        //Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true,GU_DUNS_NUMBER__c='791312069',GU_NAME__c='test tree');
        //acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        Account acc = CC_TestUtils.buildAccount('test account');
        insert acc;
        
        Contact con = new Contact();
        con.email = 'kate.mason@ca.com';
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