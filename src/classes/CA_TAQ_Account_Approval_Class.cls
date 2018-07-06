/**********************
Methods in this Class:CA_TAQ_Account_Approval_Class
1. createUpdateStdAccount: Creates Standard Account when a TAQ Account is Approved
2. createTAQAccApprRec : Creates TAQ Account Approved when a TAQ Account is Approved
*********************/
public class CA_TAQ_Account_Approval_Class{

    
    //Called From : CA_TAQ_Account_approval trigger
    //Functionality: Creates and Updates Standard Account when a TAQ Account is Approved
    //Additional Comments: Only for FY13 Regional Accounts, Partner Accounts
    
    public static List<TAQ_Account__c> lstTAQforATM  = new List<TAQ_Account__c>();
    public static Map<Id,Id> taIds = new Map<id,id>(); 
    public static  List<TAQ_Account_Approved__c> lstTAQforATMApproved  = new List<TAQ_Account_Approved__c>();
    
    //CREATED TO TRACK INITIAL SELECTED TAQ ACCOUNT APPROVAL STATUS - CR:192923781 - TADKR01
    Public Static Map<Id,String> mapApprovalStatus = new Map<Id,String>();
   
    //INTRODUCED TO BREAK THE INFINITE LOOP EXECUTION OF THE TRIGGER.    
    Public Static Integer EXEC_COUNT = 0;
    Public Static INTEGER EXECUTED_COUNT = 0;
    Public Static INTEGER EXECUTED_ORGQUOTA_COUNT = 0;
    // INTRODUCED TO TRACK THE SELECTED STATUS OF TAQ ORG.
    public static map<id,string> SELECTED_STATUS = new Map<Id,String>();
    
    //INTRODUCED TO AVOID INCREMENTING THE PARTNER RESELLER IDs TWICE.
    public static Set<String> PROCESSED_PARTNER_TAQ_IDS = new Set<String>();
    
    Set<String> camPmfky;
    Map<String,String> usrMap;
    
   public void createUpdateStdAccount(List<TAQ_Account__c> taqAccs, Map<id,string> mTAQAccOwnerPMFkey)
   {
      System.debug('_________IN CREATE ACCT METHOD______'+taqAccs.size());
      Map<id,string> mrectypeTaq = new Map<id,string>();
      Map<string,id> mrectypeAcc = new Map<string,id>();
      
      //TAQ account record info
      Schema.DescribeSObjectResult taqResult = TAQ_Account__c.SobjectType.getDescribe();
      List<Schema.RecordTypeInfo> taqRecTypes = taqResult.getRecordTypeInfos();

      for(Schema.RecordTypeInfo rtTaq:taqRecTypes)
            mrectypeTaq.put(rtTaq.getRecordTypeId(),rtTaq.getName());

      //Standard Account record info
      Schema.DescribeSObjectResult accountResult = Account.SobjectType.getDescribe();
      List<Schema.RecordTypeInfo> accountRecTypes = accountResult.getRecordTypeInfos();

      for(Schema.RecordTypeInfo rtAcc:accountRecTypes)
            mrectypeAcc.put(rtAcc.getName(), rtAcc.getRecordTypeId());      

      //'Account Team Covered Account','Reseller/Distributor Account'
      Set<id> setTAQAccIds = new Set<id>();
      Set<string> setPMFKeys = new Set<string>();
      Map<string,id> mPMFkeyUserId = new Map<string,id>();
      
      //US331581, get the picklist values from TAQ_Account__c, field Alliance_Program_Level__c, Solution_Provider_Program_Level__c, Service_Provider_Program_Level__c, Velocity_Seller_Program_Level__c keeps the same.
      //only when there is at least one partner account in TAQ account list, get the following describe

      boolean hasPartnerAccount = false;
       for(TAQ_Account__c ta:taqAccs)
        {
            if(mrectypeTaq.get(ta.RecordTypeId).contains('Partner')){
              hasPartnerAccount = true;
              break;
            }
        }

      List<string> allianceProgramLevelList = new List<string>();
      List<string> solutionProgramLevelList = new List<string>();
      list<string> serviceProgramLevelList = new List<string>();

      if (hasPartnerAccount)
      {
        for (Schema.PicklistEntry p : TAQ_Account__c.Alliance_Program_Level__c.getDescribe().getPicklistValues()) { 
            if(p.getValue() != 'Not in Program')      
                allianceProgramLevelList.add(p.getValue());
        }

        for (Schema.PicklistEntry p : TAQ_Account__c.Solution_Provider_Program_Level__c.getDescribe().getPicklistValues()) { 
            if(p.getValue() != 'Not in Program')      
                solutionProgramLevelList.add(p.getValue());
        }

        for (Schema.PicklistEntry p : TAQ_Account__c.Service_Provider_Program_Level__c.getDescribe().getPicklistValues()) { 
            if(p.getValue() != 'Not in Program')      
                serviceProgramLevelList.add(p.getValue());
        }
      }

      for(TAQ_Account__c ta:taqAccs)
      {                     
        System.debug('__TAQ Acct Id__'+ta.id);
       if((ta.Process_Step__c == 'Account Add' || ta.Process_Step__c == 'Account Update') &&  ta.Is_Error_in_Rule__c == false)
       {
         setTAQAccIds.add(ta.id);
       }
      }          
      
      system.debug('setTAQAccIds' + setTAQAccIds);
      
      if(setTAQAccIds.size() > 0)          
      {  
          for(id tid:setTAQAccIds)
            {
                String pmf=mTAQAccOwnerPMFkey.get(tid);
                if(pmf <> null)
                  setPMFKeys.add(pmf); 
            }      
          
          if(setPMFKeys.size() > 0){
              System.debug('__1____'+mTAQAccOwnerPMFkey);
              System.debug('__2____'+setPMFKeys);
              for(user u: [select id, pmfkey__c FROM User where pmfkey__c in : setPMFKeys AND IsActive= TRUE])
              {
                  mPMFkeyUserId.put(u.pmfkey__c.toUpperCase(), u.id); 
              }
          }
                
       }
       else //No Account To be added.. so skip rest
           return;
           
       Map<id, Account> m= new Map<id,account>();
           
       List<Account> lstAcc = new List<Account>();
       List<TAQ_Account__c> partAcc= new List<TAQ_Account__c>();
       
       
       List<TAQ_Account_Team__c> taqActTeams_owners = [SELECT Id,TAQ_Account__c,User__c, isActive__c from TAQ_Account_Team__c
                                                        where TAQ_Account__c in: taqAccs and Is_Account_Owner__c = true];
       Map<Id,TAQ_Account_Team__c> ownerUser_taqAcctTeam = new Map<Id,TAQ_Account_Team__c>();
       for(TAQ_Account_Team__c t: taqActTeams_owners){
        System.debug('______weee____'+t.id);
         ownerUser_taqAcctTeam.put(t.TAQ_Account__c,t);
       }                                                        
       
       // Mari, Nov, 2014 for requirement 1201
       List<Document> doclist = [Select Id, Body From Document  where name = 'Partner Locator Logo' limit 1];
       Document doc;
       if(doclist!=null && doclist.size()>0)
           doc = doclist[0];

       User taqOwner = new User(Id= Label.TAQOwner);
       
       for(TAQ_Account__c ta:taqAccs)
        {

         if(setTAQAccIds.contains(ta.id))
         {
           Account a;
           if(ta.Process_Step__c == 'Account Add')
           {   
             a=new Account();
             a.Website=ta.Website__c;  
           }    
           else
           {   
            a = new Account(id=ta.view_acc_record__c);
            a.Website=ta.Website__c;  
           }

          a.Acquisition_Customer__c = convertMultiSelectField(ta.Acquisition_Customer__c);
           
           if(mrectypeTaq.get(ta.RecordTypeId).contains('Partner')){
           
             System.debug('----in side Partner Account----');            
             string pmf = mTAQAccOwnerPMFkey.get(ta.id);
             string accownerid = mPMFkeyUserId.get(pmf);
             a.Focus_Partner__c = ta.Focus_Partner__c ;       // ALLHA02 US US164377
             a.Referral_Partner__c = ta.Referral_Partner__c;  //AMASA03 Rally Referral
             a.DistributorDesignation__c = ta.DistributorDesignation__c;
       a.Regional_Global_Account__c =ta.Regional_Global_Account__c;
             a.Enterprise_Account_Name__c = ta.Enterprise_Account_Name__c;  
             a.name=ta.name;
             a.recordtypeid=mrectypeAcc.get('Reseller/Distributor Account');
             a.Reseller_Distributor_Name__c=ta.name;
             if(ta.chkPendingReview__c == false) 
               a.Enterprise_ID__c=ta.Reseller_ID__c; //FY13 change

                  
             a.Reseller_Disti_Regional_ID__c=ta.Reseller_ID__c;
             
             if(ta.Solution_Provider_Type__c == 'Distributor' || ta.Velocity_Seller_Type__c == 'Distributor')              
                a.Customer_Category__c = 'Distributor';
             else if(ta.Referral_Partner__c && ta.Alliance__c == False && ta.Service_Provider__c == False && ta.Solution_Provider__c == False && ta.Velocity_Seller__c == False)
                a.Customer_Category__c = null;
             else
                 a.Customer_Category__c=SystemIdUtility.getAccountType();
                 a.Company_Email_Domain_s__c=ta.Company_Email_Domain_s__c;// YEDRA01 Adding email domains validation process AR:2404
                 a.Website=ta.Website__c;     
                 a.GEO__c=ta.Region__c;
                 a.Sales_Area__c=ta.Area__c;
                 a.Sales_Region__c=ta.Territory__c; 
                 a.NameLocal=ta.Account_Name_Local__c;
                 a.Account_Name_Local_2_Phonetic__c=ta.Account_Name_Local_2_Phonetic__c;
                 a.Account_Name_Local_3__c=ta.Account_Name_Local_3__c;
                 a.Physical_Country_Local__c=ta.Physical_Country_Local__c;
                 a.Physical_State_Prov_Local__c=ta.Physical_State_Prov_Local__c;
                 a.Physical_City_Local__c=ta.Physical_City_Local__c;
                 a.Physical_Street_Local__c=ta.Physical_Street_Local__c;
                 a.Physical_Zip_Local__c=ta.Physical_Zip_Local__c;
                 a.Provide_Partner_Kit__c=ta.Provide_Partner_Kit__c;
                 a.Agreement__c=ta.Agreement__c;
                 a.Contract_Start_Date__c=ta.Contract_Start_Date__c;
                 a.Business_Plan__c=ta.Business_Plan__c;
                 a.Business_Plan_Start_Date__c=ta.Business_Plan_Start_Date__c;
                 a.Partner_Enablement_Addendum__c=ta.Partner_Enablement_Addendum__c;
                 a.Agreement_Number__c=ta.Agreement_Number__c;
                 a.Agreement_Attached__c=ta.Agreement_Attached__c;
                 a.Contract_End_Date__c=ta.Agreement_End_Date__c;
                 a.Business_Plan_Attached__c=ta.Business_Plan_Attached__c;
                 a.Business_Plan_End_Date__c=ta.Business_Plan_End_Date__c;
                 a.PDS_Addendum_Attached__c=ta.PDS_Addendum_Attached__c;
                 a.Partner_Enablement_Addendum_Attached__c=ta.Partner_Enablement_Addendum_Attached__c;
                 a.PDS_Addendum__c=ta.PDS_Addendum__c;
                 a.Contract_Start_Date__c=ta.Agreement_Start_Date__c;
                 a.Program_Level__c=ta.Program_Level__c;
                 a.Account_Type1__c=ta.Account_Type1__c;
                 a.Account_Type__c=ta.Account_Type__c;
                 a.Secondary_Designation_Reseller__c=ta.Reseller_Type__c;
                 
                 a.Primary_Designation_Reseller__c=SystemIdUtility.getPrimaryDesignationReseller();
                 a.Account_Status__c=ta.Approval_Status__c;               
                 if(ta.chkPendingReview__c == true) 
                      a.Account_Status__c = 'Pending Review' ;
                 a.Billingcity=ta.Physical_City__c;
                 a.billingstate=ta.Physical_State_Province__c;
                 a.billingstreet=ta.Physical_Street__c;
                 a.billingpostalcode=ta.Physical_Zip_Postal_Code__c;                            
                 a.Eligible_for_MDF__c=ta.Eligible_for_MDF__c;
                 a.Alliance__c=ta.Alliance__c;
                 a.Primary_RTM_Alliance__c=ta.Primary_RTM_Alliance__c;
                 a.Alliance_Type__c=ta.Alliance_Type__c;
                 a.Alliance_Program_Level__c=ta.Alliance_Program_Level__c;
                 a.Alliance_Designation__c=ta.Alliance_Designation__c;
                 a.Alliance_CAM_PMFKey__c=ta.Alliance_CAM_PMFKey__c;
                 a.Agile_Central_Sales_Territory__c=ta.Agile_Central_Sales_Territory__c;
                 a.Solution_Provider__c=ta.Solution_Provider__c;
                 a.Primary_RTM_Solution_Provider__c=ta.Primary_RTM_Solution_Provider__c;

                 a.Solution_Provider_Type__c=ta.Solution_Provider_Type__c;
                 a.Solution_Provider_Program_Level__c = ta.Solution_Provider_Program_Level__c;
                 a.Solution_Provider_Designation__c = ta.Solution_Provider_Designation__c;
                 a.Solution_Provider_CAM_PMFKey__c=ta.Solution_Provider_CAM_PMFKey__c;
                 a.PDS_Addendum__c=ta.PDS_Addendum__c;
                 a.PDS_Addendum_Attached__c=ta.PDS_Addendum_Attached__c;
                                           
                 a.Service_Provider__c=ta.Service_Provider__c;
                 a.Primary_RTM_Service_Provider__c=ta.Primary_RTM_Service_Provider__c;

                 a.Service_Provider_Type__c=ta.Service_Provider_Type__c;
                 a.Service_Provider_Program_Level__c = ta.Service_Provider_Program_Level__c;
                 a.Service_Provider_Designation__c=ta.Service_Provider_Designation__c;
                 a.Service_Provider_CAM_PMFKey__c=ta.Service_Provider_CAM_PMFKey__c;
               
                 a.Velocity_Seller__c=ta.Velocity_Seller__c;
                 a.Primary_RTM_Data_Management__c=ta.Primary_RTM_Data_Management__c;

                 a.Velocity_Seller_Type__c=ta.Velocity_Seller_Type__c; 
                 a.Velocity_Seller_Program_Level__c=ta.Velocity_Seller_Program_Level__c;
                 a.Velocity_Seller_Designation__c = ta.Velocity_Seller_Designation__c ;
                 a.Velocity_Seller_CAM_PMFKey__c=ta.Velocity_Seller_CAM_PMFKey__c;                                       
                 a.Termination_Date__c=ta.Termination_Date__c;
                 a.Termination_reason__c=ta.Termination_reason__c;            
                 a.Credit_Check_completion_date__c=ta.Credit_Check_completion_date__c;
                 //a.Security_Check_completion_date__c=ta.Security_Check_completion_date__c;
                 a.Partner_On_boarding__c = ta.Partner_On_boarding__c; 
                 a.Is_Primary_Account__c = ta.Is_Primary_Account__c;
                 a.GP_SIC__c = ta.GP_SIC__c;
                 //FY14 Req
                 a.coverage_model__c = ta.Coverage_Model__c;
                 a.Global_Parent_Segment__c = ta.Global_Parent_Segment__c;
                 a.Segment__c = ta.Segment__c;
                  //added by vasantha   -300-188671
               a.GU_DUNS_NUMBER__c = ta.Global_Ultimate__c;
               a.GU_NAME__c = ta.Global_Ultimate_Name__c;
               
                 String resellerType='';
             
             /*if(ta.Alliance__c || ta.Solution_Provider__c || ta.Service_Provider__c){
                a.Reseller_Type__c='Value';
             } else{
                a.Reseller_Type__c='RMDM';
             } */
             
             if(ta.Alliance__c || ta.Solution_Provider__c || ta.Service_Provider__c){             
                resellerType='Value';             
             }
             
             if (ta.Velocity_Seller__c){
                if(resellerType=='Value')
                   resellerType ='HYBRID';
                else
                   resellerType ='RMDM';   
             }
             a.Reseller_Type__c =  resellerType;                     
             a.Contract_Type__c=ta.Contract_Type__c;
             a.Contract_Start_Date_Reseller__c=ta.Contract_Start_Date__c;
             a.Contract_Expiration_Date__c=ta.Contract_Expiration_Date__c;
              //Added for Redq.1386 by Accenture,on 16th Dec.
             if(ta.CPMS_Id__c!=null && ta.CPMS_Id__c!='')
                a.CPMS_ID__c=ta.CPMS_Id__c;
             if(accownerid<>null)
                a.Ownerid=accownerid;
             else
                 {
                  
                   a.Ownerid = TaqOwner.id; 
                 }  
             if(ta.Country__c<>null) 
             {
              a.Country_Picklist__c=ta.Country_picklist__c;
              a.Region_Country__c=ta.Country__c;
             }
             a.DUNS_Number__c = ta.DUNS_Number__c;
             a.Business_Name__c = ta.Business_Name__c;
                          
             if(ta.Account_Name_Change__c=='' || ta.Account_Name_Change__c==null)
                ta.Account_Name_Change__c=ta.Name; 
              
              //US331581, Account should be eligible for partner locator search if program partners are either Premier or Advanced, member, global, focus, picklist values from the picklist, not hard coding anymore
              boolean allianceProgramLevelForPartnerFinder = false;
              boolean solutionProgramLevelForPartnerFinder = false;
              boolean serviceProgramLevelForPartnerFinder = false;


              for(String item:allianceProgramLevelList) {
                  if (ta.Alliance_Program_Level__c == null)
                      break;

                  if(ta.Alliance_Program_Level__c!=null && ta.Alliance_Program_Level__c.contains(item)) {
                      allianceProgramLevelForPartnerFinder = true;
                      break;
                  }
              }

              for(String item:solutionProgramLevelList) {
                 if (ta.Solution_Provider_Program_Level__c == null)
                      break;

                  if(ta.Solution_Provider_Program_Level__c!=null && ta.Solution_Provider_Program_Level__c.contains(item)) {
                      solutionProgramLevelForPartnerFinder = true;
                      break;
                  }
              }

              for(String item:serviceProgramLevelList) {
                 if (ta.Service_Provider_Program_Level__c == null)
                      break;

                  if(ta.Service_Provider_Program_Level__c!=null && ta.Service_Provider_Program_Level__c.contains(item)) {
                      serviceProgramLevelForPartnerFinder = true;
                      break;
                  }
              }

            if((ta.Alliance_Program_Level__c!=null && allianceProgramLevelForPartnerFinder) ||
                (ta.Solution_Provider_Program_Level__c!=null && solutionProgramLevelForPartnerFinder) ||
                (ta.Service_Provider_Program_Level__c!=null && serviceProgramLevelForPartnerFinder) ||
               (ta.Velocity_Seller_Program_Level__c!=null && (ta.Velocity_Seller_Program_Level__c.contains('Premier') || ta.Velocity_Seller_Program_Level__c.contains('Advanced') || ta.Velocity_Seller_Program_Level__c.contains('Member'))) 
             ){                                        
                a.Approved_for_Partner_Finder__c=true;
                a.Profile_Published_to_Partner_Finder__c ='Yes';  
                //Attach logo to the account if there is no logo attached to account. 
                if(ta.Pl_Logo_Exists__c=='False'){
                                   
                 
                 if(doc!=null && doc.Body!=null){
                    
                    Logo__c logoRecord = new Logo__c(Name='CALogo.jpg');
                    insert logoRecord;
                    
                    Attachment logoAttachment = new Attachment(
                      Body=doc.body,
                      ContentType='image/jpeg',
                      IsPrivate=false,
                      Name='CALogo.jpg',
                      ParentID=logoRecord.id
                    );
                    
                    insert logoAttachment; 
                    if(logoRecord!=null)                   
                       a.Logo__c =logoRecord.id;                                    
               }
              }
            
                              
             }
             else{
                 a.Approved_for_Partner_Finder__c=False;
                 a.Profile_Published_to_Partner_Finder__c ='No'; 
             }
             ta.View_Acc_Record__r = a;    
             m.put(ta.id,ta.View_Acc_Record__r);             
           }
           else{
               a.recordtypeid=mrectypeAcc.get('Account Team Covered Account');
               a.Enterprise_Account_Name__c=ta.Enterprise_Account_Name__c;
               a.Name = ta.Enterprise_Account_Name__c;
               a.GEO__c=ta.Region__c;
              if(ta.chkPendingReview__c == false)
                  a.Enterprise_ID__c=ta.Enterprise_ID__c;
               a.Sales_Area__c=ta.Area__c;
               a.Sales_Region__c=ta.Territory__c;
               a.Segment__c=ta.Account_Type1__c; //FY13 new field Segment
               a.Agile_Central_Sales_Territory__c=ta.Agile_Central_Sales_Territory__c;
               a.Account_Type1__c=ta.Account_Type1__c;
               a.Account_Type__c=ta.Account_Type__c;
               a.Global_Parent_Segment__c = ta.Global_Parent_Segment__c;
             /* Commented out to carry over the actual coverage model value from TAQ Act. - TADKR01.  
             if(mrectypeTAQ.get(ta.recordtypeid).contains('Regional')) 
                   a.Coverage_Model__c='Account Team';
              */     
               //a.Website=ta.URL__c; //AR3331
             /* Fy13 1.1- Std Account Owner assignment logic modified.
               string pmf = mTAQAccOwnerPMFkey.get(ta.id);
               string accownerid = mPMFkeyUserId.get(pmf);
               if(accownerid  == null) accownerid = userinfo.getuserid();
               if(accownerid<> null)
                   a.Ownerid=accownerid;
              */
              
              //FY14 Req
                 a.coverage_model__c = ta.Coverage_Model__c;
                 a.Global_Parent_Segment__c = ta.Global_Parent_Segment__c;
                 a.Segment__c = ta.Segment__c;
                 
             System.debug('___wee1___');
              if(ownerUser_taqAcctTeam.containsKey(ta.Id) && ownerUser_taqAcctTeam.get(ta.Id).User__c != null && ownerUser_taqAcctTeam.get(ta.Id).isActive__c == 'true' ){
                a.ownerId = ownerUser_taqAcctTeam.get(ta.Id).User__c;
              }
              else if(!ownerUser_taqAcctTeam.containsKey(ta.Id)){//FY14-Assigning Generic Owner to Account record when TAQ Account team is not available.
                 a.ownerId = mTAQAccOwnerPMFkey.get(ta.Id);
              }
              System.debug('___wee3___');
               a.Account_Type1__c=ta.Account_Type1__c;
               a.Account_Type__c=ta.Account_Type__c;
               a.Account_Status__c=ta.Approval_Status__c;
               if(ta.chkPendingReview__c == true) 
                      a.Account_Status__c = 'Pending Review' ;

               a.GP_SIC__c = ta.GP_SIC__c;
               a.GU_DUNS_NUMBER__c = ta.Global_Ultimate__c;
               a.GU_NAME__c = ta.Global_Ultimate_Name__c;
               a.DUNS_Number__c = ta.DUNS_Number__c;
               a.Business_Name__c = ta.Business_Name__c;
               if(ta.Country__c<>null) {
                  a.Country_Picklist__c=ta.Country_picklist__c;
                  a.Region_Country__c=ta.Country__c;
               }
               a.Billingcity=ta.Physical_City__c;
               a.billingstate=ta.Physical_State_Province__c;
               a.billingstreet=ta.Physical_Street__c;
               a.billingpostalcode=ta.Physical_Zip_Postal_Code__c;
               a.Physical_Country_Local__c=ta.Physical_Country_Local__c;
               a.Physical_State_Prov_Local__c=ta.Physical_State_Prov_Local__c;
               a.Physical_City_Local__c=ta.Physical_City_Local__c;
               a.Physical_Street_Local__c=ta.Physical_Street_Local__c;
               a.Physical_Zip_Local__c=ta.Physical_Zip_Local__c;
               a.Is_Primary_Account__c = ta.Is_Primary_Account__c;
               a.Segment__c = ta.Segment__c;    
              Id CISUser = UserInfo.getUserId();
              string CisInt = label.Cis_Integration_User;
        if(CISUser == CisInt)
        {
         system.debug('Coming Inn Trail');           
         a.Source__c= 'Trail';
        }                      
               ta.View_Acc_Record__r = a;    
               m.put(ta.id,ta.View_Acc_Record__r);
                                        
           }                                 
         } 
        }
           
           try{
               
               Database.SaveResult[] updateAccountResult = null;    //Manikandan
               Database.SaveResult[] insertAccountResult = null;    //Manikandan
               Map<Id,Account> accLU = new Map<Id,Account>();
               Map<String,Account> accLI = new Map<String,Account>();
               
               if(m.VAlues().size() > 0){
                //Map<Id,Account> accLU = new Map<Id,Account>();
                //Map<String,Account> accLI = new Map<String,Account>();
                
                // Mari, Nov, 2014 for requirement 1201
                      User genericOwner = new User(Id=Label.Generic_Owner);
      
                for(Account a:m.values()){
                    if(a.ownerid == null && (a.Coverage_Model__c == Label.CovModelVal2 || a.Coverage_Model__c == Label.CovModelVal3 || a.Coverage_Model__c == Label.CovModelVal4 || a.Coverage_Model__c == Label.CovModelVal5 || a.Coverage_Model__c == Label.CovModelVal6))
                    {
                   /*
                     User TaqOwner = [select id,username from User where Username like 'taqprovisioning@ca.com%' ];
                     a.ownerid = TaqOwner.id;
                       */
                    
                     a.ownerid = genericOwner.Id;
      
                    }
                  if(a.Id!=null)    
                    accLU.put(a.Id,a);
                  else
                    accLI.put(a.Name,a);
                }
                   //database.update(accLU.values());
                   //database.insert(accLI.values());
                   
                   //Start of Add : Manikandan Raju
                    updateAccountResult = Database.update(accLU.values());
                    insertAccountResult = Database.insert(accLI.values());
               }
               
               Map<Id,List<TAQ_Account__c>> accIdToTAQAccListMap = new Map<Id,List<TAQ_Account__c>>();      //Manikandan Raju
                   
              for(taq_account__c t:taqAccs){
                if(m.keyset().contains(t.id)){
                  t.view_acc_record__c = m.get(t.id).id;                 
                  if(mrectypeTaq.get(t.RecordTypeId).contains('Partner')){
                     partAcc.add(t);
                         
                         //Manikandan - Start Collect Partner accounts that are error free
                        if( (t.Error_Code_MDM__c == null || t.Error_Code_MDM__c == '') && (t.Error_Message_MDM__c == null || t.Error_Message_MDM__c == '') ){
                            if(accIdToTAQAccListMap.containsKey(t.view_acc_record__c)){
                                accIdToTAQAccListMap.get(t.view_acc_record__c).add(t);
                            } else {
                                accIdToTAQAccListMap.put(t.view_acc_record__c,new List<TAQ_Account__c>{t});
                            }
                        }
                  }
                }  
                  
              }
              System.debug('##### Taq trgr accIdToTAQAccListMap after ins/upd of account-'+accIdToTAQAccListMap);
              //Manikandan - Start
                if( !accIdToTAQAccListMap.isEmpty() )
                    WebServiceUtilityClass.accIdToTAQAccountListMap.putAll(accIdToTAQAccListMap);
            
            Map<Id,Account> accountIdToAccountMap = new Map<Id,Account>();
            Set <ID> accInsertIdSet = new Set <ID> ();        //IDs for generating insert XML
            Set <ID> accUpdateIdSet = new Set <ID> ();        //IDs for generating update XML
            
            if( !updateAccountResult.isEmpty() ){
                for(integer i=0; i<updateAccountResult.size(); i++){
                    if(updateAccountResult[i].isSuccess()){
                        Account acc = accLU.values()[i];
                        if(accIdToTAQAccListMap.containsKey(acc.Id)){
                            accountIdToAccountMap.put(acc.Id,acc);
                            accUpdateIdSet.add(acc.Id);
                        }
                    }
                }
            }

            if( !insertAccountResult.isEmpty() ){
                for(integer i=0; i<insertAccountResult.size(); i++){
                    if(insertAccountResult[i].isSuccess()){
                        Account acc = accLI.values()[i];
                        if(accIdToTAQAccListMap.containsKey(acc.Id)){
                            accountIdToAccountMap.put(acc.Id,acc);
                            accInsertIdSet.add(acc.Id);
                        }   
                    }
               }
            }

            system.debug('##### Accounts insert/updated --'+accountIdToAccountMap.Keyset());
            if( !accountIdToAccountMap.isEmpty() )
                WebServiceUtilityClass.accountMap = accountIdToAccountMap; 
                
            if( !accInsertIdSet.isEmpty() )
                WebServiceUtilityClass.accountInsertIdSet = accInsertIdSet;
                
            if( !accUpdateIdSet.isEmpty() )
                WebServiceUtilityClass.accountUpdateIdSet = accUpdateIdSet;                                
                //Manikandan - End
                    
           }
          catch(exception ex)
          {
             system.debug('Exception caught while inserting an acc' + ex.getmessage());
          }     
                     
         if(partAcc.size()>0)
            createOrUpdtAgrmnt(partAcc);
         
   } 

    //Called From : CA_TAQ_Account_approval trigger
    //Functionality: Creates TAQ Account Approved when a TAQ Account is Approved
    //Additional Comments: Only for FY13 Regional Accounts & PRM Accounts
    public void createTAQAccApprRec(List<TAQ_Account__c> taqAccs)
    {     
       System.debug('___PPPP____');
         List<TAQ_Account_Approved__c> listapp=new List<TAQ_Account_Approved__c>();
         TAQ_Account_Approved__c[] objarr=[select id,Is_Latest_Record__c,Is_Original__c from TAQ_Account_Approved__c where TAQ_Account__c in: taqAccs and Is_Latest_Record__c=true];
                    if(objarr.size()>0)
                    {
                        
                        for(Integer i=0;i<objarr.size();i++){
                            System.debug('___PPP____'+objarr[i].Id);
                              objarr[i].Is_Latest_Record__c=false;   
                              //objarr[i].Is_Original__c=false;                    
                        }
                        update objarr;
                    }
    //AR #3886
       Map<Id,Integer> TAQAccount_ApprovedMap = new Map<Id,Integer>();
       List<AggregateResult> taqAccAppr = [Select Count(Id) number, TAQ_Account__c key from TAQ_Account_Approved__c where TAQ_Account__c in :taqAccs group by TAQ_Account__c];
       for(AggregateResult temp: taqAccAppr){
            TAQAccount_ApprovedMap.put((Id)temp.get('key'),(Integer)temp.get('number'));
           System.debug('Key:'+temp.get('key')+'--'+temp.get('number'));
        }  
    // FOR CREATING TAQ_ACCOUNT_APPROVED RECS.
         for(TAQ_Account__c eachTAQAcc: taqAccs){
                TAQ_Account_Approved__c newacc=new TAQ_Account_Approved__c();
                newacc.Is_Latest_Record__c=true;
                newacc.Focus_Partner__c = eachTAQAcc.Focus_Partner__c; // ALLHA02 US US164377
                newacc.Referral_Partner__c = eachTAQAcc.Referral_Partner__c; // AMASA03 Rally Referral
               newacc.Regional_Global_Account__c =eachTAQAcc.Regional_Global_Account__c; // AMASA03 US331581
                newacc.Acquisition_Customer__c = convertMultiSelectField(eachTAQAcc.Acquisition_Customer__c);
                newacc.DistributorDesignation__c = eachTAQAcc.DistributorDesignation__c;
             // AR #3886 if condition added
             if(TAQAccount_ApprovedMap.get(eachTAQAcc.Id) == null)
                newacc.Is_Original__c=true;    
                
                newacc.name=eachTAQAcc.name;
                newacc.TAQ_Account__c = eachTAQAcc.id;
                newacc.Company_Email_Domain_s__c=eachTAQAcc.Company_Email_Domain_s__c;// YEDRA01 Adding email domains validation process AR:2404
                newacc.DUNS_Number__c = eachTAQAcc.DUNS_Number__c; //anssa01 9/20/2011
                newacc.Business_Name__c = eachTAQAcc.Business_Name__c; //anssa01 9/20/2011
                newacc.International_Split__c = eachTAQAcc.International_Split__c; //anssa01 9/20/2011

          system.debug('******************************->' + eachTAQAcc.id);
                
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
                 
                newacc.Split__c= eachTAQAcc.Split__c;
                newacc.Split_Type__c= eachTAQAcc.Split_Type__c;
                newacc.Split_Primary_Account__c=eachTAQAcc.Is_Primary_Account__c;
                //Split_Linked_Account
                newacc.Stock_Ticker__c= eachTAQAcc.Stock_Ticker__c;
                newacc.Comments__c= eachTAQAcc.Comments__c;
                newacc.URL__c= eachTAQAcc.URL__c;
                
              
                newacc.Size_of_Company_Annual_Revenue__c=eachTAQAcc.Size_of_Company_Annual_Revenue__c;
                newacc.Size_of_Company_Employees__c=eachTAQAcc.Size_of_Company_Employees__c;            
                newacc.Account_Name_Change__c=eachTAQAcc.Account_Name_Change__c;
                newacc.Agile_Central_Sales_Territory__c=eachTAQAcc.Agile_Central_Sales_Territory__c;
          
               
                newacc.Account_ID__c=eachTAQAcc.Account_ID__c;
                newacc.Reason_for_Release__c=eachTAQAcc.Reason_for_Release__c;
               //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 
                newacc.Account_ID_being_Merged__c=eachTAQAcc.Account_ID_being_Merged__c;
               //***Changes Made by Accenture -->>PRM-TAQ-R2,reqd-606 
                if(eachTAQAcc.Prevailiing_Account_ID__c!=null || eachTAQAcc.Prevailiing_Account_ID__c!= '')
                newacc.Prevailiing_Account_ID__c=eachTAQAcc.Prevailiing_Account_ID__c;
                else
                newacc.Prevailiing_Account_ID__c=eachTAQAcc.Prevailiing_Reseller_Account_ID__c;                
                newacc.Reason_for_Merger__c=eachTAQAcc.Reason_for_Merger__c;
                 
                //new assignments to accout approved object
                newacc.Account_Type1__c=eachTAQAcc.Account_Type1__c;
                newacc.Account_Type2__c=eachTAQAcc.Account_Type__c;
       
                newacc.Approval_Status_2__c=eachTAQAcc.Approval_Status__c;
                newacc.Decision_Reason__c=eachTAQAcc.Reason_for_Rejection__c;
                newacc.Partner_Account_Name_Change__c=eachTAQAcc.Account_Name_Change__c;
                newacc.Request_Type__c=eachTAQAcc.Process_Step__c;
                
              
                newacc.Approval_Process_Status__c=eachTAQAcc.Approval_Process_Status__c;
                newacc.AD_Renewal__c= eachTAQAcc.AD_Renewal__c;
                newacc.Global_Ultimate_Region__c=eachTAQAcc.Global_Ultimate_Region__c;
                newacc.MF_Account__c=eachTAQAcc.MF_Account__c;
                newacc.Global_Ultimate__c=eachTAQAcc.Global_Ultimate__c;
                newacc.Global_Ultimate_Name__c=eachTAQAcc.Global_Ultimate_Name__c;
                
                 newacc.Sell_To_Education__c=eachTAQAcc.Sell_To_Education__c;
                 newacc.Sell_To_Mainframe_Capacity__c=eachTAQAcc.Sell_To_Mainframe_Capacity__c;
                 newacc.Sell_To_Mainframe_Time__c=eachTAQAcc.Sell_To_Mainframe_Time__c;
                 newacc.Sell_To_Product__c=eachTAQAcc.Sell_To_Product__c;
                 newacc.Sell_To_Services__c=eachTAQAcc.Sell_To_Services__c;
                 newacc.Sell_Through_Education__c=eachTAQAcc.Sell_Through_Education__c;
                 newacc.Sell_Through_Mainframe_Capacity__c=eachTAQAcc.Sell_Through_Mainframe_Capacity__c;
                 newacc.Sell_Through_Mainframe_Time__c=eachTAQAcc.Sell_Through_Mainframe_Time__c;
                 newacc.Sell_Through_Product__c=eachTAQAcc.Sell_Through_Product__c;
                 newacc.Sell_Through_Services__c=eachTAQAcc.Sell_Through_Services__c;
                 newacc.Sell_with_Education__c=eachTAQAcc.Sell_with_Education__c;
                 newacc.Sell_with_Mainframe_Capacity__c=eachTAQAcc.Sell_with_Mainframe_Capacity__c;
                 newacc.Sell_with_Mainframe_Time__c=eachTAQAcc.Sell_with_Mainframe_Time__c;
                 newacc.Sell_with_Product__c=eachTAQAcc.Sell_with_Product__c;
                 newacc.Sell_with_Services__c=eachTAQAcc.Sell_with_Services__c;
                 //FY14 INCLUSIONS.
                 newacc.Coverage_Model__c=eachTAQAcc.Coverage_Model__c;              
                 newacc.Global_Parent_Segment__c = eachTAQAcc.Global_Parent_Segment__c;
                 newacc.Segment__c = eachTAQAcc.Segment__c;     
                 newacc.Country_picklist__c = eachTAQAcc.Country_Picklist__c;
                 
       

                 Id CISUser = UserInfo.getUserId();
                 string CisInt = label.Cis_Integration_User;
         if(CISUser == CisInt)
         {
           system.debug('Coming Inn Trail');           
           newacc.Source__c= 'Trail';
         }
         else
         {
           system.debug('Going Out Trail');
         }
                
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
              newacc.Account_Type2__c=eachTAQAcc.Account_Type__c;                        
              newacc.Reseller_Type__c=eachTAQAcc.Reseller_Type__c;
              
              //***Changes Made by Accenture -->>PRM-TAQ-R2 ,reqd-1386'
              newacc.CPMS_Id__c=eachTAQAcc.CPMS_Id__c;
              
              newacc.Eligible_for_MDF__c=eachTAQAcc.Eligible_for_MDF__c;
              newacc.Alliance__c=eachTAQAcc.Alliance__c;
              newacc.Primary_RTM_Alliance__c=eachTAQAcc.Primary_RTM_Alliance__c;
              newacc.Alliance_Type__c = eachTAQAcc.Alliance_Type__c;
              newacc.Alliance_Program_Level__c= eachTAQAcc.Alliance_Program_Level__c;
              newacc.Alliance_Designation__c=eachTAQAcc.Alliance_Designation__c;
              newacc.Alliance_CAM_PMFKey__c= eachTAQAcc.Alliance_CAM_PMFKey__c;
            
              newacc.Service_Provider__c = eachTAQAcc.Service_Provider__c;
              newacc.Primary_RTM_Service_Provider__c=eachTAQAcc.Primary_RTM_Service_Provider__c;
              newacc.Service_Provider_Type__c = eachTAQAcc.Service_Provider_Type__c;
              newacc.Service_Provider_Designation__c=eachTAQAcc.Service_Provider_Designation__c;
              newacc.Service_Provider_CAM_PMFKey__c = eachTAQAcc.Service_Provider_CAM_PMFKey__c;
              newacc.Service_Provider_Program_Level__c = eachTAQAcc.Service_Provider_Program_Level__c;
            
              newacc.Solution_Provider__c = eachTAQAcc.Solution_Provider__c;
              newacc.Primary_RTM_Solution_Provider__c=eachTAQAcc.Primary_RTM_Solution_Provider__c;
              newacc.Solution_Provider_Type__c = eachTAQAcc.Solution_Provider_Type__c;
              newacc.Solution_Provider_Program_Level__c = eachTAQAcc.Solution_Provider_Program_Level__c ;
              newacc.Solution_Provider_Designation__c = eachTAQAcc.Solution_Provider_Designation__c;
              newacc.Solution_Provider_CAM_PMFKey__c = eachTAQAcc.Solution_Provider_CAM_PMFKey__c ;
              newacc.PDS_Addendum__c=eachTAQAcc.PDS_Addendum__c;
              newacc.PDS_Addendum_Attached__c=eachTAQAcc.PDS_Addendum_Attached__c;
             
              newacc.Velocity_Seller__c = eachTAQAcc.Velocity_Seller__c;
              newacc.Primary_RTM_Data_Management__c=eachTAQAcc.Primary_RTM_Data_Management__c;
              newacc.Velocity_Seller_Type__c= eachTAQAcc.Velocity_Seller_Type__c;
              newacc.Velocity_Seller_Program_Level__c = eachTAQAcc.Velocity_Seller_Program_Level__c ;
              newacc.Velocity_Seller_CAM_PMFKey__c = eachTAQAcc.Velocity_Seller_CAM_PMFKey__c ;
              newacc.Velocity_Seller_Designation__c = eachTAQAcc.Velocity_Seller_Designation__c ;
                        
              newacc.Credit_Check_completion_date__c=eachTAQAcc.Credit_Check_completion_date__c;
              newacc.Security_Check_completion_date__c=eachTAQAcc.Security_Check_completion_date__c;               
              newacc.Termination_Date__c= eachTAQAcc.Termination_Date__c;
              newacc.Termination_reason__c= eachTAQAcc.Termination_reason__c;
              //FY14 INCLUSIONS.
              newacc.Coverage_Model__c=eachTAQAcc.Coverage_Model__c; 
              newacc.Global_Parent_Segment__c = eachTAQAcc.Global_Parent_Segment__c;
              newacc.Segment__c = eachTAQAcc.Segment__c;
              }
              // Assigned the requestor queue to be the owner of the apporved record
              System.debug('+++++++eachTAQAcc.ownerid;++++'+eachTAQAcc.ownerid);
              
              //newacc.ownerid =  QueueCust__c.getInstance('TAQ Add Account Approver').Queue_ID__c ; //eachTAQAcc.ownerid;
              
              newacc.ownerid = eachTAQAcc.ownerid;
              listapp.add(newacc);
            }
          system.debug('listapp -->' + listapp);
          if(!Test.isRunningTest()){
        insert listapp;
          }
        System.debug('_________a_________'+listapp.size());
        taIds = new Map<Id,Id>();
        for(TAQ_Account_Approved__c t: listapp)
        {
            taIds.put(t.TAQ_Account__c,t.Id);
        }
        
        lstTAQforATM = taqAccs;
        system.debug('lstTAQforATM'+lstTAQforATM);
        lstTAQforATMApproved = listapp;
        //AR 3841 Invoke CreateTAQAccountTeams() method to check/create TAQ_Account_Team_Approved__c records.
        CreateTAQAccountTeams();
    } 
    
 //This method is being called from - Apex Trigger CA_TAQ_EnablePartnerAccounts after insert and update  
    public static void CreateTAQAccountTeams()
    {
       //AR 3841 Check if there are any existing TAQ_Account_Team_Approved__c records. If yes, return. Else, create new records.
        List<TAQ_Account_Team_Approved__c> accTeamAppr = new List<TAQ_Account_Team_Approved__c>();
        if(Test.isRunningTest()){
        accTeamAppr = [Select Id,Effective_Date__c,Is_Account_Owner__c,Percentage__c,PMFKey__c,Primary_Secondary__c,Role__c,Partner_Role__c,TAQ_Account_Approved__c from TAQ_Account_Team_Approved__c where TAQ_Account_Approved__c in: lstTAQforATMApproved limit 10];
        }
        else
        {
        accTeamAppr = [Select Id,Effective_Date__c,Is_Account_Owner__c,Percentage__c,PMFKey__c,Primary_Secondary__c,Role__c,Partner_Role__c,TAQ_Account_Approved__c from TAQ_Account_Team_Approved__c where TAQ_Account_Approved__c in: lstTAQforATMApproved];    
        }
            if(accTeamAppr != null && accTeamAppr.size()!=0){
           return;
       }
        // CREATING TAQ ACCOUNT TEAM MEMBERS LIST TO TAQ ACCOUNT APPROVED RECORDS.   
       List<TAQ_Account_Team__c> actTeam = [SELECT Id,TAQ_Account__c, Partner_Role__c, Effective_Date__c,Is_Account_Owner__c,Percentage__c,PMFKey__c,Primary_Secondary__c,Role__c, TAQ_Role__c, User__c from TAQ_Account_Team__c where TAQ_Account__c in: lstTAQforATM];
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
       for(TAQ_Account_Approved__c ta: lstTAQforATMApproved)
       {
       //Added below cond to avoid null point exception.
        if(ta.TAQ_Account__c!=null && accVSaccTeam.get(ta.TAQ_Account__c)!=null)
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
              newTeamApprRec.Partner_Role__c = t.Partner_Role__c;   
              newTeamApprRec.TAQ_Account_Approved__c = ta.Id;
              acteamAppr.add(newTeamApprRec);  
          } 
         }
       }
       try{
           Database.SaveResult[] insertTAQAccountTeamResult = null;        //Manikandan
       if(acteamAppr.size()>0)
        //Start of Add/Change : Manikandan Raju
        //Database.Insert(acteamAppr);  
        insertTAQAccountTeamResult = Database.insert(acteamAppr);
            
             
            
            Set<Id> TAQAccountTeamApprovedIDSet = new Set<Id>();
            
            if( !insertTAQAccountTeamResult.isEmpty() ){
                for(integer i=0; i<insertTAQAccountTeamResult.size(); i++){
                    if(insertTAQAccountTeamResult[i].isSuccess()){
                        system.debug('##### Created ATM-' +acteamAppr[i].Id);
                        TAQAccountTeamApprovedIDSet.add(acteamAppr[i].Id); 
                    }
               }
            }
        
            if( !TAQAccountTeamApprovedIDSet.isEmpty() ) 
            WebServiceUtilityClass.TAQAccountTeamApprovedSet.addall(TAQAccountTeamApprovedIDSet);  

            //End of Add/Change : Manikandan Raju
       
       }catch(Exception e){
        System.debug('___Exception while inserting taq account'+e.getMessage());
       }
      
        
        TAQ_AddStdAcctTeamMem oTAQ_AddStdAcctTeamMem   = new TAQ_AddStdAcctTeamMem();
        oTAQ_AddStdAcctTeamMem.AddAccountTeam(lstTAQforATM,actTeam);
    }
    
        
   
  
  
   public void validatePMFKeys(List<TAQ_Account__c> lstTAQ){
      camPmfky=new Set<String>();
      usrMap = new Map<String,String>();
  
    TAQ_Account__c c = new TAQ_Account__c();
    
    for(TAQ_Account__c t:lstTAQ){
     
        //PRM Sprint 4 changes
        addCamPmfky(t.Alliance_CAM_PMFKey__c);
        addCamPmfky(t.Service_Provider_CAM_PMFKey__c);
        addCamPmfky(t.Solution_Provider_CAM_PMFKEY__c);
        addCamPmfky(t.Velocity_Seller_CAM_PMFKey__c);
     }
    
    String strCamPmfky = '';
    List<User> usrList = [select Id,PMFKey__c from User where PMFKey__c in:camPmfky];
    if(usrList != null && usrList .size() > 0){
      for(User u: usrList)
       usrMap.put(u.PMFKey__c.toUpperCase(),u.Id);
    }   

    
    for(TAQ_Account__c acc:lstTAQ){
    
        if(acc.Alliance_CAM_PMFKey__c!=null){
           strCamPmfky = getCamPmfKy(acc.Alliance_CAM_PMFKey__c);
           if(strCamPmfky=='')
              acc.Alliance_CAM_PMFKey__c.addError('No employee exists with the provided PMFKey - ' + acc.Alliance_CAM_PMFKey__c+'. Please enter a valid PMFKey.'); 
           else
             acc.Alliance_CAM_PMFKey__c = acc.Alliance_CAM_PMFKey__c.toUpperCase();
        }

       if(acc.Service_Provider_CAM_PMFKey__c!=null){
          strCamPmfky = getCamPmfKy(acc.Service_Provider_CAM_PMFKey__c);
          if(strCamPmfky=='')
             acc.Service_Provider_CAM_PMFKey__c.addError('No employee exists with the provided PMFKey - ' + acc.Service_Provider_CAM_PMFKey__c+'. Please enter a valid PMFKey.'); 
          else
            acc.Service_Provider_CAM_PMFKey__c = acc.Service_Provider_CAM_PMFKey__c.toUpperCase();
       }

      if(acc.Solution_Provider_CAM_PMFKEY__c!=null){
         strCamPmfky = getCamPmfKy(acc.Solution_Provider_CAM_PMFKEY__c);
         if(strCamPmfky=='')
            acc.Solution_Provider_CAM_PMFKEY__c.addError('No employee exists with the provided PMFKey - ' + acc.Solution_Provider_CAM_PMFKEY__c+'. Please enter a valid PMFKey.'); 
         else
           acc.Solution_Provider_CAM_PMFKEY__c = acc.Solution_Provider_CAM_PMFKEY__c.toUpperCase();
      }

     if(acc.Velocity_Seller_CAM_PMFKey__c!=null){
        strCamPmfky = getCamPmfKy(acc.Velocity_Seller_CAM_PMFKey__c);
        if(strCamPmfky=='')
           acc.Velocity_Seller_CAM_PMFKey__c.addError('No employee exists with the provided PMFKey - ' + acc.Velocity_Seller_CAM_PMFKey__c+'. Please enter a valid PMFKey.'); 
        else
          acc.Velocity_Seller_CAM_PMFKey__c = acc.Velocity_Seller_CAM_PMFKey__c.toUpperCase();
     }   
                 
    }
    
          
   
   
   } 
    
   private void addCamPmfky(string strKey){           
      if(strKey<>null && !camPmfky.contains(strKey))           
       camPmfky.add(strKey);        
    }

   private string getCamPmfKy(string strPmfKey){
     string pmfKy = usrMap.get(strPmfKey.toUpperCase());
     if(pmfKy != null)
       return pmfKy;
     else
      return '';
   }    
    
  
  //****PRM Sprint 3 code Start
  /****    
   ***   Method to perfrom Creation and Updates on Agreement Object .
   **
   */     
 
   public void createOrUpdtAgrmnt(List<TAQ_Account__c> lstTAQ)
   {
       map<String,Route_To_Market__c> m = new map<String,Route_To_Market__c>();
       map<id,List<Route_To_Market__c>> mAgreement = new Map<id,List<Route_To_Market__c>>();
       set<id> sAccids = new set<id>(); 
       List<Route_To_Market__c> lstRTMUpsert = new List<Route_To_Market__c>();
       List<Route_To_Market__c> lstRTMDelete = new List<Route_To_Market__c>();
       
     
       
       for(TAQ_Account__c taqAcc :lstTAQ)
             sAccids.add(taqAcc.View_Acc_Record__c);
             
        System.debug('----in side createOrUpdtAgrmntt----' + sAccids);
     
       for(Route_To_Market__c rtm : [SELECT id,Name,RTM__c, Account__c FROM Route_To_Market__c where Account__c IN : sAccids])
       {
           system.debug('inside rtm of createupdate');
           List<Route_To_Market__c> lst= mAgreement.get(rtm.Account__c);
            if(lst == null)
                lst = new List<Route_To_Market__c>();
          lst.add(rtm);
          mAgreement.put(rtm.account__c, lst);  

       }

        for(TAQ_Account__c taqAcc: lstTAQ)
         {
             List<Route_To_Market__c> agrmnt  = mAgreement.get(taqAcc.View_Acc_Record__c);
         
         if(agrmnt!=null && agrmnt.size()>0){
            for(Route_To_Market__c a :agrmnt )
            {
               m.put(a.RTM__c,a );
            }
         }    
               
         if(taqAcc.Alliance__c  == true)
         {
            if(m.containsKey('Alliance'))
            {
               Route_To_Market__c agrmntrec = m.get('Alliance');     
               agrmntrec.Name = taqAcc.Name+'-Alliance';
               agrmntrec.RTM__c = 'Alliance';
               agrmntrec.RTM_Type__c =taqAcc.Alliance_Type__c ; 
               agrmntrec.Program_Level__c =  taqAcc.Alliance_Program_Level__c ;
               agrmntrec.CAM_PMFKey__c = taqAcc.Alliance_CAM_PMFKey__c ;
               agrmntrec.Designation__c  =  taqAcc.Alliance_Designation__c ;
               lstRTMUpsert.add(agrmntrec);
            
            }else
            {
               Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-Alliance',RTM__c = 'Alliance',RTM_Type__c =taqAcc.Alliance_Type__c,Program_Level__c =  taqAcc.Alliance_Program_Level__c,CAM_PMFKey__c = taqAcc.Alliance_CAM_PMFKey__c,Designation__c  =  taqAcc.Alliance_Designation__c);
               lstRTMUpsert.add(agg);
               
             }
         }
         else
         {
              if(m.containsKey('Alliance'))
              {
                 Route_To_Market__c agrmntrec = m.get('Alliance');
                 lstRTMDelete.add(agrmntrec);
                 
              }
         }
         if(taqAcc.Service_Provider__c == true)
         {
           if(m.containsKey('Service Provider'))
           {
              Route_To_Market__c agrmntrec = m.get('Service Provider');
              agrmntrec.RTM__c = 'Service Provider' ;
              agrmntrec.Name = taqAcc.Name+'-Service Provider';
              agrmntrec.RTM_Type__c =taqAcc.Service_Provider_Type__c; 
              agrmntrec.Program_Level__c =  taqAcc.Service_Provider_Program_Level__c ;
              agrmntrec.CAM_PMFKey__c = taqAcc.Service_Provider_CAM_PMFKey__c;
              agrmntrec.Designation__c  =  taqAcc.Service_Provider_Designation__c ;
              lstRTMUpsert.add(agrmntrec);
              
           }else
           {
              Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-Service Provider',RTM__c = 'Service Provider',RTM_Type__c =taqAcc.Service_Provider_Type__c,Program_Level__c =  taqAcc.Service_Provider_Program_Level__c ,CAM_PMFKey__c = taqAcc.Service_Provider_CAM_PMFKey__c,Designation__c  =  taqAcc.Service_Provider_Designation__c);
              lstRTMUpsert.add(agg);
              
            }
         }
         else
         {
              if(m.containsKey('Service Provider')){
                 Route_To_Market__c agrmntrec = m.get('Service Provider');
                 lstRTMDelete.add(agrmntrec);
                 
              }
         }

         if(taqAcc.Solution_Provider__c == true){
            if(m.containsKey('Solution Provider'))
            {
               Route_To_Market__c agrmntrec = m.get('Solution Provider');
               agrmntrec.Name = taqAcc.Name+'-Solution Provider';
               agrmntrec.RTM__c = 'Solution Provider' ;               
               agrmntrec.RTM_Type__c =taqAcc.Solution_Provider_Type__c ; 
               agrmntrec.Program_Level__c =  taqAcc.Solution_Provider_Program_Level__c ;
               agrmntrec.CAM_PMFKey__c = taqAcc.Solution_Provider_CAM_PMFKey__c ;
               agrmntrec.Designation__c  =  taqAcc.Solution_Provider_Designation__c ;
               lstRTMUpsert.add(agrmntrec);
              
            }
            else
            {
              Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-Solution Provider',RTM__c = 'Solution Provider',RTM_Type__c =taqAcc.Solution_Provider_Type__c,Program_Level__c =  taqAcc.Solution_Provider_Program_Level__c,CAM_PMFKey__c = taqAcc.Solution_Provider_CAM_PMFKey__c,Designation__c  =  taqAcc.Solution_Provider_Designation__c);
              lstRTMUpsert.add(agg);
                       
             }              
         }else{
              if(m.containsKey('Solution Provider')){
                 Route_To_Market__c agrmntrec = m.get('Solution Provider');
                 lstRTMDelete.add(agrmntrec);
                 
              }
         }

        if(taqAcc.Velocity_Seller__c == true)
        {
          if(m.containsKey('Data Management')){
             Route_To_Market__c agrmntrec = m.get('Data Management');
             agrmntrec.Name = taqAcc.Name+'-DM';
             agrmntrec.RTM__c = 'Data Management';
             agrmntrec.RTM_Type__c =taqAcc.Velocity_Seller_Type__c ; 
             agrmntrec.Program_Level__c =  taqAcc.Velocity_Seller_Program_Level__c ;
             agrmntrec.CAM_PMFKey__c = taqAcc.Velocity_Seller_CAM_PMFKey__c ;
             agrmntrec.Designation__c  =  taqAcc.Velocity_Seller_Designation__c ;
             lstRTMUpsert.add(agrmntrec);
             
          }
          else
          {
               Route_To_Market__c agg = new Route_To_Market__c (Account__c = taqAcc.View_Acc_Record__c,Name = taqAcc.Name+'-DM',RTM__c = 'Data Management',RTM_Type__c =taqAcc.Velocity_Seller_Type__c,Program_Level__c =  taqAcc.Velocity_Seller_Program_Level__c,CAM_PMFKey__c = taqAcc.Velocity_Seller_CAM_PMFKey__c,Designation__c  =  taqAcc.Velocity_Seller_Designation__c);
               lstRTMUpsert.add(agg);
               
          }
        }
        else
        {
              if(m.containsKey('Data Management'))
              {
                 Route_To_Market__c agrmntrec = m.get('Data Management');
                 lstRTMDelete.add(agrmntrec);
                 
              }
        }      
           
      }
      if(lstRTMUpsert.size()>0)
         database.upsert(lstRTMUpsert, false);
        
      if(lstRTMDelete.size()>0)
         database.Delete(lstRTMDelete,false);
         
    }//PRM Sprint 3 code End
 
    
    public class TAQPartnerRoutes
    {
        public string velocity {get;set;}
        public string alliance {get;set;}
        public string serviceProvider {get;set;}
        public string solutionProvider {get;set;}
        public TAQPartnerRoutes()
        {
            velocity = '';
            alliance = '';
            serviceProvider = '';
            solutionProvider = '';
        }
        
        
    }
    
    Map<string,TAQ_Account_Team__c> mapTAQIdPMFkeys = new Map<string,TAQ_Account_Team__c>();
    Map<id,TAQ_Account_Team__c> mapTAQIdUpdateATM = new Map<id,TAQ_Account_Team__c>();
    Map<string,TAQ_Account_Team__c> mapTAQIdInsertATM = new Map<string,TAQ_Account_Team__c>();
    Map<id,TAQ_Account_Team__c> mapTAQIdDeleteATM = new Map<id,TAQ_Account_Team__c>();
   
   
    
    //To Get the Product Alignment Records associated with a Current Routes 
     public Map<string, Set<String>> getProductAlignment(Set<string> routes)
     {
        
        Map<string, Set<String>> mapPA = new Map<string, Set<String>>();
    
        if(routes <> null && routes.size() > 0)
        {
                string strroutes = '';
                for(string str:routes)
                    strroutes += (strroutes == ''?'\'' +str + '\'': ',\''+ str + '\'');
                string strquery = 'Select p.Product_Group__c, p.Partner_Approved__c, p.Market_Focus_Area__c From Product2 p WHERE Salesforce_CPQ_Product__c=false and Partner_Approved__c INCLUDES (' + strroutes + ')';

                system.debug('strquery =' +strquery );
                List<Product2> lstProd = DataBase.Query(strquery);
                
                for(Product2 p:lstProd)
                {
                        
                        for(String route: p.Partner_Approved__c.split(';'))
                        {
                            Set<String> setPA = mapPA.get(route);
                            if(setPA == null) { setPA = new Set<string>(); }
                            setPA.add((p.Product_Group__c <> null? p.Product_Group__c : '' ) +':' +  (p.Market_Focus_Area__c <> null? p.Market_Focus_Area__c : '' ));
                            mapPA.put(route,setPA);
                        }
                }                        
        
        }
        return mapPA;
     }
   
    public void createOrUpdtTAQAccTeam(List<TAQ_Account__c> newTAQLst, Map<id,TAQ_Account__c> oldTAQMap)
    {
     // newTAQLst, oldTAQMap,
    List<TAQ_Account_Team__c> taqTeam =  new List<TAQ_Account_Team__c>();   
    Map<String,Map<String,String>> taqRoles = new Map<String,Map<String,String>>(); 
    
    Map<string, string> mapPArtnerRoutes = new Map<string, string>();   
    set<string> oldCAMPMFkeys   = new set<string>();
  
    //INITIALISE for UPDATES    
     if(trigger.isUpdate)
     {
            mapTAQIdPMFkeys = new Map<string,TAQ_Account_Team__c>();
            mapTAQIdUpdateATM = new Map<id,TAQ_Account_Team__c>();
            mapTAQIdInsertATM = new Map<string,TAQ_Account_Team__c>();
            mapTAQIdDeleteATM = new Map<id,TAQ_Account_Team__c>();
            for(TAQ_Account_Team__c tatm:[Select id, Partner_Role__c, TAQ_Account__C, PMFKey__c from TAQ_Account_Team__c where TAQ_Account__C in :  newTAQLst])
            {
                mapTAQIdPMFkeys.put(tatm.TAQ_Account__c +'|'+(tatm.PMFKey__c != null?tatm.PMFKey__c.toUpperCase():'') , tatm);
            }
        
     }  
     
       for(TAQ_Account__c taqAcc :newTAQLst){
            
            Map<String,String> pmfKeys = new Map<String,String>();  
            string velSelCAMPMFKey   = taqAcc.velocity_Seller_CAM_PMFKey__c;
            string allianceCAMPMFKey = taqAcc.Alliance_CAM_PMFKey__c;
            string servProvCAMPMFKey = taqAcc.Service_Provider_CAM_PMFKey__c;
            string solProvCAMPMFKEY  = taqAcc.Solution_Provider_CAM_PMFKEY__c;
         
            string velSelRole        = 'PARTN DM';
            string allianceRole      = 'PARTN ALLIANCE';
            string servProvRole      = 'PARTN SERVPROV';
            string solProvRole       = 'PARTN SOLPROV';
            
        
        
        if(Trigger.isInsert){
            
            
        System.debug('CAMS((((()))))'+velSelCAMPMFKey+allianceCAMPMFKey+servProvCAMPMFKey+solProvCAMPMFKEY);    
          if(solProvCAMPMFKEY!=null)
            pmfKeys.put(solProvCAMPMFKEY,solProvRole);      
            
          if(servProvCAMPMFKey!=null){
            if(pmfKeys.containsKey(servProvCAMPMFKey))
               pmfKeys.put(servProvCAMPMFKey,pmfKeys.get(servProvCAMPMFKey)+';'+servProvRole);
            
            else
               pmfKeys.put(servProvCAMPMFKey,servProvRole);  
                        
          }  
          
          System.debug('pmfKeys**********' + pmfKeys);
          
          if(allianceCAMPMFKey !=null){
            if(pmfKeys.containsKey(allianceCAMPMFKey))
               pmfKeys.put(allianceCAMPMFKey,pmfKeys.get(allianceCAMPMFKey)+';'+allianceRole);
            else
               pmfKeys.put(allianceCAMPMFKey,allianceRole);   
            
          }
          
          if(velSelCAMPMFKey !=null){
            if(pmfKeys.containsKey(velSelCAMPMFKey))
               pmfKeys.put(velSelCAMPMFKey,pmfKeys.get(velSelCAMPMFKey)+';'+velSelRole);
            else
               pmfKeys.put(velSelCAMPMFKey,velSelRole);             
          }
          
          System.debug('pmfKeys**********' + pmfKeys);
          
          for(string pmfKey : pmfKeys.keySet()) {
            
            TAQ_Account_Team__c tnew = new TAQ_Account_Team__c(taq_account__c =taqAcc.id, pmfkey__c = pmfKey, partner_role__c =pmfKeys.get(pmfKey));
            mapTAQIdInsertATM.put(tnew.taq_account__c + '|' + tnew.pmfkey__c, tnew );
          }
          
          
          
        }
        else if(Trigger.isUpdate)
        {
            TAQ_Account__c oldAcc = oldTAQMap.get(taqacc.id);
            if(taqAcc.velocity_Seller_CAM_PMFKey__c <> oldAcc.velocity_Seller_CAM_PMFKey__c || taqAcc.Alliance_CAM_PMFKey__c <> oldAcc.Alliance_CAM_PMFKey__c ||
            taqAcc.Service_Provider_CAM_PMFKey__c <> oldAcc.Service_Provider_CAM_PMFKey__c|| taqAcc.Solution_Provider_CAM_PMFKEY__c <> oldAcc.Solution_Provider_CAM_PMFKEY__c)
            {
                if(taqAcc.Solution_Provider_CAM_PMFKEY__c <> oldAcc.Solution_Provider_CAM_PMFKEY__c)
                    syncmemembers(taqacc,oldAcc,oldAcc.Solution_Provider_CAM_PMFKEY__c, taqAcc.Solution_Provider_CAM_PMFKEY__c, solProvRole);
                
                if(taqAcc.Service_Provider_CAM_PMFKey__c <> oldAcc.Service_Provider_CAM_PMFKey__c)
                    syncmemembers(taqacc,oldAcc,oldAcc.Service_Provider_CAM_PMFKey__c, taqAcc.Service_Provider_CAM_PMFKey__c,servProvRole );
                
                if(taqAcc.Alliance_CAM_PMFKey__c <> oldAcc.Alliance_CAM_PMFKey__c)
                    syncmemembers(taqacc,oldAcc,oldAcc.Alliance_CAM_PMFKey__c, taqAcc.Alliance_CAM_PMFKey__c,allianceRole );
                
                if(taqAcc.velocity_Seller_CAM_PMFKey__c <> oldAcc.velocity_Seller_CAM_PMFKey__c)
                    syncmemembers(taqacc,oldAcc,oldAcc.velocity_Seller_CAM_PMFKey__c, taqAcc.velocity_Seller_CAM_PMFKey__c,velSelRole );
                
            }
        }
        
        /*if(pmfKeys.size()>0)
          taqRoles.put(taqAcc.Id,pmfKeys);*/
     }
     
      System.debug('mapTAQIdDeleteATM-------------' + mapTAQIdDeleteATM + '----mapTAQIdInsertATM' + mapTAQIdInsertATM);
      
      
 /*  if(taqRoles.size()>0){      
       for(string id : taqRoles.keySet()) {
          Map<String,String> roles = taqRoles.get(id); 
       
        for(string pmfKey : roles.keySet()) {
         TAQ_Account_Team__c team = new TAQ_Account_Team__c(PMFKey__c=pmfKey,Role__c=roles.get(pmfKey),TAQ_Account__c=id);          
         taqTeam.add(team);
        }
      }  
     }*/
      
      
    /*  if(taqTeam.size()>0)
         database.insert(taqTeam,true);  */
    
      if(mapTAQIdDeleteATM.keyset().size() > 0)
        database.delete(mapTAQIdDeleteATM.values(), false);         
      if(mapTAQIdInsertATM.keyset().size() > 0)
        database.insert(mapTAQIdInsertATM.values(), false);
     if(mapTAQIdUpdateATM.keyset().size() > 0)
        database.update(mapTAQIdUpdateATM.values(), false);
      
            
     
    }

  public String convertMultiSelectField(String multiSelect){
      String[] values;
      String formattedString;
  
      if(multiSelect != null){
        values = multiSelect.split(';');
      }

      if(values != null){
          formattedString = String.join(values, ', ');
      }
      return formattedString;
  }

     
   public void syncmemembers(TAQ_Account__c TaqAcc, TAQ_Account__c oldAcc, string pmfkeyOld, string pmfkeyNew, string vrole )
     {
            //For the Old TAQ ATM member
            if(pmfkeyOld <> null)
                {
                system.debug('>>>>>>>1' + pmfkeyOld);
                    
                TAQ_Account_Team__c told = mapTAQIdPMFkeys.get(oldAcc.id +'|'+pmfkeyOld);
                system.debug( vrole + 'told='+told);
                if(told != null)
                        {
                            
                            //Remove the role - start
                            if(told.partner_role__c <> null)
                                told.partner_role__c = told.partner_role__c.replaceAll(';'+vrole+';','').replaceAll(';'+vrole,'').replaceAll(vrole +';','').replaceAll(vrole,'');
                            //if role becomes empty - add for deletion
                            if(told.partner_role__c == null || told.partner_role__c == '')
                                mapTAQIdDeleteATM.put(told.id, told);
                            else //if role has a value - add for updation
                                mapTAQIdUpdateATM.put(told.id, told);
                            //Remove the role - end
                            system.debug(vrole +'mapTAQIdDeleteATM='+mapTAQIdDeleteATM);
                            system.debug(vrole +'mapTAQIdUpdateATM='+mapTAQIdUpdateATM);
                            
                        }       
                    }   
                    
                    
                    //Add Role - if there is one
                    if(pmfkeyNew <> null)
                    {
                        //Find if the TAQ ATM is there in the Account Team Map
                        TAQ_Account_Team__c tnew = mapTAQIdPMFkeys.get(taqAcc.id +'|'+pmfkeyNew);
                        
                        //IF found in , then find in the mapTAQIdUpsertATM
                        if(tnew <> null)
                        { 
                            if(mapTAQIdDeleteATM.keySet().contains(tnew.id)) //IF not found the find in mapTAQIdDeleteATM
                            {
                                tnew =  mapTAQIdDeleteATM.get(tnew.id);
                                mapTAQIdDeleteATM.remove(tnew.id); // IF found in mapTAQIdDeleteATM remove the occurence from there and add in mapTAQIdUpsertATM
                                
                            }
                            else if(mapTAQIdUpdateATM.keyset().contains(tnew.id))
                            {   
                                tnew =  mapTAQIdUpdateATM.get(tnew.id);
                            }
                            //IF found then update the role and add in mapTAQIdUpsertATM
                            
                            System.debug('*************Partn Role'+ tnew.partner_role__c);
                            tnew.partner_role__c  = ( tnew.partner_role__c <> null && tnew.partner_role__c.contains(vrole) ?   tnew.partner_role__c   :   (tnew.partner_role__c == null || tnew.partner_role__c == ''? '': tnew.partner_role__c +';') + vrole);
                            System.debug('*************tnew.partner_role__c Role'+ tnew.partner_role__c);
                            
                            //mapTAQIdUpdateATM.put(tnew.taq_account__c + '|' + tnew.pmfkey__c, tnew);
                            mapTAQIdUpdateATM.put(tnew.id, tnew);
                        }
                        else
                        {
                            //if not found - create new atm, and add in map TAQ ATM
                            tnew = new TAQ_Account_Team__c(taq_account__c =taqAcc.id, pmfkey__c = pmfkeyNew, partner_role__c =vrole);
                            if(mapTAQIdInsertATM.keyset().contains(tnew.taq_account__c + '|' + tnew.pmfkey__c))
                            {   
                                tnew =  mapTAQIdInsertATM.get(tnew.taq_account__c + '|' + tnew.pmfkey__c);
                                tnew.partner_role__c  = ( tnew.partner_role__c <> null && tnew.partner_role__c.contains(vrole) ?   tnew.partner_role__c   :   (tnew.partner_role__c == null || tnew.partner_role__c == ''? '': tnew.partner_role__c +';') + vrole);
                            }
                            mapTAQIdInsertATM.put(tnew.taq_account__c + '|' + tnew.pmfkey__c, tnew );
                        }
        }
      
      }
                    
}