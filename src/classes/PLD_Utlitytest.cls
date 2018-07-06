@isTest
public class PLD_Utlitytest {
    
     //@testsetup
     static testMethod void testMethod1() 
    {
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        User usr=[select id from user limit 1];
        
        Group grp=new Group(Type = 'Queue',Name = 'Partner Lead Distribution');
        insert grp;  
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'Lead');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
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
        
        insert a;
        system.assertNotEquals(null, a.id, 'Account not inserted');
        
        list<account> acc_list=new list<account>();
        
        account a1 = new account(name ='Test Account', recordtypeid =res);
        
        a1.Region_Country__c='xxx';
        a1.Enterprise_ID__c='PN12345';
        a1.PartnerOperatingArea__c='PS_FSI';
        a1.Solution_Provider_Program_Level__c='Global';
        a1.Lead_Champion__c=usr.id;
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
        //insert a1;
        //system.assertNotEquals(null, a1.id, 'Account not inserted');
        acc_list.add(a1);
        
         
        account a2 = new account(name ='Test Account', recordtypeid =res,Region_Country__c='xxx',Enterprise_ID__c='PN12345',PartnerOperatingArea__c='PS_FSI');
             
        a2.Solution_Provider_Program_Level__c='Premier';
        a2.Lead_Champion__c=usr.id;
        a2.customer_Category__c= 'Reseller';
        a2.hq__c= true;
        a2.Commercial_Account_Name__c='test 11111114'  ;
        a2.Commercial_ID__c= 'test 11111115';
        a2.Country_Picklist__c= 'USA';
        a2.GEO__c='NA';
        a2.Sales_Area__c= 'usa';
        a2.Sales_Region__c= 'usa';
        a2.Segment__c='xxx';
         a2.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         a2.Solution_Provider__c=true;
        
         a2.Country_Picklist__c='US - UNITED STATES';
         a2.Solution_Provider_Type__c='Reseller';
         a2.Solution_Provider_Program_Level__c='Premier';
         a2.Solution_Provider_Designation__c='Partner of Franchisee';
        //insert a2;
        //system.assertNotEquals(null, a2.id, 'Account not inserted');
        acc_list.add(a2);
        
        account a3 = new account(name ='Test Account', recordtypeid =res,Region_Country__c='xxx',Enterprise_ID__c='PN12345',PartnerOperatingArea__c='PS_FSI');
             
        //a3.Solution_Provider_Program_Level__c='Premier';
        a3.Lead_Champion__c=usr.id;
        a3.customer_Category__c= 'Reseller';
        a3.hq__c= true;
        a3.Commercial_Account_Name__c='test 11111114'  ;
        a3.Commercial_ID__c= 'test 11111115';
        a3.Country_Picklist__c= 'USA';
        a3.GEO__c='NA';
        a3.Sales_Area__c= 'usa';
        a3.Sales_Region__c= 'usa';
        a3.Segment__c='xxx';
         a3.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         a3.Solution_Provider__c=true;
        
         a3.Country_Picklist__c='US - UNITED STATES';
         a3.Solution_Provider_Type__c='Reseller';
         a3.Solution_Provider_Program_Level__c='Premier';
         a3.Solution_Provider_Designation__c='Partner of Franchisee';
        //insert a3;
        //system.assertNotEquals(null, a3.id, 'Account not inserted');
        acc_list.add(a3);
        
        account a4 = new account(name ='Test Account', recordtypeid =res,Region_Country__c='xxx',Enterprise_ID__c='PN12345',PartnerOperatingArea__c='PS_FSI');
             
        
        a4.Lead_Champion__c=usr.id;
        a4.customer_Category__c= 'Reseller';
        a4.hq__c= true;
        a4.Commercial_Account_Name__c='test 11111114'  ;
        a4.Commercial_ID__c= 'test 11111115';
        a4.Country_Picklist__c= 'USA';
        a4.GEO__c='NA';
        a4.Sales_Area__c= 'usa';
        a4.Sales_Region__c= 'usa';
        a4.Segment__c='xxx';
         a4.Solution_Provider_CAM_PMFKey__c='BOYAL01';
         a4.Solution_Provider__c=true;
        
         a4.Country_Picklist__c='US - UNITED STATES';
         a4.Solution_Provider_Type__c='Reseller';
         a4.Solution_Provider_Program_Level__c='Member';
         a4.Solution_Provider_Designation__c='Partner of Franchisee';
        //insert a4;
        //system.assertNotEquals(null, a4.id, 'Account not inserted');
        acc_list.add(a4);
        
        insert acc_list;
        
        Schema.DescribeSObjectResult leadresult = Schema.SObjectType.Lead;        
        Map<String,Schema.RecordTypeInfo> leadRecType = leadresult.getRecordTypeInfosByName(); 
        Id CaIndirectLeadrecType = leadRecType.get('CA Indirect Lead').getRecordTypeId();
        
        RecordTypes_Setting__c rec = new RecordTypes_Setting__c();
        rec.SObject_Name__c = 'Lead';
        rec.RecordType_Id__c = String.valueOf(CaIndirectLeadrecType);
        rec.Name = 'CA Indirect Lead';
        insert rec;
        
        List<Lead> lstLead = new List<Lead>();   
                
        for(Integer i = 0 ; i<2 ; i++) {
            lead ld=new Lead(lastName = 'testLName'+1 ,
                             Company = 'Salesforce',
                             RecordTypeId=CaIndirectLeadrecType,
                             EAID__c='L098704', 
                             Commercial_Account__c=a.id, 
                             mkto71_Lead_Score__c=45, 
                             CSU_Driver__c='API Gateway',
                             OwnerId=grp.id);
            
            lstLead.add(ld);
         }
        insert lstLead ;
           
         //query the data back from the database
        lstLead=[select id,EAID__c,MKT_Territory__c,Sales_Territory__c,Commercial_Account__r.Region_Country__c,mkto71_Lead_Score__c,
                 Commercial_Account__r.Sales_Area__c,Commercial_Account__r.GEO__c,
                 Commercial_Account__r.Sales_Region__c,CSU_Driver__c 
                 from Lead 
                       ];
        
        id lrmRectype=Schema.SObjectType.LeadRoutingMatrix__c.getRecordTypeInfosByName().get('Threshold').getRecordTypeId();
     
        LeadRoutingMatrix__c Lrm=new LeadRoutingMatrix__c(Business_Unit__c='API Gateway',GEO__c='NA',LeadScore__c=5,Operating_Area__c='usa',Sales_Region__c='usa',RecordtypeId=lrmRectype);
        insert Lrm;
                  
         Date curdate=Date.today();
        String fiscalYear;
        if(curdate.month()>0 && curdate.month()<4)
        {
            fiscalYear='FY '+curdate.year();
        }
        else
        {
            Integer i;
            i=curdate.year()+1;
            fiscalYear='FY '+i;
        }
     
        
        list<Business_Plan_New__c> bplist=new list<Business_Plan_New__c>();
        Business_Plan_New__c bp=new Business_Plan_New__c(Account__c=a1.id,Plan_Fiscal_Year__c=fiscalYear,Status__c='CA & Partner Approved');
        bplist.add(bp);
        Business_Plan_New__c bp1=new Business_Plan_New__c(Account__c=a2.id,Plan_Fiscal_Year__c=fiscalYear,Status__c='CA & Partner Approved');
        bplist.add(bp1);
        Business_Plan_New__c bp2=new Business_Plan_New__c(Account__c=a4.id,Plan_Fiscal_Year__c=fiscalYear,Status__c='CA & Partner Approved');
        bplist.add(bp2);
        insert bplist;
       
        
        //query data back from database for BP data assignment to Account a1
         List<String> ProgramLevelList = new List<String>{'Global','Focus','Premier','Member','Advanced'};
          List<String> leadGeos = new List<String>{'NA'};
            list<account>       acclist=[select 	id, GEO__c,
                                   			Enterprise_ID__c,
                                   			PartnerOperatingArea__c,
                                   			Alliance_Program_Level__c,
                                   			Service_Provider_Program_level__c,
                                   			Solution_Provider_Program_Level__c,
                      						(	select Plan_Fiscal_Year__c,Status__c  
                                             	from Business_Plans__r 
                       							where 	Plan_Fiscal_Year__c=:fiscalYear and 
                                             			Status__c='CA & Partner Approved' )
                      				from 	Account 
                      				where 	RecordType.Name='Reseller/Distributor Account' and 
                            				PartnerOperatingArea__c != null and 
                            				Lead_Champion__c != null and 
                            				GEO__c in : leadGeos and
                                   			Enterprise_ID__c LIKE 'P%' and
                      						(	Alliance_Program_Level__c 			in :ProgramLevelList or 
                                                Service_Provider_Program_level__c 	in :ProgramLevelList or 
                                                Solution_Provider_Program_Level__c 	in :ProgramLevelList
                            				) ];
        
        Lead__c weightage=new Lead__c();
        weightage.Name='Total Score';
        weightage.LoyalityHistorial__c=40;
        weightage.PartnerProgramScore__c=20;
        weightage.ProductCompetency__c=40;
        insert weightage;
        
    // Create some opportunity objects from LEAD with stageName = '100% - Contract Signed'

        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;        
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();   
         
        id comopp = oppRecType.get('Deal Registration').getRecordTypeId();

        RecordTypes_Setting__c recOpp = new RecordTypes_Setting__c();
        recOpp.SObject_Name__c = 'Opportunity';
        recOpp.RecordType_Id__c = String.valueOf(comopp);
        recOpp.Name = 'Deal Registration';
        insert recOpp;
        
        Opportunity opp = new Opportunity(Name = 'TBR_Test_opp1', recordtypeid=comopp);
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
        opp.Source__c = 'Lead';
        insert opp;
         
        Opportunity opp2 = new Opportunity(Name = 'TBR_Test_opp2', recordtypeid=comopp);
        opp2.AccountId = a2.Id ; 
        opp2.Reseller__c = a2.Id ; 
        opp2.CloseDate = system.today();
        opp2.ReasonField__c = 'Luck';
        opp2.stageName = '100% - Contract Signed';
        opp2.Type = 'Direct';
        opp2.Inside_Outside__c = 'Inside';
        opp2.Contract_Type__c = 'ELA';
        opp2.CurrencyIsoCode = 'USD';
        opp2.Created_from_Lead__c = 'TRUE';
        opp2.Source__c = 'Lead';
        insert opp2;
         

        test.startTest();
               
        PartnerLeadDistribution_Utility pp=new PartnerLeadDistribution_Utility(lstLead);
        pp.AccountScoring(lstLead);
        PartnerLeadDistribution_Utility.ispartneruser(usr.id);
       // PartnerLeadDistribution_Utility.ispartner();
        test.stopTest();
    }

}