/************************************************************************************************
 * Created For :  US423678 - XXXL Renewals
 * Created By 	:	SAMAP01
 * Created Date : Nov 16th 2017
 * ***********************************************************************************************/
global class Batch_RenewalDetachContracts implements Database.Batchable<sObject> ,Database.Stateful  {
    
    List<OpportunityLineItem> olilist = new List<OpportunityLineItem>();
    public string failedDML ='';
    public Set<Id> aclids = new Set<id>();
    public set<id> acpIds = new Set<id>();
    global final Set<id> prodids ;
   //  public  Set<id> acpids ;
       global final Id oppId;
     global  Opportunity opp = new Opportunity();
    //Variable to count Success and Error Records
    public Integer successCounter = 0;
    public Integer failureCounter = 0;    
    public Set<Id> oliDelOppIds = new Set<Id>();
    global Batch_RenewalDetachContracts(Set<id> acpprodids,Id opportunityId)
    {
        prodids =acpprodids;
        oppId =opportunityId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
           opp = [Select o.Name,o.Id,o.Account.Name,o.CurrencyIsoCode, o.AccountId,CloseDate,StageName,o.Start_Date__c,o.End_Date__c,Detach_Contracts_Batch_Id__c 
               From Opportunity o where o.Id =: oppId];
         acpids =prodids;
        return database.getQueryLocator([Select Id,Active_Contract_Line_Item__c,Active_Contract_Product__c,OpportunityId from OpportunityLineItem where  Active_Contract_Product__c in : prodIds ]);
    }
    
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope)
    {
        integer olicount = 0;
       // List<Active_Contract_Product__c> acpList = new List<Active_Contract_Product__c>();
        if(scope !=null && scope.size()>0)
        {
            olicount=scope.size() ;
            olilist = scope;
            //get details of the  Acli Ids, ACP id and Opportunity Ids
            for(OpportunityLineItem oli : olilist )
            {
                if(!aclids.contains(oli.Active_Contract_Line_Item__c))
                aclids.add(oli.Active_Contract_Line_Item__c);
                //  if(!acpIds.contains(oli.Active_Contract_Product__c))
                //  acpIds.add(oli.Active_Contract_Product__c);
                  if(!oliDelOppIds.contains(oli.OpportunityId))
                oliDelOppIds.add(oli.OpportunityId);
            }
            //delete olilist;
            //Savepoint sp = Database.setSavepoint();
            try{
                delete olilist;
                 System.debug('samap01 -detach oli'+olilist );
                            List<Active_Contract_Line_Item__c> acllist = [Select Id,Opportunity_Product__c from Active_Contract_Line_Item__c where  Contract_Product__c in : acpids ] ;
                            if(acllist.size()>0)
                            {
                                for( Active_Contract_Line_Item__c  acli : acllist)
                                {
                                    acli.Opportunity_Product__c='';
                                    
                                }
                                
                                update acllist;
                                System.debug('samap01 -acllist updated '+acllist);
                            }
                            if(olilist.size()>0 && prodIds.size()>0)
                            {
                                List<CA_Product_Renewal__c> prodRenewalList = [Select id,name from CA_Product_Renewal__c where Active_Contract_Product__c
                                                                               IN :prodIds and Renewal_Opportunity__c =:opp.Id];
                                if(prodRenewalList.size()>0) 
                                    delete prodRenewalList;
                                System.debug('samap01 -prodRenewalList delete '+prodRenewalList);
                            }
                            
                            //update acp
                            
                            //  Set<Id> acpIds = new Set<Id>();
                            
                            List<Active_Contract_Product__c> acpList = new List<Active_Contract_Product__c>();
                            for(Id acpId : prodIds){                       
                                acpList.add(new Active_Contract_Product__c(id=acpId,Opportunity_Product__c = null,Opportunity__c = null,Renewal_Contract_Product__c = null,Converted_to_Opportunity__c = false));
                                //   acpIds.add(acpId);                      
                            }
                            
                            System.debug('samap01 the acp is updated: ' + acpList);      
                            update acpList;   
                     
                /*
                if(aclids.size()>0)
                {
                    List<Active_Contract_Line_Item__c> acllist = [Select Id,Opportunity_Product__c from Active_Contract_Line_Item__c where  Id in : aclids ] ;
                    if(acllist.size()>0)
                    {
                        for( Active_Contract_Line_Item__c  acli : acllist)
                        {
                            acli.Opportunity_Product__c='';
                        }
                        
                        update acllist;
                        System.debug('samap01 - acl updated');
                    }
                    
                    
                }
                 for(Id acpId : acpIds){
                
                    acpList.add(new Active_Contract_Product__c(id=acpId,Opportunity_Product__c = null,Opportunity__c = null,Renewal_Contract_Product__c = null,Converted_to_Opportunity__c = false));
                    acpIds.add(acpId);
                     System.debug('samap01- acp created');
              
            }
            if(olilist.size()>0 && acpIds.size()>0){
                List<CA_Product_Renewal__c> prodRenewalList = [Select id,name from CA_Product_Renewal__c where Active_Contract_Product__c IN :acpIds and Renewal_Opportunity__c IN :oliDelOppIds];
                if(prodRenewalList.size()>0) 
                    delete prodRenewalList;
                System.debug('deleted  prodRenewalList'+ prodRenewalList);
            }
           //  System.debug(LoggingLevel.ERROR, 'samap01 8 Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());      
            update acpList;
               */ 
            }
            catch(Exception e){
                  failedDML = failedDML + e.getMessage() +e.getLineNumber() + e.getCause();
                //Database.rollback(sp);
            }
            
        }
        
    }
    
    //Finish method to execute at last.
    global void finish(Database.BatchableContext BC) {
        
         //set the batch number to null after batch finishes
        OpportunityHandler.renewalToOppConversion = true; //setting this value as we dont want primary contact validation to fire
        opp.Detach_Contracts_Batch_Id__c = null;
        update opp;
        
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String currentuseremail= UserInfo.getUserEmail();
        String[] toAddresses = new String[] {currentuseremail};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Schedule Job- Attach contract ' + a.Status);
        mail.setHtmlBody('<html><body>Hi ' +UserInfo.getFirstName() + ' <br><br>The Detach contract processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.<br><br>' +  failedDML);
        // If(a.NumberOfErrors>0)
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}