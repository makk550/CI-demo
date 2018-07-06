@isTest
private class LiveAgentPostChatPageControllerTest {
    public static testMethod void  testConstructor(){
        List<LiveAgent_Post_Survey_Questions__c> quesList = new List<LiveAgent_Post_Survey_Questions__c>();
        LiveAgent_Post_Survey_Questions__c ques = new LiveAgent_Post_Survey_Questions__c();
        ques.Name = 'Question 1';
        ques.Question__c = 'Do you have any comments or suggestions to improve the chat experience?';
        ques.Question_Type__c = 'text';
        ques.Language_Code__c ='ENG';
        quesList.add(ques);
        
        LiveAgent_Post_Survey_Questions__c ques1 = new LiveAgent_Post_Survey_Questions__c();
        ques1.Name = 'Question 2';
        ques1.Question__c = 'Would you use chat again?';
        ques1.Question_Type__c = 'boolean';
        ques1.Language_Code__c ='ENG';
        quesList.add(ques1);
        
        LiveAgent_Post_Survey_Questions__c ques2 = new LiveAgent_Post_Survey_Questions__c();
        ques2.Name = 'Question 3';
        ques2.Question__c = 'Please rate your satisfaction with this support experience.  Not at all satisfied = 0  and Extremely Satisfied = 9';
        ques2.Question_Type__c = 'number';
        ques2.Language_Code__c ='ENG';
        quesList.add(ques2);
        
        LiveAgent_Post_Survey_Questions__c ques3 = new LiveAgent_Post_Survey_Questions__c();
        ques3.Name = 'Question 4';
        ques3.Question__c = 'Was your issue resolved?';
        ques3.Question_Type__c = 'boolean';
        ques3.Language_Code__c ='ENG';
        quesList.add(ques3);

        insert quesList;
        Test.startTest();
            ApexPages.currentPage().getParameters().put('chatKey','chatKey');
            LiveAgentPostChatPageController controller = new LiveAgentPostChatPageController();
        Test.stopTest();
        
    }
    
     public static testMethod void  testsaveSurveyResponse(){
           Test.startTest();
            String response = '[{ "questionType":"boolean" , "id":"a8Re00000004CKHEA2" , "question":"Was your issue resolved?" , "response":"True" }, { "questionType":"boolean" , "id":"a8Re00000004CKIEA2" , "question":"Would you use chat again?" , "response":"True" }, { "questionType":"number" , "id":"a8Re00000004CKFEA2" , "question":"Please rate your satisfaction with this support experience.  Not at all satisfied = 0  and Extremely Satisfied = 9" , "response":"0" }, { "questionType":"text" , "id":"a8Re00000004CKDEA2" , "question":"Do you have any comments or suggestions to improve the chat experience?" , "response":"vcxvxcvxcv" }]';  
         LiveAgentPostChatPageController.saveSurveyResponse('chatkey',response);
        Test.stopTest();
     }
}