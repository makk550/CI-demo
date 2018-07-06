/*************************************************************************************************
Apex Class Name     : TAQOrgAdmin_Error
Date Created        : 01-Aug-2017
Function            : Test Class for the TAQOrgAdmin_Error Apex Class
Code coverage       : 81%
                                                                
Modification Log    :
--------------------------------------------------------------------------------------------------
* Developer              Date                    Description
* ---------------        -----------             ----------------------------------------------
* Samhitha               01-Aug-2017             Initial Creation
**************************************************************************************************/
@istest
private class TAQOrgAdmin_Error_Test {
        
        @testsetup
        public static void CreateTestData() {
            
            
            Integer numAccts =3 ;
          Integer numOppsPerAcct =4;
          lIST<RecordTypes_Setting__c> lstrec = new lIST<RecordTypes_Setting__c>    ();        
            RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Commercial Account');
            lstrec.add(rec1);
            RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFP', Name='CA Enterprise Account');
            lstrec.add(rec2);
            RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFA', Name='Account Team Covered Account');
            lstrec.add(rec3);
            RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFR', Name='Reseller/Distributor Account');
            lstrec.add(rec4);
          RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000001L55o', Name='Territory Covered Account');
            lstrec.add(rec5);
              RecordTypes_Setting__c rec7 = new RecordTypes_Setting__c(RecordType_Id__c = '01230000000GaFD', Name='SMB');
            lstrec.add(rec7);
                    RecordTypes_Setting__c rec8 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFD', Name='Deal Registration');
            lstrec.add(rec8); 
            RecordTypes_Setting__c rec9 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFP', Name='Partner Opportunity');
            lstrec.add(rec9); 
              RecordTypes_Setting__c rec19 = new RecordTypes_Setting__c(RecordType_Id__c = '01240000000GaFN', Name='New Opportunity');
            lstrec.add(rec19); 
            insert lstrec;
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i,BillingState = 'NY',Customer_Category__c = 'Enterprise',GEO__c='NA',
                                        Enterprise_ID__c = '1234te'+i,Enterprise_Account_Name__c = 'rdName',RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId(),
                                            Commercial_ID__c = 'asdf'+i);
            accts.add(a);
        }
        insert accts;
        
        List<Opportunity> opps = new List<Opportunity>();
            List<Contact> Contacts = new list<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id));
                  Contacts.add(new Contact(LastName ='testCon',AccountId = acct.Id));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
          insert contacts;
          
         Profile p1 = [SELECT Id FROM Profile WHERE Name='Ideas Only Portal User'];
         Profile p2=   [SELECT Id FROM Profile WHERE Name='Ideation Portal User'];
            Profile p3=   [SELECT Id FROM Profile WHERE Name='External - Overage High Volume CaseCommunity Portal User']; 
            
     
   
        List<user> users = new List<user>();
        for (Integer k=0;k<numOppsPerAcct;k++) {
            Contact con = Contacts[k];
            // For each account just inserted, add opportunities
            
            users.add(new User(alias = 'test123' +k, email='testx123'+k+ '@ca.com',emailencodingkey='UTF-8',
                               lastname='Testing'+k, languagelocalekey='en_US',localesidkey='en_US',
                               profileId= p1.id, country='United States',IsActive =true,ContactId = con.Id,PMFKey__c='_______',
                               timezonesidkey='America/Los_Angeles', username='testerx1234' + k + '@ca.com',firstName= 'test'+k));
            
            
        }
        insert users;          
        
            
    }
    
    
    private static void createTestDataforTAQAdmin(){
       User[] u=[select id,PMFKey__c,profile.name, profileId, UserRole.name, userRoleId  from User where isActive=true and UserType='PowerCustomerSuccess' and PMFKey__c like '_______' limit 3];
         System.runAs(u[1]){    
        TAQ_Organization__c taqOrg =new TAQ_Organization__c();
        taqOrg.Employee_Name__c='test,user';
        taqOrg.Process_Step__c='Open Headcount';
        taqOrg.Manager_Name__c='test,mgr';
        taqOrg.Manager_PMF_Key__c=u[1].PMFKey__c;
        taqOrg.PMFKey__c=u[0].PMFKey__c;
        taqOrg.Position_Id__c='testpos1';
        taqOrg.Role__c='AD/AM';
        taqOrg.Organization__c='DIRECT';
        taqOrg.Region__c='EMEA';
        taqOrg.Area__c='testa';
        taqOrg.Territory__c='nordics';
        taqOrg.Country__c='United States';
        taqOrg.Plan_Type__c='test';
        taqOrg.Distribute_Plan__c='NO';
        taqOrg.Plan_Type__c='LOA';
        taqOrg.ownerid=UserInfo.getUserId();             //userinfo.getuserid();
        
        taqOrg.Cost_Center_Desc_For_Data_Load__c='test cost';
        taqOrg.Job_Title_For_Data_Load__c='test job';
        taqOrg.IC_Currency_For_Data_Load__c='test currency';
        
        taqOrg.Organization_for_Data_Load__c='DIRECT';
        taqOrg.Area_for_Data_Load__c='testa';
        taqOrg.Territory_For_Data_Load__c='nordics';
        taqOrg.Country_for_Data_Load__c='United States';
        taqOrg.Approval_Process_Status__c='Migrated';
        taqOrg.Employee_Status__c='Active';
        taqOrg.Position_ID_Status__c='Active';
        taqOrg.PlanType_Effective_Date__c = Date.newInstance(2012, 12, 01);
        insert taqOrg;
         
        //---------
        
        //Create Dummy Records for TAQ Org Approved and TAQ Ref position
        
        TAQ_REF_Position__c testRp =new TAQ_REF_Position__c();
        testRp.name='TEST POS';
        testRp.profile_name__c=u[0].Profile.name;
        testRp.role_name__c=u[0].UserRole.name;
        insert testRp; 
        System.debug('u[0].Profile.name'+u[0].Profile.name); 
        System.debug('u[0].UserRole.name'+u[0].UserRole.name); 
        TAQ_Organization_Approved__c testApp=new TAQ_Organization_Approved__c();
        testApp.PMFKey__c=u[0].PMFKey__c;
        testApp.position_id__c='TEST POS';
        testApp.process_status__c = 'Error';
        testApp.process_message__c='';
        testApp.process_step__c= 'New Hire';
        testApp.employee_status__c = 'Transfer';
        testApp.Plan_Type__c='TEST PLAN';
        testApp.Organization__c='DIRECT';
        insert testApp;
        
        TAQ_Organization__c taqOrg2 =new TAQ_Organization__c();
        taqOrg2.Employee_Name__c='test,usr';
        taqOrg2.Process_Step__c='Open Headcount';
        taqOrg2.Manager_Name__c='test,mngr';
        taqOrg2.Manager_PMF_Key__c=u[1].PMFKey__c;
        taqOrg2.PMFKey__c='tess04';
        taqOrg2.Position_Id__c='testpos2';
        taqOrg2.Role__c='AD/AM';
        taqOrg2.Organization__c='DIRECT';
        taqOrg2.Region__c='EMEA';
        taqOrg2.Area__c='testa';
        taqOrg2.Territory__c='nordics';
        taqOrg2.Country__c='United States';
        taqOrg2.Plan_Type__c='test';
        taqOrg2.Distribute_Plan__c='NO';
        taqOrg2.Plan_Type__c='LOA';
        taqOrg2.ownerid=userinfo.getuserid();
        
        taqOrg2.Cost_Center_Desc_For_Data_Load__c='test cost';
        taqOrg2.Job_Title_For_Data_Load__c='test job';
        taqOrg2.IC_Currency_For_Data_Load__c='test currency';
        
        taqOrg2.Organization_for_Data_Load__c='DIRECT';
        taqOrg2.Area_for_Data_Load__c='testa';
        taqOrg2.Territory_For_Data_Load__c='nordics';
        taqOrg2.Country_for_Data_Load__c='United States';
        taqOrg2.Approval_Process_Status__c='Migrated';
        taqOrg2.Employee_Status__c='Active';
        taqOrg2.Position_ID_Status__c='Open';
        taqOrg2.PlanType_Effective_Date__c = Date.newInstance(2012, 12, 01);
        insert taqOrg2;
         
        
        
        TAQ_REF_Position__c testRp2 =new TAQ_REF_Position__c();
        testRp2.name='TEST POS';
        testRp2.profile_name__c=u[1].Profile.name;
        testRp2.role_name__c=u[2].UserRole.name;
        insert testRp2; 
                                                 
        TAQ_Organization_Approved__c testApp2=new TAQ_Organization_Approved__c();
        testApp2.PMFKey__c=u[1].PMFKey__c;
        testApp2.position_id__c='testpos2';
        testApp2.process_status__c = 'Error';
        testApp2.process_message__c='';
        testApp2.process_step__c= 'New Hire';
        testApp2.employee_status__c = 'Transfer';
        testApp2.Plan_Type__c='TEST PLAN';
        testApp2.Organization__c='DIRECT';
        insert testApp2;
             
             
        TAQ_Organization_Approved__c testApp3=new TAQ_Organization_Approved__c();
        testApp3.PMFKey__c=u[2].PMFKey__c;
        testApp3.position_id__c='testpos2';
        testApp3.process_status__c = 'Error';
        testApp3.process_message__c='';
        testApp3.process_step__c= 'New Hire';
        testApp3.employee_status__c = 'Transfer';
        testApp3.Plan_Type__c='TEST PLAN';
        testApp3.process_step__c = 'Term / Transfer';
        testApp3.Organization__c='DIRECT';
        insert testApp3;
        system.assertNotEquals(null, testApp2.id, 'Account inserted');
         }
        
        
        
        
    }
  
    private static testMethod void AutoProvTest2() {
        
      
       createTestDataforTAQAdmin();
        try{
        TaqOrgAdmin_Error.updateUser();
        }Catch (Exception e)
        {
            System.Debug ('ERROR..'+e);
            
        }

    }
    
    
}