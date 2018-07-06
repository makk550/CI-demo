public class ddrAdminPanelControllerExt 
{
    private final DDR_Rules__c ddrRules;
    
    public ddrAdminPanelControllerExt(ApexPages.StandardController stdController)
    {
        this.ddrRules = (DDR_Rules__c)stdController.getRecord();
    }
    
    public PageReference checkForRecord()
    {
        if(ddrRules.Id == NULL)
        {
            List<DDR_Rules__c> ddrRules = [SELECT Id FROM DDR_Rules__c LIMIT 1];
            
            if(!ddrRules.isEmpty())
            {
                PageReference cp = ApexPages.currentPage();
                cp.getParameters().put('id', ddrRules[0].Id);
                cp.setRedirect(true);
            
                return cp;
            }
        }
        
        return NULL;
    }
}