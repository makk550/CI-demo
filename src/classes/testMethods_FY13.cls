@istest
Public Class testMethods_FY13
{
	
	public static testmethod void testBulkOppTriggers()	
	{
		//OpportunityGateway og = new OpportunityGateway();
		//ITrigger oh = new OpportunityHandler();
	
	}
	
	
     public static testmethod  void testCA_TAQ_Trigger_Class()
     {   
     	
     	 Account acc = new Account();
	     acc.Name = 'test';
	     acc.BillingStreet = 'Arlington';
	     acc.BillingCountry = 'US';
	     acc.BillingCity = 'VA';
	     acc.Reseller_Disti_Regional_ID__c ='AID';
	     insert acc;
     	 TAQ_Account__c taq=new TAQ_Account__c();
		 taq.name='Partner test TAQ';    
		 taq.Region__c='';
		 taq.Area__c='';
		 taq.Territory__c='testt';
		 taq.Country__c='testc';
		 taq.Account_Type__c='test type';
		 taq.Reseller_ID__c = 'TESTID';
		 taq.Is_Primary_Account__c = true;
		 taq.Enterprise_Id__c ='EA0520';
		 taq.View_Acc_Record__c = acc.Id;
		 insert taq;
     	
     	TAQ_Organization__c taqOrg =new TAQ_Organization__c();
        taqOrg.Employee_Name__c='test,user';
        taqOrg.Process_Step__c='Open Headcount';
        taqOrg.Manager_Name__c='test,mgr';
      //taqOrg.Manager_PMF_Key__c=u[1].PMFKey__c;
      //taqOrg.PMFKey__c=u[0].PMFKey__c;
        taqOrg.Position_Id__c='testpos1';
        taqOrg.Role__c='AD/AM';
        taqOrg.Organization__c='DIRECT';
        taqOrg.Region__c='EMEA';
        taqOrg.Area__c='testa';
        taqOrg.Territory__c='nordics';
        taqOrg.Country__c='United States';
        taqOrg.Plan_Type__c='test';
        taqOrg.Distribute_Plan__c='NO';
        taqOrg.Plan_Type__c='LOA';
        taqOrg.ownerid=userinfo.getuserid();
        
        taqOrg.Cost_Center_Desc_For_Data_Load__c='test cost';
        taqOrg.Job_Title_For_Data_Load__c='test job';
        taqOrg.IC_Currency_For_Data_Load__c='test currency';
        
        taqOrg.Organization_for_Data_Load__c='DIRECT';
        taqOrg.Area_for_Data_Load__c='testa';
        taqOrg.Territory_For_Data_Load__c='nordics';
        taqOrg.Country_for_Data_Load__c='United States';
        taqOrg.Approval_Process_Status__c='Migrated';
        taqOrg.Employee_Status__c='Active';
        taqOrg.Position_ID_Status__c='Active';
        taqOrg.PlanType_Effective_Date__c = Date.newInstance(2012, 12, 01);
        insert taqOrg;
         
		TAQ_Organization_Approved__c taqOrgApproved = new TAQ_Organization_Approved__c();
		taqOrgApproved.Employee_Name__c = 'test emp';
		taqOrgApproved.Is_Latest_Record__c = true ; 
		taqOrgApproved.TAQ_Organization__c = taqOrg.Id;
		insert taqOrgApproved ; 		 
		 
		TAQ_Org_Quota_Approved__c taOrganizationQuotaApp = new TAQ_Org_Quota_Approved__c();
		taOrganizationQuotaApp.TAQ_Organization_Approved__c = taqOrgApproved.Id; 
		insert taOrganizationQuotaApp ;
        
        TAQ_Account_Approved__c taqAccApproved = new TAQ_Account_Approved__c();
        taqAccApproved.Is_Latest_Record__c = true ; 
        taqAccApproved.TAQ_Account__c = taq.Id;
        taqAccApproved.Is_Original__c = true;
        insert taqAccApproved;
        
        TAQ_Account_Team_Approved__c taApp = new TAQ_Account_Team_Approved__c();
        taApp.Is_Latest_Record__c = true ; 
        taApp.Effective_Date__c = Date.Today();
        taApp.TAQ_Account_Approved__c = taqAccApproved.Id;
        insert taApp;
        ID test = taApp.Id ; 
        
        CA_TAQ_Trigger_class otriggerclass=new CA_TAQ_Trigger_class();
        taApp = [select TAQ_Account_Approved__r.TAQ_Account__r.Approval_Process_Status__c, TAQ_Account_Approved__r.TAQ_Account__c 
        from TAQ_Account_Team_Approved__c where TAQ_Account_Approved__c <> null AND TAQ_Account_Approved__r.TAQ_Account__c <> null AND TAQ_Account_Approved__r.Is_Latest_Record__c=true and TAQ_Account_Approved__r.Is_Original__c=true LIMIT 1];
        Map<id,TAQ_Account__c> mapRejected = new Map<id,TAQ_Account__C>();
        TAQ_Account__c ta = taApp.TAQ_Account_Approved__r.TAQ_Account__r; //[Select Approval_Process_Status__c from TAQ_Account__c where  Approval_Process_Status__c ='' LIMIT 1];
        ta.Approval_Process_Status__c='Rejected';
        mapRejected.put(ta.id,ta);
        otriggerclass.massCopyTAQAcc(mapRejected);
        CA_TAQ_Trigger_class.isflagRejected = true;
        List<id> lstid = new List<id>();
        lstid.add(ta.id);
        otriggerclass.revertTAQAccountTeam(lstid);
          
        taOrganizationQuotaApp = [select TAQ_Organization_Approved__r.TAQ_Organization__r.Approval_Process_Status__c, TAQ_Organization_Approved__r.TAQ_Organization__c 
        from TAQ_Org_Quota_Approved__c where TAQ_Organization_Approved__c <> null and  TAQ_Organization_Approved__r.TAQ_Organization__c <> null AND TAQ_Organization_Approved__r.Is_Latest_Record__c=true LIMIT 1];
        Map<id,TAQ_Organization__c> mapRejectedOrganization = new Map<id,TAQ_Organization__C>();
        TAQ_Organization__c to = taOrganizationQuotaApp.TAQ_Organization_Approved__r.TAQ_Organization__r; //[Select Approval_Process_Status__c from TAQ_Account__c where  Approval_Process_Status__c ='' LIMIT 1];
        to.Approval_Process_Status__c='Rejected';
        mapRejectedOrganization.put(to.id,to);
        CA_TAQ_Trigger_class.isflagRejected = true;
        otriggerclass.massCopyTAQOrg(mapRejectedOrganization); 

     }   


     public static testmethod  void testCA_TAQ_Actual_MiniForm()
     {   
     	   Account acc = new Account();
	       acc.Name = 'test';
	       acc.BillingStreet = 'Arlington';
	       acc.BillingCountry = 'US';
	       acc.BillingCity = 'VA';
	       acc.Reseller_Disti_Regional_ID__c ='AID';
	       insert acc;
     	  TAQ_Account__c ta=new TAQ_Account__c();
		  ta.name='Partner test TAQ';    
		  ta.Region__c='';
		  ta.Area__c='';
		  ta.Territory__c='testt';
		  ta.Country__c='testc';
		  ta.Account_Type__c='test type';
		  ta.Reseller_ID__c = 'TESTID';
		  ta.Is_Primary_Account__c = true;
		  ta.Enterprise_Id__c ='EA0520';
		  ta.View_Acc_Record__c = acc.Id;
		  insert ta;
          
          ta = [select Enterprise_Id__c, id, View_Acc_Record__r.Reseller_Disti_Regional_ID__c, View_Acc_Record__c, Approval_Status__c
 	     from TAQ_Account__c where Enterprise_Id__c <> null and Is_Primary_Account__c=true 
 	    // and View_Acc_Record__r.Reseller_Disti_Regional_ID__c <> null 
 	     AND View_Acc_Record__c <> null LIMIT 1];
 	 	 account a = ta.View_Acc_Record__r;
         ApexPages.StandardController c=new ApexPages.StandardController(a);
         CA_TAQ_Actual_MiniForm tse=new CA_TAQ_Actual_MiniForm(c);
		
		//TAQ_Account__c.
	
         PageReference p = Page.CA_TAQ_Actual_MiniForm;
         p.getParameters().put('reqType', 'Account Update');
         p.getParameters().put('EID', ta.Enterprise_Id__c);
         p.getParameters().put('RID', a.Reseller_Disti_Regional_ID__c);
         p.getParameters().put('AID', a.Reseller_Disti_Regional_ID__c);

		Test.startTest();
        Test.setCurrentPage(p);

        tse.isAccAdd = false;
        tse.isAccUpdate = true;
        tse.isError = false;
		        
        
        tse.isAccAdd=false;
        tse.isAccUpdate=true;
        tse.isError=false;
        tse.isAccUpdateForPartner=true;
        tse.isAccReleaseForPartner=true;
        tse.isAccMergeForPartner=true;

        tse.onLoad();
        tse.taqAccount.Process_Step__c='Account Add';
        tse.getOptions();
        tse.taqAccount.Process_Step__c=null;
        tse.getOptions();
        tse.getSelected();
        tse.setSelected('Account Update');
        tse.nextStep();
	    tse.saveForm();
	    tse.seloption='Account Merge';
        tse.nextStep();
        tse.selOption = 'Partner Account';
        tse.nextStep();
	    tse.seloption='Enterprise Account';
		tse.nextStep();
	    tse.seloption='Account Update';
		tse.nextStep();
	    tse.seloption='Account Release';
		tse.nextStep();
        
        ta = [select Enterprise_Id__c, id, View_Acc_Record__r.Reseller_Disti_Regional_ID__c, View_Acc_Record__c, Approval_Status__c
 	     from TAQ_Account__c where 
 	    // Enterprise_Id__c <> null and Is_Primary_Account__c=true 
 	    // and 
 	     View_Acc_Record__c <> null AND
 	   	 View_Acc_Record__r.Reseller_Disti_Regional_ID__c <> null 
 	     LIMIT 1];
 	 	 a = ta.View_Acc_Record__r;
         c=new ApexPages.StandardController(a);
         tse=new CA_TAQ_Actual_MiniForm(c);
		
		//TAQ_Account__c.
	
         p = Page.CA_TAQ_Actual_MiniForm;
         p.getParameters().put('reqType', 'Account Update');
         p.getParameters().put('EID', ta.Enterprise_Id__c);
         p.getParameters().put('RID', a.Reseller_Disti_Regional_ID__c);
         p.getParameters().put('AID', a.Reseller_Disti_Regional_ID__c);
		
	    Test.setCurrentPage(p);

        tse.isAccAdd = false;
        tse.isAccUpdate = true;
        tse.isError = false;
		        
        
        tse.isAccAdd=false;
        tse.isAccUpdate=true;
        tse.isError=false;
        tse.isAccUpdateForPartner=true;
        tse.isAccReleaseForPartner=true;
        tse.isAccMergeForPartner=true;

        tse.onLoad();
        tse.taqAccount.Process_Step__c='Account Add';
        tse.getOptions();
        tse.taqAccount.Process_Step__c=null;
        tse.getOptions();
        tse.getSelected();
        tse.setSelected('Account Update');
        tse.nextStep();
	    tse.saveForm();
	    tse.seloption='Account Merge';
        tse.nextStep();
        tse.selOption = 'Partner Account';
        tse.nextStep();
	    tse.seloption='Enterprise Account';
		tse.nextStep();
	    tse.seloption='Account Update';
		tse.nextStep();
	    tse.seloption='Account Release';
		tse.nextStep();
        test.stopTest();
     }   

}