@IsTest
private class TestGeoMath {
	
	private static testmethod void testGetBounds(){
		assertValues(GeoMath.getBounds(new GeoPoint(0,0),20000),	new Long[]{90,180,-90,-180});
		assertValues(GeoMath.getBounds(new GeoPoint(0,0),10000),	new Long[]{90,90,-90,-90});
		assertValues(GeoMath.getBounds(new GeoPoint(90,90),10000),	new Long[]{90,180,0,-180});
		assertValues(GeoMath.getBounds(new GeoPoint(0,0),GeoMath.KM_IN_ONE_LATITUDE_DEGREE),		
			new Long[]{1,1,-1,-1});
		assertValues(GeoMath.getBounds(new GeoPoint(45,90),GeoMath.KM_IN_ONE_LATITUDE_DEGREE),		
			new Long[]{46,91,44,89});
		assertValues(GeoMath.getBounds(new GeoPoint(60,120),GeoMath.KM_IN_ONE_LATITUDE_DEGREE),		
			new Long[]{61,122,59,118});
		assertValues(GeoMath.getBounds(new GeoPoint(75,150),GeoMath.KM_IN_ONE_LATITUDE_DEGREE),		
			new Long[]{76,154,74,146});
		assertValues(GeoMath.getBounds(new GeoPoint(90,180),GeoMath.KM_IN_ONE_LATITUDE_DEGREE),		
			new Long[]{90,180,89,-180});
	}
	
	private static void assertValues(GeoBounds bounds, Long[] neLatNeLngSwLatSwLngRounded){
		System.debug('### assertValues(' + bounds.toStr() + ',' + ArrayUtils.toString(neLatNeLngSwLatSwLngRounded) + ')');
		System.assertNotEquals(null,bounds);
		System.assertNotEquals(null,neLatNeLngSwLatSwLngRounded);
		System.assertEquals(4,neLatNeLngSwLatSwLngRounded.size());
		System.assertEquals(neLatNeLngSwLatSwLngRounded[0],Math.round(bounds.northeast.lat()));
		System.assertEquals(neLatNeLngSwLatSwLngRounded[1],Math.round(bounds.northeast.lng()));
		System.assertEquals(neLatNeLngSwLatSwLngRounded[2],Math.round(bounds.southwest.lat()));
		System.assertEquals(neLatNeLngSwLatSwLngRounded[3],Math.round(bounds.southwest.lng()));
	}
	
	private static testmethod void testDistanceInKilometersException(){
		Boolean exceptionThrown = false;
		try{
			GeoMath.distanceInKilometers(null,null);
		}catch(IllegalArgumentException e){exceptionThrown = true;}
		System.assert(exceptionThrown);
	}

	private static testmethod void testDistanceInKilometers(){
		assertDist(-90,-90,-90,90,0);
		assertDist(-60,-90,-60,90,6672);
		assertDist(-30,-90,-30,90,13343);
		assertDist(0,-90,0,90,20015);
		assertDist(30,-90,30,90,13343);
		assertDist(60,-90,60,90,6672);
		assertDist(90,-90,90,90,0);
		
		assertDist(-90,-30,90,-30,20015);
		assertDist(-90,0,90,0,20015);
		assertDist(-90,30,90,30,20015);

		assertDist(0,0,60,60,8398);
		assertDist(-60,-60,60,60,16795);
		assertDist(-60,60,60,-60,16795);
	}
	
	private static void assertDist(Double lat1, Double lng1, Double lat2, Double lng2, Long expected){
		GeoPoint point1 = new GeoPoint(lat1,lng1);
		GeoPoint point2 = new GeoPoint(lat2,lng2);
		Double actual = Math.round(GeoMath.distanceInKilometers(point1,point2));
		System.assert(expected==actual,'GeoMath.distanceInKilometers(' + point1.toStr() + ',' + point2.toStr() 
			+ ') returned ' + actual + '; expected ' + expected);
		
	}
	
	
}