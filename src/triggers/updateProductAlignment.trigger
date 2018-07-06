trigger updateProductAlignment on Product2 (after update) {
   
    List<AggregateResult>  asyncjob1= [Select count(Id) FROM AsyncApexJob WHERE JobType='BatchApex' AND(Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')];
    Integer batchesexecuting1  = (Integer)asyncjob1[0].get('expr0');
    if(batchesexecuting1  == 0)
    {
    List<Productmap__c> delp = [Select id from productmap__c];
    if(delp!=null && delp.size()>0)
    delete delp;
    }

    if(SystemIdUtility.skipUpdatePartnerLocations_testrun == false)
    {
      //-----CODE START FOR FY15 Business Plan Focus field Update Requirement-------------
    Set<Id> productIdSet = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate){
        for(Integer i=0;i<trigger.new.size();i++){
             if(trigger.old[i].Product_Group__c != trigger.new[i].Product_Group__c){
                if(trigger.new[i].Salesforce_CPQ_Product__c==false)
                    productIdSet.add(trigger.new[i].Id);
             }
        }
        if(productIdSet != null && productIdSet.size()>0){
            UpdateBusinessPlanFocusBatch UBPF = new UpdateBusinessPlanFocusBatch();
            UBPF.SetOfIds.addAll(productIdSet);
            System.debug('+++++UBPF.SetOfIds++++++'+UBPF.SetOfIds);
            UBPF.Query = 'select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where PriceBookEntry.Product2Id IN: SetOfIds';              
            ID batchprocessid = Database.executeBatch(UBPF);
            //UpdateBusinessPlanFocus.LogicTriggeredFromProduct(productIdSet);
        }
    }
    //-----CODE END FOR FY15 Business Plan Focus field Update Requirement---------------

}

    List<Product2> changedProd = new List<Product2>();
    String[] paSplit_old;
    String[] paSplit_new;
    Set<Id> prodId = new Set<Id>();
    Set<String> prodGroup = new Set<String>();
    Set<String> addedRTMSet = new Set<String>();
    Set<String> addedRTMSetNew = new Set<String>();
    Set<String> deletedRTMSet = new Set<String>();
    Map<String,String> addedRTM = new Map<String,String>();
    Map<String,String> deletedRTM = new Map<String,String>();    
    Set<String> s_new = new Set<String>();
    Set<String> s_old = new Set<String>();

    
        for(Product2 newProduct : trigger.new)
        {
            Product2 oldProduct = trigger.oldmap.get(newproduct.id);
            if(oldProduct.Id == newProduct.Id && oldProduct.Partner_Approved__c != newProduct.Partner_Approved__c)
            {
                changedProd.add(newProduct);
                
                prodId.add(newProduct.Id);
                prodGroup.add(newProduct.Product_Group__c);
                System.debug('oldProduct.Partner_Approved__c: '+oldProduct.Partner_Approved__c+' newProduct.Partner_Approved__c: '+newProduct.Partner_Approved__c);
                if(oldProduct.Partner_Approved__c != null)
                    paSplit_old = oldProduct.Partner_Approved__c.split(';');                
                System.debug(paSplit_old);
                if(newProduct.Partner_Approved__c != null)
                    paSplit_new = newProduct.Partner_Approved__c.split(';');
                System.debug(paSplit_new); 
                
                if(paSplit_old!=null && paSplit_old.size()>0)
                s_old = new Set<String>(paSplit_old);
                if(paSplit_new!=null && paSplit_new.size()>0)
                s_new = new Set<String>(paSplit_new);
                
                if(s_old.size()>s_new.size() && s_old.containsAll(s_new))
                {
                    for(String s1:s_old)                
                    if(!s_new.contains(s1))
                    {
                        System.debug('Removed-'+s1); 
                        deletedRTM.put(newProduct.id+':'+s1,s1);
                        deletedRTMSet.add(s1);
                    }
                }   
                
                else if(s_old.size()<s_new.size() && s_new.containsAll(s_old))
                {
                    for(String s1:s_new)                
                    if(!s_old.contains(s1))
                    {
                        System.debug('Added-'+s1); 
                        addedRTM.put(newProduct.id+':'+s1,s1);
                        addedRTMSet.add(s1);
                    }
                }
                
                else if(!s_new.containsAll(s_old))
                {
                    System.debug('Added and Removed');
                    for(String s1:s_old)                
                    if(!s_new.contains(s1))
                    {
                        System.debug('ARemoved-'+s1);
                        deletedRTM.put(newProduct.id+':'+s1,s1);
                        deletedRTMSet.add(s1);
                    }
                    
                    for(String s1:s_new)                
                    if(!s_old.contains(s1))
                    {
                        System.debug('AAdded-'+s1);  
                        addedRTM.put(newProduct.id+':'+s1,s1);   
                        addedRTMSet.add(s1);
                    }                         
                }                               
            }
        }
    
    
    
    List<Route_To_Market__c> rtmList = new List<Route_To_Market__c>();
    List<Route_To_Market__c> rtmListNew = new List<Route_To_Market__c>();
    Set<Id> rtmIDSet = new Set<Id>();
    Set<Id> rtmIDSetNew = new Set<Id>();
    if(addedRTMSet!=null && addedRTMSet.size()>0)
        rtmList = [Select Id, RTM__c, Account__c from Route_To_Market__c where RTM__c in: addedRTMSet];
    
    if(rtmList!=null && rtmList.size()>0)
    for(Route_To_Market__c rtm : rtmList)
        rtmIdSet.add(rtm.Id);
    List<Route_To_Market__c> rtmList1 = new List<Route_To_Market__c>();
    Set<Id> rtmIDSet1 = new Set<Id>();
    if(deletedRTMSet!=null && deletedRTMSet.size()>0)
        rtmList1 = [Select Id, RTM__c, Account__c from Route_To_Market__c where RTM__c in: deletedRTMSet];
    
    if(rtmList1!=null && rtmList1.size()>0)
    for(Route_To_Market__c rtm : rtmList1)
        rtmIdSet1.add(rtm.Id);   
        
    System.debug('rtmIDSet: '+ rtmIDSet );
    BatchAddRTM objAddBatchRTM;
    if(addedRTMSet!=null && addedRTMSet.size()>0)
    {
        List<AggregateResult>  asyncjob= [Select count(Id) FROM AsyncApexJob WHERE JobType='BatchApex' AND(Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')];
        Integer batchesexecuting  = (Integer)asyncjob[0].get('expr0');
        Boolean parallelflag = false;
        List<productmap__c> pm1 = [Select id, name from productmap__c ];
        for(Product2 p : changedProd)
        {
            for(String s : addedRTMSet)
            {        
                if(pm1!=null && pm1.size()>0)
                for(productmap__c pm : pm1)                        
                if(pm.name == p.Product_Group__c+''+s)
                parallelflag = true;
            }
        }
        if(batchesexecuting == 0 || parallelflag == false)
        {
        list<productmap__c> pmlist = new List<productmap__c>();
        for(Product2 p : changedProd)
        {
            for(String s : addedRTMSet)
            {    Productmap__c pm = new ProductMap__c(name=p.product_group__c+''+s); 
                pmlist.add(pm);
                }
        }
        if(pmlist!=null && pmlist.size()>0)
        insert pmlist;
        objAddBatchRTM=new BatchAddRTM();
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
        if(!test.isrunningtest())     
        Database.executeBatch(objAddBatchRTM,200);
        }
    }
    
    
    BatchDeleteRTM objDelBatchRTM=new BatchDeleteRTM();
    if(deletedRTMSet !=null && deletedRTMSet.size()>0)
    {
        objDelBatchRTM.rtmIDSet1=new Set<Id>();
        objDelBatchRTM.rtmIDSet1.addAll(rtmIDSet1);
        objDelBatchRTM.changedProd = new List<Product2>();
        objDelBatchRTM.changedProd.addAll(changedProd);
        objDelBatchRTM.rtmList1 = new List<Route_To_Market__c>();
        objDelBatchRTM.rtmList1.addAll(rtmList1);
        objDelBatchRTM.deletedRTM = new Map<String,String>();
        objDelBatchRTM.deletedRTM =deletedRTM.Clone();
        objDelBatchRTM.deletedRTMSet = new Set<String>();
        objDelBatchRTM.deletedRTMSet.addAll(deletedRTMSet);
        objDelBatchRTM.prodGroup = new Set<String>();
        objDelBatchRTM.prodGroup.addAll(prodGroup);
        if(!test.isrunningtest())  
        Database.executeBatch(objDelBatchRTM,200);
    }
    

  
}