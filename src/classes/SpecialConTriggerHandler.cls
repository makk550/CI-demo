/******************************************************************
 Name : SpecialConTriggerHandler
 Created By : Anil Kumar (alcan02@ca.com)
 Created Date : June 20, 2016
 Description : Implements the functionality for the Special Condition
 History tracking trigger for before delete and before update.
********************************************************************/
public class SpecialConTriggerHandler{

    Special_Conditions_History__c schObj;
    List<Special_Conditions_History__c> lstSpecCondition;

    
    
    // Delete history tracking when records are deleted from special condtion
    public void onBeforeDelete(List<Special_Conditions__c> oldRecords){
        
        lstSpecCondition = new List<Special_Conditions_History__c>();
        
        for(Special_Conditions__c specCond :oldRecords){
        
             schObj = new Special_Conditions_History__c();
             schObj.Site_Association__c = specCond.Site_Association__c ;
             schObj.User__c = userInfo.getUserId();
             schObj.Date__c = DateTime.Now();
             schObj.Action__c ='Record Deleted ';
             schObj.Special_Condition_Name__c= specCond.SPC_Description__c;
             schObj.Start_Date__c = specCond.Start_Date__c;
             schObj.End_Date__c = specCond.End_Date__c ;
             lstSpecCondition.add(schObj);
         }
         
         if(lstSpecCondition.size()>0){
            insert lstSpecCondition;
         }
    }
    
    // update field history tracking when records are updated from special condtion
    public void onBeforeupdate(List<Special_Conditions__c> newRecords,Map<id,Special_Conditions__c> oldRecordMap ){
    
         DescribeSObjectResult oSomeObjectSchema = Schema.SObjectType.Special_Conditions__c ;
         Map<string, Schema.SObjectField> mapFields = oSomeObjectSchema.fields.getMap();
        
         lstSpecCondition = new List<Special_Conditions_History__c>();
         
         for(Special_Conditions__c newSPL: newRecords){
             
             Special_Conditions__c oldSPL = oldRecordMap.get(newSPL.Id);
             
             for (String str : mapFields.keyset()) 
             { 
                 
                try 
                { 
                    if(newSPL.get(str) != oldSPL.get(str) && str !='SPC_Description__c')
                    {
                        Schema.SObjectField field = mapFields.get(str);
                        Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                        
                        schObj = new Special_Conditions_History__c();
                        schObj.Action__c = 'Changed '+fieldDescribe.getLabel() +' from '+oldSPL.get(str)+' to '+newSPL.get(str)+'.';
                        schObj.Site_Association__c = oldSPL.Site_Association__c ;
                        schObj.User__c = userInfo.getUserId();
                        schObj.Date__c = DateTime.Now();
                        schObj.Special_Condition_Name__c= newSPL.SPC_Description__c;
                        schObj.Start_Date__c = oldSPL.Start_Date__c;
                        schObj.End_Date__c = oldSPL.End_Date__c !=null ? oldSPL.End_Date__c :newSPL.End_Date__c ;
                        
                        lstSpecCondition.add(schObj);
                         
                    } 
                } 
                catch (Exception e) 
                { 
                    System.Debug('Error: ' + e); 
                } 
             }
          }
          
          if(lstSpecCondition.size()>0){
            insert lstSpecCondition;
         }
    }
    
    
    

}