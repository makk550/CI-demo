public with sharing class OpportunityRegistrationHandler implements ITrigger {
	
	public Map<Id, Set<Id>> oppRegApproversMap = new Map<Id, Set<Id>>();
	
	//constructor
	public OpportunityRegistrationHandler()
	{
		
	}
	
	// Bulk methods
	public void bulkBefore()
	{
		if(Trigger.isUpdate) oppRegApproversMap = OpportunityRegistrationGateway.getOppRegApprovers(Trigger.newMap.keySet());
	}
	
	public void bulkAfter()
	{
		
	}
	
	// before methods
	public void beforeInsert(Sobject so)
	{
		Opportunity_Registration__c oppReg = (Opportunity_Registration__c) so;
		
		if(OppReg.First_Approver__c != null)
		OppReg.Is_Required_Approver_1__c = true;
		
		if(OppReg.Second_Approver__c != null)
		OppReg.Is_Required_Approver_2__c = true;
		
		if(OppReg.Third_Approver__c!= null)
		OppReg.Is_Required_Approver_3__c = true;
		
	}
	
	public void beforeUpdate(Sobject oldso, Sobject so)
	{
        
		Opportunity_Registration__c oldOppReg = (Opportunity_Registration__c) oldso;
		Opportunity_Registration__c OppReg = (Opportunity_Registration__c) so;
        system.debug('oldso.registration_status__c'+oldOppReg.registration_status__c);
        system.debug('so.registration_status__c'+OppReg.registration_status__c);
		Set<Id> approvers = oppRegApproversMap.get(OppReg.id);
        if(approvers != null && OppReg.registration_status__c != 'Rejected')
            {
                if(OppReg.First_Approver__c != null)
                if(approvers.contains(OppReg.First_Approver__c) && OppReg.Modifying__c != 'Yes')
                OppReg.Is_Required_Approver_1__c = false;
                else{
                OppReg.Is_Required_Approver_1__c = true;				
                //if(OppReg.Second_Approver__c != null)OppReg.Modifying__c = 'Second';
                }
                if(OppReg.Second_Approver__c != null)
                if(approvers.contains(OppReg.Second_Approver__c) && OppReg.Modifying__c != 'Second')
                OppReg.Is_Required_Approver_2__c = false;
                else{
                OppReg.Is_Required_Approver_2__c = true;
                 //if(OppReg.Third_Approver__c != null)OppReg.Modifying__c = 'Third';  
                }
                if(OppReg.Third_Approver__c != null)
                if(approvers.contains(OppReg.Third_Approver__c) && OppReg.Modifying__c != 'Third')
                OppReg.Is_Required_Approver_3__c = false;
                else{
                OppReg.Is_Required_Approver_3__c = true;
                //OppReg.Modifying__c = 'Approved';
                }
        }
        
		else
		{
            if(OppReg.First_Approver__c != null){
			OppReg.Is_Required_Approver_1__c = true;
            }
		
            if(OppReg.Second_Approver__c != null){
			OppReg.Is_Required_Approver_2__c = true;
            }
		
        if(OppReg.Third_Approver__c!= null){
			OppReg.Is_Required_Approver_3__c = true;
            }
		}
        
	}
	
	public void beforeDelete(Sobject so)
	{
		
	}
	
	// After methods
	public void afterInsert(Sobject so)
	{
		
	}
	public void afterUpdate(Sobject oldso, Sobject so)
	{
		
	}
	
	public void afterDelete(Sobject so)
	{
		
	}
	
	// Finally Method
	public void andFinally()
	{
		
	}

}