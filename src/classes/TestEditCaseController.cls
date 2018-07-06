public class TestEditCaseController {   
    public Case CurrentCase {
        get;
        set;
    }
    
    public String fieldName {
        get;
        set;
    }
    
    public Boolean hasError {
        get {
            return ApexPages.hasMessages();
        }
    }
    
    
   //Set<String> updatableFields = new Set<String>();
    
    public TestEditCaseController() {
        String id = apexPages.currentPage().getParameters().get('rid'); 
		String fid= apexPages.currentPage().getParameters().get('fid'); 
		System.debug('rid:'+id+';fid:'+fid);
        
        fieldName = fid;
        
        
       Map<String,String> fieldIdNameMap = TestListViewController.fetchFieldIdNameMap();
       fieldName = fieldIdNameMap.get(fid);
       
        List<String> standardLookUpFields = new List<String>();
        standardLookUpFields.add('account');
        standardLookUpFields.add('contact');
        standardLookUpFields.add('businesshours');
        standardLookUpFields.add('user');
        standardLookUpFields.add('queue');
        standardLookUpFields.add('owner');
        
        if(standardLookUpFields.contains(fieldName)){
            fieldName = fieldName+'Id';
        }
        
       String soql = 'Select id, ' + fieldName + ' From Case where id = :id'; 
       CurrentCase = (Case)Database.Query(soql);  
       
       /* 
       List<Case_Fields_Mapping__mdt> caseFieldMappings = [select FieldID__c,Field_API_Name__c from Case_Fields_Mapping__mdt where FieldID__c = :fid];
		
        if(caseFieldMappings != null && caseFieldMappings.size()>0) {
            FieldName = caseFieldMappings[0].Field_API_Name__c ;
            
            String soql = 'Select id, ' + caseFieldMappings[0].Field_API_Name__c + ' From Case where id = :id'; 
            CurrentCase = (Case)Database.Query(soql); 
        } else {
           //TODO: ADD Error messages            
        } */
      

    }
    
    public PageReference  SaveCaseField() {
        try{
            update CurrentCase;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getdmlMessage(0).unescapeHtml4()));
        }
        return null;
    }
    
    public PageReference  Cancel() {
        return null;
    }
    
}