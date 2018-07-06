public class Renewals_FutureUpdate
{
    @future
    public static void UpdateRPinFuture(set<string> updatedRenewalIds)
    {
         List <Renewal_Product__c> lstUpdate = new List<Renewal_Product__c>();
         
        for(Renewal_Product__c[] rpBulk: [SELECT Id, Projected_Renewal_LC__c, 
                                            Is_Update_From_Renewal__c 
                                      FROM Renewal_Product__c
                                      WHERE Renewal__c IN: updatedRenewalIds]){
        for(Renewal_Product__c listToUpdate:rpBulk){
           listToUpdate.Is_Update_From_Renewal__c = true;
           lstUpdate.add(listToUpdate);
        }
        }
        
        update lstUpdate;
    
    }
    @isTest(SeeAllData=true)
    public static void Renewals_FutureUpdate_test() {
        //Renewal_Product__c renProd = [Select Renewal__c from Renewal_Product__c where Renewal__c != null LIMIT 1];
        Renewal__c ren = new Renewal__c(name = 'Renewal Test');
        insert ren;
        Set<String> renIds = new Set<String>();
        renIds.add(ren.id);
        Renewals_FutureUpdate.UpdateRPinFuture(renIds);
    } 

}