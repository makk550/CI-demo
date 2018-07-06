/**
* Class OpportunityHandler
* Trigger Handler for the Opportunity SObject. This class implements the ITrigger
* interface to help ensure the trigger code is bulkified and all in one place.
*/
public without sharing class OpportunityHandler
implements ITrigger
{   
    // Member variable to hold the Id's of Opportunitys 'in use'
    
    private static List<FeedItem> posts = new List<FeedItem>(); 
    // Member variables
    private List<OpportunityLineItem> s_oli = new List<OpportunityLineItem>();
    public static List<Trial_Request__c> lst_req = new List<Trial_Request__c>();
    //used to control the block of code for Closed-Lost Notification
    private static boolean competitorNotification = false;
    private static boolean NotificationCheck = false;
    public static Map<Id, List<GroupMember>> adminGroupMap = new Map<Id, List<GroupMember>>();
    public static boolean renewalToOppConversion = false; //chajo30 - US368497
    
      public static boolean RenewalsMassConversion = false;  //samap01 -US423678
    // Constructor
    public OpportunityHandler()
    {
        
    }
    
    /**
* bulkBefore
*
* This method is called prior to execution of a BEFORE trigger. Use this to cache
* any data required into maps prior execution of the trigger.
*/
    public static boolean isNewConvertedFromLead {get;set;} 
    //= (Trigger.isInsert &&  ((Opportunity) Trigger.new[0]).LeadSource  <> null);
    
    public void bulkBefore()
    {
        if(isNewConvertedFromLead == null)
            isNewConvertedFromLead= (Trigger.isInsert &&  ((Opportunity) Trigger.new[0]).LeadSource  <> null);
        
        if( !isNewConvertedFromLead)
            OpportunityGateway.loadOpportunityBulkValues();
    }
    
    
    public void bulkAfter()
    {
        if(isNewConvertedFromLead == null)
            isNewConvertedFromLead= (Trigger.isInsert &&  ((Opportunity) Trigger.new[0]).LeadSource  <> null);
        
        if(isNewConvertedFromLead)
            OpportunityGateway.loadOpportunityBulkValues();
        
        OpportunityGateway.loadSbQuoteOpportunityBulkAfterUpdate();
    }
    
    public void beforeInsert(SObject so)
    {
        Opportunity opp = (Opportunity)so;
        if(opp.IsClosed) //bibu_DefaultCloseDate
            opp.CloseDate = Date.today();
        if(opp.CPM_Owner__c == null && opp.Business_Type__c!=null) //OppUpdateAggregateInfo        
            opp.CPM_Owner__c = opp.OwnerId;
        
        opp.Amount = 1; 
        
        RecordTypes_Setting__c priceBookRec = RecordTypes_Setting__c.getValues('Standard Price Book');  //to get details from custom setting for Standard Price Book
        string priceBookRecValue;  //stores the standard pricebook ID.
        if(priceBookRec!=null)
            priceBookRecValue = priceBookRec.RecordType_Id__c;
        
        RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
        string steelBrickRecType;
        if(sbRecType!=null)
            steelBrickRecType = sbRecType.RecordType_Id__c;
        
        RecordTypes_Setting__c entlSync = RecordTypes_Setting__c.getValues('Entitlement_Sync');
        string entlSyncRecType;
        if(entlSync!=null)
            entlSyncRecType = entlSync.RecordType_Id__c;
        
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
        opp.Salesforce_CPQ_Eligibility_Route__c = false;
        
        if(String.isNotBlank(steelBrickRecType) && opp.RecordTypeId==steelBrickRecType){
            opp.Pricebook2Id = priceBookRecValue;
            //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
            opp.Salesforce_CPQ_Eligibility_Route__c = true;
        }
            
        
        if(String.isNotBlank(entlSyncRecType) && opp.RecordTypeId==entlSyncRecType){
            opp.Pricebook2Id = priceBookRecValue;
            //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
            opp.Salesforce_CPQ_Eligibility_Route__c = true;
        }
        
        
        //Update Dated Conversion Rates on Opp 
        for(DatedConversionRate cr: OpportunityGateway.conversionRates)
        {
            if(opp.CloseDate >= cr.StartDate && opp.CloseDate<cr.NextStartDate && opp.CurrencyIsoCode==cr.IsoCode)
            {
                opp.USD_Exchange_Rate__c=cr.ConversionRate;
                break;
            }
        }
        
        // moving WF to trigger - Pipeline Conversion Date Populator - BAJPI01
        set<String> Pipeline_Conversion_STAGE = new set<String>{Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,
                                                                Label.Opp_Stage_80_Percent};
            
            if(Pipeline_Conversion_STAGE.contains(opp.StageName))
              opp.Pipeline_Conversion_Date__c = system.today();
        // moving WF to trigger - Pipeline Conversion Date Populator - BAJPI01
         
        // moving WF to trigger - UpdateHealthScoreHealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        // moving WF to trigger - Update opportunity Create Alert field - BAJPI01
        if(opp.StageName==Label.Opp_Stage_Closed_Won){
            opp.Health_Score_Rating_Text__c = 'Healthy';
            opp.Health_Score_Total__c = 100;
            opp.Opportunity_New_Logo_CA__c = 'N/A';
            opp.Opportunity_New_Logo_GBU__c = null;
            opp.Create_Alert__c = true;
        }
        // moving WF to trigger - UpdateHealthScoreHealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        // moving WF to trigger - Update opportunity Create Alert field - BAJPI01
        
        // moving WF to trigger - UpdateHealthScoreUnhealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        if(opp.StageName==Label.Opp_Stage_Closed_Lost){
            opp.Health_Score_Rating_Text__c = 'Unhealthy';
            opp.Health_Score_Total__c = 0;
            opp.Opportunity_New_Logo_CA__c = 'N/A';
            opp.Opportunity_New_Logo_GBU__c = null;
        }
        // moving WF to trigger - UpdateHealthScoreUnhealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        
        // moving WF to trigger - RMP uncheck Sales Milestone - BAJPI01
        if((opp.StageName==Label.Opp_Stage_Closed_Lost || opp.StageName==Label.Opp_Stage_Closed_Won) && opp.RoadmapToPlan__c==true)
            opp.RoadmapToPlan__c = false;
        // moving WF to trigger - RMP uncheck Sales Milestone - BAJPI01
       
        
    }
    
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Opportunity opp = (Opportunity)so;
        Opportunity oldOpp = (Opportunity)Trigger.oldMap.get(opp.id);
        List<GroupMember> userInOppAdminGroup = new List<GroupMember>();
        
        RecordTypes_Setting__c priceBookRec = RecordTypes_Setting__c.getValues('Standard Price Book');  //to get details from custom setting for Standard Price Book
        string priceBookRecValue;  //stores the standard pricebook ID.
        if(priceBookRec!=null)
            priceBookRecValue = priceBookRec.RecordType_Id__c;
        
        RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
        string steelBrickRecType;
        if(sbRecType!=null)
            steelBrickRecType = sbRecType.RecordType_Id__c;
        
        RecordTypes_Setting__c entlSync = RecordTypes_Setting__c.getValues('Entitlement_Sync');
        string entlSyncRecType;
        if(entlSync!=null)
            entlSyncRecType = entlSync.RecordType_Id__c;
        
        //BAJPI01 - as part of US461190
        RecordTypes_Setting__c dealReg = RecordTypes_Setting__c.getValues('Deal Registration');
        string dealRegRecType;
        if(dealReg!=null)
            dealRegRecType = dealReg.RecordType_Id__c;
        system.debug('----prob----'+opp.Probability);
        if(opp.Probability>=60 && String.isNotBlank(dealRegRecType) && opp.RecordTypeId!=dealRegRecType &&
           opp.Source__c!='Partner' && opp.Source__c!='Deal Registration' && !(opp.Source__c=='Lead' && opp.Partner_Engagement__c=='Incremental')){
               system.debug('----prob----'+opp.Probability);
               system.debug('----MEDDPICC VALIDATION DATE----' + Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.left(4)));
               system.debug('----MEDDPICC VALIDATION DATE----' + Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.mid(4,2)));
               system.debug('----MEDDPICC VALIDATION DATE----' + Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.right(2)));
               system.debug('----MEDDPICC VALIDATION DATE----' + date.newInstance(Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.left(4)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.mid(4,2)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.right(2))));
               if(OpportunityGateway.oppAndContactRoles!=null && OpportunityGateway.oppAndContactRoles.size()>0){
                   if(OpportunityGateway.oppAndContactRoles.containsKey(opp.id)){
                       Set<OpportunityContactRole> tempContactRoleList = new Set<OpportunityContactRole>();
                       Boolean economicBuyer = false;
                       Boolean champion = false;
                       tempContactRoleList = OpportunityGateway.oppAndContactRoles.get(opp.id);
                       if(tempContactRoleList.size()>0){
                           for(OpportunityContactRole ocr:tempContactRoleList){
                               if(ocr.Role=='Economic Buyer')
                                   economicBuyer = true;
                               else if(ocr.Role=='Champion')
                                   champion = true;
                           }
                       }
                       //if(economicBuyer==false||champion==false){
                       if((economicBuyer==false||champion==false) && opp.CloseDate > date.newInstance(Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.left(4)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.mid(4,2)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.right(2)))){
                           opp.addError(Label.Economic_And_Champion_Error_Message);
                       }
                   }
               }
               else{
                   //opp.addError('Economic Buyer and Champion Contact Roles are required to move beyond Sales Stage: 4 - Prove');
                   if(opp.CloseDate > date.newInstance(Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.left(4)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.mid(4,2)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.right(2)))){
                       opp.addError(Label.Economic_And_Champion_Error_Message);
                   }
               }
           }
        //BAJPI01 - as part of US461190
        
        if((String.isNotBlank(steelBrickRecType) && opp.RecordTypeId==steelBrickRecType) ||
           (String.isNotBlank(entlSyncRecType) && opp.RecordTypeId==entlSyncRecType) ){
               //sunji03 -- move Tenser WFR on opportunity to trigger
               //Equivalent to the WF entry criteria of any time it's edited to subsequently meet criteria
               if (oldOpp.StageName != Label.Opp_Stage_Closed_Won && opp.StageName == Label.Opp_Stage_Closed_Won && opp.SBQQ__PrimaryQuote__c!=null) 
               {
                   opp.SBQQ__Contracted__c = true;
                   //US487512 & US489475 - PORAS01 - Consesssion Offered Due to Primary Deal & Contract Linkage field can't be blank.
                   if(opp.RecordTypeId == steelBrickRecType){
                       
                       List<String> concessionAndContractFlagVal = OpportunityGateway.concessionAndContractFlagVal.get(opp.Id);                       
                       String isConcessnOffrd;
                       //String isDealLnkd;
                       
                       if(concessionAndContractFlagVal.size() >= 1){
                           isConcessnOffrd = concessionAndContractFlagVal[0];
                           //isDealLnkd = concessionAndContractFlagVal[1];
                       }
                       
                       String error = '';
                       //PORAS01 - Added to run validation only for Concession Flag
                       if(String.isBlank(isConcessnOffrd)){
                           opp.StageName.adderror(System.Label.Is_Concession_Offered_Due_to_Prior_Deal);                           
                       }
                       
                       //Suppressing the contract linkage flag as per business requirement to hold it for now. *DO NOT REMOVE* - PORAS01
                       /*if(String.isBlank(isConcessnOffrd) && String.isBlank(isDealLnkd)){
                           opp.StageName.adderror('Discount Concession Flag and Contract Linkage Flag must be set on Primary Quote to set Sales Milestone to Closed – Won');
                       }
                       else{
                           if(String.isBlank(isConcessnOffrd)){
                               opp.StageName.adderror(System.Label.Is_Concession_Offered_Due_to_Prior_Deal);                           
                           }
                           if(String.isBlank(isDealLnkd)){
                               opp.StageName.adderror(System.Label.Blank_not_allowed_for_Contract_Linkage_Flag);                           
                           }
                       } */
                   }
                   
                   //US487512 & US489475 - PORAS01 - end
               }
               if(opp.Pricebook2Id != priceBookRecValue)
                   opp.Pricebook2Id = priceBookRecValue;
           }
        
        //BAJPI01 - US428062 - flip record type on opportunity to entitlement sync from SB Record Type
        if(opp.Convert_To_Ent_Sync__c==true && oldOpp.Convert_To_Ent_Sync__c==false && String.isNotBlank(entlSyncRecType)){
            if(opp.SBQQ__Renewal__c==true||opp.SBQQ__RenewedContract__c!=null||opp.SBQQ__AmendedContract__c!=null){
                opp.RecordTypeId = entlSyncRecType;
                //if(String.isNotBlank(Label.OPP_OWNER_Data_Migration))
                //  opp.OwnerId = Label.OPP_OWNER_Data_Migration;
                if(String.isNotBlank(Label.OPP_Migrated_Name))
                  opp.Name = Label.OPP_Migrated_Name;
                opp.StageName = Label.Opp_Stage_Closed_Lost;
                opp.ReasonField__c = 'Duplicate';
            }              
            else{
                opp.addError('You can only convert a Renewal or Amendment Opportunity to Entitlement Sync Record Type');
            }
        }
        //BAJPI01 - US428062 - flip record type on opportunity to entitlement sync from SB Record Type
        
        String recordTypeByName; 
        if(oldOpp.RecordTypeId != null){
            recordTypeByName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(oldOpp.recordtypeid).getname();
        }
        
        if(adminGroupMap.containsKey(UserInfo.getUserId())){
            userInOppAdminGroup =  adminGroupMap.get(UserInfo.getUserId());
        }else{
            userInOppAdminGroup = [SELECT Id FROM GroupMember WHERE groupid = :label.Opportunity_Admin_Edit_For_Closed_Opps_Id 
                                   AND UserOrGroupId = :UserInfo.getUserId()];
            adminGroupMap.put(UserInfo.getUserId(), userInOppAdminGroup);
        }
        
        if(oldOpp.CloseDate != opp.CloseDate && (userInOppAdminGroup.size() == 0) && (Opp.StageName == Label.Opp_Stage_Closed_Won || Opp.StageName == Label.Opp_Stage_Closed_Lost) &&
           (opp.CloseDate.daysbetween(System.Date.today()) >= 14) && (recordTypeByName == 'New Opportunity' || recordTypeByName == 'Acquisition')
           && (String.isBlank(oldOpp.Opportunity_Type__c) || !oldOpp.Opportunity_Type__c.contains('Renewal')))
        {
            opp.adderror('Cannot close Opportunity more than 14 days in the past or future');   
        }else if(oldOpp.CloseDate != opp.CloseDate && (userInOppAdminGroup.size() != 0) && (Opp.StageName == Label.Opp_Stage_Closed_Lost) &&
                 (opp.CloseDate.daysbetween(System.Date.today()) >= 14) && (recordTypeByName == 'New Opportunity' || recordTypeByName == 'Acquisition')
                 && (String.isBlank(oldOpp.Opportunity_Type__c) || !oldOpp.Opportunity_Type__c.contains('Renewal'))) 
        {
            opp.adderror('Cannot close Opportunity more than 14 days in the past or future');
        }
        
        if((opp.IsClosed && !oldOpp.IsClosed )&& opp.CloseDate==oldOpp.CloseDate) //bibu_DefaultCloseDate  //Removed Within 14 days condition for AR3883  
            opp.CloseDate = Date.today();
        System.debug('Date.today().daysBetween(opp.CloseDate)'+Date.today().daysBetween(opp.CloseDate)+Date.today()+opp.CloseDate);
        
        
        
        //Update Conversion Rates
        if(opp.CloseDate<>oldOpp.CloseDate || opp.CurrencyIsoCode<>oldOpp.CurrencyIsoCode)
        {
            for(DatedConversionRate cr: OpportunityGateway.conversionRates)
            {
                if(opp.CloseDate >= cr.StartDate && opp.CloseDate<cr.NextStartDate && opp.CurrencyIsoCode==cr.IsoCode)
                {
                    opp.USD_Exchange_Rate__c=cr.ConversionRate;
                    break;
                }
            }
        }
    
        // moving WF to trigger - Pipeline Conversion Date Populator - BAJPI01
    set<String> Pipeline_Conversion_STAGE = new set<String>{Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,
                                                            Label.Opp_Stage_80_Percent};
    
    if(opp.Pipeline_Conversion_Date__c ==null && opp.StageName!=oldOpp.StageName && Pipeline_Conversion_STAGE.contains(opp.StageName))
      opp.Pipeline_Conversion_Date__c = system.today();
        // moving WF to trigger - Pipeline Conversion Date Populator - BAJPI01
        
        // moving WF to trigger - UpdateHealthScoreHealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        // moving WF to trigger - Update opportunity Create Alert field - BAJPI01
        if(opp.StageName==Label.Opp_Stage_Closed_Won && opp.StageName!=oldOpp.StageName){
            opp.Health_Score_Rating_Text__c = 'Healthy';
            opp.Health_Score_Total__c = 100;
            opp.Opportunity_New_Logo_CA__c = 'N/A';
            opp.Opportunity_New_Logo_GBU__c = null;
            opp.Create_Alert__c = true;
        }
        // moving WF to trigger - UpdateHealthScoreHealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        // moving WF to trigger - Update opportunity Create Alert field - BAJPI01
        
        // moving WF to trigger - UpdateHealthScoreUnhealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        if(opp.StageName==Label.Opp_Stage_Closed_Lost && opp.StageName!=oldOpp.StageName){
            opp.Health_Score_Rating_Text__c = 'Unhealthy';
            opp.Health_Score_Total__c = 0;
            opp.Opportunity_New_Logo_CA__c = 'N/A';
            opp.Opportunity_New_Logo_GBU__c = null;
        }
        // moving WF to trigger - UpdateHealthScoreUnhealthy - BAJPI01
        // moving WF to trigger - New Logo Oppy within GBU - BAJPI01
        
        // moving WF to trigger - UpdateHealthScorePending - BAJPI01
        set<String> HealthScore_Pending_STAGE = new set<String>{Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,
                                                                Label.Opp_Stage_80_Percent};
        set<String> Closed_STAGE = new set<String>{Label.Opp_Stage_Closed_Won,Label.Opp_Stage_Closed_Lost};
            if(HealthScore_Pending_STAGE.contains(opp.StageName) && opp.StageName!=oldOpp.StageName && Closed_STAGE.contains(oldOpp.StageName)){
                opp.Health_Score_Rating_Text__c = 'Pending';
                opp.Health_Score_Total__c = -1;
            }
        // moving WF to trigger - UpdateHealthScorePending - BAJPI01
        
        
        // moving WF to trigger - RMP Uncheck Inside_Outside_Flag - BAJPI01
        if(opp.Inside_Outside__c!=oldOpp.Inside_Outside__c && opp.RoadmapToPlan__c==true)
            opp.RoadmapToPlan__c = false;
        // moving WF to trigger - RMP Uncheck Inside_Outside_Flag - BAJPI01
        
        // moving WF to trigger - Deal Review Modified Date - BAJPI01
        if(opp.Deal_Review__c!=oldOpp.Deal_Review__c)
            opp.Deal_Review_Approved_Date__c = system.today();
        // moving WF to trigger - Deal Review Modified Date - BAJPI01
        
        // moving WF to trigger - Opportunity Stage Change - BAJPI01
        if(opp.StageName!=oldOpp.StageName)
            opp.Stage_Change_Date__c = system.today();
        // moving WF to trigger - Opportunity Stage Change - BAJPI01
         
        // moving WF to trigger - RMP uncheck Sales Milestone - BAJPI01
        if((opp.StageName==Label.Opp_Stage_Closed_Lost || opp.StageName==Label.Opp_Stage_Closed_Won) && opp.RoadmapToPlan__c==true)
            opp.RoadmapToPlan__c = false;
        // moving WF to trigger - RMP uncheck Sales Milestone - BAJPI01
        
        Boolean WaterMarkDup=false;
        if(opp.StageName==Label.Opp_Stage_20_Percent){
            
            WaterMarkDup=WatermarkDupCheck(opp);
            if(WaterMarkDup){
                opp.Watermark_Duplicate__c=WaterMarkDup;
            }
        }
    }
    
    /**
* beforeDelete
* This method is called iteratively for each record to be deleted during a BEFORE
* trigger.
*/
    public void beforeDelete(SObject so)
    {   
        //Cast the SObject to an Opportunity
        Opportunity opp = (Opportunity)so;
        
    }
    
    public void afterInsert(SObject so)
    {
        Opportunity opp = (Opportunity)so;
        
        afterInsertandUpdate(null, opp);
        
    }
    
    private static  Set<id> setAddedIds = new Set<id>();
    
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        Opportunity opp = (Opportunity)so;
        Opportunity oldOpp = (Opportunity)Trigger.oldMap.get(opp.id);
        
        
        //chatter post made through code, because formula fields cannot be tracked through chatter feed tracking 
        if(opp.RPD_Status_Formula__c != oldOpp.RPD_Status_Formula__c){
            posts = OpportunityGateway.addFeedToList(posts, opp.id, ' changed the RPD Status from ' +oldOpp.RPD_Status_Formula__c+ ' to ' +opp.RPD_Status_Formula__c+' .');
        }
        
        System.debug('Near Competitor Notification');
        if((opp.competitor__c != oldOpp.competitor__c) && competitorNotification == false)
        {
            //competit0orNotification(opp);
            CompetitorNotificationLogic.competitorNotification(opp);//US235713
            competitorNotification = true;
        }
        

        System.debug('Near Driving SCBU field');
        if((opp.Driving_Sales_Coverage_Business_Unit__c!=null && oldOpp.Driving_Sales_Coverage_Business_Unit__c == null) && NotificationCheck ==false )
        {
            //competitorNotification(opp);
            CompetitorNotificationLogic.competitorNotification(opp);//US235713
            NotificationCheck = true;
        }
        
        afterInsertandUpdate(oldOpp, opp);
        
    }
    
    public void afterInsertandUpdate(Opportunity oldOpp, Opportunity opp)
    {
        
        
        //sales team from TAQ - start
        System.debug('In Opportunity Handler - Add_Enterprise_Members__c is:'+opp.Add_Enterprise_Members__c);
        
        
        if(opp.Service_Provider_Client__c != null && opp.Add_Enterprise_Members__c == true)
        { 
      OpportunityGateway.addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Service_Provider_Client__c,'');
        }
        
        
        //bajpi01 as part of US304954
        if(opp.OwnerId!=null && ((oldOpp == null || oldOpp.OwnerId == null)))
        {
            Boolean ownerexistsinTAQ = false;
            List<OpportunityTeamMember> otmlist = OpportunityGateway.lstOTM;
            if(otmlist.size()>0){
                for(OpportunityTeamMember otm: otmlist){
                    if(otm.userId==opp.OwnerId){
                        ownerexistsinTAQ = true;
                        break;
                    }
                }
            }
            if(!ownerexistsinTAQ)
                OpportunityGateway.addOppTeamMember(opp.Ownerid, opp.Id, 'Owner');
            
        }
        //bajpi01 as part of US304954 ends here.
        //sales team from TAQ - end
        
    }
    
    public void afterDelete(SObject so)
    {
        
    }
    
    /**
* andFinally
* This method is called once all records have been processed by the trigger. Use this 
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally()
    {
        
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.IsUpdate))
        {
            
            if(posts.size() > 0)
            {    
                database.insert(posts, false);
                posts = new List<FeedItem>();
                
            }
            if(Trigger.IsUpdate)
            {
                if(OpportunityGateway.lst_dealDesk.size() > 0) //OppUpdateDealDeskTrigger
                {    Database.update(OpportunityGateway.lst_dealDesk,false);
                 OpportunityGateway.lst_dealDesk = new List<Deal_Desk_Review__c>();
                }
                if(OpportunityGateway.lst_QuoteRequest.size() > 0) //OppUpdateDealDeskTrigger
                {    Database.update(OpportunityGateway.lst_QuoteRequest,false);
                 OpportunityGateway.lst_QuoteRequest = new List<Quote_Request__c>();
                }
                
                //PATSA27 - for Send To SAP
                if(OpportunityGateway.steelbricklist!=null && OpportunityGateway.steelbricklist.size()>0)
                    update OpportunityGateway.steelbricklist;
                //PATSA27 - for Send To SAP
                
                if(OpportunityGateway.listROIFinal!=null && OpportunityGateway.listROIFinal.size()>0)
                    update OpportunityGateway.listROIFinal;
                
                
            }
            
            if(OpportunityGateway.lstOTM.size() > 0) //Common for All Opp Team additions
            {
                //Ar 3785
                opportunityteamMember otmOwner = new opportunityteamMember();
                for(opportunityteamMember oppTeamMem : OpportunityGateway.lstOTM){
                    if(oppTeamMem.TeamMemberRole =='Owner'){
                        otmOwner.TeamMemberRole = 'Owner';
                        otmOwner.OpportunityId  = oppTeamMem.OpportunityId;
                        otmOwner.UserId = oppTeamMem.UserId;
                    }
                } //Ar 3785 
                List<Database.upsertResult> uResults = Database.upsert(OpportunityGateway.lstOTM,false);                 
                if(otmOwner.UserId != null)upsert otmOwner; //Ar 3785
                for(Database.upsertResult result:uResults) {
                    
                    System.debug('is scucess:' + result.isSuccess()+ 'Is insert:'+ result.isCreated());
                    if(result.isSuccess()){
                        
                        System.debug('ID:*******'+result.getId());
                    }
                }
                OpportunityGateway.lstOTM = new List<OpportunityTeamMember>();
                
                
                
            }
            
            if(OpportunityGateway.lstOS.size() > 0) //Common for All Opp Team additions
            {       
                
                System.debug('opp lstos:'+OpportunityGateway.lstOS);
                //system.assertEquals(true,false, OpportunityGateway.lstOS);
                List<Database.upsertResult> uResults = Database.upsert(OpportunityGateway.lstOS,false);
                
                
                for(Database.upsertResult result:uResults) {
                    
                    System.debug('is scucess lstOS:' + result.isSuccess()+ 'Is insert:'+ result.isCreated() + 'Is Error :' +result.getErrors());
                    if(result.isSuccess()){                       
                        System.debug('ID:***lstOS****'+result.getId());
                    }                     
                }
                
                OpportunityGateway.lstOS = new List<OpportunityShare>();
            }            
            
            
        }
        
    }
   //merha02 -- watermark solution draft
    public boolean WatermarkDupCheck(Opportunity opp){
       
        List<id> OppIds=new List<id>();
        if(OpportunityGateway.OppRelatedOppsMap!=null && OpportunityGateway.OppRelatedOppsMap.size()>0){
            OppIds = OpportunityGateway.OppRelatedOppsMap.get(opp.id);
        }
        Set<String> AllBuList=new Set<String>();
        List<String> InitialOppBu=new List<String>();
        if(OpportunityGateway.oppBU!=null && OpportunityGateway.oppBU.size()>0){
            InitialOppBu=OpportunityGateway.oppBU.get(opp.id);
        }
        
        if(OppIds!=null && OppIds.size()>0){
            for(Id opportunityId : OppIds){
                List<String> tempBU=OpportunityGateway.oppBU.get(opportunityId);
                if(tempBU!=null && tempBU.size()>0)
                    AllBuList.addAll(tempBU);
            }
            if(InitialOppBu!=null && InitialOppBu.size()>0 && AllBuList!=null && AllBuList.size()>0){
                for(String BU : InitialOppBu){
                    if(AllBuList.contains(BU)){
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    
}