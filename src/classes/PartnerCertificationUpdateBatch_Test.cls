@isTest
public class PartnerCertificationUpdateBatch_Test {
 
    static testMethod void test_GenerateContacts() {
     
         Id atID = SystemIdUtility.getAccountTeamAcctRecordTypeId();  
        Account acc = new Account(RecordTypeId= atID,Name='Test Account Named1',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc21',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                           Alliance__c = false, segment__c = Label.SegmentVal2, coverage_model__c = Label.CovModelVal1);
     
        Business_Plan_New__c    bpObject = new Business_Plan_New__c();
        bpObject.Account__c='00130000015SVaTAAW';
        bpObject.Incentive__c ='BDF';
        bpObject.Alliance__c=true;
        bpObject.Service_Provider__c=true;
        bpObject.Solution_Provider__c=true;
        bpObject.Data_Management__c=true;
        bpObject.DM_Program_Level__c='true';
        bpObject.Plan_Fiscal_Year__c='FY 2018';
        bpObject.CA_Business_Plan_Owner__c='005300000045UXA';
        bpObject.NA__c=true;
        bpObject.EMEA__c=true;
        bpObject.LA__c=true;
        bpObject.APJ__c=true;
        bpObject.Status__c = 'insert';
        bpObject.Approvers_01__c  = '005300000045UXA';
        bpObject.Approvers_02__c  = '005300000045UXA';
        bpObject.Account_Executive__c  = '005300000045UXA';
        bpObject.GEO_Sales_VP__c  = '005300000045UXA';
        bpObject.GEO_Enablement__c  = '005300000045UXA';
        bpObject.GEO_Program_Lead__c  = '005300000045UXA';
        bpObject.GEO_Finance__c  = '005300000045UXA';
        bpObject.GEO_Marketing__c  = '005300000045UXA';
        bpObject.Partner_Business_Plan_Owner__c  = '005300000045UXA';
        bpObject.Partner_Executive_Sponsor__c = '005300000045UXA';
         

        insert bpObject;
        
        BP_Solutions__c bps=New BP_Solutions__c();
        bps.Name='Test BP sol';
        bps.Business_Plan__c=bpObject.id;
        bps.Product_Group__c='';
        insert bps;
        
        BP_Training_Contact__c bptcon=New BP_Training_Contact__c();
        
        bptcon.BP_Solutions__c=bps.Id;
        insert bptcon;
        test.startTest();
        String Query = 'SELECT Id, BP_Solutions__c, Contact__c, Resource_Type__c, Contact_Email__c, Certification_Level__c, Approved__c, Product_Group__c FROM BP_Training_Contact__c where Id = \'' + bptcon.Id + '\'';
        PartnerCertificationUpdate_Batch gen=new PartnerCertificationUpdate_Batch();
        Database.BatchableContext bc;
        gen.start(bc);
        List<BP_Training_Contact__c> bptraincons = Database.query(Query);
        gen.execute(bc,bptraincons);
        gen.finish(bc);
        test.stopTest();

      
    }
}