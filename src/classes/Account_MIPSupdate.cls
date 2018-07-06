public class Account_MIPSupdate{
    //---THIS CLASS WAS DEVELOPED TO IMPLEMENT THE FUNCTIONALITY IN CR:191138508 DURING DECEMBER MINI RELEASE 2012---
    //---THIS CLASS WILL BE INVOKED IN THE APEX CLASS "ContractsInvalidation" WHICH WAS AN EMAIL SERVICE THAT GETS TRIGGERED WHEN ACL LOAD IS DONE FROM INFORMATICA END
    /*  For each Account (Account Team, Territory or SMB) calculate the Account : Max Licensed MIPS amount equal to the  MAX Licensed MIPS Quantity 
        of all related Active Contracts where Active Contract.Invalid not = True and where "Action at End of Contract" is not "Term Ended Renewed,".   
        Optimize the query to only process accounts where there is at least one related Active Contract with an Active Contract. Last Modified Date within the previous month.
    */
    public void updateAccount_MIPS(Set<Id> ACIdSet){
        System.debug('+++++++ACIdSet in Account_MIPSupdate class+++++'+ACIdSet);      
        System.debug('+++++++ACIdSet size in Account_MIPSupdate class+++++'+ACIdSet.size());
        Set<Id> AccIdSet = new Set<Id>();

        //List<Active_Contract__c> ACList = [select Id,Account__c,Licensed_MIPS_Quantity__c from Active_Contract__c where Account__c!=null AND Invalid__c=:False AND Segmentation__c != 'Term Ended Renewed' AND LastModifiedDate = LAST_MONTH];    
        List<Active_Contract__c> ACList = [select Id,Account__c,Licensed_MIPS_Quantity__c from Active_Contract__c where Id IN: ACIdSet AND Account__c!=null AND Invalid__c=:False AND Segmentation__c != 'Term Ended Renewed'];    
        System.debug('+++++++ACList+++++++'+ACList);
        Map<Id,List<Active_Contract__c>> AccIdACMap = new Map<Id,List<Active_Contract__c>>();//---Map of as Account Id as key and valid ActiveContracts as values---
        for(Active_Contract__c ac:ACList){
            AccIdSet.add(ac.Account__c); 
            if(!AccIdACMap.containsKey(ac.Account__c)){
                AccIdACMap.put(ac.Account__c,new List<Active_Contract__c>());
                AccIdACMap.get(ac.Account__c).add(ac);
            }else{
                AccIdACMap.get(ac.Account__c).add(ac);
            }
        }  
        List<Account> AccountsList = [select Id,Max_Licensed_MIPS__c from Account where Id IN: AccIdSet];
        System.debug('+++++++AccountsList+++++++'+AccountsList);
        for(Account a:AccountsList){
              Decimal MAXMIPSValue = 0;
              for(Active_Contract__c ac:AccIdACMap.get(a.Id)){
                  if(ac.Licensed_MIPS_Quantity__c > MAXMIPSValue){
                        MAXMIPSValue = ac.Licensed_MIPS_Quantity__c;
                  }
              }
              a.Max_Licensed_MIPS__c = MAXMIPSValue;                        
        }   
        SystemIdUtility.skipAccountOnMIPSUpdate = true;
        update AccountsList;  
         
    }
}