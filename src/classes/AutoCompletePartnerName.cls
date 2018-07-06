global class AutoCompletePartnerName extends AutoCompleteSearch{

    global AutoCompletePartnerName(String searchString){
        super(searchString);
    }

    public override Set<String> internalExecute(){
        final List<Partner_Location__c> results = SearchUtils.doQuery(  
            new Set<Object>{'Account__r.name'}, //fields
            null, //bounds
            new FieldCondition('Account__r.name').likex(StringUtils.ensureStringStartsEndsWithChar(searchString,'%')), //extraCriteria
            true, //primaryOnly
            new OrderBy('account__r.Partner_Finder_Recommended_Flag__c').descending(), //orderBy
            5);
        final Set<String> distinct = new Set<String>();
        for(Partner_Location__c result : results){
            if(result.Account__r != null){
                distinct.add(result.Account__r.name);
            }
        }
        return distinct;
    }
   
}