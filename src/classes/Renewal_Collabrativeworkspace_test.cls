/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Renewal_Collabrativeworkspace_test {
    
     static PageReference pref;
     static Renewal_Collabrativeworkspace_extension ext;
    static testMethod void myUnitTest() {    
    
       Account testaccount =new Account();
        testaccount.Name ='testaccount';
        testaccount.GEO__c='Japan';
        testaccount.Sales_Area__c='Japan';
        //testaccount.OwnerId='005Q0000000SYhU';
        testaccount.Sales_Region__c='Japan';
        testaccount.Country_Picklist__c='JP-JAPAN';
        testaccount.Account_Status__c='Submitted';
        testaccount.Customer_Category__c='Commercial';
        testaccount.Region_Country__c='JP';
        testaccount.Enterprise_ID__c='';
        testaccount.Enterprise_Account_Name__c='';        
        
        insert testaccount;
        
        List<Opportunity> opportunity =new List<Opportunity>();
        List<Active_Contract__c> contracts =new List<Active_Contract__c>();
        List<Renewal__c> renewals=new List<Renewal__c>();
        
        for(integer i=0;i<=15;i++)
        {
        Opportunity opp =new Opportunity(Name='testopp'+i,AccountId=testaccount.Id,
                            Type='Direct',Split_Opportunity__c='No',
                            StageName=Label.Opp_Stage_10_Percent, 
                            CloseDate=System.today(),Initial_Billing__c=0.00);
        opportunity.add(opp);
        i=i++;
        }
        Opportunity opp1 =new Opportunity(Name='testopp1',AccountId=testaccount.Id,
                            Type='Direct',Split_Opportunity__c='No',
                            StageName=Label.Opp_Stage_10_Percent,
                            CloseDate=System.today(),Initial_Billing__c=0.00);
        opportunity.add(opp1);
        
        insert opportunity;
        for(integer i=0;i<=15;i++)
        {
        Active_Contract__c contract =new Active_Contract__c(Name='tescontract'+i,Account__c=testaccount.Id);
        contracts.add(contract);
        i=i++;
        }
        Active_Contract__c contract1 =new Active_Contract__c(Name='tescontract1',Account__c=testaccount.Id,Sold_To_Party__c=testaccount.Id);
        contracts.add(contract1);
        
        Insert contracts;
        for(integer i=0;i<=15;i++)
        {
        Renewal__c renewal =new Renewal__c(Name='testRenewal'+i,Account__c=testaccount.Id);
        renewals.add(renewal);
        i=i++;
        }
        Renewal__c renewal1 =new Renewal__c(Name='testRenewal1',Account__c=testaccount.Id);
        renewals.add(renewal1);        
        insert  renewals;
        
        // set the page reference
        
        pref = Page.Renewal_CollaborativeWorkspace;
        pref.getParameters().put('id',testaccount.id);
        Test.setCurrentPage(pref);
 
        ApexPages.StandardController con = new ApexPages.StandardController(testaccount);
        ext = new Renewal_Collabrativeworkspace_extension(con);

        
        //Renewal_Collabrativeworkspace_extension ext =new Renewal_Collabrativeworkspace_extension();
        
        Test.startTest();        
        //call the extension methods
        ext.getSortDirection();
        ext.setoppValues();
        ext.getcontracts();
        ext.getcontractsbysoldoparty();
        ext.getrenewals();
        ext.sort();
        ext.getHasNext();
        ext.getoppHasNext();
        ext.getcontractHasNext();
        ext.getHasPrevious();
        ext.getoppHasPrevious();
        ext.getcontractHasPrevious();
        ext.next();
        ext.previous();
        ext.getPageSize();
        ext.setPageSize(2);
        ext.getResultSize();
        ext.getoppResultSize();
        ext.getcontractResultSize();
        Test.stopTest();
    }
}