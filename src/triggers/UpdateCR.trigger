trigger UpdateCR on PDD__c (after update) {
//Trigger to udpate customereltionship object with client releaselevl, GA level text, Scale of Adoption for a given product
   
    try
    {
    
    for(PDD__c pdd : trigger.New){
        system.debug(pdd.CustomerRelationship__c);
        //PDD__c existingPDDRec= (PDD__c)Trigger.oldMap.get(pdd.ID);
       if(pdd.CustomerRelationship__c != null ) //&&  pdd.CustomerRelationship__c!= existingPDDRec.CustomerRelationship__c 
       {
           CustomerRelationship__c crToUpdate = [select id from CustomerRelationship__c where id = :pdd.CustomerRelationship__c];
           InstancePDD__c instance  = [select id, GA_level_Text__c from instancepdd__c where id = :pdd.Instance__c];
               
           if(crToUpdate != null && instance != null)
           {
            crToUpdate.GALevelText__c = instance.GA_level_Text__c;
            crToUpdate.Client_Release_Level__c = pdd.Client_Release_Level__c;
            crToUpdate.ScaleOfAdoption__c = pdd.Scale_of_Adoption__c;
             //pdd.CAProduct__c = crToUpdate.CAProduct__c;
            update crToUpdate;
           }
       }
    }
    }
    Catch(Exception ex)
    {
        system.debug(ex.getMessage() + ex.getLineNumber());
    }
 
}