@isTest(SeeAllData=true)
public class quoteRequestUpdateTriggerTestClass 
{
    static testMethod void quoteRequestUpdateTriggerTest() 
    { 
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();  
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        
        Id recid = SystemIdUtility.getResellerDistRecordTypeId();
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();

        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();

        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
        
        Opportunity opp = new Opportunity(AccountId=smbAcct.Id,Reseller__c=resellerAcct.Id,Name='Opp',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);
        insert opp;
        
        Trial_Request__c trialRequest = new Trial_Request__c();
        trialRequest.Account_Name__c = opp.AccountId;
        trialRequest.Opp_Name__c = opp.Id;
        trialRequest.Request_Type__c = 'Trial Request';
        trialRequest.Request_Status__c = 'New';
        trialRequest.Record_Type__c = opp.RecordType.Name;
        insert  trialRequest;
        Quote_Request__c qr = new Quote_Request__c();
        qr.Request_Status__c = 'New';
        qr.Opportunity_Name__c = opp.Id;
        qr.Quote_Number__c = '12345';
        qr.Trial_Request__c = trialRequest.Id;
        insert qr;
        
        Quote_Request__c retqr = [SELECT Id, Name, OwnerId 
                                    FROM Quote_Request__c WHERE Id = :qr.Id LIMIT 1];
        retqr.OwnerId = UserInfo.getUserId();
        retqr.Request_Status__c = 'Complete' ;
        update retqr;
        
    }
}