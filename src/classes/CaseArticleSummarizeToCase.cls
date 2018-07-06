global class CaseArticleSummarizeToCase implements Database.Batchable<sObject>, Schedulable{

    public static String JOB_TITLE = 'Job to stamp case with count of CaseArticle objects';
    public static String CRON_STRING = '0 0 4 * * ?'; // 4 AM daily

    public static void scheduleMe(){
        CaseArticleSummarizeToCase sch = new CaseArticleSummarizeToCase();

        if(Test.isRunningTest()){
            System.schedule('Test ' + JOB_TITLE + ' Test', CRON_STRING, sch);
        }else{
            System.schedule(JOB_TITLE, CRON_STRING, sch);
        }
    }

    public void execute(SchedulableContext sc){
        CaseArticleSummarizeToCase sch = new CaseArticleSummarizeToCase();
        Database.executeBatch(sch, 200); // integer is the size of the batch
    }

    public final String objects;

    public CaseArticleSummarizeToCase() {
        //Update query to include last modified >= today - 1
        String modFilter = String.valueOf(Datetime.now().addDays(-1));
        //Uncomment below to fix the Case Article Count Issue
        //String modFilter = String.valueOf(Datetime.now().addDays(-2));
        modFilter = modFilter.replace(' ', 'T');
        modFilter = modFilter + 'Z';
        objects = 'SELECT Id, Case_Article_Count__c FROM Case WHERE LastModifiedDate >= ' + modFilter;
        system.debug(objects);
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(objects);
    }

    global void execute(Database.BatchableContext BC, List<Case> scope){ 
        List<Case> updateCases = new List<Case>();
        Map<String,Integer> caseArticleCounts = new Map<String,Integer>();
        for(Case record : scope){
            caseArticleCounts.put(record.Id, 0);
        }
        for (CaseArticle ca : [SELECT Id, CaseId FROM CaseArticle WHERE CaseId in :caseArticleCounts.keySet()]) {
            Integer currentCount = caseArticleCounts.get(ca.CaseId);
            currentCount++;
            caseArticleCounts.put(ca.CaseId, currentCount);
        }

        for (Case record : scope) {
            if (record.Case_Article_Count__c != caseArticleCounts.get(record.Id)) {
                if ((record.Case_Article_Count__c == null) && (caseArticleCounts.get(record.Id) == 0)) {
                    //do nothing as null and 0 are the same for the formula field
                } else {
                    record.Case_Article_Count__c = caseArticleCounts.get(record.Id);
                    updateCases.add(record);
                }
            }
        }
        if (!updateCases.isEmpty()) {
            Database.SaveResult [] updateResult = Database.update(updateCases, false);
        }


    }

    global void finish(Database.BatchableContext BC){

    }
}