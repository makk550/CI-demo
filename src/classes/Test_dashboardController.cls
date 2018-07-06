@isTest
public class Test_dashboardController{
    
    private static List<knowledge__kav> listKnowledgeObj;
    
    private static testMethod void method1(){
      Test.startTest();
        createTestData();
        dashboardController dashboardControllerObj = new dashboardController();
        //dashboardControllerObj.isApprover = true;
        dashboardControllerObj.scriptvar = 'T';
        dashboardControllerObj.selectedVal = '';
        dashboardControllerObj.searchStr = 'es';
        dashboardControllerObj.getOptns();
        //dashboardControllerObj.getRecordTypes();
        dashboardControllerObj.Create();
        dashboardControllerObj.searchKB();
        //dashboardControllerObj.getIsApprover();
        //dashboardControllerObj.getApprovalsQueue();
        Test.stopTest();
    }
    
    private static testMethod void method2(){
      Test.startTest();
        createTestData();
        dashboardController dashboardControllerObj = new dashboardController();
        //dashboardControllerObj.isApprover = true;
        dashboardControllerObj.scriptvar = 'T';
        dashboardControllerObj.selectedVal = 't';
        dashboardControllerObj.searchStr = '';
        dashboardControllerObj.getOptns();
        //dashboardControllerObj.getRecordTypes();
        dashboardControllerObj.Create();
        dashboardControllerObj.searchKB();
        //dashboardControllerObj.getIsApprover();
        //dashboardControllerObj.getApprovalsQueue();
        Test.stopTest();
    }
    
    private static testMethod void method3(){
      Test.startTest();
        createTestData();
        dashboardController dashboardControllerObj = new dashboardController();
        //dashboardControllerObj.isApprover = true;
        dashboardControllerObj.scriptvar = 'T';
        dashboardControllerObj.selectedVal = 't';
        dashboardControllerObj.searchStr = '{xxxx}';
        dashboardControllerObj.getOptns();
        //dashboardControllerObj.getRecordTypes();
        dashboardControllerObj.Create();
        dashboardControllerObj.searchKB();
        //dashboardControllerObj.getIsApprover();
        //dashboardControllerObj.getApprovalsQueue();
        //dashboardControllerObj.cancelPage();
        Test.stopTest();
    }
    
    private static testMethod void method4(){
      Test.startTest();
        createTestData();
        dashboardController dashboardControllerObj = new dashboardController();
        dashboardControllerObj.selectedVal = null;
        dashboardControllerObj.Create();
        Test.stopTest();
    }
    
    private static void createTestData(){
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = 'testingning11111';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        listKnowledgeObj.add(knowledgeObj1);
        
        knowledge__kav knowledgeObj2 = new knowledge__kav();
        knowledgeObj2.Title = 'test11112';
        knowledgeObj2.UrlName = 'testing12111';
        knowledgeObj2.Summary = 'testingning121111';
        knowledgeObj2.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj2.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj2.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj2.Releases__c = 'CA PPM: 1';
        knowledgeObj2.Product_Names__c = 'CA PPM';
        knowledgeObj2.Content1__c='Issue';
        knowledgeObj2.Content2__c = 'Resolution';
        knowledgeObj2.IsVisibleInPkb = true;
        knowledgeObj2.Introduction__c = '<a></a>';
        knowledgeObj2.Additional_Information__c = '<a></a>';
        knowledgeObj2.Answer__c = '<a></a>';
        knowledgeObj2.Background__c = '<a></a>';
        knowledgeObj2.Cause__c = '<a></a>';        
        listKnowledgeObj.add(knowledgeObj2);
        
        knowledge__kav knowledgeObj3 = new knowledge__kav();
        knowledgeObj3.Title = 'test11112x';
        knowledgeObj3.UrlName = 'testing12111x';
        knowledgeObj3.Summary = 'testingning121x111';
        knowledgeObj3.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj3.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj3.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj3.Releases__c = 'CA PPM: 1';
        knowledgeObj3.Product_Names__c = 'CA PPM';
        knowledgeObj3.Content1__c='Issue';
        knowledgeObj3.Content2__c = 'Resolution';
        knowledgeObj3.IsVisibleInPkb = true;
        knowledgeObj3.Introduction__c = '<a></a>';
        knowledgeObj3.Additional_Information__c = '<a></a>';
        knowledgeObj3.Answer__c = '<a></a>';
        knowledgeObj3.Background__c = '<a></a>';
        knowledgeObj3.Cause__c = '<a></a>';        
        listKnowledgeObj.add(knowledgeObj3);
        insert listKnowledgeObj;
        
        List<knowledge__kav> testingKav = [Select id, knowledgeArticleId from knowledge__kav where Id=:listKnowledgeObj[2].Id];
        KbManagement.PublishingService.publishArticle(testingKav[0].knowledgeArticleId, true);
        
        /*Approval.ProcessSubmitRequest req1 =  new Approval.ProcessSubmitRequest();
        req1.setObjectId(listKnowledgeObj[0].id);
        req1.setSubmitterId(userinfo.getUserId());
        req1.setProcessDefinitionNameOrId('KB_Approval_Process');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        
        Approval.ProcessSubmitRequest req2 =  new Approval.ProcessSubmitRequest();
        req2.setObjectId(listKnowledgeObj[1].id);
        req2.setSubmitterId(userinfo.getUserId());
        req2.setProcessDefinitionNameOrId('KB_Approval_Process');
        req2.setSkipEntryCriteria(true);
        Approval.ProcessResult result1 = Approval.process(req2);
        
        List<Id> newWorkItemIds = result1.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
        req3.setComments('Approving request.');
        req3.setAction('Approve');
        req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req3.setWorkitemId(newWorkItemIds.get(0));
        Approval.ProcessResult result2 =  Approval.process(req3);*/
    }
}