trigger au_ValidateHVNOwners on HVN__c (before insert, before update) {
    HVNController hvnCtl = new HVNController(); 
    User parentUser = new User();
//    List<AccountTeamMember> atm = new List<AccountTeamMember>(); 
    List<AccountShare> accShare = new List<AccountShare>(); 
    string strMessage = 'Owner must first be added to the account team with R/W access.';
    Integer nAccTeamCount = 0;
    for(HVN__c hvn : trigger.new){
        List<Contact> contacts = [select Id,AccountId,Account.OwnerId,Name from Contact where Id=:hvn.Contact__c];
        if(!contacts.isEmpty()){
            Contact cnt = contacts[0];
    
            if(hvn.Primary_HVN_Owner__c!=null){
//              atm = [Select UserId, User.UserRoleId, TeamMemberRole, IsDeleted, Id, AccountId, AccountAccessLevel From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Primary_HVN_Owner__c];
//              if(atm==null || atm.size()==0){
                nAccTeamCount = [Select count() From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Primary_HVN_Owner__c];
                if(nAccTeamCount==0){
                    parentUser = [Select HVN_Exception__c, UserRoleId from User where id=:hvn.Primary_HVN_Owner__c];
                    if(!parentUser.HVN_Exception__c){
                        accShare = [select AccountId from AccountShare where (AccountAccessLevel='Edit' or AccountAccessLevel='All') and userorgroupid=:hvn.Primary_HVN_Owner__c and AccountId=:cnt.AccountId];
                        if(accShare.isEmpty())
                            hvn.Primary_HVN_Owner__c.addError(strMessage);
                    }
                }
            }
                    
            if(hvn.Secondary_HVN_Contact_Owner_1__c!=null){
//              atm = [Select UserId, User.UserRoleId, TeamMemberRole, IsDeleted, Id, AccountId, AccountAccessLevel From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Secondary_HVN_Contact_Owner_1__c];
//              if(atm==null || atm.size()==0){
                nAccTeamCount = [Select count() From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Primary_HVN_Owner__c];
                if(nAccTeamCount==0){
                    parentUser = [Select HVN_Exception__c,UserRoleId from User where id=:hvn.Secondary_HVN_Contact_Owner_1__c];
                    if(!parentUser.HVN_Exception__c){
                        accShare = [select AccountId from AccountShare where (AccountAccessLevel='Edit' or AccountAccessLevel='All') and userorgroupid=:hvn.Secondary_HVN_Contact_Owner_1__c and AccountId=:cnt.AccountId];
                        if(accShare.isEmpty())
                            hvn.Secondary_HVN_Contact_Owner_1__c.addError(strMessage);
                    }
                }
            }
        
            if(hvn.Secondary_HVN_Contact_Owner_2__c!=null){
//              atm = [Select UserId, User.UserRoleId, TeamMemberRole, IsDeleted, Id, AccountId, AccountAccessLevel From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Secondary_HVN_Contact_Owner_2__c];
//              if(atm==null || atm.size()==0){
                nAccTeamCount = [Select count() From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Primary_HVN_Owner__c];
                if(nAccTeamCount==0){
                    parentUser = [Select HVN_Exception__c,UserRoleId from User where id=:hvn.Secondary_HVN_Contact_Owner_2__c];
                    if(!parentUser.HVN_Exception__c){
                        accShare = [select AccountId from AccountShare where (AccountAccessLevel='Edit' or AccountAccessLevel='All') and userorgroupid=:hvn.Secondary_HVN_Contact_Owner_2__c and AccountId=:cnt.AccountId];
                        if(accShare.isEmpty())
                            hvn.Secondary_HVN_Contact_Owner_2__c.addError(strMessage);
                    }
                }
            }
    
            if(hvn.Secondary_HVN_Contact_Owner_3__c!=null){
///             atm = [Select UserId, User.UserRoleId, TeamMemberRole, IsDeleted, Id, AccountId, AccountAccessLevel From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Secondary_HVN_Contact_Owner_3__c];
//              if(atm==null || atm.size()==0){
                nAccTeamCount = [Select count() From AccountTeamMember where TeamMemberRole='HVN Owner' and IsDeleted=false and AccountId=:cnt.AccountId and UserId=:hvn.Primary_HVN_Owner__c];
                if(nAccTeamCount==0){
                    parentUser = [Select HVN_Exception__c,UserRoleId from User where id=:hvn.Secondary_HVN_Contact_Owner_3__c];
                    if(!parentUser.HVN_Exception__c){
                        accShare = [select AccountId from AccountShare where (AccountAccessLevel='Edit' or AccountAccessLevel='All') and userorgroupid=:hvn.Secondary_HVN_Contact_Owner_3__c and AccountId=:cnt.AccountId];
                        if(accShare.isEmpty())
                            hvn.Secondary_HVN_Contact_Owner_3__c.addError(strMessage);
                    }
                }
            }
        }
    }
}