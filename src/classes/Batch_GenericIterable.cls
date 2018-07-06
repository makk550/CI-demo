global class Batch_GenericIterable implements Database.batchable<Sobject>{ 
   list<Sobject> sobjlist;
      public string failedDML =''; 
    global  List<Active_Contract_Product__c> acplist = new List<Active_Contract_Product__c>();
     global  List<OpportunityLineItem> olilist =new List<OpportunityLineItem>();
      global  List<CA_Product_Renewal__c> rcplist = new List<CA_Product_Renewal__c>();
      global final Id opportunityId;
     global  Opportunity opp = new Opportunity();
    global Batch_GenericIterable(List<Active_Contract_Product__c> acplines,
                          List<OpportunityLineItem> olilines,
                          List<CA_Product_Renewal__c> rcplines, Id oppid)
    {
        //this.sobjlist = accts;
        this.acplist = acplines;
        this.olilist = olilines;
        this.rcplist = rcplines;
        this.opportunityId =oppid;
        System.debug('samap01 Batch_GenericIterable oppid ' +opportunityId);
    }
   global Iterable<Sobject> start(Database.batchableContext info){ 
        System.debug('samap01 Batch_GenericIterable opp ' +opp);
       
          Iterable<SObject> sobjlist = (Iterable<SObject>) new CustomIterable(acplist,olilist,rcplist);
       return  sobjlist; 
   }     
   global void execute(Database.batchableContext info, List<Sobject> scope){ 
      // List<Sobject> accsToUpdate = new List<Sobject>(); 
         try
         {
             if(scope.size() >0)
             {
                update scope; 
                 System.debug('samap01 scope update Batch_GenericIterable');
             }   
            
             else
             {
               failedDML = 'No records to upsert for the line items'  ;
             }
         }
          catch(Exception e){
                  failedDML = failedDML + e.getMessage() +e.getLineNumber() + e.getCause();
                //Database.rollback(sp);
            }
   }     
   global void finish(Database.batchableContext info){     
      try
        {
             opp  = [select Id,Renewal_BatchId__c from opportunity where Id=: opportunityId];
       
      //set the batch number to null after batch finishes
         // opp  = [select Id,Renewal_BatchId__c from opportunity where Id=: ];
             //Renewal_OpportunityUtilityClass.getOpportunitydetails(opportunityId) ;
            SYSTEM.debug('samap01 generatiterablebatch opp'+opp);
         OpportunityHandler.renewalToOppConversion = true;  //setting this to true so that Primary contact validation doesnt fire
       	 opp.Renewal_BatchId__c = null;
      	 update opp;  
     
        }
     
     	catch(DMLexception e)
        {
              for (Integer index = 0; index < e.getNumDml(); index++){
                  failedDML =   '\n' + failedDML + e.getMessage() +e.getLineNumber() + e.getCause();}
            
        }
        finally
        {
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :info.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String currentuseremail= UserInfo.getUserEmail();
        String[] toAddresses = new String[] {currentuseremail};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Schedule Job -- Batch_GenericIterable for Renewal updates ' + a.Status);
        mail.setPlainTextBody
            ('The Batch_GenericIterable for Renewal updates is processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.' +  failedDML);
        // If(a.NumberOfErrors>0)
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   } 
}