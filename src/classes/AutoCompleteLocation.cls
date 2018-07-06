global class AutoCompleteLocation extends AutoCompleteSearch{

    global AutoCompleteLocation(String searchString){
        super(searchString);
    }

    public override Set<String> internalExecute(){
        final Set<String> distinct = new Set<String>();
        final String searchStrWildcarded = StringUtils.ensureStringStartsEndsWithChar(this.searchString,'%');

        List<Partner_Location__c> results = SearchUtils.doQuery(  
            new Set<Object>{'City__c','State_Province__c','Country__c'}, //fields
            null, //bounds
            new OrCondition()
                .add(new FieldCondition('City__c').likex(searchStrWildcarded))
                .add(new FieldCondition('State_Province__c').likex(searchStrWildcarded)), //extraCriteria
            false, //primaryOnly
            null, //orderBy
            5 //queryRowLimit
        );

	    for(Partner_Location__c location : results){
	    	distinct.add(
	            StringUtils.defaultString(location.City__c) + ' ' +
	            StringUtils.defaultString(location.State_Province__c) + ' ' + 
	            StringUtils.trim(StringUtils.substringBeforeLast(StringUtils.defaultString(location.Country__c),'('))
	    	);
	    }

        results = SearchUtils.doQuery(  
            new Set<Object>{'Postal_Code__c','Country__c'}, //fields
            null, //bounds
            new FieldCondition('Postal_Code__c').likex(searchStrWildcarded), //extraCriteria
            false, //primaryOnly
            null, //orderBy
            null //queryRowLimit
        );

        for(Partner_Location__c location : results){
            if(StringUtils.isNotEmpty(location.Postal_Code__c)){
                distinct.add(
                    location.Postal_Code__c + ' ' 
                    + StringUtils.trim(StringUtils.substringBeforeLast(StringUtils.defaultString(location.Country__c),'('))
                );
            }
        }
        return distinct;
    }
   
}