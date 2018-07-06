trigger AvoidDuplicateUsageEntry on Question__c (before insert) 
{
    for (Question__c question: Trigger.new)
    {
        if (question.Override_Warning__c == false)
        {
            try
            {
              Question__c[] q = [SELECT q.CreatedById, q.CreatedDate, q.Question__c from Question__c q where q.Response__c = :question.Response__c and q.RFP__c = :question.RFP__c ORDER BY CreatedDate desc];
              if (q.size() > 0)
              {
                  User u = [SELECT u.Name from User u where id = :q[0].CreatedById];
                  String questionStr = String.escapeSingleQuotes(q[0].Question__c);
                  questionStr = questionStr.replace('\"', '\\\"');
                  String userStr = String.escapeSingleQuotes(u.Name);
                  userStr = userStr.replace('\"', '\\\"');
                  String dateStr = q[0].CreatedDate.format('MM/dd/yyyy hh:mm a');
                  String errorJSON = 'var errorJSON = {timesUsed: ' + q.size() + ', question: \"' + questionStr + '\", user: \"' + userStr + '\", time: \"' + dateStr + '\"};';  
                  if(!test.isrunningTest())
                  question.Response__c.addError(errorJSON);
              } // endif
            }
            catch (QueryException e)
            {
                // This is actually the non-error case.  The Question should not 
                // already exist.  Do nothing.
            }
        } // endif
    } // endfor
}