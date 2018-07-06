trigger ai_CopyLineItemsToRequest on TSO_Request__c (after insert) {
 if(SystemIdUtility.skipTSORequestTriggers)
            return;


    for(TSO_Request__c req:Trigger.new){
        if(req.Selected_Product_Ids__c!=null && req.Selected_Product_Ids__c!=''){
            String[] productIds = req.Selected_Product_Ids__c.split(',',3);
            for(String strId:productIds){
                List<Product2> prods = [Select Name, Market_Focus_Area__c, Id, Family From Product2 where id=:strId];
                if(!prods.isEmpty()){
                    Product2 prod = prods[0];
                    TSO_Request_Product_Selection__c reqProd = new TSO_Request_Product_Selection__c();
                    reqProd.Name = prod.Name;
                    //reqProd.BU__c = prod.Market_Focus_Area__c;
                    //reqProd.Product__c = prod.Name;
                    //reqProd.Product_Family__c = prod.Family;
                    string reqId = req.Id;
                    if(reqId .length()>15)
                        reqId = reqId .substring(0, 15);
                        
                    reqProd.TSO_Request_ID__c = reqId;
                    reqProd.ProductId__c = strId;

                    insert reqProd;
                }
            }
        }
    }
}