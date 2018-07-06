@isTest(seeAllData=true)
public class testEditPartnerOpportunity{
   public static testMethod void testMeth_EPO(){
   
   RecordType rt = new RecordType();
        rt = [select id from RecordType where Name='Deal Registration' and isActive = true and sObjectType = 'Opportunity' limit 1];
   
        Account acc = new Account();
            acc.Name = 'test Acc';
            acc.Country_Picklist__c = 'AL - ALBANIA';
            acc.Account_Status__c = 'New';
            acc.Geo__c = 'EMEA';
            acc.BillingStreet='Arlington';
            acc.BillingCity='NY';
            acc.BillingCountry='US';
            insert acc;
           
    
        Contact c = new Contact();
              c.FirstName = 'test contact';
              c.LastName = 'test contact';      
              c.AccountId = acc.Id;
        insert c;
        
          Opportunity opp = new Opportunity();
                opp.Name = 'test opp';
            if(rt.Id != null)
                opp.RecordTypeId = rt.Id;
                opp.AccountId = acc.Id ;
                opp.End_User_Contact__c = c.Id;
                opp.CloseDate = system.today()+1;
                opp.stageName = 'Negotiation';
                opp.type='Direct';
                opp.Partner_Engagement__c='None';
            insert opp;
            
            ApexPages.StandardController opp_std = new ApexPages.StandardController(opp);
            
            EditPartnerOpportunity objEPO = new EditPartnerOpportunity(opp_std);
            objEPO.updateOpportunity();
            
            
   
   }
}