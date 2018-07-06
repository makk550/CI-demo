public with sharing class EBC_Visit_EmailTemplateController{

    public Id ebcAccId{get;set;}
    public List<AccountTeamMember> accountTeammembers;

    public EBC_Visit_EmailTemplateController() {
    }
    
    public List<AccountTeamMember> getaccountTeammembers() {
        accountTeammembers = [select Id,User.Name, TeamMemberRole from AccountTeamMember where AccountId = : ebcAccId];
        return accountTeammembers;
    }
    
    
}