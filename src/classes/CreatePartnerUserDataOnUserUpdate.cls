/**
*Description :Class to Create partner user data records based on Partner Users
*Methods CreatePartnerUserData(future)  , with List of User Ids as input
*SOQl: 1
*DML: 1 
*Client: CA technologies
*Developed By:  Accenture
*/
global class CreatePartnerUserDataOnUserUpdate {
  @future      
   public static void createPartnerUserData(Set<Id> UserIds){
    
    List<Partner_User_Data__c> listOfPartners = new List<Partner_User_Data__c>();
    List<Partner_User_Data__c> listOfOnBoardPartners = new List<Partner_User_Data__c>();
    
    Partner_User_Data__c thisPartnerUser;
    Map<Id,User> mapOfUsers;
        
        System.debug('---'+UserIds +'  : ' + SystemIdUtility.getSFDCDATA_USER_ID() );
        //get the user details        
        mapOfUsers=new Map<Id,User>([select Email,FirstName,LastName,Id,ProfileId,UserRoleId,Username,LDAP_Id__c,
        Education_Access__c,UserRole.RollupDescription,Profile.Description,IsActive,ContactId,IsPortalEnabled, 
        Contact.Account.Reseller_Disti_Regional_ID__c,Contact.Account.Name,Contact.Functional_Role__c,Contact.User_Key__c  
        
        
        from User where id in: UserIds ]); 
        //added SFDCuser id filter in query to avoid infinite looping  
        //system.debug('mapOfUsers='+mapOfUsers);      
        // Populate the Partner User Data record.                                             
        for(User u: mapOfUsers.values()){
            thisPartnerUser=new Partner_User_Data__c();
            thisPartnerUser.E_mail__c=u.Email;
            thisPartnerUser.First_Name__c=u.FirstName;
            thisPartnerUser.Last_Name__c=u.LastName;            
            thisPartnerUser.LDAP_Id__c=u.LDAP_Id__c;
            thisPartnerUser.Profile__c=u.ProfileId;
            thisPartnerUser.Role__c=u.UserRoleId;
            thisPartnerUser.Username__c=u.Username;
            thisPartnerUser.Education_Access__c=u.Education_Access__c;
            thisPartnerUser.Profile_Description__c=MapOfUsers.get(u.id).Profile.Description;
            thisPartnerUser.Role_Description__c=MapOfUsers.get(u.id).UserRole.RollupDescription;
            thisPartnerUser.Company_Partner_Name__c=u.Contact.Account.Name;
            thisPartnerUser.Reseller_Disti_Regional_ID__c=u.Contact.Account.Reseller_Disti_Regional_ID__c;
            thisPartnerUser.Functional_Role__c = u.Contact.Functional_Role__c;
            thisPartnerUser.User__c=u.Id;
            thisPartnerUser.User_key__c=u.Contact.User_Key__c;
            
            //if(u.IsActive){
                thisPartnerUser.PRM_Portal_Access__c=true;
            //}
            //else{
              //  thisPartnerUser.PRM_Portal_Access__c=false;
            //}
            
            if(u.LDAP_Id__c!=null)
               listOfPartners.add(ThisPartnerUser);            
            else if(u.Email!=null)
               listOfOnBoardPartners.add(ThisPartnerUser);
            
        }
                  
        //upsert the Partner User Data records
        if(listOfPartners!=null && listOfPartners.size()>0)
           upsert listOfPartners Partner_User_Data__c.Fields.LDAP_Id__c;
        if(listOfOnBoardPartners!=null && listOfOnBoardPartners.size()>0)
          upsert listOfOnBoardPartners Partner_User_Data__c.Fields.E_mail__c;
    }
    
    @future
    public static void updatePartnerUserData(Set<Id> UserIds){
    
    List<Partner_User_Data__c> listOfPartners = new List<Partner_User_Data__c>();
    List<Partner_User_Data__c> listOfOnBoardPartners = new List<Partner_User_Data__c>();
    
    Partner_User_Data__c thisPartnerUser;
    Map<Id,User> mapOfUsers;
        
        //get the user details        
        mapOfUsers=new Map<Id,User>([select Email,FirstName,LastName,Id,ProfileId,UserRoleId,Username,LDAP_Id__c,
        Education_Access__c,UserRole.RollupDescription,Profile.Description,IsActive,ContactId,IsPortalEnabled, 
        Contact.Account.Reseller_Disti_Regional_ID__c,Contact.Account.Name  
        from User where id in: UserIds and LDAP_Id__c!=null and 
        LastModifiedById !=:SystemIdUtility.getSFDCDATA_USER_ID()]); 
        //added SFDCuser id filter in query to avoid infinite looping  
        //system.debug('mapOfUsers='+mapOfUsers);      
        // Populate the Partner User Data record.                                             
        for(User u: mapOfUsers.values()){
            thisPartnerUser=new Partner_User_Data__c();
            thisPartnerUser.E_mail__c=u.Email;
            thisPartnerUser.First_Name__c=u.FirstName;
            thisPartnerUser.Last_Name__c=u.LastName;            
            thisPartnerUser.LDAP_Id__c=u.LDAP_Id__c;
            thisPartnerUser.Profile__c=u.ProfileId;
            thisPartnerUser.Username__c=u.Username;
            thisPartnerUser.Education_Access__c=u.Education_Access__c;
            thisPartnerUser.Profile_Description__c=MapOfUsers.get(u.id).Profile.Description;                        
            thisPartnerUser.Role__c='';
            thisPartnerUser.Role_Description__c='';
            thisPartnerUser.Company_Partner_Name__c='';
            thisPartnerUser.Reseller_Disti_Regional_ID__c='';
            thisPartnerUser.PRM_Portal_Access__c=false;
            
            //System.debug('**--Account Name :'+u.Contact.Account.Name);
            //System.debug('**--Reseller Dist Regional ID :'+u.Contact.Account.Reseller_Disti_Regional_ID__c);
            //System.debug('**--IsPortalEnabled :'+u.IsPortalEnabled);

            //listOfPartners.add(ThisPartnerUser);
            
            if(u.LDAP_Id__c!=null)
               listOfPartners.add(ThisPartnerUser);            
            else if(u.Email!=null)
               listOfOnBoardPartners.add(ThisPartnerUser);
               
        }         
         //system.debug('listOfPartners ='+listOfPartners+ '&&&' +thisPartnerUser.PRM_Portal_Access__c);            
          //upsert the Partner User Data records
         
          if(listOfPartners!=null && listOfPartners.size()>0)
              upsert listOfPartners Partner_User_Data__c.Fields.LDAP_Id__c;
          if(listOfOnBoardPartners!=null && listOfOnBoardPartners.size()>0)
              upsert listOfOnBoardPartners Partner_User_Data__c.Fields.E_mail__c;
         
    }   
    
    
    @future
  public static void unCheckPortalChampion(Set<Id> unChkContactsIds){
   
    Set<Id> unChkContacts= new Set<Id>();
    List<Contact> ContactDetailsUncheck = new List<Contact>([Select Portal_Champion__c,Id From Contact where Id IN:unChkContactsIds]);
   
    List<Contact> ContactRecToUpdate = new List<Contact>();
   
    for(Contact con : ContactDetailsUncheck )
    {
      if(con.Portal_Champion__c == true )
        {
            con.Portal_Champion__c = false;
            ContactRecToUpdate.add(con);
         }
     }
           
     if(ContactRecToUpdate.size()>0){
      
        update ContactRecToUpdate;
     }
  }
    
    
 
 public static void updatePortalChampion(Set<Id> conId){

    
    Set<string> emails = new Set<String>();
    Set<Id> chkContacts= new Set<Id>();
    Set<Id> unChkContacts= new Set<Id>();
    Map<Id,Id> contactMap = new Map<Id,Id>();
    
    if(conId!=null && conId.size()>0) {
       List<user> usrLst = [Select Id,IsActive,ContactId,ProfileId,Profile.Name,UserRole.Name,UserType,IsPortalEnabled, 
                             contact.Portal_Champion__c,Contact.AccountId,Contact.Email from user where ContactId IN:conId];
      
       for(user usr: usrLst){
          if(usr.IsActive == true && usr.IsPortalEnabled == true && usr.UserType=='PowerPartner' &&
                       usr.Profile.Name.Contains('Champion') && usr.UserRole.Name.Contains('Executive')){
           
           //Create Partner location Record after activation of Partner User if he is a partner champion.                 
           if(usr.Contact.AccountId!=null && usr.Contact.Email!=null){
                 contactMap.put(usr.ContactId,usr.Contact.AccountID);       
                 emails.add(usr.Contact.Email);
            }
            if(usr.contact.Portal_Champion__c != true){              
              chkContacts.add(usr.ContactId);                            
            }            
          }
          else{
            if(usr.contact.Portal_Champion__c != true)
               unChkContacts.add(usr.ContactId);
          }        
        }     
     }
           
     if(chkContacts.size()>0 || unChkContacts.size()>0){            
         CreatePartnerUserDataOnUserUpdate.updatePortalChampionOnContact(chkContacts,unChkContacts);       
     
     }
     
     if(contactMap.size()>0 && !Test.isRunningTest()){               
         CreatePartnerUserDataOnUserUpdate.createPartnerLocations(contactMap,emails);                  
      }
   }    
   
  /*
     This method is to create Partner location Record.
     verify there exists Partner locator record with the mentioned address if not then create Partner Locator Record. 
     verify there exists primary Partner locator if not make the locator as primary else leave it.  
  
  */ 
   
    @Future(callout=true)  
  public static void createPartnerLocations(Map<Id,Id> contactMap, Set<string> emails){
 
  System.debug('+++ Inside ContactUtils : createPartnerLocations  +++');
  List <Partner_Location__c> createPartnLocations = new List <Partner_Location__c>();

       //comment below code(Point_of_Contact_Phone__c) for changing data type of phone.  sandeep dstsa01    
       List <Partner_Location__c> partLoc = [select Account__c, Point_of_Contact_Email__c,Point_of_Contact_Name__c, Point_of_Contact_Phone__c,
                                              Postal_Code__c, City__c,Country__c,State_Province__c,Street__c,Is_Primary__c from Partner_Location__c 
                                              where (Account__c IN :contactMap.values())];
                                            
                                          // AND Point_of_Contact_Email__c IN :emails
                                            
        List <Contact> contactLst =[select name,Phone,Email,Website__c,Account.Name,Account.Id,Account.Billingcity,Account.Billingstate,
                                     Account.Billingstreet,Account.Billingpostalcode,Account.Country_Picklist__c,RTM__c,Account.Website from contact
                                     where Id in:contactMap.Keyset() ]; 

         
        Map<Id,String> partnLocEmailMap = new Map<Id,String>(); 
        Set<Id> primaryLocAccnts = new Set<Id>();
        Set<String> locations = new Set<String>();
                                           
        for(Partner_Location__c pl : partLoc){
          
          if(emails!=null && pl.Point_of_Contact_Email__c!=null && pl.Point_of_Contact_Email__c!='' 
               && emails.contains(pl.Point_of_Contact_Email__c)){
             String key = pl.Account__c;
             String val= pl.Point_of_Contact_Email__c;             
            
             if(partnLocEmailMap.containsKey(key)){
                val=val+';'+partnLocEmailMap.get(key);            
             }
             else
               partnLocEmailMap.put(key,val);           
          }     
          
          locations.add(pl.Account__c+'-'+pl.Street__c+'-'+pl.City__c+'-'+pl.State_Province__c+'-'+pl.Postal_Code__c+'-'+pl.Country__c);  
                                   
          if(pl.Is_Primary__c)
            primaryLocAccnts.add(pl.Account__c);                     
       
       }                                    
              System.debug('-******-'+locations);
              System.debug('*******************' +primaryLocAccnts);   
           for(Contact con: contactLst){
           
              System.debug('****');
              System.debug('****' + contactMap.get(con.Id));
              System.debug('****---' + con.Account.Id+'-'+con.Account.Billingstreet+'-'+con.Account.Billingcity+'-'+con.Account.Billingstate+'-'+con.Account.Billingpostalcode+'-'+con.Account.Country_Picklist__c);
              String partLocEmail=partnLocEmailMap.get(contactMap.get(con.Id));
                                                
                //if(partLocEmail==null || !partLocEmail.contains(con.Email)){
                if(!locations.contains(con.Account.Id+'-'+con.Account.Billingstreet+'-'+con.Account.Billingcity+'-'+con.Account.Billingstate+'-'+con.Account.Billingpostalcode+'-'+con.Account.Country_Picklist__c) && !Test.isRunningTest()){  
                     
                      String addr ='';         
                      Partner_Location__c p = new Partner_Location__c();                     
                      p.Name = con.Account.Name+'-'+con.Account.Billingcity;
                      p.Account__c = con.Account.Id;
                      p.City__c = con.Account.Billingcity;
                      p.State_Province__c = con.Account.Billingstate;
                      p.Street__c =  con.Account.Billingstreet;
                      p.Postal_Code__c = con.Account.Billingpostalcode;
                      p.Country__c = con.Account.Country_Picklist__c;
                      p.Website__c = con.Account.Website;
                      p.Point_of_Contact_Name__c = con.Name;
                      
                      //comment below code for changing data type of phone.  sandeep dstsa01
                      p.Point_of_Contact_Phone__c = con.Phone;
                      p.Point_of_Contact_Email__c = con.Email;    
                      
                      //If there exists primary location dont make locator as primary.
                          
                       System.debug('*******************' +primaryLocAccnts.contains(con.Account.Id));   
                         
                       System.debug('*******************' +con.Account.Id);
                       System.debug('*******************' +p.Account__c); 
                       
                          
                      if(primaryLocAccnts !=null && primaryLocAccnts.contains(con.Account.Id))
                         p.Is_Primary__c = false;
                      else    
                         p.Is_Primary__c = true;
                      if(con.RTM__c!=null)
                      p.Route_To_Market__c = con.RTM__c;
                      else
                      p.Route_To_Market__c = 'Data Management';
                      
                      addr = p.Street__c + ','+p.City__c+','+p.State_Province__c;
                      if(p.Postal_Code__c!=null)
                        addr += ',' + p.Postal_Code__c;
                      string url = 'http://maps.google.com/maps/geo?key=ABQIAAAAn-_wL1b8pbIpJfusL0LMmRQ72da4xWLg1N8Ce02Xdu0VxpZsuRQ204RfeXqfJttrBEVklwfOQn2xNA' 
                                    + '&output=csv&q=' + EncodingUtil.urlEncode(addr,'UTF-8');
                      Http h = new Http(); 
                      HttpRequest req = new HttpRequest(); 
                      req.setHeader('Content-type', 'application/x-www-form-urlencoded'); 
                      req.setHeader('Content-length', '0'); 
                      req.setEndpoint(url); 
                      req.setMethod('POST'); 
                        
                      HttpResponse res = h.send(req); 
                      String responseBody = res.getBody();
                      String[] Coordinates = responseBody.split(',',0);  
                      
                      System.debug('addr********' +addr);
                      System.debug('lll'+Coordinates);
                      String lat = Coordinates[2];
                      String longt = Coordinates[3];
                      p.Latitude__c = decimal.valueOf(lat);
                      p.Longitude__c = decimal.valueOf(longt);
                      
                      System.debug('Latitude********' + lat + '*******Long**' + longt+'addr');                                                         
                      createPartnLocations.add(p);
                }           
           }
 
     if(createPartnLocations.size()>0)
        Database.Insert(createPartnLocations,False);

  }
  
  @future
  public static void updateActiveUserOnContact(Set<Id> activeUsers ,Set<Id> inactiveUsers){
     List<Contact> UserActiveChk = new List<Contact>();
     List<Contact> UserInActiveUnChk = new List<Contact>(); //([Select Portal_Champion__c,Id From Contact where Id IN:unChkContacts]);
     List<Contact> ContactRecToUpdate = new List<Contact>();
     
     if(activeUsers !=null && activeUsers .size()>0){
        UserActiveChk = [Select Active_User__c,Id From Contact where Id IN:activeUsers ];        
     }
     if(inactiveUsers!=null && inactiveUsers.size()>0){
        UserInActiveUnChk = [Select Active_User__c,Id From Contact where Id IN:inactiveUsers];        
     }
   
     for(Contact con : UserActiveChk )
     {           
      if(con.Active_User__c != true){
          con.Active_User__c= true;
          ContactRecToUpdate.add(con);
        }                
     }
     for(Contact con : UserInActiveUnChk )
     {           
      if(con.Active_User__c== true){
         con.Active_User__c= False;
         ContactRecToUpdate.add(con);
        }                
     } 
     
     if(ContactRecToUpdate.size()>0)
        Database.update(ContactRecToUpdate,False);
  }
  
  @future
  public static void updatePortalChampionOnContact(Set<Id> chkContacts ,Set<Id> unChkContacts){
    
    List<Contact> ContactDetailsChk = new List<Contact>();
     List<Contact> ContactDetailsUnChk = new List<Contact>([Select Portal_Champion__c,Id From Contact where Id IN:unChkContacts]);
     List<Contact> ContactRecToUpdate = new List<Contact>();
     
     if(chkContacts!=null && chkContacts.size()>0){
        ContactDetailsChk = [Select Portal_Champion__c,Id From Contact where Id IN:chkContacts];        
     }
     if(unChkContacts!=null && unChkContacts.size()>0){
        ContactDetailsUnChk = [Select Portal_Champion__c,Id From Contact where Id IN:unChkContacts];        
     }
   
     for(Contact con : ContactDetailsChk )
     {           
      if(con.Portal_Champion__c != true){
          con.Portal_Champion__c = true;
          ContactRecToUpdate.add(con);
        }                
     }
     for(Contact con : ContactDetailsUnChk )
     {           
      if(con.Portal_Champion__c == true){
         con.Portal_Champion__c = False;
         ContactRecToUpdate.add(con);
        }                
     } 
     
     if(ContactRecToUpdate.size()>0)
        Database.update(ContactRecToUpdate,False);
  }
   @future
  public static void DeleteDealRegAfterMerge(Set<Id> dealRegsToDel){
           List <Opportunity> toDelete = New List<Opportunity>();
     toDelete = [select Id from Opportunity where Id in :dealRegsToDel];
     if(toDelete.size() > 0 )
       Delete toDelete;
  }
  
    @future
  public static void updateContacts(Set<Id> userContacts, Set<Id> partnerUserContacts, Set<Id> portalChampionContacts)
  {
      List<Contact> contactsToUpdate = new List<Contact>();
      
      for(Id cId : userContacts)
          contactsToUpdate.add( new Contact(Id=cId, Active_User__c=partnerUserContacts.contains(cId), Portal_Champion__c=portalChampionContacts.contains(cId)) );
      
      update contactsToUpdate;
  }     
}