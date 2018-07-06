public class Quote_TechnicalContactSearchController {
    
    @TestVisible
    private String EndUserId='';
    @TestVisible
    private String quoteId='';
    @TestVisible
    private List<SBQQ__Quote__c> quote = new List<SBQQ__Quote__c>();	//to query transaction type
    @TestVisible
    private boolean isPartnerQuote = false;		//to check if it's a partner quote or not.
    @TestVisible
    private boolean endUserExists = false;		//to check if End User exists and is different from sold to, for a partner quote
    											//and if the contact type is Shipping or Technical.
    @TestVisible
    private String searchType = '';				//to store search type.
    @TestVisible
    private String EndUserCountry = '';				//to store End User Country.
    
    public List<SAP_ECC_Utility.ContactItem> ContactList{get;set;}
    public String SoldToID{get;set;}
    public String SoldToCountry{get;set;}
    public Boolean showContactList{get;set;}
    public Boolean showContactLink{get;set;}
    public Boolean showCreateContact{get;set;}
    public string firstName{get;set;}
    public string lastName{get;set;}
    public string email{get;set;}
    public string title{get;set;}
    public string partnerRole{get;set;}
    public string phone{get;set;}
    public string mobile{get;set;}
    public string fax{get;set;}
    public string firstnamelocal{get;set;}
    public string lastnamelocal{get;set;}
    public SAP_ECC_Utility SAPUtilityObj;
    public Quote_TechnicalContactSearchController(){
        SoldToID= ApexPages.currentPage().getParameters().get('soldId');
        SoldToCountry=ApexPages.currentPage().getParameters().get('SoldToCountry');
        EndUserId = ApexPages.currentPage().getParameters().get('EndUserId');
        quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        searchType = ApexPages.currentPage().getParameters().get('searchtype');
        EndUserCountry = ApexPages.currentPage().getParameters().get('EndUserCountry');
        
        
        if(String.isNotBlank(quoteId))
            quote = [select Id,Transaction_Type__c from SBQQ__Quote__c where Id=:quoteId];
        
        if(quote[0].Transaction_Type__c=='1 Tier'){
            system.debug('---partner quote----');
            isPartnerQuote = true;		//to determine if quote is partner quote or not..
            if(String.isNotBlank(EndUserId) && EndUserId!=SoldToID && (searchType=='Shipping'||searchType=='TECHNICAL')){
                system.debug('----end user exists----');
                endUserExists = true;
            }
            else{
                system.debug('----end user does not exist----');
                endUserExists = false;
            }
        }
        else{
            system.debug('---direct quote----');
            isPartnerQuote = false;
        }
        
        system.debug('-----end user id-----'+EndUserId);
        
        showContactList = true;
        showContactLink = true;
        showCreateContact = false;
        ContactList = new List<SAP_ECC_Utility.ContactItem>();
    title='';        
    }
    
    public pagereference doDataload(){
        SAPUtilityObj =new SAP_ECC_Utility();
        SAP_ECC_Utility.SAPResponse Resobj = new SAP_ECC_Utility.SAPResponse();
        SAP_ECC_Utility.SAPResponse Resobj2 = new SAP_ECC_Utility.SAPResponse();
        Boolean partnerSoldToNoData = false;
        Boolean partnerSoldToError = false;
        Boolean partnerEndUserNoData = false;
        Boolean partnerEndUserError = false;
       
        if(searchType!='EndUserContact'){
            Resobj=SAPUtilityObj.getAllTechnicalContact(SoldToID,SoldToCountry);
        }
        else if(searchType=='EndUserContact'){
            Resobj=SAPUtilityObj.getAllTechnicalContact(EndUserId,EndUserCountry);
        }
        
        
        if(isPartnerQuote==false){
            if(Resobj.Message == ''){
                if(Resobj.ContactList.size()>0){
                    ContactList=Resobj.ContactList;
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found.'));
                }
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Resobj.Message));
            }
            
        }
        else if(isPartnerQuote==true){
            system.debug('---partner quote calls-----');
            if(Resobj.Message == ''){
                if(Resobj.ContactList.size()>0){
                    ContactList=Resobj.ContactList;
                }else{
                    system.debug('---no sold to data----');
                    partnerSoldToNoData = true;
                }
                
            }else{
                system.debug('---error in sold to call----');
                partnerSoldToError = true;
            }
            
            if(endUserExists==true){
                system.debug('--making end user call----');
                Resobj2=SAPUtilityObj.getAllTechnicalContact(EndUserId,EndUserCountry);
                if(Resobj2.Message == ''){
                    if(Resobj2.ContactList.size()>0){
                        system.debug('---adding----');
                        ContactList.addAll(Resobj2.ContactList);
                    }
                    else{
                        system.debug('---no end user data----');
                        partnerEndUserNoData = true;
                    }
                }
                else{
                    system.debug('---error in end user call----');
                    partnerEndUserError = true;
                }
            }
            if(endUserExists==true){
                if(partnerEndUserNoData==true && partnerSoldToNoData==true){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found.'));
                }
                if(partnerSoldToError==true && partnerEndUserError==true){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Resobj.Message));
                }
            }
            else{
                if(partnerSoldToNoData==true){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found.'));
                }
                if(partnerSoldToError==true){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Resobj.Message));
                }
            }
                     
        }
        return null;   
    }
     public List<SelectOption> getpartnerRoles()  {
        List<SelectOption> functionalRoleOptions = new List<SelectOption>();
        functionalRoleOptions.add(new SelectOption('--Select--','--Select--'));
        functionalRoleOptions.add(new SelectOption('TECHNICAL_CONTACT','TECHNICAL CONTACT'));
         functionalRoleOptions.add(new SelectOption('BILLING_CONTACT','BILLING CONTACT'));
         functionalRoleOptions.add(new SelectOption('SHIPPING_CONTACT','SHIPPING CONTACT'));
        return functionalRoleOptions;
    }
    public pagereference opencreateContact(){
         showContactList = false;
        showContactLink = false;
        showCreateContact = true;
        return null;
    }
    public Pagereference Createcontact(){
       
        if(String.isBlank(firstName)){
             Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'First Name is required.'));
            return null;
        }
        if(String.isBlank(lastName)){
             Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Last Name is required.'));
            return null;
        }
         
         if(String.isBlank(email)){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Email is required'));
            return null;
         }
        /*else{
                if(!Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z0-9]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', email))
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Invalid E-mail Address')); 
                    return null;
                }
         }*/
        if(partnerRole == '--Select--'){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Partner Function is required.'));
            return null;
        }
        Map<String,String> responseMAP =new Map<String,String>();
        if(searchType!='EndUserContact'){
            responseMAP=SAPUtilityObj.CreateTechnicalContact(SoldToID,'',partnerRole,title,firstName,lastName,email,phone);
        }
        else if(searchType=='EndUserContact'){
            responseMAP=SAPUtilityObj.CreateTechnicalContact(EndUserId,'',partnerRole,title,firstName,lastName,email,phone);
        }
        if(responseMAP != null){
            if(responseMAP.containsKey('STATUS') && responseMAP.get('STATUS').equalsIgnoreCase('Success')){
                doDataload();
                ClearControls();
                showContactList = true;
                showContactLink = true;
                showCreateContact = false;
            }else{
                if(responseMAP.containsKey('MESSAGE') && responseMAP.get('MESSAGE') != ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,responseMAP.get('MESSAGE')));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Something went wrong. Please try again later.'));
                }
                
            }
        }
        return null;
        
    }
     public void ClearControls()
    {
        partnerRole = '--Select--';
        firstName = null;
        lastName = null;
        email = null;
        title = '';
        phone = null;
        mobile = null;
        fax = null;
        firstnamelocal = null;
        lastnamelocal = null;
    }
    
}