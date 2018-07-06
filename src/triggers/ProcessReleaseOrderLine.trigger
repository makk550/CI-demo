trigger ProcessReleaseOrderLine on Release_Order_Line_Item__c (before insert, before update)
{
    TriggerFactory.createHandler(Release_Order_Line_Item__c.sObjectType);

    /*
    List<Release_Order_Line_Item__c> rolToUpdate;
    
    if(Trigger.isInsert)
    {
        rolToUpdate = Trigger.New;
    }
    else
    {
        rolToUpdate = new List<Release_Order_Line_Item__c>();
        
        for(Release_Order_Line_Item__c rol : Trigger.New)
            if(rol.Product_Code__c!=null && Trigger.oldMap.get(rol.Id).Product_Code__c!=rol.Product_Code__c)
                rolToUpdate.add(rol);
    }
    
    if(!rolToUpdate.isEmpty())
    {
        Set<String> pCodes = new Set<String>();
        for(Release_Order_Line_Item__c rol : rolToUpdate)
            pCodes.add(rol.Product_Code__c);
        
        
        Map<String, Id> codeToMaterial = new Map<String, Id>();   
        for(Product_Material__c pm : [SELECT Id, Name FROM Product_Material__c WHERE Name In :pCodes])
            codeToMaterial.put(pm.Name, pm.Id);
            
        for(Release_Order_Line_Item__c rol : rolToUpdate)
            rol.Product_Material__c = codeToMaterial.get(rol.Product_Code__c);
    }
    */
}