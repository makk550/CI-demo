trigger sendWelcomeEmail on User(after update, after insert) {

    //This trigger will send a Welcome Email to all new users and any users who are reactivated. Requested by Iris Mintz.

    User[] userAfter = Trigger.new;
    if(Trigger.isInsert){
    
        for(Integer i=0 ; i < userAfter.size(); i++){
        
            if((userAfter[i].IsActive  == true) && (userAfter[i].UserType == 'Standard')){
                  
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(userAfter[i].id);
                mail.setTemplateId('00X30000001CA1L'); //mail.setTemplateId('00XQ0000000QC7p');
                mail.setReplyTo('noreply@ca.com');
                mail.setOrgWideEmailAddressId('0D230000000GmoQ');                       
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                          //FOR JIGSAW
                If(UserAfter[i].profileId != '00e30000001FlzU' //ServiceDesk Admin
                   && UserAfter[i].profileId != '00e30000000pLJe' //System Administrator XI 
                   && UserAfter[i].profileId != '00e300000014q4b' // Refstor Integration
                   && UserAfter[i].profileId != '00e30000000nOD5' //Read Only 
                   && UserAfter[i].profileId != '00e30000000oEVu' //Integration User
                   && UserAfter[i].profileId != '00e30000000oF0a' //  Indirect Integration
                   && UserAfter[i].profileId != '00e30000000noJ5' // Integration Profile
                   && UserAfter[i].profileId != '00e30000001FlxD' //Global Trainer
                   && UserAfter[i].profileId != '00e30000000nahr' // 5.0 CA New User
                   && UserAfter[i].profileId != '00e30000001Fmf8' // 4.0 Read Only – Japan
                   && UserAfter[i].profileId != '00e30000001GLDT' // 4.0 Read Only (PRM)
                   && UserAfter[i].profileId != '00e30000001FmPa' // 4.0 Read Only
                   && ((UserAfter[i].Title != null && UserAfter[i].Title.toUpperCase().indexOf('NON') > -1  && UserAfter[i].Title.toUpperCase().indexOf('EMPLOYEE') > -1  ) != true)
                   && UserInfo.getOrganizationId().indexOf('00D300000006yn4') > -1 //To be commented in test for testing
                )
                {
                        mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'carequest@jigsaw.com'};
                        String[] bccAddresses = new String[] {'george.white@ca.com'};
                        mail.setToAddresses(toAddresses);
                        mail.setbCcAddresses(bccAddresses);
                        // Specify the address used when the recipients reply to the email.
                        mail.setReplyTo('donotreply@ca.com');
                        mail.setSenderDisplayName('CA Technologies');
                        mail.setSubject('User Activation Request');    
                        mail.setBccSender(false);
                        mail.setUseSignature(false);
                        mail.setPlainTextBody('Please activate the following CA User - First Name : ' + userAfter[i].FirstName +', Last Name : ' + userAfter[i].LastName +', Pmfkey : ' + userAfter[i].Pmfkey__c +'. Thank you');
                        mail.setHtmlBody('Please activate the following CA User <br/><br/>' +
                        ' <b> First Name </b> : ' + userAfter[i].FirstName + ' <br/>' +
                        ' <b> Last Name </b> : ' + userAfter[i].LastName +' <br/>' +
                        ' <b> Pmfkey </b> : ' + userAfter[i].Pmfkey__c +' <br/><br/>' +
                        'Thank you');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                     }   
                
            }
        }
    }
    
    if(Trigger.isUpdate){
    
        User[] userBefore = Trigger.old;
        
        for(Integer i=0 ; i < userAfter.size(); i++){
        
            if((userBefore[i].IsActive == false)&& (userAfter[i].IsActive == true) && (userAfter[i].UserType == 'Standard')){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(userAfter[i].id);
                mail.setTemplateId('00X30000001CA1L');
                mail.setReplyTo('noreply@ca.com');
                mail.setOrgWideEmailAddressId('0D230000000GmoQ');                 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               }
               
              If( userBefore[i].IsActive != userAfter[i].IsActive) //consider activating and deactivating both cases
               { 
                //FOR JIGSAW
                If(UserAfter[i].profileId != '00e30000001FlzU' //ServiceDesk Admin
                   && UserAfter[i].profileId != '00e30000000pLJe' //System Administrator XI 
                   && UserAfter[i].profileId != '00e300000014q4b' // Refstor Integration
                   && UserAfter[i].profileId != '00e30000000nOD5' //Read Only 
                   && UserAfter[i].profileId != '00e30000000oEVu' //Integration User
                   && UserAfter[i].profileId != '00e30000000oF0a' //  Indirect Integration
                   && UserAfter[i].profileId != '00e30000000noJ5' // Integration Profile
                   && UserAfter[i].profileId != '00e30000001FlxD' //Global Trainer
                   && UserAfter[i].profileId != '00e30000000nahr' // 5.0 CA New User
                   && UserAfter[i].profileId != '00e30000001Fmf8' // 4.0 Read Only – Japan
                   && UserAfter[i].profileId != '00e30000001GLDT' // 4.0 Read Only (PRM)
                   && UserAfter[i].profileId != '00e30000001FmPa' // 4.0 Read Only
                   && ((UserAfter[i].Title != null && UserAfter[i].Title.toUpperCase().indexOf('NON') > -1  && UserAfter[i].Title.toUpperCase().indexOf('EMPLOYEE') > -1  ) != true)
                   && UserInfo.getOrganizationId().indexOf('00D300000006yn4') > -1 //To be commented in test for testing
                )
                {
                
                        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'carequest@jigsaw.com'};
                        mail.setToAddresses(toAddresses);
                        mail.setReplyTo('donotreply@ca.com');
                        mail.setOrgWideEmailAddressId('0D230000000GmoQ');                 
                       if(userAfter[i].IsActive)
                                mail.setSubject('User Activation Request');    
                        else
                                mail.setSubject('User Deactivation Request');    
                        mail.setBccSender(false);
                        mail.setUseSignature(false);
                        mail.setPlainTextBody('Please ' + ((userAfter[i].IsActive)? 'activate' :'deactivate') + ' the following CA User - First Name : ' + userAfter[i].FirstName +', Last Name : ' + userAfter[i].LastName +', Pmfkey : ' + userAfter[i].Pmfkey__c +'. Thank you');
                        mail.setHtmlBody('Please ' + ((userAfter[i].IsActive)? 'activate' :'deactivate') + ' the following CA User <br/><br/>' +
                        ' <b> First Name </b> : ' + userAfter[i].FirstName + ' <br/>' +
                        ' <b> Last Name </b> : ' + userAfter[i].LastName +' <br/>' +
                        ' <b> Pmfkey </b> : ' + userAfter[i].Pmfkey__c +' <br/><br/>' +
                        'Thank you');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                
                }
                
                
            }
        }
    }

}