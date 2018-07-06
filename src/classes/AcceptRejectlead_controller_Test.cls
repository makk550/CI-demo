@isTest (seealldata=true)
public class AcceptRejectlead_controller_Test {
  
    private static testmethod void testAccept()
     {
        String strRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='CAIndirectLead'].Id;
         String strdelRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='Deal_Registration'].Id;
           id p = [SELECT Id FROM Profile WHERE Name='Partner Champion'].id;
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Type__c='Reseller';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        ac.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       //ac.IsPartner = true; 
          
         ac.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         ac.Solution_Provider__c=true;
        
         ac.Country_Picklist__c='US - UNITED STATES';
         ac.Solution_Provider_Type__c='Reseller';
         ac.Solution_Provider_Program_Level__c='Global';
         ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac; 
        
       // Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,Active_User__c=true);
       // insert con; 
         Contact contactacct =[SELECT AccountId,ID,Account.Account_Type__c FROM Contact WHERE Is_Partner_Acc__c = 'true' and Account.Account_Type__c='Reseller' LIMIT 1];
        Contact con=new Contact();        
        con.LastName='trail';
        con.FirstName='try';
         con.Active_User__c=true;
        con.email='trytest@gg.com';
        con.Country_Picklist__c='DZ - ALGERIA';
        //con.Is_Partner_Acc__c ='true';
        con.AccountId=contactacct.AccountId;
        insert con;
         system.debug(' ===== con is ' + con);
         
           
         system.debug(' ===== con is ' + con);
           User partnerUser1 = new User(alias = 'test123', email='test1234@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='testersd@noemail.com',FirstName='partne');
        insert partnerUser1;
         
         system.debug(' ===== account is ' + ac);
         system.debug(' ===== user is ' + partnerUser1);
          system.debug(' ===== user UserType ' + partnerUser1.Is_Partner_User__c);
         system.debug(' ===== record type is ' + strRecordTypeId);
         
         system.runAs(partnerUser1){
      lead ld=New Lead();
         ld.LastName='Sesi Test';
         ld.Company='Company Test';
         ld.Status='New';
         ld.RecordTypeId=strRecordTypeId;
         ld.mkto71_Lead_Score__c=1.23;
         ld.RTM__c='Solution Provider';
         ld.Is_Lead_Owner_Partner__c=true;
         ld.Reseller__c=con.AccountId;
         ld.Reseller_Contact_Name__c=con.id;
             
             try
             { insert ld;
                           system.debug('=====lead ' + ld);

             
             }
             catch(exception e)
             {
                 system.debug(' exce is ' + e);
             }
        
         
             system.debug(' ===== lead is ' + ld);
             
      system.debug('--ld--'+ld);
         //PageReference pageRef = Page.AcceptRejaectlead;
      //pageRef.getParameters().put('id',ld.id);
      //Test.setCurrentPage(pageRef);
     

       
    ApexPages.StandardController sc = new ApexPages.StandardController(ld);
            PageReference pageRef = Page.LeadViewOverride;
                              Test.setCurrentPage(pageRef);
             pageRef.getParameters().put('id', String.valueOf(ld.Id));
          system.debug('====ld.id==='+ld.id);
             ld.AcceptReject__c='Accept';
             ld.RecordTypeId=strdelRecordTypeId;
         update ld;
         // ApexPages.currentPage().getParameters().put('id', ld.id);
         string idstr= ApexPages.currentPage().getParameters().get('id');
             System.debug('===idstr=='+idstr);
     PLD_AcceptRejectCntrllr testAcceptreject = new PLD_AcceptRejectCntrllr(sc);
          

         testAcceptreject.showPopup();
    testAcceptreject.save();
         testAcceptreject.submit();
             testAcceptreject.closePopup();
         } 
     }
    
    
      private static testmethod void testRejecttoqueue()
     {
           String strRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='CAIndirectLead'].Id;
         String strdelRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='LeadRoutingMatrix__c' and name ='Account_Score'].Id;
           id p = [SELECT Id FROM Profile WHERE Name='Partner Champion'].id;
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Type__c='Reseller';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        ac.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         ac.Solution_Provider__c=true;
        
         ac.Country_Picklist__c='US - UNITED STATES';
         ac.Solution_Provider_Type__c='Reseller';
         ac.Solution_Provider_Program_Level__c='Global';
         ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac; 
        
        
       Contact contactacct =[SELECT AccountId,ID,Account.Account_Type__c FROM Contact WHERE Is_Partner_Acc__c = 'true' and Account.Account_Type__c='Reseller' LIMIT 1];
        Contact con=new Contact();        
        con.LastName='trail';
        con.FirstName='try';
         con.Active_User__c=true;
        con.email='trytest@gg.com';
        con.Country_Picklist__c='DZ - ALGERIA';
        //con.Is_Partner_Acc__c ='true';
        con.AccountId=contactacct.AccountId;
        insert con;
         system.debug(' ===== con is ' + con);
           User partnerUser = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='testers@noemail.com',FirstName='partne');
        insert partnerUser;
       
          system.runAs(partnerUser){
      lead ld=New Lead();
         ld.LastName='Sesi Test';
         ld.Company='Company Test';
         ld.Status='New';
         ld.RecordTypeId=strRecordTypeId;
         ld.mkto71_Lead_Score__c=1.23;
 ld.Reseller__c=con.AccountId;
         ld.Reseller_Contact_Name__c=con.id;
         insert ld;
        LeadRoutingMatrix__c lrm1=New LeadRoutingMatrix__c();
             lrm1.Partner_Lead__c=ld.id;
              lrm1.RecordTypeId=strdelRecordTypeId;
              lrm1.Statuss__c='Eligible';
              lrm1.AccountScore__c=0.70;
              lrm1.Total_Account_Score_Reason__c='Abcd';
              insert lrm1;
          LeadRoutingMatrix__c lrm2=New LeadRoutingMatrix__c();
             lrm2.Partner_Lead__c=ld.id;
              lrm2.RecordTypeId=strdelRecordTypeId;
              lrm2.Statuss__c='Assigned to Partner';
              lrm2.AccountScore__c=0.90;
              lrm2.Total_Account_Score_Reason__c='Abcd';
              insert lrm2;
      system.debug('--ld--'+ld);
         PageReference pageRef = Page.LeadViewOverride;
      pageRef.getParameters().put('id',ld.id);
      Test.setCurrentPage(pageRef);
    ld.AcceptReject__c='Reject';
         ld.Rejection_Reason__c='Not Enough Bandwidth';
         update ld;

       
    ApexPages.StandardController sc = new ApexPages.StandardController(ld);
       
     PLD_AcceptRejectCntrllr testAcceptreject = new PLD_AcceptRejectCntrllr(sc);
          String ids = ApexPages.currentPage().getParameters().get('id');
        testAcceptreject.showPopup();
        testAcceptreject.save();
         testAcceptreject.submit();
              testAcceptreject.closePopup();
          }  
     }
}