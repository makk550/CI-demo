public Class CA_ImportOfflineDoc_Controller{

    String agrId = ApexPages.currentPage().getParameters().get('id');
    List<Apttus__APTS_Agreement__c> aptAgr = new List<Apttus__APTS_Agreement__c>();
    public Pagereference generate(){
        if(agrId !=null)
        aptAgr = [Select id,CA_Agreement_Amends_Terms_of_Master__c,Apttus__Status_Category__c from Apttus__APTS_Agreement__c where id =: agrId and CA_Record_Type_Name__c !=: Label.NDA];
        //system.debug('&&&&&&&&&&&&&&'+aptAgr[0].CA_Agreement_Amends_Terms_of_Master__c);
        if(aptAgr != null && aptAgr.size()>0) {
            if(aptAgr[0].CA_Agreement_Amends_Terms_of_Master__c == '' || aptAgr[0].CA_Agreement_Amends_Terms_of_Master__c == null){
                system.debug('IIIIIFFFFF');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select "Agreement Amends" before proceeding to Import Offline Document.');
                ApexPages.addMessage(myMsg); 
                return null;
            } 
            else{
               return new PageReference('/apex/Apttus__OfflineDocumentImport?id='+agrId);
            }
        }
        else{
           return new PageReference('/apex/Apttus__OfflineDocumentImport?id='+agrId);
        }
        
    }
    public Pagereference returnToAgreement(){    
        return new PageReference('/'+agrId);
    }
}