public class DefectResponse{

        public String operation;    //POST
        public boolean successful;
        public String objectId; //https://rally1.rallydev.com/slm/webservice/v2.0/defect/43502284586
        public String uiId; //DE478
        public String uiUrl;  
        public String defectPriority;
        public String defectSeverity;  
        public String workspaceName; 
        public cls_errors[] errors;
        public cls_warnings[] warnings;
    
    class cls_errors {
        public String cause;    //RALLY CREATE ERROR
        public String detail;   //Could not convert: "Severity" must be a string : Conversion method name : com.f4tech.slm.convert.DefectConversion.getSeverityNamed : value to convert : Minor Problem : type to convert : class com.f4tech.slm.domain.Rating : valid set is : (Major Problem,Crash/Data Loss,,Cosmetic,small Problem)
    }
    class cls_warnings {
        public String cause;
        public String detail; 
    }
   }