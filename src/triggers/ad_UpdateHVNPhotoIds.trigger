trigger ad_UpdateHVNPhotoIds on Attachment (before delete) {
    List<HVN__c> hvnList  = new List<HVN__c>();
    List<Account> accList  = new List<Account>();

    for(Attachment att:Trigger.old){
        try{
            HVN__c[] hvns = [select HVN_Contact_Photo_ID__c from HVN__c where HVN_Contact_Photo_ID__c=:att.Id];
            for(HVN__c hvn:hvns){
                hvn.HVN_Contact_Photo_ID__c = '';
                hvnList.add(hvn);
            }

            Account[] accs= [select Company_Logo_ID__c  from Account where Company_Logo_ID__c=:att.Id];
            for(Account acc:accs){
                acc.Company_Logo_ID__c = '';
                accList.add(acc);
            }
            update hvnList;
            update accList;
        }catch(Exception e){}
    }
}