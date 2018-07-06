public class ContactSiteAssociationGateway {

   /*
    * Member variables
    */
    public static Map<String,id> contactSiteAssociationMap = new Map<String,id>(); 
    public static Map<Id,Contact>contactMap ; 
    public static Map<Id,Site_Association__c> siteAssociationMap;
    private static Set<Id> contactIdSet = new Set<Id>();
    private static Set<Id> siteIdSet = new Set<Id>();
    private static List<Contacts_Site_Association__c> contactSiteAssociationList = new List<Contacts_Site_Association__c>();
    
     /**
     * Public static method to load map of matching contact site association records 
     *
     * Arguments: List of  Contacts_Site_Association__c
     
     * 
     */
    public static void loadContactSiteAssociationBulkBefore(List<Contacts_Site_Association__c>contactSiteList){
        if(contactSiteList!=null && contactSiteList.Size()>0){
            for(Contacts_Site_Association__c contactSite : contactSiteList){
                contactIdSet.add(contactSite.SC_CSA_CONTACTS__c);
                siteIdSet.add(contactSite.SC_CSA_SITE__c);
            }
            contactSiteAssociationList = [Select Id , SC_CSA_CONTACTS__c,SC_CSA_SITE__c
                                          from Contacts_Site_Association__c
                                          where SC_CSA_CONTACTS__c IN:contactIdSet AND SC_CSA_SITE__c IN :siteIdSet
                                         ];
            if(contactSiteAssociationList!=null && contactSiteAssociationList.Size()>0){
                for(Contacts_Site_Association__c contactSite :contactSiteAssociationList){
                    String s =  String.valueOf(contactSite.SC_CSA_CONTACTS__c) + String.valueof(contactSite.SC_CSA_SITE__c);
                    contactSiteAssociationMap.put(s,contactSite.Id);
                }
            } 
            //code to check duplicate in bulk list that was passed in Trigger.New 
            Set<String> combinationSet = new Set<String>();
            for(Contacts_Site_Association__c contactSite : contactSiteList){  
            	    String s =  String.valueOf(contactSite.SC_CSA_CONTACTS__c) + String.valueof(contactSite.SC_CSA_SITE__c);
            	    //condition to check if queried records doesnt have ID and bulk list has duplicate
            	    if(!contactSiteAssociationMap.containskey(s) && combinationSet.contains(s)){
                    	contactSiteAssociationMap.put(s,contactSite.Id);		
            	    }
            	    combinationSet.add(s);
            }
            contactMap = new Map<Id,Contact>([Select Id , AccountId 
                                              from Contact 
                                              where Id IN : contactIdSet AND AccountId =''
                                             ]);
            siteAssociationMap = new Map<Id,Site_Association__c>([Select Id,Enterprise_ID__c 
                                                                  from Site_Association__c
                                                                  where Id IN :siteIdSet
                                                                 ]);                                                    
        }
    }
    
     /**
     * Public static method to get matching duplicate contact site association record
     *
     * Arguments:   Contacts_Site_Association__c
     
     * returns Boolean true if match found
     */
    public static boolean getMatch(Contacts_Site_Association__c contactSiteAssociation){
        
         String match =  String.valueOf(contactSiteAssociation.SC_CSA_CONTACTS__c) + String.valueof(contactSiteAssociation.SC_CSA_SITE__c); 
         if(contactSiteAssociationMap.containsKey(match)){
            return true;
         }
         else return false;
         
    }
}