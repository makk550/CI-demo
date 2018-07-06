/*
 * Test class created by BAJPI01.
 * Creates account, opportunity, pricebook records, product and opplineitems, without
 * the use of seealldata = true.
 * Use this class to create instances of account, opp and line items without seealldata = true, but skips triggers.
 * 
 * NOTE - THIS CLASS IS USED IN A LOT OF OTHER TEST CLASSES. DO NOT COMMENT OUT ANY OPERATIONS WITHOUT
 * LOOKING AT THE DEPENDENCY.
 * 
 */ 

@isTest
public class testCreateAccOppandLineItemClass {
	
    //this method returns a map of Opportunity and OppLineItem List. Use this wherever opp and opplineitems are required.
    public static Map<Opportunity,List<OpportunityLineItem>> returnTestOpportunityDetails(){
                
        testCreateAccount.createTestAccountData();
        Account a = [select id from account limit 1];
        
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
        
        
        
        Opportunity opp = new Opportunity(RecordTypeId=recopp,Reseller__c = a.Id,
                                          Name = 'TestOpp' ,
                                          AccountId = a.Id,
                                          StageName = Label.Opp_Stage_10_Percent , 
                                          CloseDate = Date.today(),
                                          Start_Date__c = Date.today(),
                                          Type = 'Direct',
                                          Contract_Type__c = 'SAAS',
                                          Inside_Outside__c = 'Inside',
                                          CurrencyISOCode = 'USD',
                                          End_Date__c = Date.today().addMonths(12));
        insert opp;
        system.assertNotEquals(null, opp.id, 'Opportunity inserted');
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true );
        insert pb;
        system.assertNotEquals(null, pb.id, 'Pricebook inserted');
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true,Family='Product',Market_Focus_Area__c='Agile Central',Commissionable_BU__c ='AC');
        insert prod;
        system.assertNotEquals(null, prod.id, 'Product inserted');
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 1000, IsActive = true);
        insert pbe;
        system.assertNotEquals(null, pbe.id, 'PriceBook Entry inserted');
        
        
        List<OpportunityLineItem> OppItmList =new List<OpportunityLineItem>();
        for(integer i=0;i<15;i++)
        {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id, PricebookEntryId = pbe.Id, UnitPrice = 200,Business_Type__c = 'Renewal',
                                                              raw_maintenance__c=1.00,Start_Date__c = opp.Start_Date__c,End_Date__c = opp.End_Date__c );
            OppItmList.add(oli);
            i=i++;
        }
        insert OppItmList;
        for(OpportunityLineItem oli:OppItmList){
            system.assertNotEquals(null, oli.id, 'Opp Line Item inserted');
        }
        system.debug('size'+OppItmList.size());
        oppAndLineItemMap.put(opp,OppItmList);
        return oppAndLineItemMap;
    }

    public static void insertSterlingQuote(){
        
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        
        Opportunity opp;
        Map<Opportunity,List<OpportunityLineItem>> oppAndLineItemMap = testCreateAccOppandLineItemClass.returnTestOpportunityDetails();
        Set<Opportunity> OppSet = oppAndLineItemMap.keySet();
        for(Opportunity tempOpp:Oppset){
            Opp = tempOpp;
        }
        
        
        scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
         sterlingQuote.scpq__OpportunityId__c=opp.Id;
        sterlingQuote.Name='Sterlingquote1';
        sterlingQuote.Ramp_Bridge_Order__c=false;
        sterlingQuote.Is_this_an_Agile_Central_Transaction__c='Light';
        sterlingQuote.scpq__Status__c='Approved';
        sterlingQuote.CA_CPQ_Quote_Number__c = 'testquote';
        sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch';
        sterlingQuote.Sold_To_Address__c='fffff';
        sterlingQuote.CA_CPQ_Quote_Total__c=5000;     
        sterlingQuote.CA_Sold_To_ID__c='344234';
        sterlingQuote.CA_Customer_Name_Sold_To__c='adasda';
        sterlingQuote.CA_Technical_Contact_Name__c='Test tech contact name';
        sterlingQuote.CA_Bill_To_ID__c='56757';
        sterlingQuote.CA_Bill_To_Name__c='xxxx';
        sterlingQuote.CA_Billing_Contact_Name__c='qqq';
        sterlingQuote.CA_Ship_To_ID__c='22';
        sterlingQuote.CA_Ship_To_Name__c='rrrr';
        sterlingQuote.CA_Shipping_Contact_Name__c='wwww';
        sterlingQuote.CA_Service_Provider_ID__c='eeeeeee';
        sterlingQuote.CA_Service_Provider_Name__c='hhhhh';
        sterlingQuote.CA_End_User_Contact_Name__c='iiiii';
        sterlingQuote.CA_End_User_ID__c='oooo';
        sterlingQuote.CA_End_User_Name__c='nnnnn';
        sterlingQuote.CA_Direct_Indirect__c='direct';
        sterlingQuote.CA_Sales_Area__c='vvvvv';
        sterlingQuote.CurrencyIsoCode='USD';
        sterlingQuote.CA_Services_Included__c='ttttttt';
        sterlingQuote.CA_Annual_Srvs_Edu_In_Transaction__c=55555;
        sterlingQuote.CA_Total_Old_TRR__c=6666666;
        sterlingQuote.CA_Revenue_Per_Day_Percentage__c=98;
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';/*YEDRA01 for AR:2994*/
        sterlingQuote.CA_Contracted_Renewal__c='444';
        sterlingQuote.CA_Purchase_Order_Number__c='5555';
        sterlingQuote.CA_Effective_Date__c=System.today();
        sterlingQuote.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote.scpq__OrderHeaderKey__c='cccc333333'; 
        sterlingQuote.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.Ship_To_Address__c='dddd';
        sterlingQuote.Sold_To_Address__c='dddd,CN';
        sterlingQuote.Bill_To_Address__c='dddd';
        sterlingQuote.Agile_Central_Clauses__c='ELA';
        sterlingQuote.Services_Payment__c=666;
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        
        insert sterlingQuote;
        system.assertNotEquals(null, sterlingQuote.id, 'Sterling Quote inserted');
        
    }
    

}