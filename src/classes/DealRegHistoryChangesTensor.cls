public class DealRegHistoryChangesTensor {
   public static Set<Id> oppIds=new Set<Id>();
   public static Blob bodydata;
    
 public static void dealReghistroyObjSource(opportunity newopp ){
     
     System.debug('====opp=='+newopp);
   Opportunity opp;
  if(newopp!=null && newopp.id!=null && (newopp.Type=='1 Tier'||newopp.Type=='2 Tier'||newopp.Type=='xSP')&&newopp.Salesforce_CPQ_Eligibility_Route__c==true){
     opp=[select id,Deal_Registration_Status__c,Source__c,(select id,IsLatest__c from Deal_Registration_Approved__r where IsLatest__c=true ),New_Opportunity_Status__c,Partner_Engagement__c from Opportunity where id=:newopp.id ];
    if(opp!=null&&(opp.Deal_Registration_Status__c=='Sale Approved'||opp.Deal_Registration_Status__c=='Deal Rejected')&&opp.Source__c=='Deal Registration'){
              
            oppIds.add(opp.id);  
              
     }else if(opp!=null&&(opp.New_Opportunity_Status__c=='New Opportunity Approved'||opp.New_Opportunity_Status__c	=='New Opportunity Rejected')&&opp.Source__c=='Partner'){
              
              oppIds.add(opp.id);  
              
     }else if(opp!=null&&(opp.Partner_Engagement__c=='Collaborative'||opp.Partner_Engagement__c=='Fulfillment-Only')&&(opp.Source__c=='CA Internal'||opp.Source__c=='Lead')){
              
                oppIds.add(opp.id);  
              
     }else if(opp!=null&&opp.Partner_Engagement__c=='Incremental'&&opp.Source__c=='Lead'){
           oppIds.add(opp.id);
         
     }else if(opp!=null&&String.isBlank(opp.Partner_Engagement__c)&&opp.Source__c=='CA Internal'){
             oppIds.add(opp.id) ; 
       }
      
        if(opp!=null && opp.Deal_Registration_Approved__r!=null&&opp.Deal_Registration_Approved__r.size()==0&&oppIds.size()>0){
            dealReghistroyObjSource_Deal_Reg(newopp); 
         
        }

      
    }     
     
 }
    
    
    public static void dealReghistroyObjSource_Deal_Reg(Opportunity newopp){
        
      if(oppIds.size()>0&&newopp!=null){
         bodydata=AttachDealRegCertificate.getCertifiacteBody(newopp);
           Map<Id,List<OpportunityLineItem>> Mapoppline=new Map<id,List<OpportunityLineItem>>();
            for(OpportunityLineItem opl:[select id,Deal_Registration__c,OpportunityId,Product2Id,Business_Type__c,UnitPrice,Term_Month__c from OpportunityLineItem where OpportunityId=:newopp.id ]){
                     List<OpportunityLineItem> lisopp=new List<OpportunityLineItem>();
                     if(!Mapoppline.containsKey(opl.OpportunityId)){
                         lisopp.add(opl);
                         Mapoppline.put(opl.OpportunityId,lisopp);
                     }else{
                         
                          lisopp.add(opl);
                         
                     }
                 
                 
              }
         
         if(Mapoppline.size()>0&&bodydata!=null){
             System.debug('==========Entered Del Reg Map');
            AttachDealRegCertificate.attachPDFtodeaHistory(newopp,bodydata); 
                
         }
        List<DealRegProductHistory__c> Delregproductlist=new List<DealRegProductHistory__c>();  
          System.debug('======');

     for(DealRegistrationApproved__c dlra:[select id,IsLatest__c,Opportunity_Name__c from DealRegistrationApproved__c where Opportunity_Name__c=:newopp.id]){
         if(dlra.IsLatest__c==true){
             List<OpportunityLineItem> listIteam=new List<OpportunityLineItem>();  

           listIteam.addAll(Mapoppline.get(dlra.Opportunity_Name__c));
             
              for(OpportunityLineItem opl:listIteam){
                   DealRegProductHistory__c drprodhistory= new DealRegProductHistory__c();
                        drprodhistory.DealRegistrationApprovedHistory__c=dlra.id;
                        drprodhistory.Product__c=opl.Product2Id;
                        drprodhistory.Operation__c='Added';
                        drprodhistory.Business_Type__c=opl.Business_Type__c;
                        drprodhistory.Sales_Price__c=opl.UnitPrice;
                        drprodhistory.Term__c=opl.Term_Month__c;
                        Delregproductlist.add(drprodhistory);
             
                 }   
         
           }  
         
       }
          if(Delregproductlist.size()>0){
              
             insert Delregproductlist;              
          }      
     }
        
  }   
    
  
}