public class JunEditCaseController {   
    public Case CurrentCase {
        get;
        set;
    }
    
    public String FieldName {
        get;
        set;
    }
    
    public JunEditCaseController() {
        String id = apexPages.currentPage().getParameters().get('rid'); 
		String fid= apexPages.currentPage().getParameters().get('fid'); 

        FieldName = fid;

       String soql = 'Select id, ' + FieldName + ' From Case where id = :id'; 
       CurrentCase = (Case)Database.Query(soql); 

    }
    
    public PageReference  SaveCaseField() {
        Update CurrentCase;
        return null;
    }
    
}