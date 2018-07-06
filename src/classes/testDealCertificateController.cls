@isTest(seeAllData= true)
public class testDealCertificateController{
 
    public testDealCertificateController(){
       
    }
    public static testmethod void testMeth(){
     RecordType rt = new RecordType();
        rt = [select id from RecordType where Name='Deal Registration' and isActive = true and sObjectType = 'Opportunity' limit 1];
   
        Account acc = new Account();
            acc.Name = 'test Acc';
            acc.Country_Picklist__c = 'AL - ALBANIA';
            acc.Account_Status__c = 'New';
            acc.Geo__c = 'EMEA';
            acc.Commercial_Id__c = 'adf';
            acc.BillingStreet = 'Arlington';
            acc.BillingCountry = 'US';
            acc.BillingCity = 'VA';
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
        ApexPages.currentPage().getParameters().put('OppId',opp.Id);
        DealCertificateController dccObj = new DealCertificateController();
        dccObj.setValues();
        dccObj.getshowDealName();
        dccObj.getLocale();
        dccObj.getLanguage();
        dccObj.getemailTemplate();
        dccObj.getTestId();
        dccObj.getshowDealNumber();
        dccObj.getshowCreatedDate();
        dccObj.getshowExpirationDate();
        dccObj.getShowDealProgram();
        dccObj.getShowPartner();
        dccObj.getShowEndUser();
        dccObj.getshowEstimatedValue();        
        dccObj.getshowSubmissionDate();
        dccObj.getshowProducts();
        
       
    }
    
       
    
}