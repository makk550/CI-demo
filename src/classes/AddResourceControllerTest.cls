/*
 * For Class = AddResourceController
 * Coverage = 95%.
 * Updated by SAMTU01
*/


@isTest                      //(seeAllData=true)
public class AddResourceControllerTest {
    
    public static testMethod void testforAddresorce(){
        
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
      
       
       PreSales_Director_Queues__c presalDirect=new PreSales_Director_Queues__c();
           presalDirect.Name='Presales Queue NA AC';
           presalDirect.GEO__c='NA';
           presalDirect.CBU__c='AC';
           presalDirect.Queue_Id__c='00Ga0000004K9Yd';
         insert presalDirect;
       
         PreSales_Director_Queues__c presalDirect1=new PreSales_Director_Queues__c();
           presalDirect1.Name='Presales Queue NA Mismatch';
           presalDirect1.GEO__c='NA';
           presalDirect1.CBU__c='';
           presalDirect1.Queue_Id__c='00Ga0000004K9Yi';
         insert presalDirect1;
        
        
        testOpportunityTriggersClass.createNewOpportunity();
        Opportunity opp = [select id from Opportunity limit 1];
        
        
        PreSales_Comm__c commision=new PreSales_Comm__c();        
           commision.Commission_BU__c='AC';
           commision.Presales_Resource1__c=UserInfo.getUserId();  
           commision.Presales_Resource2__c=UserInfo.getUserId();
           commision.Commission_Split1__c=50;
           commision.Commission_Split2__c=50;
         insert commision;
        
        Presales_Request__c preRecord=new Presales_Request__c();
        preRecord.opportunity__c=opp.id; 
        preRecord.PreSales_Commission__c=commision.Id;
        preRecord.Presales_Resource1__c=UserInfo.getUserId();
        preRecord.Presales_Resource2__c=UserInfo.getUserId();
        preRecord.Presales_Resource3__c=null;

        preRecord.GEO__c='NA';
        preRecord.Activity__c='Roadmap';
        preRecord.Commission_BU__c='AC';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
         Test.setCurrentPageReference(new PageReference('Page.AddResourcesPage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
        
        AddResourceController addResource=new AddResourceController();
                    addResource.addResource();
                 addResource.redirectRequest();
        
    }

}