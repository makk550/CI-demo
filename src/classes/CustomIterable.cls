global class CustomIterable implements Iterable<SObject>, Iterator<SObject>{ 
    
    List<SObject> sobjs {get; set;} 
    Integer i {get; set;} 
     public Iterator<SObject> iterator() { return this; }
    public CustomIterable(List<Active_Contract_Product__c> acplist,
                          List<OpportunityLineItem> olilist,
                          List<CA_Product_Renewal__c> rcplist
                       
                         ){ 
                             i=0;

                             sobjs = new List<SObject>();
                             if( acplist!= null && acplist.size() >0 )
                                 sobjs.addAll(acplist);
                             if ( olilist != null && olilist.size() >0)    
                                 sobjs.addAll(olilist);
                             if(rcplist != null && rcplist.size() >0 )
                                 sobjs.addAll(rcplist);
                         System.debug('samap01 sobjs '+sobjs.size());
                         
                         }   
    global boolean hasNext(){ 
        if(i >= sobjs.size()) 
            return false; 
        else 
            return true; 
    }    
    global SObject next(){ 
        if(i == sobjs.size()){ i++; return null;} 
        i=i+1; 
        return sobjs[i-1]; 
    } 
                         
}