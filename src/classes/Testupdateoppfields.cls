@isTest(SeeAllData=true)
private class Testupdateoppfields {


 static testmethod void test_updateOpportunityFields_triggerClass() {
        Schema.DescribeSObjectResult accresult1 = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType1 = accresult1.getRecordTypeInfosByName();          
        ID techRecTypeId = accRecType1.get('Technology Partner').getRecordTypeId(); 
        ID ResellerRecTypeId = accRecType1.get('Reseller/Distributor Account').getRecordTypeId();
     
       //RecordType r1 = [Select id from Recordtype where name =: 'Reseller/Distributor Account' limit 1];
          Account resellerAcct = new Account(Alliance__c = true, RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;
        
        //RecordType r2 = [Select id from Recordtype where name =: 'Technology Partner' limit 1];
        Account techAcct = new Account(RecordTypeId= techRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert techAcct;
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId();  
        Opportunity opp = new Opportunity(RecordTypeId=recopp, Name = 'oppInsertTrigger1' , StageName = Label.Opp_Stage_Closed_Won , CloseDate = Date.today()
                            , AccountId = techAcct.Id, Reseller__c= resellerAcct.Id );
                insert opp;
        
        List<User> usrList = new List<User>();
        Profile profileid = [Select id From Profile where name = 'Regional Admin' limit 1];
        usrList = [select id from User where profileid =:  profileid.id and IsActive = true Limit 5]; 
         Opportunity_Registration__c rec = new Opportunity_Registration__c(Opportunity_Name__c = opp.id,name = 'test', Alliance_Partner__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id,
               Technology_Partner__c= techAcct.id, Alliance_Partner_Services_Revenue__c = 890, Technology_Partner_Lead__c  = usrList[3].id, Registration_Status__c = 'Partially Approved');
          
          insert rec;  
        
          
         Opportunity_Registration__c rec1 = new Opportunity_Registration__c(Opportunity_Name__c = opp.id,name = 'test', Alliance_Partner__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id,
               Registration_Status__c= 'Pending Approval', Technology_Partner__c= techAcct.id, Alliance_Partner_Services_Revenue__c = 890, Technology_Partner_Lead__c  = usrList[3].id);
          
         insert rec1;
         Opportunity_Registration__c rec2 = new Opportunity_Registration__c(Opportunity_Name__c = opp.id,name = 'test', Alliance_Partner__c = resellerAcct.id, 
               Field_Alliance_Leader__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id, 
               Technology_Partner__c= techAcct.id, Alliance_Partner_Services_Revenue__c = 890, Technology_Partner_Lead__c  = usrList[3].id, Registration_Status__c = 'Approved');
          
          insert rec2;
        Opportunity_Registration__c rec3 = new Opportunity_Registration__c(Opportunity_Name__c = opp.id,name = 'test', Alliance_Partner_2__c = resellerAcct.id, 
               Field_Alliance_Lead_2__c = usrList[0].id, Second_Approver__c = usrList[1].id, First_Approver__c = usrList[2].id,
               Technology_Partner__c= techAcct.id, Alliance_Partner_Services_Revenue__c = 890, Technology_Partner_Lead__c  = usrList[3].id, Registration_Status__c = 'Partially Approved');
          
          insert rec3; 
        rec1.name = 'test1';
        rec1.Registration_Status__c = 'Rejected';
        update rec1;
        delete rec1;
        
        
        
        
                
            }
    
    }