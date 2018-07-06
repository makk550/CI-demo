public class OppNewButtonController{

   @TestVisible Set<String> OppAdminProfiles = new Set<String>();
    
   @TestVisible Set<String> OppPartnerProfiles = new Set<String>();
    
   @TestVisible private ApexPages.Standardcontroller standardController;
        

    public OppNewButtonController(ApexPages.StandardController cntrl) {
    standardController = cntrl; 
    OppAdminProfiles.addAll(Label.OppNewButtonAdminProfiles.split(','));
    OppPartnerProfiles.addall(Label.OppNewButtonPartnerProfiles.split(','));
    }
    
    
    public PageReference ProfileSelection(){
        

        if(OppAdminProfiles.contains(UserInfo.getProfileId()))
            return new PageReference('/apex/OpportunityCreateOverride');
        else if(OppPartnerProfiles.contains(UserInfo.getProfileId()))
            return new PageReference('/apex/DealRegistrationEdit_New? RecordType=01230000000cohD&save_new=1&sfdc.override=1&ent=Opportunity');
        else{
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please create an opportunity from a Contact.'));
         return null;   
        }
        
    }
    
}