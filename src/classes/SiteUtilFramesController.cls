public class SiteUtilFramesController {
    
    public List<SiteUtilServicesDataWrapper.Data> entitlementDetailsWrapperList{get;set;}
    public SiteUtilServicesDataWrapper.Error entitlementErrorDetailsWrapper{get;set;}
    public SiteUtilServicesDataWrapper siteUtilDetailsWrapperRef {get;set;}
    public SiteUtilServicesDataWrapper siteUtilDetailsWrapperSupportOfferingRef {get;set;}
    public List<SiteUtilServicesDataWrapper.Data> offeringDetailsWrapperList{get;set;}
    public String responseFromService {get;set;}
    public String topsSiteID {get;set;}
    public Boolean isDetailsPresent{get;set;}
    public Boolean isRecordsPerPage {get;set;}
    public String  startRecNum {get;set;}
    public Boolean executeFlow=false;
    public Integer getMoreStartRecNum {get;set;}
    public Boolean isGetMoreLinkEnable {get;set;}
    public Boolean isGetPreviousLinkEnable {get;set;}
    public String entitlementProductCodeSelected {get;set;}
    public String entitlementTopsProductCodeSelected {get;set;}
    public String siteName {get;set;}     
    public String responseFromSupportOffering {get;set;}    
    public Boolean executeCreateCaseFlow=false;
    public String entitlementOfferingCodeSelected {get;set;} 
    public String designatedSupportEngineerPMFkey {get;set;}
    public String searchTerm {get; set;}
    public String selectedSiteId {get; set;}    
    public String getSiteAssociationIdfromUrlField;
    public String getSiteAssociationNamefromUrlField;
    public String getContactIdfromUrlField;
    public String contactName;
    public String rangeValueforRecords {get;set;}
    public Boolean israngeValueofRecordsPresent {get;set;}
    public static boolean testFlagHandler=false;
    public static boolean testFlagWrapper=false;
    public static boolean testFlagService=false;
    public String sapContractNum {get;set;}
    
    public SiteUtilFramesController(){}
    
    public SiteUtilFramesController(ApexPages.StandardController controller){       
        this.searchTerm=searchTerm;        
        getSiteAssociationNamefromUrlField=ApexPages.currentPage().getParameters().get(System.Label.OfferingCaseFieldIdSitePage);
        
        getSiteAssociationIdfromUrlField=ApexPages.currentPage().getParameters().get(System.Label.OfferingCaseFieldIdSitePageLkid);
         System.Debug('getSiteAssociationIdfromUrlField is : ' + getSiteAssociationIdfromUrlField);
        if(getSiteAssociationIdfromUrlField<>null){
            topsSiteID=[SELECT SC_TOPS_ID__c FROM Site_Association__c WHERE ID=:getSiteAssociationIdfromUrlField].SC_TOPS_ID__c;  
             System.Debug('topsSiteID is IAS: ' + topsSiteID);   
        }      
        if(getSiteAssociationNamefromUrlField<>null){
            this.searchTerm       =getSiteAssociationNamefromUrlField;  
            this.selectedSiteId   =getSiteAssociationIdfromUrlField;
            this.siteName         =getSiteAssociationNamefromUrlField;
        }       
        getContactIdfromUrlField=ApexPages.currentPage().getParameters().get('def_contact_id');
        if(getContactIdfromUrlField<>null){
            contactName=[SELECT NAME FROM CONTACT WHERE ID=:getContactIdfromUrlField].NAME;  
        }
    }
    
    @RemoteAction
    public static List<Site_Association__c> searchSiteList(String searchTerm) {
        String query=null;
        List<Site_Association__c> siteList = null;       
        try{
            searchTerm=String.escapeSingleQuotes(searchTerm);                  
            query='Select ID,SC_TOPS_ID__c,Name,City__c,Country_Picklist__c from Site_Association__c';
            if(searchTerm.isNumeric()){
                query=query+' WHERE SC_TOPS_ID__c=:searchTerm ORDER BY SC_TOPS_ID__c';  
            }else{
                query=query+'  WHERE SC_TOPS_ID__c<>NULL AND NAME LIKE \'%' + searchTerm + '%\' ORDER BY SC_TOPS_ID__c';   
            }
            siteList=Database.query(query);
        }finally{
            if(query!=null){
                query=null;
            }            
        }        
        return siteList;
    } 
    
    public PageReference resetValues(){
        this.entitlementDetailsWrapperList=null;
        this.isRecordsPerPage =false;
        this.isDetailsPresent=false;
        this.topsSiteID=null;
        this.startRecNum=null;
        this.executeFlow=false;
        this.isGetMoreLinkEnable=false;
        this.getMoreStartRecNum=null; 
        this.siteName=null;
        this.searchTerm=null;
        this.rangeValueforRecords=null;
        this.isGetPreviousLinkEnable=false;
        this.israngeValueofRecordsPresent=false;
        this.sapContractNum=null;
        return null;
    }
    
    public PageReference gottodirectCasePage(){
        PageReference pageref=null;
      //  String[] fieldIDValues=new String[3];
      String[] fieldIDValues=new String[4];
        String fieldUrl=null;
        String url=null;
        try{
            fieldIDValues[0]=System.Label.OfferingCaseFieldIdSite;
            fieldIDValues[1]=System.Label.OfferingCaseFieldIdSiteLkid;
            fieldIDValues[2]=System.Label.OfferingCaseFieldIdCasewithoutEntitlement;
            fieldIDValues[3]=System.Label.TSStage;
            if(siteName<>null && siteName!='' && selectedSiteId<>null && selectedSiteId!=''){             
                siteName=EncodingUtil.urlEncode(siteName,'UTF-8');               
                
                //fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId;
               // fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification';
               fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification';


            }else{
               // fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1';
               fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[3]+'=1. Problem Identification';
            }           
            url=System.URL.getSalesforceBaseUrl().toExternalForm()+fieldUrl;               
            if(!(url.length()>=2000)){
                pageref=new PageReference(url);
                pageref.setRedirect(true); 
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please contact System Administrator,URL Length reached Limitation');
                ApexPages.addMessage(myMsg);
            } 
            
        }catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,e.getMessage());
            ApexPages.addMessage(myMsg);
        }finally{
            if(fieldIDValues<>null){
                fieldIDValues=null;  
            }
            if(fieldUrl<>null){
                fieldUrl=null;  
            }
            if(url<>null){
                url=null; 
            }
        }         
        return pageref;
    }
    
    public PageReference executeDetails(){        
        if(topsSiteID!=null && topsSiteID!=''){        
            this.isRecordsPerPage =true;
            this.executeFlow=true;             
        }else{            
            this.isDetailsPresent=false;
            this.executeFlow=false; 
            this.isGetMoreLinkEnable=false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please Select TOPS SITE ID');
            ApexPages.addMessage(myMsg);
        }          
        if(executeFlow){
            this.startRecNum='1';
            executePaginationFlow(this.topsSiteID,this.startRecNum); 
        } 
        //return Page.SiteUtilSupportServicesDetails; 
        return null;       
    }
    
    public void executePaginationFlow(String topsSiteID,String startRecNum){
        try {
            this.searchTerm=searchTerm;
            this.isGetMoreLinkEnable=false;
            this.isGetPreviousLinkEnable=false;
            responseFromService=SiteUtilServicesHandler.getServiceDetails(topsSiteID,null,startRecNum,'EntitlementService'); 
            if(responseFromService<>null && responseFromService!=''){                   
                siteUtilDetailsWrapperRef=SiteUtilServicesHandler.getServiceResponseList(responseFromService);              
                if(siteUtilDetailsWrapperRef<> null  && siteUtilDetailsWrapperRef.status=='success'){                   
                    entitlementDetailsWrapperList=SiteUtilServicesHandler.getDataWrapperList(responseFromService);
                    if(entitlementDetailsWrapperList.size()>0){
                        this.isDetailsPresent=true;
                        System.Debug('Entitlements Wrapper values ias : ' + entitlementDetailsWrapperList);
                        //System.Debug('Entitlements Wrapper product values ias : ' + entitlementDetailsWrapperList.cAProductName);
                        List<string> lstProdNames = new List<String>();
                        for(SiteUtilServicesDataWrapper.Data prodDetails : entitlementDetailsWrapperList){                        
                        lstProdNames.add(prodDetails.cAProductName);

                        }
                        System.Debug('Prod Size is IAS: '+lstProdNames.Size());
                        System.Debug('Prod Names: '+lstProdNames);
                        
                        String tempCounter='';
                        if(Integer.valueOf(startRecNum)>Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit)){
                            tempCounter=(Integer.valueOf(startRecNum)+Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit)-1)+'';
                        }else{
                            tempCounter=System.Label.SiteServicesCalloutRecordsLimit;
                        }
                        this.rangeValueforRecords=startRecNum+'-'+tempCounter;
                        if(this.rangeValueforRecords<>null && this.rangeValueforRecords.contains('-')){
                            israngeValueofRecordsPresent=true;
                        }                       
                        if(Integer.valueOf(entitlementDetailsWrapperList.size())>Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit)){
                            isGetMoreLinkEnable=true;
                        } 
                        if(Integer.valueOf(startRecNum)>1){
                            isGetPreviousLinkEnable=true;
                        }
                    } 
                    else{
                        this.isDetailsPresent=false;                        
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Active Entitlements for Site :'+topsSiteID);
                        ApexPages.addMessage(myMsg);
                    }  
                }else if(siteUtilDetailsWrapperRef<> null  && siteUtilDetailsWrapperRef.status=='failure'){
                    this.isDetailsPresent=false;                  
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,siteUtilDetailsWrapperRef.Error.description);
                    ApexPages.addMessage(myMsg);
                }
            }else{
                this.isDetailsPresent=false;          
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Unable to Connect Entitlement Service');
                ApexPages.addMessage(myMsg);
            }         
        }catch(System.Exception e){
            this.isDetailsPresent=false;  
            ApexPages.Message myMsg=null;
            if(e.getMessage().contains('Read timed out')){
                myMsg= new ApexPages.Message(ApexPages.Severity.Fatal,'Unable to process Data from EAI/DB');   
            }else{
                myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,e.getMessage());
            }
            ApexPages.addMessage(myMsg);
        }        
    }
    
    public PageReference getMore(){
        if(getMoreStartRecNum==null){
            getMoreStartRecNum=Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit)+1;
        }
        else{
            getMoreStartRecNum=getMoreStartRecNum+Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit);
        }        
        startRecNum=getMoreStartRecNum+'';
        executePaginationFlow(this.topsSiteID,this.startRecNum);
        return null;
    }
    
    public PageReference getPrevious(){
        if(Integer.valueOf(startRecNum)>Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit)){
            startRecNum=(Integer.valueOf(startRecNum)-Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit))+'';
            getMoreStartRecNum=getMoreStartRecNum-Integer.valueOf(System.Label.SiteServicesCalloutRecordsLimit);
            executePaginationFlow(this.topsSiteID,this.startRecNum);
        }       
        return null;
    }
    
    public PageReference executeOfferingServiceDetails(){
        PageReference pageref=null;
        String url=null;
        String fieldUrl=null;
        String[] fieldIDValues=new String[12];
        CA_Product_Component__c[] caProductComponent=null;
        String caProductComponentName='';
        String caProductComponentID='';
        try{  
                      
            caProductComponent=[SELECT Id,Name FROM CA_Product_Component__c where CA_Product_Controller__r.Name =:entitlementProductCodeSelected and Default_Component_for_this_CA_Product__c = True LIMIT 1]; 
            if(caProductComponent<>null && caProductComponent.size()>0){
                caProductComponentName=caProductComponent[0].Name;
                caProductComponentID=caProductComponent[0].ID;                    
            }
            
            if(contactName==null){
                contactName='';
            }
            
            fieldIDValues[0]=System.Label.OfferingCaseFieldIdSite;
            fieldIDValues[1]=System.Label.OfferingCaseFieldIdSiteLkid;
            fieldIDValues[2]=System.Label.OfferingCaseFieldIdCAProduct;
            fieldIDValues[3]=System.Label.OfferingCaseFieldCAProdComponent;
            fieldIDValues[4]=System.Label.OfferingCaseFieldCAProdComponentLKID;
            fieldIDValues[5]=System.Label.OfferingCaseFieldIdContact;
            fieldIDValues[10]=System.Label.OfferingCaseFieldIdTopsProductCodeSelected;
            fieldIDValues[6]=System.Label.TSStage;

            
            if(siteName<>null){
                siteName=EncodingUtil.urlEncode(siteName,'UTF-8');                  
            }               
            //fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[10]+'='+entitlementTopsProductCodeSelected;
             fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[10]+'='+entitlementTopsProductCodeSelected+'&'+fieldIDValues[6]+'=1. Problem Identification';
            
            if(siteName<>null && siteName!=''){
                fieldUrl=fieldUrl+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId;
            }                
            if(entitlementProductCodeSelected<>null && entitlementProductCodeSelected!=''){
                fieldUrl=fieldUrl+'&'+fieldIDValues[2]+'='+entitlementProductCodeSelected+'&'+fieldIDValues[3]+'='+caProductComponentName;
            }
            if(caProductComponentID<>null && caProductComponentID!=''){
                fieldUrl=fieldUrl+'&'+fieldIDValues[4]+'='+caProductComponentID;
            }
            if(contactName<>null && contactName!=''){
                fieldUrl=fieldUrl+'&'+fieldIDValues[5]+'='+contactName;
            }
            
            url=System.URL.getSalesforceBaseUrl().toExternalForm()+fieldUrl;                
            if(!(url.length()>=2000)){                 
                pageref=new PageReference(url);
                pageref.setRedirect(false); 
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please contact System Administrator,URL Length reached Limitation');
                ApexPages.addMessage(myMsg);
            }                               
        }        
        catch(System.Exception e){          
        }
        finally{
            if(url<>null){
                url=null;
            }
            if(fieldUrl<>null){
                fieldUrl=null;
            }
            if(fieldIDValues<>null){
                fieldIDValues=null;
            }
            if(caProductComponent<>null){
                caProductComponent=null;
            }
            if(caProductComponentName<>null){
                caProductComponentName=null;
            }
            if(caProductComponentID<>null){
                caProductComponentID=null;
            }
        }       
        return pageref;
    } 
public PageReference redirectBasedOnLayout(){
        String recType = String.isNotBlank(ApexPages.currentPage().getParameters().get('RecordType'))?ApexPages.currentPage().getParameters().get('RecordType'):'';
        System.debug('recType: '+recType); 
        if(String.isNotBlank(recType) && recType.equalsIgnoreCase('0121h0000008YfOAAU')){
            String withoutEntitlement = System.Label.OfferingCaseFieldIdCasewithoutEntitlement;
            String redirectURL = 'https://ca--fsb1.cs79.my.salesforce.com/500/e?nooverride=1&'+withoutEntitlement+'=1&RecordType='+recType;
            system.debug('redirectURL: '+redirectURL);
            PageReference pageref = new PageReference(redirectURL);
            pageref.setRedirect(false); 
            return pageref;
        }
        return null;    
    }
    
}