global class Partner {
	public ID id {get;set;}
	public Boolean isPartner {get;set;}
	public Boolean isEnabledByOrg {get;set;}
	public Boolean isEnabledByPartner {get;set;}
	public Boolean isTermsAndConditionsSignedByPartner{get;set;}
	public Boolean isEnabled {get{ return isPartner && isEnabledByOrg && isEnabledByPartner && isTermsAndConditionsSignedByPartner; }}
	public String name {get;set;}
	public String logoId {get;set;}
	public String logoRecordId{get; set;}
	public String accountEmail {get;set;}
	
	public static Partner build(Account acct, Configuration config){
		List<Account> accts = new List<Account>();
		accts.add(acct);
		Partner partner = new Partner();
		partner.id 										= acct.id;	
		partner.isPartner 								= acct.IsPartner;	
		partner.isEnabledByOrg 							= acct.Approved_for_Partner_Finder__c;	
		partner.isEnabledByPartner 						= 'yes'.equalsIgnoreCase(acct.Profile_Published_to_Partner_Finder__c);	
		partner.isTermsAndConditionsSignedByPartner		= !config.isTermsConditionsFeatureEnabled || 
		                                                  (acct.Partner_User_Agreed_to_PF_Terms_Cond__c != null 
		                                                  && acct.Partner_Date_Agreed_to_PF_Terms_Cond__c != null);
		partner.name 									= acct.name;
		partner.logoId									= getLogoId(accts);
		partner.logoRecordId							= acct.Logo__c;
		
		
		
		return partner;
	}
	
	private static String getLogoId(List<Account> accts){
		Set<Id> logoIds = new Set<Id>();
		for(Account acct : accts){
			logoIds.add(acct.Logo__c);
		}
		List<Attachment> logos = [select id,parentid from Attachment where parentid in :logoIds]; 
		if(logos != null && logos.size() > 0){
    		return logos[0].Id;
		} else {
			return null;
		}
	}
}