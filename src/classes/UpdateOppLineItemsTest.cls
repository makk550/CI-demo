@istest(SeeAllData=true)
public class UpdateOppLineItemsTest{
static boolean tempBool = SystemIdUtility.skipProductTriggers;

@istest(SeeAllData=true)
public static void UpdateOppLineItemsTestMethod(){

SystemIdUtility.skipProductTriggers = false;


     
   Product2 prd1= new Product2(Name='Prd1',SKU__c = 'CAAAVM1600W00C6', Upfront_Revenue_Eligible__c = 'No',Family='Product',Market_Focus_Area__c='Test1',IsActive=true);
   Product2 prd2 = new Product2(Name='Prd2', SKU__c = 'CAD2DCR16A005DG',Upfront_Revenue_Eligible__c = 'No',Family='Time',Market_Focus_Area__c='Test2',IsActive=true);
        
   Product2[] prd = new Product2[]{prd1,prd2};
   insert prd ;
   
   
   
    Pricebook2 pb = new Pricebook2();
    pb = [Select Id from Pricebook2 where IsStandard=true];
    
    PricebookEntry pbe1 = new PricebookEntry(Product2Id=prd[0].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true); 
    PricebookEntry pbe2 = new PricebookEntry(Product2Id=prd[1].Id,Pricebook2Id=pb.Id,UnitPrice=2,IsActive=true);
   
    PricebookEntry[] pbe = new PricebookEntry[]{pbe1,pbe2};
    insert pbe;
   
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;    

      Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
    Id oppRecId = oppRecType.get('New Opportunity').getRecordTypeId();
    
   Opportunity opp = new Opportunity(AccountId=smbAcct.Id,Reseller__c=resellerAcct.Id,CloseDate=Date.today().addDays(5), Name='Opp1',Type='DM',RecordTypeId=oppRecId,StageName=Label.Opp_Stage_10_Percent,
                                     Initial_Billing__c=2,Start_Date__c = Date.today(), End_Date__c = Date.today().addMonths(12));       
   insert opp; 
   
    OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[0].Id,UnitPrice=6,Business_Type__c='Upgrade');
    OpportunityLineItem oli5 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[1].Id,Term_Month__c=2,UnitPrice=6,Business_Type__c='Upgrade');
    OpportunityLineItem oli6 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[1].Id,Term_Month__c=2,UnitPrice=6,Business_Type__c='Upgrade');
    OpportunityLineItem oli7 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[0].Id,Term_Month__c=2,UnitPrice=6,Business_Type__c='Upgrade');
    OpportunityLineItem oli8 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[1].Id,Term_Month__c=2,UnitPrice=6,Business_Type__c='Upgrade');
    OpportunityLineItem oli9 = new OpportunityLineItem(OpportunityId=opp.Id,PricebookEntryId = pbe[0].Id,Term_Month__c=2,UnitPrice=6,Business_Type__c='Upgrade');
    OpportunityLineItem[] oli = new OpportunityLineItem[]{oli4,oli5,oli6,oli7,oli8,oli9};
    SystemIdUtility.skipOpportunityLineItemTriggers = true;
    insert oli;
   
   prd.get(0).Upfront_Revenue_Eligible__c = 'Yes';
   prd.get(1).Upfront_Revenue_Eligible__c = 'Yes';
   
   update prd;
   
   SystemIdUtility.skipOpportunityLineItemTriggers = false;
   delete oli;
   delete prd;
   SystemIdUtility.skipProductTriggers = tempBool;
}
}