public Class CA_GenerateAgreement_Controller{
    String agrId = ApexPages.currentPage().getParameters().get('id');
    Apttus__APTS_Agreement__c aptAgr;
    public Pagereference generate(){
        if(agrId != null)   
        aptAgr = [Select id,CA_Agreement_Amends_Terms_of_Master__c,Apttus__Status_Category__c from Apttus__APTS_Agreement__c where id =: agrId];        
                  
        if(aptAgr != null){
            if(aptAgr.CA_Agreement_Amends_Terms_of_Master__c == '' || aptAgr.CA_Agreement_Amends_Terms_of_Master__c == null){
                system.debug('IIIIIFFFFF');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select "Agreement Amends" before proceeding to Generate Agreement.');
                ApexPages.addMessage(myMsg);        
                return null;
            }
            else{           
                    return new PageReference('/apex/Apttus__SelectTemplate?id='+agrId+'&action=Generate_Agreement&templateType=Agreement');            
            }
        }else{
            return new PageReference('/apex/Apttus__SelectTemplate?id='+agrId+'&action=Generate_Agreement&templateType=Agreement');
        }         
    }
    public Pagereference returnToAgreement(){      
        return new PageReference('/'+agrId);         
    }
}