@isTest
public with sharing class CC_LDAPRolesTest {
	@IsTest
	static void it_should_parse_cns_from_connectmemberof_attribute() {
  	// given
  	CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
  	Set<String> expectedCns = new Set<String> {
  		'SCONNECT_CA_USER_TEST',
  		'SConnect_Impleng_Test'
  	};
  	String connectMemberOf = 'cn=SCONNECT_CA_USER_TEST,ou=Connect Authority,o=Computer Associates,c=US^cn=SConnect_Impleng_Test, ou=Connect Authority,o=Computer Associates,c=US';
    // when
    Set<String> cns = ldapRoles.extractCNAttributes(connectMemberOf);
  	// then
  	System.assertEquals(expectedCns, cns);
  }	

  @isTest 
  static void it_should_build_a_value_string() {
		// given
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		String expectedString = 'SCONNECT_CA_USER_TEST;SConnect_Impleng_Test';
		String connectMemberOf = 'cn=SCONNECT_CA_USER_TEST,ou=Connect Authority,o=Computer Associates,c=US^cn=SConnect_Impleng_Test, ou=Connect Authority,o=Computer Associates,c=US';
		// when
		String result = ldapRoles.buildValueString(connectMemberOf);
		// then
		System.assertEquals(expectedString, result);
	}

	@isTest 
	static void buildValueString_should_return_same_results_given_same_inputs() {
		// given
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		String expectedString = 'SCONNECT_CA_USER_TEST;SConnect_Impleng_Test';
		String connectMemberOf = 'cn=SCONNECT_CA_USER_TEST,ou=Connect Authority,o=Computer Associates,c=US^cn=SConnect_Impleng_Test, ou=Connect Authority,o=Computer Associates,c=US';
		String result = ldapRoles.buildValueString(connectMemberOf);
		System.assertEquals(expectedString, result);

		// when
		result = ldapRoles.buildValueString(connectMemberOf);
		// then
		System.assertEquals(expectedString, result);
	}

	@isTest
	static void it_should_return_ldap_cn_value_if_no_translation_found(){
		// given
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		String cnValue = 'SCONNECT_CA_USER_TEST';
		// when
		String result = ldapRoles.translateCNValue(cnValue);
		// then
		System.assertEquals(cnValue, result);
	}

	@isTest
	static void it_should_translate_ldap_cn_value_to_sf_value(){
		// given
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		String cnValue = 'SCONNECT_CA_USER_NODOWNLOAD';
		String expectedCn = 'CA Internal User With No Downloads';
		// when
		String result = ldapRoles.translateCNValue(cnValue);
		// then
		System.assertEquals(expectedCn, result);
	}

	@isTest
	static void it_should_ignore_case_when_translating_ldap_cn_value_to_sf_value(){
		// given
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		String cnValue = 'ScOnNEcT_CA_USER_NODOWNLOAD';
		String expectedCn = 'CA Internal User With No Downloads';
		// when
		String result = ldapRoles.translateCNValue(cnValue);
		// then
		System.assertEquals(expectedCn, result);
	}

	@IsTest
	static void it_should_allow_access_to_CC_when_user_has_specific_role() {
		// given
		String userRoles = 'role 1;role 2;role 3';
		CC_Settings.allowAccessRoles = new Set<String>{'role 2', 'another role'};
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		// when
		Boolean result = ldapRoles.allowAccessToCustomerCommunity(userRoles);
		// then
		System.assertEquals(true, result);
	}

	@IsTest
	static void it_should_not_allow_access_to_CC_when_user_does_not_have_specific_role() {
		// given
		String userRoles = 'role 1;role 2;role 3';
		CC_Settings.allowAccessRoles = new Set<String>{'another role 1', 'another role 2'};
		CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
		// when
		Boolean result = ldapRoles.allowAccessToCustomerCommunity(userRoles);
		// then
		System.assertEquals(false, result);
	}


}