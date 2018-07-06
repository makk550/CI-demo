trigger CA_SBQuoteLineItemTrigger on SBQQ__QuoteLine__c(after insert, after update, after delete) {
   
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }
        if (Trigger.isUpdate) {
        
        }
        if (Trigger.isDelete) {
        
        }
    }

    if (Trigger.IsAfter) {
        if (Trigger.isInsert) {  
            system.debug('is insert getting called: ');
         CA_SBQuoteLineItemTriggerHandler.createAgreementLineItems(Trigger.new);   
        } 
        if (Trigger.isUpdate) {
           /* Integer flag=0;
            for(SBQQ__QuoteLine__c sbquote: Trigger.new){
                system.debug(' Out SBQuote.name : '+SBQuote.name+', SBQuote.Parent_Bundle__c : '+SBQuote.Parent_Bundle__c +', SBQuote.SBQQ__RequiredBy__c ' +SBQuote.SBQQ__RequiredBy__c);
                if(!SBQuote.Parent_Bundle__c){
                    system.debug('SBQuote.name : '+SBQuote.name+', SBQuote.Parent_Bundle__c : '+SBQuote.Parent_Bundle__c);
                    flag=1;
            }
            }
            system.debug('Flag value : '+flag);
            if(flag!=0)
            {*/
            if(CA_SBQuoteLineItemTriggerHandler.runOrNot())
            CA_SBQuoteLineItemTriggerHandler.deleteAgreementLineItems(Trigger.new);
            
       //  CA_SBQuoteLineItemTriggerHandler.updateAgreementLineItems(Trigger.new,Trigger.oldMap);
        }
        if (Trigger.isDelete) {
        CA_SBQuoteLineItemTriggerHandler.deleteAgreementLineItems(Trigger.old);
        }
    }
}