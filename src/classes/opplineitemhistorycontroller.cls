public class opplineitemhistorycontroller{
    public id oppid{get;set;}
    public opplineitemhistorycontroller(ApexPages.StandardController controller) {
     delapprlist= new list<DealRegistrationApproved__c>();
     oppid= ApexPages.CurrentPage().getParameters().get('id');
  delapprlist=[select id,name,IsLatest__c,AttachmentID__c,Opportunity_Name__c,CreatedDate,(select id,Product__c,Operation__c from Deal_Reg_Product_History__r Order By CreatedDate ) from DealRegistrationApproved__c where   Opportunity_Name__c=:oppid Order By CreatedDate Desc];



    }


  public List<DealRegistrationApproved__c> delapprlist{set;get;}
  
  
  
  
  
  }