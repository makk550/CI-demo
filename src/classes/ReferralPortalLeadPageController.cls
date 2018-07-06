public class ReferralPortalLeadPageController {
    public Lead ReferralLead{get;set;}
    public Boolean isRegistrationcompleted{get;set;}
    public Boolean isleadnew{get;set;}
    public string physicalCountry {get;set;}
    public List<SelectOption> countries {get;set;}
    Map<String,String> mapStatesForCA;
    Map<string,string> mapStatesForUS;
    public string physicalStateFree{get;set;}
    public string physicalStateCAUS{get;set;}
    public string physicalStateUS{get;set;}
    public string physicalStateCA{get;set;}
    public boolean isstatepicklist{get;set;}
    Public User CurrentUserRec{get;set;}
    Private List<Group> ReferralQueueList;
    public List<SelectOption> respectedstates{get;set;}
    public ReferralPortalLeadPageController(ApexPages.StandardController controller){
        isRegistrationcompleted = false;
        ReferralQueueList=[Select Id from Group where type='Queue' and Name='Pre-Other Staged Leads'];
        ReferralLead = new Lead();
        /*Added In Rally Supercare-Start*/
        ReferralLead.CSU__c ='Agile Central';
        ReferralLead.CSU_Driver__c = 'Agile Central';
        ReferralLead.mkto_si__Last_Interesting_Moment_Date__c =System.now();
        /**End**/
        id userid = UserInfo.getUserId();
        ReferralLead.Referral_Partner__c =userid;
        ReferralLead.Referral_Date__c = System.today();
        ReferralLead.LeadSource='Partner Referral';
        isleadnew = true;
        /****** Fetching Countries from Lead Object****/
        CurrentUserRec = [select id,Contact.Country_Picklist__c,Related_Partner_Account__c,ContactID,Country from User where id = :UserInfo.getUserId() limit 1];
        ReferralLead.Referral_Partner_Account__c =CurrentUserRec.Related_Partner_Account__c;
        string usrcntry = CurrentUserRec.Country;
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('--Select--','--Select--'));
        Schema.DescribeFieldResult countryFieldDescription = Lead.Country_Picklist__c.getDescribe();
        for(Schema.Picklistentry picklistEntry:countryFieldDescription.getPicklistValues()) {
            countryOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            string picklistCountry = pickListEntry.getLabel();
             if(physicalCountry == null){
                if(CurrentUserRec.Contact.Country_Picklist__c != null)
                     physicalCountry = CurrentUserRec.Contact.Country_Picklist__c;
                 
                else if(usrcntry!=null&&picklistCountry.startsWith(usrcntry))
                 physicalCountry = picklistCountry;
           
            }
        }
        countries = countryOptions;
        if(physicalCountry == 'CA - CANADA' || physicalCountry == 'US - UNITED STATES'){
                isstatepicklist =true;
            if(physicalCountry == 'CA - CANADA'){
                respectedstates = getStateRegionsForCANADA();
  
            }else{
                respectedstates = getStateRegionsFor_US();
            }
        }else{
            isstatepicklist =false;
         }
        System.debug('ReferralLead1'+ReferralLead);
    }
    public pageReference save(){
        if (physicalCountry == '--Select--') {
            Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Please select the country.');
            Apexpages.addMessage(error);
            return null;
        }else{
            if(physicalCountry == 'CA - CANADA' && physicalStateCAUS =='--Select--'){
                Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Please select the State.');
                Apexpages.addMessage(error);
                return null;
               
            }else{
                if(physicalCountry == 'US - UNITED STATES' && physicalStateCAUS =='--Select--'){
                    Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Please select the State.');
                    Apexpages.addMessage(error);
                    return null;
                }
                
                
            }
        }
         if(CurrentUserRec.Related_Partner_Account__c == null){
             Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Related Partner Account not found on Partner User ');
            Apexpages.addMessage(error);
            return null;
             
         }
        try {
            	ReferralLead.Country =physicalCountry;
            if(physicalCountry == 'CA - CANADA'){
                ReferralLead.State =physicalStateCAUS;
            }else{
                if(physicalCountry == 'US - UNITED STATES'){
                    ReferralLead.State =physicalStateCAUS;
                }else{
                    ReferralLead.State =physicalStateFree;
                }
            }
            
           
                Database.UpsertResult UReferralLead= Database.upsert(ReferralLead);
            System.debug('ReferralLead2'+ReferralLead);
                isRegistrationcompleted =true;
                    if (UReferralLead.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted Lead ' + UReferralLead.getId());
                    LeadSendEmail(UReferralLead.getId());
                   if(ReferralQueueList.size() > 0){
                           ReferralLead.OwnerId = ReferralQueueList[0].id;
                        }
            		Database.UpsertResult UReferralLead1= Database.upsert(ReferralLead);
                        
                }
           
            	
            	
            
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        if(isleadnew == true){
            
            return null;
        }else{
              pageReference pageref = new pageReference('/apex/ReferralPortalPage');
              pageRef.setRedirect(true);
              return pageRef;
        }

	}
    public pagereference popupthestates(){
        if(physicalCountry == 'CA - CANADA'){
            respectedstates = getStateRegionsForCANADA();
            isstatepicklist =true;
        }else{
            if(physicalCountry == 'US - UNITED STATES'){
                respectedstates = getStateRegionsFor_US();
                isstatepicklist =true;
            }else{
                respectedstates =null;
                isstatepicklist =false;
            }
        }
            
        return null;
    }
    public pageReference viewpendingLeads(){
       	pageReference pageref = new pageReference('/apex/ReferralPortalPage');
        pageRef.setRedirect(true);
        return pageRef;
    }
    Public PageReference redirecttoLeads(){
        	pageReference pageref = new pageReference('/apex/ReferralPortalLeadPage');
              pageRef.setRedirect(true);
              return pageRef;
    }
    public List<SelectOption> getStateRegionsForCANADA() {
        List<SelectOption> StateRegionOptions = new List<SelectOption>();
        mapStatesForCA = prepareStatesForCanada();
        
        StateRegionOptions.add(new SelectOption('--Select--','--Select--'));
        List<String> statesList = new List<String>();
        statesList.addAll(mapStatesForCA.keySet());
        statesList.sort();
        for (string statekey:statesList)
            StateRegionOptions.add(new SelectOption(statekey,mapStatesForCA.get(statekey)));
        return StateRegionOptions;   
    }
    Public void LeadSendEmail(Id LeadId){
        if(LeadId != null){
            id userid = UserInfo.getUserId();
            Messaging.singleEmailMessage emailRequestNA = new Messaging.singleEmailMessage();
            emailRequestNA.setUseSignature(false);
            emailRequestNA.setTemplateId(Label.Referral_Portal_Email_Template);
            emailRequestNA.setTargetObjectId(userid);
            emailRequestNA.setWhatId(LeadId);
            emailRequestNA.saveAsActivity = false;
            emailRequestNA.setReplyTo('noreply@ca.com');
            emailRequestNA.setCcAddresses(new String[] {Label.ReferralCCAgileemail});
            emailRequestNA.setOrgWideEmailAddressId(Label.Referral_OrgWideEmailAddress);
            if(!test.isrunningtest())
                {
                    Messaging.SendEmailResult [] emailResultNA = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailRequestNA});
                }
            System.debug('emailRequestNA   -> '+emailRequestNA);
        }
        
    }
    public List<SelectOption> getStateRegionsFor_US() {
        List<SelectOption> StateRegionOptions = new List<SelectOption>();
        mapStatesForUS = prepareStatesForUS();
        StateRegionOptions.add(new SelectOption('--Select--','--Select--'));
        List<String> statesListUs = new List<String>();
        statesListUs.addAll(mapStatesForUS.keySet());
        statesListUs.sort();
        
        for (string statekey:statesListUs)
            StateRegionOptions.add(new SelectOption(statekey,mapStatesForUS.get(statekey)));
        
        return StateRegionOptions;
    }
    public Map<String,String> prepareStatesForUS()
    {
        Map<String,String> mapUSStates = new Map<String, String>();
        mapUSStates.put('Alabama','AL - Alabama');
        mapUSStates.put('Alaska','AK - Alaska');
        mapUSStates.put('Arkansas','AR - Arkansas');
        mapUSStates.put('Arizona','AZ - Arizona');
        mapUSStates.put('California','CA - California');
        mapUSStates.put('Colorado','CO - Colorado');
        mapUSStates.put('Connecticut','CT - Connecticut');
        mapUSStates.put('Delaware','DE - Delaware');
        mapUSStates.put('District Of Columbia','DC - District Of Columbia');
        mapUSStates.put('Florida','FL - Florida');
        mapUSStates.put('Georgia','GA - Georgia');
        mapUSStates.put('Hawaii','HI - Hawaii');
        mapUSStates.put('Idaho','ID - Idaho');
        mapUSStates.put('Illinois','IL - Illinois');
        mapUSStates.put('Indiana','IN - Indiana');
        mapUSStates.put('Iowa','IA - Iowa');
        mapUSStates.put('Kansas','KS - Kansas');
        mapUSStates.put('Kentucky','KY - Kentucky');
        mapUSStates.put('Louisiana','LA - Louisiana');
        mapUSStates.put('Maine','ME - Maine');
        mapUSStates.put('Maryland','MD - Maryland');
        mapUSStates.put('Massachusetts','MA - Massachusetts');
        mapUSStates.put('Michigan','MI - Michigan');
        mapUSStates.put('Minnesota','MN - Minnesota');
        mapUSStates.put('Mississippi','MS - Mississippi');
        mapUSStates.put('Missouri','MO - Missouri');
        mapUSStates.put('Montana','MT - Montana');
        mapUSStates.put('Nebraska','NE - Nebraska');
        mapUSStates.put('Nevada','NV - Nevada');
        mapUSStates.put('New Hampshire','NH - New Hampshire');
        mapUSStates.put('New Jersey','NJ - New Jersey');
        mapUSStates.put('New Mexico','NM - New Mexico');
        mapUSStates.put('New York','NY - New York');
        mapUSStates.put('North Carolina','NC - North Carolina');
        mapUSStates.put('North Dakota','ND - North Dakota');
        mapUSStates.put('Ohio','OH - Ohio');
        mapUSStates.put('Oklahoma','OK - Oklahoma');
        mapUSStates.put('Oregon','OR - Oregon');
        mapUSStates.put('Pennsylvania','PA - Pennsylvania');
        mapUSStates.put('Rhode Island','RI - Rhode Island');
        mapUSStates.put('South Carolina','SC - South Carolina');
        mapUSStates.put('South Dakota','SD - South Dakota');
        mapUSStates.put('Tennessee','TN - Tennessee');
        mapUSStates.put('Texas','TX - Texas');
        mapUSStates.put('Utah','UT - Utah');
        mapUSStates.put('Vermont','VT - Vermont');
        mapUSStates.put('Virginia','VA - Virginia');
        mapUSStates.put('Washington','WA - Washington');
        mapUSStates.put('West Virginia','WV - West Virginia');
        mapUSStates.put('Wisconsin','WI - Wisconsin');
        mapUSStates.put('Wyoming','WY - Wyoming');
        return mapUSStates;
    }
     public Map<String,String> prepareStatesForCanada()
    {
        Map<String,String> mapCAStates = new Map<String, String>();
        mapCAStates.put('Alberta','AB - Alberta');
        mapCAStates.put('British','BC - British ');
        mapCAStates.put('Manitoba','MB - Manitoba');
        mapCAStates.put('New Brunswick','NB - New Brunswick');
        mapCAStates.put('Newfoundland and Labrador','NL - Newfoundland and Labrador');
        mapCAStates.put('Nova Scotia','NS - Nova Scotia');
        mapCAStates.put('Ontario','ON - Ontario');
        mapCAStates.put('Prince Edward Island','PE - Prince Edward Island');
        mapCAStates.put('Quebec','QC - Quebec');
        mapCAStates.put('Saskatchewan','SK - Saskatchewan');
        mapCAStates.put('Northwest Territories','NT - Northwest Territories');
        mapCAStates.put('Nunavut','NU - Nunavut');
        mapCAStates.put('Yukon','YT - Yukon');
        return mapCAStates;
    }

}