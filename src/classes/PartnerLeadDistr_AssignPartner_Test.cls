@isTest
private class PartnerLeadDistr_AssignPartner_Test {

     static testmethod void testSortAndAssignPartnermap(){
          SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true; 
        String strRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='CAIndirectLead'].Id;
        
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
         Account aclc = new Account();
        aclc.Name = 'Test Account';
        aclc.BillingState = 'NY';   
        aclc.Customer_Category__c = 'Enterprise';
        aclc.Account_Type__c='Reseller';
        aclc.GEO__c='NA';
        aclc.Enterprise_ID__c = '1234te';       
        aclc.Enterprise_Account_Name__c = 'rdName';
        aclc.RecordTypeId =res;
        aclc.Commercial_ID__c = 'asdf';
        aclc.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         aclc.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         aclc.Solution_Provider__c=true;
        
         aclc.Country_Picklist__c='US - UNITED STATES';
         aclc.Solution_Provider_Type__c='Reseller';
         aclc.Solution_Provider_Program_Level__c='Global';
         aclc.Solution_Provider_Designation__c='Partner of Franchisee';
        insert aclc; 
         Contact conlc = new Contact(LastName ='testCon',AccountId = aclc.Id,Active_User__c=true);
        insert conlc; 
        
        User partnerUserlc = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=conlc.id,
                                    timezonesidkey='America/Los_Angeles', username='tester1623g4@noemail.com',firstName= 'test');
        insert partnerUserlc;
         
         
         
         
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
        ac.Lead_Champion__c=partnerUserlc.id;
         ac.Country_Picklist__c='US - UNITED STATES';
         ac.Solution_Provider_Type__c='Reseller';
         ac.Solution_Provider_Program_Level__c='Global';
         ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac; 
         Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,Active_User__c=true);
        insert con; 
        
        User partnerUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con.id,
                                    timezonesidkey='America/Los_Angeles', username='tester16234@noemail.com',firstName= 'test');
        insert partnerUser;

		 Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.BillingState = 'NY';   
        ac1.Customer_Category__c = 'Enterprise';
        ac1.Account_Type__c='Reseller';
        ac1.GEO__c='NA';
        ac1.Enterprise_ID__c = '1234te';       
        ac1.Enterprise_Account_Name__c = 'rdName';
        ac1.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        ac1.Commercial_ID__c = 'asdf';
        ac1.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac1.Solution_Provider_CAM_PMFKey__c='PONSE01';
         ac1.Solution_Provider__c=true;
          ac1.Lead_Champion__c=partnerUserlc.id;
         ac1.Country_Picklist__c='US - UNITED STATES';
         ac1.Solution_Provider_Type__c='Reseller';
         ac1.Solution_Provider_Program_Level__c='Global';
         ac1.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac1; 
         Contact con1 = new Contact(LastName ='testCon',AccountId = ac1.Id,Active_User__c=true);
        insert con1; 
        
        User partnerUser1 = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con1.id,
                                    timezonesidkey='America/Los_Angeles', username='tester12334@noemail.com',firstName= 'test');
        insert partnerUser1;
		
		 Account ac2 = new Account();
        ac2.Name = 'Test Account';
        ac2.BillingState = 'NY';   
        ac2.Customer_Category__c = 'Enterprise';
        ac2.Account_Type__c='Reseller';
        ac2.GEO__c='NA';
        ac2.Enterprise_ID__c = '1234te';       
        ac2.Enterprise_Account_Name__c = 'rdName';
        ac2.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        ac2.Commercial_ID__c = 'asdf';
        ac2.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac2.Solution_Provider_CAM_PMFKey__c='BOCAL01';
         ac2.Solution_Provider__c=true;
          ac2.Lead_Champion__c=partnerUserlc.id;
         ac2.Country_Picklist__c='US - UNITED STATES';
         ac2.Solution_Provider_Type__c='Reseller';
         ac2.Solution_Provider_Program_Level__c='Global';
         ac2.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac2; 
         Contact con2 = new Contact(LastName ='testCon',AccountId = ac2.Id,Active_User__c=true);
        insert con2; 
        
        User partnerUser2 = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con2.id,
                                    timezonesidkey='America/Los_Angeles', username='tester12345@noemail.com',firstName= 'test');
        insert partnerUser2;
		
		
		
		lead ld=New Lead();
         ld.LastName='Sesi Test';
         ld.Company='Company Test';
         ld.Status='New';
         ld.RecordTypeId=strRecordTypeId;
		 insert ld;
	
		
		
		/*
		 Map<id, double> accscoreMap = new Map<id, double>{ac.id => 0.3,ac1.id => 0.1, ac2.id => 0.1};
		  
		  Map<id,Map<id,double>> AllTotalAccountScoreMap=new map<id,map<id,double>>{ld.id => accscoreMap};
		   PartnerLeadDistribution_AssignPartner ap=new PartnerLeadDistribution_AssignPartner();
        ap.SortAndAssignPartner(AllTotalAccountScoreMap);
        */
           Map<Id,PLR_PartnerScore> MapToInit =  New Map<id,PLR_PartnerScore>();
				    PLR_PartnerScore PartnerScore = new PLR_PartnerScore();
                    PartnerScore.SetPartnerScoreValue(0.00);
                    MapToInit.put(ac.ID, PartnerScore);
                  //  ppScoreMap.put(ld.ID,MapToInit);
         Map<id,Map<id,PLR_PartnerScore>> AllTotalAccountScoreMap=new map<id,map<id,PLR_PartnerScore>>{ld.id => MapToInit};
              PartnerLeadDistribution_AssignPartner ap=new PartnerLeadDistribution_AssignPartner();
        ap.SortAndAssignPartner(AllTotalAccountScoreMap);
         
}

    static testmethod void testSortAndAssignPartnermapdeligate(){
         SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true; 
        String strRecordTypeId = [SELECT Id,Name,developername FROM RecordType WHERE SobjectType='lead' and developername ='CAIndirectLead'].Id;
        
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
        
        User partnerUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con.id,
                                    timezonesidkey='America/Los_Angeles', username='tester16234@noemail.com',firstName= 'test');
        insert partnerUser;
         system.debug('partnerUser---'+partnerUser);

		 Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.BillingState = 'NY';   
        ac1.Customer_Category__c = 'Enterprise';
        ac1.Account_Type__c='Reseller';
        ac1.GEO__c='NA';
        ac1.Enterprise_ID__c = '1234te';       
        ac1.Enterprise_Account_Name__c = 'rdName';
        ac1.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        ac1.Commercial_ID__c = 'asdf';
        ac1.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac1.Solution_Provider_CAM_PMFKey__c='PONSE01';
         ac1.Solution_Provider__c=true;
        
         ac1.Country_Picklist__c='US - UNITED STATES';
         ac1.Solution_Provider_Type__c='Reseller';
         ac1.Solution_Provider_Program_Level__c='Global';
         ac1.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac1; 
         Contact con1 = new Contact(LastName ='testCon',AccountId = ac1.Id,Active_User__c=true);
        insert con1; 
        
        User partnerUser1 = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con1.id,
                                    timezonesidkey='America/Los_Angeles', username='tester12334@noemail.com',firstName= 'test');
        insert partnerUser1;
		
         Contact con2 = new Contact(LastName ='testCon',AccountId = ac.Id,Active_User__c=true);
        insert con2; 
        
        User partnerUser2 = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con2.id,
                                    timezonesidkey='America/Los_Angeles', username='tester12345@noemail.com',firstName= 'test');
        insert partnerUser2;
        ac.Lead_Champion__c=partnerUser.id;
        update ac;
		 Account ac3 = new Account();
        ac3.Name = 'Test Account';
        ac3.BillingState = 'NY';   
        ac3.Customer_Category__c = 'Enterprise';
        ac3.Account_Type__c='Reseller';
        ac3.GEO__c='NA';
        ac3.Enterprise_ID__c = '1234te';       
        ac3.Enterprise_Account_Name__c = 'rdName';
        ac3.RecordTypeId =res;
        ac3.Commercial_ID__c = 'asdf';
        ac3.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
       
         ac3.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         ac3.Solution_Provider__c=true;
        
         ac3.Country_Picklist__c='US - UNITED STATES';
         ac3.Solution_Provider_Type__c='Reseller';
         ac3.Solution_Provider_Program_Level__c='Global';
         ac3.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac3; 
         Contact con3 = new Contact(LastName ='testCon',AccountId = ac3.Id,Active_User__c=true);
        insert con3; 
        
        User partnerUser3 = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con3.id,
                                    timezonesidkey='America/Los_Angeles', username='tester1623400@noemail.com',firstName= 'test');
        insert partnerUser3;
         Contact con5 = new Contact(LastName ='testCon',AccountId = ac3.Id,Active_User__c=true);
        insert con5; 
        
        User partnerUser5 = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,contactid=con5.id,
                                    timezonesidkey='America/Los_Angeles', username='tester16234900@noemail.com',firstName= 'test');
        insert partnerUser5;
         
		system.runas(partnerUser){
			DelegateLeadChampion__c dlc2=New DelegateLeadChampion__c();
		dlc2.DelegateLeadChampion__c=partnerUser2.id;
		dlc2.StartDate__c=system.today();
		dlc2.EndDate__c=system.today()+1;
        dlc2.UseDelegateLeadChampion__c=True;
			insert dlc2;
            system.debug('dlc2----'+dlc2);
            system.debug('dlc2----'+dlc2.id);
		}
         
		
		
		
		lead ld=New Lead();
         ld.LastName='Sesi Test';
         ld.Company='Company Test';
         ld.Status='New';
         ld.RecordTypeId=strRecordTypeId;
        ld.OwnerId=partnerUser.id;
		 insert ld;
	
         
        // update ld;
         /*
		 Map<id, double> accscoreMap = new Map<id, double>{ac.id => 0.3,ac1.id => 0.2,ac3.id => 0.3};
		  
		  Map<id,Map<id,double>> AllTotalAccountScoreMap=new map<id,map<id,double>>{ld.id => accscoreMap};
		   PartnerLeadDistribution_AssignPartner ap=new PartnerLeadDistribution_AssignPartner();
        ap.SortAndAssignPartner(AllTotalAccountScoreMap);
		*/
          Map<Id,PLR_PartnerScore> MapToInit =  New Map<id,PLR_PartnerScore>();
				    PLR_PartnerScore PartnerScore = new PLR_PartnerScore();
                    PartnerScore.SetPartnerScoreValue(0.00);
                    MapToInit.put(ac.ID, PartnerScore);
                  //  ppScoreMap.put(ld.ID,MapToInit);
         Map<id,Map<id,PLR_PartnerScore>> AllTotalAccountScoreMap=new map<id,map<id,PLR_PartnerScore>>{ld.id => MapToInit};
              PartnerLeadDistribution_AssignPartner ap=new PartnerLeadDistribution_AssignPartner();
        ap.SortAndAssignPartner(AllTotalAccountScoreMap);
}
    
 
}