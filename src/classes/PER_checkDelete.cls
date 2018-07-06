public class PER_checkDelete {
 //public ApexPage.standardcontroller stdCtrl;
 Partner_Engagement_Program__c per;
    public Id oppId{get;set;}
       public PER_checkDelete(ApexPages.Standardcontroller std)
   {
      per=(Partner_Engagement_Program__c) std.getRecord();
      //stdCtrl=std;
   }

   public PageReference per_checkDelete()
   {
      //Partner_Engagement_Program__c per=(Partner_Engagement_Program__c) stdctrl.getRecord();
       per =[select id,status__c,Parent_Opportunity__c from Partner_Engagement_Program__c where id=:per.id ];
       oppId = per.Parent_Opportunity__c;
      if (per.Status__c == 'New' || per.Status__c == 'Pending Approval')
      {
          List<opportunity > oppListToReset= new List<opportunity>();
          oppListToReset = [select Partner_Engagement__c,SkipPERValidation__c from opportunity where id=:oppId];
          for(opportunity opp:oppListToReset){
              if(opp.Partner_Engagement__c == 'Pending'){
                  opp.Partner_Engagement__c ='';
                  opp.SkipPERValidation__c = true;
              }
          }
          
          delete per;
          if(oppListToReset.isEmpty() == false) update oppListToReset;
          for(opportunity opp:oppListToReset){
              if(opp.SkipPERValidation__c){
                  
                  opp.SkipPERValidation__c = false;
              }
          }
          update oppListToReset;
          return  new PageReference('/'+oppId);
      }
      else
      {
         return null;
      }
   }

}