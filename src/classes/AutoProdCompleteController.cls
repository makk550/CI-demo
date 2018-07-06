public class AutoProdCompleteController 
{

     
   
    public String searchTerm {get; set;}
    public String selectedProd {get; set;}
    
    public String productReleaseValue{get;set;}
    public Map<Id,String> mapOfRelease{get;set;} 
    public String productName{get;set;}
    
    //public Boolean showComp{get;set;}
    public String productComponentValue{get;set;}
    public Map<Id,String> mapOfComp{get;set;}
    
    public Boolean showComp{get;set;}
    public Boolean showTable{get;set;}
    
    public String siteName {get;set;} 
    public String selectedSiteId {get; set;}  
    
     public AutoProdCompleteController () 
    {
    }
    
    public AutoProdCompleteController(ApexPages.StandardController controller) 
    {
    
        mapOfRelease = new Map<Id,String>();
        showTable = false;
        showComp = false;
       
       
     mapOfRelease = new Map<Id,String>();
     productName = 'CLARITY ON DEMAND';//selectedProd;     
         if(String.isNotBlank(productName))
         {
                List<Product_Release_Component_Release__c> productReleaseObj = [Select Id, Product_Release__r.Product_Release__c, Product_Release__r.Product_Material__r.Name, Product_Release__r.Product_Material__r.CA_Product_Controller__r.Name from Product_Release_Component_Release__c where Product_Release__r.Product_Material__r.CA_Product_Controller__r.Name=:productName];
                if(productReleaseObj<>null && productReleaseObj.size()>0){
                    Set<String> uniqueVal = new Set<String>();
                    for(Product_Release_Component_Release__c prodRelObj:productReleaseObj){
                        if(uniqueVal==null || uniqueVal.size()==0 || (uniqueVal.size()>0 && !uniqueVal.contains(prodRelObj.Product_Release__r.Product_Release__c))){
                            mapOfRelease.put(prodRelObj.Id,prodRelObj.Product_Release__r.Product_Release__c);
                            showTable = true;
                            uniqueVal.add(prodRelObj.Product_Release__r.Product_Release__c);
                        }
                    }
                }else{
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'No product release found');
                    ApexPages.addmessage(errorMsg);
                }
            }
     }
     
     
     public List<SelectOption> getProudctRelease(){
        List<SelectOption> productReleaseObj = new List<SelectOption>();
        if(mapOfRelease<>null && mapOfRelease.keySet()<>null){
            productReleaseObj.add(new SelectOption('-None-','-None-')); 
            
            for(String getIdValue:mapOfRelease.keySet()){
                productReleaseObj.add(new SelectOption(getIdValue,mapOfRelease.get(getIdValue)));    
            }
            productReleaseObj.sort();
        }
        system.debug('%%%%%%'+productReleaseObj);
        return productReleaseObj;
    }
    
        
    public pageReference releaseFunc(){
        String idVal = System.currentPagereference().getParameters().get('releaseId');
        if(String.isNotBlank(idVal)){
            mapOfComp = new Map<Id,String>();
            List<Product_Release_Component_Release__c> productReleaseObj = [Select Id, Product_Release__c from Product_Release_Component_Release__c where Id=:idVal limit 1];
            
            if(productReleaseObj<>null && productReleaseObj.size()>0 && String.isNotBlank(productReleaseObj[0].Product_Release__c)){
                 List<Product_Release_Component_Release__c> listOfComp = [Select id, Component_Release__r.Name from Product_Release_Component_Release__c where Product_Release__c=:productReleaseObj[0].Product_Release__c];
                
                if(listOfComp <>null && listOfComp .size()>0){
                    for(Product_Release_Component_Release__c compReleaseObj:listOfComp){
                        if(String.isNotBlank(productName) && String.isNotBlank(compReleaseObj.Component_Release__r.Name)){
                            mapOfComp.put(compReleaseObj.Id, compReleaseObj.Component_Release__r.Name); 
                            showComp = true;
                        }
                    }      
                }
            }
        }
        return null;
    }
    //caProductController=ACF2&productCode=ACF2WS05500 
    public List<SelectOption> getProudctComponent(){
        List<SelectOption> productCompObj = new List<SelectOption>();
        if(mapOfComp<>null && mapOfComp.keySet()<>null){
            productCompObj.add(new SelectOption('-None-','-None-')); 
            
            for(String getIdValue:mapOfComp.keySet()){
                productCompObj.add(new SelectOption(getIdValue,mapOfComp.get(getIdValue)));    
            }
            productCompObj.sort();
        }
       system.debug('CCCCCOOOOO'+productCompObj);
        return productCompObj;
    }
    
     public PageReference gottodirectCasePage(){
        PageReference pageref=null;
      //  String[] fieldIDValues=new String[3];
      String[] fieldIDValues=new String[10];
        String fieldUrl=null;
        String url=null;
        try{
            fieldIDValues[0]=System.Label.OfferingCaseFieldIdSite;
            fieldIDValues[1]=System.Label.OfferingCaseFieldIdSiteLkid;
            fieldIDValues[2]=System.Label.OfferingCaseFieldIdCasewithoutEntitlement;
            fieldIDValues[3]=System.Label.TSStage;
            //Product
            fieldIDValues[4] = 'CF00Na000000ArhgS';
            fieldIDValues[5] = 'CF00Na000000ArhgS_lkid';
            //Component
            fieldIDValues[6] = 'CF00Na000000ArhgR';
            fieldIDValues[7] = 'CF00Na000000ArhgR_lkid';
            //Release 
            fieldIDValues[8] = 'CF00Na000000Arhh3';
            fieldIDValues[9] = 'CF00Na000000Arhh3_lkid';
            
            
            //CA Product//            
            if(siteName<>null && siteName!='' && selectedSiteId<>null && selectedSiteId!=''){             
                siteName=EncodingUtil.urlEncode(siteName,'UTF-8');               
                
                //fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId;
               // fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification';
                //fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification';
                fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[0]+'='+siteName+'&'+fieldIDValues[1]+'='+selectedSiteId+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'=CLARITY ON DEMAND'+'&'+fieldIDValues[5]+'=a7Za0000000PB6eEAG'+'&'+fieldIDValues[8]+'=15.3'+'&'+fieldIDValues[9]+'=a7m0c000000PLA0AAO';


            }else{
               // fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1';
               fieldUrl='/500/e?nooverride=1'+'&'+fieldIDValues[2]+'=1'+'&'+fieldIDValues[3]+'=1. Problem Identification'+'&'+fieldIDValues[4]+'=CLARITY ON DEMAND'+'&'+fieldIDValues[5]+'=a7Za0000000PB6eEAG'+'&'+fieldIDValues[8]+'=15.3'+'&'+fieldIDValues[9]+'=a7m0c000000PLA0AAO'+'&'+fieldIDValues[6]+'=ODEVCL 15.3 CLARITY PPM SAAS OPERATIONS'+'&'+fieldIDValues[7]+'=a7m0c000000PLA0AAO';
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



  
    
}