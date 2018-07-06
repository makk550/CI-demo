global class PartnerDetailsController extends PartnerFinderBaseController implements SObjectPaginatorListener{

    //==================================================
    // PROPERTIES
    //==================================================
    private static final Integer DEFAULT_PAGE_SIZE = 5;
     
    // EMAIL FIELDS
    public String senderEmailFullName {get; set;}
    public String senderEmailAddress {get; set;}
    public String senderEmailSubject {get; set;}
    public String senderEmailBody {get; set;}
    
    // PAGE LOAD ERROR CODES
    public String EMPTY_ID_PARAM { get{ return 'EMPTY_ID_PARAM'; }}
    public String RECORD_NOT_FOUND { get{ return 'RECORD_NOT_FOUND'; }}
    public String ACCESS_DENIED { get{ return 'ACCESS_DENIED'; }}
    public String DELETE_FAILED { get{ return 'DELETE_FAILED'; }}
    public String TERMS_REQUIRED { get{ return 'TERMS_REQUIRED'; }}
    
    
    public Boolean isIE{get{return PageUtils.isIE();}}  
    public String errorCode {get;private set;}
    public Boolean errorOccurred {get{ return StringUtils.isNotEmpty(this.errorCode); }}
    public Boolean isCurrentUserAdmin {get;set;}
    public String googleMapsApiKey {get;set;}
    public String recordId {get;set;}
    public Partner partnerRecord {get;set;} 
    public List<Location> locations {get;set;}
    public String locationsInJson {get;set;}
    public SObjectPaginator locationPaginator {get;set;} 
    public String selectedLocation {get;set;}
    public List<FormField> partnerDetailFieldsBasic    {get; set;}
    public List<FormField> partnerDetailFieldsOverview {get; set;}
    public PartnerSearchCriteria searchCriteria {get; set;}
    public Boolean checkAgreement{get; set;}
    public String deleteLocationId{get; set;}
    public Account accountForID{get; set;}
    public String activeTab {get;set;}
    
    private User currentUser = null;
    public Configuration                config                      {get; private set;} 
    
    private static Set<String> accFieldsOverview;
    private static Set<String> accFieldsBasic;
    private static Set<String> locationFields;
    private static ID selectedLocationId;
    private static Map<String,Set<String>> fieldMapLocationStatic = new Map<String,Set<String>>();
    private static Map<String,Set<String>> fieldMapBasic = new Map<String,Set<String>>();
    private static Map<String,Set<String>> fieldMapOverview = new Map<String,Set<String>>();
    private static Map<String, Schema.SObjectField> detailFields=null;
    private String recordIdType;
    private SObject recordToEdit;
    private PartnerSearch partnerSearch;
    private Map<String,Set<String>> fieldMapLocation = new Map<String,Set<String>>();
    private List<FormField> editFields = null;
    private List<String> additionalMessages;
    private Partner_Location__c partnerContactLocation=null; 

    
    //==================================================
    // CONSTRUCTOR  
    //==================================================
    public PartnerDetailsController(){
        this.recordId = PageUtils.param('id');
    }

    //==================================================
    // ACTIONS
    //==================================================
    public PageReference doOnLoad(){
        this.config = Configuration.getInstance();
        try{
            this.currentUser = [
                select Contact.AccountId,Is_Admin_for_Partner_Finder_Profile__c 
                from User where id = :Userinfo.getUserId()];
        }catch(QueryException e){}
        if(StringUtils.isEmpty(this.recordId)){
            this.recordId = this.currentUser.Contact.AccountId;
        }
        
        this.additionalMessages             = new List<String>();
        String accountId = null;
        initialize();
        //DETERMINE ENTRY POINT
        //  Is the ID an account id or a location id? 
        final String idPrefix = StringUtils.defaultString(StringUtils.substring(this.recordId, 0, 3));
        if(idPrefix.equals(Account.sObjectType.getDescribe().getKeyPrefix())){
            //is an Account ID
            accountId = this.recordId;
            
        } else if(idPrefix.equals(Partner_Location__c.sObjectType.getDescribe().getKeyPrefix())){
            //is a Location ID
            accountId = getAccountIDFromLocationID(this.recordId);
            selectedLocation = this.recordId;
            selectedLocationId = this.recordId;
        }
        Account accountForCurrentUser = loadAccount(UserUtils.getCurrentUserPortalAccountID());
        this.accountForID = loadAccount(accountId);
        Account accountToView=null;
        if(this.accountForID == null){
            if(accountForCurrentUser == null){
                //PageUtils.addInfo('Empty Id');
                return error(EMPTY_ID_PARAM);
            }
            accountToView = accountForCurrentUser;
        } else {
            accountToView = this.accountForID;
        }
        if(accountToView.IsPartner == false || accountToView.Approved_for_Partner_Finder__c == false){
            return error(ACCESS_DENIED);
        }

        
        this.isCurrentUserAdmin = currentUser == null ? false : 
            (currentUser.Contact.AccountID == accountToView.id && currentUser.Is_Admin_for_Partner_Finder_Profile__c);
        
        // REMOVE this **************************
        //this.isCurrentUserAdmin=true;
        
        if(StringUtils.isNotEmpty(this.config.termsAndConditionsUrl) 
            && StringUtils.isEmpty(accountToView.Partner_User_Agreed_to_PF_Terms_Cond__c)){
            if(this.isCurrentUserAdmin){
                return error(TERMS_REQUIRED); 
            } else {
                return error(ACCESS_DENIED);
            }
        }
        this.partnerRecord = Partner.build(accountToView,this.config);

        this.partnerDetailFieldsBasic = FormField.populateFields(
            FormField.build(this.config.detailScreenCompanyBasicFields),accountToView);
        this.partnerDetailFieldsOverview = FormField.populateFields(
            FormField.build(this.config.detailScreenCompanyExtendedFields),accountToView);

        this.fieldMapLocation=fieldMapLocationStatic;
        this.partnerContactLocation = getPartnerContactLocation();
        this.locationPaginator = new SObjectPaginator(DEFAULT_PAGE_SIZE,this);
        this.locationPaginator.setRecords(accountToView.Partner_Locations__r);
        return null;
    }
    
    public PageReference clickTab(){
        this.activeTab = PageUtils.param('tab');    
        return null;
    }
    
    public PageReference cancelDetail(){
        return backToPartnerDetails();
    }
    
    public PageReference backToPartnerDetails(){
        PageReference pageRef = Page.PartnerDetails;
        pageRef.setRedirect(false);
        pageRef.getParameters().put('id',this.recordId);
        pageRef.getParameters().put('random', String.valueOf(DateTime.now().getTime()));//PRM5.5 - By-pass using cached logo display.
        return pageRef;
    }
    
    public PageReference saveDetail(){
        additionalMessages.clear();
        if(recordToEdit!=null){
            FormField.populateSObject(recordToEdit,this.editFields);
            Database.Saveresult result = null;
            try{
                result = Database.update(recordToEdit);
            }catch(Exception e){
                return null;
            }
            if(result != null && result.isSuccess()){
                this.additionalMessages.add(Label.msgdetailrecordedited);
            } else {
                this.additionalMessages.add(Label.msgdetailrecordnotedited);
            }
        } else {
            this.additionalMessages.add(Label.internal_error_record_not_found);
        }
        return backToPartnerDetails();
    }
    
    public PageReference cancelContactEmail(){
        return cancelDetail();
    }

    public PageReference updateTermsAndContitionsStatus(){
        this.accountForID.Partner_User_Agreed_to_PF_Terms_Cond__c=Userinfo.getUserId();
        this.accountForID.Partner_Date_Agreed_to_PF_Terms_Cond__c=Datetime.now();
        Database.Saveresult result = Database.update(this.accountForID);
        if(result.isSuccess()){
            PageReference pageRef = Page.PartnerDetails;
            pageRef.setRedirect(false);
            //pageRef.getParameters().put('id',this.recordId);
            return pageRef;
        }
        return null;
    }
    
    public PageReference updatePublishStatus(){
        if(additionalMessages != null){
            additionalMessages.clear();
        }
        try{
            String param = PageUtils.param('publish');
            if('Yes'.equalsIgnoreCase(param) || 'No'.equalsIgnoreCase(param)){
                if('Yes'.equalsIgnoreCase(param)){
                    //validate at least one location has been added
                    try{
                        final Integer locationCount = [select count() from Partner_Location__c where Account__c = :this.accountForID.id];    
                        if(locationCount <= 0){
                            PageUtils.addInfo(Label.your_profile_cannot_be_published_in_ord);
                            return null;
                        }
                    }catch(QueryException e){
                        PageUtils.addFatal(Label.publish_unpublish_error + e.getMessage());
                        return null;
                    }
                }
                this.accountForID.Profile_Published_to_Partner_Finder__c= param;
                this.partnerRecord = Partner.build(this.accountForID,this.config);
                Database.Saveresult result= Database.update(this.accountForID);
                if(result.isSuccess()){
                    if('Yes'.equalsIgnoreCase(param)){
                        PageUtils.addInfo(Label.msgpartnerpublished);
                    } else {
                        PageUtils.addInfo(Label.msgpartnerunpublished);
                    }
                } else {
                    if('Yes'.equalsIgnoreCase(param)){
                        PageUtils.addInfo(Label.msgpartnernotpublished);
                    } else {
                        PageUtils.addInfo(Label.msgpartnernotunpublished);
                    }
                }
            }
        } catch(Exception exp){
            PageUtils.addFatal(Label.publish_unpublish_error + exp.getMessage());
        }
        return null;
    }
    
    public PageReference sendContactEmail(){
        if(StringUtils.isEmpty(this.senderEmailSubject) || StringUtils.isEmpty(this.senderEmailBody)){
            PageUtils.addError(Label.fields_required);
            return null;
        }else{
            if(this.partnerContactLocation != null 
               && !StringUtils.isEmpty(this.partnerContactLocation.Point_of_Contact_Email__c)){
                
                User company = null;
                try{
                    company = [select CompanyName from User where id = :Userinfo.getUserId() limit 1];
                }catch(QueryException e){}
                
                EmailUtils.sendTextEmail(
                    new List<String>{this.partnerContactLocation.Point_of_Contact_Email__c}//List<String> recipients
                    ,'Message from ' 
                        + (company != null && company.CompanyName != null ? company.CompanyName : '' ) 
                        + ' \"Find a Partner\": ' 
                        + this.senderEmailSubject//String emailSubject
                    ,'From: ' 
                        + this.senderEmailFullName 
                        + ' (' 
                        + this.senderEmailAddress 
                        + ')\nSubject: ' 
                        + this.senderEmailSubject
                        + '\nMessage: ' 
                        + this.senderEmailBody//String textBody
                );
            } else {
                PageUtils.addError(Label.no_email_address_registered_for_partner);
            }
        }
        return backToPartnerDetails();
        
    }

    public PageReference deleteLocation(){
        additionalMessages.clear();
        if(!StringUtils.isEmpty(deleteLocationId)){
            Database.Deleteresult deleteResult =Database.delete(deleteLocationId);
            if(deleteResult.isSuccess()){
                List<SObject> records= this.locationPaginator.all;
                for(Integer i=0;i<records.size();i++){
                    if(deleteLocationId.equalsIgnoreCase(records.get(i).Id)){
                        PageUtils.addInfo(Label.location_deleted);
                        records.remove(i);
                        break;      
                    }
                }
                this.locationPaginator.setRecords(records);
            } else {
                PageUtils.addInfo(Label.deletion_failed);
            }
        }
        return null;
    }
    
    public PageReference skipToLocation(){
        String pageNumberParam = PageUtils.param('pageNumber');
        if(StringUtils.isNumeric(pageNumberParam)){
            this.locationPaginator.skipToPage(Integer.valueOf(pageNumberParam));
        }
        return null;
    }   
    
    public PageReference toggleEmail() {
        showEmail = !showEmail;
        if(showEmail){
            //reset form
            senderEmailFullName = null;
            senderEmailAddress = null;
            senderEmailSubject = null;
            senderEmailBody = null;
        }
        return Page.Email_Partner;
    } 
    

    public PageReference toggleEditDetail() {
        showEditDetail = !showEditDetail;
        return Page.PartnerDetailsEdit;
    }
    
    //==================================================
    // DERIVED PROPERTIES
    //==================================================
    public List<String> getMessages(){
        List<String> msgList= new List<String>();
        for(ApexPages.Message msg:ApexPages.getMessages()){
            msgList.add(msg.getSummary());
        }
        if(this.additionalMessages != null && !this.additionalMessages.isEmpty()){
            for(String msg : this.additionalMessages){
                msgList.add(msg);
            }
        }
        return msgList;
    }
    
    public String getSearchStateParams(){
         List<String> params=new List<String>();
         for(String key: ApexPages.currentPage().getParameters().keySet()){
            if(!'id'.equalsIgnoreCase(key)){
                params.add(key+'='+ApexPages.currentPage().getParameters().get(key));
            }
         }
         return StringUtils.joinArray(params,'&');
    }
    
    public void setEditFields(List<FormField> fields){
        editFields = fields;
    }
    
    public List<FormField> getEditFields(){
        if(editFields == null){
            this.setEditDetailRecord();
            editFields = FormField.populateFields(FormField.build(this.config.detailScreenEditFields),recordToEdit);
        }
        return editFields;
    }
    
    public String getTermsAndConditionsURL(){
        return config.termsAndConditionsUrl;
    }
    
    private void setEditDetailRecord(){
        this.recordToEdit = null;
        try {
            this.recordToEdit = Database.query(
                new SoqlBuilder()
                .selectx(getAccountFields())
                .fromx('Account')
                .wherex(new FieldCondition('id',this.accountForID.id))
                .toSoql());
        } catch(Exception exp){
            PageUtils.addError(Label.failed_to_load_record + exp.getMessage());
        }
    }
    
    public Partner_Location__c getPartnerContactLocation(){
        if(this.partnerContactLocation == null){
            try{
                this.partnerContactLocation = Database.query(
                    new SoqlBuilder()
                        .selectx(new Set<Object>{
                            'Id','Name','Point_of_Contact_Email__c','Point_of_Contact_Phone__c'
                            ,'Point_of_Contact_Name__c','Website__c','Street__c','State_Province__c'
                            ,'Postal_Code__c','Longitude__c','Latitude__c','Country__c','City__c'})
                        .fromx('Partner_Location__c')
                        .wherex(new FieldCondition(selectedLocationId==this.recordId  ? 'Id' : 'Account__r.Id').equals(this.recordId))
                        .orderByx(new OrderBy('Is_Primary__c').descending())
                        .limitx(1)
                        .toSoql()
                );
            }catch(QueryException e){}
        }
        return this.partnerContactLocation;
    }

    //==================================================
    // HELPER METHODS
    //==================================================
    private void  initialize(){
        this.partnerRecord                  = null;
        this.locations                      = new List<Location>();
        this.accountForID                   = null;
        this.showEmail                      = false;
        this.showEditDetail                 = false;
        this.searchCriteria                 = new PartnerSearchCriteria();
        this.activeTab                      = 'Details';
        this.isCurrentUserAdmin             = false;
        this.errorCode                      = '';

        this.googleMapsApiKey               = StringUtils.isEmpty(Site.getName()) ? this.config.googleMapsApiKey : this.config.googleMapsApiKeyForSites;
        
    }

     
    
    

    
    
    
    private Boolean sendEmail(String toEmail, String fromEmail, 
                              String senderDisplayName, String subject,
                              String content){
        // Create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Strings to hold the email addresses to which you are sending the email.
        String[] toAddresses = new String[] {toEmail}; 
        String[] ccAddresses = new String[] {};
            
        // Assign the addresses for the To and CC lists to the mail object.
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        
        // Specify the address used when the recipients reply to the email. 
        // May have to change...
        mail.setReplyTo(toEmail); 
        
        // Specify the name used as the display name.
        mail.setSenderDisplayName(senderDisplayName);
        
        // Specify the subject line for your email address.
        mail.setSubject(subject);
        
        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);
        
        // Optionally append the salesforce.com email signature to the email.
        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);
        
        // Specify the text content of the email.
        mail.setPlainTextBody(content);
        
        //mail.setHtmlBody('Your case:<b> ' + case.Id +' </b>has been created<p>'+
        //    ' View case <a href=https://na1.salesforce.com/'+case.Id+'>click here</a>');
        
        // Send the email you have created.
        List<Messaging.Sendemailresult> emailResults= Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        if(emailResults.size()>0){
            Messaging.Sendemailresult emailResult = emailResults[0];
            if(emailResult.isSuccess()){
                this.additionalMessages.add('Your message sent successfully!');
                //PageUtils.addInfo('Your message sent successfully!');
                return true;
            } 
        }
        //PageUtils.addInfo('Message could not be sent!');
        return false;
    }

    
    private PageReference error(String errorCode){
        this.errorCode = errorCode;
        return null;
    }
    


    private List<FormField> getCustomLocationFields(List<FormField> initialFieldList){
        List<FormField> filteredFieldList = new List<FormField>();
        for(FormField locDetail:initialFieldList){
            if( !locDetail.name.equalsIgnoreCase('Id') && 
                !locDetail.name.equalsIgnoreCase('Name') && 
                !locDetail.name.equalsIgnoreCase('Latitude__c') &&
                !locDetail.name.equalsIgnoreCase('Longitude__c') &&
                !locDetail.name.equalsIgnoreCase('Street__c') &&
                !locDetail.name.equalsIgnoreCase('City__c') &&
                !locDetail.name.equalsIgnoreCase('State_Province__c') &&
                !locDetail.name.equalsIgnoreCase('Postal_Code__c') &&
                !locDetail.name.equalsIgnoreCase('Country__c')
              ){
                filteredFieldList.add(locDetail);
            }
        }
        return filteredFieldList;
    }
    
    global void handlePageChange(List<SObject> newPage){
        this.locations.clear();
        this.locationsInJson = null;
        if(this.locationPaginator == null || newPage == null){
            return;
        }
        List<String> locationsInJsonList = new List<String>();
        Location aLocation = null;
        for(Integer i = 0; i < newPage.size(); i++){
            aLocation = Location.build((Partner_Location__c)newPage.get(i));
            aLocation.detailFields=  this.getCustomLocationFields(FormField.populateFields(FormField.build(this.config.detailScreenLocationFields),newPage.get(i)));
            aLocation.serialNumber = i + this.locationPaginator.pageStartPositionDisplayFriendly;
            locationsInJsonList.add(aLocation.toJSON());
            this.locations.add(aLocation);
            
        
        }
        this.locationsInJson = '{ "locations" : [' + StringUtils.joinArray(locationsInJsonList,',') + ']}';
    }
    
    private String getAccountQuery(String accountId){

        final Set<Object> fieldsLocation = new Set<Object>{
            'Id'
            ,'Name'
            ,'Point_of_Contact_Name__c'
            ,'Point_of_Contact_Email__c'
            ,'Point_of_Contact_Phone__c'
            ,'Street__c'
            ,'City__c'
            ,'State_Province__c'
            ,'Postal_Code__c'
            ,'Country__c'
            ,'Latitude__c'
            ,'Longitude__c'
            ,'Website__c'
        };
        if(this.config.detailScreenLocationFields != null && this.config.detailScreenLocationFields.size() > 0){
            for(FieldConfiguration field : this.config.detailScreenLocationFields ){
                fieldsLocation.add(field.fieldName);
            }
        }
        String sql =  new SoqlBuilder()
            .selectx(getAccountFields())
            .selectx(
                new SoqlBuilder()
                .selectx(fieldsLocation)
                .fromx('Partner_Locations__r')
                .orderByx(new OrderBy('Is_Primary__c').descending())
            )
            .fromx('Account')
            .wherex(new FieldCondition('id',accountId))
            .toSoql();
        return sql; 
    }
    
    private Set<Object> getAccountFields(){
        final Set<Object> returnValue = new Set<Object>{
            'Id'
            ,'Name'
            ,'Approved_for_Partner_Finder__c'
            ,'Profile_Published_to_Partner_Finder__c'
            ,'Partner_User_Agreed_to_PF_Terms_Cond__c'
            ,'Partner_Date_Agreed_to_PF_Terms_Cond__c'
            ,'Approved_for_Partner_Finder__c'
            ,'IsPartner'
            ,'Partner_Self_Description_Short__c'
            ,'Website'
            ,'Logo__c'
        };
        final List<FieldConfiguration> combined = new List<FieldConfiguration>();
        combined.addAll(this.config.detailScreenCompanyBasicFields);
        combined.addAll(this.config.detailScreenCompanyExtendedFields);
        combined.addAll(this.config.detailScreenEditFields);
        if(combined != null && combined.size() > 0){
            for(FieldConfiguration field : combined ){
                returnValue.add(field.fieldName);
            }
        }       
        return returnValue;
    }
    
    private Account loadAccount(String accountId){
        if(accountId == null){
            return null;
        }
        String accountQuery = getAccountQuery(accountId);
        List<Account> accounts = Database.query(accountQuery);
        if(accounts != null || accounts.size() > 0){
            return accounts.get(0);
        }
        return null;
    }
    
    private static String getAccountIDFromLocationID(String locationId){
        String acctId = null;
        if(StringUtils.isNotBlank(locationId)){
            List<Partner_Location__c> locations = [select account__c from partner_location__c where id = :locationId];
            if(locations != null && locations.size() > 0){
                acctId = locations.get(0).account__c;
            }
        }
        return acctId; 
    }
    
    
    public Boolean showEmail {
        get {
            if (showEmail == null) showEmail = true;
            return showEmail;
        }
        set;
    }

    
    public Boolean showEditDetail {
        get {
            if (showEditDetail == null) showEditDetail = false;         
            return showEditDetail;
        }
        set;
    }
    

}