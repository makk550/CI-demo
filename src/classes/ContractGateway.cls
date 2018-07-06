public class ContractGateway {
    
    public static Set<Id> quoteIds = new Set<Id>(); 
    public static Map<Id, SBQQ__Quote__c> sbQuoteMap;

    public static void loadBulkContractValues(){
        List<Contract> listTrigger;

        if(Trigger.isInsert||Trigger.isUpdate){
            listTrigger = trigger.new;
            
        }
        else if(Trigger.isDelete){
            listTrigger = trigger.old;
        }
        if(Trigger.isBefore && Trigger.isInsert){
            for(Contract c: listTrigger){
                quoteIds.add(c.SBQQ__Quote__c);
            }
        }
        
        //retreive quote for each contract 
        if(quoteIds != null && quoteIds.size()>0){
            if(sbQuoteMap == null){
                sbQuoteMap = new Map<Id, SBQQ__Quote__c>();


                List<SBQQ__Quote__c> quotes = fetchQuoteDetails(quoteIds);

                //place each quote in map on the contract id 
                for(SBQQ__Quote__c q: quotes){
                    sbQuoteMap.put(q.SBQQ__MasterContract__c, q);
                }

                //for each contract retreive corresponging quote and map values 
                for(Contract c: listTrigger){
                    SBQQ__Quote__c quoteToMap = sbQuoteMap.get(c.Id);
                    if(quoteToMap!=null)
                         mapQuoteFieldsToContract(quoteToMap, c);
                }
            }
        }

    }   
    
    
    public static List<SBQQ__Quote__c> fetchQuoteDetails(Set<Id> quoteIds){
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        
        if(quoteIds!=null && quoteIds.size()>0){
            quoteList = [SELECT id, SBQQ__MasterContract__c, Bill_To_Address_Lcl__c, BillingContact_ID__c, BillingContact_Email__c,
                         BillingContact_FirstName__c,BillingContact_IntlFName__c, BillingContact_IntlLName__c,BillingContact_LastName__c,
                         BillingContact_Phone__c, BillTo_BPID__c,BillTo_City_Intl__c, BillTo_Name_Intl__c, BillTo_State_Intl__c,
                         BillTo_Street_Intl__c, BillTo_Street2_Intl__c, BillTo_City__c,BillTo_Country__c, BillTo_Name__c,
                         BillTo_PostalCode__c,BillTo_State__c, BillTo_Street__c, BillTo_Street2__c, CA_Bill_To_Name_Lcl__c,
                         CA_Customer_Name_Sold_To_Lcl__c, CA_Ship_To_Name_Lcl__c, ShippingContact_ID__c, ShippingContact_Email__c,
                         ShippingContact_FirstName__c,ShippingContact_IntlFName__c,ShippingContact_IntlLName__c,ShippingContact_LastName__c,
                         ShippingContact_Phone__c, Ship_To__c, ShipTo_BPID__c,ShipTo_City_Intl__c, ShipTo_Name__c, ShipTo_Name_Intl__c,
                         ShipTo_State_Intl__c, ShipTo_Street_Intl__c, ShipTo_Street2_Intl__c, ShipTo_City__c,
                         ShipTo_Country__c, ShipTo_PostalCode__c,ShipTo_State__c, ShipTo_Street__c, ShipTo_Street2__c, Sold_To_Address_Lcl__c,
                         Sold_To__c,SoldTo_BPID__c, SoldTo_City_Intl__c, SoldTo_Name_Intl__c, SoldTo_State_Intl__c, SoldTo_Street_Intl__c,
                         SoldTo_Street2_Intl__c, SoldTo_City__c,SoldTo_Country__c,SoldTo_Name__c, SoldTo_PostalCode__c, SoldTo_State__c,
                         SoldTo_Street__c, SoldTo_Street2__c, TechnicalContact_ID__c,TechnicalContact_Email__c, TechnicalContact_FirstName__c,
                         TechnicalContact_IntlFName__c, TechnicalContact_IntlLName__c,TechnicalContact_LastName__c,Company_Code__c,
                         TechnicalContact_Phone__c, Sales_Organization__c,Company_Registration_Number__c,
                         Booking_Country__c,EndUser_Contact_Email__c,EndUser_Contact_First_Name__c,EndUser_Contact_ID__c,
                         EndUser_Contact_Intl_First_Name__c,EndUser_Contact_Intl_Last_Name__c,EndUser_Contact_Last_Name__c,
                         EndUser_Contact_Phone__c,EndUser_City__c,EndUser_City_Intl__c,EndUser_Country__c,EndUser_BPID__c,
                         EndUser_ID__c,EndUser_Name__c,EndUser_Name_Intl__c,EndUser_Postal_Code__c,EndUser_State__c,
                         EndUser_State_Intl__c,EndUser_Street__c,EndUser_Street2__c,EndUser_Street2_Intl__c,EndUser_Street_Intl__c,
                         Reseller_City__c,Reseller_City_Intl__c,Reseller_Country__c,Reseller_BPID__c,Reseller_ID__c,
                         Reseller_Name__c,Reseller_Name_Intl__c,Reseller_Postal_Code__c,Reseller_State__c,Reseller_State_Intl__c,Partner_Engagement__c,
                         Reseller_Street__c,Reseller_Street2__c,Reseller_Street2_Intl__c,Reseller_Street_Intl__c,Partner1__c,Deal_Registration_Status__c,
                         SBQQ__Opportunity2__r.Route__c from SBQQ__Quote__c where id in :quoteIds];
            
        }
                
        return quoteList;
    }
    
    private static void mapQuoteFieldsToContract(SBQQ__Quote__c q, Contract c){
        c.Bill_To_Address_Lcl__c = q.Bill_To_Address_Lcl__c;
        c.Billing_Contact__c = q.BillingContact_ID__c;
        c.Billing_Contact_Email__c = q.BillingContact_Email__c;
        c.Billing_Contact_First_Name__c = q.BillingContact_FirstName__c;
        c.Billing_Contact_Intl_First_Name__c = q.BillingContact_IntlFName__c;
        c.Billing_Contact_Intl_Last_Name__c = q.BillingContact_IntlFName__c;
        c.Billing_Contact_Last_Name__c = q.BillingContact_LastName__c;
        c.Billing_Contact_Phone__c = q.BillingContact_Phone__c;
        c.Bill_To__c = q.BillTo_BPID__c;
        c.BillTo_City_Intl__c = q.BillTo_City_Intl__c;
        c.BillTo_Name_Intl__c = q.BillTo_Name_Intl__c;
        c.BillTo_State_Intl__c = q.BillTo_State_Intl__c;
        c.BillTo_Street_Intl__c = q.BillTo_Street_Intl__c;
        c.BillTo_Street2_Intl__c = q.BillTo_Street2_Intl__c;
        c.Bill_To_City__c = q.BillTo_City__c;
        c.Bill_To_Country__c = q.BillTo_Country__c;
        c.Bill_To_Name__c = q.BillTo_Name__c;
        c.Bill_To_PostalCode__c = q.BillTo_PostalCode__c;
        c.Bill_To_State__c = q.BillTo_State__c;
        c.Bill_To_Street__c = q.BillTo_Street__c;
        c.Bill_To_Street2__c = q.BillTo_Street2__c;
        c.CA_Bill_To_Name_Lcl__c = q.CA_Bill_To_Name_Lcl__c;
        c.CA_Customer_Name_Sold_To_Lcl__c = q.CA_Customer_Name_Sold_To_Lcl__c;
        c.CA_Ship_To_Name_Lcl__c = q.CA_Ship_To_Name_Lcl__c;
        c.Shipping_Contact__c = q.ShippingContact_ID__c;
        c.Shipping_Contact_Email__c = q.ShippingContact_Email__c;
        c.Shipping_Contact_First_Name__c = q.ShippingContact_FirstName__c;
        c.Shipping_Contact_Intl_First_Name__c = q.ShippingContact_IntlFName__c;
        c.Shipping_Contact_Intl_Last_Name__c = q.ShippingContact_IntlLName__c;
        c.Shipping_Contact_Last_Name__c = q.ShippingContact_LastName__c;
        c.Shipping_Contact_Phone__c = q.ShippingContact_Phone__c;
        c.Ship_To__c = q.Ship_To__c;
        c.ShipTo_BPID__c = q.ShipTo_BPID__c;
        c.ShipTo_City_Intl__c = q.ShipTo_City_Intl__c;
        c.ShipTo_Name__c = q.ShipTo_Name__c;
        c.ShipTo_Name_Intl__c = q.ShipTo_Name_Intl__c;
        c.ShipTo_State_Intl__c = q.ShipTo_State_Intl__c;
        c.ShipTo_Street_Intl__c = q.ShipTo_Street_Intl__c;
        c.ShipTo_Street2_Intl__c = q.ShipTo_Street2_Intl__c;
        c.Ship_To_City__c = q.ShipTo_City__c;
        c.Ship_To_Country__c = q.ShipTo_Country__c;
        c.Ship_To_PostalCode__c = q.ShipTo_PostalCode__c;
        c.Ship_To_State__c = q.ShipTo_State__c;
        c.Ship_To_Street__c = q.ShipTo_Street__c;
        c.Ship_To_Street2__c = q.ShipTo_Street2__c;
        c.Sold_To_Address_Lcl__c = q.Sold_To_Address_Lcl__c;
        c.Sold_To__c = q.Sold_To__c;
        c.SoldTo_BPID__c = q.SoldTo_BPID__c;
        c.SoldTo_City_Intl__c = q.SoldTo_City_Intl__c;
        c.SoldTo_Name_Intl__c = q.SoldTo_Name_Intl__c;
        c.SoldTo_State_Intl__c = q.SoldTo_State_Intl__c;
        c.SoldTo_Street_Intl__c = q.SoldTo_Street_Intl__c;
        c.SoldTo_Street2_Intl__c = q.SoldTo_Street2_Intl__c;
        c.Sold_To_City__c = q.SoldTo_City__c;
        c.Sold_To_Country__c = q.SoldTo_Country__c;
        c.Sold_To_Name__c = q.SoldTo_Name__c;
        c.Sold_To_PostalCode__c = q.SoldTo_PostalCode__c;
        c.Sold_To_State__c = q.SoldTo_State__c; 
        c.Sold_To_Street__c = q.SoldTo_Street__c;
        c.Sold_To_Street2__c = q.SoldTo_Street2__c;
        c.Technical_Contact__c = q.TechnicalContact_ID__c;
        c.Technical_Contact_Email__c = q.TechnicalContact_Email__c;
        c.Technical_Contact_First_Name__c = q.TechnicalContact_FirstName__c;
        c.Technical_Contact_Intl_First_Name__c = q.TechnicalContact_IntlFName__c;
        c.Technical_Contact_Intl_Last_Name__c = q.TechnicalContact_IntlLName__c;
        c.Technical_Contact_Last_Name__c = q.TechnicalContact_LastName__c;
        c.Technical_Contact_Phone__c = q.TechnicalContact_Phone__c;
        c.Booking_Country__c = q.Booking_Country__c;
        c.Sales_Organization__c = q.Sales_Organization__c;
        c.Company_Code__c = q.Company_Code__c;
        c.Company_Registration_Number__c=q.Company_Registration_Number__c;
        
        //populating Partner Site Details to Contract from quote - BAJPI01
        c.EndUser_Contact_Email__c = q.EndUser_Contact_Email__c;
        c.EndUser_Contact_First_Name__c = q.EndUser_Contact_First_Name__c;
        c.EndUser_Contact_ID__c = q.EndUser_Contact_ID__c;
        c.EndUser_Contact_Intl_First_Name__c = q.EndUser_Contact_Intl_First_Name__c;
        c.EndUser_Contact_Intl_Last_Name__c = q.EndUser_Contact_Intl_Last_Name__c;
        c.EndUser_Contact_Last_Name__c = q.EndUser_Contact_Last_Name__c;
        c.EndUser_Contact_Phone__c = q.EndUser_Contact_Phone__c;        
        c.EndUser_City__c = q.EndUser_City__c;
        c.EndUser_City_Intl__c = q.EndUser_City_Intl__c;
        c.EndUser_Country__c = q.EndUser_Country__c;
        c.EndUser_BPID__c = q.EndUser_BPID__c;
        c.EndUser_ID__c = q.EndUser_ID__c;
        c.EndUser_Name__c = q.EndUser_Name__c;
        c.EndUser_Name_Intl__c = q.EndUser_Name_Intl__c;
        c.EndUser_Postal_Code__c = q.EndUser_Postal_Code__c;
        c.EndUser_State__c = q.EndUser_State__c;
        c.EndUser_State_Intl__c = q.EndUser_State_Intl__c;
        c.EndUser_Street__c = q.EndUser_Street__c;
        c.EndUser_Street2__c = q.EndUser_Street2__c;
        c.EndUser_Street2_Intl__c = q.EndUser_Street2_Intl__c;
        c.EndUser_Street_Intl__c = q.EndUser_Street_Intl__c;        
        c.Reseller_City__c = q.Reseller_City__c;
        c.Reseller_City_Intl__c = q.Reseller_City_Intl__c;
        c.Reseller_Country__c = q.Reseller_Country__c;
        c.Reseller_BPID__c = q.Reseller_BPID__c;
        c.Reseller_ID__c = q.Reseller_ID__c;
        c.Reseller_Name__c = q.Reseller_Name__c;
        c.Reseller_Name_Intl__c = q.Reseller_Name_Intl__c;
        c.Reseller_Postal_Code__c = q.Reseller_Postal_Code__c;
        c.Reseller_State__c = q.Reseller_State__c;
        c.Reseller_State_Intl__c = q.Reseller_State_Intl__c;
        c.Reseller_Street__c = q.Reseller_Street__c;
        c.Reseller_Street2__c = q.Reseller_Street2__c;
        c.Reseller_Street2_Intl__c = q.Reseller_Street2_Intl__c;
        c.Reseller_Street_Intl__c = q.Reseller_Street_Intl__c;
        //c.Partner_Engagement__c = q.Partner_Engagement__c;
        //populating Partner Site Details to Contract from quote - BAJPI01
        
        c.Reseller__c = q.Partner1__c;
        c.Route__c = q.SBQQ__Opportunity2__r.Route__c;
        //c.Deal_Registration_Status__c = q.Deal_Registration_Status__c;

    }

    
    
}