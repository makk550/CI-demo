trigger UpdateLeadFromCampaign on CampaignMember (after insert, after update, after delete) 
{
  CampaignMember[] cm = Trigger.new;
  if(Trigger.isInsert && Trigger.isAfter)
  {
    LeadFieldUpdate Lfd = new LeadFieldUpdate();
    Lfd.UpdateLead(cm);
  } 
  if(Trigger.isUpdate && Trigger.isAfter)
  {
    LeadFieldUpdate Lfd = new LeadFieldUpdate();
    Lfd.UpdateLead(cm);
    
  } 
  if(Trigger.isDelete && Trigger.isAfter)
  {
    CampaignMember[] cm1 = Trigger.old;
    LeadFieldUpdate Lfd = new LeadFieldUpdate();
    Lfd.UpdateLead(cm1);
    
  }
}