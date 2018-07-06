public class SystemIdUtility {
    
    //lead record type ids
    private static final List<Id> INDIRECT_LEAD_RECORDTYPEIDS=new List<Id> {'01230000000Dhu2AAC'};
    private static final Id INDIRECT_LEAD_RECORDTYPEID = '01230000000Dhu2AAC';
    //added by heena for lead conversion mapping in PRM R2
    private static final Id Deal_Registration_RecordTYPEID ='01230000000yspf'; ///rao   = '012Q00000000IJc';
    
    public static Map<Id,Account> mapAccountsOld=new Map<Id,Account> ();//{'01230000000GfY6AAK','01230000000GfYyAAK','01230000000GfiBAAS'};
   
    //opportunity Record Type Ids
    private static final List<Id> INDIRECT_OPPORTUNITY_RECORDTYPEIDS=new List<Id> {'01230000000GfY6AAK','01230000000GfYyAAK','01230000000GfiBAAS'};
    private static final Id NCV_OPPORTUNITY_RecordTYPEID     = '01230000000DO13AAG';
    private static final Id NCV_MQL_OPPORTUNITY_RecordTYPEID = '01230000000DV3uAAG';    
    private static final Id IND_ISBU_OPPORUNITY_RecordTYPEID ='01230000000GfY6AAK';
    private static final Id IND_RMDM_OPPORUNITY_RecordTYPEID ='01230000000GfYyAAK';
    private static final Id IND_VALUE_OPPORUNITY_RecordTYPEID ='01230000000GfiBAAS';
    //added by heena for lead conversion mapping in PRM R2
    private static final Id Deal_Registration_Opportunity_RECORDTYPEID   = '012Q00000000IJd';
    private static final Id New_Opportunity_RECORDTYPEID   = '01230000000cohDAAQ';
    
    public static boolean isLeadUpdate1= false;
    public static boolean isLeadUpdate2= false;
    public static boolean isLeadUpdate3= false;
     
    public static boolean isFutureUpdate = false;
    public static boolean isTest= false;
    public static boolean skipTrigger = false;
    public static boolean isneeded = false;//---****---
    public static boolean skipTAQAccountTeam = false;//---****---
    public static boolean skipTAQAccount = false;//---****---
    public static boolean skipAccount = false;//---****---
    public static boolean skipTAQOrg = false;//---****---
    public static boolean skipTAQOrgApproved = false;//---****---
    public static boolean skipAccountOnMIPSUpdate = false;//---****---
    public static boolean runTestContractsInvalidation = false;//---****---
    public static boolean skipSterlingQuoteProcessor = false;//---Nimsoft Addition---
    public static boolean skipAQueryInRenewal_Notification = false;//---****---
    public static boolean skipLead_Not_Null = false;//---****---
    public static boolean skipUpdatePartnerLocations = false;//---Req13.3FY15---
    public static boolean skipUpdatePartnerLocations_testrun = false;

    
    public static boolean skipUpdateCoTermTrigger  = true;//-- Quote Approval rule matrix--
    
     public static boolean skipTAQTrigger = false ; //  CA_TAQ_Org_Approval
    
    public static boolean hasPopulatedPartnerRating =false;
    public static boolean isAccntUpdated= false;
    public static boolean hasPrtnChampNotifiedOnAddChanage =false;   
    
    private static final Id CPMS_INTEGRATION_USER_ID='005300000017VqMAAU';
    //Marjorie Martinez's ID always 
    private static final Id IND_LEAD_OWNER_QUEUE_ID = '005300000017Q6lAAE';   
    private static final String VOLUME_OPPMILESTONE = '10% - Discovery & Assessment';
    private static final String VALUE_OPPMILESTONE = Label.Opp_Stage_10_Percent;
   /// private static final String LEAD_CONVERT_STATUS = 'MQL';'Converted';// by rao
       private static final String LEAD_CONVERT_STATUS = 'Converted';
    public static final String Deal_Registration_STATUS = 'Sale Approved';
    
    //Profile Ids for SSP Custom Home Page       
    private static final set<String> dirProfileIds = new set<String>{'00e30000000nagjAAA','00e30000000nah3AAA','00e30000000oo0NAAQ'}; 
    private static final set<String> indirProfileIds = new set<String>{'00e30000000yZxRAAU','00e30000000yZxSAAU','00e30000000yZxOAAU'}; 
    
    //Account Record Types
    private static final Id ACCOUNT_RESELLERDIST_RECORDTYPEID = '01230000000GaFdAAK';    
    private static final Id ACCOUNT_ENTERPRISE_RECORDTYPEID   = '01230000000DNfMAAW';
    private static final Id ACCOUNT_SMB_RECORDTYPEID   = '01230000001L55j';//RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c;
    private static final Id ACCOUNT_TEAM_COVERED_RECORDTYPEID   = '01230000001L55e';//RecordTypes_Setting__c.getValues('Account Team Covered Account').RecordType_Id__c;
    private static final Id ACCOUNT_TERRITORY_RECORDTYPEID   = '01230000001L55o';//RecordTypes_Setting__c.getValues('Territory Covered Account').RecordType_Id__c;
    
    //private static final Id ACCOUNT_COMMERCIAL_RECORDTYPEID   = '01230000000GaFYAA0';
    private static final Id ACCOUNT_TECHPARTNER_RECORDTYPEID= '01230000000f5SlAAI';

    //QUEUE ID
    private static final Id ENTERPRISE_UNASSIGNED_QUEUEID  = '00G30000001jYOs';

    //Lead Record Types
    private static final Id LEAD_GLOBAL_RECORDTYPEID = '01230000000DUOh';    
    
    private static final string VALUE_DEAL_TYPE='1 Tier';
    private static final string VALUE_DEAL_TYPE_WITHDISTRIBUTOR='2 Tier';
    private static final string ISBU_DEAL_TYPE='ISBU';
    private static final string RMDM_DEAL_TYPE='Channel'; 
    
    //Changes by Heena Begin   
    //used for REverse feed interface in PRM R2
    private static final String SFDCDATA_USER_ID='00530000000wdzY';
     /*Standered Account Values, when created or updated through TAQ Account 
     Changes done by accenture.For PRM-TAQ-R2 
     Last Updated on Dec 9,2010.
     */ 
    private static final string ACCOUNT_TYPE='Reseller';
    private static final string RESELLER_TYPE='Value';
    private static final string PRIMARY_DESIGNATION_RESELLER='ESP/EITM';

    //Oppty LineItemsUpdate 
    public static boolean isAfter_UpdateLineitems_Fire= false;
    
    //FY13
    public static boolean skipOpportunityTriggers= shouldSkipTrigger('Opportunity');
    public static boolean skipOpportunityTriggersIntegration = shouldSkipTrigger('OpportunityIntegration');
    
    public static boolean skipOpportunityLineItemTriggers=  shouldSkipTrigger('OpportunityLineItem');
    public static boolean skipOpportunityLineItemTriggersIntegration= shouldSkipTrigger('OpportunityLineItemIntegration');
    
    public static boolean skipProductTriggers=  shouldSkipTrigger('Product');
    public static boolean skipTSORequestTriggers=  shouldSkipTrigger('TSO_Request');
    
    //FY13 Prod Support
    public static boolean skipTAQ_Organization=  shouldSkipTrigger('TAQ_Organization');
    public static boolean skipTAQ_OrganizationApproved=  shouldSkipTrigger('TAQ_Organization_Approved');
    
    public static boolean skipTAQ_OrgQuota=  shouldSkipTrigger('TAQ_Org_Quota');
    public static boolean skipTAQ_OrgQuotaApproved=  shouldSkipTrigger('TAQ_Org_Quota_Approved');
    
    public static boolean skipTAQ_Account=  shouldSkipTrigger('TAQ_Account');
    public static boolean skipTAQ_AccountApproved=  shouldSkipTrigger('TAQ_Account_Approved');
    
    public static boolean skipTAQ_AccountTeam=  shouldSkipTrigger('TAQ_Account_Team');
    public static boolean skipTAQ_AccountTeamApproved=  shouldSkipTrigger('TAQ_Account_Team_Approved');
    

   public static Boolean shouldSkipTrigger(String triggerName){
        Boolean skip =
            (Triggers_Inactive__c.getValues(triggerName) <> null && ( Triggers_Inactive__c.getValues(triggerName).Is_Inactive__c ||
            (Triggers_Inactive__c.getValues(triggerName).Inactive_for_User__c <> null &&  Userinfo.getUserId().contains(Triggers_Inactive__c.getValues(triggerName).Inactive_for_User__c))));
        return skip;
   } 

   public static string getAccountType()
    {
        return ACCOUNT_TYPE;
    }
    public static string getResellerType()
    {
        return RESELLER_TYPE;
    }
    public static string getPrimaryDesignationReseller()
    {
        return PRIMARY_DESIGNATION_RESELLER;
    }
    public static String getSFDCDATA_USER_ID() 
    {
        return SFDCDATA_USER_ID;
    }
   
    //Changed by Heena End
    
    public static Id getGlobalLeadRecordTypeId() 
    {
        return LEAD_GLOBAL_RECORDTYPEID;
    }
    
    public static Id getEnterpriseUnassignedQueueId() 
    {
        return ENTERPRISE_UNASSIGNED_QUEUEID;
    }
    
    public static Id getEnterpriseAccountRecordTypeId() 
    {
        return ACCOUNT_ENTERPRISE_RECORDTYPEID;
    }    
    public static string getValueDealType()
    {
        return VALUE_DEAL_TYPE;
    }
    public static string getValueDealTypeWithDistributor()
    {
        return VALUE_DEAL_TYPE_WITHDISTRIBUTOR;
    }
    public static string getIsbuDealType()
    {
        return ISBU_DEAL_TYPE;
    }
    public static string getRmdmDealType()
    {
        return RMDM_DEAL_TYPE;
    }    
    public static Boolean IsIndirectLeadRecordType(Id recTypeId)
    {
        boolean isIndirect=false;

        if(recTypeId==INDIRECT_LEAD_RECORDTYPEID){
            isIndirect=true;
        }
        return isIndirect; 
    }
    // added by heena on 11/3 for PRM 2 Deal Registration conversion
    //changes by Heena begins
    public static Boolean IsDeal_RegistrationRecordType(Id recTypeId)
    {
        boolean isDealReg=false;
        if(recTypeId==Deal_Registration_RecordTYPEID)
        { 
            isDealReg=true;
        }
        return isDealReg;
    }
    public static Boolean IsNew_OpportunityRecordType(Id recTypeId)
    {
        boolean isNewOpp=false;
        if(recTypeId==New_Opportunity_RECORDTYPEID)
        { 
            isNewOpp=true;
        }
        return isNewOpp;
    }
    // changes by Heena End
    public static Boolean IsIndirectOpportunityRecordType(Id recTypeId)
    {
        boolean isIndirect=false;
        for(Id indId:INDIRECT_OPPORTUNITY_RECORDTYPEIDS)
        {
            if(recTypeId==indId)
            { 
                isIndirect=true;
                break;
            }
        }
        return isIndirect;
    }
    public static Id getIndirectISBURecordTypeId()
    {
        return IND_ISBU_OPPORUNITY_RecordTYPEID;
    }
    public static Id getIndirectRMDMRecordTypeId()
    {
        return IND_RMDM_OPPORUNITY_RecordTYPEID;
    }
    public static Id getIndirectVALUERecordTypeId()
    {
        return IND_VALUE_OPPORUNITY_RecordTYPEID;
    }
    //heena changes begins for lead conversion
    public static Id getDealRegistrationOpportunityRecordTypeId()
    {
        return Deal_Registration_Opportunity_RECORDTYPEID;
    }
    //heena changes end for lead conversion
    public Id getCPMSIntegrationUserID()
    {
        return CPMS_INTEGRATION_USER_ID;
    }
    
    public static Id getLeadQueueOwnerId()
    {
        return IND_LEAD_OWNER_QUEUE_ID;
    }

    public static Id getSMBAcctRecordTypeId()
    { 
        return ACCOUNT_SMB_RECORDTYPEID;
    }
    
    public static Id getAccountTeamAcctRecordTypeId()
    { 
        return ACCOUNT_TEAM_COVERED_RECORDTYPEID;
    }
    
    public static Id getTerritoryAcctRecordTypeId()
    { 
        return ACCOUNT_TERRITORY_RECORDTYPEID;
    }
    
    public static String getVolOppMilestone()
    {
        return VOLUME_OPPMILESTONE;
    }
    
    public static String getValueOppMilestone()
    {
        return VALUE_OPPMILESTONE; 
    }
    
    public static String getLeadConvertStatus()
    {
        return LEAD_CONVERT_STATUS;
    }
    
    public static set<String> getDirectProfileIds()
    {
        return dirProfileIds;   
    }
    
    public static set<String> getInDirectProfileIds()
    {
        return indirProfileIds; 
    }           

    public static Id getInDirLeadRecordTypeId()
    {
        return INDIRECT_LEAD_RECORDTYPEIDS.get(0); 
    }
    
    public static String getResellerDistRecordTypeId()
    {
        return ACCOUNT_RESELLERDIST_RECORDTYPEID;   
    }          
    
    public static String getTechPartnerRecordTypeId()
    {
        return ACCOUNT_TECHPARTNER_RECORDTYPEID;   
    } 
    public static set<Id> getOppsRecTypeIds(String userType,String userRegion)
    {
        set<Id> homePageOppRecordTypeIds = new set<Id>();
        if(userType == 'direct')
        {
            homePageOppRecordTypeIds.add(NCV_OPPORTUNITY_RecordTYPEID);
            homePageOppRecordTypeIds.add(NCV_MQL_OPPORTUNITY_RecordTYPEID);              
            if(userRegion != 'EMEA')
            {
                homePageOppRecordTypeIds.add(IND_VALUE_OPPORUNITY_RecordTYPEID);
            }   
            return homePageOppRecordTypeIds;
        }
        else
        {
            homePageOppRecordTypeIds.add(IND_VALUE_OPPORUNITY_RecordTYPEID);
            return homePageOppRecordTypeIds;
        }   
    }
    public static set<Id>   getHomePageAccountRecordTypes(string userType)
    {
        set<Id> homePageAccountRecordTypeIds = new set<Id>();
        if(userType == 'direct')
        {
            homePageAccountRecordTypeIds.add(ACCOUNT_ENTERPRISE_RECORDTYPEID);
        }
        else
        {
            homePageAccountRecordTypeIds.add(ACCOUNT_RESELLERDIST_RECORDTYPEID);
        }
        return homePageAccountRecordTypeIds;
    }    
    // test method for this class
    static testMethod void testAllGetters() {
        Test.startTest();
        SystemIdUtility sysIdUtil = new SystemIdUtility(); 
        SystemIdUtility.IsIndirectLeadRecordType(INDIRECT_LEAD_RECORDTYPEIDS.get(0));
        SystemIdUtility.IsIndirectOpportunityRecordType(INDIRECT_LEAD_RECORDTYPEIDS.get(0));
        SystemIdUtility.getIndirectISBURecordTypeId();      
        SystemIdUtility.getIndirectRMDMRecordTypeId();
        SystemIdUtility.getIndirectVALUERecordTypeId();
        sysIdUtil.getCPMSIntegrationUserID();
        SystemIdUtility.getLeadQueueOwnerId();
        SystemIdUtility.getSMBAcctRecordTypeId();
        SystemIdUtility.getVolOppMilestone();
        SystemIdUtility.getValueOppMilestone();
        SystemIdUtility.getLeadConvertStatus();
        SystemIdUtility.getDirectProfileIds();
        SystemIdUtility.getInDirectProfileIds();
        SystemIdUtility.getInDirLeadRecordTypeId();
        SystemIdUtility.getResellerDistRecordTypeId();
        SystemIdUtility.getValueDealType(); 
        SystemIdUtility.getIsbuDealType();  
        SystemIdUtility.getRmdmDealType();
        SystemIdUtility.getOppsRecTypeIds('direct','NA');
        SystemIdUtility.getOppsRecTypeIds('indirect','NA');
        SystemIdUtility.getOppsRecTypeIds('direct','EMEA');
        SystemIdUtility.getHomePageAccountRecordTypes('direct');
        SystemIdUtility.getHomePageAccountRecordTypes('indirect');   
        SystemIdUtility.getEnterpriseAccountRecordTypeId();     
        Test.stopTest();
    } 
}