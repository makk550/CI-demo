@IsTest
private class GeoSearchCriteriaTest {
    
    private static testmethod void testConversionsMilesToKilometers(){
        final GeoSearchCriteria criteria = new GeoSearchCriteria(new GeoPoint(0,0),100,UnitOfLength.MILES);
        criteria.toStr();
        assertEqualsRounded(100,criteria.distanceInMiles,5);  
        assertEqualsRounded(ConversionUtils.convert(100,UnitOfLength.MILES,UnitOfLength.KILOMETERS),criteria.distanceInKilometers,5);  
    }

    private static testmethod void testConversionsKilometersToMiles(){
        final GeoSearchCriteria criteria = new GeoSearchCriteria(new GeoPoint(0,0),100,UnitOfLength.KILOMETERS);
        assertEqualsRounded(100,criteria.distanceInKilometers,5);  
        assertEqualsRounded(ConversionUtils.convert(100,UnitOfLength.KILOMETERS,UnitOfLength.MILES),criteria.distanceInMiles,5);  
    }

    private static testmethod void testConstructorIllegalArgument_point(){
        Boolean exceptionCaught = false;
        try{
           new GeoSearchCriteria(null,1,UnitOfLength.MILES);  
        }catch(IllegalArgumentException e){
           exceptionCaught = true;
        }
        System.assert(exceptionCaught == true, 'IllegalArgumentException not thrown');
    }

    private static testmethod void testConstructorIllegalArgument_distance1(){
        Boolean exceptionCaught = false;
        try{
           new GeoSearchCriteria(new GeoPoint(0,0),null,UnitOfLength.MILES);  
        }catch(IllegalArgumentException e){
           exceptionCaught = true;
        }
        System.assert(exceptionCaught == true, 'IllegalArgumentException not thrown');
    }

    private static testmethod void testConstructorIllegalArgument_distance2(){
        Boolean exceptionCaught = false;
        try{
           new GeoSearchCriteria(new GeoPoint(0,0),0,UnitOfLength.MILES);  
        }catch(IllegalArgumentException e){
           exceptionCaught = true;
        }
        System.assert(exceptionCaught == true, 'IllegalArgumentException not thrown');
    }

    private static testmethod void testConstructorIllegalArgument_distance3(){
        Boolean exceptionCaught = false;
        try{
           new GeoSearchCriteria(new GeoPoint(0,0),GeoSearchCriteria.MAX_DISTANCE_IN_MILES+1,UnitOfLength.MILES);  
        }catch(IllegalArgumentException e){
           exceptionCaught = true;
        }
        System.assert(exceptionCaught == true, 'IllegalArgumentException not thrown');
    }

    private static testmethod void testConstructorIllegalArgument_unitOfLength(){
        Boolean exceptionCaught = false;
        try{
           new GeoSearchCriteria(new GeoPoint(0,0),1,null);  
        }catch(IllegalArgumentException e){
           exceptionCaught = true;
        }
        System.assert(exceptionCaught == true, 'IllegalArgumentException not thrown');
    }

    private static testmethod void testCloneByDistanceIncrement(){
        GeoSearchCriteria criteria = new GeoSearchCriteria(new GeoPoint(0,0),100,UnitOfLength.KILOMETERS);
        criteria = criteria.cloneByDistanceIncrement(-50,UnitOfLength.KILOMETERS);
        assertEqualsRounded(50,criteria.distance,5);  
        System.assertEquals(UnitOfLength.KILOMETERS,criteria.unit);  
    }
    
    private static void assertEqualsRounded(Double expected, Double actual, Integer decimalPlaces){
    	System.assertEquals(round(expected,decimalPlaces),round(actual,decimalPlaces));
    }
    
    private static Double round(Double d, Integer decimalPlaces){
    	if(decimalPlaces >= 0){
    		d = Decimal.valueOf(d).setScale(decimalPlaces).doubleValue();
    	}
    	System.assert(true);
    	return d;
    }
    


}