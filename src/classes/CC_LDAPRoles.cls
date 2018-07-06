public with sharing class CC_LDAPRoles {
    public CC_LDAPRoles() {
        
    }

    public String buildValueString(String connectMemberOf) {
        String translatedValue;
        String valueString = '';
        List<String> translatedValues = new List<String>();     
        Set<String> cns = extractCNAttributes(connectMemberOf);

        for (String cnValue : cns){
            translatedValue = translateCNValue(cnValue);
            translatedValues.add(translatedValue);
        }

        valueString = String.join(translatedValues, ';');
        return valueString;
    }

    public Boolean allowAccessToCustomerCommunity(String userRoles) {
        Boolean accessGranted = false;
        Set<String> accessRoles = CC_Settings.allowAccessRoles;
        List<String> communityUserRoles = userRoles.split(';');
        for(String role : communityUserRoles){
            if(accessRoles.contains(role)){
                accessGranted = true;
            }
        } 
        return accessGranted;
    }

    @TestVisible
    private Set<String> extractCNAttributes(String connectMemberOf) {
        Set<String> cnAttributes = new Set<String>();
        Pattern cnPattern = Pattern.compile('cn=([\\w]*)');
        Matcher result = cnPattern.matcher(connectMemberOf);
        while (result.find()){
            cnAttributes.add(result.group(1));
        }
        return cnAttributes;
    }

    @TestVisible
    private String translateCNValue(String cnValue) {
        String translatedValue;
        LDAP_Translation__mdt[] cnsTranslations = [SELECT SF_Value__c FROM LDAP_Translation__mdt WHERE Type__c = 'LDAP_Role' AND LDAP_Value__c LIKE :cnValue];
        if (cnsTranslations.size() > 0) {
            translatedValue = cnsTranslations.get(0).SF_Value__c;
            } else{
                translatedValue = cnValue;
            }
            log.debug('Translated ' + cnValue + ' To ' + translatedValue);
            return translatedValue;
    }
    
    @TestVisible
    public String reverseTranslateString(String sfValue)
    {
        System.debug('In reverseTranslateString - sfValue - ' + sfValue);
        List<String> myRoles = sfValue.split(';');
        String translatedString = '';
        List<LDAP_Translation__mdt> myTranslationsList = [Select LDAP_Value__c,SF_Value__c from LDAP_Translation__mdt where type__c='LDAP_Role'];
        Map<String, String> myTranslationsMap = new Map<String, String>();
        for(LDAP_Translation__mdt myRecord : myTranslationsList)
        {
           myTranslationsMap.put(myRecord.SF_Value__c, myRecord.LDAP_Value__c);
        }
        for(string myRole : myRoles)
        {
            if(myTranslationsMap.get(myRole) != null)
            {
                translatedString = translatedString + ';' + myTranslationsMap.get(myRole);
            }
            else
            {
                translatedString = translatedString + ';' + myRole;
            }
        }
        System.debug('In reverseTranslateString - translatedValue - ' + translatedString.substring(1));
        return translatedString.substring(1);
    }      
}