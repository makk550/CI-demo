/*************************************************************************************************
Apex Class Name     : Test_Add_and_Rmve_Part_Users
Function            : Test Class for the Remove_Partner_Users Trigger
Coverage			: 100%
--------------------------------------------------------------------------------------------------
* Developer             			 Date                    Description
* ---------------        		-----------             ----------------------------------------------
* Samhitha Tummanapalli          08/08/2017              		Updation
**************************************************************************************************/
@isTest
public class Test_Add_and_Rmve_Part_Users {
    
		
   		static Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        static Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName(); 
        static List<Account> testacclist = new  List<Account>();
     	static id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
    	static Id contactRecordTypeId = Schema.SObjectType.Contact.RecordTypeInfosByName.get('CA Contact Record Type').RecordTypeId;
    	static Contact con=new Contact();
    	static Profile p;
    	static User u;
    	static List<user> users = new List<user>();
    	static Group g = new Group();
    	static GroupMember GM = new GroupMember();
    	
    @testSetup
	public static void TestDataCreation() {
       
       	AccountPlanTest.insertRecordtypes();
       
        Account acc1 = new Account(Name='test account',RecordTypeId=res);
        testacclist.add(acc1);
        Account acc2 = new Account(Name='test account 2',RecordTypeId=res);
        testacclist.add(acc2);
     	insert testacclist;
        system.assertNotEquals(null, testacclist, 'account list inserted');
        con.LastName ='testCon';
        con.AccountId = testacclist[1].Id;
        p = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
        for (Integer k=0;k<3;k++) {
            
            users.add(new User(alias = 'test123' +k, email='test123'+k+ '@ca.com',emailencodingkey='UTF-8',
                               lastname='Testing'+k, languagelocalekey='en_US',localesidkey='en_US',
                               profileId= p.id, country='United States',IsActive =true,ContactId = con.Id,PMFKey__c='_______',
                               timezonesidkey='America/Los_Angeles', username='tester1234' + k + '@ca.com',firstName= 'test'+k));
        }
        insert users;  
        system.assertNotEquals(null, users, 'users list inserted');
     
 }
   
    @istest
    public static void test1(){
        
        u = [select id, Related_Partner_Account__c from user limit 1];
             	
         Set<Id> s1 = new Set<Id>();
       	 g.Name='Test Group';
        	insert g;
            GM.GroupId=g.Id;
        	GM.UserOrGroupId=u.Id;
            insert GM;
        s1.add(GM.id);
        Remove_Partner_Users.callTrigger(s1);
    }
	@istest
    public static void test2(){
        	
        	Set<String> strset = new Set<String>();
        	User u1 = [select id, Related_Partner_Account__c from user where Related_Partner_Account__c!=null and IsActive=true limit 1];
        	 Group g1 = new Group(Name='group name', type='Queue');
            insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
            insert q1;
        	System.runAs(u1)
        	{
        		QueueCust__c qutest = new  QueueCust__c(name='Common Partner Lead Pool');
        		qutest.Queue_ID__c = q1.id;
        		insert qutest;
        	}
        	
        	strset.add(u1.Related_Partner_Account__c);
        	
        	Remove_Partner_Users.callTriggerInsert(strset);
        	
        
    }
       
}