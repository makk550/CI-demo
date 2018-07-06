/**************
@Initial author : Saikumar Amand
*****************/

public class Quote_MDMSiteSearchController {
    
    @TestVisible
    private List<SBQQ__Quote__c> quote = new List<SBQQ__Quote__c>();	//to query opportunity name and number, to send to MDM during
    																	//lean customer creation.
    @TestVisible
    private List<User> userDetail = new List<User>();		//to query user detail to get the pmf key to send to MDM/ECC.
    @TestVisible
    private List<String> SoldToIds;							//list to store sold to ids, to send to MDM in payload.
	@TestVisible
    private String userPmfKey='';							//stores the logged in user's PMF key from the userDetail List.
    @TestVisible
    private List<Azure_MDM_Utility.SOLDIdData> MDMsitedata = new List<Azure_MDM_Utility.SOLDIdData>();

    public List<Azure_MDM_Utility.SOLDIdData> MDMsitedataPagenation{get;set;}		//to display Site Search Details, with pagination.
    public String SelectedId{get;set;}
    public String SearchType{get;set;}						//stores the search type - Sold To/Bill To and so on
    public String SoldToID{get;set;}						//stores the SOLDTO id
    public String EndUserID{get;set;}						//stores the EndUser Id
    public String accountId{get;set;}						//account ID of the account tied to the quote.
    public String OppCountryCode{get;set;}					//Opp country code.
    public Boolean isSoldTo{get;set;}
    public String SalesOrg{get;set;}						//stores the sales org value.
    public String SelectedSoldTo; //used for Bill To,Ship To
    public Boolean ShowCountrySelect{get;set;}
    public Boolean ShowDataTable{get;set;}				//boolean to render the site search result and Lean Customer Create Button.
    public Boolean siteSearchScreenEnabled{get;set;}    //boolean to render the site search input screen.
    public Boolean ShowCreateSite{get;set;}				//to show the lean customer create site screen.
    public Boolean ShowDupTable{get;set;}				//to show the duplicate match results after initial lean customer create
    public string LeanCustomerCountry{get;set;}			//country selected in drop down list when customer tries to create a customer.
    public LeanCustomerClass LeanCustomerObj{get;set;}
    public SiteSearchRequest SiteSearchRequestObj{get;set;}		//site search wrapper instance.
    public Lean_Customer_Country__mdt CountryMappedData{get;set;}	//to get list of countries from the custom metadata
    public List<SelectOption> StatePicklistValues{get;set;}			//to populate the states of a country to show during lean customer create.
    public List<Azure_UtilityClass.DuplicateMatchedRecords> AzureDuplicateRecords{get;set;}	//to get the response of duplicate sites when lean
    																						//customer create request is sent.
    																						
    public Azure_UtilityClass.Creation_AzureResponse returnAzureResponse{set;get;}			//response receieved when a site is force created.
    public boolean isStatePicklist{get;set;}		//boolean to render state picklist field during lean customer create.
    public boolean isLocalRequired{get;set;}
    public boolean isTaxsectionRequired{get;set;}
    public boolean isStateRequiredLean{get;set;}	//boolean to indicate if state is required during lean customer create
    public boolean isPostalRequiredLean{get;set;}	//boolean to indicate if postal code is required during lean customer create
    public String SiteId{set;get;}
    public Integer postalCodeLength;				//postal code length allowed
    public string quoteId;
    
    public boolean isPartnerQuote{get;set;}			//to check if it's a partner quote or not.
    
    //pagination implementation - BAJPI01
    public Boolean PrevCommandLink{get;set;}	//prev button render boolean
    public Boolean NextCommandLink{get;set;}	//next button render boolean
    public Integer pages{get;set;}				//total pages
    public Integer currentPage{get;set;}		//current page
    private Integer blockSize = Integer.valueOf(Label.Azure_Pagination_Size);				//max record per page
    private Integer totalRecs = 0;				//total records for site search
    //pagination implementation - BAJPI01
    
    
    public Quote_MDMSiteSearchController(){
        
        SoldToID= ApexPages.currentPage().getParameters().get('soldId');
        SearchType= ApexPages.currentPage().getParameters().get('searchtype');
        accountId= ApexPages.currentPage().getParameters().get('accountId');
        OppCountryCode=ApexPages.currentPage().getParameters().get('OppCountryCode');
        SalesOrg=ApexPages.currentPage().getParameters().get('salesOrg');
        SelectedSoldTo=ApexPages.currentPage().getParameters().get('selectedcountry');
        quoteId = ApexPages.currentPage().getParameters().get('quoteId');
        EndUserID = ApexPages.currentPage().getParameters().get('endUserId');
        
        //queries user detail and assigns pmf key to the string variable.
        userDetail = [select id,PMFKey__c from user where id=:UserInfo.getUserId()];
		if(userDetail!=null && userDetail.size()==1)
            userPmfKey = userDetail[0].PMFKey__c;
        
        //initialize the variables below.
        
        returnAzureResponse=new Azure_UtilityClass.Creation_AzureResponse();
        PrevCommandLink=false;
        NextCommandLink=false;
        
        LeanCustomerCountry='';
        LeanCustomerObj=new LeanCustomerClass();
        
        pages = 0;
        currentpage=1;
        
        
        
        StatePicklistValues = new List<SelectOption>();
        isStateRequiredLean=false;
        isPostalRequiredLean=false;
        
        //to query opportunity name and number, to send to MDM during
    	//lean customer creation.
        if(String.isNotBlank(quoteId))
            quote = [select Name,Opportunity_Number__c,Transaction_Type__c
                     from SBQQ__Quote__c where Id=:quoteId];
        
        if(quote[0].Transaction_Type__c=='1 Tier'){
            isPartnerQuote = true;		//only rendered if Transaction Type is 1 Tier.
        }
        else{
            isPartnerQuote = false;
        }
        
        //soldtoids list to be populated only for billto or shipto site search.
        SoldToIds=new List<String>();
        if((SearchType=='BILLTO' || SearchType=='SHIPTO') && String.isNotBlank(SoldToID)){
            Azure_MDM_Utility azureUtilInstc = new Azure_MDM_Utility();
            SoldToIds.add(azureUtilInstc.getFullsite(SoldToId));
            if(SearchType=='SHIPTO' && isPartnerQuote==true){
                if(String.isNotBlank(EndUserID) && String.isNotBlank(SoldToID) && EndUserId!=SoldToID){
                    SoldToIds.add(azureUtilInstc.getFullsite(EndUserId));
                }
            }
        }
        SiteSearchRequestObj = new SiteSearchRequest();
        
        //site search screen is for soldto/reseller/enduserid, for Indirect Quotes Only.
        //For Direct Quotes and Indirect - bill to/ship to, directly show the results.
        if((SearchType=='SOLDTO' || SearchType=='RESELLER' || SearchType=='ENDUSERID') && isPartnerQuote==true){
            siteSearchScreenEnabled=true;
            ShowDataTable =false;
            ShowCountrySelect=false;
            ShowCreateSite=false;
            
        }
        else{
            siteSearch();
        }        
        
        
    }
	
    
    //this method initializes the response variable, and calls the appropriate
    //method - getSiteDetails() - for SoldTO/Reseller/ENDUser or getBusinessPartnerData() for BillTo/ShipTo.
    //Reseller and End user Ids are SOLDTO search.
    public void siteSearch(){
        
        Azure_MDM_Utility.AzureResponse AzureRes = new Azure_MDM_Utility.AzureResponse();   
        Boolean errorExists = false;
        String accountGroup;
        String siteName = '';
		String siteCountry = '';
        String tempAccountId = '';
        Decimal tempTotalPages = 0;
        SiteSearchRequestObj.Name1 = SiteSearchRequestObj.Name1.normalizeSpace(); //this is to remove the leading/trailing whitespace characters
        siteName = SiteSearchRequestObj.Name1;
        siteCountry = SiteSearchRequestObj.Country;
        
        if(isPartnerQuote==false)
            tempAccountId = accountId;
        else
            tempAccountId = '';		//for partner quotes, account id to be sent has to be blank.
        
        system.debug('--is partner quote?----'+isPartnerQuote);
        system.debug('--search Type----'+SearchType);
        system.debug('---site name----'+siteName);
        system.debug('---site country----'+siteCountry);
        
        if(isPartnerQuote==true && (SearchType == 'SOLDTO'||SearchType == 'RESELLER'||SearchType == 'ENDUSERID')){
            if(String.isBlank(siteName)){
                system.debug('---name blank----');
                errorExists = true;
            }
            else{
                system.debug('--length---'+siteName.length());
                if(siteName.length()<2){
                    system.debug('---name less than 2 characters----');
                    errorExists = true;
                } 
            }
        }
        
        if(errorExists==true){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter atleast 2 characters for Site Name.'));           
        }
        else{
            if(SearchType == 'SOLDTO'||SearchType == 'RESELLER'||SearchType == 'ENDUSERID'){
                AzureRes = getSiteDetails(SearchType,tempAccountId,SoldToIds,siteName,siteCountry,userPmfKey,OppCountryCode);
            }
            else{
                if(SelectedSoldTo == 'GB'){
                    
                }else{
                    SalesOrg='';
                }
                AzureRes = getBusinessPartnersData(SoldToIds,SearchType,siteName,siteCountry,OppCountryCode,SalesOrg,userPmfKey);
            }
            
            //if a response is returned and is successful, it gets the site list from the response (AzureRes.SoldToList)
            //and sends it to the pagination method, otherwise shows the appropriate error message.
            if(AzureRes!=null&&AzureRes.Status == 'OK'){
                if(AzureRes.SoldToList.size() >0){
                    MDMsitedata =AzureRes.SoldToList;
                    totalRecs=MDMsitedata.size();
                    
                    if(blockSize!=0)
	                    tempTotalPages = Decimal.valueOf(totalRecs)/Decimal.valueOf(blockSize);
                    else
                        tempTotalPages = 1;
                    
                    system.debug('--total--'+tempTotalPages);
                    pages = (Integer)Math.ceil(tempTotalPages);
                    system.debug('---pages---'+pages);
                    if(pages==0)
                        currentPage = 0;
                    searchResultPagination(MDMsitedata);
                    
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,AzureRes.Message));
                }
            }
            else if(AzureRes!=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AzureRes.Message));
            }
            
            ShowDataTable =true;
            siteSearchScreenEnabled=false;
            ShowDupTable = false;
            ShowCountrySelect=false;
            ShowCreateSite=false;
        }
        
        
        
    }
    
    //method to implement pagination for search site results.
    public void searchResultPagination(List<Azure_MDM_Utility.SOLDIdData> MDMsitedata){
        MDMsitedataPagenation=new List<Azure_MDM_Utility.SOLDIdData>();
        
        system.debug('---size----'+MDMsitedata.size());
        
        if(MDMsitedata.size()>0){
            
            system.debug('--current page--'+currentPage);
            system.debug('---block size----'+blockSize);
            
            Integer startNumber = (currentPage-1)*blockSize;	//start number of record, for every page
            Integer endNumber = currentPage*blockSize;			//end number of record, for every page.
            
            system.debug('--start number--'+startNumber);
            system.debug('--end number--'+endNumber);
            system.debug('----total recs----'+totalRecs);
            
            if(endNumber>totalRecs)
                endNumber = totalRecs;							//if last page, setting end number = total #of records.
            
            for(integer i=startNumber;i < endNumber;i++){
                MDMsitedataPagenation.add(MDMsitedata[i]);		//forming list to be shown on the screen.
            }
        }
        
        //enabling and disabling previous and next buttons, as per the case.
        if(currentPage == pages)
            NextCommandLink=false;
        else 
             NextCommandLink=true;
        
        if(currentPage>1)
            PrevCommandLink=true;
        else
            PrevCommandLink=false;
        
    }
    
    //method called when previous button is clicked on page, for site search results. Returns records of previous page.
    public void previous(){
        currentPage--;
        searchResultPagination(MDMsitedata);
    }
    
    //method called when next button is clicked on page, for site search results. Returns records of next page.
    public void next(){
        currentPage++;
        searchResultPagination(MDMsitedata);
    }
    
    
    public PageReference loadBillShipdetails(){
        System.debug('SelectedId'+SelectedId);
        return null;
        
    }
   
   //method called when user selects the country during site creation. It calls the InitLeanCustomerFields() method to populate
   //fields like opp number, date/time, pmf key, etc on the request. It queries data from lean customer country and state custom metadata
   //and populates a few fields on the request. and forms the state picklist, if state is required. and enforces the min/max lenght for
   //postal code. Also checks if tax fields are required or not. Finally enables the site create screen where user enters the site name,
   //address, tax information and so on.
    public PageReference createcustomer(){
        if(String.isBlank(LeanCustomerCountry) || LeanCustomerCountry =='--Select--'){
            
        }else{
            initLeanCustomerFields();
            CountryMappedData = [SELECT DeveloperName,Id,InternationalCode__c,isLocalRequired__c,isPostalCodeRequired__c,isStateRequired__c,Label,Language,MasterLabel,NamespacePrefix,QualifiedApiName,TaxNumber1Label__c,TaxNumber1__c,TaxNumber2Label__c,TaxNumber2__c,TaxNumber3Label__c,TaxNumber3__c,TaxNumber4Label__c,TaxNumber4__c,
                                 VATRegistrationNumberLabel__c,VATRegistrationNumber__c,PostalCodeMinLength__c,PostalCodeMaxLength__c,GSTRegistrationNumber__c,GSTRegistrationNumberLabel__c,
                                 (select id,RegionCode__c,Label,QualifiedApiName from Lean_Customer_States__r order by Label) FROM Lean_Customer_Country__mdt where QualifiedApiName =:LeanCustomerCountry];
            if(CountryMappedData != null){
                isLocalRequired =CountryMappedData.isLocalRequired__c;
                LeanCustomerObj.CountryLabel = CountryMappedData.Label;
                LeanCustomerObj.CountryCode  = CountryMappedData.QualifiedApiName;
                LeanCustomerObj.AccountGroup = getAccountGroup(SearchType);
                LeanCustomerObj.CAAccountID = accountId;
                if(CountryMappedData.TaxNumber1__c || CountryMappedData.TaxNumber2__c || CountryMappedData.TaxNumber3__c || CountryMappedData.TaxNumber4__c || CountryMappedData.VATRegistrationNumber__c||CountryMappedData.GSTRegistrationNumber__c){
                    isTaxsectionRequired =true;
                }
                isStateRequiredLean=CountryMappedData.isStateRequired__c;
                isPostalRequiredLean=CountryMappedData.isPostalCodeRequired__c;
                if(CountryMappedData.Lean_Customer_States__r.size() >0){
                    isStatePicklist =true;
                    StatePicklistValues = new List<SelectOption>();
                    StatePicklistValues.add(new SelectOption('--Select--','--Select--'));
                    for(Lean_Customer_State__mdt states:CountryMappedData.Lean_Customer_States__r){
                        StatePicklistValues.add(new SelectOption(states.RegionCode__c,states.Label));
                    }
                }else{
                    isStatePicklist =false;
                    
                }
                siteSearchScreenEnabled=false;
                ShowDataTable=false;
                ShowCountrySelect=false;
                ShowCreateSite=true;
                if(CountryMappedData.PostalCodeMaxLength__c!=null && CountryMappedData.PostalCodeMaxLength__c!=-1)
                    postalCodeLength = Integer.valueOf(CountryMappedData.PostalCodeMaxLength__c);
            }
            
        }
        
        return null;
    }
    
    //method to get the account group, as per the search type. It is used to send it in the request during site search or
    //site create.
    public static String getAccountGroup(String SearchType){
        if(SearchType == 'SOLDTO'||SearchType == 'RESELLER'||SearchType == 'ENDUSERID'){
            return 'Z001';
        }else{
            if(SearchType == 'SHIPTO'){
                return 'Z002';
            }else{
                if(SearchType == 'BILLTO'){
                    return 'Z004';
                }
            }
        }
        return '';
    }
    
    //search strategy, that is used to send it in the request for site search.
    public static String getSearchStrategy(String searchType){
        string tempSearchStrategy = '';
        if(SearchType=='SOLDTO'||SearchType == 'RESELLER'||SearchType == 'ENDUSERID'){
            tempSearchStrategy = 'SoldTo';
        }
        else{
            tempSearchStrategy = 'BP';
        }
        return tempSearchStrategy;
    }
    
    //enables the country select section when customer wants to create a site.
    public PageReference SelectCountry(){
        ShowDataTable=false;
        ShowCountrySelect=true;
        ShowCreateSite=false;
        return null;
    }
    
    //returns the countries where CA does business. Fetches it from the Lean Customer Country Custom Metadata.
    public List<SelectOption> getcountryPicklistValues()  {
        Lean_Customer_Country__mdt[] CountryList = [SELECT Label,MasterLabel,QualifiedApiName FROM Lean_Customer_Country__mdt order by Label];
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('--Select--','--Select--'));
        for(Lean_Customer_Country__mdt Country:CountryList){
            countryOptions.add(new SelectOption(Country.QualifiedApiName,Country.Label));
        }
        
        
        return countryOptions;
    }
    
    //method called to get the response from MDM, for site search, for SOLD TO, RESELLER OR ENDUSERID.
    //It creates the site search request body, and makes a call to MDM to get the site details. Parses
    //the data through a method, in the Azure_MDM_Utility Class.
    public static Azure_MDM_Utility.AzureResponse getSiteDetails(String tempSearchType, String accountId, List<String> SoldToIds, String siteName, String siteCountry, String userPmfKey, String TempOppCountryCode){
        
        Azure_MDM_Utility.AzureResponse AzureOb=new  Azure_MDM_Utility.AzureResponse();
        String endpoint = System.Label.Azure_EndPoint_SiteSearch;
        String accountGroup = getAccountGroup(tempSearchType);
        String searchStrategy = getSearchStrategy(tempSearchType);
        List<String> accGroupList = new List<String>();
        accGroupList.add(accountGroup);
        
        SiteSearchRequest requestBody=new SiteSearchRequest(accountId,accGroupList,SoldToIds,siteName,siteCountry);
        SiteRequest requestOBJ =new SiteRequest(requestBody,searchStrategy,userPmfKey);
        String jsonRequest=Json.serialize(requestOBJ);
        
        Http http = new Http();
        HttpRequest req = Azure_MDM_Utility.SiteSearchHttpRequest(endpoint,jsonRequest);
        System.debug('----------jsonRequest-------'+jsonRequest);
        

        try{
            System.debug('-------------Try1-------------------');
            HttpResponse response1 = http.send(req);
            System.debug('=======response1======='+response1.getbody());
            if(response1.getStatusCode() == 200){
                System.debug('Body-------'+response1.getbody());
                AzureOb=Azure_MDM_Utility.JSONparserMDMdata(response1.getbody(),TempOppCountryCode);
            }else{
                AzureOb = new Azure_MDM_Utility.AzureResponse();
                AzureOb.Status = 'ERROR';
               // AzureOb.Message ='Sorry,System was unable to process the request.';
                
            }
        }catch(Exception e){
            System.debug('-------------Try2-------------------');
            HttpResponse response2 = http.send(req);
            if(response2.getStatusCode() == 200){
                System.debug('Body-------'+response2.getbody());
                AzureOb=Azure_MDM_Utility.JSONparserMDMdata(response2.getbody(),TempOppCountryCode);
            }else{
                AzureOb = new Azure_MDM_Utility.AzureResponse();
                AzureOb.Status = 'ERROR';
                AzureOb.Message =e.getMessage();
                System.debug('Exception'+AzureOb);
            }
        }
        
        return  AzureOb;
        
        
        
    }
    
    //method called to get the response from MDM, for site search, for BILL TO & SHIP TO.
    //It creates the site search request body, and makes a call to MDM to get the site details. Parses
    //the data through a method, in the Azure_MDM_Utility Class. For BILL TO AND SHIP TO, Opp Country Code and Sales Org
    //is required, when parsing the sites returned.
    public static Azure_MDM_Utility.AzureResponse getBusinessPartnersData(List<String> SoldID,String BPType,String siteName, String siteCountry, String TempOppCountryCode,String Salesorg, String userPmfKey){
        
        Azure_MDM_Utility.AzureResponse AzureOb = new  Azure_MDM_Utility.AzureResponse();
        String accountGroup = getAccountGroup(BPType);
        String searchStrategy = getSearchStrategy(BPType);
		String accId = '';
        List<String> accGroupList = new List<String>();
        accGroupList.add(accountGroup);
        
        String endpoint = System.Label.Azure_EndPoint_SiteSearch;
        
        System.debug('--------'+siteName+'---------'+siteCountry);
        
        SiteSearchRequest requestBody=new SiteSearchRequest(accId,accGroupList,SoldID,siteName,siteCountry);
        SiteRequest requestOBJ =new SiteRequest(requestBody,searchStrategy,userPmfKey);
        String jsonRequest=Json.serialize(requestOBJ);
        
        Http http = new Http();
        HttpRequest req = Azure_MDM_Utility.SiteSearchHttpRequest(endpoint,jsonRequest);
        System.debug('----------jsonRequest-------'+jsonRequest);
        
        HttpResponse response = http.send(req);
        System.debug('=======response======='+response.getbody());
        
        
        try{
            HttpResponse response1 = http.send(req);
            if(response.getStatusCode() == 200){
                System.debug('Body-------'+response.getbody());
                AzureOb=Azure_MDM_Utility.JSONparserSoldTodata(response.getbody(),'BusinessPartners',BPType,TempOppCountryCode,Salesorg);
            }else{
                AzureOb = new Azure_MDM_Utility.AzureResponse();
                AzureOb.Status = 'ERROR';
                AzureOb.Message ='Sorry,System was unable to process the request.';
            }
        }catch(Exception e){
            AzureOb = new Azure_MDM_Utility.AzureResponse();
            AzureOb.Status = 'ERROR';
            AzureOb.Message =e.getMessage();
        }
        return AzureOb;
    }
    
    //when user decides to not go ahead with site creation by cancelling it when selecting a country. Displays
    //the list of searched site, again.
    public pagereference cancelCountry(){
        siteSearchScreenEnabled=false;
        ShowDataTable=true;
        ShowCountrySelect=false;
        ShowCreateSite=false;
        LeanCustomerCountry ='--Select--';
        return null;
    }
    
    //initializes the Lean Customer Create Request Body with the fields, when user wants to create a site.
    public void initLeanCustomerFields(){
        LeanCustomerObj =new LeanCustomerClass();
        if(!String.isBlank(SoldToID)){
            Azure_MDM_Utility AzureUtil =new Azure_MDM_Utility();
            LeanCustomerObj.SoldToId=AzureUtil.getFullsite(SoldToID);
        }
        DateTime localdate = System.now();
        String myDate = localdate.format(String.valueOf(System.now()),'CST');  
        LeanCustomerObj.CreatedDate=myDate;
        LeanCustomerObj.RequestedUserName=UserInfo.getUserName();
        
        if(userDetail!=null && userDetail.size()==1)
            LeanCustomerObj.PMFKey = userDetail[0].PMFKey__c;
        
        if(quote!=null && quote.size()==1){
            LeanCustomerObj.TransactionReferenceNo = quote[0].Name;
            LeanCustomerObj.OpportunityNumber = quote[0].Opportunity_Number__c;
        } 
       
    }
    
    //calls the lean customer create function, this function does not create the customer, but first returns a list of 
    //duplicate sites, as per create request body.
    public Pagereference saveLeanCustomer(){
        
        PageReference pf;
        pf = createLeanCustomer();
        return null;
    }
    
    //calls the lean customer create function, this function creates the customer.
    //the isForceCreate flag is set to true, which force creates the customer.
    public Pagereference forceCreateLeanCustomer(){
        
        PageReference pf;
        LeanCustomerObj.isForceCreate='true';
        pf = createLeanCustomer();
        return null;
        
    }
    
    //create lean customer function. It makes a call to MDM/ECC to create the customer. If forcecreate flag is true,
    //it creates the customer. If the flag is false, it returns the list of duplicate sites as per the create request
    //body. Does the necessary data validation before sending the request. Once the response is returned, displays
    //the duplicate site, or creates and populates the site on the screen - if it is a force create, or displays the error
    //as the case maybe.
    public PageReference createLeanCustomer(){
        
        
        Boolean errorExists = false;
        Boolean otherErrors,missingFieldErrors;
        String ErrorMessage='';
        String PostalCodeErrorMessage='';
        String PhoneNumberErrorMessage = '';
        String phonnumberRegex='^(?=.*[0-9])[- +()0-9]+$';
        ErrorMessage  = combinedErrorMessage(LeanCustomerObj);
        otherErrors = false;

        if(String.isNotBlank(LeanCustomerObj.PhoneNumber) && !Pattern.matches(phonnumberRegex, LeanCustomerObj.PhoneNumber)){
            PhoneNumberErrorMessage+='Only numbers and +, -,  (,  ), and space are allowed for phone number. ';
            otherErrors = true;
        }
        
        if(String.isBlank(ErrorMessage) && otherErrors==false){
            errorExists = false;
        }
        else{
            if(String.isNotBlank(ErrorMessage))
                missingFieldErrors =true;
            errorExists = true; 
        }
        
        if(errorExists==false){
            returnAzureResponse =new Azure_UtilityClass.Creation_AzureResponse();
            
            System.debug('Name1---'+LeanCustomerObj.Name1);
            Azure_UtilityClass AzureObj=new Azure_UtilityClass();
            if(String.isNotBlank(LeanCustomerObj.RegionCode) && LeanCustomerObj.RegionCode=='--Select--'){
                LeanCustomerObj.RegionCode = '';
            }
            if(String.isNotBlank(LeanCustomerObj.RegionCode)){
                LeanCustomerObj.RegionName=LeanCustomerObj.RegionCode +','+LeanCustomerObj.CountryCode;
            }
            returnAzureResponse=AzureObj.LeanCustomerCallout(LeanCustomerObj,accountId,isPartnerQuote);
            System.debug('returnAzureResponse---------'+returnAzureResponse);
            if(returnAzureResponse!=null&&String.isNotBlank(returnAzureResponse.Create_Customer.SoldToId)&&String.isBlank(returnAzureResponse.Create_Customer.BillToId)&&String.isBlank(returnAzureResponse.Create_Customer.ShipToId)){
                SiteId=returnAzureResponse.Create_Customer.SoldToId;   
                
            }else  if(returnAzureResponse!=null&&String.isNotBlank(returnAzureResponse.Create_Customer.SoldToId)&&String.isNotBlank(returnAzureResponse.Create_Customer.BillToId)&&String.isBlank(returnAzureResponse.Create_Customer.ShipToId)){
                SiteId=returnAzureResponse.Create_Customer.BillToId;   
                
            }else  if(returnAzureResponse!=null&&String.isNotBlank(returnAzureResponse.Create_Customer.SoldToId)&&String.isBlank(returnAzureResponse.Create_Customer.BillToId)&&String.isNotBlank(returnAzureResponse.Create_Customer.ShipToId)){
                SiteId=returnAzureResponse.Create_Customer.ShipToId;   
                
            }
            if(returnAzureResponse != null){
                if(returnAzureResponse.status =='DUPS_FOUND'){
                    siteSearchScreenEnabled=false;
                    ShowDupTable = true;
                    ShowDataTable=false;
                    ShowCountrySelect=false;
                    ShowCreateSite=false;
                    AzureDuplicateRecords =returnAzureResponse.MATCHED_RECORDS;
                }else if(returnAzureResponse.status =='INPUT_ERROR'){
                    ShowDupTable = false;
                    ShowDataTable=false;
                    ShowCountrySelect=false;
                    ShowCreateSite=true;
                    siteSearchScreenEnabled=false;
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,returnAzureResponse.message+':'+returnAzureResponse.reason));
                }
                else if(returnAzureResponse.status =='OK'){
                    ShowDupTable = false;
                    ShowDataTable=false;
                    ShowCountrySelect=false;
                    ShowCreateSite=false;
                    siteSearchScreenEnabled=false;
                }
                else{
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,returnAzureResponse.message+':'+returnAzureResponse.reason));
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please try again after sometime.'));
            }
        }
        else{
            if(missingFieldErrors == true)
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter values for:'+ErrorMessage+' fields.'));
            if(String.isNotBlank(PostalCodeErrorMessage))
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,PostalCodeErrorMessage));
            if(String.isNotBlank(PhoneNumberErrorMessage))
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,PhoneNumberErrorMessage));
            return null;
        }
        
        return null;
    }
    
    //method to combine error messages for lean customer create.
    public string combinedErrorMessage(LeanCustomerClass tempLeanCustomerObj){
        String ErrorMessage='';
        if(String.isBlank(tempLeanCustomerObj.Name1)){
            ErrorMessage=concateErrorMessage(ErrorMessage,'Name1');
            
        }
        if(String.isBlank(tempLeanCustomerObj.Street1)){
            ErrorMessage=concateErrorMessage(ErrorMessage,'Street1');
            
        }
        if(isStateRequiredLean && ((isStatePicklist==false && String.isBlank(tempLeanCustomerObj.RegionName))||(isStatePicklist==true && (String.isBlank(tempLeanCustomerObj.RegionCode)||tempLeanCustomerObj.RegionCode=='--Select--')))){
            
            ErrorMessage=concateErrorMessage(ErrorMessage,'State');
        }
        if(String.isBlank(tempLeanCustomerObj.City)){
            ErrorMessage=concateErrorMessage(ErrorMessage,'City');
            
        }
        /*
        if(isPostalRequiredLean && String.isBlank(tempLeanCustomerObj.PostalCode)){
            ErrorMessage=concateErrorMessage(ErrorMessage,'Postal Code');
            
        }
        */
        return ErrorMessage;
    }
    
    public String concateErrorMessage(String ErrorMessage,String MType){
        if(String.isBlank(ErrorMessage)){
            ErrorMessage=MType;
        }else{
            ErrorMessage=ErrorMessage+','+MType;
        }
        return ErrorMessage;
    }
    
    //wrapper class to populate the lean customer create request. Naming convention depends on format decided by MDM team.
    //Do not change it, unless changed there.
    public class LeanCustomerClass{
        public String Name1{get;set;}
        public String Name2{get;set;}
        public String Name3{get;set;}
        public String Name4{get;set;}
        public String Name1InternationalLanguage{get;set;}
        public String Name2InternationalLanguage{get;set;}
        public String Name3InternationalLanguage{get;set;}
        public String Name4InternationalLanguage{get;set;}
        public String Street1{get;set;}
        public String Street2{get;set;}
        public String Street3{get;set;}
        public String Street4{get;set;}
        public String Street5{get;set;}
        public String Street1InternationalLanguage{get;set;}
        public String Street2InternationalLanguage{get;set;}
        public String Street3InternationalLanguage{get;set;}
        public String Street4InternationalLanguage{get;set;}
        public String Street5InternationalLanguage{get;set;}
        public String PostalCode{get;set;}
        public String City{get;set;}
        public String CityInternationalLanguage{get;set;}
        public String RegionCode{get;set;}
        public String RegionName{get;set;}
        public String CountryLabel{get;set;}
        public String CountryCode{get;set;}
        public String TaxNumber1{get;set;}
        public String TaxNumber2{get;set;}
        public String TaxNumber3{get;set;}
        public String TaxNumber4{get;set;}
        public String VATRegistrationNumber{get;set;}
        public String GSTRegistrationNumber{get;set;}
        public String RequestedUserName{get;set;}
        public string PMFKey{get;set;}
        public string TransactionReferenceNo{get;set;}
        public String OpportunityNumber{get;set;}
        public String CreatedDate{get;set;}
        public String CAAccountID{get;set;}
        public String PhoneNumber{get;set;}
        public String AccountGroup{get;set;}
        public String isForceCreate{get;set;}
        public String SoldToId{set;get;}
        public LeanCustomerClass(){
            this.Name1='';
            this.Name2='';
            this.Name3='';
            this.Name4='';
            this.Name1InternationalLanguage='';
            this.Name2InternationalLanguage='';
            this.Name3InternationalLanguage='';
            this.Name4InternationalLanguage='';
            this.Street1='';
            this.Street2='';
            this.Street3='';
            this.Street4='';
            this.Street5='';
            this.Street1InternationalLanguage='';
            this.Street2InternationalLanguage='';
            this.Street3InternationalLanguage='';
            this.Street4InternationalLanguage='';
            this.Street5InternationalLanguage='';
            this.PostalCode='';
            this.City='';
            this.CityInternationalLanguage='';
            this.RegionCode='';
            this.RegionName='';
            this.CountryLabel='';
            this.TaxNumber1 ='';
            this.TaxNumber2 ='';
            this.TaxNumber3 ='';
            this.TaxNumber4 ='';
            this.VATRegistrationNumber ='';
            this.GSTRegistrationNumber = '';
            this.RequestedUserName='';
            this.PMFKey='';
            this.TransactionReferenceNo='';
            this.OpportunityNumber='';
            this.CreatedDate='';
            this.isForceCreate='false';
            this.SoldToId='';
        }
    }
    
    //wrapper class to populate the search site request. Naming convention depends on format decided by MDM team.
    //Do not change it, unless changed there.
    public class SiteSearchRequest{
        
        public String CA_Account_ID{get;set;}
        public List<String> Account_Group_Code{get;set;}
        public List<String> Sold_To_ID{get;set;}
        public String Name1{get;set;}
        public String City{get;set;}
        public String Region{get;set;}
        public String Country{get;set;}
        public String Name1_Search_Startegy{get;set;}
        public String City_Search_Startegy{get;set;}
        public String Region_Search_Startegy{get;set;}
        public String Country_Search_Startegy{get;set;}
    
        public SiteSearchRequest(){
            this.CA_Account_ID = '';
            this.Account_Group_Code = new List<String>();
            this.Sold_To_ID=new List<String>();
            this.Name1 = '';
            this.Country='';
            this.Region='';
            this.City='';
            this.Name1_Search_Startegy='';
            this.City_Search_Startegy='';
            this.Region_Search_Startegy='';
            this.Country_Search_Startegy='';
        }
       
        
        public SiteSearchRequest(String accountId,List<String> accountGroupList,List<String> soldtoIds,String Name,String Country){
            this.CA_Account_ID = accountId;
            this.Account_Group_Code = accountGroupList;
            this.Sold_To_ID=soldtoIds;
            this.Name1 = Name;
            if(Country == '--Select--'||String.isBlank(Country)){
                this.Country = '';
                this.Country_Search_Startegy='';
            }              
            else{
                this.Country = Country;
                this.Country_Search_Startegy='Equals';
            }
            
            if(String.isBlank(Name)){
                this.Name1_Search_Startegy='';
            }
            else{
                this.Name1_Search_Startegy='startswith';
            }
            this.Region='';
            this.City='';
          //  this.Name1_Search_Startegy='';
            this.City_Search_Startegy='';
            this.Region_Search_Startegy='';
            
            
        }
        
        
    }
    
    //wrapper class to populate the search site request. Naming convention depends on format decided by MDM team. Do not change,
    //unless it changes there.
    public class SiteRequest{
        public SiteSearchRequest Site_Search_Request;
        public String Search_Startegy;
        public String Consumer_System_Name;
        public String RequesterPMFKey;
        public SiteRequest(SiteSearchRequest body,String searchStrategy,String pmfkey){
            this.Site_Search_Request =body;
            this.Search_Startegy=searchStrategy;
            this.Consumer_System_Name='SFCPQ';
            this.RequesterPMFKey=pmfkey;
        }
    }
    
    
}