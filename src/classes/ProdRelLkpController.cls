public class ProdRelLkpController {
    public String query {get; set;}
    public List<Product_Release__c> prdmats {get; set;}

    public PageReference runQuery()
    {
        prdmats = new List<Product_Release__c>();
        Map<String,Product_Release__c> prodMap = new Map<String,Product_Release__c>();
        System.debug('query ===='+query);
        //prdmats = [Select GA_Level_Text__c,Product_Material__r.Product__r.Name, Product_Material__r.SAP_Product_Mapping__c, Product_Material__r.Material_Text__c, Product_Release__c from Product_Release__c where Product_Material__c in (Select id from Product_Material__c where SAP_Product_Mapping__c = :query) order by Product_Release__c desc];
        for(Product_Release__c prodRel : [Select GA_Level_Text__c,Product_Material__r.Product__r.Name, Product_Material__r.SAP_Product_Mapping__c, Product_Material__r.Material_Text__c, Product_Release__c from Product_Release__c where Product_Material__c in (Select id from Product_Material__c where SAP_Product_Mapping__c = :query) order by Product_Release__c desc]){
            prodMap.put(prodRel.Product_Material__r.Product__r.Name+'~'+prodRel.Product_Material__r.SAP_Product_Mapping__c+'~'+prodRel.Product_Material__r.Material_Text__c+'~'+prodRel.Product_Release__c,prodRel);
            System.debug('==='+prodMap.values());
        }
        if(prodMap !=null && prodMap.size()>0){
            prdmats.addAll(prodMap.values());
        }

        return null;
    }
}