global class SearchField extends FormField {

    global String applyTo {get; private set;}
    
    global SearchField(FieldConfiguration configuration){
    	super(configuration);
    	this.applyTo = configuration.applyToFieldName;
    	if(StringUtils.isBlank(this.applyTo)){
            this.applyTo = this.localName;
    	}
    }

    global static List<SearchField> filterOutUnsupportedTypes(List<SearchField> listToFilter ){
    	final List<FormField> formFields = FormField.filterOutUnsupportedTypes(listToFilter);
    	final List<SearchField> returnValue = new List<SearchField>();
    	if(formFields != null && formFields.size() > 0){
    		for(FormField formField : formFields){
    			returnValue.add((SearchField)formField);
    		}
    	}
    	return returnValue;
    }

    global static List<SearchField> build(List<FieldConfiguration> fieldConfigurations){
        final List<SearchField> returnValue = new List<SearchField>();
        if(fieldConfigurations != null && fieldConfigurations.size() > 0){
            for(FieldConfiguration fieldConfiguration : fieldConfigurations){
                returnValue.add(new SearchField(fieldConfiguration));
            }
        }
        return SearchField.filterOutUnsupportedTypes(returnValue);
    }

}