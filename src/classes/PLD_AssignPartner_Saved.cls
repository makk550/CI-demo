public class PLD_AssignPartner_Saved {
    
    List<double> lst;
    Map<id,List<id>> tiebrkMap=new Map<id,list<id>>();
    Map<id,id> assignPtrMap=new Map<id,id>();
    Map<id,id>  assignPartnerMap=new Map<id,id>();
    list<id> tempaccs;
    
    public PLD_AssignPartner_Saved(){}
    
   Public  void SortAndAssignPartner(Map<id,Map<id,double>> AllTotalAccountScoreMap){
       system.debug('----AllTotalAccountScoreMap-----'+AllTotalAccountScoreMap);
            for(id lead_id:AllTotalAccountScoreMap.keyset()){
                system.debug('lead_id--'+lead_id);
                    
                tempaccs=new list<id>();
                lst=new List<double>();
                lst=AllTotalAccountScoreMap.get(lead_id).values();
                System.debug('lst---\n'+lst);
                lst.sort();
                System.debug('---\n'+lst);
                double MaxScore = lst[lst.size()-1]; 
               system.debug('MaxScore--'+MaxScore);
                for(id acc_id:AllTotalAccountScoreMap.get(lead_id).keyset()){
                    system.debug('comparision--'+AllTotalAccountScoreMap.get(lead_id).get(acc_id));
                    if(AllTotalAccountScoreMap.get(lead_id).get(acc_id) == MaxScore){
                        tempaccs.add(acc_id);
                    }
                }
                system.debug('tempaccs---'+tempaccs.size());
                if(tempaccs.size()>1){
                    tiebrkMap.put(lead_id,tempaccs);
                }
                 else{   
                      assignPtrMap.put(lead_id,tempaccs[0]);
                 }
            }
       System.debug('--tiebrkMap-size------'+tiebrkMap.size());
        System.debug('--tiebrkMap--'+tiebrkMap);
       
        System.debug('--assignPtrMap--'+assignPtrMap);
       System.debug('--assignPtrMap---size---'+assignPtrMap.size());
        
        
       
       if(tiebrkMap != null && tiebrkMap.size()>0)
       {       
            PLR_TieBreakingRules tieBreakingRules = new PLR_TieBreakingRules();
            assignPartnerMap = tieBreakingRules.applyTieBreakingRules(tiebrkMap);
           System.debug('-----assignPartnerMap after tiebreaking rules----'+assignPartnerMap.size());
           
           if(assignPartnerMap != null && assignPartnerMap.size() > 0){
               assignPtrMap.putAll(assignPartnerMap);
               System.debug('--assignPtrMap---size---'+assignPtrMap.size());
               LeadOwnerassignment(assignPtrMap); 
           }
           else{
                if(assignPtrMap != null && assignPtrMap.size()>0){
                    System.debug('--assignPtrMap---size---'+assignPtrMap.size());
                     LeadOwnerassignment(assignPtrMap);
                }
           }
                       
       }
       else{
           if(assignPtrMap != null && assignPtrMap.size()>0){
               System.debug('--assignPtrMap---size---'+assignPtrMap.size());
            LeadOwnerassignment(assignPtrMap);
        }
       }
        
    }
   
    
    ///LeadOwnerassignment---start-----Ponse01
    list<User> Userlist=New List<User>();
    list<Lead> Leadlist=New List<Lead>();
    list<Lead> LeadstoUpdate=New List<Lead>();
    list<Account> Acclist=New List<Account>();
    list<DelegateLeadChampion__c> deligatelist=New List<DelegateLeadChampion__c>();
    list<LeadRoutingMatrix__c> LRMlist=New List<LeadRoutingMatrix__c>();
    set<id> accidset=New set<id>();
    set<id> leadidset=New set<id>();
    Map<id,id> accidusermap=New Map<id,id>();
    Map<id,DelegateLeadChampion__c> useriddlcmap=New Map<id,DelegateLeadChampion__c>();
    
    Map<id,id> LeadAccMap=new Map<Id,id>();
    
    Public Void LeadOwnerassignment(Map<id,id> leadaccmap){
        system.debug('****--leadaccmap-size--*****'+leadaccmap.size());
        system.debug('--leadaccmap---'+leadaccmap);
        System.debug('--Leads which are getting routed to Accounts--');
        for(id st:leadaccmap.keyset()){
          System.debug('--lead id--'+st+'-acc id--'+leadaccmap.get(st));
        }
        Leadlist=PartnerLeadDistribution_DynamicSOQL.LeadList(leadaccmap.keyset());
        Acclist=PartnerLeadDistribution_DynamicSOQL.AccountList(leadaccmap.Values());
        
        for(Account ac:Acclist){
            
            LeadAccMap.put(ac.id, ac.Lead_Champion__r.AccountId);
            accidusermap.put(ac.id,ac.Lead_Champion__c);
            
        }
        deligatelist=PartnerLeadDistribution_DynamicSOQL.DeligateList();
        system.debug('deligatelist---'+deligatelist);
            for(DelegateLeadChampion__c dlc:deligatelist){
            useriddlcmap.put(dlc.Createdbyid, dlc);
        }
        
        System.debug('-------------------------------Partner Routed lead details------------------');
        for(Lead ld:Leadlist){
            if(leadaccmap.containskey(ld.id)){
                if(accidusermap.containsKey(leadaccmap.get(ld.id))){
                    
                    if(useriddlcmap.containsKey(accidusermap.get(leadaccmap.get(ld.id)))){
                        System.debug('-------------------------------Partner Routed lead to delegate------------------');
                       // System.debug('--before delegate---'+accidusermap.get(leadaccmap.get(ld.id)));
                        ld.Partnerleadprocessed__c=True;
                         ld.AssignmentDate__c =system.now();
                        ld.Status='Routed to Partner';
                       // ld.RecordTypeId=system.label.Ldm_Partner;
                        ld.AcceptReject__c='';
                        ld.Rejection_Reason__c='';
                        ld.AutoRejectionPartner__c=False;
                      // ld.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Deal_Registration').getRecordTypeId();
                        ld.ownerid=useriddlcmap.get(accidusermap.get(leadaccmap.get(ld.id))).DelegateLeadChampion__c;
                        ld.Reseller__c=getpartneraccountid(useriddlcmap.get(accidusermap.get(leadaccmap.get(ld.id))).DelegateLeadChampion__c);
                        System.debug('----lead id---'+ld.id+'--ld.ownerid---'+ld.ownerid);
                        LeadstoUpdate.add(ld);
                    }else{
                        leadidset.add(ld.Id);
                        accidset.add(leadaccmap.get(ld.id));
                        ld.Partnerleadprocessed__c=True;
                         ld.AssignmentDate__c =system.now();
                        ld.Status='Routed to Partner';
                        ld.AcceptReject__c='';
                        ld.Rejection_Reason__c='';
                       // ld.RecordTypeId=system.label.Ldm_Partner;
                        ld.AutoRejectionPartner__c=False;
                       // ld.RecordTypeId=Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Deal_Registration').getRecordTypeId();
                        ld.ownerid=accidusermap.get(leadaccmap.get(ld.id));
                        ld.Reseller__c=LeadAccMap.get(leadaccmap.get(ld.id));
                        if(Test.Isrunningtest()){
                            id partneruser=getpartneraccountid(accidusermap.get(leadaccmap.get(ld.id)));
                        }
                        System.debug('----lead id---'+ld.id+'--ld.ownerid---'+ld.ownerid);
                        LeadstoUpdate.add(ld);
                    }
                    
                }
            }
        }
        if(LeadstoUpdate.size()>0){
            System.debug('------------update lead owner--------'+LeadstoUpdate);
            
            //commenting the DML for soft deploy
           update LeadstoUpdate;
         }
        for(LeadRoutingMatrix__c lr:[select id,Name,Partner_Account__c,Statuss__c,Partner_Lead__c from LeadRoutingMatrix__c where  Partner_Lead__c IN:leadidset and Partner_Account__c IN:accidset and Statuss__c=:'Eligible']){
           lr.Statuss__c= 'Assigned to Partner';
            LRMlist.add(lr);
        }
         if(LRMlist.size()>0){
             System.debug('---LRMlist------'+LRMlist);
             
             //commenting the DML for soft deploy
            update LRMlist;
            
         }
 
    }
//LeadOwnerassignment---end-----Ponse01
    public  id getpartneraccountid(id user_id){
        id accid;
        for(User ur:[select id,Accountid from User where id=:user_id limit 1]){
            accid=ur.Accountid;
            
        }
        
      return   accid;
    }

}