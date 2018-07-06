public class CA_BacktoAuthoring {

    public Id agrmId {get; set;}

    public CA_BacktoAuthoring() {
        agrmId = ApexPages.currentPage().getParameters().get('id');  
        system.debug('Agrement Id:::'+agrmId);    
    }
    
    public pageReference updateAgreementStatus() {
        system.debug('Agreement Id::::'+agrmId);
        Apttus__APTS_Agreement__c agr = [Select Id, RecordType.Name, CA_NDA_Flag__c, Name, Apttus__Status_Category__c, Apttus__Status__c from Apttus__APTS_Agreement__c where Id =: agrmId];
        User u = [select Id, profileId, Name from User where Id =: UserInfo.getUserId()];
        
        if(agr.RecordType.Name != Label.NDA) {
            agr.Apttus__Status_Category__c = Label.In_Authoring;
            agr.Apttus__Status__c = Label.Author_Contract;
            agr.Apttus__IsLocked__c = false;
            agr.Apttus_Approval__Approval_Status__c = Label.Not_Submitted;
        }
        else{
            if(agr.RecordType.Name == Label.NDA && (agr.Apttus__Status_Category__c == Label.Approved && agr.Apttus__Status__c == Label.Approved)) {
                agr.Apttus__Status_Category__c = Label.In_Authoring;
                agr.Apttus__Status__c = Label.Author_Contract;
                agr.Apttus__IsLocked__c = false;
                if(agr.CA_NDA_Flag__c == Label.Non_Standard_NDA) {
                    List<PermissionSetAssignment> psalist = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment where AssigneeId =: UserInfo.getUserId()];
                    system.debug('PSA List:::'+psalist);
                    for(PermissionSetAssignment psa : psalist) {
                        system.debug('PSA Permission Set Name:::'+psa.PermissionSet.Name);
                        if(psa.PermissionSet.Name == 'CLM_Legal')
                            agr.OwnerId = u.Id;    
                    }
                }
                
            } else {
                agr.Apttus__Status_Category__c = Label.In_Authoring;
                agr.Apttus__Status__c = Label.Author_Contract;
                agr.Apttus__IsLocked__c = false;
                agr.Apttus_Approval__Approval_Status__c = Label.Not_Submitted;
            }
        }     
        
        update agr;
        Approval.unlock(agr);
        PageReference pg = new PageReference('/'+agrmId);
        pg.setRedirect(true);
        return pg;
    }
}