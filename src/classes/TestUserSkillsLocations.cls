@isTest(SeeAllData=true)
public class TestUserSkillsLocations
{
    public static testMethod void testUserSkillsLocation()
    {
        User_Skills__c myUSK = new User_Skills__c(NA_Countries__c = 'UM - UNITED STATES MINOR OUTLYING ISLAND', LA_Countries__c='GS - SOUTH GEORGIA AND THE SOUTH SANDWIC', EMEA_Countries__c='CD - CONGO, THE DEMOCRATIC REPUBLIC OF T', APJ_Countries__c='ABC', WW_Countries__c='CC');
        insert myUSK;
        ApexPages.StandardController sc = new ApexPages.standardController(myUSK);
        UserSkillsController e = new UserSkillsController(sc);
        
        e.save();        
    }
}