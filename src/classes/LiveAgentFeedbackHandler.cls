public class LiveAgentFeedbackHandler {
    
        public static void linkToAnswers(List<LiveChatTranscript> liveChatTranscripts){
        System.debug('****liveChatTranscripts***'+liveChatTranscripts);
        Set<String> chatKeys = new Set<String>();
        Map<String,ID> transcriptMap = new Map<String,ID>();
        Map<String,ID> caseMap = new Map<String,ID>();
        for(LiveChatTranscript liveChatTranscript : liveChatTranscripts){
            chatKeys.add(liveChatTranscript.ChatKey);
            transcriptMap.put(liveChatTranscript.ChatKey , liveChatTranscript.Id); 
        }
        List<LiveAgent_Post_Survey_Answers__c> answers = new List<LiveAgent_Post_Survey_Answers__c> ();
  
        for(LiveAgent_Post_Survey_Answers__c answer : [SELECT Id, Name, Chat_Key__c,  Live_Chat_Transcript__c FROM LiveAgent_Post_Survey_Answers__c where Chat_Key__c in : chatKeys ]){  
            if(transcriptMap.get(answer.Chat_Key__c)!=null){
                answer.Live_Chat_Transcript__c = transcriptMap.get(answer.Chat_Key__c);
                answers.add(answer);
            }
        }
        System.debug('****answers***'+answers);
        if(answers.size()>0){
            update answers;
        }
        
    }
    
    
    
    public static void linkToCases(List<LiveChatTranscript> liveChatTranscripts){
        System.debug('****l before insert iveChatTranscripts***'+liveChatTranscripts);
        Set<String> chatKeys = new Set<String>();
        Map<String,ID> transcriptMap = new Map<String,ID>();
        Map<String,ID> caseMap = new Map<String,ID>();
        for(LiveChatTranscript liveChatTranscript : liveChatTranscripts){
            chatKeys.add(liveChatTranscript.ChatKey);
            transcriptMap.put(liveChatTranscript.ChatKey , liveChatTranscript.Id); 
        }
        List<LiveAgent_Post_Survey_Answers__c> answers = new List<LiveAgent_Post_Survey_Answers__c> ();
           
    }
    //added by suresh
    public static void updateCaseType(List<LiveChatTranscript> liveChatTranscripts)
    {
        List<Case> lstCases = new List<Case>();
       // System.debug('****l before insert iveChatTranscripts***'+liveChatTranscripts);
        Set<Id> caseIdSet = new Set<Id>();
        for(LiveChatTranscript chatTrans :liveChatTranscripts){
       // System.debug('===='+chatTrans.closure_reason__c );
                if(String.isNotBlank(chatTrans.caseId) && String.isNotBlank(chatTrans.closure_reason__c) && chatTrans.closure_reason__c =='Closed - Assisted Issue Created (Transferred to Service Cloud Case)'){
                    caseIdSet.add(chatTrans.caseId);
                }
        }
       // System.debug('==####'+caseIdSet);
        for(case c : [select id,case_Type__c from Case where Id IN: caseIdSet]){
        
            c.case_Type__c ='Standard';
            lstCases.add(c);
        
        }
       // System.debug('@@@@@'+lstCases);
        if(lstCases.size()>0)
        update lstCases;
        
    }
    

    
    //Update Contact/Lead if associated to the live chat transcript. Allha02 Live Chat Enhancement US144325
    public static void updateContact_Leads(List<LiveChatTranscript> liveChatTranscripts,Map<Id,LiveChatTranscript> liveChatTranscripts_old){
        System.debug('**** before insert/Update liveChatTranscripts***'+liveChatTranscripts);
        System.debug('**** before insert/Update liveChatTranscripts Old Map***'+liveChatTranscripts_old);
        List<Contact> contacts = new List<Contact>();
        List<Lead> leads = new List<Lead>();
        
        for(LiveChatTranscript lt: liveChatTranscripts){
            
            if(lt.ContactId!=null && lt.Sales_Chat_Reason__c!=null){
                Contact ct = new Contact();
                ct.Id=lt.ContactId;
                ct.Sales_Chat_Reason__c=lt.Sales_Chat_Reason__c;
                contacts.add(ct);
            }
            if(lt.LeadId!=null && lt.Sales_Chat_Reason__c!=null){
                Lead ld = new Lead();
                ld.Id = lt.LeadId;
                ld.Sales_Chat_Reason__c=lt.Sales_Chat_Reason__c;
                leads.add(ld);
            }
            if(!liveChatTranscripts_old.isEmpty()){
            if(lt.ContactId==null && liveChatTranscripts_old.get(lt.Id).ContactId!=null){
                Contact ct = new Contact();
                ct.Id=liveChatTranscripts_old.get(lt.Id).ContactId;
                ct.Sales_Chat_Reason__c=null;
                contacts.add(ct);
                
            }
            if(lt.LeadId==null && liveChatTranscripts_old.get(lt.Id).LeadId!=null){
                Lead ld = new Lead();
                ld.Id = liveChatTranscripts_old.get(lt.Id).LeadId;
                ld.Sales_Chat_Reason__c=null;
                leads.add(ld);
            }
          }
        }
        if(contacts.size()>0) {
           Database.SaveResult[] sr_c = Database.update(contacts,false);
        }
        if(leads.size()>0) {
           Database.SaveResult[] sr_l = Database.update(leads,false); 
        }
    }
}