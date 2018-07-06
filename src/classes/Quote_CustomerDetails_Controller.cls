/***************************************************************************************************************************
 About
-------
        Description:This Controller is used for Quote_CustomerDetails_Page.vfp Page.
        it is used for displaying Quote Customer deatils and adding/updating the customer details to Quote(SBQQ__Quote__c)

Methods
--------

Updated History
----------------

*****************************************************************************************************************************/
public class Quote_CustomerDetails_Controller {
    
    private string oldSoldTo;
    private string oldBillTo;
    private string oldShipTo;
    //partner customer details - BAJPI01
    private string oldResellerId;
    private string oldEndUserId;
    //partner customer details - BAJPI01
    
    public SBQQ__Quote__c quote {get;set;}
    public String QuoteId{get;set;}
    public String accountID{get;set;}
    public String OppCountryCode{get;set;}
    public String SoldTofullAddress;
    public String BillTofullAddress;
    public String ShipTofullAddress;
    
    //partner customer details - BAJPI01
    public String ResellerIdFullAddress;
    public String EndUserIdFullAddress;
    //partner customer details - BAJPI01
    
    public String TechnicalContactName;
    public String BillingContactName;
    public String ShippingContactName;
    //partner customer details - BAJPI01
    public String EndUserContactName;
    //partner customer details - BAJPI01
    public boolean enableCopylink{get;set;}
    public boolean enableCopyTechlink{get;set;}
    public String BookingCountryOld; //To check whether booking country is changed by user or not
    public Set<String> countryCodeHM;
    
    //created as part of US489975 -BAJPI01
    public String selectedSoldToSiteId{get;set;}		//selected Sold To's site ID
    public String selectedSoldToAccGroup{get;set;}		//selected sold to ID's account group
    public String selectedSoldToAccId{get;set;}			//selected sold to ID's account Id
    public String soldTosearchType{get;set;}			//search type Sold To 
    public String selectedSoldToAction{get;set;}		//selected Sold To's Site Id's Action
    public String selectedSoldToEDM{get;set;}			//selected Sold To's Site Id's EDM Action
    
    public String selectedBillToSiteId{get;set;}		//selected Bill To's site ID
    public String selectedBillToAccGroup{get;set;}		//selected Bill To ID's account group
    public String selectedBillToAccId{get;set;}			//selected Bill to ID's account Id
    public String billTosearchType{get;set;}			//search type Bill To
    public String selectedBillToEDM{get;set;}			//selected Bill To's Site Id's Action
    public String selectedBillToAction{get;set;}		//selected Bill To's Site Id's EDM Action
    
    public String selectedShipToSiteId{get;set;}		//selected Ship To's site ID
    public String selectedShipToAccGroup{get;set;}		//selected Ship To ID's account group
    public String selectedShipToAccId{get;set;}			//selected Ship to ID's account Id
    public String shipTosearchType{get;set;}			//search type Ship To
    public String selectedShipToEDM{get;set;}			//selected Ship To's Site Id's Action
    public String selectedShipToAction{get;set;}		//selected Ship To's Site Id's EDM Action
    
    public String selectedResellerSiteId{get;set;}		//selected Reseller's site ID
    public String selectedResellerAccGroup{get;set;}	//selected Reseller ID's account group
    public String selectedResellerAccId{get;set;}		//selected Reseller ID's account Id
    public String ResellerSearchType{get;set;}			//search type Reseller
    public String selectedResellerEDM{get;set;}			//selected Reseller Site Id's Action
    public String selectedResellerAction{get;set;}		//selected Reseller Site Id's EDM Action
    
    public String selectedEndUserIdSiteId{get;set;}		//selected EndUserId To's site ID
    public String selectedEndUserIdAccGroup{get;set;}	//selected EndUserId's account group
    public String selectedEndUserIdAccId{get;set;}		//selected EndUserId's account Id
    public String EndUserIdsearchType{get;set;}			//search type EndUserId
    public String selectedEndUserIdEDM{get;set;}		//selected EndUserId's Action
    public String selectedEndUserIdAction{get;set;}		//selected EndUserId's EDM Action
    //created as part of US489975 -BAJPI01
    
    public Boolean enablePartnerSites1Tier{get;set;}	//boolean to render Partner Site Section on the screen
    
    public Quote_CustomerDetails_Controller(ApexPages.StandardController standardPageController){
        //this.quote = (SBQQ__Quote__c)standardPageController.getRecord();
        enableCopylink =false;
        enableCopyTechlink = false;
        QuoteId = ApexPages.currentPage().getParameters().get('Id');
        if(QuoteId != null){
            quote = [Select Id,SBQQ__Account__r.Enterprise_ID__c,SBQQ__Opportunity2__r.Opportunity_Country__c,SoldTo_BPID__c,SoldTo_Name__c,SoldTo_Street__c,SoldTo_Street2__c,SoldTo_City__c,SoldTo_State__c,SoldTo_PostalCode__c,SoldTo_Country__c,SoldTo_Name_Intl__c,
                     SoldTo_Street_Intl__c,SoldTo_Street2_Intl__c,SoldTo_City_Intl__c,SoldTo_State_Intl__c,
                     ShipTo_BPID__c,ShipTo_Name__c,ShipTo_Street__c,ShipTo_Street2__c,ShipTo_City__c,ShipTo_State__c,ShipTo_PostalCode__c,ShipTo_Country__c,ShipTo_Name_Intl__c,ShipTo_Street_Intl__c,ShipTo_Street2_Intl__c,ShipTo_City_Intl__c,ShipTo_State_Intl__c,
                     BillTo_BPID__c,BillTo_Name__c,BillTo_Street__c,BillTo_Street2__c,BillTo_City__c,BillTo_State__c,BillTo_PostalCode__c,BillTo_Country__c,BillTo_Name_Intl__c,BillTo_Street_Intl__c,BillTo_Street2_Intl__c,BillTo_City_Intl__c,BillTo_State_Intl__c,
                     Sales_Organization__c,Company_Code__c,TechnicalContact_ID__c,TechnicalContact_FirstName__c,TechnicalContact_LastName__c,TechnicalContact_Email__c,TechnicalContact_Phone__c,TechnicalContact_IntlFName__c,TechnicalContact_IntlLName__c,
                     BillingContact_ID__c,BillingContact_FirstName__c,BillingContact_LastName__c,BillingContact_Email__c,BillingContact_Phone__c,BillingContact_IntlFName__c,BillingContact_IntlLName__c,SBQQ__Account__r.Name,Name,SBQQ__SalesRep__c,
                     ShippingContact_ID__c,ShippingContact_FirstName__c,ShippingContact_LastName__c,ShippingContact_Phone__c,ShippingContact_Email__c,ShippingContact_IntlFName__c,ShippingContact_IntlLName__c,Booking_Country__c,Company_Registration_Number__c,
                     Transaction_Type__c,EndUser_Contact_Email__c,EndUser_Contact_First_Name__c,EndUser_Contact_ID__c,
                     EndUser_Contact_Intl_First_Name__c,EndUser_Contact_Intl_Last_Name__c,EndUser_Contact_Last_Name__c,
                     EndUser_Contact_Phone__c,EndUser_City__c,EndUser_City_Intl__c,EndUser_Country__c,EndUser_BPID__c,
                     EndUser_ID__c,EndUser_Name__c,EndUser_Name_Intl__c,EndUser_Postal_Code__c,EndUser_State__c,
                     EndUser_State_Intl__c,EndUser_Street__c,EndUser_Street2__c,EndUser_Street2_Intl__c,EndUser_Street_Intl__c,
                     Reseller_City__c,Reseller_City_Intl__c,Reseller_Country__c,Reseller_BPID__c,Reseller_ID__c,
                     Reseller_Name__c,Reseller_Name_Intl__c,Reseller_Postal_Code__c,Reseller_State__c,Reseller_State_Intl__c,
                     Reseller_Street__c,Reseller_Street2__c,Reseller_Street2_Intl__c,Reseller_Street_Intl__c from SBQQ__Quote__c where id =:QuoteId];
            
            if(quote.Transaction_Type__c=='1 Tier'){
                enablePartnerSites1Tier = true;		//only rendered if Transaction Type is 1 Tier.
            }
            else{
                enablePartnerSites1Tier = false;
            }
            
            accountID=quote.SBQQ__Account__r.Enterprise_ID__c;
            OppCountryCode=quote.SBQQ__Opportunity2__r.Opportunity_Country__c;
            if(!String.isBlank(OppCountryCode))
            	OppCountryCode=OppCountryCode.substringBefore('-').trim();
            System.debug('OppCountryCode-------------'+OppCountryCode);
            if(!String.isBlank(quote.Booking_Country__c)){
                BookingCountryOld =quote.Booking_Country__c;
             }else{
                BookingCountryOld ='';    
             }
            countryCodeHM =SAP_ECC_Utility.countryCodeHM;
            enablelinks();
          
            
            oldSoldTo = quote.SoldTo_BPID__c;
            oldBillTo = quote.BillTo_BPID__c;
            oldShipTo = quote.ShipTo_BPID__c;
            oldResellerId = quote.Reseller_BPID__c;
            oldEndUserId = quote.EndUser_BPID__c;
            system.debug('---old sold to---'+oldSoldTo);
            system.debug('---old bill to---'+oldBillTo);
            system.debug('---old ship to---'+oldShipTo);
            system.debug('---old Reseller ID---'+oldResellerId);
            system.debug('---old EndUserId---'+oldEndUserId);
        }
        //SoldTofullAddress =getSoldTofullAddress();
        System.debug('quote---'+this.quote);
    }
    public void enablelinks(){
        if(!String.isEmpty(quote.SoldTo_BPID__c)){
                enableCopylink = true;
            }
         if(!String.isEmpty(quote.TechnicalContact_ID__c)){
                enableCopyTechlink = true;
        }
    }
    public String getSoldTofullAddress(){
        String retunAddress;
        System.debug('-------------jsjsjsjsjs');
        if(quote != null){
            System.debug('jsjsjsjsjs');
            retunAddress =buildfullAddress(quote.SoldTo_Street__c,quote.SoldTo_Street2__c,quote.SoldTo_City__c,quote.SoldTo_State__c,quote.SoldTo_PostalCode__c,quote.SoldTo_Country__c);
            //retunAddress =Street;
            
        }
        return retunAddress;
        
    }
    public void setSoldTofullAddress(String SoldTofullAddress){
        this.SoldTofullAddress = SoldTofullAddress;
    }
    public String getBillTofullAddress(){
        String retunAddress;
        System.debug('-------------jsjsjsjsjs');
        if(quote != null){
            System.debug('jsjsjsjsjs');
            retunAddress =buildfullAddress(quote.BillTo_Street__c,quote.BillTo_Street2__c,quote.BillTo_City__c,quote.BillTo_State__c,quote.BillTo_PostalCode__c,quote.BillTo_Country__c);
            //retunAddress =Street;
            
        }
        return retunAddress;
        
    }
    public void setBillTofullAddress(String SoldTofullAddress){
        this.SoldTofullAddress = SoldTofullAddress;
    }
    public String getShipTofullAddress(){
        String retunAddress;
        System.debug('-------------jsjsjsjsjs');
        if(quote != null){
            System.debug('jsjsjsjsjs');
            retunAddress =buildfullAddress(quote.ShipTo_Street__c,quote.ShipTo_Street2__c,quote.ShipTo_City__c,quote.ShipTo_State__c,quote.ShipTo_PostalCode__c,quote.ShipTo_Country__c);
            //retunAddress =Street;
            
        }
        return retunAddress;
        
    }
    public void setShipTofullAddress(String SoldTofullAddress){
        this.SoldTofullAddress = SoldTofullAddress;
    }
    
    //Partner Quote Customer Details Full Address - BAJPI01
    public String getResellerIdFullAddress(){
        String returnAddress;
        System.debug('-------------reseller full address');
        if(quote != null){
            System.debug('reseller full address quote!=null');
            returnAddress =buildfullAddress(quote.Reseller_Street__c,quote.Reseller_Street2__c,quote.Reseller_City__c,quote.Reseller_State__c,quote.Reseller_Postal_Code__c,quote.Reseller_Country__c);
            
        }
        return returnAddress;
        
    }
    public void setResellerIdFullAddress(String ResellerIdFullAddress){
        this.ResellerIdFullAddress = ResellerIdFullAddress;
    }	
	public String getEndUserIdFullAddress(){
        String returnAddress;
        System.debug('-------------reseller full address');
        if(quote != null){
            System.debug('reseller full address quote!=null');
            returnAddress =buildfullAddress(quote.EndUser_Street__c,quote.EndUser_Street2__c,quote.EndUser_City__c,quote.EndUser_State__c,quote.EndUser_Postal_Code__c,quote.EndUser_Country__c);
            
        }
        return returnAddress;
        
    }
    public void setEndUserIdFullAddress(String EndUserIdFullAddress){
        this.EndUserIdFullAddress = EndUserIdFullAddress;
    }
	//Partner Quote Customer Details Full Address - BAJPI01
    
    public String buildfullAddress(String Street,String Street2,String City,String State,String Pincode,String Country){
        String retunAddress;
        if (Street2 !=null && Street2 !='')
            Street=Street+','+Street2;
        if(City != null && City !='')
            Street = Street+','+ City;
        if(State != null && State !='')
            Street = Street+','+State;
        if(Pincode !=null && Pincode !=''){
            Street = Street+','+Pincode;
        }
        if(Country !=null && Country !=''){
            Street = Street+','+Country;
        }
        retunAddress =Street;
        return retunAddress;
        
    }
    
    public String getTechnicalContactName(){
        String fullname = '';
        if(quote != null){
            if(quote.TechnicalContact_FirstName__c != null && quote.TechnicalContact_LastName__c != null)
            fullname = quote.TechnicalContact_FirstName__c+' '+quote.TechnicalContact_LastName__c;
         }
        System.debug('fullname-------'+fullname);
        return fullname;
    }
    public String getBillingContactName(){
        String fullname = '';
        if(quote != null){
            if(quote.BillingContact_FirstName__c != null && quote.BillingContact_LastName__c != null)
            fullname = quote.BillingContact_FirstName__c+' '+quote.BillingContact_LastName__c;
         }
        return fullname;
    }
    public String getShippingContactName(){
        String fullname = '';
        if(quote != null){
            if(quote.ShippingContact_FirstName__c != null && quote.ShippingContact_LastName__c != null)
            fullname = quote.ShippingContact_FirstName__c+' '+quote.ShippingContact_LastName__c;
         }
        return fullname;
    }
    
    //Partner Quote End User Contact Full Name - BAJPI01
    public String getEndUserContactName(){
        String fullname = '';
        if(quote != null){
            if(quote.EndUser_Contact_First_Name__c != null && quote.EndUser_Contact_Last_Name__c != null)
            fullname = quote.EndUser_Contact_First_Name__c+' '+quote.EndUser_Contact_Last_Name__c;
         }
        return fullname;
    }
    //Partner Quote End User Contact Full Name - BAJPI01
    
    public void setTechnicalContactName(String TechnicalContactName){
        this.TechnicalContactName =TechnicalContactName;
    }
    public void setShippingContactName(String ShippingContactName){
        this.ShippingContactName =ShippingContactName;
    }
    public void setBillingContactName(String BillingContactName){
        this.BillingContactName =BillingContactName;
    }
    
    //Partner Quote End User Contact Full Name - BAJPI01
    public void setEndUserContactName(String EndUserContactName){
        this.EndUserContactName =EndUserContactName;
    }
    //Partner Quote End User Contact Full Name - BAJPI01
    
    public pagereference save(){
        if(!String.isBlank(quote.SoldTo_BPID__c) && String.isBlank(quote.Booking_Country__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,System.Label.Quote_Booking_Required));
            return null;
        }
        if(!String.isBlank(BookingCountryOld) && (BookingCountryOld != quote.Booking_Country__c)){
            copytheBookingCountry(false);
            if(String.isBlank(quote.Sales_Organization__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Quote_Invalid_Booking));
                return null;
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,System.Label.Quote_Booking_SalesOrg));
            }
            
        }
        
        try{
            system.debug('---selectedSoldToSiteId----'+selectedSoldToSiteId);
            system.debug('---selectedSoldToAccGroup----'+selectedSoldToAccGroup);
            system.debug('---selectedSoldToAccId----'+selectedSoldToAccId);
            system.debug('---soldToSearchType----'+soldToSearchType);
            system.debug('---selectedBillToSiteId----'+selectedBillToSiteId);
            system.debug('---selectedBillToAccGroup----'+selectedBillToAccGroup);
            system.debug('---selectedBillToAccId----'+selectedBillToAccId); 
            system.debug('---billToSearchType----'+billToSearchType);
            system.debug('---selectedShipToSiteId----'+selectedShipToSiteId);
            system.debug('---selectedShipToAccGroup----'+selectedShipToAccGroup);
            system.debug('---selectedShipToAccId----'+selectedShipToAccId);
            system.debug('---shipToSearchType----'+shipToSearchType);
            system.debug('---selectedResellerSiteId----'+selectedResellerSiteId);
            system.debug('---selectedResellerAccGroup----'+selectedResellerAccGroup);
            system.debug('---selectedResellerAccId----'+selectedResellerAccId);
            system.debug('---ResellerSearchType----'+ResellerSearchType);
            system.debug('---selectedResellerEDM----'+selectedResellerEDM);
            system.debug('---selectedResellerAction----'+selectedResellerAction);
            system.debug('---selectedEndUserIdSiteId----'+selectedEndUserIdSiteId);
            system.debug('---selectedEndUserIdAccGroup----'+selectedEndUserIdAccGroup);
            system.debug('---selectedEndUserIdAccId----'+selectedEndUserIdAccId);
            system.debug('---EndUserIdsearchType----'+EndUserIdsearchType);
            system.debug('---selectedEndUserIdEDM----'+selectedEndUserIdEDM);
            system.debug('---selectedEndUserIdAction----'+selectedEndUserIdAction);
            PopulateEmail();
            upsert quote;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,System.Label.Quote_Customer_Details));
            
            if(leanCustomerEmailFunctionalityClass.messages!=null && leanCustomerEmailFunctionalityClass.messages.size()>0){
                system.debug('---sending emails----');
                Messaging.SendEmailResult[] results = Messaging.sendEmail(leanCustomerEmailFunctionalityClass.messages);
            }
            
            oldSoldTo = quote.SoldTo_BPID__c;
            oldBillTo = quote.BillTo_BPID__c;
            oldShipTo = quote.ShipTo_BPID__c;
            oldResellerId = quote.Reseller_BPID__c;
            oldEndUserId = quote.EndUser_BPID__c;
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
        }
        
        
        return null;
    }
    public pagereference copythedetails(){
        System.debug( quote.ShipTo_BPID__c +'-----'+quote.SoldTo_BPID__c);
        copytheBookingCountry(true);
        clearBillTo();
        clearShipTo();
        clearTechnicalcontacts();
        clearBillingcontacts();
        clearShippingcontacts();
        
        //enableCopylink = true;
        enablelinks();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    
    //method to replicate the Sold To method to clear off other site and contact details that depend on End User ID.
    public pagereference endUserIdCopyTheDetails(){
        System.debug( quote.EndUser_BPID__c +'-----'+quote.EndUser_BPID__c);

        clearShipTo();
        clearTechnicalcontacts();
        clearShippingcontacts();
        clearEndUserContacts();
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    
    /***Method to copy the booking country value from lookup and map the booking country with salesOrg***/
    public void copytheBookingCountry(Boolean iscopy){
        if(iscopy){
            quote.Booking_Country__c =quote.SoldTo_Country__c;
        }
        SalesOrg__c SalesOb = SalesOrg__c.getValues(quote.Booking_Country__c);
        if(SalesOb != null){
            quote.Sales_Organization__c=SalesOb.Sales_Organization__c;
            quote.Company_Code__c =SalesOb.Company_Code__c;
            BookingCountryOld =quote.Booking_Country__c;
        }else{
            quote.Sales_Organization__c ='';
            quote.Company_Code__c ='';
            BookingCountryOld =quote.Booking_Country__c;
                
        }
    }
    
    public pagereference copyBillTo(){
        quote.BillTo_BPID__c=quote.SoldTo_BPID__c;
        quote.BillTo_Name__c=quote.SoldTo_Name__c;
        quote.BillTo_Street__c =quote.SoldTo_Street__c;
        quote.BillTo_Street2__c=quote.SoldTo_Street2__c;
        quote.BillTo_City__c=quote.SoldTo_City__c;
        quote.BillTo_State__c=quote.SoldTo_State__c;
        quote.BillTo_PostalCode__c=quote.SoldTo_PostalCode__c;
        quote.BillTo_Country__c=quote.SoldTo_Country__c;
        quote.BillTo_Name_Intl__c=quote.SoldTo_Name_Intl__c;
        quote.BillTo_Street_Intl__c=quote.SoldTo_Street_Intl__c;
        quote.BillTo_Street2_Intl__c=quote.SoldTo_Street2_Intl__c;
        quote.BillTo_City_Intl__c=quote.SoldTo_City_Intl__c;
        quote.BillTo_State_Intl__c=quote.SoldTo_State_Intl__c;
        //copying as part of US489975
        selectedBillToSiteId = selectedSoldToSiteId;
        selectedBillToAccGroup = selectedSoldToAccGroup;
        selectedBillToAccId = selectedSoldToAccId;
        billTosearchType = 'BILLTO';
        selectedBillToEDM = selectedSoldToEDM;
        selectedBillToAction = selectedSoldToAction;
        //copying as part of US489975
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    
    public pagereference copyShipTo(){
        quote.ShipTo_BPID__c=quote.SoldTo_BPID__c;
        quote.ShipTo_Name__c=quote.SoldTo_Name__c;
        quote.ShipTo_Street__c =quote.SoldTo_Street__c;
        quote.ShipTo_Street2__c=quote.SoldTo_Street2__c;
        quote.ShipTo_City__c=quote.SoldTo_City__c;
        quote.ShipTo_State__c=quote.SoldTo_State__c;
        quote.ShipTo_PostalCode__c=quote.SoldTo_PostalCode__c;
        quote.ShipTo_Country__c=quote.SoldTo_Country__c;
        quote.ShipTo_Name_Intl__c=quote.SoldTo_Name_Intl__c;
        quote.ShipTo_Street_Intl__c=quote.SoldTo_Street_Intl__c;
        quote.ShipTo_Street2_Intl__c=quote.SoldTo_Street2_Intl__c;
        quote.ShipTo_City_Intl__c=quote.SoldTo_City_Intl__c;
        quote.ShipTo_State_Intl__c=quote.SoldTo_State_Intl__c;
        //copying as part of US489975
        selectedShipToSiteId = selectedSoldToSiteId;
        selectedShipToAccGroup = selectedSoldToAccGroup;
        selectedShipToAccId = selectedSoldToAccId;
        shipTosearchType = 'SHIPTO';
        selectedShipToEDM = selectedSoldToEDM;
        selectedShipToAction = selectedSoldToAction;
        //copying as part of US489975
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
        
    }
    
    //BAJPI01 - Copying details for Partner Quote Customer Details from Sold To
    public pagereference copyReseller(){
        
		quote.Reseller_BPID__c = quote.SoldTo_BPID__c;
        quote.Reseller_Name__c = quote.SoldTo_Name__c;
        quote.Reseller_Street__c = quote.SoldTo_Street__c;
        quote.Reseller_Street2__c = quote.SoldTo_Street2__c;
        quote.Reseller_City__c = quote.SoldTo_City__c;
        quote.Reseller_State__c = quote.SoldTo_State__c;
        quote.Reseller_Postal_Code__c = quote.SoldTo_PostalCode__c;
        quote.Reseller_Country__c = quote.SoldTo_Country__c;
        quote.Reseller_Name_Intl__c = quote.SoldTo_Name_Intl__c;
        quote.Reseller_Street_Intl__c = quote.SoldTo_Street_Intl__c;
        quote.Reseller_Street2_Intl__c = quote.SoldTo_Street2_Intl__c;
        quote.Reseller_City_Intl__c = quote.SoldTo_City_Intl__c;
        quote.Reseller_State_Intl__c = quote.SoldTo_State_Intl__c;
        
		//copying as part of US489975
        selectedResellerSiteId = selectedSoldToSiteId;
        selectedResellerAccGroup = selectedSoldToAccGroup;
        selectedResellerAccId = selectedSoldToAccId;
        ResellerSearchType = 'RESELLER';
        selectedResellerEDM = selectedSoldToEDM;
        selectedResellerAction = selectedSoldToAction;
        //copying as part of US489975
        
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
        
    }
	
	public pagereference copyEndUserId(){
        
		quote.EndUser_BPID__c = quote.SoldTo_BPID__c;
        quote.EndUser_Name__c = quote.SoldTo_Name__c;
        quote.EndUser_Street__c = quote.SoldTo_Street__c;
        quote.EndUser_Street2__c = quote.SoldTo_Street2__c;
        quote.EndUser_City__c = quote.SoldTo_City__c;
        quote.EndUser_State__c = quote.SoldTo_State__c;
        quote.EndUser_Postal_Code__c = quote.SoldTo_PostalCode__c;
        quote.EndUser_Country__c = quote.SoldTo_Country__c;
        quote.EndUser_Name_Intl__c = quote.SoldTo_Name_Intl__c;
        quote.EndUser_Street_Intl__c = quote.SoldTo_Street_Intl__c;
        quote.EndUser_Street2_Intl__c = quote.SoldTo_Street2_Intl__c;
        quote.EndUser_City_Intl__c = quote.SoldTo_City_Intl__c;
        quote.EndUser_State_Intl__c = quote.SoldTo_State_Intl__c;
        
		//copying as part of US489975
        selectedEndUserIdSiteId = selectedSoldToSiteId;
        selectedEndUserIdAccGroup = selectedSoldToAccGroup;
        selectedEndUserIdAccId = selectedSoldToAccId;
        EndUserIdsearchType = 'ENDUSERID';
        selectedEndUserIdEDM = selectedSoldToEDM;
        selectedEndUserIdAction = selectedSoldToAction;
        //copying as part of US489975
        
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
        
    }
    //BAJPI01 - Copying details for Partner Quote Customer Details from Sold To
    
    public void clearBillTo(){
        quote.BillTo_BPID__c='';
        quote.BillTo_Name__c='';
        quote.BillTo_Street__c ='';
        quote.BillTo_Street2__c='';
        quote.BillTo_City__c='';
        quote.BillTo_State__c='';
        quote.BillTo_PostalCode__c='';
        quote.BillTo_Country__c='';
        quote.BillTo_Name_Intl__c='';
        quote.BillTo_Street_Intl__c='';
        quote.BillTo_Street2_Intl__c='';
        quote.BillTo_City_Intl__c='';
        quote.BillTo_State_Intl__c='';
    }
    
    public void clearShipTo(){
        quote.ShipTo_BPID__c='';
        quote.ShipTo_Name__c='';
        quote.ShipTo_Street__c='';
        quote.ShipTo_Street2__c='';
        quote.ShipTo_City__c='';
        quote.ShipTo_State__c='';
        quote.ShipTo_PostalCode__c='';
        quote.ShipTo_Country__c='';
        quote.ShipTo_Name_Intl__c='';
        quote.ShipTo_Street_Intl__c='';
        quote.ShipTo_Street2_Intl__c='';
        quote.ShipTo_City_Intl__c='';
        quote.ShipTo_State_Intl__c='';
        
    }
    
    //BAJPI01 - Clearing details for Partner Quote Customer Details
    public void clearReseller(){
        
        quote.Reseller_BPID__c='';
        quote.Reseller_Name__c='';
        quote.Reseller_Street__c ='';
        quote.Reseller_Street2__c='';
        quote.Reseller_City__c='';
        quote.Reseller_State__c='';
        quote.Reseller_Postal_Code__c='';
        quote.Reseller_Country__c='';
        quote.Reseller_Name_Intl__c='';
        quote.Reseller_Street_Intl__c='';
        quote.Reseller_Street2_Intl__c='';
        quote.Reseller_City_Intl__c='';
        quote.Reseller_State_Intl__c='';
        
    }
    
    public void clearEndUserId(){
        
        quote.EndUser_BPID__c='';
        quote.EndUser_Name__c='';
        quote.EndUser_Street__c ='';
        quote.EndUser_Street2__c='';
        quote.EndUser_City__c='';
        quote.EndUser_State__c='';
        quote.EndUser_Postal_Code__c='';
        quote.EndUser_Country__c='';
        quote.EndUser_Name_Intl__c='';
        quote.EndUser_Street_Intl__c='';
        quote.EndUser_Street2_Intl__c='';
        quote.EndUser_City_Intl__c='';
        quote.EndUser_State_Intl__c='';
        
    }
    //BAJPI01 - Copying details for Partner Quote Customer Details
    
    public void clearTechnicalcontacts(){
    	quote.TechnicalContact_ID__c='';
       	quote.TechnicalContact_FirstName__c='';
        quote.TechnicalContact_LastName__c='';
        quote.TechnicalContact_Email__c='';
        quote.TechnicalContact_Phone__c='';
        quote.TechnicalContact_IntlFName__c='';
        quote.TechnicalContact_IntlLName__c='';
    }
    
    public void clearBillingcontacts(){
    	quote.BillingContact_ID__c='';
       	quote.BillingContact_FirstName__c='';
        quote.BillingContact_LastName__c='';
        quote.BillingContact_Email__c='';
        quote.BillingContact_Phone__c='';
        quote.BillingContact_IntlFName__c='';
        quote.BillingContact_IntlLName__c='';
    }
    
    public pagereference copyBillingcontacts(){
    	quote.BillingContact_ID__c=quote.TechnicalContact_ID__c;
       	quote.BillingContact_FirstName__c=quote.TechnicalContact_FirstName__c;
        quote.BillingContact_LastName__c=quote.TechnicalContact_LastName__c;
       	quote.BillingContact_Email__c=quote.TechnicalContact_Email__c;
        quote.BillingContact_Phone__c=quote.TechnicalContact_Phone__c;
        quote.BillingContact_IntlFName__c=quote.TechnicalContact_IntlFName__c;
        quote.BillingContact_IntlLName__c=quote.TechnicalContact_IntlLName__c;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    
    public void clearShippingcontacts(){
        	quote.ShippingContact_ID__c='';
        	quote.ShippingContact_FirstName__c='';
         	quote.ShippingContact_LastName__c='';
            quote.ShippingContact_Email__c='';
            quote.ShippingContact_Phone__c='';
        	quote.ShippingContact_IntlFName__c='';
            quote.ShippingContact_IntlLName__c='';
    }
    
    public pagereference copyShippingcontacts(){
    	quote.ShippingContact_ID__c=quote.TechnicalContact_ID__c;
       	quote.ShippingContact_FirstName__c=quote.TechnicalContact_FirstName__c;
        quote.ShippingContact_LastName__c=quote.TechnicalContact_LastName__c;
        quote.ShippingContact_Email__c=quote.TechnicalContact_Email__c;
        quote.ShippingContact_Phone__c=quote.TechnicalContact_Phone__c;
        quote.ShippingContact_IntlFName__c=quote.TechnicalContact_IntlFName__c;
        quote.ShippingContact_IntlLName__c=quote.TechnicalContact_IntlLName__c;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    
    //BAJPI01 - Partner Quote Customer Details End User Contact
    public void clearEndUserContacts(){
    	
        quote.EndUser_Contact_ID__c='';
       	quote.EndUser_Contact_First_Name__c='';
        quote.EndUser_Contact_Last_Name__c='';
        quote.EndUser_Contact_Email__c='';
        quote.EndUser_Contact_Phone__c='';
        quote.EndUser_Contact_Intl_First_Name__c='';
        quote.EndUser_Contact_Intl_Last_Name__c='';
    
    }
    
    public pagereference copyEndUserContacts(){
    	
        quote.EndUser_Contact_ID__c = quote.TechnicalContact_ID__c;
       	quote.EndUser_Contact_First_Name__c = quote.TechnicalContact_FirstName__c;
        quote.EndUser_Contact_Last_Name__c = quote.TechnicalContact_LastName__c;
        quote.EndUser_Contact_Email__c = quote.TechnicalContact_Email__c;
        quote.EndUser_Contact_Phone__c = quote.TechnicalContact_Phone__c;
        quote.EndUser_Contact_Intl_First_Name__c = quote.TechnicalContact_IntlFName__c;
        quote.EndUser_Contact_Intl_Last_Name__c = quote.TechnicalContact_IntlLName__c;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    //BAJPI01 - Partner Quote Customer Details End User Contact
    
    public pagereference refreshaddress(){
        
        System.debug(BillTofullAddress);
        if(!String.isBlank(OppCountryCode) && !countryCodeHM.contains(OppCountryCode)){
            //clear the first and last local details for contacts
            clearlocalDetails();
        }
        enablelinks();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,System.Label.Quote_Unsaved));
        return null;
    }
    
    public void clearlocalDetails(){
        
        quote.TechnicalContact_IntlFName__c='';
        quote.TechnicalContact_IntlLName__c='';
        quote.ShippingContact_IntlFName__c='';
        quote.ShippingContact_IntlLName__c='';
        quote.BillingContact_IntlFName__c='';
        quote.BillingContact_IntlLName__c='';
        
        quote.EndUser_Contact_Intl_First_Name__c = '';
        quote.EndUser_Contact_Intl_Last_Name__c = '';
        
    }
    
    //created as part of US489975
    public void PopulateEmail(){
            
       system.debug('---old sold to---'+oldSoldTo);
        system.debug('---new sold to---'+selectedSoldToSiteId);
        if((String.isBlank(oldSoldTo) && String.isNotBlank(selectedSoldToSiteId)) ||
          (String.isNotBlank(oldSoldTo) && String.isNotBlank(selectedSoldToSiteId) &&
           oldSoldTo!=selectedSoldToSiteId)){
               leanCustomerEmailFunctionalityClass.userEmailMethod(soldToSearchType,selectedSoldToAccGroup,selectedSoldToAccId,selectedSoldToSiteId,selectedSoldToEDM,selectedSoldToAction,quote);
           }
        
        system.debug('---old Bill to---'+oldBillTo);
        system.debug('---new Bill to---'+selectedBillToSiteId);
        if((String.isBlank(oldBillTo) && String.isNotBlank(selectedBillToSiteId)) ||
          (String.isNotBlank(oldBillTo) && String.isNotBlank(selectedBillToSiteId) &&
           oldBillTo!=selectedBillToSiteId)){
               system.debug('----entered method----');
               leanCustomerEmailFunctionalityClass.userEmailMethod(billToSearchType,selectedBillToAccGroup,selectedBillToAccId,selectedBillToSiteId,selectedBillToEDM,selectedBillToAction,quote);
           }
		
        system.debug('---old Ship to---'+oldShipTo);
        system.debug('---new Ship to---'+selectedShipToSiteId);
        if((String.isBlank(oldShipTo) && String.isNotBlank(selectedShipToSiteId)) ||
          (String.isNotBlank(oldShipTo) && String.isNotBlank(selectedShipToSiteId) &&
           oldShipTo!=selectedShipToSiteId)){
               leanCustomerEmailFunctionalityClass.userEmailMethod(shipToSearchType,selectedShipToAccGroup,selectedShipToAccId,selectedShipToSiteId,selectedShipToEDM,selectedShipToAction,quote);
           }
        
        system.debug('---is partner quote----'+enablePartnerSites1Tier);
        
        if(enablePartnerSites1Tier==true){
            system.debug('---old Reseller ID---'+oldResellerId);
            system.debug('---new Reseller ID---'+selectedResellerSiteId);
            if((String.isBlank(oldResellerId) && String.isNotBlank(selectedResellerSiteId)) ||
               (String.isNotBlank(oldResellerId) && String.isNotBlank(selectedResellerSiteId) &&
                oldResellerId!=selectedResellerSiteId)){
                    leanCustomerEmailFunctionalityClass.userEmailMethod(ResellerSearchType,selectedResellerAccGroup,selectedResellerAccId,selectedResellerSiteId,selectedResellerEDM,selectedResellerAction,quote);
                }
            
            system.debug('---old End User ID---'+oldEndUserId);
            system.debug('---new End User ID---'+selectedEndUserIdSiteId);
            if((String.isBlank(oldEndUserId) && String.isNotBlank(selectedEndUserIdSiteId)) ||
               (String.isNotBlank(oldEndUserId) && String.isNotBlank(selectedEndUserIdSiteId) &&
                oldEndUserId!=selectedEndUserIdSiteId)){
                    leanCustomerEmailFunctionalityClass.userEmailMethod(EndUserIdsearchType,selectedEndUserIdAccGroup,selectedEndUserIdAccId,selectedEndUserIdSiteId,selectedEndUserIdEDM,selectedEndUserIdAction,quote);
                }
        }
        
    }

}