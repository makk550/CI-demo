/**
*Description :Class to update the account on Accreditation when the related Contact 
    changes the Account
*Methods updateAccreditationPartner  , with List of Contact as input
*SOQl: 1
*DML: 1 
*Client: CA technologies
*Developed By:  Accenture
*/
public with sharing class PAD_UpdateAccountOnAccreditation {
    Set<Id> updatedContacts=new Set<Id>();
    List<Accreditation__c> listOfAccreditations=new List<Accreditation__c>();
    
    //method to update Account on the Accreditations
    public void updateAccreditationPartner(List<Contact> contactOldMap,List<Contact> contactNewMap){
        for(Integer i=0;i<contactNewMap.size();i++){
            if(contactNewMap[i]!=contactOldMap[i]){
                updatedContacts.add(contactNewMap[i].Id);
            }   
        }
        if(updatedContacts!=null || updatedContacts.size()>0){
            listOfAccreditations=[select Contact_Name__r.Id,Partner__c,Contact_Name__r.AccountId 
                                  from Accreditation__c where Contact_Name__r.Id in: UpdatedContacts];  
        }
        if(listOfAccreditations!=null || listOfAccreditations.size()>0){
            for(Accreditation__c a: listOfAccreditations){
                a.Partner__c=a.Contact_Name__r.AccountId;
            }
            update listOfAccreditations;
        }
    }
}