Public class PRM_Email_Notifications
{                  
    public static Map<string,string> mLocale = new Map<string,string>();
    
    //Map for Language Code and Language 
    public static map<string,string> getMap()
    {
        if(mLocale.keyset().size() ==0)
        {
                mLocale.put('UTF-08','Unicode');
                mLocale.put('ISO-8859-1','General US & Western Europe');
                mLocale.put('Shift_JIS','Japanese');
                mLocale.put('ISO-2022-JP','Japanese');
                mLocale.put('EUC-JP','Japanese');
                mLocale.put('ks_c_5601-1987','Korean');
                mLocale.put('BIG5','Traditional Chinese');
                mLocale.put('GB2312','Simplified Chinese');
                mLocale.put('en_US','English');
                mLocale.put('de','German');
                mLocale.put('es','Spanish');
                mLocale.put('fr','French');
                mLocale.put('it','Italian');
                mLocale.put('ja','Japanese');
                mLocale.put('sv','Swedish');
                mLocale.put('ko','Korean');
                mLocale.put('zh_TW','Chinese (Traditional)');
                mLocale.put('zh_CN','Chinese (Simplified)');
                mLocale.put('pt_BR','Portuguese (Brazilian)');
                mLocale.put('nl_NL','Dutch');
                mLocale.put('da','Danish');
                mLocale.put('th','Thai');
                mLocale.put('fi','Finnish');
                mLocale.put('ru','Russian');
                mLocale.put('en_SG','English');            
                mLocale.put('Danish', 'da ');
                mLocale.put('nl_NL','Dutch');
                mLocale.put('en_US','English');
                mLocale.put('fi','Finnish');
                mLocale.put('fr' ,'French');
                mLocale.put('de','German');
                mLocale.put('it','Italian');
                mLocale.put('ja','Japanese');
                mLocale.put('ko','Korean');
                mLocale.put('pt_BR','Portuguese (Brazil)');
                mLocale.put('ru','Russian');
                mLocale.put('es','Spanish');
                mLocale.put('sv','Swedish');
                mLocale.put('th','Thai');
                mLocale.put('ar','Arabic');
                mLocale.put('bg','Bulgarian');
                mLocale.put('cs','Czech');
                mLocale.put('en_GB','English');
                mLocale.put('el','Greek');
                mLocale.put('es_MX','Spanish (Mexico)');
                mLocale.put('iw','Hebrew');
                mLocale.put('hu','Hungarian');
                mLocale.put('in','Indonesian');
                mLocale.put('no','Norwegian');
                mLocale.put('pl','Polish');
                mLocale.put('ro','Romanian');
                mLocale.put('tr','Turkish');
                mLocale.put('uk','Ukrainian');
                mLocale.put('vi','Vietnamese');
                mLocale.put('sq','Albanian');
                mLocale.put('hy','Armenian');
                mLocale.put('eu','Basque');
                mLocale.put('bs','Bosnian');
                mLocale.put('hr','Croatian');
                mLocale.put('en_AU' ,'English');
                mLocale.put('en_CA','English');
                mLocale.put('en_IN','English');
                mLocale.put('en_MY','English');
                mLocale.put('en_PH','English');
                mLocale.put('et','Estonian');
                mLocale.put('fr_CA','French (Canada)');
                mLocale.put('ka','Georgian');
                mLocale.put('hi','Hindi');
                mLocale.put('is','Icelandic');
                mLocale.put('ga','Irish');
                mLocale.put('lv','Latvian');
                mLocale.put('lt','Lithuanian');
                mLocale.put('lb','Luxembourgish');
                mLocale.put('mk','Macedonian');
                mLocale.put('ms','Malay');
                mLocale.put('mt','Maltese');
                mLocale.put('ro_MD','Moldovan');
                mLocale.put('sh_ME','Montenegrin');
                mLocale.put('pt_PT','Portuguese (European)');
                mLocale.put('rm','Romansh');
                mLocale.put('sr','Serbian (Cyrillic)');
                mLocale.put('sh','Serbian (Latin)');
                mLocale.put('sk','Slovak');
                mLocale.put('sl' ,'Slovenian');
                mLocale.put('tl','Tagalog');
                mLocale.put('ur' ,'Urdu');
                mLocale.put('cy','Welsh');
         }      
      return mLocale;
    }       
    
    public static id emailruleid{get;set;}
    public static id emailruletemplateid{get;set;}
    public static id dealregid{get;set;}
    public static string lang{get;set;}
    public static string getLocale()
    {
    
        try{
                if(lang <> null)
                        return lang;
                else
                        return Userinfo.getLocale();
            }
            catch(exception ex)
            {
                            return 'en_US'; 
            }
    }
    
    
    
    public void sendEmailByUserLocale(string capability, id recordId, string actionstatus, List<String> additionalRecipientsList)
    {
        string languageCode = getLocale() ;
        map<string,string> mlanguage = getMap();
        string languagename = mlanguage.get(languageCode);
        system.debug('___________0');
        
        System.debug('languagename' + languagename);
        System.debug('languageCode' + languageCode);
                
        Email_Rule__c[] ers;
        Email_Rule__c[] ersTemp;
        Set<Id> ersIdSet = new Set<Id>();
        if(capability.contains('Deal'))
        {
            ers = new List<Email_Rule__c>();
            system.debug('___________1');
                        
            dealregid = recordid;
        
             Opportunity opp = [select Deal_Registration_Program__c, account.geo__c, 
             Deal_Registration_Program__r.Partner_Program_Level__c FROM Opportunity 
             WHERE ID=: RECORDID];
             List<String> prgLevels = new List<String>();
             if(opp.Deal_Registration_Program__r.Partner_Program_Level__c != null) {
                if(opp.Deal_Registration_Program__r.Partner_Program_Level__c.indexOf(';') > 0) {
                    String[] tempLevels = opp.Deal_Registration_Program__r.Partner_Program_Level__c.split(';');
                    prgLevels = tempLevels;
                } else {
                    prgLevels.add(opp.Deal_Registration_Program__r.Partner_Program_Level__c);
                }
             }
             system.debug('>>> rule query>>::' + 'Select id, Object__c from Email_Rule__c where Email_Capability__c = \'' + capability  +'\' and action__c = \'' + actionstatus + '\' and Deal_Registration_Program__c = \'' + opp.Deal_Registration_Program__c + ' and partner_program_level__c includes (\'' + opp.Deal_Registration_Program__r.Partner_Program_Level__c +'\' ) ');
             //and partner_program_level__c includes (: opp.Deal_Registration_Program__r.Partner_Program_Level__c ) 
                    
             ersTemp= [Select id, Object__c,partner_program_level__c   from 
             Email_Rule__c where Email_Capability__c = : capability  
             and action__c = : actionstatus 
             and Deal_Registration_Program__c = : opp.Deal_Registration_Program__c 
             //and partner_program_level__c IN :prgLevels 
             // AND region__c = :opp.account.geo__c
             ];

             System.debug('ersTemp-->' + ersTemp); 
             if(prgLevels.size() != 0) { 
                 for(Email_Rule__c temp : ersTemp) {
                    for(String prgLevelTemp : prgLevels) {
                        if(temp.partner_program_level__c != null && temp.partner_program_level__c.indexOf(prgLevelTemp) != -1) {
                            if(!ersIdSet.contains(temp.Id)) {
                                ersIdSet.add(temp.Id);
                                ers.add(temp);
                            }
                        }
                    }
                 }
             } else {
                ers = ersTemp;
             }
        }
        else
        {
        system.debug('___________2');
                        
            ers = [Select id, 
            //Email_Template__c, 
            Object__c from Email_Rule__c where Email_Capability__c = : capability  
            //and  language__c =: languagename 
            and action__c = : actionstatus Limit 1];
        }
        
        if(ers <> null && ers.size() > 0)
                {
                
                system.debug('___________3');
                        
                    Email_Rule__c er = ers[0];
                    emailruleid = er.id;
                    
                    Map<string,List<string>> m= PRM_Email_Notifications.getRecipientsByLocale(er, recordid, additionalRecipientsList, languageCode); 
                    System.debug('Recipient List-->'  +  m);
                    
                    if(m <> null && m.keyset().size() > 0)
                    {
                        set<string> languagenames = new set<string>();
                        
                        for(string langcode:m.keySet())
                            {
                                 languagenames.add(mlanguage.get(langcode));
                            }
                        
                        Map<string, Email_Rule_Template__c> mTemplate = new Map<string, Email_Rule_Template__c>();
                        
                        
                        for(Email_Rule_Template__c ert : [Select id, language__c, email_template__c from Email_Rule_Template__c 
                        where email_rule__C =: er.id and Language__c IN : languagenames ])
                            {
                                mTemplate.put(ert.language__c, ert);
                            }
                    
                        //User u = [Select lastname,firstname,email, locale__c from User where id =: Userinfo.getuserid() ];
                        //Contact con = new Contact(LastName=u.LastName, FirstName = u.FirstName, email=u.Email, locale__c= u.locale__c);
                        Contact con = null;
                        System.debug('capability----->'+capability);
                        //if(!capability.contains('Deal')) {
                            System.debug('capability111111----->'+capability);
                            con = new Contact(LastName='team-sfdcsupport', FirstName = 'team-sfdcsupport', email = System.Label.Notification_Email, locale__c='en_US');
                            insert con; //This contact is created only to enable the templates to have what id of the related records specified.
                        //} 
                        
                        system.debug('___________4');
                        
                        for(string langcode:m.keySet())
                        {
                        
                        system.debug('___________5'+langcode);
                        System.debug('+++++++m++++++++'+m);
                        System.debug('++++++m.keySet()++++'+m.keySet());
                        
                            
                            try{
                                string langname = mlanguage.get(langcode);
                                Email_Rule_Template__c ert = mTemplate.get(langname); //erts[0];
                                if(ert <> null)
                                {
                                    emailruletemplateid = ert.id;
                                    lang = langcode;
                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                    mail.setUseSignature(false);
                                    list<string> s = m.get(lang); //getRecipients(er, recordId, additionalRecipientsList);  
                                    System.debug('++++++++++++++'+s);   
                                
                                  /*
                                   *  COMMENTED BELOW METHODCALL AS THE EMAIL ADDRESS IS BEING SET TWICE PER EMAIL MESSAGE - TADKR01
                                   */
                                 // mail.setToAddresses(s);
                                 
                                 
                                    //mail.setBccAddresses(new String[] { 'godna01@ca.com', 'anssa01@ca.com' });
                                    mail.setTemplateId(ert.email_template__c);//('00XQ0000000E2DW');
                                    //if(!capability.contains('Deal'))
                                     
                                    if(er.object__c=='Contact'){                                      
                                       mail.setTargetObjectId(recordId);
                                       if(capability.contains('Deal'))
                                       {
                                          mail.setToAddresses(s);
                                        System.debug('SetToAddresses -> ' + s);
                                       }
                                     }  
                                    else{                                    
                                      /*
                                   *  ADDED BELOW METHODCALL AS THE EMAIL ADDRESS IS NOT BEING SET PROPERLY.
                                   */
                                        mail.setToAddresses(s);
                                        mail.setTargetObjectId(con.id);                                                                        
                                        mail.setWhatId(recordId);
                                    }
                                    if(actionstatus == 'Referral Partner Registration'){
                                        mail.setCcAddresses(new String[] {Label.ReferralCCAgileemail});
                                    }
                                    
                                    mail.setSaveAsActivity(false);
                                    if(capability.contains('Deal'))
                                        mail.setSenderDisplayName('CApartners@ca.com');
                                    else
                                        mail.setSenderDisplayName('CA SFDC Support');
                                    System.debug('----recordId: '+recordId+'  ert.email_template__c:'+ert.email_template__c + ' To address:' +s );                                  
                               
                                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                   system.debug('___________send');
                                     s.clear();
                               
                                }
                                else
                                {
                                    system.debug('Error:: No Email Template for the language ' + langname + ' found' );
                                }
                            }
                            catch(Exception ex)
                            {
                                System.debug('Error::' + ex);   
                            }
                        
                        }
                        //if(!capability.contains('Deal'))
                            delete con;
                        
                    }
                    else
                    {
                        system.debug('Error: No Email Template found');
                    }
                }
                else
                {
                    system.debug('Error: No Email Rule found');
                }
                
            
                
    
    }   
    
    

    
    
    public static void sendEmailByCapability(string capability, id recordid, string languageCode, string actionstatus, id dealRegProgramId, string region)
    {
        PRM_Email_Notifications p = new PRM_Email_Notifications();
        p.sendEmailByUserLocale(capability,recordid,actionstatus,null);
        
        /*map<string,string> mlanguage = getMap();
        string colorname = mlanguage.get(languageCode);
        if(capability == 'Deal Registration')
            {   
                Email_Rule__c[] ers = [Select id, Email_Template__c, Object__c   from Email_Rule__c where Email_Capability__c = : capability  and  language__c =: colorname and action__c = : actionstatus 
                and Deal_Registration_Program__c = : dealRegProgramId AND region__c = :region];
                
                if(ers <> null && ers.size() > 0)
                {
                    Email_Rule__c er = ers[0];
                    //sendDealCertificateEmail(er,recordid);
                    sendEmail(er,recordid, null);
                }
                else
                {
                    system.debug('Error: No Email Template found');
                }
            }
        else
            sendEmailByCapability(capability, recordid, languageCode, actionstatus) ;
    */
    }
    
    public static void sendEmailByCapability(string capability, id recordid, string languageCode, string actionstatus)
    {
        PRM_Email_Notifications p = new PRM_Email_Notifications();
        p.sendEmailByUserLocale(capability,recordid,actionstatus,null);
        
        /*map<string,string> mlanguage = getMap();
        string colorname = mlanguage.get(languageCode);
        Email_Rule__c[] ers = [Select id, Email_Template__c, Object__c from Email_Rule__c where Email_Capability__c = : capability  and  language__c =: colorname and action__c = : actionstatus ];
        if(ers <> null && ers.size() > 0)
                {
                    Email_Rule__c er = ers[0];
                    sendEmail(er,recordid, null);
            
                }
                else
                {
                    system.debug('Error: No Email Template found');
                }
        */
    }
    
    
    
    public static void sendEmailByCapability(string capability, id recordid, string languageCode, string actionstatus, List<String> additionalRecipientsList)
    {
        PRM_Email_Notifications p = new PRM_Email_Notifications();
        p.sendEmailByUserLocale(capability,recordid,actionstatus,null);
        
        /*
        map<string,string> mlanguage = getMap();
        string languagename = mlanguage.get(languageCode);
        Email_Rule__c[] ers = [Select id, Email_Template__c, Object__c from Email_Rule__c where Email_Capability__c = : capability  and  language__c =: languagename and action__c = : actionstatus ];
        if(ers <> null && ers.size() > 0)
                {
                    Email_Rule__c er = ers[0];
                    sendEmail(er,recordid, additionalRecipientsList);
                }
                else
                {
                    system.debug('Error: No Email Template found');
                }
        */
                
    }
    
    

    public static void sendEmail(Email_Rule__c er, Id recordId, List<string> additionalRecipientsList)
    {
         /* //try
        {
            
        List<string> s = getRecipients(er, recordId, additionalRecipientsList);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(s);
        mail.setTemplateId(er.Email_Template__c);
        //mail.setTargetObjectId('003Q000000ZJAoJ');
        mail.setWhatId(recordId);
        mail.setSaveAsActivity(false);
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        //catch(exception ex)
        {
        //  system.debug('Error in send email:' + ex);
        }*/
        
    }


/*
    public static void sendDealCertificateEmail(Email_Rule__c er, Id oppId) 
    {
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] { 'godna01@ca.com', 'anssa01@ca.com' });
        mail.setTemplateId(er.email_template__c);
        mail.setTargetObjectId(oppid);
        mail.setWhatId('006Q000000AXxwQ');
        mail.setSaveAsActivity(false);
         // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }

*/

  /*

     public static List<string> getRecipients(Email_Rule__c er, id recordid, List<string> additionalRecipientsList)
    {
        List<string> recipientEmailList = additionalRecipientsList;
        if(recipientEmailList == null)
                recipientEmailList = new List<string>();
    
        List<Email_Recipient_Information__c> erilist = [Select Email_Rule__r.Object__c, Field_API__c, Field_Label__c, Recipient_Type__c from Email_Recipient_Information__c Where Email_rule__c =: er.id ];
        if(erilist <> null && erilist.size() > 0)
        {
            map<string, set<string>> mObjectFields = new map<string, set<string>>();
            map<string, set<string>> mEmailFields = new map<string, set<string>>();
            map<string, set<string>> mRelatedUserContactFields = new map<string, set<string>>();
            
            Set<id> UserIds = new Set<id>();
            Set<id> ContactIds = new Set<id>();
            for(Email_Recipient_Information__c eri: erilist)
            {
                if(eri.Recipient_Type__c.contains('User') && ! eri.Recipient_Type__c.contains('Related'))
                {
                    set<string> s = mObjectFields.get('User');
                    if(s==null){s=new set<string>();}
                    s.add(eri.Field_API__c);
                    mObjectFields.put('User',s);
                }
                else if(eri.Recipient_Type__c == 'Email Field')
                {
                    set<string> s = mEmailFields.get(eri.Email_Rule__r.Object__c);
                    if(s==null){s=new set<string>();}
                    s.add(eri.Field_API__c);
                    mEmailFields.put(eri.Email_Rule__r.Object__c,s);
                }
                else if(eri.Recipient_Type__c.contains('Related') )
                {
                    set<string> s = mEmailFields.get(eri.Email_Rule__r.Object__c);
                    if(s==null){s=new set<string>();}
                    string strfield = eri.Field_API__c;
                    if(strfield.indexOf('__c')> 0)
                        strfield = strfield.replace('__c', '__r');
                    else
                        strfield = strfield + 'Id';
                    strfield += '.email';
                    s.add(strfield);
                    mEmailFields.put(eri.Email_Rule__r.Object__c,s);
                }                       
            }   
        //Fetch the email ids of the Users
        
        
        
        
        List<User> ulist = new List<user>();
        if(mObjectFields.get('User') <> null && mObjectFields.get('User').size() > 0) 
            {
                set<string> s = mObjectFields.get('User');
                
                ulist= [Select id, email from User where id in: s];
    
            }
        if(ulist.size() > 0)
            for(User u:ulist)
                recipientEmailList.add(u.email);
        
        
        set<string> emailObjects = mEmailFields.keySet();
        
        if(emailObjects <> null && emailObjects.size() > 0)
        for( string obj: emailObjects)
        {
            set<string> emailFields =   mEmailFields.get(obj);
            if(emailFields <> null && emailFields.size() > 0)
            {
                    String fields = '';
                    for(string em: emailFields)
                        {
                            fields += (fields==''? '':', ') + em; 
                        }
                        
                    if(fields != '')
                    {
                        String strQuery = 'Select ' + fields + ' FROM ' + obj + ' WHERE Id = \'' + recordid + '\'';
                        SObject[] queryObject = Database.query(strQuery);
                        for (SObject objRecord : queryObject)
                        {
                            for(string fld: emailFields)
                            {
                                Object objFieldValue = objRecord.get(fld);
                                if(objFieldValue  <> null)
                                    recipientEmailList.add((string)objFieldValue );
                            }
                        }
                                    
                    }   
                        
                }
        }
        }
        
        return recipientEmailList;
    }    
    */

 public static Map<string,List<string>> getRecipientsByLocale(Email_Rule__c er, id recordid, List<string> additionalRecipientsList, string languagecode)
    {
        
        Map<string,List<string>> m = new Map<string,List<string>>();
        
        List<string> recipientEmailList = additionalRecipientsList;
        
        if(recipientEmailList == null)
                recipientEmailList = new List<string>();

        
        
        m.put(languagecode, recipientEmailList);
         
        
        List<Email_Recipient_Information__c> erilist = [Select Email_Rule__r.Object__c, Field_API__c, Field_Label__c, Recipient_Type__c from Email_Recipient_Information__c Where Email_rule__c =: er.id ];
        
        if(erilist <> null && erilist.size() > 0)
        {
            System.debug('erilist -->' + erilist);
            map<string, set<string>> mObjectFields = new map<string, set<string>>();
            map<string, set<string>> mEmailFields = new map<string, set<string>>();
            map<string, set<string>> mRelatedUserContactFields = new map<string, set<string>>();
            
            Set<id> UserIds = new Set<id>();
            Set<id> ContactIds = new Set<id>();
            Map<string,Map<string,string>> mEmailLocale = new Map<string,Map<string,string>>();
            
            for(Email_Recipient_Information__c eri: erilist)
            {
                if(eri.Recipient_Type__c.contains('User') && ! eri.Recipient_Type__c.contains('Related'))
                {
                    System.debug('getRecipients -- ' + eri.Recipient_Type__c);
                    set<string> s = mObjectFields.get('User');
                    if(s==null){s=new set<string>();}
                    s.add(eri.Field_API__c);
                    mObjectFields.put('User',s);
                }
                else if(eri.Recipient_Type__c == 'Email Field')
                {
                    set<string> s = mEmailFields.get(eri.Email_Rule__r.Object__c);
                    if(s==null){s=new set<string>();}
                    s.add(eri.Field_API__c);
                    mEmailFields.put(eri.Email_Rule__r.Object__c,s);
                }
                else if(eri.Recipient_Type__c.contains('Related'))
                {
                    set<string> s = mEmailFields.get(eri.Email_Rule__r.Object__c);
                    if(s==null){s=new set<string>();}
                    s.add(eri.Field_API__c);
                    mEmailFields.put(eri.Email_Rule__r.Object__c,s);
                    System.debug('asdfdasf' + mEmailFields);
                }

                /*
                else if(eri.Recipient_Type__c.contains('Related') )
                {
                    set<string> s = mEmailFields.get(eri.Email_Rule__r.Object__c);
                    if(s==null){s=new set<string>();}
                    string strfield = eri.Field_API__c;
                    if(strfield.indexOf('__c')> 0)
                        strfield = strfield.replace('__c', '__r');
                    else
                        strfield = strfield + 'Id';
                    
                    
                    Map<string,string> m2 = mEmailLocale.get(eri.Email_Rule__r.Object__c);
                    if(m2 == null) m2 = new Map<string,string>();
                    m2.put(strfield +'.email',strfield +'.locale__c');
                    
                    strfield += '.email';
                    s.add(strfield);
                    
                    mEmailLocale.put(eri.Email_Rule__r.Object__c, m2);
                    mEmailFields.put(eri.Email_Rule__r.Object__c,s);
                }  */                     
            }   
        
        
        //init for users
        recipientEmailList = new List<string>();
        
              
        //init for object fields
        recipientEmailList = new List<string>();
        
        set<string> emailObjects = mEmailFields.keySet();
        
        if(emailObjects <> null && emailObjects.size() > 0)
        for( string obj: emailObjects)
        {
            set<string> emailFields =   mEmailFields.get(obj);
            map<string, string> m2 = mEmailLocale.get(obj);
            
            if(emailFields <> null && emailFields.size() > 0)
            {
                    String fields = '';
                    for(string em: emailFields)
                        {
                            fields += (fields==''? '':', ') + em;
                            if(m.containsKey(em))
                                 fields += (fields==''? '':', ') + m.get(em);
                        }
                        
                    if(fields != '')
                    {
                        String strQuery = 'Select ' + fields + ' FROM ' + obj + ' WHERE Id = \'' + recordid + '\'';
                        SObject[] queryObject = Database.query(strQuery);
                        for (SObject objRecord : queryObject)
                        {
                            for(string fld: emailFields)
                            {
                                Object objFieldValue = objRecord.get(fld);

                                if(objFieldValue != null &&  ((string)objFieldValue).startsWith('005'))
                                {
                                    set<string> s = mObjectFields.get('User');
                                    if(s==null){s=new set<string>();}
                                    s.add((string)objFieldValue);
                                    mObjectFields.put('User',s);
                                }
                                else if(objFieldValue != null &&  ( (string)objFieldValue).startsWith('003'))
                                {
                                    
                                    set<string> s = mObjectFields.get('Contact');
                                    if(s==null){s=new set<string>();}
                                    s.add((string)objFieldValue);
                                    mObjectFields.put('Contact',s);
                                }
                                else if(objFieldValue  <> null)
                                {
                                    string locale ;
                                    if(m2!=null && m2.containsKey(fld))
                                    {
                                        if(objRecord.get(m2.get(fld)) <> null)
                                            locale = (string)objRecord.get(m2.get(fld));    
                                    }
                                    if(locale == null) locale = languagecode;//set default locale
                                    recipientEmailList = m.get(locale);
                                    if(recipientEmailList == null) recipientEmailList = new List<string>();
                                    recipientEmailList.add((string)objFieldValue );
                                    m.put(locale, recipientEmailList);
                                }   
                            }
                        }
                                    
                    }   
                        
                }
        }

        set<id> excludePartnerContacts = new Set<id>(); //to exclude partner contacts

        //Fetch the email ids of the Users
        List<User> ulist = new List<user>();
        if(mObjectFields.get('User') <> null && mObjectFields.get('User').size() > 0) 
            {
                set<string> s = mObjectFields.get('User');
                system.debug('>>>>>111100' +s );  
                
                if(mObjectFields.get('Contact') <> null && mObjectFields.get('Contact').size() > 0) 
                {
                    
                    set<string> sconids = mObjectFields.get('Contact');
                    system.debug('>>>>>111101' +sconids);  
                    ulist= [Select id, email, LocaleSidKey, ContactId from User where id in: s or contactid in : sconids ]; //include partner contacts
                }
                else
                {                            
                    ulist= [Select id, email, LocaleSidKey, ContactId from User where id in: s];
                } 
                
                system.debug('>>>>>1111' +ulist );  
            }
            else  if(mObjectFields.get('Contact') <> null && mObjectFields.get('Contact').size() > 0) 
                {
                    
                    set<string> sconids = mObjectFields.get('Contact');
                    system.debug('>>>>>111101' +sconids);  
                    ulist= [Select id, email, LocaleSidKey, ContactId from User where contactid in : sconids ]; //include partner contacts
                }
            
        if(ulist <> null && ulist.size() > 0)
        {   
            for(User u:ulist)
            {
                if(u.contactid <> null)
                     excludePartnerContacts.add(u.contactid);
                
                recipientEmailList =  m.get(u.LocaleSidKey);
                if(recipientEmailList == null) recipientEmailList = new List<string>();
                recipientEmailList.add(u.email);
                m.put(u.LocaleSidKey, recipientEmailList);
                System.debug('****************2222222**'+recipientEmailList);
            }   
        
        }
        
        List<Contact> clist = new List<Contact>();
        if(mObjectFields.get('Contact') <> null && mObjectFields.get('Contact').size() > 0) 
            {
                set<string> s = mObjectFields.get('Contact');
                System.debug('>>>>>>>>>>>>>>>>>'+s);
                if(excludePartnerContacts <> null && excludePartnerContacts.size() > 0)
                    clist= [Select id, email, locale__c from Contact where id in: s and id not in : excludePartnerContacts ]; //Excluding the partner contacts already included above
                else
                    clist= [Select id, email, locale__c from Contact where id in: s ];
            }
            
        if(clist.size() > 0)
        {   
            for(Contact c:clist)
            {
                String tempLocale = null;
                if(c.locale__c == null)
                    tempLocale = getLocale();
                else
                    tempLocale = c.locale__c;   
                recipientEmailList =  m.get(tempLocale);
                if(recipientEmailList == null) recipientEmailList = new List<string>();
                
                recipientEmailList.add(c.email);
                m.put(tempLocale, recipientEmailList);
                
                System.debug('****************11111111'+recipientEmailList);
            }   
        
        }
        }
        System.debug('****************'+m);
        return m;
    }    



}