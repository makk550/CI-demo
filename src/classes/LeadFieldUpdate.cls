public class LeadFieldUpdate
{
  public void UpdateLead(CampaignMember[] cmember)
  {
    Set<Id> leadIds = new Set<Id>();
    Set<String> campaignperLead;
    List<Lead> leadforupdate = new List<Lead>();
    String Compname;
    
    
    for (CampaignMember  cm: cmember)
    {
       leadIds.add(cm.LeadId);
       
    }
    for(Lead con:[SELECT id, Compaign_Name1__c,(SELECT id, CampaignId, CreatedDate,Campaign.Name, Campaign.StartDate, Status, LeadId, HasResponded FROM CampaignMembers Order by CreatedDate,HasResponded) FROM Lead where Id IN :leadIds])
    {
      Compname = NULL;
      
      campaignperLead = new Set<String>();
      for(CampaignMember uis: con.CampaignMembers) 
      { 
        IF(uis.CampaignId!= NULL && uis.HasResponded == true)
        {
          Compname = uis.CampaignId;
          
        }
      }
      boolean isUpdateRequired = false;
     
      if(con.Compaign_Name1__c != string.valueof(Compname))
      {
        
        con.Compaign_Name1__c = string.valueof(Compname);
        isUpdateRequired = true;
        system.debug('6----******Lead Updated Compaign Name is*********' + con.Compaign_Name1__c);
        
      }
      if(isUpdateRequired)
        leadforupdate.add(con);
        
    }
     if(leadforupdate.size() > 0)
            update leadforupdate;  
  } 
}