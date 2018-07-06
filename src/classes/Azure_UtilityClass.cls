/******
This class is used for SFDC integration with Salesforce
@author		: 	SAIKUMAR AMAND
@project	:	Tensor H1.1

******/
public class Azure_UtilityClass {
    
    /***Wrapper Class to handle Azue Auth token Resposne-----START*****/
    public class AzureResponse {
        public String token_type;
        public String access_token;
    }
    /******************AzureResponse END*********************/
    /*****Azure Authrization Service----------START******/
    public static String Azure_Authrization(){
        HttpRequest req = new HttpRequest();
        String grant_type=EncodingUtil.urlEncode(System.Label.Azure_Grant_type, 'UTF-8');
        String client_id=EncodingUtil.urlEncode(System.Label.Azure_client_id, 'UTF-8');
        String client_secret=EncodingUtil.urlEncode(System.Label.Azure_client_secret, 'UTF-8');
        String resource=EncodingUtil.urlEncode(System.Label.Azure_resource, 'UTF-8');
        String extbodyURL='grant_type='+grant_type+'&client_id='+client_id+'&client_secret='+client_secret+'&resource='+resource;
        String Azure_Endpoint='https://login.microsoftonline.com/'+System.Label.Azure_tenant_id+'/oauth2/token';
        req.setEndpoint(Azure_Endpoint);
        req.setMethod('POST');
        req.setTimeout(100000);
        req.setbody(extbodyURL);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        Http http = new Http();
        System.debug(req);
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return deserialiseToken(res);

    }
    /***************Azure_Authrization END******************/
     private static String deserialiseToken(HTTPResponse res) {
        
        String responseBody = res.getBody();
        
        AzureResponse parsedResponse = (AzureResponse) System.JSON.deserialize(responseBody, AzureResponse.class);
         system.debug('---parsed token----'+parsedResponse);
        System.debug(parsedResponse.access_token);
        return parsedResponse.access_token;
    }
    public Creation_AzureResponse LeanCustomerCallout(Quote_MDMSiteSearchController.LeanCustomerClass LeanCusObj,String caAccId, Boolean isPartnerQuote){
        Creation_AzureResponse returnAzureResponse =new Creation_AzureResponse();
        try{
            String auth_token =Azure_Authrization();
            System.debug('========='+auth_token);
            if(auth_token!=null){
                String requestBody=copydatatoRequestBody(LeanCusObj);
                HttpRequest req = new HttpRequest();
                String Endpoint=System.Label.Azure_Endpoint;
                req.setEndpoint(Endpoint);
                req.setMethod('POST');
                req.setTimeout(100000);
                req.setBody(requestBody);
                req.setHeader('Authorization','Bearer '+auth_token);
                req.setHeader('Content-Type','application/json');
                Http http = new Http();
                HTTPResponse res = http.send(req);
                System.debug('respose=============='+res.getStatusCode());
                if(res.getStatusCode() == 200){
                    
                    System.debug('res.getBody()---'+res.getBody());
                    returnAzureResponse =parseAzureResponse(res.getBody(),caAccId,isPartnerQuote);
                 	System.debug('returnAzureResponse============='+returnAzureResponse);
                    return returnAzureResponse;
                }else{
                    
                }
            }
        }catch(Exception e){
            System.debug('Exception ---'+e);
        }
        System.debug('returnAzureResponse2==========='+returnAzureResponse);
        return null;
    }
    public String copydatatoRequestBody(Quote_MDMSiteSearchController.LeanCustomerClass LeanCusObj){
        CustomerNames reqNames=new CustomerNames();
        reqNames.Name1=LeanCusObj.Name1;
        reqNames.Name2=LeanCusObj.Name2;
        reqNames.Name3=LeanCusObj.Name3;
        reqNames.Name4=LeanCusObj.Name4;
        reqNames.Name1InternationalLanguage=LeanCusObj.Name1InternationalLanguage;
        reqNames.Name2InternationalLanguage=LeanCusObj.Name2InternationalLanguage;
        reqNames.Name3InternationalLanguage=LeanCusObj.Name3InternationalLanguage;
        reqNames.Name4InternationalLanguage=LeanCusObj.Name4InternationalLanguage;
        CustomerAddress reqAddress=new CustomerAddress();
        reqAddress.Street1=LeanCusObj.Street1;
        reqAddress.Street2=LeanCusObj.Street2;
        reqAddress.Street3=LeanCusObj.Street3;
        reqAddress.Street4=LeanCusObj.Street4;
        reqAddress.Street5=LeanCusObj.Street5;
        reqAddress.Street1InternationalLanguage=LeanCusObj.Street1InternationalLanguage;
        reqAddress.Street2InternationalLanguage=LeanCusObj.Street2InternationalLanguage;
        reqAddress.Street3InternationalLanguage=LeanCusObj.Street3InternationalLanguage;
        reqAddress.Street4InternationalLanguage=LeanCusObj.Street4InternationalLanguage;
        reqAddress.Street5InternationalLanguage=LeanCusObj.Street5InternationalLanguage;
        reqAddress.PostalCode=LeanCusObj.PostalCode;
        reqAddress.City=LeanCusObj.City;
        reqAddress.CityInternationalLanguage=LeanCusObj.CityInternationalLanguage;
        reqAddress.RegionCode=LeanCusObj.RegionCode;
        reqAddress.RegionName=LeanCusObj.RegionName;
        reqAddress.Country=LeanCusObj.CountryCode;
        CustomerTaxDetails reqTAXNumbers=new CustomerTaxDetails();
        reqTAXNumbers.TaxNumber1=LeanCusObj.TaxNumber1;
        reqTAXNumbers.TaxNumber2=LeanCusObj.TaxNumber2;
        reqTAXNumbers.TaxNumber3=LeanCusObj.TaxNumber3;
        reqTAXNumbers.TaxNumber4=LeanCusObj.TaxNumber4;
        reqTAXNumbers.VATRegistrationNumber=LeanCusObj.VATRegistrationNumber;
        reqTAXNumbers.GSTRegistrationNumber=LeanCusObj.GSTRegistrationNumber;
        ReuestUserInformation reqUserInformation=new ReuestUserInformation();
        reqUserInformation.RequestedUserName=LeanCusObj.RequestedUserName;
        reqUserInformation.PMFKey=LeanCusObj.PMFKey;
        reqUserInformation.TransactionReferenceNo=LeanCusObj.TransactionReferenceNo;
        reqUserInformation.OpportunityNumber=LeanCusObj.OpportunityNumber;
        reqUserInformation.CreatedDate=LeanCusObj.CreatedDate;
        CustomerCreationbody createBody=new CustomerCreationbody();
        createBody.Names=reqNames;
        createBody.Address=reqAddress;
        createBody.TAXNumbers=reqTAXNumbers;
        createBody.UserInformation=reqUserInformation;
        createBody.CAAccountID=LeanCusObj.CAAccountID;
        createBody.PhoneNumber=LeanCusObj.PhoneNumber;
        createBody.AccountGroupCode=LeanCusObj.AccountGroup;
        createBody.isForceCreate=LeanCusObj.isForceCreate;
        createBody.SoldToId=LeanCusObj.SoldToID;
        AzureRequestWrapper AzurerequestObj=new AzureRequestWrapper();
        AzurerequestObj.customerCreationRequest=createBody;
        String requestBody = JSON.serialize(AzurerequestObj);
        System.debug('final Json---'+requestBody);
        return requestBody;
    }
    /****public void WebserviceCall(){
        String auth_token =Azure_Authrization();
        HttpRequest req = new HttpRequest();
        String body='{ "customerCreationRequest": { "isForcedDupCheck": "true", "Names": { "Name1": "IBM CORP", "Name2": "", "Name3": "", "Name4": "", "Name1InternationalLanguage": "", "Name2InternationalLanguage": "", "Name3InternationalLanguage": "", "Name4InternationalLanguage": "" }, "Address": { "Street1": "11501 Burnet Rd", "Street2": "", "Street3": "", "Street4": "", "Street5": "", "Street1InternationalLanguage": "", "Street2InternationalLanguage": "", "Street3InternationalLanguage": "", "Street4InternationalLanguage": "", "Street5InternationalLanguage": "", "PostalCode": "78758-3400", "City": "Austin", "CityInternationalLanguage": "", "RegionCode": "TX, US", "RegionName": "", "Country": "US, USA" }, "TAXNumbers": { "TaxNumber1": "", "TaxNumber2": "", "TaxNumber3": "", "TaxNumber4": "", "VATRegistrationNumber": "" }, "AccountGroup": "Z001", "PhoneNumber": "", "CAAccountID": "W097064", "UserInformation": { "RequestedUserName": "", "PMFKey": "", "QuoteNumber": "", "OpportunityNumber": "", "CreatedDate": "2017-11-23T19:35:46.621+00:00" } } }';
        String Enppp='https://imss-leancustomer.azurewebsites.net/api/customer-creation?code=xoHDlj4KH4amU1LFwqEVgy/UIny7a9aDC9J2Pfh1Ecnjq1vZOMaCsw==';
        req.setEndpoint(Enppp);
        req.setMethod('POST');
        req.setTimeout(100000);
        req.setBody(body);
        req.setHeader('Authorization','Bearer '+auth_token);
        req.setHeader('Content-Type','application/json');
        //req.setHeader('Content-Length','0'); 
        
        System.debug('req'+req.getHeader('Authorization'));
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        System.debug(res.getBody());
    }***********/
    public class AzureRequestWrapper{
        public CustomerCreationbody customerCreationRequest{get;set;}
        public AzureRequestWrapper(){
            this.customerCreationRequest =new CustomerCreationbody();
        }
    }
    public class CustomerCreationbody{
        public CustomerNames Names{get;set;}
        public CustomerAddress Address{get;set;}
        public CustomerTaxDetails TAXNumbers{get;set;}
        public ReuestUserInformation UserInformation{get;set;}
        public String CAAccountID{get;set;}
        public String PhoneNumber{get;set;}
        public String AccountGroupCode{get;set;}
        public String isForceCreate{get;set;}
        public string SoldToId{set;get;}
        public CustomerCreationbody(){
            this.Names = new CustomerNames();
            this.UserInformation =new ReuestUserInformation();
            this.TAXNumbers =new CustomerTaxDetails();
            this.Address =new CustomerAddress();
            this.CAAccountID='';
			this.PhoneNumber='';
            this.SoldToId='';
			this.AccountGroupCode='';
			this.isForceCreate='false';          
        }
    }
    public class CustomerNames{
        public String Name1{get;set;}
        public String Name2{get;set;}
        public String Name3{get;set;}
        public String Name4{get;set;}
        public String Name1InternationalLanguage{get;set;}
        public String Name2InternationalLanguage{get;set;}
        public String Name3InternationalLanguage{get;set;}
        public String Name4InternationalLanguage{get;set;}
        public CustomerNames(){
            this.Name1='';
            this.Name2='';
            this.Name3='';
            this.Name4='';
            this.Name1InternationalLanguage='';
        	this.Name2InternationalLanguage='';
        	this.Name3InternationalLanguage='';
        	this.Name4InternationalLanguage='';
        }
    }
    public class CustomerAddress{
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
        public String Country{get;set;}
        public CustomerAddress(){
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
        	this.Country='';
        }
    }
    public class ReuestUserInformation{
        public String RequestedUserName{get;set;}
        public String PMFKey{get;set;}
        public String TransactionReferenceNo{get;set;}
        public String OpportunityNumber{get;set;}
        public String CreatedDate{get;set;}
        public ReuestUserInformation(){
            this.RequestedUserName='';
            this.OpportunityNumber='';
            this.CreatedDate='';
            this.PMFKey='';
            this.TransactionReferenceNo='';
        }
    }
    public class CustomerTaxDetails{
        public String TaxNumber1{get;set;}
        public String TaxNumber2{get;set;}
        public String TaxNumber3{get;set;}
        public String TaxNumber4{get;set;}
        public String VATRegistrationNumber{get;set;}
        public String GSTRegistrationNumber{get;set;}
        public CustomerTaxDetails(){
            this.TaxNumber1 ='';
            this.TaxNumber2 ='';
        	this.TaxNumber3 ='';
        	this.TaxNumber4 ='';
        	this.VATRegistrationNumber ='';
            this.GSTRegistrationNumber = '';
        }
    }
	Public Creation_AzureResponse parseAzureResponse(String responseBody,String caAccId, Boolean isPartnerQuote){
    	Creation_AzureResponse AzureParseReturn=new Creation_AzureResponse();
      	List<DuplicateMatchedRecords> DuplicateDataList =new List<DuplicateMatchedRecords>();
      	CustomeCreationResponse customerCreate=new CustomeCreationResponse();
		JSONParser parser = JSON.createParser(responseBody);
        if(parser.nextToken() != null){
            if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                parser.nextToken();
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME&&(parser.getText() == 'status')){
                    parser.nextToken();
                    AzureParseReturn.Status=parser.getText();
                }
                parser.nextToken();
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME&&(parser.getText() == 'message')){
                    parser.nextToken();
                    AzureParseReturn.message=parser.getText();
                }
                if(AzureParseReturn.Status=='OK') {
                    parser.nextToken();
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME&&(parser.getText() == 'siteId')){
                        parser.nextToken();
                        AzureParseReturn.siteId=parser.getText();
                    }
                }
                parser.nextToken();
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME&&(parser.getText() == 'reason')){
                    parser.nextToken();
                    AzureParseReturn.reason=parser.getText();
                }
                if(!String.isBlank(AzureParseReturn.Status)&&AzureParseReturn.Status=='DUPS_FOUND'){
                    parser.nextToken();
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() =='CUSTOMER_INFO')) {
                            parser.nextToken();
                            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {       
                             while (parser.nextToken() != null) {
                                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {                    
                                 DuplicateMatchedRecords Duplicate = (DuplicateMatchedRecords)parser.readValueAs(DuplicateMatchedRecords.class);
                                    system.debug('----account id----'+Duplicate.CA_Account_ID);
                                    system.debug('----quote acc id----'+caAccId);
                                    if((isPartnerQuote==true) || (isPartnerQuote==false && String.isBlank(Duplicate.CA_Account_ID)) || (isPartnerQuote==false && String.isNotBlank(Duplicate.CA_Account_ID) && Duplicate.CA_Account_ID==caAccId))
                                        Duplicate.allowSelection = true;
                                    else
                                        Duplicate.allowSelection = false;
                                        
                                    
                                   DuplicateDataList.add(Duplicate);
                                  }
                              }
                            }
                        }
                      AzureParseReturn.MATCHED_RECORDS=DuplicateDataList;    
                 }else if(!String.isBlank(AzureParseReturn.Status)&&AzureParseReturn.Status=='OK'){
                      parser.nextToken();
                      if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() =='CUSTOMER_INFO')) {
                            parser.nextToken();
                            System.debug('---------------2');
                            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                System.debug('=====Start Object=====');
                                  customerCreate = (CustomeCreationResponse)parser.readValueAs(CustomeCreationResponse.class);
                                System.debug('customerCreate========'+customerCreate);
                                  if(String.isNotBlank(customerCreate.SoldToId))
                                  	customerCreate.SoldToId =String.valueOf(Integer.valueOf(customerCreate.SoldToId));
                                  if(String.isNotBlank(customerCreate.BillToId))
                                  	customerCreate.BillToId =String.valueOf(Integer.valueOf(customerCreate.BillToId));
                                 if(String.isNotBlank(customerCreate.ShipToId))
                                  	customerCreate.ShipToId =String.valueOf(Integer.valueOf(customerCreate.ShipToId));
                                System.debug('customerCreate------2222222');
                            }
                        }
                     AzureParseReturn.Create_Customer=customerCreate;
                 }
               }
        }
        System.debug('AzureParseReturn--'+AzureParseReturn);
        return AzureParseReturn;
    }
    
    public class Creation_AzureResponse{
    	public String status{set;get;}
        public String message{set;get;}
        public String reason{set;get;}
        public String siteId{set;get;}
        public List<DuplicateMatchedRecords> MATCHED_RECORDS{set;get;}
        public CustomeCreationResponse  Create_Customer{set;get;}
     	public Creation_AzureResponse(){
           this.status='';
           this.message='';
           this.reason='';
           this.siteId='';
           MATCHED_RECORDS=new List<DuplicateMatchedRecords>();
           Create_Customer=new CustomeCreationResponse();
         }
    }
    public class DuplicateMatchedRecords{
        public string SoldToId{set;get;}
        public string CA_Account_ID{set;get;}
        public string Account_Group{set;get;}	//added as part of US467348 - by BAJPI01
        public string Action{set;get;}			//added as part of US467348 - by BAJPI01
        public string City{set;get;}
        public string Country_code{set;get;}
        public string Name1{set;get;}
        public string Name2{set;get;}
        public string Postal_Code{set;get;}
        public string Region_code{set;get;}
        public string Street{set;get;}
        public string Street2{set;get;}			//added as part of US467348 - by BAJPI01
        public string Telephone{set;get;}
        public string score{set;get;}
        public string percentage{set;get;}
        public string rank{set;get;}
        public string EDM_Action{set;get;}		//added as part of US467348 - by BAJPI01
        public Boolean allowSelection{set;get;}	//US489973 - this is not from the response, but internal boolean to check if record can be selected or not.
        public DuplicateMatchedRecords(){
            this.SoldToId='';
            this.CA_Account_ID='';
            this.Account_Group='';
            this.Action='';
            this.City='';
            this.Country_code='';
            this.Name1='';
            this.Name2='';
            this.Postal_Code='';
            this.Region_code='';
            this.Street='';
            this.Street2='';
            this.Telephone='';
            this.score='';
            this.percentage='';
            this.rank='';
            this.EDM_Action='';
            this.allowSelection = false;
    	}
    }
    public class CustomeCreationResponse{
      public String SoldToId{set;get;}
      public String BillToId{set;get;}
      Public string ShipToId{set;get;}
      public String CA_Account_ID{set;get;}
      public String Account_Group{set;get;}
      public String Account_Group_code{set;get;}
      public String City{set;get;}
      public String CityInternationalLanguage{set;get;}
      public String Country{set;get;}  
      public string Country_code{set;get;}
      public String Name1{set;get;}
	  public string Name2{set;get;}
      public string Name3{set;get;}
	  public string Name4{set;get;}
      public String Name1InternationalLanguage{set;get;}
      public string Name2InternationalLanguage{set;get;}
      public string Name3InternationalLanguage{set;get;}
      public string Name4InternationalLanguage{set;get;}
      public string Region{set;get;}
	  public string Postal_Code{set;get;}
	  public string Region_code{set;get;}
	  public string Street{set;get;}
      public string Street2{set;get;}
	  public string Street3{set;get;}
	  public string Street4{set;get;}
	  public string Street5{set;get;}
      public string Street1InternationalLanguage{set;get;}
      public string Street2InternationalLanguage{set;get;}
      public string Street3InternationalLanguage{set;get;}
      public string Street4InternationalLanguage{set;get;}
      public string Street5InternationalLanguage{set;get;}
      public string Tax_Number_1{set;get;}
      public string Tax_Number_2{set;get;}
      public string Tax_Number_3{set;get;}
      public string Tax_Number_4{set;get;}
	  public string Telephone{set;get;}
      public string VAT_Registration_Number{set;get;}
      public string GST_Registration_Number{set;get;}
      public string UserInfo_RequestedUserName{set;get;}
      public string UserInfo_PMFKey{set;get;}
      public string UserInfo_TransactionReferenceNo{set;get;}
      public string UserInfo_OpportunityNumber{set;get;}
      public string UserInfo_CreatedDate{set;get;}
      public CustomeCreationResponse(){
         this.SoldToId='';
         this.BillToId='';
         this.ShipToId='';
         this.CA_Account_ID='';
         this.Account_Group='';
         this.Account_Group_code='';
         this.City='';
         this.CityInternationalLanguage='';
         this.Country='';
         this.Country_code='';
         this.Name1='';
         this.Name2='';
         this.Name3='';
         this.Name4='';
         this.Region='';
		 this.Postal_Code='';
		 this.Region_code='';
		 this.Street='';
         this.Street2='';
		 this.Street3='';
		 this.Street4='';
		 this.Street5='';
         this.Street1InternationalLanguage='';
         this.Street2InternationalLanguage='';
         this.Street3InternationalLanguage='';
         this.Street4InternationalLanguage='';
         this.Street5InternationalLanguage='';
         this.Tax_Number_1='';
         this.Tax_Number_2='';
         this.Tax_Number_3='';
         this.Tax_Number_4='';
         this.VAT_Registration_Number='';
         this.GST_Registration_Number='';
         this.UserInfo_RequestedUserName='';
         this.UserInfo_PMFKey='';
         this.UserInfo_TransactionReferenceNo='';
         this.UserInfo_OpportunityNumber='';
         this.UserInfo_CreatedDate='';
		 this.Telephone='';
      }
    }
    
}