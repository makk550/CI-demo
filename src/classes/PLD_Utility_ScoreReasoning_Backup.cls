public class PLD_Utility_ScoreReasoning_Backup {
    

    Map<id,lead> ThresholdFitLeads=new Map<id,lead>();
    List<Lead> DeDupFitLeads=new List<Lead>();
    List<Account> AccountList=new List<Account>();
   
    
    //// AUTHOR: AMILI01  
    Public PLD_Utility_ScoreReasoning_Backup(){
        
    }
    
    Public PLD_Utility_ScoreReasoning_Backup(list<lead> Batch_LeadList){
         
      System.debug('------------------**************PartnerLeadDistribution_Utility***************-------start--cpu time--'+limits.getCpuTime());
/*        
       list<lead> LeadList=[select id,EAID__c,Commercial_Account__r.Region_Country__c,mkto71_Lead_Score__c,Commercial_Account__r.Sales_Area__c,Commercial_Account__r.GEO__c,Commercial_Account__r.Sales_Region__c,CSU_Driver__c from Lead 
                  where Segment1__c!=Null 
                   and CSU_Driver__c != NULL 
                  and Commercial_Account__r.Region_Country__c!= null 
                  and mkto71_Lead_Score__c!=null and Commercial_Account__r.Sales_Area__c!=null 
                  and Commercial_Account__r.GEO__c != null and Commercial_Account__r.Sales_Region__c !=null 
                  and OwnerId IN (select Id from Group where Type = 'Queue' AND Name = 'Partner Lead Distribution' ) limit 248];
*/        
        //Initializing the Leadlist with the leads from the batch class
       List<Lead> LeadList=Batch_LeadList;
       System.debug('----Lead list count----'+LeadList.size());
        
           
          if(LeadList != Null && LeadList.size()>0)
        {
            Map<id,Lead> TH_InputMap=new Map<id,Lead>(LeadList);
                                  
            //filter the leads which satisfy the threshold limits
            ThresholdFitLeads=ThresholdFitLeadsMethod(TH_InputMap);
            System.debug('--ThresholdFitLeads- utility-'+ThresholdFitLeads.size());
            System.debug('--lead ids--'+ThresholdFitLeads.keySet());
          
        }
                    
         if(ThresholdFitLeads != NULL && ThresholdFitLeads.size()>0)
        {
            System.debug('-----ThresholdFitLeads------'+ThresholdFitLeads.size());
           //System.debug('---lead keys---'+ThresholdFitLeads.keySet());
            
            //remove the duplicate leads 
            DeDupFitLeads = checkforduplicates(ThresholdFitLeads); 
            System.debug('---DeDupFitLeads-----'+DeDupFitLeads.size());
            
                    
        }
        
         if(DeDupFitLeads != NULL && DeDupFitLeads.size()>0)
        {
             System.debug('---DeDupFitLeads-----'+DeDupFitLeads.size());
    
            //Score the accounts for concern leads
            AccountScoring(DeDupFitLeads);
            
        }
    }
    
   
     ///// USERSTORY: US407324 [Lead Routing Rules - Threshold ] 
    ///// AUTHOR: AMILI01 
     public Map<id,lead> ThresholdFitLeadsMethod(Map<id,lead> TH_leadsMap)
    {
             
        System.debug('------------------**************ThresholdFitLeadsMethod***************-------start cpu time--'+Limits.getCpuTime());
         Map<id,lead> tempMap=new Map<id,lead>();
         List<LeadRoutingMatrix__c> LRMList=new List<LeadRoutingMatrix__c>();
         List<lead> TH_LeadList=new List<lead>();
        
        TH_LeadList.addAll(TH_leadsMap.values());
       
             //Querying records from LeadRoutingMatrix as this Object contains Threshold values
               LRMList= PartnerLeadDistribution_DynamicSOQL.getLRMList();
               System.debug('--LRMList size----'+LRMList.size());
        
                if(LRMList != NULL && LRMList.size() >0)
                {
                   for(Lead lead_a:TH_LeadList)
                   {
                     for(LeadRoutingMatrix__c LRM_a:LRMList)
                     {
                                             
                         if(lead_a.mkto71_Lead_Score__c >= LRM_a.LeadScore__c )
                         {
                             
                             if(lead_a.CSU_Driver__c == LRM_a.Business_Unit__c)
                             {
                                // System.debug('--lead_a.id--'+lead_a.id +'---LRM---'+LRM_a.id+'--lead_a.CSU_Driver__c---'+lead_a.CSU_Driver__c);
                                 if(lead_a.Commercial_Account__r.GEO__c == LRM_a.GEO__c)
                                 {
                                   //  System.debug('--lead_a.Commercial_Account__r.GEO__c---'+lead_a.Commercial_Account__r.GEO__c);
                                  if(lead_a.Commercial_Account__r.Sales_Area__c == LRM_a.Operating_Area__c || lead_a.Commercial_Account__r.Sales_Region__c == LRM_a.Sales_Region__c  )   
                                  {
                                      
                                     if(tempMap.containsKey(lead_a.id)== false)
                                     {
                                       tempMap.put(lead_a.id,lead_a);
                                         break;
                                     }
                                  }
                                 }
                             }
                             
                         }
                     }
                   }
                }
        System.debug('------------------**************ThresholdFitLeadsMethod***************-------end cpu time--'+Limits.getCpuTime());
            return tempMap;
        
    }
    
      ///// END OF USERSTORY: US407324 [Lead Routing Rules - Threshold ]  AUTHOR: AMILI01 
      
     //to find the duplicates in leads
        public set<Lead> Finalleads{get;set;}
        public list<Lead> Finalleadlist{get;set;}
        public  List<Lead> CleanLeadlist{get;set;}
        public  List<Lead> dupLeadlist{get;set;}
        public  List<Lead> Historicalleads=New List<Lead>();
    public list<lead> checkforduplicates(Map<id,Lead> TLeadList){
        System.debug('------------------**************checkforduplicates***************-------start-'+Limits.getCpuTime());
        system.debug('entered check for duplicates');
       
        List<Lead> ThresholdLeadList=new List<Lead>();
        ThresholdLeadList.addAll(TLeadList.values());
        
       //for(lead ld:TLeadList.values()) {
        //  ThresholdLeadList.add(ld); }
        
            system.debug('--LeadList--'+ThresholdLeadList);
            Finalleads=New Set<Lead>();
            Finalleadlist=new List<Lead>();
            set<id> accids=New set<id>();
            set<id> leadids=New set<id>();
            set<string> CBUdriverset=New set<string>();
            Map<string,Lead> mapcsuLead=new Map<string,Lead>();
            Map<id,Lead> mapcaccountLead=new Map<id,Lead>();
        Map<id,Map<string,Lead>> mapcaccountLead1=new Map<id,Map<string,Lead>>();
            Map<string,Opportunity> mapcsuopp=new Map<string,Opportunity>();
            Map<id,Opportunity> mapcaccountopp=new Map<id,Opportunity>();
            
        for(lead ld:ThresholdLeadList){
            leadids.add(ld.id);
            if(ld.Commercial_Account__c !=Null){
                accids.add(ld.Commercial_Account__c);
            }
            if(ld.CSU_Driver__c !=Null && ld.CSU_Driver__c !=''){
                CBUdriverset.add(ld.CSU_Driver__c);
            }
        }
       // system.debug('--accids----'+accids+'---size---'+accids.size());
       // system.debug('--CBUdriverset----'+CBUdriverset+'---size---'+CBUdriverset.size());
        if(accids.size()>0 && CBUdriverset.size()>0){
                Historicalleads=[select id,Name,CSU_Driver__c,Commercial_Account__c,EAID__c from Lead where Commercial_Account__c IN:accids And CSU_Driver__c IN:CBUdriverset and id Not IN:leadids limit 5000];
         //   system.debug('--Historicalleads--'+Historicalleads.size());
            for(lead led:Historicalleads){
                mapcaccountLead.put(led.Commercial_Account__c,led);
                mapcsuLead.put(led.CSU_Driver__c,led);
                mapcaccountLead1.put(led.Commercial_Account__c, mapcsuLead);
            }
          //  system.debug('--mapcaccountLead1-size-'+mapcaccountLead1.size());
          //  system.debug('--mapcaccountLead1--'+mapcaccountLead1);
           // system.debug('--mapcsuLead--'+mapcsuLead);
                list<Opportunity> opplist=[select id,name,Sales_Milestone_Search__c,Type,Service_Provider_Client__c,Accountid,Account.name,(select Product2id,Product2.Name,Product2.CSU_Driver__c from Opportunitylineitems where Product2.CSU_Driver__c IN:CBUdriverset) from opportunity where StageName in ('Deal Reg - Pending','10% - Identification & Qualification','20% - Researching','40% - Plan Confirmed','60% - Initial Proposal','80% - Preliminary Agreement','90% - Agreement Finalized')and (Accountid IN:accids OR Service_Provider_Client__c IN:accids)];     
        
            for(Opportunity opt:opplist){
                if(opt.Type=='xSP'){
                    mapcaccountopp.put(opt.Service_Provider_Client__c,opt);
                }else{
                mapcaccountopp.put(opt.Accountid,opt); 
                }
           
                for(Opportunitylineitem optl:opt.Opportunitylineitems){
                    mapcsuopp.put(optl.Product2.Name,opt);
                }
            }
        }     
        
            CleanLeadlist=New List<Lead>();
            dupLeadlist=New List<Lead>();
            system.debug('ThresholdLeadList--'+ThresholdLeadList);
            system.debug('ThresholdLeadList--'+ThresholdLeadList.size());
            Map<string,lead> csumap=New Map<string,lead>();
            for(Lead cld:ThresholdLeadList){
              //  system.debug('cld.Commercial_Account__c---'+cld.Commercial_Account__c);
              //  system.debug('----'+mapcaccountLead1.get(cld.Commercial_Account__c));
              //  system.debug('----'+mapcaccountLead1.containsKey(cld.Commercial_Account__c));
                if(mapcaccountLead1.containsKey(cld.Commercial_Account__c)){
                    
                    csumap=mapcaccountLead1.get(cld.Commercial_Account__c);
                    if(csumap.containsKey(cld.CSU_Driver__c)){
                        dupLeadlist.add(cld);
                    }else{
                   // system.debug('---Duplicate Lead doesent exists---');
                    CleanLeadlist.add(cld);
                } 
                } else{
                   // system.debug('---Duplicate Lead doesent exists---');
                    CleanLeadlist.add(cld);
                } 
                    if(mapcaccountopp.containsKey(cld.Commercial_Account__c) && mapcsuopp.containsKey(cld.CSU_Driver__c)){
                        
                       dupLeadlist.add(cld); 
                        
                    }else{
                        //system.debug('---Duplicate opps doesent Exsists---');
                    CleanLeadlist.add(cld);
                }                  
                           
            }
           // system.debug('dupLeadlist--'+dupLeadlist);
           // system.debug('CleanLeadlist--'+CleanLeadlist);
            Finalleads.addAll(CleanLeadlist); 
            system.debug('----finalleads----------'+Finalleads+'------'+Finalleads.size());
           
            Finalleadlist.addAll(Finalleads);
           // system.debug('Finalleadlist--'+Finalleadlist);
             
        System.debug('------------------**************checkforduplicates***************-------END-'+Limits.getCpuTime());
            return  Finalleadlist;
        }
    
    ///// USERSTORY : US397434 [Lead Routing Rules - Territory/Region]
    ///// AUTHOR : AMILI01
    Public void AccountScoring(List<Lead> FitLeads)
    {
        System.debug('------------------**************AccountScoring***************-------start cpu time---'+Limits.getCpuTime());
        Map<ID,Map<Id,PLR_PartnerScore>> AllPartnerScoresMap = new Map<ID,Map<Id,PLR_PartnerScore>>();
        Map<ID,Map<Id,PLR_PartnerScore>> AllLoyaltyHistoricalScoreMap = new Map<ID,Map<Id,PLR_PartnerScore>>();
        Map<ID,Map<Id,PLR_PartnerScore>> AllProductCompetencyScoreMap = new Map<ID,Map<Id,PLR_PartnerScore>>();
        Map<ID,Map<Id,PLR_PartnerScore>> AllTotalAccountScoreMap = new Map<ID,Map<Id,PLR_PartnerScore>>();
        Map<lead,List<Account>> OAFitAccountsMap=new  Map<lead,List<Account>>();
        List<Account> OAtempAccLst;
        
        List<LeadRoutingMatrix__c> InsertLRMList=new List<LeadRoutingMatrix__c>();
        set<String> leadGeos =new set<String>();
        
        LeadRoutingMatrix__c lrm;
        LeadRoutingMatrix__c InsertLRM=new LeadRoutingMatrix__c();
        
        
        for(lead l:Fitleads)
        {
            leadGeos.add(l.Commercial_Account__r.GEO__c);
        }
        
        System.debug('---lead GEOS----'+leadGeos);
        
        Date curdate=Date.today();
        String fiscalYear;
        if(curdate.month()>0 && curdate.month()<4)
        {
            fiscalYear='FY '+curdate.year();
        }
        else
        {
            Integer i;
            i=curdate.year()+1;
            fiscalYear='FY '+i;
        }

        List<String> ProgramLevelList = new List<String>{'Global','Focus','Premier','Member','Advanced'};
       	List<account> AccountList =[select 	id,
                                   			GEO__c,
                                   			Enterprise_ID__c,
                                   			PartnerOperatingArea__c,
                                   			Alliance_Program_Level__c,
                                   			Service_Provider_Program_level__c,
                                   			Solution_Provider_Program_Level__c,
                      						(	select Plan_Fiscal_Year__c,Status__c  
                                             	from Business_Plans__r 
                       							where 	Plan_Fiscal_Year__c=:fiscalYear and 
                                             			Status__c='CA & Partner Approved' )
                      				from 	Account 
                      				where 	RecordType.Name='Reseller/Distributor Account' and 
                            				PartnerOperatingArea__c != null and 
                            				Lead_Champion__c != null and 
                            				GEO__c in : leadGeos and
                                   			Enterprise_ID__c LIKE 'P%' and
                      						(	Alliance_Program_Level__c 			in :ProgramLevelList or 
                                                Service_Provider_Program_level__c 	in :ProgramLevelList or 
                                                Solution_Provider_Program_Level__c 	in :ProgramLevelList
                            				) ];
 
        	//Solution_Provider__c = TRUE and 
          System.debug('----Accounts size----'+AccountList.size());
          System.debug('******* CPU time after Accounts retrieved ---------'+Limits.getCpuTime());
  
          if(AccountList != NULL && AccountList.size()>0)
          {
            // Account Elimination Criteria 
            // the account PartnerOperatingArea__c and Geo matching with lead's account region and lead's geo are stored in OAFitAccountsMap
            for(Lead ld:FitLeads )
            {
                OAtempAccLst=new List<Account>();
                for(Account ac:AccountList)
                {
                                       
                    String str=ac.PartnerOperatingArea__c;
                    String[] partnerOpArea=str.split(';');
                    //system.debug('--account-and geo--'+ac.PartnerOperatingArea__c +'---ac.GEO__c--'+ac.GEO__c+'--lead----'+ld.Commercial_Account__r.Region_Country__c+'----'+ld.Commercial_Account__r.GEO__c);
                    // ac.PartnerOperatingArea__c == ld.Commercial_Account__r.Region_Country__c
                    if( partnerOpArea.contains(ld.Commercial_Account__r.Region_Country__c) && ac.GEO__c == ld.Commercial_Account__r.GEO__c) //match PartnerOperatingArea__c as well !!
                    {
                       OAtempAccLst.add(ac);  
                      //System.debug('---account ID----'+ac.id);
                    }
                }
                if(OAtempAccLst != Null && OAtempAccLst.size()>0)
                {
                   OAFitAccountsMap.put(ld,OAtempAccLst);                  
                }

                System.debug('-lead---'+ ld.id +'---OAtempAccLst size---'+OAtempAccLst.size());            
               
            }

          
            System.debug('---------------++++++++++++++++++++++++++++++++++---------------------');            
            System.debug('------OAFitAccountsMap size---'+OAFitAccountsMap.size());            
            System.debug('---------------++++++++++++++++++++++++++++++++++---------------------');            
            ///// USERSTORY : US422240 [Partner Lead Routing - Determine total score] 
            ///// AUTHOR : AMILI01              
           
            if(OAFitAccountsMap != NULL && OAFitAccountsMap.size() >0)
            {
                //P.P.S
          		System.debug('******* CPU time before CalculatePartnerProgramScore ---------'+Limits.getCpuTime());
                AllPartnerScoresMap=CalculatePartnerProgramScore(OAFitAccountsMap);
                System.debug('-----AllPartnerScoresMap----size---'+AllPartnerScoresMap.size());
                
                // L. H
                System.debug('--------queries before LoyaltyHistoricalScore---------'+Limits.getQueries());
          		System.debug('******* CPU time before calculateLHScore ---------'+Limits.getCpuTime());
                AllLoyaltyHistoricalScoreMap = calculateLHScore(OAFitAccountsMap);  
               System.debug('--------queries after LoyaltyHistoricalScore---------'+Limits.getQueries());
               System.debug('--------CPU time after LoyaltyHistoricalScore---------'+Limits.getCpuTime());
               System.debug('-----AllLoyaltyHistoricalScoreMap-------'+AllLoyaltyHistoricalScoreMap.size());
                
                // P.C
               System.debug('-------- AllProductCompetencyScoreMap-----start cpu time----'+Limits.getCpuTime());         
                PLD_ProductCompetency Pldpc=new PLD_ProductCompetency();
                AllProductCompetencyScoreMap=Pldpc.Productcompetencyscoring(OAFitAccountsMap);
               System.debug('-----AllProductCompetencyScoreMap--size-----'+AllProductCompetencyScoreMap.size());
                System.debug('-------- AllProductCompetencyScoreMap-----END cpu time----'+Limits.getCpuTime());
               
                //// fetching business weightages 
                Lead__c weightage =Lead__c.getInstance('Total Score');
                System.debug('--weightage---'+weightage);  
    
                // Total score in AllTotalAccountScoreMap and INSERTING LRM records
                for(id ld_id:AllPartnerScoresMap.keySet())
                {
                    for(id ac_id:AllPartnerScoresMap.get(ld_id).keySet())
                    {
                       	Decimal score1;
                       	Decimal score2;
                        Decimal score3;
                        Decimal tot_score=0;
                        String	PartnerProgramScoreReason = '';
                        String	CompetencySpreadScoreReason = '';
                        String	NumberOfResourcesScoreReason = '';
                        String	ProductCompetencyScoreReason = '';
                        String	LoyaltyScoreReason = '';
                        String	FitInterestAnalysisScoreReason = '';
                        String	AISScoreReason = '';
                        String	PartnerCapacityScoreReason = '';
                        String	LoyaltyHistoricalScoreReason = '';
                                               
                        if ((AllPartnerScoresMap.containsKey(ld_id) == true) && 
                           (AllPartnerScoresMap.get(ld_id).containsKey(ac_id) == true ))
                        {
                            score1=AllPartnerScoresMap.get(ld_id).get(ac_id).GetPartnerScoreValue();
                            PartnerProgramScoreReason = AllPartnerScoresMap.get(ld_id).get(ac_id).GetPartnerScoreReason1();
                            //System.debug('--lead id---'+ld_id+'---acc id--'+ac_id+'--s1--'+score1);
                        }
                        else
                        {
                            score1=0.00;
                            PartnerProgramScoreReason = '';
                        }
                                                                    
                        if ((AllProductCompetencyScoreMap.containsKey(ld_id) == true) && 
                           (AllProductCompetencyScoreMap.get(ld_id).containsKey(ac_id) == true ))
                        {
                          //  System.debug('-ac_id-'+ac_id+'---print score 2--'+AllProductCompetencyScoreMap.get(ld_id).get(ac_id));
                            score2=AllProductCompetencyScoreMap.get(ld_id).get(ac_id).GetPartnerScoreValue();
                        	CompetencySpreadScoreReason = AllProductCompetencyScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason1();
                        	NumberOfResourcesScoreReason = AllProductCompetencyScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason2();
                        	ProductCompetencyScoreReason = AllProductCompetencyScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason3();
                        }
                        else
                        {
                            score2=0.00;
                        	CompetencySpreadScoreReason = '';
                        	NumberOfResourcesScoreReason = '';
                        	ProductCompetencyScoreReason = '';
                        }
                        
				
                       if ((AllLoyaltyHistoricalScoreMap.containsKey(ld_id) == true) && 
                           (AllLoyaltyHistoricalScoreMap.get(ld_id).containsKey(ac_id) == true ))
                        {
                            score3=AllLoyaltyHistoricalScoreMap.get(ld_id).get(ac_id).GetPartnerScoreValue();
                            LoyaltyScoreReason = AllLoyaltyHistoricalScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason1();
                            FitInterestAnalysisScoreReason = AllLoyaltyHistoricalScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason2();
                            AISScoreReason = AllLoyaltyHistoricalScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason3();
                            PartnerCapacityScoreReason = AllLoyaltyHistoricalScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason4();
                            LoyaltyHistoricalScoreReason = AllLoyaltyHistoricalScoreMap.get(ld_id).get(ac_id).GetPartnerScoreReason5();
                        }
                        else
                        {
                            score3=0.00;
                            LoyaltyScoreReason = '';
                            FitInterestAnalysisScoreReason = '';
                            AISScoreReason = '';
                            PartnerCapacityScoreReason = '';
                            LoyaltyHistoricalScoreReason = '';
                        }

         				PLR_PartnerScore TotalAccountScore = new PLR_PartnerScore();
               
                          //System.debug('--score1--'+score1+'--score2--'+score2+'--score3--'+score3);                     
                        if(weightage.PartnerProgramScore__c !=Null && weightage.ProductCompetency__c !=null && weightage.LoyalityHistorial__c !=null)
                        tot_score=((weightage.PartnerProgramScore__c)*score1+(weightage.ProductCompetency__c)*score2+(weightage.LoyalityHistorial__c)*score3)/100;
                        
                       // System.debug('---- *** tot_score = '+tot_score );
                        tot_score.setScale(2);
                        TotalAccountScore.SetPartnerScoreValue( tot_score );
                        TotalAccountScore.SetPartnerScoreReason1('Total Account Score  = ' + tot_score + 
                                                                 ' ( ' + (Integer)weightage.PartnerProgramScore__c + '% of Parter Program Score + ' + 
                                                          	     (Integer)weightage.ProductCompetency__c + '% of Product Competency Score + ' + 
                                                                 (Integer)weightage.LoyalityHistorial__c + '% of Loyalty/Historical Score )');
                        
                        if(tot_score != null && tot_score >0.00){
                            lrm=new LeadRoutingMatrix__c();
                            lrm.Partner_Lead__c=ld_id;
                            lrm.Partner_Account__c=ac_id;
                                                        
                        
                            lrm.RecordTypeid=Schema.SObjectType.LeadRoutingMatrix__c.getRecordTypeInfosByName().get('Account_Score').getRecordTypeId();
                       
                            if(AllTotalAccountScoreMap.containsKey(ld_id) == false){
                                lrm.PartnerProgramScore__c=score1;
                                lrm.Partner_Program_Score_Reason__c = PartnerProgramScoreReason;
                                lrm.ProductCompetency__c=score2;
                                lrm.Product_Competency_Score_Reason__c = ProductCompetencyScoreReason;
                                lrm.LoyalityHistorial__c=score3;
                                lrm.Loyalty_Historical_Score_Reason__c = LoyaltyHistoricalScoreReason;
                                lrm.AIS_Score_Reason__c = AISScoreReason;
                                lrm.Competency_Spread_Score_Reason__c = CompetencySpreadScoreReason;
                                lrm.Fit_Interest_Analysis_Score_Reason__c = FitInterestAnalysisScoreReason;
                                lrm.Loyalty_Score_Reason__c = LoyaltyScoreReason;
                                lrm.Number_Of_Resources_Score_Reason__c = NumberOfResourcesScoreReason;
                                lrm.Partner_Capacity_Score_Reason__c  = PartnerCapacityScoreReason;
                                
                                lrm.AccountScore__c=tot_score;
                                lrm.Total_Account_Score_Reason__c = TotalAccountScore.GetPartnerScoreReason1();
                                AllTotalAccountScoreMap.put(ld_id,New Map<id,PLR_PartnerScore>());
                            }
                            else{
                              lrm.PartnerProgramScore__c=score1;
                              lrm.Partner_Program_Score_Reason__c = PartnerProgramScoreReason;
                              lrm.ProductCompetency__c=score2;
                              lrm.Product_Competency_Score_Reason__c = ProductCompetencyScoreReason;
                              lrm.LoyalityHistorial__c=score3;
                              lrm.Loyalty_Historical_Score_Reason__c = LoyaltyHistoricalScoreReason;
                              lrm.AIS_Score_Reason__c  = AISScoreReason;
                              lrm.Competency_Spread_Score_Reason__c  = CompetencySpreadScoreReason;
                              lrm.Fit_Interest_Analysis_Score_Reason__c = FitInterestAnalysisScoreReason;
                              lrm.Loyalty_Score_Reason__c = LoyaltyScoreReason;
                              lrm.Number_Of_Resources_Score_Reason__c = NumberOfResourcesScoreReason;
                              lrm.Partner_Capacity_Score_Reason__c  = PartnerCapacityScoreReason;
                                
                              lrm.AccountScore__c=tot_score;
                              lrm.Total_Account_Score_Reason__c = TotalAccountScore.GetPartnerScoreReason1();
                              AllTotalAccountScoreMap.get(ld_id).put(ac_id,TotalAccountScore);
                        	}
                        lrm.Statuss__c='Eligible';
                        InsertLRMList.add(lrm);
                            
                        }
                      
                    }
                }
                 System.debug('-AllTotalAccountScoreMap-'+AllTotalAccountScoreMap);
                // Inserting into LeadRoutingMatrix
                
          		System.debug('******* CPU time before inserting LRM ---------'+Limits.getCpuTime());
                
                //commenting the DML for soft deploy
                 Insert InsertLRMList;
                
               System.debug('-----InsertLRMList---size-----'+InsertLRMList.size());
                System.debug('-----InsertLRMList--------'+InsertLRMList);
                
                for(LeadRoutingMatrix__c lr:InsertLRMList){
                    System.debug('--leadid--'+lr.Partner_Lead__c+'--accid--'+lr.Partner_Account__c+'-pps-'+lr.PartnerProgramScore__c+'-pc-'+lr.ProductCompetency__c+'-lh-'+lr.LoyalityHistorial__c+'-tot-'+lr.AccountScore__c+'--status--'+lr.Statuss__c);
                }

                // Assign lead to the partner
                if(AllTotalAccountScoreMap != NULL && AllTotalAccountScoreMap.size()>0)
                {
                    System.debug('------------------**************AccountScoring***************-------end cpu time-'+Limits.getCpuTime());
                    PartnerLeadDistribution_AssignPartner AssignPtr = new PartnerLeadDistribution_AssignPartner();
                    AssignPtr.SortAndAssignPartner(AllTotalAccountScoreMap) ;
                    System.debug('--------sucesss---------'+Limits.getCpuTime());
                    
                } 
            } 
		}
        
    } //--end of AccountScoring
    
    
     ///// USERESTORY : US397440 [Lead Routing Rules - Partner Program]
    ///// AUTHOR : AMILI01
    Public Map<ID,Map<Id,PLR_PartnerScore>> CalculatePartnerProgramScore(Map<lead,List<Account>> PpInputMap)
    {
         Map<Id,Map<Id,PLR_PartnerScore>> ppScoreMap = new Map<Id,Map<Id,PLR_PartnerScore>>();
         
        List<Business_Plan_New__c> bplist ; 
        
        for(lead ll:PpInputMap.keySet())
        {
           for(account a:PpInputMap.get(ll))
           {
               if(ppScoreMap.containsKey(ll.ID)== false)
                {
                    ppScoreMap.put(ll.ID,New Map<id,PLR_PartnerScore>());
                }
                 
         		PLR_PartnerScore PartnerProgramScore = new PLR_PartnerScore();
                 
                bplist = new List<Business_Plan_New__c>();
                bplist = a.Business_Plans__r;
                if(bplist!=NULL && bplist.size()>0)
                 {  
                    if(a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel1 || a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel2 )
                    {
                         PartnerProgramScore.SetPartnerScoreValue( 1.00 ); 
                         PartnerProgramScore.SetPartnerScoreReason1('Partner Program Score  = 1.00' + 
                                                                    ' ( The partner has Global or Focus program level with an approved BP )');
                     //   System.debug('-----lead id---'+ll.ID+'--score----'+1.0);
                    }
                    else
                    {
                        if(a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel3 )
                        {
                        //    System.debug('-----lead id---'+ll.ID+'--score----'+0.9);
                         	PartnerProgramScore.SetPartnerScoreValue( 0.90 ); 
                            PartnerProgramScore.SetPartnerScoreReason1('Partner Program Score  = 0.90' + 
                                                              	       ' ( The partner has Premier program level with an approved BP )');
                        }
                        else
                        {
                               if(a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel4 )
                               {
                         			PartnerProgramScore.SetPartnerScoreValue( 0.80 ); 
                         			PartnerProgramScore.SetPartnerScoreReason1('Partner Program Score  = 0.80' + 
                                                              	               ' ( The partner has Advanced program level with an approved BP )');
                        		}
                                else
                               {
                         			PartnerProgramScore.SetPartnerScoreValue( 0.70 ); 
                         			PartnerProgramScore.SetPartnerScoreReason1('Partner Program Score  = 0.70' + 
                                                              	               ' ( The partner did not meet BP for Global, Focus, Premier or Advanced program level )');
                               }
                          }
                    
                     }
                }
                else
                {
                     if(a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel4 || a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel1 || a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel2 || a.Solution_Provider_Program_Level__c==System.Label.SolutionLevel3 )
                    {
                        PartnerProgramScore.SetPartnerScoreValue( 0.70 ); 
                        PartnerProgramScore.SetPartnerScoreReason1('Partner Program Score  = 0.70' + 
                                                                   ' ( The partner is at the Member program level but does not have a BP )');
                    }
                    else 
                    {
                        PartnerProgramScore.SetPartnerScoreValue( 0.00 ); 
                        PartnerProgramScore.SetPartnerScoreReason1('Partner Program Score  = 0.00' + 
                                                                   ' ( The partner does not have a BP )');
                    }
                   
                }
                ppScoreMap.get(ll.ID).put(a.ID,PartnerProgramScore); 

                System.debug('\r\n====== PartnerProgramScore:'+PartnerProgramScore.GetPartnerScoreReason1());
        	}
     	}
        System.debug('--ppScoreMap---'+ppScoreMap);
        
        return ppScoreMap;
}   
    
    ///// END OF USERESTORY : US397440 [Lead Routing Rules - Partner Program]  AUTHOR:AMILI01
      //Product Competency Method --Start----
      
//Product Competency Method --ends----
//
    ///////////////////////////////////////////////
    // START //////////////////////////////////////
    // Methods to compute the overall loyalty score
    // Author:  Dorel
    // Date:    12/28/2017   
    ///////////////////////////////////////////////

    Public Map<ID,Map<Id,PLR_PartnerScore>> calculateLHScore(Map<lead,List<Account>> PpInputMap)
    {
//        System.debug('------------------**************calculateLHScore***************-------START - cpu limit--'+limits.getCpuTime());
//        system.debug('---PpInputMap-Size:--'+PpInputMap.Size());
        
        // Retrieve the dates from the Period object
        PLR_RetrieveDatesFromPeriod quarterDates = new PLR_RetrieveDatesFromPeriod();
            
        // Get the start date of the last completed 4 quarters
        Date lastComplete4QuartersStartDate = quarterDates.Last4QuartersFirstDate();
        Date lastCompleteQuarterStartDate = quarterDates.LastQuartersFirstDate();
        //System.debug('******* lastComplete4QuartersStartDate = '+lastComplete4QuartersStartDate);
        //System.debug('******* lastCompleteQuarterStartDate = '+lastCompleteQuarterStartDate);
        
        //System.debug('******* CPU time before queries---------'+Limits.getCpuTime());
    	Map<Id,Map<Id,PLR_PartnerScore>> lhScoreMap = new Map<Id,Map<Id,PLR_PartnerScore>>();

        Set<Account>    totalAccSet = new Set<Account>();
        Set<String>     totalCA_Account_IDsSet = new Set<String>();
        for(lead ll:PpInputMap.keySet())
        {
           // system.debug('******* lead ID = '+ll.Id);

            totalAccSet.addAll(PpInputMap.get(ll));
            totalCA_Account_IDsSet.Add(ll.EAID__c);
        }

        
        // Get the Opportunity objects that have been closed in the last 4 completed quarters and belong to one of the accounts in the list. 
        List<Opportunity>   oppList = PartnerLeadDistribution_DynamicSOQL.GetOppListForLHScore(totalAccSet, lastComplete4QuartersStartDate);
        
     	// system.debug('******* oppList-Size:--'+oppList.size());
        
       	// System.debug('******* CPU time before GetLeadListForLHScore ---------'+Limits.getCpuTime());
        // Get all the leads assigned to this partner 
        List<Lead> leadList = PartnerLeadDistribution_DynamicSOQL.GetLeadListForLHScore(lastCompleteQuarterStartDate, 
                                                                                        lastComplete4QuartersStartDate,
                                                                                        totalCA_Account_IDsSet );
       	// system.debug('******* leadList-Size:--'+leadList.size());
       	// System.debug('******* CPU time before loop over leads ---------'+Limits.getCpuTime());
        for(lead ll:PpInputMap.keySet())
        {
            //  system.debug('******* lead ID = '+ll.Id);
            
        	//system.debug('******* PpInputMap.get(ll)-Size:--'+PpInputMap.get(ll).size());
           	for(account a:PpInputMap.get(ll))
           	{
                PLR_PartnerScore loyaltyHistoricalScore = new PLR_PartnerScore();	
                PLR_PartnerScore partnerCapacityScore = new PLR_PartnerScore();        		
                PLR_PartnerScore overallLHScore = new PLR_PartnerScore();
                
                //  system.debug('******* ACCOUNT ID = '+a.Id);
                if(lhScoreMap.containsKey(ll.ID) == false)
                {
                    lhScoreMap.put(ll.ID,New Map<id,PLR_PartnerScore>());
                }
            
                 ////////////////////////////////
                // Has partner ever made a sale
                System.debug('------------------**************calculateLoyaltyHistoricalScore***************-------start--- CPU Time'+limits.getCpuTime());
                
                List<Opportunity> partnerClosedOpportunities = new List<Opportunity>();
                List<Opportunity> partnerOppQuotes = new List<Opportunity>();
                List<Opportunity> partnerOppTotal = new List<Opportunity>();
                
                // Get only the opportunities closed in the last 4 completed quarters that have the status set to "100% - Contract Signed"
                for(Opportunity opp : oppList)
                {
                    if((opp != null) && (opp.Reseller__c == a.Id))
                    {                    
                        partnerOppTotal.add( opp);
                        
                        if ( opp.StageName == '100% - Contract Signed' )
                        {
                            partnerClosedOpportunities.add( opp);
                            loyaltyHistoricalScore.SetPartnerScoreValue( 1.00 ); 
                            loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 1.00' + 
                                                                          ' ( The partner had a successful sale from a CA Lead in the last 4 quarters )');
                            break;
                        }
                        
                        if( opp.Has_Primary_Quote__c ==true )
                        {
                            partnerOppQuotes.add( opp);
                        }
                    }
                }
                
                if(loyaltyHistoricalScore.GetPartnerScoreValue() != 1.00)
                {
                    // If this partner has closed at least one of these opportunities in the last 4 completed quarters then
                    // he gets a loyalty score of 1.0
                    if ( partnerClosedOpportunities.size() != 0 )
                    {
                        loyaltyHistoricalScore.SetPartnerScoreValue( 1.00 ); 
                        loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 1.00' + 
                                                                      ' ( The partner had a successful sale from a CA Lead in the last 4 quarters )' );
                    }
                    
                    ///////////////////////////////////////////////////////
                    // Has partner ever attached a quote to an opportunity
                    // 
                    
                    // If this partner has attached a quote to an opportunity in the last 4 completed quarters then
                    // he gets a loyalty score of 0.6
                    if ( partnerOppQuotes.size() != 0 )
                    {
                    	loyaltyHistoricalScore.SetPartnerScoreValue( 0.60 ); 
                        loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 0.60' + 
                                                                      ' ( The partner tied a Primary Quote to an Opportunity in the last 4 quarters. The opportunity was converted from a CA Lead )' );
                    }
                
                    ///////////////////////////////////////////////////////
                    // Has partner ever converted a lead to an opportunity
                    
                    // If this partner has converted at least one lead to an opportunity in the last 4 completed quarters then
                    // he gets a loyalty score of 0.4
                    if ( partnerOppTotal.size() != 0 )
                    {
                    	loyaltyHistoricalScore.SetPartnerScoreValue( 0.40 ); 
                        loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 0.40' + 
                                                                      ' ( The partner has converted at least one lead to an opportunity in the last 4 quarters )' );
                    }
    
                    ///////////////////////////////////////////////////////////////////
                    // Has partner accepted or rejected a lead in the last 4 quarters ?
                    
                	if(loyaltyHistoricalScore.GetPartnerScoreValue() == 0.00)
                    {
                        integer count_Rejected = 0;
                        for(Lead ldObject : leadList)
                        {
                            if((ldObject != null) && 
                               (ldObject.Lead_Status_Date__c >= lastComplete4QuartersStartDate))
                            {
                                // If at least one lead was accepted then the partner gets the score of 0.2
                                if ( ldObject.Status == 'Pursuing' )
                                {
                    				loyaltyHistoricalScore.SetPartnerScoreValue( 0.20 ); 
                        			loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 0.20' + 
                                                                                  ' ( The partner has accepted at least one lead in the last 4 quarters )' );
                                    break;
                                }
                                else if ( ldObject.Status == 'Rejected' )
                                {
                                    count_Rejected++;
                                }
                            }
                        }
              
                        // No lead was accepted, so all the leads were either rejected or ignored
                        // If at least one lead was rejected then the partner gets the score of 0.1
                		if(loyaltyHistoricalScore.GetPartnerScoreValue() != 0.20)
                        {
                            if ( count_Rejected > 0 )
                            {
                    			loyaltyHistoricalScore.SetPartnerScoreValue( 0.10 ); 
                        		loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 0.10' + 
                                                                              ' ( The partner has rejected at least one lead in the last 4 quarters )' );
                            }
                            else
                            {
                                // The partner has not taken any action on any lead in the last 4 quarters                  
                    			loyaltyHistoricalScore.SetPartnerScoreValue( 0.00 ); 
                        		loyaltyHistoricalScore.SetPartnerScoreReason1('Loyalty Score  = 0.00' + 
                                                                              ' ( The partner has tasken no action on a lead in the last 4 quarters )' );
                            }
                          	//System.debug('------------------**************calculateLoyaltyHistoricalScore***************-------end--- CPU Time'+limits.getCpuTime());
                        }
              		}
             	}
    
                System.debug('\r\n====== LHScoreReason:'+loyaltyHistoricalScore.GetPartnerScoreReason1());
                
                ///////////////////////////////////////////////////////
                // First we calculate the Fit-Interest analysis scoring
        
                PLR_PartnerScore FitInterestAnalysisScore = new PLR_PartnerScore();
                PLR_PartnerScore AgeSalesMilestoneScore = new PLR_PartnerScore();
                
                // If this partner has accepted and converted leads in the past completed quarter then
                // we can compute the Fit-Interest Analysis score
                for(Lead ldObjectInQuarter : leadList)
                {
                    if((ldObjectInQuarter != null) &&
                       (ldObjectInQuarter.PartnerAcceptancedate__c >= lastCompleteQuarterStartDate) &&
                       (ldObjectInQuarter.IsConverted == TRUE))
                       
                    {
                        Date    LeadConversionDate = ldObjectInQuarter.ConvertedDate;
                        Date    LeadAcceptanceDate = ldObjectInQuarter.PartnerAcceptancedate__c;
                        
                        if ( LeadConversionDate.day() == 0 || LeadAcceptanceDate.day() == 0 )
                            continue;
                        
                        Integer nDaysBetween = LeadConversionDate.daysBetween(LeadAcceptanceDate);
        
                        // If at least one lead was converted in less than 15 days then the score is 1.0
                        if ( nDaysBetween < 15 )
                        {
                            if ( FitInterestAnalysisScore.GetPartnerScoreValue() < 1.00 )
                            {
                    			FitInterestAnalysisScore.SetPartnerScoreValue( 1.00 ); 
                                FitInterestAnalysisScore.SetPartnerScoreReason1('Fit-Interest Analysis Score  = 1.00' + 
                                                                              ' ( Leads assigned to this partner in past quarter have Fit-Interest analysis of < 15 days )' );
                            }
                        }
                        // If at least one lead was converted in less than 30 days then the score is 0.75
                        else if ( nDaysBetween < 30 )
                        {
                            if ( FitInterestAnalysisScore.GetPartnerScoreValue() < 0.75 )
                            {
                    			FitInterestAnalysisScore.SetPartnerScoreValue( 0.75 ); 
                                FitInterestAnalysisScore.SetPartnerScoreReason1('Fit-Interest Analysis Score  = 0.75' + 
                                                                                ' ( Leads assigned to this partner in past quarter have Fit-Interest analysis of 15-29 days )' );
                            }
                        }
                        // If at least one lead was converted in less than 60 days then the score is 0.50
                        else if ( nDaysBetween < 61 )
                        {
                            if ( FitInterestAnalysisScore.GetPartnerScoreValue() < 0.50 )
                            {
                    			FitInterestAnalysisScore.SetPartnerScoreValue( 0.50 ); 
                                FitInterestAnalysisScore.SetPartnerScoreReason1('Fit-Interest Analysis Score  = 0.50' + 
                                                                                ' ( Leads assigned to this partner in past quarter have Fit-Interest analysis of 30-60 days )' );
                            }
                        }
                    }
                }
        
                // If none of the leads were processed in less than 60 days then the score is 0.25
                if ( FitInterestAnalysisScore.GetPartnerScoreValue() == 0.00 )
                {
                   FitInterestAnalysisScore.SetPartnerScoreValue( 0.25 ); 
                   FitInterestAnalysisScore.SetPartnerScoreReason1('Fit-Interest Analysis Score  = 0.25' + 
                                                                   ' ( Leads assigned to this partner in past quarter have Fit-Interest analysis of > 60 days )' );                
                }
        
                System.debug('\r\n====== FitInterestAnalysisScoreReason:'+FitInterestAnalysisScore.GetPartnerScoreReason1());
                
                ///////////////////////////////////////////////////////
                // Now we calculate the Age in Sales Milestone score
                          
                List<Opportunity> partnerOpportunities = new List<Opportunity>();
        
                // Get only the opportunities closed in the last 4 completed quarters that have the Sales Milestone status set to "100%"
                for(Opportunity opp : oppList)
                {
                    if((opp != null) && (opp.Reseller__c == a.Id) && (opp.Stage_Change_Date__c != null))
                    {
                        Integer nAge = DATE.today().daysBetween(opp.Stage_Change_Date__c);
                        if ( nAge > 60 )
                        {
                            partnerOpportunities.add( opp);
                        }
                    }
                }
        
                if ( partnerOpportunities.size() != 0 )
                {
                    integer nPercentOverSixty = partnerOpportunities.size() * 100 / oppList.size();
                    
                    if ( nPercentOverSixty < 25 )
                    {
                   		AgeSalesMilestoneScore.SetPartnerScoreValue( 1.00 ); 
                        AgeSalesMilestoneScore.SetPartnerScoreReason1('AIS Score = 1.00' + 
                                                                      ' ( Less than 25% of opportunities assigned to this partner have an AIS > 60 days )');
                    }
                    else if ( nPercentOverSixty >= 25 && nPercentOverSixty < 50 )
                    {
                   		AgeSalesMilestoneScore.SetPartnerScoreValue( 0.75 );
                        AgeSalesMilestoneScore.SetPartnerScoreReason1('AIS Score = 0.75' + 
                                                                      ' ( 25% - 49% of opportunities assigned to this partner have an AIS > 60 days )');
                    }
                    else if ( nPercentOverSixty >= 50 && nPercentOverSixty < 74 )
                    {
                   		AgeSalesMilestoneScore.SetPartnerScoreValue( 0.50 ); 
                        AgeSalesMilestoneScore.SetPartnerScoreReason1('AIS Score = 0.50' + 
                                                                      ' ( 50% - 74% of opportunities assigned to this partner have an AIS > 60 days )');
                    }
                    else
                    {
                   		AgeSalesMilestoneScore.SetPartnerScoreValue( 0.25 ); 
                        AgeSalesMilestoneScore.SetPartnerScoreReason1('AIS Score = 0.25' + 
                                                                      ' ( Greater than 75% of opportunities assigned to this partner have an AIS > 60 days )');
                    }
                }
                else
                {
                    // No opportunity has an age of over 60
                	AgeSalesMilestoneScore.SetPartnerScoreValue( 1.00 ); 
                    AgeSalesMilestoneScore.SetPartnerScoreReason1('AIS Score = 1.00' + 
                                                                  ' ( No opportunity assigned to this partner has an AIS > 60 days )');
                }
                    
                System.debug('\r\n====== AgeSalesMilestoneScoreReason:'+AgeSalesMilestoneScore.GetPartnerScoreReason1());
                
                // Compute the overall partner capacity score
                 //System.debug('-----------------------**************calculatePartnerCapacityScore**************------------END-');
                Decimal	partnerCapacityScoreValue = 0.00;
                
                if ( FitInterestAnalysisScore.GetPartnerScoreValue() != 0.00 || AgeSalesMilestoneScore.GetPartnerScoreValue() != 0.00 )
                	partnerCapacityScoreValue = (FitInterestAnalysisScore.GetPartnerScoreValue() + AgeSalesMilestoneScore.GetPartnerScoreValue()) / 2.00;
                
                partnerCapacityScore.SetPartnerScoreValue( partnerCapacityScoreValue ); 
                partnerCapacityScore.SetPartnerScoreReason1('Partner Capacity Score  = ' + partnerCapacityScoreValue +
                                                            ' ( 50% of Fit-InterestAnalysisScore + 50% of AISScore )' );

                System.debug('\r\n====== partnerCapacityScoreReason:'+partnerCapacityScore.GetPartnerScoreReason1()+'\n\r\n\r');
                
                 // Compute the overall score: 75% for loyaltyHistoricalScore and 25% for the partnerCapacityScore
                Decimal	overallLHScoreValue = loyaltyHistoricalScore.GetPartnerScoreValue() * 0.75 + partnerCapacityScore.GetPartnerScoreValue() * 0.25;
                overallLHScoreValue.setScale(2);
                overallLHScore.SetPartnerScoreValue( overallLHScoreValue );
                overallLHScore.SetPartnerScoreReason1(loyaltyHistoricalScore.GetPartnerScoreReason1());
                overallLHScore.SetPartnerScoreReason2(FitInterestAnalysisScore.GetPartnerScoreReason1());
                overallLHScore.SetPartnerScoreReason3(AgeSalesMilestoneScore.GetPartnerScoreReason1());
                overallLHScore.SetPartnerScoreReason4(partnerCapacityScore.GetPartnerScoreReason1());
                overallLHScore.SetPartnerScoreReason5('Loyalty Historical Score = ' + overallLHScoreValue +
                                              	      ' ( 75% of Loyalty Score + 25% of Partner Capacity Score )' ); 
                
                System.debug('\r\n====== Lead_ID = '+ll.ID +'\n\rAccount_ID = '+a.ID+
                             '\r\n====== overallLHScoreReason:'+overallLHScore.GetPartnerScoreReason5()+'\n\r\n\r');
                
               	//   system.debug('******* dOverallScore = '+dOverallScore);
               
                // Save the loyalty/historical score for this lead and this account
                lhScoreMap.get(ll.ID).put(a.ID, overallLHScore); 
        	}
        }
            
        //system.debug('******* lhScoreMap = '+lhScoreMap);

        System.debug('------------------**************calculateLHScore***************-------END-- CPU Time'+limits.getCpuTime());
        
        return lhScoreMap;
    }
    ///////////////////////////////////////////////
    // END ////////////////////////////////////////
    // Methods to compute the overall loyalty score
    // Author:  Dorel
    // Date:    12/28/2017   
    ///////////////////////////////////////////////
 
    // This code is moved here as PartnerLeadRouting Trigger is using this.
    
     public static Boolean ispartneruser(id User_id){
	boolean partner;
	 for(User ur:[SELECT id,usertype,name FROM user  where UserType=:'PowerPartner' and isActive=:True and id=:User_id]){
            if(ur.UserType=='PowerPartner'){
                 partner=True;
            }else{
				 partner=False;
			}
         }
		 return partner;
}
}