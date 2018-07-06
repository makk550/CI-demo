public class CAEndUserAccountSearch {
    
    transient public string accountName{get;set;}
    public string physicalStreet{get;set;}
    public string physicalCity{get;set;}
    public string physicalState{get;set;}
    public string physicalCountry{get;set;}
    public string ZipPostalCode{get;set;} //PRM5 - CAM
    public string createaccountName{get;set;}
    public string stateRegion{get;set;}
    public string newCountry{get;set;}
    
    public string selectedCountry{get;set;}
    public List<Account> results{get;set;}
    public boolean showResults{get;set;}
    public boolean showSearch{get;set;}
    public boolean showCreate{get;set;}
    public boolean showCreateBlock{get;set;}
    
    public string account_SMB_RecordTypeID {get;set;}
    public string account_AccountTeamCovered_RecordTypeID {get;set;}
    public string account_Territory_RecordTypeID {get;set;}
    public boolean IsAccCreateSuccess {get; set;}
        
    public pagereference CreateAccount() {
               
       try{
       
          Account unnamedAccount = new Account();
          unnamedAccount.Name = createaccountName.trim();        
          unnamedAccount.RecordTypeId = account_SMB_RecordTypeID;
          unnamedAccount.BillingStreet = physicalStreet.trim();
          unnamedAccount.BillingCity = physicalCity.trim();
          unnamedAccount.BillingState = physicalState.trim();
          unnamedAccount.Country_Picklist__c = newCountry;
          unnamedAccount.BillingPostalCode=ZipPostalCode; //PRM5 - CAM
          
          User user = [select id,Contactid from User where id = :Userinfo.getUserId()];
          
          Set<String> couSet = new Set<String>();
          List<No_Zip_Code_Countries__c>   nzcList = [select Country__c from No_Zip_Code_Countries__c];
   
          if(nzcList<> null){ 
           for(No_Zip_Code_Countries__c nc:nzcList)
           {
               couSet.add(nc.Country__c);
           }
          }
          
          if(user.Contactid !=null && couSet <> null){
              //system.debug('testing outside'+newCountry+couSet+ZipPostalCode);

              if(!couSet.Contains(newCountry) && (ZipPostalCode=='' || ZipPostalCode==null))
              {    
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'Please enter Zip/Postal Code.'));
              }
              else{
                  
                  //system.debug('testing inside'+newCountry+couSet);
                  insert unnamedAccount;
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Account has been created successfully.'));
                  accountName = createaccountName;
                  selectedCountry = newCountry;
                  stateRegion = '';
                  SearchAccounts();
                  showResults = true;
                  ClearControls();
              }
          }
       }
       catch(Exception e)
       {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e));
       }
        return null;
    }
    
    public void ClearControls()
    {
        accountName = null;
        physicalStreet = null;
        physicalCity = null;
        physicalState = null;
        physicalCountry = null;
        createaccountName = null;
        stateRegion = null;
        ZipPostalCode=null; //PRM5 - CAM
        selectedCountry = '--Select--';
        newCountry = '--Select--';
        showCreate = false;
    }
    
    public CAEndUserAccountSearch() {
        List<RecordType> accRecordTypes = [SELECT Id,
                                                  Name 
                                           FROM RecordType WHERE 
                                           Name in ('SMB','Account Team Covered Account','Territory Covered Account') AND 
                                           IsActive=true AND SObjectType='Account'];
        for(RecordType accRecType: accRecordTypes){
            if(accRecType.Name == 'SMB')
                account_SMB_RecordTypeID = accRecType.ID;
            else if(accRecType.Name == 'Account Team Covered Account')
                account_AccountTeamCovered_RecordTypeID = accRecType.ID;
            else if(accRecType.Name == 'Territory Covered Account'){
                account_Territory_RecordTypeID = accRecType.ID;
            }       
        }

        showResults = false;
        showCreate = false;
        showSearch = true;
        showCreateBlock = false;
    }

    public PageReference SearchAccounts()
    {  
       //string accountTypes = account_SMB_RecordTypeID +',' + account_AccountTeamCovered_RecordTypeID +','+ account_Territory_RecordTypeID;
       string strAccountName = accountName.trim() +'%';
       string strRegion = stateRegion.trim() + '%';  
       
       strAccountName   = strAccountName.replaceAll('\'' , '%');
       
       List<String> HQCountries_Terr = new List<String>();
       String str_HQCountries_Terr = '';
       if(selectedCountry!= NULL &&  selectedCountry == 'US - UNITED STATES'){
          Schema.DescribeFieldResult F = Account.HQ_Countries__c.getDescribe();
          List<Schema.PicklistEntry> P = F.getPicklistValues();
          for(Schema.PicklistEntry pEntry :p)
          {
                if(pEntry.getValue().startsWith('EA_') || pEntry.getValue().startsWith('NA_') || pEntry.getValue().startsWith('NO_') || pEntry.getValue().startsWith('PS_') || pEntry.getValue().startsWith('WE_')){
                    HQCountries_Terr.add(pEntry.getValue());
                    str_HQCountries_Terr+='\''+pEntry.getValue()+'\''+',';
                   
                }   
          }
         
       }
       else if(selectedCountry!= NULL &&  selectedCountry == 'BR - BRAZIL'){
          Schema.DescribeFieldResult F = Account.HQ_Countries__c.getDescribe();
          List<Schema.PicklistEntry> P = F.getPicklistValues();
          
          for(Schema.PicklistEntry pEntry :p)
          {
                if(pEntry.getValue().length()==3){
                    HQCountries_Terr.add(pEntry.getValue());
                    str_HQCountries_Terr+='\''+pEntry.getValue()+'\''+',';
                }   
          }
          str_HQCountries_Terr+='\'BR\',';
       }
       else if(selectedCountry!= NULL && selectedCountry.length()>2){
           HQCountries_Terr.add(selectedCountry.subString(0,2));
          str_HQCountries_Terr+='\''+selectedCountry.subString(0,2)+'\''+',';
       }  
       
       try{ 
        str_HQCountries_Terr = str_HQCountries_Terr.subString(0,str_HQCountries_Terr.length()-1);   
       }catch(Exception e){
          str_HQCountries_Terr = str_HQCountries_Terr.subString(0);  
       }
                   
       String accQuery = NULL;
       System.debug('_____str_HQCountries_Terr____1____'+str_HQCountries_Terr);
       if(stateRegion != ''){
            // PRM 4 - Dynamic Query Introduced - 71.00
        accQuery = 'SELECT Name,Business_Name__c,GEO__c,BillingStreet,BillingState,BillingCity,Country_Picklist__c,BillingPostalCode FROM Account WHERE Name like '+'\''+strAccountName+'\''+' AND '+
        '((RecordTypeID IN '+'(\''+account_SMB_RecordTypeID+'\''+','+'\''+account_AccountTeamCovered_RecordTypeID+'\''+','+'\''+account_Territory_RecordTypeID+'\') AND BillingState like '+'\''+strRegion+'\''+' AND Country_Picklist__c= '+'\''+selectedCountry+'\')'+
                                                                 ' OR '
            +'(RecordTypeID ='+'\''+account_Territory_RecordTypeID+'\' AND BillingState like '+'\''+strRegion+'\''+' AND HQ_Countries__c includes ('+str_HQCountries_Terr+')))  LIMIT 25';
      
         System.debug('____dynamic soql__1___'+accQuery);
        /* PRM 4 - Commented out - 71.00 
           results = [SELECT Name, Business_Name__c,
                          GEO__c,
                          BillingStreet,
                          BillingState,
                          BillingCity,
                          Country_Picklist__c
                   FROM Account 
                   WHERE Name like :strAccountName  AND
                   
                   ((RecordTypeID IN (:account_SMB_RecordTypeID, :account_AccountTeamCovered_RecordTypeID, :account_Territory_RecordTypeID) AND BillingState like :strRegion  AND Country_Picklist__c =: selectedCountry)
                                                        OR
                         (RecordTypeID =: account_Territory_RecordTypeID  AND HQ_Countries__c includes ('NA_CORPORATE','EA_SOUTHEAST')))
                                       LIMIT 25];  
         */
       }
       else
       {
        // PRM 4 - Dynamic Query Introduced - 71.00
        accQuery = 'SELECT Name,Business_Name__c,GEO__c,BillingStreet,BillingState,BillingCity,Country_Picklist__c,BillingPostalCode FROM Account WHERE Name like '+'\''+strAccountName+'\''+' AND '+
        '((RecordTypeID IN '+'(\''+account_SMB_RecordTypeID+'\''+','+'\''+account_AccountTeamCovered_RecordTypeID+'\''+','+'\''+account_Territory_RecordTypeID+'\') AND Country_Picklist__c= '+'\''+selectedCountry+'\')'+
                                                                 ' OR '
            +'(RecordTypeID ='+'\''+account_Territory_RecordTypeID+'\' AND HQ_Countries__c includes ('+str_HQCountries_Terr+')))  LIMIT 25';
           

        
          
         /* PRM 4 - Commented out - 71.00 
          results = [SELECT Name, Business_Name__c,
                          GEO__c,
                          BillingStreet,
                          BillingState,
                          BillingCity,
                          Country_Picklist__c
                   FROM Account 
                   WHERE Name like :strAccountName  AND
                   
                   ((RecordTypeID IN (:account_SMB_RecordTypeID, :account_AccountTeamCovered_RecordTypeID, :account_Territory_RecordTypeID) AND Country_Picklist__c =: selectedCountry)
                                                        OR
                         (RecordTypeID =: account_Territory_RecordTypeID  AND HQ_Countries__c includes ('NA_CORPORATE','EA_SOUTHEAST')))
                         
                                       LIMIT 25];  */
                                       System.debug('____dynamic soql__2___'+accQuery);
       
       }
        results = database.query(accQuery);         
        if(results.size()>0)
        {
            showResults = true;
            showCreate = true;
        }
        else if(!showCreateBlock) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Account not found.'));
            showCreate = true;
            showResults = false;
            
        }
        return null;
    }
    
    public List<SelectOption> getCountries()
    {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('--Select--','--Select--'));
        Schema.DescribeFieldResult countryFieldDescription = Account.Country_Picklist__c.getDescribe();
        for(Schema.Picklistentry picklistEntry:countryFieldDescription.getPicklistValues())
        {
            countryOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return countryOptions;
    }
    
    public PageReference showCreateAccount()
    {
      showCreateBlock = true;
      showCreate = false;
      showSearch = false;  
      showResults = false;        
      return null;  
    }
    
    public PageReference showSearchScreen()
    {
      showCreateBlock = false;
      showCreate = false;
      showSearch = true;    
      showResults = false;      
      return null;  
    }
     /*     
    public static testMethod void CAEndUserAccountSearch_Test(){
     CAEndUserAccountSearch objSearch = new CAEndUserAccountSearch();   
     objSearch.accountName = 'test';
     objSearch.stateRegion = 'test';
     objSearch.createaccountName ='test';
     objSearch.physicalStreet = 'test';
     objSearch.physicalCity = 'test';
     objSearch.newCountry ='IN - INDIA';
     objSearch.physicalState = 'test';
     objSearch.getCountries();
     objSearch.showCreateAccount();
     objSearch.showSearchScreen();
     objSearch.newCountry = 'BR - BRAZIL';
     objSearch.selectedCountry = 'BR - BRAZIL';
     objSearch.SearchAccounts();    
     objSearch.CreateAccount();
     objSearch.ClearControls();
     
     objSearch = new CAEndUserAccountSearch(); 
     objSearch.accountName = 'test';
     objSearch.stateRegion = '';
     objSearch.selectedCountry = 'IN - INDIA';
   //  objSearch.SearchAccounts();
    } */
    
    public String formatName(String Name)
    {
        return String.escapeSingleQuotes(Name);
    }
}