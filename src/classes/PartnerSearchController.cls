global class PartnerSearchController extends PartnerFinderBaseController implements ObjectPaginatorListener{

    //==================================================
    // PROPERTIES
    //==================================================
    public Configuration                config                      {get; private set;} 
    public SearchForm                   form                        {get; private set;}
    public List<SearchHitWrapper>       hits                        {get; private set;} 
    public ObjectPaginator              paginator                   {get; set;} 
    public Boolean                      displayAdvancedSearchFlag   {get; set;}
    public Boolean                      displaySearchResultsFlag    {get; set;}
    public String                       sortColumn                  {get; set;}


    //  PUBLIC STATIC STRING ADDLQUERY{get;set;}//prm5.5
    //==================================================
    // CONSTRUCTOR  
    //==================================================
    public PartnerSearchController(){
        this.paramString = StringUtils.substringAfter(ApexPages.currentPage().getUrl(),'?');
    //    ADDLQUERY = 'null';//prm5.5
    }  
    
    //==================================================
    // ACTIONS
    //==================================================
    public PageReference doOnLoad(){
        this.config = Configuration.getInstance();
        this.hits = new List<SearchHitWrapper>();
        this.paginator = new ObjectPaginator(this);
        this.form = SearchForm.deSerialize(this.paramString);        
        if(!form.isBlank){
            //return search(); 
        }
        this.displayAdvancedSearchFlag = !form.advancedFieldsAreBlank;
        return null; 
    }
     
    public PageReference searchClicked(){ 
        return search(); 
    } 
    
    public PageReference refresh(){ 
        return null; 
    } 
    
    public PageReference search(){ 
        if(form != null){
            this.paginator.setRecords(
                wrap(
                    new Search(
                        form.getAttributeSearchCriteria()
                        ,form.getGeoSearchCriteria()
                    )
                    .addFields(buildFieldsInResultListForQueryAsSet(this.config))
                    .execute()
                )
            );
            this.displaySearchResultsFlag = true;
            this.searchSerialized = this.form.serialize();
        }
        return null; 
    } 
    
    public PageReference skipToLocation(){ 
        String pageNumberParam = PageUtils.param('pageNumber');
        if(StringUtils.isNumeric(pageNumberParam)){
            this.paginator.skipToPage(Integer.valueOf(pageNumberParam));
        }
        return null; 
    } 
    
    public PageReference toggleFilter(){ 
        this.displayAdvancedSearchFlag = !this.displayAdvancedSearchFlag;
        return null; 
    } 
    
    public PageReference sortData(){ 
        
        Configuration.sortColumn = sortColumn;
        return search();
        //return null; 
    } 

    //==================================================
    // DERIVED PROPERTIES
    //==================================================
    public String googleMapsApiKey  { get{return config == null ? null : (StringUtils.isEmpty(Site.getName()) ? config.googleMapsApiKey : config.googleMapsApiKeyForSites);}}
    public String locationsJSON     { get{return SearchHitWrapper.toJSON(hits);} set;}
    public String searchSerialized  { get; private set;}
    public String paramString       { get; set; }
    
    //==================================================
    // HELPER METHODS
    //==================================================
    global void handlePageChange(List<Object> records){
        this.hits.clear();
        if(records != null && records.size() > 0){
            for(Object record : records){
                this.hits.add((SearchHitWrapper)record);
            }
        }
    }

    public List<SelectOption> getSortColumnList() {
        final List<SelectOption> returnValue = new List<SelectOption>();
        if( config != null 
            && config.searchScreenSortableFields != null 
            && config.searchScreenSortableFields.size() > 0){
            for(FieldConfiguration field : config.searchScreenSortableFields){
                if(field != null){
                    returnValue.add(new SelectOption(field.name,field.label));
                }
            }
        }
        return returnValue;
    }

    public List<String> getMessages(){
        List<String> msgList= new List<String>();
        for(ApexPages.Message msg:ApexPages.getMessages()){
            msgList.add(msg.getSummary());
        }
        return msgList;
    }
    
    private List<SearchHitWrapper> wrap(List<SearchHit> hits){
        final List<SearchHitWrapper> wrappedHits = new List<SearchHitWrapper>();
        if(hits != null && hits.size() > 0){
            final FieldIndex fieldIndex = new FieldIndex().indexType(
                new List<Schema.DescribeSObjectResult>{
                    Schema.sObjectType.Account,
                    Schema.sObjectType.Partner_Location__c
                }
            );
            for(SearchHit hit : hits){
                wrappedHits.add(new SearchHitWrapper(hit,this.config));
            }
        }
        return wrappedHits;
    }

    private static Set<Object> buildFieldsInResultListForQueryAsSet(Configuration config){
        final Set<Object> fields = new Set<Object>();
        if( config != null 
            && config.searchScreenFieldsInResultList != null 
            && config.searchScreenFieldsInResultList.size() > 0){
            for(FieldConfiguration fieldConfiguration : config.searchScreenFieldsInResultList){
                if(fieldConfiguration != null){
                    fields.add(fieldConfigurationToFieldName(fieldConfiguration));
                }
            }
        }
        return fields;
    }

    private static String fieldConfigurationToFieldName(FieldConfiguration fieldConfiguration){
        String returnValue = null;
        if(fieldConfiguration != null){
            returnValue = ('Account'.equalsIgnoreCase(fieldConfiguration.objectName) ? 'Account__r.' : '') 
                + fieldConfiguration.fieldName;
        }
        return returnValue;
    }
    
    
}