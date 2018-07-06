trigger ai_getOppsAndCSA on Account_Visit__c (after insert) {

    List<EBC_Opportunity__c> ebcOpps = new List<EBC_Opportunity__c>();
    for(Account_Visit__c vst:Trigger.New){

        Account_Visit__c visit = [select CSA__c,Company_Name__c,Opp_Ids__c from Account_Visit__c where id=:vst.Id];
        if(visit!=null){
            List<AccountTeamMember> members = [Select UserId, User.Name, IsDeleted, Id, AccountId, 
            AccountAccessLevel From AccountTeamMember where AccountId=:visit.Company_Name__c and TeamMemberRole='CSA' and IsDeleted=false];
            Integer count = 0;
            for(AccountTeamMember member: members){
                if(visit.CSA__c!=null)
                    visit.CSA__c+= member.User.Name;
                else
                    visit.CSA__c = member.User.Name;
                
                if(count>0 && count<members.size())
                    visit.CSA__c+=', ';
            }
    
            if(visit.Opp_Ids__c!=null){
                String[] opps = visit.Opp_Ids__c.split('=');
                string oppNumbers = '';
                for(string oppId:opps){
                    String[] oppInfo = oppId.split(':');
    
                    //visit.CSA__c.addError('oppId is : ' + oppId);
                    EBC_Opportunity__c ebcOpp = new EBC_Opportunity__c();
                    ebcOpp.Opportunity__c = oppInfo[0];
                    ebcOpp.EBC_Visit__c = visit.Id;
                    System.debug('visit.Id: ' + visit.Id);
                    ebcOpps.add(ebcOpp);
                    oppNumbers+= oppInfo[1] + ', ';
                }
                insert ebcOpps;
                visit.Opp_Ids__c = '';
                visit.Opportunity_Numbers__c = oppNumbers;
            }
            Account acc = [Select Owner.Name from Account where id=:visit.Company_Name__c];
            visit.AD__c = acc.Owner.Name;
            update visit;
        }
    }
        //AR# 1751
    set<Id> ebcVisitIds = new set<Id>();
    List<AccountTeamMember> actTeamMembers = new List<AccountTeamMember>();
    
    //query on template object
    //EmailTemplate et=[Select id from EmailTemplate where name=:'EBC visit'];

    for(Account_Visit__c vst:Trigger.New){
        ebcVisitIds.add(vst.id);
    }
  
    EBCCommunicationTemplateClass obj = new EBCCommunicationTemplateClass();
    obj.TriggerEmailTemplate_AccountTeam(ebcVisitIds);


}