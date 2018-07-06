@istest(SeeAllData=true)
private class TestPartnerleveltrigger
{
static testMethod void FieldValidate()
{
Business_Plan__c BPA=new Business_Plan__c();
Account acc = new Account();
RecordType recAcct = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name='Reseller/Distributor Account'];
       acc.Name = 'Test Account';
       acc.Type = 'Customer';
       acc.GEO__c = 'LA';
       acc.Customer_Category__c = 'Enterprise';
       acc.Alliance_program_level__c='Premier';
       acc.Account_Status__c = 'New';
       acc.recordtypeid = recAcct.id;
       acc.Alliance__c = true;
       insert acc;
       
       BPA.Name='Test Business Plan';
       BPA.Account__c=acc.id;
       insert BPA;
       
       acc.Alliance__c=false;
       acc.Alliance_program_level__c = null;
       acc.Service_Provider__c=true;
       acc.Service_Provider_Program_level__c = 'Premier';
       update acc;
       
       Business_Plan__c BPS=new Business_Plan__c();
       BPS.Name='Test Business Plan';
       BPS.Account__c=acc.id;
       insert BPS;
       
       acc.Solution_Provider__c=true;
       acc.Solution_Provider_Program_Level__c = 'Premier';
       acc.Service_Provider__c=false;
       acc.Service_Provider_Program_level__c = null;
       update acc;
       
       Business_Plan__c BPSol=new Business_Plan__c();
       BPSol.Name='Test Business Plan';
       BPSol.Account__c=acc.id;
       insert BPSol;
       

    }
    
 }