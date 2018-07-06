@isTest
Private Class Renewal_CRVControllerTest{
    
       

   public Static testmethod void TestRenewal_CrvController()
    {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
         
        Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert ac;
        system.assertNotEquals(null, ac.id, 'Account should get inserted');
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        system.assertNotEquals(null, renCurrency.id, 'Renewal Currency should get inserted');
        
        Product2 prod = new Product2(Name = 'TestProd');
        insert prod;      
		system.assertNotEquals(null, prod.id, 'Product should get inserted');        
        
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        insert activeContract;  
        system.assertNotEquals(null, activeContract.id, 'Active Contract should get inserted');  
        
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=ac.Id,Projected_Renewal__c=200);
        insert renewal;
        system.assertNotEquals(null, renewal.id, 'Renewal should get inserted');
            
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);
        insert rnwlProdct;
        system.assertNotEquals(null, rnwlProdct.id, 'Renewal Product should get inserted');
        
        List<Active_Contract_Product__c> actvContPrd = new List<Active_Contract_Product__c>();       
        //for(integer i=0;i<15;i++)
        //{
            Active_Contract_Product__c actvContPrd1= new Active_Contract_Product__c(name='TestACP',Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
            actvContPrd.add(actvContPrd1);
            //i=i++;
        //}
        insert actvContPrd;
        
        List<Active_Contract_Line_Item__c> acl =new List<Active_Contract_Line_Item__c>();
        //for(integer i=0;i<15;i++)
        //{
            Active_Contract_Line_Item__c acli = new Active_Contract_Line_Item__c(Name='Test', Contracted_Renewal_Amount__c = 1000, Raw_Maintenance_LC__c  = 1000, Increase_Step_1_text2__c = 1, Contract_Product__c=actvContPrd[0].Id,AOCV__c=10,ATTRF_CRV__c=10,OCV__c=10,Raw_Maint_Calc_LC__c=10);
            acl.add(acli);
            //i=i++;
        //}
           insert acl;
        Renewal_Contracts__c rnwlContrct= new Renewal_Contracts__c(name='TestRnwlCont',Renewal__c=renewal.Id,Active_Contract__c=activeContract.Id);
        insert rnwlContrct;
                
        Product2 prod2 = new Product2(Name = 'TestProd2');
        insert prod2;       
        Renewal__c renewal2 = new Renewal__c(name='TestRenewal2',Account__c=ac.Id);
        insert renewal2;
        Active_Contract__c activeContract2 = new Active_Contract__c(name='TestActiveContract2',Account__c=ac.Id);
        insert activeContract2;
        Renewal_Product__c rnwlProdct2= new Renewal_Product__c(name='TestRnwlPrdct2',Product__c=prod2.Id,Renewal__c=renewal2.Id);
        insert rnwlProdct2;
        Active_Contract_Product__c actvContPrd2= new Active_Contract_Product__c(name='TestACP2',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct2.Id,Product__c=prod2.Id);
        insert actvContPrd2;
           
        Active_Contract_Product__c actvContPrd3= new Active_Contract_Product__c(name='TestACP3',Active_Contract__c=activeContract2.Id,Renewal_Product__c=rnwlProdct2.Id,Product__c=prod2.Id);
        insert actvContPrd3;
                
        Renewal_Contracts__c rnwlContrct2= new Renewal_Contracts__c(name='TestRnwlCont2',Renewal__c=renewal2.Id,Active_Contract__c=activeContract2.Id);
        insert rnwlContrct2;
        test.starttest();
        ApexPages.StandardController acctPage = new ApexPages.StandardController(activeContract);
        Renewal_CRVController CRVcontroller =new Renewal_CRVController(acctPage);
        
         if(!CRVcontroller.lstACP.isEmpty()){         
           CRVcontroller.lstACP[0].sel = true;
           CRVcontroller.selectedRenewal = renewal2.Id;
           CRVcontroller.getlstACP();
           CRVcontroller.getACPHasPrevious();
           CRVcontroller.getACPHasNext();
           CRVcontroller.getPageSize();
            CRVcontroller.setPageSize(1);
            CRVcontroller.next();
            CRVcontroller.previous();
            CRVcontroller.getACPResultSize();
           CRVcontroller.moveRenewals();
           CRVcontroller.reasonForInvalidate = 'Invalid - Education';
           CRVcontroller.InvalidateACP(); 
           CRVcontroller.fetchRenewals(ac.Id);
        }
        if(!CRVcontroller.lstACL.isEmpty()){
            CRVcontroller.moveRenewals();
            CRVcontroller.getlstACL();
            CRVcontroller.getACLHasPrevious();
            CRVcontroller.getACLHasNext();
            CRVcontroller.getPageSize();
            CRVcontroller.setPageSize(1);
            CRVcontroller.next();
            CRVcontroller.previous() ;
            CRVcontroller.getACPResultSize();
            CRVcontroller.getACLResultSize();
            CRVcontroller.saveACL();
         }
         
         if(!CRVcontroller.lstACL.isEmpty()){
         
         CRVcontroller.getPageNo();
         CRVcontroller.getPages();
         CRVcontroller.setPages(1);
         CRVcontroller.setPageSize(1);
         CRVcontroller.editHeaderValuation();
         CRVcontroller.onload();
         CRVcontroller.unload();
         }
         test.stoptest();
         
    }
    
    public Static testmethod void TestRenewal_CrvController1()
    {
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        Account ac= new Account(Name='testAccount',Commercial_Id__c = 'test',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert ac;
        
        Renewal_Currency__c renCurrency = new Renewal_Currency__c(name='INR');
        insert renCurrency;
        
        Product2 prod = new Product2(Name = 'TestProd');
        insert prod;      
                
        Active_Contract__c activeContract = new Active_Contract__c(name='TestActiveContract',Account__c=ac.Id,Contract_Term_Months__c=10,Renewal_Currency__c=renCurrency.Id);
        insert activeContract;   
        
        Renewal__c renewal = new Renewal__c(name='TestRenewal',Account__c=ac.Id,Projected_Renewal__c=200);
        insert renewal;
            
        Renewal_Product__c rnwlProdct= new Renewal_Product__c(name='TestRnwlPrdct',Product__c=prod.Id,Renewal__c=renewal.Id);
        insert rnwlProdct; 
               test.starttest();
        List<Active_Contract_Product__c> actvContPrd = new List<Active_Contract_Product__c>();       
        for(integer i=0;i<15;i++)
        {
            Active_Contract_Product__c actvContPrd1= new Active_Contract_Product__c(name='TestACP'+i,Active_Contract__c=activeContract.Id,Renewal_Product__c=rnwlProdct.Id,Product__c=prod.Id);
            actvContPrd.add(actvContPrd1);
            i=i++;
        }
        insert actvContPrd;
 
        List<Active_Contract_Line_Item__c> acl =new List<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acli = new Active_Contract_Line_Item__c(Name='Test', Contracted_Renewal_Amount__c = 1000, Raw_Maintenance_LC__c  = 1000, Increase_Step_1_text2__c = 1, Contract_Product__c=actvContPrd[0].Id,AOCV__c=10,ATTRF_CRV__c=10,OCV__c=10,Raw_Maint_Calc_LC__c=10);
         insert acli;
         																																	
          Active_Contract_Line_Item__c acli1 = new Active_Contract_Line_Item__c(Name='Test',  Contracted_Renewal_Amount__c = 1000,TRR__C=1,Material_TARR_LC__c=1,Adjusted_ATTRF_LC__c=2, Raw_Maintenance_LC__c  = 1000, Increase_Step_1_text2__c = 1, Contract_Product__c=actvContPrd[0].Id,AOCV__c=1,ATTRF_CRV__c=10,OCV__c=10,Raw_Maint_Calc_LC__c=10);
        insert acli1;
           
           acli1.AOCV__c = 10;           
           acli1.stop_sync_trr_lc__c = false;
           acli1.Material_TARR_LC__c = 20;        
           //update acli1;

         	acli1.TRR__c = 20;     
           //acli1.stop_sync_trr_lc__c = false;
           //update acli1;
           
           acli1.Orig_ATTRF_LC__c = 3;             
           update acli1;
           test.stoptest();
           }
           
       
}