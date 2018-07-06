trigger PartnerFundEntry_bi on SFDC_Budget_Entry__c (before insert,before Update,After Update) {
    if(Trigger.IsBefore && Trigger.Isinsert){
    MDF_PopulateCurrencyOnFundEntry.populateCurrencyOnFundEntry(Trigger.new);
    }
    //-------------Ponse01 starts-------------------------------
	 
     Map<string,string> languagetemplatemap=New Map<string,string>();
    Map<string,string> sixtynotlanguagetemplatemap=New Map<string,string>();
   
    // Getting all template id form Custom Settings-Start
            Map<String, MDF_Language_Setting__c> mapStatusCodeCustomSetting = MDF_Language_Setting__c.getAll();
            system.debug('---------'+mapStatusCodeCustomSetting);
    if(mapStatusCodeCustomSetting!=null){
        for(MDF_Language_Setting__c mandatoryRoles : mapStatusCodeCustomSetting.values()){
            if(mandatoryRoles.Recordtype__c=='Notified Check'){
                languagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
            }
           
            
            if(mandatoryRoles.Recordtype__c=='After 60 days'){
                sixtynotlanguagetemplatemap.put(mandatoryRoles.Language__c, mandatoryRoles.Templateid__c);
            }
            
        }
    }
            
    // Getting all template id form Custom Settings-Ends

    
    if(Trigger.IsAfter && Trigger.Isupdate){
      
    Map<id,id> Budget_BEntryMap=new Map<id,id>();
    list<SFDC_Budget__c> pflist=New list<SFDC_Budget__c>();
        list<SFDC_Budget__c> pfundlist=New list<SFDC_Budget__c>();
    Map<id,String> currencymap=New Map<id,String>();
    set<id> partnerfundid=New set<id>();
         Messaging.SingleEmailMessage[] messagesss = 
                                        new List<Messaging.SingleEmailMessage> ();
        map<id,Boolean> notifiedmap=New map<id,Boolean>();
        
        map<id,Boolean> Monnotifiedmap=New map<id,Boolean>();
        set<id> partnerfunentid=New set<id>();
        set<string> partnerfunentaccountid=New set<string>();
        map<string,id> budgetidaccountmap=New map<string,id>();
        map<id,SFDC_Budget_Entry__c> partnersFEMap=New map<id,SFDC_Budget_Entry__c>();
    for(SFDC_Budget_Entry__c sbe:Trigger.new){
        // If planning and expiration dates of budget are changed then reflect them to SFDC_Budget__c as well - amili01
                   Budget_BEntryMap.put(sbe.Budget__c,sbe.id);
       
        
    system.debug('old map----'+Trigger.oldmap.get(sbe.id).CurrencyIsoCode+'  current----'+sbe.CurrencyIsoCode);
    if(Trigger.oldmap.get(sbe.id).CurrencyIsoCode!=sbe.CurrencyIsoCode){
    
        partnerfundid.add(sbe.Budget__c);
        currencymap.put(sbe.Budget__c,sbe.CurrencyIsoCode);
    
    }
        if(sbe.Notified__c==True && Trigger.oldMap.get( sbe.id ).Notified__c!=True){
           
            notifiedmap.put(sbe.Id,true);
            if(!partnersFEMap.containskey(sbe.Budget__c)){
                        partnersFEMap.put(sbe.Budget__c,sbe);
                    }
                    partnerfunentid.add(sbe.Budget__c);
        }else{
            notifiedmap.put(sbe.Id,False);
        }
         
         if(((Trigger.oldMap.get( sbe.id ).Last_Notification_sent_about_Fund__c != Trigger.newMap.get( sbe.id ).Last_Notification_sent_about_Fund__c)&&(sbe.Notified__c==True || Trigger.oldMap.get( sbe.id ).Notified__c==True))){
                 
            	Monnotifiedmap.put(sbe.Id,True);
            	if(!partnersFEMap.containskey(sbe.Budget__c)){
                        partnersFEMap.put(sbe.Budget__c,sbe);
                    }
                    partnerfunentid.add(sbe.Budget__c);
        }else{
            Monnotifiedmap.put(sbe.Id,False);
        }
    
    }
    if(partnerfundid.size()>0 ||partnerfunentid.size()>0){
    
    for(SFDC_Budget__c pf:[select id,CurrencyIsoCode,Account__c from SFDC_Budget__c where Id IN:partnerfundid OR id IN:partnerfunentid]){
        if(currencymap.containskey(pf.id) && partnerfundid.contains(pf.id)){
        // populated planning & execution dates to Budget -amili01
            if(Budget_BEntryMap.containsKey(pf.id)){
            pf.Start_Date__c = Trigger.newmap.get(Budget_BEntryMap.get(pf.id)).Planning_Expiration_Date__c;
        	pf.End_Date__c = Trigger.newmap.get(Budget_BEntryMap.get(pf.id)).Expiration_Date__c;
            }
            pf.CurrencyIsoCode=currencymap.get(pf.id);
            pflist.add(pf);
        }
        if(partnerfunentid.contains(pf.id)){
                string accidss=String.valueOf(pf.Account__c).substring(0, 15);
             system.debug('accids----'+accidss);
            partnerfunentaccountid.add(accidss);
            budgetidaccountmap.put(accidss,pf.id);
        }
    }
        system.debug('partnerfunentaccountid----'+partnerfunentaccountid);
          system.debug('budgetidaccountmap----'+budgetidaccountmap);      
        if(partnerfunentaccountid.size()>0){
            system.debug('=====in After update users=====');
            for(User ur:[select id,Name,toLabel(LanguageLocaleKey),profileid,email,profile.name,contactid,Related_Partner_Account__c from User
                        where Related_Partner_Account__c IN:partnerfunentaccountid and IsActive=True and (profileid=:system.label.MDF_Profile OR profileid=:system.label.MDF_Profile2)]){
                            system.debug('=====in for users=====');
                            if(budgetidaccountmap.containskey(ur.Related_Partner_Account__c) && partnersFEMap.containskey(budgetidaccountmap.get(ur.Related_Partner_Account__c))){
                             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                           //message.toAddresses = new String[] { 'sesidhar.ponnada@ca.com'};
                           //Monnotifiedmap.get(partnersFEMap.get(budgetidaccountmap.get(ur.Related_Partner_Account__c)).id);
                         message.setToAddresses(new String[] {ur.Email});
                            message.setTargetObjectId(ur.Id);
                            message.setWhatId(partnersFEMap.get(budgetidaccountmap.get(ur.Related_Partner_Account__c)).id);
                            if(languagetemplatemap.containskey(ur.LanguageLocaleKey) && notifiedmap.get(partnersFEMap.get(budgetidaccountmap.get(ur.Related_Partner_Account__c)).id)==True){
                                message.setTemplateId(languagetemplatemap.get(ur.LanguageLocaleKey));
                            }else if(!languagetemplatemap.containskey(ur.LanguageLocaleKey) && notifiedmap.get(partnersFEMap.get(budgetidaccountmap.get(ur.Related_Partner_Account__c)).id)==True){
                                message.setTemplateId(languagetemplatemap.get('English'));
                            }
                            else if(sixtynotlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && Monnotifiedmap.get(partnersFEMap.get(budgetidaccountmap.get(ur.Related_Partner_Account__c)).id)==True){
                                message.setTemplateId(sixtynotlanguagetemplatemap.get(ur.LanguageLocaleKey));
                            }else if(!sixtynotlanguagetemplatemap.containskey(ur.LanguageLocaleKey) && Monnotifiedmap.get(partnersFEMap.get(budgetidaccountmap.get(ur.Related_Partner_Account__c)).id)==True){
                                 message.setTemplateId(sixtynotlanguagetemplatemap.get('English'));
                            }
                          message.saveAsActivity = false;
                            //message.setHtmlBody(body);
                 messagesss.add(message);
                        }
           }
            if(messagesss.size()>0){
                 Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesss);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: '
                          + results[0].errors[0].message);
                    }
            }
            
            
        }
        
        
    if(pflist.size()>0){
        update pflist;
    }
   }
    //------------------ponse01 Ends--------------------------------------
    System.debug('+++++++++++++++++++ Budget_BEntryMap +++++++'+Budget_BEntryMap.size());
    }
}