@IsTest
private class TestGeoBounds {
	
	private static testmethod void testListConstruct(){
		GeoBounds bounds = new GeoBounds(new GeoPoint[]{ 
				new GeoPoint(20,40)
			,	new GeoPoint(10,50)
			,	new GeoPoint(-10,100)
			,	new GeoPoint(5,-15)
		});
		System.assert((new GeoPoint(20,100)).equals(bounds.northeast));
		System.assert((new GeoPoint(-10,-15)).equals(bounds.southwest));
		System.assertEquals('<#GeoBounds(northeast=<#GeoPoint(latitude=20.0,longitude=100.0)>,' 
			+ 'southwest=<#GeoPoint(latitude=-10.0,longitude=-15.0)>)>', bounds.toStr());
	}

	private static testmethod void testGeoPointConstruct(){
		GeoBounds bounds = new GeoBounds(new GeoPoint(-20,100),new GeoPoint(30,-50));
		System.assert((new GeoPoint(30,100)).equals(bounds.northeast));
		System.assert((new GeoPoint(-20,-50)).equals(bounds.southwest));
	}

	private static testmethod void testContains(){
		GeoBounds bounds = new GeoBounds(new GeoPoint(-20,100),new GeoPoint(30,-50));
		System.assert(bounds.contains(new GeoPoint(0,0)));
		System.assert(false == bounds.contains(null));
		System.assert(false == bounds.contains(new GeoPoint(-30,-100)));
		System.assert(false == bounds.contains(new GeoPoint(50,120)));
	}
}