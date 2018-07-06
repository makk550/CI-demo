@isTest
private class CC_SettingsTest{
	@isTest
	static void it_should_initialize_csoUrl(){
		String result = CC_Settings.csoUrl;
		System.assertNotEquals(null ,result);
	}

	@isTest
	static void it_should_initialize_communityUserProfileId(){
		String result = CC_Settings.communityUserProfileId ;
		System.assertNotEquals(null, result);
	}

	@isTest
	static void it_should_instantiate_communityUserDefaultAccountId(){
		String result = CC_Settings.communityUserDefaultAccountId;
		System.assertNotEquals(null, result);		
	}

	@isTest
	static void it_should_instantiate_searchDotCaDotComSourceId (){
		String result = CC_Settings.searchDotCaDotComSourceId ;
		System.assertNotEquals(null, result);	
	}

	@isTest
	static void it_should_instantiate_debugEnabled(){
		Boolean result = CC_Settings.debugEnabled;
		System.assertNotEquals(null, result);
	}
	
	@isTest
	static void it_should_instantiate_caseSearchMaxResults(){
		Integer result = CC_Settings.caseSearchMaxResults;
		System.assertNotEquals(null, result);
	}

	@isTest
	static void it_should_instantiate_allowAccessRoles(){
		Set<String> result = CC_Settings.allowAccessRoles;
		System.assertNotEquals(null, result);
	}

	@isTest
	static void it_should_instantiate_careUrl(){
		String result = CC_Settings.careUrl;
		System.assertNotEquals(null, result);
	}

	@isTest
	static void it_should_instantiate_communityExternalUserProfileId(){
		String result = CC_Settings.communityExternalUserProfileId;
		System.assertNotEquals(null, result);		
	}	
	@isTest
	static void it_should_get_product_gscId(){
		String result = CC_Settings.prodGSCId;
		System.assertNotEquals(null, result);		
	}	@isTest
	static void it_should_get_lmpkey(){
		String result = CC_Settings.comLPMKEY;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_get_default_siteId_no_access(){
		String result = CC_Settings.defaultSiteIDforNoAccess;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_get_scnect(){
		String result = CC_Settings.comSCNECT;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_get_eai_aws_token_url(){
		String result = CC_Settings.eaiAWSTokenURL;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_ret_show_solution_url(){
		String result = CC_Settings.csoShowSolutionURL;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_eai_baseurl(){
		String result = CC_Settings.AWSAPIGatewayBaseURL;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_GlobalScape_URL(){
		String result = CC_Settings.globalScapeUrl;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_L7_GlobalScape_URL(){
		String result = CC_Settings.L7GlobalScapeUrl;
		System.assertNotEquals(null, result);		
	}

	@isTest
	static void it_should_return_customerCommunityGuestProfileId(){
		String result = CC_Settings.customerCommunityGuestProfileId;
		System.assertNotEquals(null, result);		
	}

	@isTest
	static void it_should_return_missingContactId(){
		String result = CC_Settings.missingContactId;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_componentALPKEY(){
		String result = CC_Settings.componentALPKEY;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_componentTLC(){
		String result = CC_Settings.componentTLC;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_componentGSCOTH(){
		String result = CC_Settings.componentGSCOTH;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_componentGSCPRM(){
		String result = CC_Settings.componentGSCPRM;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_componentGSCLMS(){
		String result = CC_Settings.componentGSCLMS;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_helptext(){
		List<CC_Help_Text__mdt> result = CC_Settings.getHelpText;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_security_groups(){
		List<CC_Security_Groups_Config__c> result = CC_Settings.securityGroups;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_activity_flag_date(){
		String result = CC_Settings.activityFlagDate;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_paLicensing(){
		String result = CC_Settings.paLicensing;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_paCSP(){
		String result = CC_Settings.paCSP;
		System.assertNotEquals(null, result);		
	}
	@isTest
	static void it_should_return_cftpEnabled(){
		String result = CC_Settings.cftp_Enabled;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_gsEnabled(){
		String result = CC_Settings.gs_Enabled;
		System.assertNotEquals(null, result);		
	}
    @isTest
	static void it_should_return_cftpUrl(){
		String result = CC_Settings.cftp_url;
		System.assertNotEquals(null, result);		
	}
    
}