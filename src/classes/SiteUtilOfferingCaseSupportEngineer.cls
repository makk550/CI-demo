public class SiteUtilOfferingCaseSupportEngineer {
    
    public static List<Offering_Profiles_Check__c> offeringUserProfilesList = Offering_Profiles_Check__c.getAll().values();
    public static String[] userDetails=null; 
    public static Boolean isValidProfile=false;
    public static List<Case> CaseEmailAlertList = new List<Case>();
    
     public static void executeOfferingCaseOwner(List<Case> caseList){
       for(Case offeringCase:caseList){
            if(offeringCase.Offering_Name__c<>null && offeringCase.Offering_Support_Engineer__c<>null){
                userDetails= getActiveUser(offeringCase.Offering_Support_Engineer__c);              
                if(userDetails<>null){
                    isValidProfile=isValidProfileCheck(userDetails);               
                    if(isValidProfile){
                        offeringCase.OwnerId=userDetails[0];
                        if(!(userDetails[0].startsWith('00G'))){
                   			 CaseEmailAlertList.add(offeringCase);                             
                        }
                    }   
                }
            }
        }
         sendEmailNotification();
    }
    
    public static String[] getActiveUser(String pmfKey){
        User userDet=[SELECT Id,Profile.Name from User where IsActive=TRUE AND PMFKey__c=:pmfKey LIMIT 1];
        if(userDet<>null){
            userDetails=new String[2];
            userDetails[0]=userDet.ID;
            userDetails[1]=userDet.Profile.Name;
        }    
        return userDetails;
    }
    
    public static Boolean isValidProfileCheck(String[] userDet){
        for(Offering_Profiles_Check__c customProfiles:offeringUserProfilesList){
            if(customProfiles.Name.equals(userDet[1])){
                isValidProfile=true;
                break;
            }            
        }
        return isValidProfile;
    }
    
    public static void sendEmailNotification(){       
       if(CaseEmailAlertList.size() > 0){
            UtilityFalgs.sendNotificationToAssgnUser(CaseEmailAlertList);
            UtilityFalgs.sentAlert=true;
        } 
    }
}