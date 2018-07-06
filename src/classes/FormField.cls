global virtual class FormField {

    //==================================================
    // PROPERTIES
    //==================================================
    global String               objectName      {get; private set;}
    global String               label           {get; private set;}
    //ANSSA01 help text
    global String               inlineHelpText {get; private set;}
  
    global Integer              length          {get; private set;}
    global String               localName       {get; private set;}
    global String               name            {get; private set;}
    global List<SelectOption>   picklistValues  {get; private set;}
    global Schema.DisplayType   displayType     {get; private set;}
    global String               value           {get; set;}
    global List<String>         values          {get; set;}

    //==================================================
    // CONSTRUCTOR  
    //==================================================
    global FormField(FieldConfiguration configuration){
        this.objectName      = configuration.objectName;
        this.label           = configuration.label;
        this.length          = configuration.length;
        this.localName       = configuration.localName;
        this.name            = configuration.name;
        this.picklistValues  = configuration.picklistValues;
        this.displayType     = configuration.displayType;
        this.inlineHelpText  = configuration.inlineHelpText; //anssa01 help text
        this.value           = null;
        this.values          = new List<String>();
    }

    //==================================================
    // DERIVED PROPERTIES
    //==================================================
    global String fieldType {get{ 
        return StringUtils.remove('' + displayType,'Schema.DisplayType.');
    }}
    
    global Boolean blank {get{
        Boolean returnValue = true;
        if(isMultiselectPicklist){
            if(values != null && values.size() > 0){
                returnValue = false;
            }
        } else {
            returnValue = (typedValue == null);   
        } 
        return returnValue;
    }}

    global Boolean notBlank {get{ 
        return !blank; 
    }}
    
    global Boolean isPicklist {get{ 
        return Schema.Displaytype.PICKLIST == displayType; 
    }}

    global Boolean isMultiselectPicklist {get{ 
        return Schema.Displaytype.MULTIPICKLIST == displayType; 
    }}
    
    global void populate(String str){
        if(isMultiselectPicklist){
            values = StringUtils.isBlank(str) ? new List<String>() : StringUtils.split(str, ';');
        } else {
            value = str;
        }
    }
    
    global Object typedValue {get{
        Object returnValue = null;
        if(isMultiselectPicklist){
            returnValue = StringUtils.joinArray(values,';');
        } else if(StringUtils.isNotBlank(value)){
            if(Schema.DisplayType.BOOLEAN == displayType){
                returnValue = 'true'.equalsIgnoreCase(value);
            } else if(Schema.DisplayType.DOUBLE == displayType
                      || Schema.DisplayType.PERCENT == displayType
                      || Schema.DisplayType.CURRENCY == displayType){
                try{ returnValue = Double.valueOf(value); } catch(System.TypeException e){}
            } else if(Schema.DisplayType.INTEGER == displayType){
                try{ returnValue = Integer.valueOf(value); } catch(System.TypeException e){}
            } else { 
                returnValue = value;
            }
        }
        return returnValue;
    }}

    //==================================================
    // HELPER METHODS
    //==================================================
    global static Boolean isSupportedType(Schema.DisplayType displayType){
        return

            //SUPPORTED
            Schema.DisplayType.MULTIPICKLIST == displayType

            || Schema.DisplayType.BOOLEAN == displayType

            || Schema.DisplayType.DOUBLE == displayType
            || Schema.DisplayType.PERCENT == displayType
            || Schema.DisplayType.CURRENCY == displayType

            || Schema.DisplayType.INTEGER == displayType

            || Schema.DisplayType.PICKLIST == displayType
            || Schema.DisplayType.STRING == displayType
            || Schema.DisplayType.URL == displayType
            || Schema.DisplayType.EMAIL == displayType
            || Schema.DisplayType.PHONE == displayType
            || Schema.DisplayType.TEXTAREA == displayType
            ;

            //UNSUPPORTED
            //|| Schema.DisplayType.ANYTYPE == displayType
            //|| Schema.DisplayType.BASE64 == displayType
            //|| Schema.DisplayType.COMBOBOX == displayType
            //|| Schema.DisplayType.DATE == displayType
            //|| Schema.DisplayType.DATETIME  == displayType
            //|| Schema.DisplayType.ID == displayType
            //|| Schema.DisplayType.REFERENCE == displayType
    }

    global static List<FormField> filterOutUnsupportedTypes(List<FormField> listToFilter ){
        final List<FormField> returnValue = new List<FormField>();
        if(listToFilter != null && listToFilter.size() > 0){
            for(FormField field : listToFilter){
                if(isSupportedType(field.displayType)){
                    returnValue.add(field);
                }
            }
        }
        return returnValue;
    }    

    global static List<FormField> build(List<FieldConfiguration> fieldConfigurations){
        List<FormField> returnValue = new List<FormField>();
        if(fieldConfigurations != null && fieldConfigurations.size() > 0){
            for(FieldConfiguration fieldConfiguration : fieldConfigurations){
                returnValue.add(new FormField(fieldConfiguration));
            }
        }
        System.debug('### build before filter: ' + returnValue);
        returnValue = FormField.filterOutUnsupportedTypes(returnValue);
        System.debug('### build after filter: ' + returnValue);
        return returnValue;
    }

    global static Set<Object> fieldNames(List<FormField> fields){
        Set<Object> returnValue = new Set<Object>();
        if(fields != null && fields.size() > 0){
            for(FormField field : fields){
                returnValue.add(field.localName);
            }
        }
        return returnValue;
    }
    
    global static List<FormField> populateFields(List<FormField> fields, SObject sobj){
        if(fields != null && fields.size() > 0){
            for(FormField field : fields){
                field.populate(String.valueOf(sobj.get(field.name)));
            }
        }
        return fields;
    }
    
    global static List<FormField> populateSObject(SObject sobj, List<FormField> fields){
        System.debug('### sobj ' + sobj);
        System.debug('### fields ' + fields);
        if(sobj != null && fields != null && fields.size() > 0){
            for(FormField field : fields){
                if(field != null && field.typedValue != null){
                    sobj.put(field.name, field.typedValue);
                }
            }
        }
        System.debug('### sobj ' + sobj);
        return fields;
    }

}