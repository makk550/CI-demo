global class BatchDeleteRTM implements Database.Batchable<SOBJECT>
{
    global String Query;
    global List<Product2> changedProd{get;set;}
    global List<Route_To_Market__c> rtmList1{get;set;}
    global Map<String,String> deletedRTM{get;set;}
    global Set<String> deletedRTMSet{get;set;}
    global Set<String> prodGroup{get;set;}
    global Set<Id> rtmIDSet1{get;set;}
    
    global  Database.QueryLocator Start(Database.BatchableContext BC)
    {
      Query='Select Id, RTM__c, Product_Group__c, Route_To_Market__c, Partner_Approved__c from Product_Alignment__c where Route_To_Market__c in:rtmIdSet1 and Product_Group__c in:ProdGroup';
      return Database.getQueryLocator(query);
    }

    global void Execute(Database.BatchableContext BC,List<Product_Alignment__c> listPA1)
    {
         Map<Id, List<Product_Alignment__c>> mapPA1=  new Map<Id, List<Product_Alignment__c>>();   
         Set<Product_Alignment__c> paList_delete = new Set<Product_Alignment__c>();   
        for(Product_Alignment__c pa : listPA1)
        {
            List<Product_Alignment__c> listnewPA = mapPA1.get(pa.Route_To_Market__c);
            if(listnewPA==null)    
            {
                listnewPA = new List<Product_Alignment__c>();           
                mapPA1.put(pa.Route_To_Market__c, listnewPA);
            }
            listnewPA.add(pa);
        }
        System.debug('mapPA1 : '+mapPA1);
        List<Product2> prod2List = new List<Product2>();
    Map<String,boolean> prod2Map = new Map<String,boolean>();
    if(deletedRTMSet!=null && deletedRTMSet.size()>0)
    {
       prod2List = [Select Id, Product_Group__c, Partner_Approved__c from Product2 where Product_Group__c in: prodGroup and Salesforce_CPQ_Product__c=false];
        for(Product2 p2 : prod2List)
        {
            String[] s;
            if(p2.Partner_Approved__c!=null)
            s = p2.Partner_Approved__c.split(';');
            if(s!=null && s.size()>0)
            for(String s1:s)        
                prod2Map.put(p2.Product_Group__c+':'+s1,true);
        }
    }
    
    
        if(rtmList1!=null && rtmList1.size()>0)
    for(Route_To_Market__c rtm : rtmList1)
    {
        if(mapPA1.get(rtm.Id)!=null)
        {
            List<Product_Alignment__c> paList = mapPA1.get(rtm.Id);
            if(paList!=null && paList.size()>0)
            {
                for(Product_Alignment__c pa : paList)
                for(String s : deletedRTMSet)
                {
                    if(prod2Map.get(pa.Product_Group__c+':'+s)!=null && prod2Map.get(pa.Product_Group__c+':'+s) == true)
                        System.debug('Other products with same RTM and Product Group exists--'+pa.Product_Group__c+':'+s);
                    else if(pa.RTM__c == s)
                    {
                        System.debug('delete this prod-'+pa.Product_Group__c+':'+s);
                        paList_delete.add(pa);
                    }
                }                                    
            }
        }        
    }
    if(paList_delete!=null && paList_delete.size()>0)
    {
        SystemIdUtility.skipUpdatePartnerLocations = true;
        System.debug('paList_delete.size():'+paList_delete.size()+'--'+paList_delete);
        List<Product_Alignment__c> paList_delete1 = new List<Product_Alignment__c>();
        paList_delete1.addall(paList_delete);
        Database.delete(paList_delete1);  
    }
    }
    global void finish(Database.BatchableContext BC)
    {
        //do nothing
    }
}