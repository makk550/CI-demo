@isTest
public class preSalesDirectorRedirectionContrlTest {
     public static testMethod void testforRedirection(){
           RecordTypes_Setting__c recordTyp=new RecordTypes_Setting__c();
          recordTyp.RecordType_Id__c='0120S0000004Jaf';
          recordTyp.Name='Presales Cancelled Request';
          recordTyp.SObject_Name__c='Presales Request';
        insert recordTyp;
        
        RecordTypes_Setting__c recordTyp1=new RecordTypes_Setting__c();
          recordTyp1.RecordType_Id__c='0120S0000004Jaf';
          recordTyp1.Name='Presales Fulfilled';
          recordTyp1.SObject_Name__c='Presales Request';
        insert recordTyp1;
          RecordTypes_Setting__c recordTyp2=new RecordTypes_Setting__c();
          recordTyp2.RecordType_Id__c='01230000000DUCb';
          recordTyp2.Name='Presales_event_RecordType';
          recordTyp2.SObject_Name__c='Event';
        insert recordTyp2;
       


       testOpportunityTriggersClass.createNewOpportunity();

       Opportunity opp = [select id from Opportunity limit 1];
        
        PreSales_Comm__c commision=new PreSales_Comm__c();
         
           commision.Commission_BU__c='AG';
           commision.Presales_Resource1__c=UserInfo.getUserId();
        
           commision.Presales_Resource2__c=UserInfo.getUserId();
           commision.Commission_Split1__c=50;
           commision.Commission_Split2__c=50;
         insert commision;
        
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
         preRecord.Action__c='Cancel';
        preRecord.Duration__c=28;
        preRecord.Start_Date__c=Date.newInstance(2017, 3, 24);
        preRecord.Request_Status__c='Pending Fulfillment ';
        preRecord.Action__c = 'New';
        //preRecord.RecordTypeId = Fulfillmentrecordtypeid;
        //preRecord.OwnerId=PreSalesFormController.queueIds(preRecord).Queue_Id__c;
        insert preRecord;
       
        Test.setCurrentPageReference(new PageReference('Page.presalesRequestDirectorRedirectionPage')); 
           System.currentPageReference().getParameters().put('id', preRecord.id);
         preSalesDirectorRedirectionController predir=new preSalesDirectorRedirectionController();
         predir.redirectpage();
     }

}