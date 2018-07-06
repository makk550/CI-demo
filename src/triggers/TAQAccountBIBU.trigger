trigger TAQAccountBIBU on TAQ_Account__c (before insert, before update) {
  //Put in validation for 7 characters
 //This trigger is now used only by prm for validating pmf keys.
 /* 
  Set<String> camPmfky=new Set<String>();
  Map<String,String> usrMap = new Map<String,String>();
  
  TAQ_Account__c c = new TAQ_Account__c();
    
    for(TAQ_Account__c t:Trigger.new){
     
        //PRM Sprint 4 changes
        addCamPmfky(t.Alliance_CAM_PMFKey__c);
        addCamPmfky(t.Service_Provider_CAM_PMFKey__c);
        addCamPmfky(t.Solution_Provider_CAM_PMFKEY__c);
        addCamPmfky(t.Velocity_Seller_CAM_PMFKey__c);
    }
    
    String strCamPmfky = '';
    List<User> usrList = [select Id,PMFKey__c from User where PMFKey__c in:camPmfky];
    if(usrList != null && usrList .size() > 0){
      for(User u: usrList)
       usrMap.put(u.PMFKey__c.toUpperCase(),u.Id);
    }   

    
    for(TAQ_Account__c acc:Trigger.new){
    
        if(acc.Alliance_CAM_PMFKey__c!=null){
           strCamPmfky = getCamPmfKy(acc.Alliance_CAM_PMFKey__c);
           if(strCamPmfky=='')
              acc.Alliance_CAM_PMFKey__c.addError('No employee exists with the provided PMFKey - ' + acc.Alliance_CAM_PMFKey__c+'. Please enter a valid PMFKey.'); 
           else
             acc.Alliance_CAM_PMFKey__c = acc.Alliance_CAM_PMFKey__c.toUpperCase();
        }

       if(acc.Service_Provider_CAM_PMFKey__c!=null){
          strCamPmfky = getCamPmfKy(acc.Service_Provider_CAM_PMFKey__c);
          if(strCamPmfky=='')
             acc.Service_Provider_CAM_PMFKey__c.addError('No employee exists with the provided PMFKey - ' + acc.Service_Provider_CAM_PMFKey__c+'. Please enter a valid PMFKey.'); 
          else
            acc.Service_Provider_CAM_PMFKey__c = acc.Service_Provider_CAM_PMFKey__c.toUpperCase();
       }

      if(acc.Solution_Provider_CAM_PMFKEY__c!=null){
         strCamPmfky = getCamPmfKy(acc.Solution_Provider_CAM_PMFKEY__c);
         if(strCamPmfky=='')
            acc.Solution_Provider_CAM_PMFKEY__c.addError('No employee exists with the provided PMFKey - ' + acc.Solution_Provider_CAM_PMFKEY__c+'. Please enter a valid PMFKey.'); 
         else
           acc.Solution_Provider_CAM_PMFKEY__c = acc.Solution_Provider_CAM_PMFKEY__c.toUpperCase();
      }

     if(acc.Velocity_Seller_CAM_PMFKey__c!=null){
        strCamPmfky = getCamPmfKy(acc.Velocity_Seller_CAM_PMFKey__c);
        if(strCamPmfky=='')
           acc.Velocity_Seller_CAM_PMFKey__c.addError('No employee exists with the provided PMFKey - ' + acc.Velocity_Seller_CAM_PMFKey__c+'. Please enter a valid PMFKey.'); 
        else
          acc.Velocity_Seller_CAM_PMFKey__c = acc.Velocity_Seller_CAM_PMFKey__c.toUpperCase();
     }   
                 
    }
   
    private void addCamPmfky(string strKey){           
      if(strKey<>null && !camPmfky.contains(strKey))           
       camPmfky.add(strKey);        
    }

   private string getCamPmfKy(string strPmfKey){
     string pmfKy = usrMap.get(strPmfKey.toUpperCase());
     if(pmfKy != null)
       return pmfKy;
     else
      return '';
  }
  */
}