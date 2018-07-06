@isTest(seealldata=true)
private class LeadFieldUpdate_Test 
{
static testMethod void testNominalLookup_Lead()
{
          RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('CA Indirect Lead');
          Id recIndirectLeadId = rec.RecordType_Id__c; // record type id for CA Indirect Lead
          Lead lead1 = new Lead(RecordTypeId =recIndirectLeadId ,LastName='dummylastname', Company = 'DummyCompany', Status ='New');
          
          insert lead1;
          
          Campaign c1 = new Campaign(Name ='CA-ITC',Status ='Planned',IsActive =True);
          insert c1;
          Campaign c2 = new Campaign(Name ='CA-ITC1',IsActive =True, Status ='Planned');
          insert c2;
          
          List<CampaignMember> cmlist = new List<CampaignMember>();
          CampaignMember cm = new CampaignMember();
          cm.LeadId = lead1.id;
          cm.CampaignId= c1.id;
          cm.LeadId = lead1.id;
          cm.CampaignId= c2.id;
          cmlist.add(cm);
          insert cmlist;
          LeadFieldUpdate lfupdate = new LeadFieldUpdate();
          lfupdate.UpdateLead(cmlist);
}
}