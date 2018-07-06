public class Location {

    public ID id {get; set;}
    public String name {get;set;}
    public Double latitude {get;set;}
    public Double longitude {get;set;}
    public String street {get;set;}
    public String city {get;set;}
    public String state {get;set;}
    public String postalCode {get;set;}
    public String country {get;set;}
    public String pointOfContactName{get; set;}
    public String phone{get;set;}
    public Integer serialNumber {get;set;}
    public List<FormField> detailFields{get; set;}

    public static Location build(Partner_Location__c partnerLocation){
        Location location   = new Location();
        location.Id         = partnerLocation.Id; 
        location.name       = partnerLocation.Name;
        location.latitude   = partnerLocation.Latitude__c;
        location.longitude  = partnerLocation.Longitude__c;
        location.street     = partnerLocation.Street__c;
        location.city       = partnerLocation.City__c;
        location.state      = partnerLocation.State_Province__c;
        location.postalCode = partnerLocation.Postal_Code__c;
        location.country    = partnerLocation.Country__c;
        location.pointOfContactName=partnerLocation.Point_of_Contact_Name__c;
         //comment below code(Point_of_Contact_Phone__c) for changing data type of phone.  sandeep dstsa01  
        location.phone=partnerLocation.Point_of_Contact_Phone__c;
        return location;
    }   
    
    public String toJSON(){
        return 
            '{'
            + '"id":' + JSONUtils.encode(this.id) 
            + ',"name":' + JSONUtils.encode(this.name) 
            + ',"latitude":' + this.latitude 
            + ',"longitude":' + this.longitude 
            + ',"street":' + JSONUtils.encode(this.street) 
            + ',"city":' + JSONUtils.encode(this.city) 
            + ',"state":' + JSONUtils.encode(this.state) 
            + ',"postalCode":' + JSONUtils.encode(this.postalCode) 
            + ',"country":' + JSONUtils.encode(this.country) 
            + ',"serialNumber":' + this.serialNumber 
            + '}';
    }


}