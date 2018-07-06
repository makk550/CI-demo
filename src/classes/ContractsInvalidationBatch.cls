global class ContractsInvalidationBatch implements Database.Batchable<sObject>, Database.Stateful{
    //---THIS CLASS WAS DEVELOPED TO IMPLEMENT THE FUNCTIONALITIES IN CR:192534927, CR:192777136 DURING DECEMBER MINI RELEASE 2012---
    /*
        CR:192534927
        If all active contract line item "ACL status" field values  contains “Invalid”  then automatically set the Active Contract Product = “Invalid”.
        If all active contract product status values = “invalid”, the automatically set the Active Contract  = “invalid”.    
    */
    /*
        CR:192777136
        If a new active contract line item record is created for an existing active contract 
        and  the active contract.valuation status = ‘validated’
        update active contract. CRV_Process_completed_c = false  (unchecked)
        and active contract.In_Progress_c = false (unchecked) 

    */
    public String Query;
    public String DT;
    public string CDT;
    public String current;
    public String previous;
    
    global Set<Id> ACIdSet = new Set<Id>();//---Used this set in the Class Account_MIPSupdate to query the Active Contracts which got updated in the ACL load
    public DateTime dttt = System.now()-1;//---Last 24 hours date
     
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      System.debug('++++++In Batch Class Start++++++++++');        
      return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, 
                       List<Active_Contract_Line_Item__c> scope){
        Set<Id> ACPIdSet = new set<Id>();//---Set of ActiveContractProduct IDs---
        Set<Id> ACIds = new Set<Id>();//---Set of ActiveContract IDs---
        Set<Id> ACRecIdSetCreatedToday = new Set<Id>();//---Creates a set of AC Record ID set for all the ACL records created TODAY
        System.debug('++++++In Batch Class Execute++++++++++'); 
        
        for(Active_Contract_Line_Item__c acl:scope){
            if(acl.CreatedDate>=dttt){            
                ACRecIdSetCreatedToday.add(acl.Contract_Product__r.Active_Contract__c);                
            }
            ACPIdSet.add(acl.Contract_Product__c);
            ACIds.add(acl.Contract_Product__r.Active_Contract__c);
        }
                
        
        List<Active_Contract_Product__c> ACPList = [select Id,Invalid__c,Active_Contract__c,Licensed_MIPS_Quantity__c from Active_Contract_Product__c where Active_Contract__c IN: ACIds];   
        Set<Id> ACPIds = new Set<Id>();
        for(Active_Contract_Product__c acp:ACPList){
            ACPIds.add(acp.Id);
        }
        
        
        List<Active_Contract_Line_Item__c> ACLList = [select Id,ACL_Status__c,Contract_Product__c,Licensed_MIPS_Quantity__c from Active_Contract_Line_Item__c where Contract_Product__c IN: ACPIds];
        Map<Id,List<Active_Contract_Line_Item__c>> ACPIdACLMap = new Map<Id,List<Active_Contract_Line_Item__c>>();//---Map of ActiveContractProductId as a key and the corresponding ActiveContractLineItems as values---  
        for(Active_Contract_Line_Item__c acl:ACLList){
            if(!ACPIdACLMap.containsKey(acl.Contract_Product__c)){
                ACPIdACLMap.put(acl.Contract_Product__c,new List<Active_Contract_Line_Item__c>());
                ACPIdACLMap.get(acl.Contract_Product__c).add(acl);
            }else{
                ACPIdACLMap.get(acl.Contract_Product__c).add(acl);
            }
        } 
        Map<Id,boolean> ACPStatusMap = new Map<Id,boolean>();//---Map of ActiveContractProductId as a key and its status as a value--
        
        for(Id i:ACPIdACLMap.keySet()){
            boolean anyNullRecord = false;
            List<Active_Contract_Line_Item__c> aclListInLoop = ACPIdACLMap.get(i);            
            for(Active_Contract_Line_Item__c acl:ACPIdACLMap.get(i)){                
                if(acl.ACL_Status__c!=null){
                    if(!(acl.ACL_Status__c.containsIgnoreCase('Invalid'))){
                        if(!ACPStatusMap.containsKey(i)){
                            ACPStatusMap.put(i,false);                            
                        }                    
                    }
                }else{
                    anyNullRecord = true;                     
                }
                if(anyNullRecord == true){
                    if(!ACPStatusMap.containsKey(i)){
                            ACPStatusMap.put(i,false);                            
                    }
                }
                 
                         
            }            
        } 
        
        for(Active_Contract_Product__c acp:ACPList){                      
            if(ACPStatusMap.containsKey(acp.Id)){                
                acp.Invalid__c = ACPStatusMap.get(acp.Id);
                Decimal MAXMIPSValue = 0;
                for(Active_Contract_Line_Item__c acl:ACPIdACLMap.get(acp.Id)){ 
                    if(acl.ACL_Status__c!=null){                   
                        if(!(acl.ACL_Status__c.containsIgnoreCase('Invalid')) && acl.Licensed_MIPS_Quantity__c > MAXMIPSValue){
                            MAXMIPSValue = acl.Licensed_MIPS_Quantity__c;                            
                        }
                    }else if(acl.Licensed_MIPS_Quantity__c > MAXMIPSValue){
                        MAXMIPSValue = acl.Licensed_MIPS_Quantity__c;                        
                    }
                }
                acp.Licensed_MIPS_Quantity__c = MAXMIPSValue;
            }else{                
                acp.Invalid__c = true;
            }
        }  
        update ACPList;//---Updating ActiveContractProduct with the status---
        
        
        Map<Id,List<Active_Contract_Product__c>> ACIdACPMap = new Map<Id,List<Active_Contract_Product__c>>();//---Map of ActiveContract as  key and ActiveContractProducts as values---
        for(Active_Contract_Product__c acp:ACPList){
            if(!ACIdACPMap.containsKey(acp.Active_Contract__c)){
                ACIdACPMap.put(acp.Active_Contract__c,new List<Active_Contract_Product__c>());
                ACIdACPMap.get(acp.Active_Contract__c).add(acp);
            }else{
                ACIdACPMap.get(acp.Active_Contract__c).add(acp);
            }
        }  
        Map<Id,boolean> ACStatusMap = new Map<Id,boolean>();//---Map of ActiveContractId as a key and its status as a value---
        for(Id i:ACIdACPMap.keySet()){
            for(Active_Contract_Product__c acp:ACIdACPMap.get(i)){
                if(acp.Invalid__c == false){
                    if(!ACStatusMap.containsKey(i)){
                        ACStatusMap.put(i,false);
                    }  
                }
            }
        }
        
        List<Active_Contract__c> ACList = [select Id,Invalid__c,Status_Formula__c,In_Progress__c,CRV_Process_completed__c,Licensed_MIPS_Quantity__c,Business_Transaction_Type__c,Valuation_Tier__c,Finance_Owner__c from Active_Contract__c where Id IN: ACIds];    
        for(Active_Contract__c ac:ACList){
            ACIdSet.add(ac.Id);  
            if(ACStatusMap.containsKey(ac.Id)){
                ac.Invalid__c = ACStatusMap.get(ac.Id);
                                
                Decimal MAXMIPSValue = 0;
                for(Active_Contract_Product__c acp:ACIdACPMap.get(ac.Id)){                    
                    if(acp.Invalid__c != True && acp.Licensed_MIPS_Quantity__c > MAXMIPSValue){
                        MAXMIPSValue = acp.Licensed_MIPS_Quantity__c;
                    }
                }
                ac.Licensed_MIPS_Quantity__c = MAXMIPSValue;
                
            }else{
                ac.Invalid__c = true;
            }
            
            if(ACRecIdSetCreatedToday.contains(ac.Id) && ac.Status_Formula__c == 'Validated'){  
                if(ac.Valuation_Tier__c == 'Tier 2' && ac.Business_Transaction_Type__c == 'Time' && ac.Finance_Owner__c != NULL){
                    ac.CRV_Process_completed__c = true;
                }else{
                    ac.In_Progress__c = false;
                    ac.CRV_Process_completed__c = false; 
                }          
            }
        }
        update ACList;//---Updating ActiveContract with the status---
    }
    global void finish(Database.BatchableContext BC){
        System.debug('++++++In Batch Class Finish++++++++++');
        Account_MIPSupdate AM = new Account_MIPSupdate();
        AM.updateAccount_MIPS(ACIdSet);
    }    
}