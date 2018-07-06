@isTest
private class updateOppPdtTest{
    static testMethod void testUpdateOppPdt(){ 
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();  
        Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
        
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    
        
        Opportunity opp = new Opportunity(AccountId=smbAcct.Id,Reseller__c=resellerAcct.Id,Name='Opptest',RecordTypeId=oppRecId,CloseDate=System.today()+5,StageName='50%-Proposal Created',Initial_Billing__c=2);
        insert opp;
        
        
        Active_Contract__c ac = new Active_Contract__c(Name ='TestACrec');
        insert ac;
        
        
        
        Active_Contract_Product__c acp = new Active_Contract_Product__c(Name ='TestAcpRecord',Active_Contract__c= ac.id,Opportunity__c =opp.id,Dismantle_Date__c= System.today());
        insert acp;   
        
        Pricebook2 pb2 = [SELECT Id  FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];        
        Product2 prod2 = new Product2(Name = 'testprod');                    
        insert prod2;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb2.Id, Product2Id = prod2.Id , UnitPrice = 1.00, IsActive = TRUE);                    
        insert pbe;
        Active_Contract_Line_Item__c acli=new Active_Contract_Line_Item__c(Name='TestAcliRecord',Contract_Product__c=acp.id,AOCV__c=10);
        insert acli;    
        OpportunityLineItem oppli = new OpportunityLineItem(OpportunityId = opp.Id,PricebookEntryId = pbe.Id,Active_Contract_Product__c= acp.id,Active_Contract_Line_Item__c=acli.id);                    
        insert oppli;
        
        CA_Product_Renewal__c capr=new CA_Product_Renewal__c(name='testCARecord',Renewal_Opportunity__c=opp.id,Active_Contract_Product__c=acp.id);
        insert capr;
        
        acli = [select name,AOCV__c from Active_Contract_Line_Item__c where id =: acli.id];
        
        acli.AOCV__c =20;
        
        update acli;
        
        
    }
}