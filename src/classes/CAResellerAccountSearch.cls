public class CAResellerAccountSearch {
    
    public string accountName{get;set;}
    public string physicalStreet{get;set;}
    public string physicalCity{get;set;}
    public string physicalState{get;set;}
    public string physicalCountry{get;set;}
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
        
    public PageReference CreateAccount() {
               
       try{
          Account unnamedAccount = new Account();
          unnamedAccount.Name = createaccountName.trim();        
          unnamedAccount.RecordTypeId = account_SMB_RecordTypeID;
          unnamedAccount.BillingStreet = physicalStreet.trim();
          unnamedAccount.BillingCity = physicalCity.trim();
          unnamedAccount.BillingState = physicalState.trim();
          unnamedAccount.Country_Picklist__c = newCountry;
          insert unnamedAccount;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Account has been created successfully.'));
          accountName = createaccountName;
          selectedCountry = newCountry;
          stateRegion = '';
          SearchAccounts();
          showResults = true;
          ClearControls();
       }
       catch(Exception e)
       {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error occurred while creating an Account.'));
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
        selectedCountry = '--Select--';
        newCountry = '--Select--';
        showCreate = false;
    }
    
    public CAResellerAccountSearch() {
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
		if( accountName == null || accountName == '' ){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Partner_Account ));
			showCreate = true;
			showResults = false;
			return null;
		}
		 
		if( selectedCountry == '--Select--' ){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.Partner_s_Country ));
			showCreate = true;
			showResults = false;
			return null;
		} 
		
		if( (accountName != null || accountName != '') && ( selectedCountry != '--Select--' ) ) {			
			string accQuery;
			string strAccountName = accountName.trim() +'%';
	   
			strAccountName   = strAccountName.replaceAll('\'' , '%');
	   
			accQuery = 'SELECT Name,Business_Name__c,GEO__c,BillingStreet,BillingState,BillingCity,Country_Picklist__c FROM Account WHERE (Solution_Provider_Type__c = \'Reseller\'  or  Velocity_Seller_Type__c = \'Reseller\' or Customer_Category__c  = \'Reseller\')and Country_Picklist__c =: selectedCountry and Name like '+'\''+strAccountName+'\''; 
			results = database.query(accQuery);
	  
			System.debug('selectedCountry'+selectedCountry);
			if(results.size()>0) {
			    showResults = true;
			    showCreate = true;
			} else {
			    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Account not found.'));
			    showCreate = true;
			    showResults = false;
			}			
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
    
    //ISTP - Lead to Cash : 3075 : Getter method to return list of recently accessed Reseller Accounts to be displayed on Partner Account lookup
    public List<Opportunity> getrecentlyAccessedResellers() {
        
		List<Opportunity> recentResellers = new List<Opportunity>();
		Set<id> uniqueAccounts = new Set<Id>();
		
		for(Opportunity opp : [Select Reseller__c, Reseller__r.Name, Reseller__r.Enterprise_ID__c, Reseller__r.Country_Picklist__c 
								from Opportunity 
								Where CreatedById =: UserInfo.getUserId() AND Reseller__c != null
								Order By CreatedDate DESC]){
		            
			if(!(uniqueAccounts.contains(opp.Reseller__c))){
				recentResellers.add(opp);
				uniqueAccounts.add(opp.Reseller__c);
			}
		}
        
        return recentResellers;
        
    }
          
}