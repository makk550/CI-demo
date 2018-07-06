@isTest(seeAllData = true)
public class testExt_PartnerLeadRouting{
    public static testMethod void testMeth_PLRRouting(){
    
          User u = new User();
          u.FirstName = 'dfn';
          u.LastName = 'ln';
          u.email = 'fnlnjhnmi@ca.com';
          u.username='asddg09@ca.com';
          u.alias = 'asdxcvc';
          u.profileId = [select id from profile where name='System Administrator' limit 1].Id;
          u.Eligible_to_receive_leads__c  = true;
          u.EmailEncodingKey='UTF-8';
          u.TimeZoneSidKey='Pacific/Fiji';
          u.LanguageLocaleKey='en_US';
          u.LocaleSidKey='ar';
          insert u;
    
          Account testAcc=new Account(Name='Test Account' ,Lead_Champion__c = u.Id,Velocity_Seller__c=true,Velocity_Seller_Type__c='Reseller',
          RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
    
          insert(testAcc);
          
          Route_to_market__c rtmObj = new Route_to_market__c();
          rtmObj.Account__c = testAcc.Id;
          rtmObj.Name = 'etst rtm';
          rtmObj.RTM__c = 'Alliance';
          rtmObj.RTM_Type__c = 'RM Other';
          insert rtmObj;
         
          Product_Alignment__c paObj = new Product_Alignment__c();
          paObj.Route_to_market__c = rtmObj.Id;
          paObj.Related_Account__c = testAcc.Id;
          paObj.Business_Unit__c = 'Alliance';
          paObj.Product_Group__c = 'Antivirus';
          insert paObj;
          
       
         Campaign c= new Campaign(Name='test camp');
         insert c;
      
        Partner_Lead_Routing_Rules__c plrr=new Partner_Lead_Routing_Rules__c();
        plrr.Campaign__c=c.id;
        plrr.Account__c=testAcc.id;
         plrr.BU__c = 'Other';
        plrr.NCV_Driver__c = 'RM Other';
        plrr.Product_Group__c = 'Antivirus';
         plrr.Rule_Start_Date__c=system.today()-1;
         plrr.Rule_Expiration_Date__c=system.today()+1;
         plrr.Tie_Breaker_Rule__C = 'Round Robin';
        insert(plrr);
        
           
            Account testAcc1=new Account(Name='Test Account1' ,Lead_Champion__c = u.Id,
          RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId());
    
          insert(testAcc1);
          
          
          Product_Alignment__c paObj1 = new Product_Alignment__c();
         // paObj1.Route_to_market__c = rtmObj.Id;
          paObj1.Related_Account__c = testAcc1.Id;
          paObj1.Business_Unit__c = 'Other';
          paObj1.Product_Group__c = 'Antivirus';
          insert paObj1;
          
         Campaign c1= new Campaign(Name='test camp1');
         insert c1;
        
         Partner_Lead_Routing_Rules__c plrr1=new Partner_Lead_Routing_Rules__c();
        plrr1.Campaign__c=c1.id;
        plrr1.Account__c=testAcc.id;
        plrr1.Rule_Start_Date__c=system.today()-20;
         plrr1.Rule_Expiration_Date__c=system.today();
     
         plrr1.RTM__c = 'Alliance';
        plrr1.RTM_Type__c = 'Reseller';
        plrr1.Product_group__c = 'Antivirus';
        plrr1.Tie_Breaker_Rule__c = 'Score';
        insert(plrr1);
        
    }
}