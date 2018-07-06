@IsTest
private class SearchUtilsTest {

    private static testmethod void testDistanceChange(){
        System.assertEquals(100,SearchUtils.distanceChange(100,1)); 
        System.assertEquals(50,SearchUtils.distanceChange(100,2)); 
        System.assertEquals(25,SearchUtils.distanceChange(100,3)); 
        System.assertEquals(12.5,SearchUtils.distanceChange(100,4));  
    }

    private static testmethod void testFilterResultsOutsideDistance(){
        List<SearchHit> hits = new List<SearchHit>();
        for(Integer lat = -50; lat < -45; lat++){
            for(Integer lng = -160; lng < -155; lng++){
                hits.add(new SearchHit(new Partner_Location__c(
                    Name = 'test (' + lat + ',' + lng + ')',Latitude__c = lat,Longitude__c = lng)));
            }           
        }
        System.assertEquals(25,hits.size());
        final GeoPoint referencePoint = new GeoPoint(-48,-158);
        for(SearchHit hit : hits){
            System.assertEquals(false,hit.containsDistance);
            hit.setDistanceToPoint(referencePoint);
            System.assertEquals(true,hit.containsDistance);
        }
        hits = SearchUtils.filterResultsOutsideDistance(hits,200);
        for(SearchHit hit : hits){
            System.assert(hit.distanceInKilometers <= 200);
        }        
        System.assertEquals(15,hits.size());
    }
    

}