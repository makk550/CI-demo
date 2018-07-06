trigger AccreditationProductMaterial on Accreditation__c (before update, before insert)
{
    Set<String> courseNumbers = new Set<String>();
    List<Accreditation__c> accredsToUpdate = new List<Accreditation__c>();
    
    for(Accreditation__c accred : Trigger.New)
    {
        if( (Trigger.isInsert || Trigger.oldMap.get(accred.Id).Course_Number__c != accred.Course_Number__c) && accred.Course_Number__c != null && accred.Course_Number__c != '' )
        {
            courseNumbers.add(accred.Course_Number__c);
            accredsToUpdate.add(accred);
        }
    }
    
    if(!courseNumbers.isEmpty())
    {
        Map<String, Product_Material__c> courseNumberToPM = new Map<String, Product_Material__c>();
        for(Product_Material__c pm : [SELECT Name, Material_Text__c, Product__r.CSU2__c, Product__r.Product_Group__c FROM Product_Material__c WHERE Name IN :courseNumbers])
            courseNumberToPM.put(pm.Name, pm);
        
        for(Accreditation__c accred : accredsToUpdate)
        {
            Product_Material__c pm = courseNumberToPM.get(accred.Course_Number__c);
            
            if(pm == null)
            {
                accred.Product__c = null;
                accred.Product_Material__c = null;
                accred.CSU2__c = null;
                accred.Product_Group_MPL__c = null;
            }
            else 
            {
                accred.Product__c = pm.Material_Text__c;
                accred.Product_Material__c = pm.Id;
                accred.CSU2__c = pm.Product__r.CSU2__c;
                accred.Product_Group_MPL__c = pm.Product__r.Product_Group__c;
            }
            
        }
    }
}