public class DemoAutoComplete {
    public String productName{get;set;}
    public Id accId{get;set;}
    public String searchTerm {get; set;}
    

    public String selectedProd {get; set;}
    
    public String productReleaseValue{get;set;}
    public Map<Id,String> mapOfRelease{get;set;} 
    public String accName{get;set;}
    
    
    //public Boolean showComp{get;set;}
    public String productComponentValue{get;set;}
    public Map<Id,String> mapOfComp{get;set;}
    
    public Boolean showComp{get;set;}
    public Boolean showTable{get;set;}
    
    public String siteName {get;set;} 
    public String selectedSiteId {get; set;}  
    
    
    public DemoAutoComplete()
    {
    
    }
    
     public DemoAutoComplete(ApexPages.StandardController controller) 
   {
    
      mapOfRelease = new Map<Id,String>();
      //  showTable = false;
      //  showComp = false;
       
       
     mapOfRelease = new Map<Id,String>();
     //productName = accName; //'CLARITY ON DEMAND';//selectedProd;     
         if(String.isNotBlank(productName))
         {
                List<Product_Release_Component_Release__c> productReleaseObj = [Select Id, Product_Release__r.Product_Release__c, Product_Release__r.Product_Material__r.Name, Product_Release__r.Product_Material__r.CA_Product_Controller__r.Name from Product_Release_Component_Release__c where Product_Release__r.Product_Material__r.CA_Product_Controller__r.Name=:productName];
                if(productReleaseObj<>null && productReleaseObj.size()>0){
                    Set<String> uniqueVal = new Set<String>();
                    for(Product_Release_Component_Release__c prodRelObj:productReleaseObj){
                        if(uniqueVal==null || uniqueVal.size()==0 || (uniqueVal.size()>0 && !uniqueVal.contains(prodRelObj.Product_Release__r.Product_Release__c))){
                            mapOfRelease.put(prodRelObj.Id,prodRelObj.Product_Release__r.Product_Release__c);
                           // showTable = true;
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
     
         
     mapOfRelease = new Map<Id,String>();
     System.Debug('productName is : ' +productName );
      System.Debug('Entered getProudctRelease');
     //productName = accName; //'CLARITY ON DEMAND';//selectedProd;     
         if(String.isNotBlank(productName))
         {
                List<Product_Release_Component_Release__c> productReleaseObj = [Select Id, Product_Release__r.Product_Release__c, Product_Release__r.Product_Material__r.Name, Product_Release__r.Product_Material__r.CA_Product_Controller__r.Name from Product_Release_Component_Release__c where Product_Release__r.Product_Material__r.CA_Product_Controller__r.Name=:productName];
                if(productReleaseObj<>null && productReleaseObj.size()>0){
                    Set<String> uniqueVal = new Set<String>();
                    for(Product_Release_Component_Release__c prodRelObj:productReleaseObj){
                        if(uniqueVal==null || uniqueVal.size()==0 || (uniqueVal.size()>0 && !uniqueVal.contains(prodRelObj.Product_Release__r.Product_Release__c))){
                            mapOfRelease.put(prodRelObj.Id,prodRelObj.Product_Release__r.Product_Release__c);
                           // showTable = true;
                            uniqueVal.add(prodRelObj.Product_Release__r.Product_Release__c);
                        }
                    }
                }else{
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'No product release found');
                    ApexPages.addmessage(errorMsg);
                }
            }
            else
            {
                System.Debug('Prod Name is Blank');
            }
     
     
     
       
        List<SelectOption> productReleaseObj = new List<SelectOption>();
        System.Debug('Entered getProudctRelease and mapOfRelease is :' + mapOfRelease);
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
                            //showComp = true;
                        }
                    }      
                }
            }
        }
        return null;
    }
    
    public pageReference getrel()
    {
      
      getProudctRelease();     
      return null;     
    }  
    
     
    //caProductController=ACF2&productCode=ACF2WS05500 
    public List<SelectOption> getProudctComponent(){
        List<SelectOption> productCompObj = new List<SelectOption>();
         productCompObj.add(new SelectOption('-None-','-None-')); 
        if(mapOfComp<>null && mapOfComp.keySet()<>null){
           // productCompObj.add(new SelectOption('-None-','-None-')); 
            
            for(String getIdValue:mapOfComp.keySet()){
                productCompObj.add(new SelectOption(getIdValue,mapOfComp.get(getIdValue)));    
            }
            productCompObj.sort();
        }
       system.debug('CCCCCOOOOO'+productCompObj);
        return productCompObj;
    }
    
    public PageReference refresh(){
        return null;
    }
     public PageReference getsairelepls(){
        return null;
    }
    
    @RemoteAction
   // public static list<Account> getAccounts(string s){
   public static List<CA_Product_Controller__c> getAccounts(String searchTerm) {
        list<CA_Product_Controller__c >accList = new list<CA_Product_Controller__c >();
        if(searchTerm != ''){
            accList = [ Select Name From CA_Product_Controller__c WHERE Name LIKE :'%' + String.escapeSingleQuotes(searchTerm) + '%' ] ;
           // accList = database.query(query);
        }    
        return accList;
    }
    

     
   
    
    }