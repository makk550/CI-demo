@isTest
public class oppTeamMemberTriggerTestClass {
    
    public static testMethod void createAndDeleteTeamMember(){
        
        testOpportunityTriggersClass.createTestData();
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        
        OpportunityTeamMember oppteam1=new OpportunityTeamMember();
        oppteam1.CanAddPresales__c= true;
        oppteam1.UserId = UserInfo.getUserId();
        oppteam1.OpportunityAccessLevel='Edit';
        oppteam1.TeamMemberRole = 'Education Rep';
        oppteam1.OpportunityId=opp.id;
        
        SystemIdUtility.skipOpportunityTriggers = true;
        
        insert oppteam1;
        
        SystemIdUtility.skipOpportunityTriggers = false;
        
        oppteam1 = [select id from OpportunityTeamMember where OpportunityId=:opp.id limit 1];
        delete oppteam1;
        
        OpportunityTeamMember oppteam2=new OpportunityTeamMember();
        oppteam2.CanAddPresales__c= true;
        oppteam2.UserId = UserInfo.getUserId();
        oppteam2.OpportunityAccessLevel='Edit';
        oppteam2.TeamMemberRole = 'Education Rep';
        oppteam2.OpportunityId=opp.id;
         insert oppteam2;
        
		oppteam2 = [select id,TeamMemberRole from OpportunityTeamMember where OpportunityId=:opp.id limit 1]; 
        oppteam2.TeamMemberRole = 'Presales–Field';
        update oppteam2;
        try{
            delete oppteam2;
        }
        catch(exception e){
            system.debug('---message---'+e.getMessage());
        }
        
    }

}