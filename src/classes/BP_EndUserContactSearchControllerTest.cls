@isTest(seealldata=true)
public class BP_EndUserContactSearchControllerTest {
    public static testMethod void popupBP_Endusertesting(){
        Test.startTest();
                Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true);
                acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId();
                insert acc;
         Contact c = new Contact();
              c.FirstName = 'test contact';
              c.LastName = 'test contact';      
              c.AccountId = acc.Id;
              c.email = 'testgys@test.com';
        insert c;
        Contact c1 = new Contact();
              c1.FirstName = 'teswt contact1';
              c1.LastName = 'teswt contact1';      
              c1.AccountId = acc.Id;
              c1.email = 'testg1ys@test.co1';
        insert c1;
        Test.stopTest();
           //Test.setMock(HttpCalloutMock.class, new BP_EnduserMockTestClass());
                 PageReference ref = new PageReference('/apex/BP_EndUserContactSearch');
                 Test.setCurrentPage(ref);
                ApexPages.currentPage().getParameters().put('accId', acc.Id);
                ApexPages.currentPage().getParameters().put('fiscalyear', 'FY 2018');
        		ApexPages.currentPage().getParameters().put('inputvalues', '0.Solution Provider.Continuous Application Insight.Implementation');
        		BP_EndUserContactSearchController obj = new BP_EndUserContactSearchController();
                 	obj.firstName = 'creFistname';
                    obj.lastName='creLastn';        
                    obj.email='test12@test.com';
                    obj.title='sss';
                    obj.functionalRole='Implementation';
        			obj.phone='';
        			obj.mobile='';
        			obj.fax='';
            		obj.firstnamelocal='';
            		obj.lastnamelocal='';
                PageReference ref1=obj.CreateContact();
        		List<SelectOption> op = obj.getfunctionalRoles();
        		obj.sortExpression='name';
        		PageReference ref2=obj.ViewData();
                obj.sortExpression='certificate';
                PageReference ref3=obj.ViewData();
        		obj.searchcon ='test';
        		PageReference ref4=obj.SearchContacts();
        
        	 
    }
}