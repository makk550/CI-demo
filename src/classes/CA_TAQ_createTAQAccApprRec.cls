public with sharing class CA_TAQ_createTAQAccApprRec {
    public void createTAQAccApprRec(List<TAQ_Account__c> taqAccs)
    {
        System.debug('______________in the class_______'+taqAccs.size());
         List<TAQ_Account_Approved__c> listapp=new List<TAQ_Account_Approved__c>();
         List<Id> relTAQAccIds = new List<Id>();
                for(TAQ_Account__c eachTAQAcc: taqAccs)
                {
                    relTAQAccIds.add(eachTAQAcc.Id);      
                }
                
                TAQ_Account_Approved__c[] objarr=[select id,Is_Latest_Record__c from TAQ_Account_Approved__c where TAQ_Account__c in: relTAQAccIds and Is_Latest_Record__c=true];
                    if(objarr.size()>0)
                    {
                        for(Integer i=0;i<objarr.size();i++)
                              objarr[i].Is_Latest_Record__c=false;                    
                        update objarr;
                    }
    
    // FOR CREATING TAQ_ACCOUNT_APPROVED RECS.
         for(TAQ_Account__c eachTAQAcc: taqAccs){
                TAQ_Account_Approved__c newacc=new TAQ_Account_Approved__c();
                newacc.Is_Latest_Record__c=true;    
                newacc.name=eachTAQAcc.name;
                newacc.TAQ_Account__c = eachTAQAcc.id;
              
                newacc.DUNS_Number__c = eachTAQAcc.DUNS_Number__c; //anssa01 9/20/2011
                newacc.Business_Name__c = eachTAQAcc.Business_Name__c; //anssa01 9/20/2011
                newacc.International_Split__c = eachTAQAcc.International_Split__c; //anssa01 9/20/2011


                
                newacc.Contract_Expiration_Date__c=eachTAQAcc.Contract_Expiration_Date__c;
                newacc.Contract_Start_Date__c=eachTAQAcc.Contract_Start_Date__c;
                newacc.Program_Level__c=eachTAQAcc.Program_Level__c;
                newacc.Contract_Type__c=eachTAQAcc.Contract_Type__c;
                newacc.CPMS_Id__c=eachTAQAcc.CPMS_Id__c;
                newacc.Reseller_Type__c=eachTAQAcc.Reseller_Type__c;
                newacc.Process_Step__c=eachTAQAcc.Process_Step__c;
                //fields added as part of reseller
                newacc.Partner_Account_Owner_PMFKey__c=eachTAQAcc.Reseller_Account_Director_PMFKey__c;
                newacc.Partner_Account_Owner_Effective_Date__c=eachTAQAcc.Reseller_Account_Director_Effective_Date__c;
                
                newacc.Physical_City__c=eachTAQAcc.Physical_City__c;
                //newacc.Physical_Country__c=eachTAQAcc.Physical_Country__c;
                newacc.Physical_State_Province__c=eachTAQAcc.Physical_State_Province__c;
                newacc.Physical_Street__c=eachTAQAcc.Physical_Street__c;
                newacc.Physical_Zip_Postal_Code__c=eachTAQAcc.Physical_Zip_Postal_Code__c;
                    
                newacc.Approved_Date_Time__c=system.now();
                newacc.Approved_By__c=userinfo.getuserid();
    
                newacc.Enterprise_Id__c= eachTAQAcc.Enterprise_Id__c;
                if(eachTAQAcc.Enterprise_Id__c!=null)
                     newacc.Enterprise_Account_Name__c= eachTAQAcc.Enterprise_Account_Name__c;
                if(eachTAQAcc.Reseller_ID__c!=null)
                {
                    newacc.Reseller_ID__c= eachTAQAcc.Reseller_ID__c;
                    newacc.Reseller_Name__c= eachTAQAcc.Reseller_Name__c;
                }
                
             //   newacc.Market_Segment__c= eachTAQAcc.Market_Segment__c;
                newacc.Region__c= eachTAQAcc.Region__c;
                newacc.Area__c= eachTAQAcc.Area__c;
                newacc.Territory__c= eachTAQAcc.Territory__c;
                newacc.Country__c= eachTAQAcc.Country__c;
          //      newacc.Account_Type__c= eachTAQAcc.Account_Type__c;
          //      newacc.Account_Class__c= eachTAQAcc.Account_Class__c;
            //    newacc.Rubric_Class__c= eachTAQAcc.Rubric_Class__c;
                
                newacc.Split__c= eachTAQAcc.Split__c;
                newacc.Split_Type__c= eachTAQAcc.Split_Type__c;
                newacc.Split_Primary_Account__c=eachTAQAcc.Is_Primary_Account__c;
                //Split_Linked_Account
                
            //    newacc.Industry_Vertical__c= eachTAQAcc.Industry_Vertical__c;
                newacc.Stock_Ticker__c= eachTAQAcc.Stock_Ticker__c;
                newacc.Comments__c= eachTAQAcc.Comments__c;
                newacc.URL__c= eachTAQAcc.URL__c;
               
               
             //   newacc.Regional_Alliance_Director_PMF_Key__c=eachTAQAcc.Regional_Alliance_Director_PMF_Key__c;
            //    newacc.Regional_Alliance_Director_Eff_Date__c =eachTAQAcc.Regional_Alliance_Director_Eff_Date__c  ;
     
              
                //Account Mini Form Fields flowing to Account Approved
                
             //   newacc.Third_Split_Owner__c=eachTAQAcc.Third_Split_Owner__c;  
              //  newacc.Where_HQ_is_Located__c=eachTAQAcc.Where_HQ_is_Located__c;
              //  newacc.Secondary_Split_Owner__c=eachTAQAcc.Secondary_Split_Owner__c;
             //   newacc.Primary_Split_Owner__c=eachTAQAcc.Primary_Split_Owner__c;
             
                
                //newacc.Account_Name__c=eachTAQAcc.Account_Name__c;
                //newacc.Account_Request_Type__c=eachTAQAcc.Account_Request_Type__c;
                
              
                newacc.Size_of_Company_Annual_Revenue__c=eachTAQAcc.Size_of_Company_Annual_Revenue__c;
                newacc.Size_of_Company_Employees__c=eachTAQAcc.Size_of_Company_Employees__c;
            //    newacc.Parent_or_Subsidiary__c=eachTAQAcc.Parent_or_Subsidiary__c;
            //    newacc.If_Sub_who_is_Parent__c=eachTAQAcc.If_Sub_who_is_Parent__c;
                newacc.Account_Name_Change__c=eachTAQAcc.Account_Name_Change__c;
           //    newacc.SS_Alignment_Change__c=eachTAQAcc.SS_Alignment_Change__c;
          //      newacc.Quota_Change__c=eachTAQAcc.Quota_Change__c;
              
             
         //       newacc.Territory_Change__c=eachTAQAcc.Territory_Change__c;
               
                newacc.Account_ID__c=eachTAQAcc.Account_ID__c;
                newacc.Reason_for_Release__c=eachTAQAcc.Reason_for_Release__c;
          //      newacc.Open_Opportunities_Sites_move_to_another__c=eachTAQAcc.Open_Opportunities_Sites_move_to_another__c;
                //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 
              
                
                newacc.Account_ID_being_Merged__c=eachTAQAcc.Account_ID_being_Merged__c;
               //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 
                if(eachTAQAcc.Prevailiing_Account_ID__c!=null || eachTAQAcc.Prevailiing_Account_ID__c!= '')
                newacc.Prevailiing_Account_ID__c=eachTAQAcc.Prevailiing_Account_ID__c;
                else
                newacc.Prevailiing_Account_ID__c=eachTAQAcc.Prevailiing_Reseller_Account_ID__c;
                
                newacc.Reason_for_Merger__c=eachTAQAcc.Reason_for_Merger__c;
                
            //    newacc.Primary_Split_Percentage__c=eachTAQAcc.Primary_Split_Percentage__c;
           //     newacc.Secondary_Split_Percentage__c=eachTAQAcc.Secondary_Split_Percentage__c;
            //    newacc.Third_Split_Percentage__c=eachTAQAcc.Third_Split_Percentage__c;
             //   newacc.Fourth_Split_Percentage__c=eachTAQAcc.Fourth_Split_Percentage__c;
                
                //new assignments to accout approved object
                newacc.Account_Type1__c=eachTAQAcc.Account_Type1__c;
            //        newacc.Account_Type2__c=eachTAQAcc.Account_Type__c;
       
                newacc.Approval_Status_2__c=eachTAQAcc.Approval_Status__c;
                newacc.Decision_Reason__c=eachTAQAcc.Reason_for_Rejection__c;
                newacc.Partner_Account_Name_Change__c=eachTAQAcc.Account_Name_Change__c;
                
                newacc.Request_Type__c=eachTAQAcc.Process_Step__c;
              
                newacc.Approval_Process_Status__c=eachTAQAcc.Approval_Process_Status__c;
                // newacc.Effective_Date__c=eachTAQAcc.Effective_Date_Change__c;
                // newacc.Y10_Product_NCV_Quota_USD__c=eachTAQAcc.Y10_Product_NCV_Quota_USD__c;              
                
             //   newacc.Plan_Uplift_Product_NCV_Quota__c=eachTAQAcc.Plan_Uplift_Product_NCV_Quota__c;

                // changed made by rao on 11th March 2011

                    newacc.AD_Renewal__c= eachTAQAcc.AD_Renewal__c;
               //     newacc.SLED_Area__c=eachTAQAcc.SLED_Area__c;
              //      newacc.GSP_Business_Type__c=eachTAQAcc.GSP_Business_Type__c;
                    newacc.Global_Ultimate_Region__c=eachTAQAcc.Global_Ultimate_Region__c;
                 //   newacc.FY12_Direct_Coverage__c=eachTAQAcc.FY12_Direct_Coverage__c;
                    newacc.MF_Account__c=eachTAQAcc.MF_Account__c;
                    
                //    newacc.MSP_Account_Owner__c=eachTAQAcc.MSP_Account_Owner__c;
                //    newacc.MSP_Account_Owner_Effective_Date__c=eachTAQAcc.MSP_Account_Owner_Effective_Date__c;
                //    newacc.GSP_Business_Type__c=eachTAQAcc.GSP_Business_Type__c;
              //      newacc.GSP_EMEA_AD1_Area__c=eachTAQAcc.GSP_EMEA_AD1_Area__c;
               //     newacc.GSP_EMEA_AD2_Area__c=eachTAQAcc.GSP_EMEA_AD2_Area__c;
              //      newacc.GSP_EMEA_AD3_Area__c=eachTAQAcc.GSP_EMEA_AD3_Area__c;
               //      newacc.GSP_EMEA_CSA_Area__c=eachTAQAcc.GSP_EMEA_CSA_Area__c;
               //     newacc.GSP_ENCV_Influence__c=eachTAQAcc.GSP_ENCV_Influence__c;
              //      newacc.GSP_ENCV_RunAndOper__c=eachTAQAcc.GSP_ENCV_RunAndOper__c;
               //     newacc.GSP_NA_AD1_Area__c=eachTAQAcc.GSP_NA_AD1_Area__c;
              //      newacc.GSP_NA_AD2_Area__c=eachTAQAcc.GSP_NA_AD2_Area__c;
              //      newacc.GSP_NA_AD3_Area__c=eachTAQAcc.GSP_NA_AD3_Area__c;
              //     newacc.GSP_NA_CPM_Area__c=eachTAQAcc.GSP_NA_CPM_Area__c;
               ////    newacc.GSP_NA_CSA_Area__c=eachTAQAcc.GSP_NA_CSA_Area__c;
               //     newacc.GSP_NA_SS_SA1_Area__c=eachTAQAcc.GSP_NA_SS_SA1_Area__c;
               //      newacc.GSP_NA_SS_SA2_Area__c=eachTAQAcc.GSP_NA_SS_SA2_Area__c;
               //      newacc.GSP_NA_SS_SA_Mgr1_Area__c=eachTAQAcc.GSP_NA_SS_SA_Mgr1_Area__c;
               //      newacc.GSP_NA_SS_SA_Mgr2_Area__c=eachTAQAcc.GSP_NA_SS_SA_Mgr2_Area__c;
               //     newacc.GSP_PNCV_Influence__c=eachTAQAcc.GSP_PNCV_Influence__c;
               //     newacc.GSP_PNCV_RunAndOper__c=eachTAQAcc.GSP_PNCV_RunAndOper__c;
               //     newacc.GSP_SNCV_Influence__c=eachTAQAcc.GSP_SNCV_Influence__c;
               //     newacc.GSP_SNCV_RunAndOper__c=eachTAQAcc.GSP_SNCV_RunAndOper__c;
               //     newacc.GSP_NA_AD1_Territory__c=eachTAQAcc.GSP_NA_AD1_Territory__c;
               //     newacc.GSP_NA_AD2_Territory__c=eachTAQAcc.GSP_NA_AD2_Territory__c;
                //    newacc.GSP_NA_AD3_Territory__c=eachTAQAcc.GSP_NA_AD3_Territory__c;
                //    newacc.Mainframe_Time_Quota__c=eachTAQAcc.Mainframe_Time_Quota__c;
                //    newacc.Mainframe_Capacity_Quota__c=eachTAQAcc.Mainframe_Capacity_Quota__c;
                    //newacc.Is_Secondary_Account__c=eachTAQAcc.Is_Secondary_Account__c;
                    newacc.Global_Ultimate__c=eachTAQAcc.Global_Ultimate__c;
                    newacc.Global_Ultimate_Name__c=eachTAQAcc.Global_Ultimate_Name__c;
                    

                
              if(eachTAQAcc.Reseller_ID__c!=null)
              {
                //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 'Address Fields Local (APJ)' Added For Reseller.***
                
                newacc.Account_Name_local__c=eachTAQAcc.Account_Name_Local__c;
                newacc.Account_Name_Local_2_Phonetic__c=eachTAQAcc.Account_Name_Local_2_Phonetic__c;   
                newacc.Account_Name_Local_3__c=eachTAQAcc.Account_Name_Local_3__c;
                newacc.Physical_City_Local__c=eachTAQAcc.Physical_City_Local__c;
                newacc.Physical_State_Prov_Local__c=eachTAQAcc.Physical_State_Prov_Local__c;
                newacc.Physical_Country_Local__c=eachTAQAcc.Physical_Country_Local__c;
                newacc.Physical_Street_Local__c=eachTAQAcc.Physical_Street_Local__c;          
                newacc.Physical_Zip_Local__c=eachTAQAcc.Physical_Zip_Local__c;
                
                //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-606'Partner Milestone Section' Added For Reseller.***
                
              newacc.Provide_Partner_Kit__c=eachTAQAcc.Provide_Partner_Kit__c;
              newacc.Agreement__c=eachTAQAcc.Agreement__c;
              newacc.Contract_Start_Date__c=eachTAQAcc.Contract_Start_Date__c;
              newacc.Business_Plan__c=eachTAQAcc.Business_Plan__c;
              newacc.Business_Plan_Start_Date__c=eachTAQAcc.Business_Plan_Start_Date__c;
              newacc.Partner_Enablement_Addendum__c=eachTAQAcc.Partner_Enablement_Addendum__c;
              newacc.Agreement_Number__c=eachTAQAcc.Agreement_Number__c;
              newacc.Agreement_Attached__c=eachTAQAcc.Agreement_Attached__c;
              newacc.Agreement_End_Date__c=eachTAQAcc.Agreement_End_Date__c;
              newacc.Business_Plan_Attached__c=eachTAQAcc.Business_Plan_Attached__c;
              newacc.Business_Plan_End_Date__c=eachTAQAcc.Business_Plan_End_Date__c;
              newacc.PDS_Addendum_Attached__c=eachTAQAcc.PDS_Addendum_Attached__c;
              newacc.Partner_Enablement_Addendum_Attached__c=eachTAQAcc.Partner_Enablement_Addendum_Attached__c;
              newacc.PDS_Addendum__c=eachTAQAcc.PDS_Addendum__c;
              newacc.Agreement_Start_Date__c=eachTAQAcc.Agreement_Start_Date__c;
                
              //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-606'
              newacc.Account_Type1__c=eachTAQAcc.Account_Type1__c;
      //        newacc.Account_Type2__c=eachTAQAcc.Account_Type__c;
              
            
              newacc.Reseller_Type__c=eachTAQAcc.Reseller_Type__c;
              //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-1386'
              newacc.CPMS_Id__c=eachTAQAcc.CPMS_Id__c;
               
              }
                
                
                // Assigned the requestor queue to be the owner of the apporved record
                
                newacc.ownerid = eachTAQAcc.ownerid;
            
                listapp.add(newacc);
            }
            
        insert listapp;
        System.debug('_________a_________'+listapp.size());
        Map<Id,Id> taIds = new Map<Id,Id>();
        for(TAQ_Account_Approved__c t: listapp)
        {
            taIds.put(t.TAQ_Account__c,t.Id);
        }
   
    // CREATING TAQ ACCOUNT TEAM MEMBERS APPROVED LIST TO TAQ ACCOUNT APPROVED RECORDS.   
       List<TAQ_Account_Team__c> actTeam = [SELECT Id,TAQ_Account__c,Effective_Date__c,Is_Account_Owner__c,Percentage__c,PMFKey__c,Primary_Secondary__c,Role__c from TAQ_Account_Team__c where TAQ_Account__c in: relTAQAccIds];
       Map<Id,List<TAQ_Account_Team__c>> accVSaccTeam = new Map<Id,List<TAQ_Account_Team__c>>();
       for(TAQ_Account_Team__c ta: actTeam)
       {
          if(accVSaccTeam.containsKey(ta.TAQ_Account__c))
          {
            accVSaccTeam.get(ta.TAQ_Account__c).add(ta);
          }
          else
          {
            accVSaccTeam.put(ta.TAQ_Account__c, new List<TAQ_Account_Team__c>());
            accVSaccTeam.get(ta.TAQ_Account__c).add(ta);
          }
       }
       
       List<TAQ_Account_Team_Approved__c>  acteamAppr = new List<TAQ_Account_Team_Approved__c>();
       for(TAQ_Account_Approved__c ta: listapp)
       {
          for(TAQ_Account_Team__c t: accVSaccTeam.get(ta.TAQ_Account__c))
          {
            TAQ_Account_Team_Approved__c newTeamApprRec = new TAQ_Account_Team_Approved__c();
              newTeamApprRec.Effective_Date__c = t.Effective_Date__c;
              newTeamApprRec.Is_Account_Owner__c = t.Is_Account_Owner__c;
              newTeamApprRec.Percentage__c = t.Percentage__c;
              newTeamApprRec.PMFKey__c = t.PMFKey__c;
              newTeamApprRec.Primary_Secondary__c = t.Primary_Secondary__c;
              newTeamApprRec.Role__c = t.Role__c;   
              newTeamApprRec.TAQ_Account_Approved__c = ta.Id;
            acteamAppr.add(newTeamApprRec);  
          } 
       }
        Database.Insert(acteamAppr);       
        System.debug('______________in the class____end___'+acteamAppr.size());  
    }
    
    @isTest(SeeAllData=true)
    public static void CA_TAQ_createTAQAccApprRec_test() {
    	try {
    	List<TAQ_Account__c> taqList = [SELECT Account_ID__c, Account_ID_being_Merged__c, Account_Name_Change__c, Account_Name_Local__c, Account_Name_Local_2_Phonetic__c, Account_Name_Local_3__c, Account_Type1__c, AD_Renewal__c, Agreement__c, Agreement_Attached__c, Agreement_End_Date__c, Agreement_Number__c, Agreement_Start_Date__c, Approval_Process_Status__c, Approval_Status__c, Area__c, Business_Name__c, Business_Plan__c, Business_Plan_Attached__c, Business_Plan_End_Date__c, Business_Plan_Start_Date__c, Comments__c, Contract_Start_Date__c, Contract_Type__c, Country__c, CPMS_Id__c, DUNS_Number__c, Enterprise_Account_Name__c, Enterprise_Id__c, Global_Ultimate__c, Global_Ultimate_Name__c, Global_Ultimate_Region__c, International_Split__c, Is_Primary_Account__c, MF_Account__c, name, ownerid, Partner_Enablement_Addendum__c, Partner_Enablement_Addendum_Attached__c, PDS_Addendum__c, PDS_Addendum_Attached__c, Physical_City__c, Physical_City_Local__c, Physical_Country_Local__c, Physical_State_Prov_Local__c, Physical_State_Province__c, Physical_Street__c, Physical_Street_Local__c, Physical_Zip_Local__c, Physical_Zip_Postal_Code__c, Prevailiing_Account_ID__c, Prevailiing_Reseller_Account_ID__c, Process_Step__c, Program_Level__c, Provide_Partner_Kit__c, Reason_for_Merger__c, Reason_for_Rejection__c, Reason_for_Release__c, Region__c, Reseller_Account_Director_Effective_Date__c, Reseller_Account_Director_PMFKey__c, Reseller_ID__c, Reseller_Name__c, Reseller_Type__c, Size_of_Company_Annual_Revenue__c, Size_of_Company_Employees__c, Split__c, Split_Type__c, Stock_Ticker__c, Territory__c, URL__c,Contract_Expiration_Date__c,Id FROM TAQ_Account__c LIMIT 10];
 			CA_TAQ_createTAQAccApprRec testObj = new CA_TAQ_createTAQAccApprRec();
 			testObj.createTAQAccApprRec(taqList);   									 	                           
    	} catch(Exception e) {
    		
    	}
    }  
}