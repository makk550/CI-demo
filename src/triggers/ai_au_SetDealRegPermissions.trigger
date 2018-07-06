trigger ai_au_SetDealRegPermissions on Opportunity (after insert, after update) {


 
    if(SystemIdUtility.skipOpportunityTriggers)
            return;

    //---------CODE START FOR FY15 Requirement on Business Plan Focus Field-----------
         Set<Id> oppIdSet = new Set<Id>();
         if(Trigger.isUpdate && Trigger.isAfter){
             for(Integer i=0;i<trigger.new.size();i++){
                 if((trigger.old[i].Type != trigger.new[i].Type) || (trigger.old[i].Reseller__c != trigger.new[i].Reseller__c) || (trigger.old[i].AccountId != trigger.new[i].AccountId) || (trigger.old[i].Partner__c != trigger.new[i].Partner__c)){
                     oppIdSet.add(trigger.new[i].Id);
                 }
             }
             if(oppIdSet != null && oppIdSet.size()>0){                 
                 UpdateBusinessPlanFocus.LogicTriggeredFromOpportunity(oppIdSet);
             }
         }
         
         
         
         //---------CODE END FOR FY15 Requirement on Business Plan Focus Field-------------
    
    

    List<OpportunityShare> oppShareList = new List<OpportunityShare>();
    OpportunityShare objOpprtunityShare = null;
    Set<Id> partnerIds = new Set<Id>();
    Set<Id> dealRegIds = new Set<Id>();
    Set<Id> acctIds = new Set<Id>();
    Map<Id,Id> partner_dealReg_map = new Map<Id,Id>();
    Map<Id,Id> partner_account_map = new Map<Id,Id>();
    Map<Id,List<Id>> acctId_Users_map = new Map<Id,List<Id>>();
    List<Id> userList = null;
    Set<Id> usersInShareList = new Set<Id>();
    Set<Id> endUserAccountId = new Set<Id>();
    Set<Id> approvedDealRegIds = new Set<Id>();
    
   RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
   Id dealRegOppRecordTypeID = rec.RecordType_Id__c; 
    
     for(Opportunity objOpportunity : Trigger.new) {
        if(objOpportunity.RecordTypeId == dealRegOppRecordTypeID)
        {
            if(Trigger.isUpdate)
            {
                if(Trigger.newMap.get(objOpportunity.Id).CreatedById <> Trigger.oldMap.get(objOpportunity.Id).CreatedById){
                    oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.CreatedById));
                }
                
                if(Trigger.newMap.get(objOpportunity.Id).First_Approver__c <> Trigger.oldMap.get(objOpportunity.Id).First_Approver__c){
                    oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.First_Approver__c));
                }
                
                if(objOpportunity.Second_Approver__c != null) {
                    if(Trigger.newMap.get(objOpportunity.Id).Second_Approver__c <> Trigger.oldMap.get(objOpportunity.Id).Second_Approver__c){
                        oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.Second_Approver__c));
                    }
                 }
                
                if(objOpportunity.Third_Approver__c != null) {
                    if(Trigger.newMap.get(objOpportunity.Id).Third_Approver__c <> Trigger.oldMap.get(objOpportunity.Id).Third_Approver__c){
                        oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.Third_Approver__c));
                    }
                }
                
                if(objOpportunity.Partner_User_Internal__c != null) {
                    if(Trigger.newMap.get(objOpportunity.Id).Partner_User_Internal__c <> Trigger.oldMap.get(objOpportunity.Id).Partner_User_Internal__c){
                        oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.Partner_User_Internal__c));
                    }
                }
            }
            else
            {
                oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.CreatedById));  
                oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.First_Approver__c));
                if(objOpportunity.Second_Approver__c != null) {
                    oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.Second_Approver__c));
                }
                
                if(objOpportunity.Third_Approver__c != null) {
                    oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.Third_Approver__c));
                }
                
                if(objOpportunity.Partner_User_Internal__c != null) {
                    oppShareList.add(AddTotheOppShare(objOpportunity.Id, objOpportunity.Partner_User_Internal__c));
                }
            }
        }       
    }
    
    if(oppShareList.size() > 0)
        Database.insert(oppShareList,false);  
    
    private OpportunityShare AddTotheOppShare(Id oppId, Id authorizedUser)
    {   
        objOpprtunityShare = new OpportunityShare();
        if(!usersInShareList.contains(authorizedUser)){
            objOpprtunityShare.OpportunityAccessLevel = 'Edit';
            objOpprtunityShare.OpportunityId = oppId;
            objOpprtunityShare.UserOrGroupId = authorizedUser;
            usersInShareList.add(authorizedUser);
        }
        return  objOpprtunityShare;
    }
}