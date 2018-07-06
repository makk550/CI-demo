public with sharing class  EXT_RFP_OppLineItem 
{
   public class OppLineItm
  {
    public String Id {get; set;}
    public String productName {get; set;}
    public String busUnit {get; set;}
    public String productFamily {get; set;}
  }
   public List<OppLineItm>lst_opli{get;set;}
   public List<String>lst_opp_Busunit{get;set;}
   
   
   private final RFP__c rfp;
   private RFP__c rfpOpp;
   
   List<OpportunityLineItem> lst_oppli = new List<OpportunityLineItem>();
   
   public EXT_RFP_OppLineItem(ApexPages.StandardController stdController)
   {
        rfp = (RFP__c)stdController.getRecord();
        fetchSetRFPLinkedOppLineItems();
   }
   public void fetchSetRFPLinkedOppLineItems()
   {
      lst_opli = new List<OppLineItm>();
      lst_opp_Busunit = new List<String>();
      rfpOpp = [Select Opportunity__r.Id,Opportunity__r.Business_Unit__c from RFP__c where Id =: rfp.Id];
      String s_busUnits = rfpOpp .Opportunity__r.Business_Unit__c;
       String[] busUnits = null;
      if(s_busUnits!=null)
      {
        busUnits = s_busUnits.split(';',0);
      }  
      if (busUnits != null && busUnits .size() > 0)
      {
          for(Integer s=0;s<busUnits .size();s++)
          {
             lst_opp_Busunit.add(busUnits[s]);
          }
      }
      /**Schema.DescribeFieldResult F = rfp.Opportunity__r.Business_Unit__c;
      List<Schema.PicklistEntry> P = F.getPicklistValues();
      for(Schema.PicklistEntry pe:P)
      {    
          lst_opp_Busunit.add(pe.getValue());
      }*/
      
      lst_oppli = [Select Id,Business_Unit__c,PricebookEntry.Product2.name,PricebookEntry.Product2.Family from OpportunityLineItem where OpportunityId = :rfpOpp.Opportunity__r.Id];
      System.debug('================Opli '+lst_oppli.size());
      if(lst_oppli.size()>0)
      {
          
           OppLineItm opli = null;
           for(Integer k=0;k<lst_oppli.size();k++)
           {
 
              opli = new OppLineItm();
              opli.Id = lst_oppli[k].Id;
              opli.productName = lst_oppli[k].PricebookEntry.Product2.name;
              opli.busUnit = lst_oppli[k].Business_Unit__c;
              opli.productFamily = lst_oppli[k].PricebookEntry.Product2.Family;
              lst_opli.add(opli);
           }           
      }
   }
   
   
}