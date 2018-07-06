public with sharing class DealProgramEligibility {
    public account useraccount{get;set;}
    Public account ptraccount{get;set;}
    public boolean isValidDesignation(String accountDesg, String dealProgDesg) {
        system.debug('is valid designation accountDesg:'+accountDesg+' dealProgDesg: '+dealProgDesg);
        if(dealProgDesg == null)
            return true;
        if(accountDesg == null)
            return false;
        if(accountDesg != null && dealProgDesg != null) {
            String[] accountStrArr = accountDesg.split(';', 0);
            String[] dealPrmStrArr = dealProgDesg.split(';', 0);
            for(String s : accountStrArr) {
                for(String s1 : dealPrmStrArr) {
                    if(s.equalsIgnoreCase(s1))
                        return true;
                }
            }
        }
                return false;
            }
    //SINJY02 : Added regionCountry to method for AR 3884
    Public boolean isvalidsector(string partDesg,String dealProgDesg,string acctype,string salesregion,string geo){  //string edacctype,string edsalesregion
        System.debug('acctype:'+acctype + ',salesregion :'+salesregion +',dealProgDesg :'+dealProgDesg +' geo:'+geo+' partDesg '+partDesg);
        
        if(geo == 'PS/CAN' || geo == 'NA'){
            Boolean Issuccess = false;
            /*Commented out this code for AR 3884 : SINJY02
            //if(dealProgDesg == null)
            if(dealProgDesg == null && ((acctype!=null&&(!acctype.contains('Government') && !acctype.contains('Public sector') && !acctype.contains('SLED' ))) || (salesregion != null && (salesregion!= 'PS_FED/FSI' && salesregion != 'PS_SLED'))))
                return true;
                
            if(acctype == null && salesregion!= 'PS_FED/FSI' && salesregion != 'PS_SLED'){
                if(dealProgDesg == null || !(dealProgDesg.contains('FED')|| dealProgDesg.contains('SLED'))){
                    return true;
                }
                return false;
            } 
            if(acctype == null && (salesregion == 'PS_FED/FSI' || salesregion == 'PS_SLED')){
                if((dealProgDesg.contains('FED')|| dealProgDesg.contains('SLED'))){
                    return true;
                }
                return false;
            }  
            else if(((acctype != null&& (acctype.contains('Government')|| acctype.contains('Public sector') || acctype.contains( 'SLED'))) || (salesregion != null &&( salesregion == 'PS_FED/FSI' || salesregion == 'PS_SLED'))) && (dealProgDesg != null && (dealProgDesg.contains('FED') || dealProgDesg.contains('SLED')))) {
                   Issuccess = true;
            }
            else if ( ((acctype!=null&&(!acctype.contains('Government') && !acctype.contains('Public sector') && !acctype.contains('SLED' ))) || (salesregion != null && (salesregion!= 'PS_FED/FSI' && salesregion != 'PS_SLED'))) && (dealProgDesg != null && (!dealProgDesg.contains('FED') && !dealProgDesg.contains('SLED' ))) ){
                    Issuccess =true;
            }*/
             //non public prog and account (partner designation)
             
             system.debug('Partner Desg ' + partDesg);
             system.debug('Deal Prog Desg' + dealProgDesg);
             if(dealProgDesg == null || !(dealProgDesg.contains('FED')|| dealProgDesg.contains('SLED'))) {
                if(partDesg == null || !(partDesg.contains('FED')&&partDesg.contains('SLED'))){
                     if((acctype==null || (acctype!=null&&(!acctype.contains('Government') && !acctype.contains('Public sector') && !acctype.contains('SLED' )))) && ( salesregion!= 'PS_FED/FSI' && salesregion != 'PS_SLED' )){
                      system.debug('in non public prog and non public account desg');
                      return true;
                  }
                  
                }
                else if((acctype==null || (acctype!=null&&(!acctype.contains('Government') && !acctype.contains('Public sector') && !acctype.contains('SLED' )))) && ( salesregion!= 'PS_FED/FSI' && salesregion != 'PS_SLED' )){
                    system.debug('in non public prog and non public Industry desg');
                    return true;
                }
                } //Public Program
                else if (dealProgDesg.contains('FED')|| dealProgDesg.contains('SLED')){
                   if(partDesg != null && (partDesg.contains('FED') || partDesg.contains('SLED'))){
                        if((acctype != null&& (acctype.contains('Government')|| acctype.contains('Public sector') || acctype.contains( 'SLED'))) || (salesregion != null &&(salesregion == 'PS_FED/FSI' || salesregion == 'PS_SLED'))){
                            system.debug('in  public prog and  public Industry desg/account desg');
                            return true;
                        }
                   }
                }
            
            
            return Issuccess;           
        }
        else{
            return true;
        }       
          
    }
    
    public boolean isValidLevel(String acctLevel, String dealRegPrmLevel ) {
      system.debug('is valid LEVEL acctLevel:'+acctLevel+' dealRegPrmLevel: '+dealRegPrmLevel);  
        if(dealRegPrmLevel == null)
            return true;
        if(acctLevel == null)
            return false;
        String[] dealPrmLevel = dealRegPrmLevel.split(';');
        for(String s : dealPrmLevel) {  
            if(s.equalsIgnoreCase(acctLevel))
                return true;
        }
        return false;           
    }
    
    public boolean isValidType(String acctType, String dealRegPrmType) {
        system.debug('is valid TYPE acctType:'+acctType+' dealRegPrmType: '+dealRegPrmType);
        if(dealRegPrmType == null)
            return true;
        if(acctType == null)
            return false;
        if(dealRegPrmType.indexOf(acctType) != -1)
            return true;
        return false;
    }
    
    public boolean isValidGEO(String dealRegPrmGEO, String accountGEO) {
        if(dealRegPrmGEO == null)
            return true;
        if(accountGEO == null)
            return false;
        String[] dealPrmGEO = dealRegPrmGEO.split(';');
        for(String s : dealPrmGEO) {
            if(accountGEO.equalsIgnoreCase(s))
                return true;
        }   
        return false;
    }
    
    public boolean isValidCountry(String acctCntry, String dealPrmCntry1, String dealPrmCntry2) {
        if(dealPrmCntry1 == null && dealPrmCntry2 == null)
            return true;
        if(acctCntry == null)
            return false;
        if(dealPrmCntry1 != null) {
            String[] countries = dealPrmCntry1.split(';');
            for(String str : countries) {
        //        String countryCode = str.substring(0, str.indexOf('-'));
        //        if(acctCntry.trim().equals(countryCode.trim()))
            if(acctCntry.trim().equals(str.trim()))
                    return true;
            }   
        }
        if(dealPrmCntry2 != null) {
            String[] countries = dealPrmCntry2.split(';');
            for(String str : countries) {
        //        String countryCode = str.substring(0, str.indexOf('-'));
        //        if(acctCntry.trim().equals(countryCode.trim()))
            if(acctCntry.trim().equals(str.trim()))
                    return true;
            }   
        }       
        return false;           
    }
    //This Block Added for 3186 Jyoti Singh
    public boolean isValidOppType(String dealRegPrmtype, String OpportunityType) {
        if(dealRegPrmtype == null)
            return true;
        if(OpportunityType == null)
            return false;
        String[] dealPrmTyp = dealRegPrmtype.split(';');
        for(String s : dealPrmTyp) {
            if(OpportunityType.equalsIgnoreCase(s))
                return true;
        }   
        return false;
    }
    
    public boolean isValidDealRegistrationProgram(Id userAccountID, Id dealRegRefID,Id endUserAcctId, Id oppRef ) {
        
        Opportunity Opp = [Select type,Distributor_6__c,Distributor__c from Opportunity where id=:oppRef];
        Account endUserAccount = [select id,account_type__c,sales_region__c,geo__c,Region_Country__c from account where id =: endUserAcctId];       
        
        Account userAccount = [Select Customer_Category__c, Name, Alliance__c,Solution_Provider__c,Service_Provider__c, 
                                  GEO__c, Region_Country__c, Velocity_Seller_Program_Level__c,Velocity_Seller_Type__c, Velocity_Seller_Designation__c,
                                  Alliance_Program_Level__c,Alliance_Type__c,Alliance_Designation__c,Partner_Designation__c,
                                  Service_Provider_Program_level__c,Service_Provider_Type__c,Service_Provider_Designation__c,
                                  Solution_Provider_Program_Level__c, Solution_Provider_Type__c,Solution_Provider_Designation__c
                                  From Account where Id = :userAccountID LIMIT 1];
                              
        Deal_Registration_Program__c dealRegRef =  [Select d.Secondary_Business_Functions__c,d.opp_type__c,d.Primary_Business_Functions__c, d.Partner_Program_Level__c,End_Date__c,Start_Date__c, 
                                                                    d.Deal_Program_Type__c, d.CurrencyIsoCode, d.Geography__c, d.Partner_Friendly_Name__c,d.Country__c,d.Distributor_Required__c,
                                                                    d.Country1__c,d.Country2__c From Deal_Registration_Program__c d
                                                                    where Id  = : dealRegRefID LIMIT 1];
        boolean isValid = false;
        if(userAccount <> null && dealRegRef <> null){                                                            
            //System.debug('Inside isValidDealRegistrationProgram' + userAccount);
            Set<String> routes = new Set<String>();
            if(userAccount.Alliance__c)
                routes.add('Alliance');
            if(userAccount.Solution_Provider__c)
                routes.add('Solution Provider');
            if(userAccount.Service_Provider__c)
                routes.add('Service Provider');
            //System.debug('Inside isValidDealRegistrationProgram'+routes + '-'+dealRegRef.Deal_Program_Type__c);   
            if(isValidOppType(dealRegRef.Opp_Type__c, Opp.Type)){  
                
                if(dealRegRef.End_Date__c >= Date.today() && dealRegRef.Start_Date__c <= Date.today()) {
                    if(routes.contains(dealRegRef.Deal_Program_Type__c)) {
                        
                         If(!dealRegRef.Distributor_Required__c || (dealRegRef.Distributor_Required__c && (Opp.Distributor_6__c != null || Opp.Distributor__c != null))){
                        
                            if(isValidGEO(dealRegRef.Geography__c,userAccount.GEO__c)) {
                                //System.debug('inside geo if ');
                                //SINJY02 : Added regionCountry to method for AR 3884
                                if(isValidsector(userAccount.Partner_Designation__c,dealRegRef.Secondary_Business_Functions__c,endUserAccount.account_type__c,endUserAccount.sales_region__c,endUserAccount.geo__c)) {
                                    if(isValidCountry(userAccount.Region_Country__c,dealRegRef.Country1__c,dealRegRef.Country2__c)) {
                                        //System.debug('inside country if ');
                                    
                                        
                                            if(isValidLevel(userAccount.Velocity_Seller_Program_Level__c,dealRegRef.Partner_Program_Level__c)) {
                                                if(isValidType(userAccount.Velocity_Seller_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                                    if(isValidDesignation(userAccount.Velocity_Seller_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                                        //if(isValidsector(dealRegRef.Secondary_Business_Functions__c,ptraccount.account_type__c,ptraccount.sales_region__c)){ //,userAccount.account_type__c,userAccount.sales_region__c
                                                            isValid = true;
                                                    //}
                                                }
                                            }
                                          }
                                       
                                      
                                      else if(userAccount.Alliance__c && dealRegRef.Deal_Program_Type__c == 'Alliance') {
                                            //System.debug('inside alliance if ');
                                            if(isValidLevel(userAccount.Alliance_Program_Level__c,dealRegRef.Partner_Program_Level__c)) {
                                                //System.debug('inside alliance program level if ');
                                                if(isValidType(userAccount.Alliance_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                                    //System.debug('inside alliance type if ');
                                                    if(isValidDesignation(userAccount.Alliance_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                                        //if(isValidsector(dealRegRef.Secondary_Business_Functions__c,ptraccount.account_type__c,ptraccount.sales_region__c)){ //,userAccount.account_type__c,userAccount.sales_region__c
                                                        //System.debug('inside alliance designa if ');
                                                            isValid = true;
                                                    //}
                                                }
                                            }
                                         }
                                      } else if(userAccount.Service_Provider__c && dealRegRef.Deal_Program_Type__c == 'Service Provider') {
                                            //System.debug('inside Serv pro if ');
                                            if(isValidType(userAccount.Service_Provider_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                                if(isValidDesignation(userAccount.Service_Provider_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                                   //if(isValidsector(dealRegRef.Secondary_Business_Functions__c,ptraccount.account_type__c,ptraccount.sales_region__c)){ //,userAccount.account_type__c,userAccount.sales_region__c
                                                    isValid = true;
                                                //}
                                            }
                                          }
                                     } else if(userAccount.Solution_Provider__c && dealRegRef.Deal_Program_Type__c == 'Solution Provider') {
                                            //System.debug('inside sol pro if ');
                                            if(isValidLevel(userAccount.Solution_Provider_Program_Level__c,dealRegRef.Partner_Program_Level__c)) {
                                                if(isValidType(userAccount.Solution_Provider_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                                    if(isValidDesignation(userAccount.Solution_Provider_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                                       //if(isValidsector(dealRegRef.Secondary_Business_Functions__c,ptraccount.account_type__c,ptraccount.sales_region__c)){ //,userAccount.account_type__c,userAccount.sales_region__c
                                                            isValid = true;
                                                    //}
                                                }
                                            }
                                        }
                                    }
                                }
                                }//validsector
                        }
                    } //Distributor_Required__c
                }
            }
        }//is valid OppType 
       }
      return isValid;
    }
     
    public List<Deal_Registration_Program__c> getEligibleDealRegistrationPrograms(Id accountId, id ptrid, Id oppRef) {
        Opportunity Opp = [Select type,Distributor_6__c,Distributor__c from Opportunity where id=:oppRef];
        Account userAccount = [Select a.Velocity_Seller__c,a.Partner_Designation__c,
                           
                                     a.Solution_Provider__c, 
                                     a.Service_Provider__c,
                                     a.Alliance__c, 
                                     a.Velocity_Seller_Program_Level__c, 
                                     a.Solution_Provider_Program_Level__c, 
                                     a.Alliance_Program_Level__c,
                                     a.Alliance_Type__c,
                                     a.Service_Provider_Type__c,
                                     a.Solution_Provider_Type__c,
                                     a.Velocity_Seller_Type__c,
                                     a.Alliance_Designation__c,
                                     a.Service_Provider_Designation__c,
                                     a.Solution_Provider_Designation__c,
                                     a.Velocity_Seller_Designation__c, 
                                     a.GEO__c, 
                                     a.Country_Picklist__c,
                                     a.Region_Country__c,
                                     a.account_type__c,
                                     a.sales_region__c 
                                From Account a 
                                where a.Id = :accountId];
          account ptraccount = [select id,geo__c,
                                   account_type__c,
                                   sales_region__c,Region_Country__c
                                from account where id =: ptrid];                         
        
        List<String> routes = new List<String>();
        
        if(userAccount.Alliance__c)
            routes.add('Alliance');
        if(userAccount.Solution_Provider__c)
            routes.add('Solution Provider');
        if(userAccount.Service_Provider__c)
            routes.add('Service Provider'); 
        //System.debug('Account routes'+routes);
 List<Deal_Registration_Program__c> allDealRegPrms =  [Select d.Secondary_Business_Functions__c,d.Ranking__c,d.name,d.Deal_Program_Number__c,Distributor_Required__c,Accounts_Support__c,
                                                                    d.Primary_Business_Functions__c, 
                                                                    d.Partner_Program_Level__c, 
                                                                    d.Deal_Program_Type__c, 
                                                                    d.CurrencyIsoCode,
                                                                    d.Geography__c,
                                                                    d.Partner_Friendly_Name__c,
                                                                    d.Country__c,
                                                                    d.Country1__c,
                                                                    d.opp_type__c,
                                                                    d.Max_Deal_Value__c,
                                                                    d.Min_Deal_Value__c,
                                                                    d.Country2__c,
                                                                    (Select Id,
                                                                    Approver__c,
                                                                    Region__c
                                                                    From Deal_Reg_Approvers__r) 
                                                                    From Deal_Registration_Program__c d
                                                                    where d.Deal_Program_Type__c in :routes and d.Start_Date__c <= TODAY and d.End_Date__c >= TODAY];
       
        //System.debug('Total Deal Reg Prms'+allDealRegPrms);
        List<Deal_Registration_Program__c> filteredDealRegPrms = new List<Deal_Registration_Program__c>();
        List<Deal_Registration_Program__c> finalDealRegPrms = new List<Deal_Registration_Program__c>();
        system.debug('Alprgram count'+allDealRegPrms.size());
        for(Deal_Registration_Program__c dealRegRef : allDealRegPrms) {
        System.debug('dealRegRef :'+dealRegRef );
          if(isValidOppType(dealRegRef.Opp_Type__c, Opp.Type)){
            System.debug('inside for loop'+dealRegRef);
             If(!dealRegRef.Distributor_Required__c || (dealRegRef.Distributor_Required__c && (Opp.Distributor_6__c != null || Opp.Distributor__c != null))){
                if(isValidGEO(dealRegRef.Geography__c,userAccount.GEO__c)) {
                    System.debug('inside geo if ');
                    //SINJY02 : Added regionCountry to method for AR 3884
                    if(isValidsector(userAccount.Partner_Designation__c,dealRegRef.Secondary_Business_Functions__c,ptraccount.account_type__c,ptraccount.sales_region__c,ptraccount.geo__c)) {
                     system.debug('dealRegRef.name inside valid Sector'+dealRegRef.Deal_Program_Number__c);//,userAccount.account_type__c,userAccount.sales_region__c
                    if(isValidCountry(userAccount.Region_Country__c,dealRegRef.Country1__c,dealRegRef.Country2__c)) {
                        System.debug('inside country if ');
                        
                    } 
                    if(userAccount.Alliance__c && dealRegRef.Deal_Program_Type__c == 'Alliance') {
                            //System.debug('inside alliance if ');
                            if(isValidLevel(userAccount.Alliance_Program_Level__c,dealRegRef.Partner_Program_Level__c)) {
                                //System.debug('inside alliance program level if ');
                                if(isValidType(userAccount.Alliance_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                    //System.debug('inside alliance type if ');
                                    if(isValidDesignation(userAccount.Alliance_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                        //System.debug('inside alliance designa if ');
                                            filteredDealRegPrms.add(dealRegRef);
                                    }
                                }
                            }
                       } 
                        if(userAccount.Service_Provider__c && dealRegRef.Deal_Program_Type__c == 'Service Provider') {
                            //System.debug('inside Serv pro if ');
                            if(isValidType(userAccount.Service_Provider_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                if(isValidDesignation(userAccount.Service_Provider_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                        filteredDealRegPrms.add(dealRegRef);
                                }
                            }
                        } 
                        if(userAccount.Solution_Provider__c && dealRegRef.Deal_Program_Type__c == 'Solution Provider') {
                            System.debug('inside sol pro if ');
                            if(isValidLevel(userAccount.Solution_Provider_Program_Level__c,dealRegRef.Partner_Program_Level__c)) {
                                System.debug('inside sol pro if level');
                                if(isValidType(userAccount.Solution_Provider_Type__c, dealRegRef.Primary_Business_Functions__c)) {
                                    System.debug('inside sol pro if type');
                                    if(isValidDesignation(userAccount.Solution_Provider_Designation__c,dealRegRef.Secondary_Business_Functions__c)) {
                                        System.debug('inside sol pro if designation');
                                        filteredDealRegPrms.add(dealRegRef);
                                    }
                                }
                            }
                        }
                }  
             } 
            } 
        }
        
       } 
        system.debug('filteredDealRegPrms-->'+filteredDealRegPrms);
        for(Deal_Registration_Program__c DRP : filteredDealRegPrms){
             system.debug('userAccount'+userAccount.Geo__c);
            for(Deal_Reg_Approvers__c DRA :DRP.Deal_Reg_Approvers__r){
            system.debug('userAccount'+DRA.Region__c+userAccount.Geo__c);
                if(DRA.Region__c == userAccount.Geo__c){
                    finalDealRegPrms.add(DRP);
                    break;  
                }
                
            
            }   
        }
        system.debug('finalDealRegPrms-->'+finalDealRegPrms);
        return finalDealRegPrms;
    }
    
    public static testMethod void DealProgramEligibility_Test()
    {           
        DealProgramEligibility objDealEligibility = new DealProgramEligibility();
        
        List<Account> accntList = new List<Account>();
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        //ac.Account_Status__c = 'Approved';        
        ac.GEO__c='NA';
        
        ac.Enterprise_ID__c = '1234te';
        
        
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        //ac.Sales_Area__c =''
        accntList.add(ac);
        Account ac1 = new Account();
        ac1.Name = 'Test Account';
        ac1.BillingState = 'NY';   
        ac1.Customer_Category__c = 'Enterprise';
        //ac1.Account_Status__c = 'Approved';       
        ac1.GEO__c='LA';
        ac1.Enterprise_ID__c = '1234te';
        ac1.Enterprise_Account_Name__c = 'rdName1';
        ac1.Commercial_ID__c = 'asdf';
        ac1.RecordTypeId = SystemIdUtility.getTerritoryAcctRecordTypeId();

        accntList.add(ac1);
        insert accntList;
        
        List<Contact> contactsList = new List<contact>();
        Contact testContact = new Contact();
        testContact.FirstName = 'test';
        testContact.LastName = 'contact';
        testContact.AccountId = ac1.Id;  
        contactsList.add(testContact);  
        
        Contact testContact1 = new Contact();
        testContact1.FirstName = 'test';
        testContact1.LastName = 'contact1';
        testContact1.AccountId = ac1.Id;  
        contactsList.add(testContact1);
        
        Contact testContact2 = new Contact();
        testContact2.FirstName = 'test';
        testContact2.LastName = 'contact2';
        testContact2.AccountId = ac1.Id;  
        contactsList.add(testContact2);
        
        Contact testContact3 = new Contact();
        testContact3.FirstName = 'test';
        testContact3.LastName = 'contact3';
        testContact3.AccountId = ac1.Id;  
        contactsList.add(testContact3);
            
        insert contactsList;
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        //UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        
       Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Basic User' Limit 1];
        List<User> usersList = new List<User>();
        User u1 = new User(alias = 'TJK', email='testjk1@ca.com',
            emailencodingkey='UTF-8', lastname='Test1',firstname='f1',
            languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles',
            username='testjk@ca.com',ContactId=testContact.Id);
        usersList.add(u1);
        
        User u2 = new User(alias = 'TJK1', email='testjk2@ca.com',
            emailencodingkey='UTF-8', lastname='Test2',firstname='f2',
            languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles',
            username='testjk1@ca.com',ContactId=testContact1.Id);
        usersList.add(u2);
        
        User u3 = new User(alias = 'TJK2', email='testjk3@ca.com',
            emailencodingkey='UTF-8', lastname='Test3',firstname='f3',
            languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles',
            username='testjk2@ca.com',ContactId=testContact2.Id);
        usersList.add(u3);
        
        User u4 = new User(alias = 'TJK3', email='testjk4@ca.com',
            emailencodingkey='UTF-8', lastname='Test4',firstname='f4',
            languagelocalekey='en_US',
            localesidkey='en_US', profileid = portalProfile.Id,
            timezonesidkey='America/Los_Angeles',
            username='testjk3@ca.com',ContactId=testContact3.Id);
       usersList.add(u4);
        insert usersList;
        
        
        List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 3];
        List<User> partnerUsers = [Select Id, ContactId, AccountId, Email from User where IsActive = true and UserType='PowerPartner' and IsPortalEnabled= true LIMIT 4];
        
        Id acctId1 = partnerUsers[0].AccountId;
        //Account acct1 = [Select Id from Account where Id = :acctId1 LIMIT 1];
        Account acct1 = ac1;
        id acc = [select id from account  limit 1].id;
        acct1.Alliance__c = true;
        acct1.Customer_Category__c = 'Reseller';
        acct1.GEO__c = 'NA';
        acct1.Region_Country__c = 'IN';
        acct1.Alliance_Designation__c = 'OEM';
        acct1.Alliance_Type__c = 'Technology Alliance';

        acct1.Service_Provider__c = false;
        acct1.Service_Provider_Program_level__c='';
        acct1.Service_Provider_Type__c='';
        acct1.Service_Provider_Designation__c='';
        acct1.Service_Provider_CAM_PMFKey__c = '';
        
        acct1.Solution_Provider__c = false;
        acct1.Solution_Provider_CAM_PMFKey__c = '';
        acct1.Solution_Provider_Program_Level__c = ''; 
        acct1.Solution_Provider_Type__c = '';
        acct1.Solution_Provider_Designation__c = '';
        
        update acct1;
        
        Id acctId2 = partnerUsers[1].AccountId;
        //Account acct2 = [Select Id from Account where Id = :acctId2 LIMIT 1];
        Account acct2 = ac1;
        acct2.Velocity_Seller__c = true;
        acct2.Customer_Category__c = 'Reseller';
        acct2.GEO__c = 'NA';
        acct2.Region_Country__c = 'IN';
        update acct2;

        Id acctId3 = partnerUsers[2].AccountId;
        //Account acct3 = [Select Id from Account where Id = :acctId3 LIMIT 1];
        Account acct3 = ac1;
        acct3.Solution_Provider__c = true;
        acct3.Customer_Category__c = 'Reseller';
        acct3.GEO__c = 'NA';
        acct3.Region_Country__c = 'IN';

        acct3.Service_Provider__c = false;
        acct3.Service_Provider__c = false;
        acct3.Service_Provider_Program_level__c='';
        acct3.Service_Provider_Type__c='';
        acct3.Service_Provider_Designation__c='';
        acct3.Service_Provider_CAM_PMFKey__c = '';
        
        acct3.Alliance__c = false;
        acct3.Alliance_Program_Level__c = '';
        acct3.Alliance_Type__c = '';
        acct3.Alliance_Designation__c = '';
        acct3.Alliance_CAM_PMFKey__c = '';
        update acct3;

        Id acctId4 = partnerUsers[3].AccountId;
        //Account acct4 = [Select Id from Account where Id = :acctId4 LIMIT 1];
        Account acct4 = ac1;
        acct4.Service_Provider__c = true;
        acct4.Customer_Category__c = 'Reseller';
        acct4.GEO__c = 'NA';
        acct4.Region_Country__c = 'IN';

        acct4.Alliance__c = false;
        acct4.Alliance__c = false;
        acct4.Alliance_Program_Level__c = '';
        acct4.Alliance_Type__c = '';
        acct4.Alliance_Designation__c = '';
        acct4.Alliance_CAM_PMFKey__c = '';
        
        acct4.Solution_Provider__c = false;
        acct4.Solution_Provider__c = false;
        acct4.Solution_Provider_Program_Level__c = ''; 
        acct4.Solution_Provider_Type__c = '';
        acct4.Solution_Provider_Designation__c = '';
        acct4.Solution_Provider_CAM_PMFKey__c = '';
        
        update acct4;
                                     
        //Create Deal Registration Program
        Deal_Registration_Program__c delPgrm = new Deal_Registration_Program__c();
        delPgrm.name = 'TestDRP';
        delPgrm.Partner_Friendly_Name__c = 'TestDRP';
        delPgrm.Description__c = 'TestDRP';
        delPgrm.Program_Manager__c = approvers[0].Id;
        delPgrm.Program_Queries__c = approvers[1].Id;
        delPgrm.First_Approver__c = approvers[2].Id;
        delPgrm.Max_Deal_Value__c = 1000;
        delPgrm.Min_Deal_Value__c = 500;
        delPgrm.Start_Date__c = Date.today();
        delPgrm.End_Date__c = Date.today();
        delPgrm.Expiry_Days__c = 10;
        delPgrm.Deal_Program_Type__c = 'Solution Provider';
        delPgrm.Finance_Approver_Email__c = 'approver@ca.com';    
        delPgrm.Opp_Type__c = '1 Tier';
        insert delPgrm;     
                              
        Deal_Registration_Program__c delPgrm2 = new Deal_Registration_Program__c();
        delPgrm2.name = 'TestDRP2';
        delPgrm2.Partner_Friendly_Name__c = 'TestDRP2';
        delPgrm2.Description__c = 'TestDRP2';
        delPgrm2.Program_Manager__c = approvers[0].Id;
        delPgrm2.Program_Queries__c = approvers[1].Id;
        delPgrm2.First_Approver__c = approvers[2].Id;
        delPgrm2.Max_Deal_Value__c = 1000;
        delPgrm2.Min_Deal_Value__c = 500;
        delPgrm2.Start_Date__c = Date.today();
        delPgrm2.End_Date__c = Date.today();
        delPgrm2.Expiry_Days__c = 10;
        delPgrm2.Deal_Program_Type__c = 'Service Provider';    
        delPgrm2.Finance_Approver_Email__c = 'approver@ca.com'; 
        insert delPgrm2;        
                               
        Deal_Registration_Program__c delPgrm3 = new Deal_Registration_Program__c();
        delPgrm3.name = 'TestDRP3';
        delPgrm3.Partner_Friendly_Name__c = 'TestDRP3';
        delPgrm3.Description__c = 'TestDRP3';
        delPgrm3.Program_Manager__c = approvers[0].Id;
        delPgrm3.Program_Queries__c = approvers[1].Id;
        delPgrm3.First_Approver__c = approvers[2].Id;
        delPgrm3.Max_Deal_Value__c = 1000;
        delPgrm3.Min_Deal_Value__c = 500;
        delPgrm3.Start_Date__c = Date.today();
        delPgrm3.End_Date__c = Date.today();
        delPgrm3.Expiry_Days__c = 10;
        delPgrm3.Deal_Program_Type__c = 'Alliance';   
        delPgrm3.Finance_Approver_Email__c = 'approver@ca.com';   
        delPgrm3.Opp_Type__c = 'Eriwin';
        insert delPgrm3;        
                                       
        Deal_Registration_Program__c delPgrm4 = new Deal_Registration_Program__c();
        delPgrm4.name = 'TestDRP4';
        delPgrm4.Partner_Friendly_Name__c = 'TestDRP4';
        delPgrm4.Description__c = 'TestDRP4';
        delPgrm4.Program_Manager__c = approvers[0].Id;
        delPgrm4.Program_Queries__c = approvers[1].Id;
        delPgrm4.First_Approver__c = approvers[2].Id;
        delPgrm4.Max_Deal_Value__c = 1000;
        delPgrm4.Min_Deal_Value__c = 500;
        delPgrm4.Start_Date__c = Date.today();
        delPgrm4.End_Date__c = Date.today();
        delPgrm4.Expiry_Days__c = 10;
        delPgrm4.Deal_Program_Type__c = 'Reseller';  
        delPgrm4.Finance_Approver_Email__c = 'approver@ca.com';     
        delPgrm4.Opp_Type__c = '2 Tier';
        insert delPgrm4;
         
        objDealEligibility.isValidDesignation('Test','Test');    
        objDealEligibility.isValidDesignation(null ,'Test');
        objDealEligibility.isValidDesignation('Test' ,'Test1');
        
        objDealEligibility.isvalidsector('FED','Test','Test','Test','NA');      //,'TEST','TEST'
        objDealEligibility.isvalidsector('abcd','FED',null,null,'NA');
        objDealEligibility.isvalidsector('SLED','FED',null,null,'NA');
        objDealEligibility.isvalidsector('xyz','Test',null,null,'NA');
        objDealEligibility.isvalidsector('','FED','Government','','NA');
        objDealEligibility.isvalidsector('fghyr','FED','Government','','');
        
        objDealEligibility.isValidLevel('Test','Test');
        objDealEligibility.isValidLevel(null,'Test');
        objDealEligibility.isValidLevel('test','abc');        
        
        objDealEligibility.isValidType('Test','Test');
        objDealEligibility.isValidType(null,'Test');
        objDealEligibility.isValidType('Test','Test1');
        
        objDealEligibility.isValidGEO('Test','Test');
        objDealEligibility.isValidGEO('Test',null);
        objDealEligibility.isValidGEO('Test','Test1');
        
        objDealEligibility.isValidCountry('Test-1','Test-2','Test-3');
        objDealEligibility.isValidCountry(null,'Test-2','Test-3');
        objDealEligibility.isValidCountry('Test','Test','Test');
        
        objDealEligibility.isValidOppType(null, 'Test');
        objDealEligibility.isValidOppType('Test', null);
        //to do Test class
        /*objDealEligibility.isValidDealRegistrationProgram(acct3.Id, delPgrm.Id,acct3.Id);
        objDealEligibility.isValidDealRegistrationProgram(acct4.Id, delPgrm2.Id);
        objDealEligibility.isValidDealRegistrationProgram(acct1.Id, delPgrm3.Id);
        objDealEligibility.isValidDealRegistrationProgram(acct2.Id, delPgrm4.Id);*/
        
        Id oppId;
        Id oppId2;
        
             Profile p = [SELECT Id FROM Profile WHERE Name='1.0 CA Sys Admin Commit & PR Non-SSO'];
                
        Account ac11 = new Account();
        ac11.Name = 'Test Account';
        ac11.BillingState = 'NY';   
        ac11.Customer_Category__c = 'Enterprise';   
        ac11.GEO__c='NA';
        ac11.Enterprise_ID__c = '1234te';       
        ac11.Enterprise_Account_Name__c = 'rdName';
        ac11.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac11.Commercial_ID__c = 'asdf';
        insert ac11; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac11.Id);
        insert con; 
        
        User partnerUser = new User(alias = 'test123', email='test123@gmail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        
        try{
            insert partnerUser;
        }
        catch(exception e){
            
        }
       // User pUser = Test_CreateOpportunity.createPartnerUser();
        System.runAs(partnerUser){
            Opportunity opp1 = Test_CreateOpportunity.createTestOpp('1 Tier');
            oppId = opp1.Id;            
           
        }
        
        objDealEligibility.isValidDealRegistrationProgram(acct3.Id, delPgrm.Id,acct4.Id,oppId);
        objDealEligibility.isValidDealRegistrationProgram(acct4.Id, delPgrm2.Id,acct3.Id,oppId);
       // objDealEligibility.isValidDealRegistrationProgram(acct1.Id, delPgrm3.Id,acct2.Id,oppId);
       // objDealEligibility.isValidDealRegistrationProgram(acct2.Id, delPgrm4.Id,acct1.Id,oppId);
        
        objDealEligibility.getEligibleDealRegistrationPrograms(partnerUsers[0].AccountId,acc,oppId);
        objDealEligibility.getEligibleDealRegistrationPrograms(partnerUsers[1].AccountId,acc,oppId);
       // objDealEligibility.getEligibleDealRegistrationPrograms(partnerUsers[2].AccountId,acc,oppId);
       //objDealEligibility.getEligibleDealRegistrationPrograms(partnerUsers[3].AccountId,acc,oppId);
    }
}