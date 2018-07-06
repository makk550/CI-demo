public class EntitlementControllerExtension {
    String recordId;
    PermissionSetAssignment psetID;
    EntitlementPDD__c entRec;

    public EntitlementControllerExtension(ApexPages.StandardController stdController) {
        recordID = stdController.getId();
    }

    public PageReference redirect(){
    	try {
            //system.debug('recordID ' + recordId);
            
           	psetID = [Select ID from PermissionSetAssignment where PermissionSetId in (SELECT ID FROM PermissionSet where Name = 'Customer_Success_PDD') and AssigneeID = :UserInfo.getUserId() limit 1];
      		
            if (psetID != NULL) {
                try{
                    entRec = [SELECT SFDC_Account_ID__c FROM EntitlementPDD__c where id = :recordId limit 1];
                    if(entRec != NULL){
                        PageReference customPage = new PageReference('/apex/PDDSingle?dID=' + entRec.SFDC_Account_ID__c + '&entID=' + recordId);
                        customPage.setRedirect(true);
                        return customPage;
                    } 
                }catch(Exception e){
                    PageReference customPage = new PageReference('/' + recordId);
                    customPage.getParameters().put('nooverride','1');
                    customPage.setRedirect(true);
                    return customPage;
                }
        	}
        } catch(Exception e){
        	//system.debug('User does not have Customer Success PDD Permission Set');	
            PageReference customPage = new PageReference('/' + recordId);
            customPage.getParameters().put('nooverride','1');
            customPage.setRedirect(true);
            return customPage;
        }
        
        return null;

    }
}