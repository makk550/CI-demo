/**
 * Class ReleaseOrderLineGateway
 *
 * Provides finder methods for accessing data in the Release_Order_Line_Item__c object.
 */
public without sharing class ReleaseOrderLineGateway
{   
    public static Map<String, Id> getCodeToMaterialMap(List<Release_Order_Line_Item__c> rNew, List<Release_Order_Line_Item__c> rOld)
    {
        Set<String> productCodes = new Set<String>();
        
        for(Integer i=0; i < rNew.size(); i++)
            if(rNew[i].Product_Code__c !=null && rOld[i].Product_Code__c != rNew[i].Product_Code__c)
                productCodes.add(rNew[i].Product_Code__c);
                
        Map<String, Id> codeToMaterialMap = new Map<String, Id>();
        if(!productCodes.isEmpty())
        {
            for(Product_Material__c pm : [SELECT Name FROM Product_Material__c WHERE Name In :productCodes])
                codeToMaterialMap.put(pm.Name, pm.Id);
        }
        
        return codeToMaterialMap;
    }
    
    public static Map<String, Id> getCodeToMaterialMap(List<Release_Order_Line_Item__c> rNew)
    {
        Set<String> productCodes = new Set<String>();
        
        for(Release_Order_Line_Item__c rol : rNew)
            productCodes.add(rol.Product_Code__c);
                
        Map<String, Id> codeToMaterialMap = new Map<String, Id>();
        if(!productCodes.isEmpty())
        {
            for(Product_Material__c pm : [SELECT Name FROM Product_Material__c WHERE Name In :productCodes])
                codeToMaterialMap.put(pm.Name, pm.Id);
        }
        
        return codeToMaterialMap;
    }
    
    public static void updateMaterialOnRol(Release_Order_Line_Item__c rol, Map<String, Id> codeToMaterialMap)
    {
        if(rol.Product_Code__c != null && codeToMaterialMap.containsKey(rol.Product_Code__c))
            rol.Product_Material__c = codeToMaterialMap.get(rol.Product_Code__c);
        else
            rol.Product_Material__c = null;
    }
}