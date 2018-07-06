//Trigger for Auto Creation of DDR
//Developer : Saba Ansari
//Created Date : 1/15/2011
trigger ServiceRequest_Auto_Create_DDR on Services_Request__c (after update) 
{
    List<Services_Request__c> lstSR = new List<Services_Request__c>();
    integer count = 0;
    set<id> oppids = new set<id>();
    
    for(Services_Request__c sr: trigger.new)
    {
        if(sr.Oppty_Name__c != null && sr.Services_Request_Status__c == 'DDR Creation' && trigger.old[count].Services_Request_Status__c != 'DDR Creation' )
        {
            lstSR.add(sr); 
            oppids.add(sr.Oppty_Name__c); 
        } 
    }
    
    if(lstSR.size() > 0)
    {
        map<id,opportunity> mapOpp = new map<id,opportunity>([select id, name,type,StageName,closedate from Opportunity where id in: oppids]);
        List<Deal_Desk_Review__c> lstDDR = new List<Deal_Desk_Review__c>();
    
        for(Services_Request__c sr: lstSR)
        {
                Opportunity opp = mapOpp.get(sr.Oppty_Name__c);
                Deal_Desk_Review__c ddr = new Deal_Desk_Review__c();
                ddr.Services_Request__c = sr.id;
                ddr.Opportunity_Name__c = sr.Oppty_Name__c; 
                ddr.Oppty_Number__c = sr.Oppty_Number__c;
                ddr.Opportunity_Owner__c = opp.Owner.Name; // Anthony Russell - replace sr.Oppty_Owner__c with opp.Owner Replacing sr field with formula field from Opp
                ddr.Type__c = opp.type; 
                ddr.Sales_Milestone__c = opp.stagename;
                ddr.Oppty_Close_Date__c = opp.closedate;
                ddr.Oppty_Amount__c = sr.Opportunity_Amount__c ;
                ddr.Account_Name__c = sr.Account_Name__c;
                ddr.Region__c = sr.Account_Region__c; 
                ddr.Area__c = sr.Account_Area__c;
                ddr.Territory__c = sr.Account_Territory__c ;
                ddr.Area02__c = sr.Country__c;                
                ddr.Deal_Desk_Request_Type__c= sr.Transaction_Type__c;
                lstDDR.add(ddr);
            
        }
        
        if(lstDDR.size() > 0)
           database.insert(lstDDR);
    
    }        
   
}