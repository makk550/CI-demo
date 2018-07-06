public class ext_PartnerLeadRouting {
   
   public Map<String,id> que = new Map<String, Id>(); 
   public List<Lead> leads_DesginationProcess = new List<lead>();
   Public List<String> listTerritory = new List<String>();
   public void matchPLRR(List<Lead> leadList){
     List<String> listBU     = new List<String>();
     List<String> listNCV    = new List<String>();
     List<String> listRTM    = new List<String>();
     List<String> listRTMType= new List<String>();
     List<String> listRTMDesignation= new List<String>();
     List<String> listSegment= new List<String>();
     listTerritory= new List<String>();
     List<Partner_Lead_Routing_Rules__c> listPLRR = new List<Partner_Lead_Routing_Rules__c>();
     
     system.debug('leadList:'+leadList);
      for(Lead l: leadList){
        listBU.add(l.Mkt_BU_Category__c);
        system.debug('listBU');
        
        listNCV.add(l.MKT_Solution_Set__c);
        system.debug('listNCV');
        
        listRTM.add(l.Lead_RTM__c);
        system.debug('listRTM');
        
        listRTMDesignation.add(l.Lead_RTM_Designation__c);
        system.debug('listRTMDesignation');
        
        listRTMType.add(l.Lead_RTM_Type__c);
        system.debug('listRTMType');
        
        listSegment.add(l.Segment__c);
        system.debug('listSegment');
        
        listTerritory.add(l.Sales_Territory__c);
        system.debug('listTerritory');
      }
      Date currentDate = system.today();
     
      
      listPLRR = [SELECT Id,BU__c,NCV_Driver__c,Product_Group__c,Tie_Breaker_Rule__c,Territory_Region__c,
                                                            Account_RTM__c,Account_RTM_Type__c,Account_RTM_Designation__c,RTM__c,RTM_Type__c 
                                                            from Partner_Lead_Routing_Rules__c
                                                            where (((BU__c in: listBU OR BU__c = NULL )
                                                            and (NCV_Driver__c in: listNCV OR NCV_Driver__c = NULL))
                                                            OR ((RTM__c in: listRTM OR RTM__c = NULL )))
                                                            AND (Territory_Region__c in: listTerritory AND Territory_Region__c!=NULL)
                                                            AND (Segment__c in: listSegment AND Segment__c!=NULL)
                                                            AND (Rule_Start_Date__c  <= : currentDate 
                                                            AND Rule_Expiration_Date__c >= : currentDate)];                                                                                        
                                                           
                   
     for(Partner_Lead_Routing_Rules__c plr: listplrr)
         System.debug('_______each plr:' +plr.id);
                                                                
     if(listPLRR.size()>0)
        leadRouting_BUNCV(leadList,listPLRR,'NO');
                
  }
   
 //PRM 4 - Req#59.05,#80.00  
   public List<lead> leadRouting_BUNCV(List<Lead> leadList,List<Partner_Lead_Routing_Rules__c> listPLRR,String DML_Needed){

    System.debug('___leadList'+leadList);
    System.debug('___listPLRR'+listPLRR);
    System.debug('___DML_Needed'+DML_Needed);

      List<String> listBU_PLRR = new List<String>();
      List<String> listProductGroup_PLRR= new List<String>();
      List<Lead>   Leads_RTM  = new List<lead>();
      Map<String,Partner_Lead_Routing_Rules__c> strVSPLRR = new Map<String,Partner_Lead_Routing_Rules__c>();
         
      try{
            que.put(QueueCust__c.getInstance('Common Partner Lead Pool').Name,QueueCust__c.getInstance('Common Partner Lead Pool').Queue_ID__c);
            que.put(QueueCust__c.getInstance('Partner Admin').Name,QueueCust__c.getInstance('Partner Admin').Queue_ID__c);  
      }catch(Exception e){
            System.debug('___Exception while fetching custom settings');
      }
   
     
     if(listPLRR.size()>0){
            String strBU_PLRR = NULL;
            String strNCV_PLRR= NULL;
            for(Partner_Lead_Routing_Rules__c plrr: listPLRR){
               listBU_PLRR.add(plrr.BU__c);
               listProductGroup_PLRR.add(plrr.Product_Group__c);
               strBU_PLRR = plrr.BU__c != NULL ? plrr.BU__c : 'NULL';
               strNCV_PLRR= plrr.NCV_Driver__c!= NULL ? plrr.NCV_Driver__c:'NULL';
            
               strVSPLRR.put(strBU_PLRR +'||'+strNCV_PLRR,plrr);
              
            }
            List<Product_Alignment__c> listPAlignment = [SELECT BU__c,Business_Unit__c,Product_Group__c,Related_Account__c,
                                                        Related_Account__r.Lead_Champion__c,Related_Account__r.Last_Accepted_Lead_Date__c,
                                                        Related_Account__r.Lead_Routing_Score__c,Related_Account__r.Sales_Region__c 
                                                        from Product_Alignment__c 
                                                        where (Business_Unit__c in: listBU_PLRR AND Business_Unit__c!= NULL) 
                                                        and (Product_Group__c in: listProductGroup_PLRR AND Product_Group__c!= NULL) 
                                                        and (Related_Account__r.Lead_Champion__c != null AND Related_Account__r.Lead_Champion__c!='')];
            
            system.debug('listPAlignment:'+listPAlignment);                                         
                                                        
            Map<String,List<Product_Alignment__c>> strVSpAlignment = new Map<String,List<Product_Alignment__c>>(); 
            String strBU_PA = null;
            String strProductGroup_PA = null;
            if(listPAlignment !=null && listPAlignment.size()>0)
            
            system.debug('listPAlignmentSize:'+listPAlignment.size());
            
            for(Product_Alignment__c pa: listPAlignment){
               strBU_PA = pa.Business_Unit__c != NULL ? pa.Business_Unit__c : 'NULL';
               strProductGroup_PA= pa.Product_Group__c!= NULL ? pa.Product_Group__c:'NULL';
            
               if(strVSpAlignment.containsKey(strBU_PA +'||'+strProductGroup_PA)){
                 strVSpAlignment.get(strBU_PA +'||'+strProductGroup_PA).add(pa);
               }else{
                 strVSpAlignment.put(strBU_PA +'||'+strProductGroup_PA,new List<Product_Alignment__c>());
                 strVSpAlignment.get(strBU_PA +'||'+strProductGroup_PA).add(pa);
               }
            }
            
            String matchBU = NULL;
            String matchNCV = NULL;
            for(Lead l: leadList){
                matchBU = l.Mkt_BU_Category__c!= NULL? l.Mkt_BU_Category__c : 'NULL';
                matchNCV = l.MKT_Solution_Set__c != NULL ? l.MKT_Solution_Set__c: 'NULL';
                
                
                if(strVSPLRR.containsKey(matchBU+'||'+matchNCV) && strVSPLRR.get(matchBU+'||'+matchNCV) != null){
                  
                   Partner_Lead_Routing_Rules__c plr= strVSPLRR.get(matchBU+'||'+matchNCV);
                   String matchAccounts = (plr.BU__c != NULL? plr.BU__c:'NULL')+'||'+ (plr.Product_Group__c != NULL?plr.Product_Group__c:'NULL');
                  
                  if(strVSpAlignment.containsKey(matchAccounts) && strVSpAlignment.get(matchAccounts).size()==1){
                   System.debug('____one relevant acc found for lead');
                      Id leadChampion = strVSpAlignment.get(matchAccounts)[0].Related_Account__r.Lead_Champion__c;
                      if(leadChampion != NULL)                    
                                l.OwnerId = leadChampion ;
                   }
                   else if(strVSpAlignment.containsKey(matchAccounts) && strVSpAlignment.get(matchAccounts).size()>1){
                   System.debug('____multiple relevant accs found for lead');
                          if(plr.tie_breaker_Rule__c == 'Round Robin'){
                           System.debug('__tb__round robin');
                             Date dt=null;
                             integer iter =1;
                             for( Product_Alignment__c pAlign : strVSpAlignment.get(matchAccounts)){
                                System.debug('__palign id___'+pAlign.Id);
                                System.debug('__iter___'+iter);

                                System.debug('_____dt1___'+dt);
                                System.debug('_____dt2___'+pAlign.Related_Account__r.Last_Accepted_Lead_Date__c);
                                System.debug('_____dt3___'+pAlign.Related_Account__r.Sales_Region__c);
                                System.debug('_____dt4___'+l.Sales_Territory__c);
                                
                                if(dt == null){
                                 System.debug('__5555');
                                  //DEFECT:60489-MOVED TO INNER FOR - TADKR01 --  dt = pAlign.Related_Account__r.Last_Accepted_Lead_Date__c;
                                    if(pAlign.Related_Account__r.lead_champion__c <> null && pAlign.Related_Account__r.Sales_Region__c == l.Sales_Territory__c){
                                          dt = pAlign.Related_Account__r.Last_Accepted_Lead_Date__c;
                                        l.ownerId = pAlign.Related_Account__r.lead_champion__c;
                                        System.debug('___in if');
                                    }
                                }
                                else if(pAlign.Related_Account__r.Last_Accepted_Lead_Date__c != null && dt>pAlign.Related_Account__r.Last_Accepted_Lead_Date__c && pAlign.Related_Account__r.Sales_Region__c == l.Sales_Territory__c){
                                   System.debug('__6666');
                                    dt = pAlign.Related_Account__r.Last_Accepted_Lead_Date__c;
                                    if(pAlign.Related_Account__r.lead_champion__c <> null)
                                        l.ownerId = pAlign.Related_Account__r.lead_champion__c;
                                        System.debug('___in else');
                                }
                                System.debug('___lead owner____'+l.ownerId);
                                iter++;
                             }
                           }
                           else if(plr.tie_breaker_Rule__c == 'Score'){
                           System.debug('_tb___score');
                              Decimal score=null;
                              List<Product_Alignment__c> For_tiedPartneracc = new List<Product_Alignment__c>();
                              
                              for(Product_Alignment__c pAlign:strVSpAlignment.get(matchAccounts)){
                                if(score==null){
                                    score = pAlign.Related_Account__r.Lead_Routing_Score__c;
                                    For_tiedPartneracc.add(pAlign);                            
                                }
                                if(pAlign.Related_Account__r.Lead_Routing_Score__c > score){
                                    For_tiedPartneracc.clear();
                                    score = pAlign.Related_Account__r.Lead_Routing_Score__c;
                                    For_tiedPartneracc.add(pAlign);
                                }
                                else if(pAlign.Related_Account__r.Lead_Routing_Score__c == score){
                                    For_tiedPartneracc.add(pAlign);
                                }
                              }
                               Date dtlocal = null;
                              for(Product_Alignment__c a:For_tiedPartneracc){
                                if(dtlocal == null){
                                    dtlocal = a.Related_Account__r.Last_Accepted_Lead_Date__c;
                                    if(a.Related_Account__r.lead_champion__c <> null && a.Related_Account__r.Sales_Region__c == l.Sales_Territory__c)
                                        l.ownerId = a.Related_Account__r.Lead_Champion__c;                                      
                                }else if(dtlocal > a.Related_Account__r.Last_Accepted_Lead_Date__c && a.Related_Account__r.Sales_Region__c == l.Sales_Territory__c){
                                    dtlocal = a.Related_Account__r.Last_Accepted_Lead_Date__c;
                                    if(a.Related_Account__r.lead_champion__c <> null)
                                        l.ownerId = a.Related_Account__r.Lead_Champion__c;                                          
                                }
                              }
                           }else if(plr.tie_breaker_Rule__c == 'Shark Tank' && que.get('Common Partner Lead Pool') != NULL){
                           System.debug('__tb__shark tank');
                                l.ownerId = que.get('Common Partner Lead Pool');
                                
                           }else if(plr.tie_breaker_Rule__c == 'Manual' && que.get('Partner Admin') != NULL){
                            System.debug('__tb__manual');
                                l.ownerId = que.get('Partner Admin');
                           }
                       }
                   
                }
                else if(!(strVSPLRR.containsKey(matchBU+'||'+matchNCV)) || strVSPLRR.get(matchBU+'||'+matchNCV) == null){
                     Leads_RTM.add(l);
                }
            }
            leadRouting_RTM(Leads_RTM,listPLRR);
      }
      if(DML_Needed == 'YES'){
        List<Lead> modifiedleads = new List<lead>();
        modifiedleads.addAll(leadList);
        if(Leads_RTM.size()>0)
            modifiedleads.addAll(Leads_RTM);        
        return modifiedleads;
      }
      else
        system.debug('EnteringElsePart');
        return null;
   }
   
 // PRM 4 - Req#79.00,#80.00
   public void leadRouting_RTM(List<Lead> RTMLeads,List<Partner_Lead_Routing_Rules__c> listPLRR){
   System.debug('__RTM_method call entry');
     
            List<String> listactRTM_PLRR = new List<String>();
            List<String> listactRTMType_PLRR= new List<String>();
            Map<String,Partner_Lead_Routing_Rules__c> strVSPLRR = new Map<String,Partner_Lead_Routing_Rules__c>();
            String strRTM_PLRR = NULL;
            String strRTMType_PLRR= NULL;
            for(Partner_Lead_Routing_Rules__c plrr: listPLRR){
            System.debug('____list plrr id____'+plrr.Id);
            System.debug('____list plrr id____'+plrr.Account_RTM__c);
               listactRTM_PLRR.add(plrr.Account_RTM__c); 
               listactRTMType_PLRR.add(plrr.Account_RTM_Type__c);
               
               strRTM_PLRR = plrr.RTM__c != NULL ? plrr.RTM__c : 'NULL';
               strRTMType_PLRR= plrr.RTM_Type__c!= NULL ? plrr.RTM_Type__c:'NULL';
            
               strVSPLRR.put(strRTM_PLRR +'||'+strRTMType_PLRR,plrr);   
               
               strRTM_PLRR = plrr.BU__c != NULL ? plrr.BU__c : 'NULL';
               strRTMType_PLRR = plrr.NCV_Driver__c != NULL ? plrr.NCV_Driver__c : 'NULL';  
                
                strVSPLRR.put(strRTM_PLRR +'||'+strRTMType_PLRR,plrr);         
            }
            
            List<Account> accList= new List<Account>();
            List<Account> accList1= new List<Account>();
            
            if(listterritory.size()==0)
                for(Lead l: RTMLeads)
                    listTerritory.add(l.Sales_Territory__c);
            
            try{
             System.debug('______list territory:'+listterritory);  

            //Modified the query to make it as selective by adding extra filter condition (ownerId in:accOwners) to avoid Non selective SOQL exception.
            
            String[] accOwners = System.Label.Partner_Account_Generic_Owners.split(',');
            
            accList = [SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c 
                      from Account 
                      where RecordType.Name ='Reseller/Distributor Account' 
                      and Sales_Region__c in: listTerritory 
                      and (Enterprise_Id__c like 'PE%' OR Enterprise_Id__c like 'RL%' OR Enterprise_Id__c like 'RN%')
                      and (((Alliance__c = true and  Alliance_Type__c in :listactRTMType_PLRR 
                      and Service_Provider_Type__c != null)
                      OR (Service_Provider__c = true and Service_Provider_Type__c in :listactRTMType_PLRR and Service_Provider_Type__c != null)
                      OR (Solution_Provider__c = true and Solution_provider_Type__c in :listactRTMType_PLRR and Solution_provider_Type__c != null)
                      OR (Velocity_seller__C = true and Velocity_Seller_Type__c in :listactRTMType_PLRR and Velocity_Seller_Type__c != null))) 
                      and ownerId in:accOwners];
                                                                                                                                                          
            accList1 = [SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c 
                        from Account 
                        where RecordType.Name ='Reseller/Distributor Account' 
                        and Sales_Region__c in: listTerritory 
                        and (Enterprise_Id__c like 'PA%' OR Enterprise_Id__c like 'PJ%' OR Enterprise_Id__c like 'PL%' OR Enterprise_Id__c like 'PN%' OR Enterprise_Id__c like 'PW%')
                        and (((Alliance__c = true and  Alliance_Type__c in :listactRTMType_PLRR and Service_Provider_Type__c != null) 
                        OR (Service_Provider__c = true and Service_Provider_Type__c in :listactRTMType_PLRR and Service_Provider_Type__c != null) 
                        OR (Solution_Provider__c = true and Solution_provider_Type__c in :listactRTMType_PLRR and Solution_provider_Type__c != null) 
                        OR (Velocity_seller__C = true and Velocity_Seller_Type__c in :listactRTMType_PLRR and Velocity_Seller_Type__c != null))) 
                        and ownerId in:accOwners];       
 
            
            
            accList.addAll(accList1);
            }catch(NullPointerException e){
            accList = new List<Account>();
            accList1 = new List<Account>();
               System.debug('______Exception occured while retrieving the acc list:'+e.getMessage());              
            }
            
            for(Account a: accList){
               System.debug('   '+a.Id);
            }
            
            Map<String,List<Account>> mapRTMAccounts = new Map<String,List<Account>>();
            
            for(Account acc: accList){
                String accRTM = acc.RTM__c!= NULL?acc.RTM__c:'NULL';
                String accRTMType = acc.RTM_Type__c != NULL ? acc.RTM_Type__c:'NULL';
                if(mapRTMAccounts.containsKey(accRTM+'||'+accRTMType)){
                    mapRTMAccounts.get(accRTM+'||'+accRTMType).add(acc);
                }
                else{
                    mapRTMAccounts.put(accRTM+'||'+accRTMType,new List<Account>());
                    mapRTMAccounts.get(accRTM+'||'+accRTMType).add(acc);
                }
            }
            String RTM_lead = null;
            String RTMType_lead = null;   
            String BU_lead = null;
            String NCV_lead = null;
            String matchAccounts = NULL;
            for(Lead l: RTMLeads){
                RTM_lead = l.Lead_RTM__c != NULL ? l.Lead_RTM__c : 'NULL';
                RTMType_lead = l.Lead_RTM_Type__c != NULL ? l.Lead_RTM_Type__c : 'NULL';
                BU_lead = l.Mkt_BU_Category__c != NULL ? l.Mkt_BU_Category__c : 'NULL';
                NCV_lead = l.Mkt_Solution_Set__c != NULL ? l.Mkt_Solution_Set__c : 'NULL';
                
                Partner_Lead_Routing_Rules__c plr = strVSPLRR.containsKey(RTM_lead+'||'+RTMType_lead)?strVSPLRR.get(RTM_lead+'||'+RTMType_lead):strVSPLRR.containsKey(BU_lead+'||'+NCV_lead)?strVSPLRR.get(BU_lead+'||'+NCV_lead):new Partner_Lead_Routing_Rules__c();
               
                matchAccounts = (plr.Account_RTM__c !=NULL?plr.Account_RTM__c:'NULL') + '||' + (plr.Account_RTM_Type__c !=NULL?plr.Account_RTM_Type__c:'NULL');
          
                
            if(plr.Account_RTM_Type__c != null )/* && mapRTMAccounts.containsKey(matchAccounts)*/{
                    Integer count_rtm = 0;
                    leads_DesginationProcess = new List<lead>();
                    for(String s:mapRTMAccounts.keyset()){
                     if(s.contains(plr.Account_RTM__c) && s.contains(plr.Account_RTM_Type__c) && count_rtm == 0){
                        if(mapRTMAccounts.get(s).size()==1 && mapRTMAccounts.get(s)[0].Lead_Champion__c != null){
                            l.OwnerId = mapRTMAccounts.get(s)[0].Lead_Champion__c;
                            count_rtm = 1;
                        }// END - ONE PARTNER ACCOUNT.
                        else if(mapRTMAccounts.get(s).size()>1  && count_rtm == 0){
                            if(plr.tie_breaker_Rule__c == 'Round Robin'){
                             Date dt=null;
                             for( Account acc : mapRTMAccounts.get(s)){
                                if(dt == null && acc.Last_Accepted_Lead_Date__c != null){
                                    dt = acc.Last_Accepted_Lead_Date__c;
                                    if(acc.lead_champion__c <> null){
                                        l.ownerId = acc.lead_champion__c;
                                        count_rtm = 1;
                                    }
                                }
                                else if(acc.Last_Accepted_Lead_Date__c != null && ( dt>acc.Last_Accepted_Lead_Date__c)){
                                    dt = acc.Last_Accepted_Lead_Date__c;
                                    if(acc.lead_champion__c <> null){
                                        l.ownerId = acc.lead_champion__c;
                                        count_rtm = 1;
                                    }
                                }
                             }
                           }
                           else if(plr.tie_breaker_Rule__c == 'Score'){
                             System.debug('___score RTM meth');
                              Decimal score=null;
                              List<Account> For_tiedPartneracc = new List<Account>();
                              
                              for(Account acc:mapRTMAccounts.get(s)){
                                if(score==null){
                                    score = acc.Lead_Routing_Score__c;
                                    For_tiedPartneracc.add(acc);                            
                                }
                                if(acc.Lead_Routing_Score__c > score){
                                    For_tiedPartneracc.clear();
                                    score = acc.Lead_Routing_Score__c;
                                    For_tiedPartneracc.add(acc);
                                }
                                else if(acc.Lead_Routing_Score__c == score){
                                    For_tiedPartneracc.add(acc);
                                }
                              }
                               Date dtlocal = null;
                              for(Account a:For_tiedPartneracc){
                                if(dtlocal == null){
                                    dtlocal = a.Last_Accepted_Lead_Date__c;
                                    if(a.lead_champion__c <> null){
                                        l.ownerId = a.Lead_Champion__c;
                                        count_rtm = 1;
                                    } 
                                }else if(dtlocal > a.Last_Accepted_Lead_Date__c){
                                    dtlocal = a.Last_Accepted_Lead_Date__c;
                                    if(a.lead_champion__c <> null){
                                        l.ownerId = a.Lead_Champion__c;
                                        count_rtm = 1;
                                    } 
                                }
                             }
                           }else if(plr.tie_breaker_Rule__c == 'Shark Tank' && que.get('Common Partner Lead Pool') != null){
                            System.debug('____shark tank____');
                                l.ownerId = que.get('Common Partner Lead Pool');
                                count_rtm = 1;
                           }else if(plr.tie_breaker_Rule__c == 'Manual' && que.get('Partner Admin') != NULL){
                            System.debug('____manual____');
                                l.ownerId = que.get('Partner Admin');
                                count_rtm = 1;
                           }
                           
                        }// END - MULTIPLE PARTNER ACCOUNTS.
                       
                        }
                        else{
                            leads_DesginationProcess.add(l);
                        }
                        
                    }
           //END - Commented out as another method for designation is introduced.  
              }else{
                leads_DesginationProcess.add(l);
              }
            
            }
            if(leads_DesginationProcess.size()>0)
                  system.debug('listPLRR:'+listPLRR);
                  leadRouting_RTMDesignation(leads_DesginationProcess,listPLRR);
    }
    
    
    
       //PRM 4 - Leads Mgmt - Req 81.00
       public void leadRouting_RTMDesignation(List<Lead> RTMLeads,List<Partner_Lead_Routing_Rules__c> listPLRR){
                List<String> listactRTM_PLRR = new List<String>();
                List<String> listactRTMDesignation_PLRR= new List<String>();
                Map<String,Partner_Lead_Routing_Rules__c> strVSPLRR = new Map<String,Partner_Lead_Routing_Rules__c>();
                String strRTM_PLRR = NULL;
                String strRTMDesignation_PLRR= NULL;
                
                system.debug('listPLRRuuuuu'+listPLRR);
                String AccountRTM;    
                
                for(Partner_Lead_Routing_Rules__c plrr: listPLRR){
                   listactRTM_PLRR.add(plrr.Account_RTM__c);

                   system.debug('listactRTM_PLRR:'+listactRTM_PLRR);
                   //AccountRTM='(';
                   AccountRTM = listactRTM_PLRR[0];
                   
                   if(AccountRTM == '(null)' || AccountRTM == null)
                   AccountRTM='';

                   system.debug('AccountRTMLst'+AccountRTM);      
                   try{
                      listactRTMDesignation_PLRR.addAll(plrr.Account_RTM_Designation__c.split(';',0));
                   }catch(Exception e){
                      listactRTMDesignation_PLRR= new List<String>();
                   }
                   strRTM_PLRR = plrr.RTM__c != NULL ? plrr.RTM__c : 'NULL';
                   strRTMDesignation_PLRR= plrr.Account_RTM_Designation__c!= NULL ? plrr.Account_RTM_Designation__c:'NULL';
                
                   strVSPLRR.put(strRTM_PLRR +'||'+strRTMDesignation_PLRR,plrr);   
                   
                   strRTM_PLRR = plrr.BU__c != NULL ? plrr.BU__c : 'NULL';
                   strRTMDesignation_PLRR = plrr.NCV_Driver__c != NULL ? plrr.NCV_Driver__c : 'NULL';  
                    
                    strVSPLRR.put(strRTM_PLRR +'||'+strRTMDesignation_PLRR,plrr);         
                }
              
               
              String designationsList = '(';
                System.debug('___desgn list_1___'+designationsList);
                Integer flag_Loop = 0;
              for(String s:listactRTMDesignation_PLRR){
                designationsList+='\''+s+'\''+',';
                flag_Loop++;
              }
              
              System.debug('___desgn list_2___'+designationsList);
              designationsList = designationsList.subString(0,designationsList.length()-1);
              
              System.debug('___desgn list__3__'+designationsList);
              designationsList+=')';
              
              if(designationsList.length() <3)
                designationsList = '(\'\')';
                System.debug('___desgn list__4__'+designationsList);
               System.debug('___desgn list____'+designationsList);
           
               String acc_query;    
               integer ActualLimit = limits.getLimitQueryRows();
               integer ReturnedLimit = limits.getQueryRows();
               
               system.debug('ReturnedLimit'+ReturnedLimit+'ActualLimit'+ActualLimit);
              
               system.debug('designationsList:'+designationsList);
               system.debug('StringValue:'+'(\'\')');

              string strQueryId = '01230000000GaFdAAK';
              system.debug('strQueryId:'+strQueryId);
              if(designationsList!= '(\'\')' && designationsList!= null){
                  acc_query = 'SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c,Alliance_Designation__c,'+
                  'Service_Provider_Designation__c,Solution_provider_Designation__c,Velocity_Seller_Designation__c from Account where '+
                  '(recordtypeid = \''+strQueryId+'\') '+
                  'AND ((RTM__c LIKE \'%'+AccountRTM+'%\' AND Alliance__c = true AND Alliance_Designation__c includes '+designationsList+') OR '+
                  '(RTM__c LIKE \'%'+AccountRTM+'%\' AND Velocity_seller__c = true AND Velocity_Seller_Designation__c includes '+designationsList+' ) OR '+
                  '(RTM__c LIKE \'%'+AccountRTM+'%\' AND Solution_Provider__c = true AND Solution_Provider_Designation__c includes'+designationsList+' ) OR '+
                  '(RTM__c LIKE \'%'+AccountRTM+'%\' AND Service_Provider__c = true AND Service_Provider_Designation__c includes '+designationsList+' )) '+
                  'ORDER BY CreatedDate DESC limit 5000';
                  system.debug('Satisfied');
                  system.debug('acc_query:'+acc_query);
              }
              else if(AccountRTM!='' && AccountRTM!= NULL) {
                  acc_query = 'SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c,Alliance_Designation__c,'+
                  'Service_Provider_Designation__c,Solution_provider_Designation__c,Velocity_Seller_Designation__c from Account where '+
                  '(recordtypeid = \''+strQueryId+'\') '+
                  'AND ((RTM__c LIKE \'%'+AccountRTM+'%\' AND Alliance__c = true ) OR '+
                  '(RTM__c LIKE \'%'+AccountRTM+'%\' AND Velocity_seller__c = true ) OR '+
                  '(RTM__c LIKE \'%'+AccountRTM+'%\' AND Solution_Provider__c = true ) OR '+
                  '(RTM__c LIKE \'%'+AccountRTM+'%\' AND Service_Provider__c = true )) '+
                  'ORDER BY CreatedDate DESC limit 5000';
                  system.debug('Not Satisfied');
                  system.debug('acc_query2:'+acc_query);
              }
            
            /* String query_acc = 'SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c,Alliance_Designation__c,Service_Provider_Designation__c,Solution_provider_Designation__c,Velocity_Seller_Designation__c from Account where (Alliance__c = true OR Service_Provider__c = true OR Solution_Provider__c = true OR Velocity_seller__C = true)' +
              'and Alliance_Designation__c includes '+designationsList;
               
              System.debug('___query_acc____'+query_acc);*/
              
              
                if(AccountRTM!='' && AccountRTM!= NULL) {
                    List<Account> accList = database.query(acc_query);
                    
            /*
                if(test.isrunningtest())
                {
                acc_query = 'SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c,Alliance_Designation__c,Service_Provider_Designation__c,Solution_provider_Designation__c,Velocity_Seller_Designation__c from Account where Id = \'0013000000Nwk0mAAB\'';
                              
                               
                              accList = database.query(acc_query);
                }
                
                else
                {
                acc_query = 'SELECT Name,Lead_Champion__c,RTM__c,RTM_Type__c,Last_Accepted_Lead_Date__c,Lead_Routing_Score__c,Alliance_Designation__c,Service_Provider_Designation__c,Solution_provider_Designation__c,Velocity_Seller_Designation__c from Account where (Enterprise_Id__c like \'RA%\' OR Enterprise_Id__c like \'RL%\'  OR Enterprise_Id__c like \'P%\') AND (Alliance__c = true OR Service_Provider__c = true OR Solution_Provider__c = true OR Velocity_seller__c = true) ' +
                              ' and Alliance_Designation__c includes '+designationsList+' ORDER BY CreatedDate DESC NULLS LAST LIMIT 5000';
                               
                              accList = database.query(acc_query);
                }           
            */      
                    system.debug('TestaccList2:'+accList);
                            
                       Map<String,List<Account>> mapRTMAccounts = new Map<String,List<Account>>();
                       system.debug('accList:'+accList.size());
                       for(Account acc: accList){
                            String accRTM = acc.RTM__c!= NULL?acc.RTM__c:'NULL';
                            String accRTMDesignation = acc.Alliance_Designation__c+';'+acc.Service_Provider_Designation__c+';'+acc.Solution_Provider_Designation__c+';'+acc.Velocity_Seller_Designation__c;
                            system.debug('accRTMDesignation'+accRTMDesignation);
                            
                            if(mapRTMAccounts.containsKey(accRTM+'||'+accRTMDesignation)){
                                mapRTMAccounts.get(accRTM+'||'+accRTMDesignation).add(acc);
                            }
                            else{
                                mapRTMAccounts.put(accRTM+'||'+accRTMDesignation,new List<Account>());
                                mapRTMAccounts.get(accRTM+'||'+accRTMDesignation).add(acc);
                            }
                        }

                String RTM_lead = null;
                String RTMType_lead = null;   
                String RTMDesignation_lead = null;   
                String BU_lead = null;
                String NCV_lead = null;
                String matchAccounts = NULL;
                for(Lead l: RTMLeads){
                    RTM_lead = l.Lead_RTM__c != NULL ? l.Lead_RTM__c : 'NULL';
                    RTMType_lead = l.lead_rtm_type__c != NULL ? l.lead_rtm_type__c : 'NULL';
                    RTMDesignation_lead = l.Lead_RTM_Designation__c != NULL ? l.Lead_RTM_Designation__c : 'NULL';
                    BU_lead = l.Mkt_BU_Category__c != NULL ? l.Mkt_BU_Category__c : 'NULL';
                    NCV_lead = l.Mkt_Solution_Set__c != NULL ? l.Mkt_Solution_Set__c : 'NULL';
                    
                    Partner_Lead_Routing_Rules__c plr = strVSPLRR.containsKey(RTM_lead+'||'+RTMType_lead)?strVSPLRR.get(RTM_lead+'||'+RTMType_lead):strVSPLRR.containsKey(BU_lead+'||'+NCV_lead)?strVSPLRR.get(BU_lead+'||'+NCV_lead):new Partner_Lead_Routing_Rules__c();
                //TO BE REMOVED
                
                    matchAccounts = (plr.Account_RTM__c !=NULL?plr.Account_RTM__c:'NULL') + '||' + (plr.Account_RTM_Type__c !=NULL?plr.Account_RTM_Type__c:'NULL');
                
                       if(plr.Account_RTM_Designation__c != null){
                        Integer count_rtm = 0;
                        for(String s:mapRTMAccounts.keyset()){
                         if(s.contains(plr.Account_RTM__c) && s.contains(plr.Account_RTM_Designation__c) && count_rtm == 0){
                            if(mapRTMAccounts.get(s).size()==1 && mapRTMAccounts.get(s)[0].Lead_Champion__c != null){
                                system.debug('MapSize'+mapRTMAccounts.get(s).size());
                            
                                List<User> Lstuser = new list<user>();
                                string str = string.valueOf(mapRTMAccounts.get(s)[0].Lead_Champion__c);
                                set<ID> UserIDSet = new set<ID>();
                                UserIDSet.add(str);
                                
                                system.debug('strstrstr:'+str);
                                
                                Lstuser = [Select ID, Name, IsActive From user Where IsActive = true AND ID IN :UserIDSet];
                                                                        
                                if(Lstuser.size()>0)
                                {
                                    l.OwnerId = mapRTMAccounts.get(s)[0].Lead_Champion__c;
                                    system.debug('EnteringIF_OwnerID:'+l.OwnerId);
                                    count_rtm = 1;
                                    system.debug('EnteringIF:');
                                }
                            }// END - ONE PARTNER ACCOUNT.
                            
                            else if(mapRTMAccounts.get(s).size()>1){
                                if(plr.tie_breaker_Rule__c == 'Round Robin'){
                                    System.debug('____round robin____');
                                 Date dt=null;
                                 for( Account acc : mapRTMAccounts.get(s)){
                                    if(dt == null && acc.Last_Accepted_Lead_Date__c != null){
                                        dt = acc.Last_Accepted_Lead_Date__c;
                                        system.debug('acc.lead_champion__c:');
                                        if(acc.lead_champion__c <> null){
                                            l.ownerId = acc.lead_champion__c;
                                            system.debug('l.ownerId'+l.ownerId);
                                            count_rtm = 1;
                                        }
                                    }
                                    else if(acc.Last_Accepted_Lead_Date__c != null && dt>acc.Last_Accepted_Lead_Date__c){
                                        system.debug('Debugging:');
                                        dt = acc.Last_Accepted_Lead_Date__c;
                                        system.debug('acc.lead_champion__c1:');
                                        if(acc.lead_champion__c <> null){
                                            l.ownerId = acc.lead_champion__c;
                                            system.debug('l.ownerId22'+l.ownerId);
                                            count_rtm = 1;
                                       }
                                    }
                                 }
                               }
                               else if(plr.tie_breaker_Rule__c == 'Score'){
                                System.debug('____score____');
                                  Decimal score=null;
                                  List<Account> For_tiedPartneracc = new List<Account>();
                                  
                                  for(Account acc:mapRTMAccounts.get(s)){
                                    if(score==null){
                                        score = acc.Lead_Routing_Score__c;
                                        For_tiedPartneracc.add(acc); 
                                        system.debug('For_tiedPartneracc:'+For_tiedPartneracc);                           
                                    }
                                    if(acc.Lead_Routing_Score__c > score){
                                        For_tiedPartneracc.clear();
                                        score = acc.Lead_Routing_Score__c;
                                        For_tiedPartneracc.add(acc);
                                        system.debug('For_tiedPartneracc2:'+For_tiedPartneracc);
                                    }
                                    else if(acc.Lead_Routing_Score__c == score){
                                        For_tiedPartneracc.add(acc);
                                        system.debug('For_tiedPartneracc3:'+For_tiedPartneracc);
                                    }
                                  }
                                   Date dtlocal = null;
                                  for(Account a:For_tiedPartneracc){
                                    if(dtlocal == null){
                                        dtlocal = a.Last_Accepted_Lead_Date__c;
                                        if(a.lead_champion__c <> null){
                                            l.ownerId = a.Lead_Champion__c;
                                            system.debug('ForOwnerID:'+For_tiedPartneracc);
                                            count_rtm = 1;
                                        } 
                                    }else if(dtlocal > a.Last_Accepted_Lead_Date__c){
                                        dtlocal = a.Last_Accepted_Lead_Date__c;
                                        if(a.lead_champion__c <> null){
                                            l.ownerId = a.Lead_Champion__c;
                                            system.debug('ForOwnerID2:'+For_tiedPartneracc);
                                            count_rtm = 1;
                                        } 
                                    }
                                 }
                               }else if(plr.tie_breaker_Rule__c == 'Shark Tank' && que.get('Common Partner Lead Pool') != null){
                                System.debug('____shark tank____');
                                    l.ownerId = que.get('Common Partner Lead Pool');
                                System.debug('l.ownerId::'+l.ownerId);
                                    count_rtm = 1;
                               }else if(plr.tie_breaker_Rule__c == 'Manual' && que.get('Partner Admin') != NULL){
                                System.debug('____manual____');
                                    l.ownerId = que.get('Partner Admin');
                                System.debug('l.ownerId:::'+l.ownerId);
                                    count_rtm = 1;
                               }
                               
                            }// END - MULTIPLE PARTNER ACCOUNTS.
                            
                            }
                            
                        }
                        
           }
           else if(plr.Account_RTM_Designation__c == null){
            system.debug('Entering Account_RTM_Designation__c :');
                       integer count = 0;
                       for(String actKey:mapRTMAccounts.keySet()){
                            if(actKey.split('||',0)[0] == plr.Account_RTM__c && count == 0){
                                system.debug('entering actKey.split:');
                                try{                                               
                                    if(mapRTMAccounts.get(actKey).size()==1 && mapRTMAccounts.get(actKey)[0].Lead_Champion__c != null){
                                        system.debug('Entering mapRTMAccounts:');
                                        l.OwnerId = mapRTMAccounts.get(actKey)[0].Lead_Champion__c;
                                    }// END - ONE PARTNER ACCOUNT.
                                    else if(mapRTMAccounts.get(actKey).size()>1){
                                        system.debug('Entering mapRTMAccountsss:');
                                        if(plr.tie_breaker_Rule__c == 'Round Robin'){
                                         Date dt=null;
                                         for( Account acc : mapRTMAccounts.get(actKey)){
                                            if(dt == null){
                                                dt = acc.Last_Accepted_Lead_Date__c;
                                                system.debug('acc.lead_champion__c'+acc.lead_champion__c);
                                                if(acc.lead_champion__c <> null)
                                                    l.ownerId = acc.lead_champion__c;
                                                    system.debug('Owner ID'+l.ownerId);
                                            }
                                            else if(acc.Last_Accepted_Lead_Date__c != null && dt>acc.Last_Accepted_Lead_Date__c){
                                                dt = acc.Last_Accepted_Lead_Date__c;
                                                if(acc.lead_champion__c <> null)
                                                    system.debug('OwnerID::');
                                                    l.ownerId = acc.lead_champion__c;
                                            }
                                         }
                                       }
                                       else if(plr.tie_breaker_Rule__c == 'Score'){
                                          Decimal score=null;
                                          List<Account> For_tiedPartneracc = new List<Account>();
                                          
                                          for(Account acc:mapRTMAccounts.get(actKey)){
                                            if(score==null){
                                                score = acc.Lead_Routing_Score__c;
                                                For_tiedPartneracc.add(acc);
                                                system.debug('For_tiedPartneracc1');                            
                                            }
                                            if(acc.Lead_Routing_Score__c > score){
                                                For_tiedPartneracc.clear();
                                                score = acc.Lead_Routing_Score__c;
                                                For_tiedPartneracc.add(acc);
                                                system.debug('For_tiedPartneracc2');
                                            }
                                            else if(acc.Lead_Routing_Score__c == score){
                                                For_tiedPartneracc.add(acc);
                                                system.debug('For_tiedPartneracc3');
                                            }
                                          }
                                           Date dtlocal = null;
                                          for(Account a:For_tiedPartneracc){
                                            if(dtlocal == null){
                                                dtlocal = a.Last_Accepted_Lead_Date__c;
                                                if(a.lead_champion__c <> null)
                                                    l.ownerId = a.Lead_Champion__c; 
                                                    system.debug('a.Lead_Champion__c:'+a.Lead_Champion__c);
                                            }else if(dtlocal > a.Last_Accepted_Lead_Date__c){
                                                dtlocal = a.Last_Accepted_Lead_Date__c;
                                                if(a.lead_champion__c <> null)
                                                    l.ownerId = a.Lead_Champion__c; 
                                                    system.debug('a.Lead_Champion__c1:'+a.Lead_Champion__c);
                                            }
                                         }
                                       }else if(plr.tie_breaker_Rule__c == 'Shark Tank' && que.get('Common Partner Lead Pool') != NULL){
                                            l.ownerId = que.get('Common Partner Lead Pool');
                                            system.debug('Common Partner Lead Pool:'+l.ownerId);
                                       }else if(plr.tie_breaker_Rule__c == 'Manual' && que.get('Partner Admin') != NULL){
                                            l.ownerId = que.get('Partner Admin');
                                            system.debug('Partner Admin'+l.ownerId);
                                       }
                                    }// END - MULTIPLE PARTNER ACCOUNTS.
                                    else if(mapRTMAccounts.get(actKey).size() == 0){
                                        
                                    }// END - NO PARTNER ACCOUNTS.
                                
                                    count = 1;  
                                    }catch(Exception e){
                                    count = 0;
                                    }
                      }
                    }
           }
                   
                }
                }
       }
       @isTest(seeAllData=true)
       public static void testRoutingExt(){
            Ext_PartnerLeadRouting ObjPLR = new Ext_PartnerLeadRouting();
            
            Partner_Lead_Routing_Rules__c pl = new Partner_Lead_Routing_Rules__c();
            pl.BU__c = 'Alliance';
            pl.NCV_Driver__c = 'RM Other';
            pl.RTM__c = 'Service Provider';
            pl.RTM_Type__c = 'CSP';
            pl.Account_RTM__c = 'Alliance';
            pl.Account_RTM_Type__c = 'Reseller';
            pl.Tie_Breaker_Rule__c = 'Round Robin';
            pl.Rule_Start_Date__c = System.today()-2;
            pl.Rule_Expiration_Date__c= System.today()+2;
            pl.Territory_Region__c = 'NO_GREATLAKES';
            insert pl;
            
         
            
            List<Lead> lList1 = [select OwnerId,Mkt_BU_Category__c,MKT_Solution_Set__c,Lead_RTM__c,Lead_RTM_Designation__c,Lead_RTM_Type__c,Segment__c,Sales_Territory__c 
                                from lead 
                                where (MKT_Solution_Set__c!= NULL AND MKT_Solution_Set__c = 'RM Other') 
                                and (Sales_Territory__c!= NULL AND Sales_Territory__c= 'NO_GREATLAKES') 
                                and (segment__c = null) 
                                limit 5];
            
            objPLR.matchPLRR(lList1);
            
            pl.Tie_Breaker_Rule__c = 'Score';
            update pl;
            objPLR.matchPLRR(lList1);
            List<Lead> lList2 = [select OwnerId,Mkt_BU_Category__c,MKT_Solution_Set__c,Lead_RTM__c,Lead_RTM_Designation__c,Lead_RTM_Type__c,Segment__c,Sales_Territory__c 
                                from lead 
                                where (Lead_RTM__c != NULL AND Lead_RTM__c = 'Service Provider') 
                                and (Lead_RTM_Type__c!= NULL AND Lead_RTM_Type__c = 'CSP') 
                                and (Sales_Territory__c!=NULL AND Sales_Territory__c= 'NO_GREATLAKES') 
                                and (segment__c = null) 
                                limit 5];
            
            objPLR.matchPLRR(lList2);
            
            pl.Tie_Breaker_Rule__c = 'Shark Tank';
            update pl;
            
            objPLR.matchPLRR(lList1);
            objPLR.matchPLRR(lList2);
            
            pl.Tie_Breaker_Rule__c = 'Shark Tank';
            update pl;
            
            objPLR.matchPLRR(lList1);
            objPLR.matchPLRR(lList2);
            
            
       }
}