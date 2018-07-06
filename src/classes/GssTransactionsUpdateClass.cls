public class GssTransactionsUpdateClass {
		
    @InvocableMethod
    public static void populateCurrentNextActionDueDate(List<Case> caseList){
        
        List<GSS_Transactions__C> gssUpdateList = new List<GSS_Transactions__C>();
        List<Id> caseIdList = new List<Id>();
        for(Case caseRec : caseList){
            caseIdList.add(caseRec.Id);
        }
        
        List<GSS_Transactions__C> gssTransList = [select id,Current_GSS_TR__c,Current_Next_Action_Due_Date__c,case__r.Next_Action_Due_Date__c from GSS_Transactions__C
                                             	where case__c IN :caseIdList order by createdDate desc limit 2
                                             ];
       
        System.debug('gssTransList:'+gssTransList);
        
        for(GSS_Transactions__C gsstr: gssTransList){
            if(gsstr.Current_Next_Action_Due_Date__c == null){
                gsstr.Current_Next_Action_Due_Date__c = gsstr.Case__r.Next_Action_Due_Date__c;        
                gssUpdateList.add(gsstr);
            }            
        }
        
        System.debug('gssUpdateList:'+gssUpdateList);
        if(gssUpdateList!= null && gssUpdateList.size()>0)
        	update gssUpdateList;               
        
    }
    
}