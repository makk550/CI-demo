@IsTest
public class DelegateLeadChampion_Test {

     private static testmethod void testDelegateLeadChampion()
     {
           Profile p = [SELECT Id FROM Profile WHERE Name='Partner Champion'];
           Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        List<RecordTypes_Setting__c > listrecd=new List<RecordTypes_Setting__c >();
        RecordTypes_Setting__c rectype=new RecordTypes_Setting__c();
        rectype.Name='Commercial Account';
        rectype.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Account').getRecordTypeId();
        rectype.SObject_Name__c='Account';
        listrecd.add(rectype);
          RecordTypes_Setting__c rectype1=new RecordTypes_Setting__c();
        rectype1.Name='CA Enterprise Account';
        rectype1.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Enterprise Account').getRecordTypeId();
        rectype1.SObject_Name__c='Account';
        
           listrecd.add(rectype1);
         RecordTypes_Setting__c rectype2=new RecordTypes_Setting__c();
        rectype2.Name='Account Team Covered Account';
        rectype2.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        rectype2.SObject_Name__c='Account';
        
         listrecd.add(rectype2);
        
         RecordTypes_Setting__c rectype3=new RecordTypes_Setting__c();
        rectype3.Name='Reseller/Distributor Account';
        rectype3.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
        rectype3.SObject_Name__c='Account';
        
         listrecd.add(rectype3);
         
         
          RecordTypes_Setting__c rectype4=new RecordTypes_Setting__c();
        rectype4.Name='CA Indirect Lead';
        rectype4.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Indirect Lead').getRecordTypeId();
        rectype4.SObject_Name__c='Lead';
        
         listrecd.add(rectype4);
         
         
           RecordTypes_Setting__c rectype5=new RecordTypes_Setting__c();
        rectype5.Name='CA Global Lead';
        rectype5.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
        rectype5.SObject_Name__c='Lead';
        
         listrecd.add(rectype5);
         insert listrecd;
         
         id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();        
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Type__c='Reseller';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =res;
        ac.Commercial_ID__c = 'asdf';
        ac.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         ac.Solution_Provider__c=true;
        
         ac.Country_Picklist__c='US - UNITED STATES';
         ac.Solution_Provider_Type__c='Reseller';
         ac.Solution_Provider_Program_Level__c='Global';
         ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,Active_User__c=true);
        insert con; 
        Contact con2 = new Contact(LastName ='testCon2',AccountId = ac.Id,Active_User__c=true);
        insert con2;  
        User partnerUser = new User(alias = 't39856', email='test1239856@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con.id,
                                    timezonesidkey='America/Los_Angeles', username='test1239856@noemail.com',firstName= 'testg');
        insert partnerUser;
          User partnerUser2 = new User(alias = 't3467', email='test123467@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con2.id,
                                    timezonesidkey='America/Los_Angeles', username='test123467@noemail.com',firstName= 'test2');
         insert partnerUser2;
          system.runAs(partnerUser){
              date ds=date.today();
              Time myTime = Time.newInstance(0, 0, 0, 0);
             datetime dns=datetime.newInstance(ds, myTime) ;
              
         DelegateLeadChampion__c dlc=New DelegateLeadChampion__c();
          dlc.DelegateLeadChampion__c=partnerUser2.id; 
        //  dlc.StartDate__c= datetime.newInstance(2014, 9, 15, 12, 30, 0);                  //dns;
        //  dlc.EndDate__c= datetime.newInstance(2014, 9, 15, 13, 30, 0); 
                                             //system.Now().addDays(2);
             dlc.StartDate__c=system.Today()-1;
          dlc.EndDate__c=system.today()-2; 
              insert dlc;
            ApexPages.StandardController sc = new ApexPages.StandardController(dlc);
            DelegateLeadChampion testdelegate = new DelegateLeadChampion(sc);
              testdelegate.DlcRecord=dlc;
              testdelegate.saveDR();
          }
     }
     private static testmethod void testDelegateLeadChampion23()
     {
           Profile p = [SELECT Id FROM Profile WHERE Name='Partner Champion'];
           Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        List<RecordTypes_Setting__c > listrecd=new List<RecordTypes_Setting__c >();
        RecordTypes_Setting__c rectype=new RecordTypes_Setting__c();
        rectype.Name='Commercial Account';
        rectype.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Account').getRecordTypeId();
        rectype.SObject_Name__c='Account';
        listrecd.add(rectype);
          RecordTypes_Setting__c rectype1=new RecordTypes_Setting__c();
        rectype1.Name='CA Enterprise Account';
        rectype1.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Enterprise Account').getRecordTypeId();
        rectype1.SObject_Name__c='Account';
        
           listrecd.add(rectype1);
         RecordTypes_Setting__c rectype2=new RecordTypes_Setting__c();
        rectype2.Name='Account Team Covered Account';
        rectype2.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        rectype2.SObject_Name__c='Account';
        
         listrecd.add(rectype2);
        
         RecordTypes_Setting__c rectype3=new RecordTypes_Setting__c();
        rectype3.Name='Reseller/Distributor Account';
        rectype3.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
        rectype3.SObject_Name__c='Account';
        
         listrecd.add(rectype3);
         
         
          RecordTypes_Setting__c rectype4=new RecordTypes_Setting__c();
        rectype4.Name='CA Indirect Lead';
        rectype4.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Indirect Lead').getRecordTypeId();
        rectype4.SObject_Name__c='Lead';
        
         listrecd.add(rectype4);
         
         
           RecordTypes_Setting__c rectype5=new RecordTypes_Setting__c();
        rectype5.Name='CA Global Lead';
        rectype5.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
        rectype5.SObject_Name__c='Lead';
        
         listrecd.add(rectype5);
         insert listrecd;
         
         id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();        
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Type__c='Reseller';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =res;
        ac.Commercial_ID__c = 'asdf';
        ac.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac.Solution_Provider_CAM_PMFKey__c='BOYAL06';
         ac.Solution_Provider__c=true;
        
         ac.Country_Picklist__c='US - UNITED STATES';
         ac.Solution_Provider_Type__c='Reseller';
         ac.Solution_Provider_Program_Level__c='Global';
         ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,Active_User__c=true);
        insert con; 
        Contact con2 = new Contact(LastName ='testCon2',AccountId = ac.Id,Active_User__c=true);
        insert con2;  
        User partnerUser = new User(alias = 't3o8w', email='tester123o8w@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con.id,
                                    timezonesidkey='America/Los_Angeles', username='tester123o8w@noemail.com',firstName= 'test');
        insert partnerUser;
          User partnerUser2 = new User(alias = 'test34', email='tester1234@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con2.id,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test1');
         insert partnerUser2;
          system.runAs(partnerUser){
              date ds=date.today();
              Time myTime = Time.newInstance(0, 0, 0, 0);
             datetime dns=datetime.newInstance(ds, myTime) ;
              
         DelegateLeadChampion__c dlc=New DelegateLeadChampion__c();
          dlc.DelegateLeadChampion__c=partnerUser2.id; 
        //  dlc.StartDate__c= datetime.newInstance(2014, 9, 15, 12, 30, 0);                  //dns;
        //  dlc.EndDate__c= datetime.newInstance(2014, 9, 15, 13, 30, 0); 
                                             //system.Now().addDays(2);
             dlc.StartDate__c=system.Today();
          dlc.EndDate__c=system.today()-1; 
              insert dlc;
            ApexPages.StandardController sc = new ApexPages.StandardController(dlc);
            DelegateLeadChampion testdelegate = new DelegateLeadChampion(sc);
              testdelegate.DlcRecord=dlc;
              testdelegate.saveDR();
          }
     }
     private static testmethod void testDelegateLeadChampionexception()
     {
          Profile p = [SELECT Id FROM Profile WHERE Name='Partner Champion'];
           Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        List<RecordTypes_Setting__c > listrecd=new List<RecordTypes_Setting__c >();
        RecordTypes_Setting__c rectype=new RecordTypes_Setting__c();
        rectype.Name='Commercial Account';
        rectype.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Account').getRecordTypeId();
        rectype.SObject_Name__c='Account';
        listrecd.add(rectype);
          RecordTypes_Setting__c rectype1=new RecordTypes_Setting__c();
        rectype1.Name='CA Enterprise Account';
        rectype1.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CA Enterprise Account').getRecordTypeId();
        rectype1.SObject_Name__c='Account';
        
           listrecd.add(rectype1);
         RecordTypes_Setting__c rectype2=new RecordTypes_Setting__c();
        rectype2.Name='Account Team Covered Account';
        rectype2.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        rectype2.SObject_Name__c='Account';
        
         listrecd.add(rectype2);
        
         RecordTypes_Setting__c rectype3=new RecordTypes_Setting__c();
        rectype3.Name='Reseller/Distributor Account';
        rectype3.RecordType_Id__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
        rectype3.SObject_Name__c='Account';
        
         listrecd.add(rectype3);
         
         
          RecordTypes_Setting__c rectype4=new RecordTypes_Setting__c();
        rectype4.Name='CA Indirect Lead';
        rectype4.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Indirect Lead').getRecordTypeId();
        rectype4.SObject_Name__c='Lead';
        
         listrecd.add(rectype4);
         
         
           RecordTypes_Setting__c rectype5=new RecordTypes_Setting__c();
        rectype5.Name='CA Global Lead';
        rectype5.RecordType_Id__c=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
        rectype5.SObject_Name__c='Lead';
        
         listrecd.add(rectype5);
         insert listrecd;
         
         id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();        
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Type__c='Reseller';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =res;
        ac.Commercial_ID__c = 'asdf';
        ac.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         ac.Solution_Provider__c=true;
        
         ac.Country_Picklist__c='US - UNITED STATES';
         ac.Solution_Provider_Type__c='Reseller';
         ac.Solution_Provider_Program_Level__c='Global';
         ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,Active_User__c=true);
        insert con; 
        Contact con2 = new Contact(LastName ='testCon2',AccountId = ac.Id,Active_User__c=true);
        insert con2;  
        User partnerUser = new User(alias = 't123psp', email='tester123psp@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con.id,
                                    timezonesidkey='America/Los_Angeles', username='tester123psp@noemail.com',firstName= 'test');
        insert partnerUser;
          User partnerUser2 = new User(alias = 't1234u', email='tester1234u@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con2.id,
                                    timezonesidkey='America/Los_Angeles', username='tester1234u@noemail.com',firstName= 'test1');
         insert partnerUser2;
          system.runAs(partnerUser){
         DelegateLeadChampion__c dlc=New DelegateLeadChampion__c();
          dlc.DelegateLeadChampion__c=partnerUser2.id; 
          dlc.StartDate__c=system.today();
          dlc.EndDate__c=system.today()+1;
             // insert dlc;
            ApexPages.StandardController sc = new ApexPages.StandardController(dlc);
            DelegateLeadChampion testdelegate = new DelegateLeadChampion(sc);
              testdelegate.DlcRecord=dlc;
              testdelegate.saveDR();
          }
     }
}