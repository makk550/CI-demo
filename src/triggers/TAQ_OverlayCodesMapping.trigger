trigger TAQ_OverlayCodesMapping on TAQ_Org_Quota_Approved__c (before insert, before update) {
   
   if(SystemIdUtility.skipTAQ_OrgQuotaApproved) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return; 
      
   List<TAQ_Org_Quota_Approved__c>TAQList = new List<TAQ_Org_Quota_Approved__c>();
     
     List<String> orgQuotaNames = new List<String>();
     for(TAQ_Org_Quota_Approved__c t: trigger.new)
         orgQuotaNames.add(t.Name);
     
     List<TAQ_Org_Quota__c> orgQuotas = [SELECT Id,RecordType.Name,Name from TAQ_Org_Quota__c where Name in: orgQuotaNames];
     Map<String,String> quotaRecordType = new Map<String,String>();
     for(TAQ_Org_Quota__c oq: orgQuotas){
        quotaRecordType.put(oq.name,oq.RecordType.Name);
     }
     
     if(trigger.isInsert)
     {  
       for(TAQ_Org_Quota_Approved__c eachRec: trigger.new)
       {
             if((eachRec.Region__c=='NA' || eachRec.Region__c=='LA' || eachRec.Region__c=='EMEA' || eachRec.Region__c=='WW'))
             {
               if(quotaRecordType.containsKey(eachRec.Name)){
                  if(quotaRecordtype.get(eachRec.Name) != 'Manual Overlay Codes')
                     TAQList.add(eachRec);
               }
               else{
                TAQList.add(eachRec);
               }                                         
             }
       }
     }
     else
     {
        for(TAQ_Org_Quota_Approved__c eachRec: trigger.new)
       {
          TAQ_Organization_Approved__c org= new TAQ_Organization_Approved__c(Id=eachRec.TAQ_Organization_Approved__c);
            //sunji03 - FY19 PS/CAN GEO is added 
             if(((eachRec.Region__c=='NA' || eachRec.Region__c=='PS/CAN') || eachRec.Region__c=='LA' || eachRec.Region__c=='EMEA' || eachRec.Region__c=='WW') )
             {
             
             
             if(quotaRecordType.containsKey(eachRec.Name)){
                  if(quotaRecordtype.get(eachRec.Name) != 'Manual Overlay Codes'){
                        if(trigger.oldMap.get(eachRec.Id).CSU_BU__c != eachRec.CSU_BU__c
                        || trigger.oldMap.get(eachRec.Id).Territory_Country__c != eachRec.Territory_Country__c
                        || trigger.oldMap.get(eachRec.Id).Quota_Type__c != eachRec.Quota_Type__c
                        || trigger.oldMap.get(eachRec.Id).Overlay_Code__c != eachRec.Overlay_Code__c
                        || trigger.oldMap.get(eachRec.Id).Country__c != eachRec.Country__c
                        || trigger.oldMap.get(eachRec.Id).Region__c != eachRec.Region__c
                        || trigger.oldMap.get(eachRec.Id).Area__c != eachRec.Area__c
                        || trigger.oldMap.get(eachRec.Id).Account_Segment__c != eachRec.Account_Segment__c
                        || trigger.oldMap.get(eachRec.Id).Plan_Type__c != eachRec.Plan_Type__c)               
                        {
                             TAQList.add(eachRec);
                        }  
                  }
             }
             else{
                 if(trigger.oldMap.get(eachRec.Id).CSU_BU__c != eachRec.CSU_BU__c
                    || trigger.oldMap.get(eachRec.Id).Territory_Country__c != eachRec.Territory_Country__c
                    || trigger.oldMap.get(eachRec.Id).Quota_Type__c != eachRec.Quota_Type__c
                    || trigger.oldMap.get(eachRec.Id).Overlay_Code__c != eachRec.Overlay_Code__c
                    || trigger.oldMap.get(eachRec.Id).Country__c != eachRec.Country__c
                    || trigger.oldMap.get(eachRec.Id).Region__c != eachRec.Region__c
                    || trigger.oldMap.get(eachRec.Id).Area__c != eachRec.Area__c
                    || trigger.oldMap.get(eachRec.Id).Account_Segment__c != eachRec.Account_Segment__c
                    || trigger.oldMap.get(eachRec.Id).Plan_Type__c != eachRec.Plan_Type__c)              
                 {
                     TAQList.add(eachRec);
                 } 
             }   
                
                  
             } 
       } 
     }
     
   TAQ_OrgQuota_OverlayMapping TAQClass= new TAQ_OrgQuota_OverlayMapping();
   if(TAQList.size()>0){
        TAQClass.Org_Approved_overlayMapping(TAQList);
    }
    
     // FY13 1.1 - QUOTA TYPE CALLIDUS FIELD MAPPING
 TAQ_matchQuotaTypeValue qtObj = new TAQ_matchQuotaTypeValue();
  
  List<TAQ_Org_Quota_Approved__c> quotaList = new List<TAQ_Org_Quota_Approved__c>();
  if(trigger.isInsert){
    for(TAQ_Org_Quota_Approved__c o: trigger.new){
        if(o.Quota_Type__c != null){
            quotaList.add(o);
        }
    }
  }
  else{
    for(TAQ_Org_Quota_Approved__c o: trigger.new){
        if(trigger.oldMap.get(o.Id).Quota_Type__c != o.Quota_Type__c){
            quotaList.add(o);
        }
    }
  }  
   qtObj.matchQuotaTypeCallidus(quotaList);          
}