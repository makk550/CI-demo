@isTest(SeeAllData=true)
public class BPAttachmentsViewControllerTest {

    static testMethod void testMultipleAttachments() 
	{
  	//	ID accountId = PopulateTestAccount();
    ID accountId = TestBPDataFactory.PopulateTestAccount();
   //     ID bpId = PopulateTestBP(accountId);
        ID bpId = TestBPDataFactory.PopulateTestBP(accountId);
        system.debug(' account id ' + accountId);
        system.debug(' bp id ' + bpId);
        
       // PopulateTestAttachments(bpId);
       TestBPDataFactory.PopulateTestAttachments(bpId);
        
       PageReference pr = Page.BPAttachmentsDetails;
		Test.setCurrentPage(pr);
		ApexPages.currentPage().getParameters().put('id', bpId);
		system.assertEquals(bpID, ApexPages.currentPage().getParameters().get('id'));
        
        ApexPages.currentPage().getParameters().put('aid', accountId);
		system.assertEquals(accountId, ApexPages.currentPage().getParameters().get('aid'));
        
        BPAttachmentsViewController controller = new BPAttachmentsViewController();
        controller.AccountId = accountId;
        System.assertEquals(controller.AccountId,accountId);
        
        List<Account> aList = [select name from Account where id =:accountId];
        Account a;
        if (aList.size() > 0)
        { 
            a = alist[0];
            controller.AccountName = a.name;
        	System.assertEquals(controller.AccountName,a.name);
        }
        
        System.assertEquals(controller.BackUrl,URL.getSalesforceBaseUrl().getHost() + '/' + AccountId);
        
        System.assertEquals(Controller.getAttachments().size(),1);

	}
}