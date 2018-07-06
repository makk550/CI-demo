/**
 * Class ReleaseOrderLineHandler
 *
 * Trigger Handler for the Release_Order_Line_Item__c SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */

public without sharing class ReleaseOrderLineHandler implements ITrigger
{
    Map<String, Id> productCodeToMaterialIdMap = new Map<String, Id>();

    // Constructor
    public ReleaseOrderLineHandler()
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
        if(Trigger.isInsert)
            productCodeToMaterialIdMap = ReleaseOrderLineGateway.getCodeToMaterialMap( (List<Release_Order_Line_Item__c>) Trigger.new);
        else if(Trigger.isUpdate)
            productCodeToMaterialIdMap = ReleaseOrderLineGateway.getCodeToMaterialMap( (List<Release_Order_Line_Item__c>) Trigger.new, (List<Release_Order_Line_Item__c>) Trigger.old);
    }
    
    public void bulkAfter()
    {
    }
    
    public void beforeInsert(SObject so)
    {
        ReleaseOrderLineGateway.updateMaterialOnRol( (Release_Order_Line_Item__c) so, productCodeToMaterialIdMap);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        ReleaseOrderLineGateway.updateMaterialOnRol( (Release_Order_Line_Item__c) so, productCodeToMaterialIdMap);
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
        
    }
}