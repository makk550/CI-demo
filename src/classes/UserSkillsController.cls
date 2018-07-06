public class UserSkillsController
{
    private final User_Skills__c USK;
    private Apexpages.StandardController controller;

    public UserSkillsController(ApexPages.StandardController std)
    {
        this.controller = std;
        USK= (User_Skills__c)std.getRecord();
    }
    
    public PageReference save()
    {
         return controller.save();
    }
    
}