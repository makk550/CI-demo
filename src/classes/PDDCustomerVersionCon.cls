public class PDDCustomerVersionCon{

    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
   
    public String accId ;
    public String prodName;
    
    public PDDCustomerVersionCon(ApexPages.StandardController controller){
        
        prodName =ApexPages.currentPage().getParameters().get('accId');
        
        accId = ApexPages.currentPage().getParameters().get('id');
       
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        System.debug('accId@@@====='+accId);
    }
     
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) { 
                String cvmQuery ='SELECT CVM_Product_Name__c,CreatedDate,csu2__c,product_new__r.Name,date_created_in_DW__c,Enterprise_account__c,etl_timestamp__c,firstcall__c,firstdate__c,'+
                                                    'Id,lastcall__c,lastdate__c,Name,Product_id__c,product_new__c,product_segment_enterprise_id__c,region__c,'+
                                                    'source_system_to_DW__c,status__c,totalcall__c,version__c,Version_Text__c FROM Customer_Version_Map__c where ';
                                                    
                if(!String.isBlank(prodName)){
                  // cvmQuery += 'product_new__r.Product__r.Name =\''+prodName.trim()+'\' AND ';
                    cvmQuery += 'CVM_Product_Name__c =\''+prodName.trim()+'\' AND ';
                   
                }
                
                    cvmQuery += 'Enterprise_account__c =\''+accId+'\'';
               
                System.debug('==='+cvmQuery );
                //if(!String.isBlank(accId)){               
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(cvmQuery));
                //}
                setCon.setPageSize(size);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(size);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
    public List<Customer_Version_Map__c> getlstVersions() {
         return (List<Customer_Version_Map__c>) setCon.getRecords();
    }
}