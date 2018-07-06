global class ConvertSAOPartnerProductFields{
    String query = 'Select s.Opportunity_Line_Item_Id__c, s.CreatedDate, s.CurrencyIsoCode, s.Id, s.IsDeleted, s.LastModifiedDate, s.Name,  s.Product__c, s.Revenue_Split__c, s.Revenue_Split_in_USD__c, s.Sales_Price__c, s.SAO_Partner__c, s.SAO_Partner__r.Id, s.SAO_Partner__r.Name, s.SAO_Partner__r.Nbr_of_Products__c, s.SAO_Partner__r.Opportunity__c, s.SAO_Partner__r.Opportunity__r.Name,  s.SAO_Partner__r.Opportunity__r.Opportunity_Number__c, s.SAO_Partner__r.SAO_Partner_Name__c, s.SAO_Partner__r.Total_Sales_Price__c from SAO_Partner_Product__c s  Where  s.SAO_Partner__r.Opportunity__c <> \'\' and s.SAO_Partner__r.Nbr_of_Products__c > 0';
    String query1 = 'Select s.Opportunity_Line_Item_Id__c, s.CreatedDate, s.CurrencyIsoCode, s.Id, s.IsDeleted, s.LastModifiedDate, s.Name,  s.Product__c, s.Revenue_Split__c, s.Revenue_Split_in_USD__c, s.Sales_Price__c, s.SAO_Partner__c, s.SAO_Partner__r.Id, s.SAO_Partner__r.Name, s.SAO_Partner__r.Nbr_of_Products__c, s.SAO_Partner__r.Opportunity__c, s.SAO_Partner__r.Opportunity__r.Name,  s.SAO_Partner__r.Opportunity__r.Opportunity_Number__c, s.SAO_Partner__r.SAO_Partner_Name__c, s.SAO_Partner__r.Total_Sales_Price__c from SAO_Partner_Product__c s  Where  s.SAO_Partner__r.Opportunity__c <> \'\' and s.SAO_Partner__r.Nbr_of_Products__c > 0 and s.Name < \'SOA_PP_0000001000\'';
    String query2 = 'Select s.Opportunity_Line_Item_Id__c, s.CreatedDate, s.CurrencyIsoCode, s.Id, s.IsDeleted, s.LastModifiedDate, s.Name,  s.Product__c, s.Revenue_Split__c, s.Revenue_Split_in_USD__c, s.Sales_Price__c, s.SAO_Partner__c, s.SAO_Partner__r.Id, s.SAO_Partner__r.Name, s.SAO_Partner__r.Nbr_of_Products__c, s.SAO_Partner__r.Opportunity__c, s.SAO_Partner__r.Opportunity__r.Name,  s.SAO_Partner__r.Opportunity__r.Opportunity_Number__c, s.SAO_Partner__r.SAO_Partner_Name__c, s.SAO_Partner__r.Total_Sales_Price__c from SAO_Partner_Product__c s  Where  s.SAO_Partner__r.Opportunity__c <> \'\' and s.SAO_Partner__r.Nbr_of_Products__c > 0 and s.Name >= \'SOA_PP_0000001000\' and s.Name < \'SOA_PP_0000002000\'';
    String query3 = 'Select s.Opportunity_Line_Item_Id__c, s.CreatedDate, s.CurrencyIsoCode, s.Id, s.IsDeleted, s.LastModifiedDate, s.Name,  s.Product__c, s.Revenue_Split__c, s.Revenue_Split_in_USD__c, s.Sales_Price__c, s.SAO_Partner__c, s.SAO_Partner__r.Id, s.SAO_Partner__r.Name, s.SAO_Partner__r.Nbr_of_Products__c, s.SAO_Partner__r.Opportunity__c, s.SAO_Partner__r.Opportunity__r.Name,  s.SAO_Partner__r.Opportunity__r.Opportunity_Number__c, s.SAO_Partner__r.SAO_Partner_Name__c, s.SAO_Partner__r.Total_Sales_Price__c from SAO_Partner_Product__c s  Where  s.SAO_Partner__r.Opportunity__c <> \'\' and s.SAO_Partner__r.Nbr_of_Products__c > 0 and s.Name >= \'SOA_PP_0000002000\'';
    String query4 = 'update SAO_Partner_Product__c set Opportunity_Line_Item_Id__c = \'\'';
    String email;
    String mailBody = '';   
    
    global void updateLineItems1(){
        updateLineItems(query1);
    }
    global void updateLineItems2(){
        updateLineItems(query2);
    }
    global void updateLineItems3(){
        updateLineItems(query3);
    }
    global void updateLineItems(String newQuery){
        query = newQuery;
        List<SAO_Partner_Product__c> forUpdate = new List<SAO_Partner_Product__c>();
        List<SAO_Partner_Product__c> partnerProducts = Database.query(query);
        System.debug('No of partner product records retrieved: ' + partnerProducts.size()+ '\n');
        for(SAO_Partner_Product__c a : partnerProducts){
            a.Opportunity_Line_Item_Id__c = '';
            forUpdate.add(a);
        }
        if(forUpdate.size()>0)
            Database.update(forUpdate);
    }
    global database.Querylocator start(){
        return Database.getQueryLocator(query);
    }
    global void updateLineItemsToEmpty(){
        Database.query(query4);
    }
    global void getEmptyRows(String newQuery){
       query = newQuery;
        List<SAO_Partner_Product__c> partnerProducts = Database.query(query);
        System.debug('Total empty records: ' + partnerProducts.size()+ '\n');
       for(SAO_Partner_Product__c s : partnerProducts ){
            SAO_Partner_Product__c a = (SAO_Partner_Product__c)s;
            System.debug(a + '\n');
       }
   }
  
   global void forceStart1(){
        forceStart(query1);
    }
    global void forceStart2(){
        forceStart(query2);
    }
    global void forceStart3(){
        forceStart(query3);
    }
    
    global void forceStart(String newQuery){
        query = newQuery;
        List<SAO_Partner_Product__c> partnerProducts = Database.query(query);
        System.debug('No of partner product records retrieved: ' + partnerProducts.size()+ '\n');
        executeBatch(partnerProducts);
    }
    global void executeBatch(Sobject[] scope){
        printDuplicates(scope);
    }
    
    global void printDuplicates(Sobject[] scope){
        //        System.debug('in execute batch');
        List<SAO_Partner_Product__c> saoPartnerToUpdate = new List<SAO_Partner_Product__c>(); 
        Map<String, SAO_Partner_Product__c> saoPartnerProductMap = new Map<String, SAO_Partner_Product__c>();
        Map<String, SAO_Partner_Product__c> saoPartnerProductDupsMap = new Map<String, SAO_Partner_Product__c>();
        
        Map<String, OpportunityLineItem> oppLineMap = new Map<String, OpportunityLineItem>();
        Map<String, OpportunityLineItem> oppLineDupsMap = new Map<String, OpportunityLineItem>();
    
        Map<String, String> saoProductOpportunityComboMap = new Map<String, String>();        
        Map<String, String> productOpportunityComboMap = new Map<String, String>();        
        Map<String, String> saoProductOpportunityMap = new Map<String, String>();
        Map<String, String> productOpportunityMap = new Map<String, String>();
        System.debug('Duplicate product in SAO Partner Product ');
        for(sobject s : scope){
            SAO_Partner_Product__c a = (SAO_Partner_Product__c)s;
            
            String partOppProdId = (String)a.SAO_Partner__r.Opportunity__c + (String)a.Product__c;
            if(saoProductOpportunityComboMap.get(partOppProdId) != null) {
//          System.debug('Duplicate product in SAP Partner Product ' +a.SAO_Partner__r.SAO_Partner_Name__c+' '+ a.SAO_Partner__r.Id + '  ' + a.Product__c + '  ' + a.SAO_Partner__r.Opportunity__r.Opportunity_Number__c);
            System.debug(a+'\r\n');
            saoPartnerProductDupsMap.put(a.Id, a);
            }
            else{
                saoPartnerProductMap.put(a.Id, a);
                saoProductOpportunityMap.put(a.SAO_Partner__r.Opportunity__c, a.Product__c);
                saoProductOpportunityComboMap.put(partOppProdId, a.Id);
            }
        }
        System.debug('Duplicate products Opportunity line item');
        MAP<ID, OpportunityLineItem> o = new MAP<ID, OpportunityLineItem>([Select o.Id, o.ListPrice, o.OpportunityId, o.PricebookEntryId, o.PricebookEntry.Name, o.PricebookEntry.Product2Id, o.PricebookEntry.UnitPrice, o.TotalPrice, o.UnitPrice from OpportunityLineItem o Where  o.PricebookEntry.Product2Id IN :saoProductOpportunityMap.values() and o.OpportunityId IN :saoProductOpportunityMap.keySet()]);
        System.debug('No of opportunity line item records retrieved: ' + o.values().size() + '\n');
        for(OpportunityLineItem a : o.values()){
            String oppId = a.OpportunityId;
            String prodId = a.PricebookEntry.Product2Id;
            String oppProdId = oppId +prodId;
            
            if(productOpportunityComboMap.get(oppProdId) != null){
                System.debug(a+'\r\n');
                oppLineDupsMap.put(a.Id, a);
            }
            else{
                oppLineMap.put(a.Id, a);
                productOpportunityComboMap.put(oppProdId ,a.Id);
                String saoProductLineId = saoProductOpportunityComboMap.get(oppProdId);
                if(saoProductLineId != null){
                    SAO_Partner_Product__c b = (SAO_Partner_Product__c)saoPartnerProductMap.get(saoProductLineId);
                    b.Opportunity_Line_Item_Id__c = a.Id;
                    b.Sales_Price__c  = a.UnitPrice;
                    b.Revenue_Split__c  = a.UnitPrice;
                    saoPartnerToUpdate.add(b);
                }
                    
            }
        }
        System.debug('Number of duplicate products in alliance partners: ' +saoPartnerProductDupsMap.size() + '\n');
        String dupPP = '';
        //for(SAO_Partner_Product__c a: saoPartnerProductDupsMap.values()){
        //    dupPP = dupPP + a.
        //}
        System.debug('Number of duplicate products in opportunity line items: ' + oppLineDupsMap.size()+ '\n');
        if(saoPartnerToUpdate.size()>0){
            System.debug('No of records updated: ' + saoPartnerToUpdate.size());
            Database.update(saoPartnerToUpdate);
        }    
    }
    
    public static testMethod void testBatch() {
        Test.StartTest();
        ConvertSAOPartnerProductFields reassign = new ConvertSAOPartnerProductFields();
        reassign.updateLineItems1();
        reassign.forceStart1();
        
        
        Test.StopTest();
    }
}