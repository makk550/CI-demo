/* 
 * Class as part of OnGoingSync_QuoteInterface
 * send the request to SAP, receives response and parses it
 * Created By: merha02
*/

public class SAP_Quote_Utility {
    
    // authentication details of SAP stores in lables
    public string Username { get { return System.Label.OnGoingSync_SAP_UserName; } private set; }
    public string Password { get { return System.Label.OnGoingSync_SAP_Password; } private set; }
    public static Boolean ContainsACprod = false;
    
    public SAPQuoteResponse getQuoteData(String inputType,String inputValue){
        
        // request to SAP in form of json with contract/quote number details
        SAPQuoteResponse SAPObj;
        FetchQuoteRequestBody requestBody=new FetchQuoteRequestBody(inputType,inputValue);
        FetchQuoteRequest requestOBJ =new FetchQuoteRequest(requestBody);
        String jsonRequest=Json.serialize(requestOBJ);
        System.debug('----jsonRequest----'+jsonRequest);
        
        /*----jsonRequest----{"RECORDS":{"SALESDOCUMENT":"123","CPQQUOTENUMBER":null}}*/
        
        
        String endpoint = System.Label.OnGoingSyncUrl_SAP;
        Http http = new Http();
        HttpRequest req = SAPHttpRequest(endpoint,jsonRequest);
        try{
            HttpResponse response = http.send(req);
            System.debug('=======response======='+response.getbody());
            System.debug('------------response.getStatusCode()--------'+response.getStatusCode());
            if(response.getStatusCode() == 200){
                // parses the json response 
                SAPObj=JsonParsePullQuoteData(response.getBody());
                System.debug('--SAPObj'+SAPObj);
            }else{
                SAPObj = new SAPQuoteResponse();
                SAPObj.Message='something went worng,please try again later';
            }
        }catch (Exception e) {
            SAPObj = new SAPQuoteResponse();
            SAPObj.Message=e.getMessage();
            
        }
        System.debug('--------SAPObj.Message--------'+SAPObj.Message);
        return SAPObj;
        
    }
    Public class SAPQuoteResponse{
        public String Message{get;set;}
        public HeaderDetails QuoteHeaderDetails{get;set;}
        public List<Item> QuoteLineDetails{get;set;}
        
        public SAPQuoteResponse(){
            this.QuoteHeaderDetails =  new HeaderDetails();
            this.QuoteLineDetails=new List<Item>();
            this.Message ='';
        }
    }
    public class FetchQuoteRequest{
        public FetchQuoteRequestBody RECORDS;
        public FetchQuoteRequest(FetchQuoteRequestBody body){
            this.RECORDS =body;
        }
    }
    public Class FetchQuoteRequestBody{
        public String SALESDOCUMENT;
        public String CPQQUOTENUMBER;
        public FetchQuoteRequestBody(String InputType,String InputValue){
            if(InputType=='Contract Number'){
                this.SALESDOCUMENT = InputValue;
                this.CPQQUOTENUMBER = '';
            } else{
                this.CPQQUOTENUMBER = InputValue;
                this.SALESDOCUMENT = '';
            }
            
        }
    }
    public HttpRequest SAPHttpRequest(String endpoint,String jsonRequest){
        String authHeader = getSAP_AuthHeader();
        HttpRequest req = new HttpRequest();
        req.setTimeout(60000);
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setHeader('content-Type', 'application/json');
        req.setHeader('Accept', '*/*');
        req.setHeader('Authorization', authHeader);
        req.setBody(jsonRequest);
        System.debug('-----req----'+req);
        return req;        
    }
    public String getSAP_AuthHeader(){
        Blob headerValue = Blob.valueOf(Username + ':' + Password); 
        String authHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue); 
        return authHeader;
    }
    // method to parse the response to Header and line details
    public SAPQuoteResponse JsonParsePullQuoteData(String resBody){
        Set<String> ACMaterialIds = AC_Products_Material_ID__c.getall().keySet(); // to filter out AC products
        Set<String> PPMmaterialIds = PPM_Products_Material_Ids__c.getall().keySet(); // to filter out PPM products
        
        System.debug('------resBody-------'+resBody);
        SAPQuoteResponse SAPObj =new SAPQuoteResponse();
        
        List<Item> QuoteLineDetails = new List<Item>();
         List<Item> PPMQuoteLineDetails = new List<Item>();
        
        JSONParser parser = JSON.createParser(resbody);
        while (parser.nextToken() != null){
            System.debug('--------getcurrent token--------'+parser.getCurrentToken());
            System.debug('------get text----------'+parser.getText());
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'STATUS_SAP')) {
                    parser.nextToken();
                 //   SAPObj.Message=parser.getText();
                   System.debug('---- parser mesage------'+parser.getText());
                }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'HEADER_DETAILS')) {
                    parser.nextToken();
                         if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                          SAPObj.QuoteHeaderDetails  = (HeaderDetails)parser.readValueAs(HeaderDetails.class);
                    }
                }
            
             if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'ITEM_DETAILS')) {
                    System.debug('--------in item section getcurrent token--------'+parser.getCurrentToken()+'-----'+parser.getText());
                    parser.nextToken();
                    parser.nextToken();
                    
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'item')) {
                            parser.nextToken();
                            if (parser.getCurrentToken() == JSONToken.START_ARRAY) { 
                                while (parser.nextToken() != null) {
                                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                        Item s = (Item)parser.readValueAs(Item.class);
                                        System.debug('-----------item--------'+s);
                                        if(ACMaterialIds.contains(s.MATERIAL)){
                                            QuoteLineDetails.add(s);
                                            ContainsACprod = true; 
                                        }
                                        if(PPMmaterialIds.contains(s.MATERIAL) && ContainsACprod == false){
                                            PPMQuoteLineDetails.add(s);   
                                        }
                                          
                                    }
                                }
                                if(QuoteLineDetails!=null && QuoteLineDetails.size()>0){
                                     SAPObj.QuoteLineDetails=QuoteLineDetails;
                                }
                                else if (PPMQuoteLineDetails!=null && PPMQuoteLineDetails.size()>0 && ContainsACprod == false){
                                    SAPObj.QuoteLineDetails=PPMQuoteLineDetails;
                                }
                            }
                            
                        }
                }
            
        }
        System.debug('------------JsonParsePullQuoteData----------'+SAPObj);
        
        return SAPObj;
    }

    public class HeaderDetails{
        public String SHIPPING_CONTACT{get;set;}
        public String BILLING_CONTACT{get;set;}
        public String SALES_DOCUMENT{get;set;}
        public String CREATED_ON{get;set;}
        public String CREATED_BY{get;set;}
        public String SALES_DOC_TYPE{get;set;}
        public String CONTRACT_NET_VALUE{get;set;}
        public String CONTRACT_START_DATE{get;set;}
        public String ACCEPTANCE_DATE_HEAD{get;set;}
        public String DOC_CURRENCY{get;set;}
        public String RAMP_INDICATOR{get;set;}
        public String RAMP_BRIDGE{get;set;}
        public String CPQ_QUOTE_NUMBER{get;set;}
        public String OPP_NUMBER{get;set;}
        public String CA_ACCOUNT_ID{get;set;}
        public String SALES_ORG{get;set;}
        public String SOLD_TO_ID{get;set;}
        public String SOLD_TO_NAME{get;set;}
        public String SHIP_TO_ID{get;set;}
        public String SHIP_TO_NAME{get;set;}
        public String BILL_TO_ID{get;set;}
        public String END_USER_ID{get;set;}
        public String RESELLER_ID{get;set;}
        public String DISTRIBUTOR_ID{get;set;}
        public String TECHNICAL_CONTACT{get;set;}
        public String TECH_CONTACT_FISTNAME{get;set;}
        public String TECH_CONTACT_LASTNAME{get;set;}
        public String TECHNICAL_CONTACT_PHONE{get;set;}
        public String TECHNICAL_CONTACT_EMAIL{get;set;}
        public String SHIPPING_CONTACT_FISTNAME{get;set;}
        public String SHIPPING_CONTACT_LASTNAME{get;set;}
        public String SHIPPING_CONTACT_PHONE{get;set;}
        public String SHIPPING_CONTACT_EMAIL{get;set;}
        public String BILLING_CONTACT_FISTNAME{get;set;}
        public String BILLING_CONTACT_LASTNAME{get;set;}
        public String BILLING_CONTACT_PHONE{get;set;}
        public String BILLING_CONTACT_EMAIL{get;set;}
        
        public HeaderDetails(){
            this.SHIPPING_CONTACT='';
            this.BILLING_CONTACT='';
            this.SALES_DOCUMENT='';
            this.CREATED_ON='';
            this.CREATED_BY='';
            this.SALES_DOC_TYPE='';
            this.CONTRACT_NET_VALUE='';
            this.CONTRACT_START_DATE='';
            this.ACCEPTANCE_DATE_HEAD='';
            this.DOC_CURRENCY='';
            this.RAMP_INDICATOR='';
            this.RAMP_BRIDGE='';
            this.CPQ_QUOTE_NUMBER='';
            this.OPP_NUMBER='';
            this.CA_ACCOUNT_ID='';
            this.SALES_ORG='';
            this.SOLD_TO_ID='';
            this.SOLD_TO_NAME='';
            this.SHIP_TO_ID='';
            this.SHIP_TO_NAME='';
            this.BILL_TO_ID='';
            this.END_USER_ID='';
            this.RESELLER_ID='';
            this.DISTRIBUTOR_ID='';
            this.TECHNICAL_CONTACT='';
            this.TECH_CONTACT_FISTNAME='';
            this.TECH_CONTACT_LASTNAME='';
            this.TECHNICAL_CONTACT_PHONE='';
            this.TECHNICAL_CONTACT_EMAIL='';
            this.SHIPPING_CONTACT_FISTNAME='';
            this.SHIPPING_CONTACT_LASTNAME='';
            this.SHIPPING_CONTACT_PHONE='';
            this.SHIPPING_CONTACT_EMAIL='';
            this.BILLING_CONTACT_FISTNAME='';
            this.BILLING_CONTACT_LASTNAME='';
            this.BILLING_CONTACT_PHONE='';
            this.BILLING_CONTACT_EMAIL='';
        }
    }
    public class Item{
        public String ITEM{get;set;}
        public String MATERIAL{get;set;}
        public String DESCRIPTION{get;set;}
        public String QUANTITY{get;set;}
        public String DURATION{get;set;}
        public String INSTALLATION_DATE{get;set;}
        public String DISMANTLING_DATE{get;set;}
        public Decimal CPQ_LIST_PRICE{get;set;}
        public Decimal CPQ_LICENSE_PRICE{get;set;}
        public Decimal CPQ_MAINTENANCE_PRICE{get;set;}
        public Decimal CPQ_SUBSCRIPTION_PRICE{get;set;}
        public Decimal CPQ_LICENSE_DISCOUNT{get;set;}
        public Decimal CPQ_MAINTENANCE_DISCOUNT{get;set;}
        public Decimal CPQ_SUBSCRIPTION_DISCOUNT{get;set;}
        public Decimal CPQ_RENEWAL_DISCOUNT{get;set;}
        public Decimal ZLMP{get;set;}
        public Decimal ZVSM{get;set;}
        public String SAAS_PRODUCT{get;set;}
        public String CA_BUSTRANS_TYPE{get;set;}
        public String AUTHORIZATION_MODEL{get;set;}
        public String MAINTENANCE{get;set;}
        public String LICENSE_TYPE{get;set;}
        public String PRODUCT_INST_ID{get;set;}
        public String ACCEPTANCE_DATE{get;set;}
        
        public Item(){
            this.ITEM='';
            this.MATERIAL='';
            this.DESCRIPTION='';
            this.QUANTITY='';
            this.DURATION='';
            this.INSTALLATION_DATE='';
            this.DISMANTLING_DATE='';
            this.CPQ_LIST_PRICE=0.0;
            this.CPQ_LICENSE_PRICE=0.0;
            this.CPQ_MAINTENANCE_PRICE=0.0;
            this.CPQ_SUBSCRIPTION_PRICE=0.0;
            this.CPQ_LICENSE_DISCOUNT=0.0;
            this.CPQ_MAINTENANCE_DISCOUNT=0.0;
            this.CPQ_SUBSCRIPTION_DISCOUNT=0.0;
            this.CPQ_RENEWAL_DISCOUNT=0.0;
            this.ZLMP=0.0;
            this.ZVSM=0.0;
            this.SAAS_PRODUCT='';
            this.CA_BUSTRANS_TYPE='';
            this.AUTHORIZATION_MODEL='';
            this.MAINTENANCE='';
            this.LICENSE_TYPE='';
            this.PRODUCT_INST_ID='';
            this.ACCEPTANCE_DATE='';
        }
    }
    
    
}