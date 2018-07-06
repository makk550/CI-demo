/**
* Description :This global class contains a web service method
*              to handle user record updates based on the process steps of the
*              Approved Org records. This class can be invoked through trigger a
*              Or with a button on a page layout.
*               
* Author       : Abinav Pothuganti (POTAB02)
* Last Updated  : November 2015
* With Reference to AR# 3687
**/

global class TAQOrgAdmin implements schedulable{
    public static boolean inFutureContext = false;
    // added a static variable check for keeping count of future method calls in same transaction - Heena sept-29
    // this interface is requirement to be able to used by apex scheduler
    // We will simply kick start the web service
    global void execute (SchedulableContext sc){
        System.enqueueJob(new TAQOrgAdminMainLogic());
    }
    
    
    webservice static void updateUser()
    {
        System.enqueueJob(new TAQOrgAdminMainLogic());
    }
}