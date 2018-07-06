public class EBCCommunicationTemplateClass {

    public void TriggerEmailTemplate_AccountTeam(set<id> ebcVisitIds) {
        List<AccountTeamMember> actTeamMembers = new List<AccountTeamMember>();
    
        set<Id> accIds = new set<Id>();
        //query on template object
        EmailTemplate et=[Select id from EmailTemplate where name='EBC visit'];
        
        for(Account_Visit__c vst: [select Send_Email_to_Account_Team__c, Company_Name__c from Account_Visit__c where Id =: ebcVisitIds]) 
            accIds.add(vst.Company_Name__c);
            
        actTeamMembers = [Select UserId, TeamMemberRole, User.Name, User.Email, IsDeleted, Id, AccountId, 
                    AccountAccessLevel From AccountTeamMember where AccountId=:accIds and User.Email <> null and User.Email <> '' and IsDeleted=false];
    
        map<Id, List<AccountTeamMember>> mapebcActTeam = new map<Id, List<AccountTeamMember>>();
        List<AccountTeamMember> tempList;
        Map<Id,String> mapTeamRecipients = new Map<Id,String>();
                        integer i =0;
        for(AccountTeamMember members:actTeamMembers) {
           
           
            if(mapTeamRecipients  != null && mapTeamRecipients.size() > 0)
            {
              mapTeamRecipients.put(members.AccountId,mapTeamRecipients.get(members.AccountId) + members.User.Email + ';' ) ;
            }
            else
            {
              mapTeamRecipients.put(members.AccountId ,members.User.Email + ';' );
            }
                
        }
    
        for(Account_Visit__c vst:[select Send_Email_to_Account_Team__c,CreatedBy.Email, Company_Name__c from Account_Visit__c where Id =: ebcVisitIds]){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] ArrstrRecipients;
            mail.setTemplateId(et.id);
            if(vst.Send_Email_to_Account_Team__c && mapTeamRecipients != null && mapTeamRecipients.size() > 0)
                ArrstrRecipients = mapTeamRecipients.get(vst.Company_Name__c).split(';');
            /*else {
                ArrstrRecipients = new String[0];
                ArrstrRecipients.add(vst.CreatedBy.Email);
            }*/
            system.debug('_______'+ArrstrRecipients);
            String[] ArrstrCCRecipients = Label.EBCVisti_CC.split(';');
            mail.setToAddresses(ArrstrRecipients);
            mail.setCCAddresses(ArrstrCCRecipients); 
            mail.setWhatId(vst.Id);
            mail.setTargetObjectId(UserInfo.getUserId());
            mail.setSaveAsActivity(false);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] {mail}); 
        }
    }    

}