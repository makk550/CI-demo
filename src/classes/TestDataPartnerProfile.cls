/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 ***************************************************************************************************
 * Test Class for creating Test Data on Account, Contact, TAQ Account, TAQ Organization, Users.
 * 
 * Version Date         Owner                         Description
 ****************************************************************************************************
 * 1.0     31/03/2015   Manikandan Raju               Created.
 ****************************************************************************************************/

@isTest

public class TestDataPartnerProfile {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    }

    /*** Create Account Data Method. ***
    Input : None
    Return Type : List of Accounts
    ***/
    public static List<Account> insertDirectAccount() {
        
        Id acctTeamRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name LIKE '%Account Team Covered Account%' LIMIT 1].Id;
        List<Account> DirectAccountList = new List<Account>();
        
        for(Integer i=0;i<20;i++) {
            Account DirectAccount = new Account(Name = 'TestAcc1'+i, RecordTypeId = acctTeamRecordTypeId, Enterprise_Id__c = 'DA00005', Enterprise_Account_Name__c = 'Direct Account Test',
                GU_DUNS_NUMBER__c = '12345678', GU_NAME__c = 'GU Name test', Segment__c = Label.SegmentVal1, GEO__c = 'EMEA',Customer_Category__c = 'Distributor', Website = 'test_a@123.com', 
                Sales_Area__c = 'E-EMEA', Sales_Region__c = 'CA SA', Country_ISO_code__c = 'AO', Account_Type1__c = 'Enterprise Account', CPMS_ID__c = '123450', Alliance_Type__c ='Global Systems Integrator',
                Account_Type__c = 'SLED', Coverage_Model__c = 'Account Team', Sales_Volume__c = 12.0, NumberOfEmployees = 200, Sic = 'Sic test', SicDesc = 'Sic Desc test', Alliance_Program_Level__c = 'Advanced',
                SLED_Area__c = 'Area test', Billingstate = 'state test', BillingStreet = 'street test', BillingPostalCode = '1213123', phone='999999999', 
                Billingcountry = 'country Test', Account_Status__c = 'Approved', Error_Sending_To_EAI__c = true, Error_Code_MDM__c = null, Error_Message_MDM__c = null, Alliance_CAM_PMFKey__c = 'ABCDE0',
                Solution_Provider_Type__c ='CSP', Solution_Provider_Program_Level__c = 'Advanced', Solution_Provider_CAM_PMFKey__c = 'ABCDE0', Service_Provider_CAM_PMFKey__c = 'ABCDE0', Velocity_Seller_CAM_PMFKey__c ='ABCDE0'
                );
            DirectAccountList.add(DirectAccount);
        }
        
        insert DirectAccountList;
        return DirectAccountList;
    }
    
    /*** Create Contact Data Method. ***
    Input : Account ID
    Return Type : List of Contacts
    ***/
    public static List<Contact> insertContact(Id accId) {  
        Id contactRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND Name LIKE '%CA Contact Record Type%' LIMIT 1].Id;
        List<Contact> contactList = new List<Contact>();

        for (Integer k=0;k<10;k++) {
            contactList.add(new Contact(renewal__c = false , senior_executive_sales_leader__c = false , 
                        functional_role__c = 'CEO/President' , phone='999999999', fax ='999999999', MailingPostalCode = '643521',
                        recordtypeid = contactRecordTypeId , portal_champion__c = false , 
                        hasoptedoutofemail = false ,MailingStreet = 'Arlington' , MailingCity = 'NY', MailingState='NY',
                        do_not_contact_flag__c = false , hvn__c = false , lastname = 'Zeidler' , mailingcountry = 'US' , 
                        title = 'Applications Developer' , OTHERSTREET ='Arlington', OTHERCITY='NY', OTHERSTATE='NY',
                        marketing_mailing_opt_in_out__c = false , firstname = 'Bob' , language_preference__c = 'English' , 
                        salutation = 'Lord' , OTHERPOSTALCODE = '643521', job_level_group__c = 'Executive Level' , 
                        do_not_email__c = false , partner_satisfaction_survey_opt_in_out__c = false , primary__c = false , 
                        hasoptedoutoffax = false , country_picklist__c = 'US - UNITED STATES' , email = 'bob@bob.bob' , 
                        donotcall = false , confirmed_pilot_user__c = false , currencyisocode = 'USD' , technical__c = false , 
                        accountid = accId , marketing__c = false , 
                        exists_in_sap__c = false , c_suite_senior_executive__c = false
            ));
        }
//  reference_contact__c = true , 
        insert contactList;
        return contactList;
    }
    
    /*** Create Partner Account Data Method. ***
    Input : None
    Return Type : List of TAQ Accounts
    ***/
    public static List<TAQ_Account__c> insertPartnerAccount() {
        List<TAQ_Account__c> partnerAcctsList = new List<TAQ_Account__c>();
        for (Integer i=0;i<20;i++) {
            partnerAcctsList.add(new TAQ_Account__c(name='test acc'+i, Enterprise_Account_Name__c='test acc name', Reseller_ID__c='test id', Reseller_Name__c='test res',
                                        Region__c='EMEA', Area__c='testa', Territory__c='testt', Country__c='testc', Account_Type__c='test type',
                                        Industry_Vertical__c='test ind', Stock_Ticker__c='test tick', Comments__c='testcom', //ownerid=userinfo.getuserid(),    
                                        Enterprise_Id__c='EA0520', Sell_To_Education__c = 100, Sell_To_Mainframe_Capacity__c = 100, Sell_To_Mainframe_Time__c = 100,
                                        Sell_To_Product__c = 100, Sell_To_Services__c = 100));
        }        
        insert partnerAcctsList;
        return partnerAcctsList;
    }
    
    /*** Create TAQ Account Data Method. ***
    Input : TAQ Account Id
    Return Type : List of TAQ Account Account Approved
    ***/
    public static List<TAQ_Account_Approved__c> insertTAQAccApp(Id TAQAccId) {
        List<TAQ_Account_Approved__c> taqApprovedAccList = new List<TAQ_Account_Approved__c>();

            for (Integer k=0;k<10;k++) {
                taqApprovedAccList.add(new TAQ_Account_Approved__c(Is_Latest_Record__c = true, Name = 'taqAcct'+ k, TAQ_Account__c = TAQAccId,
                                       Enterprise_Account_Name__c = 'Test Enterprise acc name'));
            }

        insert taqApprovedAccList;
        return taqApprovedAccList;
    }
    
    /*** Create TAQ Account Team Approved Data Method. ***
    Input : TAQ Account Approved ID
    Return Type : List of TAQ Account Team Approved
    ***/
    public static List<TAQ_Account_Team_Approved__c> insertTAQAccTeamApp(Id TAQAccAppId) {
        List<TAQ_Account_Team_Approved__c> taqAccTeamApprList = new List<TAQ_Account_Team_Approved__c>();

        for(Integer m=0;m<5;m++){
            taqAccTeamApprList.add(new TAQ_Account_Team_Approved__c(PMFKey__c = 'ABCDE0',TAQ_Account_Approved__c = TAQAccAppId));
        }

        insert taqAccTeamApprList;
        return taqAccTeamApprList;
    }
    
    /*** Create TAQ Organization Data Method. ***
    Input : None
    Return Type : List of TAQ Organization
    ***/
    public static List<TAQ_Organization__c> insertTAQOrganization() {
        List<TAQ_Organization__c> taqOrganizationList = new List<TAQ_Organization__c>();
        
        for(Integer n=0;n<20;n++){
            taqOrganizationList.add(new TAQ_Organization__c(Employee_Name__c='test,user', Process_Step__c='Open Headcount', Manager_Name__c='test,mgr',
                                Position_Id__c='testpos1', Role__c='AD/AM', Organization__c='DIRECT', Region__c='EMEA', Area__c='testa',
                                Territory__c='nordics', Country__c='United States', Distribute_Plan__c='NO', Plan_Type__c='LOA', ownerid=userinfo.getuserid(), Cost_Center_Desc_For_Data_Load__c='test cost',
                                Job_Title_For_Data_Load__c='test job', IC_Currency_For_Data_Load__c='test currency',PMFKey__c='',
                                Organization_for_Data_Load__c='DIRECT', Area_for_Data_Load__c='testa', Territory_For_Data_Load__c='nordics',
                                Country_for_Data_Load__c='United States', Approval_Process_Status__c='Migrated', Employee_Status__c='Active',
                                Position_ID_Status__c='Active', PlanType_Effective_Date__c = date.newinstance(1960, 2, 1)));
        }
        
        insert taqOrganizationList;
        return taqOrganizationList;
    }
    
    /*** Create TAQ Organization Approved Data Method. ***
    Input : TAQ Organization ID
    Return Type : List of TAQ Organization Approved
    ***/    
    public static List<TAQ_Organization_Approved__c> insertTAQOrganizationApp(ID TAQOrgID) {
        List<TAQ_Organization_Approved__c> taqOrgAppList = new List<TAQ_Organization_Approved__c>();
        
        for(Integer p=0; p<20; p++){
            taqOrgAppList.add(new TAQ_Organization_Approved__c( Employee_Name__c = 'test emp'+p,Is_Latest_Record__c = true,TAQ_Organization__c = TAQOrgID, PMFKey__c='ABCDE0' ));
        }
        
        insert taqOrgAppList;
        return taqOrgAppList;
    }
    
    /*** Create User Data Method. ***
    Input : None
    Return Type : List of Users
    ***/
    public static List<User> insertUsers() {
        List<User> usersList = new List<User>();
        Id ProfleId = [Select Id from Profile where Name like 'GEM Partner%' limit 1].Id;
        for(Integer q=0; q<20; q++){
            usersList.add( new User(FirstName = 'First Name', LastName = 'last Name'+q, pmfkey__c = 'ABCDE0'+q,
                                        Alias = 'testca', Username = 'testmethod@ca.com.test',
                                        Email = 'testmethod@ca.com.test', LocaleSidKey = 'ar', 
                                        ProfileId = ProfleId, EmailEncodingKey = 'UTF-8', TimeZoneSidKey = 'Pacific/Fiji', 
                                        LanguageLocaleKey = 'en_US', TermsAccepted__c=false) );
        }
        
        insert usersList;
        return usersList;
    }
    
}