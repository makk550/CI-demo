trigger RestrictCaseDelete on Case (before delete) 
{     
    if(Label.UsersWithCaseDeleteAccess.contains(userinfo.getUserId().substring(0,15)))
       return;

    for(Case myCase : trigger.old)
    {
        myCase.addError('Deletion of Cases is not allowed. Please use the browser back button or keyboard backspace to return to the View.');
    }    

}