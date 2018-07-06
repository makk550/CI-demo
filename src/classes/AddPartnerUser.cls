global class AddPartnerUser {
  
    
    webservice static string createPartnerUser(ID ContactID, String UserEmailId,String Firstname)
    {
        string response = '';
        response =ValidateDetails(ContactID, UserEmailId,Firstname);
        if(!String.isblank(response))
        {
            return response;
        }
        else
        {
             Contact Contacts = GetContactInfo(ContactID);
             string localeval =(Contacts.Language_Preference__c!=null && Language_Keys__c.getValues(Contacts.Language_Preference__c)!=null 
                                       ? Language_Keys__c.getValues(Contacts.Language_Preference__c).Language_Key__c:'en_US');
             string country = (contacts.country_picklist__c <> null? contacts.country_picklist__c.substring(0,2):'US');
             string ldaplocalkey =  GetLdapLocalKey(country,localeval);
             List<User> Users = new List<User>();                               
                    User usr = new User(Alias = (Contacts.FirstName.length()<8 ? Contacts.FirstName :Contacts.FirstName.substring(0, 7)),
                                        Email= Contacts.Email,isActive=false,
                                        FirstName=Contacts.FirstName,
                                        ContactId=Contacts.id,
                                        LastName=Contacts.LastName, 
                                        ProfileId = System.label.POB_partnerprofile_salestools,
                                        Username =  'capartner_' + Contacts.Email,
                                        localesidkey=(Contacts.Language_Preference__c !=null 
                                            && Language_Keys__c.getValues(Contacts.Language_Preference__c)!=null 
                                          ? Language_Keys__c.getValues(Contacts.Language_Preference__c).Language_Key__c:'en_US'),
                                        EmailEncodingKey='UTF-8',
                                        TimeZoneSidKey='America/Los_Angeles',
                                        LanguageLocaleKey=(Contacts.Language_Preference__c!=null && Language_Keys__c.getValues(Contacts.Language_Preference__c)!=null 
                                                           ? Language_Keys__c.getValues(Contacts.Language_Preference__c).Language_Key__c:'en_US'),
                                        DefaultCurrencyIsoCode=Contacts.CurrencyIsoCode,
                                        Street=Contacts.MailingStreet,
                                        City=Contacts.Mailing_City_Local__c,
                                        State=Contacts.Mailing_State_Prov_Local__c,
                                        PostalCode=Contacts.Mailing_Postal_Code_Local__c,
                                        Country=Contacts.Country_Picklist__c,
                                        Phone=Contacts.Phone,
                                        CompanyName=Contacts.account.Name,
                                        Is_Admin_for_Partner_Finder_Profile__c=true,
                                        PortalRole='Worker',
                                        Education_Access__c = (Contacts.account.Velocity_Seller__c == True ? False:True),
                                        LDAP_LOCALE_KEY__c = ldaplocalkey                        
                                       );
            
                     Users.add(usr);
                    //insert Users;
                    System.debug('************Usr Details********'+ Usr); 
                                     
                    Database.SaveResult[] usrResult = Database.insert(Users,False);         
                    for(Database.SaveResult res : usrResult){         
                        if(!res.isSuccess()){
                            
                            System.debug('***************Errors********'+ res.getErrors()[0] + UserInfo.getUserId());              
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setSenderDisplayName('CA Support Team');
                            mail.setTargetObjectId(UserInfo.getUserId());
                            mail.setSubject('User Creation Failed');
                            mail.setHtmlBody('Your Request for Partner user creation failed with below exception:<b> ' + res.getErrors()[0] +' </b>.<p>'+
                                             'Please enable the partner by going to the respective contact.');
                            mail.setSaveAsActivity(False);               
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            response ='Error inserting user. Please try again ' + res.getErrors()[0] ;  
                            
                            
                        }    
                        else
                        {
                            System.debug('***************Success******** Partner User created and Sending Email'); 
                            
                           //EmailTemplate templateId = [Select id,HtmlValue,Body  from EmailTemplate where name = 'Partner User Creation Notification'];
                            EmailTemplate templateId = [Select id,HtmlValue,Body,Subject from EmailTemplate where name = 'Partner User Created'];
                            String htmlBody = templateId.HtmlValue;
                            htmlBody = htmlBody.replace('{!User.Name}', UserInfo.getFirstName());
                            //htmlBody = htmlBody.replace('{!Partner_User_Data__c.E_mail__c}', UserEmailId);
                            string userurl =  url.getsalesforcebaseurl().toexternalform() + '/' + usrResult.get(0).getId();
                            htmlBody = htmlBody.replace('{!Partner_User_Data__c.E_mail__c}', '<a href='+userurl+'>'+Firstname+'</a>');// );
                            String plainBody = templateId.Body;
                            plainBody = plainBody.replace('{!User.Name}', UserInfo.getFirstName());
                            plainBody = plainBody.replace('{!Partner_User_Data__c.E_mail__c}', '<a href='+userurl+'>'+Firstname+'</a>');// );
                            
                            // process the merge fields
                            String subject = templateId.Subject;
                            
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setSenderDisplayName('CA Support Team');
                            mail.setTargetObjectId(UserInfo.getUserId());
                            mail.setTemplateID(templateId.Id);   
                            mail.setSaveAsActivity(false);
                            mail.setHtmlBody(htmlBody);
                            mail.setPlainTextBody(plainBody);
                            mail.setSubject(subject);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            
                            response ='Partner User Created successfully.' ;
                            
                        }                       
            
        }
                        return response;
                    
        
        }  
    }
    
    
    public static String ValidateDetails(ID ContactID, String UserEmailId,String Firstname)
    {
        string response = '';
        //Verify the Required fields - Firstname and Emailid
        if(String.isBlank(UserEmailId) || String.isBlank(Firstname)  )
        {
            System.debug('EmailId and Firstname cannot be blank'); 
            return response ='Email Id and Firstname cannot be blank ';    
        }
        //Verify if the user with same email already exists
        List<User> userexist= [SELECT Username, contactid FROM User where Email =: UserEmailId Limit 1 ];
            if(userexist.Size() > 0)
            {
                System.debug('User with the Email already exists.' + UserEmailId); 
                response = (userexist[0].contactid != ContactID) ? 'User with Email already exists with another contact. Please use different Email Id.': 'User with the Email already exists. Please use different Email Id. ';  
                return response ;
            }
        
         //check if the contact is linked to a partner Account                     
                Contact PartnerContact = [SELECT Is_Partner_Acc__c,Name FROM Contact  where Id= :ContactID];
                If(PartnerContact.Is_Partner_Acc__c =='false')
                {
                       System.debug('Enable as Partner functionality is only available for Partner Contacts.' + PartnerContact.Name); 
                       response = 'Enable as Partner functionality is only available for Partner Contacts.'; 
                       return response ;
                }
               //Check if the user already exists
              List<User> Contactexists = [SELECT Username FROM User where ContactId= :ContactID];
                if(!Contactexists.isEmpty())
                {
                    System.debug('User for the contact already exists.' + UserEmailId); 
                    response = 'Partner user already exists'; 
                   // return response ;
                }
        return response;
    }
    
    public static Contact GetContactInfo(ID ContactID)
    {
        Contact Contacts =[SELECT AccountId,Active_User__c,CA_Account_Id__c,Company_Name_Local__c,Company_Name__c,
                           Contact_Type__c,Country_Picklist__c,CPMS_Contact_ID__c,CurrencyIsoCode,Email,FirstName,GEO__c,Id,
                           Is_Partner_Acc__c,Language_Preference__c,LastName,MailingCity,MailingCountry,Mailing_City_Local__c,Account.Name,account.Velocity_Seller__c,
                           Mailing_Country_Code_Local__c,Mailing_Postal_Code_Local__c,Mailing_State_Prov_Local__c,Mailing_Street_Local__c,MailingStreet,Phone
                           FROM Contact where ID= :ContactID];
        
        // if(Contacts.Is_Partner_Acc__c == 'true')
        system.debug('Get Contact information ' +Contacts);
        try
        {
            Partner_Registration__c[] PartnerReg = [SELECT Name FROM Partner_Registration__c WHERE
                                                    TAQ_Account__c IN (SELECT Id FROM TAQ_Account__c WHERE TAQ_Account__c.View_Acc_Record__c= :Contacts.AccountId  )] ;//'001e000000tYAOaAAO')]
            
            if(PartnerReg.size()>0)    
            {
                Contacts.User_Key__c =PartnerReg[0].Name ; 
                update Contacts ;       
                system.debug('Update field User_Key__c for Contact ' +Contacts);    
            }
            else
            {
                Contacts.User_Key__c = 'PR' + Crypto.getRandomInteger().format().replace(',','');      
                update Contacts ;       
                system.debug('Update field User_Key__c for Contact ' +Contacts);   
            }
            
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        return Contacts;
    }
    
    public static String GetLdapLocalKey(String country, String localeval)
    {
        string val;
         string locale = localeval.substring(0,2);
                    if(locale == 'es')
                    {
                        if(country == 'mx' || country == 'ar' || country == 'cl' || country == 'co' || country == 'pe' || country == 've' )
                            val =  locale + '_' + country;
                        else
                            val =  locale + '_' + 'es';
                    }
                    else if (locale == 'fr')
                    {
                        if(country == 'ca' || country == 'ch' || country == 'fr')
                            val =  locale + '_' + country;
                        else
                            val =  locale + '_' + 'fr'; 
                    }
                    else if (locale == 'de')
                    {
                        if(country == 'ch' || country == 'at' || country == 'de')
                            val =  locale + '_' + country;
                        else
                            val =  locale + '_' + 'de'; 
                    }
                    else if (locale == 'en')
                    {
                        if(country == 'gb' || country == 'us' || country == 'za' || country == 'au' || country == 'be' || country == 'hk'  || country == 'in'  || country == 'ae' || country == 'sg' || country == 'ca' || country == 'il' || country == 'se' )
                            val =  locale + '_' + country;
                        else
                            val =  locale + '_' + 'us'; 
                    }
                    else if (locale == 'pt')
                    {
                        val =  locale + '_' + 'br';
                    }
                    else if (locale == 'ja')
                    {
                        val =  locale + '_' + 'jp';
                    }
                    else if (locale == 'zh')
                    {
                        val =  locale + '_' + 'cn';
                    }            
                    else if(locale == 'fr' || locale == 'de' || locale == 'it' || locale == 'ro')
                    {
                        val =  locale + '_' + locale ;
                    }     
        return val;
    }


}