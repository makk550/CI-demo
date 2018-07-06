trigger ai_CopyHvnIdToContact on HVN__c (after insert) {
    for(HVN__c hvn:Trigger.New){
        if(hvn.Contact__c!=null){
            Contact cnt = [select HVN_ID__c, HVN__c from Contact where Id=:hvn.Contact__c];
            if(cnt!=null){
                if(cnt.HVN_ID__c!=null){
                    hvn.Contact__c.addError('HVN record already exist for this contact');
                }else{                  
                    cnt.HVN_ID__c = hvn.Id;
                    cnt.HVN__c = true;
                    update cnt;
                }
            }
        }
    }
}