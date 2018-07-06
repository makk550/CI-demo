public class TestListViewController {

    //public Set<String> updatableFields = new Set<String>();
    public static Map<String,String> fieldIdNameMap {get;set;} //= new Map<String,String>();
    public String jsonFieldIdNameMap {get;set;}
    
    public static Set<String> updatableFields { get; 
                                        set{
                                            updatableFields = new Set<String>();
                                        }        
    }
    
    public static List<String> fieldsAvailableonPageLayouts = new List<String>();    
    public static Set<String> controllingPickListFieldSet = new Set<String>();
    public static Set<String> fieldsOnLookUpFilters = new Set<String>();    
    
    public TestListViewController(ApexPages.StandardSetController controller){
        
        if(updatableFields == null){
            System.debug('updatableFields:'+updatableFields);
            updatableFields = new Set<String>();
        }
        
        Map<String, Schema.SObjectField> caseFieldsMap = Schema.SObjectType.Case.fields.getMap();
        for(String fieldName : caseFieldsMap.keySet()) {
            //OOB Not allowed : In-Line Editing of Dependent Picklists in List Views
            if( caseFieldsMap.get(fieldName).getDescribe().getController() == null &&  caseFieldsMap.get(fieldName).getDescribe().isUpdateable()) {
                if(fieldName.toLowerCase() != 'status' ){
                    updatableFields.add(fieldName.toLowerCase().trim());
                    System.debug('updatableFields:'+updatableFields);
                }
            }
            if( caseFieldsMap.get(fieldName).getDescribe().getController() != null){
                System.debug('controllingPickListFieldSet -->fieldName:'+ caseFieldsMap.get(fieldName).getDescribe().getController().getDescribe().getName().toLowerCase().trim());
                //caseFieldsMap.get(fieldName).getDescribe().getController() -- returns  SObjectField
                controllingPickListFieldSet.add(caseFieldsMap.get(fieldName).getDescribe().getController().getDescribe().getName().toLowerCase().trim());
            }
        }
        
        System.debuG('controllingPickListFieldSet:'+controllingPickListFieldSet);
        
        if( controllingPickListFieldSet != null && controllingPickListFieldSet.size() >0 )
            updatableFields.removeAll(controllingPickListFieldSet); 
        
        System.debug('updatableFields.contains(status):'+updatableFields.contains('status'));
        
        if(fieldIdNameMap == null){
            fieldIdNameMap = new Map<String,String>();
        }
        /*
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint( URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/query/?q=Select+id,DeveloperName+from+CustomField+where+TableEnumOrId=\'Case\'');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);    
        req.setMethod('POST');
        string a = res.getBody(); 
        Matcher m = Pattern.compile('"Id":"(\\w+)","DeveloperName":"(\\w+)"').matcher(a);
        while(m.find()) {
            if(m.group(2).containsIgnoreCase('seve') ){
                System.debug('Id:'+ m.group(1).substring(0,15) + ';Name:' + m.group(2));
            }
            if(m.group(2).containsIgnoreCase('Priority') ){
                System.debug('Id:'+ m.group(1) + ';Name:' + m.group(2)+'__c');
            }
            fieldIdNameMap.put(m.group(1).substring(0,15),m.group(2).toLowerCase()+'__c');
        }
        
        //For StandardFields
        List<FieldDefinition> fieldDefs = [select QualifiedApiName,DeveloperName,PublisherId from FieldDefinition 
                                           where EntityDefinition.QualifiedApiName = 'Case' and PublisherId = 'System'];
        
        if( fieldDefs!= null && fieldDefs.size()>0){
            for(FieldDefinition fieldDef: fieldDefs ){
                fieldIdNameMap.put(fieldDef.DeveloperName, fieldDef.DeveloperName.toLowerCase());
            }            
        }
        */
        
        fieldIdNameMap = fetchFieldIdNameMap();   
        System.debug('***fieldIdNameMap.values().size():'+ fieldIdNameMap.values().size());
        System.debug('***updatableFields.size():'+ updatableFields.size());
        if(fieldsAvailableonPageLayouts!= null && fieldsAvailableonPageLayouts.size()>0){
            updatableFields.retainAll(fieldsAvailableonPageLayouts);
            System.debug('***After checking on pageLayout avaialabilityFlag, updatableFields.size():'+ updatableFields.size());     
        }
        
        
        if( fieldsOnLookUpFilters != null && fieldsOnLookUpFilters.size() >0 ){
            updatableFields.removeAll(fieldsOnLookUpFilters); 
            System.debug('***After checking fieldsOnLookUpFilters, updatableFields.size():'+ updatableFields.size());   
        }

        jsonFieldIdNameMap = JSON.serialize(fieldIdNameMap);        
        System.debug('fieldIdNameMap:'+fieldIdNameMap);
    }
    
    
    public static Map<String,String> fetchFieldIdNameMap(){
        /*
        Map<String,String> fieldIdNameMap = new  Map<String,String>();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint( URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/query/?q=Select+id,DeveloperName+from+CustomField+where+TableEnumOrId=\'Case\'');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);    
        req.setMethod('POST');
        string a = res.getBody(); 
        Matcher m = Pattern.compile('"Id":"(\\w+)","DeveloperName":"(\\w+)"').matcher(a);
        while(m.find()) {           
            fieldIdNameMap.put(m.group(1).substring(0,15),m.group(2).toLowerCase()+'__c');
        } */
        
        Map<String,String> fieldIdNameMap = new  Map<String,String>();
        List<Case_Fields_Mapping__mdt> caseFieldMappings = [select FieldID__c,Field_API_Name__c,Available_on_PageLayout__c,In_Lookup_Filter__c  from Case_Fields_Mapping__mdt];      
        if(caseFieldMappings != null && caseFieldMappings.size()>0) {
            for(Case_Fields_Mapping__mdt caseFieldMapping : caseFieldMappings ){
                 fieldIdNameMap.put(caseFieldMapping.FieldID__c.trim() , caseFieldMapping.Field_API_Name__c.toLowerCase().trim());
                if(caseFieldMapping.Available_on_PageLayout__c){
                    fieldsAvailableonPageLayouts.add(caseFieldMapping.Field_API_Name__c.toLowerCase().trim());
                }
                if(caseFieldMapping.In_Lookup_Filter__c){
                    fieldsOnLookUpFilters.add(caseFieldMapping.Field_API_Name__c.toLowerCase().trim());
                }
            }
        } 
        
        //For StandardFields
       /* List<FieldDefinition> fieldDefs = [select QualifiedApiName,DeveloperName,PublisherId from FieldDefinition 
                                           where EntityDefinition.QualifiedApiName = 'Case' and PublisherId = 'System'];
        
        if( fieldDefs!= null && fieldDefs.size()>0){
            for(FieldDefinition fieldDef: fieldDefs ){
                fieldIdNameMap.put(fieldDef.DeveloperName, fieldDef.DeveloperName.toLowerCase());
            }            
        } */
             
        System.debug('fieldIdNameMap:'+fieldIdNameMap);
        return fieldIdNameMap;
    }  
  
}