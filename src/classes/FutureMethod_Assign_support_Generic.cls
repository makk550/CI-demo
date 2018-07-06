public class FutureMethod_Assign_support_Generic{
public static boolean isFutureRunning = false;
@future
public static void updateaccountoncase(Map<id,id> siteMap){

List<Case> caseList = new List<Case>();
     isFutureRunning = true;
    for(Case cse : [select id,AccountID,site_association__c from case where site_association__c IN :siteMap.KeySet()])
    {
      cse.AccountID = siteMap.get(cse.site_association__c);
      caseList.add(cse);
    }
    Database.SaveResult[] srList = Database.update(caseList, false);
     isFutureRunning = false;
    // Iterate through each returned result
   for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted case. Case ID: ' + sr.getId());
        }
    else {
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                    
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Case fields that affected this error: ' + err.getFields());
        }
        }
           }
       }
}