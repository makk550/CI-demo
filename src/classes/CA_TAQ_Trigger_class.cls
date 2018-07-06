/**
* Description  : This Class contains methods to insert the records in TAQ Account Approved object and 
*                TAQ Org Approved Object and also includes various actions which needs to be performed 
*                at Open Headcount/New-Hire/Employe change/Term-Transfer processes.
*               
* Author       : Amasa03
* Last Update  : November 2015
 * with reference to AR#3794
 
**/ 

public class CA_TAQ_Trigger_class{
   public static boolean isflagRejected = true; // CRM Sprint 4  
   
 //  public Static List<TAQ_Account_Team__c> lstNewInsrt = new List<TAQ_Account_Team__c>();
 //  public Static List<TAQ_Account_Team__c> lstOldDelete = new List<TAQ_Account_Team__c>();
 //  public static integer revertedTATCount = 0;
   public Static List<TAQ_Org_Quota__c> lstNewInsrt_OrgQuota = new List<TAQ_Org_Quota__c>();
   public Static List<TAQ_Org_Quota__c> lstOldDelete_OrgQuota = new List<TAQ_Org_Quota__c>();
 //CRM Sprint 4 - Start 
 /*** Copy the last modified value from TAQ Org Approved Object once a record is Rejected  ***/

   public Map<id,TAQ_Organization__c> massCopyTAQOrg(Map<id,TAQ_Organization__c> mapRejected){
        
        if(isflagRejected){
            isflagRejected=false;
           
            Map<id,TAQ_Organization_Approved__c> mapApproved = new Map<id,TAQ_Organization_Approved__c>();
/*FY13 - Commented and re-written below.
            for(TAQ_Organization_Approved__c ta :[select id, Position_Id__c, Position_ID_Status__c,
            PMFKey__c,Employee_Name__c,
            Open_Priority__c,Employee_Status_Date__c,Organization__c,Market__c,Region__c,
            Area__c,Territory__c,Country__c,Job_Title__c,Role__c,Role_Effective_Date__c,
            Cost_Center_Desc__c,Org_Type__c,Approval_Process_Status__c,
            Record_Status__c,Decision_Reason__c,Market_Focus_Area__c,Quota1_PNCV__c,
            Process_Step__c,AE_SE_PMFKey__c,Manager_PMFKey__c,Manager_Name__c,Manager_Effective_Date__c,
            Distribute_Plan__c,Comments__c,Business_Unit__c,Plan_Type__c,PlanType_Effective_Date__c,
            Plantype_Delimited_Date__c,Plan_Reset__c,IC_Currency__c,IC_Amount__c,
            Standard_Flat_Rate__c,Non_Standard_Flat_Rate__c,Weighted_IC_PNCV__c,
            Quota_Currency__c,Quota1_BU__c,Quota1_SNCV__c,Quota1_Type__c,
            Quota1_Other__c,Quota2_BU__c,Quota2_Type__c,Quota_2_PNCV_ENCV__c,Quota2_SNCV__c,
            Quota2_Other__c,Quota3_BU__c,Quota3_Territory_Country__c,Quota3_Type__c,Quota3_Service__c,
            Quota3_Product_EDU__c,Quota3_Other__c,Overlay1_Code__c,Overlay2_Code__c,Overlay3_Code__c,
            TAQ_Organization__c,IS_CSU_Subscriptions__c, Quota1_Mainframe_Time__c, Vurv_Req_ID__c,
            Quota1_ENCV__c,Constant_Scale__c,Quota1_Mainframe_Capacity__c,Quota1_Territory_Country__c,
            Quota2_Education__c,Quota3_Education__c,Quota2_Mainframe_Time__c,Quota2_Mainframe_Capacity__c,
            Quota3_Mainframe_Time__c,Quota3_Mainframe_Capacity__c,Quota_Carrier__c,ownerid,Employee_Status__c,
            Quota1_Territory_And_Country__c, Quota1_Territory_Country_Approved__c, Quota2_Territory_And_Country__c, Quota2_Territory_Country_Approved__c, Quota3_Territory_And_Country__c, Quota3_Territory_Country_Approved__c, TAQ_Plan_ID__c
            from TAQ_Organization_Approved__c where TAQ_Organization__c in :mapRejected.keyset() and Is_Latest_Record__c=true])
            {
                    mapApproved.put(ta.TAQ_Organization__c, ta);
            }
*/
          for(TAQ_Organization_Approved__c ta :[select Proration__c,id,Country_picklist__c, Position_Id__c, Position_ID_Status__c,
            PMFKey__c,Employee_Name__c,
            Open_Priority__c,Employee_Status_Date__c,Organization__c,/*FY13Market__c,*/Region__c,
            Area__c,Territory__c,Country__c,Job_Title__c,Role__c,/*FY13Role_Effective_Date__c,*/
            Cost_Center_Desc__c,/*Org_Type__c,*/Approval_Process_Status__c,
            Record_Status__c,Decision_Reason__c,/*Fy13Market_Focus_Area__c,Quota1_PNCV__c,*/
            Process_Step__c,/*FY13AE_SE_PMFKey__c,*/Manager_PMFKey__c,Manager_Name__c,/*FY14Manager_Effective_Date__c,*/Manager_Org__c,
            Distribute_Plan__c,Comments__c,Business_Unit__c,Plan_Type__c,PlanType_Effective_Date__c,
            Plantype_Delimited_Date__c,Plan_Reset__c,IC_Currency__c,IC_Amount__c,Employee_Status__c,ownerid,
            Secondary_CSU_BU__c,Account_Segment__c,Account_Territory_Coverage__c,/*FY14-Deleting Field.Beachhead__c,*/
            /*FY13Standard_Flat_Rate__c,Non_Standard_Flat_Rate__c,Weighted_IC_PNCV__c,*/
           /*Fy13 Quota_Currency__c,Quota1_BU__c,Quota1_SNCV__c,Quota1_Type__c,
            Quota1_Other__c,Quota2_BU__c,Quota2_Type__c,Quota_2_PNCV_ENCV__c,Quota2_SNCV__c,
            Quota2_Other__c,Quota3_BU__c,Quota3_Territory_Country__c,Quota3_Type__c,Quota3_Service__c,
            Quota3_Product_EDU__c,Quota3_Other__c,Overlay1_Code__c,Overlay2_Code__c,Overlay3_Code__c, */
            TAQ_Organization__c,/*FY13IS_CSU_Subscriptions__c, Quota1_Mainframe_Time__c,*/ Vurv_Req_ID__c,
           /*FY13 Quota1_ENCV__c,Constant_Scale__c,Quota1_Mainframe_Capacity__c,Quota1_Territory_Country__c,
            Quota2_Education__c,Quota3_Education__c,Quota2_Mainframe_Time__c,Quota2_Mainframe_Capacity__c,
            Quota3_Mainframe_Time__c,Quota3_Mainframe_Capacity__c,Quota_Carrier__c,
            Quota1_Territory_And_Country__c, Quota1_Territory_Country_Approved__c, Quota2_Territory_And_Country__c, Quota2_Territory_Country_Approved__c, Quota3_Territory_And_Country__c, Quota3_Territory_Country_Approved__c, */TAQ_Plan_ID__c
            from TAQ_Organization_Approved__c where TAQ_Organization__c in :mapRejected.keyset() and Is_Latest_Record__c=true])
            {
                    mapApproved.put(ta.TAQ_Organization__c, ta);
            }
            
            for(id orgId : mapRejected.keyset())
            {
                TAQ_Organization__c rejectedOrg = mapRejected.get(orgId);
                TAQ_Organization_Approved__c OrgApproved = mapApproved.get(orgId);

            
            if(OrgApproved <> null)
            {
    /*FY13        rejectedOrg.Quota1_Territory_And_Country__c = OrgApproved.Quota1_Territory_And_Country__c; //New field added in TAQ Organization Approved
            rejectedOrg.Quota1_Territory_Country__c = OrgApproved.Quota1_Territory_Country_Approved__c; //New field added in TAQ Organization Approved
          
            rejectedOrg.Quota2_Territory_And_Country__c = OrgApproved.Quota2_Territory_And_Country__c; //New field added in TAQ Organization Approved
            rejectedOrg.Quota2_Territory_Country__c = OrgApproved.Quota2_Territory_Country_Approved__c; //New field added in TAQ Organization Approved
            rejectedOrg.Quota3_Territory_And_Country__c = OrgApproved.Quota3_Territory_And_Country__c; //New field added in TAQ Organization Approved
            rejectedOrg.Quota3_Territory_Country__c = OrgApproved.Quota3_Territory_Country_Approved__c; //New field added in TAQ Organization Approved
      */      rejectedOrg.TAQ_Plan_ID__c = OrgApproved.TAQ_Plan_ID__c; //New field added in TAQ Organization Approved
            rejectedOrg.Vurv_Req_ID__c = OrgApproved.Vurv_Req_ID__c;
            rejectedOrg.Proration__c = OrgApproved.Proration__c;

            rejectedOrg.Position_Id__c = OrgApproved.Position_Id__c;
            rejectedOrg.Secondary_CSU_BU__c = OrgApproved.Secondary_CSU_BU__c;
            rejectedOrg.Account_Segment__c = OrgApproved.Account_Segment__c;
            rejectedOrg.Account_Territory_Coverage__c = OrgApproved.Account_Territory_Coverage__c;
         //FY14-Deleting field.   rejectedOrg.Beachhead__c = OrgApproved.Beachhead__c;
            rejectedOrg.Position_ID_Status__c= OrgApproved.Position_ID_Status__c;
            rejectedOrg.PMFKey__c= OrgApproved.PMFKey__c;
            rejectedOrg.Employee_Name__c= OrgApproved.Employee_Name__c;
            rejectedOrg.Employee_Status__c= OrgApproved.Employee_Status__c;
            rejectedOrg.Open_Priority__c= OrgApproved.Open_Priority__c;
            rejectedOrg.Employee_Status_Date__c= OrgApproved.Employee_Status_Date__c;
            rejectedOrg.Organization__c= OrgApproved.Organization__c;
      //Fy13     rejectedOrg.Market__c= OrgApproved.Market__c;
            rejectedOrg.Region__c= OrgApproved.Region__c;
            rejectedOrg.Area__c= OrgApproved.Area__c;
            rejectedOrg.Territory__c= OrgApproved.Territory__c;
            rejectedOrg.Country__c= OrgApproved.Country__c;
            rejectedOrg.JobTitle__c= OrgApproved.Job_Title__c;
            rejectedOrg.Role__c= OrgApproved.Role__c;
    //FY13        rejectedOrg.Role_Effective_Date__c= OrgApproved.Role_Effective_Date__c;
            rejectedOrg.Cost_Center_Desc__c= OrgApproved.Cost_Center_Desc__c;
     //Fy13       rejectedOrg.Org_Type__c=OrgApproved.Org_Type__c;
      //Fy13      rejectedOrg.Market_Focus_Area__c=OrgApproved.Market_Focus_Area__c;
      //FY13      rejectedOrg.Quota1_PNCV__c=OrgApproved.Quota1_PNCV__c;
                    
        //    rejectedOrg.Process_Step__c=OrgApproved.Process_Step__c;
      //Fy13      rejectedOrg.AE_SE_PMFKey__c=OrgApproved.AE_SE_PMFKey__c;
            
            rejectedOrg.Manager_PMF_Key__c= OrgApproved.Manager_PMFKey__c;
            rejectedOrg.Manager_Name__c= OrgApproved.Manager_Name__c;
       //FY14     rejectedOrg.Manager_Effective_Date__c = OrgApproved.Manager_Effective_Date__c;
         //FY14
         rejectedOrg.Country_Picklist__c = OrgApproved.Country_Picklist__c; 
             rejectedOrg.Manager_Org__c = OrgApproved.Manager_Org__c;
            
            rejectedOrg.Distribute_Plan__c= OrgApproved.Distribute_Plan__c;
            rejectedOrg.Comments__c= OrgApproved.Comments__c;
            rejectedOrg.Business_Unit__c= OrgApproved.Business_Unit__c;
            rejectedOrg.Plan_Type__c= OrgApproved.Plan_Type__c;
                
            rejectedOrg.PlanType_Effective_Date__c= OrgApproved.PlanType_Effective_Date__c;
            rejectedOrg.Plantype_Delimited_Date__c= OrgApproved.Plantype_Delimited_Date__c;
            rejectedOrg.Plan_Reset__c= OrgApproved.Plan_Reset__c;
            
            rejectedOrg.IC_Currency__c=OrgApproved.IC_Currency__c;
            rejectedOrg.IC_Amount__c= OrgApproved.IC_Amount__c;
   //FY13         rejectedOrg.Weighted_IC_PNCV__c=OrgApproved.Weighted_IC_PNCV__c;
  //FY13          rejectedOrg.Standard_Flat_Rate__c=OrgApproved.Standard_Flat_Rate__c;
   //FY13         rejectedOrg.Non_Standard_Flat_Rate__c=OrgApproved.Non_Standard_Flat_Rate__c;
            
  //FY13          rejectedOrg.Weighted_IC_PNCV__c=OrgApproved.Weighted_IC_PNCV__c;
            
   /*FY13         rejectedOrg.Quota_Currency__c = OrgApproved.Quota_Currency__c;
            rejectedOrg.Quota1_BU__c = OrgApproved.Quota1_BU__c;
            rejectedOrg.Quota1_PNCV__c = OrgApproved.Quota1_PNCV__c;
            rejectedOrg.Quota1_SNCV__c = OrgApproved.Quota1_SNCV__c;
           // rejectedOrg.Quota1_Territory_Country_F__c = OrgApproved.Quota1_Territory_Country__c;
            
            rejectedOrg.Quota1_Type__c = OrgApproved.Quota1_Type__c;
            rejectedOrg.Quota1_Other__c = OrgApproved.Quota1_Other__c;
            
            rejectedOrg.Quota2_BU__c = OrgApproved.Quota2_BU__c;
            //rejectedOrg.Quota2_Territory_Country_F__c = OrgApproved.Quota2_Territory_Country__c;
            rejectedOrg.Quota2_Type__c = OrgApproved.Quota2_Type__c;
            rejectedOrg.Quota_2_PNCV_ENCV__c=OrgApproved.Quota_2_PNCV_ENCV__c;
            rejectedOrg.Quota2_SNCV__c=OrgApproved.Quota2_SNCV__c;
            rejectedOrg.Quota2_Other__c = OrgApproved.Quota2_Other__c;
            
            rejectedOrg.Quota3_BU__c = OrgApproved.Quota3_BU__c;
            rejectedOrg.Quota3_Territory_And_Country__c=OrgApproved.Quota3_Territory_Country__c;
            rejectedOrg.Quota3_Type__c = OrgApproved.Quota3_Type__c;
            
            rejectedOrg.Quota3_SNCV__c = OrgApproved.Quota3_Service__c;
            rejectedOrg.Quota3_PNCV_ENCV__c = OrgApproved.Quota3_Product_EDU__c;
            rejectedOrg.Quota3_Other__c = OrgApproved.Quota3_Other__c;
            
           
            rejectedOrg.Overlay1_Code__c = OrgApproved.Overlay1_Code__c;
            rejectedOrg.Overlay2_Code__c = OrgApproved.Overlay2_Code__c;
            rejectedOrg.Overlay3_Code__c = OrgApproved.Overlay3_Code__c;
            
       
            rejectedOrg.Constant_Scale__c =OrgApproved.Constant_Scale__c;
            rejectedOrg.Quota_Carrier__c= OrgApproved.Quota_Carrier__c;
            rejectedOrg.Quota1_ENCV__c   =   OrgApproved.Quota1_ENCV__c;
          
            rejectedOrg.Constant_Scale__c    =OrgApproved.Constant_Scale__c;
  
            rejectedOrg.IS_CSU_Subscriptions__c =OrgApproved.IS_CSU_Subscriptions__c;
            rejectedOrg.Quota1_Mainframe_Time__c=OrgApproved.Quota1_Mainframe_Time__c;
            
            rejectedOrg.Quota1_Mainframe_Capacity__c =OrgApproved.Quota1_Mainframe_Capacity__c;
            rejectedOrg.Quota2_ENCV__c=OrgApproved.Quota2_Education__c;
            rejectedOrg.Quota3_Education__c= OrgApproved.Quota3_Education__c;
           
            rejectedOrg.Quota2_Mainframe_Time__c= OrgApproved.Quota2_Mainframe_Time__c;
            
            rejectedOrg.Quota2_Mainframe_Capacity__c =OrgApproved.Quota2_Mainframe_Capacity__c;
            
            
           
            rejectedOrg.Quota3_Mainframe_Time__c=OrgApproved.Quota3_Mainframe_Time__c;
           
            rejectedOrg.Quota3_Mainframe_Capacity__c =OrgApproved.Quota3_Mainframe_Capacity__c;
            
            
           
            rejectedOrg.Quota_Carrier__c =   OrgApproved.Quota_Carrier__c;
     */     
            rejectedOrg.ownerid = OrgApproved.ownerid;
            
           
        }
        }
 		
       System.debug('before revert______');
       // Reverting the Approved TAQ Org Quota. 
       // AR3794 by AMASA03
        try{
            System.debug('in revert______'+mapRejected.keySet());
          	List<TAQ_Org_Quota__c> oldTAQOrgQuota = [SELECT Id,Name,Plan_type__c,Mainframe_Time__c,Country_picklist__c,Weighting__c,
                    Segment__c,Services__c, Services_USD__c, Region__c,Territory__c,
                    Quota_Type__c,Quota_Total__c, Quota_Total_USD__c,
                     Quota_Holder__c, Prorated_Services__c, Prorated_Quota_Total__c,
                      Prorated_Product__c, Prorated_Other__c, Prorated_Mainframe_Capacity__c, Prorated_Education__c, 
                      Product__c, Product_USD__c, Overlay_Code__c,Overlay_Code_Description__c,
                       Other__c,Other_USD__c, Merlin_Territory_Country__c,
                       Mainframe_Capacity__c, Mainframe_Capacity_USD__c, Flat_Rate__c, Education__c, 
                       Education_USD__c, Country__c, CSU_BU__c, Area__c,Quota_Currency__c from TAQ_Org_Quota__c where TAQ_Organization__c in: mapRejected.keySet()];
        
                 List<TAQ_Organization_Approved__c> latestApprovedTAQOrgRecs = [SELECT Id,TAQ_Organization__c from TAQ_Organization_Approved__c where TAQ_Organization__c in: mapRejected.keySet() and Is_Latest_Record__c = true];
                  List<TAQ_Org_Quota_Approved__c> approvedOrgQuota = [Select Name,Plan_type__c,Mainframe_Time__c,Country_picklist__c,Weighting__c, Time__c, Territory_Country__c,
                    TAQ_Organization_Approved__c, TAQ_Organization_Approved__r.TAQ_Organization__c, 
                    Segment__c,Services__c, Services_USD__c, Region__c,
                    Quota_Type__c, Quota_Type_Callidus__c, Quota_Total__c, Quota_Total_USD__c,
                     Quota_Holder__c, Prorated_Services__c, Prorated_Quota_Total__c,
                      Prorated_Product__c, Prorated_Other__c, Prorated_Mainframe_Capacity__c, Prorated_Education__c, 
                      Product__c, Product_USD__c, Overlay_Code__c,
                       Other__c,Other_USD__c, Merlin_Territory_Country__c,Overlay_Code_Description__c,
                       Mainframe_Capacity__c, Mainframe_Capacity_USD__c, Flat_Rate__c, Education__c, 
                       Education_USD__c, Country__c, CSU_BU__c, Area__c,Quota_Currency__c From TAQ_Org_Quota_Approved__c where TAQ_Organization_Approved__c in: latestApprovedTAQOrgRecs];  
             
                
                List<TAQ_Org_Quota__c> updatedTAQorgQUotas = new List<TAQ_Org_Quota__c>();
                 for(TAQ_Org_Quota__c tOld: oldTAQOrgQuota){
                     Integer tempval = 0;
                     for(TAQ_Org_Quota_Approved__c tNew: approvedOrgQuota){
                         //comparing taqorg quota Approved record name with taqorg quota record                       
                         if( tNew.Name == tOld.Name){
                             tempval = 1;
                             if(tOld.Weighting__c != tNew.Weighting__c){
                                 tOld.Weighting__c= tNew.Weighting__c;
                                 
                             }
                             if(tOld.Territory__c != tNew.Territory_Country__c){
                                 tOld.Territory__c = tNew.Territory_Country__c;
                             }
                             if(tOld.Segment__c != tNew.Segment__c){
                                 tOld.Segment__c = tNew.Segment__c;
                             }
                             if(tOld.Services__c != tNew.Services__c){
                                 tOld.Services__c= tNew.Services__c;
                             }
                             if(tOld.Region__c != tNew.Region__c){
                                 tOld.Region__c = tNew.Region__c;
                             }
                             if(tOld.Quota_Type__c != tNew.Quota_Type__c){
                                 tOld.Quota_Type__c = tNew.Quota_Type__c ;
                             }
                             if(tOld.Quota_Holder__c != tNew.Quota_Holder__c){
                                 tOld.Quota_Holder__c = tNew.Quota_Holder__c ;
                             }
                             if(tOld.Product__c != tNew.Product__c){
                                 tOld.Product__c = tNew.Product__c ;
                             }
                             if(tOld.Overlay_Code__c != tNew.Overlay_Code__c){
                                 tOld.Overlay_Code__c = tNew.Overlay_Code__c ;
                             }
                             if(tOld.Other__c != tNew.Other__c)
                             {
                                  tOld.Other__c = tNew.Other__c ;
                             }
 							if(tOld.Merlin_Territory_Country__c != tNew.Merlin_Territory_Country__c)
                             {
                                 tOld.Merlin_Territory_Country__c = tNew.Merlin_Territory_Country__c ;   
                             }                          
 							if(tOld.Mainframe_Capacity__c != tNew.Mainframe_Capacity__c)
                             {
                                 tOld.Mainframe_Capacity__c = tNew.Mainframe_Capacity__c ;
                             }  
 							if(tOld.Flat_Rate__c != tNew.Flat_Rate__c)
                             {
                                 tOld.Flat_Rate__c = tNew.Flat_Rate__c ;
                             }  
 							if(tOld.Education__c != tNew.Education__c)
                             {
                                 tOld.Education__c = tNew.Education__c ;
                             }                          
                             if(tOld.Country__c != tNew.Country__c)
                             {
                                 tOld.Country__c = tNew.Country__c ;
                             }
 							if(tOld.CSU_BU__c != tNew.CSU_BU__c)
                             {
                                 tOld.CSU_BU__c = tNew.CSU_BU__c ;
                             }                          
 							if(tOld.Area__c != tNew.Area__c)
                             {
                                 tOld.Area__c = tNew.Area__c ;
                             }  
 							if(tOld.quota_currency__c != tNew.quota_currency__c)
                             {
                                 tOld.quota_currency__c = tNew.quota_currency__c ;
                             }  
 							if(tOld.Mainframe_Time__c != tNew.Mainframe_Time__c)
                             {
                                 tOld.Mainframe_Time__c = tNew.Mainframe_Time__c; //GODVA01
                             }                          
                             if(tOld.Country_Picklist__c != tNew.Country_Picklist__c){
                                 tOld.Country_Picklist__c = tNew.Country_Picklist__c;
                             }
                             if(tOld.Plan_Type__c != tNew.Plan_Type__c){
                                 tOld.Plan_Type__c = tNew.Plan_Type__c;
                             }
                             if(tOld.Overlay_Code_Description__c != tNew.Overlay_Code_Description__c){
                                 tOld.Overlay_Code_Description__c = tNew.Overlay_Code_Description__c;
                             }
                          
                           updatedTAQorgQUotas.add(tOld);
                             
                         }//end of if(tNew.Name == tOld.Name)
                         
                         
                     }//end of inner for loop
                     if( tempval == 0){
                         System.debug('record not existing in approved records');
                         lstOldDelete_OrgQuota.add(tOld);
                     }
                    
                 }// end of outer for loop
       // }
            if(updatedTAQorgQUotas.size()>0){
                //System.debug('length of updated list is :'+ updatedTAQorgQUotas.size());
                //System.debug('inside update');
                database.update(updatedTAQorgQUotas);
            }
            
        }catch(Exception e){
            System.debug('____Exception occurred while reverting TAQ Org Quota records:'+e.getMessage());
        }
        }
        return mapRejected;
     }
    
     

  /*** Copy the last modified value from TAQ Account Approved Object once a record is Rejected  ***/   
  // Added by raipa02 on 09/11/11 for sprint 4
 
     public Map<id,TAQ_Account__c> massCopyTAQAcc(Map<id,TAQ_Account__c> mapAccRejected){
        
        if(isflagRejected){
            isflagRejected=false;
           
             Map<id,TAQ_Account_Approved__c> mapAccApproved = new Map<id,TAQ_Account_Approved__c>();

            for(TAQ_Account_Approved__c tac :[select id,Country_picklist__c, Name,Global_Parent_Segment__c,Coverage_Model__c,Segment__c, TAQ_Account__c, Account_ID_being_Merged__c,AD_Renewal__c,Partner_Enablement_Addendum_Attached__c,  DUNS_Number__c, Business_Name__c, International_Split__c, 
             Contract_Expiration_Date__c, Contract_Start_Date__c, Program_Level__c, Contract_Type__c, CPMS_Id__c, Reseller_Type__c, Process_Step__c,
             Partner_Account_Owner_PMFKey__c, Partner_Account_Owner_Effective_Date__c, Physical_City__c,
            Physical_State_Province__c, Physical_Street__c, Physical_Zip_Postal_Code__c, Approved_Date_Time__c, Approved_By__c, Enterprise_Id__c, Enterprise_Account_Name__c, Reseller_ID__c,
            Reseller_Name__c,  Region__c, Area__c, Territory__c, Country__c,  Split__c,Split_Type__c, Split_Primary_Account__c,  Stock_Ticker__c, Comments__c, URL__c,
         /* FY13 SS_Virtualise_Service_Automate_Eff_Date__c, SS_Service_Virtu_and_Automation_PMFKEY__c,SS_Mainframe_Effective_Date__c, SS_Security_Compliance_PMFKey__c,  SS_Security_Compliance_Effective_Date__c,
            SS_ServiceAssurance_PMFKey__c, SS_ServiceAssurance_Effective_Date__c,*/Size_of_Company_Annual_Revenue__c,Size_of_Company_Employees__c, Account_Name_Change__c,  
             Account_ID__c, Prevailiing_Account_ID__c, Reason_for_Merger__c, Account_Type1__c, Account_Type2__c, Approval_Status_2__c,
             Decision_Reason__c, Partner_Account_Name_Change__c,Reason_for_Release__c, Request_Type__c, /*Fy13SAM_Manager_PMFKey__c,*/Approval_Process_Status__c,Global_Ultimate_Region__c,  MF_Account__c, /* FY13 MSP_Account_Owner__c,MSP_Account_Owner_Effective_Date__c, */ 
            Global_Ultimate__c,Global_Ultimate_Name__c,  Account_Name_local__c, Account_Name_Local_2_Phonetic__c,Account_Name_Local_3__c, Physical_City_Local__c, Physical_State_Prov_Local__c, Physical_Country_Local__c, Physical_Street_Local__c, Physical_Zip_Local__c, Provide_Partner_Kit__c,
            Agreement__c,Business_Plan__c, Business_Plan_Start_Date__c, Partner_Enablement_Addendum__c, Agreement_Number__c, Agreement_Attached__c, Agreement_End_Date__c, 
            Business_Plan_Attached__c, Business_Plan_End_Date__c, PDS_Addendum_Attached__c, PDS_Addendum__c, Agreement_Start_Date__c,
            Sell_To_Education__c,Sell_To_Mainframe_Capacity__c,Sell_To_Mainframe_Time__c,Sell_To_Product__c,Sell_To_Services__c,
            Sell_Through_Education__c,Sell_Through_Mainframe_Capacity__c,Sell_Through_Mainframe_Time__c,Sell_Through_Product__c,Sell_Through_Services__c,
            Sell_with_Education__c,Sell_with_Mainframe_Capacity__c,Sell_with_Mainframe_Time__c,Sell_with_Product__c,Sell_with_Services__c
            from TAQ_Account_Approved__c where TAQ_Account__c in :mapAccRejected.keyset() and Is_Latest_Record__c=true and  Is_Original__c=true])
        {
            mapAccApproved.put(tac.TAQ_Account__c, tac);
        }
        
        
        for(id AccId : mapAccRejected.keyset())
            {
                TAQ_Account__c rejectedAcc = mapAccRejected.get(AccId);
                TAQ_Account_Approved__c AccApproved = mapAccApproved.get(AccId);

            
                if(AccApproved <> null)
                {
                     rejectedAcc.Name = AccApproved.Name;
                     rejectedAcc.DUNS_Number__c = AccApproved.DUNS_Number__c; 
                     rejectedAcc.Business_Name__c = AccApproved.Business_Name__c; 
                     rejectedAcc.International_Split__c = AccApproved.International_Split__c; 
                    rejectedAcc.Contract_Expiration_Date__c=AccApproved.Contract_Expiration_Date__c;
                    rejectedAcc.Contract_Start_Date__c=AccApproved.Contract_Start_Date__c;
                    rejectedAcc.Program_Level__c=AccApproved.Program_Level__c;
                    rejectedAcc.Contract_Type__c=AccApproved.Contract_Type__c;
                    rejectedAcc.CPMS_Id__c=AccApproved.CPMS_Id__c;
                    rejectedAcc.Reseller_Type__c=AccApproved.Reseller_Type__c;
                    rejectedAcc.Physical_City__c=AccApproved.Physical_City__c;
                
                    rejectedAcc.Physical_State_Province__c=AccApproved.Physical_State_Province__c;
                    rejectedAcc.Physical_Street__c=AccApproved.Physical_Street__c;
                    rejectedAcc.Physical_Zip_Postal_Code__c=AccApproved.Physical_Zip_Postal_Code__c;
                    
                    rejectedAcc.Sell_To_Education__c=AccApproved.Sell_To_Education__c;
                    rejectedAcc.Sell_To_Mainframe_Capacity__c=AccApproved.Sell_To_Mainframe_Capacity__c;
                    rejectedAcc.Sell_To_Mainframe_Time__c=AccApproved.Sell_To_Mainframe_Time__c;
                    rejectedAcc.Sell_To_Product__c=AccApproved.Sell_To_Product__c;
                    rejectedAcc.Sell_To_Services__c=AccApproved.Sell_To_Services__c;
                    
                    rejectedAcc.Sell_Through_Education__c=AccApproved.Sell_Through_Education__c;
                    rejectedAcc.Sell_Through_Mainframe_Capacity__c=AccApproved.Sell_Through_Mainframe_Capacity__c;
                    rejectedAcc.Sell_Through_Mainframe_Time__c=AccApproved.Sell_Through_Mainframe_Time__c;
                    rejectedAcc.Sell_Through_Product__c=AccApproved.Sell_Through_Product__c;
                    rejectedAcc.Sell_Through_Services__c=AccApproved.Sell_Through_Services__c;
                    rejectedAcc.Sell_with_Education__c=AccApproved.Sell_with_Education__c;
                    rejectedAcc.Sell_with_Mainframe_Capacity__c=AccApproved.Sell_with_Mainframe_Capacity__c;
                    rejectedAcc.Sell_with_Mainframe_Time__c=AccApproved.Sell_with_Mainframe_Time__c;
                    rejectedAcc.Sell_with_Product__c=AccApproved.Sell_with_Product__c;
                    rejectedAcc.Sell_with_Services__c=AccApproved.Sell_with_Services__c;
                    rejectedAcc.Enterprise_Id__c= AccApproved.Enterprise_Id__c;
                    if(AccApproved.Enterprise_Id__c!=null)
                    rejectedAcc.Enterprise_Account_Name__c= AccApproved.Enterprise_Account_Name__c;
                    if(AccApproved.Reseller_ID__c!=null)
                    {
                    rejectedAcc.Reseller_ID__c= AccApproved.Reseller_ID__c;
                    rejectedAcc.Reseller_Name__c= AccApproved.Reseller_Name__c;
                    }
                    rejectedAcc.Region__c= AccApproved.Region__c;
                    rejectedAcc.Area__c= AccApproved.Area__c;
                    rejectedAcc.Territory__c= AccApproved.Territory__c;
                    rejectedAcc.Country__c= AccApproved.Country__c;
                    rejectedAcc.Split__c= AccApproved.Split__c;
                    rejectedAcc.Split_Type__c= AccApproved.Split_Type__c;
                    rejectedAcc.Is_Primary_Account__c=AccApproved.Split_Primary_Account__c;
                 
                    rejectedAcc.Stock_Ticker__c= AccApproved.Stock_Ticker__c;
                    rejectedAcc.Comments__c= AccApproved.Comments__c;
                    rejectedAcc.URL__c= AccApproved.URL__c;
                    rejectedAcc.Size_of_Company_Annual_Revenue__c=AccApproved.Size_of_Company_Annual_Revenue__c;
                    rejectedAcc.Size_of_Company_Employees__c=AccApproved.Size_of_Company_Employees__c;
                    rejectedAcc.Account_ID__c=AccApproved.Account_ID__c;
                    rejectedAcc.Reason_for_Release__c=AccApproved.Reason_for_Release__c;
                    rejectedAcc.Account_ID_being_Merged__c=AccApproved.Account_ID_being_Merged__c;
                    rejectedAcc.Prevailiing_Account_ID__c=AccApproved.Prevailiing_Account_ID__c;
                    rejectedAcc.Reason_for_Merger__c=AccApproved.Reason_for_Merger__c;
                    rejectedAcc.Account_Type1__c=AccApproved.Account_Type1__c;
                    rejectedAcc.Account_type__c  = AccApproved.Account_Type2__c;
                    rejectedAcc.Account_Name_Change__c=AccApproved.Partner_Account_Name_Change__c;
                    
                    rejectedAcc.Process_Step__c=AccApproved.Request_Type__c;
                    rejectedAcc.AD_Renewal__c= AccApproved.AD_Renewal__c;

                    rejectedAcc.Global_Ultimate_Region__c=AccApproved.Global_Ultimate_Region__c;
                    rejectedAcc.MF_Account__c=AccApproved.MF_Account__c;

                    rejectedAcc.Global_Ultimate__c=AccApproved.Global_Ultimate__c;
                    rejectedAcc.Global_Ultimate_Name__c=AccApproved.Global_Ultimate_Name__c;
       
                    rejectedAcc.Account_Name_local__c=AccApproved.Account_Name_Local__c;
                    rejectedAcc.Account_Name_Local_2_Phonetic__c=AccApproved.Account_Name_Local_2_Phonetic__c;   
                    rejectedAcc.Account_Name_Local_3__c=AccApproved.Account_Name_Local_3__c;
                    rejectedAcc.Physical_City_Local__c=AccApproved.Physical_City_Local__c;
                    rejectedAcc.Physical_State_Prov_Local__c=AccApproved.Physical_State_Prov_Local__c;
                    rejectedAcc.Physical_Country_Local__c=AccApproved.Physical_Country_Local__c;
                    rejectedAcc.Physical_Street_Local__c=AccApproved.Physical_Street_Local__c;          
                    rejectedAcc.Physical_Zip_Local__c=AccApproved.Physical_Zip_Local__c;
                
                  rejectedAcc.Provide_Partner_Kit__c=AccApproved.Provide_Partner_Kit__c;
                  rejectedAcc.Agreement__c=AccApproved.Agreement__c;
                  rejectedAcc.Contract_Start_Date__c=AccApproved.Contract_Start_Date__c;
                  rejectedAcc.Business_Plan__c=AccApproved.Business_Plan__c;
                  rejectedAcc.Business_Plan_Start_Date__c=AccApproved.Business_Plan_Start_Date__c;
                  rejectedAcc.Partner_Enablement_Addendum__c=AccApproved.Partner_Enablement_Addendum__c;
                  rejectedAcc.Agreement_Number__c=AccApproved.Agreement_Number__c;
                  rejectedAcc.Agreement_Attached__c=AccApproved.Agreement_Attached__c;
                  rejectedAcc.Agreement_End_Date__c=AccApproved.Agreement_End_Date__c;
                  rejectedAcc.Business_Plan_Attached__c=AccApproved.Business_Plan_Attached__c;
                  rejectedAcc.Business_Plan_End_Date__c=AccApproved.Business_Plan_End_Date__c;
                  rejectedAcc.PDS_Addendum_Attached__c=AccApproved.PDS_Addendum_Attached__c;
                  rejectedAcc.Partner_Enablement_Addendum_Attached__c=AccApproved.Partner_Enablement_Addendum_Attached__c;
                  rejectedAcc.PDS_Addendum__c=AccApproved.PDS_Addendum__c;
                  rejectedAcc.Agreement_Start_Date__c=AccApproved.Agreement_Start_Date__c;
                  rejectedAcc.Account_Type1__c=AccApproved.Account_Type1__c;
                  rejectedAcc.Reseller_Type__c=AccApproved.Reseller_Type__c;
                  rejectedAcc.CPMS_Id__c=AccApproved.CPMS_Id__c;
                  //FY14 ADDED
                  rejectedAcc.Global_Parent_Segment__c=AccApproved.Global_Parent_Segment__c;
                  rejectedAcc.Coverage_Model__c=AccApproved.Coverage_Model__c;
                  rejectedAcc.Segment__c = AccApproved.Segment__c;
                  rejectedAcc.Country_Picklist__c = AccApproved.Country_Picklist__c;  
                }    
            }
        }      
    return mapAccRejected;


}
 //CRM Sprint 4 - End 
 
 public void revertTAQAccountTeam(List<Id> rejectedTAQAccs){
 // Reverting the Approved TAQ Account Team. 
      
       System.debug('_________trying 1______'+rejectedTAQAccs);
         try{
            List<TAQ_Account_team__c> delTAQAccTeamList = new List<TAQ_Account_Team__c>();
            List<TAQ_Account_Team__c> insTAQAccTeamList = new List<TAQ_Account_Team__c>();
            System.debug('_________trying 2______');
          List<TAQ_Account_Team__c> oldTAQAccountTeam = [SELECT Id from TAQ_Account_Team__c where TAQ_Account__c in: rejectedTAQAccs];
                    delTAQAccTeamList.addAll(oldTAQAccountTeam);   
                       System.debug('_________trying 3______');
                 List<TAQ_Account_Approved__c> latestApprovedTAQAccts = [SELECT Id,TAQ_Account__c from TAQ_Account_Approved__c where TAQ_Account__c in: rejectedTAQAccs and Is_Latest_Record__c = true];
                 List<TAQ_Account_Team_Approved__c> approvedActTeam = [Select TAQ_Role__c,TAQ_Account_Approved__c,TAQ_Account_Approved__r.TAQ_Account__c,Role__c,Primary_Secondary__c,Percentage__c,PMFKey__c, OwnerId, Name,Is_Latest_Record__c, Is_Account_Owner__c,Effective_Date__c From TAQ_Account_Team_Approved__c where TAQ_Account_Approved__c in: latestApprovedTAQAccts ];  
                 List<TAQ_Account_Team__c> revertedTAQAccountTeam = new List<TAQ_Account_Team__c>();
                 for(TAQ_Account_Team_Approved__c t: approvedActTeam){
                    TAQ_Account_Team__c newAccTeamRec = new TAQ_Account_Team__c();
                          newAccTeamRec.TAQ_Account__c = t.TAQ_Account_Approved__r.TAQ_Account__c;
                          newAccTeamRec.Role__c= t.Role__c;
                          newAccTeamRec.Primary_Secondary__c= t.Primary_Secondary__c;
                          newAccTeamRec.Percentage__c = t.Percentage__c;
                          newAccTeamRec.PMFKey__c= t.PMFKey__c;
                          newAccTeamRec.Is_Account_Owner__c= t.Is_Account_Owner__c;
                          newAccTeamRec.Effective_Date__c = t.Effective_Date__c ;
                       insTAQAccTeamList.add(newAccTeamRec);
                 }     
                 
                 delete delTAQAccTeamList;
                 insert insTAQAccTeamList;
                 System.debug('_________trying 4______');
        }catch(Exception e){
             System.debug('____Exception occurred while reverting TAQ Account team:'+e.getMessage());
        }
    
 }

}