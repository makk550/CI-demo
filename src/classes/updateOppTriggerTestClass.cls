@isTest(seeAllData=true)
public class updateOppTriggerTestClass 
{
    static testMethod void updateOppTriggerTest() 
    { 
        test.startTest();
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();  
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    
        
        Opportunity opp = new Opportunity(AccountId=smbAcct.Id,Reseller__c=resellerAcct.Id,Name='Opp',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);
        insert opp;
        
        contact con = new contact (firstname = 'testconnameeee', lastname = 'lastname', AccountId = smbAcct.id);
        insert con;
        
        OpportunityContactRole oppcon = new OpportunityContactRole(IsPrimary = true, OpportunityId = opp.id, contactId = con.id);
        insert oppcon ;
        
        Quote_Reporting__c q = new Quote_Reporting__c();
        q.Name = 'Test Quote reporting';
        q.Primary_Quote__c = true;
        q.Opportunity__c = opp.ID;
        q.Total_ATTRF__c = 100;
        q.Realization_Rate__c = 30;
        q.New_TRR__c = 50;
        q.TRRPercent__c = 20;
        insert q;
        
        test.stopTest();
        
    }
}