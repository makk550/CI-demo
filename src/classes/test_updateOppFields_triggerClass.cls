@istest
public class test_updateOppFields_triggerClass {
    @isTest(SeeAllData=true)
    static void clsRegisterOpportunityTestClass() {
    
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        //RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
         ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
         Account resellerAcct = new Account(Alliance__c = true, RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;
        
        ID techRecTypeId= SystemIdUtility.getTechPartnerRecordTypeId();
        Account techAcct = new Account(RecordTypeId= techRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert techAcct;
        
        Opportunity opp = new Opportunity(RecordTypeId=recopp, Name = 'oppInsertTrigger1' , StageName = 'test' , CloseDate = Date.today()
                    , AccountId = techAcct.Id, Reseller__c= resellerAcct.Id );
        insert opp;
        
        List<User> usrList = new List<User>();
        Profile profileid = [Select id From Profile where name = '1.0 CA Sys Admin Commit & PR' limit 1];
        usrList = [select id from User where profileid =:  profileid.id and IsActive = true Limit 5]; 
         Opportunity_Registration__c rec = new Opportunity_Registration__c(name = 'test', Alliance_Partner__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id,
               Registration_Status__c= 'Pending Approval', Technology_Partner__c= techAcct.id, Alliance_Partner_Services_Revenue__c = 890, Technology_Partner_Lead__c  = usrList[3].id);
          
          insert rec;
          
          
        PageReference oppReg = Page.RegisterOpportunity;
        oppReg.getParameters().put('oppid',opp.Id);
        Test.setCurrentPage(oppReg);
        ApexPages.StandardController stdcon2 = new ApexPages.StandardController(rec);
        clsRegisterOpportunity obj = new clsRegisterOpportunity(stdcon2);
        obj.save();
        obj.saveNsubmit();
        
}        
            


    static void test_updateOpportunityFields_triggerClass() {
       ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        Account resellerAcct = new Account(Alliance__c = true, RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;
        
        ID techRecTypeId= SystemIdUtility.getTechPartnerRecordTypeId();
        Account techAcct = new Account(RecordTypeId= techRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert techAcct;
        
        List<User> usrList = new List<User>();
        Profile profileid = [Select id From Profile where name = 'Regional Admin' limit 1];
        usrList = [select id from User where profileid =:  profileid.id and IsActive = true Limit 5]; 
         Opportunity_Registration__c rec = new Opportunity_Registration__c(name = 'test', Alliance_Partner__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id,
               Technology_Partner__c= techAcct.id, Alliance_Partner_Services_Revenue__c = 890, Technology_Partner_Lead__c  = usrList[3].id);
          
          insert rec;    
        
    }
    }