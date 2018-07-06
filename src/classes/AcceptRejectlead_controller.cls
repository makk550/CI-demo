public class AcceptRejectlead_controller {
    public Lead currentlead{get;set;}
    public string leadid{get;set;}
    public set<id> Accidset{get;set;}
    public set<id> useridset{get;set;}
    public set<id> leadidset{get;set;}
    public boolean showhide{get;set;}
    public string showhiderej{get;set;}
    public Group queue{get;set;}
    public List<Account> accupdatelist{get;set;}
    
    Public AcceptRejectlead_controller(ApexPages.StandardController controller){
        leadid=ApexPages.currentPage().getParameters().get('id');
        
        System.debug('====leadid==='+leadid);
        system.debug('leadid=='+leadid);
        useridset=New set<id>();
        Accidset=New set<id>();
        leadidset=New set<id>();
        accupdatelist=New List<Account>();
        showhide=true;
          queue = [SELECT Id FROM Group WHERE DeveloperName ='Partner_lead_distribution' and Type='Queue' limit 1];
        //this.currentlead = (Lead)controller.getRecord();
        currentlead=[select id,Name,AcceptReject__c,Reason__c,mkto71_Lead_Score__c,Status,PartnerAcceptancedate__c,Reseller_Status__c,Ownerid,Rejection_Reason__c,Partnerleadprocessed__c  from Lead where id=:leadid];
                system.debug('currentlead=='+currentlead);
                if(currentlead.Status=='Pursuing' ){
                showhiderej='True';
                }
        system.debug('currentlead=Ownerid='+currentlead.Ownerid);
        if(string.valueOf(currentlead.OwnerId).startsWith('005')){
            system.debug('owner is user');
            useridset.add(currentlead.OwnerId);
        }
        system.debug('==useridset-size---'+useridset.size());
        if(useridset.size()>0 && !useridset.isEmpty()){
            for(User ur:[select id,Related_Partner_Account__c,Is_Partner_User__c from User where id IN:useridset ]){
                system.debug('---Related_Partner_Account__c----'+ur.Related_Partner_Account__c);
                if(ur.Related_Partner_Account__c!= Null && ur.Related_Partner_Account__c!=''){
                    Accidset.add(id.valueof(ur.Related_Partner_Account__c));
                }
                
            }
        }
        system.debug('==Accidset-size---'+Accidset.size());
        system.debug('==Accidset----'+Accidset);
        
        
    }
    
    PartnerLeadDistribution_AssignPartner ptrdidtibution=New PartnerLeadDistribution_AssignPartner();
    list<LeadRoutingMatrix__c> LRMlist=New List<LeadRoutingMatrix__c>();
    Map<id,Map<id,PLR_PartnerScore>> rejectionmap=New Map<id,Map<id,PLR_PartnerScore>>();
    Map<id,PLR_PartnerScore> innermap=New Map<id,PLR_PartnerScore>();
    
    public PageReference submit(){
        
        system.debug('---entered in method---');
        system.debug('AcceptReject__c==  '+currentlead.AcceptReject__c);
        system.debug('Reason__c==  '+currentlead.Rejection_Reason__c);
        system.debug('==Accidset----'+Accidset);
        if(currentlead.AcceptReject__c!=null){
            system.debug('in if condition');
            if(currentlead.AcceptReject__c=='Accept'){
                system.debug('in Accepted');
                currentlead.PartnerAcceptancedate__c=system.today();
                currentlead.Status='Pursuing';
                currentlead.Reseller_Status__c='Pursuing';
                //currentlead.RecordTypeId=system.label.Ldm_Partner;
                if(currentlead.mkto71_Lead_Score__c!= Null){
                    currentlead.LeadAssignmentScore__c=currentlead.mkto71_Lead_Score__c;
                }
                if(Accidset.size()>0){
                for(Account ac:[select id,PartnerLeadLastAcceprancedate__c from Account where id IN:Accidset]){
                    ac.PartnerLeadLastAcceprancedate__c=system.today();
                    accupdatelist.add(ac);
                }
                    for(LeadRoutingMatrix__c lr:[select id,Name,Partner_Account__c,Statuss__c,Partner_Lead__c from LeadRoutingMatrix__c where  Partner_Lead__c =:leadid and Partner_Account__c IN:Accidset]){
                                 lr.Statuss__c= 'Accepted';
                        LRMlist.add(lr);
                                }
                }
                
                currentlead.Rejection_Reason__c ='';
                system.debug('before Accepted update');
                update currentlead;
                system.debug('After Accepted update');
                if(accupdatelist.size()>0 && !Test.isRunningTest()){
                    update accupdatelist;
                }
                if(LRMlist.size()>0){
                update LRMlist;
                         }
             /*   
                String p = ApexPages.currentPage().getParameters().get('id');
                if(p != null){
                    PageReference pageRef = new PageReference('/'+p);
           			 return pageRef;
                } */
                system.debug('--Accepted condition ends--');  
            }
            else if(currentlead.AcceptReject__c=='Reject'){
                system.debug('in Rejected');
                if(currentlead.Rejection_Reason__c !=Null || currentlead.Rejection_Reason__c !='' || currentlead.Rejection_Reason__c !='--None--'){
                                    system.debug('in Rejected 2');
                    currentlead.Reseller_Status__c='Rejected';
                    currentlead.Status='Rejected';
                    system.debug('in Rejected Before update');
                   update currentlead;
                    system.debug('in Rejected After update');
                     if(Accidset.size()>0){
              			PLR_PartnerScore AccountScore = new PLR_PartnerScore();
                    for(LeadRoutingMatrix__c lr:[select id,Name,Partner_Account__c,Total_Account_Score_Reason__c,Rejection_Reason__c,Statuss__c,Partner_Lead__c,AccountScore__c 
                                                 from LeadRoutingMatrix__c where  Partner_Lead__c =:leadid  and RecordType.Name ='Account_Score']){
                       if(lr.Statuss__c=='Eligible' && lr.Statuss__c!='Assigned to Partner'){
                           AccountScore.SetPartnerScoreValue(lr.AccountScore__c );
                           AccountScore.SetPartnerScoreReason1(lr.Total_Account_Score_Reason__c );
                            innermap.put(lr.Partner_Account__c, AccountScore); 
                           //innermap.put(lr.Partner_Account__c, lr.AccountScore__c); 
                             rejectionmap.put(lr.Partner_Lead__c,innermap ); 
                        }
                        if(lr.Statuss__c=='Assigned to Partner'){
                        lr.Statuss__c= 'Rejected';
                        lr.Rejection_Reason__c=currentlead.Rejection_Reason__c;
                       LRMlist.add(lr);
                      }
                       
                                }
                    
                         if(rejectionmap.size()>0)
                         {
                         system.debug('in assigning to partner');
                              ptrdidtibution.SortAndAssignPartner(rejectionmap);  
                         } else{
                             //currentlead.RecordTypeId=system.label.Ldm_rectpque;
                             currentlead.ownerid=queue.id;
                             system.debug('in assigning to queue');
                             update currentlead;
                             system.debug('in assigning to queue after');
                         }   
                         
                          if(LRMlist.size()>0){
                                update LRMlist;
                         }
                   
                         
                }
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter Reason For Rejection'));
                        }
                
                
            }
            
                                showhide=false;            
        }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select Accept/Reject'));
                        }
     
        return null;
    }

    public void refresh(){
        
        
        
    }

}