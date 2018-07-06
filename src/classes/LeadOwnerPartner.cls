/* Class to Update Is Lead Owner Partner Flag
@SOQL  #1
@Developed by , Balasaheb Wani, Feb 07, 2011
@client CA
*/
public class LeadOwnerPartner 
{
public void updateIsPartnerUserOwner(List<Lead> lstLead)
    {
        List<Lead> lstFilteredLeads= new List<Lead>();
        set<Id> LeadOwners=new Set<Id>();
        for(Lead Ld : lstLead)
        {
            
            System.Debug('______Lead Owner'+Ld);
            if(ld.OwnerId <> null)
            {
                String strOwnerId=(string)ld.OwnerId;
                if(strOwnerId.startsWith('005'))
                {
                    lstFilteredLeads.add(ld);
                    LeadOwners.add(ld.OwnerId);
                }
            }
        }
        if(LeadOwners <> null)
        {
            Map<id,User> mapUsers = new Map<id,user>([Select u.IsActive, u.Id, u.ContactId From User u where u.Id in :LeadOwners  AND IsActive = true AND ContactId <> null ]);
            System.Debug('______mapUsers'+mapUsers); 
            for(Lead objLead :lstFilteredLeads)
            {
                if(mapUsers.get(objLead.OwnerId) <> null)
                    objLead.Is_Lead_Owner_Partner__c=true;
            
               /* for(User u : lstUsers)
                {
                    if(u.Id==objLead.OwnerId && u.ContactId !=null)
                    {
                        objLead.Is_Lead_Owner_Partner__c=true;
                        break;
                    }               
                }*/
                
            }
        }
        System.Debug('______Tested Anitha');
    }
}