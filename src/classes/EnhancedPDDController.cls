public class EnhancedPDDController {
    /*
    public String accountId {get;set;}
   // public List<Customer_DNA__c> customerDNAList {get;set;}
    
    public EnhancedPDDController(){        
        accountId = ApexPages.currentPage().getParameters().get('accId');
        System.debug('accountId:'+ accountId);
        String cdnaQuery = 'select id,Account__c,CA_Product_Controller__c,GA_Level__c,'
                    +'Instance_Name__c,Scale_of_Adoption__c,Segment__c,Value_Realization_Statement__c'
                    +' from Customer_DNA__c where Account__c = \'' +  accountId + '\'';
        System.debug('cdnaQuery:'+cdnaQuery);
        controller = new ApexPages.StandardSetController(Database.getQueryLocator(cdnaQuery));    
        //customerDNAList =  controller.getRecords(); 
    }
    
    public ApexPages.StandardSetController controller {
        
        get {
            System.debug('controller:'+ controller);
            if(controller == null) {
                String cdnaQuery = 'select id,Account__c,CA_Product_Controller__c,GA_Level__c,'
                    +'Instance_Name__c,Scale_of_Adoption__c,Segment__c,Value_Realization_Statement__c'
                    +'from Customer_DNA__c where Account__c = \'' +  accountId + '\'';
               // List<Customer_DNA__c> customerDNAList = [select id,Account__c,CA_Product_Controller__c,GA_Level__c,
                                                            Instance_Name__c,Scale_of_Adoption__c,Segment__c,Value_Realization_Statement__c
                                                            from Customer_DNA__c where Account__c =: accountId
                                                           ]; 
                controller = new ApexPages.StandardSetController(Database.getQueryLocator(cdnaQuery));              
            }
            return controller;
        }
        set;       
    }
    
    public List<Customer_DNA__c> getcustomerDNAList() {
        System.debug('In getcustomerDNAList');
        return (List<Customer_DNA__c>)controller.getRecords();     
    }
    */


}