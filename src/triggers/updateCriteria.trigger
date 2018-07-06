trigger updateCriteria on TAQ_Organization__c (before insert, before update) {    
//US419453 - lanth02 - 12/14/2017
//Updated trigger to account for FY18 plans that require 4 MBO criteria. Also changed from using custom lables to custom settings to store the MBO specific plans
     
   	if(SystemIdUtility.skipTAQ_Organization) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
    if(trigger.isupdate)
    {
        for(TAQ_Organization__c tOrg: trigger.new)
        {
        	Map<String, MBO_Criteria_Plans__c> plans = MBO_Criteria_Plans__c.getAll();
            if (plans != NULL) {
                if (!plans.isEmpty()){
                    if(trigger.oldmap.get(tOrg.id).Plan_Type__c != tOrg.Plan_Type__c || trigger.oldmap.get(tOrg.id).Criteria__c != tOrg.Criteria__c)
                    {
                        if (plans.containsKey(tOrg.Plan_Type__c)){
                            if (tOrg.Criteria__c != null){
                                String[] CriteriaSplit = tOrg.Criteria__c.split(';');
                                System.debug('--CriteriaSplit:'+CriteriaSplit);
                                if(CriteriaSplit.size() == 4)
                                {
                                    tOrg.Criteria_1__c = CriteriaSplit[0];
                                    tOrg.Criteria_2__c = CriteriaSplit[1];
                                    tOrg.Criteria_3__c = CriteriaSplit[2];
                                    tOrg.Criteria_4__c = CriteriaSplit[3];
                                } else {
                                    tOrg.addError('Please select exactly 4 criteria for the Account Development Plan chosen');
                                }     
                            } else {
                                tOrg.addError('Please select exactly 4 criteria for the Account Development Plan chosen');
                            } 
                        } else if (trigger.oldmap.get(tOrg.id).Plan_Type__c != tOrg.Plan_Type__c && plans.containsKey(trigger.oldmap.get(tOrg.id).Plan_Type__c)){                     
                            tOrg.Criteria_1__c = '';
                            tOrg.Criteria_2__c = '';
                            tOrg.Criteria_3__c = '';
                            tOrg.Criteria_4__c = '';
                        }
                    }
                }
            }
    	}// End For Loop
    }
    if(trigger.isinsert)
    {
        for(TAQ_Organization__c tOrg: trigger.new)
        {
            Map<String, MBO_Criteria_Plans__c> plans = MBO_Criteria_Plans__c.getAll();
            if (plans != NULL){
                if (!plans.isEmpty()){
                    if (plans.containsKey(tOrg.Plan_Type__c)){
                        if (tOrg.Criteria__c != null){
                            String[] CriteriaSplit = tOrg.Criteria__c.split(';');
                            System.debug('--CriteriaSplit:'+CriteriaSplit);
                            if(CriteriaSplit.size() == 4)
                            {
                                tOrg.Criteria_1__c = CriteriaSplit[0];
                                tOrg.Criteria_2__c = CriteriaSplit[1];
                                tOrg.Criteria_3__c = CriteriaSplit[2];
                                tOrg.Criteria_4__c = CriteriaSplit[3];
                            } else {
                                tOrg.addError('Please select exactly 4 criteria for the Account Development Plan chosen');
                            }     
                        } else {
                            tOrg.addError('Please select exactly 4 criteria for the Account Development Plan chosen');
                        } 
                    }
                }
            }
       	}// End For Loop
    }
}