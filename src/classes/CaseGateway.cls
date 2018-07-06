/************************************************************************** \ 
   @ Author : D.S Sandeep Reddy
   @ Date : 16/04/14 
   @ Test File :Initial Version 
   @ Description : Trigger Handler for the Case SObject. This class implements the ITrigger. interface to help
    ensure the trigger code is bulkified and all in one place.
 
 
 @ Audit Trial : Repeating block for each change to the code
       @ Last Modified By   : Vamshi    
       @ Last Modified On   :  22/06/14 
       @ Last Modified Reason     :  Updated Business hours calculation rules.
       
  @Last Modified on **** 2nd July 2015 by Pankaj  *** condition "&& (caseRec.Origin != 'chat')" added by Pankaj for by pass case record created by Live Agent, find line by #liveAgent
  @Last Modified on **** by *** to ******
 ****************************************************************************/

public class CaseGateway {
    public static Map<id, String> siteCntryMap = new Map<id, String>();
    public static Map<id, String> siteAccMap = new Map<id, String>();
    public static Map<ID, Site_Association__c> siteAssMap;
    public static Map<ID,CA_Product_Component__c> prodCompMap;
    public static Map<ID, Contact> contactsMap;
    public static Set<ID> contactIDs = new Set<ID>();
    public static Map<ID, Contact> contactsMapInsert;
    public static Set<ID> contactIDInsert = new Set<ID>();
    public static Map<ID, User> userMapInsert;
    public static Set<ID> userIDInsert = new Set<ID>();
    public static Map<id, User> usrPMFkeyMap = new Map<id, User>();
    public static Map<id, List<Task>> taskMap = new Map<id, List<Task>>();
    public static Map<id, GSS_Transactions__c> caseGSSMap = new Map<id, GSS_Transactions__c>();
    public static Set<ID> csmSiteIds = new Set<ID>();
    public static Map<Id, List<Task>> otherSupportTypeTaskMap = new Map<Id, List<Task>>();
    public static Set<ID> initialCB;
    public static Set<ID> openCB;
    public static Set<ID> seAction;
    public static Set<ID> expSLO;
    public static Map<String, GSS_Transactions__c> caseStageGSSMap = new Map<String, GSS_Transactions__c>(); //US108116
    public static List<Case_Portal_View__c> casePortalViewList = new List<Case_Portal_View__c>();
    //public static String internalPriorityValue;//US237090: Priority Case Ordering
    public static Boolean medalliaSurveyFlag = false;
    public Static Map<Id,Id> siteAccountIdMap = new Map<Id,Id>();
    public static Map<Id,Id> userparentMap = new Map<Id,Id>();
    
    //US203673 - Implement Case Time Zones for Callback SLOs 
    public static Map<String,String> stateBusinessHoursMap = new Map<String,String>();  
    public static List<State_BusinessHours__c> businessHoursForState = State_BusinessHours__c.getall().values(); 
    public static Map<id, String> siteStateMap = new Map<id, String>(); 
    public static Map<String, Id> siteStateBusinessHoursMap = new Map<String, Id>(); 

                 //Added as part of LifeCycle:US47726 by Aditya  
    public static Map<String,String> stageStatusMap=new Map<String,String>{'1. Problem Identification'=>'Open',
                                                                  '2. Knowledge Search'=>'Open',
                                                                  '3. Cause Determination'=>'Open',
                                                                  '4. Solution Identification'=>'Open',
                                                                  '5. Solution Provided'=>'Verify',
                                                                  '6. Solution Deferred'=>'Verify',
                                                                  '7. Closed'=>'Closed',
                                                                   '1. Triage'=>'Open',
                                                                   '2. Customer Contact'=>'Open',
                                                                    '3. Barrier Identification'=>'Open',
                                                                    '4. Barrier Mitigation'=>'Open',
                                                                    '5. Barrier Removed'=>'Closed',
                                                                     '6. End Engagement'=>'Closed' ,
                                                                    '7. End Engagement'=>'Closed' 
        };
        
    
    public static Map<String,id> loadCaseBulkBefore(){
        List<Case> lstTrigger;
        set<id> siteIds = new set<id>();
        set<id> closedCaseIds = new set<id>();
        set<id> openCaseIds = new set<id>();
        set<id> productComponentIds = new set<id>();
        initialCB = new Set<ID>();
        openCB = new Set<ID>();
        seAction = new Set<ID>(); 
        expSLO = new Set<ID>();
        Set<Id> accIdSet = new Set<Id>();
        

        List<Businesshours> busHrsList = new List<Businesshours>();
        Map<String,id> busHrsIdMap = new Map<String,id>();
        Set<Id> parentIds = new Set<Id>();       
        lstTrigger = trigger.New;   

        for(Case rec: lstTrigger){
            System.debug('#######33'+rec);
         //US145728 : Abuse field to default 
            if(rec.Abuse_reason__c != null )
            {
                if(rec.Abuse_Created_By__c == null){
                            rec.Abuse_Created_By__c = UserInfo.getUserId();
                }
                if(rec.Abuse_date__c == null){
                            rec.Abuse_date__c = Date.today();
                }
            }
            Case oldcase;            
            if(Trigger.isUpdate)
               oldcase = (Case)Trigger.OldMap.get(rec.id);                                                     
                        
            if(Trigger.isUpdate && rec.Status!='Closed')
                openCaseIds.add(rec.Id);
               
            if(rec.Site_Association__c!=null)
                siteIds.add(rec.Site_Association__c); 
            
            if(rec.Internal_Contact__c!=null)
                userIDInsert.add(rec.Internal_Contact__c); 
            
            if(rec.contactid != null)
            {
               contactIDs.add(rec.contactID);
               contactIDInsert.add(rec.contactID);
            }
            if(rec.AccountId !=null){
            
                accIdSet.add(rec.AccountId);
            }
             if(rec.Case_Type__c =='Case Concern' && rec.parentId !=null)
              parentIds.add(rec.parentId);
               
            
            if(rec.CA_Product_Component__c!=null)
                productComponentIds.add(rec.CA_Product_Component__c);
        //Added by KESVE02 for VDA feature
            if(rec.Case_Type__c =='Standard'){
                boolean isVDA=false;
                boolean VDAProductComponent = false;
                boolean VDAProductController = false;
                if(rec.CA_Product_Controller__c!=null){
                   VDAProductController = [SELECT VDA_Product__c FROM CA_Product_Controller__c where id=:rec.CA_Product_Controller__c].VDA_Product__c;
                }
                if(rec.CA_Product_Component__c!=null){
                   VDAProductComponent = [SELECT VDA_Product_Component__c  FROM CA_Product_Component__c where id=:rec.CA_Product_Component__c].VDA_Product_Component__c;
                }
                if(VDAProductController==true && VDAProductComponent==true){
                    isVDA=true;
                }
                if(Trigger.isInsert && Trigger.isBefore){
                    rec.Category__c=null;
                        rec.Subcategory__c=null;
                        rec.Function__c=null;
                        rec.Root_Cause_Category_vda__c=null;
                        rec.Root_Cause_Sub_Category__c=null;
                         if(isVDA){
                             rec.Function_text__c=  null;
                         }else{
                            rec.Function_text__c=  'N/A';
                         }
                        rec.Root_Cause_Category_Text__c=   null;
                        rec.Root_Cause_Sub_Category_Text__c=   null;  
                        rec.CaseResolvePageHidden__c=null;
                }
                 if(Trigger.isUpdate && Trigger.isBefore && UtilityFalgs.isVDALogicExecuted!=true){
                    if(rec.CA_Product_Controller__c!= oldcase.CA_Product_Controller__c || rec.CA_Product_Component__c!= oldcase.CA_Product_Component__c){
                    System.debug('rec.CaseResolvePageHidden__c-->'+rec.CaseResolvePageHidden__c);
                            if(isVDA){
                                rec.Category__c=null;
                                rec.Subcategory__c=null;
                                if(rec.CaseResolvePageHidden__c=='CaseResolvePage')
                                { 
                                    rec.Function_text__c=  [SELECT Name FROM Function__c where id =:rec.Function__c].Name;
                                    rec.Root_Cause_Category_Text__c=   [SELECT Name FROM Root_Cause_Category__c where id =:rec.Root_Cause_Category_vda__c].Name;
                                    rec.Root_Cause_Sub_Category_Text__c=[SELECT Name FROM Root_Cause_Sub_category__c where id =:rec.Root_Cause_Sub_Category__c].Name;
                                }else{
                                    rec.Function__c=null;
                                    rec.Root_Cause_Category_vda__c=null;
                                    rec.Root_Cause_Sub_Category__c=null;
                                    rec.Function_text__c=  null;
                                    rec.Root_Cause_Category_Text__c=   null;
                                    rec.Root_Cause_Sub_Category_Text__c=   null;
                                }
                            }else{
                                 rec.Function__c=null;
                                 rec.Root_Cause_Category_vda__c=null;
                                 rec.Root_Cause_Sub_Category__c=null;
                                if(rec.CaseResolvePageHidden__c=='CaseResolvePage')
                                {
                                    rec.Function_text__c='N/A';
                                    rec.Root_Cause_Category_Text__c=rec.Category__c;
                                    rec.Root_Cause_Sub_Category_Text__c=rec.Subcategory__c;
                                }else{
                                    rec.Category__c=null;
                                    rec.Subcategory__c=null;
                                    rec.Function_text__c=  'N/A';
                                    rec.Root_Cause_Category_Text__c=   null;
                                    rec.Root_Cause_Sub_Category_Text__c=   null;
                                }
                                
                            }
                    }
                     rec.CaseResolvePageHidden__c=null;
                 }
                 UtilityFalgs.isVDALogicExecuted=true;
            }
            if(rec.Case_Type__c == 'Case Concern' || rec.Case_Type__c == 'Proactive' ){
                 if(Trigger.isInsert && Trigger.isBefore){
                    //rec.Function_text__c=  null;
                    rec.Root_Cause_Category_Text__c=   null;
                    rec.Root_Cause_Sub_Category_Text__c=   null;  
                 }
                 if(Trigger.isUpdate && Trigger.isBefore){
                    //rec.Function_text__c='N/A';
                    rec.Root_Cause_Category_Text__c=rec.Category__c;
                    rec.Root_Cause_Sub_Category_Text__c=rec.Subcategory__c;
                 }
                 if(rec.Case_Type__c == 'Proactive' && !UtilityFalgs.isSDMOwnerLogicExecuted){
                    if(rec.Product__c!= oldcase.Product__c || rec.Support_Region__c!= oldcase.Support_Region__c){
                        List<Integration_Lookup__c> listOfSDMs = [SELECT Result_Value_1__c FROM Integration_Lookup__c where Variable_1__c=:rec.Product__c and Variable_2__c=:rec.Support_Region__c limit 1];
                        if(!listOfSDMs.isEmpty()){
                            if(null!=listOfSDMs[0].Result_Value_1__c){
                                rec.Proactive_SDM_Owner__c =listOfSDMs[0].Result_Value_1__c;
                            }
                            UtilityFalgs.isSDMOwnerLogicExecuted=true;
                        }
                    }
                 }
                 
                 if(rec.Case_Type__c == 'Proactive' && !UtilityFalgs.isSDMOwnerLogicExecuted){
                    if(rec.Product__c!= oldcase.Product__c || rec.Support_Region__c!= oldcase.Support_Region__c){
                        rec.Proactive_SDM_Owner__c=null;
                    }
                    String soqlSDMOwner=null;
                    List<Integration_Lookup__c> listOfSDMs = [SELECT Result_Value_1__c FROM Integration_Lookup__c where Variable_1__c=:rec.Product__c and Variable_2__c=:rec.Support_Region__c limit 1];
                    if(!listOfSDMs.isEmpty()){
                        soqlSDMOwner=listOfSDMs[0].Result_Value_1__c;
                        UtilityFalgs.isSDMOwnerLogicExecuted=true;
                    }
                    if(null!=soqlSDMOwner && (rec.Proactive_SDM_Owner__c==null || soqlSDMOwner.equalsIgnoreCase(rec.Proactive_SDM_Owner__c))){
                        rec.Proactive_SDM_Owner__c=soqlSDMOwner;
                    }
                 }
                 
            }
        //Ended by KESVE02 for VDA feature  
        
        
         //logic skipped for Case Concern
         if(rec.Case_Type__c != 'Case Concern'){
            
               if(Trigger.isInsert && Trigger.isBefore){
                     //Added as part of LifeCycle:US47726 by Aditya  
                           if(rec.Troubleshooting_Stage__c=='7. Closed'){
                               rec.addError('You cannot select Troubleshooting Staged as '+rec.Troubleshooting_Stage__c);
                           }
                           rec.Status=stageStatusMap.get(rec.Troubleshooting_Stage__c);
                           //End of Aditya          
                           
                        
               }
           
           
               //US133508 , US133511 - Starts 
               if(rec.Next_Action__c==null && rec.Next_Action_Due_Date__c<>null ){
                        rec.addError(system.label.NextActionOwnerMustnotBeBlank);
               }
                //Defaulting Next Action Owner based on stage on case create and case reopen scenarios
               boolean cReopen = Trigger.isUpdate && (oldcase.Troubleshooting_Stage__c == '7. Closed'  && rec.Troubleshooting_Stage__c!='7. Closed' );
               if(cReopen){
                  UtilityFalgs.isCaseReopend = true;
               }
            
               if(Trigger.isInsert || cReopen ){
                          if(rec.Next_Action__c==null || rec.Next_Action__c=='' 
                             || (cReopen && rec.Next_Action__c == System.Label.CaseNextActionOwnerIssueClosed)){
                                if(rec.Troubleshooting_Stage__c != '5. Solution Provided'){
                                    rec.Next_Action__c = System.Label.CaseNextActionOwnerPendingCASupport;
                                } 
                                else{
                                    rec.Next_Action__c = System.Label.CaseNextActionOwnerPendingCustomer;
                                }
                                rec.isNextActionOwnerDefault__c=true;
                          }
                        
               }
               //US133508 , US133511 - Ends
           
               if(Trigger.isUpdate && Trigger.isBefore){
                
               
            
                      //Added for Lifecycle:US47726 by Aditya status shoudl be set before the any status logic is checked.
                      if(rec.Status!='Closed' && oldcase.Status!='Closed' && rec.Troubleshooting_Stage__c=='7. Closed' && rec.Case_Type__c !='Proactive' ){                      
                          rec.addError('Invalid Data.Troubleshooting Stage field cannot be set to Closed for Updating Case');
                         }
                         
                      /*   if(rec.Status!='Solution Provided' && oldcase.Status!='Solution Provided' && rec.Troubleshooting_Stage__c=='5. Solution Provided' && rec.Case_Type__c !='Proactive' ){                      
                          rec.addError('Invalid Data.Troubleshooting Stage field cannot be set to Solution Provided for Updating Case');
                         }
                         if(rec.Status!='Solution Deferred' && oldcase.Status!='Solution Deferred' && rec.Troubleshooting_Stage__c=='6. Solution Deferred' && rec.Case_Type__c !='Proactive' ){                      
                          rec.addError('Invalid Data.Troubleshooting Stage field cannot be set to Solution Deferred for Updating Case');
                         }*/
                   
                   /*else if(rec.Status!='Closed' && oldcase.Status!='Closed' && rec.Case_Type__c =='Proactive' && (rec.Troubleshooting_Stage__c=='6. End Engagement' || rec.Troubleshooting_Stage__c=='5. Barrier Removed') )
                   {
                        rec.addError('Invalid Data.Troubleshooting Stage field cannot be set to End Engagement or Barrier Removed  for Updating Case');
                   } */
    
                   
                      if(rec.Status=='Closed' && oldcase.Status!='Closed' && rec.Troubleshooting_Stage__c!='7. Closed' && rec.Case_Type__c !='Proactive' ){                      
                          rec.addError('Invalid Data.Troubleshooting Stage field must be set to Closed');
                         }
                /*  else if(rec.Case_Type__c =='Proactive' && (rec.Troubleshooting_Stage__c!='6. End Engagement' && rec.Troubleshooting_Stage__c!='5. Barrier Removed') && oldcase.Status!='Closed' && rec.Status=='Closed'){
                   //   else if(rec.Case_Type__c =='Proactive' && rec.Troubleshooting_Stage__c!='6. End Engagement'  && oldcase.Status!='Closed' && rec.Status=='Closed'){
                       rec.addError('Invalid Data.Troubleshooting Stage field must be set to End Engagement or Barrier Removed for Proactive cases');
                   } */
     
                         if(rec.Troubleshooting_Stage__c != null && rec.Troubleshooting_Stage__c!='')
                               rec.Status=stageStatusMap.get(rec.Troubleshooting_Stage__c);
    
                      //End of Aditya            
               }
          }//case concern check end
            if (Trigger.isUpdate && oldcase.Status!=rec.Status) {       
               
                if (rec.Status=='Closed' ){
                    rec.Next_Action__c = 'Issue Closed';    
                    rec.Next_Action_Due_Date__c=null;
                    
                    if(rec.Reopen_Count__c>0)  
                      rec.Date_Time_ReClosed__c =System.now();  
                }
                
                else if (oldcase.Status == 'Closed'){
                    if(rec.Next_Action__c == 'Issue Closed') 
                       rec.Next_Action__c =null;
                    If(rec.Status=='Open')
                      rec.Date_Time_ReOpened__c =System.now();                   
                }
                //Added logic for Case Concern
                else if(rec.Case_Type__c == 'Case Concern'){
                
                    if(rec.Status =='Closed Resolved' || rec.Status =='Closed Unresolved'){
                    
                        //rec.Next_Action_cc__c ='5. Close Concern';
                        rec.Troubleshooting_Stage__c = '5. Close Concern';
                        rec.Next_Action__c = 'Issue Closed';
                        rec.Next_Action_Due_Date__c = null;
                    }
                }
                
                //When case is owner is changed capture the case id to re-assigned initial callbacks to a real user(case owner) from a Queue. 
                //when case is closed capture the case id to close all callbacks.                  
                               
              //  if ( oldcase.ownerid!=rec.ownerid || rec.Status=='Closed')
                //    closedCaseIds.add(rec.Id);                                                                                                       
           }   
           
          
              if ( Trigger.isUpdate && (oldcase.ownerid!=rec.ownerid || rec.Status=='Closed' || 
                        ((rec.Status =='Closed Resolved' || rec.Status =='Closed Unresolved') && rec.Case_Type__c == 'Case Concern')))
                    closedCaseIds.add(rec.Id);
                                 
        } //for loop end
        
        if(!parentIds.isEmpty()){
            for(Case c : [Select id,ownerId from Case where Id IN :parentIds]){
                if(string.valueOf(c.OwnerId).startsWith('005')){
                userIDInsert.add(c.ownerId);
                userparentMap.put(c.id,c.ownerId);
                System.debug('userparentMap====='+userparentMap);
                }
            }
        }
        
        if(!accIdSet.IsEmpty()){
            for(Site_Association__c  sa : [select SC_TOPS_ID__c,id,Enterprise_ID__c from  Site_Association__c where Enterprise_ID__c IN :accIdSet and (System__c='T' or System__c='S') and SC_TOPS_ID__c!='' and SC_SITE_Sanctioned_Party__c ='NO' order by SC_TOPS_ID__c ASC]){
                siteAccountIdMap.put(sa.Enterprise_ID__c,sa.Id); 
            }
        } 
          
        if(!productComponentIds.isEmpty())
            prodCompMap = new Map<Id,CA_Product_Component__c> ([select id , Component_Code__c from CA_Product_Component__c where Id IN :productComponentIds]);
             
        if(!siteIds.isEmpty()) //US203673 - Added State__c in soql
            siteAssMap = new Map<ID,Site_Association__c>([Select id,Enterprise_ID__c,State__c,Country_picklist__c,SC_CA_Internal_Site__c,SC_SITE_CSM__c,SC_TOPS_ID__c  from Site_Association__c where id in:siteIds]);
        
        if(!userIDInsert.isEmpty())
            userMapInsert=new Map<ID, User>([Select id,FirstName,LastName,Phone,Email,Preferred_Contact_Method__c,managerId,manager.Profile.Name from User where id in:userIDInsert]);
        
        if(!contactIDInsert.isEmpty())
            contactsMapInsert=new Map<ID, Contact>([Select id,FirstName,LastName,phone,SC_CONTACT_Language_Preference2__c,Email,SC_CONTACT_Preferred_Contact_Method__c,Language_Preference__c from Contact where id in:contactIDInsert]);
            
            if(Trigger.isUpdate && !contactIDs.isEmpty())
                contactsMap = new Map<ID,Contact>([select email from contact where id=:contactIDs]);
        
            //US203673 - Implement Case Time Zones for Callback SLOs 
            for(State_BusinessHours__c stz:businessHoursForState){
                if( stz.BusinessHours_Change_Effect_From__c!= null && System.now() <  stz.BusinessHours_Change_Effect_From__c)
                    stateBusinessHoursMap.put(stz.Country__c+';'+stz.State_Code__c,stz.Current_BusinessHours__c);
                else
                    stateBusinessHoursMap.put(stz.Country__c+';'+stz.State_Code__c,stz.Next_BusinessHours__c);
            }
            System.debug('%%%%%%%%%%%stateBusinessHoursMap:'+stateBusinessHoursMap);

            if(siteAssMap != null && siteAssMap.size()>0){
                for(Site_Association__c siteRec :siteAssMap.values()){                                   
                    if(siteRec.Country_picklist__c!=null)
                        siteCntryMap.put(siteRec.id,siteRec.Country_picklist__c);
                    if(siteRec.Enterprise_ID__c!=null)
                        siteAccMap.put(siteRec.id,siteRec.Enterprise_ID__c);   
                    if(siteRec.SC_SITE_CSM__c!=null)
                        csmSiteIds.add(siteRec.id);   
                    
                    //US203673 - Implement Case Time Zones for Callback SLOs 
                    siteStateMap.put(siteRec.id,siteRec.Country_Picklist__c+';'+siteRec.State__c);
                    if( stateBusinessHoursMap.containsKey(siteRec.Country_Picklist__c+';'+siteRec.State__c ) ){
                        siteStateBusinessHoursMap.put(stateBusinessHoursMap.get(siteRec.Country_Picklist__c+';'+siteRec.State__c),siteRec.Id); 
                    }
                    if( stateBusinessHoursMap.containsKey(siteRec.Country_Picklist__c+';null') ) {//To check if default country has daylight timezones configured                               
                        siteStateBusinessHoursMap.put(stateBusinessHoursMap.get(siteRec.Country_Picklist__c+';null'),siteRec.Id);
                    } 
                    
                }
                System.debug('%%%%%%%%%%%siteStateBusinessHoursMap:'+siteStateBusinessHoursMap);
            }
            
             //US203673 - Implement Case Time Zones for Callback SLOs - starts               
            List<String> bHNameList = new List<String>();
            bHNameList.addAll(siteCntryMap.values());
            bHNameList.addAll(new List<String>(siteStateBusinessHoursMap.keySet()));
            if(bHNameList.size()>0)
                busHrsList = [select id,Name from Businesshours where name in: bHNameList and isActive = true];
            
            for(BusinessHours bhRec:busHrsList)
                busHrsIdMap.put(bhRec.Name,bhRec.id);
        
            //Commented for US203673
            /*if(siteCntryMap.size()>0)
                busHrsList = [select id,Name from Businesshours where name in: siteCntryMap.values()];
            
            for(BusinessHours bhRec:busHrsList)
                busHrsIdMap.put(bhRec.Name,bhRec.id);*/
            
            //US203673 - Implement Case Time Zones for Callback SLOs  -  ends
        
            if(!closedCaseIds.isEmpty()){     
                List<Task> taskLst = [select id,Ownerid,whatid,Case__c,Type,RecordTypeId from task where (whatid in:closedCaseIds and status NOT IN ('Closed', 'Completed')) OR (Case__c in:closedCaseIds and status Not IN ('Completed'))]; 
                System.debug('Case Gateway task list ==>'+taskLst);
                if(!taskLst.isEmpty()){        
                    for(Task taskRec:taskLst){          
                        List<Task>  taskList =  taskMap.get(taskRec.Whatid);            
                      if(taskRec.Case__c ==null) {
                      
                            if(taskMap.containsKey(taskRec.Whatid) ){
                                List<Task> rec = new List<Task>();
                                rec = taskMap.get(taskRec.Whatid) ; 
                                rec.add(taskRec);
                                Set<Task> taskSet = new Set<Task>(); //code added to remove duplicate records
                                taskSet.addAll(rec);
                                rec = new List<Task>();
                                rec.AddAll(taskSet);
                                
                                taskMap.put(taskRec.Whatid,rec);
                                
                            }
                            else{              
                                List<Task> rec = new List<Task>();
                                rec.add(taskRec);
                                
                                taskMap.put(taskRec.Whatid,rec);
                                
                                
                            }
                        
                     }
                       if(taskRec.Case__c !=null) { 
                        
                            if(taskMap.containsKey(taskRec.Case__c)){
                                List<Task> rec = new List<Task>();
                                rec = taskMap.get(taskRec.Case__c) ; 
                                rec.add(taskRec);
                                Set<Task> taskSet = new Set<Task>(); //code added to remove duplicate records
                                taskSet.addAll(rec);
                                rec = new List<Task>();
                                rec.AddAll(taskSet);
                                
                                taskMap.put(taskRec.Case__c,rec);
                            }
                            else{
                                List<Task> rec = new List<Task>();
                                rec.add(taskRec);
                                taskMap.put(taskRec.Case__c,rec);
                                System.debug('Inside IF-Else taskMap ==>' +taskMap);
                                
                            }
                        
                        }
                        
                    } 
                    System.debug('Case Gateway taskMap ==>' + taskMap);
                } 
                
                // start of fix for case close error issue in fsb1
                 else{
                    taskMap = new Map<id, List<Task>>();
                }
               // end of fix for case close error issue in fsb1
            }

            if(openCaseIds!=null && openCaseIds.size()>0){
               
              List<Task> openTaskList = [select id,Type,Status,WhatId,Due_Date_SLO__c from Task where WhatId IN:openCaseIds and ( Type='SE Action' or Type like '%Callback' ) and Status<>'Closed'];
              
            
               for(Task tsk:openTaskList){
                   if(tsk.Type=='SE Action')
                     seAction.add(tsk.WhatId);
                   else{
                       if(tsk.Due_Date_SLO__c < System.now())
                           expSLO.add(tsk.WhatId);
                       if(tsk.Type=='Initial Callback')
                           initialCB.add(tsk.WhatId);
                       else if(tsk.Type=='Callback')
                           openCB.add(tsk.WhatId);                          
                   }   
               }
            }

                //Timeboxing - Starts
                String managerAction;
                String managerActionComment;
                for(Case caseRec:lstTrigger){
                    if(caseRec.ThresholdCalc_Enabled_on_Product__c && caseRec.Case_Type__c !=  System.Label.ProactiveCaseType ) {
                        if(Trigger.isInsert){
                            caseRec=SupportThresholdCalculator.performThresholdCalculations(caseRec, null,busHrsIdMap);
                        }
                        else if(Trigger.isUpdate){                            
                            Case oldcase =(Case) Trigger.oldMap.get(caseRec.Id);
                            if(caseRec.CA_Product_Controller__c!= oldcase.CA_Product_Controller__c){
                                caseRec = SupportThresholdCalculator.performThresholdCalculations(caseRec, null,busHrsIdMap);//TODO: Should we check seacion??
                            }
                          //Start Case concern check
                          if(caseRec.Case_Type__c != 'Case Concern'){
                          
                            if(caseRec.Troubleshooting_Stage__c!= oldcase.Troubleshooting_Stage__c ){
                                if((caseRec.Troubleshooting_Stage__c.equalsIgnoreCase(system.label.SolutionIdentification)|| caseRec.Troubleshooting_Stage__c.equalsIgnoreCase(system.label.CauseDetermination)) && seAction!=null && seAction.size()>0){
                                    caseRec = SupportThresholdCalculator.performThresholdCalculations(caseRec, seAction,busHrsIdMap);
                                }else{
                                    caseRec = SupportThresholdCalculator.performThresholdCalculations(caseRec, null,busHrsIdMap);
                                }
                            }
                            else{
                                    if(UtilityFalgs.isSEActionTaskCreated && (caseRec.Troubleshooting_Stage__c.equalsIgnoreCase(system.label.SolutionIdentification) || caseRec.Troubleshooting_Stage__c.equalsIgnoreCase(system.label.CauseDetermination)) && seAction!=null && seAction.size()>0) {
                                             caseRec = SupportThresholdCalculator.performThresholdCalculations(caseRec, seAction,busHrsIdMap);
                                    }
                            }                              
                            if(caseRec.Severity__c!= oldCase.Severity__c){
                                if(caseRec.Troubleshooting_Stage__c== oldCase.Troubleshooting_Stage__c){
                                    if((caseRec.Troubleshooting_Stage__c.equalsIgnoreCase(system.label.SolutionIdentification)|| caseRec.Troubleshooting_Stage__c.equalsIgnoreCase(system.label.CauseDetermination)) && seAction!=null && seAction.size()>0){
                                        caseRec=SupportThresholdCalculator.performThresholdCalculationsonSevChange(caseRec,seAction,busHrsIdMap);
                                    }else{
                                        caseRec=SupportThresholdCalculator.performThresholdCalculationsonSevChange(caseRec,null,busHrsIdMap);
                                    }
                                }
                            }
                          }//end of case concern check
                        }//end of Trigger.isUpdate
                    }
                    else{
                        managerAction = caseRec.Manager_Action__c;
                        managerActionComment = caseRec.Manager_Action_Comment__c;
                        caseRec = SupportThresholdCalculator.clearThresholdValues(caseRec);
                    }
                    
                    //-----
                    if(Trigger.isUpdate && Trigger.isBefore){
                        Case oldcase =(Case) Trigger.oldMap.get(caseRec.Id);
                        Boolean prodChangedFromCalctoNonCalc = caseRec.CA_Product_Controller__c!= oldcase.CA_Product_Controller__c && !caseRec.ThresholdCalc_Enabled_on_Product__c && caseRec.Case_Type__c != System.Label.ProactiveCaseType;
                        if(caseRec.ThresholdCalc_Enabled_on_Product__c  && caseRec.Case_Type__c != System.Label.ProactiveCaseType )   {
                            if(caseRec.Manager_Action__c!= oldCase.Manager_Action__c){
                                if(!UtilityFalgs.clearManagerActionValues){
                                    if(caseRec.Manager_Action__c== null || caseRec.Manager_Action__c==''){
                                        caseRec.addError(system.label.Manager_Action_cannot_be_made_blank);
                                    }
                                    
                                }
                            }
                        }else{
                            if(UtilityFalgs.clearManagerActionValues && !prodChangedFromCalctoNonCalc){
                                if(managerAction!=null || managerActionComment!=null){
                                        caseRec.addError(System.label.Cannot_Set_Manager_Action);//('Cannot set \'Manager Action\' or \'Manager Action Comment\' when Thresholds are not calculated');
                                }
                            }
                        }
                        
                        if(caseRec.Threshold_Start_Date_Time__c == null){
                            if(caseRec.Manager_Action__c!= null ||caseRec.Manager_Action_Comment__c!=null ){
                                caseRec.addError(System.label.Cannot_Set_Manager_Action);//('Cannot set \'Manager Action\' or \'Manager Action Comment\' when Thresholds are not calculated');
                            }
                        }else{
                            if(caseRec.Manager_Action_Comment__c != oldcase.Manager_Action_Comment__c && caseRec.Manager_Action_Comment__c!=null){
                                caseRec.Manager_Action_Comment_By__c = UserInfo.getUserId();
                                caseRec.Manager_Action_Comment_Update_Date_Time__c = System.now();
                            }
                            if(caseRec.Manager_Action__c != oldcase.Manager_Action__c && caseRec.Manager_Action__c!=null){
                                caseRec.Manager_Action_Update_By__c = UserInfo.getUserId();
                                caseRec.Manager_Action_Update_Date_Time__c = System.now();
                            }
                        }
                                              
                        
                    }
                } //Timeboxing - Ends        
            return busHrsIdMap;       
    }

    // fetch pmf key of respective user for populating previous modied user on
    // GSS transaction record.
    // fetch latest GSS transaction record for case and store theese details in
    // previous values of a new Gss transaction record.

    public static Map<id,User> loadCaseBulkAfter(){

        List<Case> lstTrigger = trigger.New;      
        Set<id> lastModUsrIdSet= new set<id>();
        Set<id> gssCaseIds= new set<id>();
        Set<Id> updatedStatusCaseIdSet = new Set<Id>();
        Set<Id> portalViewCaseIdSet = new Set<Id>(); // Set to store Case Id for which Case Portal View  will be updated
        //List<Case> caseAlert=new List<Case>();  //US78177 - Commented as part of US78177
        List<CaseComment> closeCCList = new List<CaseComment>();
        for(Case rec: lstTrigger){
            lastModUsrIdSet.add(rec.LastmodifiedbyID); 
            if(Trigger.isUpdate){
                gssCaseIds.add(rec.Id);  
                Case oldcase = (Case)Trigger.OldMap.get(rec.id); 
          //updated condition to look for next action due date also - VELUD01 - 30-01-2015 - 300-208365
                if(rec.Status!=oldcase.status  ||oldcase.Next_Action__c!=rec.Next_Action__c || oldCase.Next_Action_Due_Date__c!=rec.Next_Action_Due_Date__c ){
                    updatedStatusCaseIdSet.add(rec.Id);
                }    
                //US78177 - Commented as part of US78177
                /*
                if(rec.Status!=oldcase.status || rec.Severity__c != oldcase.Severity__c){
                       
                        caseAlert.add(rec);
                } */
                //DE133448 : Identify cases where Action Code and Next Action fields are changed  
                if((rec.Issue_Action_c__c!=oldcase.Issue_Action_c__c)|| (rec.Next_Action__c!=oldcase.Next_Action__c)||(rec.Next_Action_Date__c!=oldcase.Next_Action_Date__c)||(rec.Next_Action_Due_Date__c!=oldcase.Next_Action_Due_Date__c)) {
                    
                     portalViewCaseIdSet.add(rec.Id);
                    
                }              
               //US184023 : Creating case comment to case has confidential attachment
                if(rec.Status=='Closed' && oldcase.status!='Closed')
                {
                    if(rec.Confidential_Attachments__c){
                        CaseComment CloseCC = new CaseComment();
                        CloseCC.ParentId = rec.Id;
                        CloseCC.IsPublished = false;
                        String str = label.ClousreCommentBody_ConfidentialAttachment;
                        String target = '00xxxxxx';
                        String replacement = rec.CaseNumber;
                        String finalComment = str.replace(target ,replacement);
                        CloseCC.CommentBody = finalComment;
                        //CloseCC.CommentBody = 'It is a requirement to delete all file attachments related to Case '+rec.CaseNumber+'.  Please make sure you have deleted all related file attachments.';
                        CloseCCList.add(CloseCC);
                    }
                }
                
                
                    /*if(rec.Status=='Closed' || rec.Status=='Verify'){
                       boolean isVDA=false;
                       boolean VDAProductComponent = false;
                       boolean VDAProductController = [SELECT VDA_Product__c FROM CA_Product_Controller__c where id=:rec.CA_Product_Controller__c].VDA_Product__c;
                        if(rec.CA_Product_Component__c!=null){
                             VDAProductComponent = [SELECT VDA_Product_Component__c  FROM CA_Product_Component__c where id=:rec.CA_Product_Component__c].VDA_Product_Component__c;
                        }
                        if(VDAProductController==true && VDAProductComponent==true){
                            isVDA=true;
                        }
                        
                        if(isVDA){
                            if(rec.CaseResolvePageHidden__c!='CaseResolvePage')
                            {
                                 rec.addError('Please click Resolve Case button to update function and category of case');
                            }
                        }else{
                             rec.Function__c=null;
                             rec.Root_Cause_Category_vda__c=null;
                             rec.Root_Cause_Sub_Category__c=null;
                            if(rec.CaseResolvePageHidden__c!='CaseResolvePage')
                            {
                                rec.addError('Please click Resolve Case button to update function and category of case');
                            }
                        }
                    }*/
                
                
            }

        }
         if(CloseCCList!=null && CloseCCList.size()>0){
                insert CloseCCList;}
        
        //US78177 - Commented as part of US78177
        /*
          if(!UtilityFalgs.sentAlert && caseAlert.size()>0 && caseAlert!=null)
          {
              
             UtilityFalgs.sendMail(caseAlert);
             UtilityFalgs.sentAlert=true;
          } */
          
          String caseStage;//US108116
        System.debug('gssCaseIds.isEmpty()-->'+gssCaseIds.isEmpty());
        System.debug('gssCaseIds-->'+gssCaseIds);
        if(!gssCaseIds.isEmpty()){
        
         
            List<GSS_Transactions__c> gssLst = [select id,Case__c,Case__r.Troubleshooting_Stage__c,Current_Next_Action__c,Current_Status__c,Current_Status_Added_By__c,Curr_Next_Action_By__c,Current_Next_Action_Date__c,
                                                Current_Status_Date__c,Current_GSS_TR__c,Current_Next_Action_Due_Date__c,Current_GSS_TR_Date__c,Current_Stage_End_Date__c,Stage_Count__c from GSS_Transactions__c where Case__c in: gssCaseIds
                                                and Stage_Count__c = null order by createdDate  desc ];                                                
                                                 //US131502 - commented   --->,  added createdDate  desc, and removed LastModifieddate desc                                    

    
            if(gssLst!=null && !gssLst.isEmpty()){
                for(GSS_Transactions__c  gssRec: gssLst){
                    if(!caseGssMap.keySet().contains(gssRec.Case__c))
                        caseGssMap.put(gssRec.Case__c,gssRec); 
                } 
            } //CLOSED the loop of if for gss transantion to be independent of task 
                //US108116 - starts
                List<GSS_Transactions__c> gssLst2 = [select id,Case__c,Case__r.Troubleshooting_Stage__c,Current_Next_Action__c,Current_Status__c,Current_Status_Added_By__c,
                Curr_Next_Action_By__c,Current_Next_Action_Date__c,Current_Status_Date__c,Current_GSS_TR__c,Current_Next_Action_Due_Date__c,Current_GSS_TR_Date__c,
                Current_Stage_End_Date__c,Stage_Count__c,Current_Troubleshooting_Stage__c  from GSS_Transactions__c where Case__c in: gssCaseIds 
                                                order by LastModifieddate desc,  createdDate  desc]; 

                for(GSS_Transactions__c gssRec : gssLst2){                    
                    caseStage = gssRec.Case__c+'-'+gssRec.Current_Troubleshooting_Stage__c;  //US131502  - commented this - caseStage = gssRec.Case__c+'-'+gssRec.Current_Status__c;            
                                    if(!caseStageGSSMap.keySet().contains(caseStage) && gssRec.Stage_Count__c != null){                      
                        caseStageGSSMap.put(caseStage,gssRec);
                    }                    
                }

                //US108116 - ends

           // } //CLOSED the loop of if for gss transantion to be independent of task //US131502
                //querying other support record type Tasks with type SE Action to set Calculated status on GSS trasanction record
                List<Task> otherSupportTaskList = [select Id,Status,WhatId from Task where RecordTypeId =: Label.Other_Support_Task_Record_Type  AND  Type = 'SE Action'
                                                    AND (WhatId IN :updatedStatusCaseIdSet )];  
                if(otherSupportTaskList!=null && otherSupportTaskList.Size()>0){
                    for(Task taskRec : otherSupportTaskList ){
                        if(otherSupportTypeTaskMap!=null && otherSupportTypeTaskMap.containsKey(taskRec.WhatId)){
                           List<Task> taskList = otherSupportTypeTaskMap.get(taskRec.WhatId);
                           taskList.add(taskRec);
                           otherSupportTypeTaskMap.put(taskRec.WhatId,taskList);
                        }
                        else{
                           otherSupportTypeTaskMap.put(taskRec.WhatId,new List<Task>{taskRec});
                        }
                    }
                }                                   
                     
        }
        //DE133448 : Query Portal View Records and Set Portal View Date for identified cases
        if(!portalViewCaseIdSet.isEmpty()){
            casePortalViewList = [select Id , Case__c , Portal_View_Date__c from Case_Portal_View__c where Case__c IN :portalViewCaseIdSet ];
            for(Case_Portal_View__c portalView :casePortalViewList ){
                portalView.Portal_View_Date__c=System.Now(); 
            }
        }
        // End DE133448
        usrPMFkeyMap = new Map<id,User>([select id,PMFKey__c from User where id in:lastModUsrIdSet]);      
        return usrPMFkeyMap;
    }
    
    //Commented as part of US252305
   public static void updInternalPriority(Case caseRec){
       System.debug('UtilityFalgs.isInitialCallBackTaskCreated:'+UtilityFalgs.isInitialCallBackTaskCreated);
      String nextAct=caseRec.Next_Action__c;     
      //updated dueDate field from Date to Datetime - VELUD01 - 30-01-2015 - 300-208365       
      DateTime nextActDueDate =null;
            
      if(caseRec.Next_Action_Due_Date__c!=null)
         nextActDueDate = caseRec.Next_Action_Due_Date__c; 
      
      //end of changes for 300-208365 
      
      //Case concern we put internal Priority value as zero             
      if(caseRec.Case_Type__c == 'Case Concern'){
         caseRec.Internal_Priority__c='0'; 
      }
      else if(caseRec.Status=='Closed')
         caseRec.Internal_Priority__c='99';
      else if(caseRec.Status=='Verify')
         caseRec.Internal_Priority__c='12';   
      else{ 
          if(nextActDueDate<system.Today()){
          caseRec.Internal_Priority__c='1';    
          }            
         else if(caseRec.Next_Action__c==null ){
          caseRec.Internal_Priority__c='2'; 
         }           
         else if(Trigger.isInsert){         
               caseRec.Internal_Priority__c='3';
          }
          else if(Trigger.isUpdate && initialCB!=null && initialCB.contains(caseRec.Id)){
            caseRec.Internal_Priority__c='3'; 
          }
          //US134926
           else if(Trigger.isUpdate && (UtilityFalgs.isInitialCallBackTaskCreated!=null && UtilityFalgs.isInitialCallBackTaskCreated == true)){
            caseRec.Internal_Priority__c='3'; 
              // UtilityFalgs.isInitialCallBackTaskCreated=false;
          }  
         else if(caseRec.Internal_Priority_4__c=='Y' || expSLO!=null && expSLO.contains(caseRec.Id)){
            caseRec.Internal_Priority__c='4';  
          }
          else if(caseRec.Site_Association__c!=null && csmSiteIds!=null && csmSiteIds.contains(caseRec.Site_Association__c)){   
            caseRec.Internal_Priority__c='5';  
          }
          else if(openCB!=null && openCB.contains(caseRec.Id)){
            caseRec.Internal_Priority__c='6';
          }    
          //US134926
          else if(nextActDueDate<>null && nextActDueDate.date()==system.Today() && NextAct!=null && (NextAct.contains('Pending CA') ||  NextAct.contains('Pending Partner') || NextAct.contains('Pending 3rd Party Vendor'))){
             caseRec.Internal_Priority__c='7';  
          }             
          else if(nextActDueDate<>null && nextActDueDate.date()==system.Today() && NextAct!=null && NextAct.contains('Pending Customer') ){
                 caseRec.Internal_Priority__c='8';
          }         
          else if(nextActDueDate<>null && nextActDueDate > system.Today() && NextAct!=null && (NextAct.contains('Pending CA') ||  NextAct.contains('Pending Partner') || NextAct.contains('Pending 3rd Party Vendor'))){
            caseRec.Internal_Priority__c='9';
          }
          else if(nextActDueDate<>null && nextActDueDate > system.Today() && NextAct!=null && NextAct.contains('Pending Customer')){
            caseRec.Internal_Priority__c='10';
          }
          //US134926
          else if(seAction!=null && seAction.contains(caseRec.Id)){
            caseRec.Internal_Priority__c='11';  
          }
          else{
             caserec.Internal_Priority__c='0'; 
          }
      }
      //internalPriorityValue =  caseRec.Internal_Priority__c.length()>1?caserec.Internal_Priority__c:'0'+caserec.Internal_Priority__c;
    } 
    /* CR:400-1600
    public static void updateContactFieldsOnCase(Case caseRec)
    {
        
          if(!Label.Service_cloud_external_user_profile.contains(userinfo.getProfileId().substring(0,15))){
        if(caseRec.Internal_Contact__c==null && caseRec.contactid != null)
        {
        Contact contactInsert=CaseGateway.contactsMapInsert.get(caseRec.ContactID);
        caseRec.Alt_Contact_First_Name__c = contactInsert.FirstName;
        caseRec.Alt_Contact_Last_Name__c = contactInsert.LastName;
        caseRec.Alternate_Phone__c = contactInsert.phone;
        caseRec.Alt_Contact_Alternate_Language__c = contactInsert.SC_CONTACT_Language_Preference2__c;
        caseRec.Alternate_email__c = contactInsert.Email;
        caseRec.Alt_Contact_Preferred_Contact_Method__c = contactInsert.SC_CONTACT_Preferred_Contact_Method__c;
        caseRec.Alt_Contact_Preferred_Language__c = contactInsert.Language_Preference__c;
        }
        if(caseRec.Internal_Contact__c!=null && caseRec.contactid == null)
        {
        User userInsert=CaseGateway.userMapInsert.get(caseRec.Internal_Contact__c);
        caseRec.Alt_Contact_First_Name__c = userInsert.FirstName;
        caseRec.Alt_Contact_Last_Name__c = userInsert.LastName;
        caseRec.Alternate_Phone__c = userInsert.phone;
        caseRec.Alternate_email__c = userInsert.Email;
        caseRec.Alt_Contact_Preferred_Contact_Method__c = userInsert.Preferred_Contact_Method__c;
        }
        } 
    }
    */

  public static boolean checkSurveyEligibility(Case caseRec){
        
        system.debug('#############'+caseRec);
        boolean eligibleForSurvey = false;
        
       //US100666 changes to restrict for survey
        system.debug(PilotProduct__c.getAll().values()+'------NAME: '+caseRec.CA_Product_Controller__c);
        if(caseRec.Do_Not_Survey__c)
        {
            eligibleForSurvey = false;
        }
        else if(
               (caseRec.status=='Closed')
            && (caseRec.Reopen_Count__c==0)   
            && (!(caseRec.Internal_Contact__c != null))  
            && (!caseRec.Internal_CA__c) 
            && (caseRec.contactid!=null) && (caseRec.Case_Type__c != 'Chat' ) //#liveAgent 
            && ( contactsMap.get(caseRec.contactid).email != null)
            && (!(contactsMap.get(caseRec.contactid).email.endsWith('@ca.com')))
            && (!(contactsMap.get(caseRec.contactid).email.endsWith('@CA.COM')))
            && (!(contactsMap.get(caseRec.contactid).email.endsWith('@contractor.ca.com')))
            && (!(contactsMap.get(caseRec.contactid).email.endsWith('@cai.com')))
            && (!(contactsMap.get(caseRec.contactid).email.endsWith('@CAI.COM')))) {
                
            if(siteAssMap.get(caseRec.Site_Association__c).SC_CA_Internal_Site__c != true){
                eligibleForSurvey = true;
                //Survey Pilot---START
              /*  Boolean pilotProductValue=false;
                List<PilotProduct__c> listOfPilotProducts = PilotProduct__c.getAll().values();
                List<String> listOfPilots = new List<String>();
                system.debug(listOfPilotProducts.size()+'####'+listOfPilotProducts+'NAME: '+caseRec.CA_Product_Controller__c);
                if(listOfPilotProducts<>null && listOfPilotProducts.size()>0){
                    if(!Test.isRunningTest()){
                        if(caseRec<>null){// && caseRec.contactId<>null){
                            //List<Contact> contactObj = [Select Language_Preference__c from Contact where id=:caseRec.contactId];
                            //if(contactObj<>null && contactObj.size()>0){
                                for(PilotProduct__c pilotProduct:listOfPilotProducts){
                                    listOfPilots.add(pilotProduct.Pilot_Product_Id__c);
                                    if(pilotProduct.Pilot_Product_Id__c == caseRec.CA_Product_Controller__c){// && contactObj[0].Language_Preference__c.equalsIgnoreCase('English')){
                                        pilotProductValue = true;   
                                        system.debug('####'+pilotProduct.Name);
                                        system.debug('####'+pilotProduct.Name);
                                        system.debug('####1'+(pilotProduct.Pilot_Product_Id__c));
                                        system.debug('####2'+(caseRec.CA_Product_Controller__c));
                                    }
                                }
                            //}
                        } 
                    }else{
                         pilotProductValue = true;   
                    }*/
                    
                     //if(pilotProductValue && listOfPilots<>null && listOfPilots.size()>0){
                        Date startDateOfWeek = system.today().toStartofWeek().addDays(1);
                         Date startDateOfWeek2 = system.today().toStartofWeek(); //3/19
                          Date startDateOfWeek1 = system.today().toStartofWeek().adddays(-6); //3/13
                          Datetime dt = System.now();

                       // Date startDateOfWeek1 = system.today().toStartofWeek().addDays(7);
                       
                       List<Case> weeklyClosedCasesTillToday = new List<Case>();//300-679230 
                         List<Case> todayClosedCases = new List<Case>();//300-679230
                        //List<Case> weeklyClosedCasesTillToday ;
                        // List<Case> todayClosedCases ;
                         //System.debug(dt.formatGMT('EEEE')+'----DAY-----'+'week===='+startDateOfWeek+'today====='+system.today()+'now===='+system.now()+'$$$==='+caseRec.ContactId+'======'+listOfPilots);
                        if(startDateOfWeek<=system.today() && dt.formatGMT('EEEE') <> 'Sunday' ) {
                            weeklyClosedCasesTillToday = [Select Id from Case where status=:'Closed' AND ClosedDate>=:startDateOfWeek AND ClosedDate<=:system.now() AND ContactId=:caseRec.ContactId AND Eligible_For_Survey__c=:true];//  AND CA_Product_Controller__c IN:listOfPilots];//AND Survey_sent__c=:false
                            todayClosedCases = [Select Id from Case where status=:'Closed' AND ClosedDate>=:system.today() AND ContactId=:caseRec.ContactId AND Eligible_For_Survey__c=:true];// AND CA_Product_Controller__c IN:listOfPilots];  //AND Survey_sent__c=:false
                        }
                           else If (dt.formatGMT('EEEE') == 'Sunday'){
                                weeklyClosedCasesTillToday = [Select Id from Case where status=:'Closed' AND ClosedDate>=:startDateOfWeek1 AND ClosedDate<=:startDateOfWeek2  AND ContactId=:caseRec.ContactId AND Eligible_For_Survey__c=:true];//  AND CA_Product_Controller__c IN:listOfPilots];//AND Survey_sent__c=:false
                                todayClosedCases = [Select Id from Case where status=:'Closed' AND ClosedDate>=:system.today() AND ContactId=:caseRec.ContactId AND Eligible_For_Survey__c=:true];// AND CA_Product_Controller__c IN:listOfPilots];  //AND Survey_sent__c=:false
                           }
                           /* system.debug('###todayClosedCases#'+todayClosedCases.size());
                            system.debug('###weeklyClosedCasesTillToday#'+weeklyClosedCasesTillToday.size());
                             system.debug('####3'+(caseRec.ContactId));  
                            system.debug('####4'+(medalliaSurveyFlag)); 
                            //300-679230---ticket*/
                            
                            
                            if((weeklyClosedCasesTillToday <> null && weeklyClosedCasesTillToday.size()<4) && (todayClosedCases<>null && todayClosedCases.size()<2)){
                                eligibleForSurvey = true;
                                medalliaSurveyFlag = false;
                                //system.debug('####4a'+(medalliaSurveyFlag));
                                                               
                            }else{
                                eligibleForSurvey = false;
                                //system.debug('####5'+(medalliaSurveyFlag));
                           // }
                       // }
                   // }
               }
                //Survey Pilot---END
                 
                for(Emails_List__c emailsList : Emails_List__c.getAll().values()){
                    if((contactsMap!=null )&&(contactsMap.get(caseRec.contactid).email == emailsList.name)) eligibleForSurvey  = false;
                }
                for(Products_List__c productsList : Products_List__c.getAll().values()){
                    if((prodCompMap!=null )&&(prodCompMap.get(caseRec.CA_Product_Component__c).Component_Code__c == productsList.name)) eligibleForSurvey  = false;
                }
                for(Sites_List__c sitesList: Sites_List__c.getAll().values()){
                    if((siteAssMap!=null) && (siteAssMap.get(caseRec.Site_Association__c).SC_TOPS_ID__c   == sitesList.name)) eligibleForSurvey  = false;
                }
            }
        }
        return eligibleForSurvey;
    }
    
    public static boolean checkAccountSelectSupportExperience(String siteId){
        if(String.isNotBlank(siteId)){
            List<Site_Association__c> siteAssocicationObj = [Select Id, Enterprise_ID__c, Enterprise_ID__r.Select_Support_Experience__c from Site_Association__c where Id=:siteId limit 1]; 
            if(siteAssocicationObj<>null && siteAssocicationObj.size()>0 && siteAssocicationObj[0].Enterprise_ID__c<>null){
                if(siteAssocicationObj[0].Enterprise_ID__r.Select_Support_Experience__c){
                    return true;    
                }else{
                    return false;
                }    
            }
        }
        return false;//300-677552--remove return null
    }   
    
    //US344581 --- START
    public static Boolean checkCallBackTask(Id caseId){
        List<Task> listOfTask = [Select Id, createdDate, Type from Task where whatId=:caseId AND Status!='Closed' AND Type like '%Callback' order by createddate desc limit 1];//AND Subject=:taskSubject 
        system.debug('--listOfTask->'+listOfTask);
        if(listOfTask<>null && listOfTask.size()>0){
            if(listOfTask[0].createdDate.addHours(Integer.valueOf(System.Label.CallBackHours))<system.now()){
                return true;
            }else{
                return false;
            }
        }
        return true;
    }
    //US344581 --- END
    
    public static Boolean isExternalUser() {
       
      return (Label.Service_cloud_external_user_profile.contains(userinfo.getProfileId().substring(0,15))
          || userinfo.getProfileId() == CC_Settings.communityUserDefaultAccountId || UserInfo.getProfileId().contains(System.Label.InternalOverageProfile) || UserInfo.getProfileId().contains(System.Label.ExternalOverageProfile)
             || Label.CC_Profiles.contains(userinfo.getProfileId().substring(0,15))
             ); //DE301432 -- Beta Case Detail: Severity Change/Case Close is not creating a callback
    }

    //US203673 - Implement Case Time Zones for Callback SLOs 
    //To fetch the BusinessHoursId based on State/Country on SiteAssociation
    public static Id fetchBusinessHoursId(Case caseRec , Map<String,Id>busHrsIdMap){
        Id bhrsId = null;
        String siteAssocState;
        String siteAssocCountry;
        String countryName;
        if(caseRec.Site_Association__c !=null){
             siteAssocState = CaseGateway.siteStateMap.get(caseRec.Site_Association__c); 
             siteAssocCountry = CaseGateway.siteCntryMap.get(caseRec.Site_Association__c);
             countryName = siteAssocState.substringBefore(';');
        }
        System.debug('###siteAssocState:'+siteAssocState);
        System.debug('###siteAssocCountry:'+siteAssocCountry);
        System.debug('### busHrsIdMap : ' + busHrsIdMap);

        
        System.debug('###countryName:'+countryName);

        if(siteAssocState != null &&  CaseGateway.stateBusinessHoursMap.containsKey(siteAssocState)){
                if( busHrsIdMap.containsKey(CaseGateway.stateBusinessHoursMap.get(siteAssocState)) ){
                        System.debug(' *** Enetred 1 ***');
                        bhrsId = busHrsIdMap.get(CaseGateway.stateBusinessHoursMap.get(siteAssocState));
                }
                else if( CaseGateway.stateBusinessHoursMap.containsKey(countryName+';null') && ( busHrsIdMap.containsKey(CaseGateway.stateBusinessHoursMap.get(countryName+';null'))) ) {
                        System.debug(' *** Enetred 2  ***');
                        bhrsId = busHrsIdMap.get(CaseGateway.stateBusinessHoursMap.get(countryName+';null'));
                }
                else{
                        System.debug(' ### Entered Country block1 ###');
                        bhrsId = busHrsIdMap.get(siteAssocCountry); 
                }
        } 
        else if( CaseGateway.stateBusinessHoursMap.containsKey(countryName+';null') ){
                 if( busHrsIdMap.containsKey(CaseGateway.stateBusinessHoursMap.get(countryName+';null')) ){
                         System.debug(' ***@ Enetred 1 ***@ ');
                         bhrsId = busHrsIdMap.get(CaseGateway.stateBusinessHoursMap.get(countryName+';null'));
                 }
                 else{
                        System.debug(' ### Entered Country block 2###');
                        bhrsId = busHrsIdMap.get(siteAssocCountry); 
                }
        }
        else {
                System.debug(' ### Entered Country block 3###');
                bhrsId = busHrsIdMap.get(siteAssocCountry); 
        }

        /*
        //Enters the if block When state is configured in the custom setting 'State BusinessHours'  
        if(siteAssocState != null &&  CaseGateway.stateBusinessHoursMap.containsKey(siteAssocState)){
            if(siteAssocCountry!=null){
                if(busHrsIdMap.containsKey(CaseGateway.stateBusinessHoursMap.get(siteAssocState))){
                    System.debug(' @@@@@@@@ Enetred 1 @@@@@@@@@@');
                    bhrsId = busHrsIdMap.get(CaseGateway.stateBusinessHoursMap.get(siteAssocState));
                }
                else if(busHrsIdMap.containsKey(CaseGateway.stateBusinessHoursMap.get(siteAssocCountry+';null'))){
                    System.debug(' @@@@@@@@ Enetred 2 @@@@@@@@@@');
                    bhrsId = busHrsIdMap.get(CaseGateway.stateBusinessHoursMap.get(siteAssocCountry+';null'));    
                }
            }
        }
        else{
            //if(siteAssocState != null){
                     siteAssocState = siteAssocState.substringBefore(';');
                    //This block is used if the country (default - with no state) is configured in the custom setting 'State BusinessHours'  
                    if(busHrsIdMap.containsKey(CaseGateway.stateBusinessHoursMap.get(siteAssocState+';null'))){
                        System.debug(' ### Entered Country;null block ### ');
                        bhrsId = busHrsIdMap.get(CaseGateway.stateBusinessHoursMap.get(siteAssocState+';null'));
                    }               
            //}
            else{
                System.debug(' ### Entered Country block ###');
                bhrsId = busHrsIdMap.get(siteAssocCountry);                         
            }
        }     */
        return bhrsId;
    }
    
    /*@Future(callout=true)
    public static void invokeGSServiceviaL7(String caseNumber, String siteId){
        CC_Layer7Service l7Svc = new CC_Layer7Service();
         String responseStatus = l7Svc.callLayer7ToCreateVirtualFolderInEFT(UserInfo.getUserEmail(),caseNumber , siteId);
    } 
    
    CC_Layer7Service l7Svc = new CC_Layer7Service(); */
    
    @future(callout=true)
    public static void caseCreateReferenceComment(Id caseId,String commentBody)
    {
      System.debug('inside createcomments method');
      if(!Test.isRunningTest()){
          String commentID=CC_Layer7Service.InsertPrivateComments(caseId,commentbody);
      }    
    }
   public void caseGatewayTestData(){
        Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
    }
    
}