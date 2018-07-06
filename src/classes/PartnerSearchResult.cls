global class PartnerSearchResult{
 
    public ID id{get;set;}
    public ID companyId{get;set;}
    public ID locationId{get;set;}
    public ID logoId{get; set;}
    public ID logoRecordId{get; set;}
    public Integer recordNumber{get; set;}
    public String companyName{get;set;}
    public String locationName{get;set;}
    public String street{get;set;}
    public String city{get;set;}
    public String state{get;set;}
    public String postalCode{get;set;}
    public String country{get;set;}
    public Double latitude{get;set;}    
    public Double longitude{get;set;}   
    public Double distance{get;set;}
    public String website{get; set;}
    public String phone{get; set;}
    public String pointOfContactName{get;set;}
    public Boolean isRecommended{get;set;}
    public Integer locationCount{get; set;}
    public Double getDistanceRounded(){ return Decimal.valueOf(distance).setScale(2); }
    public List<RenderField> customFields{get;set;}

    public PartnerSearchResult(Partner_Location__c location){
        this.id = location.id;
        this.companyName = location.account__r.name;
        this.companyId = location.account__r.id;
        this.logoRecordId = location.account__r.logo__c;
        this.locationName = location.name;
        this.locationId = location.id;
        this.street = location.Street__c;
        this.city = location.City__c;
        this.state = location.State_Province__c;
        this.postalCode = location.Postal_Code__c;
        this.country = location.Country__c;
        this.latitude = location.Latitude__c;
        this.longitude = location.Longitude__c;
        this.website= UrlUtils.ensureUrlBeginsWithHttp(location.Website__c);
        this.pointOfContactName=location.Point_of_Contact_Name__c;
        
         //comment below code for changing data type of phone.  sandeep dstsa01      
          this.phone=location.Point_of_Contact_Phone__c;
        
        this.locationCount=1;
        this.distance = 0;
        this.isRecommended = location.account__r.Partner_Finder_Recommended_Flag__c; 
        this.customFields=new List<RenderField>();
    }
    
    /*public PartnerSearchResult(Account acc){
        this.id=acc.Id;
        this.companyName=acc.Name;
        this.companyId = acc.Id;
        this.website=acc.Website;
        this.logoRecordId = acc.logo__c;
        this.isRecommended = acc.Partner_Finder_Recommended_Flag__c; 
        
        if(acc.Partner_Locations__r!=null && acc.Partner_Locations__r.size()>0){
            
            this.locationName = acc.Partner_Locations__r[0].Name;
            this.locationId = acc.Partner_Locations__r[0].Id;
            this.street = acc.Partner_Locations__r[0].Street__c;
            this.city = acc.Partner_Locations__r[0].City__c;
            this.state = acc.Partner_Locations__r[0].State_Province__c;
            this.postalCode = acc.Partner_Locations__r[0].Postal_Code__c;
            this.country = acc.Partner_Locations__r[0].Country__c;
            this.latitude = acc.Partner_Locations__r[0].Latitude__c;
            this.longitude = acc.Partner_Locations__r[0].Longitude__c;
            //this.website=acc.Partner_Locations__r[0].Website__c;
            
        }
        this.distance=0;
        this.customFields=new List<RenderField>();
    }*/

}