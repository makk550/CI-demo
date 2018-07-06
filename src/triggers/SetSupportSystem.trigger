/*************************************************************************\
       @ Author             : Sandeep Reddy D.S
       @ Date               : 17/04/14
       @ Test File   : 
       @ Description : This trigger is to  set SFDC_Support_System_c to True if the component release 
                                     is related to at least one product material record that has a CA Product Controller.
                       If any release of a component was set then ALL releases should be set.              
       
@ Audit Trial : Repeating block for each change to the code
       @ Last Modified By   :     
       @ Last Modified On   :      
       @ Last Modified Reason     :   
          
 @Last Modified on 17/04/14 by sandeep to set SFDC_Support_System_c

****************************************************************************/
trigger SetSupportSystem on Product_Release_Component_Release__c (after Insert,after Update) {

 Set<String> compCodes = new Set<String>();
 
 for(Product_Release_Component_Release__c PrdRelComRel:Trigger.new){
     if(PrdRelComRel.SFDC_Support_System__c)
        compCodes.add(PrdRelComRel.Component_Code__c) ;
 
 }


if(compCodes!=null && compCodes.size()>0){
  
  List<Component_Release__c> compRelLst = [select Id,SFDC_Support_System__c from Component_Release__c where SFDC_Support_System__c !=true and Component_Code__c in:compCodes];

  if(compRelLst!=null && compRelLst.size()>0){
     for(Component_Release__c compRel :compRelLst){
         compRel.SFDC_Support_System__c =true;
     }     
     update compRelLst;
  }
}


}