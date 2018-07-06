// TADKR01 - PRM 4 - 78.00 - Dismissing duplicate rules from being created.
trigger checkDuplicates_PLRR on Partner_Lead_Routing_Rules__c (before insert, before update) {
       
       Map<Id,List<Partner_Lead_Routing_Rules__c>> mapCampaigns =new Map<Id,List<Partner_Lead_Routing_Rules__c>>();
       Map<String,List<Partner_Lead_Routing_Rules__c>> mapLeadCriteria = new Map<String,List<Partner_Lead_Routing_Rules__c>>();   
       List<String> listCampaigns = new List<String>();
       List<String> listBU = new List<String>();
       List<String> listNCVDrivers = new List<String>();
       List<String> listSegments = new List<String>();
       List<String> listRTM = new List<String>();
       List<String> listRTMTypes = new List<String>();
       
       String tempBU = null;
       String tempNCVDriver = null;
       String tempSegment = null;
       String tempRTM = null;
       String tempRTMType = null;
       
       
       for(Partner_Lead_Routing_Rules__c plrr: trigger.new){
            listCampaigns.add(plrr.Campaign__c);
            listBU.add(plrr.BU__c);
            listNCVDrivers.add(plrr.NCV_Driver__c);
            listSegments.add(plrr.Segment__c);              
            listRTM.add(plrr.RTM__c);
            listRTMTypes.add(plrr.RTM_Type__c);
       }
       
     List<Partner_Lead_Routing_Rules__c> existingRules = [select Id,campaign__c,Rule_Start_Date__c,Rule_Expiration_Date__c,BU__c,NCV_Driver__c,Segment__c,RTM__c,RTM_Type__c
                                                                 from Partner_lead_Routing_Rules__c 
                                                                 where Campaign__c in :listCampaigns 
                                                                       OR (Campaign__c = NULL
                                                                           AND (BU__c in: listBU OR BU__c = NULL) 
                                                                           AND (NCV_Driver__c in: listNCVDrivers OR NCV_Driver__c = NULL) 
                                                                           AND (Segment__c in: listSegments OR Segment__c = NULL) 
                                                                           AND (RTM__c in: listRTM OR RTM__c = NULL) 
                                                                           AND (RTM_Type__c in: listRTMTypes OR RTM_Type__c = NULL))];
    
     for(Partner_Lead_Routing_Rules__c p: existingRules){
            if(p.Campaign__c != null && mapCampaigns.containsKey(p.Campaign__c))
               mapCampaigns.get(p.Campaign__c).add(p);
            else if(p.Campaign__c != null && !mapCampaigns.containsKey(p.Campaign__c)){
                 mapCampaigns.put(p.Campaign__c,new List<Partner_lead_Routing_rules__c>());
                 mapCampaigns.get(p.Campaign__c).add(p);
            }
            else if(p.Campaign__c == null){
                 tempBU = p.BU__c != NULL ? p.BU__c:'NULL';                  tempNCVDriver = p.NCV_Driver__c != NULL ? p.NCV_Driver__c:'NULL';
                 tempSegment = p.Segment__c != NULL ? p.Segment__c:'NULL';   tempRTM = p.RTM__c != NULL ? p.RTM__c:'NULL';
                 tempRTMType = p.RTM_Type__c != NULL ? p.RTM_Type__c:'NULL';
                 
                 if(mapLeadCriteria.containsKey(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType))
                     mapLeadCriteria.get(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType).add(p);
                 else{
                    mapLeadCriteria.put(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType,new List<Partner_Lead_Routing_Rules__c>());
                    mapLeadCriteria.get(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType).add(p);
                 }
            }
     }
       
     for(Partner_Lead_Routing_Rules__c eachRec: trigger.new){
        if(eachRec.Campaign__c !=null){
            if(eachRec.Rule_Start_Date__c != null && eachRec.Rule_Expiration_Date__c != null && mapCampaigns.containsKey(eachRec.Campaign__c) && mapCampaigns.get(eachRec.Campaign__c).size()>0){
                for(Partner_Lead_Routing_Rules__c similarPLRR : mapCampaigns.get(eachRec.Campaign__c)){
                    if((eachRec.Rule_Start_Date__c == similarPLRR.Rule_Start_Date__c || eachRec.Rule_Expiration_Date__c == similarPLRR.Rule_Expiration_Date__c)
                       || (eachRec.Rule_Expiration_Date__c >= similarPLRR.Rule_Start_Date__c && eachRec.Rule_Expiration_Date__c <= similarPLRR.Rule_Expiration_Date__c)
                       || (eachRec.Rule_Start_Date__c >= similarPLRR.Rule_Start_Date__c && eachRec.Rule_Start_Date__c <= similarPLRR.Rule_Expiration_Date__c)
                       || (eachRec.Rule_Start_Date__c <= similarPLRR.Rule_Start_Date__c && eachRec.Rule_Expiration_Date__c >= similarPLRR.Rule_Expiration_Date__c)                      
                      ){
                          if(trigger.isInsert)
                                  eachRec.addError('Cannot save duplicate Partner Lead Routing Rule');
                                else if(trigger.isUpdate && eachRec.Id != similarPLRR.Id)
                                  eachRec.addError('Cannot save duplicate Partner Lead Routing Rule');
                       }
                }
            }
        }
        else if(eachRec.Rule_Start_Date__c != null && eachRec.Rule_Expiration_Date__c != null){
                 tempBU = eachRec.BU__c != NULL ? eachRec.BU__c:'NULL';                  tempNCVDriver = eachRec.NCV_Driver__c != NULL ? eachRec.NCV_Driver__c:'NULL';
                 tempSegment = eachRec.Segment__c != NULL ? eachRec.Segment__c:'NULL';   tempRTM = eachRec.RTM__c != NULL ? eachRec.RTM__c:'NULL';
                 tempRTMType = eachRec.RTM_Type__c != NULL ? eachRec.RTM_Type__c:'NULL';
                 if(mapLeadCriteria.containsKey(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType) && mapLeadCriteria.get(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType).size()>0){
                    for(Partner_Lead_Routing_Rules__c similarPLRR : mapLeadCriteria.get(tempBU+'|'+tempNCVDriver+'|'+tempSegment+'|'+tempRTM+'|'+tempRTMType)){
                            if((eachRec.Rule_Start_Date__c == similarPLRR.Rule_Start_Date__c || eachRec.Rule_Expiration_Date__c == similarPLRR.Rule_Expiration_Date__c)
                               || (eachRec.Rule_Expiration_Date__c >= similarPLRR.Rule_Start_Date__c && eachRec.Rule_Expiration_Date__c <= similarPLRR.Rule_Expiration_Date__c)
                               || (eachRec.Rule_Start_Date__c >= similarPLRR.Rule_Start_Date__c && eachRec.Rule_Start_Date__c <= similarPLRR.Rule_Expiration_Date__c)
                               || (eachRec.Rule_Start_Date__c <= similarPLRR.Rule_Start_Date__c && eachRec.Rule_Expiration_Date__c >= similarPLRR.Rule_Expiration_Date__c)                      
                            ){
                            	if(trigger.isInsert)
                                  eachRec.addError('Cannot save duplicate Partner Lead Routing Rule');
                                else if(trigger.isUpdate && eachRec.Id != similarPLRR.Id)
                                  eachRec.addError('Cannot save duplicate Partner Lead Routing Rule');
                             }
                    }
                 }
        }
     }
}