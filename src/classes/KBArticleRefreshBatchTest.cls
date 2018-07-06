@isTest//(seealldata=true)
public class KBArticleRefreshBatchTest {
    
    static testMethod void test_Refresh() {
        
        List<KB_Article__c> lstkb = new List<KB_Article__c>();
        List<KB_Article_Case__c> lstkbcase = new List<KB_Article_Case__c>();
       
        KB_Article__c kb1=new KB_Article__c(kb_article_no__c='TEC1023762',kb_article_title__c='Test KB Creation in Chrome in QA ');
        KB_Article__c kb2=new KB_Article__c(kb_article_no__c='TEC1095284',kb_article_title__c='Test');
        KB_Article__c kb3=new KB_Article__c(kb_article_no__c='TEC1061826',kb_article_title__c='Test 123');
        lstkb.add(kb1); 
        lstkb.add(kb2);
        lstkb.add(kb3);    
        insert lstkb;
        
        
        Test.startTest();
             KBArticleRefreshBatch kb = new KBArticleRefreshBatch();
             Database.executeBatch(kb);
        Test.stopTest();
        
        
    }


}