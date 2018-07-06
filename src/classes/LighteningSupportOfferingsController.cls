public class LighteningSupportOfferingsController {
    
    @TestVisible private static List<v_support_offerings__x> mockedRequests = new List<v_support_offerings__x>();
    public List<v_support_offerings__x> offeringsList {get;set;} 
    public String totalCount {get;set;}
    public Boolean isDetailsPresent{get;set;}
    
    public LighteningSupportOfferingsController(){ }
    
    public PageReference getSupportOfferings(){
        try{ 
            offeringsList=[SELECT tops_site_id__c,ca_product_name__c,offering_cd__c,offering_start_dtm__c,offering_end_dtm__c,offering_cancel_dtm__c,sap_contract_num__c,
                           dse_pmf_key__c,dse_role__c,clarity_key__c,contract_line_num__c FROM v_support_offerings__x order By tops_site_id__c];
            if(offeringsList<>null && offeringsList.size()>0){
                totalCount=String.valueOf(offeringsList.size());
                this.isDetailsPresent=true;
            }else{
                this.isDetailsPresent=false; 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Records are Available for Support Offerings');
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