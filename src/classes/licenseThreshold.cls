global class licenseThreshold{

global static Integer thresholdReached;
 
  static{
       thresholdReached = 0;
  }

  public PageReference thresholdCheck() {
      
        Messaging.SingleEmailMessage emailCheck = new Messaging.SingleEmailMessage();
        emailCheck .setTargetObjectId(System.Label.TargetObjectID);
        emailCheck .setTemplateId(System.Label.TemplateId);
        emailCheck .saveAsActivity = false;
                        
        Messaging.SendEmailResult [] s  = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailCheck});
              
        return null;
    }
 
  public PageReference send() {
      
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<GroupMember> Members = [Select Id, UserOrGroupId from GroupMember where GroupId In (Select Id from Group where Name = 'License_Notify_List')];
        Set<Id> s = new Set<Id>();
        for (GroupMember g : Members)
                 s.add(g.UserOrGroupId);
      
        List<User> userid= [Select Email from User where Id In :s];
        
        String[] toAddresses = new String[]{};
        for (User u : userid)
             toAddresses.add(u.Email);
         
        email.setTargetObjectId(System.Label.TargetObjectID);
        email.setTemplateId(System.Label.TemplateId);
        email.saveAsActivity = false;
        email.setToAddresses(toAddresses);
                
        Messaging.SendEmailResult [] r  = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
             
        return null;
    }
    
   }