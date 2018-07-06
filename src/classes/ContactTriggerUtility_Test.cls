@isTest
public class ContactTriggerUtility_Test {
    
    
     static testMethod void testMethod1()  
    {
		//ContactTriggerUtility.bypassoppcreation=false;
		SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        SystemIdUtility.skipOpportunityTriggers=true;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        //id res = accRecType.get('Account Team').getRecordTypeId();
       // id res = accRecType.get('CA Enterprise Account').getRecordTypeId();
         
 	
        account a = new account(name ='Test Account', recordtypeid =res);
        
        a.Region_Country__c='PS_FSI';	
        
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'USA';
        a.GEO__c='NA';
        a.Sales_Area__c= 'usa';
        a.Sales_Region__c= 'usa';
        a.Segment__c='xxx';
        
        //insert a;
        //system.assertNotEquals(null, a.id, 'Account not inserted');
        
       account a1 = new account(name ='Test Account', recordtypeid =res);
        
        a1.Region_Country__c='xxx';
        a1.Enterprise_ID__c='PN12345';
        a1.PartnerOperatingArea__c='PS_FSI';
        a1.Solution_Provider_Program_Level__c='Global';
        
        a1.customer_Category__c= 'Reseller';
        a1.hq__c= true;
        a1.Commercial_Account_Name__c='test 11111114'  ;
        a1.Commercial_ID__c= 'test 11111115';
        a1.Country_Picklist__c= 'USA';
        a1.GEO__c='NA';
        a1.Sales_Area__c= 'usa';
        a1.Sales_Region__c= 'usa';
        a1.Segment__c='xxx';
         a1.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         a1.Solution_Provider__c=true;
        
         a1.Country_Picklist__c='US - UNITED STATES';
         a1.Solution_Provider_Type__c='Reseller';
         a1.Solution_Provider_Program_Level__c='Global';
         a1.Solution_Provider_Designation__c='Partner of Franchisee';
        
        list<account> acclist=new list<account>();
        acclist.add(a);
        acclist.add(a1);
        insert acclist;
        
        //insert opps // recordTypeId=preOppRecType, name=oppname,
       /*  Opportunity opp=new Opportunity(ownerid=label.Generic_OwnerID,StageName=label.Stage_0_Name,CloseDate=date.today().addMonths(3),Accountid= a.id,Type=label.SalesPlay_Opp_Type,Transaction_Type__c=label.SalesPlay_Opp_Type,Source__c=label.Salesplay_Source,GBU_Driver_100__c='Agile Central SAAS',Contact_Is_Source__c=true,
                                                        MQLDatelatest__c = date.today().addMonths(3), SALDate__c = date.today().addMonths(3),
                                                        BUDriver__c = 'Agile Central', Country__c ='USA'); 
        insert opp;*/
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();   
         
        id comopp = oppRecType.get('Deal Registration').getRecordTypeId();

        RecordTypes_Setting__c recOpp = new RecordTypes_Setting__c();
        recOpp.SObject_Name__c = 'Opportunity';
        recOpp.RecordType_Id__c = String.valueOf(comopp);
        recOpp.Name = 'Deal Registration';
        insert recOpp;
        
        Opportunity opp = new Opportunity(Name = 'TBR_Test_opp1', recordtypeid=comopp,GBU_Driver_100__c='Agile Central SAAS',Contact_Is_Source__c=true,Transaction_Type__c='Direct');
        opp.AccountId = a1.Id ; 
        opp.Reseller__c = a1.Id ; 
        opp.CloseDate = system.today();
        opp.ReasonField__c = 'Luck';
        opp.stageName = '100% - Contract Signed';
        opp.Type = 'Direct';
        opp.Inside_Outside__c = 'Inside';
        opp.Contract_Type__c = 'ELA';
        opp.CurrencyIsoCode = 'USD';
        opp.Created_from_Lead__c = 'TRUE';
        opp.Source__c = 'Marketing';
        insert opp;
        
        /*
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();   
         
        id comopp = oppRecType.get('New Opportunity').getRecordTypeId();

        RecordTypes_Setting__c recOpp = new RecordTypes_Setting__c();
        recOpp.SObject_Name__c = 'Opportunity';
        recOpp.RecordType_Id__c = String.valueOf(comopp);
        recOpp.Name = 'New Opportunity';
        insert recOpp;
        
        opportunity opp=new opportunity(Accountid=a.id,GBU_Driver_100__c='Agile Central SAAS',Contact_Is_Source__c=true,Transaction_Type__c='Direct',recordtypeid=comopp,name='opp1',StageName=label.Stage_0_Name,CloseDate=date.today().addMonths(3));
 		insert opp;
        */
        
        set<id> accids=new set<id>();
        accids.add(a.id); 
        //accids.add(a1.id);
        set<string> gbudrivers=new set<string>();
        gbudrivers.add('Agile Central');
        gbudrivers.add('Agile Central SAAS');
        ContactTriggerUtility.getExistingOpps(accids,gbudrivers);
        ContactTriggerUtility.getExistingOpps(accids,gbudrivers);

        list<contact> ccins=new list<contact>();
        contact cc0=new contact(firstname='haha',lastname='hehe1',Accountid=a.id,GBU__c='Agile Central',GBU_Driver__c='Agile Central SAAS',Contact_Engagement__c=false);
        ccins.add(cc0);
       
        contact cc1=new contact(firstname='haha',lastname='hehe1',Accountid=a.id,GBU__c='Agile Central',GBU_Driver__c='Agile Central SAAS',Contact_Engagement__c=false);
        ccins.add(cc1);
        insert ccins;
        
        ContactTriggerUtility.bypassoppcreation=false;
        cc1.Contact_Engagement__c=true;
        cc1.StrengthOfRelationship__c='1';
        cc1.GBU_Driver__c='Agile Central SAAS';
        update cc1;

		OpportunityContactRole orr=new OpportunityContactRole();
        orr.ContactId=cc1.id;
        orr.OpportunityId=opp.id; 
        insert orr;
        set<id> conIdSet=new set<id>();
        conIdSet.add(cc1.id);
        Set<String> gbudriver100=new Set<String>();
        gbudriver100.add('Agile Central');
        gbudriver100.add('Agile Central SAAS');
        ContactTriggerUtility.getContactRoles(conIdSet,gbudriver100);
        ContactTriggerUtility.getPrevOpps(conIdSet,gbudriver100);
        
    }
}