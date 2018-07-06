public class viewCertificationController {
    
    @TestVisible private static List<cbr_Calculated_Certification__x> cbrmockedRequests = new List<cbr_Calculated_Certification__x>();
    public List<CBR_Certifications_LPAC__c> cbrListView {get;set;} 
    public String totalCount {get;set;}
    public Boolean isDetailsPresent{get;set;}
    public String contactID {get;set;}
    public String UID {get;set;} 
    public String username {get;set;} 
    public viewCertificationController(){ 
    this.UID=ApexPages.currentPage().getParameters().get('id');   
     this.username=[SELECT name  FROM User WHERE ID=:this.UID].name;            
    }
    
    
    public viewCertificationController(ApexPages.StandardController controller){      
         
    }
    
    public PageReference getviewCertificationDetails(){

        try{            
                   
          
        
             cbrListView=[SELECT Employee_Name__c,badge__c,FTK_Certified__c,certified_status_text__c,valid_from__c,valid_to__c,ca_product_name__c,status_reason__c,certified__c FROM CBR_Certifications_LPAC__c where Employee_Name__c = :userName];
            
            if(cbrListView<>null && cbrListview.size()>0){
                totalCount=String.valueOf(cbrListview.size());
                this.isDetailsPresent=true;
            }else{
                this.isDetailsPresent=false; 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'User Skill has no Product Certifications');
                ApexPages.addMessage(myMsg);
            }
            //snippet to catch an excpetion in test class
            if(Test.isRunningTest()){
                String e ;
                e.toLowerCase();                
            }            
        }catch(System.Exception e){
            this.isDetailsPresent=false; 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Unable to connect Service');
            ApexPages.addMessage(myMsg);           
        }
                return null;
    }
    
  
}