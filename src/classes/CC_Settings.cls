public class CC_Settings {
    
  public static String csoUrl { 
    get {
      if (csoUrl == null) {
        csoUrl = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'CSO_URL'].Value__c;
      }
      return csoUrl;
    }
    set;
  }

  public static Id communityUserProfileId { 
    get {
      if (communityUserProfileId == null) {
        communityUserProfileId = (Id)[SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Community_User_Profile_ID'].Value__c;
      }
      return communityUserProfileId;
    }
    set;
  }
  
    public static Id communityExternalUserProfileId { 
        get {
            if (communityExternalUserProfileId == null) {
                if(!Test.isRunningTest()){
                    communityExternalUserProfileId = (Id)[SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Community_External_User_Profile_ID'].Value__c;
                } else {
                    communityExternalUserProfileId = '00e3C000000YLnm' ;
                }
            }
            return communityExternalUserProfileId;
        }
        set;
    }   

  public static Id communityUserDefaultAccountId { 
    get {
      if (communityUserDefaultAccountId == null) {
        communityUserDefaultAccountId = (Id)[SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Community_User_Default_Account_ID'].Value__c;
      }
      return communityUserDefaultAccountId;
    }
    set;
  }

  public static String searchDotCaDotComSourceId { 
    get {
      if (searchDotCaDotComSourceId == null) {
        searchDotCaDotComSourceId = (String)[SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'search_ca_com_SourceId'].Value__c;
      }
      return searchDotCaDotComSourceId;
    }
    set;
  }

  public static Boolean debugEnabled { 
    get {
      if (debugEnabled == null) {
        try {
          debugEnabled = Boolean.valueOf([SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Debug_Enabled'].Value__c);
        } catch (exception ex) {
          debugEnabled = false;
        }
      }
      return debugEnabled;
    }
    set;
  }

  public static Integer caseSearchMaxResults { 
    get {
      if (caseSearchMaxResults == null) {
        try {
          caseSearchMaxResults = Integer.valueOf([SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Case_Search_Max_Results'].Value__c);
        } catch (exception ex) {
          caseSearchMaxResults = 500;
        }
      }
      return caseSearchMaxResults;
    }
    set;
  }
  
  public static Integer caseExcelMaxResults { 
    get {
      if (caseExcelMaxResults == null) {
        try {
          caseExcelMaxResults = Integer.valueOf([SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Case_Excel_Max_Results'].Value__c);
        } catch (exception ex) {
          caseExcelMaxResults = 5000;
        }
      }
      return caseExcelMaxResults ;
    }
    set;
  }  
  
  public static String activityFlagDate {
    get{
      if (activityFlagDate == null) {       
          activityFlagDate = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Date_for_New_Activity_Flag'].Value__c;
      }
      return activityFlagDate;
    }
    set;
  }

  public static Set<String> allowAccessRoles { 
    get {
      if(allowAccessRoles == null){
        allowAccessRoles = new Set<String>();
        List<Customer_Community_Setting__mdt> rolesAllowed = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE Type__c = 'Access Role'];
        for(Customer_Community_Setting__mdt role: rolesAllowed){
          allowAccessRoles.add(role.Value__c);
        }
      }
      return allowAccessRoles;
    } 
    set; 
  }
  
  public static List<CC_Security_Groups_Config__c> securityGroups { 
    get {
      if(securityGroups == null){
        securityGroups = new List<CC_Security_Groups_Config__c>();
        securityGroups = [SELECT Name, Available_LDAP_Roles__c, Access_Solutions__c, Access_Cases_of_All_Sites__c, Can_Open_Case__c, View_Private_Comments__c, Rank__c FROM CC_Security_Groups_Config__c order by Rank__c];
      }
      return securityGroups;
    } 
    set; 
  }
  
    public static String careUrl { 
        get {
            if (careUrl == null) {
                if(!Test.isRunningTest()){
                    careUrl = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'CARE_URL'].Value__c;
                } 
                else {
                    careUrl = 'https://ca.com';
                }
            }
            return careUrl;
        }
        set;
    }
    
  public static String globalScapeUrl { 
    get {
      if (globalScapeUrl == null) {
        globalScapeUrl = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'GlobalScape_URL'].Value__c;
      }
      return globalScapeUrl;
    }
    set;
  }

  public static String L7GlobalScapeUrl { 
    get {
      if (L7GlobalScapeUrl == null) {
        L7GlobalScapeUrl = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'L7_GlobalScape_URL'].Value__c;
      }
      return L7GlobalScapeUrl;
    }
    set;
  }

   public static String gs_Enabled { 
    get {
      if (gs_Enabled == null) {
        gs_Enabled = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'GS_Enabled'].Value__c;
      }
      return gs_Enabled;
    }
    set;
  }

   public static String cftp_Enabled { 
    get {
      if (cftp_Enabled == null) {
        cftp_Enabled = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'CFTP_Enabled'].Value__c;
      }
      return cftp_Enabled;
    }
    set;
  }

  public static String cftp_url { 
    get {
      if (cftp_url == null) {
        cftp_url = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'CrushFTP_Url'].Value__c;
      }
      return cftp_url;
    }
    set;
  }    
    
    public static String prodGSCId { 
        get {
            if (prodGSCId == null) {
                if(!Test.isRunningTest()){
                    prodGSCId = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'PROD_GLOBAL_SERVICE_CENTER'].Value__c;
                }
                else {
                    prodGSCId = 'a7Za0000000PB4O';
                }
            }
            return prodGSCId;
        }
        set;
    }   
    public static String comSCNECT { 
        get {            
            if (comSCNECT == null) {
                if(!Test.isRunningTest()){
                    comSCNECT = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'COM_GSC_SCNECT'].Value__c;
                }
                else {
                    comSCNECT = 'a7Ya0000000Gnrh';
                }
            }
            return comSCNECT;
        }
        set;
    }   
  
    public static String comLPMKEY { 
    get {
      if (comLPMKEY == null) {
          if(!Test.isRunningTest()){
          comLPMKEY = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'COM_GSC_LPMKEY'].Value__c;
          }
          else {
              comLPMKEY =  'a7Ya0000000GnrW';
          }
      }
      return comLPMKEY;
    }
    set;
  }   
    public static String defaultSiteIDforNoAccess { 
    get {
      if (defaultSiteIDforNoAccess == null) {
          if(!Test.isRunningTest())
          defaultSiteIDforNoAccess = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'defaultSiteIDforNoAccess' AND Type__c=''].Value__c;
          else
              defaultSiteIDforNoAccess = 'a26a0000001ChIjAAK';
      }
      return defaultSiteIDforNoAccess;
    }
    set;
  }    

    public static String AWSAPIGatewayBaseURL { 
    get {
      if (AWSAPIGatewayBaseURL == null) {
        AWSAPIGatewayBaseURL = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'AWS_API_Gateway_Base_URL' AND Type__c=''].Value__c;
      }
      return AWSAPIGatewayBaseURL;
    }
    set;
    }
    public static String csoShowSolutionURL { 
    get {
      if (csoShowSolutionURL == null) {
        csoShowSolutionURL = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Show_Sol_URL' AND Type__c=''].Value__c;
      }
      return csoShowSolutionURL;
    }
    set;
  }
   public static String eaiAWSTokenURL { 
    get {
      if (eaiAWSTokenURL == null) {
        eaiAWSTokenURL = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'EAI_AWSToken_URL' AND Type__c=''].Value__c;
      }
      return eaiAWSTokenURL;
    }
    set;
  } 

     public static String  customerCommunityGuestProfileId{ 
            get {
              if (customerCommunityGuestProfileId == null) {
                 customerCommunityGuestProfileId = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Customer_Community_Guest_Profile_Id' AND Type__c=''].Value__c;
              }
              return customerCommunityGuestProfileId;
            }
            set;
    }

    public static String missingContactId {
            get {
              if (missingContactId == null) {
                 missingContactId = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Missing_Contact_Id' AND Type__c=''].Value__c;
              }
              return missingContactId;
            }
            set;      
    }

    public static String componentALPKEY {
            get {
              if (componentALPKEY == null) {
                 componentALPKEY = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Component_ALPKEY' AND Type__c=''].Value__c;
              }
              return componentALPKEY;
            }
            set;      
    }

        public static String componentTLC {
            get {
              if (componentTLC == null) {
                 componentTLC = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Component_TLC' AND Type__c=''].Value__c;
              }
              return componentTLC;
            }
            set;      
    }

    public static String componentGSCOTH {
            get {
              if (componentGSCOTH == null) {
                 componentGSCOTH = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Component_GSCOTH' AND Type__c=''].Value__c;
              }
              return componentGSCOTH;
            }
            set;      
    }
    
   public static String componentGSCPRM {
            get {
              if (componentGSCPRM == null) {
                 componentGSCPRM = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Component_GSCPRM' AND Type__c=''].Value__c;
              }
              return componentGSCPRM;
            }
            set;      
    }
    
    public static String componentGSCLMS {
            get {
              if (componentGSCLMS == null) {
                 componentGSCLMS = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'Component_GSCLMS' AND Type__c=''].Value__c;
              }
              return componentGSCLMS;
            }
            set;      
    }
     public static String paLicensing {
            get {
              if (paLicensing == null) {
                 paLicensing = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'ProductArea_Licensing' AND Type__c=''].Value__c;
              }
              return paLicensing;
            }
            set;      
    }
    
    public static String paCSP {
            get {
              if (paCSP == null) {
                 paCSP = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'ProductArea_CSP' AND Type__c=''].Value__c;
              }
              return paCSP;
            }
            set;      
    }
    
    public static List<CC_Help_Text__mdt> getHelpText { 
    get {
        if (getHelpText == null) {
          getHelpText = new List<CC_Help_Text__mdt>();
		  getHelpText = [SELECT url__c,  title_eng__c FROM CC_Help_Text__mdt where Module__c = 'CaseManagement' ];
        }
        return getHelpText;
        }
        set;
    }
    
    public static List<String> restrictedRecordTypes {
        get{
            String s = ''; 
            if(restrictedRecordTypes == null){
               s = [SELECT Value__c FROM Customer_Community_Setting__mdt WHERE DeveloperName = 'RecordTypes_Restricted' AND Type__c=''].Value__c;
            }            
            System.debug('restrictedRecordTypes- before split:'+s);
            restrictedRecordTypes = s.split(','); 
            System.debug('restrictedRecordTypes-after split:'+restrictedRecordTypes);            
            return restrictedRecordTypes;
        }
        set;
    }

}