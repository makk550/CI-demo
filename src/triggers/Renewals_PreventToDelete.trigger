/**        Trigger Name: Renewals_PreventToDelete      
           Object Name : Renewal__c 
           Event : Before Delete
           Number of SOQLs : 0  
           Author: Accenture 
           Last Modified: Pankaj Kumar Pandey, 09/27/10
           comments: trigger is used to prevent the renewals to delete.
*/
trigger Renewals_PreventToDelete on Renewal__c (before delete) {
    Map<Id,Renewal__c> lstRen = new Map<Id,Renewal__c>([Select Id, 
                          (Select Name From Renewal_Products__r), 
                          (Select Name From Renewals_Product_Contracts__r)
                        From Renewal__c  
                        where id in:Trigger.old]); 
    for(Renewal__c renw:Trigger.old){
     Renewal__c renwl = lstRen.get(renw.Id);                     
     if(!((renwl.Renewal_Products__r).isempty()) || !((renwl.Renewals_Product_Contracts__r).isempty())){
       renw.addError('This Renewal cannot be deleted because there are Products or Contracts attached.');    
     }
   }
}