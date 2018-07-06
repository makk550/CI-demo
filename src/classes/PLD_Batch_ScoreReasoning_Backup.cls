//Partner Lead Distribution  
//Author: AMILI01
global class PLD_Batch_ScoreReasoning_Backup implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<Lead> start(Database.BatchableContext BC){
        
       list<lead> LeadList=[select id,EAID__c,Commercial_Account__r.Region_Country__c,mkto71_Lead_Score__c,Commercial_Account__r.Sales_Area__c,Commercial_Account__r.GEO__c,Commercial_Account__r.Sales_Region__c,CSU_Driver__c from Lead 
                  where Segment1__c!=Null 
                   and CSU_Driver__c != NULL 
                  and Commercial_Account__r.Region_Country__c!= null 
                  and mkto71_Lead_Score__c!=null and Commercial_Account__r.Sales_Area__c!=null 
                  and Commercial_Account__r.GEO__c != null and Commercial_Account__r.Sales_Region__c !=null 
                  and OwnerId IN (select Id from Group where Type = 'Queue' AND Name = 'Partner Lead Distribution' )
                   ];
        
System.debug('----LeadList---'+LeadList.size());
        
       return LeadList;

    }

    global void execute(Database.BatchableContext bc, List<Lead> scope){
        
         System.debug('in execute method :');
        
        if( scope!= NULL &&  scope.size()>0){
            
            //Invoking the PartnerLeadDistribution_Utility 
           PartnerLeadDistribution_Utility PLD=new PartnerLeadDistribution_Utility(scope);
            
                     
            //Stamping Batch processed true on the lead i.e.,  PartnerBatchProcessed__c =true 
            for(Lead ld:scope ){
                ld.PartnerBatchProcessed__c=true;
            }
            
            //commenting the DML for soft deploy
          update scope;
        }
    }
        
     global void finish(Database.BatchableContext BC) {
        
         AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email    
                           from AsyncApexJob where Id =:BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'amili01@ca.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('PartnerLeadDistribution Batch Status' + a.Status);
        mail.setPlainTextBody('Records processed ' + a.TotalJobItems +   'with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

         
     }
}