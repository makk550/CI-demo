@isTest(seeAllData = true)
public class testTriggers{
  public static boolean IS_TEST_PASS = FALSE;
    public static testMethod void testMeth_account_opp(){
    IS_TEST_PASS = TRUE;
       
       Account acc = new Account();
       acc.Name = 'Test Account';
       acc.Type = 'Customer';
       acc.GEO__c = 'LA';
       acc.Customer_Category__c = 'Enterprise';
       acc.Account_Status__c = 'New';
       acc.BillingStreet='Arlington';
       acc.BillingCity='NY';
       acc.BillingCountry='US';
       insert acc;
       
      
      Deal_Registration_Program__c drpObj = new Deal_Registration_Program__c();
      drpObj.Name = 'test';
      drpobj.partner_friendly_name__c='ibmjuvtfcuydfyrdyrd';
      drpObj.Start_Date__c = system.today()-1;
      drpObj.End_Date__c=  System.today()+1;
      drpObj.Deal_Program_Type__c = 'Reseller';
      insert drpObj;
      
       RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='Deal Registration'];
       
       Opportunity opp = new Opportunity();
       opp.Name = 'Test Oppty';
       opp.AccountId = acc.Id;
       
       Id recid = SystemIdUtility.getResellerDistRecordTypeId();
       
       Account testAcc=new Account(Name='Test Account', recordtypeid = recid);
        
        insert testAcc;
        
       
       opp.Reseller__c= testAcc.id;
       opp.Closedate = System.today();
       opp.StageName = Label.Opp_Stage_10_Percent;
       opp.RecordTypeId = recopp.Id;
       opp.Additional_Emails__c = 'test_tadkr01@ca.com;test_xyfctadkr01@ca.com';
       opp.Reseller_Win_Loss_Reason__c = 'Closed By Another Reseller1';
       opp.Reseller_Sales_Milestone__c = 'Closed - sWon';
       opp.closedate = system.today()+1;
       opp.Deal_Registration_Program__c = drpObj.Id;
       opp.Reseller__c = testAcc.id;
       opp.CurrencyIsoCode = 'USD';
       opp.Type='Direct';
       opp.Partner_Engagement__c='None';
    //   opp.deal_program_end_date__c= system.today()+2;
       insert opp;
        opp.Additional_Emails__c = 'test_tadkr01@ca.com';
        opp.Source__c = 'Deal Registration';
        opp.Reseller_Sales_Milestone__c = Label.Opp_Stage_Closed_Lost;
        opp.Reseller_Win_Loss_Reason__c = 'Closed By Another Reseller';
        opp.Reseller_Name__c = 'xyz';
        
       update opp;
        opp.Additional_Emails__c = null;
        opp.Reseller_Sales_Milestone__c = Label.Opp_Stage_Closed_Won;
        opp.Deal_Registration_Status__c ='Deal Rejected';
        opp.Deal_Registration_Rejection_Reason_Other__c = 'asd';
        opp.Deal_Rejection_Reason__c = 'asd';
        update opp;
      
    
       Test.startTest();
       
       Site_Association__c srObj1 = new Site_Association__c();
       srObj1.Name = 'test srObj1';
       srObj1.Account_Group__c = 'Z00';
       srObj1.Country_picklist__c= 'US - UNITED STATES';
       srObj1.State__c='New York';
       srObj1.City__c ='Austin';
       insert srObj1;
       
       Site_Association__c srObj2 = new Site_Association__c();
       srObj2.Name = 'test srObj2';
       srObj2.Account_Group__c = 'Z001';
       srObj2.Country_picklist__c= 'US - UNITED STATES';
       srObj2.State__c='New York';
       srObj2.City__c ='Austin';
       insert srObj2;
      Test.stopTest();
       Services_Request__c srObj = new Services_Request__c();
      // srObj.Name = 'test srObj';
      srObj.Oppty_Name__c = opp.Id;
      srObj.Ship_To__c = '1';
      srObj.Services_Request_Status__c = 'DDR Creation1';
       insert srObj;
       
        srObj.Services_Request_Status__c = 'DDR Creation';
        srObj.Government_Security_Clearance_Required__c = 'No';
        srObj.Ship_To__c = '1';
        srObj.sold_To__c = 'asd';
        srObj.Bill_to__c = 'bill';
        
         srObj.Ship_To_Site__c = srObj1.Id;
        srObj.sold_To_Site__c = srObj2.Id;
     //   srObj.Bill_to_Site__c = srObj3.Id;
       update srObj;
          
      
    }
}