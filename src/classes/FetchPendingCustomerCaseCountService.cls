@RestResource(urlMapping='/getPendingCustomerCaseCount')
global with sharing class FetchPendingCustomerCaseCountService  {
    
    @HttpGet
    global static ReturnClass fetchPendingCustomerCaseCount() {    
        system.debug(RestContext.request+'*****');
        String ldapIDofContact = RestContext.request.params.get('ldapID');
        System.debug('ldapIDofContact:'+ldapIDofContact);
        Integer pendingCustomerCaseCount = 0;
        try {
            if(String.isNotBlank(ldapIDofContact)){
                String contactEmail = fetchPartnerUserEmail(ldapIDofContact);
                System.debug('contactEmail:-------------------->'+contactEmail);
                if(contactEmail != 'PartnerNotFound' ){
                        List<Case> caseList = [select id,CaseNumber, Contact.SC_CONTACT_LDAPID__c from Case where Contact.email =:contactEmail  AND  Next_Action__c =:System.label.Pending_Customer AND Case_Type__c!=:'Chat' AND Case_Type__c!=:System.Label.ProactiveCaseType]; //DE269958: chats shall be excluded from the number of cases returned
                        pendingCustomerCaseCount = caseList.size();
                     return new ReturnClass('true', 'Query executed successfully.', pendingCustomerCaseCount);
                } else{
                        List<Case> caseList = [select id,CaseNumber, Contact.SC_CONTACT_LDAPID__c from Case where Contact.SC_CONTACT_LDAPID__c =:ldapIDofContact  AND  Next_Action__c =:System.label.Pending_Customer AND Case_Type__c!=:'Chat' AND Case_Type__c!=:System.Label.ProactiveCaseType]; //DE269958: chats shall be excluded from the number of cases returned
                        pendingCustomerCaseCount = caseList.size();
                        return new ReturnClass('true', 'Query executed successfully.', pendingCustomerCaseCount);
                }   }else{
                return new ReturnClass('false', 'Please pass the correct paramter value', null); }
        } catch (Exception e) {
            return new ReturnClass('false', e.getMessage(), null);
        }
    }
    
    global class ReturnClass {
        global String success;
        global String message;
        global Integer recordCount;
        global ReturnClass(String success, String message, Integer count) {
            this.success = success;
            this.message = message;
            this.recordCount = count;
        }
    }

    public static String fetchPartnerUserEmail(String ldapIDofContact){
            List<Contact> contactList = [select id,SC_CONTACT_LDAPID__c,email from Contact where SC_CONTACT_LDAPID__c = :ldapIDofContact];
                if(contactList!=null && contactList.size()>0 ){
                     List<User> userlist = [select id, Usertype,contactId  from  User where contactId = : contactList[0].Id  ];
                     if(userlist!=null && userlist.size()>0){
                           if(userlist[0].UserType.equalsIgnoreCase('PowerPartner')){  return contactList[0].email; }
                           return 'PartnerNotFound';
                     } return 'PartnerNotFound';
                } else {  return 'PartnerNotFound';  }
    }
    
}