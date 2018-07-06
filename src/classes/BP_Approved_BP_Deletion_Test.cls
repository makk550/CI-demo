@isTest(SeeAllData = true)
public class BP_Approved_BP_Deletion_Test {
	private static testMethod void testDeleteApprovedBP() {
		
		string approvedStatus = 'Draft';
		Business_plan_new__c bp = Database.query('Select id from business_plan_new__c where status__c <>:approvedStatus limit 1');
		
		try
		{
			delete bp;
		}
		catch (System.DmlException e)
		{
			System.assert(e.getMessage().contains('You do not have the level of access to perform this deletion. Please contact your Geo Program Lead for assistance.'));
		}
	}

	private static testMethod void testDeleteDraftBP() {
		
		string approvedStatus = 'Draft';
		Business_plan_new__c bp = Database.query('Select id from business_plan_new__c where status__c =:approvedStatus limit 1');

		string error = '';

		try
		{
			delete bp;
		}
		catch (System.DmlException e)
		{
			error = e.getMessage();
		}

        System.assertEquals(error, '');
	}

	//private static testMethod void testDeleteApprovedBPPermissionSet() {
		
	//	string approvedStatus = 'Modifying';
	//	Business_plan_new__c bp = Database.query('Select id from business_plan_new__c where status__c =:approvedStatus limit 1');

	//	//User user = new User(firstname='testname',lastname='testlast')
	//	Profile p = [select id from profile where name='Regional Admin - Non TAQ'];
      
	//	User u = new User(alias = 'utest', email='test@ca.com',emailencodingkey='UTF-8',lastname='Unit Test', 
	//	      languagelocalekey='en_US',
	//	      localesidkey='en_GB', profileid = p.id,
	//	      timezonesidkey='Europe/London', 
	//	      username='untest@ca.com');
        
 //       insert u;

 //       PermissionSet pset = [SELECT id FROM PermissionSet where name = 'BP_Approved_Deletion_Set'];

 //       PermissionSetAssignment assignment = new PermissionSetAssignment();
 //       assignment.AssigneeId = u.id;
 //       assignment.PermissionSetId  = pset.id;

 //       insert assignment;

 //       System.runas(u){
 //       	string error = '';

	//		try
	//		{
	//			delete bp;
	//		}
	//		catch (System.DmlException e)
	//		{
	//			error = e.getMessage();
	//		}

 //       	System.assertEquals(error, '');
	//	}
	//}
}