trigger Partnerfundinsert on Fund_Participant__c (After Insert) {

    if(Trigger.IsInsert && Trigger.IsAfter){
    list<SFDC_Budget__c> partnerfundlist=New list<SFDC_Budget__c>();
        set<id> FPadminids=New set<id>();
        Map<id,Fund_Programs_Admin__c> fpAdminmap;
        for(Fund_Participant__c fps:Trigger.New){
            FPadminids.add(fps.MDF_Program__c);
        }
        if(FPadminids.size()>0){
    		 fpAdminmap=New Map<id,Fund_Programs_Admin__c>([select id,name,Execution_expiration_date__c,Planning_expiration_date__c from Fund_Programs_Admin__c where id IN:FPadminids]);
        }
     for(Fund_Participant__c fp:Trigger.New){
    if(fp.Partner__c!=Null){
    SFDC_Budget__c pfund=New SFDC_Budget__c();
    pfund.Account__c=fp.Partner__c;
    pfund.FundParticipant__c=fp.id;
    pfund.ownerid=fp.CreatedByid;
    pfund.Active__c=True;
    pfund.Fund_Program__c=fp.MDF_Program__c;
        
    if(fpAdminmap.containsKey(fp.MDF_Program__c)){
    pfund.Name=fp.FundName__c + ' - '+fpAdminmap.get(fp.MDF_Program__c).Name ;
         // populate Execution expiration date and Planning expiration date 
        pfund.End_Date__c=fpAdminmap.get(fp.MDF_Program__c).Execution_expiration_date__c;
        pfund.Start_Date__c=fpAdminmap.get(fp.MDF_Program__c).Planning_expiration_date__c;
        
    }else{
        pfund.Name=fp.FundName__c;
    }
       
    partnerfundlist.add(pfund);
    
    }
    }
    if(partnerfundlist.size()>0){
        insert partnerfundlist;
    }
    }
}