public class PIRLinkController {
    public String linkP{get;set;}
    public Id partnerInId{get;set;}
    public PIRLinkController(){
        linkP =URL.getSalesforceBaseUrl().toExternalForm();
    }

}