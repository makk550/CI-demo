global class ACLAggregateResultIterable implements Iterable<AggregateResult>{    
     private String query;
    global ACLAggregateResultIterable(String soql){
        query = soql;
    }    
    global Iterator<AggregateResult> Iterator(){
        return new ACLAggregateResultIterator(query);
    }
}