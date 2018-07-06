trigger ProcessReleaseOrder on Release_Order__c (before update)
{
    TriggerFactory.createHandler(Release_Order__c.sObjectType);
}