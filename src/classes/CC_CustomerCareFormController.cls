public class CC_CustomerCareFormController {
   
    //Account Information
    public String siteId { get; set; }   
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String company { get; set; }
    public String addressText { get; set; }
    public String country { get; set; }
    public String city { get; set; }
    public String state_province { get; set; }
    public String postal_zip_code { get; set; }
    public String telePhNo { get; set; }
    public String extension { get; set; }
    public String email_address { get; set; }
    public String request_type { get; set; }
    
    //Details
    //public String your_question { get; set; }
    public String lic_your_question { get; set; }
    public String general_your_question { get; set; }
    public String portal_your_question { get; set; }
    public String caPartReq_your_question { get; set; }
    public String caEduSup_your_question { get; set; }
    public String product_name { get; set; }
    public String release { get; set; }
    public String licensing_type { get; set; }
    public String is_partner_registered { get; set; }  //partner registration on ca.com
    public String emailAddress_used { get; set; }          //email address used to register
    public String organizationId { get; set; }
    /*public String method_of_contact_phone { get; set; }
public String method_of_contact_email { get; set; }*/
    public String best_method_of_contact { get; set; }
    public String course_name { get; set; }
    public String course_number { get; set; }
    public String date_of_class { get; set; }
    public String class_location { get; set; }
    public String operating_system { get; set; }
    public String browser { get; set; }
    public String java_version { get; set; }
    public String contact_instruction { get; set; }
    
    
    //Required Fields Validation Message
    public String siteIdError { get; set; } 
    public String firstNameError { get; set; }
    public String lastNameError { get; set; }
    public String companyError { get; set; }
    public String addressError { get; set; }
    public String countryError { get; set; }
    public String cityError { get; set; }
    public String stateError { get; set; }
    public String zipCodeError { get; set; }
    public String telephError { get; set; }
    public String emailAddressError { get; set; }
    public String requestTypeError { get; set; }
    public String licyqError { get; set; }
    public String prodNameError { get; set; }
    public String licTypeError { get; set; }
    public String genyqError { get; set; }
    public String caspyqError { get; set; }
    public String capryqError { get; set; }
    public String ispartnerRegError { get; set; }
    public String conatctMethodError { get; set; }
    public String caeduyqError { get; set; }
    public String captchaError { get; set; }
    
    public boolean errorFound = false ;
    
    
    public boolean isLicensing { get; set;   }
    public boolean isGeneralQuestions { get; set; }
    public boolean isCASupportPortal { get; set; }
    public boolean isCAPartnerRequest { get; set; }
    public boolean isCAEduSupport { get; set; }
    public boolean showButtons { get; set; }
    public String countryName {get;set;}    
    public boolean fromSaveExecutionPath = false;
    public static String countriesFromService = fetchCountriesFromWebService();
    public String hasAttachmentsToAdd { get; set; }
    public String caseNumber { get; set; }
    public List<String> attachmentsNameList {
        get{
            if(attachmentsNameList == null){
                attachmentsNameList = new List<String>();
            }
            return attachmentsNameList;
        }
        set;
    }
    
    public boolean isAnonymousUser { get; set; }
    
    //public String cnValues { get;set; }  
    //public String userContext {get; set; } 
    
    //public Attachment attachmentRec { get; set; }
    public Attachment attachmentRec {
        get {
            if (attachmentRec == null)
                attachmentRec = new Attachment();
            return attachmentRec;
        }
        set;
    }
    
    public static List<CC_Help_Text__mdt> helpTextForCCF { 
        get {
            if (helpTextForCCF == null) {
                helpTextForCCF = new List<CC_Help_Text__mdt>();
                helpTextForCCF = [SELECT url__c,  title_eng__c FROM CC_Help_Text__mdt where Module__c = 'CustomerCareForm'];
            }
            return helpTextForCCF;
        }
        set;
    }
    
    
   /* public transient Attachment attachmentRecHelper;
    
    public Attachment attachmentRec {
        get{
             //check if accountListHelper is none
             if(attachmentRec==null){
                attachmentRec = getattachmentRec();
             }
             return attachmentRec;
          }    
        set;
    }
    
    private Attachment getattachmentRec(){
    Attachment att = new Attachment();        
        return att;
    } */
    
    //public User currentUser;
    
    // The API endpoint for the reCAPTCHA service
    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify'; 
    
    // The keys you get by signing up for reCAPTCHA for your domain
    private static String privateKey = '6LdyfQsTAAAAAPc3E0C4PrqLsmj8MI2X_nMHAlRw';
    
    public String publicKey { 
        get { return '6LdyfQsTAAAAADl2byfdilL20qM9RgexQZkBNHE7'; }
    } 
    public String questionText{
        get{
            return System.Label.CCF_Your_Question_Info; //'Please provide as much detail as possible.If requesting assistance on behalf of someone else, please ensure you also provide your email and phone number in case additional information is required.';
        }
        set;
    } 
    /*public PageReference setDetailsBlock(){
        System.debug('In setDetailsBlock');        
        isLicensing = false;
        isGeneralQuestions = false;
        isCASupportPortal = false;
        isCAPartnerRequest = false;
        isCAEduSupport = false;
        
        if( request_type == System.Label.CCF_CA_Licensing ){
            isLicensing = true;
            showButtons = true;
        }
        else if( request_type ==  System.Label.CCF_General_Questions ){
            isGeneralQuestions = true;
            showButtons = true;
        }
        else if( request_type == System.Label.CCF_CA_Support_Portal ){
            isCASupportPortal = true;
            showButtons = true;
        }
        else if( request_type == System.Label.CCF_CA_Partner_Request ){
            isCAPartnerRequest = true;
            showButtons = true;
        }
        else if( request_type == System.Label.CCF_CA_Education_Support ){
            isCAEduSupport = true;
            showButtons = true;
        }        
        System.debug('isLicensing :'+isLicensing );   
        System.debug('isGeneralQuestions :'+isGeneralQuestions ); 
        System.debug('isCASupportPortal :'+isCASupportPortal ); 
        System.debug('isCAPartnerRequest :'+isCAPartnerRequest ); 
        System.debug('isCAEduSupport :'+isCAEduSupport ); 
        System.debug('showButtons :'+showButtons );         
        return null;
    } */
    
    public CC_CustomerCareFormController(ApexPages.StandardController stdController){
        System.debug('In parametrized constructor');
        
    }
    
    public CC_CustomerCareFormController()
    {
        System.debug('In default constructor,caseNumber:'+caseNumber+'-hasAttachmentsToAdd:'+hasAttachmentsToAdd);
        if( countriesFromService == null ){
            countriesFromService = fetchCountriesFromWebService();
        }        
        showButtons = false;
        /*Id currentUserId = UserInfo.getUserId();
currentUser = [SELECT Id, FirstName, LastName, ProfileId, LDAP_Roles__c, Contact.Id, Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c,
Contact.Phone,Contact.Email,Contact.MailingStreet,Contact.MailingCity,Contact.MailingState, 
Contact.MailingCountry, Contact.MailingPostalCode,Contact.Company_Name__c
FROM User WHERE ID = :currentUserId];
System.debug('currentUser:'+currentUser); */
        
        //User currentUser= [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        /* userContext = JSON.serialize(new Map<String, Object>{
'userId' => currentUser.Id,
'firstName' => currentUser.FirstName,
'lastName' => currentUser.LastName
});


//Check if the profile license is 'Guest User License'        
if(currentUser.ProfileId ==  CC_Settings.customerCommunityGuestProfileId ){
System.debug('Anonymous User - Logged in using Guest User Profile ');
isAnonymousUser = true;
}
else {           
System.debug('Logged in User block');
isAnonymousUser = false;

//CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
//cnValues = ldapRoles.reverseTranslateString(currentUser.LDAP_Roles__c);

userContext = JSON.serialize(new Map<String, Object>{
'userId' => currentUser.Id,
'firstName' => currentUser.FirstName,
'lastName' => currentUser.LastName
}); */
        
        //Decided not to default the logged-in user's details
        /* siteId = currentUser.Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c ;
firstName = currentUser.FirstName ; // Check , if it should be the contact's /User's ?
lastName = currentUser.LastName ;
company = currentUser.Contact.Company_Name__c;
addressText = currentUser.Contact.MailingStreet;
country = currentUser.Contact.MailingCountry;
city = currentUser.Contact.MailingCity;
state_province = currentUser.Contact.MailingState;
postal_zip_code = currentUser.Contact.MailingPostalCode;
telePhNo = currentUser.Contact.Phone;
extension = ''; 
email_address = currentUser.Contact.Email;   */         
        //}
        
    }
    
    public List<SelectOption> getRequestTypes(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('',''));
        options.add(new SelectOption( System.Label.CCF_CA_Licensing, System.Label.CCF_CA_Licensing ));
        options.add(new SelectOption( System.Label.CCF_General_Questions, System.Label.CCF_General_Questions ));
        options.add(new SelectOption( System.Label.CCF_CA_Support_Portal, System.Label.CCF_CA_Support_Portal ));
        options.add(new SelectOption( System.Label.CCF_CA_Partner_Request, System.Label.CCF_CA_Partner_Request ));
        options.add(new SelectOption( System.Label.CCF_CA_Education_Support, System.Label.CCF_CA_Education_Support ));
        return options;         
    }
    
    public List<SelectOption> getLicensingTypes(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('',''));
        options.add(new SelectOption( System.Label.CCF_ALP_Keys, System.Label.CCF_ALP_Keys ));
        options.add(new SelectOption( System.Label.CCF_LMP_Keys, System.Label.CCF_LMP_Keys ));
        options.add(new SelectOption( System.Label.CCF_All_Other_Keys, System.Label.CCF_All_Other_Keys ));
        return options;         
    }
    
    public List<SelectOption> getYesNoOptions(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption( System.Label.CCF_Yes, System.Label.CCF_Yes ));
        options.add(new SelectOption( System.Label.CCF_No, System.Label.CCF_No ));
        return options;         
    }
    
    public List<SelectOption> getcontactMethods(){
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption( 'Phone', 'Phone' ));
        options.add(new SelectOption( 'Email' , 'Email' ));
        return options;         
    }
    
    public static String fetchCountriesFromWebService(){
        Http httpObj = new Http();
        HttpRequest req =  new HttpRequest();
        req.setEndpoint(System.Label.CACOM_Countries_Endpoint);
        req.setMethod('GET');
        HttpResponse response= httpObj.send(req);
        System.debug('status code:'+response.getStatus() );
        String responseBody = response.getBody();
        //System.debug('response.getBody():'+responseBody);
        return responseBody;
    }
    
    public List<SelectOption> getCountries() {
        System.debug('In getCountries'); // + countriesFromService
        String countries = countriesFromService; //fetchCountriesFromWebService();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        if(countries != null){
            List<Util_JSONParser> arrayParser = Util_JSONParser.parseArray(countries);
            for (Util_JSONParser p : arrayParser) {
                options.add(new SelectOption(p.get('Country_ID').Value,p.get('Country_Name').Value));
            } 
        }
        return options;
    }
    
    public String fetchStatesForCountryFromWebService(String countryId){
        System.debug('*****countryId:'+countryId);
        if( ! String.isBlank(countryId) ){
            Http httpObj = new Http();
            HttpRequest req =  new HttpRequest();
            req.setEndpoint(System.Label.CACOM_States_Endpoint+countryId);
            req.setMethod('GET');
            HttpResponse response= httpObj.send(req);
            System.debug('status code:'+response.getStatus() );
            String responseBody = response.getBody();
            //System.debug('response.getBody():'+responseBody);
            return responseBody;            
        } else {
            return null;
        }
        
    }
    
   /* public PageReference doSetCountryDetails(){
        // Do Something...
        System.debug('In doSetCountryDetails,countryName:' + countryName  +'-country:'+country);
        return null;
    } */
    
    public List<SelectOption> getStates() {
        System.debug('fromSaveExecutionPath:'+fromSaveExecutionPath + ',countryName:'+countryName );
        if(fromSaveExecutionPath == false || errorFound == true ){
            List<SelectOption> options = new List<SelectOption>(); 
            options.add(new SelectOption('',''));      
            System.debug('In getStates , countryId:'+country);
            String states = fetchStatesForCountryFromWebService(country);        
            if(states != null){
                List<Util_JSONParser> arrayParser = Util_JSONParser.parseArray(states);        
                for (Util_JSONParser p : arrayParser) {
                    options.add(new SelectOption(p.get('State_Name').Value,p.get('State_Name').Value));
                }             
            }
            return options;
        } else {
            return null;
        }
        
    }
    
    /*  public List<SelectOption> getCountries() {
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('',''));
options.add(new SelectOption('United States','United States'));
options.add(new SelectOption('Canada','Canada'));
options.add(new SelectOption('Albania','Albania'));
options.add(new SelectOption('Algeria','Algeria'));
options.add(new SelectOption('American Samoa','American Samoa'));
options.add(new SelectOption('Andorra','Andorra'));
options.add(new SelectOption('Angola','Angola'));
options.add(new SelectOption('Anguilla','Anguilla'));
options.add(new SelectOption('Antarctica','Antarctica'));
options.add(new SelectOption('Antigua and Aarbuda','Antigua and Aarbuda'));
options.add(new SelectOption('Argentina','Argentina'));
options.add(new SelectOption('Armenia','Armenia'));
options.add(new SelectOption('Aruba','Aruba'));
options.add(new SelectOption('Australia','Australia'));
options.add(new SelectOption('Austria','Austria'));
options.add(new SelectOption('Bahamas','Bahamas'));
options.add(new SelectOption('Bahrain','Bahrain'));
options.add(new SelectOption('Bangladesh','Bangladesh'));
options.add(new SelectOption('Barbados','Barbados'));
options.add(new SelectOption('Belarus','Belarus'));
options.add(new SelectOption('Belgium','Belgium'));
options.add(new SelectOption('Belize','Belize'));
options.add(new SelectOption('Bermuda','Bermuda'));
options.add(new SelectOption('Bolivia','Bolivia'));
options.add(new SelectOption('Bosnia and Herzegowina','Bosnia and Herzegowina'));
options.add(new SelectOption('Botswana','Botswana'));
options.add(new SelectOption('Brazil','Brazil'));
options.add(new SelectOption('British Indian Ocean','British Indian Ocean'));
options.add(new SelectOption('Brunei Darussalam','Brunei Darussalam'));
options.add(new SelectOption('Bulgaria','Bulgaria'));
options.add(new SelectOption('Burundi','Burundi'));
options.add(new SelectOption('Cambodia','Cambodia'));
options.add(new SelectOption('Cameroon','Cameroon'));
options.add(new SelectOption('Cayman Islands','Cayman Islands'));
options.add(new SelectOption('Central African Republic','Central African Republic'));
options.add(new SelectOption('Chile','Chile'));
options.add(new SelectOption('China','China'));
options.add(new SelectOption('Colombia','Colombia'));
options.add(new SelectOption('Congo','Congo'));
options.add(new SelectOption('Costa Rica','Costa Rica'));
options.add(new SelectOption('Cote Divoire','Cote Divoire'));
options.add(new SelectOption('Croatia (lHrvatska)','Croatia (lHrvatska)'));
options.add(new SelectOption('Cyprus','Cyprus'));
options.add(new SelectOption('Czech Republic','Czech Republic'));
options.add(new SelectOption('Denmark','Denmark'));
options.add(new SelectOption('Dominica','Dominica'));
options.add(new SelectOption('Dominican Republic','Dominican Republic'));
options.add(new SelectOption('Ecuador','Ecuador'));
options.add(new SelectOption('Egypt','Egypt'));
options.add(new SelectOption('El Salvador','El Salvador'));
options.add(new SelectOption('Estonia','Estonia'));
options.add(new SelectOption('Ethiopia','Ethiopia'));
options.add(new SelectOption('Fiji','Fiji'));
options.add(new SelectOption('Finland','Finland'));
options.add(new SelectOption('France','France'));
options.add(new SelectOption('French polynesia','French polynesia'));
options.add(new SelectOption('French Southern Territories','French Southern Territories'));
options.add(new SelectOption('Gambia','Gambia'));
options.add(new SelectOption('Georgia','Georgia'));
options.add(new SelectOption('Germany','Germany'));
options.add(new SelectOption('Ghana','Ghana'));
options.add(new SelectOption('Gibraltar','Gibraltar'));
options.add(new SelectOption('Greece','Greece'));
options.add(new SelectOption('Greenland','Greenland'));
options.add(new SelectOption('Grenada','Grenada'));
options.add(new SelectOption('Guadeloupe','Guadeloupe'));
options.add(new SelectOption('Guam','Guam'));
options.add(new SelectOption('Guatemala','Guatemala'));
options.add(new SelectOption('Guinea','Guinea'));
options.add(new SelectOption('Guyana','Guyana'));
options.add(new SelectOption('Haiti','Haiti'));
options.add(new SelectOption('Honduras','Honduras'));
options.add(new SelectOption('Hong Kong','Hong Kong'));
options.add(new SelectOption('Hungary','Hungary'));
options.add(new SelectOption('Iceland','Iceland'));
options.add(new SelectOption('India','India'));
options.add(new SelectOption('Indonesia','Indonesia'));
options.add(new SelectOption('Iran (islamic republic of','Iran (islamic republic of)'));
options.add(new SelectOption('Iraq','Iraq'));
options.add(new SelectOption('Ireland','Ireland'));
options.add(new SelectOption('Israel','Israel'));
options.add(new SelectOption('Italy','Italy'));
options.add(new SelectOption('Jamaica','Jamaica'));
options.add(new SelectOption('Japan','Japan'));
options.add(new SelectOption('Jordan','Jordan'));
options.add(new SelectOption('Kenya','Kenya'));
options.add(new SelectOption('Korea','Korea'));
options.add(new SelectOption('Lao','Lao'));
options.add(new SelectOption('Latvia','Latvia'));
options.add(new SelectOption('Lebanon','Lebanon'));
options.add(new SelectOption('Liberia','Liberia'));
options.add(new SelectOption('Lithuania','Lithuania'));
options.add(new SelectOption('Luxembourg','Luxembourg'));
options.add(new SelectOption('Macau','Macau'));
options.add(new SelectOption('Macedonia','Macedonia'));
options.add(new SelectOption('Malaysia','Malaysia'));
options.add(new SelectOption('Malta','Malta'));
options.add(new SelectOption('Marshall Islands','Marshall Islands'));
options.add(new SelectOption('Martinique','Martinique'));
options.add(new SelectOption('Mexico','Mexico'));
options.add(new SelectOption('Monaco','Monaco'));
options.add(new SelectOption('Mongolia','Mongolia'));
options.add(new SelectOption('Montenegro','Montenegro'));
options.add(new SelectOption('Morocco','Morocco'));
options.add(new SelectOption('Namibia','Namibia'));
options.add(new SelectOption('Nepal','Nepal'));
options.add(new SelectOption('Netherlands','Netherlands'));
options.add(new SelectOption('New Zealand','New Zealand'));
options.add(new SelectOption('Nicaragua','Nicaragua'));
options.add(new SelectOption('Niger','Niger'));
options.add(new SelectOption('Nigeria','Nigeria'));
options.add(new SelectOption('Norfolk Island','Norfolk Island'));
options.add(new SelectOption('Norway','Norway'));
options.add(new SelectOption('Pakistan','Pakistan'));
options.add(new SelectOption('Panama','Panama'));
options.add(new SelectOption('Papua New Guinea','Papua New Guinea'));
options.add(new SelectOption('Paraguay','Paraguay'));
options.add(new SelectOption('Peru','Peru'));
options.add(new SelectOption('Philippines','Philippines'));
options.add(new SelectOption('Poland','Poland'));
options.add(new SelectOption('Portugal','Portugal'));
options.add(new SelectOption('Puerto Rico','Puerto Rico'));
options.add(new SelectOption('Qatar','Qatar'));
options.add(new SelectOption('Romania','Romania'));
options.add(new SelectOption('Russian Federation','Russian Federation'));
options.add(new SelectOption('Rwanda','Rwanda'));
options.add(new SelectOption('Saint Lucia','Saint Lucia'));
options.add(new SelectOption('Samoa','Samoa'));
options.add(new SelectOption('Saudi Arabia','Saudi Arabia'));
options.add(new SelectOption('Senegal','Senegal'));
options.add(new SelectOption('Serbia','Serbia'));
options.add(new SelectOption('Seychelles','Seychelles'));
options.add(new SelectOption('Singapore','Singapore'));
options.add(new SelectOption('Slovakia (Slovak Republic)','Slovakia (Slovak Republic)'));
options.add(new SelectOption('Slovenia','Slovenia'));
options.add(new SelectOption('Solomon Islands','Solomon Islands'));
options.add(new SelectOption('South Africa','South Africa'));
options.add(new SelectOption('Spain','Spain'));
options.add(new SelectOption('Sri Lanka','Sri Lanka'));
options.add(new SelectOption('Sudan','Sudan'));
options.add(new SelectOption('Swaziland','Swaziland'));
options.add(new SelectOption('Sweden','Sweden'));
options.add(new SelectOption('Switzerland','Switzerland'));
options.add(new SelectOption('Syrian Arab Republic','Syrian Arab Republic'));
options.add(new SelectOption('Taiwan','Taiwan'));
options.add(new SelectOption('Tanzania','Tanzania'));
options.add(new SelectOption('Thailand','Thailand'));
options.add(new SelectOption('Tokelau','Tokelau'));
options.add(new SelectOption('Tonga','Tonga'));
options.add(new SelectOption('Trinidad and Tobago','Trinidad and Tobago'));
options.add(new SelectOption('Turkey','Turkey'));
options.add(new SelectOption('Uganda','Uganda'));
options.add(new SelectOption('Ukraine','Ukraine'));
options.add(new SelectOption('United Arab Emirates','United Arab Emirates'));
options.add(new SelectOption('United Kingdom','United Kingdom'));
options.add(new SelectOption('Uruguay','Uruguay'));
options.add(new SelectOption('Uzbekistan','Uzbekistan'));
options.add(new SelectOption('Venezuela','Venezuela'));
options.add(new SelectOption('Viet Nam','Viet Nam'));
options.add(new SelectOption('Virgin Islands (British)','Virgin Islands (British)'));
options.add(new SelectOption('Virgin Islands (U.S.)','Virgin Islands (U.S.)'));
options.add(new SelectOption('Zaire','Zaire'));
options.add(new SelectOption('Zambia','Zambia'));
options.add(new SelectOption('Zimbabwe','Zimbabwe'));
options.add(new SelectOption('Other','Other'));
return options;
}

public List<SelectOption> getStates() {
List<SelectOption> options = new List<SelectOption>(); 
options.add(new SelectOption('',''));
options.add(new SelectOption('Alabama','Alabama'));
options.add(new SelectOption('Alaska','Alaska'));
options.add(new SelectOption('Alberta','Alberta'));
options.add(new SelectOption('Arizona','Arizona'));
options.add(new SelectOption('Arkansas','Arkansas'));
options.add(new SelectOption('British Columbia','British Columbia'));
options.add(new SelectOption('California','California'));
options.add(new SelectOption('Colorado','Colorado'));
options.add(new SelectOption('Connecticut','Connecticut'));
options.add(new SelectOption('Delaware','Delaware'));
options.add(new SelectOption('District of Columbia','District of Columbia'));
options.add(new SelectOption('Florida','Florida'));
options.add(new SelectOption('Georgia','Georgia'));
options.add(new SelectOption('Hawaii','Hawaii'));
options.add(new SelectOption('Idaho','Idaho'));
options.add(new SelectOption('Illinois','Illinois'));
options.add(new SelectOption('Indiana','Indiana'));
options.add(new SelectOption('Iowa','Iowa'));
options.add(new SelectOption('Kansas','Kansas'));
options.add(new SelectOption('Kentucky','Kentucky'));
options.add(new SelectOption('Louisiana','Louisiana'));
options.add(new SelectOption('Maine','Maine'));
options.add(new SelectOption('Manitoba','Manitoba'));
options.add(new SelectOption('Maryland','Maryland'));
options.add(new SelectOption('Massachusetts','Massachusetts'));
options.add(new SelectOption('Michigan','Michigan'));
options.add(new SelectOption('Minnesota','Minnesota'));
options.add(new SelectOption('Mississippi','Mississippi'));
options.add(new SelectOption('Missouri','Missouri'));
options.add(new SelectOption('Montana','Montana'));
options.add(new SelectOption('Nebraska','Nebraska'));
options.add(new SelectOption('Nevada','Nevada'));
options.add(new SelectOption('New Brunswick','New Brunswick'));
options.add(new SelectOption('New Hampshire','New Hampshire'));
options.add(new SelectOption('New Jersey','New Jersey'));
options.add(new SelectOption('New Mexico','New Mexico'));
options.add(new SelectOption('New York','New York'));
options.add(new SelectOption('Newfoundland','Newfoundland'));
options.add(new SelectOption('North Carolina','North Carolina'));
options.add(new SelectOption('North Dakota','North Dakota'));
options.add(new SelectOption('North West Territories','North West Territories'));
options.add(new SelectOption('Nova Scotia','Nova Scotia'));
options.add(new SelectOption('Ohio','Ohio'));
options.add(new SelectOption('Oklahoma','Oklahoma'));
options.add(new SelectOption('Ontario','Ontario'));
options.add(new SelectOption('Oregon','Oregon'));
options.add(new SelectOption('Pennsylvania','Pennsylvania'));
options.add(new SelectOption('Prince Edward Island','Prince Edward Island'));
options.add(new SelectOption('Quebec','Quebec'));
options.add(new SelectOption('Puerto Rico','Puerto Rico'));
options.add(new SelectOption('Rhode Island','Rhode Island'));
options.add(new SelectOption('Saskatchewan','Saskatchewan'));
options.add(new SelectOption('South Carolina','South Carolina'));
options.add(new SelectOption('South Dakota','South Dakota'));
options.add(new SelectOption('Tennessee','Tennessee'));
options.add(new SelectOption('Texas','Texas'));
options.add(new SelectOption('Utah','Utah'));
options.add(new SelectOption('Vermont','Vermont'));
options.add(new SelectOption('Virginia','Virginia'));
options.add(new SelectOption('Washington','Washington'));
options.add(new SelectOption('West Virginia','West Virginia'));
options.add(new SelectOption('Wisconsin','Wisconsin'));
options.add(new SelectOption('Wyoming','Wyoming'));
options.add(new SelectOption('Yukon','Yukon'));
options.add(new SelectOption('Other','Other'));
return options;
} */
    
    public boolean isValidEmailAddress(String emailAddr) {
        boolean isValid = false;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!\'}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = emailPattern.matcher(emailAddr);
        if (emailMatcher.matches()) {
            isValid = true;
            return isValid;
        }
        System.debug('isValid:'+isValid);
        return isValid;
    }
    
    public void checkValidationErrors()
    {
        
        System.debug('checkValidationErrors');
        if(String.isBlank(siteId)){
            siteIdError = System.Label.CCF_SiteIdError;
            errorFound = true;
            System.debug('In siteIdError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please fill in the required fields.'));
        }
        if(String.isBlank(firstName)){
            firstNameError = System.Label.CCF_FirstNameError ;
            errorFound = true;
            System.debug('In firstNameError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for First Name'));
        }
        if(String.isBlank(lastName)){
            lastNameError = System.Label.CCF_LastNameError ;
            errorFound = true;
            System.debug('In lastNameError');
            // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Last Name'));
        }
        if(String.isBlank(company)){
            companyError = System.Label.CCF_CompanyError ;
            errorFound = true;
            System.debug('In companyError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Company'));
        }
        if(String.isBlank(addressText)){
            addressError = System.Label.CCF_AddressError;
            errorFound = true;
            System.debug('In addressError');
            // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Address'));
        }
        if(String.isBlank(country)){
            countryError = System.Label.CCF_CountryError;
            errorFound = true;
            System.debug('In countryError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Country'));
        }
        if(String.isBlank(city)){
            cityError = System.Label.CCF_CityError ;
            errorFound = true;
            System.debug('In cityError');
            // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for City'));
        }
        if(String.isBlank(postal_zip_code)){
            zipCodeError = System.Label.CCF_ZipCodeError;
            errorFound = true;
            System.debug('In zipCodeError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Postal/ZipCode'));
        }
        if(String.isBlank(telePhNo)){
            telephError =  System.Label.CCF_TelePhoneError;
            errorFound = true; 
            System.debug('In telephError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Telephone Number'));
        }
        if(String.isBlank(email_address)){
            emailAddressError = System.Label.CCF_EmailReqError;
            errorFound = true;
            System.debug('In emailAddressError');
            // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Email Address'));
        } else if(! isValidEmailAddress(email_address) ){
            emailAddressError = System.Label.CCF_ValidEmailError;
            errorFound = true;
            System.debug('In emailAddressError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide a valid Email Address'));
        }
        if(String.isBlank(request_type)){
            requestTypeError = System.Label.CCF_RequestTypeError ;
            errorFound = true;
            System.debug('In requestTypeError');
            //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Request Type'));
        }
        
        if(isLicensing) {
            if(String.isBlank(lic_your_question)){
                licyqError = System.Label.CCF_YourQuestError;
                errorFound = true;
                System.debug('In licyqError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Your Questions'));
            }
            if(String.isBlank(product_name)){
                prodNameError = System.Label.CCF_ProductNameError;
                errorFound = true;
                System.debug('In errorFound');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Product Name'));
            }
            /*if(String.isBlank(release)){
Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Release'));
}*/
            if(String.isBlank(licensing_type)){
                licTypeError = System.Label.CCF_LicTypeError ;
                errorFound = true;
                System.debug('In licTypeError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value Type of Licensing '));
            } 
        } 
        else if( isGeneralQuestions){
            if(String.isBlank(general_your_question)){
                genyqError = System.Label.CCF_YourQuestError;
                errorFound = true;
                System.debug('In genyqError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Your Questions'));
            }
        }
        else if ( isCASupportPortal){
            if(String.isBlank(portal_your_question)){
                caspyqError = System.Label.CCF_YourQuestError;
                errorFound = true;
                System.debug('In caspyqError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Your Questions'));
            }
        }
        else if ( isCAPartnerRequest ) {
            if(String.isBlank(caPartReq_your_question)){
                capryqError = System.Label.CCF_YourQuestError;
                errorFound = true;
                System.debug('In capryqError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Your Questions'));
            }
            if(String.isBlank(is_partner_registered)){
                ispartnerRegError = System.Label.CCF_IsPartnerRegError;
                errorFound = true;
                System.debug('In ispartnerRegError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please select if the Partner Registration is done on ca.com'));
            }
            /*if(String.isBlank(best_method_of_contact)){
conatctMethodError = 'Please provide the value  for the best method of contact' ;
errorFound = true;
//Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value  for the best method of contact'));  //TODO: Reword the error message
}*/
        } else if( isCAEduSupport ) {
            if(String.isBlank(caEduSup_your_question)){
                caeduyqError = System.Label.CCF_YourQuestError ;
                errorFound = true;
                System.debug('In caeduyqError');
                //Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Please provide the value for Your Questions'));
            }
        }
        
        
        
    }
    // Create properties for the non-VF component input fields generated
    // by the reCAPTCHA JavaScript.
    public String response  { 
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }
    private boolean validateCaptcha(){
        // On first page load, form is empty, so no request to make yet
        if (  response == null ) { 
            System.debug('reCAPTCHA verification attempt with empty form');
            return false; 
        }
        
        HttpResponse res = makeRequest(baseUrl,
                                       'secret=' + privateKey + 
                                       '&remoteip='  + remoteHost + 
                                       '&response='  + response
                                      );
        Util_JSONParser parserUtil = Util_JSONParser.createParser(res.getBody());
        String resStatus = parserUtil.get('success').Value;
        System.debug('resStatus='+resStatus);
        if (resStatus=='true')
            return true;
        else
            return false;    
        
    }
    
    public PageReference save() {
        System.debug('In submit()');
        isLicensing = false;
        isGeneralQuestions = false;
        isCASupportPortal = false;
        isCAPartnerRequest = false;
        isCAEduSupport = false;
        
        resetErrors();
        
        
        if(request_type == System.Label.CCF_CA_Licensing) isLicensing = true;
        else if( request_type ==  System.Label.CCF_General_Questions ) isGeneralQuestions = true;
        else if( request_type == System.Label.CCF_CA_Support_Portal ) isCASupportPortal = true;
        else if( request_type == System.Label.CCF_CA_Partner_Request ) isCAPartnerRequest = true;
        else if( request_type == System.Label.CCF_CA_Education_Support )  isCAEduSupport = true;
        
        checkValidationErrors();
        fromSaveExecutionPath = true;
        
        System.debug('In save() after checkValidationErrors,errorFound:'+errorFound);
        System.debug('In save(),countryName:'+countryName);
        
        Boolean captcha=validateCaptcha();
        if (captcha){
            System.debug('Captcha Success');
            //if(!(ApexPages.hasMessages())){
            if( ! errorFound){
                createCaseAndSendEmail();
            }
        }else{    
            System.debug('Captcha Failed');
            captchaError = 'Captcha not verified successfully';
        }
        
        System.debug('hasAttachmentsToAdd:'+hasAttachmentsToAdd);
        /*if( hasAttachmentsToAdd == 'No' ){
            //showFirstForm = true;
           // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'Test in No block' ));
            return null;
        } else */ 
        
        
        
        if( caseNumber != null && hasAttachmentsToAdd == System.Label.CCF_Yes ) { 
            System.debug('caseNumber:'+caseNumber);
           // if(caseNumber != null){
                PageReference pr = new PageReference('/apex/CustomerCareFormAttachment');
                pr.setRedirect(false);
                return pr;
           /* }
            else {
                    ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Case Number is null. Please contact customer care team.') );
                    return null;
            }      */                  
        }        
         return null;
    }
    
    
    
    public void createCaseAndSendEmail(){
        try{           
            
            Case caseRec = new Case();
            System.debug('isAnonymousUser :'+isAnonymousUser);
            /*if(! isAnonymousUser){
caseRec.ContactId = currentUser.contactId;  
List<Site_Association__c> siteAssoc = [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c =: siteId and SC_SITE_Sanctioned_Party__c = 'No' limit 1];
if( !siteAssoc.isEmpty() && siteAssoc.size()>0 ){
caseRec.Site_Association__c = siteAssoc[0].Id; 
} else {
caseRec.Site_Association__c = CC_Settings.defaultSiteIDforNoAccess;
}
}
else {
caseRec.ContactId = CC_Settings.missingContactId; //TODO: Missing Contact   - Confirm this
caseRec.Site_Association__c = CC_Settings.defaultSiteIDforNoAccess;
}*/
            
            /*if(! isAnonymousUser){
                caseRec.ContactId = currentUser.contactId;                                   
            }
            else {
                caseRec.ContactId = CC_Settings.missingContactId; //TODO: Missing Contact   - Confirm this
            } */
            caseRec.ContactId = CC_Settings.missingContactId;
            List<Site_Association__c> siteAssoc = [SELECT Id, Name, SC_TOPS_ID__c FROM Site_Association__c WHERE SC_TOPS_ID__c =: siteId and SC_SITE_Sanctioned_Party__c = 'No' limit 1];
            if( !siteAssoc.isEmpty() && siteAssoc.size()>0 ){
                caseRec.Site_Association__c = siteAssoc[0].Id; 
            } else {
                caseRec.Site_Association__c = CC_Settings.defaultSiteIDforNoAccess;
            }
            
            
            caseRec.Severity__c = '4' ;
            
            caseRec.Case_Type__c = System.Label.CCF_CaseType; //'Standard';
            caseRec.Origin = System.Label.CCF_CaseOrigin ; //'Community';
            //caseRec.Troubleshooting_Stage__c =
            
            if(isLicensing){    
                caseRec.Description = System.Label.CCF_c_Your_Question + ':'+ lic_your_question ;
                if(licensing_type == System.Label.CCF_ALP_Keys ) {
                    caseRec.Subject =  System.Label.CCF_c_Submit_Question + ' - ' + System.Label.CCF_c_CA_Licensing_ALP ;
                    caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                    caseRec.CA_Product_Component__c = CC_Settings.componentALPKEY ; 
                }
                else if(licensing_type == System.Label.CCF_LMP_Keys ) {
                    caseRec.Subject =  System.Label.CCF_c_Submit_Question + ' - ' + System.Label.CCF_c_CA_Licensing_LMP;
                    caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                    caseRec.CA_Product_Component__c =  CC_Settings.comLPMKEY ;  
                }
                else if(licensing_type ==  System.Label.CCF_All_Other_Keys ) {
                    caseRec.Subject =  System.Label.CCF_c_Submit_Question + ' - ' + System.Label.CCF_c_General_CA_Licensing;
                    caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                    caseRec.CA_Product_Component__c =  CC_Settings.componentTLC ;
                }
            }
            else if(isGeneralQuestions){
                caseRec.Description = System.Label.CCF_c_Your_Question + ':'+ general_your_question ;
                caseRec.Subject =  System.Label.CCF_c_Submit_General_Question ;
                caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                caseRec.CA_Product_Component__c =  CC_Settings.componentGSCOTH ;
            }
            else if(isCASupportPortal){
                caseRec.Description = System.Label.CCF_c_Your_Question + ':'+ portal_your_question ;
                caseRec.Subject =  System.Label.CCF_c_Submit_Question + ' - ' + System.Label.CCF_c_CA_Support_Portal ;
                caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                caseRec.CA_Product_Component__c =  CC_Settings.comSCNECT;
            }
            else if(isCAPartnerRequest) {
                caseRec.Description = System.Label.CCF_c_Your_Question + ':'+ caPartReq_your_question ;
                caseRec.Subject =  System.Label.CCF_c_Submit_Question + ' - ' + System.Label.CCF_CA_Partner_Request ;
                caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                caseRec.CA_Product_Component__c =  CC_Settings.componentGSCPRM;
            } 
            else if(isCAEduSupport) {
                caseRec.Description = System.Label.CCF_c_Your_Question + ':'+ caEduSup_your_question ;
                caseRec.Subject =  System.Label.CCF_c_Submit_Question + ' - ' + System.Label.CCF_CA_Education_Support ;
                caseRec.CA_Product_Controller__c = CC_Settings.prodGSCId;
                caseRec.CA_Product_Component__c =  CC_Settings.componentGSCLMS;
            }
            
            System.debug('before case insert dml: caseRec:\n'+caseRec);
            if(caseRec.ContactId == null) {
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, System.Label.CCF_ContactError )); //'ContactId cannot be empty to create a case'
            }
            insert caseRec;
            
            Case newCase = [select id,caseNumber,Site_Id__c from case where id = :caseRec.id];
            System.debug('caseRec, id:'+caseRec.Id + 'case#:'+newCase.caseNumber);
            caseNumber = newCase.caseNumber;
            System.debug('After case insert: caseNumber:'+caseNumber);
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, System.Label.CCF_SuccessInfo1 + System.Label.CCF_SuccessInfo2 + ' ' + newCase.caseNumber +'.' + System.Label.CCF_SuccessInfo3 ));
            String commentText = prepareCommentBody();
            CaseComment commentRec = new CaseComment();
            commentRec.CommentBody = commentText;
            commentRec.ParentId = newCase.Id;
            commentRec.IsPublished = true; //TODO: confirm on this parameter
            
            insert commentRec;
            System.debug('commentRec.Id:'+commentRec.Id);
            
            sendEmailForCaseCreation(newCase.caseNumber);
           /* System.debug('*** attachmentRec:'+attachmentRec+'*');

            if(attachmentRec.body != null){
                Blob b1 = attachmentRec.body;
                System.debug('b1.size():'+b1.size());
                System.debug('Before attachFilesToCase method');
                if(b1.size()>0){
                    attachFilesToCase(attachmentRec,newCase.caseNumber);
                }
                    //attachFilesToCase(attachmentRec,newCase.Id,newCase.caseNumber);
            } */
            
            
        } catch(Exception e) {
            System.debug('Exception Message:'+e.getMessage());
            System.debug('Exception Stacktrace:'+e.getStackTraceString());
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        
        
    }
    
    public String prepareCommentBody() {
        System.debug('In prepareCommentBody');
        String commentBody = '';
        
        commentBody =  'Site ID: ' + siteId ;
        commentBody +=  '\n' +System.Label.CCF_c_Name + ': ' + firstName + ' ' + lastName;
        commentBody += '\n' + System.Label.CCF_c_Company + ':' + company ;
        commentBody += '\n' + System.Label.CCF_c_Address + ':' + addressText;
        commentBody += '\n' + System.Label.CCF_c_Country + ':' + countryName;
        commentBody += '\n' + System.Label.CCF_c_City + ':' + city;
        commentBody +='\n' + System.Label.CCF_c_State + ':' + state_province;
        commentBody += '\n' + System.Label.CCF_c_Postal_Zip_Code + ':'+ postal_zip_code;
        commentBody += '\n' + System.Label.CCF_c_tele + ':' + telePhNo;
        commentBody += '\n' + System.Label.CCF_c_Email + ':' + email_address;
        
        if(isCASupportPortal) {
            commentBody += '\n' +System.Label.CCF_c_Your_Question + ':'+ portal_your_question;
        }   
        if(isGeneralQuestions){
            commentBody += '\n' +System.Label.CCF_c_Your_Question + ':'+ general_your_question;
        }
        
        if(isLicensing) {
            commentBody += '\n' +System.Label.CCF_c_Your_Question + ':'+ lic_your_question;
            commentBody += '\n' + System.Label.CCF_c_Product_Name + ':'+ product_name;
            commentBody += '\n' + System.Label.CCF_c_Release + ':'+ release;
            commentBody += '\n' + System.Label.CCF_c_LicType + ':'+ licensing_type ;
        } else if( isCAPartnerRequest) {
            commentBody +=  '\n' +System.Label.CCF_c_Your_Question + ':'+ caPartReq_your_question;
            commentBody +=  '\n' + System.Label.CCF_c_Partner_Reg_Completed + ' :' + is_partner_registered ;
            commentBody +=  '\n' + System.Label.CCF_c_EmailUsed + ' :' + emailAddress_used ;
            commentBody +=  '\n' + System.Label.CCF_c_Organization_ID +' : ' + organizationId ;
            //commentBody +=  '\n' + System.Label.CCF_c_Best_Method_of_contact + ' :' + best_method_of_contact;
            /* if(method_of_contact_phone != null) {  //TODO: Check this ***
commentBody += '\tPhone:' +  method_of_contact_phone;
} if(method_of_contact_email != null) {
commentBody += '\tEmail:' +  method_of_contact_email;
}*/
        } else if ( isCAEduSupport ){
            commentBody +=  '\n' + System.Label.CCF_c_Your_Question + ':'+ caEduSup_your_question;
            commentBody +=  '\n' + System.Label.CCF_c_Class_Name + ' : ' + course_name ;
            commentBody +=  '\n' + System.Label.CCF_c_Class_Number + ' : ' + course_number ;
            commentBody +=  '\n' + System.Label.CCF_c_Date_of_the_class + ' : ' + date_of_class ;
            commentBody +=  '\n' + System.Label.CCF_c_Class_Location + ' : ' + class_location ;
            commentBody +=  '\n' + System.Label.CCF_c_Operating_System + ' : '+ operating_system ;
            commentBody +=  '\n' + System.Label.CCF_c_Browser + ' : ' + browser ;
            commentBody +=  '\n' + System.Label.CCF_c_JavaVersion + ' : ' + java_version ;
            commentBody +=  '\n' + System.Label.CCF_c_Contact_Instruction + ' : ' + contact_instruction ;
        }                
        
        
        
        return commentBody;
    }
    
    public void sendEmailForCaseCreation(String caseNumber){
        System.debug('In sendEmail,email_address:'+email_address);
        List<String> toAddressList = new List<String>();
        toAddressList.add(email_address);
        System.debug('toAddressList:'+toAddressList);
        String emailBody = '<html><body>' + System.Label.CCF_EmailInfo1 + System.Label.CCF_EmailInfo2 + ' ' + caseNumber +'.';
        emailBody += ' <br> <br>' + System.Label.CCF_EmailInfo3 ;
        emailBody += '<br> <br>  '+ System.Label.CCF_Thankyou + '<br>' + System.Label.CCF_CACustomerCare + '</body> </html>';
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = : System.Label.CCF_FromEmailID];
        if ( owea.size() > 0 ) {
            email.setOrgWideEmailAddressId(owea.get(0).Id);
        }        
        //email.FromAddress('CATechnicalSupport@ca.com');
        email.setToAddresses(toAddressList);
        email.setSubject( System.Label.CCF_EmailSubject1 + ' ' + caseNumber + ' ' + System.Label.CCF_EmailSubject2 );
        email.setHTMLBody(emailBody);
        email.setSaveAsActivity(false);
        
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { email} );
    }
    
    //public void attachFilesToCase(Attachment attachmentRec,Id caseId,String caseNumber){
    public void attachFilesToCase(Attachment attachmentRec,String caseNumber){
        
        String[] toAddressList = new String[]{  System.Label.CCF_E2C_Email_ID }; // System.Label.CCF_E2C_Email_ID, //'eaie2c-pcsdesk-maint@ca.com','manar08@ca.com'
            System.debug('In attachFilesToCase, toAddressList:'+toAddressList);
        
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        
        Blob b = attachmentRec.body;
        attach.setBody(b);
        attach.setFileName(attachmentRec.Name);
        
        //email.FromAddress('CATechnicalSupport@ca.com');
        email.setToAddresses(toAddressList);
        email.setSubject( System.label.CCF_E2CSubject + ' ' + caseNumber + ' - '+ System.Label.CCF_FileAttachment );
        email.setPlainTextBody(System.Label.CCF_E2CBody);
        //email.setSaveAsActivity(false);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { email} );
    }   
    
    public void setNotificationOnPage(){
        System.debug('In setNotificationOnPage,caseNumber='+caseNumber);
        System.debug('***caseNumber:'+caseNumber);
        if(caseNumber == null){ 
            ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Case Number is null. Please contact customer care team'));
        }
    }
    
    public PageReference addAttachment(){
        System.debug('In addAttachment(), attachmentRec:'+ attachmentRec); 
        
       /* caseNumber= '00763588';
        String fileName = Apexpages.currentPage().getParameters().get('fileName');
    String fileValue = Apexpages.currentPage().getParameters().get('fileValue');
        Integer fileSize = Integer.valueOf(Apexpages.currentPage().getParameters().get('fileSize'));
        System.debug('fileName:'+fileName);
        System.debug('fileValue:'+fileValue);
        System.debug('fileSize:'+fileSize);
        */
        //System.debug('EncodingUtil.Base64Decode(base64BlobValue):'+ EncodingUtil.Base64Decode(fileValue));
        
        
       
        if(caseNumber == null){
            ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Case Number is null. Please contact customer care team.') );
            return null;
        }
        
     /*   if(fileSize > 0 ){
            
            if(fileSize > 5242880) {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Files with > 5MB cannot be attached. Please attach file of <= 5MB.'));
                } else {
                    Attachment attachmentRec = new Attachment(name= fileName , body = EncodingUtil.Base64Decode(fileValue));
                    attachFilesToCase(attachmentRec,caseNumber);
                  attachmentsNameList.add(attachmentRec.Name);
                }  
        } else if( fileSize == 0){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Files with 0 bytes cannot be attached. Please attach a valid file.'));
            } 
        
        System.debug('attachmentsNameList:'+attachmentsNameList); */
        
        
        if( attachmentRec != null && attachmentRec.body != null){
            Blob b1 = attachmentRec.body;
            System.debug('b1.size():'+b1.size());
            System.debug('Before attachFilesToCase method');
            if(b1.size()>0){
                if(b1.size() > 5242880) {
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Files with > 5MB cannot be attached. Please attach file of <= 5MB.'));
                } else {
                    attachFilesToCase(attachmentRec,caseNumber);
                  attachmentsNameList.add(attachmentRec.Name);
                }
            } else if(b1.size() == 0){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'Files with 0 bytes cannot be attached. Please attach a valid file.'));
            } 
        } 
        //Setting this to overcome the viewState error
        attachmentRec.body = null;
        
        return null;        
            /*PageReference pr = new PageReference('/apex/CustomerCareFormAttachment');
            pr.setRedirect(true);
            return pr; */          
    }
    
    public void resetErrors(){
        fromSaveExecutionPath = false;
        errorFound = false;
        siteIdError  = ''; 
        firstNameError  = '';
        lastNameError  = '';
        companyError  = '';
        addressError  = '';
        countryError  = '';
        cityError  = '';
        stateError  = '';
        zipCodeError  = '';
        telephError  = '';
        emailAddressError  = '';
        requestTypeError  = '';
        licyqError  = '';
        prodNameError  = '';
        licTypeError  = '';
        genyqError  = '';
        caspyqError  = '';
        capryqError  = '';
        ispartnerRegError  = '';
        conatctMethodError  = '';
        caeduyqError  = '';
        captchaError = '';
    }
    public void cancel() {
        System.debug('In cancel()');
        fromSaveExecutionPath = false;
        siteId = '';
        firstName = '';
        lastName = '';
        company = '';
        addressText = '';
        country = '';
        city = '';
        state_province = '';
        postal_zip_code = '';
        telePhNo = '';
        extension = '';
        email_address = '';
        request_type = '';
        
        //Details
        //your_question = '';
        lic_your_question = '';
        general_your_question = '';
        portal_your_question = '';
        caPartReq_your_question = '';
        caEduSup_your_question = '';
        product_name = '';
        release = '';
        licensing_type = '';
        is_partner_registered = '';  //partner registration on ca.com
        emailAddress_used = '';          //email address used to register
        organizationId = '';
        /* method_of_contact_phone = '';
method_of_contact_email = '';*/
        best_method_of_contact= '';
        course_name = '';
        course_number = '';
        date_of_class = '';
        class_location = '';
        operating_system = '';
        browser = '';
        java_version = '';
        contact_instruction = '';
        hasAttachmentsToAdd = '';
        
        isLicensing = false ;
        isGeneralQuestions = false;
        isCASupportPortal = false;
        isCAPartnerRequest = false;
        isCAEduSupport = false;
        
    }
    /* Private helper methods */
    
    private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            response = http.send(req);
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    }   
    
    private String remoteHost { 
        get { 
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            if (hdrs.get('x-original-remote-addr')!= null)
                ret =  hdrs.get('x-original-remote-addr');
            else if (hdrs.get('X-Salesforce-SIP')!= null)
                ret =  hdrs.get('X-Salesforce-SIP');
            return ret;
        }
    }
       
}