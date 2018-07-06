@isTest
public class MDF_BfInsertValidations_Test {
	@isTest static void testName() { 
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
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
        
        account a1 = new account(name ='Test Account', recordtypeid =res);
        
        a1.Region_Country__c='PS_FSI';
        
        a1.customer_Category__c= 'Reseller';
        a1.hq__c= true;
        a1.Commercial_Account_Name__c='test 11111114'  ;
        a1.Commercial_ID__c= 'test 11111115';
        a1.Country_Picklist__c= 'USA';
        a1.GEO__c='NA';
        a1.Sales_Area__c= 'usa';
        a1.Sales_Region__c= 'usa';
        a1.Segment__c='xxx';
        
        insert a1;
        system.assertNotEquals(null, a1.id, 'Account not inserted');
        
    	List<SFDC_MDF__c> MDFlist=new List<SFDC_MDF__c>();
        
        date dt=system.today()+10; 
        Fund_Programs_Admin__c FundTrack=new Fund_Programs_Admin__c(name='Test_FT',CurrencyIsoCode='USD',Planning_expiration_date__c=dt,Execution_expiration_date__c=dt);
        insert FundTrack;
                
        Fund_Participant__c FundPart=new Fund_Participant__c(MDF_Program__c=FundTrack.id,Partner__c=a.id,CurrencyIsoCode='USD'); //Partner__c
        insert FundPart;
        
        SFDC_Budget__c allU=[select id,Account__c,Name,Start_Date__c,End_Date__c,Fund_Program__c,FundParticipant__c
                                   from SFDC_Budget__c where FundParticipant__c=:FundPart.id limit 1];
        System.debug('-------- budget ----'+allU.name);
        
        
        SFDC_Budget_Entry__c Palloc=[select id,Amount__c from SFDC_Budget_Entry__c where Budget__c=: allU.id ];
        Palloc.Amount__c=3000;
        update Palloc; 
        
        SFDC_MDF__c m0=new SFDC_MDF__c(name='test_f0',Status__c='Draft',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='USD');
        MDFlist.add(m0);
        SFDC_MDF__c m1=new SFDC_MDF__c(name='test_f1',Status__c='Approved',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='USD');
        MDFlist.add(m1);
        SFDC_MDF__c m2=new SFDC_MDF__c(name='test_f2',Status__c='Draft',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='INR');
        MDFlist.add(m2);
        SFDC_MDF__c m3=new SFDC_MDF__c(name='test_f2',Status__c='Sent To Finance',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='INR');
        MDFlist.add(m3);
        SFDC_MDF__c m4=new SFDC_MDF__c(name='test_f2',Status__c='Closed',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='INR');
        MDFlist.add(m4);
        
        insert MDFlist; 
        
        MDF_BfInsertValidations pp=new MDF_BfInsertValidations();
        pp.Validate_Bfins(MDFlist);
        
        MDF_Utils.ByPassStampedCurr=false;
        
               
        list<SFDC_MDF__c> mdf=[select name,amount__c from SFDC_MDF__c where name='test_f2' limit 1];
        System.debug('-----mdf rows ---'+mdf.size());
        mdf[0].amount__c=67;
        mdf[0].CurrencyIsoCode='NOK';
        update mdf;
        
        list<SFDC_MDF__c> oldFrList=[select name,Status__c,Amount__c,Account__c,Activity_Type__c,MDF_Program__c,Budget__c,CurrencyIsoCode,MDF_Request_Approval_Status__c
                                     from SFDC_MDF__c];
               
        Map<id,SFDC_MDF__c> oldMap=new  Map<id,SFDC_MDF__c>(MDFlist);
        Map<id,SFDC_MDF__c> newMap=new  Map<id,SFDC_MDF__c>(oldFrList);
        MDF_RejectionReasonMandatoryOnRequest mm=new MDF_RejectionReasonMandatoryOnRequest();
        mm.BfUpdate_CurrVal(newMap,oldMap);
        
        
        MDF_Utils.ByPassStampedCurr=false;
        
        List<SFDC_MDF_Claim__c> ClaimList=new list<SFDC_MDF_Claim__c>();
        SFDC_MDF_Claim__c	c1=new SFDC_MDF_Claim__c(name='m1-c1',Amount__c=2,Status__c='Draft',MDF_Claim_Approval_Status__c='Submitted',CurrencyIsoCode='USD',Claim_Details__c='sdf',Account__c=a.id,Fund_Request__c=m1.id,Budget__c=allU.id);
        ClaimList.add(c1);
        SFDC_MDF_Claim__c	c2=new SFDC_MDF_Claim__c(name='m1-c1',Amount__c=2,Status__c='Draft',MDF_Claim_Approval_Status__c='First Approval',CurrencyIsoCode='INR',Claim_Details__c='sdf',Account__c=a.id,Fund_Request__c=m1.id,Budget__c=allU.id);
        ClaimList.add(c2);
        SFDC_MDF_Claim__c	c3=new SFDC_MDF_Claim__c(name='m1-c1',Amount__c=2,Status__c='Draft',MDF_Claim_Approval_Status__c='Second Approval',CurrencyIsoCode='INR',Claim_Details__c='sdf',Account__c=a.id,Fund_Request__c=m1.id,Budget__c=allU.id);
        ClaimList.add(c3);
        SFDC_MDF_Claim__c	c4=new SFDC_MDF_Claim__c(name='m1-c1',Amount__c=2,Status__c='Approved',MDF_Claim_Approval_Status__c='Approved',CurrencyIsoCode='INR',Claim_Details__c='sdf',Account__c=a.id,Fund_Request__c=m1.id,Budget__c=allU.id,CA_Reimbursement__c=2);
        ClaimList.add(c4);
        
        insert ClaimList; 
        
        Map<id,SFDC_MDF_Claim__c> OldClaimList=new Map<id,SFDC_MDF_Claim__c>(ClaimList);
        
         MDF_Utils.ByPassStampedCurr=false; 
        MDF_Utils.ValidateClaimAmt_Update(ClaimList,OldClaimList);
        
		list<SFDC_MDF__c> Gtmdf=new list<SFDC_MDF__c>();
        
        SFDC_MDF__c gm0=new SFDC_MDF__c(name='test_f0',Status__c='Draft',MDF_Request_Approval_Status__c='Submitted',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='USD');
        Gtmdf.add(gm0);
        SFDC_MDF__c gm1=new SFDC_MDF__c(name='test_f0',Status__c='Draft',MDF_Request_Approval_Status__c='First Approval',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='USD');
        Gtmdf.add(gm1);
        SFDC_MDF__c gm2=new SFDC_MDF__c(name='test_f0',Status__c='Draft',MDF_Request_Approval_Status__c='Second Approval',Amount__c=30,Account__c=a.id,Activity_Type__c='asdfd',MDF_Program__c=FundPart.id,Budget__c=allU.id,CurrencyIsoCode='USD');
        Gtmdf.add(gm2);
        MDF_GrantAccessToApprovers ga=new MDF_GrantAccessToApprovers();
        ga.giveAccessToMDFRequestApprovers(Gtmdf);
        ga.giveAccessToMDFClaimApprovers(ClaimList);
        
        allU.Account__c=a1.id;
        update allU;
	}
}