public class PartnerSearchConstants {
	public static final String CONFIG_KEY_GOOGLE_MAPS_API_KEY 			= 'GOOGLE_MAPS_API_KEY';
	public static final String CONFIG_KEY_GOOGLE_MAPS_API_KEY_SITES 	= 'GOOGLE_MAPS_API_KEY_SITES';
	public static final String CONFIG_KEY_FIELDS_SEARCHABLE_ADVANCED 	= 'FIELDS_ADVANCED_SEARCH';
	public static final String CONFIG_KEY_FIELDS_SEARCHABLE_BASIC 		= 'FIELDS_BASIC_SEARCH';
	public static final String CONFIG_KEY_FIELDS_IN_RESULT_LIST			= 'FIELDS_IN_RESULTS_LIST';
	public static final String CONFIG_KEY_FIELDS_DETAIL_BASIC			= 'FIELDS_DETAIL_BASIC';
	public static final String CONFIG_KEY_FIELDS_DETAIL_OVERVIEW		= 'FIELDS_DETAIL_OVERVIEW';
	public static final String CONFIG_KEY_FIELDS_DETAIL_LOCATION		= 'FIELDS_DETAIL_LOCATION';
	public static final String CONFIG_KEY_FIELDS_DETAIL_EDIT			= 'FIELDS_DETAIL_EDIT';
	public static final String CONFIG_KEY_FIELDS_SORTING 				= 'FIELDS_SORTING';
	public static final String CONFIG_KEY_TERMS_AND_CONDITIONS_URL 		= 'TERMS_AND_CONDITIONS_URL';
    public static final String CONFIG_KEY_IMAGE_URL_RECOMMENDED_PARTNER = 'IMAGE_URL_RECOMMENDED_PARTNER';
    public static final String CONFIG_KEY_SEARCH_HELP_URL               = 'SEARCH_HELP_URL';
	
	private static final String[] ALL_CONFIG_KEY = new String[]{
		 CONFIG_KEY_GOOGLE_MAPS_API_KEY
		,CONFIG_KEY_GOOGLE_MAPS_API_KEY_SITES
		,CONFIG_KEY_FIELDS_SEARCHABLE_ADVANCED
		,CONFIG_KEY_FIELDS_SEARCHABLE_BASIC
		,CONFIG_KEY_FIELDS_IN_RESULT_LIST
		,CONFIG_KEY_FIELDS_DETAIL_BASIC
		,CONFIG_KEY_FIELDS_DETAIL_OVERVIEW
		,CONFIG_KEY_FIELDS_DETAIL_LOCATION
		,CONFIG_KEY_FIELDS_DETAIL_EDIT
		,CONFIG_KEY_FIELDS_SORTING
		,CONFIG_KEY_TERMS_AND_CONDITIONS_URL
		,CONFIG_KEY_IMAGE_URL_RECOMMENDED_PARTNER
		,CONFIG_KEY_SEARCH_HELP_URL
	};

	public String GOOGLE_MAPS_API_KEY 			{get;private set;}
	public String GOOGLE_MAPS_API_KEY_SITES 	{get;private set;}
	public String FIELDS_SEARCHABLE_ADVANCED 	{get;private set;}
	public String FIELDS_SEARCHABLE_BASIC 		{get;private set;}
	public String FIELDS_IN_RESULT_LIST			{get;private set;}
	public String FIELDS_DETAIL_BASIC			{get;private set;}
	public String FIELDS_DETAIL_OVERVIEW		{get;private set;}
	public String FIELDS_DETAIL_LOCATION		{get;private set;}
	public String FIELDS_DETAIL_EDIT			{get;private set;}
	public String FIELDS_SORTING 				{get;private set;}
	public String TERMS_AND_CONDITIONS_URL		{get;private set;}
    public String IMAGE_URL_RECOMMENDED_PARTNER {get;private set;}
    public String SEARCH_HELP_URL               {get;private set;}
	

	public static PartnerSearchConstants getInstance(){
		Map<String,String> nameToValue = new Map<String,String>();
		List<Configuration_Variable__c> vars = [select Value__c, Name, Id from Configuration_Variable__c 
			where name in :ALL_CONFIG_KEY];
		if(vars != null && vars.size() > 0){
			for(Configuration_Variable__c var : vars){
				nameToValue.put(var.name,var.value__c);
			}
		}
		final PartnerSearchConstants constants = new PartnerSearchConstants();
		constants.GOOGLE_MAPS_API_KEY  			= nameToValue.get(CONFIG_KEY_GOOGLE_MAPS_API_KEY );
		constants.GOOGLE_MAPS_API_KEY_SITES  	= nameToValue.get(CONFIG_KEY_GOOGLE_MAPS_API_KEY_SITES );
		constants.FIELDS_SEARCHABLE_ADVANCED  	= nameToValue.get(CONFIG_KEY_FIELDS_SEARCHABLE_ADVANCED );
		constants.FIELDS_SEARCHABLE_BASIC  		= nameToValue.get(CONFIG_KEY_FIELDS_SEARCHABLE_BASIC );
		constants.FIELDS_IN_RESULT_LIST 		= nameToValue.get(CONFIG_KEY_FIELDS_IN_RESULT_LIST);
		constants.FIELDS_DETAIL_BASIC 			= nameToValue.get(CONFIG_KEY_FIELDS_DETAIL_BASIC);
		constants.FIELDS_DETAIL_OVERVIEW 		= nameToValue.get(CONFIG_KEY_FIELDS_DETAIL_OVERVIEW);
		constants.FIELDS_DETAIL_LOCATION 		= nameToValue.get(CONFIG_KEY_FIELDS_DETAIL_LOCATION);
		constants.FIELDS_DETAIL_EDIT 			= nameToValue.get(CONFIG_KEY_FIELDS_DETAIL_EDIT);
		constants.FIELDS_SORTING  				= nameToValue.get(CONFIG_KEY_FIELDS_SORTING );
		constants.TERMS_AND_CONDITIONS_URL		= nameToValue.get(CONFIG_KEY_TERMS_AND_CONDITIONS_URL);
        constants.IMAGE_URL_RECOMMENDED_PARTNER = nameToValue.get(CONFIG_KEY_IMAGE_URL_RECOMMENDED_PARTNER);
        constants.SEARCH_HELP_URL               = nameToValue.get(CONFIG_KEY_SEARCH_HELP_URL);
		 
		return constants;
	} 
}