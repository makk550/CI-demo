public class apexJobStatusACLI{
ApexPages.StandardController sc = null;

public Opportunity OppRecord ;
public Integer percentComplete{get; set;} 

    public apexJobStatusACLI(ApexPages.StandardController controller) {
         this.sc = sc;
        NumberOfErrors =0;
       
    }

    public list<AsyncApexJob> batchJobs;
    public Id jobId;
    public Id OppId;
    
    public string OppName{get; set;}
    public integer NumberOfErrors{get; set;}
    public string  acptype;
    public string BatchId ;
   	public  String theUrl;
    public PageReference RedirectPage()
    {
      
       OppId  = ApexPages.currentPage().getParameters().get('Id');
        acptype  = ApexPages.currentPage().getParameters().get('rtype');
      system.debug('OppId   --> ' + OppId   );
        OppRecord = [Select id,name,Attach_Contracts_Batch_Id__c,Detach_Contracts_Batch_Id__c,Renewal_BatchId__c
                     from Opportunity where id =: OppId];
              
        if(OppRecord != null)
           OppName = OppRecord.name;
   
      String theUrl = '/' + OppId  ;
      if(acptype == 'Attach')
      {
          System.debug('samap01- call from attach contracts');
          theUrl     = '/apex/Renewal_AddOppProduct?id='+OppId;
          BatchId = OppRecord.Attach_Contracts_Batch_Id__c ;
      }
        else if(acptype== 'licensetype')
        {
          System.debug('samap01- call from attach contracts');
          theUrl     = '/apex/Renewal_editOppProduct?id='+OppId;
          BatchId = OppRecord.Renewal_BatchId__c ;
     	 }
     else
        {
              System.debug('samap01- call from detach contracts');
             theUrl     = '/apex/Renewal_DetachContracts?id='+OppId;
             BatchId = OppRecord.Detach_Contracts_Batch_Id__c ;
        }
 

        if(BatchId == null || BatchId == '')
        {    
              System.debug('samap01- batchid null');
            return new ApexPages.PageReference(theUrl).SetRedirect(true);   
        }
        else
        {          
          jobId =  Id.valueOf(BatchId);                                   
           return null;
        }     
    }
   
    public list<AsyncApexJob> getBatchJobs(){
        //Create new list of BatchJobs, a wrapper class that includes the job and percent complete.
   list<AsyncApexJob> batchJobs = new list<AsyncApexJob>();
  system.debug('OppRecord.Attach_Contracts_Batch_Id__c' + OppRecord.Attach_Contracts_Batch_Id__c + '--'+ BatchId);
        if(BatchId != null )
           
        {
           
          batchJobs=[select TotalJobItems, Status, NumberOfErrors, MethodName, JobType, JobItemsProcessed, Id, CreatedDate, CreatedById, CompletedDate, ApexClassId, ApexClass.Name,ExtendedStatus From AsyncApexJob where Id =: jobId order by CreatedDate desc];                         
            
            system.debug('batch job ' + batchJobs);
             if ( batchJobs.size() > 0)
            {
            
            system.debug('not empty ');
           NumberOfErrors = batchJobs[0].NumberOfErrors;
           system.debug('NumberOfErrors' + NumberOfErrors);
          if(batchJobs[0].TotalJobItems == 0){
                //A little check here as we don't want to divide by 0.
                percentComplete = 0;
            }else{
                percentComplete = ((batchJobs[0].JobItemsProcessed/ batchJobs[0].TotalJobItems) * 100.0).intValue();
            }          
            

          return  batchJobs;
          
          system.debug('batchjobs'+batchjobs);
        }
        else
        {
          return null;
        }
    }
        return null;
    }
    
}