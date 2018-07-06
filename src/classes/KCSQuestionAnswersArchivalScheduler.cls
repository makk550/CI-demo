global class KCSQuestionAnswersArchivalScheduler implements Database.AllowsCallouts, Database.Batchable<sObject>, Schedulable{

    global Database.QueryLocator start(Database.BatchableContext batchableContext){
        String query;
        Id RecordTypeIdVal =Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get(System.Label.QuestionAnswerRecordType).getRecordTypeId();
        if(Test.isRunningTest()){
        	query = 'SELECT ArticleNumber, UrlName, Title, Summary, Request_Type__c, ValidationStatus, Introduction__c, Question__c, Environment__c, Answer__c, Additional_Information__c, Id, KnowledgeArticleId, RecordTypeId, Legacy_Approval_History__c, Auto_Article_Numbers__c, Product_Names__c, CADocid__c, LastPublishedDate, CreatedDate, LastModifiedDate, Product_Association__c, CreatedById, Component_Names__c, Component_Codes__c, Releases__c, ECM_Created_Date__c, ECM_Last_Modified_Date__c, ECM_Modified_Date__c, PublishStatus, LastModifiedById, CMS_IDs__c, VersionNumber, Keywords__c, Notes__c, Legacy_Source__c, Legacy_Current_Author__c FROM Knowledge__kav where PublishStatus = \'archived\' AND RecordTypeId=:RecordTypeIdVal AND ArticleArchivedById !=\'\' ';
        }
        else{
            query = 'SELECT ArticleNumber, UrlName, Title, Summary, Request_Type__c, ValidationStatus, Introduction__c, Question__c, Environment__c, Answer__c, Additional_Information__c, Id, KnowledgeArticleId, RecordTypeId, Legacy_Approval_History__c, Auto_Article_Numbers__c, Product_Names__c, CADocid__c, LastPublishedDate, CreatedDate, LastModifiedDate, Product_Association__c, CreatedById, Component_Names__c, Component_Codes__c, Releases__c, ECM_Created_Date__c, ECM_Last_Modified_Date__c, ECM_Modified_Date__c, PublishStatus, LastModifiedById, CMS_IDs__c, VersionNumber, Keywords__c, Notes__c, Legacy_Source__c, Legacy_Current_Author__c FROM Knowledge__kav where PublishStatus = \'archived\' AND RecordTypeId=:RecordTypeIdVal AND ArticleArchivedById !=\'\' AND ArchivedDate <= LAST_QUARTER';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext batchableContext, List<Knowledge__kav> knowledgeObjects){
        Set<String> knowledgeArticleIdSet = new Set<String>();
        KCSQuestionAnswersArchival kcsQuestionAnswersArchival = new KCSQuestionAnswersArchival();

        for(Knowledge__kav knowledgeObject : knowledgeObjects){
            knowledgeArticleIdSet.add(kcsQuestionAnswersArchival.generateXMLDocument(knowledgeObject));
        }

        for(String knowledgeArticleId : knowledgeArticleIdSet){
            deleteArticle(knowledgeArticleId);
        }
    }

    global void finish(Database.BatchableContext batchableContext){
        
    }

    private void deleteArticle(String knowledgeArticleId){
        try{
            if(null != knowledgeArticleId && knowledgeArticleId != ''){
                KbManagement.PublishingService.deleteArchivedArticle(knowledgeArticleId);
            }
        }catch(Exception reason){
            System.debug('************* Exception Occured While Deleting The Article For KnowledgeArticleId : '+knowledgeArticleId);
            System.debug('************* Exception Details : '+reason);
        }
    }

    global void execute(SchedulableContext schedulableContext){
        integer monthValue = Date.today().month();
        if(monthValue == 3 || monthValue == 6 || monthValue == 9 || monthValue == 12){
            Database.executeBatch(new KCSQuestionAnswersArchivalScheduler(), 10);
        }
    }
  }