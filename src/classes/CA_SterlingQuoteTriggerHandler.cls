public class CA_SterlingQuoteTriggerHandler {

    public static void updateQuoteDataonAgreement(Map<Id,scpq__SciQuote__c> newMap, Map<Id,scpq__SciQuote__c> oldMap) {
        if(test.isRunningTest()) return;
       try {
            system.debug('Update Sterling Quote Trigger Handler');
            Map<Id,scpq__SciQuote__c> mapIdvsQuote = new Map<Id,scpq__SciQuote__c>();
             Boolean callWebServiceFlag = false;
            List<String> reqPayLoad = new List<String>();
            for(scpq__SciQuote__c q : newMap.values()){
                mapIdvsQuote.put(q.Id,q);
                system.debug('Oubound_Status__c : '+newMap.get(q.Id).Oubound_Status__c);
                system.debug('oldMap.get(q.Id).Oubound_Status__c : '+oldMap.get(q.Id).Oubound_Status__c);
                 system.debug('CA_CPQ_Quote_Status__c : '+newMap.get(q.Id).CA_CPQ_Quote_Status__c);
                 system.debug('CA_CPQ_Quote_Status__c : '+newMap.get(q.Id).CA_CPQ_Quote_Status__c);
                 system.debug('CA_CPQ_Quote_Status__c : '+newMap.get(q.Id).CA_CPQ_Quote_Status__c);
                if(String.isNotBlank(newMap.get(q.Id).Oubound_Status__c) && newMap.get(q.Id).Oubound_Status__c!=oldMap.get(q.Id).Oubound_Status__c && !newMap.get(q.Id).Oubound_Status__c.equalsIgnoreCase('DRAFT') && !newMap.get(q.Id).Oubound_Status__c.equalsIgnoreCase('REQUEST APPROVAL') && !newMap.get(q.Id).Oubound_Status__c.equalsIgnoreCase('SIGNED BY CUSTOMER')){
				    String xmlStructure = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ejb="http://ejb.rpc.webservices.services.interop.yantra.com/"><soapenv:Header/><soapenv:Body><ejb:updateCAWorkflowDetails><!--Optional:--><arg0>   &lt;Environment userId=&quot;cpqintegrationuser&quot; progId=&quot;EAI&quot;/&gt; </arg0><!--Optional:--><arg1>&lt;Order OrderNo=&quot;'+q.CA_CPQ_Quote_Number__c+'&quot; EnterpriseCode=&quot;CA&quot; EnteredBy=&quot;&quot;&gt;&lt;Extn ExtnCaQuoteStatus=&quot;'+q.Oubound_Status__c+'&quot; ExtnCaDdrName=&quot;'+q.CA_DDR_Name__c+'&quot;/&gt;&lt;/Order&gt;</arg1></ejb:updateCAWorkflowDetails></soapenv:Body></soapenv:Envelope>';
                    //String xmlStructure = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:yan="http://yantra.com/yantrawebservices"><soapenv:Header/><soapenv:Body><yan:updateCAWorkflowDetails><String_1><Environment userId="cpqintegrationuser" progId="EAI"/></String_1><String_2><Order OrderNo="'+q.CA_CPQ_Quote_Number__c+'" EnterpriseCode="CA" EnteredBy=""><Extn ExtnCaQuoteStatus="'+q.Oubound_Status__c+'" ExtnCaDdrName="'+q.CA_DDR_Name__c +'" SelectMethod="WAIT"/></Order></String_2></yan:updateCAWorkflowDetails></soapenv:Body></soapenv:Envelope>';
            
                    reqPayLoad.add(xmlStructure);
                    system.debug('callWebServiceFlag : '+callWebServiceFlag);
                    callWebServiceFlag = true;
                }
            }
            
            system.debug('mapIdvsQuote size:::'+mapIdvsQuote.size());
            system.debug('mapIdvsQuote :::'+mapIdvsQuote);
            List<Apttus__APTS_Agreement__c> agrList = [Select Id, CurrencyIsoCode, CA_Geo__c, CA_Operating_Area__c, CA_Sales_Region__c, CA_Sales_Territory__c, CA_Sold_To_Id__c, CA_Account_Name__c, CA_Customer_Name_Lcl__c, CA_Street__c, CA_City__c, CA_State__c, CA_Zip_Code__c, CA_Country__c, CA_Street_Lcl__c, CA_City_Lcl__c, CA_State_Lcl__c, CA_Country_Lcl__c, CA_Bill_To_Id__c, CA_Billing_Contact_Name__c, CA_Billing_Contact_Name_Lcl__c, CA_Bill_To_Name__c, CA_Bill_To_Name_Lcl__c, CA_Bill_To_Street__c, Bill_To_City__c, CA_Bill_To_State__c, Bill_To_Zipcode__c, Bill_To_Country__c, Bill_To_Street_Lcl__c, Bill_To_City_Lcl__c, CA_Bill_To_State_Lcl__c, CA_Bill_To_Country_Lcl__c, CA_Ship_To_Id__c, CA_Ship_To_Name__c, CA_Ship_To_Name_Lcl__c, CA_Shipping_Contact_Name__c, CA_Shipping_Contact_Name_Lcl__c, CA_Ship_To_Street__c, CA_Ship_To_City__c, Ship_To_State__c, CA_Ship_To_Zipcode__c, Ship_To_Country__c, CA_Ship_To_Street_Lcl__c, Ship_To_City_Lcl__c, Ship_To_State_Lcl__c, CA_Ship_To_Country_Lcl__c, CA_Reseller_Id__c, CA_Reseller_Name__c, CA_Reseller_Name_Lcl__c, CA_Reseller_Street__c, CA_Reseller_City__c, CA_Reseller_State__c, CA_Reseller_Zipcode__c, CA_Reseller_Country__c, CA_Reseller_Street_Lcl__c, CA_Reseller_City_Lcl__c, CA_Reseller_State_Lcl__c, CA_Reseller_Country_Lcl__c, CA_Distributor_Id__c, CA_Distributor_Name__c, CA_Distributor_Name_Lcl__c, CA_Distributor_Street__c, CA_Distributor_City__c, CA_Distributor_State__c, Distributor_Zipcode__c, CA_Distributor_Country__c, CA_Distributor_Street_Lcl__c, CA_Distributor_City_Lcl__c, CA_Distributor_State_Lcl__c, CA_Distributor_Country_Lcl__c, CA_End_User_Id__c, CA_End_User_Name__c, CA_End_User_Name_Lcl__c, CA_End_User_Contact_Name__c, CA_End_User_Contact_Name_Lcl__c, CA_End_User_Street__c, CA_End_User_City__c, CA_End_User_State__c, CA_End_User_Zipcode__c, CA_End_User_Country__c, CA_End_User_Street_Lcl__c, CA_End_User_City_Lcl__c, CA_End_User_State_Lcl__c, CA_End_User_Country_Lcl__c, CA_Outsourcer_Id__c, CA_Outsourcer_Name__c, CA_Technical_Contact_Name__c, CA_Technical_Contact_Name_Lcl__c, CA_Technical_Contact_Email_Address__c, CA_Technical_Contact_Phone__c, CA_Average_Bill_Rate__c, CA_Expense_Cost__c, CA_Expenses_Price__c, CA_GSA_Schedule_Used__c, CA_Labor_Cost__c, CA_Labor_Discount__c, CA_Labor_List__c, CA_Labor_PCM__c, CA_Labor_PCM_Percent__c, CA_Labor_Revenue__c, CA_SAP_Contract_Number__c, CA_SAP_Contract_Value__c, CA_Program_Number__c, CA_Services_Quote_Type__c, CA_Services_Transaction_Type__c, CA_Total_Cost__c, CA_Total_Hours__c, CA_Total_PCM__c, CA_Total_PCM_Percent__c, CA_Total_Quote_Value__c, Apttus__Contract_Start_Date__c, Apttus__Contract_End_Date__c, Sterling_Quote__c, CA_SAP_Quote_Number__c, CA_IS_DISC_FNC__c, CA_CREDIT_DISC_DESC__c,EndUserEmailAddress__c,EndUserContactPhone__c ,CA_ABN_Number__c from Apttus__APTS_Agreement__c where Sterling_Quote__c IN: mapIdvsQuote.keySet() and (Apttus__Status_Category__c =: Label.Request or Apttus__Status_Category__c =: Label.In_Authoring)];
            
            List<Apttus__APTS_Agreement__c> updateAgrList = new List<Apttus__APTS_Agreement__c>();
            
            system.debug('Agr List Size:::::'+agrList.size());
            
            if(agrList.size() > 0) {
                for(Apttus__APTS_Agreement__c agr : agrList) {
                    if(mapIdvsQuote.containsKey(agr.Sterling_Quote__c)) {
                        scpq__SciQuote__c sq = mapIdvsQuote.get(agr.Sterling_Quote__c);
                        system.debug('Geo::'+sq.Region__c+'--Operatin Area:::'+sq.CA_Sales_Area__c+'--Sales Region:::'+sq.Territory__c+'--Territory::::'+sq.Sub_Territory__c);
                        agr.CA_Geo__c = sq.Region__c;
                        agr.CA_Operating_Area__c = sq.SalesArea__c;
                        agr.CA_Sales_Region__c = sq.Territory__c;
                        agr.CA_Sales_Territory__c = sq.Sub_Territory__c;
                        agr.CA_Sold_To_Id__c = sq.CA_Sold_To_ID__c;
                        agr.CA_ABN_Number__c= sq.Company_Number__c;
                        agr.CA_Account_Name__c = sq.CA_Customer_Name_Sold_To__c;
                        agr.CA_Customer_Name_Lcl__c = sq.CA_Customer_Name_Sold_To_Lcl__c;
                        agr.CA_Technical_Contact_Name__c = sq.CA_Technical_Contact_Name__c;
                        agr.CA_Technical_Contact_Name_Lcl__c = sq.CA_Technical_Contact_Name_Lcl__c; 
                        agr.CA_Technical_Contact_Phone__c = sq.Technical_Contact_Phone__c;
                        agr.CA_Technical_Contact_Email_Address__c = sq.Technical_Contact_Email_Address__c;
                        agr.CA_Average_Bill_Rate__c = sq.Average_Bill_Rate__c;
                        agr.CA_Desc_of_Deal_Benefits_to_CA_Customer__c = sq.CA_Brief_Deal_Desc__c;
                        //agr.CA_Services_Total__c = sq.CA_Services_Total__c;
                        agr.CA_Expense_Cost__c = sq.Expense_Cost__c;
                        agr.CA_Expenses_Price__c = sq.Expenses_Price__c; 
                        agr.CA_GSA_Schedule_Used__c = sq.GSA_Schedule_Used__c;
                        agr.CA_Labor_Cost__c = sq.Labor_Cost__c;
                        agr.CA_Labor_Discount__c = sq.Labor_Discount__c;
                        agr.CA_Labor_List__c = sq.Labor_List__c;
                        agr.CA_Labor_PCM__c = sq.Labor_PCM__c;
                        agr.CA_Labor_PCM_Percent__c = sq.Labor_PCM_Percent__c;
                        agr.CA_Labor_Revenue__c =sq.Labor_Revenue__c;
                        agr.CA_SAP_Contract_Number__c = sq.SAP_Contract_Number__c;
                        agr.CA_SAP_Contract_Value__c = sq.SAP_Contract_Balance__c;
                        agr.CA_SAP_Quote_Number__c = sq.CA_SAP_Quote_Number__c;//Added by Umang for US312680
                        agr.CA_IS_DISC_FNC__c = sq.Discount_Due_To_Contractual_Credit_Oblig__c;
                        agr.CA_CREDIT_DISC_DESC__c = sq.Contract_Where_The_Credit_Exists__c;
                        agr.CA_Program_Number__c = sq.Program_Number__c;
                        agr.CA_Services_Quote_Type__c = sq.Service_Type__c;
                        //agr.CA_Services_Quote_Total__c = sq.Services_Quote_Total__c;
                        agr.CA_Services_Transaction_Type__c = sq.Transaction_Type__c;
                        agr.CA_Total_Cost__c = sq.Total_Cost__c;
                        agr.CA_Total_Hours__c = sq.Total_Hours__c;
                        agr.CA_Total_PCM__c = sq.Total_PCM__c;
                        agr.CA_Total_PCM_Percent__c = sq.Total_PCM_Percent__c;
                        agr.CA_Total_Quote_Value__c = sq.Total_Price__c;
                        agr.Apttus__Contract_Start_Date__c = sq.CA_Effective_Date__c;
                        agr.Apttus__Contract_End_Date__c = sq.CA_Contract_End_Date__c;
                        agr.CurrencyIsoCode = sq.CurrencyIsoCode;
                        
                        List<String> soldToAddress;
                        String streetAdd = '';
                        if(sq.Sold_To_Address__c != null)
                            soldToAddress = sq.Sold_To_Address__c.split(',');
                        
                        system.debug('Sold To Address:::'+soldToAddress);
                        if(soldToAddress != null) {
                            if(soldToAddress.size() >= 5) {
                                //agr.CA_Street__c = soldToAddress[soldToAddress.size()-5];
                                agr.CA_City__c = soldToAddress[soldToAddress.size()-4];
                                agr.CA_State__c = soldToAddress[soldToAddress.size()-3];
                                system.debug('Sold to zipcode:::'+soldToAddress[soldToAddress.size()-2]);
                                agr.CA_Zip_Code__c = soldToAddress[soldToAddress.size()-2];
                                system.debug('Zip code:::'+agr.CA_Zip_Code__c);
                                agr.CA_Country__c = soldToAddress[soldToAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=soldToAddress.size();i++){ 
                                  if(i<soldToAddress.size())                        
                                  streetAdd = ','+soldToAddress[soldToAddress.size()-i]+streetAdd ;
                                  if(i==soldToAddress.size())
                                  streetAdd = soldToAddress[soldToAddress.size()-i]+streetAdd ;                                
                                }
                                system.debug('Streeet....'+streetAdd);
                                agr.CA_Street__c = streetAdd;
                            }
                        } else {
                            agr.CA_Street__c = '';
                            agr.CA_City__c = '';
                            agr.CA_State__c = '';
                            agr.CA_Zip_Code__c = '';
                            agr.CA_Country__c = '';
                        }
                        List<String> soldToAddressLcl;
                        String soldToStreetLcl = '';
                        if(sq.Sold_To_Address_Lcl__c != null)
                            soldToAddressLcl = sq.Sold_To_Address_Lcl__c.split(',');
                        
                        if(soldToAddressLcl != null) {    
                            if(soldToAddressLcl.size() >= 5) {
                                system.debug('sq.Region__c: '+sq.Region__c );
                                system.debug('sq.SalesArea__c: '+sq.SalesArea__c );
                                system.debug('sq.Territory__c: '+sq.Territory__c);
                                system.debug('sq.Sub_Territory__c: '+sq.Sub_Territory__c );
                                //added for japanese address issue
                                if(sq.Region__c == Label.APJ && sq.SalesArea__c == Label.JAPAN &&
                                   sq.Territory__c== Label.JAPAN && sq.Sub_Territory__c == Label.JAPAN) {
                                    system.debug('jk:::');
                                    agr.CA_Country_Lcl__c = soldToAddressLcl[0];
                                    agr.CA_Zip_Code__c = soldToAddressLcl[1];
                                    agr.CA_State_Lcl__c = soldToAddressLcl[2];
                                    agr.CA_City_Lcl__c = soldToAddressLcl[3];
                                    //agr.CA_Street_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-1];
                                    for(Integer i=4; i<=soldToAddressLcl.size();i++){ 
                                      if(i<soldToAddressLcl.size())                        
                                          soldToStreetLcl = soldToStreetLcl+' '+soldToAddressLcl[i];
                                    }
                                    agr.CA_Street_Lcl__c = soldToStreetLcl;
                                } else {
                                    //agr.CA_Street_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-5];
                                    system.debug('jk1:::');
                                    agr.CA_City_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-4];
                                    agr.CA_State_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-3];
                                    agr.CA_Zip_Code__c = soldToAddressLcl[soldToAddressLcl.size()-2];
                                    agr.CA_Country_Lcl__c = soldToAddressLcl[soldToAddressLcl.size()-1];
                                        // Added as part of defect DE198544
                                    for(Integer i=5; i<=soldToAddressLcl.size();i++){ 
                                      if(i<soldToAddressLcl.size())                        
                                      soldToStreetLcl = ','+soldToAddressLcl[soldToAddressLcl.size()-i]+soldToStreetLcl ;
                                      if(i==soldToAddressLcl.size())
                                      soldToStreetLcl = soldToAddressLcl[soldToAddressLcl.size()-i]+soldToStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+soldToStreetLcl );
                                    agr.CA_Street_Lcl__c = soldToStreetLcl ;
                                    }
                            }  
                        } else {
                            agr.CA_Street_Lcl__c = '';
                            agr.CA_City_Lcl__c = '';
                            agr.CA_State_Lcl__c = '';
                            agr.CA_Country_Lcl__c = '';
                        } 
                        
                        agr.CA_Bill_To_Id__c = sq.CA_Bill_To_ID__c;
                        agr.CA_Billing_Contact_Name__c = sq.CA_Billing_Contact_Name__c;
                        agr.CA_Billing_Contact_Name_Lcl__c = sq.CA_Billing_Contact_Name_Lcl__c;
                        agr.CA_Bill_To_Name__c = sq.CA_Bill_To_Name__c;
                        agr.CA_Bill_To_Name_Lcl__c = sq.CA_Bill_To_Name_Lcl__c;
                        agr.CA_Bill_To_Email__c = sq.Bill_To_Email_Address__c;
                        agr.CA_Bill_To_Phone__c = sq.Bill_To_Phone__c;
                        List<String> billToAddress;
                        string billToStreet = ''; 
                        if(sq.Bill_To_Address__c != null)
                            billToAddress = sq.Bill_To_Address__c.split(',');
                        
                        if(billToAddress != null) {      
                            if(billToAddress.size() >= 5) {
                                //agr.CA_Bill_To_Street__c = billToAddress[billToAddress.size()-5];
                                agr.Bill_To_City__c = billToAddress[billToAddress.size()-4];
                                agr.CA_Bill_To_State__c = billToAddress[billToAddress.size()-3];
                                agr.Bill_To_Zipcode__c = billToAddress[billToAddress.size()-2];
                                agr.Bill_To_Country__c = billToAddress[billToAddress.size()-1];
                                // Added as part of defect DE198544
                                for(Integer i=5; i<=billToAddress.size();i++){ 
                                  if(i<billToAddress.size())                        
                                  billToStreet = ','+billToAddress[billToAddress.size()-i]+billToStreet ;
                                  if(i==billToAddress.size())
                                  billToStreet = billToAddress[billToAddress.size()-i]+billToStreet ;                                
                                }
                                system.debug('Streeet....'+billToStreet );
                                agr.CA_Bill_To_Street__c = billToStreet ;
                            }
                        } else {
                            agr.CA_Bill_To_Street__c = '';
                            agr.Bill_To_City__c = '';
                            agr.CA_Bill_To_State__c = '';
                            agr.Bill_To_Zipcode__c = '';
                            agr.Bill_To_Country__c = '';
                        }

                        List<String> billToAddressLcl;
                        String billStreetAddLcl ='';
                        if(sq.Bill_To_Address_Lcl__c != null)
                            billToAddressLcl = sq.Bill_To_Address_Lcl__c.split(',');
                        
                        if(billToAddressLcl != null) {     
                            if(billToAddressLcl.size() >= 5) {
                                //if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                 if(sq.Region__c == Label.APJ && sq.SalesArea__c == Label.JAPAN &&
                                   sq.Territory__c== Label.JAPAN && sq.Sub_Territory__c == Label.JAPAN) {
                                agr.CA_Bill_To_Country_Lcl__c = billToAddressLcl[0];
                                agr.Bill_To_Zipcode__c = billToAddressLcl[1];
                                agr.CA_Bill_To_State_Lcl__c = billToAddressLcl[2];
                                agr.Bill_To_City_Lcl__c = billToAddressLcl[3];
                                //agr.Bill_To_Street_Lcl__c = billToAddressLcl[billToAddressLcl.size()-1];
                                for(Integer i=4; i<=billToAddressLcl.size();i++){ 
                                    if(i<billToAddressLcl.size())                        
                                       billStreetAddLcl = billStreetAddLcl+' '+billToAddressLcl[i];
                                }
                                agr.Bill_To_Street_Lcl__c = billStreetAddLcl;
                                } else {
                                    //agr.Bill_To_Street_Lcl__c = billToAddressLcl[billToAddressLcl.size()-5];
                                    agr.Bill_To_City_Lcl__c = billToAddressLcl[billToAddressLcl.size()-4];
                                    agr.CA_Bill_To_State_Lcl__c = billToAddressLcl[billToAddressLcl.size()-3];
                                    agr.Bill_To_Zipcode__c = billToAddressLcl[billToAddressLcl.size()-2];
                                    agr.CA_Bill_To_Country_Lcl__c = billToAddressLcl[billToAddressLcl.size()-1];
                                    // Added as part of defect DE198544
                                    for(Integer i=5; i<=billToAddressLcl.size();i++){ 
                                      if(i<billToAddressLcl.size())                        
                                      billStreetAddLcl = ','+billToAddressLcl[billToAddressLcl.size()-i]+billStreetAddLcl ;
                                      if(i==billToAddressLcl.size())
                                      billStreetAddLcl = billToAddressLcl[billToAddressLcl.size()-i]+billStreetAddLcl ;                                
                                    }
                                    system.debug('Streeet....'+billStreetAddLcl );
                                    agr.Bill_To_Street_Lcl__c = billStreetAddLcl ;
                                    }
                            } 
                        } else {
                            agr.Bill_To_Street_Lcl__c = '';
                            agr.Bill_To_City_Lcl__c = '';
                            agr.CA_Bill_To_State_Lcl__c = '';
                            agr.CA_Bill_To_Country_Lcl__c = '';
                        }
                        
                        agr.CA_Ship_To_Id__c = sq.CA_Ship_To_ID__c;
                        agr.CA_Ship_To_Name__c = sq.CA_Ship_To_Name__c;
                        agr.CA_Ship_To_Name_Lcl__c = sq.CA_Ship_To_Name_Lcl__c;
                        agr.CA_Shipping_Contact_Name__c = sq.CA_Shipping_Contact_Name__c;
                        agr.CA_Shipping_Contact_Name_Lcl__c = sq.CA_Shipping_Contact_Name_Lcl__c;
                        
                        List<String> shipToAddress;
                        String shiptoStreet = '';
                        if(sq.Ship_To_Address__c != null)
                            shipToAddress = sq.Ship_To_Address__c.split(',');
                        
                        if(shipToAddress != null) { 
                            if(shipToAddress.size() >= 5) {
                                //agr.CA_Ship_To_Street__c = shipToAddress[shipToAddress.size()-5];
                                agr.CA_Ship_To_City__c = shipToAddress[shipToAddress.size()-4];
                                agr.Ship_To_State__c = shipToAddress[shipToAddress.size()-3];
                                agr.CA_Ship_To_Zipcode__c = shipToAddress[shipToAddress.size()-2]; 
                                agr.Ship_To_Country__c = shipToAddress[shipToAddress.size()-1];
                                // Added as part of defect DE198544
                                    for(Integer i=5; i<=shipToAddress.size();i++){ 
                                      if(i<shipToAddress.size())                        
                                      shiptoStreet = ','+shipToAddress[shipToAddress.size()-i]+shiptoStreet ;
                                      if(i==shipToAddress.size())
                                      shiptoStreet = shipToAddress[shipToAddress.size()-i]+shiptoStreet ;                                
                                    }
                                    system.debug('Streeet....'+shiptoStreet );
                                    agr.CA_Ship_To_Street__c = shiptoStreet ;
                                    
                            }  
                        } else {
                            agr.CA_Ship_To_Street__c = '';
                            agr.CA_Ship_To_City__c = '';
                            agr.Ship_To_State__c = '';
                            agr.CA_Ship_To_Zipcode__c = ''; 
                            agr.Ship_To_Country__c = '';
                        }
                        
                        List<String> shipToAddressLcl;
                        String shipTostreetLcl = '';
                        if(sq.Ship_To_Address_Lcl__c != null)
                            shipToAddressLcl = sq.Ship_To_Address_Lcl__c.split(',');
                        
                        if(shipToAddressLcl != null) {  
                            if(shipToAddressLcl.size() >= 5) {
                               // if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                 if(sq.Region__c == Label.APJ && sq.SalesArea__c == Label.JAPAN &&
                                   sq.Territory__c== Label.JAPAN && sq.Sub_Territory__c == Label.JAPAN) { 
                                agr.CA_Ship_To_Country_Lcl__c = shipToAddressLcl[0];
                                    agr.CA_Ship_To_Zipcode__c = shipToAddressLcl[1];
                                    agr.Ship_To_State_Lcl__c = shipToAddressLcl[2];
                                    agr.Ship_To_City_Lcl__c = shipToAddressLcl[3];
                                    
                                    for(Integer i=4; i<=shipToAddressLcl.size();i++){ 
                                        if(i<shipToAddressLcl.size())                        
                                           shipTostreetLcl = shipTostreetLcl+' '+shipToAddressLcl[i];
                                    }
                                    agr.CA_Ship_To_Street_Lcl__c = shipTostreetLcl;
                                } else {
                                    //agr.CA_Ship_To_Street_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-5];
                                    agr.Ship_To_City_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-4];
                                    agr.Ship_To_State_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-3];
                                    agr.CA_Ship_To_Zipcode__c = shipToAddressLcl[shipToAddressLcl.size()-2];
                                    agr.CA_Ship_To_Country_Lcl__c = shipToAddressLcl[shipToAddressLcl.size()-1];
                                     // Added as part of defect DE198544
                                    for(Integer i=5; i<=shipToAddressLcl.size();i++){ 
                                      if(i<shipToAddressLcl.size())                        
                                      shipTostreetLcl = ','+shipToAddressLcl[shipToAddressLcl.size()-i]+shipTostreetLcl ;
                                      if(i==shipToAddressLcl.size())
                                      shipTostreetLcl = shipToAddressLcl[shipToAddressLcl.size()-i]+shipTostreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+shipTostreetLcl );
                                    agr.CA_Ship_To_Street_Lcl__c = shipTostreetLcl ;
                                }
                            }
                        } else {
                            agr.CA_Ship_To_Street_Lcl__c = '';
                            agr.Ship_To_City_Lcl__c = '';
                            agr.Ship_To_State_Lcl__c = '';
                            agr.CA_Ship_To_Country_Lcl__c = '';
                        }
                        
                        agr.CA_Reseller_Id__c = sq.CA_Reseller_ID__c;
                        agr.CA_Reseller_Name__c = sq.CA_Reseller_Name__c;
                        agr.CA_Reseller_Name_Lcl__c = sq.CA_Reseller_Name_Lcl__c;
                        
                        List<String> resellerAdd;
                        String resellerstreet = '';
                        if(sq.CA_Partner_Address__c != null)
                            resellerAdd = sq.CA_Partner_Address__c.split(',');
                        
                        if(resellerAdd != null) {  
                            if(resellerAdd.size() >= 5) {
                                //agr.CA_Reseller_Street__c = resellerAdd[resellerAdd.size()-5];
                                agr.CA_Reseller_City__c = resellerAdd[resellerAdd.size()-4];
                                agr.CA_Reseller_State__c = resellerAdd[resellerAdd.size()-3];
                                agr.CA_Reseller_Zipcode__c = resellerAdd[resellerAdd.size()-2];
                                agr.CA_Reseller_Country__c = resellerAdd[resellerAdd.size()-1];
                                 // Added as part of defect DE198544
                                    for(Integer i=5; i<=resellerAdd.size();i++){ 
                                      if(i<resellerAdd.size())                        
                                      resellerstreet = ','+resellerAdd[resellerAdd.size()-i]+resellerstreet ;
                                      if(i==resellerAdd.size())
                                      resellerstreet = resellerAdd[resellerAdd.size()-i]+resellerstreet ;                                
                                    }
                                    system.debug('Streeet....'+resellerstreet );
                                    agr.CA_Reseller_Street__c = resellerstreet ;
                            }
                        } else {
                            agr.CA_Reseller_Street__c = '';
                            agr.CA_Reseller_City__c = '';
                            agr.CA_Reseller_State__c = '';
                            agr.CA_Reseller_Zipcode__c = '';
                            agr.CA_Reseller_Country__c = '';
                        }
                        
                        List<String> resellerAddLcl;
                        String resellerStreetLcl = '';
                        if(sq.CA_Partner_Address_Lcl__c != null)
                            resellerAddLcl = sq.CA_Partner_Address_Lcl__c.split(',');
                        
                        if(resellerAddLcl != null) {  
                            if(resellerAddLcl.size() >= 5) {
                               // if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                 if(sq.Region__c == Label.APJ && sq.SalesArea__c == Label.JAPAN &&
                                   sq.Territory__c== Label.JAPAN && sq.Sub_Territory__c == Label.JAPAN) {    
                                agr.CA_Reseller_Country_Lcl__c = resellerAddLcl[0];
                                    agr.CA_Reseller_Zipcode__c = resellerAddLcl[1];
                                    agr.CA_Reseller_State_Lcl__c = resellerAddLcl[2];
                                    agr.CA_Reseller_City_Lcl__c = resellerAddLcl[3];
                                    //agr.CA_Reseller_Street_Lcl__c = resellerAddLcl[resellerAddLcl.size()-1];
                                    for(Integer i=4; i<=resellerAddLcl.size();i++){ 
                                        if(i<resellerAddLcl.size())                        
                                           resellerStreetLcl = resellerStreetLcl+' '+resellerAddLcl[i];
                                    }
                                    agr.CA_Reseller_Street_Lcl__c = resellerStreetLcl;
                                } else {
                                    //agr.CA_Reseller_Street_Lcl__c = resellerAddLcl[resellerAddLcl.size()-5];
                                    agr.CA_Reseller_City_Lcl__c = resellerAddLcl[resellerAddLcl.size()-4];
                                    agr.CA_Reseller_State_Lcl__c = resellerAddLcl[resellerAddLcl.size()-3];
                                    agr.CA_Reseller_Zipcode__c = resellerAddLcl[resellerAddLcl.size()-2];
                                    agr.CA_Reseller_Country_Lcl__c = resellerAddLcl[resellerAddLcl.size()-1];
                                     // Added as part of defect DE198544
                                    for(Integer i=5; i<=resellerAddLcl.size();i++){ 
                                      if(i<resellerAddLcl.size())                        
                                      resellerStreetLcl = ','+resellerAddLcl[resellerAddLcl.size()-i]+resellerStreetLcl ;
                                      if(i==resellerAddLcl.size())
                                      resellerStreetLcl = resellerAddLcl[resellerAddLcl.size()-i]+resellerStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+resellerStreetLcl );
                                    agr.CA_Reseller_Street_Lcl__c = resellerStreetLcl ;
                                }
                            }
                        } else {
                            agr.CA_Reseller_Street_Lcl__c = '';
                            agr.CA_Reseller_City_Lcl__c = '';
                            agr.CA_Reseller_State_Lcl__c = '';
                            agr.CA_Reseller_Country_Lcl__c = '';
                        }
                        agr.CA_Distributor_Id__c = sq.CA_Distributor_ID__c;
                        agr.CA_Distributor_Name__c = sq.CA_Distributor_Name__c;
                        agr.CA_Distributor_Name_Lcl__c = sq.CA_Distributor_Name_Lcl__c;
                        
                        List<String> distAddress;
                        String distStreet = '';
                        if(sq.CA_Distributor_Address__c != null) 
                            distAddress = sq.CA_Distributor_Address__c.split(',');
                        
                        if(distAddress != null) {  
                            if(distAddress.size() >= 5) {
                                //agr.CA_Distributor_Street__c = distAddress[distAddress.size()-5];
                                agr.CA_Distributor_City__c = distAddress[distAddress.size()-4];
                                agr.CA_Distributor_State__c = distAddress[distAddress.size()-3];
                                agr.Distributor_Zipcode__c = distAddress[distAddress.size()-2];
                                agr.CA_Distributor_Country__c = distAddress[distAddress.size()-1];
                                // Added as part of defect DE198544
                                    for(Integer i=5; i<=distAddress.size();i++){ 
                                      if(i<distAddress.size())                        
                                      distStreet = ','+distAddress[distAddress.size()-i]+distStreet ;
                                      if(i==distAddress.size())
                                      distStreet = distAddress[distAddress.size()-i]+distStreet ;                                
                                    }
                                    system.debug('Streeet....'+distStreet );
                                    agr.CA_Distributor_Street__c = distStreet ;
                            } 
                        } else {
                            agr.CA_Distributor_Street__c = '';
                            agr.CA_Distributor_City__c = '';
                            agr.CA_Distributor_State__c = '';
                            agr.Distributor_Zipcode__c = '';
                            agr.CA_Distributor_Country__c = '';
                        }  
                        
                        List<String> distAddressLcl;
                        String distStreetLcl ='';
                        if(sq.CA_Distributor_Address_Lcl__c != null) 
                            distAddressLcl = sq.CA_Distributor_Address_Lcl__c.split(',');
                        
                        if(distAddressLcl != null) {  
                            if(distAddressLcl.size() >= 5) {
                               // if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                 if(sq.Region__c == Label.APJ && sq.SalesArea__c == Label.JAPAN &&
                                   sq.Territory__c== Label.JAPAN && sq.Sub_Territory__c == Label.JAPAN) {
                                agr.CA_Distributor_Country_Lcl__c = distAddressLcl[0];
                                agr.Distributor_Zipcode__c = distAddressLcl[1];
                                agr.CA_Distributor_State_Lcl__c = distAddressLcl[2];
                                agr.CA_Distributor_City_Lcl__c = distAddressLcl[3];
                                //agr.CA_Distributor_Street_Lcl__c = distAddress[distAddress.size()-1];
                                
                                for(Integer i=4; i<=distAddressLcl.size();i++){ 
                                        if(i<distAddressLcl.size())                        
                                           distStreetLcl = distStreetLcl+' '+distAddressLcl[i];
                                    }
                                agr.CA_Distributor_Street_Lcl__c= distStreetLcl;
                                } else {
                                //agr.CA_Distributor_Street_Lcl__c = distAddress[distAddress.size()-5];
                                agr.CA_Distributor_City_Lcl__c = distAddressLcl[distAddressLcl.size()-4];
                                agr.CA_Distributor_State_Lcl__c = distAddressLcl[distAddressLcl.size()-3];
                                agr.Distributor_Zipcode__c = distAddressLcl[distAddressLcl.size()-1];
                                agr.CA_Distributor_Country_Lcl__c = distAddressLcl[distAddressLcl.size()-2];
                                // Added as part of defect DE198544
                                    for(Integer i=5; i<=distAddressLcl.size();i++){ 
                                      if(i<distAddressLcl.size())                        
                                      distStreetLcl = ','+distAddressLcl[distAddressLcl.size()-i]+distStreetLcl ;
                                      if(i==distAddressLcl.size())
                                      distStreetLcl = distAddressLcl[distAddressLcl.size()-i]+distStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+distStreetLcl );
                                    agr.CA_Distributor_Street_Lcl__c = distStreetLcl ;
                                }
                            }  
                        } else {
                            agr.CA_Distributor_Street_Lcl__c = '';
                            agr.CA_Distributor_City_Lcl__c = '';
                            agr.CA_Distributor_State_Lcl__c = '';
                            agr.CA_Distributor_Country_Lcl__c = '';
                        }
                        
                        agr.CA_End_User_Id__c = sq.CA_End_User_ID__c;
                        agr.CA_End_User_Name__c = sq.CA_End_User_Name__c;
                        agr.CA_End_User_Name_Lcl__c = sq.CA_End_User_Name_Lcl__c;
                        agr.CA_End_User_Contact_Name__c = sq.CA_End_User_Contact_Name__c;
                        agr.CA_End_User_Contact_Name_Lcl__c = sq.CA_End_User_Contact_Name_Lcl__c;
                        //US335023 added by Jagan
                        agr.EndUserEmailAddress__c=sq.End_User_Contact_Email_Address__c;
                        agr.EndUserContactPhone__c=sq.End_User_Contact_Phone__c;
                        //US335023 change ends
                        List<String> endUserAddress;
                        string enduserStreet ='';
                        if(sq.CA_End_User_Address__c != null)
                            endUserAddress = sq.CA_End_User_Address__c.split(',');
                        
                        if(endUserAddress != null) {     
                            if(endUserAddress.size() >= 5){ 
                                //agr.CA_End_User_Street__c = endUserAddress[endUserAddress.size()-5];
                                agr.CA_End_User_City__c = endUserAddress[endUserAddress.size()-4];
                                agr.CA_End_User_State__c = endUserAddress[endUserAddress.size()-3];
                                agr.CA_End_User_Zipcode__c = endUserAddress[endUserAddress.size()-2];
                                agr.CA_End_User_Country__c = endUserAddress[endUserAddress.size()-1];
                                // Added as part of defect DE198544
                                    for(Integer i=5; i<=endUserAddress .size();i++){ 
                                      if(i<endUserAddress .size())                        
                                      enduserStreet = ','+endUserAddress [endUserAddress .size()-i]+enduserStreet ;
                                      if(i==endUserAddress .size())
                                      enduserStreet = endUserAddress [endUserAddress .size()-i]+enduserStreet ;                                
                                    }
                                    system.debug('Streeet....'+enduserStreet );
                                    agr.CA_End_User_Street__c = enduserStreet ;
                            }
                        } else {
                            agr.CA_End_User_Street__c = '';
                            agr.CA_End_User_City__c = '';
                            agr.CA_End_User_State__c = '';
                            agr.CA_End_User_Zipcode__c = '';
                            agr.CA_End_User_Country__c = '';
                        }

                        List<String> endUserAddressLcl;
                        String enduserStreetLcl = '';
                        if(sq.CA_End_User_Address_Lcl__c != null)
                            endUserAddressLcl = sq.CA_End_User_Address_Lcl__c.split(',');
                        
                        if(endUserAddressLcl != null) {      
                            if(endUserAddressLcl.size() >= 5){
                               // if(sq.scpq__OpportunityId__r.Rpt_Region__c == Label.APJ && sq.scpq__OpportunityId__r.Rpt_Area__c == Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Territory_Country__c== Label.JAPAN && sq.scpq__OpportunityId__r.Rpt_Country__c == Label.JAPAN) {
                                 if(sq.Region__c == Label.APJ && sq.SalesArea__c == Label.JAPAN &&
                                   sq.Territory__c== Label.JAPAN && sq.Sub_Territory__c == Label.JAPAN) { 
                                agr.CA_End_User_Country_Lcl__c = endUserAddressLcl[0];
                                    agr.CA_End_User_Zipcode__c = endUserAddressLcl[1];
                                    agr.CA_End_User_State_Lcl__c = endUserAddressLcl[2];
                                    agr.CA_End_User_City_Lcl__c = endUserAddressLcl[3];
                                    //agr.CA_End_User_Street_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-1];
                                    for(Integer i=4; i<=endUserAddressLcl.size();i++){ 
                                        if(i<endUserAddressLcl.size())                        
                                           enduserStreetLcl = enduserStreetLcl+' '+endUserAddressLcl[i];
                                    }
                                    agr.CA_End_User_Street_Lcl__c= enduserStreetLcl;
                                    
                                } else {
                                    //agr.CA_End_User_Street_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-5];
                                    agr.CA_End_User_City_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-4];
                                    agr.CA_End_User_State_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-3];
                                    agr.CA_End_User_Zipcode__c = endUserAddressLcl[endUserAddressLcl.size()-2];
                                    agr.CA_End_User_Country_Lcl__c = endUserAddressLcl[endUserAddressLcl.size()-1];
                                     // Added as part of defect DE198544
                                    for(Integer i=5; i<=endUserAddressLcl.size();i++){ 
                                      if(i<endUserAddressLcl.size())                        
                                      enduserStreetLcl = ','+endUserAddressLcl[endUserAddressLcl.size()-i]+enduserStreetLcl ;
                                      if(i==endUserAddressLcl.size())
                                      enduserStreetLcl = endUserAddressLcl[endUserAddressLcl.size()-i]+enduserStreetLcl ;                                
                                    }
                                    system.debug('Streeet....'+enduserStreetLcl );
                                    agr.CA_End_User_Street__c = enduserStreetLcl ;
                                }
                            } 
                        } else {
                            agr.CA_End_User_Street_Lcl__c = '';
                            agr.CA_End_User_City_Lcl__c = '';
                            agr.CA_End_User_State_Lcl__c = '';
                            agr.CA_End_User_Country_Lcl__c = '';
                        }
                        
                        agr.CA_Outsourcer_Id__c = sq.CA_Service_Provider_ID__c;
                        agr.CA_Outsourcer_Name__c = sq.CA_Service_Provider_Name__c;
                        
                    }
                    updateAgrList.add(agr);
                }
            }
            
            if(updateAgrList.size() > 0)
                update updateAgrList;
           if(callWebServiceFlag && reqPayLoad<>null && reqPayLoad.size()>0 && !System.isfuture())
            {
                QuoteUpdateToLayer7.callQuoteUpdate(reqPayLoad);
            } 
                
        } catch(Exception e) {
            system.debug('Error Message::::'+e.getMessage());
        }
    }
}