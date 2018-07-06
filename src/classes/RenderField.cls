public class RenderField {
	public String fieldType{get; set;}
	public String fieldName{get; set;}
	public String fieldLabel{get; set;}
	public String objectName{get; set;}
    public List<SelectOption> pickListValues{get; set;}
    public String fieldValue{get; set{
        fieldValue = isPicklist ? translatePicklistValue(value,pickListValuesValueToLabelMap,isMultiPicklist) : value;
    }}
    public Boolean isPicklist{get{return 'Picklist'.equalsIgnoreCase(fieldType) || isMultiPicklist;}}
    public Boolean isMultiPicklist{get{return 'MultiPicklist'.equalsIgnoreCase(fieldType);}}
	
	 
	public List<String> multiPickValues{get; set;}
	public Boolean fieldBooleanValue{get; set;} 
	
	public RenderField(){}
	
    public RenderField(String objectName,Schema.DescribeFieldResult descrb){
        this.fieldType = descrb.getType().name();
		this.fieldName = descrb.getLocalName();
		this.fieldLabel = descrb.getLabel();
		this.objectName = objectName;
		this.pickListValues = new List<SelectOption>();
		this.multiPickValues=new List<String>();
		if(isPicklist && Limits.getPicklistDescribes() < Limits.getLimitPicklistDescribes()){
            this.pickListValues = getSelectOptions(descrb); 
        }
	}
	
	public RenderField(String objectName, 
					   Schema.DescribeFieldResult describeField,
					   Schema.DescribeFieldResult searchField){
		this.fieldType = describeField.getType().name();
		this.fieldName = searchField.getLocalName();
		this.fieldLabel = describeField.getLabel();
		this.objectName = objectName;	   	
		this.pickListValues = new List<SelectOption>();
		this.multiPickValues=new List<String>();
        if(('Picklist'.equalsIgnoreCase(fieldType) || 'MultiPicklist'.equalsIgnoreCase(fieldType)) 
              && Limits.getPicklistDescribes() < Limits.getLimitPicklistDescribes()){
            this.pickListValues = getSelectOptions(describeField); 
        }
	}
	
    private List<SelectOption> getSelectOptions(Schema.DescribeFieldResult field){
        final List<SelectOption> options = new List<SelectOption>();
        if(field != null){
            for(Schema.PicklistEntry entry : field.getPicklistValues()){
                options.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
        }
        return options;
    }
    
    
    public Map<String,String> pickListValuesValueToLabelMap{get{
        final Map<String,String> theMap = new Map<String,String>();
        if(pickListValues != null && pickListValues.size() > 0){
            for(SelectOption option : pickListValues){
                theMap.put(option.getValue(),option.getLabel());
            }
        }
        return theMap;
    }}
    
    public static String translatePicklistValue(    String untranslatedPicklistValueString, 
                                                    Map<String,String> pickListValuesValueToLabelMap, 
                                                    Boolean isMultiSelect){
        final List<String> untranslatedValues = 
           (isMultiSelect != null && isMultiSelect) ? 
               StringUtils.split(untranslatedPicklistValueString,';') : 
               new List<String>{untranslatedPicklistValueString};
        
        final List<String> translatedValues = new List<String>();
        if(untranslatedValues != null && untranslatedValues.size() > 0){
            for(String untranslatedValue : untranslatedValues){
                if(pickListValuesValueToLabelMap != null && pickListValuesValueToLabelMap.containsKey(untranslatedValue)){
                    translatedValues.add(pickListValuesValueToLabelMap.get(untranslatedValue));
                } else {
                    translatedValues.add(untranslatedValue);
                }
            }
        }
        return StringUtils.joinArray(translatedValues,';');
    }
    
    
}