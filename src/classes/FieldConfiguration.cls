global class FieldConfiguration {

    //==================================================
    // PROPERTIES
    //==================================================
    //source: configuration variables
    global String               objectName {get;private set;}
    global String               fieldName {get;private set;}
    global String               applyToFieldName {get;private set;}
    //Added DSTSA01 inline helpText
    global String               inlineHelpText           {get; private set;}
    //source: field describe
    global String               label           {get; private set;}
    global Integer              length          {get; private set;}
    global String               localName       {get; private set;}
    global String               name            {get; private set;}
    global List<SelectOption>   picklistValues  {get; private set;}
    global Schema.DisplayType   displayType     {get; private set;}
    
    //==================================================
    // CONSTRUCTOR  
    //==================================================
    global FieldConfiguration(){}

    global FieldConfiguration(String objectName, String fieldName, String applyToFieldName){
        this.objectName = objectName;
        this.fieldName = fieldName;
        this.applyToFieldName = applyToFieldName;
    }

    //==================================================
    // HELPER METHODS
    //==================================================
    
    /**
     * Takes string like following:
     *
     * Account.Partner_Type_METADATA__c=>Partner_Type__c|Partner_Location__c.Is_Primary__c
     * 
     * parses it and returns a list of field configurations.  In case of above, two FieldConfiguration
     * record would be returned per following:
     * 
     * FieldConfiguration[objectName=Account,fieldName=Partner_Type_METADATA__c,applyToFieldName=Partner_Type__c]
     * FieldConfiguration[objectName=Partner_Location__c,fieldName=Is_Primary__c,applyToFieldName=Is_Primary__c]
     * 
     * @param configurationVariableValue raw configuration variable
     * @return a list of field configurations
     */
    global static List<FieldConfiguration> parse(final String configurationVariableValue){
        final List<FieldConfiguration> fieldList = new List<FieldConfiguration>();
        if(StringUtils.isBlank(configurationVariableValue)){
            return fieldList;
        }
        List<String> unParsedFields = StringUtils.split(configurationVariableValue,'|');
        FieldConfiguration current = null;
        String objectNameApplyTo = null;
        for(String unParsedField : unParsedFields){
            current = new FieldConfiguration();
            current.objectName = StringUtils.trim(StringUtils.substringBefore(StringUtils.substringBefore(unParsedField,'=>'),'.'));
            current.fieldName = StringUtils.trim(StringUtils.substringAfter(StringUtils.substringBefore(unParsedField,'=>'),'.'));
            objectNameApplyTo = null;
            current.applyToFieldName = StringUtils.trim(StringUtils.substringAfter(unParsedField,'=>'));
            if(StringUtils.contains(current.applyToFieldName, '.')){
                objectNameApplyTo = StringUtils.trim(StringUtils.substringBefore(current.applyToFieldName,'.'));
                current.applyToFieldName = StringUtils.trim(StringUtils.substringAfter(current.applyToFieldName,'.'));
            }
            if( StringUtils.isNotBlank(current.objectName) 
                && StringUtils.isNotBlank(current.fieldName)
                && 
                (   StringUtils.isBlank(objectNameApplyTo)
                    || StringUtils.equalsIgnoreCase(current.objectName,objectNameApplyTo)
                )
            ){
                fieldList.add(current);
            }
        }
        return fieldList;
    }

    global FieldConfiguration populateFieldsFromDescribe(Schema.DescribeFieldResult describe){
        this.label           = describe.getLabel();
        this.length          = describe.getLength();
        this.localName       = describe.getLocalName();
        this.name            = describe.getName();
        this.picklistValues  = getSelectOptions(describe);
        this.displayType     = describe.getType();
        this.inlineHelpText  = describe.getInlineHelpText();
        return this;
    }    
    
    private List<SelectOption> getSelectOptions(Schema.DescribeFieldResult describe){
        final List<SelectOption> options = new List<SelectOption>();
        if(describe != null && Limits.getPicklistDescribes() < Limits.getLimitPicklistDescribes()){
            for(Schema.PicklistEntry entry : describe.getPicklistValues()){
              //PRM5.5 - Eliminate WW values from Geo and Country Picklist fields.
              if(((entry.getValue() != 'WW' && describe.getName() == 'Geo__c') || describe.getName() != 'Geo__c')

                    &&
                ((entry.getValue() != 'WW - WORLDWIDE' && describe.getName() == 'Country_Picklist__c') || describe.getName() != 'Country_Picklist__c')
        )
                options.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
        }
        return options;
    }

    
}