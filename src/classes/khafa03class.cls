public class khafa03class {
    
    public case displayCase{get;set;}
    
    public khafa03class(){
    	displayCase = [select PRODUCT_RELEASE__C,PRODUCT__C from case where Product__c!=NULL limit 1];  
       
    }
    
}