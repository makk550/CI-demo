// not required class = to be deleted
public class Renewal_ConvertToOpportunityWithDate {
 /*   public String segmentation {get;set;}
    public Renewal_ConvertToOpportunityWithDate () {
        ac = new Active_Contract__c();
    }
   
    public List<SelectOption> getItems() {
    List<SelectOption> options = new List<SelectOption>();
   // Schema.DescribeFieldResult F = Account.Sales_Area__c.getDescribe();
    //List<Schema.PicklistEntry> P = F.getPicklistValues();
    options.add(new SelectOption('-None-','ALL'));
    //options.add(new SelectOption('LT','LT'));
    options.add(new SelectOption('MT','MT'));
    options.add(new SelectOption('HT','HT'));
    //for(Schema.PicklistEntry pe : P){
    //options.add(new SelectOption(pe.getValue(),pe.getValue()));
    //}    
    return options;
    }
    
  
   public  Active_Contract__c ac{get;set;}
   
   public PageReference Convert()
   {
       Renewal_MassOpportunityConv rc = new Renewal_MassOpportunityConv();
       if(ac.Contract_End_Date__c == null){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Please select start date ');
          ApexPages.addMessage(msg);
       }
       if(ac.Agreement_Acceptance_Date__c == null){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Please select end date ');
          ApexPages.addMessage(msg);
       }   
       String error = rc.Renewal_ConvertRenewalsMain('TimeFrame',ac.Contract_End_Date__c,ac.Agreement_Acceptance_Date__c,segmentation);
  
       if(error.contains('Exception')){  
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'System encountered some error while generating Opportunities.Please contact System Administrator for details');
          ApexPages.addMessage(msg);
  
  return null; }else{
       
  PageReference pageRef = new PageReference('/'+System.Label.OpportunityTab);
        pageRef.setRedirect(true);
        return pageRef;}
   }     
*/

}