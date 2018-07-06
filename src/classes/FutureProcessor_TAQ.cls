/*
Author :Saba 
Project: FY12

Objective: This class has a future method UpdateTAQAccountAESEPMFKeys which takes 2 lists of PMFKeys and their Correesponding AESE PMFKeys as parameters
It searches all the TAQ Accounts which have these PMFKeys on their Team and then Updates the corresponding AE/SE or SSE keys

*/

public class FutureProcessor_TAQ{
 public static boolean skiptriggers = false; //Variable to Skip running TAQ Account when they are being updated for AE/SE and SSE fields in this class in future context
    public static boolean skiporgtriggers = false; //Variable to Skip TAQ Org Triggers


  }
//FY13 - Code Removed
/*
public class FutureProcessor_TAQ{  
    public static boolean skiptriggers = false; //Variable to Skip running TAQ Account when they are being updated for AE/SE and SSE fields in this class in future context
    public static boolean skiporgtriggers = false; //Variable to Skip TAQ Org Triggers

     //CRM sprint 4 - Open Position Id Update - Start 
    public static void UpdatePositionIdOfAccounts(Map<id,string> mapOrg)
    {
            Map<string,string> mapOldNewPositionId = new Map<string,string>();
            for(Taq_Organization_Approved__c taa: [Select id, Position_Id__c, TAQ_Organization__c from TAQ_Organization_Approved__c 
                where TAQ_Organization__c in :mapOrg.keyset() and Is_Latest_Record__c=true])
            {
                   string oldpos= taa.Position_Id__c;
                   if(oldpos <> null)
                        oldpos= oldpos.ToUpperCase();
   
                   string newpos= mapOrg.get(taa.TAQ_Organization__c);
                  
                   if(newpos <> null)
                        newpos= newpos.ToUpperCase();

                    if(oldpos <> newpos)
                        mapOldNewPositionId.put(oldpos, newpos);
                   
                   
                    system.debug('>>>>>++++++' + mapOldNewPositionId);
            }
            
            if(mapOldNewPositionId.keyset().size() > 0)
            {
                Integer LimitUpdateRecords = Limits.getLimitDMLRows() - Limits.getDMLRows();
                List<TAQ_Account__c> lstTa = 
                [Select Account_Owner_Manager_PMFKey__c , Account_Owner_PMF_Key__c , AE_PMFKey__c , CPM_PMFKey__c , CSA_Manager_PMFKey__c , CSA_PMF_key__c , CST_CSA_PMFKey__c ,
                SAM_PMFKey__c , GAD_AD_PMFKey__c , GPS_Manager_PMFKey__c , GPS_PMFKey__c , GSP_Account_Owner_PMF_Key__c , GSP_APJ_AD1_PMFKey__c , GSP_Area_Mgr_PMFKey__c ,
                GSP_CPM_MGR_PMFKey__c , GSP_CSA1_PMFKey__c , GSP_CSA2_PMFKey__c , GSP_EMEA_AD1_PMFKey__c , GSP_EMEA_AD2_PMFKey__c , GSP_EMEA_AD3_PMFKey__c , GSP_EMEA_CSA_PMFKey__c , GSP_LA_AD1_PMFKey__c , GSP_NA_AD1_PMFKey__c , GSP_NA_AD2_PMFKey__c , GSP_NA_AD3_PMFKey__c , GSP_NA_CPM_PMFKey__c , GSP_NA_CSA_PMFKey__c , GSP_NA_SS_SA1_PMFKey__c , GSP_NA_SS_SA2_PMFKey__c , GSP_NA_SS_SA_Mgr1_PMFKey__c , GSP_NA_SS_SA_Mgr2_PMFKey__c , Reseller_Account_Director_PMFKey__c , Regional_Alliance_Director_PMF_Key__c , Sales_Director_Manager_PMFKey__c , Sales_Director_PMF_Key__c ,
                SAM_Manager_PMFKey__c , SSE_MF_PMFKey__c , SSE_PPM_PMFKey__c , SSE_SA_PMFKey__c , SSE_SEC_PMFKey__c , SSE_VSA_PMFKey__c , SS_MF_Manager_PMFKey__c ,
                SS_MF_PMFKey__c , SS_PPM_Manager_PMFKey__c , SS_PPM_PMFKey__c , SS_SA_Manager_PMFKey__c , SS_SA_PMFKey__c , SS_SEC_Manager_PMFKey__c ,
                SS_SEC_PMFKey__c , SS_VSA_Manager_PMFKey__c , SS_VSA_PMFKey__c , MSP_Account_Owner__c From TAQ_Account__c
                where 
                SS_VSA_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR Account_Owner_PMF_Key__c in  : mapOldNewPositionId.keyset() 
                OR  Account_Owner_Manager_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR Sales_Director_PMF_Key__c in : mapOldNewPositionId.keyset()
                OR Sales_Director_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_VSA_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SEC_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SEC_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SA_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SA_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_PPM_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_PPM_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_MF_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_MF_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_VSA_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_SEC_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_SA_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_PPM_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_MF_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SAM_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SAM_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR Reseller_Account_Director_PMFKey__c in : mapOldNewPositionId.keyset()
                OR Regional_Alliance_Director_PMF_Key__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA_Mgr2_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA_Mgr1_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR CPM_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR  AE_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA2_PMFKey__c in : mapOldNewPositionId.keyset()    
                OR GSP_APJ_AD1_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GPS_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GPS_Manager_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR CSA_PMF_key__c in : mapOldNewPositionId.keyset()  
                OR CSA_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA1_PMFKey__c in : mapOldNewPositionId.keyset()    
                OR GSP_CSA1_PMFKey__c in : mapOldNewPositionId.keyset()   
                OR GSP_CPM_MGR_PMFKey__c in : mapOldNewPositionId.keyset()   
                OR  GSP_Area_Mgr_PMFKey__c in : mapOldNewPositionId.keyset()   
                OR GSP_Account_Owner_PMF_Key__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_CSA_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_CSA_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_AD3_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_AD2_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_AD1_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR GSP_CSA2_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_CPM_PMFKey__c in : mapOldNewPositionId.keyset()       
                OR GSP_NA_AD3_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_NA_AD2_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_NA_AD1_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_LA_AD1_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR CST_CSA_PMFKey__c in :  mapOldNewPositionId.keyset() 
                OR GAD_AD_PMFKey__c in :  mapOldNewPositionId.keyset() 
                OR MSP_Account_Owner__c in :  mapOldNewPositionId.keyset() 
                Limit 10000];
                if(lstTa.size() > 0)
                   { if(lstTa.size() > LimitUpdateRecords + 20) //Kept 10 additional Record Bandwidth 
                        {
                            FutureUpdatePositionId(mapOldNewPositionId);
                        }
                        else
                        {
                            FutureProcessor_TAQ.skiptriggers = true;
                            UpdatePositionId(mapOldNewPositionId,lstTa);
                        }
                    }    
   
            }


    }

    //Common function for Realtime and Future
    public static void UpdatePositionId(Map<string,string> mapOldNewPositionId, List<TAQ_Account__c> lstTa)
    {
            for(TAQ_Account__c ta: lstTa)
                    {
                        if(ta.Account_Owner_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.Account_Owner_Manager_PMFKey__c.toUpperCase())){ta.Account_Owner_Manager_PMFKey__c= mapOldNewPositionId.get(ta.Account_Owner_Manager_PMFKey__c.toUpperCase());}
                        if(ta.Account_Owner_PMF_Key__c <> null && mapOldNewPositionId.keyset().contains(ta.Account_Owner_PMF_Key__c.toUpperCase())){ta.Account_Owner_PMF_Key__c= mapOldNewPositionId.get(ta.Account_Owner_PMF_Key__c.toUpperCase());}
                        if(ta.AE_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.AE_PMFKey__c.toUpperCase())){ta.AE_PMFKey__c= mapOldNewPositionId.get(ta.AE_PMFKey__c.toUpperCase());}
                        if(ta.CPM_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.CPM_PMFKey__c.toUpperCase())){ta.CPM_PMFKey__c= mapOldNewPositionId.get(ta.CPM_PMFKey__c.toUpperCase());}
                        if(ta.CSA_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.CSA_Manager_PMFKey__c.toUpperCase())){ta.CSA_Manager_PMFKey__c= mapOldNewPositionId.get(ta.CSA_Manager_PMFKey__c.toUpperCase());}
                        if(ta.CSA_PMF_key__c <> null && mapOldNewPositionId.keyset().contains(ta.CSA_PMF_key__c.toUpperCase())){ta.CSA_PMF_key__c= mapOldNewPositionId.get(ta.CSA_PMF_key__c.toUpperCase());}
                        if(ta.CST_CSA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.CST_CSA_PMFKey__c.toUpperCase())){ta.CST_CSA_PMFKey__c= mapOldNewPositionId.get(ta.CST_CSA_PMFKey__c.toUpperCase());}
                        if(ta.SAM_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SAM_PMFKey__c.toUpperCase())){ta.SAM_PMFKey__c= mapOldNewPositionId.get(ta.SAM_PMFKey__c.toUpperCase());}
                        if(ta.GAD_AD_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GAD_AD_PMFKey__c.toUpperCase())){ta.GAD_AD_PMFKey__c= mapOldNewPositionId.get(ta.GAD_AD_PMFKey__c.toUpperCase());}
                        if(ta.GPS_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GPS_Manager_PMFKey__c.toUpperCase())){ta.GPS_Manager_PMFKey__c= mapOldNewPositionId.get(ta.GPS_Manager_PMFKey__c.toUpperCase());}
                        if(ta.GPS_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GPS_PMFKey__c.toUpperCase())){ta.GPS_PMFKey__c= mapOldNewPositionId.get(ta.GPS_PMFKey__c.toUpperCase());}
                        if(ta.GSP_Account_Owner_PMF_Key__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_Account_Owner_PMF_Key__c.toUpperCase())){ta.GSP_Account_Owner_PMF_Key__c= mapOldNewPositionId.get(ta.GSP_Account_Owner_PMF_Key__c.toUpperCase());}
                        if(ta.GSP_APJ_AD1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_APJ_AD1_PMFKey__c.toUpperCase())){ta.GSP_APJ_AD1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_APJ_AD1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_Area_Mgr_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_Area_Mgr_PMFKey__c.toUpperCase())){ta.GSP_Area_Mgr_PMFKey__c= mapOldNewPositionId.get(ta.GSP_Area_Mgr_PMFKey__c.toUpperCase());}
                        if(ta.GSP_CPM_MGR_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_CPM_MGR_PMFKey__c.toUpperCase())){ta.GSP_CPM_MGR_PMFKey__c= mapOldNewPositionId.get(ta.GSP_CPM_MGR_PMFKey__c.toUpperCase());}
                        if(ta.GSP_CSA1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_CSA1_PMFKey__c.toUpperCase())){ta.GSP_CSA1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_CSA1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_CSA2_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_CSA2_PMFKey__c.toUpperCase())){ta.GSP_CSA2_PMFKey__c= mapOldNewPositionId.get(ta.GSP_CSA2_PMFKey__c.toUpperCase());}
                        if(ta.GSP_EMEA_AD1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_EMEA_AD1_PMFKey__c.toUpperCase())){ta.GSP_EMEA_AD1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_EMEA_AD1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_EMEA_AD2_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_EMEA_AD2_PMFKey__c.toUpperCase())){ta.GSP_EMEA_AD2_PMFKey__c= mapOldNewPositionId.get(ta.GSP_EMEA_AD2_PMFKey__c.toUpperCase());}
                        if(ta.GSP_EMEA_AD3_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_EMEA_AD3_PMFKey__c.toUpperCase())){ta.GSP_EMEA_AD3_PMFKey__c= mapOldNewPositionId.get(ta.GSP_EMEA_AD3_PMFKey__c.toUpperCase());}
                        if(ta.GSP_EMEA_CSA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_EMEA_CSA_PMFKey__c.toUpperCase())){ta.GSP_EMEA_CSA_PMFKey__c= mapOldNewPositionId.get(ta.GSP_EMEA_CSA_PMFKey__c.toUpperCase());}
                        if(ta.GSP_LA_AD1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_LA_AD1_PMFKey__c.toUpperCase())){ta.GSP_LA_AD1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_LA_AD1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_AD1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_AD1_PMFKey__c.toUpperCase())){ta.GSP_NA_AD1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_AD1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_AD2_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_AD2_PMFKey__c.toUpperCase())){ta.GSP_NA_AD2_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_AD2_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_AD3_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_AD3_PMFKey__c.toUpperCase())){ta.GSP_NA_AD3_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_AD3_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_CPM_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_CPM_PMFKey__c.toUpperCase())){ta.GSP_NA_CPM_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_CPM_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_CSA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_CSA_PMFKey__c.toUpperCase())){ta.GSP_NA_CSA_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_CSA_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_SS_SA1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_SS_SA1_PMFKey__c.toUpperCase())){ta.GSP_NA_SS_SA1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_SS_SA1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_SS_SA2_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_SS_SA2_PMFKey__c.toUpperCase())){ta.GSP_NA_SS_SA2_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_SS_SA2_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_SS_SA_Mgr1_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_SS_SA_Mgr1_PMFKey__c.toUpperCase())){ta.GSP_NA_SS_SA_Mgr1_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_SS_SA_Mgr1_PMFKey__c.toUpperCase());}
                        if(ta.GSP_NA_SS_SA_Mgr2_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.GSP_NA_SS_SA_Mgr2_PMFKey__c.toUpperCase())){ta.GSP_NA_SS_SA_Mgr2_PMFKey__c= mapOldNewPositionId.get(ta.GSP_NA_SS_SA_Mgr2_PMFKey__c.toUpperCase());}
                        if(ta.Reseller_Account_Director_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.Reseller_Account_Director_PMFKey__c.toUpperCase())){ta.Reseller_Account_Director_PMFKey__c= mapOldNewPositionId.get(ta.Reseller_Account_Director_PMFKey__c.toUpperCase());}
                        if(ta.Regional_Alliance_Director_PMF_Key__c <> null && mapOldNewPositionId.keyset().contains(ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase())){ta.Regional_Alliance_Director_PMF_Key__c= mapOldNewPositionId.get(ta.Regional_Alliance_Director_PMF_Key__c.toUpperCase());}
                        if(ta.Sales_Director_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.Sales_Director_Manager_PMFKey__c.toUpperCase())){ta.Sales_Director_Manager_PMFKey__c= mapOldNewPositionId.get(ta.Sales_Director_Manager_PMFKey__c.toUpperCase());}
                        if(ta.Sales_Director_PMF_Key__c <> null && mapOldNewPositionId.keyset().contains(ta.Sales_Director_PMF_Key__c.toUpperCase())){ta.Sales_Director_PMF_Key__c= mapOldNewPositionId.get(ta.Sales_Director_PMF_Key__c.toUpperCase());}
                        if(ta.SAM_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SAM_Manager_PMFKey__c.toUpperCase())){ta.SAM_Manager_PMFKey__c= mapOldNewPositionId.get(ta.SAM_Manager_PMFKey__c.toUpperCase());}
                        if(ta.SSE_MF_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SSE_MF_PMFKey__c.toUpperCase())){ta.SSE_MF_PMFKey__c= mapOldNewPositionId.get(ta.SSE_MF_PMFKey__c.toUpperCase());}
                        if(ta.SSE_PPM_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SSE_PPM_PMFKey__c.toUpperCase())){ta.SSE_PPM_PMFKey__c= mapOldNewPositionId.get(ta.SSE_PPM_PMFKey__c.toUpperCase());}
                        if(ta.SSE_SA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SSE_SA_PMFKey__c.toUpperCase())){ta.SSE_SA_PMFKey__c= mapOldNewPositionId.get(ta.SSE_SA_PMFKey__c.toUpperCase());}
                        if(ta.SSE_SEC_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SSE_SEC_PMFKey__c.toUpperCase())){ta.SSE_SEC_PMFKey__c= mapOldNewPositionId.get(ta.SSE_SEC_PMFKey__c.toUpperCase());}
                        if(ta.SSE_VSA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SSE_VSA_PMFKey__c.toUpperCase())){ta.SSE_VSA_PMFKey__c= mapOldNewPositionId.get(ta.SSE_VSA_PMFKey__c.toUpperCase());}
                        if(ta.SS_MF_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_MF_Manager_PMFKey__c.toUpperCase())){ta.SS_MF_Manager_PMFKey__c= mapOldNewPositionId.get(ta.SS_MF_Manager_PMFKey__c.toUpperCase());}
                        if(ta.SS_MF_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_MF_PMFKey__c.toUpperCase())){ta.SS_MF_PMFKey__c= mapOldNewPositionId.get(ta.SS_MF_PMFKey__c.toUpperCase());}
                        if(ta.SS_PPM_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_PPM_Manager_PMFKey__c.toUpperCase())){ta.SS_PPM_Manager_PMFKey__c= mapOldNewPositionId.get(ta.SS_PPM_Manager_PMFKey__c.toUpperCase());}
                        if(ta.SS_PPM_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_PPM_PMFKey__c.toUpperCase())){ta.SS_PPM_PMFKey__c= mapOldNewPositionId.get(ta.SS_PPM_PMFKey__c.toUpperCase());}
                        if(ta.SS_SA_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_SA_Manager_PMFKey__c.toUpperCase())){ta.SS_SA_Manager_PMFKey__c= mapOldNewPositionId.get(ta.SS_SA_Manager_PMFKey__c.toUpperCase());}
                        if(ta.SS_SA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_SA_PMFKey__c.toUpperCase())){ta.SS_SA_PMFKey__c= mapOldNewPositionId.get(ta.SS_SA_PMFKey__c.toUpperCase());}
                        if(ta.SS_SEC_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_SEC_Manager_PMFKey__c.toUpperCase())){ta.SS_SEC_Manager_PMFKey__c= mapOldNewPositionId.get(ta.SS_SEC_Manager_PMFKey__c.toUpperCase());}
                        if(ta.SS_SEC_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_SEC_PMFKey__c.toUpperCase())){ta.SS_SEC_PMFKey__c= mapOldNewPositionId.get(ta.SS_SEC_PMFKey__c.toUpperCase());}
                        if(ta.SS_VSA_Manager_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_VSA_Manager_PMFKey__c.toUpperCase())){ta.SS_VSA_Manager_PMFKey__c= mapOldNewPositionId.get(ta.SS_VSA_Manager_PMFKey__c.toUpperCase());}
                        if(ta.SS_VSA_PMFKey__c <> null && mapOldNewPositionId.keyset().contains(ta.SS_VSA_PMFKey__c.toUpperCase())){ta.SS_VSA_PMFKey__c= mapOldNewPositionId.get(ta.SS_VSA_PMFKey__c.toUpperCase());}
                        if(ta.MSP_Account_Owner__c <> null && mapOldNewPositionId.keyset().contains(ta.MSP_Account_Owner__c.toUpperCase())){ta.MSP_Account_Owner__c= mapOldNewPositionId.get(ta.MSP_Account_Owner__c.toUpperCase());}

                   }
                   update lstTa;
                   
                   CA_TAQ_AddTeamMem atm = new CA_TAQ_AddTeamMem();
                   system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                   system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+ lstTa[0].Approval_Status__c);
                   
                   for(TAQ_Account__c ta:lstTa)
                       if(ta.Approval_Status__c == 'Approved')
                          atm.copyAccRecords(ta);
    }

    @future
    public static void FutureUpdatePositionId(Map<string,string> mapOldNewPositionId)
    {
                SystemIdUtility.isFutureUpdate = true;
                FutureProcessor_TAQ.skiptriggers = true;
                Integer LimitUpdateRecords = Limits.getLimitDMLRows() - Limits.getDMLRows();
                List<TAQ_Account__c> lstTa = 
                [Select Account_Owner_Manager_PMFKey__c , Account_Owner_PMF_Key__c , AE_PMFKey__c , CPM_PMFKey__c , CSA_Manager_PMFKey__c , CSA_PMF_key__c , CST_CSA_PMFKey__c ,
                SAM_PMFKey__c , GAD_AD_PMFKey__c , GPS_Manager_PMFKey__c , GPS_PMFKey__c , GSP_Account_Owner_PMF_Key__c , GSP_APJ_AD1_PMFKey__c , GSP_Area_Mgr_PMFKey__c ,
                GSP_CPM_MGR_PMFKey__c , GSP_CSA1_PMFKey__c , GSP_CSA2_PMFKey__c , GSP_EMEA_AD1_PMFKey__c , GSP_EMEA_AD2_PMFKey__c , GSP_EMEA_AD3_PMFKey__c , GSP_EMEA_CSA_PMFKey__c , GSP_LA_AD1_PMFKey__c , GSP_NA_AD1_PMFKey__c , GSP_NA_AD2_PMFKey__c , GSP_NA_AD3_PMFKey__c , GSP_NA_CPM_PMFKey__c , GSP_NA_CSA_PMFKey__c , GSP_NA_SS_SA1_PMFKey__c , GSP_NA_SS_SA2_PMFKey__c , GSP_NA_SS_SA_Mgr1_PMFKey__c , GSP_NA_SS_SA_Mgr2_PMFKey__c , Reseller_Account_Director_PMFKey__c , Regional_Alliance_Director_PMF_Key__c , Sales_Director_Manager_PMFKey__c , Sales_Director_PMF_Key__c ,
                SAM_Manager_PMFKey__c , SSE_MF_PMFKey__c , SSE_PPM_PMFKey__c , SSE_SA_PMFKey__c , SSE_SEC_PMFKey__c , SSE_VSA_PMFKey__c , SS_MF_Manager_PMFKey__c ,
                SS_MF_PMFKey__c , SS_PPM_Manager_PMFKey__c , SS_PPM_PMFKey__c , SS_SA_Manager_PMFKey__c , SS_SA_PMFKey__c , SS_SEC_Manager_PMFKey__c ,
                SS_SEC_PMFKey__c , SS_VSA_Manager_PMFKey__c , SS_VSA_PMFKey__c , MSP_Account_Owner__c From TAQ_Account__c 
                where SS_VSA_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR Account_Owner_PMF_Key__c in  : mapOldNewPositionId.keyset() 
                OR  Account_Owner_Manager_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR Sales_Director_PMF_Key__c in : mapOldNewPositionId.keyset()
                OR Sales_Director_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_VSA_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SEC_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SEC_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SA_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_SA_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_PPM_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_PPM_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_MF_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SS_MF_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_VSA_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_SEC_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_SA_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_PPM_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SSE_MF_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SAM_PMFKey__c in : mapOldNewPositionId.keyset()
                OR SAM_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR Reseller_Account_Director_PMFKey__c in : mapOldNewPositionId.keyset()
                OR Regional_Alliance_Director_PMF_Key__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA_Mgr2_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA_Mgr1_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR CPM_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR  AE_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA2_PMFKey__c in : mapOldNewPositionId.keyset()    
                OR GSP_APJ_AD1_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GPS_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GPS_Manager_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR CSA_PMF_key__c in : mapOldNewPositionId.keyset()  
                OR CSA_Manager_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_SS_SA1_PMFKey__c in : mapOldNewPositionId.keyset()    
                OR GSP_CSA1_PMFKey__c in : mapOldNewPositionId.keyset()   
                OR GSP_CPM_MGR_PMFKey__c in : mapOldNewPositionId.keyset()   
                OR  GSP_Area_Mgr_PMFKey__c in : mapOldNewPositionId.keyset()   
                OR GSP_Account_Owner_PMF_Key__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_CSA_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_CSA_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_AD3_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_AD2_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_EMEA_AD1_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR GSP_CSA2_PMFKey__c in : mapOldNewPositionId.keyset()
                OR GSP_NA_CPM_PMFKey__c in : mapOldNewPositionId.keyset()       
                OR GSP_NA_AD3_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_NA_AD2_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_NA_AD1_PMFKey__c in : mapOldNewPositionId.keyset()  
                OR GSP_LA_AD1_PMFKey__c in : mapOldNewPositionId.keyset() 
                OR CST_CSA_PMFKey__c in :  mapOldNewPositionId.keyset() 
                OR GAD_AD_PMFKey__c in :  mapOldNewPositionId.keyset() 
                OR MSP_Account_Owner__c in :  mapOldNewPositionId.keyset()
                Limit : LimitUpdateRecords];
 
                UpdatePositionId(mapOldNewPositionId,lstTa);
                
    }
    
    //CRM sprint 4 - Open Position Id Update - End
    @future     
    public static void UpdateSubordinate(Map<string,string> PMFPositionIdmap,Map<string,Date> PMFDatemap, Map<string,string> PMFNameMap)    
    {   
        set<string> pmfkys = PMFPositionIdmap.keyset();
        
        FutureProcessor_TAQ.skiporgtriggers = true;
        
        SystemIdUtility.isFutureUpdate = true;
        TAQ_Organization__c[] ta_orig;
        List<TAQ_Organization__c> taUpdate = new List<TAQ_Organization__c>();
        List<TAQ_Organization__c> tas = new List<TAQ_Organization__c>();
  
        if(pmfkys.size()>0){
             ta_orig = [Select t.Weighted_IC__c, t.Weighted_IC_USD__c, t.Weighted_IC_PNCV__c, 
             t.Total_Amount_in_Dollars__c, t.Territory__c, t.Territory_For_Data_Load__c, t.TAQ_Plan_ID__c, 
             t.SystemModstamp, t.Standard_Flat_Rate__c, t.Role__c, t.Role_Effective_Date__c, t.Reporting_Annual_IC__c, 
             t.Region__c, t.Record_Type_for_Data_Load__c, t.Record_Sent_To_Approver__c, t.RecordTypeId, 
             t.Reason_for_Rejection__c, t.Quota_Currency__c, t.Quota_Currency_For_Data_Load__c, t.Quota_Carrier__c, 
             t.Quota_3_Service_USD__c, t.Quota_2_Service_USD__c, t.Quota_2_PNCV_ENCV__c, t.Quota_1_Service_USD__c, 
             t.Quota_1_Product_USD__c, t.Quota_1_Education_USD__c, t.Quota5_Type__c, t.Quota5_Territory_Country__c, 
             t.Quota5_BU__c, t.Quota5_Amount__c, t.Quota4_Type__c, t.Quota4_Territory_Country__c, t.Quota4_BU__c, 
             t.Quota4_Amount__c, t.Quota3_Type__c, t.Quota3_Territory_Country__c, t.Quota3_Territory_Country_F__c, 
             t.Quota3_Territory_And_Country__c, t.Quota3_SNCV__c, t.Quota3_PNCV_ENCV__c, t.Quota3_Other__c, t.Quota3_Other_USD__c, 
             t.Quota3_Mainframe_Time__c, t.Quota3_Mainframe_Time_USD__c, t.Quota3_Mainframe_Capacity__c, 
             t.Quota3_Mainframe_Capacity_USD__c, t.Quota3_Education__c, t.Quota3_Education_USD__c, t.Quota3_BU__c, 
             t.Quota3_Amount_in_dollars__c, t.Quota3_Amount__c, t.Quota2_amount_in_dollars__c, t.Quota2_Type__c,
             t.Quota2_Territory_Country__c, t.Quota2_Territory_Country_F__c, t.Quota2_Territory_And_Country__c, 
             t.Quota2_SNCV__c, t.Quota2_Other__c, t.Quota2_Other_USD__c, t.Quota2_Mainframe_Time__c, 
             t.Quota2_Mainframe_Time_USD__c, t.Quota2_Mainframe_Capacity__c, t.Quota2_Mainframe_Capacity_USD__c, 
             t.Quota2_Education_USD__c, t.Quota2_ENCV__c, t.Quota2_BU__c, t.Quota2_Amount__c, t.Quota1_Type__c, 
             t.Quota1_Territory_Country__c, t.Quota1_Territory_Country_F__c, t.Quota1_Territory_And_Country__c, 
             t.Quota1_SNCV__c, t.Quota1_PNCV__c, t.Quota1_Other__c, t.Quota1_Other_USD__c, t.Quota1_Mainframe_Time__c, 
             t.Quota1_Mainframe_Time_USD__c, t.Quota1_Mainframe_Capacity__c, t.Quota1_Mainframe_Capacity_USD__c, 
             t.Quota1_ENCV__c, t.Quota1_BU__c, t.Quota1_Amount_in_dollars__c, t.Quota1_Amount__c, t.Process_Step__c, 
             t.Position_Id__c, t.Position_ID_Status__c, t.Plantype_Delimited_Date__c, t.Plan_Type__c, t.Plan_Reset__c, 
             t.PlanType_Effective_Date__c, t.PMFKey__c, t.OwnerId, t.Overlay3_Code__c, t.Overlay2_Code__c, t.Overlay1_Code__c, 
             t.Organization_for_Data_Load__c, t.Organization__c, t.Org_Type__c, t.Non_Standard_Flat_Rate__c, t.Name, 
             t.Market_for_Data_Load__c, t.Market__c, t.Market_Focus_Area__c, t.Manager_PMF_Key__c, t.Manager_Name__c, 
             t.Manager_Effective_Date__c, t.Last_Approved_Date_Time__c, t.LastModifiedDate, t.LastModifiedById, t.LastActivityDate, 
             t.Job_Title_For_Data_Load__c, t.JobTitle__c, t.JobCode__c, t.Is_Terminated__c, t.Is_Error_in_Rule__c, t.IsDeleted, 
             t.Id, t.IS_CSU_Subscriptions__c, t.IC_Currency__c, t.IC_Currency_For_Data_Load__c, t.IC_Amount__c, t.Employee_Status__c, 
             t.Employee_Status_Date__c, t.Employee_Name__c, t.Distribute_Plan__c, t.CurrencyIsoCode, t.CreatedDate, t.CreatedById, 
             t.Country_for_Data_Load__c, t.Country__c, t.Cost_Center_Number__c, t.Cost_Center_Desc__c, t.Cost_Center_Desc_For_Data_Load__c, 
             t.Constant_Scale__c, t.Comments__c, t.Business_Unit__c, t.Area_for_Data_Load__c, t.Area__c, t.Approval_Status__c, 
             t.Approval_Process_Status__c, t.AE_SE_PMFKey__c From TAQ_Organization__c t
             WHERE
              (Manager_PMF_Key__c in: pmfkys)
              AND
               Process_Step__c <> 'Term / Transfer'
               ];
        }
        
   Date dt;
        
    if(ta_orig!=null && ta_orig.size()>0){
    
       for(Integer j=0;j<ta_orig.size();j++)
       {
           dt = PMFDatemap.get(ta_orig[j].Manager_PMF_Key__c.toUpperCase());
           if(dt <> null && dt.day() <> 1)
               dt = dt.toStartOfMonth().addMonths(1);
          ta_orig[j].Manager_Effective_Date__c = dt;
          ta_orig[j].Manager_Name__c  = PMFNameMap.get(ta_orig[j].Manager_PMF_Key__c.toUpperCase()); //'Open_' + ta_orig[j].Manager_PMF_Key__c;
          ta_orig[j].Manager_PMF_Key__c=PMFPositionIdmap.get(ta_orig[j].Manager_PMF_Key__c.toUpperCase());
          taUpdate.add(ta_orig[j]);
       }
       
       if(taUpdate.size() > 0)
       {   
       
           Database.SaveResult[] lsr = database.update(taUpdate,false); 
           integer j = 0;
           Set<id> taqIds = new Set<id>();
 
           for(Database.SaveResult sr:lsr)
           {
               if(sr.isSuccess() &&  (taUpdate[j].Approval_process_status__c <> 'Send For Approval') && (taUpdate[j].Approval_Status__c == 'Approved' || taUpdate[j].Approval_Status__c == 'Migrated'))
                 {
                      tas.add(taUpdate[j]);
                      taqIds.add(taUpdate[j].id);
                 }
                 j++;
           }
           ////////
            
              
            TAQ_Organization_Approved__c[] objarr=[select id,Is_Latest_Record__c from TAQ_Organization_Approved__c where TAQ_Organization__c IN : taqIds and Is_Latest_Record__c=true];
             if(objarr.size()>0)
             {  for(Integer i=0;i<objarr.size();i++)
                                objarr[i].Is_Latest_Record__c=false;
             
                system.debug('objarr size:'+objarr.size());    
                database.update(objarr, false);
            }
            
            List<TAQ_Organization_Approved__c> listapp = new List<TAQ_Organization_Approved__c>();
            for(TAQ_Organization__c ta:tas){
                TAQ_Organization_Approved__c neworg=new TAQ_Organization_Approved__c();
                neworg.Is_Latest_Record__c=true;    
                neworg.name=ta.name;
                neworg.Approved_Date_Time__c=system.now();
                neworg.Approved_By__c=userinfo.getuserid();
                neworg.TAQ_Organization__c=ta.id;
                neworg.Position_Id__c = ta.Position_Id__c;
                neworg.Position_ID_Status__c= ta.Position_ID_Status__c;
                neworg.PMFKey__c= ta.PMFKey__c;
                neworg.Employee_Name__c= ta.Employee_Name__c;
                neworg.Employee_Status__c= ta.Employee_Status__c;
                neworg.Employee_Status_Date__c= ta.Employee_Status_Date__c;
                neworg.Organization__c= ta.Organization__c;
                neworg.Market__c= ta.Market__c;
                neworg.Region__c= ta.Region__c;
                neworg.Area__c= ta.Area__c;
                neworg.Territory__c= ta.Territory__c;
                neworg.Country__c= ta.Country__c;
                neworg.Job_Title__c= ta.JobTitle__c;
                neworg.Job_Code__c= ta.JobCode__c;
                neworg.Role__c= ta.Role__c;
                neworg.Role_Effective_Date__c= ta.Role_Effective_Date__c;
                neworg.Cost_Center_Number__c= ta.Cost_Center_Number__c;
                neworg.Cost_Center_Desc__c= ta.Cost_Center_Desc__c;
                neworg.Org_Type__c=ta.Org_Type__c;
                neworg.Approval_Process_Status__c=ta.Approval_Process_Status__c;
                neworg.Record_Status__c=ta.Approval_Status__c;
                neworg.Record_Status__c=ta.Approval_Status__c;
                neworg.Decision_Reason__c=ta.Reason_for_Rejection__c;
                //neworg.IC_Amount_USD__c=ta.Total_Amount_in_Dollars__c;
                neworg.Market_Focus_Area__c=ta.Market_Focus_Area__c;
                neworg.Quota1_PNCV__c=ta.Quota1_PNCV__c;
              
              system.debug('  neworg.AE_SE_PMFKey__c=' + ta.AE_SE_PMFKey__c)  ;
                neworg.Process_Step__c=ta.Process_Step__c;
                neworg.AE_SE_PMFKey__c=ta.AE_SE_PMFKey__c;
                
                neworg.Manager_PMFKey__c= ta.Manager_PMF_Key__c;
                neworg.Manager_Name__c= ta.Manager_Name__c;
                neworg.Manager_Effective_Date__c = ta.Manager_Effective_Date__c;
                
                neworg.Distribute_Plan__c= ta.Distribute_Plan__c;
                neworg.Comments__c= ta.Comments__c;
                neworg.Business_Unit__c= ta.Business_Unit__c;
                neworg.Plan_Type__c= ta.Plan_Type__c;
                    
                neworg.PlanType_Effective_Date__c= ta.PlanType_Effective_Date__c;
                neworg.Plantype_Delimited_Date__c= ta.Plantype_Delimited_Date__c;
                neworg.Plan_Reset__c= ta.Plan_Reset__c;
                
                neworg.IC_Currency__c=ta.IC_Currency__c;
                neworg.IC_Amount__c= ta.IC_Amount__c;
                neworg.Weighted_IC_PNCV__c=ta.Weighted_IC_PNCV__c;
                neworg.Standard_Flat_Rate__c=ta.Standard_Flat_Rate__c;
                neworg.Non_Standard_Flat_Rate__c=ta.Non_Standard_Flat_Rate__c;
                
                neworg.Weighted_IC_PNCV__c=ta.Weighted_IC_PNCV__c;
                
                neworg.Quota_Currency__c = ta.Quota_Currency__c;
                neworg.Quota1_Amount__c = ta.Quota1_Amount__c;
                neworg.Quota1_BU__c = ta.Quota1_BU__c;
                neworg.Quota1_PNCV__c = ta.Quota1_PNCV__c;
                neworg.Quota1_SNCV__c = ta.Quota1_SNCV__c;
                neworg.Quota1_Territory_Country__c = ta.Quota1_Territory_Country_F__c;
                //neworg.Quota1_Total__c = ta.Quota1_Total__c;
                neworg.Quota1_Type__c = ta.Quota1_Type__c;
                neworg.Quota1_Other__c = ta.Quota1_Other__c;
                
                neworg.Quota2_Amount__c = ta.Quota2_Amount__c;
                neworg.Quota2_BU__c = ta.Quota2_BU__c;
                neworg.Quota2_Territory_Country__c = ta.Quota2_Territory_Country_F__c;
                neworg.Quota2_Type__c = ta.Quota2_Type__c;
                neworg.Quota_2_PNCV_ENCV__c=ta.Quota_2_PNCV_ENCV__c;
                neworg.Quota2_SNCV__c=ta.Quota2_SNCV__c;
                neworg.Quota2_Other__c = ta.Quota2_Other__c;
                
                neworg.Quota3_Amount__c = ta.Quota3_Amount__c;
                neworg.Quota3_BU__c = ta.Quota3_BU__c;
                neworg.Quota3_Territory_Country__c =ta.Quota3_Territory_Country_F__c;
                neworg.Quota3_Type__c = ta.Quota3_Type__c;
                
                neworg.Quota3_Service__c = ta.Quota3_SNCV__c;
                neworg.Quota3_Product_EDU__c = ta.Quota3_PNCV_ENCV__c;
                neworg.Quota3_Other__c = ta.Quota3_Other__c;
                
                /*neworg.Quota4_Amount__c = ta.Quota4_Amount__c;
                neworg.Quota4_BU__c = ta.Quota4_BU__c;
                neworg.Quota4_Territory_Country__c = ta.Quota4_Territory_Country__c;
                neworg.Quota4_Type__c = ta.Quota4_Type__c;
                neworg.Quota5_Amount__c = ta.Quota5_Amount__c;
                neworg.Quota5_BU__c = ta.Quota5_BU__c;
                neworg.Quota5_Territory_Country__c = ta.Quota5_Territory_Country__c;
                neworg.Quota5_Type__c = ta.Quota5_Type__c;* /
                
                neworg.Overlay1_Code__c = ta.Overlay1_Code__c;
                neworg.Overlay2_Code__c = ta.Overlay2_Code__c;
                neworg.Overlay3_Code__c = ta.Overlay3_Code__c;
                
                  //changes made by rao on March 11th 2001
                neworg.Constant_Scale__c =ta.Constant_Scale__c;
                neworg.Quota_Carrier__c= ta.Quota_Carrier__c;
                neworg.Quota1_ENCV__c   =   ta.Quota1_ENCV__c;
               // neworg..Quota1_ENCV_USD__c   =   ta.Quota1_ENCV_USD__c;
                neworg.Constant_Scale__c    =ta.Constant_Scale__c;
                //neworg.Quota_1_Service_USD__c  =ta.Quota_1_Service_USD__c;
               // neworg.Quota_2_Service_USD__c  =ta.Quota_2_Service_USD__c;
                //neworg.Quota_3_Service_USD__c  =ta.Quota_3_Service_USD__c;
                neworg.IS_CSU_Subscriptions__c =ta.IS_CSU_Subscriptions__c;
                neworg.Quota1_Mainframe_Time__c=ta.Quota1_Mainframe_Time__c;
                //neworg.Quota1_Mainframe_Time_USD__c =ta.Quota1_Mainframe_Time_USD__c;
                neworg.Quota1_Mainframe_Capacity__c =ta.Quota1_Mainframe_Capacity__c;
                //neworg.Quota1_Mainframe_Capacity_USD__c=ta.Quota1_Mainframe_Capacity_USD__c;
                neworg.Quota2_Education__c=ta.Quota2_ENCV__c;
                neworg.Quota3_Education__c= ta.Quota3_Education__c;
                //neworg.Quota2_ENCV_USD__c=  ta.Quota2_ENCV_USD__c;
                neworg.Quota2_Mainframe_Time__c= ta.Quota2_Mainframe_Time__c;
                //neworg.Quota2_Mainframe_Time_USD__c =ta.Quota2_Mainframe_Time_USD__c;
                neworg.Quota2_Mainframe_Capacity__c =ta.Quota2_Mainframe_Capacity__c;
                //neworg.Quota2_Mainframe_Capacity_USD__c=ta.Quota2_Mainframe_Capacity_USD__c;
                
                //neworg.Quota3_ENCV__c=ta.TAQ_Organization__c.Quota3_ENCV__c;
                //neworg.Quota3_ENCV_USD__c   =ta.Quota3_ENCV_USD__c;
                neworg.Quota3_Mainframe_Time__c=ta.Quota3_Mainframe_Time__c;
                //neworg.Quota3_Mainframe_Time_USD__c =ta.Quota3_Mainframe_Time_USD__c;
                neworg.Quota3_Mainframe_Capacity__c =ta.Quota3_Mainframe_Capacity__c;
                
                
                //neworg.Quota3_Mainframe_Capacity_USD__c =   ta.Quota3_Mainframe_Capacity_USD__c;
                neworg.Quota_Carrier__c =   ta.Quota_Carrier__c;
                            
                //changes made by rao end 
                
                neworg.Is_Latest_Record__c=true;
                neworg.Process_Status__c = 'New';
                
                // Assigned the requestor queue to be the owner of the apporved record
                system.debug('DB3'+ta.ownerid);
                system.debug('DB4'+neworg.ownerid);            
                neworg.ownerid = ta.ownerid;
                
                listapp.add(neworg);
            }
            database.insert(listapp);
          /////////
        }
     }  
    }

    
    
    @future     
    public static void UpdateTAQAccountAESEPMFKeys(List<string> pmfkys,List<string> lstAESE)    
    {        
   
        FutureProcessor_TAQ.skiptriggers = true;
        SystemIdUtility.isFutureUpdate = true;
        TAQ_Account__c[] ta_orig;
        List<TAQ_Account__c> taUpdate = new List<TAQ_Account__c>();
        List<TAQ_Account__c> ta = new List<TAQ_Account__c>();
         
        
        Map<String,String> AesePmfKyMap=new Map<String,String>();
        integer count = 0;
        for(string pmf:pmfkys)
        {
            AesePmfKyMap.put(pmf,lstAESE[count]);
            count++;
        }

  
         if(pmfkys.size()>0){
             ta_orig = [SELECT t.Where_HQ_is_Located__c, t.Website__c, t.View_Acc_Record__c, t.URL__c, t.Total_NCV_Green_Dollars_NA_only__c,
             t.Top_100_A_C_Y_N__c, t.Third_Split_Percentage__c, t.Third_Split_Owner__c, t.Territory__c, t.Territory_For_Data_Load__c,
             t.Territory_Change__c, t.TAQ_Plan_ID__c, t.SystemModstamp, t.Stock_Ticker__c, t.Split__c, t.Split_Type__c, 
             t.Size_of_Company_Employees__c, t.Size_of_Company_Annual_Revenue__c, t.Send_For_Approval__c, t.Secondary_Split_Percentage__c,
             t.Secondary_Split_Owner__c, t.Sales_Director_PMF_Key__c, t.Sales_Director_Name__c, t.Sales_Director_Name_Change__c, 
             t.Sales_Director_Manager_PMFKey__c, t.SS_VSA_PMFKey__c, t.SS_VSA_Manager_PMFKey__c, t.SS_VSA_Effective_Date__c, 
             t.SS_SEC_PMFKey__c, t.SS_SEC_Manager_PMFKey__c, t.SS_SEC_Effective_Date__c, t.SS_SA_PMFKey__c, t.SS_SA_Manager_PMFKey__c, 
             t.SS_SA_Effective_Date__c, t.SS_PPM_PMFKey__c, t.SS_PPM_Manager_PMFKey__c, t.SS_PPM_Effective_Date__c, t.SS_MF_PMFKey__c, 
             t.SS_MF_Manager_PMFKey__c, t.SS_MF_Effective_Date__c, t.SS_Alignment_Change__c, t.SSE_VSA_PMFKey__c, t.SSE_SEC_PMFKey__c, 
             t.SSE_SA_PMFKey__c, t.SSE_PPM_PMFKey__c, t.SSE_MF_PMFKey__c, t.SM_Effective_Date__c, t.SLED_Area__c, t.SAP_ID__c,
             t.SAP_ID_Additional__c, t.SAM_PMFKey__c, t.SAM_Manager_PMFKey__c, t.SAM_Effective_Date__c, t.Rubric_Class__c,
             t.Reseller_Type__c, t.Reseller_Name__c, t.Reseller_ID__c, t.Reseller_Account_ID_Auto__c, t.Reseller_Account_Director_PMFKey__c, 
             t.Reseller_Account_Director_Effective_Date__c, t.Regional_Alliance_Director_PMF_Key__c, t.Regional_Alliance_Director_Eff_Date__c, 
             t.Region__c, t.Record_Type_for_Data_Load__c, t.RecordTypeId, t.Reason_for_Release__c, t.Reason_for_Rejection__c, 
             t.Reason_for_Merger__c, t.Quota_Change__c, t.Provide_Partner_Kit__c, t.Program_Level__c, t.Process_Step__c, 
             t.Primary_Split_Percentage__c, t.Primary_Split_Owner__c, t.Primary_Account__c, t.Prevailiing_Reseller_Account_ID__c,
             t.Prevailiing_Account_ID__c, t.Plan_Uplift_Product_NCV_Quota__c, t.Physical_Zip_Postal_Code__c, t.Physical_Zip_Local__c, 
             t.Physical_Street__c, t.Physical_Street_Local__c, t.Physical_State_Province__c, t.Physical_State_Prov_Local__c,
             t.Physical_Country__c, t.Physical_Country_Local__c, t.Physical_City__c, t.Physical_City_Local__c,
             t.Partner_Enablement_Addendum__c, t.Partner_Enablement_Addendum_Attached__c, t.Parent_or_Subsidiary__c,
             t.PDS_Addendum__c, t.PDS_Addendum_Attached__c, t.OwnerId, t.Open_Opportunities_Sites_move_to_another__c, t.Name,
             t.NCV_Total_Quota__c, t.NCV_Quota_Total__c, t.NCV_Quota_Services__c, t.NCV_Quota_Products__c, t.NCV_Quota_Education__c,
             t.Market_for_Data_Load__c, t.Market__c, t.Market_Segment__c, t.Mainframe_Time_Quota__c, t.Mainframe_Capacity_Quota__c,
             t.MSP_Account_Owner__c, t.MSP_Account_Owner_Effective_Date__c, t.MF_Account__c, t.LastModifiedDate, t.LastModifiedById, 
             t.LastActivityDate, t.Is_Primary_Account__c, t.Is_Original__c, t.Is_Error_in_Rule__c, t.Is_Change_Request__c, 
             t.IsDeleted, t.Industry_Vertical__c, t.If_Yes_New_Reseller_Account_ID__c, t.If_Yes_New_Account_ID__c, t.If_Sub_who_is_Parent__c, 
             t.Id, t.Global_Ultimate__c, t.Global_Ultimate_Region__c, t.Global_Ultimate_Name__c, t.GSP_SNCV_RunAndOper__c, 
             t.GSP_SNCV_Influence__c, t.GSP_PNCV_RunAndOper__c, t.GSP_PNCV_Influence__c, t.GSP_NA_SS_SA_Mgr2_PMFKey__c, 
             t.GSP_NA_SS_SA_Mgr2_Effective_Date__c, t.GSP_NA_SS_SA_Mgr2_Area__c, t.GSP_NA_SS_SA_Mgr1_PMFKey__c, t.GSP_NA_SS_SA_Mgr1_Effective_Date__c, 
             t.GSP_NA_SS_SA_Mgr1_Area__c, t.GSP_NA_SS_SA2_PMFKey__c, t.GSP_NA_SS_SA2_Effective_Date__c, t.GSP_NA_SS_SA2_Area__c, t.GSP_NA_SS_SA1_PMFKey__c, 
             t.GSP_NA_SS_SA1_Effective_Date__c, t.GSP_NA_SS_SA1_Area__c, t.GSP_NA_CSA_PMFKey__c, t.GSP_NA_CSA_Eff_Date__c, 
             t.GSP_NA_CSA_Area__c, t.GSP_NA_CPM_PMFKey__c, t.GSP_NA_CPM_Effective_Date__c, t.GSP_NA_CPM_Area__c,
             t.GSP_NA_AD3_Territory__c, t.GSP_NA_AD3_PMFKey__c, t.GSP_NA_AD3_Effective_Date__c, t.GSP_NA_AD3_Area__c,
             t.GSP_NA_AD2_Territory__c, t.GSP_NA_AD2_PMFKey__c, t.GSP_NA_AD2_Effective_Date__c, t.GSP_NA_AD2_Area__c,
             t.GSP_NA_AD1_Territory__c, t.GSP_NA_AD1_PMFKey__c, t.GSP_NA_AD1_Effective_Date__c, t.GSP_NA_AD1_Area__c, 
             t.GSP_LA_AD1_PMFKey__c, t.GSP_LA_AD1_Effective_Date__c, t.GSP_ENCV_RunAndOper__c, t.GSP_ENCV_Influence__c,
             t.GSP_EMEA_CSA_PMFKey__c, t.GSP_EMEA_CSA_Effective_Date__c, t.GSP_EMEA_CSA_Area__c, t.GSP_EMEA_AD3_PMFKey__c,
             t.GSP_EMEA_AD3_Effective_Date__c, t.GSP_EMEA_AD3_Area__c, t.GSP_EMEA_AD2_PMFKey__c, t.GSP_EMEA_AD2_Effective_Date__c, 
             t.GSP_EMEA_AD2_Area__c, t.GSP_EMEA_AD1_PMFKey__c, t.GSP_EMEA_AD1_Effective_Date__c, t.GSP_EMEA_AD1_Area__c, 
             t.GSP_CSA2_PMFKey__c, t.GSP_CSA2_Eff_Date__c, t.GSP_CSA1_PMFKey__c, t.GSP_CSA1_Effective_Date__c, 
             t.GSP_CPM_MGR_PMFKey__c, t.GSP_CPM_MGR_Effective_Date__c, t.GSP_Business_Type__c, t.GSP_Area_Mgr_PMFKey__c, 
             t.GSP_Area_Mgr_Effective_Date__c, t.GSP_Account_Quota_Total__c, t.GSP_Account_Owner_PMF_Key__c,
             t.GSP_Account_Owner_Effective_Date__c, t.GSP_APJ_AD1_PMFKey__c, t.GSP_APJ_AD1_Effective_Date__c,
             t.GPS_PMFKey__c, t.GPS_Manager_PMFKey__c, t.GPS_Effective_Date__c, t.Fourth_Split_Percentage__c, 
             t.Fourth_Split_Owner__c, t.FY12_Direct_Coverage__c, t.Enterprise_Id__c, t.Enterprise_Account__c, 
             t.Enterprise_Account_Name__c, t.Enterprise_Account_ID_Auto__c, t.Effective_Date_Change__c, 
             t.Did_you_seach_existing_Accounts__c, t.CurrencyIsoCode, t.CreatedDate, t.CreatedById, 
             t.Country_for_Data_Load__c, t.Country__c, t.Contract_Type__c, t.Contract_Start_Date__c,
             t.Contract_Expiration_Date__c, t.Comments__c, t.CSA_PMF_key__c, t.CSA_Manager_PMFKey__c, t.CSA_Effective_Date__c, 
             t.CPM_PMFKey__c, t.CPM_Effective_Date__c, t.CPMS_Id__c, t.Business_Plan__c, t.Business_Plan_Start_Date__c,
             t.Business_Plan_End_Date__c, t.Business_Plan_Attached__c, t.Associated_EAID2__c, t.Associated_EAID1__c, 
             t.Area_for_Data_Load__c, t.Area__c, t.Area_Change__c, t.Approval_Status__c, t.Approval_Process_Status__c, 
             t.Agreement__c, t.Agreement_Start_Date__c, t.Agreement_Number__c, t.Agreement_End_Date__c, t.Agreement_Attached__c,
             t.Account_Type__c, t.Account_Type3__c, t.Account_Type1__c, t.Account_Renewal_Total__c, t.Account_Ownership_Change__c, 
             t.Account_Owner_PMF_Key__c, t.Account_Owner_Name__c, t.Account_Owner_Manager_PMFKey__c, t.Account_Owner_Effective_Date__c,
             t.Account_Name_Local__c, t.Account_Name_Local_3__c, t.Account_Name_Local_2_Phonetic__c,
             t.Account_Name_Change__c, t.Account_ID_being_Merged__c, t.Account_ID__c, t.Account_Class__c, t.Account_Class_Change__c,
             t.AE_PMFKey__c, t.AD_Renewal__c From TAQ_Account__c t 
             WHERE
              (Account_Owner_PMF_Key__c in: pmfkys OR SS_VSA_PMFKey__c in: pmfkys OR SS_PPM_PMFKey__c in: pmfkys  
               OR SS_MF_PMFKey__c in: pmfkys OR SS_SEC_PMFKey__c in: pmfkys OR SS_SA_PMFKey__c in: pmfkys)
              AND
               Process_Step__c <> 'Account Release' AND Process_Step__c<>'Account Merge'
               ];
        }
        
    if(ta_orig!=null && ta_orig.size()>0){
    
       for(Integer j=0;j<ta_orig.size();j++)
       {
       
        if(ta_orig[j].Account_Owner_PMF_Key__c <> null && AesePmfKyMap.containsKey(ta_orig[j].Account_Owner_PMF_Key__c))
           ta_orig[j].AE_PMFKey__c=AesePmfKyMap.get(ta_orig[j].Account_Owner_PMF_Key__c);
        if(ta_orig[j].SS_VSA_PMFKey__c <> null && AesePmfKyMap.containsKey(ta_orig[j].SS_VSA_PMFKey__c))
           ta_orig[j].SSE_VSA_PMFKey__c=AesePmfKyMap.get(ta_orig[j].SS_VSA_PMFKey__c);
        if(ta_orig[j].SS_PPM_PMFKey__c <> null && AesePmfKyMap.containsKey(ta_orig[j].SS_PPM_PMFKey__c))
           ta_orig[j].SSE_PPM_PMFKey__c=AesePmfKyMap.get(ta_orig[j].SS_PPM_PMFKey__c);
        if(ta_orig[j].SS_MF_PMFKey__c <> null && AesePmfKyMap.containsKey(ta_orig[j].SS_MF_PMFKey__c))
           ta_orig[j].SSE_MF_PMFKey__c=AesePmfKyMap.get(ta_orig[j].SS_MF_PMFKey__c);
        if(ta_orig[j].SS_SEC_PMFKey__c <> null && AesePmfKyMap.containsKey(ta_orig[j].SS_SEC_PMFKey__c))
           ta_orig[j].SSE_SEC_PMFKey__c=AesePmfKyMap.get(ta_orig[j].SS_SEC_PMFKey__c);
        if(ta_orig[j].SS_SA_PMFKey__c <> null && AesePmfKyMap.containsKey(ta_orig[j].SS_SA_PMFKey__c))
           ta_orig[j].SSE_SA_PMFKey__c=AesePmfKyMap.get(ta_orig[j].SS_SA_PMFKey__c);
      
       /* if(ta_orig[j].Approval_Process_Status__c <> 'Send For Approval' && ta.Approval_Process_Status__c <> 'Saved - Not Approved')
        {
            ta_orig[j].Process_Step__c = 'Account Update';
            ta_orig[j].Approval_Process_Status__c = '';
            ta_orig[j].Approval_Status__c = 'Approved'; 
            ta.add(ta_orig[i]);
        }* /
        
       // if(ta_orig[j].Approval_Status__c == 'Approved' || ta_orig[j].Approval_Status__c == 'Migrated')
                 taUpdate.add(ta_orig[j]);
         
       }
       
       if(taUpdate.size() > 0)
       {   
       
           Database.SaveResult[] lsr = database.update(taUpdate,false); 
           integer j = 0;
           Set<id> taqIds = new Set<id>();
 
           for(Database.SaveResult sr:lsr)
           {
               if(sr.isSuccess() && (taUpdate[j].Approval_Status__c == 'Approved' || taUpdate[j].Approval_Status__c == 'Migrated'))
                 {
                      ta.add(taUpdate[j]);
                      taqIds.add(taUpdate[j].id);
                 }
                 j++;
           }
           ////////
            
              
            TAQ_Account_Approved__c[] objarr=[select id,Is_Latest_Record__c from TAQ_Account_Approved__c where TAQ_Account__c IN : taqIds and Is_Latest_Record__c=true];
             if(objarr.size()>0)
             {  for(Integer i=0;i<objarr.size();i++)
                                objarr[i].Is_Latest_Record__c=false;
             
                system.debug('objarr size:'+objarr.size());    
                    database.update(objarr, false);
            }
            List<TAQ_Account_Approved__c> listapp = new List<TAQ_Account_Approved__c>();
            for(Integer i=0;i<ta.size();i++){
                TAQ_Account_Approved__c newacc=new TAQ_Account_Approved__c();
                newacc.Is_Latest_Record__c=true;    
                newacc.name=ta[i].name;
                newacc.TAQ_Account__c = ta[i].id;
                
                if(ta[i].Is_Original__c==true)
                    newacc.Is_Original__c=true;
                    
                newacc.Contract_Expiration_Date__c=ta[i].Contract_Expiration_Date__c;
                newacc.Contract_Start_Date__c=ta[i].Contract_Start_Date__c;
                newacc.Program_Level__c=ta[i].Program_Level__c;
                newacc.Contract_Type__c=ta[i].Contract_Type__c;
                newacc.CPMS_Id__c=ta[i].CPMS_Id__c;
                newacc.Reseller_Type__c=ta[i].Reseller_Type__c;
                newacc.Process_Step__c=ta[i].Process_Step__c;
                //fields added as part of reseller
                newacc.Reseller_Account_Director_PMFKey__c = ta[i].Reseller_Account_Director_PMFKey__c;
                newacc.Reseller_Account_Director_Effective_Date__c = ta[i].Reseller_Account_Director_Effective_Date__c;
                newacc.Partner_Account_Owner_PMFKey__c=ta[i].Reseller_Account_Director_PMFKey__c;
                newacc.Partner_Account_Owner_Effective_Date__c=ta[i].Reseller_Account_Director_Effective_Date__c;
                
                newacc.Physical_City__c=ta[i].Physical_City__c;
                //newacc.Physical_Country__c=ta[i].Physical_Country__c;
                newacc.Physical_State_Province__c=ta[i].Physical_State_Province__c;
                newacc.Physical_Street__c=ta[i].Physical_Street__c;
                newacc.Physical_Zip_Postal_Code__c=ta[i].Physical_Zip_Postal_Code__c;
                    
                newacc.Approved_Date_Time__c=system.now();
                newacc.Approved_By__c=userinfo.getuserid();
    
                newacc.Enterprise_Id__c= ta[i].Enterprise_Id__c;
                if(ta[i].Enterprise_Id__c!=null)
                newacc.Enterprise_Account_Name__c= ta[i].Enterprise_Account_Name__c;
                if(ta[i].Reseller_ID__c!=null)
                {
                newacc.Reseller_ID__c= ta[i].Reseller_ID__c;
                newacc.Reseller_Name__c= ta[i].Reseller_Name__c;
                }
                newacc.Market__c= ta[i].Market__c;
                newacc.Market_Segment__c= ta[i].Market_Segment__c;
                newacc.Region__c= ta[i].Region__c;
                newacc.Area__c= ta[i].Area__c;
                newacc.Territory__c= ta[i].Territory__c;
                newacc.Country__c= ta[i].Country__c;
                newacc.Account_Type__c= ta[i].Account_Type__c;
                newacc.Account_Class__c= ta[i].Account_Class__c;
                newacc.Rubric_Class__c= ta[i].Rubric_Class__c;
                
                newacc.Split__c= ta[i].Split__c;
                newacc.Split_Type__c= ta[i].Split_Type__c;
                newacc.Split_Primary_Account__c=ta[i].Is_Primary_Account__c;
                //Split_Linked_Account
                
                newacc.Industry_Vertical__c= ta[i].Industry_Vertical__c;
                newacc.Stock_Ticker__c= ta[i].Stock_Ticker__c;
                newacc.Comments__c= ta[i].Comments__c;
                newacc.URL__c= ta[i].URL__c;
                newacc.Top_100_A_C_Y_N__c= ta[i].Top_100_A_C_Y_N__c;
                
                newacc.Account_Owner_PMFKey__c= ta[i].Account_Owner_PMF_Key__c;
                newacc.Account_Owner_Name__c= ta[i].Account_Owner_Name__c;
                newacc.Account_Owner_Effective_Date__c = ta[i].Account_Owner_Effective_Date__c;
                newacc.Sales_Director_PMFKey__c= ta[i].Sales_Director_PMF_Key__c;
                newacc.Sales_Director_Name__c= ta[i].Sales_Director_Name__c;
                newacc.SM_Effective_Date__c= ta[i].SM_Effective_Date__c; //sales director effective date
    
                newacc.Regional_Alliance_Director_PMF_Key__c=ta[i].Regional_Alliance_Director_PMF_Key__c;
                newacc.Regional_Alliance_Director_Eff_Date__c =ta[i].Regional_Alliance_Director_Eff_Date__c  ;
    
                newacc.CSA_PMF_key__c= ta[i].CSA_PMF_key__c;
                newacc.CSA_Effective_Date__c= ta[i].CSA_Effective_Date__c;
                newacc.SAM_PMFKey__c= ta[i].SAM_PMFKey__c;
                newacc.SAM_Effective_Date__c= ta[i].SAM_Effective_Date__c;
                
                newacc.SS_Virtualise_Service_Automate_Eff_Date__c =ta[i].SS_VSA_Effective_Date__c;     
                newacc.SS_Service_Virtu_and_Automation_PMFKEY__c =ta[i].SS_VSA_PMFKey__c;
    
                newacc.SS_PPM_PMFKey__c=ta[i].SS_PPM_PMFKey__c;
                
                newacc.SS_PPM_Effective_Date__c=ta[i].SS_PPM_Effective_Date__c;
                newacc.SS_Mainframe_PMFKey__c=ta[i].SS_MF_PMFKey__c;
                newacc.SS_Mainframe_Effective_Date__c=ta[i].SS_MF_Effective_Date__c;
                newacc.SS_Security_Compliance_PMFKey__c=ta[i].SS_SEC_PMFKey__c;
                newacc.SS_Security_Compliance_Effective_Date__c=ta[i].SS_SEC_Effective_Date__c;
                newacc.SS_ServiceAssurance_PMFKey__c=ta[i].SS_SA_PMFKey__c;
                newacc.SS_ServiceAssurance_Effective_Date__c=ta[i].SS_SA_Effective_Date__c;
                
                newacc.GPS_PMFKey__c =ta[i].GPS_PMFKey__c;
                newacc.GPS_Effective_Date__c =ta[i].GPS_Effective_Date__c;     
                
                newacc.NCV_Quota_Products__c=ta[i].NCV_Quota_Products__c;
                newacc.NCV_Quota_Services__c=ta[i].NCV_Quota_Services__c;
                newacc.NCV_Quota_Education__c=ta[i].NCV_Quota_Education__c;
   
                newacc.Third_Split_Owner__c=ta[i].Third_Split_Owner__c;  
                newacc.Where_HQ_is_Located__c=ta[i].Where_HQ_is_Located__c;
                newacc.Secondary_Split_Owner__c=ta[i].Secondary_Split_Owner__c;
                newacc.Primary_Split_Owner__c=ta[i].Primary_Split_Owner__c;
                newacc.Fourth_Split_Owner__c=ta[i].Fourth_Split_Owner__c;
        
                newacc.Did_you_seach_existing_Accounts__c=ta[i].Did_you_seach_existing_Accounts__c;
                newacc.Size_of_Company_Annual_Revenue__c=ta[i].Size_of_Company_Annual_Revenue__c;
                newacc.Size_of_Company_Employees__c=ta[i].Size_of_Company_Employees__c;
                newacc.Parent_or_Subsidiary__c=ta[i].Parent_or_Subsidiary__c;
                newacc.If_Sub_who_is_Parent__c=ta[i].If_Sub_who_is_Parent__c;
                newacc.Account_Name_Change__c=ta[i].Account_Name_Change__c;
                newacc.Account_Ownership_Change__c=ta[i].Account_Ownership_Change__c;
                newacc.SS_Alignment_Change__c=ta[i].SS_Alignment_Change__c;
                newacc.Quota_Change__c=ta[i].Quota_Change__c;
                newacc.Account_Class_Change__c=ta[i].Account_Class_Change__c;
                newacc.Area_Change__c=ta[i].Area_Change__c;
                newacc.Territory_Change__c=ta[i].Territory_Change__c;
                newacc.Sales_Director_Name_Change__c=ta[i].Sales_Director_Name_Change__c;
                newacc.Effective_Date_Change__c=ta[i].Effective_Date_Change__c;
                newacc.Account_ID__c=ta[i].Account_ID__c;
                newacc.Reason_for_Release__c=ta[i].Reason_for_Release__c;
                newacc.Open_Opportunities_Sites_move_to_another__c=ta[i].Open_Opportunities_Sites_move_to_another__c;
                //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 
                if(ta[i].If_Yes_New_Account_ID__c!=null || ta[i].If_Yes_New_Account_ID__c!= '' )
                newacc.If_Yes_New_Account_ID__c=ta[i].If_Yes_New_Account_ID__c;
                else
                newacc.If_Yes_New_Account_ID__c=ta[i].If_Yes_New_Reseller_Account_ID__c;
                
                newacc.Account_ID_being_Merged__c=ta[i].Account_ID_being_Merged__c;
               //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 
                if(ta[i].Prevailiing_Account_ID__c!=null || ta[i].Prevailiing_Account_ID__c!= '')
                newacc.Prevailiing_Account_ID__c=ta[i].Prevailiing_Account_ID__c;
                else
                newacc.Prevailiing_Account_ID__c=ta[i].Prevailiing_Reseller_Account_ID__c;
                
                newacc.Reason_for_Merger__c=ta[i].Reason_for_Merger__c;
                
                newacc.Primary_Split_Percentage__c=ta[i].Primary_Split_Percentage__c;
                newacc.Secondary_Split_Percentage__c=ta[i].Secondary_Split_Percentage__c;
                newacc.Third_Split_Percentage__c=ta[i].Third_Split_Percentage__c;
                newacc.Fourth_Split_Percentage__c=ta[i].Fourth_Split_Percentage__c;
                
                //new assignments to accout approved object
                newacc.Account_Owner_Manager_PMFKey__c=ta[i].Account_Owner_Manager_PMFKey__c;
                newacc.Account_Type1__c=ta[i].Account_Type1__c;
                newacc.Account_Type2__c=ta[i].Account_Type__c;
                newacc.Account_Type3__c=ta[i].Account_Type3__c;
                newacc.Approval_Status_2__c=ta[i].Approval_Status__c;
                newacc.CSA_Manager_PMFKey__c=ta[i].CSA_Manager_PMFKey__c;
                newacc.Decision_Reason__c=ta[i].Reason_for_Rejection__c;
                newacc.GPS_Manager_PMFKey__c=ta[i].GPS_Manager_PMFKey__c;
                newacc.Partner_Account_Name_Change__c=ta[i].Account_Name_Change__c;
                
                newacc.Request_Type__c=ta[i].Process_Step__c;
                newacc.Sales_Director_Manager_PMFKey__c=ta[i].Sales_Director_Manager_PMFKey__c;
                newacc.SAM_Manager_PMFKey__c=ta[i].SAM_Manager_PMFKey__c;
                newacc.SAP_ID__c=ta[i].SAP_ID__c;
                newacc.SAP_ID_Additional__c=ta[i].SAP_ID_Additional__c;
                newacc.SS_MF_Manager_PMFKey__c=ta[i].SS_MF_Manager_PMFKey__c;
                
                newacc.SS_PPM_Manager_PMFKey__c=ta[i].SS_PPM_Manager_PMFKey__c;
                newacc.SS_SA_Manager_PMFKey__c=ta[i].SS_SA_Manager_PMFKey__c;
                newacc.SS_SEC_Manager_PMFKey__c=ta[i].SS_SEC_Manager_PMFKey__c;
                newacc.SS_VSA_Manager_PMFKey__c=ta[i].SS_VSA_Manager_PMFKey__c;
                newacc.Approval_Process_Status__c=ta[i].Approval_Process_Status__c;
                                
                newacc.Plan_Uplift_Product_NCV_Quota__c=ta[i].Plan_Uplift_Product_NCV_Quota__c;

                // changed made by rao on 11th March 2011

                newacc.AD_Renewal__c= ta[i]. AD_Renewal__c;
                newacc.SLED_Area__c=ta[i].SLED_Area__c;
                newacc.GSP_Business_Type__c=ta[i].GSP_Business_Type__c;
                newacc.GSP_EMEA_AD1_Area__c=ta[i].GSP_EMEA_AD1_Area__c;
                newacc.GSP_EMEA_AD2_Area__c=ta[i].GSP_EMEA_AD2_Area__c;
                newacc.GSP_EMEA_AD3_Area__c=ta[i].GSP_EMEA_AD3_Area__c;
                newacc.GSP_EMEA_CSA_Area__c=ta[i].GSP_EMEA_CSA_Area__c;
                newacc.GSP_NA_AD1_Area__c=ta[i].GSP_NA_AD1_Area__c;
                newacc.GSP_NA_AD2_Area__c=ta[i].GSP_NA_AD2_Area__c;
                newacc.GSP_NA_AD3_Area__c=ta[i].GSP_NA_AD3_Area__c;
                newacc.GSP_NA_CPM_Area__c=ta[i].GSP_NA_CPM_Area__c;
                newacc.GSP_NA_CSA_Area__c=ta[i].GSP_NA_CSA_Area__c;
                newacc.GSP_NA_SS_SA1_Area__c=ta[i].GSP_NA_SS_SA1_Area__c;
                newacc.GSP_NA_SS_SA2_Area__c=ta[i].GSP_NA_SS_SA2_Area__c;
                newacc.GSP_NA_SS_SA_Mgr1_Area__c=ta[i].GSP_NA_SS_SA_Mgr1_Area__c;
                newacc.GSP_NA_SS_SA_Mgr2_Area__c=ta[i].GSP_NA_SS_SA_Mgr2_Area__c;
                newacc.Global_Ultimate_Region__c=ta[i].Global_Ultimate_Region__c;
                newacc.FY12_Direct_Coverage__c=ta[i].FY12_Direct_Coverage__c;
                newacc.MF_Account__c=ta[i].MF_Account__c;
                
                newacc.MSP_Account_Owner__c=ta[i].MSP_Account_Owner__c;
                newacc.MSP_Account_Owner_Effective_Date__c=ta[i].MSP_Account_Owner_Effective_Date__c;
                newacc.GSP_GSP_Account_Owner_Effective_Date__c=ta[i].GSP_Account_Owner_Effective_Date__c;
                newacc.GSP_Account_Owner_PMF_Key__c=ta[i].GSP_Account_Owner_PMF_Key__c;
                //newacc.GSP_Account_Quota_Total__c=ta[i].GSP_Account_Quota_Total__c;
                newacc.GSP_APJ_AD1_Effective_Date__c=ta[i].GSP_APJ_AD1_Effective_Date__c;
                newacc.GSP_APJ_AD1_PMFKey__c=ta[i].GSP_APJ_AD1_PMFKey__c;
                newacc.GSP_Area_Mgr_Effective_Date__c=ta[i].GSP_Area_Mgr_Effective_Date__c;
                newacc.GSP_Area_Mgr_PMFKey__c=ta[i].GSP_Area_Mgr_PMFKey__c;
                newacc.GSP_Business_Type__c=ta[i].GSP_Business_Type__c;
                newacc.GSP_CPM_MGR_PMFKey__c=ta[i].GSP_CPM_MGR_PMFKey__c;
                newacc.GSP_CPM_MGR_Effective_Date__c=ta[i].GSP_CPM_MGR_Effective_Date__c;
                newacc.GSP_CSA1_Effective_Date__c=ta[i].GSP_CSA1_Effective_Date__c;
                newacc.GSP_CSA1_PMFKey__c=ta[i].GSP_CSA1_PMFKey__c;
                newacc.GSP_CSA2_Eff_Date__c=ta[i].GSP_CSA2_Eff_Date__c;
                newacc.GSP_CSA2_PMFKey__c=ta[i].GSP_CSA2_PMFKey__c;
                newacc.GSP_EMEA_AD1_Area__c=ta[i].GSP_EMEA_AD1_Area__c;
                newacc.GSP_EMEA_AD1_Effective_Date__c=ta[i].GSP_EMEA_AD1_Effective_Date__c;
                newacc.GSP_EMEA_AD1_PMFKey__c=ta[i].GSP_EMEA_AD1_PMFKey__c;
                newacc.GSP_EMEA_AD2_Area__c=ta[i].GSP_EMEA_AD2_Area__c;
                newacc.GSP_EMEA_AD2_Effective_Date__c=ta[i].GSP_EMEA_AD2_Effective_Date__c;
                newacc.GSP_EMEA_AD2_PMFKey__c=ta[i].GSP_EMEA_AD2_PMFKey__c;
                newacc.GSP_EMEA_AD3_Area__c=ta[i].GSP_EMEA_AD3_Area__c;
                newacc.GSP_EMEA_AD3_Effective_Date__c=ta[i].GSP_EMEA_AD3_Effective_Date__c;
                newacc.GSP_EMEA_AD3_PMFKey__c=ta[i].GSP_EMEA_AD3_PMFKey__c;
                newacc.GSP_EMEA_CSA_Area__c=ta[i].GSP_EMEA_CSA_Area__c;
                newacc.GSP_EMEA_CSA_Effective_Date__c=ta[i].GSP_EMEA_CSA_Effective_Date__c;
                newacc.GSP_EMEA_CSA_PMFKey__c=ta[i].GSP_EMEA_CSA_PMFKey__c;
                newacc.GSP_ENCV_Influence__c=ta[i].GSP_ENCV_Influence__c;
                newacc.GSP_ENCV_RunAndOper__c=ta[i].GSP_ENCV_RunAndOper__c;
                newacc.GSP_LA_AD1_Effective_Date__c=ta[i].GSP_LA_AD1_Effective_Date__c;
                newacc.GSP_LA_AD1_PMFKey__c=ta[i].GSP_LA_AD1_PMFKey__c;
                newacc.GSP_NA_AD1_Area__c=ta[i].GSP_NA_AD1_Area__c;
                newacc.GSP_NA_AD1_Effective_Date__c=ta[i].GSP_NA_AD1_Effective_Date__c;
                newacc.GSP_NA_AD1_PMFKey__c=ta[i].GSP_NA_AD1_PMFKey__c;
                newacc.GSP_NA_AD2_Area__c=ta[i].GSP_NA_AD2_Area__c;
                newacc.GSP_NA_AD2_Effective_Date__c=ta[i].GSP_NA_AD2_Effective_Date__c;
                newacc.GSP_NA_AD2_PMFKey__c=ta[i].GSP_NA_AD2_PMFKey__c;
                newacc.GSP_NA_AD3_Area__c=ta[i].GSP_NA_AD3_Area__c;
                newacc.GSP_NA_AD3_Effective_Date__c=ta[i].GSP_NA_AD3_Effective_Date__c;
                newacc.GSP_NA_AD3_PMFKey__c=ta[i].GSP_NA_AD3_PMFKey__c;
                newacc.GSP_NA_CPM_Area__c=ta[i].GSP_NA_CPM_Area__c;
                newacc.GSP_NA_CPM_Effective_Date__c=ta[i].GSP_NA_CPM_Effective_Date__c;
                newacc.GSP_NA_CPM_PMFKey__c=ta[i].GSP_NA_CPM_PMFKey__c;
                newacc.GSP_NA_CSA_Area__c=ta[i].GSP_NA_CSA_Area__c;
                newacc.GSP_NA_CSA_Eff_Date__c=ta[i].GSP_NA_CSA_Eff_Date__c;
                newacc.GSP_NA_CSA_PMFKey__c=ta[i].GSP_NA_CSA_PMFKey__c;
                newacc.GSP_NA_SS_SA1_Area__c=ta[i].GSP_NA_SS_SA1_Area__c;
                newacc.GSP_NA_SS_SA1_Effective_Date__c=ta[i].GSP_NA_SS_SA1_Effective_Date__c;
                newacc.GSP_NA_SS_SA1_PMFKey__c=ta[i].GSP_NA_SS_SA1_PMFKey__c;
                newacc.GSP_NA_SS_SA2_Area__c=ta[i].GSP_NA_SS_SA2_Area__c;
                newacc.GSP_NA_SS_SA2_Effective_Date__c=ta[i].GSP_NA_SS_SA2_Effective_Date__c;
                newacc.GSP_NA_SS_SA2_PMFKey__c=ta[i].GSP_NA_SS_SA2_PMFKey__c;
                newacc.GSP_NA_SS_SA_Mgr1_Area__c=ta[i].GSP_NA_SS_SA_Mgr1_Area__c;
                newacc.GSP_NA_SS_SA_Mgr1_Effective_Date__c=ta[i].GSP_NA_SS_SA_Mgr1_Effective_Date__c;
                newacc.GSP_NA_SS_SA_Mgr1_PMFKey__c=ta[i].GSP_NA_SS_SA_Mgr1_PMFKey__c;
                newacc.GSP_NA_SS_SA_Mgr2_Area__c=ta[i].GSP_NA_SS_SA_Mgr2_Area__c;
                newacc.GSP_NA_SS_SA_Mgr2_Effective_Date__c=ta[i].GSP_NA_SS_SA_Mgr2_Effective_Date__c;
                newacc.GSP_NA_SS_SA_Mgr2_PMFKey__c=ta[i].GSP_NA_SS_SA_Mgr2_PMFKey__c;
                newacc.GSP_PNCV_Influence__c=ta[i].GSP_PNCV_Influence__c;
                newacc.GSP_PNCV_RunAndOper__c=ta[i].GSP_PNCV_RunAndOper__c;
                newacc.GSP_SNCV_Influence__c=ta[i].GSP_SNCV_Influence__c;
                newacc.GSP_SNCV_RunAndOper__c=ta[i].GSP_SNCV_RunAndOper__c;
                newacc.GSP_NA_AD1_Territory__c=ta[i].GSP_NA_AD1_Territory__c;
                newacc.GSP_NA_AD2_Territory__c=ta[i].GSP_NA_AD2_Territory__c;
                newacc.GSP_NA_AD3_Territory__c=ta[i].GSP_NA_AD3_Territory__c;
                
                //newacc.Account_Renewal_Total__c=ta[i].Account_Renewal_Total__c;
                newacc.CPM_PMFKey__c=ta[i].CPM_PMFKey__c;
                newacc.CPM_Effective_Date__c=ta[i].CPM_Effective_Date__c;
                newacc.Mainframe_Time_Quota__c=ta[i].Mainframe_Time_Quota__c;
                newacc.Mainframe_Capacity_Quota__c=ta[i].Mainframe_Capacity_Quota__c;
                //newacc.Is_Secondary_Account__c=ta[i].Is_Secondary_Account__c;
                newacc.Associated_EAID1__c=ta[i].Associated_EAID1__c;
                newacc.Associated_EAID2__c=ta[i].Associated_EAID2__c;
                newacc.Global_Ultimate__c=ta[i].Global_Ultimate__c;
                newacc.Global_Ultimate_Name__c=ta[i].Global_Ultimate_Name__c;
                newacc.AE_PMFKey__c=ta[i].AE_PMFKey__c;
                newacc.SSE_VSA_PMFKey__c=ta[i].SSE_VSA_PMFKey__c;
                newacc.SSE_PPM_PMFKey__c=ta[i].SSE_PPM_PMFKey__c;
                newacc.SSE_MF_PMFKey__c=ta[i].SSE_MF_PMFKey__c;
                newacc.SSE_SEC_PMFKey__c=ta[i].SSE_SEC_PMFKey__c;
                newacc.SSE_SA_PMFKey__c=ta[i].SSE_SA_PMFKey__c;
                   

                
              if(ta[i].Reseller_ID__c!=null)
              {
                //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 'Address Fields Local (APJ)' Added For Reseller.***
                
                newacc.Account_Name_local__c=ta[i].Account_Name_Local__c;
                newacc.Account_Name_Local_2_Phonetic__c=ta[i].Account_Name_Local_2_Phonetic__c;   
                newacc.Account_Name_Local_3__c=ta[i].Account_Name_Local_3__c;
                newacc.Physical_City_Local__c=ta[i].Physical_City_Local__c;
                newacc.Physical_State_Prov_Local__c=ta[i].Physical_State_Prov_Local__c;
                newacc.Physical_Country_Local__c=ta[i].Physical_Country_Local__c;
                newacc.Physical_Street_Local__c=ta[i].Physical_Street_Local__c;          
                newacc.Physical_Zip_Local__c=ta[i].Physical_Zip_Local__c;
                
                //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-606'Partner Milestone Section' Added For Reseller.***
                
                newacc.Provide_Partner_Kit__c=ta[i].Provide_Partner_Kit__c;
                newacc.Agreement__c=ta[i].Agreement__c;
                newacc.Contract_Start_Date__c=ta[i].Contract_Start_Date__c;
                newacc.Business_Plan__c=ta[i].Business_Plan__c;
                newacc.Business_Plan_Start_Date__c=ta[i].Business_Plan_Start_Date__c;
                newacc.Partner_Enablement_Addendum__c=ta[i].Partner_Enablement_Addendum__c;
                newacc.Agreement_Number__c=ta[i].Agreement_Number__c;
                newacc.Agreement_Attached__c=ta[i].Agreement_Attached__c;
                newacc.Agreement_End_Date__c=ta[i].Agreement_End_Date__c;
                newacc.Business_Plan_Attached__c=ta[i].Business_Plan_Attached__c;
                newacc.Business_Plan_End_Date__c=ta[i].Business_Plan_End_Date__c;
                newacc.PDS_Addendum_Attached__c=ta[i].PDS_Addendum_Attached__c;
                newacc.Partner_Enablement_Addendum_Attached__c=ta[i].Partner_Enablement_Addendum_Attached__c;
                newacc.PDS_Addendum__c=ta[i].PDS_Addendum__c;
                newacc.Agreement_Start_Date__c=ta[i].Agreement_Start_Date__c;
                  
                //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-606'
                newacc.Account_Type1__c=ta[i].Account_Type1__c;
                newacc.Account_Type2__c=ta[i].Account_Type__c;
                newacc.Account_Type3__c=ta[i].Account_Type3__c;
                newacc.Reseller_Type__c=ta[i].Reseller_Type__c;
                
                //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-1386'
                newacc.CPMS_Id__c=ta[i].CPMS_Id__c;
                 
                }
                  
                  
                //Assigned the requestor queue to be the owner of the apporved record
                 newacc.ownerid = ta[i].ownerid;
                 listapp.add(newacc);
            }
            database.insert(listapp);
          /////////
        }
     }  
    }




   
     private static testmethod void testClass()
     {
       TAQ_organization__c taq = [Select AE_SE_PMFKey__c from taq_organization__c where AE_SE_PMFKey__c <> null and Approval_Status__c = 'Approved' AND pmfkey__c <> null limit 1 ];
       
       if(taq <> null)
       {
           taq.AE_SE_PMFKey__c = 'ANSSA01';
           taq.Approval_Process_Status__c = 'Send For Approval';
          /* taq.Employee_Status_Date__c = null;
           taq.Employee_Name__c = null;   
           taq.Employee_Status__c = null;    
           taq.PMFKey__c = null;
            * /
           try{   
           update taq; 
           }
           catch(exception ex)
           {}
           taq.Approval_Process_Status__c = 'Approved';
           try{   
           update taq; 
           }
           catch(exception ex)
           {}
           
       }  
       List<string> lstpmf = new List<string>();
       lstpmf.add('AAAAA01');
       System.debug('++++++++++++++++++' + taq.PMFKey__c );
       
       List<string> lstaesepmf = new List<string>();
       lstaesepmf.add('AAAAA01');
       System.debug('++++++++++++++++++' + taq.AE_SE_PMFKey__c );         
       FutureProcessor_TAQ.UpdateTAQAccountAESEPMFKeys(lstpmf,lstaesepmf);
       Map<id,string> mapOrg = new Map<id,string>();
       mapOrg.put(taq.id, 'test_update_position_id'); 
       FutureProcessor_TAQ.UpdatePositionIdOfAccounts(mapOrg);
       Map<string,string> mapOldNewPositionId = new Map<string,string>();
       List<TAQ_Account__c> lstTa = [Select Account_Owner_Manager_PMFKey__c , Account_Owner_PMF_Key__c , AE_PMFKey__c , CPM_PMFKey__c , CSA_Manager_PMFKey__c , CSA_PMF_key__c , CST_CSA_PMFKey__c ,
                SAM_PMFKey__c , GAD_AD_PMFKey__c , GPS_Manager_PMFKey__c , GPS_PMFKey__c , GSP_Account_Owner_PMF_Key__c , GSP_APJ_AD1_PMFKey__c , GSP_Area_Mgr_PMFKey__c ,
                GSP_CPM_MGR_PMFKey__c , GSP_CSA1_PMFKey__c , GSP_CSA2_PMFKey__c , GSP_EMEA_AD1_PMFKey__c , GSP_EMEA_AD2_PMFKey__c , GSP_EMEA_AD3_PMFKey__c , GSP_EMEA_CSA_PMFKey__c , GSP_LA_AD1_PMFKey__c , GSP_NA_AD1_PMFKey__c , GSP_NA_AD2_PMFKey__c , GSP_NA_AD3_PMFKey__c , GSP_NA_CPM_PMFKey__c , GSP_NA_CSA_PMFKey__c , GSP_NA_SS_SA1_PMFKey__c , GSP_NA_SS_SA2_PMFKey__c , GSP_NA_SS_SA_Mgr1_PMFKey__c , GSP_NA_SS_SA_Mgr2_PMFKey__c , Reseller_Account_Director_PMFKey__c , Regional_Alliance_Director_PMF_Key__c , Sales_Director_Manager_PMFKey__c , Sales_Director_PMF_Key__c ,
                SAM_Manager_PMFKey__c , SSE_MF_PMFKey__c , SSE_PPM_PMFKey__c , SSE_SA_PMFKey__c , SSE_SEC_PMFKey__c , SSE_VSA_PMFKey__c , SS_MF_Manager_PMFKey__c ,
                SS_MF_PMFKey__c , SS_PPM_Manager_PMFKey__c , SS_PPM_PMFKey__c , SS_SA_Manager_PMFKey__c , SS_SA_PMFKey__c , SS_SEC_Manager_PMFKey__c ,
                SS_SEC_PMFKey__c , SS_VSA_Manager_PMFKey__c , SS_VSA_PMFKey__c , MSP_Account_Owner__c
               from TAQ_Account__c where Account_Owner_PMF_Key__c <> null LIMIT 5];
       for(TAQ_Account__c t: lstTa)
           mapOldNewPositionId.put(t.Account_Owner_PMF_Key__c, 'test_pmf_o1');
            
       FutureProcessor_TAQ.UpdatePositionId(mapOldNewPositionId, lstTa);
       FutureProcessor_TAQ.FutureUpdatePositionId(mapOldNewPositionId);
       List<TAQ_Organization__c> lstOrg = [Select id, Manager_PMF_Key__c  from TAQ_Organization__c where Manager_PMF_Key__c  <> null limit 5];
       Map<string,string> PMFPositionIdmap = new Map<string,string>();
       Map<string,Date> PMFDatemap = new Map<string,Date>();
       Map<string,string> PMFNameMap = new Map<string,string>();
       for(TAQ_Organization__c t:lstOrg)
           {
               PMFPositionIdmap.put(t.Manager_PMF_Key__c, 'testA01');
               PMFDatemap.put(t.Manager_PMF_Key__c, date.today().tostartofmonth());
               PMFNameMap.put(t.Manager_PMF_Key__c, 'dummy, user');
               
           }
       
       FutureProcessor_TAQ.UpdateSubordinate(PMFPositionIdmap,PMFDatemap, PMFNameMap);
       lstTa = [Select Account_Owner_PMF_Key__c,SS_VSA_PMFKey__c,SS_PPM_PMFKey__c,SS_MF_PMFKey__c,SS_SEC_PMFKey__c, SS_SA_PMFKey__c
       from taq_account__c where 
       Account_Owner_PMF_Key__c <> null or 
       SS_VSA_PMFKey__c <> null 
       or SS_PPM_PMFKey__c <> null 
       or SS_MF_PMFKey__c <> null or
       SS_SEC_PMFKey__c <> null or
       SS_SA_PMFKey__c <> null
       limit 10];
       List<string> pmfkys = new List<string>();
       List<string> lstAESE = new List<string>();
      for(TAQ_Account__c t: lstTa)
       {
           if(t.Account_Owner_PMF_Key__c <> null)
           {
               pmfkys.add(t.Account_Owner_PMF_Key__c);
               lstAESE.add('TAESE01');  
           }
           if(t.SS_VSA_PMFKey__c <> null)
           {
               pmfkys.add(t.SS_VSA_PMFKey__c);
               lstAESE.add('TAESE01');  
           }
           if(t.SS_PPM_PMFKey__c <> null)
           {
               pmfkys.add(t.SS_PPM_PMFKey__c);
               lstAESE.add('TAESE01');  
           }
           if(t.SS_MF_PMFKey__c <> null)
           {
               pmfkys.add(t.SS_MF_PMFKey__c);
               lstAESE.add('TAESE01');  
           }
           if(t.SS_SEC_PMFKey__c <> null)
           {
               pmfkys.add(t.SS_SEC_PMFKey__c);
               lstAESE.add('TAESE01');  
           }
           
           if(t.SS_SA_PMFKey__c <> null)
           {
               pmfkys.add(t.SS_SA_PMFKey__c);
               lstAESE.add('TAESE01');  
           }
           
       }
  test.starttest();          
       FutureProcessor_TAQ.UpdateTAQAccountAESEPMFKeys(pmfkys,lstAESE);
        
  test.stoptest();     
 
     }
 }*/