/*************************************************************************\
@ Author             : 
@ Date               : 23/04/14
@ Test File   : 
@ Description : 

@ Audit Trial : Repeating block for each change to the code
@ Last Modified By   :      
@ Last Modified On   :     
@ Last Modified Reason     : Code review comments incorporation  

@Last Modified on **** by *** to change ***

****************************************************************************/
trigger ProcessCase on Case (before insert, before update,after insert, after update) {
    
    if(userinfo.getName()=='supporteaiintegration2Cleanup')
        return;
    if(FutureMethod_Assign_support_Generic.isFutureRunning)
        return;
    //if(SystemIdUtility.skipCaseTriggers)
    //  return;
    
    //Commented the bypass code as we dont have initial case load - velud01 - dec 2,2014
       if(Label.Integration_UserProfileIds.contains(userinfo.getProfileId().substring(0,15)))
       return;
       if(CheckRecursiveTrigger.isInitiatedByJira) return;
    if(caseRunOnceFlag.caseRunOnce == true){   
        if (Trigger.isInsert && Trigger.isAfter) {
            caseRunOnceFlag.caseRunOnce = false;    
        }
        TriggerFactory.createHandler(Case.sObjectType);
    }
}