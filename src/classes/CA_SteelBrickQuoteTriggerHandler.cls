public class CA_SteelBrickQuoteTriggerHandler {
    
     public static void updateQuoteDataonAgreement(Map<Id,SBQQ__Quote__c> newMap, Map<Id,SBQQ__Quote__c> oldMap) {
         try {
            system.debug('Update Sterling Quote Trigger Handler');
            Map<Id,SBQQ__Quote__c> mapIdvsQuote = new Map<Id,SBQQ__Quote__c>();
            
            for(SBQQ__Quote__c q : newMap.values()) {
                mapIdvsQuote.put(q.Id,q);
            }
             List<Apttus__APTS_Agreement__c> agrList = [Select Id, CurrencyIsoCode, CA_Geo__c, CA_Operating_Area__c, CA_Sales_Region__c, CA_Sales_Territory__c, CA_Sold_To_Id__c, CA_Account_Name__c, CA_Customer_Name_Lcl__c, CA_Street__c, CA_City__c, CA_State__c, CA_Zip_Code__c, CA_Country__c, CA_Street_Lcl__c, CA_City_Lcl__c, CA_State_Lcl__c, CA_Country_Lcl__c, CA_Bill_To_Id__c, CA_Billing_Contact_Name__c, CA_Billing_Contact_Name_Lcl__c, CA_Bill_To_Name__c, CA_Bill_To_Name_Lcl__c, CA_Bill_To_Street__c, Bill_To_City__c, CA_Bill_To_State__c, Bill_To_Zipcode__c, Bill_To_Country__c, Bill_To_Street_Lcl__c, Bill_To_City_Lcl__c, CA_Bill_To_State_Lcl__c, CA_Bill_To_Country_Lcl__c, CA_Ship_To_Id__c, CA_Ship_To_Name__c, CA_Ship_To_Name_Lcl__c, CA_Shipping_Contact_Name__c, CA_Shipping_Contact_Name_Lcl__c, CA_Ship_To_Street__c, CA_Ship_To_City__c, Ship_To_State__c, CA_Ship_To_Zipcode__c, Ship_To_Country__c, CA_Ship_To_Street_Lcl__c, Ship_To_City_Lcl__c, Ship_To_State_Lcl__c, CA_Ship_To_Country_Lcl__c, CA_Reseller_Id__c, CA_Reseller_Name__c, CA_Reseller_Name_Lcl__c, CA_Reseller_Street__c, CA_Reseller_City__c, CA_Reseller_State__c, CA_Reseller_Zipcode__c, CA_Reseller_Country__c, CA_Reseller_Street_Lcl__c, CA_Reseller_City_Lcl__c, CA_Reseller_State_Lcl__c, CA_Reseller_Country_Lcl__c, CA_Distributor_Id__c, CA_Distributor_Name__c, CA_Distributor_Name_Lcl__c, CA_Distributor_Street__c, CA_Distributor_City__c, CA_Distributor_State__c, Distributor_Zipcode__c, CA_Distributor_Country__c, CA_Distributor_Street_Lcl__c, CA_Distributor_City_Lcl__c, CA_Distributor_State_Lcl__c, CA_Distributor_Country_Lcl__c, CA_End_User_Id__c, CA_End_User_Name__c, CA_End_User_Name_Lcl__c, CA_End_User_Contact_Name__c, CA_End_User_Contact_Name_Lcl__c, CA_End_User_Street__c, CA_End_User_City__c, CA_End_User_State__c, CA_End_User_Zipcode__c, CA_End_User_Country__c, CA_End_User_Street_Lcl__c, CA_End_User_City_Lcl__c, CA_End_User_State_Lcl__c, CA_End_User_Country_Lcl__c, CA_Outsourcer_Id__c, CA_Outsourcer_Name__c, CA_Technical_Contact_Name__c, CA_Technical_Contact_Name_Lcl__c, CA_Technical_Contact_Email_Address__c, CA_Technical_Contact_Phone__c, CA_Average_Bill_Rate__c, CA_Expense_Cost__c, CA_Expenses_Price__c, CA_GSA_Schedule_Used__c, CA_Labor_Cost__c, CA_Labor_Discount__c, CA_Labor_List__c, CA_Labor_PCM__c, CA_Labor_PCM_Percent__c, CA_Labor_Revenue__c, CA_SAP_Contract_Number__c, CA_SAP_Contract_Value__c, CA_Program_Number__c, CA_Services_Quote_Type__c, CA_Services_Transaction_Type__c, CA_Total_Cost__c, CA_Total_Hours__c, CA_Total_PCM__c, CA_Total_PCM_Percent__c, CA_Total_Quote_Value__c, Apttus__Contract_Start_Date__c, Apttus__Contract_End_Date__c, SF_Quote__c from Apttus__APTS_Agreement__c where SF_Quote__c IN: mapIdvsQuote.keySet() and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring)];
            
            List<Apttus__APTS_Agreement__c> updateAgrList = new List<Apttus__APTS_Agreement__c>();
             if(agrList.size() > 0) {
                for(Apttus__APTS_Agreement__c agr : agrList) {
                    if(mapIdvsQuote.containsKey(agr.SF_Quote__c)) {
                        SBQQ__Quote__c sbquote = mapIdvsQuote.get(agr.SF_Quote__c);
                          agr.CA_Geo__c=sbquote.Rpt_Region__c;
                            agr.CA_Sales_Region__c=sbquote.Rpt_Territory_Country__c;
                            agr.CA_Sales_Territory__c=sbquote.Rpt_Country__c;
                            agr.CA_Sold_To_Id__c = sbquote.SoldTo_BPID__c;
                            agr.CA_Account_Name__c=sbquote.SoldTo_Name__c;
                            agr.CA_Customer_Name_Lcl__c =sbquote.SoldTo_Name_Intl__c;
                            agr.CA_Technical_Contact_Name__c=String.isNotBlank(sbquote.TechnicalContact_FirstName__c) &&
                                String.isNotBlank(sbquote.TechnicalContact_LastName__c)?sbquote.TechnicalContact_FirstName__c+' '+
                                sbquote.TechnicalContact_LastName__c:String.isNotBlank(sbquote.TechnicalContact_LastName__c)?
                                sbquote.TechnicalContact_LastName__c:(String.isNotBlank(sbquote.TechnicalContact_LastName__c)?sbquote.TechnicalContact_LastName__c:'');
                           // if(sbquote.TechnicalContact_FirstName__c!=null && sbquote.TechnicalContact_LastName__c!=null)
                            //agr.CA_Technical_Contact_Name__c =sbquote.TechnicalContact_FirstName__c + sbquote.TechnicalContact_LastName__c;
                            agr.CA_Technical_Contact_Name_Lcl__c=String.isNotBlank(sbquote.TechnicalContact_IntlFName__c) &&
                                String.isNotBlank(sbquote.TechnicalContact_IntlLName__c)?sbquote.TechnicalContact_IntlFName__c+' '+
                                sbquote.TechnicalContact_IntlLName__c:String.isNotBlank(sbquote.TechnicalContact_IntlFName__c)?
                                sbquote.TechnicalContact_IntlFName__c:(String.isNotBlank(sbquote.TechnicalContact_IntlLName__c)?sbquote.TechnicalContact_IntlLName__c:'');
                            //        if(sbquote.TechnicalContact_IntlFName__c!=null && sbquote.TechnicalContact_IntlLName__c!=null)
                           // agr.CA_Technical_Contact_Name_Lcl__c =sbquote.TechnicalContact_IntlFName__c + sbquote.TechnicalContact_IntlLName__c;
                            agr.CA_Technical_Contact_Phone__c=sbquote.TechnicalContact_Phone__c;
                            system.debug('minus debug');
                            agr.CA_Technical_Contact_Email_Address__c=sbquote.TechnicalContact_Email__c;
                            agr.CA_Desc_of_Deal_Benefits_to_CA_Customer__c=sbquote.Deal_Description__c;
                            agr.Apttus__Contract_Start_Date__c=sbquote.SBQQ__StartDate__c;
                            agr.Apttus__Contract_End_Date__c=sbquote.End_Date_form__c;
                        //  agr.CA_Street__c =sbquote.Rpt_Region__c;
                            agr.CA_Street_Lcl__c =sbquote.Sold_To_Address_Lcl__c;
                            agr.CA_Bill_To_Id__c=sbquote.BillTo_BPID__c;
                            agr.CA_Billing_Contact_Name__c=String.isNotBlank(sbquote.BillingContact_FirstName__c) &&
                                String.isNotBlank(sbquote.BillingContact_LastName__c)?sbquote.BillingContact_FirstName__c+' '+
                                sbquote.BillingContact_LastName__c:String.isNotBlank(sbquote.BillingContact_FirstName__c)?
                                sbquote.BillingContact_FirstName__c:(String.isNotBlank(sbquote.BillingContact_LastName__c)?sbquote.BillingContact_LastName__c:'');
                          //  if(sbquote.BillingContact_FirstName__c!=null && sbquote.BillingContact_LastName__c!=null)
                           // agr.CA_Billing_Contact_Name__c =sbquote.BillingContact_FirstName__c + sbquote.BillingContact_LastName__c;
                           agr.CA_Billing_Contact_Name_Lcl__c=String.isNotBlank(sbquote.BillingContact_IntlFName__c) &&
                                String.isNotBlank(sbquote.BillingContact_IntlLName__c)?sbquote.BillingContact_IntlFName__c+' '+
                                sbquote.BillingContact_IntlLName__c:String.isNotBlank(sbquote.BillingContact_IntlFName__c)?
                                sbquote.BillingContact_IntlFName__c:(String.isNotBlank(sbquote.BillingContact_IntlLName__c)?sbquote.BillingContact_IntlLName__c:'');
                          //  if(sbquote.BillingContact_FirstName__c!=null && sbquote.BillingContact_LastName__c!=null)
                                  //  if(sbquote.BillingContact_IntlFName__c!=null && sbquote.BillingContact_IntlLName__c!=null)
                            //agr.CA_Billing_Contact_Name_Lcl__c =sbquote.BillingContact_IntlFName__c + sbquote.BillingContact_IntlLName__c;
                            agr.CA_Bill_To_Name__c =sbquote.BillTo_Name__c;
                            agr.CA_Bill_To_Name_Lcl__c =sbquote.BillTo_Name_Intl__c;
                            agr.CA_Bill_To_Email__c=sbquote.BillingContact_Email__c;
                            agr.CA_Bill_To_Phone__c =sbquote.BillingContact_Phone__c;
                      //    agr.CA_Bill_To_Street__c =sbquote.Rpt_Region__c;
                            agr.Bill_To_Street_Lcl__c=sbquote.Bill_To_Address_Lcl__c;
                            agr.CA_Ship_To_Id__c =sbquote.ShipTo_BPID__c;
                            system.debug('zero debug');
                            agr.CA_Ship_To_Name__c =sbquote.ShipTo_Name__c;
                            agr.CA_Ship_To_Name_Lcl__c =sbquote.ShipTo_Name_Intl__c;
                            agr.CA_Shipping_Contact_Name__c=String.isNotBlank(sbquote.ShippingContact_FirstName__c) &&
                                String.isNotBlank(sbquote.ShippingContact_LastName__c)?sbquote.ShippingContact_FirstName__c+' '+
                                sbquote.ShippingContact_LastName__c:String.isNotBlank(sbquote.ShippingContact_FirstName__c)?
                                sbquote.ShippingContact_FirstName__c:(String.isNotBlank(sbquote.ShippingContact_LastName__c)?sbquote.ShippingContact_LastName__c:'');
                            //if(sbquote.ShippingContact_FirstName__c!=null && sbquote.ShippingContact_LastName__c!=null)
                            //agr.CA_Shipping_Contact_Name__c =sbquote.ShippingContact_FirstName__c +' ' + sbquote.ShippingContact_LastName__c;
                            
                                  //  else if(sbquote.ShippingContact_FirstName__c!=null)
                              //agr.CA_Shipping_Contact_Name__c =sbquote.ShippingContact_FirstName__c;
                            //else if(sbquote.ShippingContact_LastName__c!=null)
                              // agr.CA_Shipping_Contact_Name__c =sbquote.ShippingContact_LastName__c; 
                            agr.CA_Shipping_Contact_Name_Lcl__c=String.isNotBlank(sbquote.ShippingContact_IntlFName__c) &&
                                String.isNotBlank(sbquote.ShippingContact_IntlLName__c)?sbquote.ShippingContact_IntlFName__c+' '+
                                sbquote.ShippingContact_IntlLName__c:String.isNotBlank(sbquote.ShippingContact_IntlFName__c)?
                                sbquote.ShippingContact_IntlFName__c:(String.isNotBlank(sbquote.ShippingContact_IntlLName__c)?sbquote.ShippingContact_IntlLName__c:'');
                         //if(sbquote.ShippingContact_IntlFName__c !=null && sbquote.ShippingContact_IntlLName__c!=null)
                          //  agr.CA_Shipping_Contact_Name_Lcl__c =sbquote.ShippingContact_IntlFName__c +' ' + sbquote.ShippingContact_IntlLName__c;
                            
                      //      agr.CA_Ship_To_Street__c =sbquote.Rpt_Region__c; 
                            agr.CA_Ship_To_Street_Lcl__c =sbquote.Ship_To_Address_Lcl__c;
                             agr.Bill_To_City__c    = sbquote.BillTo_City__c;
				 agr.Bill_To_City_Lcl__c  = sbquote.BillTo_City_Intl__c;
				 agr.Bill_To_Country__c  = sbquote.BillTo_Country__c;
				 agr.CA_Bill_To_State__c  = sbquote.BillTo_State__c;
				 agr.CA_Bill_To_State_Lcl__c  = sbquote.BillTo_State_Intl__c;
                            system.debug('first debug');
                        //if(SBQuote.BillTo_Street__c ! =null && SBQuote.BillTo_Street2__c ! =null)
                  agr.CA_Bill_To_Street__c=String.isNotBlank(sbquote.BillTo_Street__c) &&
                                String.isNotBlank(sbquote.BillTo_Street2__c)?sbquote.BillTo_Street__c+' '+
                                sbquote.BillTo_Street2__c:String.isNotBlank(sbquote.BillTo_Street__c)?
                                sbquote.BillTo_Street__c:(String.isNotBlank(sbquote.BillTo_Street2__c)?sbquote.BillTo_Street2__c:'');
				//if(sbquote.BillTo_Street__c!=null && sbquote.BillTo_Street2__c!=null)
                  //      agr.CA_Bill_To_Street__c  = sbquote.BillTo_Street__c+sbquote.BillTo_Street2__c;
                    //        else if(sbquote.BillTo_Street__c!=null)
                      //        agr.CA_Bill_To_Street__c =  sbquote.BillTo_Street__c;
                        //     else if(sbquote.BillTo_Street2__c!=null)
                          //  agr.CA_Bill_To_Street__c =  sbquote.BillTo_Street2__c;
                          agr.Bill_To_Street_Lcl__c=String.isNotBlank(sbquote.BillTo_Street_Intl__c) &&
                                String.isNotBlank(sbquote.BillTo_Street2_Intl__c)?sbquote.BillTo_Street_Intl__c+' '+
                                sbquote.BillTo_Street2__c:String.isNotBlank(sbquote.BillTo_Street_Intl__c)?
                                sbquote.BillTo_Street_Intl__c:(String.isNotBlank(sbquote.BillTo_Street2_Intl__c)?sbquote.BillTo_Street2_Intl__c:'');
                       // if(sbquote.BillTo_Street_Intl__c !=null && sbquote.BillTo_Street2_Intl__c !=null)
				 //agr.Bill_To_Street_Lcl__c  = sbquote.BillTo_Street_Intl__c+' '+sbquote.BillTo_Street2_Intl__c;
                            agr.Bill_To_Zipcode__c =  sbquote.BillTo_PostalCode__c;
                            system.debug('second debug');
				 agr.CA_Ship_To_City__c  = sbquote.ShipTo_City__c;
                            system.debug('debug ---  sbquote.ShipTo_City__c ' + sbquote.ShipTo_City__c);
                            system.debug('debug ---  CA_Ship_To_City__c ' + agr.CA_Ship_To_City__c);
				 agr.Ship_To_City_Lcl__c  = sbquote.ShipTo_City_Intl__c;
				 agr.Ship_To_Country__c  = sbquote.ShipTo_Country__c;
				 agr.Ship_To_State__c  = sbquote.ShipTo_State__c;
				 agr.Ship_To_State_Lcl__c  = sbquote.ShipTo_State_Intl__c;
                            agr.CA_Ship_To_Street__c=String.isNotBlank(sbquote.ShipTo_Street__c) &&
                                String.isNotBlank(sbquote.ShipTo_Street2__c)?sbquote.ShipTo_Street__c+' '+
                                sbquote.ShipTo_Street2__c:String.isNotBlank(sbquote.ShipTo_Street__c)?
                                sbquote.ShipTo_Street__c:(String.isNotBlank(sbquote.ShipTo_Street2__c)?sbquote.ShipTo_Street2__c:'');
                       // if(sbquote.ShipTo_Street__c!=null && sbquote.ShipTo_Street2__c!=null)
				 //agr.CA_Ship_To_Street__c  = sbquote.ShipTo_Street__c+sbquote.ShipTo_Street2__c;
                        agr.CA_Ship_To_Street_Lcl__c=String.isNotBlank(sbquote.ShipTo_Street_Intl__c) &&
                                String.isNotBlank(sbquote.ShipTo_Street2_Intl__c)?sbquote.ShipTo_Street_Intl__c+' '+
                                sbquote.ShipTo_Street2_Intl__c:String.isNotBlank(sbquote.ShipTo_Street_Intl__c)?
                                sbquote.ShipTo_Street_Intl__c:(String.isNotBlank(sbquote.ShipTo_Street2_Intl__c)?sbquote.ShipTo_Street2_Intl__c:'');     
			//	 agr.CA_Ship_To_Street_Lcl__c  = sbquote.ShipTo_Street_Intl__c+SBQuote.ShipTo_Street2_Intl__c;
				 agr.CA_Ship_To_Zipcode__c  = sbquote.ShipTo_PostalCode__c;
                           agr.CA_Street__c=String.isNotBlank(sbquote.SoldTo_Street__c) &&
                                String.isNotBlank(sbquote.SoldTo_Street2__c)?sbquote.SoldTo_Street__c+' '+
                                sbquote.SoldTo_Street2__c:String.isNotBlank(sbquote.SoldTo_Street__c)?
                                sbquote.SoldTo_Street__c:(String.isNotBlank(sbquote.SoldTo_Street2__c)?sbquote.SoldTo_Street2__c:'');
                       //  if(sbquote.SoldTo_Street__c!=null && sbquote.SoldTo_Street2__c!=null)
				 // agr.CA_Street__c  = sbquote.SoldTo_Street__c+sbquote.SoldTo_Street2__c;
				  agr.CA_Street_Lcl__c=String.isNotBlank(sbquote.SoldTo_Street_Intl__c) &&
                                String.isNotBlank(sbquote.SoldTo_Street2_Intl__c)?sbquote.SoldTo_Street_Intl__c+' '+
                                sbquote.ShipTo_Street2_Intl__c:String.isNotBlank(sbquote.SoldTo_Street_Intl__c)?
                                sbquote.SoldTo_Street_Intl__c:(String.isNotBlank(sbquote.ShipTo_Street2_Intl__c)?sbquote.ShipTo_Street2_Intl__c:'');
                      //  if(sbquote.SoldTo_Street_Intl__c!=null && sbquote.SoldTo_Street2_Intl__c!=null)
				 //agr.CA_Street_Lcl__c  = sbquote.SoldTo_Street_Intl__c+sbquote.SoldTo_Street2_Intl__c;
				 agr.CA_City__c  = sbquote.SoldTo_City__c;
				 agr.CA_City_Lcl__c  = sbquote.SoldTo_City_Intl__c;
				 agr.CA_State__c = sbquote.SoldTo_State__c;
				 agr.CA_State_Lcl__c = sbquote.SoldTo_State_Intl__c;
				 agr.CA_Country__c = sbquote.SoldTo_Country__c;
				 agr.CA_Zip_Code__c = sbquote.SoldTo_PostalCode__c;
                 //	US496449 changes
                        agr.CA_Reseller_City__c=sbquote.Reseller_City__c;
                        agr.CA_Reseller_City_Lcl__c=sbquote.Reseller_City_Intl__c;
                        agr.CA_Reseller_Country__c=sbquote.Reseller_Country__c;
                        agr.CA_Reseller_Id__c=sbquote.Reseller_BPID__c;
                        agr.CA_Reseller_Name__c=sbquote.Reseller_Name__c;
                        agr.CA_Reseller_Name_Lcl__c=sbquote.Reseller_Name_Intl__c;
                        agr.CA_Reseller_Zipcode__c=sbquote.Reseller_Postal_Code__c;
                        agr.CA_Reseller_State__c=sbquote.Reseller_State__c;
                        agr.CA_Reseller_State_Lcl__c=sbquote.Reseller_State_Intl__c;
                        agr.CA_Reseller_Street__c=sbquote.Reseller_Street__c;
                       // agr.CA_Reseller_City__c=sbquote.Reseller_Street2__c;
                        //agr.CA_Reseller_City__c=sbquote.Reseller_Street2_Intl__c;
                        agr.CA_Reseller_Street_Lcl__c=sbquote.Reseller_Street_Intl__c;
                        agr.EndUserEmailAddress__c=sbquote.EndUser_Contact_Email__c;
                        if(sbquote.EndUser_Contact_First_Name__c !=null && sbquote.EndUser_Contact_Last_Name__c!=null)
                        agr.CA_End_User_Contact_Name__c=sbquote.EndUser_Contact_First_Name__c + ' '+ sbquote.EndUser_Contact_Last_Name__c;
                        //agr.CA_Reseller_City__c=sbquote.EndUser_Contact_Last_Name__c;
                        agr.CA_End_User_Id__c=sbquote.EndUser_Contact_ID__c;//
                        if(sbquote.EndUser_Contact_Intl_First_Name__c !=null && sbquote.EndUser_Contact_Intl_Last_Name__c!=null)
                        agr.CA_End_User_Contact_Name_Lcl__c=sbquote.EndUser_Contact_Intl_First_Name__c + ' ' +sbquote.EndUser_Contact_Intl_Last_Name__c;
                        //agr.CA_Reseller_City__c=sbquote.EndUser_Contact_Intl_Last_Name__c;
                        agr.EndUserContactPhone__c=sbquote.EndUser_Contact_Phone__c;
                        agr.CA_End_User_Country__c=sbquote.EndUser_Country__c;
                        agr.CA_End_User_City__c=sbquote.EndUser_City__c;
                        agr.CA_End_User_City_Lcl__c=sbquote.EndUser_City_Intl__c;
                        agr.CA_End_User_Id__c=sbquote.EndUser_BPID__c;//
                        agr.CA_End_User_Name__c=sbquote.EndUser_Name__c;
                        agr.CA_End_User_Name_Lcl__c=sbquote.EndUser_Name_Intl__c;
                        agr.CA_End_User_Zipcode__c=sbquote.EndUser_Postal_Code__c;
                        agr.CA_End_User_State__c=sbquote.EndUser_State__c;
                        agr.CA_End_User_State_Lcl__c=sbquote.EndUser_State_Intl__c;
                        agr.CA_End_User_Street__c=sbquote.EndUser_Street__c;
                       // agr.CA_Reseller_City__c=sbquote.EndUser_Street2__c;
                       // agr.CA_Reseller_City__c=sbquote.EndUser_Street2_Intl__c;
                        agr.CA_End_User_Street_Lcl__c=sbquote.EndUser_Street_Intl__c;
                        //agr.CA_Reseller_City__c=sbquote.Reseller_Street2_Intl__c;
                        
                        // change end
                    }
                     updateAgrList.add(agr);
                }
             }
              if(updateAgrList.size() > 0)
                update updateAgrList;

}
         catch(Exception e) {
            system.debug('Error Message::::'+e.getMessage());
        }
         
     }
}