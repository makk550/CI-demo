trigger bibu_setAccountName on Opportunity_Plan__c (before insert, before update) {
    for(Opportunity_Plan__c plan:Trigger.new){
        list<Opportunity_Plan__c> existingPlans = [Select Id from Opportunity_Plan__c where Account__c=:plan.Account__c and isdeleted=false];
        if(existingPlans.isEmpty()){
            Account acc = [select name from Account where id=:plan.Account__c];
            plan.Name = acc.Name;
        }else{
            if(Trigger.isInsert){
                plan.addError('There is already an Opportunity Plan for selected Account. Please select another Account.');
            }
        }
    }
}