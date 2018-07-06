public class PopulateExpireDt_Quote {
    
    public void PopulateExpDate_Insert(List<Route_To_Market__c> NewRouteMarketList){
         list<Id> AccountIds=new list<Id>();
         for(Route_To_Market__c RouteMarketRec:NewRouteMarketList){
            if(RouteMarketRec.Agreement_End_Date__c != null ){
                AccountIds.add(RouteMarketRec.Account__c);
            }
        }
        
        if(AccountIds != null && AccountIds.size()>0){
            UpdateQuotes(AccountIds);
        }
    }
    
    public void PopulateExpDate_Update(List<Route_To_Market__c> NewRouteMarketList,Map<id,Route_To_Market__c> OldRouteMarketMap){
        list<Id> AccountIds=new list<Id>();
        //Date LongestEndDt=new Date();
        
         
         System.debug('+++++ inside update method +++++');
        
        for(Route_To_Market__c RouteMarketRec:NewRouteMarketList){
            if(RouteMarketRec.Agreement_End_Date__c != null && RouteMarketRec.Agreement_End_Date__c!= OldRouteMarketMap.get(RouteMarketRec.id).Agreement_End_Date__c){
                AccountIds.add(RouteMarketRec.Account__c);
                System.debug('---Id --'+RouteMarketRec.id+'--- New end date --'+ RouteMarketRec.Agreement_End_Date__c);
            }
        }
        
       	if(AccountIds!= null && AccountIds.size()>0){
            System.debug('+++ accids size() +++'+AccountIds.size());
        	UpdateQuotes(AccountIds);
    	}
    }
    
    Public void UpdateQuotes(list<id> AccountIds){
        
         Map<id,list<Route_To_Market__c>> AccIdRouteMktMap=new Map<id,list<Route_To_Market__c>>();
         Map<id,Date> AccIdGreatestDt=new Map<id,Date>();
         List<SBQQ__Quote__c> QuotesToUpdate=new List<SBQQ__Quote__c>();
        
        //Query all the route to market records to take latest end date
        	list<Route_To_Market__c> RouteMktList=[select Account__c,Agreement_End_Date__c from Route_To_Market__c where  Account__c in:AccountIds ];
        	System.debug('++++ route to market +++'+RouteMktList.size());
        if(RouteMktList !=  null && RouteMktList.size()>0){
             //form map of accid and RouteMkt greatest date
         	 for(Route_To_Market__c rmt:RouteMktList){
             	if(AccIdGreatestDt.containsKey(rmt.Account__c)){
                	 if(AccIdGreatestDt.get(rmt.Account__c) < rmt.Agreement_End_Date__c){
                     AccIdGreatestDt.put(rmt.Account__c,rmt.Agreement_End_Date__c);
                 	}
             	}
             	else{
                 AccIdGreatestDt.put(rmt.Account__c,rmt.Agreement_End_Date__c);
             	}
             }
        
             if(AccIdGreatestDt != null && AccIdGreatestDt.size()>0){
        		// Query the quotes and update these partner account associated Quotes Expires On field
       		 	list<SBQQ__Quote__c> QuotesList=[select Partner1__c,SBQQ__ExpirationDate__c from SBQQ__Quote__c where Partner1__c in :AccountIds];
                 System.debug('+++ QuotesList ++++'+QuotesList.size());
                 if(QuotesList!= null && QuotesList.size()>0){
                     
                     for(SBQQ__Quote__c sbq:QuotesList){
                         if(AccIdGreatestDt.containsKey(sbq.Partner1__c)){
                             if(sbq.SBQQ__ExpirationDate__c != AccIdGreatestDt.get(sbq.Partner1__c)  ){
                                 System.debug('+++ Greatest dt +++ '+AccIdGreatestDt.get(sbq.Partner1__c));
                                 sbq.SBQQ__ExpirationDate__c= AccIdGreatestDt.get(sbq.Partner1__c);
                                 QuotesToUpdate.add(sbq);
                             }
                         }
                     }
                     
                     if(null != QuotesToUpdate && QuotesToUpdate.size()>0){
                         update QuotesToUpdate;
                     }
                 }
             }
        }
         
        
    }

}