public class EditLocationControllerExtension extends PartnerFinderBaseController {

        //======================================================
        // PAGE LOAD ERROR CODES
        //======================================================
        public String ERROR_NO_MAP_API_KEY { get{ return 'ERROR_NO_MAP_API_KEY'; }}
        public String ERROR_NO_ACCOUNT_ID  { get{ return 'ERROR_NO_ACCOUNT_ID' ; }}

    //==================================================
    // PROPERTIES
    //==================================================
    public Boolean                       lookingForLocation     {get;private set;}
    public Boolean                       showConfirmation       {get;private set;}
    public Boolean                       locationFound          {get;private set;}
    public String                        countryCodeHint        {get;private set;}
    public String                        errorCode              {get;private set;}
    public Configuration                 config                 {get;private set;}
        public List<FormField>               fields                 {get;private set;}
        public Partner_Location__c           primary                {get;private set;}
        public Partner_Location__c           location               {get;private set;}

    private ApexPages.StandardController controller;
    private PageReference                retURL;
    private PageReference                cancelURL;
        
    //==================================================
    // CONSTRUCTOR  
    //==================================================
        public EditLocationControllerExtension(ApexPages.StandardController controller) {
                this.controller = controller;
                if(this.controller.getRecord() != null && this.controller.getRecord() instanceof Partner_Location__c){
            this.location = (Partner_Location__c) this.controller.getRecord();
                } else {
            this.location = new Partner_Location__c();
                }
        }
        
    //==================================================
    // ACTIONS
    //==================================================
        public PageReference doOnLoad(){
                //LOAD FIELDS
        this.config = Configuration.getInstance();
        this.fields = FormField.build(config.detailScreenLocationFields);
			            
        //QUERY FOR LOCATION RECORD
        if(this.location.id != null){
            this.location = Database.query(new SoqlBuilder()
                .selectx(SearchHit.minimumFields)
                .selectx(FormField.fieldNames(fields))
                .fromx('Partner_Location__c')
                .wherex(new FieldCondition('id',location.id))
                .toSoql());
                               
            FormField.populateFields(fields,location);
        }
        this.retURL = StringUtils.isBlank(PageUtils.param('retURL')) ? PageUtils.redirect('/'+location.Account__c) : PageUtils.redirect(PageUtils.param('retURL'));
        this.cancelURL = StringUtils.isBlank(PageUtils.param('cancelURL')) ? PageUtils.redirect('/'+location.Account__c) : PageUtils.redirect(PageUtils.param('cancelURL'));

        this.showConfirmation = false;
        
                if(StringUtils.isBlank(config.googleMapsApiKey)){
                        return error(ERROR_NO_MAP_API_KEY);
                }

                ID partnerAccountId = getPartnerAccountID();
                if(partnerAccountId == null){
                        if(location.Account__c == null){
                                return error(ERROR_NO_ACCOUNT_ID);
                        }
                } else {
                        location.Account__c = partnerAccountId;
                }
                try{
                        this.primary = [select id, is_primary__c from Partner_Location__c where account__c = :location.Account__c and Is_Primary__c = true limit 1];
                        if(this.primary != null && this.primary.id == this.location.id){
                                this.primary = null;
                        }
                }catch(QueryException e){
                        //no primary location exists
                        populateFirstLocation(location, location.Account__c);
                }
                return null;
        }

    public PageReference doDetailsDone(){
        this.lookingForLocation = true;
        this.locationFound = false;
        this.countryCodeHint = StringUtils.mid(StringUtils.substringAfterLast(location.Country__c, '('),0,2);
        this.showConfirmation = true;
        return null;
    }
    
    public PageReference handleLocationFound(){
        this.lookingForLocation = false;
        this.locationFound = true;
        return null;
    }
    
    public PageReference handleLocationNotFound(){
        this.lookingForLocation = false;
        this.locationFound = false;
        return null;
    }
    
    public PageReference doConfirmationDone(){
        FormField.populateSObject(location,fields);
        Savepoint sp = null;
        try { 
            sp = Database.setSavepoint();
            if(this.primary != null && this.location.Is_Primary__c == true){
                this.primary.Is_Primary__c = false;
                update this.primary;
            }
            upsert location;
        }catch(Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        return retURL;
    }
    
    public PageReference doConfirmationPrevious(){
        this.showConfirmation = false;
        return null;
    }   
    
    public PageReference doCancel(){
        return cancelURL;
    }
    
    //==================================================
    // DERIVED PROPERTIES
    //==================================================
    public ID getId(){ return controller == null ? null : controller.getId();}
    public Boolean errorOccurred {get{ return StringUtils.isNotEmpty(this.errorCode); }}

    //==================================================
    // HELPER METHODS
    //==================================================
        private void populateFirstLocation(Partner_Location__c loc, ID acctId){
                loc.Is_Primary__c = true;
                Account acct = [
                        select ShippingStreet, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCity, Name, Id 
                        from Account
                        where id = :acctId];
                loc.Street__c = acct.ShippingStreet;
                loc.City__c = acct.ShippingCity;
                loc.State_Province__c = acct.ShippingState;
                loc.Postal_Code__c = acct.ShippingPostalCode;
                loc.Country__c = acct.ShippingCountry;
        }       
        
        public static ID getPartnerAccountID(){
                final List<User> userList = [
                        select id, ContactId, Contact.AccountId, Contact.Account.id, Contact.Account.name,userrole.name 
                        from user where id = :UserInfo.getUserId()];
                if( userList.isEmpty()
                        || userList.get(0).userrole == null 
                        || StringUtils.isBlank(userList.get(0).userrole.name)
                        || userList.get(0).contact == null
                        || userList.get(0).contact.id == null
                        || userList.get(0).Contact.AccountId == null){
                        return null;
                }
                return userList.get(0).Contact.AccountId;
        }

        private PageReference error(String errorCode){
                this.errorCode = errorCode;
                return null;
        }
        
        
}