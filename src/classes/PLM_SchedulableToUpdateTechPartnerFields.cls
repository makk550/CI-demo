/**
Class Name: PLM_SchedulableToUpdateTechPartnerFields

Project/Requirement: CA PRM Phase 2/PLM 

Author: Accenture

Description: This is a sceduled class to generate the query for the batch class which runs the given query 
and updates fields on Tech partner account on Technology parnte effective date.
*/
global class PLM_SchedulableToUpdateTechPartnerFields implements schedulable{

    global void execute (SchedulableContext sContext){
        PLM_SchedulableToUpdateTechPartnerFields.updateTechPartnerFields();
    }
    
    webservice static void updateTechPartnerFields(){
        
        //Create Query for the Batch class to reset the fields on Tech partner account.
        PLM_BatchToUpdateTechPartnerFields updateAccs=new PLM_BatchToUpdateTechPartnerFields();
        String IdVar='\''+SystemIdUtility.getTechPartnerRecordTypeId()+'\'';
        
        updateAccs.query='select id,'+
                    +'Customer_Category__c,'+
                    +'Number_of_Integrated_Solution_References__c,'+
                    +'Technology_Partner_Effective_Date__c,'+
                    +'Number_of_Customer_Success_Stories__c'+
                    +' from Account where RecordTypeId='+IdVar;
        //setting batch size of 100  
        ID batchprocessid = Database.executeBatch(updateAccs,1);
    }
}