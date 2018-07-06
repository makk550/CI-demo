public class PartnerLeadDistribution_DynamicSOQL {
    
    //This Class Contains all the Partner Lead Distribution Queries
    //Accounts query is the PartnerLeadDistribution_Utility
 
    //commenting as DSR coverage is no more in PLD utility class
    /*
    public static List<TAQ_Organization__c> getTAQOrgList(Set<String> Roles){
      
         Set<String> TaqOrgRolesSet=Roles;
       // List<TAQ_Organization__c> TAQOrgList=Database.query('select name,Country__c,Region__c,CBU__c,Area__c,Terr_Covg_Sales_Region__c,Territory__c from TAQ_Organization__c where Employee_Status__c= \'Active\' and Employee_Name__c!=\' \' and Employee_Name__c !=NULL and  Role__c in: TaqOrgRolesSet and Region__c != NULL AND Area__c !=NULL and Terr_Covg_Sales_Region__c!= null and Territory__c!=null and CBU__c != NULL');
                           
        List<TAQ_Organization__c> TAQOrgList=[select name,Country__c,Region__c,CBU__c,Area__c,Terr_Covg_Sales_Region__c,Territory__c 
                                              from TAQ_Organization__c 
                                              where Employee_Status__c= 'Active' and Employee_Name__c!=' ' and Employee_Name__c !=NULL and  Role__c in: TaqOrgRolesSet and Region__c != NULL AND Area__c !=NULL and Terr_Covg_Sales_Region__c!= null and Territory__c!=null and CBU__c != NULL];
        return TAQOrgList;
    }
    
    public static List<Product2> getProduct2List(Set<String> leadProdSet){
        
       list<Product2> Product2List=[select CSU_Driver__c,Commissionable_BU__c from Product2 where CSU_Driver__c in: leadProdSet];
        return Product2List;
    }
    */
    
    public static List<LeadRoutingMatrix__c> getLRMList(){
        
        List<LeadRoutingMatrix__c> LrmList=[select id, Business_Unit__c,Country_Picklist__c,GEO__c,LeadScore__c,Operating_Area__c,Sales_Region__c,Recordtype.Name,Recordtypeid from LeadRoutingMatrix__c where RecordType.Name='Threshold'];
        //
        return LrmList;
    }
    
    public static List<DelegateLeadChampion__c> DeligateList(){
        
        List<DelegateLeadChampion__c> DeligateList=[select id,name,Createdbyu__c,Createdbyid,DelegateLeadChampion__c,StartDate__c,EndDate__c,PartnerAccount__c,UseDelegateLeadChampion__c from DelegateLeadChampion__c where StartDate__c<=Today and EndDate__c>=Today ];
        
        return DeligateList;
    }
    
     public static List<Lead> LeadList(set<id> leadidset){
        
        List<Lead> leadList=[select id,Name,ownerid,AssignmentDate__c,AcceptReject__c,Rejection_Reason__c,Partnerleadprocessed__c,Reseller__c from Lead where id IN:leadidset ];
        
        return leadList;
    }
    
    public static List<Account> AccountList(list<id> Accidset){
        
        List<Account> AccList=[select id,Lead_Champion__r.AccountId,Lead_Champion__c,Name from Account where id IN :Accidset ];
        
        return AccList;
    }

    // Get the Opportunity objects that have been closed in the last 4 completed quarters and belong to one of the accounts in the list. 
    public static List<Opportunity> GetOppListForLHScore( Set<Account> accSet, Date lastComplete4QuartersStartDate )
    {
        List<Opportunity> oppList = new List<Opportunity>();
        
        try 
        {
            oppList = [SELECT id, Reseller__c, StageName, CloseDate, Source__c, Stage_Change_Date__c, Has_Primary_Quote__c 
                       FROM Opportunity 
                       WHERE Source__c='Lead' AND CloseDate >= :lastComplete4QuartersStartDate AND Reseller__c IN :accSet ];
        }
        catch(Exception ex) 
        {       
            System.debug(logginglevel.Debug,ex);
            return oppList;
        }
        
        return oppList;
    }
    
    // Get all the leads assigned to this partner in the last 4 completed quarters
    public static List<Lead> GetLeadListForLHScore( Date lastCompleteQuarterStartDate, 
                                                    Date lastComplete4QuartersStartDate,
                                                    Set<String> CA_Account_ID_Set)
    {
        List<Lead> leadList = new List<Lead>();
        
        try 
        {
                leadList = [SELECT id, EAID__c, Lead_Status_Date__c, Status, IsConverted, PartnerAcceptancedate__c, ConvertedDate 
                            FROM Lead 
                            WHERE ((PartnerAcceptancedate__c >= :lastCompleteQuarterStartDate AND IsConverted = TRUE) OR 
                                   ((Lead_Status_Date__c >= :lastComplete4QuartersStartDate) AND 
                                    ((Status = 'Rejected') OR (Status = 'Pursuing')))) AND 
                                   EAID__c IN :CA_Account_ID_Set];        }
        catch(Exception ex) 
        {       
            System.debug(logginglevel.Debug,ex);
            return leadList;
        }
        
        return leadList;
    }

    // Get the Opportunity objects that have been closed in the last 4 completed quarters and were created from Leads. 
    public static List<Opportunity> GetOppListForTieBreakingRules( Date lastComplete4QuartersStartDate )
    {
        List<Opportunity> oppList = new List<Opportunity>();
        
        try 
        {
            oppList = [SELECT   id, Created_from_Lead__c, StageName, CloseDate, Reseller__c 
                       FROM     Opportunity 
                       WHERE    CloseDate >= :lastComplete4QuartersStartDate AND 
                                StageName = '100% - Contract Signed' AND 
                                Created_from_Lead__c = 'TRUE'];
        }
        catch(Exception ex) 
        {       
            System.debug(logginglevel.Debug,ex);
            return oppList;
        }
        
        return oppList;
    }
    
    // Get the list of account objects. 
    public static List<Account> GetAccountListForTieBreakingRules( Set<Id> accIdSet)
    {
        List<Account> accList = new List<Account>();
        
        try 
        {
            accList = [select PartnerLeadLastAcceprancedate__c, id from account where id IN :accIdSet];
        }
        catch(Exception ex) 
        {       
            System.debug(logginglevel.Debug,ex);
            return accList;
        }
        
        return accList;
    }
}