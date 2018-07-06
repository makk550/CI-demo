public class PartnerSearchAutoCompleteController {

    public List<String> results {get;set;}
    
    public static final String PARAM_KEYWORD = 'txtSearchFor';
    public static final String PARAM_LOCATION = 'txtLocation';
    
    public PartnerSearchAutoCompleteController(){
        final String keywordSearchStr = 
          getFirstMatchingParam(PARAM_KEYWORD) == null 
              ? null 
              : String.escapeSingleQuotes(getFirstMatchingParam(PARAM_KEYWORD));
        final String locationSearchStr = 
          getFirstMatchingParam(PARAM_LOCATION) == null 
              ? null 
              : String.escapeSingleQuotes(getFirstMatchingParam(PARAM_LOCATION));
        
        AutoCompleteSearch autoCompleteSearch = null;
        if(StringUtils.isNotEmpty(keywordSearchStr)){
            autoCompleteSearch = new AutoCompletePartnerName(keywordSearchStr);
        } else if(StringUtils.isNotEmpty(locationSearchStr)){
            autoCompleteSearch = new AutoCompleteLocation(locationSearchStr);
        } else {
            
        }
        this.results = autoCompleteSearch == null ? new List<String>() : autoCompleteSearch.execute();
    }
    
    private String getFirstMatchingParam(String paramName){
        Map<String,String> params = PageUtils.getParameters(paramName);
        return params == null || params.size() <= 0 ? null : params.values().get(0);
    }

}