global class LiveAgentPostChatPageController_Jp {
    
public List<String> questions;
    public Map<String,String> questionMap{get;set;}
    public List<LiveAgent_Post_Survey_Questions__c> questionRecords{get;set;}
    public List<LiveAgent_Post_Survey_Questions__c> booleanQuestions{get;set;}
    public List<LiveAgent_Post_Survey_Questions__c> numberQuestions{get;set;}
    public List<LiveAgent_Post_Survey_Questions__c> textQuestions{get;set;}
    
    
    
    public LiveAgentPostChatPageController_Jp(){    
        String chatKey = ApexPages.currentPage().getParameters().get('chatKey') ;
        questions = new List<String>();
        questionMap = new Map<String,String>();
        questionRecords =  new List<LiveAgent_Post_Survey_Questions__c>();
        booleanQuestions =  new List<LiveAgent_Post_Survey_Questions__c>();
        numberQuestions =  new List<LiveAgent_Post_Survey_Questions__c>();
        textQuestions =  new List<LiveAgent_Post_Survey_Questions__c>();
      
         for(LiveAgent_Post_Survey_Questions__c chatSurveQuestion : [Select name ,Question__c,Question_Type__c from LiveAgent_Post_Survey_Questions__c WHERE Language_Code__c='JP' order by name asc]){
             if(chatSurveQuestion.Question_Type__c == 'boolean'){
                 booleanQuestions.add(chatSurveQuestion);
             }else if(chatSurveQuestion.Question_Type__c == 'number'){
                 numberQuestions.add(chatSurveQuestion);
             }else if(chatSurveQuestion.Question_Type__c == 'text'){
                 textQuestions.add(chatSurveQuestion);
             }
           
        }  
    }
    
    public class AnswerResponse{
        
        String questionType;
        String id;
        String question;
        String response;
        
    }
    
    
    @RemoteAction
    global static  String saveSurveyResponse(String chatKey, String response){
        System.debug('response****'+response);
        List<AnswerResponse> answers = (List<AnswerResponse>)JSON.deserialize(response, List<AnswerResponse>.class); 
        System.Debug(answers);
        List<LiveAgent_Post_Survey_Answers__c> liveAgentAnswers = new List<LiveAgent_Post_Survey_Answers__c>();
        for(AnswerResponse answer : answers ){
        	LiveAgent_Post_Survey_Answers__c liveAgentAnswer = new LiveAgent_Post_Survey_Answers__c();
            if(answer.questionType == 'boolean'){
                if(answer.response.trim() == 'true'){
                    if(answer.question.contains('issue')){
                        liveAgentAnswer.issue_resolved__c = true;
                    }else if(answer.question.contains('chat again')){
                        liveAgentAnswer.chat_again__c = true;
                    }
                    
                } 
            }else if(answer.questionType.trim() == 'number'){
				 try {
                    liveAgentAnswer.Rating__c = Integer.valueOf(answer.response.trim());
                }
                Catch (exception e) {                    
                    liveAgentAnswer.Feedback__c = answer.response.trim();
                }                   
                
            } else if(answer.questionType.trim() == 'text'){		                 
                    liveAgentAnswer.Feedback__c = answer.response.trim();                                 
                
            }
            liveAgentAnswer.Chat_Key__c = chatKey;
            liveAgentAnswer.LiveAgent_Post_Survey_Questions__c = answer.Id.trim();
            liveAgentAnswer.Name = chatKey;
            liveAgentAnswer.question__c = answer.question;
            liveAgentAnswers.add(liveAgentAnswer);
        }
        
        if(liveAgentAnswers.size()>0){
            try{
                insert liveAgentAnswers;               
            }catch(Exception e){
                return e.getMessage();
            }            
        }else{
            return 'failure';            
        }
        return 'success';
    }
    
    
}