global class CAResellContactSearch {

    public String selectedAccount { get; set; }
    public List<Contact> results{get;set;}
    public boolean resultRecords{get;set;}
    public String contactName {get;set;}
    public boolean showResults {get;set;}
    public boolean showCreateBlock {get;set;}
    public boolean showCreate{get;set;}
    public string selectedFunctionalRole{get;set;}
    
    public string newSelAccount{get;set;}          
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string email{get;set;}
    public string title{get;set;}
    public string functionalRole{get;set;}
    public string phone{get;set;}
    public string mobile{get;set;}
    public string fax{get;set;}
    
    public string account_SMB_RecordTypeID {get;set;}
    public string account_AccountTeamCovered_RecordTypeID {get;set;}
    public string account_Territory_RecordTypeID {get;set;}
    public string endUserAccountId{get;set;}
    public string accountName{get;set;}
    
    public String searchcon { get; set; }
    
    public CAResellContactSearch()
    {
        endUserAccountId = ApexPages.currentPage().getParameters().get('accId');
        if(endUserAccountId != null){
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
                Account endUserAcc = [SELECT Name FROM Account WHERE Id=:endUserAccountId LIMIT 1];
                if(endUserAcc != null)
                {
                    accountName = endUserAcc.Name;  
                }
                results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title FROM Contact 
                                WHERE AccountId =: endUserAccountId LIMIT 1000 ]; // order by Name 
                if(results.size() > 0)
                {
                    showResults = true;
                }
                else
                {
                    showResults = false;                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contacts are not found.'));
                }
                showCreateBlock = false;
                showCreate = true;      
        }
    }
    
    public PageReference SearchContacts(){
      if(endUserAccountId != null){
          system.debug('______searchcon'+searchcon);
          if(searchcon != '' && searchcon<>null)
            results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title FROM Contact 
                        WHERE AccountId =: endUserAccountId and name like :'%'+searchcon+'%' order by Name]; 
          else
              results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title FROM Contact 
                        WHERE AccountId =: endUserAccountId  LIMIT 1000 ];
          if(results.size() > 0)
          {
              showResults = true;
          }
          else
          {
              showResults = false;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contacts are not found.'));
          }  
      }
        else{
              showResults = false;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'End User Account is null.'));
        }
        showCreate = true; 
        showCreateBlock = false;
        return null;
    }
    
    public PageReference CreateContact() {
        try{
                ID accId = endUserAccountId;
                Contact unnamedContact = new Contact();
                unnamedContact.FirstName = firstName.trim();
                unnamedContact.LastName = lastName.trim();        
                unnamedContact.Email = email.trim();
                unnamedContact.Title = title.trim();
                unnamedContact.Functional_Role__c = functionalRole;
                unnamedContact.Phone = phone.trim(); 
                unnamedContact.MobilePhone = mobile.trim();
                unnamedContact.fax = fax.trim();
                unnamedContact.AccountId = accId;
                insert unnamedContact;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Contact has been created successfully.'));
                ClearControls();
                SearchContacts();
        }
        catch(Exception e)
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error occurred while creating a contact.'));
        }
        return null;
    }
    
    public void ClearControls()
    {
        newSelAccount = '--Select--';
        selectedAccount = '--Select--';
        contactName = null;
        selectedFunctionalRole = '--Select--';
        firstName = null;
        lastName = null;
        email = null;
        title = null;
        functionalRole = null;
        phone = null;
        mobile = null;
        fax = null;     
        showResults = false;
        showCreateBlock = false;
        showCreate = false;
    }
    
    public List<SelectOption> getfunctionalRoles()  {
        List<SelectOption> functionalRoleOptions = new List<SelectOption>();
        functionalRoleOptions.add(new SelectOption('--Select--','--Select--'));
        Schema.DescribeFieldResult functionalRoleDescription = Contact.Functional_Role__c.getDescribe();
        for(Schema.Picklistentry picklistEntry:functionalRoleDescription.getPicklistValues())
        {
            functionalRoleOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return functionalRoleOptions;
    }
    
    public PageReference showCreateContact()
    {
      showCreateBlock = true;  
      showResults = false;
      showCreate = false;        
      return null;  
    }
 
}