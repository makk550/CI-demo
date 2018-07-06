public class PLD_ProductCompetency_BkUp_04102018 
{
    
    public Map<Id,Map<id,Double>> Productcompetencyscoring(Map<lead,List<Account>> InputMap){
        
        System.debug('----InputMap-----'+InputMap);
        
        set<string> Lead_CBUset=new set<string>();
        set<id> leadAccsSet=new set<id>();
        Map<Id,Map<Id,Double>> OutputPcMap = new Map<Id,Map<Id,Double>>();
        list<pp_calculated_certification__x> pp_certificationlist=New List<pp_calculated_certification__x>();
        
        if(InputMap !=Null && InputMap.size()>0){
            
             for(Lead lds:InputMap.keySet()){
			       Lead_CBUset.add(lds.CSU_Driver__c);  
                   System.debug('--Lead_CBUset--'+Lead_CBUset);
             }
            
            pp_certificationlist=[select account_id__c,badge__c,product_name__c,resource_type__c 
                          from pp_calculated_certification__x where resource_type__c IN ('Sales','Pre-Sales','Implementation') 
                          and (badge__c='Proven Professional' OR badge__c='Certified Expert') 
                          and product_name__c IN:Lead_CBUset ];
            
            // ??? Shouldn't we get all active certifications ?????//
            
            
            System.debug('--pp_certificationlist---'+pp_certificationlist.size());
            // Map key= account id and value= list certifications of that account.
            Map<string,list<pp_calculated_certification__x>> CertyAccsMap=new Map<string,list<pp_calculated_certification__x>>();
            
            for(pp_calculated_certification__x pcc:pp_certificationlist){
                
                string acc_prodName=pcc.account_id__c +'_'+ pcc.product_name__c;
                                
                if(CertyAccsMap.containsKey(acc_prodName)){
                    list<pp_calculated_certification__x> accCrts=CertyAccsMap.get(acc_prodName);
                    accCrts.add(pcc);
                    CertyAccsMap.put(acc_prodName,accCrts);
                }
                else{
                    CertyAccsMap.put(acc_prodName,new list<pp_calculated_certification__x>{ pcc });
                }
            }
            
                        
            for(lead pc_lead:InputMap.keySet()){
                
                System.debug('--InputMap.keySet()--'+InputMap.keySet());
                
                List<account> LeadOAaccs=new List<account>();
                LeadOAaccs=InputMap.get(pc_lead);
                                
                if(LeadOAaccs != NULL && LeadOAaccs.size()>0){
                    
                  System.debug('---LeadOAaccs---'+LeadOAaccs.size());
                    
                    for(account pc_acc:InputMap.get(pc_lead)){
                        System.debug('---***trail_acc***---'+pc_acc);

                      List<pp_calculated_certification__x> CertList;
                    
                      if(OutputPcMap.containsKey(pc_lead.id)== false){
                        OutputPcMap.put(pc_lead.ID,New Map<id,double>{pc_acc.id =>0.0});
                          System.debug('--OutputPcMap false--'+OutputPcMap);
                      }
                    
                      string accid_ldProd=pc_acc.id+'_'+pc_lead.CSU_Driver__c;
                                         
                      if(CertyAccsMap.containsKey(accid_ldProd)){
                          CertList=new List<pp_calculated_certification__x>();
                          CertList=CertyAccsMap.get(accid_ldProd);
                          
                                       
                          if(CertList != null && CertList.size()>0){
                              //declaring all the local variables for scoring
                              Double Group1_CS=0;
                              Double Group2_NR=0;
                              Double Imp_sc=0; Double Sales_sc=0; Double PreSales_sc=0;
                              Double Atleast_One_PrvnProff=0;
                              Double Pc_totScore=0;
                              for(pp_calculated_certification__x pp_rec: CertList){
                                  
                                  if(pp_rec.resource_type__c=='Implementation'){
                                      Imp_sc=1;
                                  }
                                   if(pp_rec.resource_type__c=='Sales'){
                                      Sales_sc=1;
                                  }
                                   if(pp_rec.resource_type__c=='Pre-Sales'){
                                      PreSales_sc=1;
                                  }
                                  if(pp_rec.badge__c=='Proven Professional'){
                                      Atleast_One_PrvnProff=1;
                                  }
                                  
                              }
                              
                              //calculating Group1_CS score 
                              Group1_CS=Imp_sc+Sales_sc+PreSales_sc;
                              
                              //calculating Group1_CS score 
                              if(CertList.size() >= 3 && Atleast_One_PrvnProff == 1){
                                  Group2_NR=4;
                              }
                              else if(CertList.size() == 2 && Atleast_One_PrvnProff == 1){
                                     Group2_NR=3;
                                   }
                              else if(CertList.size() >= 2 && Atleast_One_PrvnProff == 0){
                                     Group2_NR=2;
                                   }
                              else if(CertList.size() == 1){
                                     Group2_NR=1;
                                   }
                              
                              //Calculating the total score
                              Pc_totScore= (Group1_CS+Group2_NR)/7.0;
                              
                            
                              OutputPcMap.get(pc_lead.id).put(pc_acc.id,Pc_totScore);
                          }
                          else{
                               OutputPcMap.get(pc_lead.ID).put(pc_acc.id,0.0);
                          }
                      
                      }
                      else{
                          OutputPcMap.get(pc_lead.ID).put(pc_acc.id,0.0);
                      }
                      
                      System.debug('------OutputPcMap-----'+OutputPcMap);
                     
                  } 
                }
            }
            
             return OutputPcMap;
        }
        else{
            return null;
        }
    
    }

}