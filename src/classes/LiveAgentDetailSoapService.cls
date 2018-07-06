global class  LiveAgentDetailSoapService {

  webService  static String getButtonId( String productName) {
  
    String buttonId = productName;   
    Product_Button__c productButton ;
    List<Product_Material__c> proMaterials = [select id,name,CA_Product_Controller__r.Product_Button__r.Button_Id__c from Product_Material__c where name =: productName];

    if(! proMaterials.isEmpty()){
          return proMaterials[0].CA_Product_Controller__r.Product_Button__r.Button_Id__c;
      }
      else
          return 'null';
  }
}