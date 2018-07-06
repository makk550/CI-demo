public class SiteServiceOfferingsController {
    
    public List<SiteUtilServicesDataWrapper.Data> offeringDetailsWrapperList{get;set;}
    public SiteUtilServicesDataWrapper.Error OfferingErrorDetailsWrapper{get;set;}
    public SiteUtilServicesDataWrapper siteUtilDetailsWrapperRef {get;set;}
    public String responseFromService {get;set;}
    public String topsSiteID {get;set;}
    public Boolean isDetailsPresent{get;set;}
    public Boolean isRecordsPerPage {get;set;}
    public String  startRecNum {get;set;}
    public Boolean executeFlow=false;
    public String topsId {get;set;}
    public static boolean testFlagHandler=false;
    public static boolean testFlagWrapper=false;
    public static boolean testFlagService=false;
    public List<Non_Contract_Offering_Business_Rules__c> ncrlist {get;set;}
    public List<Contract_Support_Offerings__c> lighetningCCRlist {get;set;}
    public boolean isNCROfferingExists {get;set;}
    public boolean noOfferingsExists {get;set;}
    public Map<String,String> precedenceMap {get;set;}
    public List<Offering_Business_Rules__c> precendenceList {get;set;}
    
    public SiteServiceOfferingsController(){}
    
    public SiteServiceOfferingsController(ApexPages.StandardController controller){      
        this.topsId=ApexPages.currentPage().getParameters().get('id');   
        this.topsSiteID=[SELECT SC_TOPS_ID__c FROM Site_Association__c WHERE ID=:this.topsId].SC_TOPS_ID__c;    
        this.noOfferingsExists = false;
    }
    public PageReference executeDetails(){ 
        if(topsSiteID!=null && topsSiteID!=''){
            this.isRecordsPerPage =true;
            this.executeFlow=true;    
        }else{          
            this.isDetailsPresent=false;
            this.executeFlow=false; 
            this.noOfferingsExists = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please enter TOPS SITE ID');
            ApexPages.addMessage(myMsg);
        } 
        if(executeFlow){
            this.startRecNum='1';
            executePaginationFlow(this.topsSiteID,this.startRecNum);             
        }        
        return null;
    }
    
    
    public void executePaginationFlow(String topsSiteID,String startRecNum){  
        try{
            retrieveNonContractOfferings();
            if(!this.ncrlist.isEmpty()){
                this.isNCROfferingExists = true;
            }else{
                this.isNCROfferingExists = false;
            }
            
            retrieveContractOfferingsLightening();
            if(lighetningCCRlist.size() > 0){                   
                this.isDetailsPresent=true; 
            }else{
                this.isDetailsPresent=false;   
                if(isNCROfferingExists == false){
                    noOfferingsExists = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Neither Contracted nor Non-contract offerings are available for this site.');
                    ApexPages.addMessage(myMsg);                            
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Contracted Offerings are not available for this site');
                    ApexPages.addMessage(myMsg);                    
                }
            }
        }catch(System.Exception e){
            this.isDetailsPresent=false;  
            this.noOfferingsExists = true;
            ApexPages.Message myMsg=new ApexPages.Message(ApexPages.Severity.Fatal,e.getMessage());
            ApexPages.addMessage(myMsg);
        }     
        
        if(this.isNCROfferingExists == false && this.noOfferingsExists ==  false ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Non-Contract Offerings are not available for this site.');
            ApexPages.addMessage(myMsg);
        } 
        
        if(ApexPages.getMessages().size() > 1){
            this.noOfferingsExists = true;
        }
        
    }
    
    public void retrieveNonContractOfferings(){
        ncrlist = [select id,name,CA_Product_Controller__r.Name, Start_Date__c,End_Date__c,Offering_Business_Rules__r.Offering_Code__c,Offering_Business_Rules__r.Precedence__c from Non_Contract_Offering_Business_Rules__c where Site_Association__r.SC_TOPS_ID__c =: topsSiteID];
    }
    
    public void retrieveContractOfferingsLightening(){
        DateTime currentDateTime = system.now();
        this.topsSiteID='00000'+topsSiteID;
        lighetningCCRlist = [select ca_product_name__c,offering_cd__c,dse_pmf_key__c, dse_role__c,offering_start_dtm__c,offering_end_dtm__c,sap_contract_num__c,contract_line_num__c,clarity_key__c from Contract_Support_Offerings__c where tops_site_id__c =: topsSiteID 
                             and offering_start_dtm__c<=:currentDateTime AND offering_end_dtm__c>=:currentDateTime
                             and ((offering_cancel_dtm__c!=null and offering_cancel_dtm__c>=:currentDateTime) or (offering_cancel_dtm__c=null))];

        if(lighetningCCRlist<>null && lighetningCCRlist.size()>0){
            precendenceList();
        }
    }

    public void precendenceList(){
        precedenceMap=new Map<String,String>();
        precendenceList=[SELECT Offering_Code__c,Precedence__c from Offering_Business_Rules__c];       
        if(precendenceList<>null && precendenceList.size()>0){
            for(Offering_Business_Rules__c off:precendenceList){
                precedenceMap.put(off.Offering_Code__c,off.Precedence__c);
            }
        }
    }
    
}