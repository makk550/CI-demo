public Class CA_AgreementAmends_Controller{

    String agrId;

    public CA_AgreementAmends_Controller() {
        agrId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public Pagereference unlockAgreementRecord() {
        try {
            if(agrId != null) {
                if(Approval.isLocked(agrId))
                    Approval.unlock(agrId); 
            }    
            
            return new PageReference('/apex/Apttus__AgreementAmend?id='+agrId);     
              
        } catch(Exception e) {
            system.debug('Error Message:::'+e.getMessage());
            return null;
        }
    }
}