/* updateOpportunityFields
	code coverage: 72%
*/


@istest
public class clsRegisterOpportunityTestClass {
     @isTest(SeeAllData=true)
    static void clsRegisterOpportunityTestClass() {
    
        //ApexPages.StandardController stdController = new ApexPages.StandardController();
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult accresult1 = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType1 = accresult1.getRecordTypeInfosByName();          
        ID techRecTypeId = accRecType1.get('Technology Partner').getRecordTypeId(); 
        ID ResellerRecTypeId = accRecType1.get('Reseller/Distributor Account').getRecordTypeId();
        
        //RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
        //ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
         Account resellerAcct = new Account(Alliance__c = true, RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;
        
        //ID techRecTypeId= SystemIdUtility.getTechPartnerRecordTypeId();
        Account techAcct = new Account(RecordTypeId= techRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert techAcct;
        Test.startTest();
        Opportunity opp = new Opportunity(RecordTypeId=recopp, Name = 'oppInsertTrigger1' , StageName = Label.Opp_Stage_Closed_Won , CloseDate = Date.today()
                    , AccountId = techAcct.Id, Reseller__c= resellerAcct.Id,ReasonField__c='we got contract' );
        insert opp;
        
        List<User> usrList = new List<User>();
        Profile profileid = [Select id From Profile where name = '1.0 CA Sys Admin Commit & PR' limit 1];
        usrList = [select id from User where profileid =:  profileid.id and IsActive = true Limit 5]; 
        
         Opportunity_Registration__c rec = new Opportunity_Registration__c(name = 'test', Alliance_Partner__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id,
               Registration_Status__c= 'Pending Approval', Alliance_Partner_Services_Revenue__c = 890,Partner_Engagement_Phase__c='Joint Pursuit',JSO_Name__c='Accenture-WW-Application Delivery-LISA-SV');

          insert rec;
         Opportunity_Registration__c rect1 = new Opportunity_Registration__c(name = 'test', Alliance_Partner_2__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id, 
                Alliance_Partner_Services_Revenue__c = 890,  Registration_Status__c = 'Partially Approved',Partner_Engagement_Phase__c='Joint Pursuit',JSO_Name__c='Accenture-WW-Application Delivery-LISA-SV');
          
          insert rect1;  
          rect1.name = 'test123';
          rect1.Opportunity_Name__c = opp.Id;
          rect1.Registration_Status__c  = 'Terminated';  
          update rect1;
          delete rect1;
          
         Test.stopTest(); 
        PageReference oppReg = Page.RegisterOpportunity;
        oppReg.getParameters().put('oppid',opp.Id);
        Test.setCurrentPage(oppReg);
        ApexPages.StandardController stdcon2 = new ApexPages.StandardController(rec);
        clsRegisterOpportunity obj = new clsRegisterOpportunity(stdcon2);
        obj.save();
        obj.saveNsubmit();
        obj.cancel();
        
        
        
        
        ApexPages.StandardController stdcon4 = new ApexPages.StandardController(rec);
        clsRegisterOpportunity obje2 = new clsRegisterOpportunity(stdcon4);
        
        rec.Field_Alliance_Leader__c = null;
        rec.JSO_Name__c = null;
        rec.Alliance_Partner_2__c = resellerAcct.id;
        rec.Field_Alliance_Lead_2__c = null;
        rec.Partner_Engagement_Phase_2__c = null;
        rec.JSO_Name_2__c = null;
        //rec.Technology_Partner_Lead__c = null;
        update rec;
        ApexPages.StandardController stdcon5 = new ApexPages.StandardController(rec);
        clsRegisterOpportunity obje3 = new clsRegisterOpportunity(stdcon5);
        
        rec.Alliance_Partner__c = null;
        rec.Technology_Partner__c = null;
        update rec;
        
        rec.Alliance_Partner__c = resellerAcct.id;
        rec.Technology_Partner__c = null;
        rec.Registration_Status__c  = 'Approved';
        rec.Opportunity_Name__c = opp.Id;
        update rec;
        
        rec.Registration_Status__c  = 'Terminated';
        update rec;
        
        clsRegisterOpportunity obj1 = new clsRegisterOpportunity(stdcon2);
        obj1.showAlliance = true;
        //obj1.save();
        obj1.saveNsubmit();
        obj1.cancel();
        
        
       /* rec.Technology_Partner__c = null;
        rec.Alliance_Partner_2__c = null;
        update rec;
        clsRegisterOpportunity obj2 = new clsRegisterOpportunity(stdcon2);
        obj2.showAlliance = false;
        obj2.save();
        obj2.saveNsubmit();
        obj2.cancel();
        
        rec.Alliance_Partner__c = resellerAcct.id;
        update rec;
        clsRegisterOpportunity obj3 = new clsRegisterOpportunity(stdcon2);
        obj3.showAlliance = false;
        obj3.save();
        obj3.saveNsubmit();
        obj3.cancel();
        
        rec.Alliance_Partner_2__c = resellerAcct.id;
        rec.Field_Alliance_Lead_2__c = null;
        update rec;
        clsRegisterOpportunity obj4 = new clsRegisterOpportunity(stdcon2);
        obj4.save();
        obj4.saveNsubmit();
        obj4.cancel();
        
        rec.Technology_Partner__c = resellerAcct.id;
        update rec;
        clsRegisterOpportunity obj5 = new clsRegisterOpportunity(stdcon2);
        obj5.save();
        obj5.saveNsubmit();
        obj5.cancel();
        
        rec.First_Approver__c = null;
        rec.Second_Approver__c = null;
        update rec;
        clsRegisterOpportunity obj6 = new clsRegisterOpportunity(stdcon2);
        obj6.save();
        obj6.saveNsubmit();
        obj6.cancel();
        Test.stopTest(); */
        
        }
   
    
    }