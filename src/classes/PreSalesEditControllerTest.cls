@isTest         
public class PreSalesEditControllerTest {
     

     public static testMethod void testforedit1(){

        insertPreSalesRecType();

         testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];
           
        PreSales_Comm__c commision=new PreSales_Comm__c();       
           commision.Commission_BU__c='AG';
           commision.Presales_Resource1__c=null;
           commision.Presales_Resource2__c=null;
           commision.Presales_Resource1__c=null;
         insert commision;
          PreSales_Comm__c commision1=new PreSales_Comm__c();       
            commision1.Commission_BU__c='AG';
            commision1.Presales_Resource1__c=null;
            commision1.Presales_Resource2__c=null;
            commision1.Presales_Resource3__c=UserInfo.getUserId();
            commision1.Commission_Split3__c=100;
            insert commision1;
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=opp.id; 
        preRecord.PreSales_Commission__c=commision.Id;
        preRecord.GEO__c='NA';
        preRecord.Activity__c='Roadmap';
        preRecord.Presales_Resource1__c=null;
        preRecord.Presales_Resource2__c=UserInfo.getUserId();
        preRecord.Presales_Resource3__c=UserInfo.getUserId();
        preRecord.Removal_Reason1__c='Other';
        preRecord.Removal_Reason2__c='';
        preRecord.Removal_Reason3__c=''; 
        preRecord.Commission_BU__c='AG';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        //preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
       
        Test.setCurrentPageReference(new PageReference('Page.PreSalesEditpage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
         
         PreSalesEditController presaledit=new PreSalesEditController();
            presaledit.getNumberOfPreSlesResouce();
                    presaledit.numberofpresal='1';
                   presaledit.cancelationReason='Not needed';
                     presaledit.resorcesRenderingMethod();
                     presaledit.save();
                     presaledit.approveResource();
                     presaledit.removeResource();
                     presaledit.cancellationRequest();
        

         
         
     }
    
    
    public static testMethod void testforApprover1(){

        insertPreSalesRecType();
        
      testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];

        PreSales_Comm__c commision=new PreSales_Comm__c();
         
           commision.Commission_BU__c='AG';
           commision.Presales_Resource1__c=null;
           commision.Presales_Resource2__c=null;
         insert commision;
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=opp.id; 
        preRecord.PreSales_Commission__c=commision.Id;
        preRecord.GEO__c='NA';
        preRecord.Activity__c='Roadmap';
        preRecord.Presales_Resource1__c=null;
        preRecord.Presales_Resource2__c=null;
        preRecord.Presales_Resource3__c=UserInfo.getUserId();
        preRecord.Commission_BU__c='AG';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
       // preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
          Test.setCurrentPageReference(new PageReference('Page.PreSalesEditpage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
         PreSalesEditController presaledit=new PreSalesEditController();
             presaledit.numberofpresal='2';
                     presaledit.cancelationReason='Not needed';
                     presaledit.resorcesRenderingMethod();
                     presaledit.save();
                     presaledit.approveResource();
                     presaledit.removeResource();
                     presaledit.cancellationRequest();
                     presaledit.rejectedRequest();
                  
        
    }
    
     public static testMethod void testforApprover2(){

        insertPreSalesRecType();
        
       testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];

        PreSales_Comm__c commision=new PreSales_Comm__c();        
           commision.Commission_BU__c='AG';
           commision.Presales_Resource1__c=null;       
           commision.Presales_Resource2__c=null;
         insert commision;
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=opp.id; 
        preRecord.PreSales_Commission__c=commision.Id;
        preRecord.GEO__c='NA';
        preRecord.Activity__c='Roadmap';
        preRecord.Presales_Resource1__c=null;
        preRecord.Presales_Resource2__c=null;
        preRecord.Presales_Resource3__c=UserInfo.getUserId();
        preRecord.Commission_BU__c='AG';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        //preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
         
         Presales_Request__c preRecord1=new Presales_Request__c();
        preRecord1.opportunity__c=opp.id; 
        preRecord1.PreSales_Commission__c=commision.Id;
        preRecord1.GEO__c='NA';
        preRecord1.Activity__c='Roadmap';
        preRecord1.Presales_Resource1__c=UserInfo.getUserId();
        preRecord1.Role1__c=null;
        preRecord1.Commission_BU__c='AG';
        preRecord1.Duration__c=28;
        preRecord1.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord1.Request_Status__c='Pending Fulfillment ';
        preRecord1.Action__c = 'New';
          insert preRecord1;
          Test.setCurrentPageReference(new PageReference('Page.PreSalesEditpage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
         PreSalesEditController presaledit=new PreSalesEditController();
                     presaledit.numberofpresal='3';
                     presaledit.cancelationReason='Not needed';
                     presaledit.resorcesRenderingMethod();
                     presaledit.save();
                     presaledit.approveResource();
                     presaledit.removeResource();
                     presaledit.cancellationRequest();
                     presaledit.rejectedRequest();
                  
        
    }
    
    public static testMethod void testforApprover3(){
        
        insertPreSalesRecType();
      testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];

        PreSales_Comm__c commision=new PreSales_Comm__c();       
           commision.Commission_BU__c='AG';
           commision.Presales_Resource1__c=null;       
           commision.Presales_Resource2__c=null;          
             insert commision;               
        Presales_Request__c preRecord1=new Presales_Request__c();
        preRecord1.opportunity__c=opp.id; 
        preRecord1.PreSales_Commission__c=commision.Id;
        preRecord1.GEO__c='NA';
        preRecord1.Activity__c='Roadmap';
        preRecord1.Presales_Resource1__c=UserInfo.getUserId();
        preRecord1.Presales_Resource2__c=UserInfo.getUserId();
        preRecord1.Presales_Resource2__c=UserInfo.getUserId();
        preRecord1.Role1__c=null;
        preRecord1.Commission_BU__c='AG';
        preRecord1.Duration__c=28;
        preRecord1.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord1.Request_Status__c='Pending Fulfillment ';
        preRecord1.Action__c = 'Add';
          insert preRecord1;
           Test.setCurrentPageReference(new PageReference('Page.PreSalesEditpage')); 
           System.currentPageReference().getParameters().put('id', preRecord1.id);
                    PreSalesEditController presaledit=new PreSalesEditController();
                    presaledit.numberofpresal='3';
                    presaledit.preSalesResourceInform();
                    


                           
    }
    public static testMethod void testforedit4(){

        insertPreSalesRecType();
         testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];
           
       
          PreSales_Comm__c commision1=new PreSales_Comm__c();       
            commision1.Commission_BU__c='AG';
            commision1.Presales_Resource1__c=UserInfo.getUserId();
            commision1.Presales_Resource2__c=null;
            commision1.Presales_Resource3__c=UserInfo.getUserId();
            commision1.Commission_Split1__c=50;
            commision1.Commission_Split3__c=50;
            insert commision1;
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=opp.id; 
        preRecord.PreSales_Commission__c=commision1.Id;
        preRecord.GEO__c='NA';
        preRecord.Activity__c='Roadmap';
        preRecord.Presales_Resource1__c=UserInfo.getUserId();
        preRecord.Presales_Resource2__c=null;
        preRecord.Presales_Resource3__c=UserInfo.getUserId();
        preRecord.Removal_Reason1__c='';
        preRecord.Removal_Reason2__c='Other';
        preRecord.Removal_Reason3__c=''; 
        preRecord.Commission_BU__c='AG';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        //preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
       
        Test.setCurrentPageReference(new PageReference('Page.PreSalesEditpage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
         
         PreSalesEditController presaledit=new PreSalesEditController();
            presaledit.getNumberOfPreSlesResouce();
                    presaledit.numberofpresal='1';
                   presaledit.cancelationReason='Not needed';
                     presaledit.resorcesRenderingMethod();
                     presaledit.save();
                     presaledit.approveResource();
                     presaledit.removeResource();
                     presaledit.cancellationRequest();
        

         
         
     }
     public static testMethod void testforedit5(){
        insertPreSalesRecType();
         testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];
           
       
          PreSales_Comm__c commision1=new PreSales_Comm__c();       
            commision1.Commission_BU__c='AG';
            commision1.Presales_Resource1__c=UserInfo.getUserId();
            commision1.Presales_Resource2__c=null;
            commision1.Presales_Resource3__c=UserInfo.getUserId();
            commision1.Commission_Split1__c=50;
            commision1.Commission_Split3__c=50;
            insert commision1;
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=opp.id; 
        preRecord.PreSales_Commission__c=commision1.Id;
        preRecord.GEO__c='NA';
        preRecord.Activity__c='Roadmap';
        preRecord.Presales_Resource1__c=UserInfo.getUserId();
        preRecord.Presales_Resource2__c=UserInfo.getUserId();
        preRecord.Presales_Resource3__c=null;
        preRecord.Removal_Reason1__c='';
        preRecord.Removal_Reason2__c='';
        preRecord.Removal_Reason3__c='Other'; 
        preRecord.Commission_BU__c='AG';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        //preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
       
        Test.setCurrentPageReference(new PageReference('Page.PreSalesEditpage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
         
         PreSalesEditController presaledit=new PreSalesEditController();
            presaledit.getNumberOfPreSlesResouce();
                    presaledit.numberofpresal='1';
                   presaledit.cancelationReason='Not needed';
                  List<SelectOption> listop=presaledit.listop;
                     presaledit.save();
                     presaledit.approveResource();
                     presaledit.removeResource();
                     presaledit.cancellationRequest();
        

         
         
     }

     static testMethod void insertPreSalesRecType(){

           id preSalescancellId=Schema.SObjectType.Presales_Request__c.getRecordTypeInfosByName().get('Presales Cancelled Request').getRecordTypeId();

         RecordTypes_Setting__c recordTyp=new RecordTypes_Setting__c();
          recordTyp.RecordType_Id__c=preSalescancellId;                                  
          recordTyp.Name='Presales Cancelled Request';
          recordTyp.SObject_Name__c='Presales Request';
        insert recordTyp;
     id preSalesPendingId=Schema.SObjectType.Presales_Request__c.getRecordTypeInfosByName().get('Presales Pending Fulfillment').getRecordTypeId();

        RecordTypes_Setting__c recordTyp3=new RecordTypes_Setting__c();
          recordTyp3.RecordType_Id__c=preSalesPendingId;                                    
          recordTyp3.Name='Presales Pending Fulfillment';
          recordTyp3.SObject_Name__c='Presales Request';
        insert recordTyp3;
     id preSalesFullId=Schema.SObjectType.Presales_Request__c.getRecordTypeInfosByName().get('Presales Fulfilled').getRecordTypeId();
        RecordTypes_Setting__c recordTyp1=new RecordTypes_Setting__c();
          recordTyp1.RecordType_Id__c=preSalesFullId;
          recordTyp1.Name='Presales Fulfilled';
          recordTyp1.SObject_Name__c='Presales Request';
        insert recordTyp1;        
         id preSaleseventId=Schema.SObjectType.Event.getRecordTypeInfosByName().get('Presales Event').getRecordTypeId();

          RecordTypes_Setting__c recordTyp2=new RecordTypes_Setting__c();
          recordTyp2.RecordType_Id__c=preSaleseventId;
          recordTyp2.Name='Presales_event_RecordType';
          recordTyp2.SObject_Name__c='Event';
        insert recordTyp2;

     }

    
}