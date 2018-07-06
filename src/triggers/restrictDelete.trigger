trigger restrictDelete on EmailMessage (before delete)
{
    for(EmailMessage message : trigger.old)
    {
        if(Label.Restrict_Case_Email_Del.contains(userinfo.getProfileId().substring(0,15)))
        {
            message.addError('You are not allowed to delete Email communication record, please click on browser Back button to return back to your case and continue.');
        }
    }

}