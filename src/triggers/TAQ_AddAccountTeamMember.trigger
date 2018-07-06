trigger TAQ_AddAccountTeamMember on TAQ_Account_Team__c (before insert, before update)
 {
  /*  FY13 - Functionality moved to CA_TAQ_Account_Approval_Class.
    Set<String> stpmfky=new Set<String>();
    Set<String> stname=new Set<String>();
    Set<String> stPosids=new Set<String>();
    Map<String,TAQ_Account__c> mpeids=new Map<String,TAQ_Account__c>();
    
    //MapTa is used to store manager pmf keys form TAQ organization
    //MapUsr is used to store names and id for any pmf key
            
    //fy12 cahnges.
                        
    set<String> entAccPMFKeys = new set<String>(); 
    Map<String,String> orgmap = NEW Map<String,String>();
            
    Map<String,TAQ_Organization__c> MapTa=new Map<String,TAQ_Organization__c>();
    Map<String,User> MapUsr=new Map<String,User>();

      // mapRejected is used for copy the rejected record.
    Map<id,TAQ_Account__c> mapRejected=new Map<id,TAQ_Account__c>();

    Id userid;
    Boolean isMigrate=false;
    RecordType recType;
    
         
         for(TAQ_Account_Team__c t:Trigger.new){
            if(t.PMFKey__c.length()==7)
                stpmfky.add(t.PMFKey__c.toUpperCase());
            else if(t.PMFKey__c.toUpperCase() != 'NONE')
                stPosids.add(t.PMFKey__c);
         }
         
         
         for(TAQ_Organization__c t:[select Position_Id__c,Manager_PMF_Key__c from TAQ_Organization__c where Position_Id__c in :stPosids])
         {
            stpmfky.add(t.Manager_PMF_Key__c.toUpperCase());
            MapTa.put(t.Position_Id__c,t);
         } 
         if(stpmfky.size()>0)
         {
           for(User u:[select id,name,PMFKey__c from User where PMFKey__c in:stpmfky and isActive=true])
               MapUsr.put(u.PMFKey__c.toUpperCase(),u);
         }
         
         Map<TAQ_Account_Team__c,Id> actteamMap = new Map<TAQ_Account_Team__c,Id>();
         TAQ_AddStdAcctTeamMem objta=new TAQ_AddStdAcctTeamMem();
         List<TAQ_Account__c> parentTAQList = new List<TAQ_Account__c>();
        
           
        
         for(TAQ_Account_Team__c ta: trigger.new)
         {  
            if(ta.PMFKey__c != null && ta.PMFKey__c.length()==7 && MapUsr.containsKey(ta.PMFKey__c.toUpperCase())){
               userid=MapUsr.get(ta.PMFKey__c.toUpperCase()).id; 
            }
            TAQ_Account__c parentTAQ = new TAQ_Account__c(id=ta.TAQ_Account__c);
            
             if(parentTAQ.view_Acc_Record__c != null){
               parentTAQ.Process_Step__c = 'Account Update';
               ParentTAQ.Approval_Process_Status__c = 'Send For Approval';
               parentTAQ.Approval_Status__c = NULL;
               parentTAQList.add(parentTAQ);
            }       
              actteamMap.put(ta,userid);
         }      
          
       
         objta.AccTriggerActions(actteamMap);
          Database.update(parentTAQList);  */ 
}