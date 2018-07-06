trigger PopulateRoute on Account (before insert,before update) {
     if(SystemIdUtility.skipAccount == true)
        return;
  Set<Id> accId = new Set<Id>();
  Map<Id, String> accIdMap = new Map<Id,String>();
  for(Account acc:Trigger.new){
   
   String route='';
   String PartnerRoute='';
   String programLevel='';
   boolean routeChanged =True;
   boolean progLevelChanged =True;

   
   if(Trigger.isUpdate){
      if(Trigger.oldMap.get(acc.Id).Alliance__c != acc.Alliance__c || 
         Trigger.oldMap.get(acc.Id).Service_Provider__c != acc.Service_Provider__c ||
         Trigger.oldMap.get(acc.Id).Solution_Provider__c != acc.Solution_Provider__c ||
         Trigger.oldMap.get(acc.Id).Velocity_Seller__c != acc.Velocity_Seller__c 
         ){
           routeChanged =True;
           accId.add(acc.Id);
     }
     else
        routeChanged =False;
        
        
        if(Trigger.oldMap.get(acc.Id).Alliance_Program_Level__c != acc.Alliance_Program_Level__c ||
           Trigger.oldMap.get(acc.Id).Solution_Provider_Program_Level__c != acc.Solution_Provider_Program_Level__c ||
           Trigger.oldMap.get(acc.Id).Velocity_Seller_Program_Level__c != acc.Velocity_Seller_Program_Level__c ||
           Trigger.oldMap.get(acc.Id).Service_Provider_Program_level__c != acc.Service_Provider_Program_level__c){
            progLevelChanged=True;
        }
        else
           progLevelChanged=False;
   }
   
     
  if(routeChanged){ 
     
   if(acc.Alliance__c)
      route='Alliance';
    
   if(acc.Service_Provider__c){
     if(route!='')
       route+=';Service Provider';  
     else  
       route='Service Provider';
     PartnerRoute='Service Provider';
   }
   
   if(acc.Solution_Provider__c){
    if(route!='')
     route+=';Solution Provider';    
     else  
     route='Solution Provider';
     
      if(PartnerRoute!='')
     PartnerRoute +=';Solution Provider';    
     else  
     PartnerRoute ='Solution Provider';
   }
   
   if(acc.Velocity_Seller__c){
     if(route!='')
      route+=';Volume Reseller';        
     else
     route='Volume Reseller'; 
     
      if(PartnerRoute !='')
      PartnerRoute+=';Data Management';        
     else
     PartnerRoute='Data Management';     
   } 
   
  } 
   
 if(progLevelChanged){    
  if(acc.Alliance_Program_Level__c!=null)
      programLevel=acc.Alliance_Program_Level__c;    
   
   if(acc.Service_Provider_Program_level__c!=null){
   
     if(programLevel!=''){
         if(!programLevel.contains(acc.Service_Provider_Program_level__c))  
         programLevel = programLevel+';'+acc.Service_Provider_Program_level__c;
     }                 
     else
        programLevel = acc.Service_Provider_Program_level__c; 
   }
                        
   if(acc.Solution_Provider_Program_Level__c!=null){
   
     if(programLevel!=''){
         if(!programLevel.contains(acc.Solution_Provider_Program_Level__c))  
         programLevel = programLevel+';'+acc.Solution_Provider_Program_Level__c;
     }                 
     else
        programLevel = acc.Solution_Provider_Program_Level__c; 
   }
     
   if(acc.Velocity_Seller_Program_Level__c != null ){
   
     if(programLevel!=''){
        if(!programLevel.contains(acc.Velocity_Seller_Program_Level__c)) 
           programLevel = programLevel+';'+acc.Velocity_Seller_Program_Level__c ; 
     }
                
     else
        programLevel = acc.Velocity_Seller_Program_Level__c ;   
   }
  }
   
   if(routeChanged)
   {
      acc.Account_Route__c = route;  
      System.debug('Partner Route '+PartnerRoute);
      accIdMap.put(acc.Id,PartnerRoute);
    }
   
   if(progLevelChanged)
      acc.Account_Program_Level__c=programLevel;
   
   
  
  
       if(accId.size() >0)
       {
       //System.debug(LoggingLevel.Info,'PR__accID'+accId);
       //List<Partner_Location__c> modParLocation = new List<Partner_Location__c>();
       List<Partner_Location__c> parLocation = [Select Id,Account__c, Route_To_Market__c from Partner_Location__c where Account__c in :accId];
       // System.debug('PR__parLocation'+ parLocation);
           if(parLocation.size() >0)
           {
           for(Partner_Location__c pl: parLocation)
           {
           pl.Route_To_Market__c = accIdMap.get(pl.Account__c);
           //modParLocation.add(pl);
           }
           //update modParLocation;
           update parLocation;
           }
   
        }
}
}