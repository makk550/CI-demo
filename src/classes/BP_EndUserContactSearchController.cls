public class BP_EndUserContactSearchController{
    public String selectedAccount { get; set; }
    public List<Contact> results{get;set;}
    public List<wrapperclassTable> Dataresult{get;set;}
    public String Countryval;
    public boolean resultRecords{get;set;}
    public String contactName {get;set;}
    public boolean showResults {get;set;}
    public boolean showCreateBlock {get;set;}
    public boolean showCreate{get;set;}
    public string selectedFunctionalRole{get;set;}
    public String productNameUrl{get;set;}
    public String resourceTypeUrl{get;set;}
    public static String Sortingorder{get;set;}
    public Set<String> accountset;
	public Set<String> accountidset;
    
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
    public Map<String,pp_calculated_certification__x> pp_calCertificationMap{get;set;}
    
    public String searchcon { get; set; }
    public String getContactbadge(ID conId){
        if(pp_calCertificationMap.containsKey(conId)){
            pp_calculated_certification__x pprecord = pp_calCertificationMap.get(conId);
            return pprecord.badge__c;
        }
        return '';
    }
    
    set<id> accidset=new set<id>();
    
    public BP_EndUserContactSearchController()
    {
        /*getting Account ID from Url*/
        Countryval =ApexPages.currentPage().getParameters().get('countryVal');
        endUserAccountId = ApexPages.currentPage().getParameters().get('accId');
        /*****************Certification Map build start here******************************/
        String FiscalYear =ApexPages.currentPage().getParameters().get('fiscalyear');
        String IncentiveplanYear = FiscalYear.removeStart('FY ');
        pp_calCertificationMap = new Map<String,pp_calculated_certification__x>();
        String inputvaluesURL =ApexPages.currentPage().getParameters().get('inputvalues');
        
        System.debug('inputvaluesURL ->'+inputvaluesURL );
        if(inputvaluesURL != null){
            List<String> inputvalueList = inputvaluesURL.split('\\.');
            System.debug(inputvalueList);
            productNameUrl=inputvalueList[2];
            resourceTypeUrl=inputvalueList[3];
        }
        accountset = new Set<String>();
        accountset.add(endUserAccountId);
		accountidset = new Set<String>();
		accountidset.add(endUserAccountId);
        if(Countryval == null || Countryval == ''){
            List<Account> listcAccounts1 = [SELECT Id FROM Account WHERE Included_in_BP_of_CA_AccountID__c =:endUserAccountId];
            for(Account ac :listcAccounts1){
                accountidset.add(ac.Id);
            }
            
        }else{
            List<Account> listcAccounts = [SELECT Id FROM Account WHERE Included_in_BP_of_CA_AccountID__c =:endUserAccountId];
            for(Account ac :listcAccounts){
                accountset.add(ac.Id);
            }
        }
        List<pp_calculated_certification__x> calCertificationList;
        Map<String,String> LPACProductMAP =new Map<String,String>();
        if(!Test.isRunningTest()){
          calCertificationList=[select IdContact__c,badge__c,fiscal_year__c,ExternalId,product_name__c from pp_calculated_certification__x where account_id__c IN :accountset and resource_type__c =:resourceTypeUrl and fiscal_year__c=:IncentiveplanYear];
        }else{
            calCertificationList = testCertificationData(endUserAccountId,productNameUrl,resourceTypeUrl,IncentiveplanYear);
        }
        List<LPACCertificateData__c> LPACProductData = LPACCertificateData__c.getall().values();
        if(LPACProductData.size() > 0){
            for(LPACCertificateData__c Pro:LPACProductData){
                if(!LPACProductMAP.containsKey(Pro.SFDC_Product_Group__c)){
                    LPACProductMAP.put(Pro.SFDC_Product_Group__c,Pro.LPAC_Focus_Product__c);
                }
            }
        }
        for(pp_calculated_certification__x s : calCertificationList){
            if(!pp_calCertificationMap.containsKey(s.IdContact__c) && (s.product_name__c == productNameUrl || (LPACProductMAP.containsKey(productNameUrl) && LPACProductMAP.get(productNameUrl) == s.product_name__c)) ){
                //System.debug('matched ');
                pp_calCertificationMap.put(s.IdContact__c, s);
            }         
        }
        /********************************************************************************/
        System.debug('************************');
        System.debug(pp_calCertificationMap);
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
            if(Countryval == null || Countryval == '')
            {
                results = [SELECT ID,Name,Active_User__c,Country_Picklist__c, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
                           WHERE AccountId IN: accountidset order by Name Asc LIMIT 1000]; //order by Name];
            }else{
                results = [SELECT ID,Name,Active_User__c,Accountid, FirstName, LastName, Phone,Country_Picklist__c, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
                           //SAMAP01   //   WHERE AccountId =: endUserAccountId and Country_Picklist__c =:Countryval order by Name Asc LIMIT 1000]; //order by Name];
                           WHERE AccountId IN (SELECT Id FROM Account where (Included_in_BP_of_CA_AccountID__c =:endUserAccountId OR ID =: endUserAccountId) And Country_Picklist__c =:Countryval) order by Name Asc LIMIT 1000]; //order by Name];
                //(SELECT Id FROM Account WHERE Included_in_BP_of_CA_AccountID__c = '0010S000002b1Z5' OR ID='0010S000002b1Z5')
                
                //    WHERE Country_Picklist__c =:Countryval order by Name Asc LIMIT 1000]; //order by Name];
                
            }
            
            if(results.size() > 0)
            {
                System.debug('************ current contact**'+results);
                createDatatable();
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
    
    public void createDatatable(){
        Dataresult = new List<wrapperclassTable>();
        for(Contact c :results){
            boolean shouldadd = false;
            if(Countryval != null || Countryval !=''){
                shouldadd = true;
            }
            if(Countryval == null || Countryval == ''){
                shouldadd = true;
            }
            if(shouldadd == true){
                wrapperclassTable objW= new wrapperclassTable();
                objW.contactdetails = c;
                if(pp_calCertificationMap.containsKey(c.ID)){
                    objW.certificateDetails =pp_calCertificationMap.get(c.ID);
                    Dataresult.add(objW);
                    System.debug('*****************ADDED*******************');
                }else{
                    pp_calculated_certification__x ppCer =new pp_calculated_certification__x(badge__c = '',IdContact__c='');
                    objW.certificateDetails =ppCer;
                    Dataresult.add(objW);
                }
            }
            
        }
    }
    
    public PageReference SearchContacts(){
        Dataresult = new List<wrapperclassTable>();
        if(endUserAccountId != null){
            if(Countryval == null || Countryval == '')
            { 
                if(searchcon != '' && searchcon<>null)
                    results = [SELECT id,Name, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact 
                               WHERE AccountId IN (SELECT Id FROM Account WHERE (Included_in_BP_of_CA_AccountID__c =:endUserAccountId OR ID =: endUserAccountId)) and name like :'%'+searchcon+'%' order by Name Asc];
                else
                    results = [SELECT id,Name, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact 
                               WHERE AccountId IN (SELECT Id FROM Account WHERE (Included_in_BP_of_CA_AccountID__c =:endUserAccountId OR ID =: endUserAccountId))  order by Name Asc LIMIT 1000 ];
            }
            else
            { 
                if(searchcon != '' && searchcon<>null)
                    results = [SELECT id,Name,AccountId, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact 
                               WHERE AccountId IN (SELECT Id FROM Account WHERE (Included_in_BP_of_CA_AccountID__c =:endUserAccountId OR ID =: endUserAccountId) And Country_Picklist__c =:Countryval) and name like :'%'+searchcon+'%' order by Name Asc];
                
                else
                    results = [SELECT id,Name,AccountId, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact 
                               WHERE AccountId IN (SELECT Id FROM Account WHERE (Included_in_BP_of_CA_AccountID__c =:endUserAccountId OR ID =: endUserAccountId) And Country_Picklist__c =:Countryval)   order by Name Asc LIMIT 1000 ];}
            
            //results = [SELECT Name, FirstName, LastName, Phone, MobilePhone, Email, Fax, Title, FirstNameLocal, LastNameLocal FROM Contact 
            //WHERE AccountId =: endUserAccountId order by Name]; 
            if(results.size() > 0)
            {
                showResults = true;
                createDatatable();
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
            // samap01
            if(Countryval != '')
            {unnamedContact.Country_Picklist__c= Countryval; } 
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
        if(sortExpression == 'certificate'){
            createDatatable();
            Sortingorder = sortDirection;
            Dataresult.sort();
        }else{
            string sortFullExp = sortExpression  + ' ' + sortDirection;
            String s;
            if(Countryval == null || Countryval == '')
            { 
              s = 'SELECT Id,Name, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact where Accountid=\''+endUserAccountId+'\' Order by ';
            }else{
               s= 'SELECT Id,Name, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact';
                String whereB =' WHERE AccountId IN (SELECT Id FROM Account WHERE Included_in_BP_of_CA_AccountID__c =\''+endUserAccountId+'\' OR ID =\''+endUserAccountId+'\')  and Country_Picklist__c =\''+Countryval+'\' Order by ';
                s+=whereB;
            }
            s+= sortFullExp + ' limit 1000';
            //query the database based on the sort expression
            results = Database.query(s);
            createDatatable();
        }
        
        return null;
    }
    public List<pp_calculated_certification__x> testCertificationData(String AccountID,String productName,String resourceType,String planYear){
          List<Contact> conresult =[SELECT id,Name, FirstName, LastName, Phone, MobilePhone,Country_Picklist__c, Email, Fax, Title, FirstNameLocal, LastNameLocal,Active_User__c FROM Contact 
                               WHERE AccountId =: AccountID];
          List<pp_calculated_certification__x> listcert=new List<pp_calculated_certification__x>();
            pp_calculated_certification__x cert1 =new pp_calculated_certification__x();
            cert1.IdContact__c=conresult[0].Id;
            cert1.badge__c='Certified Expert';
            cert1.ExternalId=
            cert1.account_id__c=AccountID;
            cert1.product_name__c =productName;
            cert1.resource_type__c =resourceType;
            cert1.fiscal_year__c=planYear;
        listcert.add(cert1);
            return listcert;
    }
    
    public class wrapperclassTable implements Comparable {
        public pp_calculated_certification__x certificateDetails{get;set;}
        public Contact contactdetails{get;set;}
        public wrapperclassTable(){
            
        }
        public Integer compareTo(Object compareTo) {
            wrapperclassTable jobsWrapper = (wrapperclassTable) compareTo;
            if (certificateDetails.badge__c > jobsWrapper.certificateDetails.badge__c) {
                return Sortingorder == 'DESC' ? -1:1;
            } else if(certificateDetails.badge__c < jobsWrapper.certificateDetails.badge__c) {
                return Sortingorder == 'DESC' ? 1:-1;
            } else {
                return 0;
            }  
            return certificateDetails.badge__c.compareTo(((wrapperclassTable)compareTo).certificateDetails.badge__c);       
        }
        
    }
    
}