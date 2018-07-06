@isTest(seeAllData = true)
public class OppLineItemRemoteActions_PRM_Test {
    
    public static List<Deal_Registration_Program__c> createDealRegProgramList(){
            List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 3];
            List<Deal_Registration_Program__c> delPgrmList = new List<Deal_Registration_Program__c>();
            Deal_Registration_Program__c delPgrm = new Deal_Registration_Program__c();
            delPgrm.name = 'TestDRP';
            delPgrm.Partner_Friendly_Name__c = 'TestDRP';
            delPgrm.Description__c = 'TestDRP';
            delPgrm.Program_Manager__c = approvers[0].Id;
            delPgrm.Program_Queries__c = approvers[1].Id;
            delPgrm.First_Approver__c = approvers[2].Id;
            delPgrm.Max_Deal_Value__c = 1000;
            delPgrm.Min_Deal_Value__c = 500;
            delPgrm.Start_Date__c = Date.today();
            delPgrm.End_Date__c = Date.today();
            delPgrm.Expiry_Days__c = 10;
            delPgrm.Deal_Program_Type__c = 'Solution Provider';
            delPgrm.Finance_Approver_Email__c = 'approver@ca.com';    
            delPgrm.Opp_Type__c = '1 Tier';
            delPgrmList.add(delPgrm);
            
            Deal_Registration_Program__c delPgrm2 = new Deal_Registration_Program__c();
            delPgrm2.name = 'TestDRP4';
            delPgrm2.Partner_Friendly_Name__c = 'TestDRP4';
            delPgrm2.Description__c = 'TestDRP4';
            delPgrm2.Program_Manager__c = approvers[0].Id;
            delPgrm2.Program_Queries__c = approvers[1].Id;
            delPgrm2.First_Approver__c = approvers[2].Id;
            delPgrm2.Max_Deal_Value__c = 1000;
            delPgrm2.Min_Deal_Value__c = 500;
            delPgrm2.Start_Date__c = Date.today();
            delPgrm2.End_Date__c = Date.today()+5;
            delPgrm2.Expiry_Days__c = 10;
            delPgrm.Deal_Program_Type__c = 'Reseller';  
            delPgrm2.Finance_Approver_Email__c = 'approver@ca.com';     
            delPgrm2.Opp_Type__c = '2 Tier;DM';
            delPgrmList.add(delPgrm2);
            
            insert delPgrmList;         
        
            return delPgrmList;
    }
    
    static testMethod void test_Resubmission_Rollback()
    {
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;      
         Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        insert pUser;
        
        System.runAs(pUser){
            System.debug('In testOpplineRemoteActions_PRM 2');
            Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
            
            List<OpportunityLineItem> oliList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);
            update oliList[0];
            opp.DR_Added_Eligible_Products__c = oliList[0].id + '|YES,';
            opp.Deal_Reg_Initially_Approved__c = true;
            update opp;
            opplineitemRemoteActions_PRM.NotChangeProductAndResubmitForApproval(opp.id);

            OppLineItemRemoteActions_PRM.IsResubmissionPreWarningNeeded(opp.id);
            opplineitemRemoteActions_PRM.RevertBacktoApprovedRecordTypeAndDealRegStatus(opp);

            //DR_Added_Eligible_Products__c is  null
            //opp.DR_Added_Eligible_Products__c = null;
            //opp.Deal_Reg_Initially_Approved__c = true;
            //update opp;
            //opplineitemRemoteActions_PRM.NotChangeProductAndResubmitForApproval(opp.id);

            ////Add another, but remove one from DR_Added_Eligible_Products__c
            //oliList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);
            //update oliList[0];
            //opplineitemRemoteActions_PRM.NotChangeProductAndResubmitForApproval(opp.id);
        }
    }

    static testMethod void test_OpplineRemoteActions_PRM(){
        
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers  = true;      
        Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        insert pUser;
        
        System.runAs(pUser){
            System.debug('In testOpplineRemoteActions_PRM 2');
            Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
            List<OpportunityLineItem> oliList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);
            oliList[0].Deal_Program_Eligibility_Status__c = 'Separate Program';
            update oliList[0];
            
            OppLineItemRemoteActions_PRM.noPgmExists(opp.Id);
            OppLineItemRemoteActions_PRM.fetchSepPgmProdList(opp.Id);
            OppLineItemRemoteActions_PRM.executeOptoutFunc(opp.Id);
            OppLineItemRemoteActions_PRM.updateRecordTypetoNewOpp(opp.Id);

            //test checkBeforeReturn method
            List<OppLineItemcontroller_PRM.ProductWrapper> selectedProducts = new list<OppLineItemcontroller_PRM.ProductWrapper>();
            OppLineItemcontroller_PRM.ProductWrapper selectedProduct;
            for(OpportunityLineitem dbOppLineItem : oliList)
            {
                selectedProduct = new OppLineItemcontroller_PRM.ProductWrapper();
        //        selectedProduct.id = dbOppLineItem.id;
                selectedProduct.oppline = dbOppLineItem;
                selectedProducts.add(selectedProduct);
            }
            OppLineItemRemoteActions_PRM.checkBeforeReturn(oliList,selectedProducts,null);

            OppLineItemRemoteActions_PRM.SetNoProgramDealregApproverAndFlag(opp.id);
            OppLineItemRemoteActions_PRM.CheckMaxMinRuleAndSubmitForApproval(opp.Id);
            OppLineItemRemoteActions_PRM.SubmitForApproval(opp.Id);
           
            string recordTypeId = OppLineItemRemoteActions_PRM.GetRecordType(opp.id);
        }
    }
    
    static testMethod void test_AssignFirstApproverEMEA(){


        
         Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'TestAccount'+'EMEA';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='EMEA';
        ac.Enterprise_ID__c = '1234test';       
        ac.Enterprise_Account_Name__c = 'TestAccount'+'EMEA';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = '1234';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon'+'EMEA',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'EMEA', email='EMEA'+'@gmail.com',emailencodingkey='UTF-8',
                                    lastname='ln', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United Kingdom',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='EMEA'+'@noemail.com',firstName= 'fn'+'EMEA');
        insert pUser;

        System.runAs(pUser){
            Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
            OppLineItemRemoteActions_PRM.SetNoProgramDealregApproverAndFlag(opp.id);
           
        }
    }

    static testMethod void test_AssignFirstApproverLA(){

        
         Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'TestAccount'+'LA';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='LA';
        ac.Enterprise_ID__c = '1234test';       
        ac.Enterprise_Account_Name__c = 'TestAccount'+'LA';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = '1234';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon'+'LA',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'LA', email='LA'+'@gmail.com',emailencodingkey='UTF-8',
                                    lastname='ln', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='Brazil',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='LA'+'@noemail.com',firstName= 'fn'+'LA');
        insert pUser;
        System.runAs(pUser){
            Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
            OppLineItemRemoteActions_PRM.SetNoProgramDealregApproverAndFlag(opp.id);
           
        }
    }

    static testMethod void test_AssignFirstApproverAPJ(){

        
        Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'TestAccount'+'APJ';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='APJ';
        ac.Enterprise_ID__c = '1234test';       
        ac.Enterprise_Account_Name__c = 'TestAccount'+'APJ';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = '1234';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon'+'APJ',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'APJ', email='APJ'+'@gmail.com',emailencodingkey='UTF-8',
                                    lastname='ln', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='Japan',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='APJ'+'@noemail.com',firstName= 'fn'+'APJ');
        insert pUser;
        
        System.runAs(pUser){
            System.debug('In testOpplineRemoteActions_PRM 2 EMEA');
            Opportunity opp = Test_CreateOpportunity.createTestOpp('1 Tier');  
            OppLineItemRemoteActions_PRM.SetNoProgramDealregApproverAndFlag(opp.id);
           
        }
    }

    
    static testMethod void test_updateRecTypeToDealReg(){
     Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
       insert pUser;
        
        System.runAs(pUser){
            SystemIdUtility.skipOpportunityTriggers = true;
            SystemIdUtility.skipOpportunityLineItemTriggers  = true;   
            SystemIdUtility.skipAccount = true;
           
            List<Deal_Registration_Program__c> delPgrmList = OppLineItemRemoteActions_PRM_Test.createDealRegProgramList();//new List<Deal_Registration_Program__c>();
                        
            //create opp
            Opportunity opp = Test_CreateOpportunity.createTestOpp('2 Tier');              
            opp.Deal_Registration_Program__c = delPgrmList[1].Id;
            opp.RecordTypeId = '01230000000yspgAAA';  // Deal Reg RecordType id 
            opp.Closedate = Date.today().addDays(2);
            update opp;
            List<OpportunityLineItem> oliList = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);


            List<Id> delPgmId = new List<Id>();
            delPgmId.add(delPgrmList[0].Id);
            delPgmId.add(delPgrmList[1].Id);            
            List<Deal_Registration_Program__c> qdelPgrmList = [select id,Deal_Program_Number__c from Deal_Registration_Program__c where id IN :delPgmId];
            oliList[0].Deal_Program_ID__c = qdelPgrmList[0].Deal_Program_Number__c+'-1;'+qdelPgrmList[1].Deal_Program_Number__c+'-2';
            update oliList;
            
            //OppLineItemRemoteActions_PRM.sendEmailForMultiplePrograms(opp.Id);
            OppLineItemRemoteActions_PRM.updateRecordTypetoDealReg(opp.Id);             
        }
        
    } 
   
  
    static testMethod void test_sendEmailForMultiplePrograms(){
         Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
        
        User pUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        
        
            insert pUser;
        
        
        
        System.runAs(pUser){
            SystemIdUtility.skipOpportunityTriggers = true;
            SystemIdUtility.skipOpportunityLineItemTriggers  = true;   
            SystemIdUtility.skipAccount = true;
           
            List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 3];
            List<Deal_Registration_Program__c> delPgrmList = OppLineItemRemoteActions_PRM_Test.createDealRegProgramList();
            
            //create opp
            Id recid = SystemIdUtility.getResellerDistRecordTypeId();        
            ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
            ID SMBRecTypeId= RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c; 
            System.debug('SMBRecTypeId:'+SMBRecTypeId);
            
            Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA',
                                               Alliance__c = true,Alliance_CAM_PMFKey__c = 'ABCDE01', Velocity_Seller__c = true,
                                               Solution_Provider__c = true,Solution_Provider_CAM_PMFKey__c = 'ABCDE01', Primary_RTM_Data_Management__c = true,
                                               Velocity_Seller_CAM_PMFKey__c = 'ABCDE01');        
            insert resellerAcct;  
            System.debug('resellerAcct:'+resellerAcct.Id);
            Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
            insert smbAcct; 
            System.debug('smbAcct:'+smbAcct.Id);    
            
            RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
            RecordType recoppDealReg = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='Deal Registration'];
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Oppty';            
            opp.Did_the_deal_originate_from_a_campaign__c = 'Yes';
            opp.AccountId = resellerAcct.Id;
            opp.Reseller__c= smbAcct.Id;
            opp.Distributor_6__c = smbAcct.Id;
            opp.Closedate = System.today().addDays(2);
            opp.StageName = Label.Opp_Stage_10_Percent;
            opp.CurrencyIsoCode = 'USD';
            opp.RecordTypeId = recoppDealReg.Id;// recopp.Id;
            opp.Type =  '2 Tier';
            opp.What_is_your_Role__c = 'Reseller';
            opp.Deal_Registration_Program__c = delPgrmList[1].Id;
            insert opp;
            
            List<OpportunityLineItem> oliList2 = Test_CreateOpportunity.createOpportunityLineItemList(opp.Id);            
            List<Id> delPgmId = new List<Id>();
            delPgmId.add(delPgrmList[0].Id);
            delPgmId.add(delPgrmList[1].Id);            
            List<Deal_Registration_Program__c> qdelPgrmList = [select id,Deal_Program_Number__c from Deal_Registration_Program__c where id IN :delPgmId];
            oliList2[0].Deal_Program_ID__c = qdelPgrmList[0].Deal_Program_Number__c+'-1;'+qdelPgrmList[1].Deal_Program_Number__c+'-2';
            update oliList2;
            
            OppLineItemRemoteActions_PRM.sendEmailForMultiplePrograms(opp.Id);
            
        }
        //Test.stopTest();
    }  
    
}