global class Configuration {

    //==================================================
    // CONSTANTS
    //==================================================
    global static final String KEY_SEARCH_SCREEN_BASIC_SEARCH_FIELDS       = 'FIELDS_BASIC_SEARCH';
    global static final String KEY_SEARCH_SCREEN_ADVANCED_SEARCH_FIELDS    = 'FIELDS_ADVANCED_SEARCH';
    global static final String KEY_SEARCH_SCREEN_FIELDS_IN_RESULT_LIST     = 'FIELDS_IN_RESULTS_LIST';
    global static final String KEY_SEARCH_SCREEN_SORTABLE_FIELDS           = 'FIELDS_SORTING';
    global static final String KEY_DETAIL_SCREEN_COMPANY_BASIC_FIELDS      = 'FIELDS_DETAIL_BASIC';
    global static final String KEY_DETAIL_SCREEN_COMPANY_EXTENDED_FIELDS   = 'FIELDS_DETAIL_OVERVIEW';
    //global static final String KEY_DETAIL_SCREEN_LOCATION_FIELDS           = 'FIELDS_DETAIL_LOCATION';
    global static final String KEY_DETAIL_SCREEN_LOCATION_FIELDS           = 'FIELDS_LOCATION_EDIT';    
    global static final String KEY_DETAIL_SCREEN_EDIT_FIELDS               = 'FIELDS_DETAIL_EDIT';
    global static final String KEY_GOOGLE_MAPS_API_KEY                     = 'GOOGLE_MAPS_API_KEY';
    global static final String KEY_GOOGLE_MAPS_API_KEY_SITES               = 'GOOGLE_MAPS_API_KEY_SITES';
    global static final String KEY_TERMS_AND_CONDITIONS_URL                = 'TERMS_AND_CONDITIONS_URL';
    global static final String KEY_IMAGE_URL_RECOMMENDED_PARTNER           = 'IMAGE_URL_RECOMMENDED_PARTNER';
    global static final String KEY_SEARCH_HELP_URL                         = 'SEARCH_HELP_URL';
    global static final String KEY_SEARCH_DISTANCE_DEFAULT                 = 'SEARCH_DISTANCE_DEFAULT';
    global static final String KEY_SEARCH_DISTANCE_OPTIONS                 = 'SEARCH_DISTANCE_OPTIONS';
    
    global static String sortColumn                                        = 'Partner_Location__c.NAME';
    
    private static final String[] ALL_CONFIG_KEY = new String[]{
         KEY_GOOGLE_MAPS_API_KEY
        ,KEY_GOOGLE_MAPS_API_KEY_SITES
        ,KEY_SEARCH_SCREEN_ADVANCED_SEARCH_FIELDS
        ,KEY_SEARCH_SCREEN_BASIC_SEARCH_FIELDS
        ,KEY_SEARCH_SCREEN_FIELDS_IN_RESULT_LIST
        ,KEY_DETAIL_SCREEN_COMPANY_BASIC_FIELDS
        ,KEY_DETAIL_SCREEN_COMPANY_EXTENDED_FIELDS
        ,KEY_DETAIL_SCREEN_LOCATION_FIELDS
        ,KEY_DETAIL_SCREEN_EDIT_FIELDS
        ,KEY_SEARCH_SCREEN_SORTABLE_FIELDS
        ,KEY_TERMS_AND_CONDITIONS_URL
        ,KEY_IMAGE_URL_RECOMMENDED_PARTNER
        ,KEY_SEARCH_HELP_URL
        ,KEY_SEARCH_DISTANCE_DEFAULT
        ,KEY_SEARCH_DISTANCE_OPTIONS
    };

    //==================================================
    // PROPERTIES
    //==================================================
    private Map<String,String> rawConfig = null;

    global Integer searchDistanceDefault        {get;set;}
    global List<Integer> searchDistanceOptions  {get;set;}

    //==================================================
    // DERIVED PROPERTIES
    //==================================================
    global List<FieldConfiguration> searchScreenBasicSearchFields {get{
    	if(searchScreenBasicSearchFields == null){
    		searchScreenBasicSearchFields = load(KEY_SEARCH_SCREEN_BASIC_SEARCH_FIELDS);
    	}
        return searchScreenBasicSearchFields;
    }private set;}
    
    global List<FieldConfiguration> searchScreenAdvancedSearchFields {get{
        if(searchScreenAdvancedSearchFields == null){
        	searchScreenAdvancedSearchFields = load(KEY_SEARCH_SCREEN_ADVANCED_SEARCH_FIELDS);
        }
        return searchScreenAdvancedSearchFields;
    }private set;}

    global List<FieldConfiguration> searchScreenFieldsInResultList {get{
        if(searchScreenFieldsInResultList == null){
            searchScreenFieldsInResultList = load(KEY_SEARCH_SCREEN_FIELDS_IN_RESULT_LIST);	
        }
        return searchScreenFieldsInResultList;
    }private set;}

    global List<FieldConfiguration> searchScreenSortableFields {get{
        if(searchScreenSortableFields == null){
           searchScreenSortableFields = load(KEY_SEARCH_SCREEN_SORTABLE_FIELDS);
        } 
        return searchScreenSortableFields;
    }private set;}

    global List<FieldConfiguration> detailScreenCompanyBasicFields {get{
        if(detailScreenCompanyBasicFields == null){
           detailScreenCompanyBasicFields = filterByObjectName(load(KEY_DETAIL_SCREEN_COMPANY_BASIC_FIELDS),'Account');
        } 
        System.debug('### detailScreenCompanyBasicFields: ' + detailScreenCompanyBasicFields);
        return detailScreenCompanyBasicFields;
    }private set;}

    global List<FieldConfiguration> detailScreenCompanyExtendedFields {get{
        if(detailScreenCompanyExtendedFields == null){
        	detailScreenCompanyExtendedFields = filterByObjectName(load(KEY_DETAIL_SCREEN_COMPANY_EXTENDED_FIELDS),'Account');
        } 
        return detailScreenCompanyExtendedFields;
    }private set;}

    global List<FieldConfiguration> detailScreenLocationFields {get{
        if(detailScreenLocationFields == null){
            detailScreenLocationFields = load(KEY_DETAIL_SCREEN_LOCATION_FIELDS);
        } 
        return detailScreenLocationFields;
    }private set;}

    global List<FieldConfiguration> detailScreenEditFields {get{
        if(detailScreenEditFields == null){
            detailScreenEditFields = load(KEY_DETAIL_SCREEN_EDIT_FIELDS);
        } 
        return detailScreenEditFields;
    }private set;}

    global String googleMapsApiKey              {get{return get(KEY_GOOGLE_MAPS_API_KEY          );}}
    global String googleMapsApiKeyForSites      {get{return get(KEY_GOOGLE_MAPS_API_KEY_SITES    );}}
    global String imageUrlRecommendedPartner    {get{return get(KEY_IMAGE_URL_RECOMMENDED_PARTNER);}}
    global String searchHelpUrl                 {get{return get(KEY_SEARCH_HELP_URL              );}}
    global String termsAndConditionsUrl         {get{return get(KEY_TERMS_AND_CONDITIONS_URL     );}}

    global Boolean isTermsConditionsFeatureEnabled{
        get{return StringUtils.isNotEmpty(termsAndConditionsUrl);}
    }

    //==================================================
    // CONSTRUCTOR
    //==================================================
    private Configuration(){
        this.rawConfig = new Map<String,String>();
        final List<Configuration_Variable__c> vars = 
            [select Value__c, Name, Id 
            from Configuration_Variable__c 
            where name in :ALL_CONFIG_KEY];
        if(vars != null && vars.size() > 0){
            for(Configuration_Variable__c var : vars){
                this.rawConfig.put(StringUtils.trim(var.name),var.value__c);
            }
        }
        this.searchDistanceDefault = parseInteger(get(KEY_SEARCH_DISTANCE_DEFAULT));
        this.searchDistanceOptions = parseIntegerList(get(KEY_SEARCH_DISTANCE_OPTIONS));
    }
    
    //==================================================
    // HELPER METHODS
    //==================================================
    global static Configuration instance;
    
    global static Configuration getInstance(){
        if(instance == null){
            instance = new Configuration();
        }
        return instance;
    }
    
    private List<FieldConfiguration> loadIfNull( List<FieldConfiguration> fieldConfigList, final String key){
        if(fieldConfigList == null){
            fieldConfigList = load(key);
        }
        return fieldConfigList;
    }


    private List<FieldConfiguration> load( final String key){
    	List<FieldConfiguration> returnValue = filterInvalidFields(FieldConfiguration.parse(get(key)));
    	System.debug('### loaded fields for key [' + key + ']: ' + returnValue);
        return returnValue; 
    }

    private List<FieldConfiguration> filterByObjectName(  final List<FieldConfiguration> fieldConfigurations,
                                                           final String objectName)
    {
        final List<FieldConfiguration> filtered = new List<FieldConfiguration>();
        if(fieldConfigurations != null && fieldConfigurations.size() > 0){
            for(FieldConfiguration fieldConfiguration : fieldConfigurations){
            	if(StringUtils.equalsIgnoreCase(objectName,fieldConfiguration.objectName)){
            		filtered.add(fieldConfiguration);
            	}
            }
        }
        return filtered;
    }
    private String get(String key){
        String returnValue = null;
        if(StringUtils.isNotBlank(key) && this.rawConfig.containsKey(key)){
            returnValue = this.rawConfig.get(key);
        }
        return returnValue;
    }
    
    private List<FieldConfiguration> filterInvalidFields(  final List<FieldConfiguration> fieldConfigurations){
    	System.debug('### fieldConfigurations: ' + fieldConfigurations);
        final FieldIndex fieldIndex = new FieldIndex().indexType(
            new List<Schema.DescribeSObjectResult>{
                Schema.sObjectType.Account,
                Schema.sObjectType.Partner_Location__c
            }
        );
        System.debug('### fieldIndex: ' + fieldIndex);
        final List<FieldConfiguration> validFields = new List<FieldConfiguration>();
        if(fieldIndex != null && fieldConfigurations != null && fieldConfigurations.size() > 0){
            for(FieldConfiguration fieldConfiguration : fieldConfigurations){
            	System.debug('### fieldIndex.isValidField(\'' 
                    + fieldConfiguration.objectName 
                    + '\', \'' 
                    + fieldConfiguration.fieldName 
                    + '\'): ' 
                	+ fieldIndex.isValidField(fieldConfiguration.objectName, fieldConfiguration.fieldName));
                if(fieldIndex.isValidField(fieldConfiguration.objectName, fieldConfiguration.fieldName)){
                    fieldConfiguration.populateFieldsFromDescribe(
                       fieldIndex.getDescribeForField(
                           fieldConfiguration.objectName, 
                           fieldConfiguration.fieldName
                       )
                    );
                    validFields.add(fieldConfiguration);
                }
            }
        }
        return validFields;
    }

    public static Integer parseInteger(String value){
    	Integer returnValue = null;
    	if(StringUtils.isNotBlank(value)){
	    	try{
	    		returnValue = Integer.valueOf(value);
	    	}catch(System.TypeException e){}
        }
        return returnValue;
    }

    public static List<Integer> parseIntegerList(String value){
    	List<Integer> returnValue = new List<Integer>();
        List<String> split = StringUtils.split(value,'|');
    	if(split != null && !split.isEmpty()){
    		Integer parsed = null;
    		for(String toParse : split){
    			parsed = parseInteger(toParse);
    			if(parsed != null){
    				returnValue.add(parsed);
    			}
    		}
    	}
        return returnValue;
    }

      
}