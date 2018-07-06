/*
 * This Trigger should only have After Insert and After Delete,
 * and is only to insert records to the SFCPQ_SOX_Tracking__c Object.
 * No other processing should be done in this trigger. This trigger
 * should not be bypassed or deactivated during dataload. 
 * 
 */
/*
 * Test Class - TestSoxTriggersAndClasses
 * Coverage - 100%
*/
trigger sfcpq_sox_vdp on Volume_Discount_Pricing__c (after insert,after delete) {
    
    List<SFCPQ_SOX_Tracking__c> sfcpqSoxTrackList = new List<SFCPQ_SOX_Tracking__c>();
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            for(Volume_Discount_Pricing__c vdp:trigger.new){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Insert';
                temp.Object_Name__c = 'Volume_Discount_Pricing__c';
                temp.Record_ID__c = vdp.id;
                temp.VDP_Name__c = vdp.Name;
                temp.VDP_Currency_Form__c = vdp.Currency_Form__c;
                temp.VDP_Effective_End_Date__c = vdp.Effective_End_Date__c;
                temp.VDP_Effective_Start_Date__c = vdp.Effective_Start_Date__c;
                temp.VDP_License_Count_High_Bound__c = vdp.License_Count_High_Bound__c;
                temp.VDP_License_Count_Low_Bound__c = vdp.License_Count_Low_Bound__c;
                temp.VDP_Product__c = vdp.Product__c;
                temp.VDP_Product_Code__c = vdp.Product_Code__c;
                temp.VDP_Product_List_Price_usd__c = vdp.Product_List_Price_usd__c;
                temp.VDP_Product_Name__c = vdp.Product_Name__c;
                temp.VDP_Term_High_Bound__c = vdp.Term_High_Bound__c;
                temp.VDP_Term_Low_Bound__c = vdp.Term_Low_Bound__c;
                temp.VDP_Unique_Id__c = vdp.Unique_Id__c;
                temp.VDP_Volume_Discount_Percent__c = vdp.Volume_Discount_Percent__c;
                
                sfcpqSoxTrackList.add(temp);
                
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
        
        if(Trigger.isDelete){
            
            for(Volume_Discount_Pricing__c vdp:trigger.old){
                
                SFCPQ_SOX_Tracking__c temp = new SFCPQ_SOX_Tracking__c();
                temp.DML_Type__c = 'Delete';
                temp.Object_Name__c = 'Volume_Discount_Pricing__c';
                temp.Record_ID__c = vdp.id;
                temp.VDP_Name__c = vdp.Name;
                temp.VDP_Currency_Form__c = vdp.Currency_Form__c;
                temp.VDP_Effective_End_Date__c = vdp.Effective_End_Date__c;
                temp.VDP_Effective_Start_Date__c = vdp.Effective_Start_Date__c;
                temp.VDP_License_Count_High_Bound__c = vdp.License_Count_High_Bound__c;
                temp.VDP_License_Count_Low_Bound__c = vdp.License_Count_Low_Bound__c;
                temp.VDP_Product__c = vdp.Product__c;
                temp.VDP_Product_Code__c = vdp.Product_Code__c;
                temp.VDP_Product_List_Price_usd__c = vdp.Product_List_Price_usd__c;
                temp.VDP_Product_Name__c = vdp.Product_Name__c;
                temp.VDP_Term_High_Bound__c = vdp.Term_High_Bound__c;
                temp.VDP_Term_Low_Bound__c = vdp.Term_Low_Bound__c;
                temp.VDP_Unique_Id__c = vdp.Unique_Id__c;
                temp.VDP_Volume_Discount_Percent__c = vdp.Volume_Discount_Percent__c;
                
                sfcpqSoxTrackList.add(temp);
                
            }
            
            if(sfcpqSoxTrackList.size()>0){
                insert sfcpqSoxTrackList;
            }
        }
        
    }
    
    

}