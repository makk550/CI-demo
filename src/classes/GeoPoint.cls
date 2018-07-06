global class GeoPoint {
	
	global static final Double PI = 3.1415926535897932384626433832795;

	global Double latitude {get; private set;}
	global Double longitude {get; private set;}
	
	global GeoPoint (Double latitude, Double longitude){
		if(latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180){
			throw new IllegalArgumentException('Invalid latitude (' + latitude + ') or longitude (' + longitude + ')');
		}
		this.latitude = latitude;
		this.longitude = longitude;
	}

	global Double lat() { return this.latitude; }
	global Double lng() { return this.longitude; }
	
	global Double latRadians() { return this.latitude * (PI/180); }
	global Double lngRadians() { return this.longitude * (PI/180); }
	
	global Boolean equals(GeoPoint point){
		if(point == null){ 
			return false; 
		}
		return this.latitude == point.latitude && this.longitude == point.longitude;   
	}
	
	global String toStr(){ return '<#GeoPoint(latitude=' + latitude + ',longitude=' + longitude + ')>'; }
}