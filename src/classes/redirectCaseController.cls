public class redirectCaseController{

    public case caseRec;
    public boolean showDetail{get;set;}
    public redirectCaseController(ApexPages.StandardController controller) {
        List<String> fields = new List<String>{'TPC_Team__c','OwnerId'};
        if(!Test.isRunningTest()){
            controller.addFields(fields);
        }
        
        caseRec = (Case)controller.getRecord();
    }

    public pageReference redirectCase(){
        String param = ApexPages.currentPage().getParameters().get('nooverride');
      
        User communityUser = [select id,contact.TPC_Team__c,Profile.UserLicense.Name  from user where id=: UserInfo.getUserId()];
        if (Label.TPC_Profile_Id != NULL && communityUser.Profile.UserLicense.Name  == String.valueOf(Label.TPC_Profile_License_Name)) {
        //if (Label.TPC_Profile_Id != NULL && UserInfo.getProfileId() == String.valueOf(Label.TPC_Profile_Id)) {
            
            if(caseRec.TPC_Team__c == communityUser.contact.TPC_Team__c || caseRec.OwnerId == communityUser.Id ){
                showDetail = true;
                return NULL; 
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Sorry You dont have permission to see this.');
                ApexPages.addMessage(myMsg);
                showDetail = false;
                return null;
            }
        }
        else{
            pageReference ref = new PageReference('/'+caseRec.Id+'?nooverride=1');
            ref.setRedirect(false);
            return ref;
        }
    }
}