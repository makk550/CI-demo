/**
 * Class ReleaseOrderHandler
 *
 * Trigger Handler for the Release_Order__c SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */

public without sharing class ReleaseOrderHandler implements ITrigger
{
    private Map<Id, Release_Order__c> eduReqReleaseOrders;
    private List<Education_Request__c> EDU_Requests = new List<Education_Request__c>();

    // Constructor
    public ReleaseOrderHandler()
    {
    }
    
     /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {
        if(Trigger.isUpdate)
            eduReqReleaseOrders = ReleaseOrderGateway.getEduReqReleaseOrders((Map<Id, Release_Order__c>)Trigger.newMap, (Map<Id, Release_Order__c>)Trigger.oldMap);
    }
    
    public void bulkAfter()
    {
    }
    
    public void beforeInsert(SObject so)
    {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        if(eduReqReleaseOrders.containsKey(so.Id))
        {
            Release_Order__c ro = eduReqReleaseOrders.get(so.Id);
            ro.SAP_Order_Status__c = (String)so.get('SAP_Order_Status__c');
            EDU_Requests.addAll(ReleaseOrderGateway.educationRequestsFor(ro));
        }
    }
    
     /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
    public void beforeDelete(SObject so)
    {
    }
    
    public void afterInsert(SObject so)
    {
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }

    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        upsert EDU_Requests;
    }
}