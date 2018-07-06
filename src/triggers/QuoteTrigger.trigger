trigger QuoteTrigger on SBQQ__Quote__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    // Lines 5-17 check DisableCustomTriggers custom setting
    // Line 19 called QuoteTriggerHandler where all logic resides
    /*if(Trigger.isAfter&&Trigger.isInsert){
     
       Map<Id,String> oppId=new Map<Id,String>();
 for(SBQQ__Quote__c  sbquote:Trigger.new){
      
      
         
           oppId.put(sbquote.SBQQ__Opportunity2__c,sbquote.SAP_Quote_Status__c);
         
      
      }
      
if(oppId.size()>0){

  List<Opportunity> opplist=[select id,SAP_Quote_Status__c from opportunity where id=:oppId.keySet()];
  
    for(Opportunity opp:opplist){
    System.debug('oppId.get(opp.id)==='+oppId.get(opp.id));
      opp.SAP_Quote_Status__c=oppId.get(opp.id);
    
    
    }
    
    
    update opplist;


}
     
     
     }*/
    
    if(Trigger.isBefore && Trigger.isUpdate){
        for(SBQQ__Quote__c sfcpqQuote :Trigger.new){
            system.debug('--sold to before, before update handler---'+sfcpqQuote.SoldTo_Country__c);
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        for(SBQQ__Quote__c sfcpqQuote :Trigger.new){
            system.debug('--sold to before, after update handler---'+sfcpqQuote.SoldTo_Country__c);
        }
    }
    
    Boolean disableCustomTriggers = false;
    
    try {
        List<DisableCustomTriggers__c> dCTs = DisableCustomTriggers__c.getall().values();
        if ( dCTs[0].Disable_Custom_Triggers__c )
        {
            disableCustomTriggers = true;
        }
    }
    catch (Exception e) {}    
    
    if (!disableCustomTriggers && !checkRecursive.inProcess)
    {
        new QuoteTriggerHandler().run();
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        for(SBQQ__Quote__c sfcpqQuote :Trigger.new){
            system.debug('--sold to after, before update handler---'+sfcpqQuote.SoldTo_Country__c);
        }
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        for(SBQQ__Quote__c sfcpqQuote :Trigger.new){
            system.debug('--sold to after, after update handler---'+sfcpqQuote.SoldTo_Country__c);
        }
    }
}