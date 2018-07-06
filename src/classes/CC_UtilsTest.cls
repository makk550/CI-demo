@isTest
private class CC_UtilsTest {
  @isTest
  static void it_should_resolve_all_known_ldap_timezones() {
    for (String ldapTimezone : ldapTimezones) {
      String resolvedTimezone = CC_Utils.resolveLdapTimezone(ldapTimezone);
      System.assertNotEquals(null, resolvedTimezone);
    }
  }

  @isTest
  static void it_should_return_null_for_non_matches() {
    String[] ldapTimezones = new String[]{
      '',
      'some string',
      'some;other;string',
      'some really long string with more than 40 characters and it need some trimming'
    };
    for (String ldapTimezone : ldapTimezones) {
      String resolvedTimezone = CC_Utils.resolveLdapTimezone(ldapTimezone);
      System.assertEquals(null, resolvedTimezone);
    }
  }

  @isTest
  static void it_should_ignore_exceptions() {
    CC_Utils.resolveLdapTimezone(null);
  }


  @isTest
  static void it_should_translate_ldap_lang_to_sf_lang(){
    String result = CC_Utils.resolveLdapLanguage('ENG');
    System.assertEquals('English', result);
  }

  @isTest
  static void random_string_should_return_null(){
    String result = CC_Utils.resolveLdapLanguage('Pokemon');
    System.assertEquals(null, result);
  }

  @isTest
  static void null_should_return_null(){
    String result = CC_Utils.resolveLdapLanguage(null);
    System.assertEquals(null, result);
  }

  @isTest
  static void blank_string_should_return_null(){
    String result = CC_Utils.resolveLdapLanguage('');
    System.assertEquals(null, result);
  }


  @isTest
  static void it_should_translate_ldap_country_to_sf_country(){
    String result = CC_Utils.resolveLdapCountry('AL');
    System.assertEquals('AL - ALBANIA',result);
  }

  @isTest
  static void it_should_return_ldap_country_if_sf_country_not_found(){
    String result = CC_Utils.resolveLdapCountry('ZZ');
    System.assertEquals('ZZ',result);
  }

  @isTest
  static void isEmpty_should_check_for_null_values() {
    system.assertEquals(true, CC_Utils.isEmpty(null));
  }

  @isTest
  static void isEmpty_should_check_for_blank_values() {
    system.assertEquals(true, CC_Utils.isEmpty(''));
  }

  @isTest
  static void isEmpty_should_check_for_spaces_only() {
    system.assertEquals(true, CC_Utils.isEmpty(' '));
  }

  @isTest
  static void isEmpty_should_check_for_strings() {
    system.assertEquals(false, CC_Utils.isEmpty(' 123 '));
  }

  @isTest
  static void isEmpty_convert_integer_to_string() {
    system.assertEquals(false, CC_Utils.isEmpty(123));
  }

  @isTest
  static void padSiteIdforGS_should_pad_siteid_with_exactly_7_characters(){
    System.assertEquals('0123456',CC_Utils.padSiteIdforGS('123456'));
  }

  @isTest
  static void padSiteId_should_pad_siteid_with_less_than_6_characters(){
    System.assertEquals('000123',CC_Utils.padSiteId('123'));
  }

  @isTest
  static void padSiteId_should_not_pad_siteid_with_exactly_6_characters(){
    System.assertEquals('123456', CC_Utils.padSiteId('123456'));
  }

  @isTest
  static void padSiteId_should_not_pad_siteid_with_more_than_6_characters(){
    System.assertEquals('1234567', CC_Utils.padSiteId('1234567'));
  }

  @isTest
  static void padSiteId_should_not_pad_siteid_with_0_characters(){
    System.assertEquals(null, CC_Utils.padSiteId(''));
  }

  @isTest
  static void padSiteId_should_return_null_when_passed_null(){
    System.assertEquals(null, CC_Utils.padSiteId(null));
  } 
    
 @isTest
  static void fetchSmallestSiteId_should_return_smallest_value(){
      List<String> sitelist = new List<String> {'123456', '47','0000'};
    System.assertEquals('0', CC_Utils.fetchSmallestSiteId(sitelist));
  } 
  @isTest
  static void test_removeNonAlphChars(){
     String s = 'lu$ga01';
    System.assertEquals('luga01', CC_Utils.removeNonAlphChars(s));
  } 


  @IsTest
  static void navigateToPath_should_navigate_to_path() {
    // Given
    String jsonResult = '{"1":{"1-1":"1-1","1-2":{"1-2-1":"1-2-1"}},"2":"2","3":{"3-1":{"3-1-1":"3-1-1","3-1-2":[1,2,3]},"3-2":[{"3-2-1":"3-2-1"},{"3-2-2":"3-2-2"}],"3-3":{"3-3-1":[],"3-3-2":"3-3-2Value"}}}';

    JSONParser parser = JSON.createParser(jsonResult);
    String path = '3.3-1.3-1-2';

    // When
    CC_Utils.navigateToPath(parser, path);
    
    // Then
    System.assertEquals(new Integer[]{1,2,3}, parser.readValueAs(List<Integer>.class));
    System.assertEquals('3-1-2', parser.getCurrentName());
  }

  private static String[] ldapTimezones = new String[]{
    '(GMT)Casablanca,Monrovia;0.0',
    '(GMT)Greenwich MeanTime:Dublin,Edinburg,Lisbon,London;0.0',
    '(GMT+01:00)Amsterdam,Berlin,Bern,Rome,Stockholm,Vienna;0.0',
    '(GMT+01:00)Belgrade,Bratislava,Budapest,Ljublijana,Prague;0.0',
    '(GMT+01:00)Brussels,Copenhagen,Madrid,Paris;0.0',
    '(GMT+01:00)Sarajevo,Skopje,Sofija,Vilnius,Warsaw,Zagreb;0.0',
    '(GMT+01:00)West Central Africa;0.0',
    '(GMT+02:00)Athens,Istanbul,Minsk;0.0',
    '(GMT+02:00)Bucharest;0.0',
    '(GMT+02:00)Cairo;0.0',
    '(GMT+02:00)Harare,Pretoria;0.0',
    '(GMT+02:00)Helsinki,Riga,Talinn;0.0',
    '(GMT+02:00)Jerusalem;0.0',
    '(GMT+03:00)Baghdad;0.0',
    '(GMT+03:00)Kuwait,Riyadh;0.0',
    '(GMT+03:00)Moscow,St,Petersburg,Volgograd;0.0',
    '(GMT+03:00)Nairobi;0.0',
    '(GMT+03:30)Tehran;0.0',
    '(GMT+04:00)Abu Dhabi,Muscat;0.0',
    '(GMT+04:00)Baku,Yerevan;0.0',
    '(GMT+04:00)Tbisli;0.0',
    '(GMT+04:30)Kabul;0.0',
    '(GMT+05:00)EkatarinBurg;0.0',
    '(GMT+05:00)Islamabad,Karachi,Tashkent;0.0',
    '(GMT+05:30)Calcutta,Chennai,Mumbai,New Delhi;0.0',
    '(GMT+05:45)Kathmandu;0.0',
    '(GMT+06:00)Almaty;0.0',
    '(GMT+06:00)Astana,Dhaka;0.0',
    '(GMT+06:00)Novosibirisk;0.0',
    '(GMT+06:00)Sri Jayawardenapura;0.0',
    '(GMT+06:30)Rangoon;0.0',
    '(GMT+07:00)Bangkok;0.0',
    '(GMT+07:00)Krasnoyarsk;0.0',
    '(GMT+08:00)Beijing,Chongging,Hongkong,Urumqi;0.0',
    '(GMT+08:00)Iruktsk,Ulaan Bataar;0.0',
    '(GMT+08:00)Kualalumpur,Singapore;0.0',
    '(GMT+08:00)Perth;0.0',
    '(GMT+08:00)Taipai;0.0',
    '(GMT+09:00)Osaka,Sapporo,Tokyo;0.0',
    '(GMT+09:00)Seoul;0.0',
    '(GMT+09:00)Yakutsk;0.0',
    '(GMT+09:30)Adelaide;0.0',
    '(GMT+09:30)Darwin;0.0',
    '(GMT+10:00)Brisbane;0.0',
    '(GMT+10:00)Canbera,Melbourne,Sydney;0.0',
    '(GMT+10:00)Guam,Port Moresby;0.0',
    '(GMT+10:00)Hobart;0.0',
    '(GMT+10:00)Vladivostok;0.0',
    '(GMT+11:00)Magadan,Solomon Is;0.0',
    '(GMT+11:00)New Caledonia;0.0',
    '(GMT+12:00)Auckland,Wellington;0.0',
    '(GMT+12:00)Fiji,Kamtchatka,Marshall Is.;0.0',
    '(GMT+13:00)Nuku\'alofa;0.0',
    '(GMT-01:00)Azores;0.0',
    '(GMT-01:00)Cape Verde Is.;0.0',
    '(GMT-02:00)Mid Atlantic;0.0',
    '(GMT-03:00)Brasilia;0.0',
    '(GMT-03:00)Buenos Aires,Georgetown;0.0',
    '(GMT-03:00)Greenland;0.0',
    '(GMT-03:30)Newfoundland;0.0',
    '(GMT-04:00)Atlantic Time(Canada);0.0',
    '(GMT-04:00)Caracas,La Paz;0.0',
    '(GMT-04:00)Santiago;0.0',
    '(GMT-05:00)Bogota,Lima,Quito;0.0',
    '(GMT-05:00)Eastern Time(US & Canada);0.0',
    '(GMT-05:00)Indiana(East);0.0',
    '(GMT-06:00)Central America;0.0',
    '(GMT-06:00)Central Time(US & Canada);0.0',
    '(GMT-06:00)Mexico City;0.0',
    '(GMT-06:00)Saskatchewan;0.0',
    '(GMT-07:00)Arizona;0.0',
    '(GMT-07:00)Mountain Time(US&Canada);0.0',
    '(GMT-08:00)PacificTime(US & Canada),Tijuana;0.0',
    '(GMT-09:00)Alaska;0.0',
    '(GMT-10:00)Hawaii;0.0',
    '(GMT-11:00)MidwayIsland,Samoa;0.0',
    '(GMT-12:00)Eniwetok,kwajalein;0.0'
  };
}