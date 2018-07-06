//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class AutocreatedRegHandler1460987660036 implements Auth.SamlJitHandler {
    private class JitException extends Exception{}
    private void handleUser(boolean create, User u, Map<String, String> attributes,
        String federationIdentifier, boolean isStandard) {
        system.debug('@@@@@@@@@@@@2in handleuser');
        if(create && attributes.containsKey('Username')) {
            system.debug('@@@@@@@@@@@@2username'+attributes.get('Username'));
            //u.Username = attributes.get('Username');
            //u.CommunityNickname = attributes.get('Username');
        }
        if(create) {
              
                system.debug('@@@@@@@@@@@@2federation id'+federationIdentifier);
                u.FederationIdentifier = federationIdentifier;
                u.Username = federationIdentifier;
                u.CommunityNickname = federationIdentifier;
            
        }
        if(attributes.containsKey('Email')) {
            system.debug('@@@@@@@@@@@@2Email'+attributes.get('Email'));
            u.Email = attributes.get('Email');
            
            
        }
        if(attributes.containsKey('FirstName')) {
            system.debug('@@@@@@@@@@@@FirstName'+attributes.get('FirstName'));
            u.FirstName = attributes.get('FirstName');
        }
        if(attributes.containsKey('LastName')) {
            system.debug('@@@@@@@@@@@@LastName'+attributes.get('LastName'));
            u.LastName = attributes.get('LastName');
        }
        String uid = UserInfo.getUserId();
        User currentUser = 
            [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
        if(create) {
            u.LocaleSidKey = currentUser.LocaleSidKey;
        }
       if(create) {
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
        }
        if(create) {
            String alias = '';
            if(u.FirstName == null) {
                alias = u.LastName;
            } else {
                alias = u.FirstName.charAt(0) + u.LastName;
            }
            if(alias.length() > 5) {
                alias = alias.substring(0, 5);
            }
            u.Alias = alias;
        }
        if(create) {
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
        }
        if(create) {
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
        }

        
        if(attributes.containsKey('ProfileId')) {
            system.debug('@@@@@@@@@profileid user');
            String profileId = attributes.get('ProfileId');
            Profile p = [SELECT Id FROM Profile WHERE Id=:profileId];
            u.ProfileId = p.Id;
        }
        
        //Handle custom fields here

        if(!create) {
            update(u);
        }
    }

    private void handleContact(boolean create, String accountId, User u, Map<String, String> attributes) {
        Contact c;
        boolean newContact = false;
        if(create) {
            if(attributes.containsKey('Email')) {
            String contactemail = attributes.get('Email');
                
                List<Contact> con = [SELECT Id, AccountId FROM Contact WHERE email=:contactemail and AccountId =:Label.AccountForCaseArchival limit 1];
                system.debug('@@@@@@@@@@@@@@@2before if condition ');
                if(con.size()==0){
                    system.debug('@@@@@@@@@@@@@@@2in else condition ');
                    c = new Contact();
                    newContact = true;
                }
                else{
                    c=con[0];
                    u.ContactId = c.id;
                    system.debug('@@@@@@@@@@@@@@@2in if condition ');
                }
            } else {
                c = new Contact();
                newContact = true;
            }
        } else {
            if(u.ContactId==null) {
            String contactemail = attributes.get('Email');
                
                List<Contact> con = [SELECT Id, AccountId FROM Contact WHERE email=:contactemail and AccountId =:Label.AccountForCaseArchival limit 1];
                system.debug('@@@@@@@@@@@@@@@2before if condition ');
                if(con.size()==0){
                    system.debug('@@@@@@@@@@@@@@@2in else condition ');
                    c = new Contact();
                    newContact = true;
                }
                else{
                    c=con[0];
                    u.ContactId = c.id;
                    system.debug('@@@@@@@@@@@@@@@2in if condition ');
                }
            }
            else if(u.ContactId!=null){
            id contactidvalue = u.ContactId;
            c = [SELECT Id, AccountId FROM Contact WHERE Id=:contactidvalue limit 1];
            
            }
        }
        if(!newContact && c.AccountId != accountId) {
            throw new JitException('Mismatched account: ' + c.AccountId + ', ' + accountId);
        }

        if(attributes.containsKey('Email')) {
            system.debug('@@@@@@@@@email contact');
            c.Email = attributes.get('Email');
        }
        if(attributes.containsKey('FirstName')) {
            system.debug('@@@@@@@@@firstname contact');
            c.FirstName = attributes.get('FirstName');
        }
        if(attributes.containsKey('LastName')) {
            system.debug('@@@@@@@@@lastname contact');
            c.LastName = attributes.get('LastName');
        }
        if(newContact) {
            c.AccountId = accountId;
            insert(c);
            system.debug('value of contact ID'+c.Id);
            u.ContactId = c.Id;
        } else {
            update(c);
        }
    }

    
    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        if(communityId != null || portalId != null) {
            //String account = handleAccount(create, u, attributes);
            system.debug('@@@@@@@@@ in handle JIT');
            String account = Label.AccountForCaseArchival; 
            handleContact(create, account, u, attributes);
            handleUser(create, u, attributes, federationIdentifier, false);
        } else {
            handleUser(create, u, attributes, federationIdentifier, true);
        }
    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        system.debug('@@@@@@@@@@@@@@@@@@@@@in createuser');
        system.debug('@@@@@@@@@@@@@@@@@@@@@id samlSSoProviderId value'+samlSsoProviderId);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id communityId value'+communityId);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id portalId value'+portalId);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id federationIdentifier  value'+federationIdentifier);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id Attributes  value'+attributes);
                system.debug('@@@@@@@@@@@@@@@@@@@@@id assertion  value'+assertion);
        User u = new User();
        handleJit(true, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
        return u;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        
        system.debug('@@@@@@@@@@@@@@@@@@@@@id samlSSoProviderId value'+samlSsoProviderId);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id communityId value'+communityId);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id portalId value'+portalId);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id federationIdentifier  value'+federationIdentifier);
        system.debug('@@@@@@@@@@@@@@@@@@@@@id Attributes  value'+attributes);
                system.debug('@@@@@@@@@@@@@@@@@@@@@id assertion  value'+assertion);
        User u = [SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId];
        handleJit(false, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
    }
}