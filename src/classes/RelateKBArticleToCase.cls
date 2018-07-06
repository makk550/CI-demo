global class RelateKBArticleToCase {
    public String kbArticleNumb{get;set;}
    public String errorLevel {get; set;}
    public String messageName {get; set;}
    ApexPages.standardController controller;
    public static Integer statusCode;
    String kbArticleId;

    
    public RelateKBArticleToCase(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    
    public void showMessage() {
        if(errorLevel == 'ERROR') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, messageName));
        } else if(errorLevel == 'INFO') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, messageName));
        }
    }
    
    

    @RemoteAction
    global static String saveKBArticle(String kbArticleNo, String caseId) {
        if (String.isBlank(kbArticleNo)) {
            return 'Validation';
        } else {
            //Check whether KBArticle is already present.
            List<KB_Article__c> kbArticles = [Select Id from KB_Article__c where KB_Article_No__c = :kbArticleNo LIMIT 1];
            String KbArticleId;
            
            if (kbArticles.size() == 0) {
                //Call Layer7 service to validate the KB Article and fetch KB Article details
                KB_Article__c kbArtcle = KBArticleHandler.validateSyncKBArticle(kbArticleNo);
                
                if (statusCode != null) {
                    if (statusCode == 2016 || statusCode == 2020) {
                        return 'NotValidKB';
                    } else if (statusCode == 2018) {
                        return '2018';
                    } else if (statusCode == 2015) {
                        return '2015';
                    } else if (statusCode == 1212) {
                        return 'TimedOut';
                    } else if (statusCode >= 300) {
                        return 'ConnectionError';
                    } else {
                        return 'Error';
                    }
                }
                KbArticleId = kbArtcle.Id;
            } else {
                KbArticleId = kbArticles[0].Id;
            }                  
            
            if ( KbArticleId != null ) {
                List<KB_Article_Case__c> kbArticleCases = [Select Id from KB_Article_Case__c where Case__c = :caseId and KB_Article__c =:KbArticleId];
                if ( kbArticleCases.size() > 0 ) {
                    return 'Linked';
                } else {
                    KB_Article_Case__c kbArticleCase = new KB_Article_Case__c(Case__c=caseId, KB_Article__c=KbArticleId);
                    insert kbArticleCase;
                }                    
            }   
        }
        return 'Success';
    } 
}