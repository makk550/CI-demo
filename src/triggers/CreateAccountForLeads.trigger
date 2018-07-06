trigger CreateAccountForLeads on Lead(After insert) {
    set<Id> accountIds = new set<Id>();
    List<Lead> listLead = new List<Lead>();
    String[] toAddresses = new String[] {'NYKTH01@ca.com','sunji03@ca.com','SnehaSunil.Babur@ca.com'};
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    //Set<Id> recordTypeId=new Set<Id>();
    //Id recordTypeId;
      string recordTypeId = [SELECT id from RecordType where Name ='Generic Record Type'].Id;
      Id ownerId=[select id from user where Alias='Gowner' Limit 1].id;
    if(trigger.isAfter && trigger.isInsert){
        for(Lead obj : trigger.new){
                  accountIds.add(obj.Commercial_Account__c);         
        }       
    } 
    
  
    integer count=0;  
    if(!accountIds.isEmpty()&&recordTypeId!=null){
        string accName;
        String numb='';
        string nme='';
        List<Lead> listleadsData = [SELECT Id,Commercial_Account__r.name,RandomNumber__c,Name,Commercial_Account__c,RecordTypeId FROM Lead WHERE Commercial_Account__c IN : accountIds AND Commercial_Account__r.RecordTypeId =:recordTypeId];
          // Blob  blobKey=Crypto.generateAesKey(128);
           //string key=EncodingUtil.convertToHex(blobKey);
           //string nme=key.substring(0,2);
        if(listleadsData.size()>0){
             numb=String.valueOf(Integer.valueOf(listleadsData[0].RandomNumber__c));
             nme=numb.substring(0,2);
        }
        if(listleadsData.size()>0&&listleadsData!=null){
           if(listleadsData.size()>=10000){
             for(Lead lisLead:listleadsData){
                 if(lisLead.Commercial_Account__r.name!=null){
                   accName=lisLead.Commercial_Account__r.name;
                 }
                }
                Account acc = new Account();
                acc.Name = accName+nme;
                acc.RecordTypeId=recordTypeId;
                acc.OwnerId=ownerId;
            if(acc!=null)
                Insert acc;
            for(Lead led : trigger.new){
                Lead le = new Lead();
                    le.Id = led.Id;
                    le.Commercial_Account__c = acc.Id;
                listLead.add(le);
            }
             Account_Names_For_leads__c customSettingData = new Account_Names_For_leads__c();
                customSettingData.Name = acc.Name;
            Insert customSettingData; 
        
        email.setToAddresses(toAddresses);
        email.setHtmlBody('This is to inform you that a new generic account is created.'+'All the leads will now be associated to this account'+' '+'Account id:'+acc.id);
        email.setSubject('New Generic account created ');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        }
    if(listLead!=null&&listLead.size()>0)
        update listLead;
    }
}