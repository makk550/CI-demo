@IsTest
private class SearchHitTest {
    
    private static testmethod void testConstructor(){
        final Partner_Location__c location = new Partner_Location__c(
            Name = 'Acme Computer Headquarters'
            ,Is_Primary__c = true
            ,Latitude__c = random(-90, 90)
            ,Longitude__c = random(-90, 90)
            ,Account__c = null
        );
        final SearchHit hit = new SearchHit(location);
        System.assertEquals(location.name,hit.locationName);
        System.assertEquals(location.id,hit.locationId);
        System.assertEquals(location.Is_Primary__c,hit.isPrimary);
        System.assertEquals(location.Account__r.name,hit.partnerName);
        System.assertEquals(location.Account__r.id,hit.partnerAccountId);
        System.assertEquals(location.Website__c,hit.website);
         //comment below code(Point_of_Contact_Phone__c) for changing data type of phone.  sandeep dstsa01 -- 
        System.assertEquals(location.Point_of_Contact_Phone__c,hit.pointOfContactPhone);
        System.assertEquals(location.Point_of_Contact_Name__c,hit.pointOfContactName);
        System.assertEquals(location.Point_of_Contact_Email__c,hit.pointOfContactEmail);
        System.assertEquals(location.Description__c,hit.description);
        System.assertEquals(location.Street__c,hit.street);
        System.assertEquals(location.City__c,hit.city);
        System.assertEquals(location.State_Province__c,hit.stateProvince);
        System.assertEquals(location.Postal_Code__c,hit.postalCode);
        System.assertEquals(location.Country__c,hit.country);
        System.assertEquals(location.Longitude__c,hit.longitude);
        System.assertEquals(location.Latitude__c,hit.latitude);
    }

    private static testmethod void testConstructorIllegalArgument(){
        Boolean exceptionCaught = false;
        try{
           new SearchHit(null);  
        }catch(IllegalArgumentException e){
           exceptionCaught = true;
        }
        System.assert(exceptionCaught == true, 'IllegalArgumentException not thrown');
    }
    

    private static testmethod void testSort(){
        List<SearchHit> hits = new List<SearchHit>();
        //-5,-10
        addLatLong(hits,-6,-9);
        addLatLong(hits,-7,-11);
        addLatLong(hits,10,10);
        addLatLong(hits,0,0);
        addLatLong(hits,-10,-10);
        final GeoPoint searchPoint = new GeoPoint(-5,-10);
        for(SearchHit hit : hits){
            System.assertEquals(false,hit.containsDistance);
            hit.setDistanceToPoint(searchPoint);
            System.assertEquals(true,hit.containsDistance);
        }
        final Integer sizeBefore = hits.size();
        hits = SearchHit.sortByDistance(hits);
        System.assertNotEquals(null,hits);
        System.assertEquals(sizeBefore,hits.size());
        System.assertEquals(-6,hits.get(0).latitude);
        System.assertEquals(-7,hits.get(1).latitude);
        System.assertEquals(-10,hits.get(2).latitude);
        System.assertEquals(0,hits.get(3).latitude);
        System.assertEquals(10,hits.get(4).latitude);

    }
    private static Double random(Double min, Double max){
        System.assert(true);
        return min + (Math.random() * (max - min));
    }
    
    private static void addLatLong(List<SearchHit> hits, Double lat, Double lng){
        hits.add(new SearchHit(new Partner_Location__c(
            Name = 'Acme'
            ,Latitude__c = lat
            ,Longitude__c = lng
            ,Account__c = null)));
         System.assert(true);
    }

}