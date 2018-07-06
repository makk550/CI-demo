public class PRM_Email_Rule_Ext {

            public string findstring {get;set;}   
            public Email_Recipient_Information__c eri{get;set;}
            Map<string,string> m = new Map<string,string>();
            public email_rule__C er{get;set;}
            public List<Email_Rule_Template__C> lstTemplates {get;set;}
            
            public integer getsize1()
            {
                if(recipientList !=null)
                    return recipientList.size();
                else
                    return 0;    
            }
            
            public integer getsize2()
            {
                if(recipientSelectedList !=null)
                    return recipientSelectedList.size();
                else
                    return 0;
            }
            
           public List <Email_Rule_Template__c> lst {get;set;}
            
            public PRM_Email_Rule_Ext(ApexPages.StandardController controller) 
            {
                er = (email_rule__c)controller.getRecord();
                if(er==null){er = new Email_rule__c();}               

                
                if(m.keyset().size() ==0)
                {
                    m.put('UTF-08','Unicode');
                    m.put('ISO-8859-1','General US & Western Europe');
                    m.put('Shift_JIS','Japanese');
                    m.put('ISO-2022-JP','Japanese');
                    m.put('EUC-JP','Japanese');
                    m.put('ks_c_5601-1987','Korean');
                    m.put('BIG5','Traditional Chinese');
                    m.put('GB2312','Simplified Chinese');
                  }
                  loadRecipients(er.id);
                  loadTemplates(er);
                if(eri == null) { eri =  new Email_Recipient_Information__c();}
                
            }
            
            map<string,id> origRecipientsMap = new Map<string,id>();
            
            public void loadTemplates(Email_Rule__c er)
            {
                
                 if(er<>Null && er.Id<> null)
                {
                       lst =[Select  e.View_Email_Template__c, e.Name, e.Language__c, 
                                e.Id, e.Email_Template__c, e.Email_Rule__c, 
                                e.Email_Address_Text__c,e.Email_Body_Text__c, Email_Copyright_Text__c, 
                                e.Certificate_Submission_Text__c, e.Certificate_Heading_Text__c, 
                               // e.Email_Body_Text_Line_2__c,
                                e.Certificate_Details_Text__c, e.Certificate_Account_Manager_Text__c 
                                from Email_Rule_Template__c e where Email_Rule__c = :er.id];
                }
                
                 if(lst == null || lst.size() == 0)
                {
                        Schema.DescribeFieldResult F = Email_Rule_Template__c.Language__c.getDescribe();
                                        List<Schema.PicklistEntry> P = F.getPicklistValues();
                                        lst = new List<Email_Rule_Template__c>();
                                        for(Schema.PicklistEntry pe:p)
                                        {
                                                        
                                                Email_Rule_Template__c e = new Email_Rule_Template__c(Email_Rule__r =  er,Language__c= pe.getValue());
                                                e.Certificate_Details_Text__c = Email_Rule_Template__c.Certificate_Details_Text__c.getDescribe().getInlineHelpText();
                                                e.Certificate_Account_Manager_Text__c = Email_Rule_Template__c.Certificate_Account_Manager_Text__c.getDescribe().getInlineHelpText();
                                                e.Email_Address_Text__c = Email_Rule_Template__c.Email_Address_Text__c.getDescribe().getInlineHelpText();
                                                e.Email_Body_Text__c = Email_Rule_Template__c.Email_Body_Text__c.getDescribe().getInlineHelpText();
                                                e.Email_Copyright_Text__c = Email_Rule_Template__c.Email_Copyright_Text__c.getDescribe().getInlineHelpText();
                                                e.Certificate_Submission_Text__c = Email_Rule_Template__c.Certificate_Submission_Text__c.getDescribe().getInlineHelpText();
                                                e.Certificate_Heading_Text__c = Email_Rule_Template__c.Certificate_Heading_Text__c.getDescribe().getInlineHelpText();
                                                lst.add(e);
                                        
                                        }
                
                }
                
                
            
            }
            
            
            public void loadRecipients(id erid)
            {
                if(erid <> null)
                {
                    mapSelRec = new Map<string,string>();
                    recipientSelectedList = new List<SelectOption>();
                    for(Email_Recipient_Information__c eri:[ Select id,email_rule__c, recipient_type__c, field_label__c, field_api__c from Email_Recipient_Information__c where email_rule__c =: erid ])
                             { 
                                 mapSelRec.put(eri.field_api__c,eri.recipient_type__c + ' :' + eri.field_label__c);
                                 recipientSelectedList.add(new SelectOption(eri.field_api__c, eri.recipient_type__c + ' :' + eri.field_label__c));
                                 origRecipientsMap.put(eri.field_api__c, eri.id); 
                             } 
                               
                }
                
            }
            
            
            public PageReference SaveRule()
            {
                upsert er;
                saveERI(er.id);
                for(Email_Rule_Template__c e: lst)
                  {
                         if(e.Email_Rule__c == null)
                                e.Email_Rule__c = er.id;
                  }
                upsert lst;
                
                pagereference pg = new pagereference('/' + er.id);
                pg.setredirect(true);
                return pg;
            }
            
            public PageReference removeRecipents()
            {
                    for (String str: mapSelRec.keyset())
                    {
                         mapSelRec.keyset().remove(str);
                         if(origRecipientsMap.keySet().contains(str))
                              lstDelete.add(new Email_Recipient_Information__c(id=origRecipientsMap.get(str)));
                     }
        
                     return null;
            }
            
            
            public String selectedTemplateId { public get; public set; }
        
            public List<SelectOption> getMyPersonalTemplateOptions() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('', '--None--'));
                for (EmailTemplate t : [
                    select Id,Name, Encoding 
                    from EmailTemplate
                    where Folder.Name= :('PRM ' + er.Email_Capability__c + ' Templates') ])
                {
                    options.add(new SelectOption(t.Id,t.Name )); //+ '['+ t.Encoding + m.get(t.Encoding) + ']'
                }
                return options;
            }
    
                public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                public Map<string,string> mapRec = new Map<string,string>();
                public List <SelectOption> RecipientTypes{set;get;}
                public List <SelectOption> objectNames{set;}
                public List <SelectOption> recipientList{get;set;}
                public List <string> recipientString{get;set;}
                public List <SelectOption> recipientSelectedList{get;set;}
                public List <string> recipientSelectedString{get;set;}
                public String selectedObject {get; set;}
                
               public void AddTemplates () {
                
                        if(lst == null)
                                lst= new List<Email_Rule_Template__c>();
                        
                        Email_Rule_Template__c et = new Email_Rule_Template__c();
                        
                        et.Email_Rule__r =  er;                 
                    lst.add(et);
                    
                    } 
                
                
           
                public pageReference addValues() 
                {
                        if( recipientSelectedList == null) { recipientSelectedList = new List<SelectOption>();}
                        
                        if(recipientString <> null && recipientString.size() > 0)
                        {    
                             for(string str:recipientString)
                                            { 
                                                mapSelRec.put(str,mapRec.get(str));
                                                recipientSelectedList.add(new SelectOption(str, mapRec.get(str)));
                                                mapRec.keyset().remove(str);
                                            }   
                             recipientString = new  List<string>();
                             List<SelectOption> tempList = new List<SelectOption>();
                             for(SelectOption so: recipientList)
                             {
                                 if(mapRec.keyset().contains(so.getvalue()))
                                 {
                                     tempList.add(so);
                                 }
                             }
                             recipientList = tempList;
                         }             
                     return null;
                }
                
                private map<string,string> mapSelRec= new map<string,string>();
                
                
                 List<Email_Recipient_Information__c> lstDelete = new List<Email_Recipient_Information__c>();
            
        
                
                public pageReference removeValues() 
                {
                     if( recipientList == null) { recipientList = new List<SelectOption>();}
                     if(recipientSelectedString <> null && recipientSelectedString.size() > 0)
                       {    
                          for(string str:recipientSelectedString)
                                    { 
                                       if(eri.recipient_type__c <> null && mapSelRec.get(str).contains(eri.recipient_type__c))
                                            recipientList.add(new SelectOption(str, mapSelRec.get(str)));
                                       mapSelRec.keyset().remove(str);
                                     
                                     //
                                      if(origRecipientsMap.keySet().contains(str))
                                                                         lstDelete.add(new Email_Recipient_Information__c(id=origRecipientsMap.get(str)));
        
                                        
                                    }   
                     recipientSelectedString = new  List<string>();
                     List<SelectOption> tempList = new List<SelectOption>();
                     for(SelectOption so: recipientSelectedList)
                     {
                         if(mapSelRec.keyset().contains(so.getvalue()))
                         {
                             tempList.add(so);
                         }
                     }
                     
                     recipientSelectedList = tempList;
                 }             
                  return null;
                }
                
                
                public void showFields() {
                        mapRec= new map<string,string>();
                            if(eri.Recipient_Type__c.contains('Field')|| eri.Recipient_Type__c.contains('Related'))
                        {
                            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(er.Object__c).getDescribe().fields.getMap();
                            recipientList = new List<SelectOption>();
                            for(Schema.SObjectField sfield : fieldMap.Values())
                            {
                                    schema.describefieldresult dfield = sfield.getDescribe();
                                   if((eri.Recipient_Type__c.contains('Email') && (dfield.getType()+ '') == 'Email')  || (dfield.getReferenceTo()+'').replace('(','').replace(')','').equals(eri.recipient_type__c.replace('Related ','')))
                                    { 
                                        mapRec.put(dfield.getname(), eri.Recipient_Type__c + ': ' + dfield.getLabel());
                                        recipientList.add(new SelectOption(dfield.getname(), eri.Recipient_Type__c + ': ' + dfield.getLabel()));
                                    }    
                            }
                        
                       }
                       else if(eri.Recipient_Type__c.contains('User'))
                       {
                                recipientList = new List<SelectOption>();
                            
                                for(User u:[Select id, name, username from User Where UserType LIKE : (eri.Recipient_Type__c.contains('Partner')?'%Partner%':'Standard') and name LIKE :('%' + findstring + '%') and isactive = true  LIMIT 100 ])
                                {
                                              mapRec.put(u.id, eri.Recipient_Type__c + ': ' + u.name);
                                      recipientList.add(new SelectOption(u.id, eri.Recipient_Type__c + ': ' + u.name));
                            }
                       
                       } 
                        
                }
                
             

        public void saveERI(id erid)
        {
            //Email_Recipient_Information__c eri
            List<Email_Recipient_Information__c> eriList = new List<Email_Recipient_Information__c>();
            set<string> finalReciepientSet = new set<string>();
            
            for(string str:mapSelRec.keySet())
            {
               id recid = origRecipientsMap.get(str); 
               Email_Recipient_Information__c eri;
               if(recid == null)
                {  eri = new Email_Recipient_Information__c();    
                   eri.email_rule__c = erid;
                   eri.field_api__c = str;
                   eri.recipient_type__c = mapSelRec.get(str).split(':',0)[0];
                   eri.field_label__c = mapSelRec.get(str).split(':',0)[1];
                   finalReciepientSet.add(eri.field_api__c);
                   eriList.add(eri); 
               } 
            }
            
           
            if(lstDelete    !=null && lstDelete.size() > 0)
                delete lstDelete;
            
            
            if(eriList <> null && eriList.size() > 0)
                upsert eriList;
        }

}