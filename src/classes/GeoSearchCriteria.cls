global class GeoSearchCriteria {

    global static final Double MAX_DISTANCE_IN_MILES = 200;
    global static final Double MAX_DISTANCE_IN_KILOMETERS = 
        ConversionUtils.convert(MAX_DISTANCE_IN_MILES,UnitOfLength.MILES,UnitOfLength.KILOMETERS);

    global GeoPoint point {get;private set;}
    global Double distance {get;private set;}
    global UnitOfLength unit {get;private set;}
    global GeoBounds bounds {get;private set;}
    
    global GeoSearchCriteria(GeoPoint point, Double distance, UnitOfLength unit){
        if(point == null){
            throw new IllegalArgumentException('Invalid argument: point is null');
        }
        this.point = point;
        if(unit == null){
            throw new IllegalArgumentException('Invalid argument: unitOfLength is null');
        }
        this.unit = unit;
        if(distance == null || distance <= 0){
            throw new IllegalArgumentException('Invalid argument: distance is null, zero, or less than zero');
        }
        this.distance = distance;
        if(this.distanceInKilometers > MAX_DISTANCE_IN_KILOMETERS){
            throw new IllegalArgumentException('Invalid argument: distance (' 
                + distanceInKilometers 
                + 'km) exceeds max distance (' 
                + MAX_DISTANCE_IN_KILOMETERS 
                + 'km)');
        }
        this.bounds = getBounds(this);
    }
    
    global Double distanceInKilometers {get{
    	return ConversionUtils.convert(distance,unit,UnitOfLength.KILOMETERS);
    }}
    
    global Double distanceInMiles {get{
        return ConversionUtils.convert(distance,unit,UnitOfLength.MILES);
    }}
    
    private static GeoBounds getBounds(GeoSearchCriteria criteria){
    	return GeoMath.getBounds(criteria.point, criteria.distanceInKilometers);
    }
    
    global String toStr(){ return '<#GeoSearchCriteria(point=' + point.toStr() + ',distanceInKilometers=' + distanceInKilometers + ')>'; }
    
    global GeoSearchCriteria cloneByDistanceIncrement(Double distanceIncrement, UnitOfLength unit){
        return new GeoSearchCriteria(this.point,this.distance+(ConversionUtils.convert(distanceIncrement,unit,this.unit)),this.unit);     
    }
    
}