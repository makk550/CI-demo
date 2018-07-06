public class SearchUtils {

    //public static final Integer DEFAULT_QUERY_ROW_LIMIT = 1000;

   //Changes done by Sandeep Reddy D.S
    public static final Integer DEFAULT_QUERY_ROW_LIMIT = 100;
    
    public static List<Partner_Location__c> doQuery(    Set<Object> fields, 
                                                        GeoBounds bounds,
                                                        final Condition extraCondition,
                                                        Boolean primaryOnly,
                                                        final OrderBy orderBy,
                                                        Integer queryRowLimit){
        //defaults
        bounds = (bounds == null ? GeoBounds.MAX : bounds);
        primaryOnly = (primaryOnly == null ? false : primaryOnly);
        queryRowLimit = (queryRowLimit == null ? DEFAULT_QUERY_ROW_LIMIT : queryRowLimit);
                                                        
        final NestableCondition condition = 
            new AndCondition()
            
            //LATITUDE & LONGITUDE
            .add(new FieldCondition('Latitude__c' ).lessThanOrEqualTo   (bounds.northeast.latitude)) 
            .add(new FieldCondition('Longitude__c').lessThanOrEqualTo   (bounds.northeast.longitude)) 
            .add(new FieldCondition('Latitude__c' ).greaterThanOrEqualTo(bounds.southwest.latitude)) 
            .add(new FieldCondition('Longitude__c').greaterThanOrEqualTo(bounds.southwest.longitude)) 

            //ACCOUNT STATE FLAGS
            .add(new FieldCondition('Account__r.IsPartner'                              ,true)) 
            .add(new FieldCondition('Account__r.Approved_for_Partner_Finder__c'         ,true)) 
            .add(new FieldCondition('Account__r.Profile_Published_to_Partner_Finder__c' ,'Yes'));
    /* TADKR01 - PRM5.5 - REQ-PRM16-PL-016 - All non-primary locations also should be displayed on partner search page.
        if(primaryOnly){
            condition
            .add(new FieldCondition('Is_Primary__c',true));
        }
    */    
        if(Configuration.getInstance().isTermsConditionsFeatureEnabled){
            condition
            .add(new FieldCondition('Account__r.Partner_User_Agreed_to_PF_Terms_Cond__c',Operator.NOT_EQUALS,'')) 
            .add(new FieldCondition('Account__r.Partner_Date_Agreed_to_PF_Terms_Cond__c',Operator.NOT_EQUALS,null)); 
        }
        if(extraCondition != null){
            condition
            .add(extraCondition);
        }
        return Database.query(
            new SoqlBuilder()
                .selectx(fields)
                .fromx('Partner_Location__c')
                .wherex(condition)
                .orderByx(orderBy)
                .limitx(queryRowLimit)
                .toSoql(new SoqlOptions().wildcardStringsInLikeOperators()));
    }

    /*    
    public static Set<String> lowerCase(Set<String> aSet){
        final Set<String> lowered = new Set<String>();
        if(aSet != null && aSet.size() > 0){
            for(String str : aSet){
                lowered.add(StringUtils.lowerCase(str));
            }
        }
        return lowered;
    }
    */
    
    /**
     * Removes search hits which exceed certain distance.  Background:  queries 
     * against latitude and longitude essentially query a box instead of a circle.
     * This means its likely some geo search results will contain results which
     * fit inside the box but are outside the circle.  For example, let's say
     * you have following:
     * Search point:  lat = 0, lng = 0
     * Location:      lat = 1, lng = 1
     * The two points are 157km apart.  But if you execute a search for all locations
     * which are 120km apart, the soql query will contain following lat/lng bounds:
     * lat > 1.08 and lat < 1.08 and lng > 1.08 and lng < 1.08
     * That will of course, pick up the location which is 157km away.  The purpose of
     * this method is to remove such cases.
     * @param hits                          the list of hits with distance populate
     * @param limitDistanceInKilometers     the distance to not be exceeeded
     */
    public static List<SearchHit> filterResultsOutsideDistance( List<SearchHit> hits, 
                                                                Double limitDistanceInKilometers){
        if(hits != null && hits.size() > 0){
            List<Integer> indicesToRemove = new List<Integer>();
            for(Integer i = 0; i < hits.size(); i++){
                if(hits.get(i).distanceInKilometers > limitDistanceInKilometers){
                    indicesToRemove.add(i);
                }
            }
            for(Integer i = 0; i < indicesToRemove.size(); i++){
                hits.remove(indicesToRemove.get(i)-i);
            }
        }
        return hits;
    }

    /**
     * This method is used to determine distance change for recursive geo search.
     * <pre>
     * distanceChange(100,1) = 100 
     * distanceChange(100,2) = 50
     * distanceChange(100,3) = 25
     * distanceChange(100,4) = 12.5
     * </pre>
     * @param d                 original distance
     * @param recursionDepth    
     */
    public static Double distanceChange(Double d, Integer recursionDepth){
        return d * 1 / Math.pow(2,(recursionDepth-1));
    }
}