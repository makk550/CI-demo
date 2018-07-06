global virtual class AutoCompleteSearch{
	
    global String searchString {get;private set;}

    public AutoCompleteSearch(String searchString){
        if(StringUtils.length(StringUtils.trim(searchString)) < 2){
            throw new IllegalArgumentException('Search string parameter must be two characters or more!');
        }
        this.searchString = searchString;
    }
    
    public virtual Set<String> internalExecute(){
    	return new Set<String>();
    }

    global List<String> execute(){
    	final Set<String> aSet = internalExecute();
        final List<String> results = new List<String>();
        if(aSet != null && aSet.size() > 0){
            for(String result : aSet){
                results.add(result);
            }
        }
        ArrayUtils.qsort(results,new PrimitiveComparator());
        return results;
    }
    
}