public class CC_Utils {
  public static String resolveLdapTimezone(String ldapTimezone) {
    String normalizedLdapTimezone = ldapTimezone;
    try {
      if (normalizedLdapTimezone.length() > 0) {
        normalizedLdapTimezone = normalizedLdapTimezone.split(';')[0];
        if (normalizedLdapTimezone.length() > 40) {
          normalizedLdapTimezone = normalizedLdapTimezone.substring(0, 40);
        }
        SObject[] foundTimezones = Database.query('SELECT Salesforce_Timezone__c FROM LDAP_Timezone__mdt WHERE Label = :normalizedLdapTimezone');
        if (foundTimezones.size() > 0) {
          String sfTimezone = (String)foundTimezones[0].get('Salesforce_Timezone__c');
          log.debug('Resolved timezone: ' + sfTimezone + ' from LDAP timezone: ' + ldapTimezone);
          return sfTimezone;
        } else {
          log.warn('Could not resolve timezone for: ' + ldapTimezone);
        }
      }
    } catch (Exception ex) {
      // this is only likely to happen if the metadata type does not exist in this environment, just for good measure
      log.warn('Ignoring timezone error for: ' + ldapTimezone);
      log.warn(ex);
    }
    return null;
  }

  public static String resolveLdapCountry(String ldapCountry) {
    String translatedValue = ldapCountry;
    List<PicklistEntry> countryPicklistEntries = Contact.Country_Picklist__c.getDescribe().getPicklistValues();
    for (PicklistEntry e : countryPicklistEntries) {
      String picklistValue = e.getValue();
      if (picklistValue.substring(0,2) == ldapCountry) {
        translatedValue = picklistValue;
        break;
      }
    }
    log.debug('Translated ' + ldapCountry + ' To ' + translatedValue);
    return translatedValue;
  }

  public static String resolveLdapLanguage(String ldaplanguage) {
    String translatedValue = null;
    LDAP_Translation__mdt[] languageTranslations = [SELECT SF_Value__c FROM LDAP_Translation__mdt WHERE Type__c = 'Language' AND LDAP_Value__c = :ldaplanguage];
    if (languageTranslations.size() > 0) {
      translatedValue = languageTranslations.get(0).SF_Value__c;
    }
    log.debug('Translated ' + ldaplanguage + ' To ' + translatedValue);
    return translatedValue;
  }

  public static Boolean isEmpty(Object value) {
    return String.isBlank(String.valueOf(value));
  }


  public static String padSiteId(String siteId){
    if(CC_utils.isempty(siteID)){
      return null;
    }
    Integer lengthOfSiteID = siteId.length();
    String paddedSite = siteId;
    String padding = '';
    if(lengthOfSiteId < 6){
      Integer numOfZerosToPad = 6 - lengthOfSiteId;
      for(Integer i = 0; i < numOfZerosToPad; i++){       
        padding = padding + '0';
      }  
      paddedSite = padding + siteId;
    }  
    return paddedSite;
  } 
    
   //As globalscape, accepts 7 digit siteId
    public static String padSiteIdforGS(String siteId){
    if(CC_utils.isempty(siteID)){
      return null;
    }
    Integer lengthOfSiteID = siteId.length();
    String paddedSite = siteId;
    String padding = '';
    if(lengthOfSiteId < 7){
      Integer numOfZerosToPad = 7 - lengthOfSiteId;
      for(Integer i = 0; i < numOfZerosToPad; i++){       
        padding = padding + '0';
      }  
      paddedSite = padding + siteId;
    }  
    return paddedSite;
  }

  public static Boolean navigateToPath(JSONParser parser, String path) {
    String[] pathParts = path.split('\\.');
    Integer currentLevel = 0;
    while(parser.nextToken() != null) {
      if (parser.getCurrentToken() == JSONToken.START_OBJECT || parser.getCurrentToken() == JSONToken.START_ARRAY) {
        if (currentLevel == pathParts.size()) {
          parser.skipChildren();
          continue;
        }
        currentLevel++;
      } else if (parser.getCurrentToken() == JSONToken.END_OBJECT || parser.getCurrentToken() == JSONToken.END_ARRAY) {
        currentLevel--;
      } else if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
        if (!isFieldToken(parser, pathParts[currentLevel-1])) {
          parser.nextToken();
          if (parser.getCurrentToken() == JSONToken.START_OBJECT || parser.getCurrentToken() == JSONToken.START_ARRAY) {
            parser.skipChildren();
          }
        }
        if (isFieldToken(parser, pathParts[currentLevel-1]) && currentLevel == pathParts.size()) {
          parser.nextToken();
          return true;
        }
      }
    }
    return false;
  }
    
    public static String fetchSmallestSiteId(List<String> tempStiesStrList){
        Integer smallestValue;
        for(String s: tempStiesStrList){
            s = s.removeStart('"');
            s = s.removeEnd('"');
            if(smallestValue == null)
                smallestValue = Integer.valueOf(s);
            else 
                if(smallestValue > Integer.valueOf(s))
                smallestValue = Integer.valueOf(s);
        }
        return String.valueOf(smallestValue);
    }

    public static String removeNonAlphChars(String tempStr ){
      String regExp = '[^a-zA-Z0-9]';
      System.debug('Before removeNonAlphChars tempStr:'+tempStr);
      tempStr= tempStr.replaceAll(regExp, '');
      System.debug('After removeNonAlphChars tempStr:'+tempStr);
      return tempStr;
    }
    
  private static Boolean isFieldToken(JSONParser parser, String fieldName) {
    return parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == fieldName;
  }
}