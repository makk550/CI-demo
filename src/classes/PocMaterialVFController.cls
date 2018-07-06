public with sharing class PocMaterialVFController{

 public Trial_Request__c relatedTo{get;set;}
 public Id pocReqId{get;set;}
 public List<pocMaterial__c> tPocProductMaterials; 


 
public PocMaterialVFController() {

  }
 
public List<pocMaterial__c> gettPocProductMaterials() {
    this.tPocProductMaterials = [Select Id,Name , quantity__c, Product_Material__r.SAP_Product_Mapping__c, Product_Material__r.Material_Text__c, Product__r.Id, Product__r.Name from pocMaterial__c where POC_Request__c = :pocReqId];  
     return this.tPocProductMaterials ;
   }

}