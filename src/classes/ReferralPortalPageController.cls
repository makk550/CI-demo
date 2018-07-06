public class ReferralPortalPageController {
    public List<Lead> referralLeadList{get;set;}
    public ReferralPortalPageController(){
       
    }
    public pageReference redirectpage(){
        pageReference pageref = new pageReference('/apex/ReferralPortalLeadPage');
        pageRef.setRedirect(true);
        return pageRef;
        
    }

}