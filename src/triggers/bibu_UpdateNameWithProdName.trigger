trigger bibu_UpdateNameWithProdName on TSO_Request_Product_Selection__c (before insert, before update) {
    for(TSO_Request_Product_Selection__c reqProd:Trigger.new){
        List<Product2> prods = [select Name from Product2 where id=:reqProd.ProductId__c];
        if(!prods.isEmpty())
            reqProd.Name = prods[0].Name;
    }
}