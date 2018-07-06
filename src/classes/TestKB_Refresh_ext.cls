@isTest(seealldata=true)
public class TestKB_Refresh_ext {
    
    static testMethod void test_Refresh() {
        
        Kb_article_case__c test=[select case__c from KB_Article_Case__c limit 1];
        Case kbCase=new Case(id=test.case__c);
        KB_Article__c kb1=new KB_Article__c(kb_article_no__c='TEC1023762',kb_article_title__c='Test KB Creation in Chrome in QA ');
        KB_Article__c kb2=new KB_Article__c(kb_article_no__c='TEC1095284',kb_article_title__c='Test');
        KB_Article__c kb3=new KB_Article__c(kb_article_no__c='TEC1061826',kb_article_title__c='Test 123');
        insert kb1;
        insert kb2; 
        insert kb3; 
        KB_Article_Case__c caseKB1=new KB_Article_Case__c(KB_Article__c=kb1.Id, case__c=kbCase.id);
        KB_Article_Case__c caseKB2=new KB_Article_Case__c(KB_Article__c=kb2.Id, case__c=kbCase.Id);
        KB_Article_Case__c caseKB3=new KB_Article_Case__c(KB_Article__c=kb3.Id, case__c=kbCase.Id);
        insert caseKB1; 
        insert caseKB2;
        insert caseKB3;
        KB_Refresh_ext kbExt=new KB_Refresh_ext(new ApexPages.StandardController(kbCase));
        kbExt.refreshCaseKB();
        system.assert(String.isNotEmpty(kbExt.message));
    }
    
     static testMethod void testParse() {
        String json=        '{'+
            '    "d": {'+
            '        "results": ['+
            '            {'+
            '                "CACurrentAuthor": {'+
            '                    "Title": "Yerramilli, Archana"'+
            '                },'+
            '                "CA_x0020_Doc_x0020_ID": "TEC1023762",'+
            '                "CA_x0020_Doc_x0020_Title": "Test KB Creation in Chrome in QA ",'+
            '                "Workflow_x0020_Status": "Published",'+
            '                "Modified": "2015-01-14T13:43:07Z"'+
            '            },'+
            '            {'+
            '                "CACurrentAuthor": {'+
            '                    "Title": "Yerramilli, Archana"'+
            '                },'+
            '                "CA_x0020_Doc_x0020_ID": "TEC1095284",'+
            '                "CA_x0020_Doc_x0020_Title": "test",'+
            '                "Workflow_x0020_Status": "APPROVER PENDING",'+
            '                "Modified": "2015-09-03T19:56:32Z"'+
            '            },'+
            '            {'+
            '                "CACurrentAuthor": {'+
            '                    "Title": "Munnuru, Venu Gopal"'+
            '                },'+
            '                "CA_x0020_Doc_x0020_ID": "TEC1061826",'+
            '                "CA_x0020_Doc_x0020_Title": "test 123",'+
            '                "Workflow_x0020_Status": "Draft",'+
            '                "Modified": "2015-10-13T08:44:04Z"'+
            '            }'+
            '        ]'+
            '    }'+
            '}';
        KBRefreshWrapper obj = KBRefreshWrapper.parse(json);
        System.assert(obj != null);
    }
}