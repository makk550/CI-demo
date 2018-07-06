/*
 * Edited By      : Aparna Samala
 * Description    : Test Class for Renewal_AddRenewalProduct
 * 
 * Test Class	  : Renewal_AddRenewalProductTest
 * Coverage 	   :- 81%
 * Updated ON	  : Aug 3rd 2017 
 */
@isTest
private class Renewal_AddRenewalProductTest {
    @isTest
    static void myUnitTest() {
        /*Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Status__c = 'Approved';      
        ac.BillingState = 'NY';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.Reseller_Disti_Regional_ID__c = 'PA75344';
        ac.Reseller_Distributor_Name__c = 'APJ DM Test';
        ac.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId();                              
        insert ac;*/
         Test_CreateOpportunity.insertRecordtypes();
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
      Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
          
              
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        Opportunity opp = new Opportunity(RecordTypeId=recopp.Id, Name = 'oppTestAddRenewal1' , StageName = 'test' , CloseDate = Date.today()
                    , AccountId = smbAcct.Id,Reseller__c = resellerAcct.Id );
        insert opp;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        
        List<product2> prodList = new List<product2>();
        Product2 prod = new Product2(Name = 'TestProd');
        prodList.add(prod);  
        Product2 prod2 = new Product2(Name = 'TestProd2');
        prodList.add(prod2);
        insert prodList; 
        
        List<Renewal__c> renewalList = new List<Renewal__c>();    
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=smbAcct.Id,Projected_Renewal__c=200);
        renewalList.add(renewal);  
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=smbAcct.Id);
        renewalList.add(renewal2);
        insert renewalList;
              
        List<Active_Contract__c> activeContractList = new List<Active_Contract__c>(); 
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=smbAcct.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        activeContractList.add(activeContract);
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=smbAcct.Id);
        activeContractList.add(activeContract2);
        insert activeContractList;
        
        List<Renewal_Product__c> renewalProdList = new List<Renewal_Product__c>();
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);
        renewalProdList.add(rnwlProdct); 
        Renewal_Product__c rnwlProdct2= new Renewal_Product__c(name='TestRnwlPrdct2',Product__c=prod2.Id,Renewal__c=renewal2.Id);
        renewalProdList.add(rnwlProdct2);
        insert renewalProdList;
              
        List<Active_Contract_Product__c> activeContractProdList = new List<Active_Contract_Product__c>();              
        Active_Contract_Product__c actvContPrd= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
        activeContractProdList.add(actvContPrd);
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct2.Id,Product__c=prod2.Id);
        activeContractProdList.add(actvContPrd2);
        insert activeContractProdList;        
              
        
        
        List<Renewal_Contracts__c> renewalContractList = new List<Renewal_Contracts__c>();
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        renewalContractList.add(rnwlContrct);                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        renewalContractList.add(rnwlContrct2);
        insert renewalContractList;
        
        Test.startTest();
        
        String Opportunity_Type = 'Renewal,Services';
        
        
        String OppType1 = Opportunity_Type.substring(0,Opportunity_Type.indexOf('Renewal,'));
        String OppType2 = Opportunity_Type.substring(Opportunity_Type.indexOf('Renewal,')+8,Opportunity_Type.length());
        System.debug('OppType1 '+OppType1 +'OppType2 '+OppType2);
        
        Opportunity_Type = 'Support,Renewal,Services';
        OppType1 = Opportunity_Type.substring(0,Opportunity_Type.indexOf('Renewal,'));
        OppType2 = Opportunity_Type.substring(Opportunity_Type.indexOf('Renewal,')+8,Opportunity_Type.length());
        System.debug('OppType1 '+OppType1 +'OppType2 '+OppType2);
        
        Opportunity_Type = 'Support,Renewal';
        OppType1 = Opportunity_Type.substring(0,Opportunity_Type.indexOf(',Renewal'));
        //OppType2 = Opportunity_Type.substring(Opportunity_Type.indexOf('Renewal,')+8,Opportunity_Type.length()-1);
        OppType2 ='';
        System.debug('OppType1 '+OppType1 +'OppType2 '+OppType2);
                        
        //CA_Product_Renewal__c caProdRen = new CA_Product_Renewal__c();
        // class methods
        PageReference pageRef = Page.Renewal_add_CA_RenewalProduct;
        Test.setCurrentPage(pageRef);
  //ApexPages.StandardController con = new ApexPages.StandardController(new Opportunity());
  
        
        ApexPages.StandardSetController con;// = new ApexPages.StandardSetController(new CA_Product_Renewal__c());
        pageRef.getParameters().put('Id',opp.Id);
        Renewal_AddRenewalProduct ctrl = new Renewal_AddRenewalProduct(con);
        System.debug('ctrl.RenewalProductList '+ctrl.RenewalProductList);
        
        for(integer i=0;i<ctrl.RenewalProductList.size();i++){
            ctrl.RenewalProductList.get(i).selected = true;
        //camDetails.PLBSSummaryApplicantWise.get(i).add()
        }
        System.debug('ctrl.RenewalProductList '+ctrl.RenewalProductList);
        ctrl.addProduct();
        ctrl.getRenewalProductList();
        ctrl.getHasNext();
        ctrl.getHasPrevious();
        ctrl.getPageSize();
        ctrl.setPageSize(5);
        ctrl.getResultSize();
        ctrl.next();
        ctrl.getHasNext();
        ctrl.getHasPrevious();
        ctrl.previous();
        Test.stopTest();
    }
}