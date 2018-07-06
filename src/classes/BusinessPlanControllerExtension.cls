public class BusinessPlanControllerExtension {
    
    public BusinessPlanControllerExtension() {
        inch=false;
    }
    
    public String pageName{get; set;}//ponse01
    public Boolean showApprH{get;set;}//ponse01
    public Boolean inch{get;set;}
    private final Business_Plan_New__c BussPlan;       
    public boolean WarningMessage {get;set;}
    public boolean displayPopUp{set;get;}
    public String intendedTab { get; set; }
    private Apexpages.StandardController controller;
    public boolean showServProvQuestions {get;set;}
    public boolean SPQuestions {get;set;}
    public String SolutionRTM {get; set;}
    public String SolutionBU {get; set;}
    public String SolutionPG {get; set;}
    public String BookingRTM {get; set;}
    public String BookingBU {get; set;}
    public String BookingPG {get; set;}
    public String TrainingRTM {get; set;}
    public String TrainingBU {get; set;} //SAMAP01 -US293050 & US293051
    public String TrainingPG {get; set;}
    public String TrainingRT {get; set;}
    public Integer TrainingCount {get; set;}
      public string Alliancelevel {get; set;}//ponse01      
    public string Servicelevel {get; set;}//ponse01     
    public string Solutionlevel {get; set;}//ponse01        
    public boolean Alliance {get; set;}//ponse01        
    public string AllianceDesignation {get; set;}//ponse01      
    public string AllianceType {get; set;}//ponse01     
    public boolean ServiceProvider {get; set;}//ponse01     
    public string ServiceProviderDesignation {get; set;}//ponse01       
    public string ServiceProviderType {get; set;}//ponse01      
    public boolean SolutionProvider {get; set;}//ponse01        
    public string SolutionProviderDesignation {get; set;}//ponse01      
    public string SolutionProviderType {get; set;}//ponse01     
    public boolean PrimaryRTMAlliance {get; set;}//ponse01      
    public boolean PrimaryRTMServideProvider {get; set;}//ponse01       
    public boolean PrimaryRTMSolutionProvider {get; set;}//ponse01
    public String myAccountId;
    public String JSOName {get; set;}
    public List<ProductGroup> AddedPGs {get; set;}
    public String myAccountAddress  {get; set;}
    public String myAccountResellerID  {get; set;}
    public String myAccountCountry {get; set;}
    public String myAccountDUNSNumber {get; set;}
    public String myAccountGEO {get; set;}
    public String myAccountDUNSName {get; set;}
    public String myAccountPhone {get; set;}
    public String myAccountWebSite {get; set;}
    public Integer solutionCounter;
    public Integer delSolutionCounter {get; set;}
    public Integer delTrainingKey {get; set;}
    public String delTrainingPG {get; set;}
    public String delTrainingBU {get; set;}    //SAMAP01 US293050 & 51
    public String selectedRevType {get; set;}
    public Decimal revQ1 {get; set;}
    public Decimal revQ2 {get; set;}
    public Decimal revQ3 {get; set;}
    public Decimal revQ4 {get; set;}
    public ProductGroup currentBookingRow {get; set;}
    public boolean allianceBookingExists {get; set;}
    public boolean SolProBookingExists {get; set;}
    public boolean SerProBookingExists {get; set;}
    public boolean DMBookingExists {get; set;}
    public boolean showApprovalHistory {get;set;}
    public boolean profileTabEnabled {get; set;}
    public boolean territoryTabEnabled {get; set;}
    public boolean GTMTabEnabled {get; set;}
    public boolean solutionsTabEnabled {get; set;}
    public boolean trainingTabEnabled {get; set;}
    public boolean revenueTabEnabled {get; set;}
    public boolean checkoutTabEnabled {get; set;}
    public boolean historyTabEnabled {get; set;}
    public boolean engagementModelTabEnabled {get; set;}
    public boolean incentiveFieldRequired {get; set;} //FY18 Amasa03
    public boolean ShowIncentivesection {get; set;} //FY18 Amasa03
    
    public boolean logoError{get;set;}
    public ID logoRecordID {get;private set;}
    public ID logoAttachmentID {get;private set;}
    public String creatorCurrency {get; set;}
    public String creatorLanguage {get; set;}
    public String tmpProd {get; set;}
    public String tmpType {get; set;}
    
    public Map<String, List<BP_Training_Course__c>> TempTrainingMap {get;set;}
    
    public Decimal SerProTotalLatest,DMTotalLatest,allianceTotalLatest ,SolProTotalLatest ;
    public Decimal SerProTotalInitial,DMTotalInitial,allianceTotalInitial,SolProTotalInitial;
    public Integer SolnCountPrev = 0;
    public Decimal allianceBookingQ1Total {get; set;}
    public Decimal SolProBookingQ1Total {get; set;}
    public Decimal SerProBookingQ1Total {get; set;}
    public Decimal DMBookingQ1Total {get; set;}
    
    public Decimal allianceBookingQ2Total {get; set;}
    public Decimal SolProBookingQ2Total {get; set;}
    public Decimal SerProBookingQ2Total {get; set;}
    public Decimal DMBookingQ2Total {get; set;}
    
    public Decimal allianceBookingQ3Total {get; set;}
    public Decimal SolProBookingQ3Total {get; set;}
    public Decimal SerProBookingQ3Total {get; set;}
    public Decimal DMBookingQ3Total {get; set;}
    
    public Decimal allianceBookingQ4Total {get; set;}
    public Decimal SolProBookingQ4Total {get; set;}
    public Decimal SerProBookingQ4Total {get; set;}
    public Decimal DMBookingQ4Total {get; set;}
    
    public Decimal BookingQ1Total {get;set;}
    public Decimal BookingQ2Total {get;set;}
    public Decimal BookingQ3Total {get;set;}
    public Decimal BookingQ4Total {get;set;}
    public Decimal BookingGrandTotal {get;set;}
    
    public Decimal allianceTotal {get; set;}
    public Decimal SolProTotal {get; set;}
    public Decimal SerProTotal {get; set;}
    public Decimal DMTotal {get; set;}
    
    public Decimal SolProPNCVQ1Total {get; set;}
    public Decimal SolProPNCVQ2Total {get; set;}
    public Decimal SolProPNCVQ3Total {get; set;}
    public Decimal SolProPNCVQ4Total {get; set;}
    
    public Decimal SolProSNCVQ1Total {get; set;}
    public Decimal SolProSNCVQ2Total {get; set;}
    public Decimal SolProSNCVQ3Total {get; set;}
    public Decimal SolProSNCVQ4Total {get; set;}
    
    public Decimal SolProENCVQ1Total {get; set;}
    public Decimal SolProENCVQ2Total {get; set;}
    public Decimal SolProENCVQ3Total {get; set;}
    public Decimal SolProENCVQ4Total {get; set;}
    
    public Decimal AlliancePNCVQ1Total {get; set;}
    public Decimal AlliancePNCVQ2Total {get; set;}
    public Decimal AlliancePNCVQ3Total {get; set;}
    public Decimal AlliancePNCVQ4Total {get; set;}
    
    public Decimal AllianceSNCVQ1Total {get; set;}
    public Decimal AllianceSNCVQ2Total {get; set;}
    public Decimal AllianceSNCVQ3Total {get; set;}
    public Decimal AllianceSNCVQ4Total {get; set;}
    
    public Decimal AllianceENCVQ1Total {get; set;}
    public Decimal AllianceENCVQ2Total {get; set;}
    public Decimal AllianceENCVQ3Total {get; set;}
    public Decimal AllianceENCVQ4Total {get; set;}
    
    public Decimal SerProPNCVQ1Total {get; set;}
    public Decimal SerProPNCVQ2Total {get; set;}
    public Decimal SerProPNCVQ3Total {get; set;}
    public Decimal SerProPNCVQ4Total {get; set;}
    
    public Decimal SerProSNCVQ1Total {get; set;}
    public Decimal SerProSNCVQ2Total {get; set;}
    public Decimal SerProSNCVQ3Total {get; set;}
    public Decimal SerProSNCVQ4Total {get; set;}
    
    public Decimal SerProENCVQ1Total {get; set;}
    public Decimal SerProENCVQ2Total {get; set;}
    public Decimal SerProENCVQ3Total {get; set;}
    public Decimal SerProENCVQ4Total {get; set;}
    
    public Decimal DMPNCVQ1Total {get; set;}
    public Decimal DMPNCVQ2Total {get; set;}
    public Decimal DMPNCVQ3Total {get; set;}
    public Decimal DMPNCVQ4Total {get; set;}
    
    public Decimal DMSNCVQ1Total {get; set;}
    public Decimal DMSNCVQ2Total {get; set;}
    public Decimal DMSNCVQ3Total {get; set;}
    public Decimal DMSNCVQ4Total {get; set;}
    
    public Decimal DMENCVQ1Total {get; set;}
    public Decimal DMENCVQ2Total {get; set;}
    public Decimal DMENCVQ3Total {get; set;}
    public Decimal DMENCVQ4Total {get; set;}
    
    public Decimal SolProPNCVTotal {get; set;}
    public Decimal SolProSNCVTotal {get; set;}
    public Decimal SolProENCVTotal {get; set;}
    
    public Decimal AlliancePNCVTotal {get; set;}
    public Decimal AllianceSNCVTotal {get; set;}
    public Decimal AllianceENCVTotal {get; set;}
    
    public Decimal SerProPNCVTotal {get; set;}
    public Decimal SerProSNCVTotal {get; set;}
    public Decimal SerProENCVTotal {get; set;}
    
    public Decimal DMPNCVTotal {get; set;}
    public Decimal DMSNCVTotal {get; set;}
    public Decimal DMENCVTotal {get; set;}
    
    public Decimal PNCVQ1Total {get; set;}
    public Decimal PNCVQ2Total {get; set;}
    public Decimal PNCVQ3Total {get; set;}
    public Decimal PNCVQ4Total {get; set;}
    public Decimal SNCVQ1Total {get; set;}
    public Decimal SNCVQ2Total {get; set;}
    public Decimal SNCVQ3Total {get; set;}
    public Decimal SNCVQ4Total {get; set;}
    public Decimal ENCVQ1Total {get; set;}
    public Decimal ENCVQ2Total {get; set;}
    public Decimal ENCVQ3Total {get; set;}
    public Decimal ENCVQ4Total {get; set;}
    
    public Decimal pncvGrantTotal {get; set;}
    public Decimal sncvGrantTotal {get; set;}
    public Decimal encvGrantTotal {get; set;}
    
    public String bpAccountId {get; set;}
    public String testText {get; set;}
    public boolean isAddDisabled {get; set;}
    /*
public String partnerBusPlanOwnerName{get;set {if(partnerBusPlanOwnerName == '') this.BussPlan.Partner_Business_Plan_Owner__c = null;}}
public String partnerExecSponsorName {get;set{if(partnerExecSponsorName == '') this.BussPlan.Partner_Executive_Sponsor__c = null;}}
public String otherPartnerContact {get;set{if(otherPartnerContact == '') this.BussPlan.Other_Partner_Contact__c = null;}}
public String approver001 {get;set{if(approver001 == '') this.BussPlan.Approvers_01__c = null;}}
public String approver002 {get;set{if(approver002 == '') this.BussPlan.Approvers_02__c = null;}}
public String busPlanAccountId {get;set;}
//*/
    public Boolean isPowerPartner { get; set; } //AR 2431
    public String partnerBusPlanOwnerName{get;set ;}
    public String partnerExecSponsorName {get;set;}
    public String otherPartnerContact {get;set;}
    public String approver001 {get;set;}
    public String approver002 {get;set;}
    public String partnerBusPlanOwnerName_1{get;set ;}
    public String partnerExecSponsorName_1 {get;set;}
    public String otherPartnerContact_1 {get;set;}
    public String approver001_1 {get;set;}
    public String approver002_1 {get;set;}
    public String Partner_Enablement_Coordinator {get;set;} //SAMAP01 US238114 
    public String Partner_Enablement_Coordinator_1 {get;set;} //SAMAP01 US238114 
    public String busPlanAccountId {get;set;}
    public Account myAccount {get;set;}
    public Integer curFYear{get;set;} //MANAR08 AR:2953
    public Integer curBPFYear{get;set;} //MANAR08 AR:2953
    public boolean isCloneEnabled {get;set;} //MANAR08 AR:2953
    public boolean isEditDisabled {get;set;} //MANAR08 AR:2953
    private Business_Plan_New__c currentBP {get;set;} //MANAR08 AR:2953
    private boolean isClonedBP {get;set;} // MANAR08 AR:2953
    public Business_Plan_New__c clonedBP {get;set;} //MANAR08 AR:2953
    
    public String usrTypeSelected {get;set;} //SINJY02 AR : 2431
    public Boolean showCAapprvr {get;set;} //SINJY02 AR : 3030
    
    public boolean isRegionalAccount {get;set;} //AMASA03
    
    //MANAR08
    Map<String,Id> newlyAddedPg = new map<String,Id>();
    Map<String,Id> deletedPg = new Map<String,Id>();
    
    public Set<String> delPGSoln = new Set<String>();
    public Set<String> addedPGSoln = new Set<String>();
    
    public Map<String,List<BP_Training_Contact__c>> delTrainingContactMap;
    public Map<String,List<BP_Training_Contact__c>> addedTrainingContactMap;
    List<BP_Training_Contact__c> addedTrainingContact;
    List<BP_Training_Contact__c> delTrainingContact;
    
    //ALLHA02 4020      
    public String Copyright{get;set;}
    
    public string EditMode{get;set;}
    public string PMEnrolledInPartnerProgramPercentDisplay{get;set;}
    public string IntroductToProgramToolsPercentDisplay{get;set;}
    public string BusinessPlanCompletedPercentDisplay{get;set;}
    public string JointAccMappingInitiatedPercentDisplay{get;set;}
    public string DigitalPOCAlignedPercentDisplay {get;set;}
    public string MarketingPlanCompletedPercentDisplay{get;set;}
    public string DevelopEnablementPlanPercentDisplay{get;set;}    
    public string MinEducationReqMetPercentDisplay{get;set;}
    public string PromotePartnerSuccessesPercentDisplay{get;set;}  
    public string PartnershipAssessmentConductedPercentDisplay{get;set;}
    //samap01 - US293050 & US293051
    public Boolean IsGeoAccount {get;set;} 
    //public string GeoAccountCountry{get;set;} 
    public String geosalesvp {get;set;}
    public String geoprogramlead {get;set;}
    public String geofinance {get;set;}
    public String geoenablement {get;set;}
    public String geomarketing {get;set;}
    public String geosalesvp_1 {get;set;}
    public String geoprogramlead_1 {get;set;}
    public String geofinance_1 {get;set;}
    public String geoenablement_1 {get;set;}
    public String geomarketing_1 {get;set;}
    public String Is_Incubate_Product{get; set;}
    public String GeoAccountCountry {get;set;} //SAMAP01 US293050 & US293051   
    //samap01 - US293050 & US293051
    public Boolean isApprovedBP {get;set;}
    public Integer IntegerPlanyear{get;set;}
    
    public BusinessPlanControllerExtension(ApexPages.StandardController stdController) 
    {
        isAddDisabled = true; 
        isCloneEnabled = false; //MANAR08 AR:2953
        isEditDisabled = false; //MANAR08 AR:2953
        isClonedBP = false; //MANAR08 AR:2953
        getCurrentFYear(); //MANAR08 AR:2953  
        isPowerPartner=false;  
        Copyright=Label.BP_Copyright.replace('2015',string.valueof(System.Today().year()));
        inch=false;
        displayPopUp = false;
        WarningMessage = false;
        isGeoAccount =false ; //SAMAP01 US293050
        Is_Incubate_Product ='No'; //SAMAP01 US293050
        
        
        
        if(ApexPages.currentPage().getParameters().get('tabVal') != null)
        {
            currentTab=ApexPages.currentPage().getParameters().get('tabVal');
            if(ShowIncentivesection ==true){
            profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
            territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
            //GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
            solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 3);
            trainingTabEnabled = ((Integer.valueOf(currentTab)) < 4);
            revenueTabEnabled = ((Integer.valueOf(currentTab)) < 5);
            checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 6); 
            historyTabEnabled = ((Integer.valueOf(currentTab)) < 7);    
            engagementModelTabEnabled =  ((Integer.valueOf(currentTab)) < 8);  
            }
            else{
                  profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
            territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
            GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
            solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
            trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
            revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
            checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7); 
            historyTabEnabled = ((Integer.valueOf(currentTab)) < 8);    
            engagementModelTabEnabled =  ((Integer.valueOf(currentTab)) < 9);  
                
            }
        }
        
        solutionCounter = 0;
        revQ1 = 0;
        revQ2 = 0;
        revQ3 = 0;
        revQ4 = 0;
        
        PNCVQ1Total = 0;
        PNCVQ2Total = 0;
        PNCVQ3Total = 0;
        PNCVQ4Total = 0;
        SNCVQ1Total = 0;
        SNCVQ2Total = 0;
        SNCVQ3Total = 0;
        SNCVQ4Total = 0;
        ENCVQ1Total = 0;
        ENCVQ2Total = 0;
        ENCVQ3Total = 0;
        ENCVQ4Total = 0;
        pncvGrantTotal = 0;
        sncvGrantTotal = 0;
        encvGrantTotal = 0;
        BookingQ1Total = 0;            
        BookingQ2Total = 0;
        BookingQ3Total = 0;
        BookingQ4Total = 0;
        BookingGrandTotal = 0;
        
        AlliancePNCVQ1Total = 0; AlliancePNCVQ2Total = 0; AlliancePNCVQ3Total = 0; AlliancePNCVQ4Total = 0;                     
        AllianceSNCVQ1Total = 0; AllianceSNCVQ2Total = 0; AllianceSNCVQ3Total = 0; AllianceSNCVQ4Total = 0;                     
        AllianceENCVQ1Total = 0; AllianceENCVQ2Total = 0; AllianceENCVQ3Total = 0; AllianceENCVQ4Total = 0; 
        
        SolProPNCVQ1Total = 0; SolProPNCVQ2Total = 0; SolProPNCVQ3Total = 0; SolProPNCVQ4Total = 0; 
        SolProSNCVQ1Total = 0; SolProSNCVQ2Total = 0; SolProSNCVQ3Total = 0; SolProSNCVQ4Total = 0; 
        SolProENCVQ1Total = 0; SolProENCVQ2Total = 0; SolProENCVQ3Total = 0; SolProENCVQ4Total = 0;                                                          
        
        SerProPNCVQ1Total = 0; SerProPNCVQ2Total = 0; SerProPNCVQ3Total = 0; SerProPNCVQ4Total = 0; 
        SerProSNCVQ1Total = 0; SerProSNCVQ2Total = 0; SerProSNCVQ3Total = 0; SerProSNCVQ4Total = 0; 
        SerProENCVQ1Total = 0; SerProENCVQ2Total = 0; SerProENCVQ3Total = 0; SerProENCVQ4Total = 0;
        
        DMPNCVQ1Total = 0; DMPNCVQ2Total = 0; DMPNCVQ3Total = 0; DMPNCVQ4Total = 0; 
        DMSNCVQ1Total = 0; DMSNCVQ2Total = 0; DMSNCVQ3Total = 0; DMSNCVQ4Total = 0; 
        DMENCVQ1Total = 0; DMENCVQ2Total = 0; DMENCVQ3Total = 0; DMENCVQ4Total = 0;
        
        DMPNCVTotal = 0; DMSNCVTotal = 0; DMENCVTotal = 0;  
        AlliancePNCVTotal = 0; AllianceSNCVTotal = 0; AllianceENCVTotal = 0;
        SerProPNCVTotal = 0; SerProSNCVTotal = 0; SerProENCVTotal = 0;
        SolProPNCVTotal = 0; SolProSNCVTotal = 0; SolProENCVTotal = 0;  
        
        allianceBookingQ1Total = 0; SolProBookingQ1Total = 0; SerProBookingQ1Total = 0; DMBookingQ1Total = 0;
        allianceBookingQ2Total = 0; SolProBookingQ2Total = 0; SerProBookingQ2Total = 0; DMBookingQ2Total = 0;
        allianceBookingQ3Total = 0; SolProBookingQ3Total = 0; SerProBookingQ3Total = 0; DMBookingQ3Total = 0;
        allianceBookingQ4Total = 0; SolProBookingQ4Total = 0; SerProBookingQ4Total = 0; DMBookingQ4Total = 0;
        
        allianceTotal = 0;SolProTotal = 0; SerProTotal = 0; DMTotal = 0;
        
        TempTrainingMap = new Map<String, List<BP_Training_Course__c>>();  
        delTrainingContactMap = new Map<String,List<BP_Training_Contact__c>>();
        addedTrainingContactMap = new Map<String,List<BP_Training_Contact__c>>();
        
        this.controller = stdController;
        this.BussPlan = (Business_Plan_New__c)stdController.getRecord();
        
        User currentUser;
        currentUser = [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
                       From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        if(currentUser.UserType == 'PowerPartner')
        {
            if(currentUser.IsPortalEnabled) isPowerPartner = true;
            system.debug('isPowerPartner = '+isPowerPartner );
            myAccount = [Select Id, BillingCity, BillingStreet, BillingPostalCode, BillingState, BillingCountry,
                         Name, Partner_Self_Description_Long__c,Physical_City_Local__c, Reseller_Disti_Regional_ID__c,
                         Country_Picklist__c, DUNS_Number__c, GEO__c, Business_Name__c, Phone, Website, Primary_RTM_Alliance__c, Primary_RTM_Data_Management__c, Primary_RTM_Service_Provider__c,
                         Primary_RTM_Solution_Provider__c, Alliance__c, Alliance_Designation__c, Alliance_Program_Level__c, 
                         Alliance_Type__c, Service_Provider__c, Service_Provider_Designation__c, Service_Provider_Program_level__c,
                         Service_Provider_Type__c, Solution_Provider__c, Solution_Provider_Designation__c, Solution_Provider_Program_Level__c,
                         Solution_Provider_Type__c, Velocity_Seller__c, Velocity_Seller_Designation__c,Account_Program_Level__c, Velocity_Seller_Program_Level__c,Included_in_BP_of_CA_AccountID__c,  //SAMAP01 US293050
                         Velocity_Seller_Type__c, Logo__c,Regional_Global_Account__c from Account where Id=:currentUser.AccountId][0];            
            
            BussPlan.Account__c = myAccount.Id;
        }
       
        Business_Plan_New__c myBP = BussPlan;
        if(myAccount == null && BussPlan.Id != null)
        {
            myBP = [SELECT Id, Account__c, Name FROM Business_Plan_New__c WHERE Id = :BussPlan.Id][0];
        }
        myAccount = [Select Id, BillingCity, BillingStreet, BillingPostalCode, BillingState, BillingCountry,
                     Name, Partner_Self_Description_Long__c,Physical_City_Local__c, Reseller_Disti_Regional_ID__c,
                     Country_Picklist__c, DUNS_Number__c, GEO__c, Business_Name__c, Phone, Website, Primary_RTM_Alliance__c, Primary_RTM_Data_Management__c, Primary_RTM_Service_Provider__c,
                     Primary_RTM_Solution_Provider__c, Alliance__c, Alliance_Designation__c, Alliance_Program_Level__c, 
                     Alliance_Type__c, Service_Provider__c, Service_Provider_Designation__c, Service_Provider_Program_level__c,
                     Service_Provider_Type__c, Solution_Provider__c, Solution_Provider_Designation__c, Solution_Provider_Program_Level__c,
                     Solution_Provider_Type__c, Velocity_Seller__c, Velocity_Seller_Designation__c,Account_Program_Level__c, Velocity_Seller_Program_Level__c,Included_in_BP_of_CA_AccountID__c,  //SAMAP01 US293050
                     Velocity_Seller_Type__c, Logo__c,Regional_Global_Account__c from Account where Id=:myBP.Account__c][0];
        
        
        bpAccountId = ''+myAccount.Id;
        busPlanAccountId = ''+myAccount.Id;
        
        this.BussPlan.Account_Name__c = myAccount.Name;   
        this.BussPlan.Account_Description__c = myAccount.Partner_Self_Description_Long__c;                                        
        
        this.BussPlan.Account_Billing_Country__c = myAccount.BillingCountry;  
        
        this.BussPlan.Reseller_Distributor_ID__c = myAccount.Reseller_Disti_Regional_ID__c;
        this.BussPlan.Account_Country_Picklist__c = myAccount.Country_Picklist__c;
        this.BussPlan.Duns_Number__c = myAccount.DUNS_Number__c;
        this.BussPlan.GEO__c = myAccount.GEO__c;
        this.BussPlan.DUNS_Name__c = myAccount.Business_name__c;
        this.BussPlan.Phone__c = myAccount.Phone;
       
       
        myAccountId = myAccount.Id; 
        if (String.isBlank(this.BussPlan.Digital_Sales_Presales_POC_Aligned__c))
        {
            this.BussPlan.Digital_Sales_Presales_POC_Aligned__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Communication_Plan_for_Partner_achieve__c))
        {
            this.BussPlan.Communication_Plan_for_Partner_achieve__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Partner_enrolled_in_Partner_Program__c))
        {
            this.BussPlan.Partner_enrolled_in_Partner_Program__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Welcome_kit_delivered__c)){
            this.BussPlan.Welcome_kit_delivered__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.CA_account_resources_introduced__c))
        {
            this.BussPlan.CA_account_resources_introduced__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Introduce_to_program_and_tools__c))
        {
            this.BussPlan.Introduce_to_program_and_tools__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Executive_sponsor_engaged__c))
        {
            this.BussPlan.Executive_sponsor_engaged__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Business_plan_completed__c))
        {
            this.BussPlan.Business_plan_completed__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Joint_Account_mapping_initiated__c))
        {
            this.BussPlan.Joint_Account_mapping_initiated__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Marketing_plan_completed__c))
        {
            this.BussPlan.Marketing_plan_completed__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Educated_on_CA_resources_and_tools__c))
        {
            this.BussPlan.Educated_on_CA_resources_and_tools__c = 'Not started';
        }
        
        if (String.isBlank(this.BussPlan.Develop_enablement_plan__c))
        {
            this.BussPlan.Develop_enablement_plan__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Minimum_education_requirements_met__c))
        {
            this.BussPlan.Minimum_education_requirements_met__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Create_a_review_process_and_cadence__c))
        {
            this.BussPlan.Create_a_review_process_and_cadence__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Promote_partner_successes__c))
        {
            this.BussPlan.Promote_partner_successes__c = 'Not started';
        }
        if (String.isBlank(this.BussPlan.Partnership_assessment_conducted__c))
        {
            this.BussPlan.Partnership_assessment_conducted__c = 'Not started';
        }
        
        PMEnrolledInPartnerProgramPercentDisplay = 'display:none;';
        IntroductToProgramToolsPercentDisplay = 'display:none;';
        BusinessPlanCompletedPercentDisplay = 'display:none;';
        JointAccMappingInitiatedPercentDisplay = 'display:none;';
        DigitalPOCAlignedPercentDisplay = 'display:none;';
        MarketingPlanCompletedPercentDisplay = 'display:none;';
        DevelopEnablementPlanPercentDisplay = 'display:none;';
        MinEducationReqMetPercentDisplay = 'display:none;';
        PromotePartnerSuccessesPercentDisplay = 'display:none;';
        PartnershipAssessmentConductedPercentDisplay = 'display:none;';
        
        if (this.BussPlan.Partner_enrolled_in_Partner_Program__c == 'In progress')
        {
            PMEnrolledInPartnerProgramPercentDisplay = '';
        }
        else
        {
            PMEnrolledInPartnerProgramPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Introduce_to_program_and_tools__c == 'In progress')
        {
            IntroductToProgramToolsPercentDisplay = '';
        }
        else
        {
            IntroductToProgramToolsPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Business_plan_completed__c == 'In progress')
        {
            BusinessPlanCompletedPercentDisplay = '';
        }
        else 
        {
            BusinessPlanCompletedPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Joint_Account_mapping_initiated__c == 'In progress')
        {
            JointAccMappingInitiatedPercentDisplay = '';
        }
        else 
        {
            JointAccMappingInitiatedPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Digital_Sales_Presales_POC_Aligned__c == 'In progress')
        {
            DigitalPOCAlignedPercentDisplay = '';
        }
        else 
        {
            DigitalPOCAlignedPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Marketing_plan_completed__c == 'In progress')
        {
            MarketingPlanCompletedPercentDisplay = '';
        }
        else 
        {
            MarketingPlanCompletedPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Develop_enablement_plan__c == 'In progress')
        {
            DevelopEnablementPlanPercentDisplay = '';
        }
        else 
        {
            DevelopEnablementPlanPercentDisplay = 'display:none;';
        }
        if (this.BussPlan.Minimum_education_requirements_met__c == 'In progress')
        {
            MinEducationReqMetPercentDisplay = '';
        }
        else 
        {
            MinEducationReqMetPercentDisplay = 'display:none;';
        }
        
        if (this.BussPlan.Promote_partner_successes__c == 'In progress')
        {
            PromotePartnerSuccessesPercentDisplay = '';
        }
        else 
        {
            PromotePartnerSuccessesPercentDisplay = 'display:none;';
        }
        
        if (this.BussPlan.Partnership_assessment_conducted__c == 'In progress')
        {
            PartnershipAssessmentConductedPercentDisplay = '';
        }
        else 
        {
            PartnershipAssessmentConductedPercentDisplay = 'display:none;';
        }
        
        if(BussPlan.Id == null)
        {
            this.BussPlan.Status__c = 'Draft';
            this.BussPlan.Account_Billing_City__c = myAccount.BillingCity;
            this.BussPlan.Account_Billing_Street__c = myAccount.BillingStreet;
            this.BussPlan.Account_Billing_State__c = myAccount.BillingState;
            this.BussPlan.Account_Billing_Zip__c = myAccount.BillingPostalCode;                 
            this.BussPlan.Website__c= myAccount.Website;            
            this.BussPlan.Alliance__c = myAccount.Alliance__c;                   
            this.BussPlan.Alliance_Designation__c = myAccount.Alliance_Designation__c;
            this.BussPlan.Alliance_Program_Level__c = myAccount.Alliance_Program_Level__c;
            this.BussPlan.Alliance_Type__c = myAccount.Alliance_Type__c;
            //this.BussPlan.Data_Management__c = myAccount.Velocity_Seller__c; //MANAR08 AR:2267
            //this.BussPlan.DM_Designation__c = myAccount.Velocity_Seller_Designation__c; //MANAR08 AR:2267
            //this.BussPlan.DM_Program_Level__c = myAccount.Velocity_Seller_Program_Level__c; //MANAR08 AR:2267
            //this.BussPlan.DM_Type__c = myAccount.Velocity_Seller_Type__c; //MANAR08 AR:2267
            this.BussPlan.Service_Provider__c = myAccount.Service_Provider__c;
            this.BussPlan.Service_Provider_Designation__c = myAccount.Service_Provider_Designation__c;
            this.BussPlan.Service_Provider_Program_Level__c = myAccount.Service_Provider_Program_level__c;
            this.BussPlan.Service_Provider_Type__c = myAccount.Service_Provider_Type__c;
            this.BussPlan.Solution_Provider__c = myAccount.Solution_Provider__c;
            this.BussPlan.Solution_Provider_Designation__c = myAccount.Solution_Provider_Designation__c;
            this.BussPlan.Solution_Provider_Program_Level__c = myAccount.Solution_Provider_Program_Level__c;
            this.BussPlan.Solution_Provider_Type__c = myAccount.Solution_Provider_Type__c;
            this.BussPlan.Primary_RTM_Alliance__c = myAccount.Primary_RTM_Alliance__c;
            //this.BussPlan.Primary_RTM_DM__c = myAccount.Primary_RTM_Data_Management__c; //MANAR08 AR:2267
            this.BussPlan.Primary_RTM_Servide_Provider__c = myAccount.Primary_RTM_Service_Provider__c;
            this.BussPlan.Primary_RTM_Solution_Provider__c = myAccount.Primary_RTM_Solution_Provider__c;
            //MANAR08 Comment the below line for AR:1707
            this.BussPlan.Creator_Currency__c = UserInfo.getDefaultCurrency();              
            this.BussPlan.Creator_Language__c = getReadableLanguage(UserInfo.getLanguage()); 
            this.BussPlan.Communication_Plan_for_Partner_achieve__c = 'Not started';
            this.BussPlan.Partner_enrolled_in_Partner_Program__c = 'Not started';
            this.BussPlan.Digital_Sales_Presales_POC_Aligned__c = 'Not started';
            this.BussPlan.Welcome_kit_delivered__c = 'Not started';
            this.BussPlan.CA_account_resources_introduced__c = 'Not started';
            this.BussPlan.Introduce_to_program_and_tools__c = 'Not started';
            this.BussPlan.Executive_sponsor_engaged__c = 'Not started';
            this.BussPlan.Business_plan_completed__c = 'Not started';
            this.BussPlan.Joint_Account_mapping_initiated__c = 'Not started';
            this.BussPlan.Marketing_plan_completed__c = 'Not started';
            this.BussPlan.Develop_enablement_plan__c = 'Not started';
            this.BussPlan.Educated_on_CA_resources_and_tools__c = 'Not started';
            this.BussPlan.Minimum_education_requirements_met__c = 'Not started';
            this.BussPlan.Create_a_review_process_and_cadence__c = 'Not started';
            this.BussPlan.Promote_partner_successes__c = 'Not started';
            this.BussPlan.Partnership_assessment_conducted__c = 'Not started';
            //this.BussPlan.Is_Geo_Account__c = this.isGeoAccount  ; //SAMAP01 US293050 & US293051
        }
        //SAMAP01 -US324464 Always take myaccount program levels
        //this.BussPlan.Alliance_Program_Level__c = myAccount.Alliance_Program_Level__c;
        //this.BussPlan.Service_Provider_Program_Level__c = myAccount.Service_Provider_Program_level__c;
        //this.BussPlan.Solution_Provider_Program_Level__c = myAccount.Solution_Provider_Program_Level__c;
         //FY18 AMASA03
        Set<String> ProgramlevelSet = new Set<String>{'Premier','Focus','Global'};
            if(ProgramlevelSet.contains(myAccount.Alliance_Program_Level__c) || ProgramlevelSet.contains(myAccount.Service_Provider_Program_level__c) || ProgramlevelSet.contains(myAccount.Solution_Provider_Program_Level__c)){
                incentiveFieldRequired = true;
            }else{
                incentiveFieldRequired = false;
            }
        if(this.BussPlan.Plan_Fiscal_Year__c != null && this.BussPlan.Plan_Fiscal_Year__c != '--Select--'){
            String Iyear =this.BussPlan.Plan_Fiscal_Year__c;
            String IncentiveplanYear = Iyear.removeStart('FY ');
            IntegerPlanyear = integer.valueof(IncentiveplanYear);
            if(IntegerPlanyear < 2018){
                ShowIncentivesection = false;  
                
            }else
            {
                ShowIncentivesection = true; 
                
                //SAMAP01 US293050 & US293051 -MAR 23 2017
                //Ponse01-start FY19 - US457757
				if(BussPlan.Id != null && IntegerPlanyear < 2019){
					
				getIsGeoAccount();
				}
                 //Ponse01-End FY19- US457757    
            }
        } 
        else{
            ShowIncentivesection = false;
        }
        if(myAccount.Regional_Global_Account__c == true && ShowIncentivesection == true){
           // isRegionalAccount = true;  FY19- US457757
        }else{
           // isRegionalAccount =false;  FY19- US457757
        }
           //ponse01---start----        
        pageName = ApexPages.currentPage().getUrl();        
        system.debug('-----current page name----'+pageName);        
        if(pageName.contains('BusinessPlanEdit')){      
                        
        if(ShowIncentivesection == true){       
       System.debug('Entered if Condition Fiscal Year');        
        this.BussPlan.Alliance_Program_Level__c = myAccount.Alliance_Program_Level__c;      
        system.debug('this.BussPlan.Alliance_Program_Level__c--------'+ myAccount.Alliance_Program_Level__c);       
        this.BussPlan.Solution_Provider_Program_Level__c = myAccount.Solution_Provider_Program_Level__c;        
        this.BussPlan.Service_Provider_Program_Level__c = myAccount.Service_Provider_Program_level__c;      
        this.BussPlan.Alliance__c = myAccount.Alliance__c;      
        this.BussPlan.Alliance_Designation__c = myAccount.Alliance_Designation__c;      
        this.BussPlan.Alliance_Type__c = myAccount.Alliance_Type__c;        
        this.BussPlan.Service_Provider__c = myAccount.Service_Provider__c;      
        system.debug('this.BussPlan.Service_Provider__c--------'+ myAccount.Service_Provider__c);       
        this.BussPlan.Service_Provider_Designation__c = myAccount.Service_Provider_Designation__c;      
        this.BussPlan.Service_Provider_Type__c = myAccount.Service_Provider_Type__c;        
        this.BussPlan.Solution_Provider__c = myAccount.Solution_Provider__c;        
        this.BussPlan.Solution_Provider_Designation__c = myAccount.Solution_Provider_Designation__c;        
        this.BussPlan.Solution_Provider_Type__c = myAccount.Solution_Provider_Type__c;      
        system.debug('this.BussPlan.Solution_Provider_Type__c --------'+ myAccount.Solution_Provider_Type__c);      
        this.BussPlan.Primary_RTM_Alliance__c = myAccount.Primary_RTM_Alliance__c;      
        this.BussPlan.Primary_RTM_Servide_Provider__c = myAccount.Primary_RTM_Service_Provider__c;      
        this.BussPlan.Primary_RTM_Solution_Provider__c = myAccount.Primary_RTM_Solution_Provider__c;        
        system.debug('this.BussPlan.Primary_RTM_Solution_Provider__c --------'+ myAccount.Primary_RTM_Solution_Provider__c);        
                
                
                
                
        }       
        }       
        if(myAccountId != null && BussPlan.Id != null)      
        {       
                
        if(ShowIncentivesection == true){       
                
        Alliancelevel = myAccount.Alliance_Program_Level__c;        
                
        Solutionlevel = myAccount.Solution_Provider_Program_Level__c;       
        Servicelevel = myAccount.Service_Provider_Program_level__c;     
        Alliance= myAccount.Alliance__c;        
        AllianceDesignation=myAccount.Alliance_Designation__c;      
        AllianceType = myAccount.Alliance_Type__c;      
        ServiceProvider= myAccount.Service_Provider__c;     
        ServiceProviderDesignation = myAccount.Service_Provider_Designation__c;     
        ServiceProviderType = myAccount.Service_Provider_Type__c;       
        SolutionProvider= myAccount.Solution_Provider__c;       
        SolutionProviderDesignation= myAccount.Solution_Provider_Designation__c;        
        SolutionProviderType= myAccount.Solution_Provider_Type__c;      
        PrimaryRTMAlliance= myAccount.Primary_RTM_Alliance__c;      
        PrimaryRTMServideProvider = myAccount.Primary_RTM_Service_Provider__c;      
        PrimaryRTMSolutionProvider= myAccount.Primary_RTM_Solution_Provider__c;     
        }       
                
                
    }       
    //ponse01---End----
        
        if(this.BussPlan.Status__c == 'CA & Partner Approved'){
            //make incentive as read only mode
            isApprovedBP = true;
        }else{
            isApprovedBP = false;
        }
        /*FY18 AMASA03*/
        myAccountAddress = this.BussPlan.Account_Billing_Street__c + ' \n ' + this.BussPlan.Account_Billing_City__c + ', ' + this.BussPlan.Account_Billing_State__c + ' ' + this.BussPlan.Account_Billing_Zip__c;            
        
        try
        {
            logoRecordID = myAccount.Logo__c;
            Attachment logoBlob = [select id from Attachment where parentid = :logoRecordID];
            logoAttachmentID = logoBlob.id;
        }
        catch(QueryException e)
        {
            logoError = true;
        }            
        
        if(AddedPGs == null)
        {
            AddedPGs = new List<ProductGroup>();
        }

        partnerBusPlanOwnerName = '';
        partnerExecSponsorName = '';
        otherPartnerContact = '';
        approver001 = '';
        approver002 = '';
        Partner_Enablement_Coordinator =''; //SAMAP01  US238114
        showCAapprvr=true; //samap01 12/7
        //SAMAP01 US293050 & 293051
        geosalesvp ='';
        geoprogramlead ='';
        geofinance ='';
        geoenablement ='';
        geomarketing ='';
        //SAMAP01 US293050 & 293051
        Business_Plan_New__c tBp;
        if(BussPlan.Id != null)
        { 
            //tBp = [select Partner_Business_Plan_Owner__r.Name, Partner_Executive_Sponsor__r.Name, Other_Partner_Contact__r.Name,Approvers_01__r.Name,Approvers_02__r.Name from Business_Plan_New__c where id = :BussPlan.Id][0]; //MANAR08 AR:2953
            //tBp = [select Partner_Business_Plan_Owner__r.Name,Status__c, Partner_Executive_Sponsor__r.Name, Other_Partner_Contact__r.Name,Approvers_01__r.Name,Approvers_02__r.Name,Plan_Fiscal_Year__c from Business_Plan_New__c where id = :BussPlan.Id][0]; //MANAR08 AR:2953
            tBp = [select Partner_Business_Plan_Owner__r.Name,Status__c, Partner_Executive_Sponsor__r.Name, 
                   Other_Partner_Contact__r.Name,Approvers_01__r.Name,
                   Approvers_02__r.Name,Plan_Fiscal_Year__c, Partner_Enablement_Coordinator__r.Name,
                   GEO_Enablement__r.Name,GEO_Finance__r.Name,GEO_Marketing__r.Name,GEO_Program_Lead__r.Name,GEO_Sales_VP__r.Name,Is_Geo_Account__c 
                   from Business_Plan_New__c where id = :BussPlan.Id][0]; //SAMAP01 US238114   //SAMAP01 US293050 & 293051
            
            System.debug('tBp val :'+tBp);  
            System.debug('tBp.Partner_Business_Plan_Owner__r.Name:'+tBp.Partner_Business_Plan_Owner__r.Name);             
            partnerBusPlanOwnerName = partnerBusPlanOwnerName_1 =tBp.Partner_Business_Plan_Owner__r.Name;
            partnerExecSponsorName = partnerExecSponsorName_1 =tBp.Partner_Executive_Sponsor__r.Name;
            otherPartnerContact = otherPartnerContact_1 =tBp.Other_Partner_Contact__r.Name;
            approver001 = approver001_1 =tBp.Approvers_01__r.Name;
            approver002 = approver002_1 =tBp.Approvers_02__r.Name;
            Partner_Enablement_Coordinator=Partner_Enablement_Coordinator_1=tBp.Partner_Enablement_Coordinator__r.Name; //SAMAP01 US238114
            // this.BussPlan.Status__c = tBp.Status__c; //samap01 06/12
            //SAMAP01 US293050 & 293051
            geosalesvp = geosalesvp_1 = tBp.GEO_Sales_VP__r.Name ;
            geoprogramlead = geoprogramlead_1 = tBp.GEO_Program_Lead__c;
            geofinance = geofinance_1 = tBp.GEO_Finance__r.Name;
            geoenablement = geoenablement_1 = tBp.GEO_Enablement__r.Name;
            geomarketing =geomarketing_1= tBp.GEO_Marketing__r.Name;
            //isgeoAccount = tBp.Is_Geo_Account__c;
            //SAMAP01 US293050 & 293051
            System.debug('partnerBusPlanOwnerName_1:'+partnerBusPlanOwnerName_1);               
            System.debug('Par Bus Plan Owner Name :'+ partnerBusPlanOwnerName);
            System.debug('Par Exec Name :'+ partnerExecSponsorName); 
            
            //MANAR08 AR:2953
            curBPFYear = getBPFYear(tBp.Plan_Fiscal_Year__c);
            System.debug('curBPFYear:'+curBPFYear +';curFYear:'+curFYear); //TODO: delete this stmt
            if(curBPFYear==curFYear || curBPFYear == curFYear-1){
                isCloneEnabled = true;              
            }
            if(curBPFYear < curFYear){
                isEditDisabled = true;
                isCloneEnabled = true;
            }
            System.debug('isCloneEnabled:'+isCloneEnabled);
            currentBP = (Business_Plan_New__c)controller.getRecord();
            if(tbp.Status__c  == 'CA Approved'){
                showCAapprvr = false;
            }else showCAapprvr=true;
        }
        // SAMAP01 US293050 & US293051
       //Ponse01-start FY19- US457757
	   if(BussPlan.Id != null && curBPFYear <= 2018){
					
				getIsGeoAccount();
				}
        //Ponse01-end FY19- US457757
        showCAapprvr=false;
        /****** Get Business Plan Solutions Information ******/
        
        if(BussPlan.Id != null)
        {
            List<BP_Solutions__c> myBPSols = [Select JSO_Name__c, Product_Group__c, RTM__c, Sales_Coverage_Business_Unit__c,  Is_Incubate_Product__c, //samap01
                                              PNCV_Q1__c, PNCV_Q2__c, PNCV_Q3__c, PNCV_Q4__c, SNCV_Q1__c, SNCV_Q2__c, SNCV_Q3__c, SNCV_Q4__c,
                                              ENCV_Q1__c, ENCV_Q2__c, ENCV_Q3__c, ENCV_Q4__c 
                                              from BP_Solutions__c where Business_Plan__c=:BussPlan.Id];
            SolnCountPrev = myBPSols.size();
            if(AddedPGs == null)
            {
                AddedPGs = new List<ProductGroup>();
            }
            
            if(myBPSols.size() > 0)
            {
                for(BP_Solutions__c bp : myBPSols)
                {
                    solutionCounter = solutionCounter + 1;
                    if(bp.RTM__c == 'Alliance')
                    {
                        allianceBookingExists = true;
                    }
                    else if(bp.RTM__c == 'Solution Provider')
                    {
                        SolProBookingExists = true;
                    }
                    else if(bp.RTM__c == 'Service Provider')
                    {
                        SerProBookingExists = true;
                    }
                    
                    //samap01 US293050 & US293051
                    if(bp.Is_Incubate_Product__c) 
                    {
                        Is_Incubate_Product= 'Yes';
                    }
                    else
                    {
                        Is_Incubate_Product = 'No';
                    }
                    ProductGroup myPG = new ProductGroup(solutionCounter, bp.RTM__c, bp.Sales_Coverage_Business_Unit__c, bp.Product_Group__c, bp.JSO_Name__c,Is_Incubate_Product );//samap01);                     
                    myPG.AddPNCVTarget(bp.PNCV_Q1__c, bp.PNCV_Q2__c, bp.PNCV_Q3__c, bp.PNCV_Q4__c);
                    myPG.AddSNCVTarget(bp.SNCV_Q1__c, bp.SNCV_Q2__c, bp.SNCV_Q3__c, bp.SNCV_Q4__c);
                    myPG.AddENCVTarget(bp.ENCV_Q1__c, bp.ENCV_Q2__c, bp.ENCV_Q3__c, bp.ENCV_Q4__c);   
                    
                    //SAMAP01 -US293050/51 -Adding country field to resources
                    List<BP_Training_Contact__c> bpcList = [Select Contact__c, BP_Solutions__r.Product_Group__c, Test_Contact_Name__c, Resource_Type__c, Contact_Email__c,GeoCountry__c,Certification_Level__c,Credentails__c,product_group__c from BP_Training_Contact__c //SAMAP01 US293050 & US293051
                                                            where BP_Solutions__c=:bp.Id order by Resource_Type__c ASC];
                    
                    List<BP_Training_Contact__c> newBpcList = new List<BP_Training_Contact__c>();
                    //newBpcList.addAll(bpcList);
                    for(BP_Training_Contact__c bpc : bpcList)
                    {
                        
                        newBpcList.add(new BP_Training_Contact__c(Test_Contact_Name__c=bpc.Test_Contact_Name__c, contact__c=bpc.contact__c, resource_type__c=bpc.resource_type__c, Resource_Email__c = bpc.Contact_Email__c,BP_Solutions__c = bpc.BP_Solutions__c,GeoCountry__c=bpc.GeoCountry__c,Certification_Level__c = bpc.Certification_Level__c,Credentails__c = bpc.Credentails__c ,product_group__c=bpc.product_group__c));
                    }
                    myPG.AddBPTrainingContactsList(newBpcList);
                    myPG.TotalResources();
                    AddedPGs.add(myPG);                
                }
                
                
            }
        }
        // System.debug('samap01-status '+ this.BussPlan.Status__c);
        if(this.BussPlan.Status__c == 'CA & Partner Approved' || this.BussPlan.Status__c == 'CA Rejected' ||this.BussPlan.Status__c == 'Partner Rejected' || this.BussPlan.Status__c == 'Recalled' || this.BussPlan.Status__c == 'Modifying')
            WarningMessage = true;
        
        System.debug('WarningMessage'+WarningMessage);
        // System.assertEquals(this.BussPlan.Status__c,'CA & Partner Approved');
        
    }
    
    
    //MANAR08 AR:2953 starts
    public void getCurrentFYear(){
        Date curDate = Date.today();
        Integer curYear = curDate.year();
        Integer curMonth = curDate.month();
        if(curMonth >3)
            curFYear = curYear+1;
        else
            curFYear =curYear;
    }
    
    //MANAR08 AR:2427 
    public List<SelectOption> getBPFYears(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--Select--','--Select--'));        
        String currentFYear = 'FY '+curFYear;
        String nextFYear = 'FY '+ (curFYear+1);
        options.add(new SelectOption(currentFYear,currentFYear));
        options.add(new SelectOption(nextFYear,nextFYear));
        return options;         
    }
    
    public Integer getBPFYear(String strBPFyear){
        return Integer.valueof(strBPFyear.removeStart('FY '));      
    }
    
    public PageReference cloneBP(){     
        
        System.debug('In cloneBP()');
        try{                    
            currentBP = [select Account__c,Status__c ,Action_Items__c,SendPartnerEmail__c,
                         Account_Name__c, Account_Description__c, Account_Billing_Street__c, Account_Billing_City__c, Account_Billing_State__c, Account_Billing_Zip__c, 
                         Reseller_Distributor_ID__c, Account_Country_Picklist__c, DUNS_Number__c, GEO__c, DUNS_Name__c, Phone__c, Creator_Language__c, Website__c, Creator_Currency__c, 
                         Alliance__c, Alliance_Type__c, Alliance_Designation__c, Primary_RTM_Alliance__c, Alliance_Program_Level__c, 
                         Service_Provider__c, Service_Provider_Type__c, Service_Provider_Designation__c, Primary_RTM_Servide_Provider__c, Service_Provider_Program_Level__c, 
                         Solution_Provider__c, Solution_Provider_Type__c, Solution_Provider_Designation__c, Primary_RTM_Solution_Provider__c, Solution_Provider_Program_Level__c, 
                         WW__c, PS_CAN__c, PS_CAN_Operating_Area__c, PS_CAN_Countries__c, NA__c, NA_Operating_Areas__c, NA_Countries__c, LA__c, LA_Operating_Areas__c, LA_Countries__c, EMEA__c, EMEA_Operating_Areas__c, EMEA_Countries__c, 
                         APJ__c, APJ_Operating_Areas__c, APJ_Countries__c, GTM_Q1__c, GTM_Q2__c, GTM_Q3__c, GTM_Q4__c, GTM_Q5__c, GTM_Q6__c, GTM_Q7__c, GTM_Q8__c, GTM_Q11__c, GTM_Q12__c,
                         Target_Sector__c, Target_Vertical__c, MSO_Opportunity_Name__c, GTM_SP_Q2__c, GTM_SP_Q3__c, GTM_SP_Q4__c, GTM_SP_Q5__c, GTM_SP_Q6__c, GTM_SP_Q7__c, GTM_SP_Q8__c,
                         GTM_SP_Q9__c, GTM_SP_Q10__c, GTM_SP_Q11__c, GTM_SP_Q12__c, GTM_SP_Q13__c, GTM_SP_Q14__c, GTM_SP_Q15__c, GTM_SP_Q16__c, GTM_SP_Q17__c, GTM_SP_Q18__c, Number_of_data_centers__c,
                         Geography_distribution__c, Data_Center_Tiers__c, Real_estate_ownership__c, Business_Performance__c, Insourcing_Multi_sourcing__c, ROI_Expectations__c,
                         Capability_1__c, Capability_2__c, Description_of_Desired_State_1__c, Description_of_Desired_State_2__c, Description_of_Current_State_1__c, Description_of_Current_State_2__c, 
                         Rationalization_Opportunities_1__c, Rationalization_Opportunities_2__c, Capability_3__c, Capability_4__c, Description_of_Desired_State_3__c, Description_of_Desired_State_4__c, 
                         Description_of_Current_State_3__c, Description_of_Current_State_4__c, Rationalization_Opportunities_3__c, Rationalization_Opportunities_4__c, Capability_5__c, Capability_6__c, 
                         Description_of_Desired_State_5__c, Description_of_Desired_State_6__c, Description_of_Current_State_5__c, Description_of_Current_State_6__c, Rationalization_Opportunities_5__c, 
                         Rationalization_Opportunities_6__c,
                         Partner_enrolled_in_Partner_Program__c,Partner_enrolled_in_Program_percentage__c,
                         Welcome_kit_delivered__c,CA_account_resources_introduced__c,
                         Introduce_to_program_and_tools__c,Introduce_to_program_tools_percentage__c,
                         Digital_Sales_Presales_POC_Aligned__c,Digital_POC_Aligned_percentage__c,
                         Executive_sponsor_engaged__c,Business_plan_completed__c,Business_plan_completed_percentage__c,
                         Joint_Account_mapping_initiated__c,Joint_Acc_mapping_initiated_percentage__c,
                         Marketing_plan_completed__c,Marketing_plan_completed_percentage__c,
                         Develop_enablement_plan__c,Develop_enablement_plan_percentage__c,
                         Educated_on_CA_resources_and_tools__c,Partner_education_started__c,Minimum_education_requirements_met__c,min_education_req_met_percentage__c,
                         Marketing_activities_started__c,Engaged_partner_in_joint_opportunity__c,Create_a_review_process_and_cadence__c,Engaging_partner_in_Regional_QBR__c,
                         Establish_an_ongoing_business_review__c,Internal_CA_cross_functional_resources__c,Program_benefits_delivered__c,Communication_Plan_for_Partner_achieve__c,
                         Promote_partner_successes__c,Promote_partner_successes_percentage__c,Partnership_assessment_conducted__c,Partnership_assessment_conducted_percent__c,Incentive_Readonly__c,
                         GEO_Enablement__r.Name,GEO_Finance__r.Name,GEO_Marketing__r.Name,GEO_Program_Lead__r.Name,GEO_Sales_VP__r.Name,Is_Geo_Account__c  //SAMAP01 US293050 & US293051
                         from Business_Plan_New__c where id =: BussPlan.Id];      
            //Plan_Fiscal_Year__c, Plan_Period_From__c, Plan_Period_To__c,              
            /*
Id curBPAccLogoId = [select Account__r.Logo__c from Business_Plan_New__c where id = currentBP.Id ];
Attachment logoBlob = [select id from Attachment where parentid = :curBPAccLogoId];
logoAttachmentID = logoBlob.id;  ******/
            clonedBP = currentBP.clone(false);
            //samap01 US324464
            Account  myClonedBPAccount = [Select Id, BillingCity, BillingStreet, BillingPostalCode, BillingState, BillingCountry,
                     Name, Partner_Self_Description_Long__c,Physical_City_Local__c, Reseller_Disti_Regional_ID__c,
                     Country_Picklist__c, DUNS_Number__c, GEO__c, Business_Name__c, Phone, Website, Primary_RTM_Alliance__c, Primary_RTM_Data_Management__c, Primary_RTM_Service_Provider__c,
                     Primary_RTM_Solution_Provider__c, Alliance__c, Alliance_Designation__c, Alliance_Program_Level__c, 
                     Alliance_Type__c, Service_Provider__c, Service_Provider_Designation__c, Service_Provider_Program_level__c,
                     Service_Provider_Type__c, Solution_Provider__c, Solution_Provider_Designation__c, Solution_Provider_Program_Level__c,
                     Solution_Provider_Type__c, Velocity_Seller__c, Velocity_Seller_Designation__c,Account_Program_Level__c, Velocity_Seller_Program_Level__c,Included_in_BP_of_CA_AccountID__c,  //SAMAP01 US293050
                     Velocity_Seller_Type__c, Logo__c from Account where Id=:currentBP.Account__c][0];
                     
           
            this.clonedBP.Alliance_Program_Level__c = myClonedBPAccount.Alliance_Program_Level__c;
            this.clonedBP.Service_Provider_Program_level__c = myClonedBPAccount.Service_Provider_Program_level__c;
            this.clonedBP.Solution_Provider_Program_Level__c = myClonedBPAccount.Solution_Provider_Program_Level__c;    
            this.clonedBP.Alliance__c =myClonedBPAccount.Alliance__c;
            this.clonedBP.Service_Provider__c =myClonedBPAccount.Service_Provider__c;
            this.clonedBP.Solution_Provider__c =myClonedBPAccount.Solution_Provider__c;
            this.clonedBP.Alliance_Designation__c = myClonedBPAccount.Alliance_Designation__c;
            this.clonedBP.Alliance_Program_Level__c = myClonedBPAccount.Alliance_Program_Level__c; 
            this.clonedBP.Alliance_Type__c = myClonedBPAccount.Alliance_Type__c;
            this.clonedBP.Service_Provider__c = myClonedBPAccount.Service_Provider__c;
            this.clonedBP.Service_Provider_Designation__c = myClonedBPAccount.Service_Provider_Designation__c;
            this.clonedBP.Service_Provider_Program_Level__c = myClonedBPAccount.Service_Provider_Program_level__c;
            this.clonedBP.Service_Provider_Type__c = myClonedBPAccount.Service_Provider_Type__c;
            this.clonedBP.Solution_Provider__c = myClonedBPAccount.Solution_Provider__c;
            this.clonedBP.Solution_Provider_Designation__c = myClonedBPAccount.Solution_Provider_Designation__c;
            this.clonedBP.Solution_Provider_Program_Level__c = myClonedBPAccount.Solution_Provider_Program_Level__c;
            this.clonedBP.Solution_Provider_Type__c = myClonedBPAccount.Solution_Provider_Type__c;
            this.clonedBP.Primary_RTM_Alliance__c = myClonedBPAccount.Primary_RTM_Alliance__c;
            this.clonedBP.Primary_RTM_Servide_Provider__c = myClonedBPAccount.Primary_RTM_Service_Provider__c;
            this.clonedBP.Primary_RTM_Solution_Provider__c = myClonedBPAccount.Primary_RTM_Solution_Provider__c;
            this.clonedBP.Status__c='Draft';
            this.clonedBP.Action_Items__c='';
            this.clonedBP.SendPartnerEmail__c=false;
             //samap01 -US324464
            System.debug('clonedBP:'+clonedBP);
            AddedPGs.clear(); 
           //clonedBP.Incentive__c = null;
            clonedBP.Incentive_Readonly__c = false;
            ShowIncentivesection = false;
            allianceBookingExists = null;
            SolProBookingExists = null;
            SerProBookingExists = null;
            DMBookingExists = null; 
           
            partnerBusPlanOwnerName = partnerBusPlanOwnerName_1 = '';
            partnerExecSponsorName = partnerExecSponsorName_1 = '';
            otherPartnerContact = otherPartnerContact_1 = '';
            approver001 = approver001_1 = '';
            approver002 = approver002_1 = '';     
            Partner_Enablement_Coordinator = Partner_Enablement_Coordinator_1= ''; //SAMAP01 US238114
            //SAMAP01 US293050 & 293051
            geosalesvp = geosalesvp_1 = '';
            geoprogramlead = geoprogramlead_1 = '';
            geofinance = geofinance_1 = '';
            geoenablement = geoenablement_1 = '';
            geomarketing =geomarketing_1= '';
             isGeoAccount= false;
            clonedbp.Is_Geo_Account__c = false;
            //SAMAP01 US293050 & 293051
            
        }
        catch(Exception e){
            System.debug('***Exception e:'+e);
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Clone failed. Check the logs'));
            return null;
        }       
        
        /*      
profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);  
System.debug('currentTab:'+currentTab);
*/
        currentTab = '1';       
        isClonedBP = true;
        PageReference pageRef = new PageReference('/apex/BusinessPlanClonedEdit'); //TODO:
        // PageReference pageRef = new PageReference('/apex/BusinessPlanEdit?clone=1&id='+BussPlan.Id); 
        return pageRef;     
    }   
    //MANAR08 AR:2953 ends    
    
    public String getPartnerProgramLevel()
    {
        String partnerProgramLevel = '';
        if(isClonedBP){  //MANAR08 AR:2953
            if(this.clonedBP.Alliance__c)
            {
                this.clonedBP.Alliance_Program_Level__c = myAccount.Alliance_Program_Level__c;
                partnerProgramLevel  = this.clonedBP.Alliance_Program_Level__c;
            }
            else if(this.clonedBP.Service_Provider__c)
            {
                this.clonedBP.Service_Provider_Program_Level__c=myAccount.Service_Provider_Program_Level__c;
                partnerProgramLevel  = this.clonedBP.Service_Provider_Program_Level__c;        
            }
            else if(this.clonedBP.Solution_Provider__c)
            {
                 this.clonedBP.Solution_Provider_Program_Level__c=myAccount.Solution_Provider_Program_Level__c;
                partnerProgramLevel  = this.clonedBP.Solution_Provider_Program_Level__c;        
            }           
        }
        else{ //MANAR08 AR:2953
            
            if(this.BussPlan.Alliance__c)
            {
               // partnerProgramLevel  = this.BussPlan.Alliance_Program_Level__c; //samap01 -fy18
                partnerProgramLevel  = myAccount.Alliance_Program_Level__c;
            }
            else if(this.BussPlan.Service_Provider__c)
            {
                //partnerProgramLevel  = this.BussPlan.Service_Provider_Program_Level__c;   //samap01
                 partnerProgramLevel  = myAccount.Service_Provider_Program_Level__c;  
            }
            else if(this.BussPlan.Solution_Provider__c)
            {
               // partnerProgramLevel  = this.BussPlan.Solution_Provider_Program_Level__c;    //samap01
                 partnerProgramLevel  = myAccount.Solution_Provider_Program_Level__c;   
            }
        } //MANAR08 AR:2953
        
        return partnerProgramLevel;
    }
    
    public String getDMProgramLevel()
    {
        String DMProgramLevel = '';
        
        if(this.BussPlan.DM_Program_Level__c!=null && this.BussPlan.DM_Program_Level__c!='')
        {
            DMProgramLevel  = this.BussPlan.DM_Program_Level__c;
        }
        
        return DMProgramLevel;
    }
    
    public void calcPlanPeriod()
    {
        if(isClonedBP){
            if(this.clonedBP.Plan_Fiscal_Year__c != '--Select--'){
                String planYear = this.clonedBP.Plan_Fiscal_Year__c;
                planYear = planYear.removeStart('FY ');
                this.clonedBP.Plan_Period_To__c = 'March 31 ' + planYear;
                Integer startYear = integer.valueof(planYear);
                startYear = startYear - 1;
                this.clonedBP.Plan_Period_From__c = 'April 1 ' + startYear;
                if(planYear != null){
                    Integer IntegerPlanyear = integer.valueof(planYear);
                    if(IntegerPlanyear < 2018){
                        ShowIncentivesection = false;
                        inch=true;
                       // this.clonedBP.Incentive__c = null;
                    }else{
                        ShowIncentivesection = true;
                        inch=true;
                    }
                }else{
					inch=true;
					
				} 
            }else{
                ShowIncentivesection = false;
                inch=null;
                //this.clonedBP.Incentive__c = null;
            }
            
        }
        else{
            if(this.BussPlan.Plan_Fiscal_Year__c != '--Select--'){
                String planYear = this.BussPlan.Plan_Fiscal_Year__c;
                planYear = planYear.removeStart('FY ');
                this.BussPlan.Plan_Period_To__c = 'March 31 ' + planYear;
                Integer startYear = integer.valueof(planYear);
                startYear = startYear - 1;
                this.BussPlan.Plan_Period_From__c = 'April 1 ' + startYear; 
                if(planYear != null){
                    Integer IntegerPlanyear = integer.valueof(planYear);
                    if(IntegerPlanyear < 2018){
                        ShowIncentivesection = false;
                        inch=true;
                        //this.BussPlan.Incentive__c = null;
                    }else{
                        ShowIncentivesection = true;
                        inch=true;
                    }
                }else{
					inch=true;
					
				} 
                
            }else{
                ShowIncentivesection = false;
                inch=null;
               // this.BussPlan.Incentive__c = null;
            } 
        }
        if(myAccount.Regional_Global_Account__c == true && ShowIncentivesection == true){
           // isRegionalAccount = true; ponse01 FY19- US457757
        }else{
           // isRegionalAccount =false;ponse01 FY19- US457757
        }
        //samap01 US293050 & 51 - Get if its geo account
       // getIsGeoAccount(); ponse01 FY19- US457757
    }
    
    public List<SelectOption> getRTMs()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--Select--','--Select--'));   
        if(isClonedBP) {  //MANAR08 AR:2953
            if(this.clonedBP.Alliance__c)
            {
                options.add(new SelectOption('Alliance','Alliance'));
            }
            if(this.clonedBP.Service_Provider__c)
            {
                options.add(new SelectOption('Service Provider','Service Provider'));
            }
            if(this.clonedBP.Solution_Provider__c)
            {
                options.add(new SelectOption('Solution Provider','Solution Provider'));
            }
            
        } 
        else {
            if(this.BussPlan.Alliance__c)
            {
                options.add(new SelectOption('Alliance','Alliance'));
            }
            if(this.BussPlan.Service_Provider__c)
            {
                options.add(new SelectOption('Service Provider','Service Provider'));
            }
            if(this.BussPlan.Solution_Provider__c)
            {
                options.add(new SelectOption('Solution Provider','Solution Provider'));
            }
            
        }
        isAddDisabled = false;         
        return options;                     
    } 
    
    public List<SelectOption> getBUs()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--Select--','--Select--'));        
        List<Product2> applicableBUs = [Select Market_Focus_Area__c from Product2 where Partner_Approved__c INCLUDES (:SolutionRTM) and Salesforce_CPQ_Product__c=false];                          
        Set<String> uniqueApplicableBUs = new set<String>();     
        for(Product2 PA : applicableBUs)
        {
            uniqueApplicableBUs.add(PA.Market_Focus_Area__c);
        }    
        
        for(String PA1 : uniqueApplicableBUs)
        {
            options.add(new SelectOption(PA1,PA1));
        } 
        
        return options;                     
    }
    
    public List<SelectOption> getProductGroups()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--Select--','--Select--'));        
        List<Product2> applicableProductGroups = [Select Product_Group__c from Product2 where Salesforce_CPQ_Product__c=false and Partner_Approved__c INCLUDES (:SolutionRTM) AND Market_Focus_Area__c=:SolutionBU];                          
        Set<String> uniqueapplicableProductGroups = new set<String>();
        for(Product2 PA : applicableProductGroups)
        {
            if(PA.Product_Group__c!=Null){
            uniqueapplicableProductGroups.add(PA.Product_Group__c);
            }
        }    
        
        for(String PA1 : uniqueapplicableProductGroups)
        {
            options.add(new SelectOption(PA1,PA1));
        } 
        
        return options;                     
    }  
    public List<SelectOption> Geocountries {get;set;}
    // SAMAP01 US293050 - Get country picklist for the Geos 
    public List<SelectOption> getGeoAccountCountries()
    {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('None','--None--'));
        List<Account> geoCountries = [SELECT  Country_Picklist__c FROM Account where (Included_in_BP_of_CA_AccountID__c =:myAccountId or ID =:myAccountId)  and Country_Picklist__c  != null];
        System.debug('getGeoAccountCountries() countryOptions:'+geoCountries);
        geoCountries.sort();
        Set<String> Uniquecountries = new set<String>();
        // countryOptions.add(new SelectOption(myaccount.Country_Picklist__c,myaccount.Country_Picklist__c));
        for(Account account :geoCountries )
        {
            //countryOptions.add(new SelectOption(account.Country_Picklist__c,account.Country_Picklist__c));
            Uniquecountries.add(account.Country_Picklist__c);
        }    
        for(String geocountry : Uniquecountries)
        {
            countryOptions.add(new SelectOption(geocountry,geocountry));
        } 
        
        
        return countryOptions;      
    }
    public void clearBUPG()          
    {
        SolutionBU = '--Select--';        
    }
    
    public void clearBookingBUPG()          
    {
        BookingBU = '--Select--';        
    }
    
    //SAMAP01 - DE25011
    public void clearCheckbox()          
    {
        this.bussPlan.Is_Incubate_Product__c=false;      
    }
    //samap01 us293050 US293051
    public void getIsGeoAccount()
    {          
        if(isClonedBP)
        {
            
            //samap01 US293050
            System.debug('samap01 get geo value :'+isGeoAccount);  
            if(ShowIncentivesection == true)
            {
                if (String.isBlank(myAccount.Included_in_BP_of_CA_AccountID__c))
                { 
                    //US324464 - SAMAP01 
                    if(myAccount.Alliance_Program_Level__c == 'Global' || myAccount.Service_Provider_Program_level__c == 'Global' || myAccount.Solution_Provider_Program_Level__c == 'Global')
                    {
                        this.isGeoAccount= true;
                        this.clonedBP.Is_Geo_Account__c = true;
                    }
                }
                System.debug('Is GEO :'+isGeoAccount);  
                //samap01 US293050  
            }
            else
            {
                this.isGeoAccount= false;
                this.clonedBP.Is_Geo_Account__c = false;                
            }
        }
        else{
            //String Iyear =this.BussPlan.Plan_Fiscal_Year__c;
            //String IncentiveplanYear = Iyear.removeStart('FY ');
            //Integer IntegerPlanyear = integer.valueof(IncentiveplanYear);
            
            //samap01 US293050
            System.debug('samap01 get geo value :'+isGeoAccount);  
            if(ShowIncentivesection == true)
            {
                if (String.isBlank(myAccount.Included_in_BP_of_CA_AccountID__c))
                {
                    if(this.BussPlan.Alliance_Program_Level__c == 'Global' || this.BussPlan.Service_Provider_Program_level__c == 'Global' || this.BussPlan.Solution_Provider_Program_Level__c == 'Global')
                    {
                        this.isGeoAccount= true;
                        this.BussPlan.Is_Geo_Account__c = true;                        
                    }  
                }
                System.debug('Is GEO :'+isGeoAccount);  
                //samap01 US293050  
            }
            else
            {
                this.isGeoAccount= false;
                this.BussPlan.Is_Geo_Account__c = false;                
            }
        }
        
        
    }
    
    public void AddProduct()
    {
        System.debug('AddProduct() SolutionRTM:'+SolutionRTM);
        //samap01 -US293050 
       //  getIsGeoAccount(); //ponse01 FY19- US457757
        if(AddedPGs == null)
        {
            AddedPGs = new List<ProductGroup>();
        }
        solutionCounter = solutionCounter + 1;
        
        if(SolutionRTM== 'Alliance')
        {
            allianceBookingExists = true;
        }
        else if(SolutionRTM== 'Solution Provider')
        {
            SolProBookingExists = true;
            
        }
        else if(SolutionRTM== 'Service Provider')
        {
            SerProBookingExists = true;
            
        }
        
        //SAMAP01 - US293050 & US293051
        if(isGeoAccount)
        {
            if(SolutionRTM=='--Select--' || SolutionBU=='--Select--')
            {
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_14));          
                return;
            }   
        }
        else
        {
            if(SolutionRTM=='--Select--' || SolutionBU=='--Select--' || SolutionPG=='--Select--')
            {
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_14));          
                return;
            } 
        }
        
        for(ProductGroup tmpPG : AddedPGs)
        {
            if(isGeoAccount)
            {
                if((SolutionRTM==tmpPG.myRTM) && (SolutionBU==tmpPG.myBU))
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_BU)); //samap01 -business unit duplicate         
                    return;            
                }
            }
            else
            {
                if((SolutionRTM==tmpPG.myRTM) && (SolutionBU==tmpPG.myBU) && (SolutionPG==tmpPG.myPG))
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_16));          
                    return;            
                }
            }
        }
        if(this.bussPlan.Is_Incubate_Product__c) 
        {
            Is_Incubate_Product= 'Yes';
        }
        else
        {
            Is_Incubate_Product = 'No';
        }
        //SAMAP01 - US293050 & US293051
        ProductGroup newPG;
        String JSO_Name ='';
        if(isClonedBP)
        {
            JSO_Name=this.clonedBP.JSO_Name__c;
        }
        else
        {
            JSO_Name= this.BussPlan.JSO_Name__c;
        }
        
        if(isGeoAccount==true && SolutionPG=='--Select--')
        {
            SolutionPG= '';
            newPG = new ProductGroup(solutionCounter, SolutionRTM, SolutionBU, SolutionPG, JSO_Name,'');
        }
        else
        {
            
            newPG = new ProductGroup(solutionCounter, SolutionRTM, SolutionBU, SolutionPG, JSO_Name,Is_Incubate_Product);
        }
        //samap01 -10/31/2016 - US238106
        // ProductGroup newPG = new ProductGroup(solutionCounter, SolutionRTM, SolutionBU, SolutionPG, this.BussPlan.JSO_Name__c,this.bussPlan.Is_Incubate_Product__c);
        AddedPGs.add(newPG);                
        this.BussPlan.JSO_Name__c='';
        if(isclonedBP)
        {
            this.clonedBP.JSO_Name__c='';
        }     
        isAddDisabled = true;        
        this.bussPlan.Is_Incubate_Product__c=false;
        Is_Incubate_Product ='No';
        // samap01 US329334
        if(IsGeoAccount)
        {
           addedPGSoln.add(newPG.myBU); //MANAR08  
        }
        else
        {
           addedPGSoln.add(newPG.myPG); //MANAR08  
        }
       
    }
    
    
    
    
    /*public void AddBookingTarget()
{
if(selectedRevType == 'PNCV')
{
ProductGroup pg = getRelatedPG();
pg.AddPNCVTarget(revQ1, revQ2, revQ3, revQ4);
currentBookingRow = pg;
}
else if(selectedRevType == 'SNCV')
{
ProductGroup pg = getRelatedPG();
pg.AddSNCVTarget(revQ1, revQ2, revQ3, revQ4);        
currentBookingRow = pg;
}
else if(selectedRevType == 'ENCV')
{
ProductGroup pg = getRelatedPG();
pg.AddENCVTarget(revQ1, revQ2, revQ3, revQ4);        
currentBookingRow = pg;
}

PNCVQ1Total = 0;
PNCVQ2Total = 0;
PNCVQ3Total = 0;
PNCVQ4Total = 0;
SNCVQ1Total = 0;
SNCVQ2Total = 0;
SNCVQ3Total = 0;
SNCVQ4Total = 0;
ENCVQ1Total = 0;
ENCVQ2Total = 0;
ENCVQ3Total = 0;
ENCVQ4Total = 0;
pncvGrantTotal = 0;
sncvGrantTotal = 0;
encvGrantTotal = 0;
BookingQ1Total = 0;            
BookingQ2Total = 0;
BookingQ3Total = 0;
BookingQ4Total = 0;
BookingGrandTotal = 0;                            
}*/
    
    //samap01 - US293050 & US293051
    // Get BU if geoAccount
    public ProductGroup getRelatedBU()
    {
        ProductGroup retPG;
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == TrainingRTM && pg.myBU == TrainingBU)//Amasa03-supercare issue
            {
                retPG = pg;
                break;
            }
        }
        return retPG;
    }   
    public ProductGroup getRelatedPG()
    {
        ProductGroup retPG;
        for(ProductGroup pg : AddedPGs)
        {          
            
            if(pg.myRTM == TrainingRTM && pg.myPG == TrainingPG)
            {
                retPG = pg;
                break;
            }
            
            
        }
        return retPG;
    }   
    
    
    
    public class BPTrainingContact
    {
        public Contact myTrainingContact {get; set;}
        public String myResourceType {get; set;}
        
        public BPTrainingContact(Contact c, String rt)
        {
            myTrainingContact = c;
            myResourceType = rt;
        }
    }
    
    public class ProductGroup
    {
        public String myRTM {get; set;}
        public String myBU {get; set;}
        public String myPG {get; set;}
        public String myJSO {get; set;}   
        public Integer counter {get; set;}
        public String Is_Incubate_Product {get; set;}  //SAMAP01 -10/31 -US238106
        public String GeoCountry {get;set;} //SAMAP01 US293050 & US293051
        public Decimal PQ1 {get; set;}
        public Decimal PQ2 {get; set;}
        public Decimal PQ3 {get; set;}
        public Decimal PQ4 {get; set;}
        public Decimal SQ1 {get; set;}
        public Decimal SQ2 {get; set;}
        public Decimal SQ3 {get; set;}
        public Decimal SQ4 {get; set;}
        public Decimal EQ1 {get; set;}
        public Decimal EQ2 {get; set;}
        public Decimal EQ3 {get; set;}
        public Decimal EQ4 {get; set;}
        public Decimal PNCVTotal {get; set;}
        public Decimal SNCVTotal {get; set;}
        public Decimal ENCVTotal {get; set;}
        
        public Decimal PNCVTotalInitial {get; set;}
        public Decimal SNCVTotalInitial {get; set;}
        public Decimal ENCVTotalInitial {get; set;}
        
        public Integer Implementation {get;set;} 
        public Integer Sales {get;set;} 
        public Integer Support {get;set;} 
        public Integer PreSales {get;set;} 
        public Integer Architect {get;set;} 
        public Integer EnablementSponsor {get;set;}
        public Integer SalesOther {get;set;}
        public Integer PreSalesOther {get;set;}
        public Integer ArchitectOther {get;set;}
        public Integer ImplementationOther {get;set;}
        public Integer SupportOther {get;set;}
        public Integer Other {get;set;}
        public Boolean IsGeoAccount {get;set;}  //SAMAP01
        
        public List<BP_Training_Contact__c> myBPTrainingContacts {get; set;}
        //SAMAP01 -10/31 -US238106
        // public ProductGroup(Integer i, String val1, String val2, String val3, String val4,Boolean val5)
        // SAMAP01 - US293050 & US293051
        public ProductGroup(Integer i, String val1, String val2, String val3, String val4,String val5)
            //    public ProductGroup(Integer i, String val1, String val2, String val3, String val4)//, BPTrainingContact bpC)
            
        {
            counter = i;
            myRTM = val1;
            myBU = val2;
            myPG = val3;
            myJSO = val4;  
            Is_Incubate_Product=  val5;  // ? "yes" : "no"; //SAMAP01 -10/31 -US238106  trueOrFalse ? "yes" : "no";
            
            PQ1 = 0;
            PQ2 = 0;
            PQ3 = 0;
            PQ4 = 0;
            SQ1 = 0;
            SQ2 = 0;
            SQ3 = 0;
            SQ4 = 0;
            EQ1 = 0;
            EQ2 = 0;
            EQ3 = 0;
            EQ4 = 0;
            myBPTrainingContacts = new List<BP_Training_Contact__c>();
            Implementation= 0;
            Sales= 0;
            Support= 0;
            PreSales= 0;
            Architect=  0;
            EnablementSponsor = 0;
            SalesOther = 0;
            PreSalesOther = 0;
            ArchitectOther = 0;
            ImplementationOther = 0;
            SupportOther = 0;
            Other= 0;            
            
            
            
            PNCVTotal =0.00;
            SNCVTotal =0.00;
            ENCVTotal=0.00;
        }
        
        public void AddBPTrainingContacts (BP_Training_Contact__c bpc)
        {
            myBPTrainingContacts.add(bpc);
        }
        
        public void AddBPTrainingContactsList (List<BP_Training_Contact__c> bpcList)
        {
            myBPTrainingContacts = bpcList;
        }        
        
        public void AddPNCVTarget(Decimal Q1, Decimal Q2, Decimal Q3, Decimal Q4)
        {
            PQ1 = Q1;
            PQ2 = Q2;
            PQ3 = Q3;
            PQ4 = Q4;
            PNCVTotal = Q1 + Q2 + Q3 + Q4;
        }
        
        public void AddSNCVTarget(Decimal Q1, Decimal Q2, Decimal Q3, Decimal Q4)
        {
            SQ1 = Q1;
            SQ2 = Q2;
            SQ3 = Q3;
            SQ4 = Q4;
            SNCVTotal = Q1 + Q2 + Q3 + Q4;            
        }
        
        public void AddENCVTarget(Decimal Q1, Decimal Q2, Decimal Q3, Decimal Q4)
        {
            EQ1 = Q1;
            EQ2 = Q2;
            EQ3 = Q3;
            EQ4 = Q4;
            ENCVTotal = Q1 + Q2 + Q3 + Q4;            
        }    
        
        public void TotalResources(){
            
            for(BP_Training_Contact__c btc : myBPTrainingContacts)
            {
                
                if(btc.Contact__c != null)
                {
                    
                    if(btc.Resource_Type__c == 'Implementation')
                        Implementation++;
                    else if(btc.Resource_Type__c == 'Sales')
                        Sales++;
                    else if(btc.Resource_Type__c == 'Support')
                        Support++;
                    else if(btc.Resource_Type__c == 'Pre-Sales')
                        PreSales++;
                    else if(btc.Resource_Type__c == 'Architect')
                        Architect++;
                    else if(btc.Resource_Type__c == 'Enablement Sponsor')
                        EnablementSponsor++;
                    else if(btc.Resource_Type__c == 'Sales Other')
                        SalesOther++;
                    else if(btc.Resource_Type__c == 'Pre-Sales Other')
                        PreSalesOther++;
                    else if(btc.Resource_Type__c == 'Architect Other')
                        ArchitectOther++;
                    else if(btc.Resource_Type__c == 'Implementation Other')
                        ImplementationOther++;
                    else if(btc.Resource_Type__c == 'Support Other')
                        SupportOther++;
                    else if(btc.Resource_Type__c == 'Other')
                        Other++;
                    
                    
                }
            }  
        }          
    } 
    
    public List<ProductGroup> getAlliancePGs()
    {
        List<ProductGroup> alliancePGs = new List<ProductGroup>();
        
        allianceBookingQ1Total = 0;
        allianceBookingQ2Total = 0;
        allianceBookingQ3Total = 0;
        allianceBookingQ4Total = 0;
        
        AlliancePNCVQ1Total = 0;
        AlliancePNCVQ2Total = 0;
        AlliancePNCVQ3Total = 0;
        AlliancePNCVQ4Total = 0;                     
        
        AllianceSNCVQ1Total = 0;
        AllianceSNCVQ2Total = 0;
        AllianceSNCVQ3Total = 0;
        AllianceSNCVQ4Total = 0;                     
        
        AllianceENCVQ1Total = 0;
        AllianceENCVQ2Total = 0;
        AllianceENCVQ3Total = 0;
        AllianceENCVQ4Total = 0;
        
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == 'Alliance')
            {
                alliancePGs.add(pg);
                allianceBookingExists = true;
                allianceBookingQ1Total = allianceBookingQ1Total  + pg.PQ1 + pg.SQ1 + pg.EQ1;
                allianceBookingQ2Total = allianceBookingQ2Total  + pg.PQ2 + pg.SQ2 + pg.EQ2;
                allianceBookingQ3Total = allianceBookingQ3Total  + pg.PQ3 + pg.SQ3 + pg.EQ3;
                allianceBookingQ4Total = allianceBookingQ4Total  + pg.PQ4 + pg.SQ4 + pg.EQ4; 
                
                AlliancePNCVQ1Total = AlliancePNCVQ1Total + pg.PQ1;
                AlliancePNCVQ2Total = AlliancePNCVQ2Total + pg.PQ2;
                AlliancePNCVQ3Total = AlliancePNCVQ3Total + pg.PQ3;
                AlliancePNCVQ4Total = AlliancePNCVQ4Total + pg.PQ4; 
                
                AllianceSNCVQ1Total = AllianceSNCVQ1Total + pg.SQ1;
                AllianceSNCVQ2Total = AllianceSNCVQ2Total + pg.SQ2;
                AllianceSNCVQ3Total = AllianceSNCVQ3Total + pg.SQ3;
                AllianceSNCVQ4Total = AllianceSNCVQ4Total + pg.SQ4;
                
                AllianceENCVQ1Total = AllianceENCVQ1Total + pg.EQ1;
                AllianceENCVQ2Total = AllianceENCVQ2Total + pg.EQ2;
                AllianceENCVQ3Total = AllianceENCVQ3Total + pg.EQ3;
                AllianceENCVQ4Total = AllianceENCVQ4Total + pg.EQ4; 
                
                pg.PNCVTotal = pg.PQ1 + pg.PQ2 + pg.PQ3 + pg.PQ4;                                                                                      
                pg.SNCVTotal = pg.SQ1 + pg.SQ2 + pg.SQ3 + pg.SQ4;                                                                                      
                pg.ENCVTotal = pg.EQ1 + pg.EQ2 + pg.EQ3 + pg.EQ4;  
                
                if(pg.PNCVTotalInitial == null)
                    pg.PNCVTotalInitial = pg.PNCVTotal;
                
                if(pg.SNCVTotalInitial == null)
                    pg.SNCVTotalInitial = pg.SNCVTotal;
                
                if(pg.ENCVTotalInitial == null)
                    pg.ENCVTotalInitial = pg.ENCVTotal;
                
            }
        }
        
        allianceTotal = allianceBookingQ1Total + allianceBookingQ2Total + allianceBookingQ3Total+ allianceBookingQ4Total;
        
        if(allianceTotalInitial == null)
            allianceTotalInitial = allianceTotal;
        
        allianceTotalLatest = allianceTotal;
        AlliancePNCVTotal = AlliancePNCVQ1Total + AlliancePNCVQ2Total + AlliancePNCVQ3Total+ AlliancePNCVQ4Total;
        AllianceSNCVTotal = AllianceSNCVQ1Total + AllianceSNCVQ2Total + AllianceSNCVQ3Total+ AllianceSNCVQ4Total;
        AllianceENCVTotal = AllianceENCVQ1Total + AllianceENCVQ2Total + AllianceENCVQ3Total+ AllianceENCVQ4Total;
        
        BookingQ1Total = allianceBookingQ1Total + SolProBookingQ1Total + SerProBookingQ1Total + DMBookingQ1Total;            
        BookingQ2Total = allianceBookingQ2Total + SolProBookingQ2Total + SerProBookingQ2Total + DMBookingQ2Total;
        BookingQ3Total = allianceBookingQ3Total + SolProBookingQ3Total + SerProBookingQ3Total + DMBookingQ3Total;
        BookingQ4Total = allianceBookingQ4Total + SolProBookingQ4Total + SerProBookingQ4Total + DMBookingQ4Total;
        BookingGrandTotal = BookingQ1Total + BookingQ2Total + BookingQ3Total + BookingQ4Total;       
        //BookingGrandTotal = BookingGrandTotal + allianceBookingQ1Total+ allianceBookingQ2Total+ allianceBookingQ3Total+ allianceBookingQ4Total; 
        
        PNCVQ1Total = AlliancePNCVQ1Total + SolProPNCVQ1Total + SerProPNCVQ1Total + DMPNCVQ1Total;
        PNCVQ2Total = AlliancePNCVQ2Total + SolProPNCVQ2Total + SerProPNCVQ2Total + DMPNCVQ2Total;
        PNCVQ3Total = AlliancePNCVQ3Total + SolProPNCVQ3Total + SerProPNCVQ3Total + DMPNCVQ3Total;
        PNCVQ4Total = AlliancePNCVQ4Total + SolProPNCVQ4Total + SerProPNCVQ4Total + DMPNCVQ4Total;              
        
        SNCVQ1Total = AllianceSNCVQ1Total + SolProSNCVQ1Total + SerProSNCVQ1Total + DMSNCVQ1Total;
        SNCVQ2Total = AllianceSNCVQ2Total + SolProSNCVQ2Total + SerProSNCVQ2Total + DMSNCVQ2Total;
        SNCVQ3Total = AllianceSNCVQ3Total + SolProSNCVQ3Total + SerProSNCVQ3Total + DMSNCVQ3Total;
        SNCVQ4Total = AllianceSNCVQ4Total + SolProSNCVQ4Total + SerProSNCVQ4Total + DMSNCVQ4Total;
        
        ENCVQ1Total = AllianceENCVQ1Total + SolProENCVQ1Total + SerProENCVQ1Total + DMENCVQ1Total;
        ENCVQ2Total = AllianceENCVQ2Total + SolProENCVQ2Total + SerProENCVQ2Total + DMENCVQ2Total;
        ENCVQ3Total = AllianceENCVQ3Total + SolProENCVQ3Total + SerProENCVQ3Total + DMENCVQ3Total;
        ENCVQ4Total = AllianceENCVQ4Total + SolProENCVQ4Total + SerProENCVQ4Total + DMENCVQ4Total;       
        
        pncvGrantTotal = AlliancePNCVTotal + SolProPNCVTotal + SerProPNCVTotal + DMPNCVTotal;
        sncvGrantTotal = AllianceSNCVTotal + SolProSNCVTotal + SerProSNCVTotal + DMSNCVTotal;
        encvGrantTotal = AllianceENCVTotal + SolProENCVTotal + SerProENCVTotal + DMENCVTotal;       
        
        return alliancePGs;
    }
    
    public List<ProductGroup> getSolProPGs()
    {
        List<ProductGroup> SolProPGs = new List<ProductGroup>();
        
        SolProBookingQ1Total = 0;
        SolProBookingQ2Total = 0;
        SolProBookingQ3Total = 0;
        SolProBookingQ4Total = 0;  
        
        SolProPNCVQ1Total = 0;
        SolProPNCVQ2Total = 0;
        SolProPNCVQ3Total = 0;
        SolProPNCVQ4Total = 0; 
        
        SolProSNCVQ1Total = 0;
        SolProSNCVQ2Total = 0;
        SolProSNCVQ3Total = 0;
        SolProSNCVQ4Total = 0; 
        
        SolProENCVQ1Total = 0;
        SolProENCVQ2Total = 0;
        SolProENCVQ3Total = 0;
        SolProENCVQ4Total = 0;                                   
        
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == 'Solution Provider')
            {
                SolProPGs.add(pg);
                SolProBookingExists = true;
                SolProBookingQ1Total = SolProBookingQ1Total  + pg.PQ1 + pg.SQ1 + pg.EQ1;               
                SolProBookingQ2Total = SolProBookingQ2Total  + pg.PQ2 + pg.SQ2 + pg.EQ2;               
                SolProBookingQ3Total = SolProBookingQ3Total  + pg.PQ3 + pg.SQ3 + pg.EQ3;               
                SolProBookingQ4Total = SolProBookingQ4Total  + pg.PQ4 + pg.SQ4 + pg.EQ4;
                
                SolProPNCVQ1Total = SolProPNCVQ1Total + pg.PQ1;
                SolProPNCVQ2Total = SolProPNCVQ2Total + pg.PQ2;
                SolProPNCVQ3Total = SolProPNCVQ3Total + pg.PQ3;
                SolProPNCVQ4Total = SolProPNCVQ4Total + pg.PQ4;  
                
                SolProSNCVQ1Total = SolProSNCVQ1Total + pg.SQ1;
                SolProSNCVQ2Total = SolProSNCVQ2Total + pg.SQ2;
                SolProSNCVQ3Total = SolProSNCVQ3Total + pg.SQ3;
                SolProSNCVQ4Total = SolProSNCVQ4Total + pg.SQ4;
                
                SolProENCVQ1Total = SolProENCVQ1Total + pg.EQ1;
                SolProENCVQ2Total = SolProENCVQ2Total + pg.EQ2;
                SolProENCVQ3Total = SolProENCVQ3Total + pg.EQ3;
                SolProENCVQ4Total = SolProENCVQ4Total + pg.EQ4;  
                
                pg.PNCVTotal = pg.PQ1 + pg.PQ2 + pg.PQ3 + pg.PQ4;                                                                                      
                pg.SNCVTotal = pg.SQ1 + pg.SQ2 + pg.SQ3 + pg.SQ4;                                                                                      
                pg.ENCVTotal = pg.EQ1 + pg.EQ2 + pg.EQ3 + pg.EQ4;      
                
                if(pg.PNCVTotalInitial == null)
                    pg.PNCVTotalInitial = pg.PNCVTotal;
                
                if(pg.SNCVTotalInitial == null)
                    pg.SNCVTotalInitial = pg.SNCVTotal;
                
                if(pg.ENCVTotalInitial == null)
                    pg.ENCVTotalInitial = pg.ENCVTotal;
                
            }
        }
        SolProTotal = SolProBookingQ1Total + SolProBookingQ2Total + SolProBookingQ3Total+ SolProBookingQ4Total; 
        
        if(SolProTotalInitial == null)
            SolProTotalInitial = SolProTotal;
        
        SolProTotalLatest = SolProTotal;
        SolProPNCVTotal =  SolProPNCVQ1Total + SolProPNCVQ2Total + SolProPNCVQ3Total + SolProPNCVQ4Total; 
        SolProSNCVTotal =  SolProSNCVQ1Total + SolProSNCVQ2Total + SolProSNCVQ3Total + SolProSNCVQ4Total;
        SolProENCVTotal =  SolProENCVQ1Total + SolProENCVQ2Total + SolProENCVQ3Total + SolProENCVQ4Total;
        
        BookingQ1Total = allianceBookingQ1Total + SolProBookingQ1Total + SerProBookingQ1Total + DMBookingQ1Total;            
        BookingQ2Total = allianceBookingQ2Total + SolProBookingQ2Total + SerProBookingQ2Total + DMBookingQ2Total;
        BookingQ3Total = allianceBookingQ3Total + SolProBookingQ3Total + SerProBookingQ3Total + DMBookingQ3Total;
        BookingQ4Total = allianceBookingQ4Total + SolProBookingQ4Total + SerProBookingQ4Total + DMBookingQ4Total;
        BookingGrandTotal = BookingQ1Total + BookingQ2Total + BookingQ3Total + BookingQ4Total;
        //BookingGrandTotal = BookingGrandTotal + SolProBookingQ1Total+ SolProBookingQ2Total+ SolProBookingQ3Total+ SolProBookingQ4Total;         
        
        PNCVQ1Total = AlliancePNCVQ1Total + SolProPNCVQ1Total + SerProPNCVQ1Total + DMPNCVQ1Total;
        PNCVQ2Total = AlliancePNCVQ2Total + SolProPNCVQ2Total + SerProPNCVQ2Total + DMPNCVQ2Total;
        PNCVQ3Total = AlliancePNCVQ3Total + SolProPNCVQ3Total + SerProPNCVQ3Total + DMPNCVQ3Total;
        PNCVQ4Total = AlliancePNCVQ4Total + SolProPNCVQ4Total + SerProPNCVQ4Total + DMPNCVQ4Total;              
        
        SNCVQ1Total = AllianceSNCVQ1Total + SolProSNCVQ1Total + SerProSNCVQ1Total + DMSNCVQ1Total;
        SNCVQ2Total = AllianceSNCVQ2Total + SolProSNCVQ2Total + SerProSNCVQ2Total + DMSNCVQ2Total;
        SNCVQ3Total = AllianceSNCVQ3Total + SolProSNCVQ3Total + SerProSNCVQ3Total + DMSNCVQ3Total;
        SNCVQ4Total = AllianceSNCVQ4Total + SolProSNCVQ4Total + SerProSNCVQ4Total + DMSNCVQ4Total;
        
        ENCVQ1Total = AllianceENCVQ1Total + SolProENCVQ1Total + SerProENCVQ1Total + DMENCVQ1Total;
        ENCVQ2Total = AllianceENCVQ2Total + SolProENCVQ2Total + SerProENCVQ2Total + DMENCVQ2Total;
        ENCVQ3Total = AllianceENCVQ3Total + SolProENCVQ3Total + SerProENCVQ3Total + DMENCVQ3Total;
        ENCVQ4Total = AllianceENCVQ4Total + SolProENCVQ4Total + SerProENCVQ4Total + DMENCVQ4Total;
        
        pncvGrantTotal = AlliancePNCVTotal + SolProPNCVTotal + SerProPNCVTotal + DMPNCVTotal;
        sncvGrantTotal = AllianceSNCVTotal + SolProSNCVTotal + SerProSNCVTotal + DMSNCVTotal;
        encvGrantTotal = AllianceENCVTotal + SolProENCVTotal + SerProENCVTotal + DMENCVTotal;
        
        return SolProPGs;
    }
    
    public List<ProductGroup> getSerProPGs()
    {
        List<ProductGroup> SerProPGs = new List<ProductGroup>();
        
        SerProBookingQ1Total = 0;
        SerProBookingQ2Total = 0;
        SerProBookingQ3Total = 0;
        SerProBookingQ4Total = 0;  
        
        SerProPNCVQ1Total = 0;     
        SerProPNCVQ2Total = 0;
        SerProPNCVQ3Total = 0;
        SerProPNCVQ4Total = 0; 
        
        SerProSNCVQ1Total = 0;     
        SerProSNCVQ2Total = 0;
        SerProSNCVQ3Total = 0;
        SerProSNCVQ4Total = 0;
        
        SerProENCVQ1Total = 0;     
        SerProENCVQ2Total = 0;
        SerProENCVQ3Total = 0;
        SerProENCVQ4Total = 0;                                  
        
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == 'Service Provider')
            {
                SerProPGs.add(pg);
                SerProBookingExists = true; 
                SerProBookingQ1Total = SerProBookingQ1Total  + pg.PQ1 + pg.SQ1 + pg.EQ1;                                            
                SerProBookingQ2Total = SerProBookingQ2Total  + pg.PQ2 + pg.SQ2 + pg.EQ2;                                            
                SerProBookingQ3Total = SerProBookingQ3Total  + pg.PQ3 + pg.SQ3 + pg.EQ3;                                            
                SerProBookingQ4Total = SerProBookingQ4Total  + pg.PQ4 + pg.SQ4 + pg.EQ4; 
                
                SerProPNCVQ1Total = SerProPNCVQ1Total + pg.PQ1;
                SerProPNCVQ2Total = SerProPNCVQ2Total + pg.PQ2;
                SerProPNCVQ3Total = SerProPNCVQ3Total + pg.PQ3;
                SerProPNCVQ4Total = SerProPNCVQ4Total + pg.PQ4; 
                
                SerProSNCVQ1Total = SerProSNCVQ1Total + pg.SQ1;
                SerProSNCVQ2Total = SerProSNCVQ2Total + pg.SQ2;
                SerProSNCVQ3Total = SerProSNCVQ3Total + pg.SQ3;
                SerProSNCVQ4Total = SerProSNCVQ4Total + pg.SQ4;
                
                SerProENCVQ1Total = SerProENCVQ1Total + pg.EQ1;
                SerProENCVQ2Total = SerProENCVQ2Total + pg.EQ2;
                SerProENCVQ3Total = SerProENCVQ3Total + pg.EQ3;
                SerProENCVQ4Total = SerProENCVQ4Total + pg.EQ4; 
                
                pg.PNCVTotal = pg.PQ1 + pg.PQ2 + pg.PQ3 + pg.PQ4;                                                                                      
                pg.SNCVTotal = pg.SQ1 + pg.SQ2 + pg.SQ3 + pg.SQ4;                                                                                      
                pg.ENCVTotal = pg.EQ1 + pg.EQ2 + pg.EQ3 + pg.EQ4;        
                
                if(pg.PNCVTotalInitial == null)
                    pg.PNCVTotalInitial = pg.PNCVTotal;
                
                if(pg.SNCVTotalInitial == null)
                    pg.SNCVTotalInitial = pg.SNCVTotal;
                
                if(pg.ENCVTotalInitial == null)
                    pg.ENCVTotalInitial = pg.ENCVTotal;
                
            }
        }
        SerProTotal = SerProBookingQ1Total + SerProBookingQ2Total + SerProBookingQ3Total+ SerProBookingQ4Total;
        
        if(SerProTotalInitial == null)
            SerProTotalInitial = SerProTotal;
        
        SerProTotalLatest = SerProTotal;
        SerProPNCVTotal =  SerProPNCVQ1Total + SerProPNCVQ2Total + SerProPNCVQ3Total + SerProPNCVQ4Total;
        SerProSNCVTotal =  SerProSNCVQ1Total + SerProSNCVQ2Total + SerProSNCVQ3Total + SerProSNCVQ4Total; 
        SerProENCVTotal =  SerProENCVQ1Total + SerProENCVQ2Total + SerProENCVQ3Total + SerProENCVQ4Total; 
        
        BookingQ1Total = allianceBookingQ1Total + SolProBookingQ1Total + SerProBookingQ1Total + DMBookingQ1Total;            
        BookingQ2Total = allianceBookingQ2Total + SolProBookingQ2Total + SerProBookingQ2Total + DMBookingQ2Total;
        BookingQ3Total = allianceBookingQ3Total + SolProBookingQ3Total + SerProBookingQ3Total + DMBookingQ3Total;
        BookingQ4Total = allianceBookingQ4Total + SolProBookingQ4Total + SerProBookingQ4Total + DMBookingQ4Total;
        BookingGrandTotal = BookingQ1Total + BookingQ2Total + BookingQ3Total + BookingQ4Total;
        //BookingGrandTotal = BookingGrandTotal + SerProBookingQ1Total+ SerProBookingQ2Total+ SerProBookingQ3Total+ SerProBookingQ4Total;       
        
        PNCVQ1Total = AlliancePNCVQ1Total + SolProPNCVQ1Total + SerProPNCVQ1Total + DMPNCVQ1Total;
        PNCVQ2Total = AlliancePNCVQ2Total + SolProPNCVQ2Total + SerProPNCVQ2Total + DMPNCVQ2Total;
        PNCVQ3Total = AlliancePNCVQ3Total + SolProPNCVQ3Total + SerProPNCVQ3Total + DMPNCVQ3Total;
        PNCVQ4Total = AlliancePNCVQ4Total + SolProPNCVQ4Total + SerProPNCVQ4Total + DMPNCVQ4Total;              
        
        SNCVQ1Total = AllianceSNCVQ1Total + SolProSNCVQ1Total + SerProSNCVQ1Total + DMSNCVQ1Total;
        SNCVQ2Total = AllianceSNCVQ2Total + SolProSNCVQ2Total + SerProSNCVQ2Total + DMSNCVQ2Total;
        SNCVQ3Total = AllianceSNCVQ3Total + SolProSNCVQ3Total + SerProSNCVQ3Total + DMSNCVQ3Total;
        SNCVQ4Total = AllianceSNCVQ4Total + SolProSNCVQ4Total + SerProSNCVQ4Total + DMSNCVQ4Total;
        
        ENCVQ1Total = AllianceENCVQ1Total + SolProENCVQ1Total + SerProENCVQ1Total + DMENCVQ1Total;
        ENCVQ2Total = AllianceENCVQ2Total + SolProENCVQ2Total + SerProENCVQ2Total + DMENCVQ2Total;
        ENCVQ3Total = AllianceENCVQ3Total + SolProENCVQ3Total + SerProENCVQ3Total + DMENCVQ3Total;
        ENCVQ4Total = AllianceENCVQ4Total + SolProENCVQ4Total + SerProENCVQ4Total + DMENCVQ4Total;
        
        pncvGrantTotal = AlliancePNCVTotal + SolProPNCVTotal + SerProPNCVTotal + DMPNCVTotal;
        sncvGrantTotal = AllianceSNCVTotal + SolProSNCVTotal + SerProSNCVTotal + DMSNCVTotal;
        encvGrantTotal = AllianceENCVTotal + SolProENCVTotal + SerProENCVTotal + DMENCVTotal;
        
        return SerProPGs;
    }
    
    public List<ProductGroup> getDMPGs()
    {
        List<ProductGroup> dmPGs = new List<ProductGroup>();
        
        DMBookingQ1Total = 0;
        DMBookingQ2Total = 0;
        DMBookingQ3Total = 0;
        DMBookingQ4Total = 0;
        
        DMPNCVQ1Total = 0;
        DMPNCVQ2Total = 0;
        DMPNCVQ3Total = 0;
        DMPNCVQ4Total = 0;  
        
        DMSNCVQ1Total = 0;
        DMSNCVQ2Total = 0;
        DMSNCVQ3Total = 0;
        DMSNCVQ4Total = 0;
        
        DMENCVQ1Total = 0;
        DMENCVQ2Total = 0;
        DMENCVQ3Total = 0;
        DMENCVQ4Total = 0;                          
        
        for(ProductGroup pg : AddedPGs)
        {
            
        }
        DMTotal = DMBookingQ1Total + DMBookingQ2Total + DMBookingQ3Total+ DMBookingQ4Total;
        
        if(DMTotalInitial == null)
            DMTotalInitial = DMTotal;
        
        DMTotalLatest = DMTotal;
        DMPNCVTotal =  DMPNCVQ1Total + DMPNCVQ2Total + DMPNCVQ3Total + DMPNCVQ4Total;
        DMSNCVTotal =  DMSNCVQ1Total + DMSNCVQ2Total + DMSNCVQ3Total + DMSNCVQ4Total;
        DMENCVTotal =  DMENCVQ1Total + DMENCVQ2Total + DMENCVQ3Total + DMENCVQ4Total; 
        
        BookingQ1Total = allianceBookingQ1Total + SolProBookingQ1Total + SerProBookingQ1Total + DMBookingQ1Total;            
        BookingQ2Total = allianceBookingQ2Total + SolProBookingQ2Total + SerProBookingQ2Total + DMBookingQ2Total;
        BookingQ3Total = allianceBookingQ3Total + SolProBookingQ3Total + SerProBookingQ3Total + DMBookingQ3Total;
        BookingQ4Total = allianceBookingQ4Total + SolProBookingQ4Total + SerProBookingQ4Total + DMBookingQ4Total;
        BookingGrandTotal = BookingQ1Total + BookingQ2Total + BookingQ3Total + BookingQ4Total;
        //BookingGrandTotal = BookingGrandTotal + DMBookingQ1Total+ DMBookingQ2Total+ DMBookingQ3Total+ DMBookingQ4Total;              
        
        PNCVQ1Total = AlliancePNCVQ1Total + SolProPNCVQ1Total + SerProPNCVQ1Total + DMPNCVQ1Total;
        PNCVQ2Total = AlliancePNCVQ2Total + SolProPNCVQ2Total + SerProPNCVQ2Total + DMPNCVQ2Total;
        PNCVQ3Total = AlliancePNCVQ3Total + SolProPNCVQ3Total + SerProPNCVQ3Total + DMPNCVQ3Total;
        PNCVQ4Total = AlliancePNCVQ4Total + SolProPNCVQ4Total + SerProPNCVQ4Total + DMPNCVQ4Total;              
        
        SNCVQ1Total = AllianceSNCVQ1Total + SolProSNCVQ1Total + SerProSNCVQ1Total + DMSNCVQ1Total;
        SNCVQ2Total = AllianceSNCVQ2Total + SolProSNCVQ2Total + SerProSNCVQ2Total + DMSNCVQ2Total;
        SNCVQ3Total = AllianceSNCVQ3Total + SolProSNCVQ3Total + SerProSNCVQ3Total + DMSNCVQ3Total;
        SNCVQ4Total = AllianceSNCVQ4Total + SolProSNCVQ4Total + SerProSNCVQ4Total + DMSNCVQ4Total;
        
        ENCVQ1Total = AllianceENCVQ1Total + SolProENCVQ1Total + SerProENCVQ1Total + DMENCVQ1Total;
        ENCVQ2Total = AllianceENCVQ2Total + SolProENCVQ2Total + SerProENCVQ2Total + DMENCVQ2Total;
        ENCVQ3Total = AllianceENCVQ3Total + SolProENCVQ3Total + SerProENCVQ3Total + DMENCVQ3Total;
        ENCVQ4Total = AllianceENCVQ4Total + SolProENCVQ4Total + SerProENCVQ4Total + DMENCVQ4Total;
        
        pncvGrantTotal = AlliancePNCVTotal + SolProPNCVTotal + SerProPNCVTotal + DMPNCVTotal;
        sncvGrantTotal = AllianceSNCVTotal + SolProSNCVTotal + SerProSNCVTotal + DMSNCVTotal;
        encvGrantTotal = AllianceENCVTotal + SolProENCVTotal + SerProENCVTotal + DMENCVTotal;
        
        return dmPGs;
    }            
    
    public void delSolRow()
    {
      //samap01 -US329224
      // getIsGeoAccount(); //ponse01 FY19- US457757 
        if(isGeoAccount)
        {
               delPGSoln.add(AddedPGs.get(delSolutionCounter - 1).myBU); //MANAR08
        }
        else
        {
               delPGSoln.add(AddedPGs.get(delSolutionCounter - 1).myPG); //MANAR08
        }
     
        
        AddedPGs.remove(delSolutionCounter - 1);
        solutionCounter = 0;
        for(ProductGroup pg : AddedPGs)
        {
            solutionCounter = solutionCounter + 1;
            pg.counter = solutionCounter;
        }
    }
    
    public void delTrRow(List<ProductGroup> PGs)
    {
        ProductGroup myPG;
        delTrainingContact = new List<BP_Training_Contact__c>();
        for(ProductGroup pg : PGs)
        {
            if(pg.myPG == delTrainingPG)
            {
                myPG = pg;
                break;
            }
        }
        if(myPG != null)
        {
            List<BP_Training_Contact__c> contacts = myPG.myBPTrainingContacts;
            
            
            if(delTrainingContactMap.containsKey(myPG.myPG)){
                delTrainingContact = delTrainingContactMap.get(myPG.myPG);
                delTrainingContact.add(contacts.get(delTrainingKey));
                delTrainingContactMap.put(myPG.myPG,delTrainingContact);
            }
            else {
                delTrainingContact.add(contacts.get(delTrainingKey));
                delTrainingContactMap.put(myPG.myPG,delTrainingContact);
            }
            
            System.debug('delTrainingContactMap'+delTrainingContactMap);
            contacts.remove(delTrainingKey);
        }   
    }
    
    
    //samap01 - US293050 & 51 - No product group for geo account
    public void delGeoTrRow(List<ProductGroup> PGs)
    {
        ProductGroup myPG;
        delTrainingContact = new List<BP_Training_Contact__c>();
        for(ProductGroup pg : PGs)
        {
            if(pg.myBU == delTrainingBU)
            {
                myPG = pg;
                break;
            }
        }
        if(myPG != null)
        {
            List<BP_Training_Contact__c> contacts = myPG.myBPTrainingContacts;
            
            
            if(delTrainingContactMap.containsKey(myPG.myBU)){
                delTrainingContact = delTrainingContactMap.get(myPG.myBU);
                delTrainingContact.add(contacts.get(delTrainingKey));
                delTrainingContactMap.put(delTrainingPG,delTrainingContact);
            }
            else {
                delTrainingContact.add(contacts.get(delTrainingKey));
                delTrainingContactMap.put(delTrainingPG,delTrainingContact);
            }
            
            System.debug('delTrainingContactMap'+delTrainingContactMap);
            contacts.remove(delTrainingKey);
        }   
    }
    public void delAllTrRow()
    {
        tabChangeChecks(currentTab);
        List<ProductGroup> PGs = getTrAlliancePGs();
        if(isgeoAccount)
        {delGeoTrRow(PGs);
        }
        else
        { delTrRow(PGs);}
        
        
    }
    public void delSolTrRow()
    {
        tabChangeChecks(currentTab);
        List<ProductGroup> PGs = getTrSolProPGs();
        if(isgeoAccount)
        {delGeoTrRow(PGs);
        }
        else
        { delTrRow(PGs);}
    }
    public void delSerTrRow()
    {
        tabChangeChecks(currentTab);
        List<ProductGroup> PGs = getTrSerProPGs();
        if(isgeoAccount)
        {delGeoTrRow(PGs);
        }
        else
        { delTrRow(PGs);}
    }
    public void delDMTrRow()
    {
        tabChangeChecks(currentTab);
        List<ProductGroup> PGs = getTrDMPGs();
        if(isgeoAccount)
        {delGeoTrRow(PGs);
        }
        else
        { delTrRow(PGs);}
    }          
    
    public List<SelectOption> getTrainingRTMs()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--Select--','--Select--'));                           
        List<String> applicableRTMs = new List<String>();
        for(ProductGroup pg : AddedPGs)
        {
            applicableRTMs.add(pg.myRTM);
        }
        applicableRTMs.sort();        
        Set<String> uniqueApplicableRTMs = new set<String>();
        for(String tempRTM : applicableRTMs)
        {
            uniqueApplicableRTMs.add(tempRTM);
        }    
        
        for(String optRTM : uniqueApplicableRTMs)
        {
            options.add(new SelectOption(optRTM,optRTM));
        }   
        //        isAddDisabled = false; 
        options.sort();        
        return options;                     
    }
    
    /*public List<SelectOption> getBookingBUs()
{
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('--Select--','--Select--'));        
List<String> applicableBUs = new List<String>();
for(ProductGroup pg : AddedPGs)
{
if(pg.myRTM == BookingRTM)
{
applicableBUs.add(pg.myBU);
}
}
Set<String> uniqueApplicableBUs = new set<String>();
for(String tempBU : applicableBUs)
{
uniqueApplicableBUs.add(tempBU);
}    

for(String PA1 : uniqueApplicableBUs)
{
options.add(new SelectOption(PA1,PA1));
} 

return options;                     
}*/   
    
    public List<SelectOption> getTrainingPGs()
    {
        tabChangeChecks(currentTab);
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--Select--','--Select--'));        
        List<String> applicableProductGroups = new List<String>();                          
        Set<String> uniqueapplicableProductGroups = new set<String>();
        
        //samap01 US293050 & US293051
        // If isgeo account - get entire product list - Else get selected list
        if(isGeoAccount)
        {
            List<Product2> applicablePGs = [Select Product_Group__c from Product2 where Salesforce_CPQ_Product__c=false and Partner_Approved__c INCLUDES (:TrainingRTM) AND Market_Focus_Area__c=:TrainingBU];                          
            for(Product2 PA : applicablePGs)
            {
                uniqueapplicableProductGroups.add(PA.Product_Group__c);
            }    
            
            for(String PA1 : uniqueapplicableProductGroups)
            {
                options.add(new SelectOption(PA1,PA1));
            } 
            
            return options;            
        }
        else
        {
            for(ProductGroup pg : AddedPGs)
            {
                if(pg.myRTM == TrainingRTM)
                {
                    // IF(pg.myPG != '')  //samap01 -US293050 & US293051 - if product not selected for geo account do not add the blank value to resources tab
                    {
                        applicableProductGroups.add(pg.myPG);
                    }
                }
            }        
            applicableProductGroups.sort();
            for(String PA : applicableProductGroups)
            {
                uniqueapplicableProductGroups.add(PA);
            }    
            
            for(String PA1 : uniqueapplicableProductGroups)
            {
                options.add(new SelectOption(PA1,PA1));
            } 
            options.sort();          
            return options;                     
        }
        
    }    
    
    //samap01 -US293050 & US293051 
    public List<SelectOption> getTrainingBUs()
    {
        tabChangeChecks(currentTab);
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('--Select--','--Select--'));        
        List<String> applicableBUs = new List<String>();                          
        Set<String> uniqueapplicableBUs = new set<String>();
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == TrainingRTM)
            {
                // IF(pg.myPG != '')  //samap01 -US293050 & US293051 - if product not selected for geo account do not add the blank value to resources tab
                {
                    applicableBUs.add(pg.myBU);
                }
            }
        }        
        applicableBUs.sort();
        for(String PA : applicableBUs)
        {
            uniqueapplicableBUs.add(PA);
        }    
        
        for(String PA1 : uniqueapplicableBUs)
        {
            options.add(new SelectOption(PA1,PA1));
        } 
        options.sort();          
        return options;                     
        
    }
    //SAMAP01
    
    public void clearTrainingPG()          
    {
        tabChangeChecks(currentTab);
        TrainingPG = '--Select--';        
    }
    
    public List<SelectOption> getResourceTypes()
    {
        tabChangeChecks(currentTab);
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--Select--','--Select--'));
        options.add(new SelectOption('Architect','Architect'));
        options.add(new SelectOption('Architect Other','Architect Other')); 
        options.add(new SelectOption('Enablement Sponsor','Enablement Sponsor')); 
        options.add(new SelectOption('Implementation','Implementation'));
        options.add(new SelectOption('Implementation Other','Implementation Other'));
        options.add(new SelectOption('Pre-Sales','Pre-Sales'));
        options.add(new SelectOption('Pre-Sales Other','Pre-Sales Other'));
        options.add(new SelectOption('Sales','Sales'));
        options.add(new SelectOption('Sales Other','Sales Other'));
        options.add(new SelectOption('Support','Support'));
        options.add(new SelectOption('Support Other','Support Other'));

        options.add(new SelectOption('Other','Other')); 
        return options;                     
    } 
    
    public void AddTrainingRows()
    {
        tabChangeChecks(currentTab);
        Geocountries = getGeoAccountCountries(); //samap01
        System.debug('samap01 --- get geo countries ' +Geocountries);
        if(TrainingRTM=='--Select--' || TrainingRT=='--Select--' || TrainingCount == 0 || TrainingPG=='--Select--') //samap01 3/18/17 -trainingpg check added
        {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_18));          
            return;
        }
        //allha02 US166361  Increase count to 100               
        if(TrainingCount < 0 || TrainingCount > 100)
        {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_19));          
            return;
        }        
        
        addedTrainingContact = new List<BP_Training_Contact__c>();
        ProductGroup pg;
        if(isgeoaccount)
        {
            pg  = getRelatedBU();  
        }
        else
        {
            pg = getRelatedPG();
        }
        
        BP_Training_Contact__c bptc;
        for(Integer i = 0; i < TrainingCount; i++)
        {
            bptc = new BP_Training_Contact__c(resource_type__c=TrainingRT,product_group__c =TrainingPG);
            pg.AddBPTrainingContacts(bptc);
            addedTrainingContact.add(bptc);
        }  
        //SAMAP01 -US293050 & US293051
        if(isgeoaccount)
        {
            addedTrainingContactMap.put(TrainingPG,addedTrainingContact);  
        }
        else
        {
            if(addedTrainingContactMap.containskey(pg.myPG))
            {
                List<BP_Training_Contact__c> TrainingContacts = addedTrainingContactMap.get(pg.myPG);
                TrainingContacts.addAll(addedTrainingContact);
                addedTrainingContactMap.put(pg.myPG,TrainingContacts);
            }
            else
            {
                addedTrainingContactMap.put(pg.myPG,addedTrainingContact);
            }   
        }
        
        
        
        List <BP_Training_Contact__c> bpcList = pg.myBPTrainingContacts;
        TrainingContactWrapper[] bpcWrapperList = new list<TrainingContactWrapper>();
        for(BP_Training_Contact__c bpc : bpcList)
        {
            bpcWrapperList.add(new TrainingContactWrapper(bpc));
        }
        bpcWrapperList.sort();
        List <BP_Training_Contact__c> newBpcList = new List<BP_Training_Contact__c>();
        for(TrainingContactWrapper wrp : bpcWrapperList)
        {
            newBpcList.add(wrp.trngCont);
        }
        pg.AddBPTrainingContactsList(newBpcList); 
        TrainingRTM = '--Select--';     
        TrainingPG = '--Select--';
        TrainingRT = '--Select--';
        TrainingBU = '--Select--';
        TrainingCount = 0;
        
        
        
    }
    
    public List<ProductGroup> getTrAlliancePGs()
    {
        List<ProductGroup> alliancePGs = new List<ProductGroup>();
        
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == 'Alliance')
            {
                alliancePGs.add(pg);
            }
        }
        return alliancePGs;
    }
    
    public List<ProductGroup> getTrSolProPGs()
    {
        List<ProductGroup> SolProPGs = new List<ProductGroup>();
        
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == 'Solution Provider')
            {
                SolProPGs.add(pg);
            }
        }
        return SolProPGs;
    }
    
    public List<ProductGroup> getTrSerProPGs()
    {
        List<ProductGroup> SerProPGs = new List<ProductGroup>();
        
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == 'Service Provider')
            {
                SerProPGs.add(pg);
            }
        }
        return SerProPGs;
    }
    
    public List<ProductGroup> getTrDMPGs()
    {
        List<ProductGroup> dmPGs = new List<ProductGroup>();
        
        
        return dmPGs;
    }        
    
    /* public List<SelectOption> getRevenueTypes()
{
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('--Select--','--Select--'));        

options.add(new SelectOption('PNCV', 'PNCV'));
options.add(new SelectOption('SNCV', 'SNCV'));
options.add(new SelectOption('ENCV', 'ENCV'));                

return options;                     
} */ 
    
    public PageReference EditPage()
    {   
        
        profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
        // GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 6);        
        historyTabEnabled = ((Integer.valueOf(currentTab)) < 7);
        engagementModelTabEnabled = ((Integer.valueOf(currentTab)) < 8); 
        
          //ponse01 ------start--------------       
        if(ShowIncentivesection == true){       
                
        System.debug('Entered if Condition Fiscal Year');       
        this.BussPlan.Alliance_Program_Level__c = Alliancelevel;        
        system.debug('this.BussPlan.Alliance_Program_Level__c--------'+ Alliancelevel);     
        this.BussPlan.Solution_Provider_Program_Level__c = Solutionlevel;       
        this.BussPlan.Service_Provider_Program_Level__c = Servicelevel;     
        this.BussPlan.Alliance__c = Alliance;       
        this.BussPlan.Alliance_Designation__c = AllianceDesignation;        
        this.BussPlan.Alliance_Type__c = AllianceType;      
        this.BussPlan.Service_Provider__c = ServiceProvider;        
        system.debug('this.BussPlan.Service_Provider__c--------'+ ServiceProvider);     
        this.BussPlan.Service_Provider_Designation__c = ServiceProviderDesignation;     
        this.BussPlan.Service_Provider_Type__c = ServiceProviderType;       
        this.BussPlan.Solution_Provider__c = SolutionProvider;      
        this.BussPlan.Solution_Provider_Designation__c = SolutionProviderDesignation;       
        this.BussPlan.Solution_Provider_Type__c = SolutionProviderType;     
        system.debug('this.BussPlan.Solution_Provider_Type__c --------'+ SolutionProviderType);     
        this.BussPlan.Primary_RTM_Alliance__c = PrimaryRTMAlliance;     
        this.BussPlan.Primary_RTM_Servide_Provider__c = PrimaryRTMServideProvider;      
        this.BussPlan.Primary_RTM_Solution_Provider__c = PrimaryRTMSolutionProvider;        
        system.debug('this.BussPlan.Primary_RTM_Solution_Provider__c --------'+ PrimaryRTMSolutionProvider);        
        }       
        //ponse01 -----------End-----------
        
        PageReference pageRef = new PageReference('/apex/BusinessPlanEdit');
        return pageRef;
    }    
    
    public Boolean hasErrorPartnerUserLookup()
    {
        Boolean hasError =false;
        List<User> results ;
        String temp;
        System.debug('***************************************');
        System.debug(showCAapprvr);
        System.debug('***************************************');
        // if(partnerBusPlanOwnerName == '' || partnerBusPlanOwnerName == null || partnerExecSponsorName == ''|| partnerExecSponsorName == null ||  (approver001 == '' && !showCAapprvr) || (approver001 == null && !showCAapprvr) || (approver002 == '' && !showCAapprvr) ||  (approver002 ==null && !showCAapprvr) )
        if(partnerBusPlanOwnerName == null  || partnerBusPlanOwnerName == ''|| partnerExecSponsorName == null || partnerExecSponsorName == ''||  (approver001 == null  && !showCAapprvr) || (approver001 == '' && !showCAapprvr) || (approver002 == null  && !showCAapprvr) ||  (approver002 =='' && !showCAapprvr) ) //samap01
        {
            system.debug('partnerBusPlanOwnerName_1= '+partnerBusPlanOwnerName_1+' partnerExecSponsorName_1= '+partnerExecSponsorName_1+' otherPartnerContact_1= '+otherPartnerContact_1+' approver001_1 = '+approver001_1+' approver002_1= '+approver002_1); //SAMAP01 -US238114
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Partner));
            //this.BussPlan.Partner_Business_Plan_Owner__c.addError('This field is required');
            hasError = true;
        }
        System.debug('partnerBusPlanOwnerName:'+partnerBusPlanOwnerName+' partnerBusPlanOwnerName_1: '+partnerBusPlanOwnerName_1+' busPlanAccountId:'+busPlanAccountId);
        
        if((partnerBusPlanOwnerName != '' || partnerBusPlanOwnerName != null) && partnerBusPlanOwnerName != partnerBusPlanOwnerName_1)
        {
            temp = '%'+partnerBusPlanOwnerName+'%';
            results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
            if(results ==  null || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Business Plan Owner , No users found for the given name in the field')); hasError = true;}
            else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Business Plan Owner , Mulitple users found for the given name in the field'));hasError = true;}
            else if(results.size()==1)
            {
                //this.BussPlan.Partner_Business_Plan_Owner__c = results[0].Id;
                //Changes for lookup issue - *Asit*
                if(isClonedBP)
                {
                    this.clonedBP.Partner_Business_Plan_Owner__c = results[0].Id;
                }
                else
                {
                    this.BussPlan.Partner_Business_Plan_Owner__c = results[0].Id;    
                }
                //*Asit* end
            }
            System.debug('results partnerBusPlanOwnerName '+results);
        }
        if(partnerExecSponsorName != '' && partnerExecSponsorName != partnerExecSponsorName_1)
        {
            temp = '%'+partnerExecSponsorName+'%';
            results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
            if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Executive Sponsor , No users found for the given name in the field')); hasError = true;}
            else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Executive Sponsor , Mulitple users found for the given name in the field'));hasError = true;}
            else if(results.size()==1)
            {
                //this.BussPlan.Partner_Executive_Sponsor__c = results[0].Id;
                //Changes for lookup issue - *Asit*
                if(isClonedBP)
                {
                    this.clonedBP.Partner_Executive_Sponsor__c = results[0].Id;
                }
                else
                {
                    this.BussPlan.Partner_Executive_Sponsor__c = results[0].Id;
                }
                //*Asit* End
            }
        }
        if(approver001 != '' && approver001 != approver001_1)
        {
            temp = '%'+approver001+'%';
            results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
            if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Approver 01 , No users found for the given name in the field')); hasError = true;}
            else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Approver 01 , Mulitple users found for the given name in the field'));hasError = true;}
            else if(results.size()==1)
            {
                //this.BussPlan.Approvers_01__c = results[0].Id;
                //Changes for lookup issue - *Asit*
                if(isClonedBP)
                {
                    this.clonedBP.Approvers_01__c = results[0].Id;
                }
                else
                {
                    this.BussPlan.Approvers_01__c = results[0].Id;
                }
                //*Asit* End
            }
        }
        if(approver002 != '' && approver002 != approver002_1)
        {
            temp = '%'+approver002+'%';
            results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
            if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Approver 02 , No users found for the given name in the field')); hasError = true;}
            else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Approver 02 , Mulitple users found for the given name in the field'));hasError = true;}
            else if(results.size()==1)
            {
                //this.BussPlan.Approvers_02__c = results[0].Id;
                //Changes for lookup issue - *Asit*
                if(isClonedBP)
                {
                    this.clonedBP.Approvers_02__c = results[0].Id;
                }
                else
                {
                    this.BussPlan.Approvers_02__c = results[0].Id;
                }
                //*Asit* End
            }
        }
        //SAMAP01 -US238114
        if(Partner_Enablement_Coordinator != '' && Partner_Enablement_Coordinator != Partner_Enablement_Coordinator_1)
        {
            temp = '%'+Partner_Enablement_Coordinator+'%';
            results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
            if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Enablement Coordinator , No users found for the given name in the field')); hasError = true;}
            else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Partner Enablement Coordinator , Mulitple users found for the given name in the field'));hasError = true;}
            else if(results.size()==1)
            {
                //this.BussPlan.Partner_Enablement_Coordinator__c = results[0].Id;
                //Changes for lookup issue - *Asit*
                if(isClonedBP)
                {
                    this.clonedBP.Partner_Enablement_Coordinator__c = results[0].Id;
                }
                else
                {
                    this.BussPlan.Partner_Enablement_Coordinator__c = results[0].Id;
                }
                //*Asit* End
            }
        }
        //SAMAP01 -US238114
        //      //SAMAP01 US293050 & 293051
        /*if(isgeoAccount)
{
if(geosalesvp != '' && geosalesvp != geosalesvp_1)
{
temp = '%'+geosalesvp+'%';
results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Sales VP , No users found for the given name in the field')); hasError = true;}
else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Sales VP , Mulitple users found for the given name in the field'));hasError = true;}
else if(results.size()==1)
{
this.BussPlan.GEO_Sales_VP__c = results[0].Id;
}
}

if(geoprogramlead != '' && geoprogramlead != geoprogramlead_1)
{
temp = '%'+geoprogramlead+'%';
results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Program Lead , No users found for the given name in the field')); hasError = true;}
else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Program Lead , Mulitple users found for the given name in the field'));hasError = true;}
else if(results.size()==1)
{
this.BussPlan.GEO_Program_Lead__c = results[0].Id;
}
}
if(geofinance != '' && geofinance != geofinance_1)
{
temp = '%'+geofinance+'%';
results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Finance , No users found for the given name in the field')); hasError = true;}
else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Finance , Mulitple users found for the given name in the field'));hasError = true;}
else if(results.size()==1)
{
this.BussPlan.GEO_Finance__c = results[0].Id;
}
}
if(geoenablement != '' && geoenablement != geoenablement_1)
{
temp = '%'+geoenablement+'%';
results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Enablement , No users found for the given name in the field')); hasError = true;}
else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Enablement , Mulitple users found for the given name in the field'));hasError = true;}
else if(results.size()==1)
{
this.BussPlan.GEO_Enablement__c = results[0].Id;
}
}
if(geomarketing != '' && geomarketing != geomarketing_1)
{
temp = '%'+geomarketing+'%';
results =[select Id,Name from User where Contact.AccountId =:busPlanAccountId and userType ='PowerPartner' and Name like :temp and IsActive = true]; 
if(results ==  null  || results.size()==0) { Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Marketing , No users found for the given name in the field')); hasError = true;}
else if(results.size()>1) {Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Error : Geo Marketing , Mulitple users found for the given name in the field'));hasError = true;}
else if(results.size()==1)
{
this.BussPlan.GEO_Enablement__c = results[0].Id;
}
}   
}*/
        //SAMAP01 US293050 & 293051
        System.debug('hasError? ' + hasError);
        return hasError;
    }
    
    
    public List<BP_History_Activities__c> getBPhistories(){
        
        List<BP_History_Activities__c> BPHList = [Select Id,CreatedDate,from_attachment_Id__c, from_attachment_Name__c ,to_attachment_Id__c, to_attachment_Name__c , (Select Id, ChangeText__c, Operation__c, Tab_Name__c from BP_History_Lineitems__r order by CreatedDate desc) from BP_History_Activities__c where Business_Plan__c =:this.Bussplan.Id order by CreatedDate desc];
        System.debug('BPHList'+BPHList);
        return BPHList;
        
    }
    
    
    public void checkBeforeSave()
    {
        if(this.Bussplan.status__c == 'Modifying')
        {
            displayPopUp = true;
        } 
        else if(this.BussPlan.Status__c == 'CA & Partner Approved' || this.BussPlan.Status__c == 'CA Rejected' ||this.BussPlan.Status__c == 'Partner Rejected' || this.BussPlan.Status__c == 'Recalled')
        {
            Integer  SolnCountLatest = AddedPGs.size();
            Business_Plan_New__c BP = [SELECT Alliance_Program_Level__c, Service_Provider_Program_Level__c, Solution_Provider_Program_Level__c FROM Business_Plan_New__c WHERE Id = :this.BussPlan.Id][0];
            
            if(delPGSoln.size() > 0 || addedPGSoln.size() > 0 || SerProTotalInitial != SerProTotalLatest || DMTotalInitial != DMTotalLatest || allianceTotalInitial != allianceTotalLatest || SolProTotalInitial != SolProTotalLatest)
            {
                this.BussPlan.Status__c = 'Modifying';
                this.BussPlan.TriggerApproval__c=True;
                displayPopUp = true;
                
                System.debug('Soln'+SolnCountPrev+SolnCountLatest);
                System.debug('Ser'+SerProTotalInitial+SerProTotalLatest);
                System.debug('Dm'+DMTotalInitial+DMTotalLatest);
                system.debug('Alli'+allianceTotalInitial+allianceTotalLatest);
                
            }
        }  
        
    }
    public PageReference Save()
    {
        tabChangeChecks(currentTab);  
        //AR:2427 
        if(this.BussPlan.Plan_Fiscal_Year__c == null || this.BussPlan.Plan_Fiscal_Year__c == '--Select--'){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_22));
            system.debug('fyscal Year error'+BussPlan.Plan_Fiscal_Year__c);
            return null;
        }
        //Commented Incentive__c field for User story US454462 –  FY19 PONSE01
       /* if(ShowIncentivesection && incentiveFieldRequired && (this.BussPlan.Incentive__c == null || this.BussPlan.Incentive__c == '--Select--')){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_Incentive));
            system.debug('Incentive error'+BussPlan.Incentive__c);
            return null;
        }*/
        
        System.debug(' F1 :'+partnerBusPlanOwnerName +' F2 :'+partnerExecSponsorName+' F3 '+otherPartnerContact+'F4 :'+approver001); 
        if(otherPartnerContact == '') this.BussPlan.Other_Partner_Contact__c = null;
        if(currentTab.equalsIgnoreCase('6')){
            List<String> errorMessages = checkoutTabChangeCheck();
            if(errorMessages.size() > 0)
            {
                for(String error : errorMessages)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                }
                return null;
            }else{
                  if(hasErrorPartnerUserLookup() == true){
                      system.debug('hasErrorPartnerUserLookup error');
                   return null;
                    }  

             }
        }            
             
           
        
        try
        {
            if(this.BussPlan.Id == null)
            {
                insert this.BussPlan;
            }
            
            System.debug('ID: '+this.BussPlan.Id+' ; isClonedBP:'+isClonedBP);
            //BPAddAttachment(); //MANAR08
            
            List<BP_Solutions__c> bpList = new List<BP_Solutions__c>();
            bpList = [Select Id,Product_Group__c from BP_Solutions__c where Business_Plan__c=:this.BussPlan.Id];
            
            BPHistory history = new BPHistory(this.BussPlan);
            history.createBPHistory(delPGSoln,addedPGSoln,delTrainingContactMap,addedTrainingContactMap,AddedPGs,bpList,IsGeoAccount); //SAMAP01 -US239334
            
            delete bpList;
            bpList = new List<BP_Solutions__c>();
            
            List<String> RTMlist= new List<String>();
            List<String> PGlist= new List<String>();
            List<String> BUlist= new List<String>();
            
            for(ProductGroup PG: AddedPGs){
                PGlist.add(PG.myPG);
                BUlist.add(PG.myBU);
            }
            
            List<Product2> EGlist= [Select Enablement_Group__C,Partner_Approved__c,Market_Focus_Area__c,Product_Group__c  from product2 where Salesforce_CPQ_Product__c=false and Market_Focus_Area__c in :BUlist and Product_Group__c in :PGlist];
            Map<Integer,String> PGMap =new Map<Integer,String>();
            Integer CounterMap = 0;
            for(ProductGroup PG: AddedPGs){
                boolean isRTMexist =  false;
                for(Product2 ptemp:EGlist){
                    List<String> myRTMs;
                    if(ptemp.Partner_Approved__c == null){
                        myRTMs = new List<String>();
                    }else{
                        myRTMs = new List<String>(ptemp.Partner_Approved__c.split(';'));
                        for(String tRTM:myRTMs){
                            if(PG.myRTM == tRTM){
                                isRTMexist =  true;
                            }
                        }
                    }
                    
                    if(PG.myBU == ptemp.Market_Focus_Area__c && PG.myPG == ptemp.Product_Group__c && myRTMs.size() > 0 && isRTMexist) {
                        PGMap.put(CounterMap,ptemp.Enablement_Group__C );
                        
                        break;
                    }
                }
                if(PGmap.containsKey(CounterMap)){
                    
                }else{
                    PGMap.put(CounterMap,'');
                }
                CounterMap++;
                System.debug('isRTMexist'+isRTMexist);
            }
            // System.debug('Partners approved'+ Partners_Approved__C);
            // 
            
            
            Integer BPcounter =0; 
            for(ProductGroup PG : AddedPGs)
            {
                //samap01 
                Boolean isincubate =false;
                if (PG.Is_Incubate_Product =='Yes') { isincubate=true;} else {isincubate=false;}
                
                BP_Solutions__c bpSol = new BP_Solutions__c(Business_Plan__c=this.BussPlan.Id, JSO_Name__c=PG.myJSO, Is_Incubate_Product__c =isincubate, //SAMAP01
                                                            Product_Group__c=PG.myPG, RTM__c=PG.myRTM, Sales_Coverage_Business_Unit__c=PG.myBU,
                                                            PNCV_Q1__c=PG.PQ1,PNCV_Q2__c=PG.PQ2,PNCV_Q3__c=PG.PQ3,PNCV_Q4__c=PG.PQ4,
                                                            SNCV_Q1__c=PG.SQ1,SNCV_Q2__c=PG.SQ2,SNCV_Q3__c=PG.SQ3,SNCV_Q4__c=PG.SQ4,
                                                            ENCV_Q1__c=PG.EQ1,ENCV_Q2__c=PG.EQ2,ENCV_Q3__c=PG.EQ3,ENCV_Q4__c=PG.EQ4,Enablement_Group__C=PGMap.containsKey(BPcounter)?PGMap.get(BPcounter):'');
                
                
                insert bpSol;
                List<BP_Training_Contact__c> bpcInsertList = PG.myBPTrainingContacts;
                for(BP_Training_Contact__c bpc : bpcInsertList)
                {
                    bpc.BP_Solutions__c = bpSol.id;
                    insert bpc;
                }
                BPcounter++;
            }
            
        }
        catch(DMLException e)
        {}
        PageReference pageRef = controller.save();        
        if(pageRef != null){
            if(currentTab.equalsIgnoreCase('8'))
            {
                pageRef.getParameters().put('tabVal', '9');
            }
            else
            {
                pageRef.getParameters().put('tabVal', currentTab);
            }
            pageRef.setRedirect(true);
        }
        return pageRef;      
    }
    
    
    //AR:2953 clonesave
    public PageReference saveClonedBP(){
        tabChangeChecks(currentTab);  
        System.debug('saveClonedBP()');
        
        if(this.clonedBP.Plan_Fiscal_Year__c == null || this.clonedBP.Plan_Fiscal_Year__c == '--Select--'){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_22));
            system.debug('Fiscal Year');
            return null;
        }
        //Commented Incentive__c field for User story US454462 –  FY19 PONSE01
        /*if(ShowIncentivesection && incentiveFieldRequired && (this.clonedBP.Incentive__c == null || this.clonedBP.Incentive__c == '--Select--')){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_Incentive));
            system.debug('Incentive');
            return null;
        }*/
        if(currentTab.equalsIgnoreCase('6')){
            List<String> errorMessages = checkoutTabChangeCheck();
            if(errorMessages.size() > 0)
            {
                for(String error : errorMessages)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                }
                return null;
            }else{
                  if(hasErrorPartnerUserLookup() == true){
                   return null;
                    }  

             }
        }  
        System.debug(' F1 :'+partnerBusPlanOwnerName +' F2 :'+partnerExecSponsorName+' F3 '+otherPartnerContact+'F4 :'+approver001); 
        try
        {
            if(this.clonedBP.Id == null)
            system.debug('--- in clone nulls--');
                insert clonedBP;            
            System.debug('prev ID: '+this.BussPlan.Id+' ; isClonedBP:'+isClonedBP +'; clonedBP id:'+clonedBP.Id);
            List<BP_Solutions__c> bpList = new List<BP_Solutions__c>();
            bpList = [Select Id from BP_Solutions__c where Business_Plan__c=:clonedBP.Id];
            delete bpList;
            bpList = new List<BP_Solutions__c>();
            
            for(ProductGroup PG : AddedPGs)
            {
                //samap01 
                Boolean isincubate =false;
                if (PG.Is_Incubate_Product =='Yes') { isincubate=true;} else {isincubate=false;}
                
                BP_Solutions__c bpSol = new BP_Solutions__c(Business_Plan__c=clonedBP.Id, JSO_Name__c=PG.myJSO, Is_Incubate_Product__c =isincubate  , //samap01
                                                            Product_Group__c=PG.myPG, RTM__c=PG.myRTM, Sales_Coverage_Business_Unit__c=PG.myBU,
                                                            PNCV_Q1__c=PG.PQ1,PNCV_Q2__c=PG.PQ2,PNCV_Q3__c=PG.PQ3,PNCV_Q4__c=PG.PQ4,
                                                            SNCV_Q1__c=PG.SQ1,SNCV_Q2__c=PG.SQ2,SNCV_Q3__c=PG.SQ3,SNCV_Q4__c=PG.SQ4,
                                                            ENCV_Q1__c=PG.EQ1,ENCV_Q2__c=PG.EQ2,ENCV_Q3__c=PG.EQ3,ENCV_Q4__c=PG.EQ4);
                
                insert bpSol;
                List<BP_Training_Contact__c> bpcInsertList = PG.myBPTrainingContacts;
                for(BP_Training_Contact__c bpc : bpcInsertList)
                {
                    bpc.BP_Solutions__c = bpSol.id;
                    insert bpc;
                }
                
            }
            
        }
        catch(DMLException e)
        {
            System.debug('Exception Occured:'+e);
        }
        if(this.clonedBP.Status__c == 'Approved' || this.clonedBP.Status__c == 'Rejected' || this.clonedBP.Status__c == 'Recalled')
        {
            this.clonedBP.Status__c = 'Modifying';
            this.clonedBP.TriggerApproval__c=true;
        }
        //PageReference pageRef = controller.save();
        PageReference pageRef = new PageReference('/apex/BusinessPlanView?id='+this.clonedBP.Id);
        if(pageRef != null && this.clonedBP.Id != Null){
            if(currentTab.equalsIgnoreCase('8'))
            {
                pageRef.getParameters().put('tabVal', '9');
            }
            else
            {
                pageRef.getParameters().put('tabVal', currentTab);
            }
            pageRef.setRedirect(true);
            return pageRef;
        }
        
        return null;
        
    }    
    
    public void WWClick()
    {
        if(isClonedBP) {  //MANAR08 AR:2953
            this.clonedBP.PS_CAN__c = this.clonedBP.WW__c;
            this.clonedBP.NA__c = this.clonedBP.WW__c;
            this.clonedBP.LA__c = this.clonedBP.WW__c;
            this.clonedBP.EMEA__c = this.clonedBP.WW__c;
            this.clonedBP.APJ__c = this.clonedBP.WW__c;
        }
        else{
            this.Bussplan.PS_CAN__c = this.Bussplan.WW__c;
            this.BussPlan.NA__c = this.BussPlan.WW__c;
            this.BussPlan.LA__c = this.BussPlan.WW__c;
            this.BussPlan.EMEA__c = this.BussPlan.WW__c;
            this.BussPlan.APJ__c = this.BussPlan.WW__c;                 
        }
    }
    
    public void clickedTab()
    {
        
        tabChangeChecks(currentTab);
        if((Integer.valueOf(currentTab)) < (Integer.valueOf(intendedTab)))
        {  
            if(currentTab.equalsIgnoreCase('1'))
            {
                List<String> errorMessages = profileTabChangeCheck();
                if(errorMessages.size() > 0)
                {
                    for(String error : errorMessages)
                    {
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                    }
                    return;
                }            
            }
            if(currentTab.equalsIgnoreCase('4'))// && ((Integer.valueOf(currentTab))<(Integer.valueOf(intendedTab))))
            {
                if(AddedPGs.size() == 0)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_15));
                    return;
                }
            }     
            if(currentTab.equalsIgnoreCase('5'))
            {
                
                List<String> errorMessages = resourceTabChangeCheck();
                if(errorMessages.size() > 0)
                { 
                    for(String error : errorMessages)
                    {
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                    }
                    return;
                }          
            } 
           if(currentTab.equalsIgnoreCase('6')){
            List<String> errorMessages = checkoutTabChangeCheck();
            if(errorMessages.size() > 0)
            {
                for(String error : errorMessages)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                }
                return;
            }else{
                  if(hasErrorPartnerUserLookup() == true){
                   return;
                    }  

             }     
             
         }    
            
            
            String territoryErrorMessage = '';
            
            if(currentTab.equalsIgnoreCase('2'))
            {
                if(isClonedBP) {  //MANAR08 AR:2953
                    if(this.clonedBP.PS_CAN__c)
                    {
                        if(this.clonedBP.PS_CAN_Operating_Area__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.clonedBP.PS_CAN_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Countries + ', ';
                        }
                    }
                    if(this.clonedBP.NA__c)
                    {
                        if(this.clonedBP.NA_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.clonedBP.NA_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                    if(this.clonedBP.LA__c)
                    {
                        if(this.clonedBP.LA_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.clonedBP.LA_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                    if(this.clonedBP.EMEA__c)
                    {
                        if(this.clonedBP.EMEA_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.clonedBP.EMEA_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                    if(this.clonedBP.APJ__c)
                    {
                        if(this.clonedBP.APJ_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.clonedBP.APJ_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                } 
                else{
                    if(this.BussPlan.PS_CAN__c)
                    {
                        if(this.BussPlan.PS_CAN_Operating_Area__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.BussPlan.PS_CAN_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Countries + ', ';
                        }
                    }
                    if(this.BussPlan.NA__c)
                    {
                        if(this.BussPlan.NA_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.BussPlan.NA_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                    if(this.BussPlan.LA__c)
                    {
                        if(this.BussPlan.LA_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.BussPlan.LA_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                    if(this.BussPlan.EMEA__c)
                    {
                        if(this.BussPlan.EMEA_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.BussPlan.EMEA_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }
                    if(this.BussPlan.APJ__c)
                    {
                        if(this.BussPlan.APJ_Operating_Areas__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Target_Markets + ', ';
                        }
                        if(this.BussPlan.APJ_Countries__c == null)
                        {
                            territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Countries + ', ';
                        }                
                    }                   
                }
                if(territoryErrorMessage.length() > 0)
                {
                    territoryErrorMessage = territoryErrorMessage.removeEnd(', ');
                    territoryErrorMessage = System.Label.BP_Please_select+ ' ' + territoryErrorMessage + '.';
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, territoryErrorMessage));
                    return;
                }                                
            }
        }
        currentTab = intendedTab ;            
    }
    
    public String currentTab { get; set; }    
    {   
        if(ShowIncentivesection == true){
        currentTab = '1';
        profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
        //      GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 6);   
        historyTabEnabled =  ((Integer.valueOf(currentTab)) < 7);  
        engagementModelTabEnabled =  ((Integer.valueOf(currentTab)) < 8);  
        }
        else{
            currentTab = '1';
        profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
        GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);   
        historyTabEnabled =  ((Integer.valueOf(currentTab)) < 8);  
        engagementModelTabEnabled =  ((Integer.valueOf(currentTab)) < 9); 
            
        }
    }
    
    
    public void nextTab() 
    {
        if(tabChangeChecks(currentTab))
        {
            return;
        }
        
        if(currentTab.equalsIgnoreCase('1'))
        {
            List<String> errorMessages = profileTabChangeCheck();
            if(errorMessages.size() > 0)
            {
                for(String error : errorMessages)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                }
                return;
            } else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.BP_Next_Save_label));
            }              
        }
        
        if(currentTab.equalsIgnoreCase('3'))
        {
            if(AddedPGs.size() == 0)
            {
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_15));
                return;
            } else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.BP_Next_Save_label));
            }  
        }
        
        if(currentTab.equalsIgnoreCase('4'))
        {
            
            List<String> errorMessages = resourceTabChangeCheck();
            if(errorMessages.size() > 0)
            { 
                for(String error : errorMessages)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                }
                return;
            }  else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.BP_Next_Save_label));
            }           
        }
        if(currentTab.equalsIgnoreCase('6')){
            List<String> errorMessages = checkoutTabChangeCheck();
            if(errorMessages.size() > 0)
            {
                for(String error : errorMessages)
                {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, error));    
                }
                return;
            }else{
                  if(hasErrorPartnerUserLookup() == true){
                   return;
                    } else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.BP_Next_Save_label));
            }    

             }     
             
        }     
        
        
        String territoryErrorMessage = '';               
        if(currentTab.equalsIgnoreCase('2'))
        {
            if(isClonedBP) {  //MANAR08 AR:2953
                if(this.clonedBP.PS_CAN__c)
                {
                    if(this.clonedBP.PS_CAN_Operating_Area__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.clonedBP.PS_CAN_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Countries + ', ';
                    }
                }
                if(this.clonedBP.NA__c)
                {
                    if(this.clonedBP.NA_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.clonedBP.NA_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.clonedBP.LA__c)
                {
                    if(this.clonedBP.LA_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.clonedBP.LA_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.clonedBP.EMEA__c)
                {
                    if(this.clonedBP.EMEA_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.clonedBP.EMEA_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.clonedBP.APJ__c)
                {
                    if(this.clonedBP.APJ_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.clonedBP.APJ_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }   
            }
            else{

                if(this.BussPlan.PS_CAN__c)
                {
                    if(this.BussPlan.PS_CAN_Operating_Area__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.BussPlan.PS_CAN_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_PS_CAN + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.BussPlan.NA__c)
                {
                    if(this.BussPlan.NA_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.BussPlan.NA_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_NA + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.BussPlan.LA__c)
                {
                    if(this.BussPlan.LA_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.BussPlan.LA_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_LA + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.BussPlan.EMEA__c)
                {
                    if(this.BussPlan.EMEA_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.BussPlan.EMEA_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_EMEA + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
                if(this.BussPlan.APJ__c)
                {
                    if(this.BussPlan.APJ_Operating_Areas__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Target_Markets + ', ';
                    }
                    if(this.BussPlan.APJ_Countries__c == null)
                    {
                        territoryErrorMessage = territoryErrorMessage + System.Label.BP_APJ + ' ' + System.Label.BP_Countries + ', ';
                    }                
                }
            }
            if(territoryErrorMessage.length() > 0)
            {
                territoryErrorMessage = territoryErrorMessage.removeEnd(', ');
                territoryErrorMessage = System.Label.BP_Please_select+ ' ' + territoryErrorMessage + '.';
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, territoryErrorMessage));
                return;
            } else{
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,System.Label.BP_Next_Save_label));
            }    
            
        }
        currentTab = String.valueOf(Integer.valueOf(currentTab)+1); 
        
        if(ShowIncentivesection== true ){
        profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
        //       GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 6);
        historyTabEnabled =  ((Integer.valueOf(currentTab)) < 7);     
        engagementModelTabEnabled =  ((Integer.valueOf(currentTab)) < 7);    
        }
        else{
            profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
        GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);
        historyTabEnabled =  ((Integer.valueOf(currentTab)) < 8);     
        engagementModelTabEnabled =  ((Integer.valueOf(currentTab)) < 9);    
            
        }
    }
    
    public void prevTab() 
    { 
        tabChangeChecks(currentTab);
        currentTab = String.valueOf(Integer.valueOf(currentTab)-1); 
        
    } 
    
    public void prevViewTab() 
    { 
        
        currentTab = String.valueOf(Integer.valueOf(currentTab)-1); 
    } 
    
    public void nextViewTab()             
    {   
        currentTab = String.valueOf(Integer.valueOf(currentTab)+1); 
        
        if(ShowIncentivesection == true){
        profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
      //  GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 6);
        historyTabEnabled =  ((Integer.valueOf(currentTab)) < 7); 
        engagementModelTabEnabled = ((Integer.valueOf(currentTab)) < 8);
        }
        else{
             profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
        territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
        GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
        solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
        trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
        revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
        checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);
        historyTabEnabled =  ((Integer.valueOf(currentTab)) < 8); 
        engagementModelTabEnabled = ((Integer.valueOf(currentTab)) < 9);
            
        }
    }
    
    public void clickedViewTab()
    {
        try{
            currentTab = intendedTab;
        }
        catch(exception e){
            
        }
        
    }    
    
    public void showSPQuestions() { SPQuestions = true; showServProvQuestions=false;}
    
    
    
    public List<String> resourceTabChangeCheck()
    { 
        List<String> errorMessages = new List<String>();
        Set<String> resourceNameError = new Set<String>(); //MANAR08 AR:1708
        Map<ProductGroup,String> pgResourceNameMap = new Map<ProductGroup,String>();   //MANAR08 AR:1708   
        Set<String> rNamesinMap = new Set<String>();  //MANAR08 AR:1708           
        boolean isExist = false; //MANAR08 AR:1708   
        
        Integer SalesCount = 0,TechSalesCount=0;
        
        for(ProductGroup PG : AddedPGs){
            pgResourceNameMap.clear();
            for(BP_Training_Contact__c BTC : PG.myBPTrainingContacts){           
                
                if(BTC.Resource_Type__c == 'Sales')
                    SalesCount++;
                if(BTC.Resource_Type__c == 'Technical Sales')
                    TechSalesCount++;
                //samap01 -US293050 & US293051
                if(IsGeoAccount && BTC.GeoCountry__C == '--None--' ){
                    resourceNameError.add(System.Label.BP_ErrorCountry);
                } 
                if(BTC.Credentails__c == '--None--' || BTC.Credentails__c == '' || BTC.Credentails__c == null){
                    resourceNameError.add(System.Label.BP_Crendential);
                }
                
                //SAMAP01
                //MANAR08 AR:1708  
                
                if(BTC.Test_Contact_Name__c == null || BTC.Test_Contact_Name__c == '' ){
                    resourceNameError.add(System.Label.BP_Error_17);
                }
                else{
                    rNamesinMap.clear();
                    rNamesinMap.addAll(pgResourceNameMap.values());
                    
                    if(rNamesinMap.contains(BTC.Resource_Type__c+';'+BTC.Test_Contact_Name__c)){
                        isExist = comparePG(PG,getPGbyRname(pgResourceNameMap,BTC.Resource_Type__c+';'+BTC.Test_Contact_Name__c),BTC.Resource_Type__c);
                        if(isExist){                            
                            //System.debug('Resource name cannot be same for the same Product under the same Resource Type and Route to Market');
                            resourceNameError.add(System.Label.BP_Error_21);
                        }
                    }                   
                    pgResourceNameMap.put(PG,BTC.Resource_Type__c+';'+BTC.Test_Contact_Name__c);
                }
            }
        }
        
        /*  Revoke 2266

String Partnerprogram = getPartnerProgramLevel(); 
if(Partnerprogram == 'Premier')
{
if(!(SalesCount >= 2 && TechSalesCount >= 1))
errorMessages.add(System.Label.BP_Error_20);
}
else if(Partnerprogram == 'Advanced')
{ 
if(!(SalesCount >= 1 && TechSalesCount >= 1))
errorMessages.add(System.Label.BP_Error_20);
}
*/
        
        if(!resourceNameError.isEmpty())
            errorMessages.addAll(resourceNameError);
        
        return errorMessages;   
        
    }
    
    //MANAR08 AR:1708 start
    private boolean comparePG(ProductGroup pg1, ProductGroup pg2,String pg1RType){      
        boolean isEqual = false;
        if(pg2!=null){
            if( ((pg1.myPG).equals(pg2.myPG)) && ((pg1.myRTM).equals(pg2.myRTM)) ) 
            {               
                List<BP_Training_Contact__c> pg2TContacts = pg2.myBPTrainingContacts;
                for(BP_Training_Contact__c bptc2: pg2TContacts){
                    if( (bptc2.Resource_Type__c).equals(pg1RType)){   
                        isEqual = true;
                        break;
                    }
                }               
            }           
        }       
        return isEqual;
    }
    
    public ProductGroup getPGbyRname(Map<ProductGroup, String> pgmap, String RTypeName) 
    {       
        String[] res = RTypeName.split(';');
        String rtype = res[0];
        String rname = res[1];
        
        String[] res1;
        String rtype1;
        String rname1;
        
        for(ProductGroup pg: pgmap.keySet()){           
            res1 = (pgmap.get(pg)).split(';');
            rtype1 = res[0];
            rname1 = res[1];
            
            if( rtype.equals(rtype1) && rname.equals(rname1)){
                return pg;
            }           
        }       
        return null;           
    }
    //MANAR08 AR:1708 end
    
    
    
    public List<String> profileTabChangeCheck()
    {
        List<String> errorMessages = new List<String>();
        
        if(isClonedBP) {  //MANAR08 AR:2953
            
            if(this.clonedBP.Plan_Fiscal_Year__c == null || this.clonedBP.Plan_Fiscal_Year__c == '--Select--'){
                errorMessages.add(System.Label.BP_Error_22);
            }        
            //Commented Incentive__c field for User story US454462 –  FY19 PONSE01
           /* if(ShowIncentivesection && incentiveFieldRequired && (this.clonedBP.Incentive__c == null || this.clonedBP.Incentive__c == '--Select--')){
                errorMessages.add(System.Label.BP_Error_Incentive);
            }*/
            if(!(this.clonedBP.Alliance__c) && !(this.clonedBP.Data_Management__c) && !(this.clonedBP.Service_Provider__c) && !(this.clonedBP.Solution_Provider__c))
            {
                errorMessages.add(System.Label.BP_Error_3);
            }
            
            if(this.clonedBP.Alliance__c)
            {
                if(this.clonedBP.Alliance_Program_Level__c==null || this.clonedBP.Alliance_Type__c==null)
                {
                    errorMessages.add(System.Label.BP_Error_1);
                }
            }
            else
            {
                if(this.clonedBP.Alliance_Program_Level__c!=null || this.clonedBP.Alliance_Type__c!=null ||
                   this.clonedBP.Alliance_Designation__c!=null)
                {
                    errorMessages.add(System.Label.BP_Error_2);
                }
            }
            
            if(this.clonedBP.Service_Provider__c)
            {
                if(this.clonedBP.Service_Provider_Program_Level__c==null || this.clonedBP.Service_Provider_Type__c==null)
                {
                    errorMessages.add(System.Label.BP_Error_5);
                }
            }
            else
            {
                if(this.clonedBP.Service_Provider_Program_Level__c!=null || this.clonedBP.Service_Provider_Type__c!=null ||
                   this.clonedBP.Service_Provider_Designation__c!=null)
                {
                    errorMessages.add(System.Label.BP_Error_6);
                }
            }
            
            if(this.clonedBP.Solution_Provider__c)
            {
                if(this.clonedBP.Solution_Provider_Program_Level__c==null || this.clonedBP.Solution_Provider_Type__c==null)
                {
                    errorMessages.add(System.Label.BP_Error_8);
                }
            }
            else
            {
                if(this.clonedBP.Solution_Provider_Program_Level__c!=null || this.clonedBP.Solution_Provider_Type__c!=null ||
                   this.clonedBP.Solution_Provider_Designation__c!=null)
                {
                    errorMessages.add(System.Label.BP_Error_9);
                }
            }
            //MANAR08 - AR:2267
            /*
if(this.BussPlan.Data_Management__c)
{
if(this.BussPlan.DM_Program_Level__c==null || this.BussPlan.DM_Type__c==null)
{
errorMessages.add(System.Label.BP_Error_13);
}
}
else
{
if(this.BussPlan.DM_Program_Level__c!=null || this.BussPlan.DM_Type__c!=null ||
this.BussPlan.DM_Designation__c!=null)
{
errorMessages.add(System.Label.BP_Error_12);
}
} */
            
            Set<String> programLevelValues = new Set<String>();
            if(this.clonedBP.Alliance__c)
            {
                if(this.clonedBP.Alliance_Program_Level__c != null)
                    programLevelValues.add(this.clonedBP.Alliance_Program_Level__c);
            }                       
            if(this.clonedBP.Service_Provider__c)
            {
                if(this.clonedBP.Service_Provider_Program_Level__c != null)
                    programLevelValues.add(this.clonedBP.Service_Provider_Program_Level__c);
            }
            if(this.clonedBP.Solution_Provider__c)
            {
                if(this.clonedBP.Solution_Provider_Program_Level__c != null)
                    programLevelValues.add(this.clonedBP.Solution_Provider_Program_Level__c);
            }
            if(programLevelValues.size()>1)
            {
                errorMessages.add(System.Label.BP_Error_4); 
            }  
            
            Integer primaryCounter = 0;
            
            if(this.clonedBP.Primary_RTM_Alliance__c)
            {
                primaryCounter++;
            }
            if(this.clonedBP.Primary_RTM_Servide_Provider__c)
            {
                primaryCounter++;        
            }
            if(this.clonedBP.Primary_RTM_Solution_Provider__c)
            {
                primaryCounter++;        
            }   
            
            if(primaryCounter > 1)
            {
                errorMessages.add(System.Label.BP_Error_10);
            }         
            
            return errorMessages;           
        }
        else{
            
            if(this.BussPlan.Plan_Fiscal_Year__c == null || this.BussPlan.Plan_Fiscal_Year__c == '--Select--'){
                errorMessages.add(System.Label.BP_Error_22);
            }    
                //Commented Incentive__c field for User story US454462 –  FY19 PONSE01
            /*if(ShowIncentivesection && incentiveFieldRequired && (this.BussPlan.Incentive__c == null || this.BussPlan.Incentive__c == '--Select--')){
                errorMessages.add(System.Label.BP_Error_Incentive);
            }*/
            if(!(this.BussPlan.Alliance__c) && !(this.BussPlan.Data_Management__c) && !(this.BussPlan.Service_Provider__c) && !(this.BussPlan.Solution_Provider__c))
            {
                errorMessages.add(System.Label.BP_Error_3);
            }
            
            if(this.BussPlan.Alliance__c)
            {
                if(this.BussPlan.Alliance_Program_Level__c==null || this.BussPlan.Alliance_Type__c==null)
                {
                    errorMessages.add(System.Label.BP_Error_1);
                }
            }
            else
            {
                if(this.BussPlan.Alliance_Program_Level__c!=null || this.BussPlan.Alliance_Type__c!=null ||
                   this.BussPlan.Alliance_Designation__c!=null)
                {
                    errorMessages.add(System.Label.BP_Error_2);
                }
            }
            
            if(this.BussPlan.Service_Provider__c)
            {
                if(this.BussPlan.Service_Provider_Program_Level__c==null || this.BussPlan.Service_Provider_Type__c==null)
                {
                    errorMessages.add(System.Label.BP_Error_5);
                }
            }
            else
            {
                if(this.BussPlan.Service_Provider_Program_Level__c!=null || this.BussPlan.Service_Provider_Type__c!=null ||
                   this.BussPlan.Service_Provider_Designation__c!=null)
                {
                    errorMessages.add(System.Label.BP_Error_6);
                }
            }
            
            if(this.BussPlan.Solution_Provider__c)
            {
                if(this.BussPlan.Solution_Provider_Program_Level__c==null || this.BussPlan.Solution_Provider_Type__c==null)
                {
                    errorMessages.add(System.Label.BP_Error_8);
                }
            }
            else
            {
                if(this.BussPlan.Solution_Provider_Program_Level__c!=null || this.BussPlan.Solution_Provider_Type__c!=null ||
                   this.BussPlan.Solution_Provider_Designation__c!=null)
                {
                    errorMessages.add(System.Label.BP_Error_9);
                }
            }
            //MANAR08 - AR:2267
            /*
if(this.BussPlan.Data_Management__c)
{
if(this.BussPlan.DM_Program_Level__c==null || this.BussPlan.DM_Type__c==null)
{
errorMessages.add(System.Label.BP_Error_13);
}
}
else
{
if(this.BussPlan.DM_Program_Level__c!=null || this.BussPlan.DM_Type__c!=null ||
this.BussPlan.DM_Designation__c!=null)
{
errorMessages.add(System.Label.BP_Error_12);
}
} */
            
            Set<String> programLevelValues = new Set<String>();
            
            if(this.BussPlan.Alliance__c)
            {
                if(this.BussPlan.Alliance_Program_Level__c != null)
                    programLevelValues.add(this.BussPlan.Alliance_Program_Level__c);
            }                       
            if(this.BussPlan.Service_Provider__c)
            {
                if(this.BussPlan.Service_Provider_Program_Level__c != null)
                    programLevelValues.add(this.BussPlan.Service_Provider_Program_Level__c);
            }
            if(this.BussPlan.Solution_Provider__c)
            {
                if(this.BussPlan.Solution_Provider_Program_Level__c != null)
                    programLevelValues.add(this.BussPlan.Solution_Provider_Program_Level__c);
            }  
            
            if(programLevelValues.size()>1)
            {
                errorMessages.add(System.Label.BP_Error_4); 
            }  
            
            Integer primaryCounter = 0;
            
            if(this.BussPlan.Primary_RTM_Alliance__c)
            {
                primaryCounter++;
            }
            if(this.BussPlan.Primary_RTM_Servide_Provider__c)
            {
                primaryCounter++;        
            }
            if(this.BussPlan.Primary_RTM_Solution_Provider__c)
            {
                primaryCounter++;        
            }   
            
            if(primaryCounter > 1)
            {
                errorMessages.add(System.Label.BP_Error_10);
            }         
            
            return errorMessages;           
        }
        
        
        
    }
     public List<String> checkoutTabChangeCheck()
    {
        List<String> errorMessages = new List<String>();
        boolean tempval =false;
        if(isClonedBP) {
        //CA_Business_Plan_Owner__c,Account_Executive__c,GEO_Sales_VP__c,GEO_Enablement__c,GEO_Program_Lead__c,GEO_Finance__c,GEO_Marketing__c this.BussPlan this.clonedBP
            if(this.clonedBP.CA_Business_Plan_Owner__c == null){
                tempval = true;
            }
            if(this.clonedBP.Account_Executive__c == null){
                tempval = true;
            }
            if( this.clonedBP.GEO_Sales_VP__c == null){
                tempval = true;
            }
            if(  this.clonedBP.GEO_Enablement__c == null){
                tempval = true;
            }
            if( this.clonedBP.GEO_Program_Lead__c == null){
                tempval = true;
            }
            if( this.clonedBP.GEO_Finance__c == null){
                tempval = true;
            }
            if( this.clonedBP.GEO_Marketing__c  == null){
                tempval = true;
            }
        
        }
        else{
            if(this.BussPlan.CA_Business_Plan_Owner__c == null){
                tempval = true;
            }
            if(this.BussPlan.Account_Executive__c == null){
                tempval = true;
            }
            if( this.BussPlan.GEO_Sales_VP__c == null){
                tempval = true;
            }
            if( this.BussPlan.GEO_Enablement__c == null){
                tempval = true;
            }
            if( this.BussPlan.GEO_Program_Lead__c == null){
                tempval = true;
            }
            if( this.BussPlan.GEO_Finance__c == null){
                tempval = true;
            }
            if( this.BussPlan.GEO_Marketing__c  == null){
                tempval = true;
            }
        }
        if(tempval == true){
         errorMessages.add(System.Label.BP_Partner);
        }
        return errorMessages;
    }
    
    
    public boolean tabChangeChecks(String tabName)
    {
        boolean errorCondition = false;
        
        //        if(tabName=='5')
        {
            for(ProductGroup PG : AddedPGs)
            {
                List<BP_Training_Contact__c> bpcInsertList = PG.myBPTrainingContacts;
                Integer i = 0;    
                
                for(BP_Training_Contact__c bpc : bpcInsertList)
                {
                    if(ApexPages.currentPage().getParameters().get('hdnContactID.'+i+'.'+PG.myRTM+'.'+bpc.Product_Group__c+'.'+bpc.Resource_Type__c) != null &&
                       ApexPages.currentPage().getParameters().get('hdnContactID.'+i+'.'+PG.myRTM+'.'+bpc.Product_Group__c+'.'+bpc.Resource_Type__c) != '' )
                    {
                        bpc.Contact__c = ApexPages.currentPage().getParameters().get('hdnContactID.'+i+'.'+PG.myRTM+'.'+bpc.Product_Group__c+'.'+bpc.Resource_Type__c);
                        bpc.Test_Contact_Name__c = ApexPages.currentPage().getParameters().get('tstContName.'+i+'.'+PG.myRTM+'.'+bpc.Product_Group__c+'.'+bpc.Resource_Type__c);
                        bpc.Certification_Level__c=ApexPages.currentPage().getParameters().get('targetcertificationlevel.'+i+'.'+PG.myRTM+'.'+bpc.Product_Group__c+'.'+bpc.Resource_Type__c);
                        //bpc.Resource_Email__c = [Select Email from Contact where Id =: bpc.Contact__c].Email;
                    } 
                    i++;                                     
                }                     
            }
        }
        return errorCondition;    
    }
    
    //amasa03-FY18 Partner
    public List<SelectOption> getCredentialAvalues()
    {
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult =
     BP_Training_Contact__c.Credentails__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       options.add(new SelectOption('','--None--'));
       for( Schema.PicklistEntry f : ple)
       {
           if(f.getLabel() != 'Proven Professional'){
               options.add(new SelectOption(f.getLabel(), f.getValue()));
           }
          
       }       
       return options;
    }
    
    public String getReadableLanguage(String langCode)
    {
        String readableLanguage;              
        Map<String, String> languageMap = new Map<String, String>();
        languageMap.put('zh_CN','Chinese (Simplified)');
        languageMap.put('zh_TW','Chinese (Traditional)');
        languageMap.put('da','Danish');
        languageMap.put('en_US','English');
        languageMap.put('nl_NL','Dutch');
        languageMap.put('fi','Finnish');
        languageMap.put('fr','French');
        languageMap.put('de','German');
        languageMap.put('it','Italian');
        languageMap.put('ja','Japanese');
        languageMap.put('ko','Korean');
        languageMap.put('pt_BR','Portuguese (Brazil)');
        languageMap.put('ru','Russian');
        languageMap.put('es','Spanish');
        languageMap.put('sv','Swedish');
        languageMap.put('th','Thai');
        languageMap.put('ar','Arabic');
        languageMap.put('bg','Bulgarian');
        languageMap.put('cs','Czech');
        languageMap.put('en_GB','English (UK)');
        languageMap.put('el','Greek');
        languageMap.put('iw','Hebrew');
        languageMap.put('hu','Hungarian');
        languageMap.put('in','Indonesian');
        languageMap.put('no','Norwegian');
        languageMap.put('pl','Polish');
        languageMap.put('ro','Romanian');
        languageMap.put('tr','Turkish');
        languageMap.put('uk','Ukrainian');
        languageMap.put('vi','Vietnamese');
        languageMap.put('sq','Albanian');
        languageMap.put('hy','Armenian');
        languageMap.put('eu','Basque');
        languageMap.put('bs','Bosnian');
        languageMap.put('hr','Croatian');
        languageMap.put('en_AU','English (Australia)');
        languageMap.put('en_CA','English (Canada)');
        languageMap.put('en_IN','English (India)');
        languageMap.put('en_MY','English (Malaysia)');
        languageMap.put('en_PH','English (Philippines)');
        languageMap.put('et','Estonian');
        languageMap.put('fr_CA','French (Canada)');
        languageMap.put('ka','Georgian');
        languageMap.put('hi','Hindi');
        languageMap.put('is','Icelandic');
        languageMap.put('ga','Irish');
        languageMap.put('lv','Latvian');
        languageMap.put('lt','Lithuanian');
        languageMap.put('lb','Luxembourgish');
        languageMap.put('mk','Macedonian');
        languageMap.put('ms','Malay');
        languageMap.put('mt','Maltese');
        languageMap.put('ro_MD','Moldovan');
        languageMap.put('sh_ME','Montenegrin');
        languageMap.put('pt_PT','Portuguese (European)');
        languageMap.put('rm','Romansh');
        languageMap.put('sr','Serbian (Cyrillic)');
        languageMap.put('sh','Serbian (Latin)');
        languageMap.put('sk','Slovak');
        languageMap.put('sl','Slovenian');
        languageMap.put('tl','Tagalog');
        languageMap.put('ur','Urdu');
        languageMap.put('cy','Welsh');
        
        return languageMap.get(langCode);
    }
    
    public String getKey()
    {
        return tmpProd+'.'+tmpType;
    }
    
    public boolean getInDraft()
    {
        //AR 3030 : CA & Partner Approved is the new approval status : SINJY02
        if(this.BussPlan.Status__c!='CA & Partner Approved')
        {
            return true;
        }
        return false;
    }
    
    
    public boolean getIsMSP()
    {
        return (this.BussPlan.Service_Provider__c && (this.BussPlan.Service_Provider_Type__c != null && this.BussPlan.Service_Provider_Type__c.equalsIgnoreCase('MSP')));
    }
    
    public class TrainingContactWrapper implements Comparable {
        
        public BP_Training_Contact__c trngCont;
        
        public TrainingContactWrapper(BP_Training_Contact__c c) {
            trngCont = c;
        }
        
        public Integer compareTo(Object compareTo) {
            TrainingContactWrapper compareToContact = (TrainingContactWrapper)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            return (trngCont.Resource_Type__c).compareTo(compareToContact.trngCont.Resource_Type__c);
        }
    } 
    
    public List<SelectOption> getusrs() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('User','User'));
        options.add(new SelectOption('Partner User','Partner User'));
        usrTypeSelected = 'Partner User'; //samap01
        return options;
    }
    
    public boolean getIsModifying() {
        if(this.BussPlan.Status__c == 'Modifying')
            return true;
        else
            return false; 
    }   
    
    public boolean getIsPending() {
        if(this.BussPlan.Status__c == 'Pending CA Approval' || this.BussPlan.Status__c == 'Pending Partner Approval')
            return true;
        else
            return false; 
    }   
    
    public void EnrolePartnerProgramInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Partner_enrolled_in_Partner_Program__c == 'In progress')
            {
                PMEnrolledInPartnerProgramPercentDisplay = '';
                this.clonedBP.Partner_enrolled_in_Program_percentage__c = '25%';
            }
            else
            {
                PMEnrolledInPartnerProgramPercentDisplay = 'display:none;';
                this.clonedBP.Partner_enrolled_in_Program_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Partner_enrolled_in_Partner_Program__c == 'In progress')
            {
                PMEnrolledInPartnerProgramPercentDisplay = '';
                this.BussPlan.Partner_enrolled_in_Program_percentage__c = '25%';
            }
            else
            {
                PMEnrolledInPartnerProgramPercentDisplay = 'display:none;';
                this.BussPlan.Partner_enrolled_in_Program_percentage__c = '';
            }
        }
    }
    
    public void IntroduceToProgramToolsInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Introduce_to_program_and_tools__c == 'In progress')
            {
                IntroductToProgramToolsPercentDisplay = '';
                this.clonedBP.Introduce_to_program_tools_percentage__c = '25%';
            }
            else
            {
                IntroductToProgramToolsPercentDisplay = 'display:none;';
                this.clonedBP.Introduce_to_program_tools_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Introduce_to_program_and_tools__c == 'In progress')
            {
                IntroductToProgramToolsPercentDisplay = '';
                this.BussPlan.Introduce_to_program_tools_percentage__c = '25%';
            }
            else
            {
                IntroductToProgramToolsPercentDisplay = 'display:none;';
                this.BussPlan.Introduce_to_program_tools_percentage__c = '';
            }
        }
    }
    
    public void BusinessPlanCompletedInprogess()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Business_plan_completed__c == 'In progress')
            {
                BusinessPlanCompletedPercentDisplay = '';
                this.clonedBP.Business_plan_completed_percentage__c = '25%';
            }
            else
            {
                BusinessPlanCompletedPercentDisplay = 'display:none;';
                this.clonedBP.Business_plan_completed_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Business_plan_completed__c == 'In progress')
            {
                BusinessPlanCompletedPercentDisplay = '';
                this.BussPlan.Business_plan_completed_percentage__c = '25%';
            }
            else
            {
                BusinessPlanCompletedPercentDisplay = 'display:none;';
                this.BussPlan.Business_plan_completed_percentage__c = '';
            }
        }
    }
    
    public void JointAccMappingInitiatedInprogess()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Joint_Account_mapping_initiated__c == 'In progress')
            {
                JointAccMappingInitiatedPercentDisplay = '';
                this.clonedBP.Joint_Acc_mapping_initiated_percentage__c = '25%';
            }
            else
            {
                JointAccMappingInitiatedPercentDisplay = 'display:none;';
                this.clonedBP.Joint_Acc_mapping_initiated_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Joint_Account_mapping_initiated__c == 'In progress')
            {
                JointAccMappingInitiatedPercentDisplay = '';
                this.BussPlan.Joint_Acc_mapping_initiated_percentage__c = '25%';
            }
            else
            {
                JointAccMappingInitiatedPercentDisplay = 'display:none;';
                this.BussPlan.Joint_Acc_mapping_initiated_percentage__c = '';
            }
        }
    }
    
    public void DigitalPOCAlignedInprogess()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Digital_Sales_Presales_POC_Aligned__c == 'In progress')
            {
                DigitalPOCAlignedPercentDisplay = '';
                this.clonedBP.Digital_POC_Aligned_percentage__c = '25%';
            }
            else
            {
                DigitalPOCAlignedPercentDisplay = 'display:none;';
                this.clonedBP.Digital_POC_Aligned_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Digital_Sales_Presales_POC_Aligned__c == 'In progress')
            {
                DigitalPOCAlignedPercentDisplay = '';
                this.BussPlan.Digital_POC_Aligned_percentage__c = '25%';
            }
            else
            {
                DigitalPOCAlignedPercentDisplay = 'display:none;';
                this.BussPlan.Digital_POC_Aligned_percentage__c = '';
            }
        }
    }
    
    public void MarketingPlanCompletedInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Marketing_plan_completed__c == 'In progress')
            {
                MarketingPlanCompletedPercentDisplay = '';
                this.clonedBP.Marketing_plan_completed_percentage__c = '25%';
            }
            else
            {
                MarketingPlanCompletedPercentDisplay = 'display:none;';
                this.clonedBP.Marketing_plan_completed_percentage__c = '';
            }
        }
        else 
        {
            if (this.BussPlan.Marketing_plan_completed__c == 'In progress')
            {
                MarketingPlanCompletedPercentDisplay = '';
                this.BussPlan.Marketing_plan_completed_percentage__c = '25%';
            }
            else
            {
                MarketingPlanCompletedPercentDisplay = 'display:none;';
                this.BussPlan.Marketing_plan_completed_percentage__c = '';
            }
        }
    }
    
    public void DevelopEnablementPlanInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Develop_enablement_plan__c == 'In progress')
            {
                DevelopEnablementPlanPercentDisplay = '';
                this.clonedBP.Develop_enablement_plan_percentage__c = '25%';
            }
            else
            {
                DevelopEnablementPlanPercentDisplay = 'display:none;';
                this.clonedBP.Develop_enablement_plan_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Develop_enablement_plan__c == 'In progress')
            {
                DevelopEnablementPlanPercentDisplay = '';
                this.BussPlan.Develop_enablement_plan_percentage__c = '25%';
            }
            else
            {
                DevelopEnablementPlanPercentDisplay = 'display:none;';
                this.BussPlan.Develop_enablement_plan_percentage__c = '';
            }
        }
    }
    public void MinEducationReqMetInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Minimum_education_requirements_met__c == 'In progress')
            {
                MinEducationReqMetPercentDisplay = '';
                this.clonedBP.min_education_req_met_percentage__c = '25%';
            }
            else
            {
                MinEducationReqMetPercentDisplay = 'display:none;';
                this.clonedBP.min_education_req_met_percentage__c = '';
            }
        }
        else 
        {
            if (this.BussPlan.Minimum_education_requirements_met__c == 'In progress')
            {
                MinEducationReqMetPercentDisplay = '';
                this.BussPlan.min_education_req_met_percentage__c = '25%';
            }
            else
            {
                MinEducationReqMetPercentDisplay = 'display:none;';
                this.BussPlan.min_education_req_met_percentage__c = '';
            }
        }
    }
    public void PromotePartnerSuccessesInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Promote_partner_successes__c == 'In progress')
            {
                PromotePartnerSuccessesPercentDisplay = '';
                this.clonedBP.Promote_partner_successes_percentage__c = '25%';
            }
            else
            {
                PromotePartnerSuccessesPercentDisplay = 'display:none;';
                this.clonedBP.Promote_partner_successes_percentage__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Promote_partner_successes__c == 'In progress')
            {
                PromotePartnerSuccessesPercentDisplay = '';
                this.BussPlan.Promote_partner_successes_percentage__c = '25%';
            }
            else
            {
                PromotePartnerSuccessesPercentDisplay = 'display:none;';
                this.BussPlan.Promote_partner_successes_percentage__c = '';
            }
        }
    }
    public void PartnershipAssessmentConductedInprogress()
    {
        if (this.EditMode == 'Clone')
        {
            if (this.clonedBP.Partnership_assessment_conducted__c == 'In progress')
            {
                PartnershipAssessmentConductedPercentDisplay = '';
                this.clonedBP.Partnership_assessment_conducted_percent__c = '25%';
            }
            else
            {
                PartnershipAssessmentConductedPercentDisplay = 'display:none;';
                this.clonedBP.Partnership_assessment_conducted_percent__c = '';
            }
        }
        else
        {
            if (this.BussPlan.Partnership_assessment_conducted__c == 'In progress')
            {
                PartnershipAssessmentConductedPercentDisplay = '';
                this.BussPlan.Partnership_assessment_conducted_percent__c = '25%';
            }
            else
            {
                PartnershipAssessmentConductedPercentDisplay = 'display:none;';
                this.BussPlan.Partnership_assessment_conducted_percent__c = '';
            }
        }
    }
    
    
}