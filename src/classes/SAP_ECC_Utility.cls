public class SAP_ECC_Utility {
	public string base_url { get { return System.Label.SAP_Host; } private set; }
    public string Username { get { return System.Label.SAP_UserName; } private set; }
    public string Password { get { return System.Label.SAP_Password; } private set; }
    public static Set<String> countryCodeHM = new Set<String>{'CN','KR','JP','TW'};
    public SAP_ECC_Utility(){
        
    }
    public String getSAP_AuthHeader(){
        Blob headerValue = Blob.valueOf(Username + ':' + Password); 
        String authHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
        return authHeader;
    }
 
    public SAPResponse getAllTechnicalContact(String SoldSiteId,String Country){
        SAPResponse SAPObj;
        FetchTechnicalReuestBody requestBody=new FetchTechnicalReuestBody(SoldSiteId,Country);
        FetchTechnicalReuest requestOBJ =new FetchTechnicalReuest(requestBody);
        String jsonRequest=Json.serialize(requestOBJ);
        /*****SAMPLE*******String jsonRequest='{"INPUT_MESSAGE":{"COUNTRY_CODE": "","CUSTOMER_ID": "'+SoldSiteId+'"}}';******/
        String endpoint = System.Label.SAP_Customer_READ;
        Http http = new Http();
        HttpRequest req = SAPHttpReuest(endpoint,jsonRequest);
        try{
            HttpResponse response = http.send(req);
        	System.debug('=======response======='+response.getbody());
            if(response.getStatusCode() == 200){
                SAPObj=JsonParsePullContacts(response.getBody());
                System.debug('--SAPObj'+SAPObj);
            }else{
                 SAPObj = new SAPResponse();
                 SAPObj.Message='Something went wrong. Please try again later.';
            }
        }catch (Exception e) {
            SAPObj = new SAPResponse();
            SAPObj.Message=e.getMessage();
        }
         return SAPObj;
        
    }
    public SAPResponse JsonParsePullContacts(String resBody){
        SAPResponse SAPObj =new SAPResponse();
        List<ContactItem> ContactItemList =new List<ContactItem>();
        JSONParser parser = JSON.createParser(resBody);
        while (parser.nextToken() != null){
        	if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
            	(parser.getText() == 'CONTACT_DETAILS')) {
                 	parser.nextToken();
                    parser.nextToken();
                   	parser.nextToken();
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {       
                    	while (parser.nextToken() != null) {
                        	if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            	ContactItem s = (ContactItem)parser.readValueAs(ContactItem.class);
                                String contactIdCheck = s.CONTACT_ID.trim();
                                if(contactIdCheck != '0'){
                                    ContactItemList.add(s);
                                }
                                System.debug(s);
                            }
                         }
                         SAPObj.ContactList=ContactItemList;
                      }
                                //System.debug('-----'+parser.getText());
             } 
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'ERROR_MSG')) {
                    System.debug('saikumar');
                    parser.nextToken();
                    SAPObj.Message = parser.getText();
                    
                }
        }
        System.debug('JsonParsePullContacts'+SAPObj);
        return SAPObj;
        
    }
    
    
    /***************  START------Create Technical Contact******************/
    public Map<String,String> CreateTechnicalContact(String CustomerId,String contactId,String type,String title,String firstname,String lastname,String email,String telephone){
        System.debug('CreateTechnicalContact Entry');
        system.debug('----telephone----'+telephone);
        Map<String,String> responseMAP =new Map<String,String>();
        ContactCreate requestBody = new ContactCreate(CustomerId,contactId,type,title,firstname,lastname,email,telephone);
        TechnicalContactCreateWrapper reuestObj = new TechnicalContactCreateWrapper(requestBody);
        String Jsonrequest=Json.serialize(reuestObj);
        system.debug('---request----'+Jsonrequest);
        String endpoint = System.Label.SAP_Customer_CREAT;
        Http http = new Http();
        HttpRequest req = SAPHttpReuest(endpoint,Jsonrequest);
        try{
            HttpResponse response = http.send(req);
        	System.debug('=======response======='+response.getbody());
            if(response.getStatusCode() == 200){
                responseMAP=JsonParseCreateContact(response.getbody());
            }else{
                responseMAP.put('STATUS', 'Failure');
            responseMAP.put('MESSAGE','not able to connect to External System.');
            }
        }catch (Exception e) {
            responseMAP.put('STATUS', 'Failure');
            responseMAP.put('MESSAGE', e.getMessage());
        }
      return responseMAP;
        
    }
   
    public Map<String,String> JsonParseCreateContact(String resBody){
        System.JSONToken token;
        Map<String,String> responseMAP =new Map<String,String>();
        JSONParser parser = JSON.createParser(resBody);
        while (parser.nextToken() != null){
            System.debug('parser0'+parser);
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'MESSAGE')) {
                    parser.nextToken();
                    responseMAP.put('MESSAGE', parser.getText());
                    System.debug('parser1'+parser);
                    
            }else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'STATUS')) {
                    parser.nextToken();
                    System.debug('parser2'+parser);
                    System.debug('parser.getText()'+parser.getText());
                    responseMAP.put('STATUS', parser.getText());
                }
            
        }
        System.debug(responseMAP);
        return responseMAP;
    }
    /*****************END-------Create Technical Contact ****************************/
    public HttpRequest SAPHttpReuest(String endpoint,String jsonRequest){
        String authHeader = getSAP_AuthHeader();
        HttpRequest req = new HttpRequest();
        req.setTimeout(60000);
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('content-Type', 'application/json');
        req.setHeader('Accept', '*/*');
        req.setHeader('Authorization', authHeader);
        req.setBody(jsonRequest);
        return req;        
    }
    public String getFullsite(String siteId){
         while (siteId.length() < 10) {
            siteId ='0'+siteId;
        }
        return siteId;
    }
    Public class SAPResponse{
        public String Message{get;set;}
        public List<ContactItem> ContactList{get;set;}
        public SAPResponse(){
            this.ContactList =  new List<ContactItem>();
            this.Message ='';
        }
    }
    public class ContactItem{
        public String LAST_NAME_INTL{get;set;}
    	public String FIRST_NAME{get;set;}
    	public String TELEPHONE_EXTN{get;set;}
    	public String PARTNER_FUNCTION_DESCRIPTION{get;set;}
    	public String CONTACT_ID{get;set;}
    	public String FIRST_NAME_INTL{get;set;}
		public String TELEPHONE{get;set;}
    	public String EMAIL_ID{get;set;}
        public String LAST_NAME{get;set;}
        public ContactItem(){
            this.PARTNER_FUNCTION_DESCRIPTION =
            this.CONTACT_ID='';
            this.FIRST_NAME ='';
            this.LAST_NAME='';
            this.FIRST_NAME_INTL='';
            this.LAST_NAME_INTL='';
            this.TELEPHONE_EXTN='';
            this.EMAIL_ID='';
            this.TELEPHONE='';
        }
    }
    public class FetchTechnicalReuest{
       public FetchTechnicalReuestBody INPUT_MESSAGE;
        public FetchTechnicalReuest(FetchTechnicalReuestBody body){
            this.INPUT_MESSAGE =body;
        }
    }
    public Class FetchTechnicalReuestBody{
        public String COUNTRY_CODE;
        public String CUSTOMER_ID;
        public FetchTechnicalReuestBody(String SoldID,String CountryCode){
            this.COUNTRY_CODE = CountryCode;
            this.CUSTOMER_ID  = SoldID;
        }
    }
    public class TechnicalContactCreateWrapper{
        public ContactCreate CONTACT_MAINTAIN_REQ;
        public TechnicalContactCreateWrapper(ContactCreate createBody){
            this.CONTACT_MAINTAIN_REQ=createBody;
        }
    }
    public class ContactCreate{
      public String CUSTOMER_ID;
      public String CONTACT_PERSON_ID;
      public String CONTACT_TYPE;
      public String TITLE;
      public String FIRST_NAME;
      public String LAST_NAME;
      public String TELEPHONE;
      public String EMAIL_ID;
        public ContactCreate(String CustomerId,String contactId,String type,String title,String firstname,String lastname,String email,String telephone){
            this.CUSTOMER_ID = CustomerId;
            this.CONTACT_PERSON_ID = contactId;
            this.CONTACT_TYPE = type;
            this.TITLE = title;
            this.FIRST_NAME = firstname;
            this.LAST_NAME = lastname;
            this.EMAIL_ID = email;
            this.TELEPHONE = telephone;
        }
    }
}