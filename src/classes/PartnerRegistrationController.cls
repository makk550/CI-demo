public class PartnerRegistrationController {


 public String  theSelectedTab {get;set;}
 public String  preferredLangCode {get;set;}
 public boolean renderAccntDtls {get;set;}
 public boolean renderLinks {get;set;}
 public boolean displayPrivacyMsg {get;set;}
 public boolean displayCompleteMsg {get;set;}
 public boolean displayDupUsrMsg {get;set;}
 public String  Id {get;set;}
 public String selectedAccountId{get;set;}
 public List<SelectOption> selectedProducts { get; set; }
 public List<SelectOption> availableProducts { get; set; }
 public Boolean IsReferralHeader {get;set;}
 
 public pagereference pg{get;set;}
 
 List<Id> AccountNames=new List<Id>();
 public List<Account> accLst{get;set;}
 public String partnerId {get;set;}
 public Partner_Registration__c partnerReg{get;set;}
 public TAQ_Account__c taqAcc{get;set;}
 // MG added this and commented    public String inputText1{get;set;}
 
 public String tabName {get;set;}
 
 // (Mari,Partner profile R1)
 public List<PartnerProfileSearch.PartnerProfileAccounts>res {get;set;}
 public Boolean resLast{get;set;}
 Map<Integer,List<PartnerProfileSearch.PartnerProfileAccounts>> searchResultsMap{get;set;}
 public PartnerProfileSearch.PartnerProfileAccounts resAccount{get;set;}
 public Integer resultNavVar {get;set;}
 public Boolean showFullFirstPage{get;set;}
 public Integer labelNumber{get;set;}
 
 
 public PartnerRegistrationController (ApexPages.StandardController controller) {
     
    preferredLangCode = ApexPages.currentPage().getParameters().get('langCode');
     
    partnerReg = new Partner_Registration__c(); 
    taqAcc     = new TAQ_Account__c();   
    displayPrivacyMsg =True;
    renderLinks=True;
    theSelectedTab ='accTab';
// (Mari,Partner profile R1)
    showFullFirstPage = false;
    labelNumber= -1;
    searchResultsMap = new Map<Integer,List<PartnerProfileSearch.PartnerProfileAccounts>>();
    resultNavVar = 1;
     availableProducts = new List<SelectOption>();
     selectedProducts = new List<SelectOption>();
     availableProducts.add(new SelectOption(System.Label.POB_Referral_Product,System.Label.POB_Referral_Product));
     if(ApexPages.currentPage().getParameters().containsKey('referral'))
        {
            String referralParam = ApexPages.currentPage().getParameters().get('referral');
            IsReferralHeader =true;
            partnerReg.Company_business_model__c = System.Label.POB_partner_referral;
            
        }else{
            IsReferralHeader =false;
        }

 }
 
  public pagereference prev(){
        
        if(theSelectedTab=='contTab')
           theSelectedTab    = 'accTab';
        else
        if(theSelectedTab=='marketOverviewTab')
           theSelectedTab    = 'contTab';
        else   
        if(theSelectedTab=='caSolutionsTab')
           theSelectedTab    = 'marketOverviewTab';
        else   
        if(theSelectedTab=='summaryTab')
           theSelectedTab    = 'caSolutionsTab';
        else   
        if(theSelectedTab=='contTab')
           theSelectedTab    = 'accTab';
        else            
     theSelectedTab    = 'summaryTab';
     
    
    return null;
 }

 public pagereference next(){

        
   
   
        if(theSelectedTab=='accTab')
        {
            
            /* validateDomain domain = new validateDomain();              
        system.debug('partnerReg.Company_Email_Domain_s__c -->' + partnerReg);
            system.debug('partnerReg.Company_Email_Domain_s__c -->' + partnerReg.Company_Email_Domain_s__c);
        if(partnerReg.Company_Email_Domain_s__c !=null)
           if(domain.validateDomains(partnerReg.Company_Email_Domain_s__c))
           {
               Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please enter valid company email domains, separated by a semicolon. Generic email domains cannot be entered. '));                
           }
           else*/
           theSelectedTab    = 'contTab';
        }
        else
        if(theSelectedTab=='contTab'){        
         theSelectedTab    = 'marketOverviewTab';                    
        }   
        else   
            if(theSelectedTab=='marketOverviewTab'){
                 theSelectedTab    = 'caSolutionsTab';
                if(partnerReg.Company_business_model__c != System.Label.POB_partner_referral && selectedProducts.size() > 0){
                    partnerReg.CA_Solutions_and_Products__c = '';   
                }
                
            }
          
        else   
            if(theSelectedTab=='caSolutionsTab'){
                
                if(partnerReg.Company_business_model__c == System.Label.POB_partner_referral && selectedProducts.size() > 0){
                    partnerReg.CA_Solutions_and_Products__c = selectedProducts[0].getValue();
                    theSelectedTab    = 'summaryTab';
                    
                }else{
                    if(partnerReg.Company_business_model__c == System.Label.POB_partner_referral && selectedProducts.size() < 1){
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'CA Solutions and Products: You must enter a value'));   
                    }
                    else{
                            theSelectedTab    = 'summaryTab';   
                    }
                    
                }
            }
           
        else   
           theSelectedTab    = 'completeTab';
  

  
     return null;
 }
 
 public PageReference saveForm() {
    
    
    //validations
    System.debug('_________________partnerReg-->'+partnerReg);
    if( partnerReg.First_Name__c==null || partnerReg.Last_Name__c==null || partnerReg.Email_Address__c==null || partnerReg.Job_Title__c==null || partnerReg.Country__c==null
        ||partnerReg.Address_1__c==null || partnerReg.City__c==null || partnerReg.State_Province__c==null || partnerReg.Postal_Code__c==null || partnerReg.Phone__c==null || partnerReg.Functional_Role__c==null)
        {
         Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,System.Label.POB_contDtlsErrMsg));
         return null;       
        }
        
     if(partnerReg.Company_business_model__c == null ){
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,System.Label.POB_marktOvrwErrMsg));
         return null;  
     }      
     
     if(partnerReg.CA_Solutions_and_Products__c ==null){
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,System.Label.POB_solnsErrMsg));
        return null;
     }  
     
     if(!partnerReg.Terms_and_Conditions__c){
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,System.Label.POB_termsCondErrMsg));
        return null;
     }
     
      if(partnerReg.Email_Address__c!=null){
        
       User[] usr = validateContEmail();
       if(usr!=null && usr.size()>0){            
           //renderLinks=False;
           displayDupUsrMsg=True;
           //displayPrivacyMsg=False;
           return null;
         }     
      }
     
               
      
   Schema.DescribeSObjectResult d = Schema.SObjectType.TAQ_Account__c; 
   Map<string,Schema.RecordTypeInfo> AccRtMap = d.getRecordTypeInfosByName();
   Id accrectypeid= AccRtMap.get('Partner Account').getRecordTypeId();
   
   System.debug('**********'+accrectypeid);
   taqAcc.RecordTypeId = accrectypeid;        
   taqAcc.Approval_Process_Status__c = 'Send For Approval';
   taqAcc.Account_Type1__c = 'Partner Account';
    if(partnerReg.Company_business_model__c == System.Label.POB_partner_referral){
                taqAcc.Referral_Partner__c = True;
                taqAcc.Velocity_Seller__c = false;
               taqAcc.Velocity_Seller_Type__c = '';
               taqAcc.Velocity_Seller_Program_Level__c = '';
              
    }
    else{
    
            /* taqAcc.Referral_Partner__c = false;
               taqAcc.Velocity_Seller__c = True;
               taqAcc.Velocity_Seller_Type__c = 'Reseller';
               taqAcc.Velocity_Seller_Program_Level__c = 'Member';
             */
                 
               taqAcc.Referral_Partner__c = false;
               taqAcc.Solution_Provider__c = true;
               taqAcc.Solution_Provider_Type__c = 'Reseller';
               taqAcc.Solution_Provider_Program_Level__c = 'Member';
            
    }

   taqAcc.Partner_On_boarding__c =true;
   taqAcc.Company_Email_Domain_s__c=partnerReg.Company_Email_Domain_s__c;// YEDRA01 Adding email domains validation process AR:2404
   taqAcc.Process_Step__c='Account Add';
   taqAcc.Company_business_model__c = partnerReg.Company_business_model__c;
   
   System.debug('________________________TAQ Account'+taqAcc);
     
   Database.SaveResult taqResults = Database.insert(taqAcc,False);
   System.debug('________________________TAQ Account'+taqAcc); 
   
   if (taqResults.isSuccess()){
           
    partnerReg.TAQ_Account__c = taqResults.getId();  
    partnerReg.Organization_Country__c = taqAcc.Country_Picklist__c; // GODVA01 - Changed from taqAcc.Country__c to taqAcc.Country_Picklist__c
    partnerReg.Name = 'PR' + Crypto.getRandomInteger().format().replace(',','');
       if(partnerReg.Company_business_model__c == System.Label.POB_partner_referral){
           partnerReg.Please_Select_Your_Preferred_Distributor__c = '';
       }
    Database.SaveResult results = Database.insert(partnerReg,true);
    if (results.isSuccess()){ 
        Id= partnerReg.Name;
        displayPrivacyMsg=False;
        displayCompleteMsg=true;
        renderLinks=False;
        displayDupUsrMsg=False;
    }            
   }
   else{
     Database.Error err = taqResults.getErrors()[0];  
     
     Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,err.getmessage()));
     System.debug('**Error In Inserting Partner Registration Record**' + err);
   }    
   
   return null;
 }
 

  public PageReference createAcc() {
  renderAccntDtls=False;

   return null;
  }
  
 
  public PageReference createUsr() {
     return new PageReference(System.Label.Common_Reg_URL);
                        
  }
// (Mari,Partner Profile R1)
  
 public PageReference copyAccntDtls() {
 
  partnerReg.Country__c=taqAcc.Country_Picklist__c; // GODVA01 - Changed from taqAcc.Country__c to taqAcc.Country_Picklist__c
  partnerReg.State_Province__c=taqAcc.Physical_State_Province__c;
  partnerReg.Address_1__c=taqAcc.Physical_Street__c;
  partnerReg.City__c=taqAcc.Physical_City__c;
  partnerReg.Postal_Code__c=taqAcc.Physical_Zip_Postal_Code__c;
  return null;
 } 
 
 public PageReference tabChange(){
    
        
        System.debug('****************************************'+theSelectedTab);
 return null;   
        
 }
 
 //Wrote separate methods for edit as there is a salesforce defect in accessing parameters using command button.
 
  public PageReference editAccDtls(){
             
   theSelectedTab='accTab';             
   return null;          
 }
 
   public PageReference editContDtls(){
    
    theSelectedTab='contTab';       
    return null;       
 }
 
  public PageReference editMktDtls(){
   
   theSelectedTab='marketOverviewTab';      
   return null;          
 }
 
  public PageReference editsolnDtls(){
   
   theSelectedTab='caSolutionsTab';     
   return null;        
 }
  
   public User[] validateContEmail(){
             
     User[] usr = [select id from user where email =: partnerReg.Email_Address__c and IsPortalEnabled=true and IsActive=True and UserType='PowerPartner' and IsActive=True and IsPortalEnabled=true];                      
     return usr;
   }
   
   // (Mari,ISTP - Partner Profile)
   public pageReference validateAccountSearch()
   {
   
   //labelnumber = Apexpages.currentPage().getParameters().get('select');
   System.debug('resAccount ___ '+ resAccount);
   System.debug('Validate Account Search'+ labelNumber);
    
    return null;
   }
   
    // (Mari,Partner profile R1)
 public PageReference fetchAccDtls() {
    
        if(taqAcc != null && taqAcc.Name == null) {
        ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'Please Enter the Company name')); return null; }
    
        System.debug('Account __ '+taqAcc);
        System.debug('Account __ '+taqAcc.Name);
         System.debug('Label Number fetch'+labelNumber);
        showFullFirstPage =true;

        PartnerProfileSearch pps = new PartnerProfileSearch();
        pps.req.name = taqAcc.Name;
        pps.req.country= taqAcc.Country_Picklist__c;
   
        pps.callEAIPartnerPofileService();
   
        if(pps.res.size() >0)
        {
             res = pps.res;
             pps.populateAddress(res);
             System.debug('accLst __ '+res);
             searchResultsMap = createSearchResultSet(res);
             res =searchResultsMap.get(resultNavVar);
             System.debug('accLst __ '+res);
             renderAccntDtls =true;
        }
        else
        renderAccntDtls =False;

        System.debug('accLst __ '+res);
        System.debug('searchResultsMap __ '+searchResultsMap);
        
        /*
        if(res != null && res.size()>0)
        {
        renderAccntDtls =true;
        }
        
        else
        renderAccntDtls =False;
        */
        //renderAccntDtls =true;
        //if(pps.requestStatus != null) ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,pps.requestStatus));
        //if(pps.requestErrorDetail != null) ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,pps.requestErrorDetail));
      
   return null;
 }
 
 
   public PageReference redirectOnboardingorCommon()
  {
        PageReference p;
        System.debug('Label Number redirect '+labelNumber);
        System.debug('res_ '+res);
        if(labelNumber != null)
        for(PartnerProfileSearch.PartnerProfileAccounts ppa : res) if(ppa.labelNumber == labelNumber)resAccount =ppa;
        
        
            System.debug('resAccount_ '+resAccount);
            if(labelNumber == -1)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select one of the accounts'));
            }
            else if(labelNumber == -2)
            {
                renderAccntDtls=False;
                showFullFirstPage = True;
            }
            
            if(resAccount!= null)
            if(( (!resAccount.ExistingPartner)) )
            {
                System.debug('Label Number_2 '+labelNumber);
                taqAcc.Name = resAccount.Name;
                //taqAcc.Country_Picklist__c =  resAccount.country;
                taqAcc.Physical_Street__c = resAccount.street;
                taqAcc.Physical_City__c = resAccount.city;
                taqAcc.Physical_Zip_Postal_Code__c = resAccount.postalcode;
                taqAcc.Physical_State_Province__c = resAccount.state;
                taqAcc.Website__c = resAccount.website; 
                renderAccntDtls=False;
                showFullFirstPage = True;
            }
            else
            {
                 String redirectTo = System.Label.Common_Reg_URL;
                 redirectTo =redirectTo +resAccount.accountid;
                 p = new PageReference(redirectTo);
                
            }
        
        return p;
  
  }
  
  
   public Map<Integer,List<PartnerProfileSearch.PartnerProfileAccounts>> createSearchResultSet(List<PartnerProfileSearch.PartnerProfileAccounts> r)
  
   {
        Map<Integer,List<PartnerProfileSearch.PartnerProfileAccounts>> m = new Map<Integer,List<PartnerProfileSearch.PartnerProfileAccounts>>();
        Integer i =1, j=1;
        List<PartnerProfileSearch.PartnerProfileAccounts> temp;
        if(r!= null)
        {
            Integer size = r.size();
            for (PartnerProfileSearch.PartnerProfileAccounts a: r)
            {
                if(Math.mod(i, 20)==1)
                {
                    temp = new List<PartnerProfileSearch.PartnerProfileAccounts>();
                    temp.add(a);
                }
                else
                {
                    temp.add(a);
                }
                i++;
                if(Math.mod(i, 20)==0 || i-1 ==  size){
                m.put(j,temp);
                j++; }
            }
        }
        System.debug('Inside createSearchResultSet '+'Input : '+ r +' output : '+m);
        return m;
    
   }
   
   public PageReference firstResultPage()
   {
        resultNavVar =1;
        res = searchResultsMap.get(resultNavVar);
        System.debug('First res'+res);
        return null;
   
   }
    public PageReference changeShippingSection()
   {
        System.debug('Business model' +partnerReg.Company_business_model__c);
        return null;
   
   }
   public PageReference lastResultPage()
   {
        if(searchResultsMap!= null)
        {
        resultNavVar = searchResultsMap.keySet().size();
        res = searchResultsMap.get(resultNavVar);
        System.debug('Last res'+res);
        }
   return null;
   }
   public PageReference prevResultPage()
   {
        if(resultNavVar >1)
        {
        resultNavVar--;
        res = searchResultsMap.get(resultNavVar);
        System.debug('Prev res'+res);
        }
   return null;
   }
   public PageReference nextResultPage()
   {
        if(resultNavVar <searchResultsMap.keySet().size())
        {
        resultNavVar++;
        res = searchResultsMap.get(resultNavVar);
        System.debug('Next res'+res);
        }
        return null;
   }
   
   public Boolean getNext()
   {
     System.debug(' In Next '+resultNavVar);
        if(resultNavVar <searchResultsMap.keySet().size())
        return true;
        else return false;
   }
   public Boolean getPrev()
   {
   System.debug(' In Prev '+resultNavVar);
        if(resultNavVar >1)
        return true;
        else return false;
   }
   public Boolean getisLast()
   {
    if(resultNavVar ==searchResultsMap.keySet().size())
    return true;
    else return false;
    
   }
   
   
   }