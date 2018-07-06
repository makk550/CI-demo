public class UpdateBusinessPlanFocus{
   
    public static Set<Id> oppIdSet = new Set<Id>();
    public static Map<Id,List<String>> oppId_ProductGroup_Map = new Map<Id,List<String>>();
    public static List<OpportunityLineItem> oppLineItemsList;
    public static List<Opportunity> opportunityList;
    public static Set<String> OpenOppStageNameSet = new Set<String>{Label.Opp_Stage_10_Percent,Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,
                                                Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent};
    
    //@future
    public static void LogicTriggeredFromOpportunityLineItem(Set<Id> IDSet){
        oppLineItemsList = [select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where Id IN: IDSet];
        System.debug('++++++oppLineItemsList+++++'+oppLineItemsList);
        if(oppLineItemsList != null && oppLineItemsList.size()>0){
            constructOppId_prodgroup_Map(oppLineItemsList);
        }
    }
    
    //@future
    public static void LogicTriggeredFromOpportunity(Set<Id> IDSet){
        oppLineItemsList = [select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where OpportunityId IN: IDSet];
        System.debug('++++++oppLineItemsList+++++'+oppLineItemsList);
        if(oppLineItemsList != null && oppLineItemsList.size()>0){
            constructOppId_prodgroup_Map(oppLineItemsList);
        } 
    }
  
    
    //@future
    public static void LogicTriggeredFromProductAlignment(Set<Id> SolutionProviderAccountIdSet, Set<Id> ServiceProviderAccountIdSet, Set<Id> DataManagementAccountIdSet, Map<String,Boolean> ProdGroup_BPFValue_Map){
        //oppLineItemsList = [select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem];
        if(SolutionProviderAccountIdSet != null && SolutionProviderAccountIdSet.size()>0){
            opportunityList = [select Id from Opportunity where Reseller__c IN: SolutionProviderAccountIdSet AND StageName IN: OpenOppStageNameSet];
        }
        if(ServiceProviderAccountIdSet != null && ServiceProviderAccountIdSet.size()>0){
            opportunityList = [select Id from Opportunity where AccountId IN: ServiceProviderAccountIdSet AND StageName IN: OpenOppStageNameSet];
        }
        if(DataManagementAccountIdSet != null && DataManagementAccountIdSet.size()>0){
            opportunityList = [select Id from Opportunity where Reseller__c IN: DataManagementAccountIdSet AND StageName IN: OpenOppStageNameSet];
        } 
        System.debug('+++++++opportunityList999++++++'+opportunityList);       
        Set<Id> opportunityIdSet = new Set<Id>();
        for(Opportunity o:opportunityList){
            opportunityIdSet.add(o.Id);
        }
        oppLineItemsList = [select id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Name,PriceBookEntry.Product2.Product_Group__c,OpportunityId,Business_Plan_Focus__c from OpportunityLineItem where OpportunityId IN: opportunityIdSet AND PriceBookEntry.Product2.Product_Group__c IN: ProdGroup_BPFValue_Map.keySet()];
        System.debug('++++++oppLineItemsList888+++++'+oppLineItemsList);
        if(oppLineItemsList != null && oppLineItemsList.size()>0){
            //constructOppId_prodgroup_Map(oppLineItemsList);
            for(OpportunityLineItem oli:oppLineItemsList){
                System.debug('++++++Product Group777++++++'+oli.PriceBookEntry.Product2.Product_Group__c);
                if(ProdGroup_BPFValue_Map.containsKey(oli.PriceBookEntry.Product2.Product_Group__c)){
                    System.debug('++++++oli.Id++++++'+oli.Id);
                    oli.Business_Plan_Focus__c = ProdGroup_BPFValue_Map.get(oli.PriceBookEntry.Product2.Product_Group__c);
                }
            }
            Database.update(oppLineItemsList,false);
        } 
    }
    
    public static void constructOppId_prodgroup_Map(List<OpportunityLineItem> oppLineItems){
        System.debug('++++++In constructOppId_prodgroup_Map+++++'+oppLineItemsList);
        for(OpportunityLineItem oli:oppLineItems){
            System.debug('++++++PriceBookEntry.Product2Id+++++'+oli.PriceBookEntry.Product2Id);
            System.debug('++++++PriceBookEntry.Product2.Name+++++'+oli.PriceBookEntry.Product2.Name);
            System.debug('++++++PriceBookEntry.Product2.Product_Group__c+++++'+oli.PriceBookEntry.Product2.Product_Group__c);
            System.debug('++++++id+++++'+oli.Id);  
            oppIdSet.add(oli.OpportunityId);
            if(!oppId_ProductGroup_Map.containsKey(oli.OpportunityId)){
                oppId_ProductGroup_Map.put(oli.OpportunityId,new List<String>());
                oppId_ProductGroup_Map.get(oli.OpportunityId).add(oli.PriceBookEntry.Product2.Product_Group__c);
            }else{
                oppId_ProductGroup_Map.get(oli.OpportunityId).add(oli.PriceBookEntry.Product2.Product_Group__c);
            }
        }
        System.debug('++++oppId_ProductGroup_Map++++'+oppId_ProductGroup_Map);
        //if(UpdateBusinessPlanFocus.LogicTriggeredBy == 'OpportunityLineItem')
            processOpportunities(oppId_ProductGroup_Map.keySet());
    }
    
    
    public static void processOpportunities(Set<Id> OppIds){
        List<opportunity> oppList = [select Id,Type,Reseller__c,AccountId,Partner__c from opportunity where Id IN: OppIds AND StageName IN: OpenOppStageNameSet];
        //Set<Id> Account_Id_Set = new Set<Id>();
        Map<Id,String> AccountId_RTM_Map = new Map<Id,String>();
        Map<Id,List<Opportunity>> AccountId_OppList_Map = new Map<Id,List<Opportunity>>();
        if(oppList != null && oppList.size()>0){
            System.debug('+++++oppList++++++'+oppList);
            for(Opportunity opp:oppList){
                if((opp.Type == '1 Tier' || opp.Type == '2 Tier') && opp.Reseller__c != null){
                    //Account_Id_Set.add(opp.Reseller__c);
                    AccountId_RTM_Map.put(opp.Reseller__c,'Solution Provider');
                    if(!AccountId_OppList_Map.containskey(opp.Reseller__c)){
                        AccountId_OppList_Map.put(opp.Reseller__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Reseller__c).add(opp);
                    }else{
                        AccountId_OppList_Map.put(opp.Reseller__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Reseller__c).add(opp);
                    }
                        
                }
                if(opp.Type == 'xSP' && opp.AccountId != null){
                    //Account_Id_Set.add(opp.AccountId);
                    AccountId_RTM_Map.put(opp.AccountId,'Service Provider');
                    if(!AccountId_OppList_Map.containskey(opp.AccountId)){
                        AccountId_OppList_Map.put(opp.AccountId,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.AccountId).add(opp);
                    }else{
                        AccountId_OppList_Map.put(opp.AccountId,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.AccountId).add(opp);
                    }
                }
                if(opp.Type == 'Direct' && opp.Partner__c != null){
                    //Account_Id_Set.add(opp.Partner__c);
                    AccountId_RTM_Map.put(opp.Partner__c,'Service Provider');
                    if(!AccountId_OppList_Map.containskey(opp.Partner__c)){
                        AccountId_OppList_Map.put(opp.Partner__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Partner__c).add(opp);
                    }else{
                        AccountId_OppList_Map.put(opp.Partner__c,new List<Opportunity>());
                        AccountId_OppList_Map.get(opp.Partner__c).add(opp);
                    }
                }
                
            }
            
            
            System.debug('+++++AccountId_OppList_Map++++++'+AccountId_OppList_Map);
            List<Route_To_Market__c> RTMList = [select Id,Account__c,RTM__c from Route_To_Market__c where RTM__c IN: AccountId_RTM_Map.values() AND Account__c IN: AccountId_RTM_Map.keySet()];
            System.debug('+++++RTMList++++++'+RTMList);
            Set<Id> RTMIdSet = new Set<Id>();
            if(RTMList != null && RTMList.size()>0){
                for(Route_To_Market__c rtm:RTMList){
                    if(AccountId_RTM_Map.get(rtm.Account__c)==rtm.RTM__c){
                        RTMIdSet.add(rtm.Id);
                    }
                }
            }
            
            System.debug('+++++RTMIdSet++++++'+RTMIdSet);
            Map<Id,Map<String,boolean>> OppId_ProductGroup_BPF_Map = new Map<Id,Map<String,boolean>>();
            List<Product_Alignment__c> productAlignmentList = [select Id,Business_Plan__c,Related_Account__c,Product_Group__c from Product_Alignment__c where Route_To_Market__c IN: RTMIdSet];
            System.debug('+++++productAlignmentList++++++'+productAlignmentList);
            if(productAlignmentList != null && productAlignmentList.size()>0){
                for(Product_Alignment__c PA:productAlignmentList){
                    System.debug('+++++PA++++++'+PA);
                    if(AccountId_OppList_Map.containsKey(PA.Related_Account__c)){
                        System.debug('+++++111++++++');
                        for(Opportunity op:AccountId_OppList_Map.get(PA.Related_Account__c)){
                            System.debug('+++++op.Id++++++'+op.Id);
                            if(oppId_ProductGroup_Map.containsKey(op.Id)){
                                System.debug('+++++222++++++');
                                for(String prodGroup:oppId_ProductGroup_Map.get(op.Id)){
                                    System.debug('+++++prodGroup++++++'+prodGroup);
                                    System.debug('+++++PA.Business_Plan__c++++++'+PA.Business_Plan__c);
                                    System.debug('++++++++PA.Product_Group__c+++++++'+PA.Product_Group__c);
                                    if(prodGroup.equalsIgnoreCase(PA.Product_Group__c) && PA.Business_Plan__c){
                                        System.debug('+++++333++++++');
                                        if(!OppId_ProductGroup_BPF_Map.containsKey(op.Id)){
                                            OppId_ProductGroup_BPF_Map.put(op.Id,new Map<String,boolean>());
                                            OppId_ProductGroup_BPF_Map.get(op.Id).put(prodGroup,PA.Business_Plan__c);
                                            System.debug('+++++JJJ++++++'+OppId_ProductGroup_BPF_Map);
                                        }else{                                        
                                            OppId_ProductGroup_BPF_Map.get(op.Id).put(prodGroup,PA.Business_Plan__c);
                                            System.debug('+++++KKK++++++'+OppId_ProductGroup_BPF_Map);
                                        }                                
                                    }
                                }
                            }
                        }                
                    }
                }
            }
            
            System.debug('+++++OppId_ProductGroup_BPF_Map++++++'+OppId_ProductGroup_BPF_Map);
            if(oppLineItemsList != null && oppLineItemsList.size()>0){
                for(OpportunityLineItem oli:oppLineItemsList){
                    if(OppId_ProductGroup_BPF_Map.containsKey(oli.OpportunityId)){
                        System.debug('+++++444++++++');
                        if(OppId_ProductGroup_BPF_Map.get(oli.OpportunityId).containsKey(oli.PriceBookEntry.Product2.Product_Group__c)){
                            System.debug('+++++555++++++');
                            oli.Business_Plan_Focus__c = OppId_ProductGroup_BPF_Map.get(oli.OpportunityId).get(oli.PriceBookEntry.Product2.Product_Group__c);
                        }else
                            oli.Business_Plan_Focus__c = false;
                    }else{
                        oli.Business_Plan_Focus__c = false;
                    }
                }
                //SystemIdUtility.skipOpportunityLineItemTriggers = true;
                System.debug('++++++++Before Update++++++++');  
                Database.update(oppLineItemsList,false);
                System.debug('+++oppLineItemsList+++'+oppLineItemsList); 
           }
        
          
        }
         
    }
}