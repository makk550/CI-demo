@isTest

public class dealRegApproverTriggerTest {

static testMethod void insertDealRegApprover(){

test.starttest();


   List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];            
     Deal_Registration_Program__c delPgrm = new Deal_Registration_Program__c();
            delPgrm.name = 'TestDRP';
            delPgrm.Partner_Friendly_Name__c = 'TestDRP';
            delPgrm.Description__c = 'TestDRP';
            delPgrm.Program_Manager__c = approvers[0].Id;
            delPgrm.Program_Queries__c = approvers[1].Id;
            delPgrm.First_Approver__c = approvers[2].Id;
            delPgrm.Second_Approver__c = approvers[3].Id;
            delPgrm.Third_Approver__c = approvers[4].Id; 
            delPgrm.Max_Deal_Value__c = 1000;
            delPgrm.Min_Deal_Value__c = 100;
            delPgrm.Start_Date__c = Date.today();
            delPgrm.End_Date__c = Date.today() + 3;
            delPgrm.Expiry_Days__c = 10;        
            delPgrm.CurrencyIsoCode = 'USD';    
            delPgrm.Finance_Approver_Email__c = 'approver@ca.com';
            delPgrm.Geography__c = 'NA';
            delPgrm.Country2__c = 'IN-INDIA';
            delPgrm.Country1__c = 'US-USA';
            delPgrm.Partner_Program_Level__c = 'Platinum';
            delPgrm.Primary_Business_Functions__c = 'Technology Alliance';
            delPgrm.Secondary_Business_Functions__c = 'OEM';
            delPgrm.Deal_Program_Type__c = 'Alliance';
      insert delPgrm;
      
      
      
      Deal_Reg_Approvers__c DRA = new Deal_Reg_Approvers__c();
      
            DRA.Deal_Registration_Program__c= delPgrm.Id;
            DRA.Region__c = 'NA';
            DRA.Approver__c = approvers[0].Id;
      insert DRA;
      
test.stopTest();

}

}