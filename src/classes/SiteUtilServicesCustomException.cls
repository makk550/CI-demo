public class SiteUtilServicesCustomException extends Exception {
    public String message{get;set;}
        
    public String SiteUtilServicesCustomException(String message){
        return this.message=message;
    }
}