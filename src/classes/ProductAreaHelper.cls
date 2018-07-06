/* Test Classes : ProductAreaHelper_Test ; CC_AWSMock; */
public class ProductAreaHelper {
    
    public class ProductAreaWrapper{
        public String id;
        public String ca_product_area;
        public String ca_product_name;
        public ProductAreaWrapper(String id, String ca_product_area, String ca_product_name){
            this.id = id;
            this.ca_product_area = ca_product_area;
            this.ca_product_name = ca_product_name;        
        }
        public ProductAreaWrapper(String id){
            this.id = id;      
        }
    }
    
    public class PARequestPayload {
        public string requestType;
        public List<ProductAreaWrapper> productAreaArray;
    }
        
    public static String prepareRequestBody(Set<Id> paIdSet, String requestType) {
        List<ProductAreaWrapper> paList = new List<ProductAreaWrapper>();
        
        if(requestType == 'del'){
            List<ID> paIdList = new List<ID>();
            paIdList.addAll(paIdSet);
            for(Id paId : paIdList){
                ProductAreaWrapper p = new ProductAreaWrapper((String)paId);
                paList.add(p);
            }
        } else {
            List<Product_Area__c> productAreaList = [select id,Name,CA_Product__c,CA_Product__r.Name from Product_Area__c where id IN :paIdSet];
            for(Product_Area__c  t : productAreaList){
                ProductAreaWrapper p = new ProductAreaWrapper(t.Id,t.Name, t.CA_Product__r.Name);
                paList.add(p);        
            }            
        }

        
        PARequestPayload paReq = new PARequestPayload();
        paReq.requestType = requestType;
        paReq.productAreaArray= paList;
        String jsonpaReq= JSON.serialize(paReq);
        System.debug('jsonpaReq:'+jsonpaReq);
        
        return jsonpaReq;
    }
    
    @future(callout=true)
    public static void pushPAChangestoDB(Set<Id> paIDSet, String requestType){
        if(Test.isRunningTest()){
            return ;
        }
        List<Product_Area_Error_Log__c> paErrorLogList = new List<Product_Area_Error_Log__c>();
        String responseFromUpdatePAService = '';
        String params = prepareRequestBody(paIDSet,requestType); 
        //Making an AWS Call here.
        String relativeEndpoint =  System.Label.ProductArea_AWS_endpoint; //'/download-center/update-product-area';
        String awstoken = CC_Layer7Service.getAWSToken();
        try{
            responseFromUpdatePAService = CC_Layer7Service.callAWSWebService(awstoken,'POST',params,relativeEndpoint);
            System.debug('responseFromUpdatePAService:'+responseFromUpdatePAService);      
            if( responseFromUpdatePAService.contains('error') ){
                Util_JSONParser parseResponse= Util_JSONParser.createParser(responseFromUpdatePAService);
                String error=parseResponse.get('error').Value;
                if(error!=null){
                    Product_Area_Error_Log__c paError= new Product_Area_Error_Log__c();
                    paError.Input_Payload__c = 'Endpoint:'+ relativeEndpoint + '\nRequest Payload:\n'+params;
                    paError.Response_Payload__c = responseFromUpdatePAService;
                    paErrorLogList.add(paError);
                }
            } 
        } catch(Exception e){
            if(! e.getMessage().contains('CC_Layer7Service.updateAWSToken') ){
                    Product_Area_Error_Log__c paError= new Product_Area_Error_Log__c();
                    paError.Input_Payload__c = 'Endpoint:'+ relativeEndpoint + '\nRequest Payload:\n'+params;
                    paError.Response_Payload__c = 'Exception Message:'+ e.getMessage() + '\n Stacktrace:'+e.getStackTraceString();
                    paErrorLogList.add(paError);
            }
        }finally{
            if(paErrorLogList != null && paErrorLogList.size() >0 )
                insert paErrorLogList;
        }      
        
        
    }
    
}