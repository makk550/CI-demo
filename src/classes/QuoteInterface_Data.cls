/* 
* Class as part of OnGoingSync_QuoteInterface
* fetches the Technical data from SAP, PID from External object,Customer details from MDM
* pushes the data into Input Quote Header, Input Quote Line objects
* Created By: merha02
*/

public class QuoteInterface_Data {
    
    public static Azure_MDM_Utility.AzureResponse SoldDetailsResult;
    public static Azure_MDM_Utility.AzureResponse BillDetailsResult;
    public static  Azure_MDM_Utility.AzureResponse ShipDetailsResult;
    
    public static Id getAllDetails(SAP_Quote_Utility.HeaderDetails QuoteHeader,List<SAP_Quote_Utility.Item> QuoteLines){
        
        String SoldToId = (QuoteHeader.SOLD_TO_ID).leftPad(10,'0');
        String BillToId = QuoteHeader.BILL_TO_ID.leftPad(10,'0');
        String ShipToId = QuoteHeader.SHIP_TO_ID.leftPad(10,'0');
       	String AccountId = QuoteHeader.CA_ACCOUNT_ID;
        String SalesOrg = QuoteHeader.SALES_ORG;
        String siteName = (QuoteHeader.SOLD_TO_NAME).substringBefore(' ');
        
        System.debug('-----in Quote Interface data-----'+SoldToId+'--'+BillToId+'--'+ShipToId+'--'+AccountId+'--'+SalesOrg+'--'+siteName);
        
        String OppCountryCode;
        if(String.isNotBlank(SalesOrg)){
            OppCountryCode = SalesOrg.substring(0, 1);
            if(OppCountryCode == 'JP')
                OppCountryCode = OppCountryCode;
            else
                OppCountryCode='';
        }
        	
        
        List<String> SoldToIds=new List<String>();
        SoldToIds.add(SoldToId);
       
        if(SoldToIds!=null && SoldToIds.size()>0)
        	SoldDetailsResult = Quote_MDMSiteSearchController.getSiteDetails('SOLDTO',AccountId,SoldToIds,siteName,'','',OppCountryCode);
        if(SoldToIds!=null && SoldToIds.size()>0)
        	BillDetailsResult = Quote_MDMSiteSearchController.getBusinessPartnersData(SoldToIds,'BILLTO','','',OppCountryCode,SalesOrg,'');
        if(SoldToIds!=null && SoldToIds.size()>0)
        	ShipDetailsResult = Quote_MDMSiteSearchController.getBusinessPartnersData(SoldToIds,'SHIPTO','','',OppCountryCode,SalesOrg,'');
        
        
        Id result = populateData(QuoteHeader,QuoteLines);
        
        if(result != null){
            return result;
        }
        
        return null;
        
    }
    
    public static String ConvertDateFormat(String givenDate){
        Date newDate = Date.valueOf(givenDate);
        Date myDate = Date.newInstance(newDate.year(),newDate.month(),newDate.day());
        return myDate.format();
        
    }
    public static Id populateData(SAP_Quote_Utility.HeaderDetails QuoteHeader,List<SAP_Quote_Utility.Item> QuoteLines){
        
        
        String description = 'SAP Contract = '+QuoteHeader.SALES_DOCUMENT+' Opportunity Number = '+QuoteHeader.OPP_NUMBER+' Sterling Quote = '+QuoteHeader.CPQ_QUOTE_NUMBER+' Created On = '+QuoteHeader.CREATED_ON+' Created By = '+QuoteHeader.CREATED_BY+' Contract Net Value = '+QuoteHeader.CONTRACT_NET_VALUE;
        String ContractNumber = QuoteHeader.SALES_DOCUMENT.substring(2);
        
        
        Input_Quote_Header__c newRec = new Input_Quote_Header__c();
        
        newRec.Name = ContractNumber;
        newRec.Quote_Number__c = ContractNumber;
        newRec.Description__c = description;
        if(QuoteHeader.CONTRACT_START_DATE !=null && QuoteHeader.CONTRACT_START_DATE !='0000-00-00'){
            newRec.CloseDate__c = ConvertDateFormat(QuoteHeader.CONTRACT_START_DATE);
        }
        else if(QuoteHeader.ACCEPTANCE_DATE_HEAD!=null && QuoteHeader.ACCEPTANCE_DATE_HEAD !='0000-00-00'){
            newRec.CloseDate__c = ConvertDateFormat(QuoteHeader.ACCEPTANCE_DATE_HEAD);
        }
        else{
        	newRec.CloseDate__c = ConvertDateFormat(QuoteHeader.CREATED_ON);
        }
     
            
        newRec.CurrencyIsoCode__c = QuoteHeader.DOC_CURRENCY;
        newRec.Quote_Description__c = ContractNumber;
       	newRec.CA_Account_Id__c = QuoteHeader.CA_ACCOUNT_ID;
        newRec.Opportunity_Number__c = QuoteHeader.OPP_NUMBER;        
        newRec.TechnicalContact_ID__c = QuoteHeader.TECHNICAL_CONTACT.replaceFirst('^0+','');
        newRec.TechnicalContact_FirstName__c = QuoteHeader.TECH_CONTACT_FISTNAME;
        newRec.TechnicalContact_LastName__c = QuoteHeader.TECH_CONTACT_LASTNAME;
        newRec.TechnicalContact_Phone__c = QuoteHeader.TECHNICAL_CONTACT_PHONE;
        newRec.TechnicalContact_Email__c = QuoteHeader.TECHNICAL_CONTACT_EMAIL;
        
        newRec.ShippingContact_ID__c = QuoteHeader.SHIPPING_CONTACT.replaceFirst('^0+','');
        newRec.ShippingContact_FirstName__c = QuoteHeader.SHIPPING_CONTACT_FISTNAME;
        newRec.ShippingContact_LastName__c = QuoteHeader.SHIPPING_CONTACT_LASTNAME;
        newRec.ShippingContact_Phone__c = QuoteHeader.SHIPPING_CONTACT_PHONE;
        newRec.ShippingContact_Email__c = QuoteHeader.SHIPPING_CONTACT_EMAIL;
        
        newRec.BillingContact_ID__c = QuoteHeader.BILLING_CONTACT.replaceFirst('^0+','');
        newRec.BillingContact_FirstName__c = QuoteHeader.BILLING_CONTACT_FISTNAME;
        newRec.BillingContact_LastName__c = QuoteHeader.BILLING_CONTACT_LASTNAME;
        newRec.BillingContact_Phone__c = QuoteHeader.BILLING_CONTACT_PHONE;
        newRec.BillingContact_Phone__c = QuoteHeader.BILLING_CONTACT_EMAIL;
        
        List<Azure_MDM_Utility.SOLDIdData> soldtoresults=SoldDetailsResult.SoldToList;
        List<Azure_MDM_Utility.SOLDIdData> billtoresults=BillDetailsResult.SoldToList;
        List<Azure_MDM_Utility.SOLDIdData> shiptoresults=ShipDetailsResult.SoldToList;
        
        Azure_MDM_Utility.SOLDIdData soldToDetails;
        Azure_MDM_Utility.SOLDIdData billToDetails;
        Azure_MDM_Utility.SOLDIdData shipToDetails;
        
        
        
            for(Azure_MDM_Utility.SOLDIdData siteId :soldtoresults){
            	if(QuoteHeader.SOLD_TO_ID.contains(siteId.SiteID))
					soldToDetails = siteId;
            }
            for(Azure_MDM_Utility.SOLDIdData siteId :billtoresults){
                if(QuoteHeader.BILL_TO_ID.contains(siteId.SiteID))
                	billToDetails = siteId;
            }
			for(Azure_MDM_Utility.SOLDIdData siteId :shiptoresults){
                if(QuoteHeader.SHIP_TO_ID.contains(siteId.SiteID))
                	shipToDetails = siteId;
            }
			
        System.debug('-------in populate data------'+soldToDetails+'---'+billToDetails+'---'+shipToDetails);
            if(billToDetails!=null){
                newRec.BillTo_BPID__c = billToDetails.SiteID;
                newRec.BillTo_Name__c = billToDetails.Name;
                newRec.BillTo_Street__c = billToDetails.Street;
                newRec.BillTo_Street2__c = billToDetails.Street2;
                newRec.BillTo_PostalCode__c = billToDetails.Pincode;
                newRec.BillTo_City__c = billToDetails.City;
                newRec.BillTo_State__c = billToDetails.State;
                newRec.BillTo_Country__c = billToDetails.Country;
                newRec.BillTo_Name_Intl__c = billToDetails.NameLocal;
                newRec.BillTo_Street_Intl__c = billToDetails.StreetLocal;
                newRec.BillTo_Street2_Intl__c = billToDetails.Street2Local;
                newRec.BillTo_City_Intl__c = billToDetails.CityLocal;
                newRec.BillTo_State_Intl__c = billToDetails.StateLocal;
            }
            if(soldToDetails!=null){
                newRec.SoldTo_BPID__c = soldToDetails.SiteID;
                newRec.SoldTo_Name__c = soldToDetails.Name;
                newRec.SoldTo_Street__c = soldToDetails.Street;
                newRec.SoldTo_Street2__c = soldToDetails.Street2;
                newRec.SoldTo_PostalCode__c = soldToDetails.Pincode;
                newRec.SoldTo_City__c = soldToDetails.City;
                newRec.SoldTo_State__c = soldToDetails.State;
                newRec.SoldTo_Country__c = soldToDetails.Country;
                newRec.SoldTo_Name_Intl__c = soldToDetails.NameLocal;
                newRec.SoldTo_Street_Intl__c = soldToDetails.StreetLocal;
                newRec.SoldTo_Street2_Intl__c = soldToDetails.Street2Local;
                newRec.SoldTo_City_Intl__c = soldToDetails.CityLocal;
                newRec.SoldTo_State_Intl__c = soldToDetails.StateLocal;
            }
            if(shipToDetails!=null){
                newRec.ShipTo_BPID__c = shipToDetails.SiteID;
                newRec.ShipTo_Name__c = shipToDetails.Name;
                newRec.ShipTo_Street__c = shipToDetails.Street;
                newRec.ShipTo_Street2__c = shipToDetails.Street2;
                newRec.ShipTo_PostalCode__c = shipToDetails.Pincode;
                newRec.ShipTo_City__c = shipToDetails.City;
                newRec.ShipTo_State__c = shipToDetails.State;
                newRec.ShipTo_Country__c = shipToDetails.Country;
                newRec.ShipTo_Name_Intl__c = shipToDetails.NameLocal;
                newRec.ShipTo_Street_Intl__c = shipToDetails.StreetLocal;
                newRec.ShipTo_Street2_Intl__c = shipToDetails.Street2Local;
                newRec.ShipTo_City_Intl__c = shipToDetails.CityLocal;
                newRec.ShipTo_State_Intl__c = shipToDetails.StateLocal;
            }
           
        
        
        
        // PID
        Map<String,String> MaterialPIDMap=new Map<String,String>();
        List<ProductInstanceView__x> PIDList=[SELECT product_instance_id__c,material_id__c FROM ProductInstanceView__x WHERE sap_contract_number__c =: QuoteHeader.SALES_DOCUMENT];
        
        if(PIDList!=null && PIDList.size()>0){
            System.debug('-----PIDList------'+PIDList);
            for(ProductInstanceView__x pid : PIDList){
            if(!MaterialPIDMap.containsKey(pid.material_id__c)){
                MaterialPIDMap.put(pid.material_id__c, pid.product_instance_id__c);
            }
        }
        }
        
        
        List<Input_Quote_Line__c> newQuoteLineItems=new List<Input_Quote_Line__c>();
        Date minimumDismDate;
        Integer maxTerm=0;
        Decimal maxMonthsDuration;
        Date StartDate;
        Date EndDate;
      	List<Date> startDateList=new List<Date>();
        
        for(SAP_Quote_Utility.Item q: QuoteLines){
            
            startDateList.add(Date.valueOf(q.DISMANTLING_DATE));
            if(maxTerm < Integer.valueOf(q.DURATION)){
                maxTerm = Integer.valueOf(q.DURATION);
                StartDate = Date.valueOf(q.INSTALLATION_DATE);
                EndDate = Date.valueOf(q.DISMANTLING_DATE)+1;
            }           
            Input_Quote_Line__c newLineItem = new Input_Quote_Line__c();
            
            newLineItem.Quote_Number__c = ContractNumber;
            newLineItem.Quote_Line_Number__c=q.ITEM;
            newLineItem.Product_Instance_Id__c = MaterialPIDMap.get(q.MATERIAL);
            newLineItem.Auth_Use_Mode__c = q.AUTHORIZATION_MODEL;
            newLineItem.Business_Type__c=q.CA_BUSTRANS_TYPE;
            newLineItem.Quantity__c=q.QUANTITY;
            newLineItem.ProductCode__c=q.MATERIAL;
            
            if(q.MAINTENANCE == 'M' && q.CPQ_LIST_PRICE!=0 && q.CPQ_LIST_PRICE == q.CPQ_LICENSE_DISCOUNT)
                newLineItem.Discount__c = String.valueOf(100);
            else if(q.MAINTENANCE == 'M' && q.CPQ_LICENSE_DISCOUNT == 0)
                newLineItem.Discount__c = String.valueOf(0);
            else if(q.MAINTENANCE == 'M' && q.CPQ_LIST_PRICE!=0)
                newLineItem.Discount__c = String.valueOf((100 - (q.CPQ_LICENSE_PRICE/q.CPQ_LIST_PRICE)*100).setScale(2));
            else if(q.MAINTENANCE == 'I' && q.CPQ_SUBSCRIPTION_DISCOUNT == 0)
                newLineItem.Discount__c = String.valueOf(0);
            else if( q.CPQ_LIST_PRICE!=0)
                newLineItem.Discount__c = String.valueOf((100 - (q.CPQ_SUBSCRIPTION_PRICE/q.CPQ_LIST_PRICE)*100).setScale(2));
            
            if(q.MAINTENANCE == 'M' && q.ZLMP == q.CPQ_MAINTENANCE_DISCOUNT)
                newLineItem.Maintenance_Discount__c = String.valueOf(100);
            else if(q.MAINTENANCE == 'I' && q.ZLMP == 0)
                newLineItem.Maintenance_Discount__c = String.valueOf(0);
            else if(q.ZLMP!=0)
                newLineItem.Maintenance_Discount__c = String.valueOf((100 - (q.CPQ_MAINTENANCE_PRICE/q.ZLMP)*100).setScale(2));
            
            
            newQuoteLineItems.add(newLineItem);
        }
        if(startDateList!=null && startDateList.size()>0){
            startDateList.sort();
            minimumDismDate = startDateList.get(0);
        }		
         maxMonthsDuration = ARRandDurationCalculation.monthsbetweendates(StartDate,EndDate);
        
        newRec.StartDate__c = ConvertDateFormat(String.valueOf((minimumDismDate - maxTerm)+1));
       	newRec.Subscription_Term__c = String.valueOf(maxMonthsDuration);
        
        // to flag mixed deal with AC product
            if(SAP_Quote_Utility.ContainsACprod){
				newRec.Mixed_deal_incl_global_seat_count_prod__c = true;
			  }
           
        try{
             System.debug('-----Quote Details--------'+newRec);
            System.debug('------newQuoteLineItems------'+newQuoteLineItems);
            insert newRec;
            insert newQuoteLineItems;
        }catch(Exception e){
            System.debug(e);
        }
        
        
        System.debug('------------record inserted------');
        return newRec.id;
        
    }
    
    
    
}