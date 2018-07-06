/*
 * Test class for Class - Opportunity_ContactRole_Class 
 * Coverage - 92%
 * Updated by - BAJPI01
*/ 

@istest
public class Opportunity_ContactRole_Class_Test {
    
    @isTest      
    static void oppcontactroleTest() {
        Opportunity_ContactRole_Class ocr = new Opportunity_ContactRole_Class();
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipOpportunityTriggers = true;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityLineItemTriggers = true;
        
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = new Map<Opportunity,List<OpportunityLineItem>>();
        
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();          
        Id recopp = oppRecType.get('New Opportunity').getRecordTypeId(); 
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        //recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        id com = accRecType.get('SMB').getRecordTypeId();
        account a = new account(name ='Generic Support Account 1234we', recordtypeid =res);
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'JP - JAPAN';
        a.GEO__c= 'JAPAN';
        a.Sales_Area__c= 'JAPAN';
        a.Sales_Region__c= 'JAPAN';
        a.Billingstate= 'A';
        a.Billingcity= 'B';
        a.Billingstreet= 'C';
        insert a;
         
        account B = new account(Name= 'test acc' ,BillingState = 'NY',Commercial_ID__c = 'asdf', recordtypeid =res,
                                Sales_Area__c= 'JP',Billingstreet= 'acc',Billingcity= 'bcc',
                                Customer_Category__c = 'Enterprise',GEO__c='JAPAN',Enterprise_ID__c = '1234te',Country_Picklist__c= 'JP - JAPAN');
        INSERT b;
      
        Set<Id>  accids = new set<Id>();
        accids.add(a.id);
        accids.add(b.id);
        
        
        system.assertNotEquals(null, a.id, 'Account inserted');
        
        Opportunity opp = new Opportunity(RecordTypeId=recopp,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          StageName = 'test' , 
                                          CloseDate = Date.today(),
                                          New_Deal_Term_months__c = 12, 
                                          Stretch_Deal_Term_Months__c = 8,
                                          Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
                                          Business_Type__c = 'High Touch',
                                          Projected_Renewal__c = 12345.0,
                                          Start_Date__c = Date.today(),
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        system.assertNotEquals(null, opp.id, 'Opportunity inserted');
        Set<id> oppidset = new set<id>();
        oppidset.add(opp.id);
        String[] partnerpmfkeys = new String[]{'tesus01','testus02','tesus03','tesus04'};
        Map<Id,boolean> oppPrimaryCntRoleMap = Opportunity_ContactRole_Class.oppPrimaryContactRole(oppIdset);
        User Currentloggedinuser =  Opportunity_ContactRole_Class.currentuserinfo(  UserInfo.getUserId());
         List<User> partnerusers =  Opportunity_ContactRole_Class.partneruserlist(partnerpmfkeys);
        List<Account> acctlist =  Opportunity_ContactRole_Class.accountslist(accids);
       List<Partner_Engagement_Program__c> partnerlist =  Opportunity_ContactRole_Class.partneropplist(oppIdset);
    }

}