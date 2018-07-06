public with sharing class OpportunityRegistrationGateway {
	
	
	
	
	public static Map<Id, Set<Id>> getOppRegApprovers(Set<Id> OppRegSet)
	{
		Map<Id, Set<Id>> OppRegApps = new Map<Id, Set<Id>>();
		
		for(ProcessInstance p :[select id, TargetObjectId, (Select id, StepStatus,OriginalActorId from Steps) from ProcessInstance where TargetObjectId in :OppRegSet])
		{
			for(ProcessInstanceStep ps: p.Steps )
			{
				if(ps.StepStatus =='Approved')
				{
					if(OppRegApps.get(p.TargetObjectId)== null)
					OppRegApps.put(p.TargetObjectId, new Set<Id>{ps.OriginalActorId});
					else
					{
						Set<id> appIds = OppRegApps.get(p.TargetObjectId);
						appIds.add(ps.OriginalActorId);
						OppRegApps.put(p.TargetObjectId,appIds);
						
					}
				}
			}
			
		}
		return OppRegApps;
	}

}