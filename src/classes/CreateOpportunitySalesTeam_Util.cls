public without sharing class CreateOpportunitySalesTeam_Util 
{
  @future
  public static void createOpportunitySalesTeam(List<Id> accountIdList, Set<Id> opportunityIdSet)
  {
     System.debug('Inside @future method => createOpportunitySalesTeam');
     Map<Id, List<AccountTeamMember>> accountTeamMemberMap = new Map<Id, List<AccountTeamMember>>();
     List<OpportunityTeamMember> newOpportunityTeamMemberList = new List<OpportunityTeamMember>();
     Opportunity[] opptyList = [SELECT Id, Distributor_6__c, Reseller__c, Partner__c,Partner_1__c FROM Opportunity WHERE Id IN : opportunityIdSet];
     
     
    try
     {
         if(accountIdList.size() != 0)
         {
            for(AccountTeamMember accountTeamMember : [SELECT AccountAccessLevel, AccountId, TeamMemberRole, UserId,User.IsActive from AccountTeamMember WHERE AccountId IN : accountIdList])
            {
                if(accountTeamMemberMap.get(accountTeamMember.AccountId) == null)
                {
                    accountTeamMemberMap.put(accountTeamMember.AccountId, new List<AccountTeamMember> {accountTeamMember});
                }
                else
                {
                  (accountTeamMemberMap.get(accountTeamMember.AccountId)).add(accountTeamMember);
                }
                
            }
            //Create Opportunity Team Members
            //If the "Account team member" is being added to the "Oppty Sales team" (who is already a part od opty salesteam)Salesrfore will avoid the duplicate insert.
            for(Opportunity opty : opptyList)
            {
              
              System.debug(opty.Distributor_6__c+'_____1actmap___'+accountTeamMemberMap.containsKey(opty.Distributor_6__c));
              System.debug(opty.Reseller__c+'_____2actmap___'+accountTeamMemberMap.containsKey(opty.Reseller__c));
              System.debug(opty.Partner__c+'_____3actmap___'+accountTeamMemberMap.containsKey(opty.Partner__c));
              System.debug(opty.Partner_1__c+'_____4actmap___'+accountTeamMemberMap.containsKey(opty.Partner_1__c));
               
                if(accountTeamMemberMap.get(opty.Distributor_6__c) != null)
                {
                  newOpportunityTeamMemberList = resolveOpportunityTeamMemberListSize(newOpportunityTeamMemberList, accountTeamMemberMap.get(opty.Distributor_6__c), opty);
                }
                if(accountTeamMemberMap.get(opty.Reseller__c) != null)
                {
                 newOpportunityTeamMemberList = resolveOpportunityTeamMemberListSize(newOpportunityTeamMemberList, accountTeamMemberMap.get(opty.Reseller__c), opty);
                }
                if(accountTeamMemberMap.get(opty.Partner__c) != null)
                {
                 newOpportunityTeamMemberList = resolveOpportunityTeamMemberListSize(newOpportunityTeamMemberList, accountTeamMemberMap.get(opty.Partner__c), opty);
                }
                if(accountTeamMemberMap.get(opty.Partner_1__c) != null)
                {
                 newOpportunityTeamMemberList = resolveOpportunityTeamMemberListSize(newOpportunityTeamMemberList, accountTeamMemberMap.get(opty.Partner_1__c), opty);
                }
            }
            if(newOpportunityTeamMemberList.size() != 0)
            {
            insert newOpportunityTeamMemberList;
            System.debug('No of OpptyTeamMembers created ==> '+ newOpportunityTeamMemberList.size());
            }
         }
     }
     catch(Exception e)
     {
        System.Debug(e);
     }
    
  }
  
  public static List<OpportunityTeamMember> resolveOpportunityTeamMemberListSize(List<OpportunityTeamMember> newOpportunityTeamMemberList, List<AccountTeamMember> accTeamMemberList, Opportunity opty)
  {
          for(Integer s =0; s< accTeamMemberList.size(); s++)
          {
            if(newOpportunityTeamMemberList.size() < 1000)
            {
                if(accTeamMemberList[s].User.IsActive && accTeamMemberList[s].TeamMemberRole!='TAQ-PARTN DM')
                {
                 newOpportunityTeamMemberList.add(new OpportunityTeamMember(
                                                  OpportunityId = opty.Id,
                                                  TeamMemberRole = accTeamMemberList[s].TeamMemberRole,
                                                  UserId = accTeamMemberList[s].UserId
                                                  ));
                }
            }
            else
            {
                insert newOpportunityTeamMemberList;
                System.debug('No of OpptyTeamMembers created => '+ newOpportunityTeamMemberList.size());
                newOpportunityTeamMemberList.clear();
                if(accTeamMemberList[s].User.IsActive && accTeamMemberList[s].TeamMemberRole!='TAQ-PARTN DM')
                {
                newOpportunityTeamMemberList.add(new OpportunityTeamMember(
                                                  OpportunityId = opty.Id,
                                                  TeamMemberRole = accTeamMemberList[s].TeamMemberRole,
                                                  UserId = accTeamMemberList[s].UserId
                                                  ));
                }
            }
          }
          return newOpportunityTeamMemberList;
  }
    @isTest(SeeAllData=true)
    public static void CreateOpportunitySalesTeam_Util_test() {
       
       List<Id> aIds =new List<Id>();
       List<AccountTeamMember> actList = [select accountid from accountteammember limit 1000];
       
       for(AccountTeamMember act:actList)
          aIDs.add(act.AccountId);
       
        List<Account> accListt = [select id from Account where id in: aIDs limit 100];
        
        
        for(Account acc:accListt){
            aIDs.add(acc.Id);
        }
        
        
        
        List<Opportunity> opps = [Select Id, AccountId from Opportunity where Distributor__c in: aIDs or reseller__c in: aIDs or partner__c in: aIDs or partner_1__c in: aIDs LIMIT 30];
        List<Id> accList = new List<Id>();
        Set<Id> oppSet = new Set<Id>();
        for(Opportunity opp : opps) {
            accList.add(opp.AccountId);
            oppSet.add(opp.Id);
        }
        CreateOpportunitySalesTeam_Util.createOpportunitySalesTeam(accList, oppSet);
    }
}