public with sharing class controlTranscript {
    public Case cObj;
    public LiveChatTranscript lObj{get;set;}
    public controlTranscript(ApexPages.StandardController controller) {
        cObj = (Case)controller.getrecord();
        
lObj = [select Id, closure_reason__c,caseId from LiveChatTranscript where caseId =:Apexpages.currentPage().getparameters().get('Id') LIMIT 1]; 
    }
  public PageReference saveRecord() {
        
        update lObj;
        update cObj ;
      
        return null;
    } 
}