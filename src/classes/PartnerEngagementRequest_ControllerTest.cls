@isTest(seealldata=true) 
public class PartnerEngagementRequest_ControllerTest {
    public static testMethod void PartnerEngagementRequest_test()
    {
         user u1=new user(id='00530000003rQuJ');

   // system.runas(u1){
        
            Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true);
            acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
            insert acc;
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            contact con=new contact(lastname='con1',accountid=acc.id,Email='ra@ca.com',Active_User__c=true);
            insert con;
            Profile p = [SELECT Id FROM Profile WHERE Name=:'System Administrator']; 
       
            User u = new User(Alias = 'standt1', Email='ra@ca.com', 
                              EmailEncodingKey='UTF-8',FirstName='abc', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='ra@ca.com',isactive=true);
            insert u;
               
 			

        
        
        
          RecordType rt = new RecordType();
        rt = [select id from RecordType where Name='Deal Registration' and isActive = true and sObjectType = 'Opportunity' limit 1];   
       //get standard pricebook
Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
insert pbk1;
Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true,Family='Product',Market_Focus_Area__c='SECURITY');
insert prd1;
PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
insert pbe1; 
      
      test.startTest();
          Opportunity opp = new Opportunity();
                opp.Name = 'test opp';
            if(rt.Id != null)
                opp.RecordTypeId = rt.Id;
                opp.AccountId = acc.Id ;
                //opp.End_User_Contact__c = c.Id;
                opp.CloseDate = system.today()+1;
                opp.stageName = 'Negotiation';
                 opp.First_Approver__c=u.id;
                 opp.Initiated_By__c='Partner';
                 opp.Deal_Registration_Status__c='New';            

            insert opp;          
       
 

OpportunityLineItem lineItem1 = new OpportunityLineItem (OpportunityID=opp.id,PriceBookEntryID=pbe1.id, quantity=4, totalprice=200);
insert lineItem1; 
 ApexPages.currentPage().getParameters().put('oppId',opp.id);
 ApexPages.StandardController stdController=new ApexPages.StandardController(new Partner_Engagement_Program__c());
 PartnerEngagementRequest_Controller pec=new PartnerEngagementRequest_Controller(stdController);
 pec.per.Relationship_with_Customer__c =true;
 pec.per.Engagement_Approver__c=u.id;
 pec.save();
         test.stoptest(); 
        /*
 pec.saveNsubmit();
 pec.cancel();
*/

        
Partner_Engagement_Program__c per1=new Partner_Engagement_Program__c(Customer_Procurement__c=true,Parent_Opportunity__c=opp.id,Engagement_Approver__c=u.id);
insert per1;

    }
   
 }