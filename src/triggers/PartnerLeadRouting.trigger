trigger PartnerLeadRouting on Lead (before insert,before update,After update) {
   List<Lead> leadList = new List<Lead>();
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
  
    // Partner lead Disstribution - amili01
    // Below implements the reprocessing of lead, which are already processed might meet criteria in future
    if(Trigger.isbefore && Trigger.isupdate){
                
        for(Integer i=0;i<Trigger.new.size();i++)
        {            
            if(trigger.new[i].ownerid == Label.ldm_NewQueueId && trigger.new[i].PartnerBatchProcessed__c == true && trigger.new[i].Partnerleadprocessed__c == false ){
                                                
                if(trigger.new[i].mkto71_Lead_Score__c != trigger.old[i].mkto71_Lead_Score__c || trigger.new[i].CSU_Driver__c != trigger.old[i].CSU_Driver__c 
                   || trigger.new[i].Commercial_Account__r.GEO__c != trigger.old[i].Commercial_Account__r.GEO__c || trigger.new[i].Commercial_Account__r.Sales_Area__c  != trigger.old[i].Commercial_Account__r.Sales_Area__c 
                   || trigger.new[i].Commercial_Account__r.Sales_Region__c != trigger.old[i].Commercial_Account__r.Sales_Region__c ){
                       
                       trigger.new[i].PartnerBatchProcessed__c = false;
                       
                   } 
            }
            
        }
        
    }
    
     // Code Starts for Partner Lead Routing -Ponse01
           if(Trigger.isbefore && Trigger.isupdate){
        Map<id,string> partnerusermap=New Map<id,string>();
	
       
           
    
        for(Lead ld:Trigger.New){
    
            if(ld.OwnerId != null) {
    
                if(trigger.oldmap.get(ld.id).Owner.type=='Queue' && trigger.Newmap.get(ld.id).Owner.Type=='User') {
        
                    if( PartnerLeadDistribution_Utility.ispartneruser(trigger.Newmap.get(ld.id).Ownerid)){
                        ld.AssignmentDate__c =date.today();
                        ld.Status='Routed to Partner';
                        ld.Reseller_Status__c='Routed to Partner';
                        
                         ld.AssignmentDate__c =system.now();
                        
						Datetime date11,date22,date33;
					  date11= BusinessHours.nextStartDate(label.PLD_BusinessHrs, ld.AssignmentDate__c+1);
                      System.debug('----date 1--'+date11);
                      date22= BusinessHours.nextStartDate(label.PLD_BusinessHrs,date11+1);
                      System.debug('----date 2--'+date22);
                      date33= BusinessHours.nextStartDate(label.PLD_BusinessHrs, date22+1);
                      System.debug('----date 3--'+date33);  
                        ld.Date1__c=date11;
                        ld.Date2__c=date22;
                        ld.Date3__c=date33;
                       // ld.Date1__c=BusinessHours.addGmt('01m1h0000004D6V', ld.AssignmentDate__c, 86400000);
                        //ld.Date2__c=BusinessHours.addGmt('01m1h0000004D6V', ld.AssignmentDate__c, 172800000);
                       // ld.Date3__c=BusinessHours.addGmt('01m1h0000004D6V', ld.AssignmentDate__c, 259200000);
                        
                    }
                    
                }
                if(trigger.oldmap.get(ld.id).Status!='Marketing Nurture' && trigger.Newmap.get(ld.id).Status=='Marketing Nurture'){
                    system.debug('in marketing nurture');
                    ld.Previousleadowner__c=string.valueOf(trigger.oldmap.get(ld.id).OwnerId);
                   // ld.RecordTypeId=system.label.Ldm_rectpque;
                    
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
         for(LeadRoutingMatrix__c lr:[select id,Name,Partner_Account__c,Statuss__c,Partner_Lead__c,Total_Account_Score_Reason__c,AccountScore__c from LeadRoutingMatrix__c where  Partner_Lead__c IN :leadids and recordtype.developername=:'Account_Score']){
                        if(lr.Statuss__c=='Eligible' && lr.Statuss__c!='Assigned to Partner'){
                            AccountScore.SetPartnerScoreValue(lr.AccountScore__c );
                           AccountScore.SetPartnerScoreReason1(lr.Total_Account_Score_Reason__c );
                            innermap.put(lr.Partner_Account__c, AccountScore); 
                             rejectionmap.put(lr.Partner_Lead__c,innermap ); 
                        }
                        if(lr.Statuss__c=='Assigned to Partner'){
                        lr.Statuss__c= 'Rejected';
                       LRMlist.add(lr);
                      }
                       
                    }
            system.debug('rejectionmap---'+rejectionmap);
             if(rejectionmap.size()>0){
                    PartnerLeadDistribution_AssignPartner ptrdidtibution=New PartnerLeadDistribution_AssignPartner();
                    ptrdidtibution.SortAndAssignPartner(rejectionmap);
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
                    for(Lead lds:[select id,RecordTypeId,Ownerid,AssignmentDate__c,Date1__c,Date2__c,Date3__c from Lead where id IN:leadidstoupdateQueue]){
                    
                    lds.RecordTypeId=system.label.Ldm_rectpque;
                    lds.Ownerid=system.label.Ldm_queue;
                        lds.AssignmentDate__c =Null;
                     lds.Date1__c=Null;
                        lds.Date2__c=Null;
                        lds.Date3__c=Null;
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
    
    // Code Ends for Partner Lead Routing
        
}