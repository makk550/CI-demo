@isTest //(seeAllData = true)
private class TestupdateProductAlignment_Product2
{    
   
    static testmethod void TestupdateProductAlignment()
    {
    SystemIdUtility.skipUpdatePartnerLocations_testrun =  true;
     SystemIdUtility.skipProductTriggers=true;
        Set<ID> rtmIDSet =  new Set<ID>();
        Set<String> prodGroup = new Set<String>();
        Set<String> addedRTMSet= new Set<String>();
        List<Product2> changedProd = new List<Product2>();
        List<Route_To_Market__c> rtmList = new List<Route_To_Market__c>();
        Map<String,String> addedRTM = new Map<String,String>();
        Product2 prd1 = new Product2(Name='Prd1',Family='Product',Market_Focus_Area__c='SECURITY',IsActive=true, Product_Group__c='2E');
        Product2 prd5 = new Product2(Name='Prd5', Family='Support',Market_Focus_Area__c='OTHER',IsActive=true, Product_Group__c='2E');
        Product2[] prd = new Product2[]{prd1,prd5};
        insert prd;
        prodGroup.add(prd1.product_group__c);
        ChangedProd.add(prd1);
        addedRTM.put(prd1.id+':Alliance','Alliance');
        addedRTMSet.add('Alliance');
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate=true;
        Account testAccount = new Account(); 
        testAccount.Name = 'Test Account _ DM Values';
        testAccount.CurrencyIsoCode = 'USD';
        testAccount.Account_Type__c = 'Distributor';
        testAccount.Country_Picklist__c = 'MX - MEXICO';
        testAccount.RecordTypeId = SystemIdUtility.getResellerDistRecordTypeId(); 
        insert testAccount; 
        
        Route_To_Market__c rtm2 = new Route_To_Market__c(Account__c=testAccount.id,Name='rtm2',RTM__c='Alliance');
        Route_To_Market__c[] rtmList1 = new Route_To_Market__c[]{rtm2};
        insert rtmList1;
        rtmIDSet.add(rtm2.id);
        rtmList.add(rtm2);
        
        Product_Alignment__c pa1 = new Product_Alignment__c(Related_Account__c=testAccount.id,Product_Group__c='2E', Partner_Approved__c=true);
        insert pa1;
        
        Test.startTest();
        
        prd1.Partner_Approved__c = ''; //Remove
        update prd1;
        
        prd5.Partner_Approved__c = 'Service Provider';
        update prd5;
        
       // Product2[] prdList = new Product2[]{prd1,prd2,prd3,prd4,prd5,prd6};
       // update prdList;
        
        BatchAddRTM objAddBatchRTM = new BatchAddRTM ();
        objAddBatchRTM.rtmIDSet=new Set<Id>();
        objAddBatchRTM.rtmIDSet.addAll(rtmIDSet);
        objAddBatchRTM.ProdGroup =new Set<String>();
        objAddBatchRTM.ProdGroup.addAll(ProdGroup);
        objAddBatchRTM.changedProd=new List<Product2>();
        objAddBatchRTM.changedProd.addAll(changedProd);
        objAddBatchRTM.rtmList=new List<Route_To_Market__c>();
        objAddBatchRTM.rtmList.addAll(rtmList);
        objAddBatchRTM.addedRTM=New Map<String,String>();
        objAddBatchRTM.addedRTM=addedRTM.clone();
        objAddBatchRTM.addedRTMSet = new Set<String>();
        objAddBatchRTM.addedRTMSet.addAll(addedRTMSet);            
        Database.executeBatch(objAddBatchRTM,200);
        
        BatchDeleteRTM objDelBatchRTM=new BatchDeleteRTM();
        objDelBatchRTM.rtmIDSet1=new Set<Id>();
        objDelBatchRTM.rtmIDSet1.addAll(rtmIDSet);
        objDelBatchRTM.changedProd = new List<Product2>();
        objDelBatchRTM.changedProd.addAll(changedProd);
        objDelBatchRTM.rtmList1 = new List<Route_To_Market__c>();
        objDelBatchRTM.rtmList1.addAll(rtmList);
        objDelBatchRTM.deletedRTM = new Map<String,String>();
        objDelBatchRTM.deletedRTM =addedRTM.Clone();
        objDelBatchRTM.deletedRTMSet = new Set<String>();
        objDelBatchRTM.deletedRTMSet.addAll(addedRTMSet);
        objDelBatchRTM.prodGroup = new Set<String>();
        objDelBatchRTM.prodGroup.addAll(prodGroup);        
        Database.executeBatch(objDelBatchRTM,500);
        
        Test.stopTest();
        SystemIdUtility.skipUpdatePartnerLocations_testrun =  false;
    }
}