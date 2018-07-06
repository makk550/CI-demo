public class KBAutheringCustomException extends Exception {
    public String message{get;set;}
        
    public String KBAutheringCustomException(String message){
        return this.message=message;
    }
}