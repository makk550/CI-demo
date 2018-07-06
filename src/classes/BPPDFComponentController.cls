public class BPPDFComponentController {
    
    public Business_Plan_New__c BussPlan{get;set;}
    public String intendedTab { get; set; }
    public boolean showServProvQuestions {get;set;}
    public boolean SPQuestions {get;set;}
    public String SolutionRTM {get; set;}
    public String SolutionBU {get; set;}
    public String SolutionPG {get; set;}
    //public String BookingRTM {get; set;}
    public String BookingBU {get; set;}
    public String BookingPG {get; set;}
    public String TrainingRTM {get; set;}
    public String TrainingPG {get; set;}
    public String TrainingBU {get; set;} //SAMAP01 US293050 & 51
    public String TrainingRT {get; set;}
    public Integer TrainingCount {get; set;}
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
    public boolean logoError{get;set;}
    public boolean ShowIncentivesection {get; set;} //FY18
    public ID logoRecordID {get; set;}
    public ID logoAttachmentID {get;set;}
    public String creatorCurrency {get; set;}
    public String creatorLanguage {get; set;}
    public String tmpProd {get; set;}
    public String tmpType {get; set;}
    public Map<String, List<BP_Training_Course__c>> TempTrainingMap {get;set;}
    
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
    
    public boolean isRegionalAccount {get;set;} //AMASA03
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
    public String bpAccountId {get; set;}
    public String testText {get; set;}
    public boolean isAddDisabled {get; set;}
    public  Account myAccount;
    private Boolean bussPlanIdSet {get;set;}
    public String bussPlanId {get;
                              set
                                  
                              {
                                  
                                  bussPlanId=value;
                                  if(bussPlanId!= null && bussPlanId!=''){
                                      
                                      system.debug('Busplan'+bussPlanId);
                                      fetchPDFData();
                                  }
                              }
                              
                             }
    
    //allha02 4020 
    public String copyright {get; set;}      
    
    public String gethostUrl() {
        String hostName=System.URL.getSalesforceBaseUrl().getHost();    
        System.debug('*** hostName:'+hostName);
        return 'https://'+hostName+'/';     
        
    }
    
    public Integer getBPFYear(String strBPFyear){
        return Integer.valueof(strBPFyear.removeStart('FY '));      
    }
    public integer curBPFYear { get;set;} 
    /*
public integer curBPFYear { get;set;} 
{
currentTab = '1';
profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);
}
// value from Page parameter tabVal
*/   
    public void fetchPDFData(){
        
        if (!bussPlanIdSet){
            System.debug('Entering fetchData with Business Plan'+BussPlanId);
            
            //US467145 changes - new Geo location (PS/CAN) added
            this.BussPlan =[ Select Name,Incentive__c,Descriptive_Business_Plan_Name__c,Approver_Comments__c,Partner_Enablement_Coordinator__c,Is_Incubate_Product__c,
                            Account__c,Account_Billing_Country__c,Action_Items__c,Alliance__c,Alliance_Designation__c,Alliance_Program_Level__c,Alliance_Type__c,
                            GTM_SP_Q2__c,PS_CAN__c,PS_CAN_Countries__c,PS_CAN_Operating_Area__c,APJ__c,APJ_Countries__c,APJ_Operating_Areas__c,GTM_SP_Q6__c,GTM_SP_Q7__c,Approvers_03__c,Approvers_04__c,
                            CA_Business_Plan_Owner__c,Account_Executive__c,Capability_1__c,Capability_2__c,Capability_3__c,Capability_4__c,Capability_5__c,
                            Capability_6__c,GTM_SP_Q16__c,GTM_SP_Q17__c,Account_Country_Picklist__c,Creator_Currency__c,Data_Center_Tiers__c,Data_Management__c,
                            Description_of_Current_State_1__c,Description_of_Current_State_2__c,Description_of_Current_State_3__c,
                            Description_of_Current_State_4__c,Description_of_Current_State_5__c,Description_of_Current_State_6__c,
                            Description_of_Desired_State_1__c,Description_of_Desired_State_2__c,Description_of_Desired_State_3__c,Description_of_Desired_State_4__c,
                            Description_of_Desired_State_5__c,Description_of_Desired_State_6__c,DM_Designation__c,DM_Program_Level__c,DM_Type__c,
                            Due_Dates__c,DUNS_Name__c,DUNS_Number__c,EMEA__c,EMEA_Countries__c,EMEA_Operating_Areas__c,GEO__c,
                            Geography_distribution__c,Insourcing_Multi_sourcing__c,GTM_Q3__c,GTM_Q1__c,GTM_Q2__c,GTM_Q4__c,JSO_Name__c,
                            GTM_Q7__c,GTM_Q6__c,LA__c,LA_Countries__c,Creator_Language__c,LA_Operating_Areas__c,List_Next_Steps__c,
                            GTM_SP_Q3__c,GTM_SP_Q4__c,GTM_SP_Q12__c,GTM_SP_Q13__c,NA__c,NA_Countries__c,MSO_Opportunity_Name__c,
                            GTM_SP_Q5__c,NA_Operating_Areas__c,Number_of_data_centers__c,GTM_Q11__c,Account_Manager__c,
                            Other_Partner_Contact__c,Approvers_01__c,Approvers_02__c,Partner_Business_Plan_Owner__c,Account_Description__c,
                            Partner_Executive_Sponsor__c,Partner_ID__c,Account_Name__c,GTM_Q12__c,GTM_Q8__c,Phone__c,Account_Billing_City__c,
                            Physical_City__c,Account_Billing_State__c,Physical_State_Province__c,Account_Billing_Street__c,Physical_Street__c,
                            Account_Billing_Zip__c,Physical_Zip_Postal_Code__c,Plan_Fiscal_Year__c,Plan_Period_From__c,Plan_Period_To__c,Business_Performance__c,
                            GTM_Q5__c,Primary_RTM_Alliance__c,Primary_RTM_DM__c,Primary_RTM_Servide_Provider__c,Primary_RTM_Solution_Provider__c,
                            Rationalization_Opportunities_1__c,Rationalization_Opportunities_2__c,Rationalization_Opportunities_3__c,Rationalization_Opportunities_4__c,
                            Rationalization_Opportunities_5__c,Rationalization_Opportunities_6__c,Real_estate_ownership__c,Reseller_Distributor_ID__c,GTM_SP_Q18__c,
                            ROI_Expectations__c,Service_Provider__c,Service_Provider_Designation__c,Service_Provider_Program_Level__c,Service_Provider_Type__c,
                            Solution_Provider__c,Solution_Provider_Designation__c,Solution_Provider_Program_Level__c,Solution_Provider_Type__c,
                            Stakeholders_Organization_Map__c,Status__c,GTM_SP_Q14__c,GTM_SP_Q15__c,Submitted_By__c,GTM_SP_Q8__c,GTM_SP_Q10__c,GTM_SP_Q9__c,
                            GTM_SP_Q11__c,Target_Sector__c,Target_Vertical__c,Website__c,WW__c,WW_Countries__c,WW_Operating_Areas__c,
                            Approvers_03__r.Name,Account_Manager__r.name,Other_Partner_Contact__r.name,Approvers_04__r.name,
                            CA_Business_Plan_Owner__r.name,Account_Executive__r.name,Approvers_01__r.name,Approvers_02__r.name,
                            Partner_Business_Plan_Owner__r.name,Partner_Executive_Sponsor__r.name,Submitted_By__r.name,
                            GEO_Enablement__r.Name,GEO_Finance__r.Name,GEO_Marketing__r.Name,GEO_Program_Lead__r.Name,GEO_Sales_VP__r.Name,Is_Geo_Account__c //samap01 -US203050 & 51
                            from Business_Plan_New__c  where id =:BussPlanId ];
            curBPFYear = getBPFYear(this.BussPlan.Plan_Fiscal_Year__c);
            //US467145 changes end

           // if(this.BussPlan.Plan_Fiscal_Year__c){}
            
            User currentUser;
            currentUser = [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
                           From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            
            
            if(currentUser.UserType == 'PowerPartner')
            {
                myAccount = [Select Id, BillingCity, BillingStreet, BillingPostalCode, BillingState, BillingCountry,
                             Name, Partner_Self_Description_Long__c,Physical_City_Local__c, Reseller_Disti_Regional_ID__c,
                             Country_Picklist__c, DUNS_Number__c, GEO__c, Business_Name__c, Phone, Website, Primary_RTM_Alliance__c, Primary_RTM_Data_Management__c, Primary_RTM_Service_Provider__c,
                             Primary_RTM_Solution_Provider__c, Alliance__c, Alliance_Designation__c, Alliance_Program_Level__c, 
                             Alliance_Type__c, Service_Provider__c, Service_Provider_Designation__c, Service_Provider_Program_level__c,
                             Service_Provider_Type__c, Solution_Provider__c, Solution_Provider_Designation__c, Solution_Provider_Program_Level__c,
                             Solution_Provider_Type__c, Velocity_Seller__c, Velocity_Seller_Designation__c, Velocity_Seller_Program_Level__c,Included_in_BP_of_CA_AccountID__c , //SAMAP01 us293050 &51
                             Velocity_Seller_Type__c, Logo__c,Regional_Global_Account__c from Account where Id=:currentUser.AccountId][0];            
                
                //BussPlan.Account__c = myAccount.Id;
            }
            
            Business_Plan_New__c myBP = BussPlan;
            /*
if(myAccount == null && BussPlan.Id != null)
{
myBP = [SELECT Id, Account__c, Name FROM Business_Plan_New__c WHERE Id = :BussPlan.Id][0];

}
*/
            myAccount = [Select Id, BillingCity, BillingStreet, BillingPostalCode, BillingState, BillingCountry,
                         Name, Partner_Self_Description_Long__c,Physical_City_Local__c, Reseller_Disti_Regional_ID__c,
                         Country_Picklist__c, DUNS_Number__c, GEO__c, Business_Name__c, Phone, Website, Primary_RTM_Alliance__c, Primary_RTM_Data_Management__c, Primary_RTM_Service_Provider__c,
                         Primary_RTM_Solution_Provider__c, Alliance__c, Alliance_Designation__c, Alliance_Program_Level__c, 
                         Alliance_Type__c, Service_Provider__c, Service_Provider_Designation__c, Service_Provider_Program_level__c,
                         Service_Provider_Type__c, Solution_Provider__c, Solution_Provider_Designation__c, Solution_Provider_Program_Level__c,
                         Solution_Provider_Type__c, Velocity_Seller__c, Velocity_Seller_Designation__c, Velocity_Seller_Program_Level__c,Included_in_BP_of_CA_AccountID__c , //SAMAP01 US293050 & 51
                         Velocity_Seller_Type__c, Logo__c,Regional_Global_Account__c from Account where Id=:myBP.Account__c][0];
            
            
            bpAccountId = ''+myAccount.Id;
            myAccountId = myAccount.Id; 
            /* 
this.BussPlan.Account_Name__c = myAccount.Name;   
this.BussPlan.Account_Description__c = myAccount.Partner_Self_Description_Long__c;                                        

this.BussPlan.Account_Billing_Country__c = myAccount.BillingCountry;  

this.BussPlan.Reseller_Distributor_ID__c = myAccount.Reseller_Disti_Regional_ID__c;
this.BussPlan.Account_Country_Picklist__c = myAccount.Country_Picklist__c;
this.BussPlan.Duns_Number__c = myAccount.DUNS_Number__c;
this.BussPlan.GEO__c = myAccount.GEO__c;
this.BussPlan.DUNS_Name__c = myAccount.Business_name__c;
this.BussPlan.Phone__c = myAccount.Phone;

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
this.BussPlan.Data_Management__c = myAccount.Velocity_Seller__c;
this.BussPlan.DM_Designation__c = myAccount.Velocity_Seller_Designation__c;
this.BussPlan.DM_Program_Level__c = myAccount.Velocity_Seller_Program_Level__c;
this.BussPlan.DM_Type__c = myAccount.Velocity_Seller_Type__c;
this.BussPlan.Service_Provider__c = myAccount.Service_Provider__c;
this.BussPlan.Service_Provider_Designation__c = myAccount.Service_Provider_Designation__c;
this.BussPlan.Service_Provider_Program_Level__c = myAccount.Service_Provider_Program_level__c;
this.BussPlan.Service_Provider_Type__c = myAccount.Service_Provider_Type__c;
this.BussPlan.Solution_Provider__c = myAccount.Solution_Provider__c;
this.BussPlan.Solution_Provider_Designation__c = myAccount.Solution_Provider_Designation__c;
this.BussPlan.Solution_Provider_Program_Level__c = myAccount.Solution_Provider_Program_Level__c;
this.BussPlan.Solution_Provider_Type__c = myAccount.Solution_Provider_Type__c;
this.BussPlan.Primary_RTM_Alliance__c = myAccount.Primary_RTM_Alliance__c;
this.BussPlan.Primary_RTM_DM__c = myAccount.Primary_RTM_Data_Management__c;
this.BussPlan.Primary_RTM_Servide_Provider__c = myAccount.Primary_RTM_Service_Provider__c;
this.BussPlan.Primary_RTM_Solution_Provider__c = myAccount.Primary_RTM_Solution_Provider__c;
this.BussPlan.Creator_Currency__c = UserInfo.getDefaultCurrency();        
this.BussPlan.Creator_Language__c = getReadableLanguage(UserInfo.getLanguage()); 
}
*/
            myAccountAddress = this.BussPlan.Account_Billing_Street__c + ' \n ' + this.BussPlan.Account_Billing_City__c + ', ' + this.BussPlan.Account_Billing_State__c + ' ' + this.BussPlan.Account_Billing_Zip__c;            
            if(this.BussPlan.Plan_Fiscal_Year__c != null && this.BussPlan.Plan_Fiscal_Year__c != '--Select--'){
                String Iyear =this.BussPlan.Plan_Fiscal_Year__c;
                String IncentiveplanYear = Iyear.removeStart('FY ');
                Integer IntegerPlanyear = integer.valueof(IncentiveplanYear);
                if(IntegerPlanyear < 2018){
                    ShowIncentivesection = false;                   
                }else{
                    ShowIncentivesection = true; 
                    //samap01 US293050  
                      if (String.isBlank(myAccount.Included_in_BP_of_CA_AccountID__c))
                {
                    if(this.BussPlan.Alliance_Program_Level__c == 'Global' || this.BussPlan.Service_Provider_Program_level__c == 'Global' || this.BussPlan.Solution_Provider_Program_Level__c == 'Global')
                      //  this.isGeoAccount= true; ponse01 -US457757
                   // this.BussPlan.Is_Geo_Account__c = true; ponse01 -US457757
                    System.debug('Is GEO :'+isGeoAccount);  
                     
                }                             
                else
                {
                   // this.isGeoAccount= false;
                  //  this.BussPlan.Is_Geo_Account__c = false;                        
                }        
                }
                
            }else{
                ShowIncentivesection = false;
            }
            if(myAccount.Regional_Global_Account__c == true){
                isRegionalAccount = true;
            }else{
                isRegionalAccount =false;
            }
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
            
            
            /****** Get Business Plan Solutions Information ******/
            
            if(BussPlan.Id != null)
            {
                List<BP_Solutions__c> myBPSols = [Select JSO_Name__c, Product_Group__c, RTM__c, Sales_Coverage_Business_Unit__c, Is_Incubate_Product__c, //samap01
                                                  PNCV_Q1__c, PNCV_Q2__c, PNCV_Q3__c, PNCV_Q4__c, SNCV_Q1__c, SNCV_Q2__c, SNCV_Q3__c, SNCV_Q4__c,
                                                  ENCV_Q1__c, ENCV_Q2__c, ENCV_Q3__c, ENCV_Q4__c 
                                                  from BP_Solutions__c where Business_Plan__c=:BussPlan.Id];
                System.debug('myBPSols '+myBPSols);
                
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
 
                        ProductGroup myPG = new ProductGroup(solutionCounter, bp.RTM__c, bp.Sales_Coverage_Business_Unit__c, bp.Product_Group__c, bp.JSO_Name__c,bp.Is_Incubate_Product__c );//samap01);                     
                        myPG.AddPNCVTarget(bp.PNCV_Q1__c, bp.PNCV_Q2__c, bp.PNCV_Q3__c, bp.PNCV_Q4__c);
                        myPG.AddSNCVTarget(bp.SNCV_Q1__c, bp.SNCV_Q2__c, bp.SNCV_Q3__c, bp.SNCV_Q4__c);
                        myPG.AddENCVTarget(bp.ENCV_Q1__c, bp.ENCV_Q2__c, bp.ENCV_Q3__c, bp.ENCV_Q4__c);   
                        
                        List<BP_Training_Contact__c> bpcList = [Select Contact__c, Test_Contact_Name__c, Resource_Type__c, Contact_Email__c,Certification_Level__c,Credentails__c,Product_Group__c,GeoCountry__c from BP_Training_Contact__c
                                                                where BP_Solutions__c=:bp.Id order by Resource_Type__c ASC];
                        
                        List<BP_Training_Contact__c> newBpcList = new List<BP_Training_Contact__c>();
                        //newBpcList.addAll(bpcList);
                        for(BP_Training_Contact__c bpc : bpcList)
                        {
                            newBpcList.add(new BP_Training_Contact__c(Test_Contact_Name__c=bpc.Test_Contact_Name__c, contact__c=bpc.contact__c, resource_type__c=bpc.resource_type__c, Resource_Email__c = bpc.Contact_Email__c,Certification_Level__c =bpc.Certification_Level__c,Credentails__c=bpc.Credentails__c,GeoCountry__c=bpc.GeoCountry__c,Product_Group__c=bpc.Product_Group__c));
                        }
                        myPG.AddBPTrainingContactsList(newBpcList);
                        System.debug('myPG '+myPG);
                        myPG.TotalResources();
                        AddedPGs.add(myPG);                
                    }
                }
            }
            
            System.debug('Print AddedPGs '+AddedPGs);
            bussPlanIdSet = true;
            
        }
        
    }
    
    
    public BPPDFComponentController () 
    {
        curBPFYear=null;
        isAddDisabled = true;
        copyright= Label.BP_Copyright.replace('2015',string.valueof(System.Today().year()));          
        /*
currentTab = '1';
intendedTab='1';
profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7); 
*/    
        SolutionRTM ='';
        SolutionBU='';
        SolutionPG='';
        TrainingRTM='';
        BookingBU='';
        TrainingPG='';
        
        TrainingCount =0;
        myAccountId ='';
        JSOName ='';
        AddedPGs = new List<ProductGroup>();
        myAccountAddress ='';
        myAccountResellerID ='';
        myAccountCountry='';
        myAccountDUNSNumber='';
        myAccountGEO ='';
        myAccountDUNSName='';
        myAccountPhone='';
        myAccountWebSite ='';
        solutionCounter =0;
        delSolutionCounter=0;
        delTrainingKey =0;
        delTrainingPG ='';
        selectedRevType='';
        
        
        allianceBookingExists = false;
        SolProBookingExists =false;
        SerProBookingExists =false;
        DMBookingExists=false;
        showApprovalHistory=false;
        bussPlanIdSet = false;
        
        logoError =false;
        
        
        creatorCurrency ='';
        creatorLanguage ='';
        tmpProd ='';
        tmpType=''; 
        TempTrainingMap = new Map<String, List<BP_Training_Course__c>>();
        bpAccountId ='';
        testText='';
        isAddDisabled =false;
        
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
        
        TempTrainingMap = new Map<String, List<BP_Training_Course__c>>();  
        
        //this.controller = stdController;
        //this.BussPlan = (Business_Plan_New__c)stdController.getRecord();
    }
    
    public String getPartnerProgramLevel()
    {
        String partnerProgramLevel = '';
        if(this.BussPlan.Alliance__c)
        {
            partnerProgramLevel  = this.BussPlan.Alliance_Program_Level__c;
        }
        else if(this.BussPlan.Service_Provider__c)
        {
            partnerProgramLevel  = this.BussPlan.Service_Provider_Program_Level__c;        
        }
        else if(this.BussPlan.Solution_Provider__c)
        {
            partnerProgramLevel  = this.BussPlan.Solution_Provider_Program_Level__c;        
        }
        
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
        String planYear = this.BussPlan.Plan_Fiscal_Year__c;
        planYear = planYear.removeStart('FY ');
        this.BussPlan.Plan_Period_To__c = 'March 31 ' + planYear;
        Integer startYear = integer.valueof(planYear);
        startYear = startYear - 1;
        this.BussPlan.Plan_Period_From__c = 'April 1 ' + startYear;       
    }
    
    public List<SelectOption> getRTMs()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--Select--','--Select--'));                           
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
        List<Product2> applicableProductGroups = [Select Product_Group__c from Product2 where  Partner_Approved__c INCLUDES (:SolutionRTM) AND Market_Focus_Area__c=:SolutionBU and Salesforce_CPQ_Product__c=false];                          
        Set<String> uniqueapplicableProductGroups = new set<String>();
        for(Product2 PA : applicableProductGroups)
        {
            uniqueapplicableProductGroups.add(PA.Product_Group__c);
        }    
        
        for(String PA1 : uniqueapplicableProductGroups)
        {
            options.add(new SelectOption(PA1,PA1));
        } 
        
        return options;                     
    }  
    
    public void clearBUPG()          
    {
        SolutionBU = '--Select--';        
    }
    
    public void clearBookingBUPG()          
    {
        BookingBU = '--Select--';        
    }
    
    public void AddProduct()
    {
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
    
        
        if(SolutionRTM=='--Select--' || SolutionBU=='--Select--' || SolutionPG=='--Select--')
        {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_14));          
            return;
        }        
        
        for(ProductGroup tmpPG : AddedPGs)
        {
            if((SolutionRTM==tmpPG.myRTM) && (SolutionBU==tmpPG.myBU) && (SolutionPG==tmpPG.myPG))
            {
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_16));          
                return;            
            }
        }
        ProductGroup newPG = new ProductGroup(solutionCounter, SolutionRTM, SolutionBU, SolutionPG, this.BussPlan.JSO_Name__c,this.bussPlan.Is_Incubate_Product__c);
        System.debug('newPG '+newPG);
        AddedPGs.add(newPG);  
        this.BussPlan.JSO_Name__c='';
        this.bussPlan.Is_Incubate_Product__c=false; //samap01
        isAddDisabled = true;
    }
    
    
    public ProductGroup getRelatedPG()
    {
        ProductGroup retPG;
        for(ProductGroup pg : AddedPGs)
        {
            if(pg.myRTM == TrainingRTM && pg.MyPG == TrainingPG)
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
        
        public Integer Sales {get;set;} 
        public Integer PreSales {get;set;}
        public Integer Implementation {get;set;}
        public Integer Support {get;set;}
        public Integer Architect {get;set;} 
        public Integer EnablementSponsor {get;set;}
        public Integer SalesOther {get;set;}
        public Integer PreSalesOther {get;set;}
        public Integer ArchitectOther {get;set;}
        public Integer ImplementationOther {get;set;}
        public Integer SupportOther {get;set;}
        public Integer Other {get;set;}
        
        // public BOOLEAN IsIncubateProduct {get;set;}
        public String Is_Incubate_Product {get; set;}  //SAMAP01 -10/31 -US238106
        
        public List<BP_Training_Contact__c> myBPTrainingContacts {get; set;}
        
        public ProductGroup(Integer i, String val1, String val2, String val3, String val4,Boolean Val5)//, BPTrainingContact bpC)
        {
            counter = i;
            myRTM = val1;
            myBU = val2;
            myPG = val3;
            myJSO = val4;  
            // Is_Incubate_Product=  val5 ? "yes" : "no"; //SAMAP01 -10/31 -US238106  trueOrFalse ? "yes" : "no";
            if(val5) 
            {
                Is_Incubate_Product= 'Yes';
            }
            else
            {
                Is_Incubate_Product = 'No';
            }
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
            
            Sales=  0;
            PreSales = 0;
            Implementation = 0;
            Support = 0;
            Architect=  0;
            EnablementSponsor = 0;
            SalesOther = 0;
            PreSalesOther = 0;
            ArchitectOther = 0;
            ImplementationOther = 0;
            SupportOther = 0;
            Other= 0;
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
                    
                    if(btc.Resource_Type__c == 'Sales')
                        Sales++;
                    else if(btc.Resource_Type__c == 'Pre-Sales')
                        PreSales++;
                    else if(btc.Resource_Type__c == 'Implementation')
                        Implementation++;
                    else if(btc.Resource_Type__c == 'Support')
                        Support++;
                    else if(btc.Resource_Type__c == 'Architect')
                        Architect++;
                    else if(btc.Resource_Type__c == 'Enablement Sponsor')
                        EnablementSponsor++;
                    else if(btc.Resource_Type__c == 'Sales Other')
                        SalesOther++;
                    else if(btc.Resource_Type__c == 'Pre-Sales Other')
                        PreSalesOther++;
                    else if(btc.Resource_Type__c == 'ArchitectOther')
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
            }
        }
        allianceTotal = allianceBookingQ1Total + allianceBookingQ2Total + allianceBookingQ3Total+ allianceBookingQ4Total;
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
            }
        }
        SolProTotal = SolProBookingQ1Total + SolProBookingQ2Total + SolProBookingQ3Total+ SolProBookingQ4Total; 
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
            }
        }
        SerProTotal = SerProBookingQ1Total + SerProBookingQ2Total + SerProBookingQ3Total+ SerProBookingQ4Total;
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
       
        DMTotal = DMBookingQ1Total + DMBookingQ2Total + DMBookingQ3Total+ DMBookingQ4Total;
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
    /*  
public void delSolRow()
{
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
contacts.remove(delTrainingKey);
}   
}

public void delAllTrRow()
{
tabChangeChecks(currentTab);
List<ProductGroup> PGs = getTrAlliancePGs();
delTrRow(PGs);
}
public void delSolTrRow()
{
tabChangeChecks(currentTab);
List<ProductGroup> PGs = getTrSolProPGs();
delTrRow(PGs);
}
public void delSerTrRow()
{
tabChangeChecks(currentTab);
List<ProductGroup> PGs = getTrSerProPGs();
delTrRow(PGs);
}
public void delDMTrRow()
{
tabChangeChecks(currentTab);
List<ProductGroup> PGs = getTrDMPGs();
delTrRow(PGs);
}          
*/
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
    /*
public List<SelectOption> getTrainingPGs()
{
tabChangeChecks(currentTab);
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('--Select--','--Select--'));        
List<String> applicableProductGroups = new List<String>();                          
Set<String> uniqueapplicableProductGroups = new set<String>();

for(ProductGroup pg : AddedPGs)
{
if(pg.myRTM == TrainingRTM)
{
applicableProductGroups.add(pg.myPG);
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
options.add(new SelectOption('Implementation','Implementation'));
options.add(new SelectOption('Sales','Sales'));
options.add(new SelectOption('Support','Support'));
options.add(new SelectOption('Technical Sales','Technical Sales'));                           
return options;                     
} 

public void AddTrainingRows()
{
tabChangeChecks(currentTab);
if(TrainingRTM=='--Select--' || TrainingPG=='--Select--' || TrainingRT=='--Select--' || TrainingCount == 0)
{
Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_18));          
return;
}

if(TrainingCount < 0 || TrainingCount > 20)
{
Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_19));          
return;
}        

ProductGroup pg = getRelatedPG();
for(Integer i = 0; i < TrainingCount; i++)
{
pg.AddBPTrainingContacts(new BP_Training_Contact__c(resource_type__c=TrainingRT));
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
TrainingCount = 0;
}
*/
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
    
    
    /* 
public PageReference EditPage()
{
profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);        

PageReference pageRef = new PageReference('/apex/BusinessPlanEdit');
return pageRef;
}    
*/
    public void WWClick()
    {
        //US467145 changes - new Geo location (PS/CAN) added
        this.BussPlan.PS_CAN__c = this.BussPlan.WW__c;
        //US467145 changes end
        this.BussPlan.NA__c = this.BussPlan.WW__c;
        this.BussPlan.LA__c = this.BussPlan.WW__c;
        this.BussPlan.EMEA__c = this.BussPlan.WW__c;
        this.BussPlan.APJ__c = this.BussPlan.WW__c;        
    }
    /*
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

String territoryErrorMessage = '';

if(currentTab.equalsIgnoreCase('2'))
{
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
}            
}

if(currentTab.equalsIgnoreCase('4'))
{
if(AddedPGs.size() == 0)
{
Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.BP_Error_15));
return;
}
}

String territoryErrorMessage = '';               
if(currentTab.equalsIgnoreCase('2'))
{
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

if(territoryErrorMessage.length() > 0)
{
territoryErrorMessage = territoryErrorMessage.removeEnd(', ');
territoryErrorMessage = System.Label.BP_Please_select+ ' ' + territoryErrorMessage + '.';
Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, territoryErrorMessage));
return;
}                                    
}
currentTab = String.valueOf(Integer.valueOf(currentTab)+1); 

profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);        
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

profileTabEnabled = ((Integer.valueOf(currentTab)) < 1);
territoryTabEnabled = ((Integer.valueOf(currentTab)) < 2);
GTMTabEnabled = ((Integer.valueOf(currentTab)) < 3);
solutionsTabEnabled = ((Integer.valueOf(currentTab)) < 4);
trainingTabEnabled = ((Integer.valueOf(currentTab)) < 5);
revenueTabEnabled = ((Integer.valueOf(currentTab)) < 6);
checkoutTabEnabled = ((Integer.valueOf(currentTab)) < 7);    
}

public void clickedViewTab()
{

currentTab = intendedTab;
}    

public void showSPQuestions() { SPQuestions = true; showServProvQuestions=false;}

public List<String> profileTabChangeCheck()
{
List<String> errorMessages = new List<String>();

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
} 

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
if(ApexPages.currentPage().getParameters().get('hdnContactID.'+i+'.'+PG.myRTM+'.'+PG.myPG+'.'+bpc.Resource_Type__c) != null &&
ApexPages.currentPage().getParameters().get('hdnContactID.'+i+'.'+PG.myRTM+'.'+PG.myPG+'.'+bpc.Resource_Type__c) != '' )
{
bpc.Contact__c = ApexPages.currentPage().getParameters().get('hdnContactID.'+i+'.'+PG.myRTM+'.'+PG.myPG+'.'+bpc.Resource_Type__c);
bpc.Test_Contact_Name__c = ApexPages.currentPage().getParameters().get('tstContName.'+i+'.'+PG.myRTM+'.'+PG.myPG+'.'+bpc.Resource_Type__c);
//bpc.Resource_Email__c = [Select Email from Contact where Id =: bpc.Contact__c].Email;
} 
i++;                                     
}   

}
}
return errorCondition;    
}
*/
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
        //AR 3030 : Removing 'Approved' to new approval status is'CA & Partner Approved' : SINJY02
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
    
    
}