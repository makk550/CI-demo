trigger ai_InitDrivers on Opportunity_Plan__c (after insert) {
    for(Opportunity_Plan__c plan:Trigger.New){
        List<NCV_Driver_Info__c> drivers = [select id from NCV_Driver_Info__c where isdeleted=false];
        for(NCV_Driver_Info__c driver:drivers){
            Opportunity_Plan_Detail__c planDet = new Opportunity_Plan_Detail__c();
            planDet.NCV_Driver_Info__c = driver.id;
            planDet.Opportunity_Plan__c = plan.id;
            insert planDet; 
        }
    }
}