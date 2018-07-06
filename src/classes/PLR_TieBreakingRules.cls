///////////////////////////////////////////////////////////
// Class to apply tie breaking rules on the account scoring
// Author:   Dorel
// Date:  01/02/2018   
///////////////////////////////////////////////////////////
public class PLR_TieBreakingRules
{
    private PLR_RetrieveDatesFromPeriod quarterDates = new PLR_RetrieveDatesFromPeriod();
    

    /////////////////////////////////
    // Apply all tie breaking rules 
  	public Map<id,id> applyTieBreakingRules( Map<id,List<id>> tiebrkMap )
    {
//        System.debug('++++++++++++++++++++ applyTieBreakingRules +++++++++++++++++++++++++++'); 

        // Apply the Historical Close Rate tie breaking rule to the accounts that scored the same
        Map<id,id>  assignPartnerMap = new Map<id,id>();

		// Did we get anything from the caller?
        if (( tiebrkMap == NULL) || (tiebrkMap.size() == 0))
        {
            return assignPartnerMap;
        }
            
        Map<id,List<id>> historicalTieBrkMap = applyHistoricalCloseRateRule( tiebrkMap );
//        System.debug('-historicalTieBrkMap.size()--'+historicalTieBrkMap.size()); 
        
		// Did we get anything from applyHistoricalCloseRateRule()?
        if (( historicalTieBrkMap == NULL) || (historicalTieBrkMap.size() == 0))
        {
            // Do not return an empty result, return the same list that came in if the historical 
            // tie braking rule did not work.
            for(id lead_id:tiebrkMap.keySet())
            {
                if (tiebrkMap.get(lead_id).size() > 0)
                	assignPartnerMap.put(lead_id,tiebrkMap.get(lead_id)[0]);
            }
            return assignPartnerMap;
        }
            
    	// Look at the results of the first tie breaking rule and see if we still have a tie 
        map<id, list<id>> outgoinglisttoroundrobin = new map<id, list<id>>();
        Boolean  bHaveLeadsForFinalRule = FALSE;
        For(id lead_id:historicalTieBrkMap.keySet())
        {
//          System.debug('-lead_id--'+lead_id);
            
            // Do we still have more than one partner account at the top ?
            if ( historicalTieBrkMap.get(lead_id).size() > 1 )
            {
                bHaveLeadsForFinalRule = TRUE;
                
//            	System.debug('-historicalTieBrkMap.get(lead_id).size() = '+historicalTieBrkMap.get(lead_id).size());
                
                // Populate the map to be procesed by the second ( final ) tie breaking rule.
                outgoinglisttoroundrobin.put(lead_id, historicalTieBrkMap.get(lead_id));                 
            }
            else
            {
//            	System.debug('-Save the winner in the assignPartnerMap if we do not have it already --  ');
                
                // Save the winner in the assignPartnerMap if we do not have it already
                if( assignPartnerMap.containsKey(lead_id) == false )
                {  
//                    system.debug('Put in assignPartnerMap = ' + historicalTieBrkMap.get(lead_id)[0]);
                    if (historicalTieBrkMap.get(lead_id).size() > 0)
                        assignPartnerMap.put(lead_id, historicalTieBrkMap.get(lead_id)[0]);
                }            
            }            
        }
        
        if ( bHaveLeadsForFinalRule == TRUE )
        {
            // The tie is not broken yet. Apply second ( final ) tie breaking rule.
//          	System.debug('-outgoinglisttoroundrobin.size() =  '+outgoinglisttoroundrobin.size());
            Map<Id, Id> LeadToAccountMap = applyFinalTieBreakingRule(outgoinglisttoroundrobin);
            //Now AccID will have only one account id which is returned from Round Robin tie breaking Algorithm.
            
            //            	System.debug('-Save the list of winners in the assignPartnerMap --  ');
            //            	System.debug('-LeadToAccountMap.size() =  '+LeadToAccountMap.size());
            assignPartnerMap.putAll(LeadToAccountMap);
        }
        
//        System.debug('+++++++++++++++++++ Return the map between the lead and the winning partner +++++++++++++++++++++++'); 
//        System.debug('-assignPartnerMap.size()--'+assignPartnerMap.size()); 
//        System.debug('-assignPartnerMap--'+assignPartnerMap); 
    	// Return the map between the lead and the winning partner
        return assignPartnerMap;
    }
    
    ////////////////////////////////////
    // Apply Historical Close Rate rule  
    public Map<id, List<id>> applyHistoricalCloseRateRule( Map<id,List<id>> tiebrkMap )
    {
//        System.debug('++++++++++++++++++++ applyHistoricalCloseRateRule +++++++++++++++++++++++++++'); 
        Map<id,List<id>>     historicalTieBrkMap  = new Map<id, List<id>>();
        Map<id,integer>      oppConvertedCountMap = new Map<id,integer>();
        List<id>             accountIDs           = new List<id>();
        List<id>             oppIDs               = new List<id>();

    // Did we get a valid map?         
        if (( tiebrkMap == NULL ) || (tiebrkMap.size() == 0))
        {
//            System.debug('-empty tiebrkMap--'); 
            return historicalTieBrkMap;
        }
        
        // Get the start date of the last completed 4 quarters
        Date lastComplete4QuartersStartDate = quarterDates.Last4QuartersFirstDate();
//        System.debug('-lastComplete4QuartersStartDate = '+lastComplete4QuartersStartDate); 

        List<Opportunity>   oppList = PartnerLeadDistribution_DynamicSOQL.GetOppListForTieBreakingRules(lastComplete4QuartersStartDate);

        if((oppList == NULL) || (oppList.size() == 0))
        {
//            System.debug('-empty oppList--'); 

            // Since we can't apply the tie braking algorithm return the same list that came in.
            for(id lead_id:tiebrkMap.keySet())
            {
                historicalTieBrkMap.put(lead_id,tiebrkMap.get(lead_id));
            }
            return historicalTieBrkMap;
        }
        
//        System.debug('-oppList.size()--'+oppList.size()); 
        
        // Iterate over all the leads 
        For(id lead_id:tiebrkMap.keySet())
        {
//         System.debug('-lead_id = '+lead_id); 

            oppConvertedCountMap.clear();
            accountIDs.clear();
            
            // Iterate over all the accounts
            For ( id accId:tiebrkMap.get(lead_id))
            {
//                System.debug('-accId = '+accId); 

        		oppIDs.clear();
                
                // Iterate over all the closed opportunities created from leads in the last 4 completed quarters
                For ( Opportunity oppObject:oppList)
                {
                  //System.debug('-oppObject.Id - '+oppObject.Id);
                    
                    // Does this opportunity belong to the current account?
                  	if( accId == oppObject.Reseller__c)
                    {
                        // Add the opportunity ID to the list so we can count them 
//                    	System.debug('-Add to oppIDs - '+oppObject.Id); 
                        oppIDs.add(oppObject.Id);
                    }                        
                }
                
                // Save the number of opportunities associated with this account
                if( oppConvertedCountMap.containsKey(accId) == false )
                {  
//                  	System.debug('-Put in oppConvertedCountMap - '+'AccId = '+ accId + 'oppIDs.size() = '+oppIDs.size()); 
                	oppConvertedCountMap.put(accId,oppIDs.size());                
              	}
            }
            
      		// Get the values of the opportunities count for all accounts
            List<integer> accCount = oppConvertedCountMap.values();
            
//            System.debug('-accCount.size() - '+ accCount.size()); 
//            System.debug('-accCount - '+ accCount); 
                         
      		if (( accCount != NULL ) && (accCount.size() > 0))
            {
                // Sort the values and get the max value
                accCount.sort();
                integer maxCount = accCount[accCount.size()-1];               
//                System.debug('-maxCount = '+maxCount); 
                
                // Get all the accounts who converted the max amount of opportunities
                For ( id accId:tiebrkMap.get(lead_id))
                {
                    if ( oppConvertedCountMap.get(accId) == maxCount )
                    {
                        accountIDs.add(accId);
//                    	System.debug('-Added accId to accountIDs --- accId = '+accId+ 'accountIDs.size() = '+accountIDs.size()); 
                    }
                }
                
//                System.debug('-accountIDs = '+accountIDs);
                
                // Associate the lead with the accounts that converted the max amount of opportunities
                if( historicalTieBrkMap.containsKey(lead_id) == false )
                {
//                  	System.debug('-Put in historicalTieBrkMap '+accountIDs);
                    historicalTieBrkMap.put(lead_id, accountIDs);
                }
            }    
        }
        
        return historicalTieBrkMap;
    }

    ///////////////////////////////////////////////////////////////////////
    // Apply final rule to the result from the historical tie breaking rule 
    public map<id, id> applyFinalTieBreakingRule( map<id, list<id>> incominglist )
    {
//        System.debug('++++++++++++++++++++ applyFinalTieBreakingRule +++++++++++++++++++++++++++'); 

        // Note:
        // Need to implement round robin here...
        map<id,id>     returnfromtheclassMap = new map<id,id>();
        
    	Set<Id>  totalAccSet = new Set<Id>();
       
        for(id leadId:incominglist.keySet())
        {
            totalAccSet.addAll(incominglist.get(leadId));
        }
      
        // Get the account objects for all the leads. 
        List<Account>   totalAccountList = PartnerLeadDistribution_DynamicSOQL.GetAccountListForTieBreakingRules(totalAccSet);

        for(id ldID : incominglist.keySet() )
        {
            list<id> accountidlist = incominglist.get(ldID);
//            system.debug('accountIdlist '+ accountidlist);
           
      		Account leadowneraccount = NULL;
            if((accountidlist != NULL ) && (accountidlist.size() > 1 ) && 
               (totalAccountList !=NULL ) && (totalAccountList.size() > 0 ))
            {
        		Date  dt = null;
            	for(account acc : totalAccountList)
                {
                    if( accountidlist.contains(acc.Id) )
                    {
                        if(dt == null)
                        {
                            dt = acc.PartnerLeadLastAcceprancedate__c;
                            leadowneraccount = acc;
                        }
                        else if(dt != null && dt > acc.PartnerLeadLastAcceprancedate__c )
                        {
//                            system.debug('date is ---> '+ dt);
                            dt = acc.PartnerLeadLastAcceprancedate__c;
                            leadowneraccount = acc;
                        }
                    }
         		}
                if(( returnfromtheclassMap.containsKey(ldID) == false ) && (leadowneraccount != NULL))
                {  
                    returnfromtheclassMap.put(ldID, leadowneraccount.id);
                }            
      		}
            
            //if there is only one account for that lead that is passed into round robin, that account itself is returned.
            else if((accountidlist != NULL ) && (accountidlist.size() == 1))
            {
                if( returnfromtheclassMap.containsKey(ldID) == false )
                {  
                    returnfromtheclassMap.put(ldID, accountidlist[0]);
                }            
      		}
        }
        
        if(returnfromtheclassMap.isEmpty())
        {
            // Do not return an empty result, return the same list that came in if the tie braking rule did not work.
            for(id lead_id:incominglist.keySet())
            {
                if (incominglist.get(lead_id).size() > 0)
                	returnfromtheclassMap.put(lead_id,incominglist.get(lead_id)[0]);
            }
        }
    	return returnfromtheclassMap;
    }
}