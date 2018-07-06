/**
    This trigger updates the related Renewal Products when a Renewal is updated
    and the Projected Renewal value is changed at Renewal level.
*/

trigger Renewals_UpdateProRenOnRP on Renewal__c (before update) {
    
    if(Renewals_Util.fromAfterTrigger)return;
    if(Renewals_Util.fromRenewals_RollupRPToRenewal)return;
    Renewals_Util.fromAfterTrigger = true;
    Set<String> updatedRenewalIds = new Set<String>();
    for(Integer i=0;i<Trigger.new.size();i++){
        if(Trigger.old[i].Projected_Renewal__c != Trigger.new[i].Projected_Renewal__c){
            Trigger.new[i].Is_Projected_Renewal_Changed__c = true;
            updatedRenewalIds.add(Trigger.new[i].Id);
        }
    }
    
   List <Renewal_Product__c> lstUpdate = new List<Renewal_Product__c>();
     
    for(Renewal_Product__c[] rpBulk: [SELECT Id, Projected_Renewal_LC__c, 
                                            Is_Update_From_Renewal__c 
                                      FROM Renewal_Product__c
                                      WHERE Renewal__c IN: updatedRenewalIds]){
        for(Renewal_Product__c listToUpdate:rpBulk){
           listToUpdate.Is_Update_From_Renewal__c = true;
           lstUpdate.add(listToUpdate);
        }
      //  update rpBulk;
    }
    if(lstUpdate.size() > 0)
    {    if(lstUpdate.size() < =100)
            update lstUpdate;
         else
             Renewals_FutureUpdate.UpdateRPinFuture(updatedRenewalIds);
                
     }
}