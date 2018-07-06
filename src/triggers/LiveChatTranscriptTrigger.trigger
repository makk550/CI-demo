Trigger LiveChatTranscriptTrigger on LiveChatTranscript (Before Insert,After Insert,After Update, Before Delete) {
      
   
    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            LiveAgentFeedbackHandler.linkToAnswers(Trigger.New);
            Map<id,LiveChatTranscript> tmap = new Map<Id,LiveChatTranscript>();
            //Update Contact/Lead if associated to the live chat transcript. Allha02 Live Chat Enhancement US144325
             LiveAgentFeedbackHandler.updateContact_Leads(Trigger.New,tmap);
            LiveAgentFeedbackHandler.updateCaseType(Trigger.new); //added by suresh
        }        
    }
    
    if(Trigger.isUpdate){
        //Update Contact/Lead if associated to the live chat transcript. Allha02 Live Chat Enhancement US144325
        LiveAgentFeedbackHandler.updateContact_Leads(Trigger.New,Trigger.OldMap);
        //added by suresh
        if(Trigger.isAfter)
        LiveAgentFeedbackHandler.updateCaseType(Trigger.new);

    }
}