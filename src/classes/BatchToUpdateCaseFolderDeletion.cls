global class BatchToUpdateCaseFolderDeletion implements Database.Batchable<sObject>, Database.Stateful {
    
    public Set<String> caseNumbers;
    public List<Case> failedCaseNumbers = new List<Case>();
    public List<Case> successCases =  new List<Case>(); 
    
    global BatchToUpdateCaseFolderDeletion(Set<String> caseNumbers){
        this.caseNumbers = caseNumbers; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext batchContext) 
    {
        return Database.getQueryLocator( [select id,caseNumber,SFTP_Directory_Deleted__c from Case 
                                          where  caseNumber IN :caseNumbers]);
    }
    
    global void execute(Database.BatchableContext batchContext, List<Case> caseList) 
    {
        try{
            for(Case caseRec : caseList){
                caseRec.SFTP_Directory_Deleted__c = true;
            }            
            update caseList;
            successCases.addAll(caseList);
        } catch(Exception e){
            failedCaseNumbers.addAll(caseList);
        }        
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('In finish block');
        System.debug('failedCaseNumbers():' + failedCaseNumbers.size() );
        System.debug('successCases():'+successCases.size());
        System.debug('successCases:'+successCases);        
    }
    
}