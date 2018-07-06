global class PLD_ProductCompetency {
    
   global list<pp_calculated_certification__x> pp_certificationlist=New List<pp_calculated_certification__x>();
    
    //This method is only meant for test class PLD_ProductCompetency_Test - 90%
    public void setpplst(list<pp_calculated_certification__x> pplst){
        pp_certificationlist=pplst;
    }
    
    
    public Map<Id,Map<id,PLR_PartnerScore>> Productcompetencyscoring(Map<lead,List<Account>> InputMap){
        
        System.debug('----InputMap-----'+InputMap);
        
        set<string> Lead_CBUset=new set<string>();
        set<id> leadAccsSet=new set<id>();
        Map<Id,Map<Id,PLR_PartnerScore>> OutputPcMap = new Map<Id,Map<Id,PLR_PartnerScore>>();
        
        
        if(InputMap !=Null && InputMap.size()>0){
            
             for(Lead lds:InputMap.keySet()){
			       Lead_CBUset.add(lds.CSU_Driver__c);  
                   System.debug('--Lead_CBUset--'+Lead_CBUset);
             }
           
            
            if(!Test.isRunningTest()){
            // LPAC external DB stores only active certifications related to fiscal year.
            pp_certificationlist=[select account_id__c,badge__c,product_name__c,resource_type__c 
                          from pp_calculated_certification__x where resource_type__c IN ('Sales','Pre-Sales','Implementation') 
                          and (badge__c='Proven Professional' OR badge__c='Certified Expert') 
                          and product_name__c IN:Lead_CBUset ];
            }
         
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
				      PLR_PartnerScore ProductCompetencyScore = new PLR_PartnerScore();
                      List<pp_calculated_certification__x> CertList;
                    
                      if(OutputPcMap.containsKey(pc_lead.id)== false)
                      {
                        Map<Id,PLR_PartnerScore> MapToInit =  New Map<id,PLR_PartnerScore>();
                        ProductCompetencyScore.SetPartnerScoreValue(0.00);
                        MapToInit.put(pc_acc.id, ProductCompetencyScore);
                        OutputPcMap.put(pc_lead.ID, MapToInit);
                        //OutputPcMap.put(pc_lead.ID,New Map<id,double>{pc_acc.id =>0.0});
                          System.debug('--OutputPcMap false--'+OutputPcMap);
                      }
                    
                      string accid_ldProd=pc_acc.id+'_'+pc_lead.CSU_Driver__c;
                                         
                      if(CertyAccsMap.containsKey(accid_ldProd)){
                          CertList=new List<pp_calculated_certification__x>();
                          CertList=CertyAccsMap.get(accid_ldProd);
                          
                                       
                          if(CertList != null && CertList.size()>0){
                              //declaring all the local variables for scoring
                              PLR_PartnerScore Group1_CS = new PLR_PartnerScore();
                              PLR_PartnerScore Group2_NR = new PLR_PartnerScore();
                              Decimal CompetencySpread = 0.00;
                              Decimal Imp_sc=0.00; Decimal Sales_sc=0.00; Decimal PreSales_sc=0.00;
                              Decimal Atleast_One_PrvnProff=0.00;
                              Decimal Pc_totScore=0.00;
                              for(pp_calculated_certification__x pp_rec: CertList){
                                  
                                  if(pp_rec.resource_type__c=='Implementation'){
                                      Imp_sc=1.00;
                                  }
                                   if(pp_rec.resource_type__c=='Sales'){
                                      Sales_sc=1.00;
                                  }
                                   if(pp_rec.resource_type__c=='Pre-Sales'){
                                      PreSales_sc=1.00;
                                  }
                                  if(pp_rec.badge__c=='Proven Professional'){
                                      Atleast_One_PrvnProff=1.00;
                                  }
                                  
                              }
                              
                              //calculating Group1_CS score 
                              CompetencySpread = (Imp_sc+Sales_sc+PreSales_sc).setScale(2);
                              
                              if ( CompetencySpread == 3.00)
                              {
                                  Group1_CS.SetPartnerScoreValue( CompetencySpread ); 
                                  Group1_CS.SetPartnerScoreReason1('Competency Spread Score = ' + CompetencySpread +
                                                                   ' ( The partner has certified resources in all roles, (Implementation, Sales & Pre-Sales) for the given product )');
                              }
                              else if ( CompetencySpread == 2.00 )
                              {
                                  Group1_CS.SetPartnerScoreValue( CompetencySpread ); 
                                  Group1_CS.SetPartnerScoreReason1('Competency Spread Score = ' + CompetencySpread +
                                                                   ' ( The partner has certified resources in 2 of the 3 roles, (Implementation, Sales & Pre-Sales) for the given product )');
                              }
                              else if ( CompetencySpread == 1.00 )
                              {
                                  Group1_CS.SetPartnerScoreValue( CompetencySpread ); 
                                  Group1_CS.SetPartnerScoreReason1('Competency Spread Score = ' + CompetencySpread +
                                                                   ' ( The partner has certified resources in 1 of the 3 roles, (Implementation, Sales & Pre-Sales) for the given product )');
                              }
                              else
                              {
                                  Group1_CS.SetPartnerScoreValue( CompetencySpread ); 
                                  Group1_CS.SetPartnerScoreReason1('Competency Spread Score = ' + CompetencySpread +
                                                                   ' ( The partner has no certified resources in any of the 3 roles, (Implementation, Sales & Pre-Sales) for the given product )');
                              }
                              
                              //calculating Group2_NR score 
                              if(CertList.size() >= 3 && Atleast_One_PrvnProff == 1.00){
                                      Group2_NR.SetPartnerScoreValue( 4.00 ); 
                                      Group2_NR.SetPartnerScoreReason1('Number Of Resources Score = 4.00' +
                                                                       ' ( The partner has 3 or more certified resources with at least 1 Proven Professional for the given product )');
                              }
                              else if(CertList.size() == 2 && Atleast_One_PrvnProff == 1.00){
                                      Group2_NR.SetPartnerScoreValue( 3.00 ); 
                                      Group2_NR.SetPartnerScoreReason1('Number Of Resources Score = 3.00' +
                                                                       ' ( The partner has 2 certified resources with at least 1 Proven Professional for the given product )');
                                   }
                              else if(CertList.size() >= 2 && Atleast_One_PrvnProff == 0.00){
                                      Group2_NR.SetPartnerScoreValue( 2.00 ); 
                                      Group2_NR.SetPartnerScoreReason1('Number Of Resources Score = 2.00' +
                                                                       ' ( The partner has at least 2 certified resources but no Proven Professional for the given product )');
                                   }
                              else if(CertList.size() == 1){
                                      Group2_NR.SetPartnerScoreValue( 1.00 ); 
                                      Group2_NR.SetPartnerScoreReason1('Number Of Resources Score = 1.00' +
                                                                       ' ( The partner has 1 certified resources but no Proven Professional for the given product )');
                                   }
                              
                              //Calculating the total score
                              Pc_totScore= ((Group1_CS.GetPartnerScoreValue()+Group2_NR.GetPartnerScoreValue())/7.00).setScale(2);
                              
                			  ProductCompetencyScore.SetPartnerScoreValue( Pc_totScore );
                              ProductCompetencyScore.SetPartnerScoreReason1(Group1_CS.GetPartnerScoreReason1());
                              ProductCompetencyScore.SetPartnerScoreReason2(Group2_NR.GetPartnerScoreReason1());
                              ProductCompetencyScore.SetPartnerScoreReason3('Product Competency Score = ' + Pc_totScore +
                                                                            ' ( (Competency Spread Score + Number Of Resources Score)/7 )' );
                            
                              OutputPcMap.get(pc_lead.id).put(pc_acc.id,ProductCompetencyScore);
                          }
                          else{
                        	  ProductCompetencyScore.SetPartnerScoreValue( 0.00 );
                              ProductCompetencyScore.SetPartnerScoreReason1('Competency Spread Score = 0.00' +
                                                            				' ( No certificatiopn data exists for this partner on the given product )');
                              ProductCompetencyScore.SetPartnerScoreReason2('Number Of Resources Score = 0.00' +
                                                            				' ( No certificatiopn data exists for this partner on the given product )');
                              ProductCompetencyScore.SetPartnerScoreReason3('Product Competency Score = 0.00' +
                                                            				' ( No certificatiopn data exists for this partner on the given product )');
                               OutputPcMap.get(pc_lead.ID).put(pc_acc.id,ProductCompetencyScore);
                          }
                      
                      }
                      else{
                        	  ProductCompetencyScore.SetPartnerScoreValue( 0.00 ); 
                              ProductCompetencyScore.SetPartnerScoreReason1('Competency Spread Score = 0.00' +
                                                            				' ( No certificatiopn data exists for this partner on the given product )');
                              ProductCompetencyScore.SetPartnerScoreReason2('Number Of Resources Score = 0.00' +
                                                            				' ( No certificatiopn data exists for this partner on the given product )');
                              ProductCompetencyScore.SetPartnerScoreReason3('Product Competency Score = 0.00' +
                                                            				' ( No certificatiopn data exists for this partner on the given product )');
                          OutputPcMap.get(pc_lead.ID).put(pc_acc.id,ProductCompetencyScore);
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