@isTest()
public class Test_updateCriteria_Trigger {
	public static testmethod void updateCriteraTest1()
    {
    	Profile p;
    	User u;
    	List<user> users = new List<user>();
        
    	TAQ_Cost_Center__c cc=new TAQ_Cost_Center__c(name='Dummy',Cost_Center_Number__c='test num',Region__c='test');
        insert cc;
        
        TAQ_Job_Info__c job=new TAQ_Job_Info__c(name='test job',Job_Code__c='test',Region__c='test');
        insert job;
      
        TAQ_Currency_Conversion__c cur=new TAQ_Currency_Conversion__c(name='test currency',Currency_conversion_Rate__c=25.0);
        insert cur;
        
        p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
		
        for (Integer k=0;k<3;k++) {
            
            users.add(new User(alias = 'test123' +k, email='test123'+k+ '@ca.com',emailencodingkey='UTF-8',
                               lastname='Testing'+k, languagelocalekey='en_US',localesidkey='en_US',
                               profileId= p.id, country='United States',IsActive =true,PMFKey__c='_______',
                               timezonesidkey='America/Los_Angeles', username='tester1234' + k + '@ca.com',firstName= 'test'+k));
        }
        insert users;  
        system.assertNotEquals(null, users, 'users list inserted');
        
        MBO_Criteria_Plans__c cs = new MBO_Criteria_Plans__c();
        cs.Name = 'Plan_Type__c';
        cs.Plan_Type__c = 'MBOPlan1';
        insert cs;
        
        Map<String, MBO_Criteria_Plans__c> plans = MBO_Criteria_Plans__c.getAll();
        List<String> planNames = new List<String>();
        planNames.addAll(plans.keySet());
        
        Integer count1 = 0;
        Integer count2 = 1;
        Integer count3 = 0;
        String criteria1;
        String criteria2;
        String criteria3;
        Schema.DescribeFieldResult fieldResult = TAQ_Organization__c.Criteria__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        while (count1<4){
            if (count1 == 0) {
                criteria1 = ple.get(count1).getValue() + ';';
            } else {
                criteria1 = criteria1 + ple.get(count1).getValue() + ';';
            }
        	count1++;
        }
        
        while (count2<5){
            if (count2 == 1) {
                criteria2 = ple.get(count2).getValue() + ';';
            } else {
                criteria2 = criteria2 + ple.get(count2).getValue() + ';';
            }
        	count2++;
        }
        
        while (count3<2){
            if (count3 == 0) {
                criteria3 = ple.get(count3).getValue() + ';';
            } else {
                criteria3 = criteria3 + ple.get(count3).getValue() + ';';
            }
        	count3++;
        }
        
        String planName;
        if (planNames.isEmpty()){
            planName = 'LOA';
        } else {
            planName = planNames.get(0);
        }

        Date d = date.today();
        TAQ_Organization__c taqOrg_1 =new TAQ_Organization__c( 
            Process_Step__c='Open Headcount',
            Cost_Center_Desc__c=cc.id,
            JobTitle__c=job.id,
            IC_Currency__c=cur.id,
        	Manager_Name__c='test,mgr',
            Manager_PMF_Key__c=users[1].PMFKey__c,
            Organization__c='DIRECT',
            Role__c='AD/AM',
            Region__c='NA',
            Area__c='testa',
            Territory__c='nordics',
        	Country__c='United States',
            Distribute_Plan__c='NO',
            //Plan_Type__c='LOA',
            Plan_Type__c = planName,
            Criteria__c = criteria1,
            ownerid=userinfo.getuserid(),
            Cost_Center_Desc_For_Data_Load__c='test cost',
        	Job_Title_For_Data_Load__c='test job',
            IC_Currency_For_Data_Load__c='test currency',
            IC_Amount__c = 75000.00,
            Organization_for_Data_Load__c='DIRECT',
            Area_for_Data_Load__c='testa',Territory_For_Data_Load__c='nordics',
        	Country_for_Data_Load__c='United States',
            PlanType_Effective_Date__c = System.today().toStartOfMonth(),position_id__c = 'sss');
        	insert taqOrg_1;
        	
            taqOrg_1.Criteria__c = criteria2;
            update taqOrg_1;
        
        	try
        	{
        		taqOrg_1.Criteria__c = criteria3;
        		update taqOrg_1;
        	}
        	catch(Exception e)
        	{
				System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
				System.Assert(e.getMessage().contains('Please select exactly 4 criteria for the Account Development Plan chosen'));
        	} 
        
            try
        	{
        		taqOrg_1.Criteria__c = '';
        		update taqOrg_1;
        	}
        	catch(Exception e)
        	{
				System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
				System.Assert(e.getMessage().contains('Please select exactly 4 criteria for the Account Development Plan chosen'));
        	} 
        
        	taqOrg_1.Plan_Type__c = 'LOA';
        	update taqOrg_1;
        
        	try{
                TAQ_Organization__c taqOrg_2 =new TAQ_Organization__c( 
                Process_Step__c='Open Headcount',
                Cost_Center_Desc__c=cc.id,
                JobTitle__c=job.id,
                IC_Currency__c=cur.id,
                Manager_Name__c='test,mgr',
                Manager_PMF_Key__c=users[1].PMFKey__c,
                Organization__c='DIRECT',
                Role__c='AD/AM',
                Region__c='NA',
                Area__c='testa',
                Territory__c='nordics',
                Country__c='United States',
                Distribute_Plan__c='NO',
                //Plan_Type__c='LOA',
                Plan_Type__c = planName,
                Criteria__c = '',
                ownerid=userinfo.getuserid(),
                Cost_Center_Desc_For_Data_Load__c='test cost',
                Job_Title_For_Data_Load__c='test job',
                IC_Currency_For_Data_Load__c='test currency',
                IC_Amount__c = 75000.00,
                Organization_for_Data_Load__c='DIRECT',
                Area_for_Data_Load__c='testa',Territory_For_Data_Load__c='nordics',
                Country_for_Data_Load__c='United States',
                PlanType_Effective_Date__c = System.today().toStartOfMonth(),position_id__c = 'sss');
                insert taqOrg_2;
            
            }catch(Exception e)
        	{
				System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
				System.Assert(e.getMessage().contains('Please select exactly 4 criteria for the Account Development Plan chosen'));
        	} 
        
        	try{
                TAQ_Organization__c taqOrg_2 =new TAQ_Organization__c( 
                Process_Step__c='Open Headcount',
                Cost_Center_Desc__c=cc.id,
                JobTitle__c=job.id,
                IC_Currency__c=cur.id,
                Manager_Name__c='test,mgr',
                Manager_PMF_Key__c=users[1].PMFKey__c,
                Organization__c='DIRECT',
                Role__c='AD/AM',
                Region__c='NA',
                Area__c='testa',
                Territory__c='nordics',
                Country__c='United States',
                Distribute_Plan__c='NO',
                //Plan_Type__c='LOA',
                Plan_Type__c = planName,
                Criteria__c = criteria3,
                ownerid=userinfo.getuserid(),
                Cost_Center_Desc_For_Data_Load__c='test cost',
                Job_Title_For_Data_Load__c='test job',
                IC_Currency_For_Data_Load__c='test currency',
                IC_Amount__c = 75000.00,
                Organization_for_Data_Load__c='DIRECT',
                Area_for_Data_Load__c='testa',Territory_For_Data_Load__c='nordics',
                Country_for_Data_Load__c='United States',
                PlanType_Effective_Date__c = System.today().toStartOfMonth(),position_id__c = 'sss');
                insert taqOrg_2;
            
            }catch(Exception e)
        	{
				System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
				System.Assert(e.getMessage().contains('Please select exactly 4 criteria for the Account Development Plan chosen'));
        	} 
    }
}