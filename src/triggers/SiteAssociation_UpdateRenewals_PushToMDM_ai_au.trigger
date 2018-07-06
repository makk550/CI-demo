trigger SiteAssociation_UpdateRenewals_PushToMDM_ai_au on Site_Association__c (after insert, after update) {
    
      if('YES'.equals(Label.TriggerByPass)){
            return ;
       }       
    SiteAssociationChangesPushToMDM classObj = new SiteAssociationChangesPushToMDM();
    boolean pushToMDM =true ;
    if(Trigger.isInsert){
//  system.debug('e netred in to is insert-------------------------------------------'+SiteAssociationHandler.inFutureContext);
    if(Label.Informatica_userid.contains(userinfo.getUserId().substring(0,15)))
        return  ;
        for(Site_Association__c site :Trigger.new){
               if(site.SC_SITE_Source__c =='GPOC')
                  pushToMDM =false ;
              break ;
        }
        if(pushToMDM) {
              classObj.pushSiteAssociationInsertsToMDM(Trigger.newMap);
        }
    }
   
    if(Trigger.isUpdate){
      for(Site_Association__c site :Trigger.new){  
               if(site.SC_SITE_Source__c =='GPOC' ||SiteAssociationHandler.inFutureContext )
                  pushToMDM =false ;
              break ;
              
        }
        if(pushToMDM) 
              classObj.pushSiteAssociationChangesToMDM(Trigger.newMap);

    }
    //Upadate the site association lookups, account on Active contracts and also account on renewal and opportunity if needed - start
    //  Renewals_Util oRenewals_Util = new Renewals_Util();
    //  oRenewals_Util.updateRenewalsSiteAssociationsAccounts(trigger.OldMap, Trigger.New);
    //end

}