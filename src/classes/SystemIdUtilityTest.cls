@isTest
private class SystemIdUtilityTest {
	
	@isTest static void skip_opportunity_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'Opportunity', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipOpportunityTriggers; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_opportunity_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'Opportunity');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipOpportunityTriggers; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_opportunity_triggers_integration_should_return_true_if_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'OpportunityIntegration', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipOpportunityTriggersIntegration; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_opportunity_triggers_integration_should_return_false_if_user_not_inactive_on_integration_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'OpportunityIntegration');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipOpportunityTriggersIntegration; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_opportunity_lineitem_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'OpportunityLineItem', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipOpportunityLineItemTriggers; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_opportunity_line_itemtriggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'OpportunityLineItem');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipOpportunityLineItemTriggers; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_opportunity_lineitem_triggers_integration_should_return_true_if_inactive_for_user_on_integration_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'OpportunityLineItemIntegration', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipOpportunityLineItemTriggersIntegration; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_opportunity_line_itemtriggers_integration_should_return_false_if_user_not_inactive_on_integration_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'OpportunityLineItemIntegration');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipOpportunityLineItemTriggersIntegration; 
		//Then
		System.assertEquals(false, skipTrigger);
	}


	@isTest static void skip_TSORequest_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TSO_Request', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTSORequestTriggers; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TSORequest_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TSO_Request');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTSORequestTriggers; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_TAQOrganization_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Organization', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_Organization; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQOrginization_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Organization');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_Organization; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_TAQOrganization_approved_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Organization_Approved', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_OrganizationApproved; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQOrginization_approved_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Organization_Approved');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_OrganizationApproved; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_TAQOrgquota_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Org_Quota', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_OrgQuota; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQOrgquota_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Org_Quota');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_OrgQuota; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_TAQOrgquota_approved_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Org_Quota_Approved', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_OrgQuotaApproved; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQOrgquota_approved_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Org_Quota_Approved');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_OrgQuotaApproved; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_TAQAccount_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_Account; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQAccount_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_Account; 
		//Then
		System.assertEquals(false, skipTrigger);
	}


	@isTest static void skip_TAQAccount_approved_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account_Approved', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_AccountApproved; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQAccount_approved_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account_Approved');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_AccountApproved; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

	@isTest static void skip_TAQAccountTeam_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account_Team', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_AccountTeam; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQAccountTeam_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account_Team');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_AccountTeam; 
		//Then
		System.assertEquals(false, skipTrigger);
	}	
	@isTest static void skip_TAQAccountTeam_approved_triggers_should_return_true_if_inactive_for_user() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account_Team_Approved', Inactive_for_User__C = UserInfo.getUserId());
		insert customSetting;
		//When 
		Boolean skipTrigger = SystemIdUtility.skipTAQ_AccountTeamApproved; 
		//Then 
		System.assertEquals(true, skipTrigger);
	}
	
	@isTest static void skip_TAQAccountTeam_approved_triggers_should_return_false_if_user_not_inactive() {
		//Given
		Triggers_Inactive__c customSetting = new Triggers_Inactive__c(Name = 'TAQ_Account_Team_Approved');
		insert customSetting;
		//When
		Boolean skipTrigger = SystemIdUtility.skipTAQ_AccountTeamApproved; 
		//Then
		System.assertEquals(false, skipTrigger);
	}

}