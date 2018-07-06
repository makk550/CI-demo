/*
 * Trigger to store the id of the Account on Input Quote Header object upon entry on Ca Account Id
 */
trigger QuoteHeaderAccountId on Input_Quote_Header__c (before insert,before update) {
	
    System.debug('---------in QuoteHeaderAccountId-------');
    List<String> EnterpriseId = new List<String>();
    List<String> OpportunityNumber = new List<String>();
    Map<String,Id> accIdMap = new Map<String,Id>();
   
    
    for(Input_Quote_Header__c input : trigger.new){
        System.debug('------input.CA_Account_Id__c-----'+input.CA_Account_Id__c);
        if(input.CA_Account_Id__c!=null){
            EnterpriseId.add(input.CA_Account_Id__c);
        }
        if(input.Opportunity_Number__c!=null){
            OpportunityNumber.add(input.Opportunity_Number__c);
        }
       
    }
     System.debug('------EnterpriseId------'+EnterpriseId);
    List<Account> accRec;
    if(EnterpriseId!=null && EnterpriseId.size()>0){
        accRec = [select id,Enterprise_ID__c from Account where Enterprise_ID__c in : EnterpriseId];
    }
    List<Opportunity> oppRec;
    if(OpportunityNumber!=null && OpportunityNumber.size()>0){
        oppRec = [select Reseller__c,Partner_Engagement__c,Deal_Registration_Status__c,Opportunity_Number__c from Opportunity where Opportunity_Number__c in : OpportunityNumber];
    }
    
    if(accRec!=null && accRec.size()>0){
        System.debug('------accRec------'+accRec);
        for(Account acct : accRec){
            accIdMap.put(acct.Enterprise_ID__c,acct.id);
        }
    }
     Map<String,Id> oppResellerMap = new Map<String,Id>();
    Map<String,String> oppPEMap = new Map<String,String>();
    Map<String,String> oppDRStatusMap = new Map<String,String>();
    
    if(oppRec!=null && oppRec.size()>0){
        for(Opportunity opp : oppRec){
            oppResellerMap.put(opp.Opportunity_Number__c,opp.Reseller__c);
            oppPEMap.put(opp.Opportunity_Number__c,opp.Partner_Engagement__c);
            oppDRStatusMap.put(opp.Opportunity_Number__c,opp.Deal_Registration_Status__c);
        }
    }
    
    if(accIdMap!=null && accIdMap.size()>0){
        for(Input_Quote_Header__c input : trigger.new){
            input.AccountId__c = accIdMap.get(input.CA_Account_Id__c);
            input.Partner1__c = oppResellerMap.get(input.Opportunity_Number__c);
            input.Partner_Engagement__c = oppPEMap.get(input.Opportunity_Number__c);
            input.Deal_Registration_Status__c = oppDRStatusMap.get(input.Opportunity_Number__c);
        }   
    }
	 
}