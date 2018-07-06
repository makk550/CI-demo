@isTest(seeAllData = true)
public with sharing class CA_TAQ_Account_Approval_Class_Test {
    
    static testmethod void createUpdateStdAccount(){
        Id CISUser = UserInfo.getUserId();
        string strUserID = string.valueOf(CISUser);
        string CisInt = label.Cis_Integration_User;     
        Map<id,string> CisIntegrationUser = new Map<id,string>();      
        CisIntegrationUser.put(CISUser,strUserID);      
        
        string velSelRole ='PARTN DM';
        string pmfkeyOld ='KRIIR06';
        string pmfkeyNew='HYRUD02'; 
        
        CA_TAQ_Account_Approval_Class CA_TAQ = new CA_TAQ_Account_Approval_Class();
        List<TAQ_Account__c> taqApprIds = new list<TAQ_Account__c>();
        TAQ_Account__c taqAppIns = new TAQ_Account__c();
        List<TAQ_Account__c> LstInsert = new list<TAQ_Account__c>();
        taqAppIns.ownerid = CISUser;
        taqAppIns.name='test';
        LstInsert.add(taqAppIns);

        list<TAQ_Account__c> LstTaqAcc = [select Account_ID__c, RecordTypeId,Name,CurrencyIsoCode,OwnerId,
        Account_ID_being_Merged__c,
        Account_Name_Local__c,
        Account_Name_Local_2_Phonetic__c,
        Account_Name_Local_3__c,
        Account_Type1__c,
        Acquisition_Customer__c,
        Agreement__c,
        Agreement_Attached__c,
        Agreement_End_Date__c,
        Agreement_Number__c,
        Agreement_Start_Date__c,
        Alliance__c,
        Alliance_Designation__c,
        Alliance_CAM_PMFKey__c,
        Alliance_Program_Level__c,
        Alliance_Type__c,
        Approval_Process_Status__c,
        Approval_Status__c,
        Area_for_Data_Load__c,
        Business_Plan__c,
        Business_Plan_Attached__c,
        Business_Plan_End_Date__c, 
        Business_Plan_Start_Date__c,
        Enterprise_Account__c,
        Enterprise_Id__c,
        Enterprise_Account_ID_Auto__c,
        CA_Account_ID_Unique__c,
        Enterprise_Account_Name__c,
        chkPendingReview__c,
        Comments__c,
        Company_Email_Domain_s__c,
        Contract_Expiration_Date__c,
        Contract_Start_Date__c,
        Contract_Type__c,
        Country_for_Data_Load__c,
        Country_Picklist__c,
        Coverage_Model__c,
        CPMS_Id__c,
        Credit_Check_completion_date__c,
        Velocity_Seller__c,
        Reason_for_Rejection__c,
        Velocity_Seller_Designation__c,
        DM_Only_Account__c,
        Velocity_Seller_CAM_PMFKey__c,
        Velocity_Seller_Program_Level__c,
        Velocity_Seller_Type__c,
        Business_Name__c,
        DUNS_Number__c,
        Eligible_for_MDF__c,
        Error_Code_MDM__c,
        Error_Message_MDM__c,
        Error_Sending_To_EAI__c,
        FromSARecord__c,
        Region__c,
        Global_Ultimate_Name__c,
        Global_Ultimate__c,
        Global_Parent_Industry__c,
        Global_Parent_Segment__c,
        GP_SIC__c,
        Global_Parent_SIC_2_digit__c,
        Global_Parent_SIC_4_digit__c,
        Global_Ultimate_Region__c,
        If_Yes_New_Reseller_Account_ID__c,
        Industry_Vertical__c,
        Account_Type__c,
        International_Split__c,
        Is_Admin_Approved__c,
        Is_Change_Request__c,
        Is_Error_in_Rule__c,
        Is_Original__c,
        Is_this_a_multi_year_account__c,
        Prevailiing_Account_ID__c,
        Prevailiing_Reseller_Account_ID__c,
        MF_Account__c,
        Area__c,
        Account_Name_Change__c,
        Reseller_Account_Director_Effective_Date__c,
        Reseller_Account_Director_PMFKey__c,
        Partner_Enablement_Addendum__c,
        Partner_Enablement_Addendum_Attached__c,
        Reseller_ID__c,
        Partner_On_boarding__c,
        PDS_Addendum__c,
        PDS_Addendum_Attached__c,
        Pending_Review__c,
        Physical_City__c,
        Physical_City_Local__c,
        Physical_Country__c,
        Physical_Country_Local__c,
        Physical_State_Province__c,
        Physical_State_Prov_Local__c,
        Physical_Street__c,
        Physical_Street_Local__c,
        Physical_Zip_Postal_Code__c,
        Physical_Zip_Local__c,
        Pl_Logo_Exists__c,
        Primary_Roll_Up__c,
        Primary_Account__c,
        Primary_RTM_Alliance__c,
        Primary_RTM_Data_Management__c,
        Primary_RTM_Service_Provider__c,
        Primary_RTM_Solution_Provider__c,
        Program_Level__c,
        Provide_Partner_Kit__c,
        Reason_for_Merger__c,
        Reason_for_Release__c,
        Send_For_Approval__c,
        Record_Type_for_Data_Load__c,
        AD_Renewal__c,
        Process_Step__c,
        Reseller_Account_ID_Auto__c,
        Reseller_Name__c,
        Territory__c,
        Reseller_Type__c,
        Security_Check_completion_date__c,
        Segment__c,
        Sell_Through_Education__c,
        Sell_Through_Mainframe_Capacity__c,
        Sell_Through_Mainframe_Time__c,
        Sell_Through_Product__c,
        Sell_Through_Services__c,
        Sell_Through_Total__c,
        Sell_To_Education__c,
        Sell_To_Mainframe_Capacity__c,
        Sell_To_Mainframe_Time__c,
        Sell_To_Product__c,
        Sell_To_Services__c,
        Total_NCV_Green_Dollars_NA_only__c,
        Sell_With_Education__c,
        Sell_With_Mainframe_Capacity__c,
        Sell_With_Mainframe_Time__c,
        Sell_With_Product__c,
        Sell_With_Services__c,
        Sell_With_Total__c,
        Service_Provider__c,
        Service_Provider_Designation__c,
        Service_Provider_CAM_PMFKey__c,
        Service_Provider_Program_Level__c,
        Service_Provider_Type__c,
        Size_of_Company_Annual_Revenue__c,
        Size_of_Company_Employees__c,
        Solution_Provider__c,
        Solution_Provider_Designation__c,
        Solution_Provider_CAM_PMFKey__c,
        Solution_Provider_Program_Level__c,
        Solution_Provider_Type__c,
        Source__c,
        Split__c,
        Is_Primary_Account__c,
        Split_Type__c,
        Stock_Ticker__c,
        TAQ_Account_18_Digit_ID__c,
        TAQ_Plan_ID__c,
        Termination_Date__c,
        Termination_reason__c,
        Country__c,
        Territory_Change__c,
        Territory_For_Data_Load__c,
        Update_from_BP__c,
        URL__c,
        View_Acc_Record__c,
        Agile_Central_Sales_Territory__c,
        Website__c from TAQ_Account__c limit 1];//where Process_Step__c = 'Account Add' limit 1];

     List<Account> acc = new List<Account>();
     Account acc1 = new Account();
         acc1.Name = 'test 1';
         acc1.BillingStreet = 'Arlington';
         acc1.BillingCountry = 'US';
         acc1.BillingCity = 'VA';
           acc1.Enterprise_ID__c='EA0520';
         acc.add(acc1);
         
    Account acc2 = new Account();
         acc2.Name = 'test 2';
         acc2.BillingStreet = 'Arlington';
         acc2.BillingCountry = 'US';
         acc2.BillingCity = 'VA';   
         acc2.Enterprise_ID__c='EA0521';
         acc.add(acc2);
         insert acc;            

    Account acc3 = new Account();
        acc3.Name = 'Partner test acc111';
        acc3.BillingState = 'NY';
        acc3.Region_Country__c = 'IN';
        acc3.Alliance__c = true;
        acc3.Alliance_Program_Level__c = 'Premier';
        acc3.Service_Provider__c = true;
        acc3.Service_Provider_Program_level__c = 'Premier';
        acc3.Solution_Provider__c = true;
        acc3.Solution_Provider_Program_Level__c = 'Premier';
        acc3.Velocity_Seller__c = true;
        acc3.Velocity_Seller_Program_Level__c = 'Advanced';
        acc3.Commercial_Id__c = 'asdf';
        acc3.BillingStreet='Street';
        acc3.BillingCountry='US';
        acc3.BillingCity='New York';
        insert acc3; 
        
        Route_To_Market__c rtm = new Route_To_Market__c();
        rtm.Account__c = acc3.Id;
        rtm.RTM__c = 'Alliance';
        insert rtm;         
        
            List<TAQ_Account__c> Tacc = new List<TAQ_Account__c>();
            
            TAQ_Account__c Tacc1=new TAQ_Account__c(); 
            Tacc1.name='test 1 acc';
            Tacc1.RecordTypeId = '01230000000cogV';
            Tacc1.View_Acc_Record__c=acc3.id;
            Tacc1.Approval_Process_Status__c = 'Pending Review';
            Tacc1.Service_Provider__c = true;
            Tacc1.Service_Provider_Type__c = 'GSP';
            Tacc1.Service_Provider_Program_Level__c = 'Advanced';
            Tacc1.Service_Provider_CAM_PMFKey__c = 'POTAB02';
            Tacc1.Enterprise_Id__c='EA0520';
            Tacc1.Enterprise_Account_Name__c='test 1';
            Tacc1.Region__c='EMEA';
            Tacc1.Area__c='testa';
            Tacc1.Territory__c='testt';
            Tacc1.Country__c='testc';
            Tacc1.Account_Type__c='test type';
            Tacc1.Approval_Process_Status__c ='Send For Approval';
            Tacc1.OwnerId = '00530000003rQuJ';
            Tacc1.Process_Step__c='Account Add';
            Tacc.add(Tacc1);
            

            List<TAQ_Account__c> Taccs = new List<TAQ_Account__c>();            
            
            TAQ_Account__c Tacc2=new TAQ_Account__c(); 
            Tacc2.name='test 2 acc';
            Tacc2.RecordTypeId = '01230000000cogV';
            Tacc2.Service_Provider_Type__c = 'GSP';
            Tacc2.Service_Provider_Program_Level__c = 'Advanced';
            Tacc2.Service_Provider__c = true;
            Tacc2.Service_Provider_CAM_PMFKey__c = 'POTAB02';
            Tacc2.View_Acc_Record__c=acc2.id;
            Tacc2.Enterprise_Id__c='EA0521';
            Tacc2.Enterprise_Account_Name__c='test 2';
            Tacc2.Region__c='EMEA';
            Tacc2.Area__c='testa';
            Tacc2.Territory__c='testt';
            Tacc2.Country__c='testc';
            Tacc2.Account_Type__c='test type';
            Tacc2.Approval_Process_Status__c ='Send For Approval';
            Tacc2.Process_Step__c='Account Add';
            Tacc2.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc2);
            
        TAQ_Account__c Tacc3=new TAQ_Account__c(); 
            Tacc3.name='test 3 acc';
          Tacc3.RecordTypeId = '01230000000cogV';
          Tacc3.Solution_Provider_Program_Level__c = 'Premier';
          Tacc3.Solution_Provider_Type__c = 'Reseller';
           Tacc3.Solution_Provider_CAM_PMFKey__c = 'BAJPI01';
          Tacc3.Solution_Provider__c = true;
          //Tacc2.Velocity_Seller_CAM_PMFKey__c = 'BAJPI01';
            Tacc3.View_Acc_Record__c=acc3.id;
            Tacc3.Enterprise_Id__c='EA0521';
            Tacc3.Enterprise_Account_Name__c='test 2';
            Tacc3.Region__c='EMEA';
            Tacc3.Area__c='testa';
            Tacc3.Territory__c='testt';
            Tacc3.Country__c='testc';
            Tacc3.Account_Type__c='test type';
            Tacc3.Approval_Process_Status__c ='Send For Approval';
          Tacc3.Process_Step__c='Account Add';
            Tacc3.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc3);
            
        TAQ_Account__c Tacc4=new TAQ_Account__c(); 
            Tacc4.name='test 4 acc';
          Tacc4.RecordTypeId = '01230000000cogV';
          Tacc4.Velocity_Seller_CAM_PMFKey__c = 'BAJPI01';
          Tacc4.Velocity_Seller__c = true;
          Tacc4.Velocity_Seller_Program_Level__c = 'Premier';
          Tacc4.Velocity_Seller_Type__c = 'Reseller';
            Tacc4.View_Acc_Record__c=acc2.id;
            Tacc4.Enterprise_Id__c='EA0521';
            Tacc4.Enterprise_Account_Name__c='test 2';
            Tacc4.Region__c='EMEA';
            Tacc4.Area__c='testa';
            Tacc4.Territory__c='testt';
            Tacc4.Country__c='testc';
            Tacc4.Account_Type__c='test type';
          Tacc4.Process_Step__c='Account Add';    
          Tacc4.Approval_Process_Status__c ='Send For Approval';
            Tacc4.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc4);
        
        TAQ_Account__c Tacc5=new TAQ_Account__c(); 
            Tacc5.name='test 5 acc';
          Tacc5.RecordTypeId = '01230000000cogV';
          Tacc5.Alliance_CAM_PMFKey__c = 'BAJPI01';
          Tacc5.Alliance__c = true;
          Tacc5.Alliance_Program_Level__c = 'Premier';
          Tacc5.Alliance_Type__c = 'Reseller';
            Tacc5.View_Acc_Record__c=acc2.id;
            Tacc5.Enterprise_Id__c='EA0521';
            Tacc5.Enterprise_Account_Name__c='test 2';
            Tacc5.Region__c='EMEA';
            Tacc5.Area__c='testa';
            Tacc5.Territory__c='testt';
            Tacc5.Country__c='testc';
            Tacc5.Account_Type__c='test type';
          Tacc5.Process_Step__c='Account Add';
            Tacc5.Approval_Process_Status__c ='Send For Approval';
            Tacc5.OwnerId = '00530000003rQuJ';
            Tacc.add(Tacc5);            
            insert Tacc ;
 
        CA_TAQ.createUpdateStdAccount(LstTaqAcc,CisIntegrationUser);
        CA_TAQ.validatePMFKeys(LstTaqAcc);
        //CA_TAQ.createTAQAccApprRec(Tacc);
        CA_TAQ.createOrUpdtAgrmnt(LstTaqAcc);
        CA_TAQ_Account_Approval_Class.CreateTAQAccountTeams();
        CA_TAQ.syncmemembers(Tacc1,Tacc2,pmfkeyOld,pmfkeyNew,velSelRole);
    }
    
}