/**
Class Name: Renewal_oldRPDSiteSelection_Test

*/
@isTest
private class Renewal_oldRPDSiteSelection_Test {
    static Pagereference pref;
   public static testmethod void testRenewal_oldRPDSiteSelection(){
    
    
    //Renewal_oldRPDSiteSelection.ContractSelection contractSelection = new ContractSelection(site.salesDocNumber,site.soldToSite);
   //List<Renewal_oldRPDSiteSelection.ContractSelection> contracts = new List<Renewal_oldRPDSiteSelection.ContractSelection>();
    
    //ApexPages.StandardController acctPage = new ApexPages.StandardController(activeContract);
    RecordType r = [select id from recordtype where name=:'Account Team Covered Account'];
    Account testaccount =new Account();      
    testaccount.Name ='testaccount';       
    testaccount.GEO__c='Japan';        
    testaccount.Sales_Area__c='Japan';       
    testaccount.Sales_Region__c='Japan';       
    testaccount.Country_Picklist__c='JP-JAPAN';        
    testaccount.Account_Status__c='Submitted';       
    testaccount.Customer_Category__c='Commercial';       
    testaccount.Region_Country__c='JP';        
    testaccount.Enterprise_ID__c='';        
    testaccount.Enterprise_Account_Name__c='';    
    testaccount.Commercial_ID__c='10024';   
    testaccount.SAP_TOPS_Site__c='S'; //check this 
        testaccount.recordtypeid = r.id;    
        //testaccount.Coverage_Model__c    ='SMB';  
    insert testaccount;

     Opportunity opp =new Opportunity(Name='testopp',AccountId=testaccount.Id,Type='Direct',RPD_Comments__c='Test',
                                      Split_Opportunity__c='No',CurrencyIsoCode='USD',Initial_Billing__c=0.00,StageName=Label.Opp_Stage_10_Percent,CloseDate=Date.today().addDays(5));
     insert opp;
  
     Active_Contract__c ac = new Active_Contract__c(name='TestAc',Sold_to_party__c=testaccount.id);
     insert ac;
     Active_Contract_Product__c acp = new Active_Contract_Product__c(name='ACP',Active_Contract__c=ac.id);
     insert acp;
     CA_Product_Renewal__c caConProd = new CA_Product_Renewal__c(Active_Contract_Product__c=acp.Id,Contract__c=ac.ID,Renewal_Opportunity__c=opp.id);
     insert caConProd;
     RPD_Contract__c rpdCon = new RPD_Contract__c(Sold_to_Site_ID__c='S 10024',Opportunity__c=opp.id, Contract_Sales_Document_No__c='40100175');
     insert rpdCon;
     Site_Association__c siteAss = new Site_Association__c(SAP_Site_ID__c='10024',System__c='S',Enterprise_ID__c=testaccount.Id, Site_Status__c = 'Approved',Country_picklist__c= 'US - UNITED STATES' ,State__c='New York',City__c ='Austin',SC_SITE_Source__c = 'Sales');
     insert siteAss;
     

     Opportunity opp6 = [select AccountId,RPD_Comments__c from Opportunity where id = :opp.id limit 1];
     
     pref = Page.Renewal_SiteAndContractsSelection;
     pref.getParameters().put('Id',opp.id);
     pref.getParameters().put('editMode','1');
     Test.setCurrentPage(pref);
     
     Renewal_oldRPDSiteSelection controller = new Renewal_oldRPDSiteSelection();
     controller.testMeth=true;
     Test.startTest();
     controller.getContracts();
     controller.contracts=new List<Renewal_oldRPDSiteSelection.ContractSelection>();
     Renewal_oldRPDSiteSelection.ContractSelection contractSelection=new Renewal_oldRPDSiteSelection.ContractSelection('S 10024','10024');
     contractSelection.defaultSelected = true;
     contractSelection.selected = true;
     controller.contracts.add(contractSelection);
     controller.getReportData();
     controller.Scenarios();
     Test.stopTest(); 
    
    
   }
   
}