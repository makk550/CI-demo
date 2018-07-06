/** This Trigger updates AOCV, OCV on Account***/
/** The logic has been moved over to Renewals_Util class as a part of FY13 changes***/
trigger Renewal_updateAccount on Active_Contract__c (after insert,after update) {

    Renewals_Util oRenewals_Util = new Renewals_Util();
    oRenewals_Util.UpdateAOCVandOCV(trigger.new,trigger.oldMap);
    
    /*...Saba Test 
    Active_Contract__c actemp= trigger.New[0];
    actemp.Raw_Maint_Calc_LC_Val__c = actemp.Raw_Maint_Calc_LC__c;
    actemp.ATTRF_CRV_Val__c = actemp.ATTRF_CRV__c;
    actemp.AOCV_Val__c = actemp.AOCV__c;
   *******/ 
  /*  Set<Id> accIds = new Set<Id>();
    Map<Id,Decimal> ocvMap = new Map<Id,Decimal>();
    Map<Id,Decimal> aocvMap = new Map<Id,Decimal>();
    List<Account> accountList = new List<Account>();
    
    // Vaich01 for populating roll up summary fields to new fields for req 7.06
    Set<ID> actConId =new Set<ID>();
    List<Active_Contract__c> actCon = new List<Active_Contract__c>(); 
        
    try{
    for(Integer i=0; i<Trigger.New.size(); i++){
        if(Trigger.isupdate )
        {
            System.Debug('Updated Value'+ Trigger.new[i].Calculated_OCV_USD__c);
            System.Debug('Updated Value'+ Trigger.old[i].Calculated_OCV_USD__c);
        
            if(Trigger.new[i].OCV__c != 0
            || Trigger.new[i].AOCV__c != Trigger.old[i].AOCV__c)
           
                accIds.add(Trigger.New[i].account__c);
        }else{
                 accIds.add(Trigger.New[i].account__c);
       }
    }
    
    //*-- vaich01-- change starts
    List<FeedPost> posts = new List<FeedPost>();
    if(Trigger.isupdate)
    {
    for (Active_Contract__c AC :Trigger.New)
        {             
           Active_Contract__c oldAC = Trigger.oldMap.get(AC.id);
            if (AC.Raw_Maint_Calc_LC__c != oldAC.Raw_Maint_Calc_LC__c || AC.ATTRF_CRV__c != oldAC.ATTRF_CRV__c || AC.AOCV__c != oldAC.AOCV__c )
            {
                actConId.add(AC.id);
            }
            
            //added for valuation status chatter feed on AC 2.08
            if(AC.Status_Formula__c != oldAC.Status_Formula__c)
                {
                String bodyText = ' changed the Valuation Status from ' +oldAC.Status_Formula__c+ ' to ' +AC.Status_Formula__c+'.';
                FeedPost acPost = new FeedPost();
                acPost.parentId = AC.Id;
                acPost.Body = bodyText;
                system.debug('********'+acPost.Body );
                posts.add(acPost);
                }
        }
        if(!posts.isempty())
        {
        insert posts;
        }        
    }   
    
     if(!actConId.isempty())    
      {
        actCon = [select id, Raw_Maint_Calc_LC__c, ATTRF_CRV__c, AOCV__c, Raw_Maint_Calc_LC_Val__c,ATTRF_CRV_Val__c,AOCV_Val__c from Active_Contract__c where id IN :actConId];

        for (Active_Contract__c actemp :actCon )
        {
        actemp.Raw_Maint_Calc_LC_Val__c = actemp.Raw_Maint_Calc_LC__c;
            actemp.ATTRF_CRV_Val__c = actemp.ATTRF_CRV__c;
        actemp.AOCV_Val__c = actemp.AOCV__c;
        }
        update actCon;
       
       
      }
  
      //*-- vaich01-- change ends
       
    System.Debug('accIds'+ accIds);
    
    for(Active_Contract__c ac: [select Calculated_AOCV_USD__c,Calculated_OCV_USD__c,account__c from Active_Contract__c where account__c in:accIds]){
      if(ac.account__c != null){
        if(ocvMap.containsKey(ac.account__c)){
            ocvMap.put(ac.account__c,ocvMap.get(ac.account__c) + (ac.Calculated_OCV_USD__c==null?0:ac.Calculated_OCV_USD__c));
            System.Debug('OCV'+ ocvMap.get(ac.account__c) + '----'+ ac.Calculated_OCV_USD__c  );
        }else{
            ocvMap.put(ac.account__c,(ac.Calculated_OCV_USD__c==null?0:ac.Calculated_OCV_USD__c));
             System.Debug('OCV1'+ ocvMap.get(ac.account__c) + '----'+ ac.Calculated_OCV_USD__c  );
        } // OCV
        
        if(aocvMap.containsKey(ac.account__c)){
            aocvMap.put(ac.account__c,aocvMap.get(ac.account__c) + (ac.Calculated_AOCV_USD__c==null?0:ac.Calculated_AOCV_USD__c));
         System.Debug('AOCV'+ ocvMap.get(ac.account__c) + '----'+ ac.Calculated_AOCV_USD__c  );
        }else{
            aocvMap.put(ac.account__c,(ac.Calculated_AOCV_USD__c==null?0:ac.Calculated_AOCV_USD__c));
            System.Debug('AOCV1'+ ocvMap.get(ac.account__c) + '----'+ ac.Calculated_AOCV_USD__c  );
        }// AOCV 
      }  
    }
    for(Id id:aocvMap.keyset()){
        Account acc = new Account(
        Id = id,
        ocv__c = ocvMap.get(id),
        aocv__c = aocvMap.get(id));
        accountList.add(acc);
        System.Debug ('Acc id'+id );
        system.Debug ('ocv__c'+ ocvMap.get(id) + '-----'+ aocvMap.get(id));
    }
    if(accountList.size()>0)
        update accountList;
    }catch(Exception ex){
        System.debug(ex);
    }        
*/
}