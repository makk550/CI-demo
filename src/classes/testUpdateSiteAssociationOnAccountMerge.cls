@isTest(SeeAllData=true)
public class testUpdateSiteAssociationOnAccountMerge{

    
    public static testMethod void testDelAccount() {
        Account acc = new Account(Name='test account',RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        acc.BillingStreet='Street';
        acc.BillingCountry='US';
        acc.BillingCity='Islandia'; 
        insert acc;
        
        Site_Association__c srObj1 = new Site_Association__c();
        srObj1.Name = 'test srObj1';
        srObj1.Account_Group__c = 'Z00';
        srObj1.Enterprise_ID__c = acc.Id;
        srObj1.Country_picklist__c= 'US - UNITED STATES';
        srObj1.State__c='New York';
        srObj1.City__c ='Austin';
        
        insert srObj1;
        
        delete acc;
    
    }
}