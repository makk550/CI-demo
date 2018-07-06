/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        System.debug('#####'+UserInfo.getProfileId());
        if (UserInfo.getProfileId() == String.valueOf(Label.TPC_Profile_Id)) {
            
            return new PageReference('/apex/TPC_ShowAllCases');
        } else {
            // Sachin Kadian
            //Redirecting it to Contact as Network.communitiesLanding() was also doing the same means it was the default landing tab i.e contact
            return new PageReference('/003');
            //return Network.communitiesLanding();
        }
        
    }
    
    public CommunitiesLandingController() {}
}