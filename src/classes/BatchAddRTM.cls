global class BatchAddRTM implements Database.Batchable<SOBJECT>
{
    global String Query;
    global List<Product2> changedProd{get;set;}
    global List<Route_To_Market__c> rtmList {get;set;}
    global Map<String,String> addedRTM {get;set;}
    global Set<String> addedRTMSet{get;set;}  
    global Set<Id> rtmIDSet{get;set;}
    global Set<String> ProdGroup {get;set;}
    global  Database.QueryLocator Start(Database.BatchableContext BC)
    {
      system.debug('****'+rtmIDSet);
      system.debug('****'+ProdGroup);
      if(!test.isrunningtest())
      Query='Select Id, RTM__c, Account__c from Route_To_Market__c where RTM__c in: addedRTMSet';
      else
      Query='Select Id, RTM__c, Account__c from Route_To_Market__c where RTM__c in: addedRTMSet limit 200';
      
      system.debug('&&&&&&&&'+Query);           
      return Database.getQueryLocator(Query);      
    }

    global void Execute(Database.BatchableContext BC,List<Route_To_Market__c> rtmList)
    {        
        Set<Id> rtmSet = new Set<Id>();
        for(Route_To_Market__c rtm : rtmList)
            rtmSet.add(rtm.Id);
        
        List<Product_Alignment__c> listPA = [Select Id, RTM__c, Authorized_Agreement__c, Related_Account__c, Product_Group__c, Route_To_Market__c, Business_unit__c, Partner_Approved__c from Product_Alignment__c where Route_To_Market__c in: rtmSet and Product_Group__c in:ProdGroup];
        Map<Id, List<Product_Alignment__c>> mapPA=  new Map<Id, List<Product_Alignment__c>>();     
        for(Product_Alignment__c pa : listPA)
        {
            //setName.add(''+pa.Route_To_Market__c+pa.Authorized_Agreement__c+pa.Partner_Approved__c+pa.Related_Account__c+pa.Product_Group__c+pa.Business_Unit__c);
            List<Product_Alignment__c> listnewPA = mapPA.get(pa.Route_To_Market__c);
            if(listnewPA==null)    
            {
                listnewPA = new List<Product_Alignment__c>();           
                mapPA.put(pa.Route_To_Market__c, listnewPA);
            }
            listnewPA.add(pa);
        }
        System.debug('mapPA : '+mapPA);
    Set<Route_To_Market__c> toinsert = new Set<Route_To_Market__c>();
    Set<Product_Alignment__c> paList_insert = new Set<Product_Alignment__c>();
    Set<Product_Alignment__c> paList_update = new Set<Product_Alignment__c>();   
    
    if(rtmList!=null && rtmList.size()>0)
    for(Route_To_Market__c rtm : rtmList)
    {                    
        Product_Alignment__c pa1 = new Product_Alignment__c();
        if(mapPA.get(rtm.Id)!=null)
        {
            List<Product_Alignment__c> paList = mapPA.get(rtm.Id);
            if(paList!=null && paList.size()>0)
            {
                for(Product_Alignment__c pa : paList)
                {                             
                    for(Product2 p2 : changedProd)
                    {
                        System.debug('addedRTM.get(p2.id): '+addedRTM.get(p2.id+':'+pa.rtm__c)+'--p2.Product_Group__c:'+p2.Product_Group__c);
                        if(pa.Product_Group__c == p2.Product_Group__c && pa.rtm__c == addedRTM.get(p2.id+':'+pa.rtm__c))
                        {
                            System.debug('PA Record found for - '+pa.rtm__c+' Product Group- '+p2.Product_Group__c);
                            if(pa.Partner_Approved__c == false)
                            {
                                pa.Partner_Approved__c  = true;
                                paList_update.add(pa);
                            }                       
                        }                                                                 
                    }
                }
                
            }             
        } 
        else
        {                  
                System.debug('PA Record not found for - '+rtm.rtm__c);                                
                pa1.Route_To_Market__c = rtm.id;
                pa1.Authorized_Agreement__c = true;
                pa1.Partner_Approved__c = true;
                pa1.Related_Account__c = rtm.Account__c;
                pa1.Product_Group__c = changedProd[0].product_group__c;
                pa1.Business_Unit__c = changedProd[0].Market_Focus_Area__c;                       
                paList_insert.add(pa1);             
            
        }                               
    }    
    if(paList_insert!=null && paList_insert.size()>0)
    {
        SystemIdUtility.skipUpdatePartnerLocations = true;
        System.debug('paList_insert.size():'+paList_insert.size()+'--'+paList_insert);
        List<Product_Alignment__c> paList_insert1 = new List<Product_Alignment__c>();
        paList_insert1.addall(paList_insert);
        Database.insert(paList_insert1);
    } 
    if(paList_update!=null && paList_update.size()>0)
    {
        SystemIdUtility.skipUpdatePartnerLocations = true;
        System.debug('paList_update.size():'+paList_update.size()+'--'+paList_update);
        List<Product_Alignment__c> paList_update1 = new List<Product_Alignment__c>();
        paList_update1.addall(paList_update);
        Database.update(paList_update1);
    }
    }
    global void finish(Database.BatchableContext BC)
    {       
    
    }
}