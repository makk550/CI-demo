public class TAQ_OrgActions {
    public static Boolean MGR_PMFCHANGECHECK_REQ = true;
      public void commitActions(List<TAQ_Organization__c> taL)
      { 
        Set<String> pmfKeys = new Set<String>();
        Map<String,String> pmfVSName = new Map<String,String>();
        Map<String,TAQ_Organization__c> managerDetails = new Map<String,TAQ_Organization__c>();
        List<Id> newHireIds = new List<Id>();
        Set<String> posIds = new Set<String>();
        for(TAQ_Organization__c t: taL){
           if(t.Process_Step__c=='Employee Change'){
                pmfkeys.add(t.PMFKey__c);
                pmfVSName.put(t.PMFKey__c,t.Employee_Name__c);
           }        
           if((t.Process_Step__c=='New Hire')||((t.Employee_Status__c=='Transfer-within' || t.Employee_Status__c=='Transfer-Out' || t.Employee_Status__c=='Terminated') && t.Process_Step__c=='Term / Transfer' && t.Position_ID_Status__c<>'Closed')){
              newHireIds.add(t.Id);
              posIds.add(t.Position_Id__c);
              managerDetails.put(t.Manager_PMF_Key__c,t);
              
           }
        }
        
        
     //---
         /*
          List<user> userList=[select firstname,lastname,AE_SE_PMFKey__c,PMFKey__c from user where PMFKey__c in: pmfkeys];
            for(User eachUser: userList){
                 if(pmfVSName.containsKey(eachUser.PMFKey__c))
                 {  
                       String ename=pmfVSName.get(eachUser.PMFKey__c);
                       String[] names;
                       if(ename<>null)
                         names=ename.split(',');    
                       eachUser.lastname=names[0];
                       eachUser.firstname=names[1];
                 }  
           }  //UPDATING USER OBJECT WITH APPROVED NAMES FROM TAQ ORGANIZATION BASED UPON PMF KEYS.
           Database.update(userList);
         */
           
         //---
           List<TAQ_Organization__c> forCopyOrgRec = new List<TAQ_Organization__c>();
           for(TAQ_Organization__c ta: taL){
                if(ta.Process_Step__c=='New Hire' || ta.Process_Step__c=='Open Headcount' || ta.Process_Step__c=='Term / Transfer'){
                    
                    forCopyOrgRec.add(ta);
                }
           }
          
           if(forCopyOrgRec.size()>0){
       //      copyOrgRecords(forCopyOrgRec);
           }
           
           
           //----
           if(newHireIds.size() > 0)
           {
               
            TAQ_Organization__c[] tOrgL=[select PMFKey__c,Position_Id__c, Employee_Name__c, Manager_PMF_Key__c,Manager_Name__c, /*FY14-TADKR01Manager_Effective_Date__c,*/ Manager_Org__c, Approval_Process_Status__c, Approval_Status__c from TAQ_Organization__c where id NOT IN: newHireIds and  Manager_PMF_Key__c in: posIds ];
             
             for(TAQ_Organization__c t: tOrgL){
                 
                if(managerDetails.containsKey(t.Position_Id__c)){
                    if(managerDetails.get(t.Position_Id__c).Process_Step__c=='New Hire'){
                        if(managerDetails.get(t.Position_Id__c).Id != t.Id   &&    managerDetails.get(t.Position_Id__c).Employee_Name__c != t.Manager_Name__c   &&  /*FY14-TADKR01  managerDetails.get(t.Position_Id__c).Manager_Effective_Date__c != t.Employee_Status_Date__c &&*/    managerDetails.get(t.Position_Id__c).Manager_PMF_Key__c != t.PMFKey__c){
                               t.Manager_PMF_Key__c=managerDetails.get(t.Position_Id__c).PMFKey__c;
                               t.Manager_Name__c=managerDetails.get(t.Position_Id__c).Employee_Name__c;    
                        //FY14-TADKR01       t.Manager_Effective_Date__c=managerDetails.get(t.Position_Id__c).Employee_Status_Date__c;
                        }
                    }       
                }
             }    
             try{  
             //added by Rao to avoid multiple calls toa trigger....CA_TAQ_Org_Approval
             SystemIdUtility.skipTAQTrigger = true;       
                 Database.Update(tOrgL,false);
             }catch(Exception e){
                 System.debug('+++exception+++++'+e);
             }
           } 
             
             //---
             List<TAQ_Organization__c> insertOrgs = new List<TAQ_Organization__c>();
             Map<Id,TAQ_Organization__c> insertMap = new Map<Id,TAQ_Organization__c>();
             for(TAQ_Organization__c ta: taL){
                if((ta.Employee_Status__c=='Transfer-within' || ta.Employee_Status__c=='Transfer-Out' || ta.Employee_Status__c=='Terminated') && ta.Process_Step__c=='Term / Transfer' && ta.Position_ID_Status__c<>'Closed'){
                       ta.Position_ID_Status__c='Open';
                       System.debug('++++++++10 +++++++'+ta.Id);
                       TAQ_Organization__c ta2=ta.clone(false,true);//new TAQ_Organization__c()
                       ta2.Approval_Process_Status__c='Send For Approval';
                       ta2.Process_Step__c = 'Open Headcount';
                       ta2.Employee_Status__c='Open';
                       ta2.Employee_Name__c='Open_' + ta.Position_Id__c;
                       ta2.Position_Id_Status__c='Open';
                       //ta2.PMFKey__c=ta.Position_Id__c;
                       ta2.PMFKey__c='';
                       ta2.Employee_Status__c = '';
                       ta2.Employee_Status_Date__c = null;
                       //CR:189747977 plan type end date should not be null
                      // ta2.Plantype_Delimited_Date__c =null;
                    //   ta2.Standard_Flat_Rate__c = null;
                       ta2.Is_Terminated__c=true;
                       ta2.Plan_Reset__c='No'; // rao 
                       ta2.Record_Sent_To_Approver__c=true;
                       ta2.Plantype_Delimited_Date__c = null;
                         insertOrgs.add(ta2);
                       //To insert TAQ Org Quotas to new Open Head Count TAQ Org.
                         insertMap.put(ta.Id,ta2);
              }
          }
          
          FutureProcessor_TAQ.skiporgtriggers =true;
          try{
              Database.SaveResult[] MySaveResult = Database.insert(insertOrgs,false);
              
            
               /// by Rao System.debug('++++1111+++++'+MySaveResult[0].getErrors());
          }catch(Exception e){
              System.debug('++++exceptionn+++++'+e);
          }
          
          
            
          FutureProcessor_TAQ.skiporgtriggers =false;
       try{   
         //Copy Orq Quotas to cloned Orgs.
         //Added Added Overlay codes - FY15 change 
         //AR 3664 Amasa03
         List<TAQ_Org_Quota__c> quotas = [Select Territory__c, TAQ_Organization__c, Services__c, Services_USD__c,
          Region__c, RecordTypeId, Quota_Type__c, Quota_Total__c, Quota_Total_USD__c, Quota_Holder__c, Quota_Currency__c,
          Prorated_Time__c, Prorated_Services__c, Prorated_Quota_Total__c, Prorated_Product__c, Prorated_Other__c,
            Prorated_Mainframe_Capacity__c, Prorated_Education__c, Product__c, Product_USD__c,Overlay_Code__c, 
            Other__c, Other_USD__c, Merlin_Territory_Country__c,Mainframe_Time__c, Segment__c, Overlay_code_description__c,
             Mainframe_Time_USD__c, Mainframe_Capacity__c, Mainframe_Capacity_USD__c, Id, Flat_Rate__c, 
             Education__c, Education_USD__c,  Country__c, CSU_BU__c, Area__c From TAQ_Org_Quota__c where TAQ_Organization__c in: taL]; 
      
       List<TAQ_Org_Quota__c> newQuotas = new List<TAQ_Org_Quota__c>();
        for(TAQ_Org_Quota__c t: quotas){
             TAQ_Org_Quota__c newQuota = t.clone(false,true);
               if(insertMap.containsKey(t.TAQ_Organization__c)){
                   newQuota.TAQ_Organization__c = insertMap.get(t.TAQ_Organization__c).Id;
                   newQuota.Plan_Type__c = insertMap.get(t.TAQ_Organization__c).plan_Type__c;
                   newQuotas.add(newQuota);
               }
        }
        try{         
             Database.SaveResult[] MySaveResult = database.insert(newQuotas,false);
             
             for(Database.SaveResult sr:MySaveResult){
                if(!sr.isSuccess())
                 System.debug('excecption while inserting taq org quota'+sr.getErrors()[0]);
             }
         }catch(Exception e){
             System.debug('+++exception+++++'+e);
         }
        
       }catch(Exception e){
          System.debug('__Exception while cloning TAQ Org Quotas__'+e.getMessage());
       }
      }
      public void copyOrgRecords(List<TAQ_Organization__c> orgList)
      {
          // AR 3898
          // This Map holds the TAQ Org record Id's and Boolean to check if its TAQ Org Approved records are created within the same transaction or not.
          Map<Id, Boolean> newlyCreatedRecord = new Map<Id,Boolean>();
          System.debug('orgList:'+orgList);
          List<String> names = new List<String>();
          List<Id> orgIds = new List<Id>();
           for(TAQ_Organization__c t: orgList)
           {
             names.add(t.Name);
             orgIds.add(t.Id);            
           }     
         System.debug('orgIds:'+orgIds);
         //if(SystemIdUtility.isFutureUpdate == true){
            String Pmfk;
            String Emps;
            String Posid;
        
           TAQ_Organization_Approved__c[] objarr=[select id,Is_Latest_Record__c,PMFKey__c,Employee_Status__c,Position_Id__c, ownerid, Process_Step__c,CreatedDate, Manager_Name__c, Manager_PMFKey__c, Managers_Position_ID__c,TAQ_Organization__r.Id from TAQ_Organization_Approved__c where name in: names and Is_Latest_Record__c=true];
             if(objarr.size()>0){
                for(Integer i=0;i<objarr.size();i++) {
                    System.debug('+++++16 objarr[i].Id+++++++'+objarr[i].Id);
                    // AR 3898
                    // Check if the TAQ_Org_Approved records is created within 1 minute (within the same transaction)
                    // If yes, Don't create a new TAQ_Org_Approved record, instead Update the latest record available.
                    // If no, Make is_latest__c = false and create a new TAQ_Org_Approved record.
                    System.debug('Time Difference is:'+Integer.valueOf((objarr[i].CreatedDate.getTime() - System.now().getTime())/(1000)));
                    if(Math.abs(Integer.valueOf((System.now().getTime() - objarr[i].CreatedDate.getTime())/1000))< 60){
                        newlyCreatedRecord.put(objarr[i].TAQ_Organization__r.Id,true);
                        if(SystemIdUtility.isFutureUpdate == true){
                            for(TAQ_Organization__c parent:orgList){
                                objarr[i].Manager_Name__c = parent.Manager_Name__c;
                                objarr[i].Manager_PMFKey__c = parent.Manager_PMF_Key__c;
                                //objarr[i].Managers_Position_ID__c = parent.Position_Id__c;
                            }
                            
                        }
                    }
                    else{
                        if(objarr[i].Is_Latest_Record__c==true){  
                            Pmfk=objarr[i].PMFKey__c;
                            Emps=objarr[i].Employee_Status__c;
                            Posid=objarr[i].Position_Id__c;
                        }
                        
                        objarr[i].Is_Latest_Record__c=false;
                        objarr[i].Process_Status__c = '';
                        newlyCreatedRecord.put(objarr[i].TAQ_Organization__r.Id,false);
                    }                    
                }  
                
                try{         
                     Database.Update(objarr,false);
                 }catch(Exception e){
                     System.debug('+++exception+++++'+e);
                 }              
            }
            
          
            List<TAQ_Organization_Approved__c> newOrgList = new List<TAQ_Organization_Approved__c>();
            
            for(TAQ_Organization__c ta: orgList){
                System.debug('Map Value is:'+newlyCreatedRecord.get(ta.Id));
                // AR 3898
                if(newlyCreatedRecord.get(ta.Id) == null || newlyCreatedRecord.get(ta.Id) == false){
                    TAQ_Organization_Approved__c neworg=new TAQ_Organization_Approved__c();
                        neworg.EMEA_HQ__c = ta.EMEA_HQ__c;
                        neworg.name=ta.name;
                        neworg.Approved_Date_Time__c=system.now();
                        neworg.Approved_By__c=userinfo.getuserid();
                        neworg.TAQ_Organization__c=ta.id;
                        neworg.Position_Id__c = ta.Position_Id__c;
                        neworg.Position_ID_Status__c= ta.Position_ID_Status__c;
                        neworg.PMFKey__c= ta.PMFKey__c;
                        neworg.Employee_Name__c= ta.Employee_Name__c;
                        neworg.Employee_Status__c= ta.Employee_Status__c;
                        neworg.Open_Priority__c= ta.Open_Priority__c;
                        neworg.Employee_Status_Date__c= ta.Employee_Status_Date__c;
                        neworg.Organization__c= ta.Organization__c;
                        neworg.Region__c= ta.Region__c;
                        neworg.Area__c= ta.Area__c;
                        neworg.Territory__c= ta.Territory__c;
                        neworg.Country__c= ta.Country__c;
                        neworg.Job_Title__c= ta.JobTitle__c;
                        neworg.Job_Code__c= ta.JobCode__c;
                        neworg.Role__c= ta.Role__c;
                  //      neworg.Role_Effective_Date__c= ta.Role_Effective_Date__c;
                        neworg.Cost_Center_Number__c= ta.Cost_Center_Number__c;
                        neworg.Cost_Center_Desc__c= ta.Cost_Center_Desc__c;
                        neworg.Approval_Process_Status__c=ta.Approval_Process_Status__c;
                        neworg.Record_Status__c=ta.Approval_Status__c;
                        neworg.Record_Status__c=ta.Approval_Status__c;
                        neworg.Decision_Reason__c=ta.Reason_for_Rejection__c;
                        neworg.Process_Step__c=ta.Process_Step__c;
                        neworg.Manager_PMFKey__c= ta.Manager_PMF_Key__c;
                        neworg.Manager_Name__c= ta.Manager_Name__c;
                    //FY14-TADKR01    neworg.Manager_Effective_Date__c = ta.Manager_Effective_Date__c;
                        neworg.Manager_Org__c= ta.Manager_Org__c;
                        neworg.Distribute_Plan__c= ta.Distribute_Plan__c;
                        neworg.Comments__c= ta.Comments__c;
                        neworg.Business_Unit__c= ta.Business_Unit__c;
                        neworg.Plan_Type__c= ta.Plan_Type__c;
                        neworg.PlanType_Effective_Date__c= ta.PlanType_Effective_Date__c;
                        neworg.Plantype_Delimited_Date__c= ta.Plantype_Delimited_Date__c;
                        neworg.Plan_Reset__c= ta.Plan_Reset__c;
                        neworg.IC_Currency__c=ta.IC_Currency__c;
                        neworg.IC_Amount__c= ta.IC_Amount__c;
                        neworg.Is_Latest_Record__c=true;
                        neworg.Process_Status__c = 'New';
                        // Assigned the requestor queue to be the owner of the apporved record
                          neworg.ownerid = ta.ownerid;
                          //CRM Sprint 4 - Start 2
                        neworg.TAQ_Plan_ID__c=ta.TAQ_Plan_ID__c; //New field added in TAQ Organization Approved
                        neworg.Vurv_Req_ID__c=ta.Vurv_Req_ID__c;
                        
                        //FY13 - TADKR01
                          neworg.Account_Segment__c=ta.Account_Segment__c;
                          neworg.Account_Territory_Coverage__c=ta.Account_Territory_Coverage__c;
                         //FY14-Deleting field. neworg.Beachhead__c=ta.Beachhead__c;
                          neworg.Jobs_Info_Band__c=ta.Jobs_Info_Band__c;
                          neworg.Jobs_Info_Role__c=ta.Jobs_Info_Role__c;
                          neworg.Prorated_IC__c=ta.Prorated_IC__c;
                          neworg.Proration__c=ta.Proration__c;
                          neworg.Secondary_CSU_BU__c=ta.Secondary_CSU_BU__c;
                          //FY14
                          neworg.Country_Picklist__c = ta.Country_Picklist__c;
                        // CR:192993574
                          neworg.Coverage_Model__c = ta.Coverage_Model__c;
                         //Fy15 changes
                          neworg.Terr_Covg_GEO__c =ta.Terr_Covg_GEO__c;
                          neworg.Terr_Covg_Operating_Area__c  = ta.Terr_Covg_Operating_Area__c;
                          neworg.Terr_Covg_Sales_Region__c =ta.Terr_Covg_Sales_Region__c;
                          neworg.Terr_Covg_Territory__c  =ta.Terr_Covg_Territory__c;
                          neworg.Terr_Covg_NMD__c  = ta.Terr_Covg_NMD__c;
                          if(ta.Practice__c!=null)
                          newOrg.Practice__c = ta.Practice__c;
                          if(ta.Criteria__c!=null)
                          newOrg.Criteria__c = ta.Criteria__c;
                          if(ta.Criteria_1__c!=null)
                          newOrg.Criteria_1__c = ta.Criteria_1__c;
                          if(ta.Criteria_2__c!=null)
                          newOrg.Criteria_2__c = ta.Criteria_2__c;
                          if(ta.Criteria_3__c!=null)
                          newOrg.Criteria_3__c = ta.Criteria_3__c;
                          if(ta.Criteria_4__c!=null)
                          newOrg.Criteria_4__c = ta.Criteria_4__c;
                          newOrg.CBU__c = ta.CBU__c;
               newOrgList.add(newOrg);
                }
            }            
            try{         
                Database.insert(newOrgList,false);
             }catch(Exception e){
                 System.debug('+++exception+++++'+e);
             } 
            
            
           
           //Added Overlay codes - FY15 change 
           List<TAQ_Org_Quota__c> quotaList = [Select Overlay_Code_Description__c, Country_picklist__c,Id,Name,Area__c,Country__c,Merlin_Territory_Country__c,CSU_BU__c,Education__c,Education_USD__c,Flat_Rate__c,Mainframe_Capacity__c,Mainframe_Capacity_USD__c,Other__c,Other_USD__c,Overlay_Code__c,  
           Product__c,Product_USD__c,Prorated_Education__c,Prorated_Mainframe_Capacity__c,Prorated_Other__c,Prorated_Product__c,Prorated_Quota_Total__c,Prorated_Services__c,Prorated_Time__c,Quota_Currency__c,Quota_Holder__c,Quota_Total__c,Quota_Total_USD__c,Quota_Type__c,Region__c,Services__c,Services_USD__c,
                            TAQ_Organization__c,Territory__c,Mainframe_Time__c,Mainframe_Time_USD__c,Weighting__c,Segment__c, CM1__C, CM2__C, CM3__c, CM4__C, CBU__c from TAQ_Org_Quota__c 
                                WHERE TAQ_Organization__c in: orgIds];
         
            Map<Id,List<TAQ_Org_Quota__c>> orgVsorgQuota = new Map<Id,List<TAQ_Org_Quota__c>>();
           
           // Mapping TAQ Org records with corresponding list of TAQ Org Quota recs.
            for(TAQ_Org_Quota__c t: quotaList){
                if(orgVSorgQuota.containsKey(t.TAQ_Organization__c)){
                    orgVSorgQuota.get(t.TAQ_Organization__c).add(t);
                }
                else{
                    orgVSorgQuota.put(t.TAQ_Organization__c,new List<TAQ_Org_Quota__c>());
                    orgVSorgQuota.get(t.TAQ_Organization__c).add(t);
                }
            }
        //CREATING AND ATTACHING LATEST SET OF TAQ ORG QUOTA APPROVED RECORDS WITH TAQ ORG APPROVED.   
           List<TAQ_Org_Quota_Approved__c> orgQuotaApprovedRecs = new List<TAQ_Org_Quota_Approved__c>();
           for(TAQ_Organization_Approved__c newOrgAppr: newOrgList){
              if(orgVSorgQuota.containsKey(newOrgAppr.TAQ_Organization__c)){
                 for(TAQ_Org_Quota__c toq: orgVSorgQuota.get(newOrgAppr.TAQ_Organization__c)){
                    TAQ_Org_Quota_Approved__c newOrgApprRec = new TAQ_Org_Quota_Approved__c();
                            newOrgApprRec.Name = toq.Name;
                             newOrgApprRec.TAQ_Organization_Approved__c = newOrgAppr.Id;
                          newOrgApprRec.Area__c = toq.Area__c;
                          newOrgApprRec.Country__c = toq.Country__c;
                          newOrgApprRec.Merlin_Territory_Country__c = toq.Merlin_Territory_Country__c;
                            newOrgApprRec.CSU_BU__c = toq.CSU_BU__c;
                            newOrgApprRec.Education__c = toq.Education__c;
                            newOrgApprRec.Education_USD__c = toq.Education_USD__c;
                            newOrgApprRec.Flat_Rate__c = toq.Flat_Rate__c;
                            newOrgApprRec.Mainframe_Capacity__c = toq.Mainframe_Capacity__c;
                            newOrgApprRec.Mainframe_Capacity_USD__c = toq.Mainframe_Capacity_USD__c;
                            newOrgApprRec.Other__c = toq.Other__c;
                            newOrgApprRec.Other_USD__c = toq.Other_USD__c;
                            if(toq.Overlay_Code__c!= null){
                            newOrgApprRec.Overlay_Code__c = toq.Overlay_Code__c;
                            }                            
                            if(toq.Overlay_Code_Description__c!=null)
                            newOrgApprRec.Overlay_Code_Description__c = toq.Overlay_Code_Description__c;
                            newOrgApprRec.Product__c = toq.Product__c;
                            newOrgApprRec.Product_USD__c = toq.Product_USD__c;
                            newOrgApprRec.Prorated_Education__c = toq.Prorated_Education__c;
                            newOrgApprRec.Prorated_Mainframe_Capacity__c = toq.Prorated_Mainframe_Capacity__c;
                            newOrgApprRec.Prorated_Other__c = toq.Prorated_Other__c;
                            newOrgApprRec.Prorated_Product__c = toq.Prorated_Product__c;
                            newOrgApprRec.Prorated_Quota_Total__c = toq.Prorated_Quota_Total__c;
                            newOrgApprRec.Prorated_Services__c = toq.Prorated_Services__c;
                     //DESTINATION FIELD DATA TYPE MODIFIED - TADKR01      newOrgApprRec.Prorated_Time__c = toq.Prorated_Time__c;
                            newOrgApprRec.Quota_Currency__c = toq.Quota_Currency__c; 
                            newOrgApprRec.Quota_Holder__c = toq.Quota_Holder__c;                            
                            newOrgApprRec.Quota_Total__c = toq.Quota_Total__c;
                            newOrgApprRec.Quota_Total_USD__c = toq.Quota_Total_USD__c; 
                            newOrgApprRec.Quota_Type__c = toq.Quota_Type__c;
                            newOrgApprRec.Region__c = toq.Region__c;
                            newOrgApprRec.Services__c = toq.Services__c;
                            newOrgApprRec.Services_USD__c = toq.Services_USD__c;
                            newOrgApprRec.Territory_Country__c = toq.Territory__c;
                            //FY14
                            newOrgApprRec.Country_Picklist__c = toq.Country_Picklist__c; 
                            newOrgApprRec.Mainframe_Time__c = toq.Mainframe_Time__c;  
                        //RE-MATCHED WITH NEW FIELD IN DESTINATION OBJECT(MAINFRAME_TIME_USD__C):TADKR01    newOrgApprRec.T__c = toq.Mainframe_Time_USD__c;
                            
                            newOrgApprRec.Weighting__c = toq.Weighting__c;
                             newOrgApprRec.Segment__c= toq.Segment__c;// added new value segment__c as part of fy15
                          //ADD contribution margins as part of fy18
                          newOrgApprRec.CM1__c = toq.CM1__c;
                          newOrgApprRec.CM2__c = toq.CM2__c;
                          newOrgApprRec.CM3__c = toq.CM3__c;
                          newOrgApprRec.CM4__c = toq.CM4__c;
                          if(toq.CBU__C != null){
                            newOrgApprRec.CBU__c = convertString(toq.CBU__c);
                          }
                        orgQuotaApprovedRecs.add(newOrgApprRec);    
                }
              }
           }  
           try{         
               Database.insert(orgQuotaApprovedRecs,false);
             }catch(Exception e){
                 System.debug('+++exception+++++'+e);
             }
           //}
      }

      public string convertString(String value){
          String[] values = value.split(';');
          String singleString = String.join(values, ', ');
          return singleString;
      }

      public static testMethod void convertStringTest(){
        TAQ_OrgActions  Obj = new TAQ_OrgActions();
        String input = 'ABC;ZTX;PNT';
        String output = Obj.convertString(input);
        String expected = 'ABC, ZTX, PNT';
        System.assertEquals(expected, output);
      }
      
      public static testMethod void commitActionsTest()
      {
            TAQ_OrgActions  Obj = new TAQ_OrgActions();
            List<TAQ_Organization__c>  OrgLst = [Select Practice__c,criteria__c,criteria_1__c,criteria_2__c,criteria_3__c,criteria_4__c,Country_Picklist__c,id,Name,Open_Priority__c,Employee_Status_Date__c,Country__c,JobCode__c, 
                    Role__c,Cost_Center_Number__c, Approval_Process_Status__c, Approval_Status__c ,
                    Reason_for_Rejection__c , Manager_Name__c ,/*FY14-TADKR01 Manager_Effective_Date__c  ,*/ Manager_Org__c, Comments__c , Business_Unit__c, 
                    PlanType_Effective_Date__c ,  Plantype_Delimited_Date__c , Plan_Reset__c , IC_Amount__c ,
                    TAQ_Plan_ID__c, Vurv_Req_ID__c ,  Account_Segment__c ,Cost_Center_Desc__c,Distribute_Plan__c,Plan_Type__c,
                     ownerid, IC_Currency__c, Account_Territory_Coverage__c , Jobs_Info_Role__c, Secondary_CSU_BU__c,CBU__c,
                   /*FY14-Deleting field. Beachhead__c ,*/ Jobs_Info_Band__c , Prorated_IC__c , Proration__c ,  Position_ID_Status__c, Employee_Name__c , Employee_Status__c  , Position_Id__c , organization__c, process_step__c ,
                    Region__c,Territory__c,Area__c , JobTitle__c , EMEA_HQ__c,Manager_PMF_Key__c , PMFkey__c , Coverage_Model__c,Terr_Covg_GEO__c,Terr_Covg_Operating_Area__c,Terr_Covg_Sales_Region__c, Terr_Covg_NMD__c, Terr_Covg_Territory__c From TAQ_Organization__c where 
                    
                    Region__c != Null And Territory__c != null And Area__c != null And JobTitle__c != null And Manager_PMF_Key__c != null And PMFkey__c != null And Plan_Type__c != 'None' and Distribute_Plan__c != 'No' And ( process_step__c = 'Open HeadCount' Or process_step__c = 'New Hire' Or process_step__c = 'Employee Change' OR Process_Step__c = 'Term / Transfer')  limit 50 ]; 
            Test.startTest();
          
            Obj.commitActions(OrgLst);
            Obj.copyOrgRecords(OrgLst);
             List<TAQ_Organization__c>  OrgLst1 = [Select id,Practice__c,criteria__c,criteria_1__c,criteria_2__c,criteria_3__c,criteria_4__c,Country_Picklist__c,Name,Open_Priority__c,Employee_Status_Date__c,Country__c,JobCode__c, 
                    Role__c,Cost_Center_Number__c, Approval_Process_Status__c, Approval_Status__c ,
                    Reason_for_Rejection__c , Manager_Name__c ,CBU__c, /*FY14-TADKR01Manager_Effective_Date__c  ,*/ manager_Org__c, Comments__c , Business_Unit__c, 
                    PlanType_Effective_Date__c ,  Plantype_Delimited_Date__c , Plan_Reset__c , IC_Amount__c ,
                    TAQ_Plan_ID__c, Vurv_Req_ID__c ,  Account_Segment__c ,Cost_Center_Desc__c,Distribute_Plan__c,Plan_Type__c,
                     ownerid, IC_Currency__c, Account_Territory_Coverage__c , Jobs_Info_Role__c, Secondary_CSU_BU__c,
                    /* Beachhead__c ,*/ Jobs_Info_Band__c , Prorated_IC__c , Proration__c ,  Position_ID_Status__c, Employee_Name__c , Employee_Status__c  , Position_Id__c , organization__c, process_step__c ,
                    Region__c,Territory__c,Area__c , JobTitle__c , Manager_PMF_Key__c , PMFkey__c , EMEA_HQ__c,Coverage_Model__c,Terr_Covg_GEO__c,Terr_Covg_Operating_Area__c,Terr_Covg_Sales_Region__c, Terr_Covg_NMD__c , Terr_Covg_Territory__c From TAQ_Organization__c where plan_type__c ='None' and  Employee_Status__c='Transfer-within' and Process_Step__c='Term / Transfer' and Position_ID_Status__c<>'Closed' limit 50 ]; 
           TAQ_OrgActions  Obj1 = new TAQ_OrgActions();
           Obj1.commitActions(OrgLst1);
            Test.stopTest();
      }   
}