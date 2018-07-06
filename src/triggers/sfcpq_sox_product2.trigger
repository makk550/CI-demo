/*
 * This Trigger should only have After Insert and After Delete,
 * and is only to insert records to the SFCPQ_SOX_Tracking__c Object.
 * No other processing should be done in this trigger. This trigger
 * should not be bypassed or deactivated during dataload. 
 * 
 */ 
trigger sfcpq_sox_product2 on Product2 (after insert,after delete) {
    
    List<SFCPQ_SOX_Tracking__c> sfcpqSoxTrackList = new List<SFCPQ_SOX_Tracking__c>();
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            for(Product2 prod:trigger.new){
                
                if(prod.Salesforce_CPQ_Product__c==true){
                    
                    SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                    temp.DML_Type__c = 'Insert';
                    temp.Object_Name__c = 'Product2';
                    temp.Record_ID__c = prod.id;
                    temp.Product2_SubscriptionPercent__c = prod.SBQQ__SubscriptionPercent__c;
                    temp.Product2_SubscriptionBase__c = prod.SBQQ__SubscriptionBase__c;
                    temp.Product2_Product_Code_For_Promotions__c = prod.Product_Code_For_Promotions__c;
                    temp.Product2_Subscription_Pricing__c = prod.SBQQ__SubscriptionPricing__c;
                    temp.Product2_Subscription_Term__c = prod.SBQQ__SubscriptionTerm__c;  
                    temp.Product2_FreeofChargeProduct__c = prod.Free_of_Charge_Product__c;	//US492363 - BAJPI01
                    
                    sfcpqSoxTrackList.add(temp);                    
                }
                
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
        
        if(Trigger.isDelete){
            
            for(Product2 prod:trigger.old){
                
                if(prod.Salesforce_CPQ_Product__c==true){
                    
                    SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                    temp.DML_Type__c = 'Delete';
                    temp.Object_Name__c = 'Product2';
                    temp.Record_ID__c = prod.id;
                    temp.Product2_SubscriptionPercent__c = prod.SBQQ__SubscriptionPercent__c;
                    temp.Product2_SubscriptionBase__c = prod.SBQQ__SubscriptionBase__c;
                    temp.Product2_Product_Code_For_Promotions__c = prod.Product_Code_For_Promotions__c;
                    temp.Product2_Subscription_Pricing__c = prod.SBQQ__SubscriptionPricing__c;
                    temp.Product2_Subscription_Term__c = prod.SBQQ__SubscriptionTerm__c;
					temp.Product2_FreeofChargeProduct__c = prod.Free_of_Charge_Product__c;  //US492363 - BAJPI01                  
                    
                    sfcpqSoxTrackList.add(temp);                    
                }
                
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
        
        
    }
    
}