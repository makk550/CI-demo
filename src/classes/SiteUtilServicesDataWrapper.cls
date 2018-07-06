public class SiteUtilServicesDataWrapper{
    public String status{get;set;}
    public List<Data> data {get;set;}
    public Error error;
      
    public class Error {
        public String code;
        public String description;
        public String reason;
        public String error_code;  
    }    
    
    public class Data implements Comparable {
  
        //common for both services    
        public String topSiteID {get;set;}       
        public String cAProductName {get;set;}
        
        // Fields for Entitlement Service 
        public String topsPRNum {get;set;}
        public String topsProdDesc {get;set;}      
                     
        //Fields for Offering Service
        public String role {get;set;}
        public String sapContractId {get;set;}
        public String contractLineNum {get;set;}
        public String clarityKey {get;set;}
        public String offeringCode {get;set;}
        public String offeringStartDT {get;set;}
        public String offeringEndDT {get;set;}
        public String assignedEngineer{get;set;}       
        
        public Integer compareTo(Object ObjToCompare){
            return cAProductName.CompareTo(((Data)ObjToCompare).cAProductName);
        }                     
    }
}