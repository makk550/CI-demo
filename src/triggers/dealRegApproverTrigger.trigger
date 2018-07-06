trigger dealRegApproverTrigger on Deal_Reg_Approvers__c (before Insert) {




if(Trigger.isInsert){

    if(Trigger.isBefore){
    
    Map<Id, List<Deal_Reg_Approvers__c>> DRAMap = new Map<Id, List<Deal_Reg_Approvers__c>>();
    List<Deal_Reg_Approvers__c> DAppList;
    
    for(Deal_Reg_Approvers__c DApp : [Select Id, Region__c, Deal_Registration_Program__c from Deal_Reg_Approvers__c])
    {
        
        if(DRAMap.containsKey(DApp.Deal_Registration_Program__c)){
        
            DAppList = DRAMap.get(DApp.Deal_Registration_Program__c);
            DAppList.add(DApp);
            DRAMap.put(DApp.Deal_Registration_Program__c,DAppList);
            
        }
         else{
             
            DAppList = new List<Deal_Reg_Approvers__c>();
            DAppList.add(DApp);
            DRAMap.put(DApp.Deal_Registration_Program__c,DAppList);
        
         }
    }
        
    for(Deal_Reg_Approvers__c DRA : Trigger.New){
        
          if(DRAMap.containsKey(DRA.Deal_Registration_Program__c)){
          
              for(Deal_Reg_Approvers__c DApp : DRAMap.get(DRA.Deal_Registration_Program__c)){
          
                  if(DApp.Region__c == DRA.Region__c){
                  
                      DRA.addError('There is already an approver for this region');
                  }
              }
              DAppList = DRAMap.get(DRA.Deal_Registration_Program__c);
              DAppList.add(DRA);
              DRAMap.put(DRA.Deal_Registration_Program__c,DAppList);
                  
          }
          else{
          
                
             
              DAppList = DRAMap.get(DRA.Deal_Registration_Program__c);
              if(DAppList == null)
                   DAppList = new List<Deal_Reg_Approvers__c>();
              DAppList.add(DRA);
              DRAMap.put(DRA.Deal_Registration_Program__c,DAppList);
              
          }
          
        
    }
    }
 }


}