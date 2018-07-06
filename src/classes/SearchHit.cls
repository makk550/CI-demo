global class SearchHit {

    private Partner_Location__c location;
    
    global static final Set<Object> minimumFields = new Set<Object>{
        'name',
        'Account__c',
        'id',
        'website__c',
        'is_primary__c',
        'point_of_contact_phone__c',
        'phone_formula__c',
        'point_of_contact_name__c',
        'point_of_contact_email__c',
        'description__c',
        'street__c',
        'city__c',
        'state_province__c',
        'postal_code__c',
        'country__c',
        'longitude__c',
        'latitude__c',
        'account__r.name',
        'account__r.id',
        'account__r.logo__c',
        'account__r.partner_finder_recommended_flag__c'
    };

    global Integer resultSequenceNumber {get;set;}
    global String locationName {get{ return location.name;}}
    global ID locationId {get{ return location.id;}}
    global String partnerName {get{ return location.Account__r.name;}}
    global ID partnerAccountId {get{ return location.Account__r.id;}}
    global String website {get{ return UrlUtils.ensureUrlBeginsWithHttp(location.Website__c);}}
    global Boolean isPrimary {get{ return location.Is_Primary__c;}}
    
    //comment below code for changing data type of phone.  sandeep dstsa01
    
    global String pointOfContactPhone {get{ return location.Point_of_Contact_Phone__c;}}
    //PRM5.5 -- REQ-PRM16-PL-016 -- Display Acc's Phone Num if Location's phone number is unavailable.
    global String Phone_Formula{get{ return location.Phone_Formula__c;}}
    global String pointOfContactName {get{ return location.Point_of_Contact_Name__c;}}
    global String pointOfContactEmail {get{ return location.Point_of_Contact_Email__c;}}
    global String description {get{ return location.Description__c;}}
    global String street {get{ return location.Street__c;}}
    global String city {get{ return location.City__c;}}
    global String stateProvince {get{ return location.State_Province__c;}}
    global String postalCode {get{ return location.Postal_Code__c;}}
    global String country {get{ return location.Country__c;}}
    global Double longitude {get{ return location.Longitude__c;}}
    global Double latitude {get{ return location.Latitude__c;}}
    global GeoPoint point {get;private set;}
    global Boolean containsDistance {get{return distanceInKilometers != null;}}
    global Double distanceInKilometers {get;private set;}
    global Double distanceInMiles {get{ return ConversionUtils.convert(distanceInKilometers,UnitOfLength.KILOMETERS,UnitOfLength.MILES);}}
    
    //TBD    
    global Boolean isRecommended {get{return location.account__r.Partner_Finder_Recommended_Flag__c;}}
    global String logoId {get;set;}
    global String logoRecordId {get{return location.Account__r.logo__c;}}
    global Map<String,Object> userRequestedFieldValues {get;set;}
    
    global SearchHit(Partner_Location__c location){
        if(location == null){
            throw new IllegalArgumentException('Invalid argument: location is null');
        }
        this.location = location;
        this.point = new GeoPoint(latitude, longitude);
    }
    
    global void setDistanceToPoint(GeoPoint point){
        distanceInKilometers = GeoMath.distanceInKilometers(this.point,point);
    }

    global static List<SearchHit> sortByDistance(List<SearchHit> hits){
        return (List<SearchHit>) ArrayUtils.qsort(hits,new SearchHitSortByDistComparator());        
    }    
    
    global class SearchHitSortByDistComparator implements ObjectComparator{

        global Integer compare(Object object1, Object object2){
            Double r1 = ((SearchHit)object1).distanceInKilometers;
            Double r2 = ((SearchHit)object2).distanceInKilometers;
            if(r1 < r2){
                return -1;
            } else if(r1 == r2){
                return 0;
            }else{
                return 1;
            }
        }
    
    }
    

    
    
    
}