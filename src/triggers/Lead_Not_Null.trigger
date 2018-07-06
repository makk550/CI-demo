/************************************************************************************************************************
Name : Lead_Not_Null

Type : Apex Trigger

Desc : Check if lead is not null and then route to appropriate account 

Auth : Deloitte Consulting LLP

*************************************************************************************************************************

LastMod                Developed By                 Desc

5/4/2012               Anto Germans              Assign leads based on records in Partner Lead Routing Rules 
************************************************************************************************************************/

trigger Lead_Not_Null on CampaignMember (before insert) {
    if(SystemIdUtility.skipLead_Not_Null)
        return;
        
    list<Partner_Lead_Routing_Rules__c> plrrList = new list< Partner_Lead_Routing_Rules__c>() ; 
    list<CampaignMember> lstCampMembers = new list<CampaignMember>();
    Map<String,id> que = new Map<String, Id>();
    Set<Id> leadIds = new Set<Id>();
    set<Id> campMembers = new set<Id>();
    List<lead> leadList;
    List<Account> tiedPartnerAcc = new List<Account>();
    Set<Lead> leadsTobeUpdated = new Set<Lead>();
    List<Lead> leadsFinal = new List<Lead>();
    for(CampaignMember cm : trigger.new )
    {
        if(cm.LeadId != null) {
        lstCampMembers.add(cm);
        leadIds.add(cm.LeadId);
        campMembers.add(cm.CampaignId);
        }
    }

    try{
        que.put(QueueCust__c.getInstance('Common Partner Lead Pool').Name,QueueCust__c.getInstance('Common Partner Lead Pool').Queue_ID__c);
        que.put(QueueCust__c.getInstance('Data Management Leads').Name,QueueCust__c.getInstance('Data Management Leads').Queue_ID__c);
        que.put(QueueCust__c.getInstance('Partner Admin').Name,QueueCust__c.getInstance('Partner Admin').Queue_ID__c);  
    }catch(Exception e){
    
    }


    if(leadIds.size() > 0){
    leadList = [select id, OwnerId,Mkt_BU_Category__c,MKT_Solution_Set__c,Lead_RTM__c,Lead_RTM_Type__c,Lead_RTM_Designation__c,Sales_Territory__c from Lead where Id IN : leadIds]; 
    
    Map<Id,Lead> mapLeads = new Map<Id,lead>();
    for(lead l:leadlist)
          mapLeads.put(l.Id,l);
 
    if(campMembers.size() > 0)
    plrrList = [Select id, Campaign__c,Rule_Expiration_Date__c,tie_breaker_rule__c,Account__c,Account_2__c,Account_3__c,Account_4__c,Account_5__c,
                                               Account__r.Lead_Champion__c,Account_2__r.Lead_Champion__c,Account_3__r.Lead_Champion__c,Account_4__r.Lead_Champion__c,Account_5__r.Lead_Champion__c,selected_accounts__c,
                                               Account__r.Last_Accepted_Lead_Date__c,Account_2__r.Last_Accepted_Lead_Date__c,Account_3__r.Last_Accepted_Lead_Date__c,Account_4__r.Last_Accepted_Lead_Date__c,Account_5__r.Last_Accepted_Lead_Date__c,
                                               Account__r.Lead_Routing_Score__c,Account_2__r.Lead_Routing_Score__c,Account_3__r.Lead_Routing_Score__c,Account_4__r.Lead_Routing_Score__c,Account_5__r.Lead_Routing_Score__c,
                                               BU__c,NCV_Driver__c,Product_Group__c,Account_RTM__c,Account_RTM_Type__c,Account_RTM_Designation__c,RTM__c,RTM_Type__c
                              from Partner_Lead_Routing_Rules__c where Campaign__c IN : campMembers];

    system.debug('rules list: '+plrrList.size());
    Map<id,Partner_Lead_Routing_Rules__c> mapCampvsPLRR = new Map<Id,Partner_Lead_Routing_Rules__c>();
    for(Partner_Lead_Routing_Rules__c pl: plrrList)
      if(pl.Campaign__c != null)
           mapCampvsPLRR.put(pl.Campaign__c,pl);
           
       
               
        /*
        if(lstCampMembers.size() > 0){
            for(CampaignMember camMem : lstCampMembers) {
                
                 if(plrrList.size() > 0) {
                     for(Partner_Lead_Routing_Rules__c plrr: plrrList)
                     {
                         if(camMem.CampaignId == plrr.Campaign__c)
                         {
                             for(Lead l: leadList)
                             {
                                 if(camMem.LeadId == l.Id)
                                 {    
                                     l.OwnerId = plrr.Account__r.Lead_Champion__c;
                                     leadsToBeUpdated.add(l);
                                 }
                             }
                         }
                     
                     }
                 }       
            }
         }
        */
system.debug('___________outisde first if block');
    if(lstCampMembers.size() > 0 && plrrList.size() > 0){
        system.debug('entered in first if block');
        List<Lead> noAccLeads = new List<lead>();
        for(CampaignMember camMem : lstCampMembers) {
            try{
                if(mapCampvsPLRR.containsKey(camMem.CampaignId) && mapCampvsPLRR.get(camMem.CampaignId) != null){
                    system.debug('entered in second if block');
                    if(mapLeads.containsKey(camMem.LeadId)){
                       system.debug('entered in lead if block');
                       Partner_Lead_Routing_Rules__c routingRuleRec = mapCampvsPLRR.get(camMem.CampaignId);
                       String tie_breaker = routingRuleRec.Tie_Breaker_Rule__c;
                       system.debug('selected accounts in routing rule: '+routingRuleRec.selected_accounts__c );
                       if(routingRuleRec.selected_accounts__c > 1 && tie_breaker != null){//when multiple accounts are selected.
                            List<Account> accList = new List<Account>();
                            accList.add(new Account(Last_Accepted_Lead_Date__c= routingRuleRec.account__r.Last_Accepted_Lead_Date__c,Lead_Champion__c=routingRuleRec.account__r.Lead_Champion__c ));
                            accList.add(new Account(Last_Accepted_Lead_Date__c= routingRuleRec.account_2__r.Last_Accepted_Lead_Date__c,Lead_Champion__c=routingRuleRec.account_2__r.Lead_Champion__c ));
                            accList.add(new Account(Last_Accepted_Lead_Date__c= routingRuleRec.account_3__r.Last_Accepted_Lead_Date__c,Lead_Champion__c=routingRuleRec.account_3__r.Lead_Champion__c ));
                            accList.add(new Account(Last_Accepted_Lead_Date__c= routingRuleRec.account_4__r.Last_Accepted_Lead_Date__c,Lead_Champion__c=routingRuleRec.account_4__r.Lead_Champion__c ));
                            accList.add(new Account(Last_Accepted_Lead_Date__c= routingRuleRec.account_5__r.Last_Accepted_Lead_Date__c,Lead_Champion__c=routingRuleRec.account_5__r.Lead_Champion__c ));
                           if(tie_breaker == 'Round Robin'){
                             Date dt=null;
                             for( Account acc : accList){
                                if(dt == null){
                                    dt = acc.Last_Accepted_Lead_Date__c;
                                    if(acc.lead_champion__c <> null)
                                        mapLeads.get(camMem.LeadId).ownerId = acc.lead_champion__c;
                                }
                                else if(acc.Last_Accepted_Lead_Date__c != null && dt>acc.Last_Accepted_Lead_Date__c){
                                    dt = acc.Last_Accepted_Lead_Date__c;
                                    if(acc.lead_champion__c <> null)
                                        mapLeads.get(camMem.LeadId).ownerId = acc.lead_champion__c;
                                }
                             }
                           }else if(tie_breaker == 'Score'){
                              Decimal score=null;
                              tiedPartnerAcc.clear();
                              for(Account acc:accList){
                                if(score==null){
                                    score = acc.Lead_Routing_Score__c;
                                    tiedPartnerAcc.add(acc);                            
                                }
                                if(acc.Lead_Routing_Score__c > score){
                                    tiedPartnerAcc.clear();
                                    score = acc.Lead_Routing_Score__c;
                                    tiedPartnerAcc.add(acc);
                                }
                                else if(acc.Lead_Routing_Score__c == score){
                                    tiedPartnerAcc.add(acc);
                                }
                              }
                               Date dtlocal = null;
                              for(Account a:tiedPartnerAcc){
                                if(dtlocal == null){
                                    dtlocal = a.Last_Accepted_Lead_Date__c;
                                    if(a.lead_champion__c <> null)
                                        mapLeads.get(camMem.LeadId).ownerId = a.Lead_Champion__c; 
                                }else if(dtlocal > a.Last_Accepted_Lead_Date__c){
                                    dtlocal = a.Last_Accepted_Lead_Date__c;
                                    if(a.lead_champion__c <> null)
                                        mapLeads.get(camMem.LeadId).ownerId = a.Lead_Champion__c; 
                                }
                              }
                           }else if(tie_breaker == 'Shark Tank'){
                                mapLeads.get(camMem.LeadId).ownerId = que.get('Common Partner Lead Pool');
                           }else if(tie_breaker == 'Manual'){
                                mapLeads.get(camMem.LeadId).ownerId = que.get('Partner Admin');
                           }
                     //     if(mapLeads.get(camMem.LeadId).ownerid != null) 
                          leadsToBeUpdated.add(mapLeads.get(camMem.LeadId));  
                       }else if(routingRuleRec.selected_accounts__c == 1){//when one account is selected.
                            system.debug('entered in if block (single account)');   
                           Id acc1 = routingRuleRec.Account__c!=null?routingRuleRec.Account__r.Lead_Champion__c:null;
                           Id acc2 = routingRuleRec.Account_2__c!=null?routingRuleRec.Account_2__r.Lead_Champion__c:null;
                           Id acc3 = routingRuleRec.Account_3__c!=null?routingRuleRec.Account_3__r.Lead_Champion__c:null;
                           Id acc4 = routingRuleRec.Account_4__c!=null?routingRuleRec.Account_4__r.Lead_Champion__c:null;
                           Id acc5 = routingRuleRec.Account_5__c!=null?routingRuleRec.Account_5__r.Lead_Champion__c:null;
                           
                            mapLeads.get(camMem.LeadId).ownerId = acc1!=null?acc1:(acc2!=null?acc2:(acc3!=null?acc3:(acc4!=null?acc4:acc5)));
                           // if(mapLeads.get(camMem.LeadId).ownerId!= null)
                             system.debug('Lead camption id :'+mapLeads.get(camMem.LeadId));
                               leadsToBeUpdated.add(mapLeads.get(camMem.LeadId));
                       
                       }
                       else if(routingRuleRec.selected_accounts__c == 0 && leadList.size()>0){// when no account is selected.
                            //     PLRR_PartnerAccountSelection routeObj =new PLRR_PartnerAccountSelection();
                            //     routeObj.routeLeads(leadlist);
                           noAccLeads.addAll(leadList);
                       }
                    }
                }
            }catch(Exception e){
                System.debug('____Exception in Lead_Not_Null_trigger__'+e.getMessage());
            }
        }
                            ext_PartnerLeadRouting routeObj = new ext_PartnerLeadRouting();
                            List<Lead> leadsfrmEXT = new List<lead>();
                            leadsfrmEXT = routeObj.leadRouting_BUNCV(leadlist,plrrList,'YES');
                            if(leadsfrmEXT.size()>0)
                               leadsToBeUpdated.addAll(leadsfrmEXT);
    }
 
       //update mapLeads.values();
        try{
            if(leadsToBeUpdated.size() > 0){
             //adding to set to eliminate dup if any
                leadsFinal.addAll(leadsToBeUpdated);
            }    
            system.debug('b4444444444444****************************************'+leadsToBeUpdated.size());
           Database.SaveResult[] results = database.update(leadsFinal,true);
            system.debug('****************************************'+results.size());
            if(results.size() > 0){
                for(Database.Error err: results[0].getErrors())
                {
                  system.debug('**Error************'+err);   
                }
            }
            
        }catch(Exception e){
          System.debug('___Exception while updating leads_Lead_Not_Null trigger:'+e.getMessage());
        }
    }   
}