/******************************************************************
 Name : SpecialConditiontrigger 
 Created By : Anil Kumar (alcan02@ca.com)
 Created Date : June 20, 2016
 Description : Class that implements trigger functionality for
 Special Condition History
********************************************************************/
trigger specialConditiontrigger on Special_Conditions__c (before delete,before update) {

    SpecialConTriggerHandler specHandler = new SpecialConTriggerHandler();
    
    if (Trigger.isDelete) {
         specHandler.onBeforeDelete(Trigger.old);
     }
     
     if(Trigger.isUpdate){
         specHandler.onBeforeupdate(Trigger.new,Trigger.oldMap);
     }
     

}