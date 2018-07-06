public Class RelatedAgreementTriggerHandler{

    public static void updateParentAgreement(List<Apttus__APTS_Related_Agreement__c> lstRelatedAgr){
        Set<Id> orignalAgrId = new Set<Id>();
        Set<Id> newAgrId = new Set<Id>();
            for(Apttus__APTS_Related_Agreement__c relAgr : lstRelatedAgr){
                if(relAgr.Apttus__APTS_Contract_To__c != null){
                    newAgrId.add(relAgr.Apttus__APTS_Contract_To__c);
                    orignalAgrId.add(relAgr.Apttus__APTS_Contract_From__c);
                }        
            }
        List<Apttus__APTS_Agreement__c> listOfAgr = new List<Apttus__APTS_Agreement__c>();
        listOfAgr = [Select id,Name from Apttus__APTS_Agreement__c where id in:newAgrId];
        List<Apttus__APTS_Agreement__c> listOfAgrToUpdate = new List<Apttus__APTS_Agreement__c>();
        for(Apttus__APTS_Related_Agreement__c relAgr : lstRelatedAgr){
            for(Apttus__APTS_Agreement__c agr : listOfAgr){
                if(agr.id == relAgr.Apttus__APTS_Contract_To__c ){
                    agr.Apttus__Parent_Agreement__c = relAgr.Apttus__APTS_Contract_From__c; 
                    agr.CA_Agreement_Amends_Terms_of_Master__c = null;
                    listOfAgrToUpdate.add(agr);
                }
            }    
        } 
        if(listOfAgrToUpdate.size()>0){
            update listOfAgrToUpdate;
        }   
    }
}