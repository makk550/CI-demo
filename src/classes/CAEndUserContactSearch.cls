public class CAEndUserContactSearch{

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
    public string firstnamelocal{get;set;}
    public string lastnamelocal{get;set;}
    
    public string account_SMB_RecordTypeID {get;set;}
    public string account_AccountTeamCovered_RecordTypeID {get;set;}
    public string account_Territory_RecordTypeID {get;set;}
    public string endUserAccountId{get;set;}
    public string accountName{get;set;}
    
    public String searchcon { get; set; }

    set<id> accidset=new set<id>();
    
    public CAEndUserContactSearch()
    {
        endUserAccountId = ApexPages.currentPage().getParameters().get('accId');
    
    accidset.add(endUserAccountId); 

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
            //samap01 -10/31/2016 US232174
               // results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
               //                 WHERE AccountId =: endUserAccountId LIMIT 1000]; //order by Name]; 
            
             results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
                                WHERE AccountId =: endUserAccountId order by Name Asc LIMIT 1000]; //order by Name]; 
              //samap01 -10/31/2016 US232174
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
        if(searchcon != '' && searchcon<>null)
            results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
                        WHERE AccountId =: endUserAccountId and name like :'%'+searchcon+'%' order by Name Asc];
        else
            results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
                        WHERE AccountId =: endUserAccountId  order by Name Asc LIMIT 1000 ];
                        
        //results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
                        //WHERE AccountId =: endUserAccountId order by Name]; 
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
            system.debug('--accId--'+accId);
                Contact unnamedContact = new Contact();
                unnamedContact.FirstName = firstName.trim();
                unnamedContact.LastName = lastName.trim();        
                unnamedContact.Email = email.trim();
                unnamedContact.Title = title.trim();
                unnamedContact.Functional_Role__c = functionalRole;
                unnamedContact.Phone = phone.trim(); 
                unnamedContact.MobilePhone = mobile.trim();
                unnamedContact.fax = fax.trim();
                unnamedContact.FirstNameLocal = firstnamelocal.trim();
                unnamedContact.LastNameLocal = lastnamelocal.trim();
                unnamedContact.AccountId = accId;
                insert unnamedContact;
            system.debug('--unnamedContact--'+unnamedContact);
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
        firstnamelocal = null;
        lastnamelocal = null;
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

     private String sortDirection = 'ASC';
    private String sortExp = 'name';

   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

 public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
    
    public PageReference ViewData() {
       //build the full sort expression
       string sortFullExp = sortExpression  + ' ' + sortDirection;
      
     String s = 'SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact where Accountid=\''+endUserAccountId+'\' Order by ';
   s+= sortFullExp + ' limit 1000';

       //query the database based on the sort expression
       results = Database.query(s);
       return null;
   }
    
    @isTest(SeeAllData=true)   
    public static void CAEndUserContactSearch_Test(){
      RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('SMB');
      Id accRecordTypeId = rec.RecordType_Id__c;
    
      List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];
                                             
      Account smbAccount = new Account();
      smbAccount.Name = 'TestSMBAccount';
      smbAccount.RecordTypeId = accRecordTypeId;
      smbAccount.OwnerId = approvers[0].Id;
      smbAccount.BillingStreet = 'Arlington';
      smbAccount.BillingCountry = 'US';
      smbAccount.BillingCity = 'VA';
      insert smbAccount;
        
      PageReference pageRef = Page.CAEndUserContactSearch; 
      Test.setCurrentPage(pageRef);    
      ApexPages.currentPage().getParameters().put('accId',smbAccount.Id);   
      CAEndUserContactSearch objSearch = new CAEndUserContactSearch();
     
        Account acc = [SELECT Id FROM Account WHERE RecordType.Name ='SMB' LIMIT 1];
        objSearch.firstName = 'test';
        objSearch.lastName = 'test';        
        objSearch.email = 'test@ca.com';
        objSearch.title = 'test';
        objSearch.functionalRole = 'test';
        objSearch.phone = '132345'; 
        objSearch.mobile = '123254';
        objSearch.fax = '232344';
        objSearch.firstnamelocal = 'testlocal';
        objSearch.lastnamelocal = 'testlocal';
        objSearch.endUserAccountId = smbAccount.Id;
        objSearch.CreateContact();
        objSearch.getfunctionalRoles();
        objSearch.SearchContacts();
        objSearch.showCreateContact();
    } 
}