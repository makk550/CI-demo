trigger Leaddelete on Lead (After delete) {
    User u = [select Name,email,Managerid from user where id=:userinfo.getuserid()];
    // Checking whether the user has manager, If yes we are Sending user and Manager email in a array "email".
    string[] email= new String[]{u.email};
    if(u.Managerid != null)
    {
        User m=[select Name,email from user where id=:u.Managerid ];
        email.add(m.email);                
    }
    system.debug('Not2'+email);
    List<lead> leadLst = new List<Lead>();
    //leadLst =[select id,Name from lead where id in:trigger.oldmap.keyset()];
    for(Lead l : Trigger.old){
        if(l.MasterRecordId == null) leadLst.add(l);
    }
    string username = u.name;
    system.debug('ListleadLst'+leadLst);
    if(leadLst.size()>0) LeadDeleteNotification.readrecord(leadLst,username,email);
}