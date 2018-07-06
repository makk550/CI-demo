@isTest(SeeAllData=true)
public class newDealDeskAccountTest {
    @isTest static void testfun(){
       //SystemIdUtility.skipOpportunityTriggers = true;
        //SystemIdUtility.skipOpportunityLineItemTriggers  = true;
        //SystemIdUtility.isneeded=true;
        //SystemIdUtility.skipAccount = true;
                
        /*Id recid = SystemIdUtility.getResellerDistRecordTypeId();
        Account acc = new Account();
        acc.Name = 'TestAccount123';
        acc.Type = 'Customer';
        acc.GEO__c = 'LA';
        acc.Customer_Category__c = 'Enterprise';
        acc.Account_Status__c = 'New';
        acc.Commercial_Id__c = 'asdf';
        acc.recordtypeid = recid;
        system.debug('before insert');
        insert acc;*/
        SystemIdUtility.skipAccount=true;
        Account acc = new Account();
            acc.Name = 'test CAAcc';
            acc.Country_Picklist__c = 'AL - ALBANIA';
            acc.Account_Status__c = 'New';
            acc.Geo__c = 'EMEA';
            acc.BillingStreet='Arlington';
            acc.BillingCity='NY';
            acc.BillingCountry='US';
            insert acc;
        system.debug('after insert');
        system.debug('account id is'+acc.id);
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc); 
        system.debug('acc id is:'+acc.id);
        // system.debug('printing apex pages id:'+ApexPages.currentPage().getParameters().put('id',opp.id));
        ApexPages.currentPage().getParameters().put('id',acc.id);
        newDealDeskAccount obj=new newDealDeskAccount(sc);
        
        
        obj.ApplySelectionfunction();
        obj.enableNDAtypefun();
        obj.Cancelfunction();
        obj.testOutside();
        obj.testfun();
    }
    
    
}