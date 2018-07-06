trigger PRM_Validate_RTM on Route_To_Market__c (before insert , after insert) {
  
  if (Trigger.isBefore) {
        for (Route_To_Market__c agrmnt: Trigger.new) {
            List<Route_To_Market__c> lst = [select Id,RTM__c,RTM_CAM_PMFKey__c,Account__c from Route_To_Market__c where Account__c  =: agrmnt.Account__c];
            if(lst.size()>0){
                for(Route_To_Market__c agrmntReslt:lst){
                    if(agrmntReslt.RTM__c!=null && agrmntReslt.RTM__c == agrmnt.RTM__c){
                        agrmnt.RTM__c.addError('Record already exists with the selected RTM Value.');    
                    }
                }
            }
     }
    // If the trigger is not a before trigger, it must be an after trigger.  
  }else {
        for (Route_To_Market__c agrmnt : Trigger.new) {
            if(agrmnt.RTM__c != null && agrmnt.RTM_CAM_PMFKey__c == null){
                agrmnt.addError('Please select '+ agrmnt.RTM__c +' Checkbox on Account.');
                agrmnt.RTM_CAM_PMFKey__c.addError('Record cannot be created with empty PAM PMF key on Account.');
            }           
        }   
  }
 
}