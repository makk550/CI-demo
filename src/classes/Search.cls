global class Search {
    
    private static final Integer   DEFAULT_MAX_RECURSION    = 10;

    private Set<Object>             fields                  {get;set;}

    global Condition                attributeSearchCriteria {get;set;}
    global GeoSearchCriteria        geoSearchCriteria       {get;set;}
    public Integer                  maxRecursion            {get;set;}
    public Integer                  queryRowLimit           {get;set;}    
    public String                   Order_by           {get;set;}

    global Search(){
        this(null,null);
    }
    
    global Search(  Condition attributeSearchCriteria){
        this(attributeSearchCriteria,null);
    }

    global Search(  GeoSearchCriteria geoSearchCriteria){
        this(null,geoSearchCriteria);
    }    

    global Search(  Condition attributeSearchCriteria, 
                    GeoSearchCriteria geoSearchCriteria){
        this.fields = new Set<Object>();
        this.attributeSearchCriteria = attributeSearchCriteria;        
        this.geoSearchCriteria = geoSearchCriteria;
        this.maxRecursion = DEFAULT_MAX_RECURSION;
        this.queryRowLimit = SearchUtils.DEFAULT_QUERY_ROW_LIMIT;
    }
    
    global Search addFields(Set<Object> fields){
        if(fields != null && fields.size() > 0){
            this.fields.addAll(fields);
        }
        return this;
    }
       
    global List<SearchHit> execute(){
        
    
        return addLogoIDs(doSearch(
           null,
           attributeSearchCriteria,
           geoSearchCriteria,
           geoSearchCriteria,
           1,
           maxRecursion,
           queryRowLimit,
           fields));        
    }
    
    
    private static List<SearchHit> doSearch(    List<SearchHit> previous,
                                                Condition attributeCriteria,
                                                GeoSearchCriteria originalGeoCriteria,
                                                GeoSearchCriteria currentGeoCriteria,
                                                Integer recursionDepth,
                                                final Integer maxRecursion,
                                                final Integer queryRowLimit,
                                                Set<Object> userRequestedFields){
        if(recursionDepth >= maxRecursion){
            return previous;
        }
        
        //======================================================
        //EXECUTE QUERY
        //======================================================
        final Set<Object> allFields = new Set<Object>();
        allFields.addAll(SearchHit.minimumFields);
        allFields.addAll(userRequestedFields);
        final List<Partner_Location__c> results = SearchUtils.doQuery(  
            allFields, //fields
            currentGeoCriteria == null ? null : currentGeoCriteria.bounds, //bounds
            attributeCriteria, //extraCriteria
            currentGeoCriteria == null, //primaryOnly
            //new OrderBy('account__r.Partner_Finder_Recommended_Flag__c').descending(), //orderBy
            new OrderBy(Configuration.sortColumn).ascending(), //orderBy            
            queryRowLimit);
            
        //======================================================
        //PROCESS RESULTS
        //======================================================
        List<SearchHit> current = new List<SearchHit>();
        if(results != null && results.size() > 0){
            SearchHit hit = null;
            for(Partner_Location__c result : results){
               hit = new SearchHit(result);
                if(currentGeoCriteria != null){
                    hit.setDistanceToPoint(currentGeoCriteria.point);
                }
                if(userRequestedFields != null && userRequestedFields.size() > 0){
                    hit.userRequestedFieldValues = new Map<String,Object>();
                    String fieldName = null;
                    for(Object userRequestedField : userRequestedFields){
                        if(userRequestedField instanceof String){
                            fieldName = StringUtils.trim((String)userRequestedField); 
                            if(StringUtils.contains(fieldName, '.')){
                                hit.userRequestedFieldValues.put(
                                    fieldName,
                                    result.getSObject(StringUtils.substringBefore(fieldName,'.'))
                                    .get(StringUtils.substringAfter(fieldName,'.'))
                                );
                            } else {
                                hit.userRequestedFieldValues.put(fieldName,result.get(fieldName));
                            }
                        }
                    }
                }
                current.add(hit);
            }
        }
        if(currentGeoCriteria != null){
            current = SearchHit.sortByDistance(SearchUtils.filterResultsOutsideDistance(current,currentGeoCriteria.distanceInKilometers));
        }

        //======================================================
        //DETERMINE IF RECURSIVE CALL SHOULD BE EXECUTED
        //  A recursive call needs to be executed if the current query is a geographic
        //  based query and returned max results.  This is due to limitations with
        //  SOQL result set size and inability of SOQL to perform SOQL side functions.  In
        //  this case, a function is needed in SOQL to determine distance from point so
        //  that results can be sorted on distance.  As a workaround, a max of 5 recursive
        //  calls will be made which vary the search distance.
        //======================================================
  
  
  
       if(currentGeoCriteria == null || (results.size() < queryRowLimit && recursionDepth <= 1)){
            recursionDepth = maxRecursion;
        } else {
            recursionDepth++;
            final Double delta = SearchUtils.distanceChange(originalGeoCriteria.distanceInKilometers, recursionDepth);
            currentGeoCriteria = currentGeoCriteria.cloneByDistanceIncrement(
               results.size() >= queryRowLimit ? -delta : delta, UnitOfLength.KILOMETERS );
            if(previous != null){
                //cut previous & current in half and merge
                List<Object> currentAsObj = ArrayUtils.merg(
                    ArrayUtils.subset(previous,ArrayUtils.MAX_NUMBER_OF_ELEMENTS_IN_LIST/2),
                    ArrayUtils.subset(current,ArrayUtils.MAX_NUMBER_OF_ELEMENTS_IN_LIST/2)
                );
                //remove dups
                final Map<Id,SearchHit> aMap = new Map<Id,SearchHit>();
                SearchHit hit = null;
                for(Object hitAsObj : currentAsObj){
                    hit = (SearchHit) hitAsObj;
                    aMap.put(hit.locationId,hit);
                } 
                //sort results
                current = SearchHit.sortByDistance(aMap.values());
            }
        } 
        for(Integer i = 0; i < (current == null ? 0 : current.size()); i++){
            current.get(i).resultSequenceNumber = i+1;
        }

        return doSearch(
            current,
            attributeCriteria,
            originalGeoCriteria,
            currentGeoCriteria,
            recursionDepth,
            maxRecursion,
            queryRowLimit,
            userRequestedFields
        ); 
    }
    
    private List<SearchHit> addLogoIDs(final List<SearchHit> hits){
        if(hits != null && hits.size() > 0){
            Set<String> distinctLogoRecordIds = new Set<String>(); 
            Map<String,List<SearchHit>> logoRecordId2Hits = new Map<String,List<SearchHit>>();
            for(SearchHit hit : hits){
                if(hit.logoRecordID != null){
                    if(!logoRecordId2Hits.containsKey(hit.logoRecordID)){
                        logoRecordId2Hits.put(hit.logoRecordID, new List<SearchHit>());
                    }
                    logoRecordId2Hits.get(hit.logoRecordID).add(hit);
                    distinctLogoRecordIds.add(hit.logoRecordId);
                }
            }
            List<SearchHit> resultsForOneLogo = null;
            
           
            List<Attachment> logos = [select id,parentid from Attachment where parentid in :distinctLogoRecordIds]; 
            if(logos != null && logos.size() > 0){
                for(Attachment logo : logos){
                    resultsForOneLogo = logoRecordId2Hits.get(logo.parentid);
                    if(resultsForOneLogo != null && resultsForOneLogo.size() > 0){
                        for(SearchHit aResult : resultsForOneLogo){
                            aResult.logoId = logo.id;
                        }
                    }
                }
            }
            
            
            /*
            for(List<Attachment> logos : [select id,parentid from Attachment where parentid in :distinctLogoRecordIds]){                                
                if(logos != null && logos.size() > 0){
                  for(Attachment logo : logos){
                    resultsForOneLogo = logoRecordId2Hits.get(logo.parentid);
                    if(resultsForOneLogo != null && resultsForOneLogo.size() > 0){
                        for(SearchHit aResult : resultsForOneLogo){
                            aResult.logoId = logo.id;
                        }
                    }
                 }
              }             
            }
            
            */
            
            
        }
        return hits;
    } 
     
          
           
}