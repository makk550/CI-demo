/*************************************************************************\
       @ Author             : Sandeep Reddy D.S
       @ Date               : 04/08/14
       @ Test File   : 
       @ Description : This trigger is to set SFDC_Support_System_c to True 
                         if there are already exsiting compoenets with same component code. 

       any of a component was set then ALL releases should be set.              

@ Audit Trial : Repeating block for each change to the code
       @ Last Modified By   :     
       @ Last Modified On   :      
       @ Last Modified Reason     :   

 ****************************************************************************/

trigger UpdateSFDCSupportSystem on Component_Release__c (after insert) {

    Set<string> compCodes = new Set<string>();
    Set<string> compCodesTobeUpdated = new Set<string>();

    for(Component_Release__c comRel:Trigger.new){   
        if(comRel.Component_Code__c!=null)                   
            compCodes.add(comRel.Component_Code__c);              
    }

    if(compCodes!=null && compCodes.size()>0){
        List<Component_Release__c> compReleses = [Select Id,Component_Code__c,SFDC_Support_System__c from Component_Release__c where 
                                                  Component_Code__c in : compCodes and SFDC_Support_System__c=True];
        if(compReleses!=null && compReleses.size()>0){                                       
            for(Component_Release__c compRel:compReleses){
                compCodesTobeUpdated.add(compRel.Component_Code__c);
            }
        }                                        
    }

    if(compCodesTobeUpdated!=null && compCodesTobeUpdated.size()>0){

        List<Component_Release__c> compRelToBeUpdatedLst = [Select Id,Component_Code__c,SFDC_Support_System__c from Component_Release__c where 
                                                         Component_Code__c in : compCodes and SFDC_Support_System__c=False];

        if(compRelToBeUpdatedLst!=null && compRelToBeUpdatedLst.size()>0){                                       
            for(Component_Release__c compRel:compRelToBeUpdatedLst){
                compRel.SFDC_Support_System__c=True;
            }    
            Update compRelToBeUpdatedLst;
        }
    }

}