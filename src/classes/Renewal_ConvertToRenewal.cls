public class Renewal_ConvertToRenewal {
    public Boolean ShowDataMessage {get;set;}
    public Boolean ShowErrorMessage {get;set;}
    List<Renewal__c> generatedRenewals = new List<Renewal__c> ();
    public String region {get;set;}
    public String error;
    public Boolean batchProcessing {get;set;}
    Set<string> errors = new set<string>();
    
    public Set<String> getErrors (){
         return errors;   
    }
    public List<Renewal__c> getGeneratedRenewals(){
         return generatedRenewals;   
    }
    public Renewal_ConvertToRenewal() {
        ac = new Renewal__c();
        region = '-None-';
        List<AsyncApexJob> jobs = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email, ApexClass.Name , MethodName  from AsyncApexJob  where status in ('Queued','Processing')];
         //system.debug('ApexClassID>>>>' + a.ApexClass.Name);  
         for(AsyncApexJob a : jobs){
             if(a.ApexClass.Name == 'Renewal_BatchGenerateRenewals') {
                 batchProcessing = true;
             }
         }
    }
   
    public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption>();
    Schema.DescribeFieldResult F = Account.GEO__c.getDescribe();
    List<Schema.PicklistEntry> P = F.getPicklistValues();
    options.add(new SelectOption('-None-','ALL'));
    for(Schema.PicklistEntry pe : P){
    options.add(new SelectOption(pe.getValue(),pe.getValue()));
    }    
    return options;
    }
    
  
   public  Renewal__c ac{get;set;}
   
   public PageReference Convert()
   {
       ShowDataMessage = false;
       ShowErrorMessage = false;
       Renewal_ConvertActiveContracts rc = new Renewal_ConvertActiveContracts();
       
       if(ac.ChangeDate__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select start date '));
          return null;
       }
       if(ac.Expected_Close_Date__c == null){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please select end date '));
          return null;
       }
       
       error = rc.Renewal_ConvertActiveContractsMain('TimeFrame',ac.ChangeDate__c,ac.Expected_Close_Date__c,region);

       if(error.contains('No Data')){            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'There are no eligible contract products for the data that you selected. No renewals generated.'));
            return null;
        }
      else if(error.contains('BatchCalled')){
        
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Records are sent for Processing.'));
         return null;
      }
       else if(error.contains('Exception')){  
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'System encountered an error while generating Renewals. Please contact System Administrator for details'));
          return null;
      }else{
          generatedRenewals = rc.generatedRenewals;
          ShowDataMessage = true; 
          ShowErrorMessage  = false;
          System.debug('generatedRenewals### '+generatedRenewals);
          System.debug('ShowDataMessage ### '+ShowDataMessage );
          System.debug('ShowErrorMessage  ### '+ShowErrorMessage  );
        /*PageReference pageRef = new PageReference('/'+System.Label.Renewals_Tab);
        pageRef.setRedirect(true);
        return pageRef;*/
        return null;
        }
   }     
     public PageReference recentRenewals() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        Report report =[Select r.Name,r.Id From Report r where DeveloperName=:'Recently_Created_Renewals'];
        PageReference ref = new PageReference('/'+report.Id);
        return ref;
    }

}