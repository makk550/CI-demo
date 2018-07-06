@IsTest
private class SearchHitWrapperTest {

    private static testmethod void testToJson(){
        final Partner_Location__c location = new Partner_Location__c(
            Name = 'acme'
            ,Is_Primary__c = true
            ,Latitude__c = 1.1
            ,Longitude__c = 1.1
            ,Account__c = null
            ,Street__c = '123 Broadway'
            ,State_Province__c = 'NY'
            ,Postal_Code__c = '10001'
            ,Country__c = 'UNITED STATES'
            ,City__c = 'New York'
        );
        Configuration config = Configuration.getInstance();
        final List<SearchHitWrapper> hits = new List<SearchHitWrapper>{
           new SearchHitWrapper(new SearchHit(location),config),
           new SearchHitWrapper(new SearchHit(location),config)
        };
        
       /* System.assertEquals(
           '{ "locations" : [' 
               + '{"name":"acme","id":null,"state":"NY","latitude":1.1,"street":"123 Broadway","recordNumber":null' 
               + ',"postalCode":"10001","longitude":1.1,"country":"UNITED STATES","city":"New York"}' 
               + ',{"name":"acme","id":null,"state":"NY","latitude":1.1,"street":"123 Broadway","recordNumber":null' 
               + ',"postalCode":"10001","longitude":1.1,"country":"UNITED STATES","city":"New York"}' 
               + ']}'
           ,SearchHitWrapper.toJson(hits));*/
    }    

    private static testmethod void testToJsonEmptyList(){
        System.assertEquals('{ "locations" : []}',SearchHitWrapper.toJson(null));
    }    

    private static testmethod void testFields(){
        final Partner_Location__c location = new Partner_Location__c(
            Name = 'acme'
            ,Is_Primary__c = true
            ,Latitude__c = 1.1
            ,Longitude__c = 1.1
            ,Account__c = null
            ,Street__c = '123 Broadway'
            ,State_Province__c = 'NY'
            ,Postal_Code__c = '10001'
            ,Country__c = 'UNITED STATES'
            ,City__c = 'New York'
        );
        final SearchHitWrapper wrapper = new SearchHitWrapper(new SearchHit(location),Configuration.getInstance());
        System.debug(wrapper.point); 
        System.debug(wrapper.containsDistance);
        System.debug(wrapper.distanceInKilometers); 
        System.debug(wrapper.distanceInMiles);
        System.debug(wrapper.isRecommended); 
        System.debug(wrapper.logoId);
        Configuration config = Configuration.getInstance();
        final List<SearchHitWrapper> hits = new List<SearchHitWrapper>{
           new SearchHitWrapper(new SearchHit(location),config)};
      /*  System.assertEquals(
           '{ "locations" : [' 
               + '{"name":"acme","id":null,"state":"NY","latitude":1.1,"street":"123 Broadway","recordNumber":null' 
               + ',"postalCode":"10001","longitude":1.1,"country":"UNITED STATES","city":"New York"}' 
               + ']}'
           ,SearchHitWrapper.toJson(hits));*/
    }

    private static testmethod void testNullWrappedConstructorArgument(){
        Boolean exceptionCaught = false;
        try{
            new SearchHitWrapper(null,null);
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
        System.assert(exceptionCaught == true,'IllegalArgumentException not thrown');
    }

    private static testmethod void testNullConfigConstructorArgument(){
        Boolean exceptionCaught = false;
        try{
            new SearchHitWrapper(new SearchHit(new Partner_Location__c()),null);
        }catch(IllegalArgumentException e){
            exceptionCaught = true;
        }
     //   System.assert(exceptionCaught == true,'IllegalArgumentException not thrown');
    }




}