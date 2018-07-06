public with sharing class CZQuoteInterfaceUtility {
    public static Opportunity copyOpportunityInformation(CZQILookupHelper lookupHelper, Opportunity opp, Input_Quote_Header__c header) {
        if (!String.isBlank(header.Quote_Number__c)) {
            opp.Quote_Number__c = header.Quote_Number__c;
        } else {
            throw new CZQuoteInterfaceException('Quote Number is required.');
        }

        if (!String.isBlank(header.AccountId__c)) {
            opp.AccountId = header.AccountId__c;
        } else {
            if (!String.isBlank(header.SoldTo_BPID__c)) {
                Account soldToAccount = lookupHelper.getAccount(header.SoldTo_BPID__c);
                
                if (soldToAccount != null) {
                    opp.AccountId = soldToAccount.Id;
                } else {
                    throw new CZQuoteInterfaceException('Account Id not provided and Sold To Account not found with site id ' + header.SoldTo_BPID__c + '.');
                }
            } else {
                throw new CZQuoteInterfaceException('Account Id and Sold To Account not provided.');
            }
        }

        if (!String.isBlank(header.CloseDate__c)) {
            opp.CloseDate = Date.parse(header.CloseDate__c);
        }

        if (!String.isEmpty(header.StartDate__c)) {
            opp.Start_Date__c = Date.parse(header.StartDate__c);
        }
        
        if (!String.isBlank(header.CurrencyIsoCode__c)) {
            opp.CurrencyIsoCode = header.CurrencyIsoCode__c;
        }

        opp.Name = header.Name;

        if (!String.isBlank(header.Description__c)) {
            opp.Description = header.Description__c;
        }
        
        if (!String.isBlank(header.Opportunity_Type__c)) {
            opp.Type = header.Opportunity_Type__c;
        }
        
        if (!String.isBlank(header.Partner1__c)) {
            opp.Reseller__c = header.Partner1__c;
            //opp.PrimaryPartner4__c = header.Partner1__c;
        }
        
        if (!String.isBlank(header.Deal_Registration_Status__c)) {
            opp.Deal_Registration_Status__c = header.Deal_Registration_Status__c;
        }
        
        if (!String.isBlank(header.Partner_Engagement__c)) {
            opp.Partner_Engagement__c = header.Partner_Engagement__c;
        }
        
        return opp;
    }

    public static SBQQ__Quote__c copyQuoteInformation(CZQILookupHelper lookupHelper, SBQQ__Quote__c quote, Input_Quote_Header__c header) {

        quote.SAP_Quote_Number__c = header.Quote_Number__c;
        
        if (!String.isBlank(header.SoldTo_Country__c)) {
            SalesOrg__c soldToSalesOrg = SalesOrg__c.getInstance(header.SoldTo_Country__c);
            
            if (soldToSalesOrg != null) {
                quote.Company_Code__c = soldToSalesOrg.Company_Code__c;
                quote.Sales_Organization__c = soldToSalesOrg.Sales_Organization__c;
            }
        }

        //Copy technical contact detail over
        if (!String.isBlank(header.TechnicalContact_ID__c)) {
           quote.TechnicalContact_ID__c = header.TechnicalContact_ID__c;
        }
        if (!String.isBlank(header.TechnicalContact_Email__c)) {
            quote.TechnicalContact_Email__c = header.TechnicalContact_Email__c;
        }
        if (!String.isBlank(header.TechnicalContact_FirstName__c)) {
            quote.TechnicalContact_FirstName__c = header.TechnicalContact_FirstName__c;
        }
        if (!String.isBlank(header.TechnicalContact_LastName__c)) {
            quote.TechnicalContact_LastName__c = header.TechnicalContact_LastName__c;
        }
        if (!String.isBlank(header.TechnicalContact_Phone__c)) {
            quote.TechnicalContact_Phone__c = header.TechnicalContact_Phone__c;
        }
        if (!String.isBlank(header.TechnicalContact_Intl_FName__c)) {
            quote.TechnicalContact_IntlFName__c = header.TechnicalContact_Intl_FName__c;
        }
        if (!String.isBlank(header.TechnicalContact_Intl_LName__c)) {
            quote.TechnicalContact_IntlLName__c = header.TechnicalContact_Intl_LName__c;
        }

        //Copy billing contact detail over
        if (!String.isBlank(header.BillingContact_ID__c)) {
           quote.BillingContact_ID__c = header.BillingContact_ID__c;
        }
        if (!String.isBlank(header.BillingContact_Email__c)) {
            quote.BillingContact_Email__c = header.BillingContact_Email__c;
        }
        if (!String.isBlank(header.BillingContact_FirstName__c)) {
            quote.BillingContact_FirstName__c = header.BillingContact_FirstName__c;
        }
        if (!String.isBlank(header.BillingContact_LastName__c)) {
            quote.BillingContact_LastName__c = header.BillingContact_LastName__c;
        }
        if (!String.isBlank(header.BillingContact_Phone__c)) {
            quote.BillingContact_Phone__c = header.BillingContact_Phone__c;
        }
        if (!String.isBlank(header.BillingContact_IntlFName__c)) {
            quote.BillingContact_IntlFName__c = header.BillingContact_IntlFName__c;
        }
        if (!String.isBlank(header.BillingContact_IntlLName__c)) {
            quote.BillingContact_IntlLName__c = header.BillingContact_IntlLName__c;
        }

        //Copy shipping contact detail over
        if (!String.isBlank(header.ShippingContact_ID__c)) {
           quote.ShippingContact_ID__c = header.ShippingContact_ID__c;
        }
        if (!String.isBlank(header.ShippingContact_Email__c)) {
            quote.ShippingContact_Email__c = header.ShippingContact_Email__c;
        }
        if (!String.isBlank(header.ShippingContact_FirstName__c)) {
            quote.ShippingContact_FirstName__c = header.ShippingContact_FirstName__c;
        }
        if (!String.isBlank(header.ShippingContact_LastName__c)) {
            quote.ShippingContact_LastName__c = header.ShippingContact_LastName__c;
        }
        if (!String.isBlank(header.ShippingContact_Phone__c)) {
            quote.ShippingContact_Phone__c = header.ShippingContact_Phone__c;
        }
        if (!String.isBlank(header.ShippingContact_Intl_FName__c)) {
            quote.ShippingContact_IntlFName__c = header.ShippingContact_Intl_FName__c;
        }
        if (!String.isBlank(header.ShippingContact_Intl_LName__c)) {
            quote.ShippingContact_IntlLName__c = header.ShippingContact_Intl_LName__c;
        }

        //Copy EndUser contact detail over
        if (!String.isBlank(header.EndUserContact_ID__c)) {
           quote.EndUser_Contact_ID__c = header.EndUserContact_ID__c;
        }
        if (!String.isBlank(header.EndUserContact_Email__c)) {
            quote.EndUser_Contact_Email__c = header.EndUserContact_Email__c;
        }
        if (!String.isBlank(header.EndUserContact_FirstName__c)) {
            quote.EndUser_Contact_First_Name__c = header.EndUserContact_FirstName__c;
        }
        if (!String.isBlank(header.EndUserContact_LastName__c)) {
            quote.EndUser_Contact_Last_Name__c = header.EndUserContact_LastName__c;
        }
        if (!String.isBlank(header.EndUserContact_Phone__c)) {
            quote.EndUser_Contact_Phone__c = header.EndUserContact_Phone__c;
        }
        if (!String.isBlank(header.EndUserContact_IntlFName__c)) {
            quote.EndUser_Contact_Intl_First_Name__c = header.EndUserContact_IntlFName__c;
        }
        if (!String.isBlank(header.EndUserContact_IntlLName__c)) {
            quote.EndUser_Contact_Intl_Last_Name__c = header.EndUserContact_IntlLName__c;
        }

        //SoldTo address copy
        if (!String.isBlank(header.SoldTo_BPID__c)) {
            quote.SoldTo_BPID__c = header.SoldTo_BPID__c;
            Site_Association__c soldToSiteAssociation = lookupHelper.getSiteAssociation(header.SoldTo_BPID__c);
            
            if (soldToSiteAssociation != null) {
                quote.Sold_To__c = soldToSiteAssociation.Id;
            } else {
                throw new CZQuoteInterfaceException('Site Id was not found for SoldTo BPID ' + header.SoldTo_BPID__c + '.');
            }
        } else {
            throw new CZQuoteInterfaceException('Site Id was not provided for SoldTo BPID.');
        }

        if (!String.isEmpty(header.SoldTo_Name__c)) {
            quote.SoldTo_Name__c = header.SoldTo_Name__c;
        }
        if (!String.isEmpty(header.SoldTo_Name_Intl__c)) {
            quote.SoldTo_Name_Intl__c = header.SoldTo_Name_Intl__c;
        }
        if (!String.isEmpty(header.SoldTo_Street__c)) {
            quote.SoldTo_Street__c = header.SoldTo_Street__c;
        }
        if (!String.isEmpty(header.SoldTo_Street_Intl__c)) {
            quote.SoldTo_Street_Intl__c = header.SoldTo_Street_Intl__c;
        }
        if (!String.isEmpty(header.SoldTo_Street2__c)) {
            quote.SoldTo_Street2__c = header.SoldTo_Street2__c;
        }
        if (!String.isEmpty(header.SoldTo_Street2_Intl__c)) {
            quote.SoldTo_Street2_Intl__c = header.SoldTo_Street2_Intl__c;
        }
        if (!String.isEmpty(header.SoldTo_City__c)) {
            quote.SoldTo_City__c = header.SoldTo_City__c;
        }
        if (!String.isEmpty(header.SoldTo_City_Intl__c)) {
            quote.SoldTo_City_Intl__c = header.SoldTo_City_Intl__c;
        }
        if (!String.isEmpty(header.SoldTo_PostalCode__c)) {
            quote.SoldTo_PostalCode__c = header.SoldTo_PostalCode__c;
        }
        if (!String.isEmpty(header.SoldTo_State__c)) {
            quote.SoldTo_State__c = header.SoldTo_State__c;
        }
        if (!String.isEmpty(header.SoldTo_State_Intl__c)) {
            quote.SoldTo_State_Intl__c = header.SoldTo_State_Intl__c;
        }
        if (!String.isEmpty(header.SoldTo_Country__c)) {
            quote.SoldTo_Country__c = header.SoldTo_Country__c;
        }
        if (!String.isEmpty(header.SoldTo_Address_Lcl__c)) {
            quote.Sold_To_Address_Lcl__c = header.SoldTo_Address_Lcl__c;
        }

        //Reseller address copy
        if (!String.isEmpty(header.Reseller_BPID__c)) {
            quote.Reseller_BPID__c = header.Reseller_BPID__c;
        }
        if (!String.isEmpty(header.Reseller_Name__c)) {
            quote.Reseller_Name__c = header.Reseller_Name__c;
        }
        if (!String.isEmpty(header.Reseller_Name_Intl__c)) {
            quote.Reseller_Name_Intl__c = header.Reseller_Name_Intl__c;
        }
        if (!String.isEmpty(header.Reseller_Street__c)) {
            quote.Reseller_Street__c = header.Reseller_Street__c;
        }
        if (!String.isEmpty(header.Reseller_Street_Intl__c)) {
            quote.Reseller_Street_Intl__c = header.Reseller_Street_Intl__c;
        }
        if (!String.isEmpty(header.Reseller_Street2__c)) {
            quote.Reseller_Street2__c = header.Reseller_Street2__c;
        }
        if (!String.isEmpty(header.Reseller_Street2_Intl__c)) {
            quote.Reseller_Street2_Intl__c = header.Reseller_Street2_Intl__c;
        }
        if (!String.isEmpty(header.Reseller_City__c)) {
            quote.Reseller_City__c = header.Reseller_City__c;
        }
        if (!String.isEmpty(header.Reseller_City_Intl__c)) {
            quote.Reseller_City_Intl__c = header.Reseller_City_Intl__c;
        }
        if (!String.isEmpty(header.Reseller_PostalCode__c)) {
            quote.Reseller_Postal_Code__c = header.Reseller_PostalCode__c;
        }
        if (!String.isEmpty(header.Reseller_State__c)) {
            quote.Reseller_State__c = header.Reseller_State__c;
        }
        if (!String.isEmpty(header.Reseller_State_Intl__c)) {
            quote.Reseller_State_Intl__c = header.Reseller_State_Intl__c;
        }
        if (!String.isEmpty(header.Reseller_Country__c)) {
            quote.Reseller_Country__c = header.Reseller_Country__c;
        }
        //if (!String.isEmpty(header.Reseller_Address_Lcl__c)) {
            //quote.Reseller_Address_Lcl__c = header.Reseller_Address_Lcl__c;
        //}

        //BillTo address copy
        if (!String.isEmpty(header.BillTo_BPID__c)) {
            quote.BillTo_BPID__c = header.BillTo_BPID__c;
        }
        if (!String.isEmpty(header.BillTo_Name__c)) {
            quote.BillTo_Name__c = header.BillTo_Name__c;
        }
        if (!String.isEmpty(header.BillTo_Name_Intl__c)) {
            quote.BillTo_Name_Intl__c = header.BillTo_Name_Intl__c;
        }
        if (!String.isEmpty(header.BillTo_Street__c)) {
            quote.BillTo_Street__c = header.BillTo_Street__c;
        }
        if (!String.isEmpty(header.BillTo_Street_Intl__c)) {
            quote.BillTo_Street_Intl__c = header.BillTo_Street_Intl__c;
        }
        if (!String.isEmpty(header.BillTo_Street2__c)) {
            quote.BillTo_Street2__c = header.BillTo_Street2__c;
        }
        if (!String.isEmpty(header.BillTo_Street2_Intl__c)) {
            quote.BillTo_Street2_Intl__c = header.BillTo_Street2_Intl__c;
        }
        if (!String.isEmpty(header.BillTo_City__c)) {
            quote.BillTo_City__c = header.BillTo_City__c;
        }
        if (!String.isEmpty(header.BillTo_City_Intl__c)) {
            quote.BillTo_City_Intl__c = header.BillTo_City_Intl__c;
        }
        if (!String.isEmpty(header.BillTo_PostalCode__c)) {
            quote.BillTo_PostalCode__c = header.BillTo_PostalCode__c;
        }
        if (!String.isEmpty(header.BillTo_State__c)) {
            quote.BillTo_State__c = header.BillTo_State__c;
        }
        if (!String.isEmpty(header.BillTo_State_Intl__c)) {
            quote.BillTo_State_Intl__c = header.BillTo_State_Intl__c;
        }
        if (!String.isEmpty(header.BillTo_Country__c)) {
            quote.BillTo_Country__c = header.BillTo_Country__c;
        }
        if (!String.isEmpty(header.Bill_To_Address_Lcl__c)) {
            quote.Bill_To_Address_Lcl__c = header.Bill_To_Address_Lcl__c;
        }

        //ShipTo address copy
        if (!String.isBlank(header.ShipTo_BPID__c)) {
            quote.ShipTo_BPID__c = header.ShipTo_BPID__c;
            Site_Association__c shipToSiteAssociation = lookupHelper.getSiteAssociation(header.ShipTo_BPID__c);
            
            if (shipToSiteAssociation != null) {
                quote.Ship_To__c = shipToSiteAssociation.Id;
            } else {
                throw new CZQuoteInterfaceException('Site Id was not found for ShipTo BPID ' + header.ShipTo_BPID__c + '.');
            }
        } else {
            throw new CZQuoteInterfaceException('Site Id was not provided for ShipTo BPID.');
        }

        if (!String.isEmpty(header.ShipTo_Name__c)) {
            quote.ShipTo_Name__c = header.ShipTo_Name__c;
        }
        if (!String.isEmpty(header.ShipTo_Name_Intl__c)) {
            quote.ShipTo_Name_Intl__c = header.ShipTo_Name_Intl__c;
        }
        if (!String.isEmpty(header.ShipTo_Street__c)) {
            quote.ShipTo_Street__c = header.ShipTo_Street__c;
        }
        if (!String.isEmpty(header.ShipTo_Street_Intl__c)) {
            quote.ShipTo_Street_Intl__c = header.ShipTo_Street_Intl__c;
        }
        if (!String.isEmpty(header.ShipTo_Street2__c)) {
            quote.ShipTo_Street2__c = header.ShipTo_Street2__c;
        }
        if (!String.isEmpty(header.ShipTo_Street2_Intl__c)) {
            quote.ShipTo_Street2_Intl__c = header.ShipTo_Street2_Intl__c;
        }
        if (!String.isEmpty(header.ShipTo_City__c)) {
            quote.ShipTo_City__c = header.ShipTo_City__c;
        }
        if (!String.isEmpty(header.ShipTo_City_Intl__c)) {
            quote.ShipTo_City_Intl__c = header.ShipTo_City_Intl__c;
        }
        if (!String.isEmpty(header.ShipTo_PostalCode__c)) {
            quote.ShipTo_PostalCode__c = header.ShipTo_PostalCode__c;
        }
        if (!String.isEmpty(header.ShipTo_State__c)) {
            quote.ShipTo_State__c = header.ShipTo_State__c;
        }
        if (!String.isEmpty(header.ShipTo_State_Intl__c)) {
            quote.ShipTo_State_Intl__c = header.ShipTo_State_Intl__c;
        }
        if (!String.isEmpty(header.ShipTo_Country__c)) {
            quote.ShipTo_Country__c = header.ShipTo_Country__c;
        }
        if (!String.isEmpty(header.ShipTo_Address_Lcl__c)) {
            quote.Ship_To_Address_Lcl__c = header.ShipTo_Address_Lcl__c;
        }

        //EndUser address copy
        if (!String.isEmpty(header.EndUser_BPID__c)) {
            quote.EndUser_BPID__c = header.EndUser_BPID__c;
        }
        if (!String.isEmpty(header.EndUser_Name__c)) {
            quote.EndUser_Name__c = header.EndUser_Name__c;
        }
        if (!String.isEmpty(header.EndUser_Name_Intl__c)) {
            quote.EndUser_Name_Intl__c = header.EndUser_Name_Intl__c;
        }
        if (!String.isEmpty(header.EndUser_Street__c)) {
            quote.EndUser_Street__c = header.EndUser_Street__c;
        }
        if (!String.isEmpty(header.EndUser_Street_Intl__c)) {
            quote.EndUser_Street_Intl__c = header.EndUser_Street_Intl__c;
        }
        if (!String.isEmpty(header.EndUser_Street2__c)) {
            quote.EndUser_Street2__c = header.EndUser_Street2__c;
        }
        if (!String.isEmpty(header.EndUser_Street2_Intl__c)) {
            quote.EndUser_Street2_Intl__c = header.EndUser_Street2_Intl__c;
        }
        if (!String.isEmpty(header.EndUser_City__c)) {
            quote.EndUser_City__c = header.EndUser_City__c;
        }
        if (!String.isEmpty(header.EndUser_City_Intl__c)) {
            quote.EndUser_City_Intl__c = header.EndUser_City_Intl__c;
        }
        if (!String.isEmpty(header.EndUser_PostalCode__c)) {
            quote.EndUser_Postal_Code__c = header.EndUser_PostalCode__c;
        }
        if (!String.isEmpty(header.EndUser_State__c)) {
            quote.EndUser_State__c = header.EndUser_State__c;
        }
        if (!String.isEmpty(header.EndUser_State_Intl__c)) {
            quote.EndUser_State_Intl__c = header.EndUser_State_Intl__c;
        }
        if (!String.isEmpty(header.EndUser_Country__c)) {
            quote.EndUser_Country__c = header.EndUser_Country__c;
        }
        //if (!String.isEmpty(header.EndUser_Address_Lcl__c)) {
            //quote.EndUser_ = header.EndUser_Address_Lcl__c;
        //}

        //other quote information
        if (!String.isEmpty(header.Quote_Description__c)) {
            quote.Quote_Description__c = header.Quote_Description__c;
        }

        if (!String.isEmpty(header.Quote_Effective_Date__c)) {
            quote.Quote_Date_Effective_Date__c = Date.parse(header.Quote_Effective_Date__c);
        }

        if (!String.isEmpty(header.StartDate__c)) {
            quote.SBQQ__StartDate__c = Date.parse(header.StartDate__c);
            System.debug('SBQQ__StartDate__c: ' + quote.SBQQ__StartDate__c);
        }
        
        if (!String.isEmpty(header.Subscription_Term__c)) {
            quote.SBQQ__SubscriptionTerm__c = Integer.valueOf(header.Subscription_Term__c);
            System.debug('SBQQ__SubscriptionTerm__c: ' + quote.SBQQ__SubscriptionTerm__c);
        }
        
        if (!String.isEmpty(header.End_Date__c)) {
            quote.SBQQ__EndDate__c = Date.parse(header.End_Date__c);
            System.debug('SBQQ__EndDate__c: ' + quote.SBQQ__EndDate__c);
        }
        
        if (!String.isBlank(header.CurrencyIsoCode__c)) {
            quote.CurrencyIsoCode = header.CurrencyIsoCode__c;
        }
        
        if (header.Mixed_deal_incl_global_seat_count_prod__c != null) {
            quote.Mixed_deal_incl_global_seat_count_prod__c = header.Mixed_deal_incl_global_seat_count_prod__c;
        }
        
        return quote;
    }

    public static SBQQ__QuoteLine__c copyQuoteLineInformation(CZQILookupHelper lookupHelper, SBQQ__QuoteLine__c quoteline, Input_Quote_Line__c inputline) {
        if (!String.isBlank(inputline.Quote_Line_Number__c)) {
            quoteline.Quote_Line_Number_SAP__c = Integer.valueOf(inputline.Quote_Line_Number__c);
        }

        if (!String.isBlank(inputline.Product_Instance_Id__c)) {
	        quoteline.Instance_Id__c = inputline.Product_Instance_Id__c;
        }

        if (!String.isBlank(inputline.ProductCode__c)) {
            String authUseMode = CZQuoteInterfaceConstants.INSTANCE_AUTH_USE_MODE;

            if (!String.isBlank(inputline.Auth_Use_Mode__c)) {
                authUseMode = inputline.Auth_Use_Mode__c;
            } else {
                throw new CZQuoteInterfaceException('No auth use mode provided.');
            }

            String productCode = inputLine.ProductCode__c + ',' + authUseMode;
            Product2 product = lookupHelper.getProduct(productCode);

            if (product == null) {
                throw new CZQuoteInterfaceException('No products found for product code ' + inputline.ProductCode__c + ' and auth use mode ' + authUseMode);
            }

            quoteLine.SBQQ__Product__c = product.Id;
        } else {
            throw new CZQuoteInterfaceException('No product code provided.');
        }

        if (!String.isBlank(inputline.Auth_Use_Mode__c)) {
            quoteline.Auth_Use_Mode__c = inputline.Auth_Use_Mode__c;
        }
        if (!String.isBlank(inputline.Business_Type__c)) {
            quoteline.Business_Type__c = inputline.Business_Type__c;
        } else {
            quoteline.Business_Type__c = 'New';
        }
        if (!String.isBlank(inputline.Discount__c) && inputline.Discount__c != 'NULL') {
            quoteline.SBQQ__Discount__c = Double.valueOf(inputline.Discount__c);
        }
        if (!String.isBlank(inputline.Quantity__c) && inputline.Discount__c != 'NULL') {
            quoteline.SBQQ__Quantity__c = Double.valueOf(inputline.Quantity__c);
        }
        if (!String.isBlank(inputline.Reason_for_Disc__c)) {
            quoteline.Reason_for_Disc__c = inputline.Reason_for_Disc__c;
        }
        if (!String.isBlank(inputline.Competitor_name__c)) {
            quoteline.Competitor_name__c = inputline.Competitor_name__c;
        }
        if (!String.isBlank(inputline.Product_Discount_Reason__c)) {
            quoteline.Product_Discount_Reason__c = inputline.Product_Discount_Reason__c;
        }
        
        return quoteline;
    }

    public static List<Input_Quote_Header__c> getInputHeaders(Set<Id> ids) {
        return [SELECT Id, Quote_Number__c, Quote__c, StartDate__c, Opportunity_Id__c, CurrencyIsoCode__c, Status__c, Error_Reason__c from Input_Quote_Header__c where Id in : ids];
    }

    public static void setSuccess(Input_Quote_Header__c input) {
        input.Status__c = CZQuoteInterfaceConstants.SUCCESS_STATUS;
        input.Error_Reason__c = '';
    }

    public static void setSuccess(Input_Quote_Line__c input) {
        input.Status__c = CZQuoteInterfaceConstants.SUCCESS_STATUS;
        input.Error_Reason__c = '';
    }

    public static void setSuccess(List<Input_Quote_Line__c> lines) {
        for (Input_Quote_Line__c line : lines) {
            setSuccess(line);
        }
    }

    public static void setReadyForQuoteCalculation(Input_Quote_Header__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.QUOTE_CALCULATE_STATUS;
            input.Error_Reason__c = '';
        }
    }

    public static void setReadyForQuoteCalculation(Input_Quote_Line__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.QUOTE_CALCULATE_STATUS;
            input.Error_Reason__c = '';
        }
    }
    
    public static void setReadyForOppContracting(Input_Quote_Header__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.OPP_CONTRACT_STATUS;
            input.Error_Reason__c = '';
        }
    }

    public static void setReadyForOppContracting(Input_Quote_Line__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.OPP_CONTRACT_STATUS;
            input.Error_Reason__c = '';
        }
    }

    public static void setReadyForOppContracting(List<Input_Quote_Line__c> lines) {
        for (Input_Quote_Line__c line : lines) {
            setReadyForOppContracting(line);
        }
    }

    public static void setReadyForClosing(Input_Quote_Header__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.FINAL_PROCESS_STATUS;
            input.Error_Reason__c = '';
        }
    }

    public static void setReadyForClosing(Input_Quote_Line__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.FINAL_PROCESS_STATUS;
            input.Error_Reason__c = '';
        }
    }

    public static void setReadyForClosing(List<Input_Quote_Line__c> lines) {
        for (Input_Quote_Line__c line : lines) {
            setReadyForClosing(line);
        }
    }

    public static void setReadyForProcessing(Input_Quote_Header__c input) {
        if (input.Status__c != 99) {
            input.Status__c = CZQuoteInterfaceConstants.PROCESS_READY_STATUS;
            input.Error_Reason__c = '';
        }
    }

    public static void setFailure(String errorMessage, Input_Quote_Header__c input) {
        input.Status__c = CZQuoteInterfaceConstants.FAILURE_STATUS;
        input.Error_Reason__c = errorMessage;
        System.debug('we have an error: ' + errorMessage);
    }

    public static void setFailure(String errorMessage, Input_Quote_Line__c input) {
        input.Status__c = CZQuoteInterfaceConstants.FAILURE_STATUS;
        input.Error_Reason__c = errorMessage;
        System.debug('we have an error: ' + errorMessage);
    }

    public static void setFailure(String errorMessage, List<Input_Quote_Header__c> inputs) {
        if (inputs == null || inputs.isEmpty())
            return;

        for (Input_Quote_Header__c header : inputs) {
            setFailure(errorMessage, header);
        }
    }
    
    public static void setFailure(String errorMessage, List<Input_Quote_Line__c> inputs) {
        if (inputs == null || inputs.isEmpty())
            return;

        for (Input_Quote_Line__c line : inputs) {
            setFailure(errorMessage, line);
        }
    }

    public static String generateErrorMessage(Exception e) {
        String errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
        System.debug(errorMessage);

        return errorMessage;
    }

    public static String generateProductCode(Product2 product) {
        return product.ProductCode + ',' + product.Auth_Use_Mode__c;
    }
    
    public static String generateProductCode(Input_Quote_Line__c line) {
        String authUseMode = CZQuoteInterfaceConstants.INSTANCE_AUTH_USE_MODE;

        if (!String.isBlank(line.Auth_Use_Mode__c)) {
            authUseMode = line.Auth_Use_Mode__c;
        }

        return line.ProductCode__c + ',' + authUseMode;
    }
}