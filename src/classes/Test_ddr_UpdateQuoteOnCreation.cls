@isTest(SeeAllData=true)
public class Test_ddr_UpdateQuoteOnCreation {
            
     public static testmethod void createDDR(){
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
       
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
                insert resellerAcct;                
                
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
                insert smbAcct;
                
        Opportunity testOppty=new Opportunity();
        testOppty.AccountId=smbAcct.Id;
        testOppty.Name='testOpp';        
        testOppty.StageName='10%-Unqualified Opp.';
        testOppty.CloseDate=System.today();
        testOppty.Inside_Outside__c='Outside';
        testOppty.Initial_Billing__c=1200;        
        testOppty.Type='FM4';
        testOppty.Deal_Review__c='YELLOW, Needs Work!';        
        testOppty.Solution_Playbook_Triggers__c='Agile CLoud Delivery';
        //testOppty.RecordTypeId=oppRectypeId;
        testOppty.Reseller__c=resellerAcct.Id;
        testOppty.OwnerId =UserInfo.getUserId();
        insert testOppty;
        
        scpq__SciQuote__c  sterlingQuote=new scpq__SciQuote__c();
        sterlingQuote.scpq__OpportunityId__c=testOppty.Id;
        sterlingQuote.Name='Sterlingquote1';
        sterlingQuote.scpq__Status__c='Approved';
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
        sterlingQuote.CA_Commissionable_Area__c='Medium Touch Nimsoft SaaS';//YEDRA01 for AR:2994
        sterlingQuote.CA_Contracted_Renewal__c='444';
        sterlingQuote.CA_Purchase_Order_Number__c='5555';
        sterlingQuote.CA_Effective_Date__c=System.today();
        sterlingQuote.CA_Contract_End_Date__c=System.today()+120;
        sterlingQuote.CA_CPQ_Quote_Status__c='Approved';
        //sterlingQuote.CPQ_Quote_Number__c,
        sterlingQuote.scpq__OrderHeaderKey__c='cccc333333'; 
        sterlingQuote.scpq__SciLastModifiedDate__c=System.Today();
        //sterlingQuote.CA_Quote_Type__c='New Product';
        sterlingQuote.Ship_To_Address__c='dddd,aaa,xxx';
        sterlingQuote.Sold_To_Address__c='dddd,CN';
        sterlingQuote.Bill_To_Address__c='dddd,vfg,tyu,ert';
        sterlingQuote.Services_Payment__c=666;
        sterlingQuote.Technical_Contact_Email_Address__c='test@test.com';
        sterlingQuote.Technical_Contact_Phone__c='9999977777';
        sterlingQuote.Bill_To_Phone__c='9999977777';
        sterlingQuote.Bill_To_Email_Address__c='test@test.com';        
        sterlingQuote.Order_Form__c='66666';
        insert sterlingQuote;       
        
        system.debug('sterlingQuote======='+sterlingQuote);
        Deal_Desk_Review__c ddr = new Deal_Desk_Review__c();
        ddr.Sterling_Quote__c = sterlingQuote.Id;
        ddr.Opportunity_Name__c =testOppty.Id;
        insert ddr;
        
        system.debug('sterlingQuote======='+ddr.Id);
     }
}