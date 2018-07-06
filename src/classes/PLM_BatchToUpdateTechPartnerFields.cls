/**
*Description :Batch Class to update the Technlogy partner account fields on the 
    Technology partner effective date. This a scheduled to run every day mid night(EST)
*SOQl: 1
*DML: 1 
*Client: CA technologies 
*Developed By:  Siddharth Agarwal
*/
global class PLM_BatchToUpdateTechPartnerFields implements Database.Batchable<sObject>,Database.Stateful{
    public String query;
    
    global database.querylocator start(Database.BatchableContext batchContext){
        system.debug('Batch Start. Query='+query);
        return Database.getQueryLocator(query);    
    }
    
    global void execute(Database.BatchableContext batchContext, List<sObject> scope){
    
        List<Account> listOfAccountsToUpdate=new List<Account>(); 
        for(sObject sObj: scope){
            Account acc=(Account)sObj;
            if(acc.Technology_Partner_Effective_Date__c!=null){
                if(acc.Technology_Partner_Effective_Date__c.day()== System.today().day() && 
                                    acc.Technology_Partner_Effective_Date__c.month()== System.today().month()){
                    acc.Number_of_Integrated_Solution_References__c=0;
                    acc.Number_of_Customer_Success_Stories__c=0;
                    listOfAccountsToUpdate.add(acc);
                }
            }
        }
        try{
        system.debug('listOfAccountsToUpdate ='+listOfAccountsToUpdate);
            update listOfAccountsToUpdate;
        }   
        catch(Exception exp){
            System.debug('The batch to update tech account fields failed'+exp);
        }
    }
        
    global void finish(Database.BatchableContext batchContext){
    }
    
}