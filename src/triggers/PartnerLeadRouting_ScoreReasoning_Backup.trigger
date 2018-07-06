trigger PartnerLeadRouting_ScoreReasoning_Backup on Lead (before insert,before update,After update) {
/*   List<Lead> leadList = new List<Lead>();
    if(Trigger.isbefore && Trigger.Isinsert){
         for(Lead l:trigger.new){
    if(l.BU__c != NULL || l.MKT_Solution_Set__c != NULL){
        leadlist.add(l);
    }
   }
   
   if(leadlist.size()>0){
      ext_PartnerLeadRouting obj = new ext_PartnerLeadRouting ();
      obj.matchPLRR(leadlist);
   }
    }
  
    
     // Code Starts for Partner Lead Routing -Ponse01
           if(Trigger.isbefore && Trigger.isupdate){
        Map<id,string> partnerusermap=New Map<id,string>();

       
           
    
        for(Lead ld:Trigger.New){
    
            if(ld.OwnerId != null) {
    
                if(trigger.oldmap.get(ld.id).Owner.type=='Queue' && trigger.Newmap.get(ld.id).Owner.Type=='User') {
        
                    if( PartnerLeadDistribution_Utility.ispartneruser(trigger.Newmap.get(ld.id).Ownerid)){
                        ld.AssignmentDate__c =system.now();
                        ld.Status='Routed to Partner';
                        ld.Reseller_Status__c='Routed to Partner';
                    }
                    
                }
                if(trigger.oldmap.get(ld.id).Status!='Marketing Nurture' && trigger.Newmap.get(ld.id).Status=='Marketing Nurture'){
                    system.debug('in marketing nurture');
                    ld.Previousleadowner__c=string.valueOf(trigger.oldmap.get(ld.id).OwnerId);
                    ld.RecordTypeId=system.label.Ldm_rectpque;
                    
                }
                 if(trigger.oldmap.get(ld.id).Status!='Re-engaged' && trigger.Newmap.get(ld.id).Status=='Re-engaged'){
                     if(ld.Previousleadowner__c!=Null ){
                         ld.OwnerId=id.valueOf(ld.Previousleadowner__c);
                       //  ld.RecordTypeId=system.label.Ldm_Partner;
                     }
                    
                    
                }
            }

        }
    }
  
    
    if(Trigger.isAfter && Trigger.isUpdate){
        set<id> leadids=New set<id>();
        list<lead> ledstoupdate=New List<Lead>();
         set<id> leadidstoupdateQueue=New set<id>();
         list<LeadRoutingMatrix__c> LRMlist=New List<LeadRoutingMatrix__c>();
         Map<id,Map<id,PLR_PartnerScore>> rejectionmap=New Map<id,Map<id,PLR_PartnerScore>>();
         Map<id,PLR_PartnerScore> innermap=New Map<id,PLR_PartnerScore>();
        for(Lead lds:Trigger.New){
            system.debug('AutoRejectionPartner__c---'+lds.AutoRejectionPartner__c);
            if(lds.AutoRejectionPartner__c==True && lds.AcceptReject__c=='Reject'){
                system.debug('auto reject leadid'+lds.Id);
                leadids.add(lds.id);
            }
            
        } 
        system.debug('leadids---'+leadids);
        if(leadids.size()>0){
         PLR_PartnerScore AccountScore = new PLR_PartnerScore();
         for(LeadRoutingMatrix__c lr:[select id,Name,Rejection_Reason__c,Partner_Account__c,Statuss__c,Total_Account_Score_Reason__c,Partner_Lead__c,AccountScore__c   from LeadRoutingMatrix__c where  Partner_Lead__c IN :leadids]){
                        if(lr.Statuss__c=='Eligible' && lr.Statuss__c!='Assigned to Partner'){
                            AccountScore.SetPartnerScoreValue(lr.AccountScore__c );
                            AccountScore.SetPartnerScoreReason1(lr.Total_Account_Score_Reason__c );
                            innermap.put(lr.Partner_Account__c, AccountScore); 
                             rejectionmap.put(lr.Partner_Lead__c,innermap ); 
                        }
                        if(lr.Statuss__c=='Assigned to Partner'){
                        lr.Statuss__c= 'Rejected';
                         lr.Rejection_Reason__c='No Knowhow';
                       LRMlist.add(lr);
                      }
                       
                    }
            system.debug('rejectionmap---'+rejectionmap);
             if(rejectionmap.size()>0){
                   // PartnerLeadDistribution_AssignPartner ptrdidtibution=New PartnerLeadDistribution_AssignPartner();
                   // ptrdidtibution.SortAndAssignPartner(rejectionmap);
            } else{
        
                    for(id ldi:leadids)
                    {
                      if(rejectionmap.containskey(ldi)){
            
                        }else{
                        
                        leadidstoupdateQueue.add(ldi);
                        }
                     }
                            
            }    
            
                if(leadidstoupdateQueue.size()>0){
                    for(Lead lds:[select id,RecordTypeId,Ownerid from Lead where id IN:leadidstoupdateQueue]){
                    
                    lds.RecordTypeId=system.label.Ldm_rectpque;
                    lds.Ownerid=system.label.Ldm_queue;
                    ledstoupdate.add(lds);
                    }
                
                
                }    
                     if(LRMlist.size()>0){
                        update LRMlist;
                 }
            if(ledstoupdate.size()>0){
                update ledstoupdate;
            }
            
        }
       
    
    }
*/    
    // Code Ends for Partner Lead Routing
        
}