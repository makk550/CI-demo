/**
    This class is Utility class for Renewals module having public static
    variables.
    FY13 Updates: This class also has methods which update the active contracts, renewals, opportunities and accounts on various events like sites being created and approved and also the AOCV/OCV/Account being updated on active contracts 
    Last Modified By: Saba Ansari
    Last Modified Date: 3/17/2012
*/

public class Renewals_Util
{
    // Keeps track of renewals that were processed in the approval trigger during the transaction so they are not processed more than once
    public static Set<Id> processedRenewals = new Set<Id>();
    
    public static boolean fromAfterTrigger = false;
    public static boolean fromRenewals_RollupRPToRenewal = false;
    Public static boolean Renewal_Approvalupdatetrigger=false; 
    Public static boolean Renewal_updateProjectedRenewalOnOpp=false;      
    
    /***Description : When a new Site Association record is create, the Account lookup of the Active Contract may be updated.
    /**               In case the account lookup is updated on Active Contracts, the Opportunities, Renewals tied to the Active Contract via their products have to be scanned too.
    /** Created by  : Saba
    /** Created Date: 3/13/2012
    /** Called from : This Class updateRenewalsSiteAssociationsAccounts on Site_Association__c
    /** Input Parameter: List<Active_Contract__c> lst = List out the Active Contracts where the Account has changed.
    /**/ 
    public void SyncRenewalAndOpportunities(List<Active_Contract__c> lst)
    {      
        Map<id,id> mapopptoaccountids = new Map<id,id>();
        Map<id,id> maprenewaltoaccountids = new Map<id,id>();
        
        //Get all the Renewals, Ops tied to the ACs
        for(Active_Contract_Product__c a:[Select a.Opportunity__c, a.Opportunity__r.AccountId, a.Renewal_Product__r.Renewal__c, a.Renewal_Product__r.Renewal__r.Account__c, 
         a.Active_Contract__c From Active_Contract_Product__c a
                where Active_Contract__c  in : lst])
           {
                mapopptoaccountids.put(a.Opportunity__c,a.Opportunity__r.AccountId);
                maprenewaltoaccountids.put(a.Renewal_Product__r.Renewal__c,a.Renewal_Product__r.Renewal__r.Account__c);
           }
         
         map<id,set<id>> mOpportunityIdToAccountIds = new Map<id,set<id>> ();
         map<id,set<id>> mRenewalIdToAccountIds = new Map<id,set<id>> ();
         Set<id> sAccountIds;
        
        if(maprenewaltoaccountids.size() ==0 && mapopptoaccountids.size() ==0)
            return; 
         
        System.debug('maprenewaltoaccountids='+maprenewaltoaccountids);
        System.debug('mapopptoaccountids='+mapopptoaccountids);
                    
        //Get all the relevant ACs for each Renewal, Opp.
        for(Active_Contract_Product__c acp:[Select a.Opportunity__c, a.Opportunity__r.AccountId, a.Renewal_Product__r.Renewal__c, 
        a.Renewal_Product__r.Renewal__r.Account__c, a.Active_Contract__c, a.Active_Contract__r.Account__c From Active_Contract_Product__c a
                where ( (a.Opportunity__c in: mapopptoaccountids.keySet() AND a.Opportunity__c <> null) OR (a.Renewal_Product__r.Renewal__c in : maprenewaltoaccountids.keySet() and a.Renewal_Product__r.Renewal__c <> null) ) 
              LIMIT 20000  ])
        {
            //if(acp.Active_Contract__r.Account__c <> acp.Opportunity__r.AccountId)
            {
                        sAccountIds = mOpportunityIdToAccountIds.get(acp.Opportunity__c); 
                        if(sAccountIds == null) sAccountIds = new Set<id>(); 
                        sAccountIds.add(acp.Active_Contract__r.Account__c);
                        mOpportunityIdToAccountIds.put(acp.Opportunity__c,sAccountIds);
            }
            //if(acp.Active_Contract__r.Account__c <> acp.Renewal_Product__r.Renewal__r.Account__c)
            {
                        
                        sAccountIds = mRenewalIdToAccountIds.get(acp.Renewal_Product__r.Renewal__c); 
                        if(sAccountIds == null) sAccountIds = new Set<id>(); 
                        sAccountIds.add(acp.Active_Contract__r.Account__c);
                        mRenewalIdToAccountIds.put(acp.Renewal_Product__r.Renewal__c,sAccountIds);
            }           
        }        
    
    
        List<Renewal__c> lstRenewals = new List<Renewal__c>();
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        
        //Verify if The Opportunities are really Eligible for updates, i.e. there is only one unique account associated to all their active contract products.
        for(id oppid: mOpportunityIdToAccountIds.keySet())
        {
            //Get All the Account Ids Associated with the Opportunity via different Active Contract Product> Active Contract > Account Ids
            sAccountIds = mOpportunityIdToAccountIds.get(oppid);
        
            if(sAccountIds <> null && sAccountIds.size() == 1) //If there is a unique Account
                for(id aid: sAccountIds) //this will execute only once 
                    lstOpportunity.add(new Opportunity(id=oppid,accountid=aid)); //Add to the list of Opps to be updated
        }
        //Verify if The Renewals are really Eligible for updates, i.e. there is only one unique account associated to all their active contract products.  
        for(id renid: mRenewalIdToAccountIds.keySet())
        {
            //Get All the Account Ids Associated with the Renewal via different Active Contract Product> Active Contract > Account Ids
            sAccountIds = mRenewalIdToAccountIds.get(renid);
            if(sAccountIds <> null && sAccountIds.size() == 1) //If via all the different active contracts we have one common Account
                for(id aid: sAccountIds) //this will execute only once
                     lstRenewals.add(new Renewal__c(id=renid, account__c = aid)); //Add to the list of renewals to be updated
        } 
        
        if(lstRenewals.size() > 0)
            Database.update(lstRenewals,false);
            
        if(lstOpportunity.size() > 0)
            Database.update(lstOpportunity,false);
        
       
    }
    
  
  //This Class would contain the AOCV Values to be added and Substracted  
   public class AOCV_OCV
   {
        public decimal ocv_new{get;set;}
        public decimal aocv_new{get;set;}
        public decimal ocv_old{get;set;}
        public decimal aocv_old{get;set;}
        
        
        public AOCV_OCV()
        {
            ocv_new =0;
            aocv_new =0;
            ocv_old =0;
            aocv_old =0;
        }
        
   } 
    
   /***************************
   Description: 1.When a new approved site comes in or an old site is approved, this updates the fields End_User_Site_Association__c, Sold_To_Site_Association__c,Ship_To_Site_Association__c and Account__c values on Active Contracts.
                2. Calls the function SyncRenewalAndOpportunities which will update the new account on relevant opportunities and renewals too, if all the active contracts associated to them point to the new account
   
   Created by  : Saba
   Created Date: 3/13/2012
   Called from : Apex Trigger  Renewal_UpdateAccount on Active_Contract__c
   Input Parameter: Map<id,Active_Contract__c> mOldMap = Trigger.OldMap of the calling Trigger , List<Active_Contract__c> lst = Trigger.New of the calling trigger
   Last Updated: 3/17/2012 
   **********/  
   public void UpdateAOCVandOCV(List<Active_Contract__c> lst, Map<id,Active_Contract__c> mOldMap)
   {
        Map<id,AOCV_OCV> mChangesInAOCV_OCV = new Map<id,AOCV_OCV>();  //MAP: Key= Account Id, Value = Class to store the old and new ocv and the aocv values which were associated to the affected accounts' active contracts 
        AOCV_OCV changedValues;
        
        for(Active_Contract__c ac:lst)
        {
            Active_Contract__c acold = new Active_Contract__c();
            //Get the old values active contract associated
            if(mOldMap <> null && mOldMap.get(ac.id) <> null)
                acold = mOldMap.get(ac.id);
            
            //Check if the AOCV, OCV values should be updated
            if(acold.Account__c <> ac.Account__c || acold.ocv__c <> ac.ocv__c || acold.aocv__c <> ac.aocv__c)
                {   
                    changedValues = mChangesInAOCV_OCV.get(ac.Account__c);
                    if(changedValues == null) changedValues = new AOCV_OCV();
                    changedValues.ocv_new += (ac.Calculated_OCV_USD__c != null? ac.Calculated_OCV_USD__c: 0);
                    changedValues.aocv_new +=(ac.Calculated_AOCV_USD__c != null? ac.Calculated_AOCV_USD__c: 0);
                    if(acold.Account__c <> ac.Account__c) //if the account old and new are different than the changes need to be tied to diff accounts
                    {
                        mChangesInAOCV_OCV.put(ac.Account__c,changedValues); //Add the id of the account for newer version of Active Contract, if the account has changed
                        changedValues = mChangesInAOCV_OCV.get(acold.Account__c);
                        if(changedValues == null) changedValues = new AOCV_OCV();
                    }
                    changedValues.ocv_old += ( acold != null && acold.Calculated_OCV_USD__c != null? acold.Calculated_OCV_USD__c: 0);
                    changedValues.aocv_old += ( acold != null && acold.Calculated_AOCV_USD__c != null? acold.Calculated_AOCV_USD__c: 0);
                    mChangesInAOCV_OCV.put(acold.Account__c,changedValues); //Add the id of the account for newer version of Active Contract, if the account has changed
                }
            //
        }
        
        if(mChangesInAOCV_OCV.keySet().size() == 0)
            return;
    
        List<Account> lstAcc = new List<Account>();
        for(Account a: [Select account.AOCV__c, account.OCV__c from Account where id in :mChangesInAOCV_OCV.keySet()])
            {
                if(a.OCV__c == null) a.ocv__c = 0;
                if(a.AOCV__c == null) a.aocv__c = 0;
                changedValues =     mChangesInAOCV_OCV.get(a.id);
                
                if(changedValues<> null)
                {
                    if(changedValues.ocv_new <> changedValues.ocv_old)
                    {
                    a.OCV__c += changedValues.ocv_new; //Add the new OCV Value
                    a.OCV__c -= changedValues.ocv_old; //Substract the old OCV Value
                    
                    }
                    if(changedValues.aocv_new <> changedValues.aocv_old)
                    {
                    a.AOCV__c += changedValues.aocv_new; //Add the new AOCV Value
                    a.AOCV__c -= changedValues.aocv_old; //Substract the old AOCV Value
                    }
                    
                    lstAcc.add(a);
                }
            }
            
       if(lstAcc.size() > 0)
                database.update(lstacc, false);
                
   } 
    
   /***************************
   Description: 1.When a new approved site comes in or an old site is approved, this updates the fields End_User_Site_Association__c, Sold_To_Site_Association__c,Ship_To_Site_Association__c and Account__c values on Active Contracts.
                2. Calls the function SyncRenewalAndOpportunities which will update the new account on relevant opportunities and renewals too, if all the active contracts associated to them point to the new account
   
   Created by  : Saba
   Created Date: 3/13/2012
   Called from : Apex Trigger  SiteAssociation_UpdateRenewals_PushToMDM_ai_au on Site_Association__c
   Input Parameter: Map<id,Site_Association__c> mOld = Trigger.OldMap of the calling Trigger ,  List<Site_Association__c> lstNewSites = Trigger.New of the calling trigger
   Last Updated: 3/17/2012 
   **********/
   public void updateRenewalsSiteAssociationsAccounts(Map<id,Site_Association__c> mOld,  List<Site_Association__c> lstNewSites)
   {
    
    List<Active_Contract__c> lstACSync = new List<Active_Contract__c>();
    List<Account> lstSMB = new List<Account>(); //For Storing the Site Association related SMB Accounts
    Set<string> setSMBSiteIDs = new Set<string>(); // for storing the Site Ids for SMBs
    Set<string> setSMBSystems = new Set<string>(); // for storing the source system S/T for SMBs
    Set<string> setAllSiteIDs = new Set<string>(); // for storing all the Site Ids 
    Set<string> setAllSystems = new Set<string>(); // for storing all the source system S/T
    Map<string,site_association__c> mapSiteIdSiteAssociationId = new Map<string,site_association__c>();// for storing the mapping of site id with site association id
    Map<string,id> mapSiteSMB = new Map<string,id>();// for storing the mapping of site id with account id for smb 
    for(Site_Association__c sa:lstNewSites)
    {
    if( ( mOld ==null && sa.Site_Status__c == 'Approved') || (mOld <> null && sa.Site_Status__c == 'Approved' && mOld.get(sa.id).Site_Status__c <> 'Approved' ) )
    {   
        if(sa.Enterprise_ID__c == null)
        {
            setSMBSiteIDs.add(sa.SAP_Site_ID__c);
            setSMBSystems.add(sa.System__c);
        }
            setAllSiteIDs.add(sa.SAP_Site_ID__c);
            setAllSystems.add(sa.System__c);
        mapSiteIdSiteAssociationId.put(sa.System__c + sa.SAP_Site_ID__c, sa);
        
    }     
    }
    
    //Below logic retrieves the SMB Account Ids for Site Associations not rolling up to any accounts
    if(setSMBSiteIDs.size() > 0)
        for(Account a:[Select id, commercial_id__c,SAP_TOPS_Site__c from Account where 
             commercial_id__c IN: setSMBSiteIDs AND SAP_TOPS_Site__c IN:setSMBSystems])
             {
               mapSiteSMB.put( a.SAP_TOPS_Site__c + a.commercial_id__c, a.id);
             }
 
    List<Active_Contract__c> lstactivecontract = [Select Name, id, SAP_Tops__c,Account__c,
    End_User_ID__c, End_User_Site_Association__c, 
    Ship_To_ID__c, Ship_To_Site_Association__c,
    Sold_To_ID__c, Sold_To_Site_Association__c from Active_Contract__c where 
    SAP_Tops__c in : setAllSystems AND 
    ( ( End_User_ID__c in: setAllSiteIDs AND End_User_Site_Association__c = NULL) OR
      (Ship_To_ID__c in: setAllSiteIDs AND Ship_To_Site_Association__c = NULL) OR
      (Sold_To_ID__c in: setAllSiteIDs AND Sold_To_Site_Association__c = NULL) )   
    ];
    
    Id AccountId;
    
    for(Active_Contract__c activecontract: lstactivecontract)
    {
        if(mapSiteIdSiteAssociationId.keySet().contains(activecontract.SAP_Tops__c + activecontract.End_User_ID__c))
        {
                activecontract.End_User_Site_Association__c = mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.End_User_ID__c).id;
        } 
        
        if(mapSiteIdSiteAssociationId.keySet().contains(activecontract.SAP_Tops__c + activecontract.Ship_To_ID__c))
        {
                activecontract.Ship_To_Site_Association__c = mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.Ship_To_ID__c).id;
        } 
        
        if(mapSiteIdSiteAssociationId.keySet().contains(activecontract.SAP_Tops__c + activecontract.Sold_To_ID__c))
        {
                activecontract.Sold_To_Site_Association__c = mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.Sold_To_ID__c).id;
        }    
       
        AccountId = null;    
        if(activecontract.End_User_Site_Association__c <> null)
          {  
             if(mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.End_User_ID__c) <> null) 
                  AccountId =mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.End_User_ID__c).Enterprise_ID__c;
             if(AccountId == null) //An SMB Account may be the End User
                   AccountId = mapSiteSMB.get(activecontract.SAP_Tops__c + activecontract.End_User_ID__c);
          }    
        else if (activecontract.name.contains('indirect') && activecontract.Ship_To_Site_Association__c <> null)
          { 
             if(mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.Ship_To_ID__c) <> null) 
                 AccountId =mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.Ship_To_ID__c).Enterprise_ID__c;        
             if(AccountId == null) //An SMB Account may be the Ship To
                    AccountId = mapSiteSMB.get(activecontract.SAP_Tops__c + activecontract.Ship_To_ID__c);
          }
        else if(activecontract.Sold_To_Site_Association__c <> null)
          {  
            if(mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.Sold_To_ID__c) <> null)
                    AccountId =mapSiteIdSiteAssociationId.get(activecontract.SAP_Tops__c + activecontract.Sold_To_ID__c).Enterprise_ID__c;                
              if(AccountId == null) //An SMB Account may be the Sold To
                    AccountId = mapSiteSMB.get(activecontract.SAP_Tops__c + activecontract.sold_To_ID__c);
          }
        
        if(accountid <> null && accountid <> activecontract.account__c )
            {
                activecontract.account__c = accountid;
                lstACSync.add(activecontract);
            }
        
        }
      
      database.update(lstactivecontract);
            
    //Upadate the account on renewal and opportunity - start
    if(lstACSync.size()> 0)
        SyncRenewalAndOpportunities(lstACSync);
    //end
   }//// end function
   public static testMethod void SyncRenewalAndOpportunitiesTest()
     {

        Renewals_Util  Obj = new Renewals_Util();
        List<Active_Contract__c> AcLst= [Select  id, Calculated_OCV_USD__c , Calculated_AOCV_USD__c,Account__c,OCV__c,AOCV__c , Segmentation__c ,ATTRF_CRV_Val__c ,GSA_Pricing__c From Active_Contract__c limit 10 ];
        Set<Id> acc = new Set<Id>();
        Set<Decimal> ocv= new Set<Decimal>();
        for(Active_Contract__c a: AcLst){
          acc.add(a.Account__c);
          ocv.add(a.ocv__c);
        }
        Map<id,Active_Contract__c> oldMap = new Map<id,Active_Contract__c>([ Select id, Calculated_OCV_USD__c , Calculated_AOCV_USD__c,Account__c,OCV__c,AOCV__c , Segmentation__c ,ATTRF_CRV_Val__c ,GSA_Pricing__c From Active_Contract__c Where Account__c not in: acc and ocv__c not in: ocv limit 10  ]); 
        Map<id,AOCV_OCV> mChangesInAOCV_OCV = new Map<id,AOCV_OCV>();  //MAP: Key= Account Id, Value = Class to store the old and new ocv and the aocv values which were associated to the affected accounts' active contracts 
        AOCV_OCV changedValues;
        
        
        
        //updateRenewalsSiteAssociationsAccounts
        Map<id,Site_Association__c> mOld = new Map<id,Site_Association__c>();
        List<Site_Association__c> lst = [ Select id , Site_Status__c , Enterprise_ID__c ,SAP_Site_ID__c ,System__c from Site_Association__c where Site_Status__c = 'Approved' and Enterprise_ID__c= null limit 10];
        
        for(Site_Association__c ls : lst)
        {
            mOld.put(ls.id,ls );
        }
        
        
        Test.startTest();
        Obj.SyncRenewalAndOpportunities(AcLst);
        Obj.UpdateAOCVandOCV(AcLst,oldMap  );
         
        
        obj.updateRenewalsSiteAssociationsAccounts(mOld,lst );
        Renewals_Util.AOCV_OCV obj1 = new Renewals_Util.AOCV_OCV();
        Test.stopTest();

      }
   
}