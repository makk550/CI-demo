trigger BP_Approved_BP_Delete on Business_Plan_New__c (before Insert,before delete) {
static final string permissionSetName = 'BP_Approved_Deletion_Set';
    if(Trigger.isBefore && Trigger.isdelete){
     
     string userId = Userinfo.getUserId();
     integer deletePermissionSetCount = database.countQuery('SELECT count() FROM PermissionSetAssignment WHERE AssigneeId =:userId AND PermissionSet.Name =:permissionSetName');

     for(Business_Plan_New__c bp : Trigger.old){
          if((Trigger.oldmap.get(bp.Id).Status__c != 'Draft') && (deletePermissionSetCount == null || deletePermissionSetCount == 0))
          {
                 bp.addError(Label.BP_Approved_Deletion_Error);
          }
     }
     }
     
     // Ponse01 --start------------------US357357-------
     if(!Test.isRunningTest()){
 if(Trigger.isBefore && Trigger.isinsert){
        for(Business_Plan_New__c bp : Trigger.new)
        {
        if(bp.CA_Business_Plan_Owner__c==null || bp.Account_Executive__c==null || bp.GEO_Sales_VP__c== null
        || bp.GEO_Enablement__c== null || bp.GEO_Program_Lead__c== null || bp.GEO_Finance__c==null || bp.GEO_Marketing__c== null 
        || bp.Partner_Business_Plan_Owner__c == null || bp.Partner_Executive_Sponsor__c== null || bp.Approvers_01__c== null || bp.Approvers_02__c== null)
        {
        
        bp.addError(System.Label.BP_Partner);
        
        }
        
        
        }
    } 
    }  
// Ponse01 --End----------US357357----------    
}