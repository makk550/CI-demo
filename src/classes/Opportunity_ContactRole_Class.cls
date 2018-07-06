/*
 * Test Class - Opportunity_ContactRole_Class_Test
 * Coverage - 97%
 * updated by - SAMAP01
 * 
* SAMAP01		21/8/2017		US384301    	Optimized to avoid Heap Size error
* ********************************************************************************************/

public class Opportunity_ContactRole_Class
{
    public static Set<Id> insertedOpps = new Set<Id>();
    public static boolean skipPartnerOppTrg = false;
    public static boolean skipTAQBatch = false;
    public static boolean skipTAQ_NHTT = false;
    public static boolean userIsBypass = [SELECT Id, Opportunity_Validation_Bypass__c FROM USER WHERE Id = :UserInfo.getUserID()][0].Opportunity_Validation_Bypass__c;
    public static integer fymonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth;
   /* public static List<User> ulist_st = [Select id,UserType, ContactId, Is_Partner_User__c, IsPortalEnabled, AccountId,
                                         contact.Account.Solution_Provider_CAM_PMFKey__c, PMFKey__c, Title from user		//- user license type excluded as part of 300-755349
                                         where Isactive=true AND usertype NOT IN ('CSPLitePortal','CsnOnly') limit 50000]; //check the limit 
*///samap01 changed 50000 to 1 to test 8/24
    public static User loggedinuser ;
    public static List<User> partneruserlst ;
    public static  list<Account> Accountlist;
    public static list<Partner_Engagement_Program__c> partnerEP;
    public static List<CurrencyType> crncyType = [SELECT ConversionRate, IsoCode FROM CurrencyType];    
    
    //AR:3503
    public static Map<Id,boolean> oppPrimaryContactRole(Set<Id> oppIdset){  
        Map<Id,boolean> oppPrimaryCntRoleMap = new Map<Id,boolean>();            
        List<OpportunityContactRole> oppPrimaryContactRoleList = [select id,contactId,IsPrimary,OpportunityId from OpportunityContactRole where OpportunityId IN :oppIdset AND IsPrimary = true];
        for(OpportunityContactRole ocr:oppPrimaryContactRoleList){
            
            oppPrimaryCntRoleMap.put(ocr.OpportunityId,ocr.IsPrimary);
        }
        return oppPrimaryCntRoleMap;        
    }
    
    //SAMAP01 - US384301
    public static User currentuserinfo( Id userid)
    {
        if(loggedinuser == null)
        {
            if(userid != null)
            {
                             loggedinuser = [Select id,UserType, ContactId, Is_Partner_User__c, IsPortalEnabled, AccountId,     
                         contact.Account.Solution_Provider_CAM_PMFKey__c, PMFKey__c, Title from user    //- user license type excluded as part of 300-755349
                                         where Isactive=true AND usertype NOT IN ('CSPLitePortal','CsnOnly') AND ID =:userid LIMIT 1 ]; 
                	  	System.Debug('opp contactrole classs -get user details'+partneruserlst);

            }
           }
        
        return loggedinuser;
      
    }
    
    public static List<User> partneruserlist( String[] partnerpmfkeys)
    {
        if(partneruserlst == null)
        {
            if(partnerpmfkeys != null  && partnerpmfkeys.size() > 0)
            {
                    partneruserlst = [Select id,UserType, ContactId, Is_Partner_User__c, IsPortalEnabled, AccountId,
                                      contact.Account.Solution_Provider_CAM_PMFKey__c, PMFKey__c, Title from user	
                                      where Isactive=true AND usertype NOT IN ('CSPLitePortal','CsnOnly')  and PMFKey__c IN : partnerpmfkeys] ;      
       				  System.Debug('opp contactrole classs -get partner details'+partneruserlst);
            }
              }
        
        return partneruserlst;
      
    }
    
    // PartnerAccountlist=[SELECT Id, Name, OwnerId, Segment__c, RecordType.Name, Solution_Provider_CAM_PMFKey__c, Service_Provider_CAM_PMFKey__c, Velocity_Seller_CAM_PMFKey__c, Alliance_CAM_PMFKey__c from Account where Id in : partnerAccId];
    public static List<Account> accountslist(Set<Id> accids)
    {
        if(Accountlist == null)
        {
            if(accids != null && accids.size()>0)
            {
                 Accountlist =[SELECT Id, Name, OwnerId, Segment__c, RecordType.Name, Solution_Provider_CAM_PMFKey__c, Service_Provider_CAM_PMFKey__c,
                      Account.Coverage_Model__c, Alliance_CAM_PMFKey__c,
                               Sales_Area__c,Sales_Region__c,Region_Country__c from Account where Id in : accids];
                System.Debug('-opp contactrole classs Accountlist'+Accountlist);
               
            }
               
        }    
        return Accountlist;
    }
    
     public static List<Partner_Engagement_Program__c> partneropplist(Set<Id> oppids)
    {
        if(partnerEP == null)
        {
            if(oppids != null && oppids.size()>0)
            {
                   partnerEP=[select id, Parent_Opportunity__c from Partner_Engagement_Program__c where Parent_Opportunity__c in : oppids limit 50000];
                System.Debug('opp contactrole classs partneropplist'+partnerEP);
               
            }
               
        }    
        return partnerEP;
    }

    
}