trigger TPCTeamLocation on TPC_Team__c(before update, before insert)
{
    for(TPC_Team__c recUS:Trigger.new)
    {
        if(trigger.isInsert || (trigger.isUpdate && ((trigger.oldMap.get(recUS.Id).NA_Countries__c != recUS.NA_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).WW_Countries__c != recUS.WW_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).LA_Countries__c != recUS.LA_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).EMEA_Countries__c != recUS.EMEA_Countries__c)
                                    || (trigger.oldMap.get(recUS.Id).APJ_Countries__c != recUS.APJ_Countries__c))))
        {                                    
            String locations = '';
            if(recUS.NA_Countries__c!=null)
            {
                locations = locations + recUS.NA_Countries__c+';';
            }
            if(recUS.LA_Countries__c!=null)
            {
                locations = locations + recUS.LA_Countries__c+';';
            }
            if(recUS.EMEA1_Countries__c!=null)
            {
                locations = locations + recUS.EMEA1_Countries__c+';';
            }
           if(recUS.EMEA2_Countries__c!=null)
            {
                locations = locations + recUS.EMEA2_Countries__c+';';
            }           
            if(recUS.APJ_Countries__c!=null)
            {
                locations = locations + recUS.APJ_Countries__c+';';
            }
            if(recUS.WW_Countries__c!=null)
            {
                locations = locations + recUS.WW_Countries__c+';';
            }        
            
            if(locations.length() > 0)
            {
                locations = locations.substring(0,locations.lastindexof(';'));
                locations = locations.toUpperCase();
                locations = locations.replace(Label.User_Skill_Korea_Target, Label.User_Skill_Korea_Replacement);
                locations = locations.replace('UM - UNITED STATES MINOR OUTLYING ISLAND','UM - UNITED STATES MINOR OUTLYING ISLANDS');
                locations = locations.replace('GS - SOUTH GEORGIA AND THE SOUTH SANDWIC','GS - SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS');
                locations = locations.replace('CD - CONGO, THE DEMOCRATIC REPUBLIC OF T','CD - CONGO, THE DEMOCRATIC REPUBLIC OF THE');
                locations = locations.replace('MK - MACEDONIA, THE FORMER YUGOSLAV REPU','MK - MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF');                        
                recUS.Location__c = locations;                
            }
 
         }       
    }
}