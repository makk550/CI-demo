/**************************************************************************************************
* Account Trigger Handler
* 
*Vesrion Date         Owner                         Description                                   
****************************************************************************************************
* 1.0                                               Created.
* 2.0    23/03/2015   Manikandan Raju               PR04659 : Account - EAI webservice callout. Modified the method pushAccountUpdatesToMDM
**************************************************************************************************/

/*
    Accounts should be direct accounts - done
    MDM error free - done
    Trigger will be clled only when the mapping fields value change
*/

public with sharing class AccountChangesPushToMDM {
    
    public void pushAccountUpdatesToMDM(Map < Id, Account > oldMap, Map < Id, Account > newMap) {
        
        if (BooleanUtils.skipAccTrigger == true) return;
        
        System.debug('Inside pushAccountUpdatesToMDM');
        Set < Id > eligibleAcctIds = new Set < Id > ();
        
        RecordTypes_Setting__c accTeamBasedRecordType = RecordTypes_Setting__c.getValues('Account Team Covered Account');
        Id acctTeamRecordTypeId = accTeamBasedRecordType.RecordType_Id__c;
        RecordTypes_Setting__c territoryRecordType = RecordTypes_Setting__c.getValues('Territory Covered Account');
        Id territoryRecordTypeId = territoryRecordType.RecordType_Id__c;
        RecordTypes_Setting__c partnerRecordType = RecordTypes_Setting__c.getValues('Reseller/Distributor Account');
        Id partnerRecordTypeId = partnerRecordType.RecordType_Id__c;
        
        String genericUserIds = System.Label.Generic_Users;
        String[] users = genericUserIds.split(';');
        Set < Id > usersSet = new Set < Id > ();
        Map < String, String > acctMap = null;
        for (String userId: users) {
            usersSet.add(userId);
        }
        
        //Account Id to Account List Map which will be sent to EAI Webservice Callout - PR04659 : Manikandan Raju
        Map<Id,List<Account>> accountIdToAccountListMap = new  Map<Id,List<Account>>();
        
        for (Id acctId: newMap.keySet()) {
            Account oldAcct;
            Account newAcct = newMap.get(acctId);
            system.debug(newAcct.FromSARecord__c);
            
            if (oldMap != null)
                oldAcct  = oldMap.get(acctId);
              
            if ((
                    (newAcct.RecordTypeId == acctTeamRecordTypeId && newAcct.Is_Primary_Account__c) 
                    || newAcct.RecordTypeId == territoryRecordTypeId 
                    // || newAcct.RecordTypeId == partnerRecordTypeId    //Commented - PR04659 : Manikandan Raju
                ) 
                && (newAcct.Account_Status__c == 'Approved' || newAcct.Account_Status__c == 'Pending Review') 
                //&& !usersSet.contains(newAcct.LastModifiedById)   //Commented - PR04659 : Manikandan Raju 
                && !System.isFuture() 
                //&& (Trigger.isUpdate || (Trigger.isInsert && !newAcct.FromSARecord__c))   //Commented - PR04659 : Manikandan Raju 
                && ( newAcct.Error_Code_MDM__c == null && newAcct.Error_Message_MDM__c == null )
            ) {

                System.debug('--Before checking field values--');
                if (oldMap != null &&
                    (oldAcct.Enterprise_ID__c != newAcct.Enterprise_ID__c || oldAcct.Enterprise_Account_Name__c != newAcct.Enterprise_Account_Name__c ||
                        oldAcct.GU_DUNS_NUMBER__c != newAcct.GU_DUNS_NUMBER__c || oldAcct.GU_NAME__c != newAcct.GU_NAME__c ||
                        oldAcct.Segment__c != newAcct.Segment__c || oldAcct.GEO__c != newAcct.GEO__c ||
                        oldAcct.Sales_Area__c != newAcct.Sales_Area__c || oldAcct.Sales_Region__c != newAcct.Sales_Region__c ||
                        oldAcct.REGION_COUNTRY__C != newAcct.REGION_COUNTRY__C ||
                        oldAcct.Account_Type1__c != newAcct.Account_Type1__c || oldAcct.Account_Type__c != newAcct.Account_Type__c ||
                        oldAcct.Account_Status__c != newAcct.Account_Status__c || oldAcct.Coverage_Model__c != newAcct.Coverage_Model__c ||
                        oldAcct.Sales_Volume__c != newAcct.Sales_Volume__c ||                        
                        oldAcct.RecordTypeId != newAcct.RecordTypeId ||                         
                        oldAcct.Global_Parent_Segment__c != newAcct.Global_Parent_Segment__c || oldAcct.ownerID != newAcct.ownerID ||
                        oldAcct.NumberOfEmployees != newAcct.NumberOfEmployees || oldAcct.Sic != newAcct.Sic ||
                        oldAcct.SicDesc != newAcct.SicDesc || oldAcct.RecordTypeId != newAcct.RecordTypeId ||                       
                        oldAcct.Country_Picklist__c!=newAcct.Country_Picklist__c ||
                        oldAcct.BillingCity != newAcct.BillingCity ||
                        oldAcct.BillingStreet != newAcct.BillingStreet ||
                        oldAcct.BillingState != newAcct.BillingState ||
                        oldAcct.BillingPostalCode != newAcct.BillingPostalCode ||
                        oldAcct.BillingCountry != newAcct.BillingCountry ||
                        oldAcct.Name != newAcct.Name ||
                        oldAcct.Is_Primary_Account__c != newAcct.Is_Primary_Account__c || 
                        oldAcct.Global_Parent_SIC_2_digit__c != newAcct.Global_Parent_SIC_2_digit__c ||
                        oldAcct.Global_Parent_SIC_4_digit__c != newAcct.Global_Parent_SIC_4_digit__c ||
                        oldAcct.Global_Parent_Industry__c != newAcct.Global_Parent_Industry__c ||
                        oldAcct.OwnerId != newAcct.OwnerId ||
                        oldAcct.Website != newAcct.Website ||
                        oldAcct.Alliance__c != newAcct.Alliance__c ||
                        oldAcct.Alliance_Type__c != newAcct.Alliance_Type__c ||
                        oldAcct.Alliance_Program_Level__c != newAcct.Alliance_Program_Level__c ||
                        oldAcct.CPMS_ID__c != newAcct.CPMS_ID__c ||
                        oldAcct.Velocity_Seller__c != newAcct.Velocity_Seller__c ||
                        oldAcct.Velocity_Seller_Type__c != newAcct.Velocity_Seller_Type__c ||
                        oldAcct.Velocity_Seller_Program_Level__c != newAcct.Velocity_Seller_Program_Level__c ||
                        oldAcct.rtm__c!= newAcct.rtm__c ||
                        oldAcct.Service_Provider__c != newAcct.Service_Provider__c ||
                        oldAcct.Service_Provider_Type__c != newAcct.Service_Provider_Type__c ||
                        oldAcct.Service_Provider_Program_level__c != newAcct.Service_Provider_Program_level__c ||
                        oldAcct.Solution_Provider__c != newAcct.Solution_Provider__c ||
                        oldAcct.Solution_Provider_Type__c != newAcct.Solution_Provider_Type__c ||
                        oldAcct.Solution_Provider_Program_Level__c != newAcct.Solution_Provider_Program_Level__c
                    ))
                    {
                        System.debug('--valid record--id:'+newAcct.Id); 
                        //eligibleAcctIds.add(acctId);      //Commented - PR04659 : Manikandan Raju 
                        accountIdToAccountListMap.put(newAcct.Id,new List<Account>{newAcct});
                    }
                    if (oldMap == null)
                    {
                    System.debug('--valid insert record--id:'+newAcct.Id); 
                        //eligibleAcctIds.add(acctId);      //Commented - PR04659 : Manikandan Raju 
                        accountIdToAccountListMap.put(newAcct.Id,new List<Account>{newAcct});
                    }
            }
        }
        
        /*** Webservice Callout to EAI - PR04659 : Manikandan Raju ***/
        if ( !System.isFuture() && !accountIdToAccountListMap.keyset().isEmpty() ) {
            WebServiceUtilityClass.callEAIWebserviceBulkRequest(accountIdToAccountListMap);
        }
        
        BooleanUtils.skipAccTrigger = true;
    }

    public void pushAccountInsertToMDM(Map < Id, Account > oldMap, Map < Id, Account > newMap) {
        System.debug('Inside pushAccountInsertToMDM');
        System.debug('New Map accounts' + newMap.values());
        Set < Id > eligibleAcctIds = new Set < Id > ();
        RecordTypes_Setting__c accTeamBasedRecordType = RecordTypes_Setting__c.getValues('Account Team Covered Account');
        Id acctTeamRecordTypeId = accTeamBasedRecordType.RecordType_Id__c;
        RecordTypes_Setting__c territoryRecordType = RecordTypes_Setting__c.getValues('Territory Covered Account');
        Id territoryRecordTypeId = territoryRecordType.RecordType_Id__c;
        RecordTypes_Setting__c partnerRecordType = RecordTypes_Setting__c.getValues('Reseller/Distributor Account');
        Id partnerRecordTypeId = partnerRecordType.RecordType_Id__c;
        String genericUserIds = System.Label.Generic_Users;
        String[] users = genericUserIds.split(';');
        Set < Id > usersSet = new Set < Id > ();
        Map < String, String > acctMap = null;
        for (String userId: users) {
            usersSet.add(userId);
        }
        for (Id acctId: newMap.keySet()) {

            Account newAcct = newMap.get(acctId);
            system.debug(newAcct.FromSARecord__c);
            if (oldMap != null)
                Account oldAcct = oldMap.get(acctId);
            if ((
                    (newAcct.RecordTypeId == acctTeamRecordTypeId && newAcct.Is_Primary_Account__c) ||
                    newAcct.RecordTypeId == territoryRecordTypeId ||
                    newAcct.RecordTypeId == partnerRecordTypeId
                ) &&
                (newAcct.Account_Status__c == 'Approved' || newAcct.Account_Status__c == 'Pending Review') && !usersSet.contains(newAcct.LastModifiedById)

            ) {
            eligibleAcctIds.add(acctId);            
            }
        }
        if (eligibleAcctIds.size() == 1) {
            System.debug('Inside pushAccountInsertToMDM - eligible ids');
            Id tempId;
            for (Id aId: eligibleAcctIds) {
                tempId = aId;
            }
            Account tempAcct = newMap.get(tempId);
            Set < Id > userIds = new Set < Id > ();
            userIds.add(tempAcct.OwnerId);
            userIds.add(tempAcct.CreatedById);
            userIds.add(tempAcct.LastModifiedById);
            List < User > usersList = [Select PMFKey__c, Id from User where Id IN: userIds];
            Map < Id, String > userId_pmfKey_map = new Map < Id, String > ();
            for (User userObj: usersList) {
                userId_pmfKey_map.put(userObj.Id, userObj.PMFKey__c);
            }
            acctMap = createMapFromObject(tempAcct);
            callMDMWebserviceRequest(acctMap, userId_pmfKey_map);
        }
    }

    public String getValidDateFormat(DateTime dateObj) {
        if (dateObj != null)
            return dateObj.format('yyyyMMdd HH:mm:ss');
        return '';
    }

    public Map < String, String > createMapFromObject(Account acctObj) {
        System.debug('in createMapFromObject');
        Map < String, String > acctMap = new Map < String, String > ();
        if (acctObj.Enterprise_ID__c != null)
            acctMap.put('Enterprise_ID__c', acctObj.Enterprise_ID__c);
        if (acctObj.Enterprise_Account_Name__c != null)
            acctMap.put('Enterprise_Account_Name__c', acctObj.Enterprise_Account_Name__c);
        if (acctObj.GU_DUNS_NUMBER__c != null)
            acctMap.put('GU_DUNS_NUMBER__c', acctObj.GU_DUNS_NUMBER__c);
        if (acctObj.GU_NAME__c != null)
            acctMap.put('GU_NAME__c', acctObj.GU_NAME__c);
        if (acctObj.Segment__c != null)
            acctMap.put('Segment__c', acctObj.Segment__c);
        if (acctObj.GEO__c != null)
            acctMap.put('GEO__c', acctObj.GEO__c);
        if (acctObj.Sales_Area__c != null)
            acctMap.put('Sales_Area__c', acctObj.Sales_Area__c);
        if (acctObj.Sales_Region__c != null)
            acctMap.put('Sales_Region__c', acctObj.Sales_Region__c);
        if (acctObj.REGION_COUNTRY__C != null)
            acctMap.put('REGION_COUNTRY__C', acctObj.REGION_COUNTRY__C);
        if (acctObj.OwnerId != null)
            acctMap.put('OwnerId', acctObj.OwnerId);
        if (acctObj.Account_Type1__c != null)
            acctMap.put('Account_Type1__c', acctObj.Account_Type1__c);
        if (acctObj.Account_Type__c != null)
            acctMap.put('Account_Type__c', acctObj.Account_Type__c);
        if (acctObj.Account_Status__c != null)
            acctMap.put('Account_Status__c', acctObj.Account_Status__c);
        if (acctObj.Coverage_Model__c != null)
            acctMap.put('Coverage_Model__c', acctObj.Coverage_Model__c);
        if (acctObj.Sales_Volume__c != null) {
            system.debug('acctObj.Sales_Volume__c.toPlainString()=' + acctObj.Sales_Volume__c.toPlainString());
            acctMap.put('Sales_Volume__c', acctObj.Sales_Volume__c.toPlainString());
        }

        if (acctObj.NumberOfEmployees != null)
            acctMap.put('NumberOfEmployees', String.valueOf(acctObj.NumberOfEmployees));
        if (acctObj.Sic != null)
            acctMap.put('Sic', acctObj.Sic);
        if (acctObj.SicDesc != null)
            acctMap.put('SicDesc', acctObj.SicDesc);
        if (acctObj.SLED_Area__c != null)
            acctMap.put('SLED_Area__c', acctObj.SLED_Area__c);
        acctMap.put('CreatedById', acctObj.CreatedById);
        acctMap.put('CreatedDate', getValidDateFormat(acctObj.CreatedDate));
        acctMap.put('LastModifiedById', acctObj.LastModifiedById);
        if (acctObj.IsDeleted != null) {
            if (acctObj.IsDeleted)
                acctMap.put('IsDeleted', 'true');
            else
                acctMap.put('IsDeleted', 'false');
        }
        acctMap.put('LastModifiedDate', getValidDateFormat(acctObj.LastModifiedDate));
        acctMap.put('RecordTypeId', acctObj.RecordTypeId);
        acctMap.put('Id', acctObj.Id);
        if (acctObj.Billingstate != null)
            acctMap.put('Billingstate', acctObj.Billingstate);
        if (acctObj.BillingStreet != null)
            acctMap.put('BillingStreet', acctObj.BillingStreet);
        if (acctObj.BillingPostalCode != null)
            acctMap.put('BillingPostalCode', acctObj.BillingPostalCode);
        if (acctObj.Billingcountry != null)
            acctMap.put('Billingcountry', acctObj.Billingcountry);

        //FY14 Readiness code changes Start: Added new parameter to web service
        if (acctObj.Global_Parent_Segment__c != null)
            acctMap.put('Global_Parent_Segment__c', acctObj.Global_Parent_Segment__c);
        //FY14 Readiness code changes End.    


        acctMap.put('Name', acctObj.name);
        if (acctObj.Country_Picklist__c != null)
            acctMap.put('Country_Picklist__c', acctObj.Country_Picklist__c);
        if (acctObj.billingcity != null)
            acctMap.put('billingcity', acctObj.billingcity);
        if (acctObj.Is_Primary_Account__c != null)
            acctMap.put('Is_Primary_Account__c', String.valueOf(acctObj.Is_Primary_Account__c));
        if (acctObj.Global_Parent_SIC_2_digit__c != null)
            acctMap.put('Global_Parent_SIC_2_digit__c', acctObj.Global_Parent_SIC_2_digit__c.substring(0, 2));
        if (acctObj.Global_Parent_SIC_4_digit__c != null)
            acctMap.put('Global_Parent_SIC_4_digit__c', acctObj.Global_Parent_SIC_4_digit__c.substring(0, 4));
        if (acctObj.Global_Parent_Industry__c != null)
            acctMap.put('Global_Parent_Industry__c', acctObj.Global_Parent_Industry__c);
        if (acctObj.RecordTypeid != null) {
            List < RecordType > rt = [select name from RecordType where id = : acctObj.recordTypeid];
            String rtName = null;
            if (rt.size() > 0) rtName = rt[0].name;
            acctMap.put('RecordType', rtName);
        }
        if (acctObj.Customer_Category__c != null)
            acctMap.put('Customer_Category__c', acctObj.Customer_Category__c);
        if (acctObj.Website != null)
            acctMap.put('Website', acctObj.Website);
        if (acctObj.Alliance__c != null)
            acctMap.put('Alliance__c', String.valueOf(acctObj.Alliance__c));
        if (acctObj.Alliance_Type__c != null)
            acctMap.put('Alliance_Type__c', acctObj.Alliance_Type__c);
        if (acctObj.Alliance_Program_Level__c != null)
            acctMap.put('Alliance_Program_Level__c', acctObj.Alliance_Program_Level__c);
        if (acctObj.CPMS_ID__c != null)
            acctMap.put('CPMS_ID__c', acctObj.CPMS_ID__c);
        if (acctObj.Velocity_Seller__c != null)
            acctMap.put('Velocity_Seller__c', String.valueOf(acctObj.Velocity_Seller__c));
        if (acctObj.Velocity_Seller_Type__c != null)
            acctMap.put('Velocity_Seller_Type__c', acctObj.Velocity_Seller_Type__c);
        if (acctObj.Velocity_Seller_Program_Level__c != null)
            acctMap.put('Velocity_Seller_Program_Level__c', acctObj.Velocity_Seller_Program_Level__c);
        if (acctObj.rtm__c != null)
            acctMap.put('rtm__c', acctObj.rtm__c);
        if (acctObj.Service_Provider__c != null)
            acctMap.put('Service_Provider__c', String.valueOf(acctObj.Service_Provider__c));
        if (acctObj.Service_Provider_Type__c != null)
            acctMap.put('Service_Provider_Type__c', acctObj.Service_Provider_Type__c);
        if (acctObj.Service_Provider_Program_level__c != null)
            acctMap.put('Service_Provider_Program_level__c', acctObj.Service_Provider_Program_level__c);
        if (acctObj.Solution_Provider__c != null)
            acctMap.put('Solution_Provider__c', String.valueOf(acctObj.Solution_Provider__c));
        if (acctObj.Solution_Provider_Type__c != null)
            acctMap.put('Solution_Provider_Type__c', acctObj.Solution_Provider_Type__c);
        if (acctObj.Solution_Provider_Program_Level__c != null)
            acctMap.put('Solution_Provider_Program_Level__c', acctObj.Solution_Provider_Program_Level__c);


        return acctMap;
    }

    public String convertToString(Decimal value) {
        String str = value.format();
        if (str.indexOf(',') != -1) {
            str = str.replace(',', '');
        }
        System.debug('-------------------------------------------' + str);
        return str;
    }

    public static Map < String, String > parseResponseXML(String response) {
        String status = null;
        String data = null;
        String error = null;
        Map < String, String > respDetails = new Map < String, String > ();
        XmlStreamReader reader = new XmlStreamReader(response);
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('status' == reader.getLocalName()) {
                    if (reader.hasNext())
                        reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        status = reader.getText();
                    }
                }
                if ('dataObject' == reader.getLocalName()) {
                    if (reader.hasNext())
                        reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        data = reader.getText();
                    }
                }
                if ('remoteKey' == reader.getLocalName()) {
                    if (reader.hasNext())
                        reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        if (reader.getText().length() == 7)
                            respDetails.put('caaccountid', reader.getText());
                        else if (reader.getText().length() == 18)
                            respDetails.put('sfdcaccountid', reader.getText());
                    }
                }
                if ('text' == reader.getLocalName()) {
                    if (reader.hasNext())
                        reader.next();
                    if (reader.getEventType() == XmlTag.CHARACTERS) {
                        error = reader.getText();
                    }
                }
            }
            reader.next();
        }
        respDetails.put('STATUS', status);
        respDetails.put('DATA', data);
        respDetails.put('ERROR', error);
        return respDetails;
    }

    public static Map < String, String > accountExists(String sfdcid, String enterpriseId) {
        String respXML = '<?xml version="1.0" encoding="utf-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SOAP-ENV:Body xmlns:rpl="urn:ACCOUNTVi">    <rpl:updateVT_ACCOUNTSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans" xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base"' +
            ' xmlns:rn4="urn:com.sap.mdm.ws.beans.account" xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>OK</rn1:status><rn1:description>Record was updated</rn1:description>' +
            '<rn1:dataObject>6486</rn1:dataObject></rn1:ExecutionStatus></rpl:Response></rpl:updateVT_ACCOUNTSResponse>  </SOAP-ENV:Body></SOAP-ENV:Envelope>';
        boolean isExists = false;
        String status = null;
        String data = null;
        String error = null;
        Map < String, String > respDetails = null;
        String soapXML = getSearchSOAPXML(sfdcid, enterpriseId);
        String respBody = null;
        if (!Test.isRunningTest()) {
            respBody = callWebService(soapXML, enterpriseId, null);
        } else {
            respBody = respXML;
        }
        system.debug('respBody=' + respBody);
        if (respBody != null) {
            respDetails = parseResponseXML(respBody);
        }
        /*status = respDetails.get('STATUS');
        data = respDetails.get('DATA');
        error = respDetails.get('ERROR');
        if(status == 'OK') {
            if(data.indexOf('1..1') != -1) {
                isExists = true;
            }
        }*/
        return respDetails;
    }

    public static String callWebService(String soapXML, String enterpriseId, String Id) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml; charset=utf-8');
        req.setHeader('Content-Length', '2048');
        req.setHeader('Host', System.Label.MDM_Host);
        req.setHeader('Connection', 'keep-alive');
        String encodedb64usernamepassword = System.Label.MDM_Authorization_Key;
        String authorizationHeader = 'Basic ' + encodedb64usernamepassword;
        req.setHeader('Authorization', authorizationHeader);
        req.setEndpoint(System.Label.MDM_End_Point_URL);

        req.setBody(soapXML);
        req.setTimeout(120000);
        Http http = new Http();
        String respBody = null;
        try {
            HTTPResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                respBody = res.getBody();
                System.debug('Responsebody ' + respBody);
            } else {
                if (Id == null)
                    sendEmail(res.getStatus(), System.Label.MDM_Server_Name + ' - Search Failed - ' + enterpriseId);
                else
                    sendEmail(res.getStatus(), System.Label.MDM_Server_Name + ' - ' + Id + ' - ' + enterpriseId);
            }
        } catch (Exception e) {
            try {
                HTTPResponse res = http.send(req);
                if (res.getStatusCode() == 200) {
                    respBody = res.getBody();
                } else {
                    if (Id == null)
                        sendEmail(res.getStatus(), System.Label.MDM_Server_Name + ' - Search Failed - ' + enterpriseId);
                    else
                        sendEmail(res.getStatus(), System.Label.MDM_Server_Name + ' - ' + Id + ' - ' + enterpriseId);
                }
            } catch (Exception e1) {
                if (Id == null)
                    sendEmail(e1.getMessage(), System.Label.MDM_Server_Name + ' - Search Failed - ' + enterpriseId);
                else
                    sendEmail(e1.getMessage(), System.Label.MDM_Server_Name + ' - ' + Id + ' - ' + enterpriseId);
            }
        }
        return respBody;
    }

    public static String callEAIService(String DUNS, String Id) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml');
        req.setHeader('consumerUsername', Label.EAIConsumerUsername);
        req.setEndpoint(System.Label.EAIURL);
        Xmlstreamwriter xsw = new Xmlstreamwriter();
        xsw.writeStartElement(null, 'accountRequest', null);
        xsw.writeStartElement(null, 'source', null);
        xsw.writeStartElement(null, 'dunsGPNumber', null);
        xsw.writeCharacters(DUNS);
        xsw.writeEndElement();
        xsw.writeEndElement();
        xsw.writeStartElement(null, 'strategies', null);
        xsw.writeStartElement(null, 'strategy', null);
        xsw.writeAttribute(null, null, 'name', 'MDM-Duns-Table-Update');
        xsw.writeEndElement();
        xsw.writeEndElement();
        xsw.writeEndElement();
        System.debug('____dunsReq' + xsw.getXmlString());
        req.setBody(xsw.getXmlString());
        req.setTimeout(120000);
        Http http = new Http();
        String respBody = null;
        try {
            HTTPResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                respBody = res.getBody();
            } else {
                sendEmail(res.getStatus(), 'Sending DUNS number has been failed. Account Id ' + Id);
            }
        } catch (Exception e) {
            try {
                HTTPResponse res = http.send(req);
                if (res.getStatusCode() == 200) {
                    respBody = res.getBody();
                } else {
                    sendEmail(res.getStatus(), 'Sending DUNS number has been failed. Account Id ' + Id);
                }
            } catch (Exception e1) {
                sendEmail(e1.getMessage(), 'Sending DUNS number has been failed. Account Id ' + Id);
            }
        }
        return respBody;
    }


    public static String getSearchSOAPXML(String sfdcid, String enterpriseId) {
        String soapXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ACCOUNTVi" xmlns:urn1="urn:com.sap.mdm.ws.beans.account" xmlns:urn2="urn:com.sap.mdm.ws.beans" xmlns:urn3="urn:com.sap.mdm.core.beans">';
        soapXML = soapXML + '<soapenv:Header/>';
        soapXML = soapXML + '<soapenv:Body>';
        soapXML = soapXML + '<urn:searchACCOUNTS>';
        soapXML = soapXML + '<urn:query>';
        soapXML = soapXML + '<urn1:criteria>';
        System.debug('Enterprise ID ' + enterpriseId);
        soapXML = soapXML + '<urn1:sfdcaccountid>';
        soapXML = soapXML + '<urn2:constraint>';
        soapXML = soapXML + '<urn2:value>' + sfdcid + '</urn2:value>';
        soapXML = soapXML + '<urn2:expressionOperator>EQUALS</urn2:expressionOperator>';
        soapXML = soapXML + '</urn2:constraint>';
        soapXML = soapXML + '</urn1:sfdcaccountid>';
        soapXML = soapXML + '</urn1:criteria>';
        soapXML = soapXML + '</urn:query>';
        soapXML = soapXML + '<urn:reposInfo>';
        soapXML = soapXML + '<urn3:dataLang>English [US]</urn3:dataLang>';
        soapXML = soapXML + '<urn3:repositoryName>ZCustomer</urn3:repositoryName>';
        soapXML = soapXML + '<urn3:serverName>' + System.Label.MDM_Server_Name + '</urn3:serverName>';
        soapXML = soapXML + '</urn:reposInfo>';
        soapXML = soapXML + '</urn:searchACCOUNTS>';
        soapXML = soapXML + '</soapenv:Body>';
        soapXML = soapXML + '</soapenv:Envelope>';

        system.debug('search soapXML=' + soapXML);
        return soapXML;
    }

    public static String getInsertSOAPXML(Map < String, String > updateAcct, Map < Id, String > userId_pmfKey_map) {
        String soapXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ACCOUNTVi" xmlns:urn1="urn:com.sap.mdm.ws.beans.account" xmlns:urn2="urn:com.sap.mdm.ws.beans" xmlns:urn3="urn:com.sap.mdm.core.beans">';
        soapXML = soapXML + '<soapenv:Header/>';
        soapXML = soapXML + '<soapenv:Body>';
        soapXML = soapXML + '<urn:createACCOUNTS>';
        soapXML = soapXML + '<urn:ACCOUNTS>';
        soapXML = soapXML + '<urn1:ACCOUNTS__Create>';
        if (updateAcct.get('Enterprise_ID__c') != null)
            soapXML = soapXML + '<urn1:caaccountid>' + updateAcct.get('Enterprise_ID__c') + '</urn1:caaccountid>';
        if (updateAcct.get('Enterprise_Account_Name__c') != null)
            soapXML = soapXML + '<urn1:caaccountname><![CDATA[' + updateAcct.get('Enterprise_Account_Name__c') + ']]></urn1:caaccountname>';
        if (updateAcct.get('GU_DUNS_NUMBER__c') != null)
            soapXML = soapXML + '<urn1:globalparentnumber><![CDATA[' + updateAcct.get('GU_DUNS_NUMBER__c') + ']]></urn1:globalparentnumber>';
        if (updateAcct.get('GU_NAME__c') != null)
            soapXML = soapXML + '<urn1:globalparentname><![CDATA[' + updateAcct.get('GU_NAME__c') + ']]></urn1:globalparentname>';
        if (updateAcct.get('Segment__c') != null)
            soapXML = soapXML + '<urn1:segment><![CDATA[' + updateAcct.get('Segment__c') + ']]></urn1:segment>';
        if (updateAcct.get('GEO__c') != null)
            soapXML = soapXML + '<urn1:geo><![CDATA[' + updateAcct.get('GEO__c') + ']]></urn1:geo>';
        if (updateAcct.get('Sales_Area__c') != null)
            soapXML = soapXML + '<urn1:operatingarea><![CDATA[' + updateAcct.get('Sales_Area__c') + ']]></urn1:operatingarea>';
        if (updateAcct.get('Sales_Region__c') != null)
            soapXML = soapXML + '<urn1:salesregion><![CDATA[' + updateAcct.get('Sales_Region__c') + ']]></urn1:salesregion>';
        if (updateAcct.get('REGION_COUNTRY__C') != null)
            soapXML = soapXML + '<urn1:territory><![CDATA[' + updateAcct.get('REGION_COUNTRY__C') + ']]></urn1:territory>';

        if (updateAcct.get('OwnerId') != null && userId_pmfKey_map.get(updateAcct.get('OwnerId')) != null)
            soapXML = soapXML + '<urn1:accountowner><![CDATA[' + userId_pmfKey_map.get(updateAcct.get('OwnerId')) + ']]></urn1:accountowner>';

        if (updateAcct.get('Account_Type1__c') != null)
            soapXML = soapXML + '<urn1:accounttype1><![CDATA[' + updateAcct.get('Account_Type1__c') + ']]></urn1:accounttype1>';
        if (updateAcct.get('Account_Type__c') != null)
            soapXML = soapXML + '<urn1:accounttype2><![CDATA[' + updateAcct.get('Account_Type__c') + ']]></urn1:accounttype2>';
        if (updateAcct.get('Account_Status__c') != null)
            soapXML = soapXML + '<urn1:accountstatus><![CDATA[' + updateAcct.get('Account_Status__c') + ']]></urn1:accountstatus>';
        if (updateAcct.get('Coverage_Model__c') != null)
            soapXML = soapXML + '<urn1:coveragemodel><![CDATA[' + updateAcct.get('Coverage_Model__c') + ']]></urn1:coveragemodel>';
        if (updateAcct.get('Sales_Volume__c') != null)
            soapXML = soapXML + '<urn1:salesvolume><![CDATA[' + updateAcct.get('Sales_Volume__c') + ']]></urn1:salesvolume>';
        if (updateAcct.get('NumberOfEmployees') != null)
            soapXML = soapXML + '<urn1:employees><![CDATA[' + updateAcct.get('NumberOfEmployees') + ']]></urn1:employees>';
        if (updateAcct.get('Sic') != null)
            soapXML = soapXML + '<urn1:siccode><![CDATA[' + updateAcct.get('Sic') + ']]></urn1:siccode>';
        if (updateAcct.get('SicDesc') != null)
            soapXML = soapXML + '<urn1:sicdesc><![CDATA[' + updateAcct.get('SicDesc') + ']]></urn1:sicdesc>';
        if (updateAcct.get('CreatedDate') != null)
            soapXML = soapXML + '<urn1:createddate><![CDATA[' + updateAcct.get('CreatedDate') + ']]></urn1:createddate>';
        if (updateAcct.get('CreatedById') != null)
            soapXML = soapXML + '<urn1:createdbyid><![CDATA[' + updateAcct.get('CreatedById') + ']]></urn1:createdbyid>';
        if (updateAcct.get('LastModifiedDate') != null)
            soapXML = soapXML + '<urn1:lastmodifieddate><![CDATA[' + updateAcct.get('LastModifiedDate') + ']]></urn1:lastmodifieddate>';
        if (updateAcct.get('LastModifiedById') != null)
            soapXML = soapXML + '<urn1:lastmodifiedbyid><![CDATA[' + updateAcct.get('LastModifiedById') + ']]></urn1:lastmodifiedbyid>';
        if (updateAcct.get('IsDeleted') != null)
            soapXML = soapXML + '<urn1:isdeleted><![CDATA[' + updateAcct.get('IsDeleted') + ']]></urn1:isdeleted>';
        if (updateAcct.get('RecordTypeId') != null)
            soapXML = soapXML + '<urn1:recordtypeid><![CDATA[' + updateAcct.get('RecordTypeId') + ']]></urn1:recordtypeid>';
        if (updateAcct.get('Id') != null)
            soapXML = soapXML + '<urn1:sfdcaccountid><![CDATA[' + updateAcct.get('Id') + ']]></urn1:sfdcaccountid>';
        if (updateAcct.get('Billingstate') != null)
            soapXML = soapXML + '<urn1:physicalstate><![CDATA[' + updateAcct.get('Billingstate') + ']]></urn1:physicalstate>';
        if (updateAcct.get('BillingStreet') != null)
            soapXML = soapXML + '<urn1:physicalstreet><![CDATA[' + updateAcct.get('BillingStreet') + ']]></urn1:physicalstreet>';
        if (updateAcct.get('BillingPostalCode') != null)
            soapXML = soapXML + '<urn1:physicalzip><![CDATA[' + updateAcct.get('BillingPostalCode') + ']]></urn1:physicalzip>';
        if (updateAcct.get('Billingcountry') != null)
            soapXML = soapXML + '<urn1:physicalcountry><![CDATA[' + updateAcct.get('Billingcountry') + ']]></urn1:physicalcountry>';
        if (updateAcct.get('Global_Parent_Segment__c') != null)
            soapXML = soapXML + '<urn1:globalparentsegment><![CDATA[' + updateAcct.get('Global_Parent_Segment__c') + ']]></urn1:globalparentsegment>';
        if (updateAcct.get('Name') != null)
            soapXML = soapXML + '<urn1:accountname><![CDATA[' + updateAcct.get('Name') + ']]></urn1:accountname>';
        if (updateAcct.get('Country_Picklist__c') != null)
            soapXML = soapXML + '<urn1:countrypicklist><![CDATA[' + updateAcct.get('Country_Picklist__c') + ']]></urn1:countrypicklist>';
        if (updateAcct.get('billingcity') != null)
            soapXML = soapXML + '<urn1:physicalcity><![CDATA[' + updateAcct.get('billingcity') + ']]></urn1:physicalcity>';
        if (updateAcct.get('Is_Primary_Account__c') != null)
            soapXML = soapXML + '<urn1:splitprimaryaccount><![CDATA[' + updateAcct.get('Is_Primary_Account__c') + ']]></urn1:splitprimaryaccount>';
        if (updateAcct.get('Global_Parent_SIC_2_digit__c') != null)
            soapXML = soapXML + '<urn1:globalparentsic2Digit><![CDATA[' + updateAcct.get('Global_Parent_SIC_2_digit__c') + ']]></urn1:globalparentsic2Digit>';
        if (updateAcct.get('Global_Parent_SIC_4_digit__c') != null)
            soapXML = soapXML + '<urn1:globalparentsic4Digit><![CDATA[' + updateAcct.get('Global_Parent_SIC_4_digit__c') + ']]></urn1:globalparentsic4Digit>';
        if (updateAcct.get('Global_Parent_Industry__c') != null)
            soapXML = soapXML + '<urn1:globalparentindustry><![CDATA[' + updateAcct.get('Global_Parent_Industry__c') + ']]></urn1:globalparentindustry>';
        if (updateAcct.get('RecordType') != null)
            soapXML = soapXML + '<urn1:accountrecordtype><![CDATA[' + updateAcct.get('RecordType') + ']]></urn1:accountrecordtype>';
        if (updateAcct.get('Customer_Category__c') != null)
            soapXML = soapXML + '<urn1:accounttype><![CDATA[' + updateAcct.get('Customer_Category__c') + ']]></urn1:accounttype>';
        if (updateAcct.get('Website') != null)
            soapXML = soapXML + '<urn1:website><![CDATA[' + updateAcct.get('Website') + ']]></urn1:website>';
        if (updateAcct.get('Alliance__c') != null)
            soapXML = soapXML + '<urn1:alliance><![CDATA[' + updateAcct.get('Alliance__c') + ']]></urn1:alliance>';
        if (updateAcct.get('Alliance_Type__c') != null)
            soapXML = soapXML + '<urn1:alliancetype><![CDATA[' + updateAcct.get('Alliance_Type__c') + ']]></urn1:alliancetype>';
        if (updateAcct.get('Alliance_Program_Level__c') != null)
            soapXML = soapXML + '<urn1:allianceprogramlevel><![CDATA[' + updateAcct.get('Alliance_Program_Level__c') + ']]></urn1:allianceprogramlevel>';
        if (updateAcct.get('CPMS_ID__c') != null)
            soapXML = soapXML + '<urn1:cpmshqid><![CDATA[' + updateAcct.get('CPMS_ID__c') + ']]></urn1:cpmshqid>';
        if (updateAcct.get('Velocity_Seller__c') != null)
            soapXML = soapXML + '<urn1:datamanagement><![CDATA[' + updateAcct.get('Velocity_Seller__c') + ']]></urn1:datamanagement>';
        if (updateAcct.get('Velocity_Seller_Type__c') != null)
            soapXML = soapXML + '<urn1:dmtype><![CDATA[' + updateAcct.get('Velocity_Seller_Type__c') + ']]></urn1:dmtype>';
        if (updateAcct.get('Velocity_Seller_Program_Level__c') != null)
            soapXML = soapXML + '<urn1:dmprogramlevel><![CDATA[' + updateAcct.get('Velocity_Seller_Program_Level__c') + ']]></urn1:dmprogramlevel>';
        if (updateAcct.get('rtm__c') != null)
            soapXML = soapXML + '<urn1:routetomarket><![CDATA[' + updateAcct.get('rtm__c') + ']]></urn1:routetomarket>';
        if (updateAcct.get('Service_Provider__c') != null)
            soapXML = soapXML + '<urn1:serviceprovider><![CDATA[' + updateAcct.get('Service_Provider__c') + ']]></urn1:serviceprovider>';
        if (updateAcct.get('Service_Provider_Type__c') != null)
            soapXML = soapXML + '<urn1:serviceprovidertype><![CDATA[' + updateAcct.get('Service_Provider_Type__c') + ']]></urn1:serviceprovidertype>';
        if (updateAcct.get('Service_Provider_Program_level__c') != null)
            soapXML = soapXML + '<urn1:spprogramlevel><![CDATA[' + updateAcct.get('Service_Provider_Program_level__c') + ']]></urn1:spprogramlevel>';
        if (updateAcct.get('Solution_Provider__c') != null)
            soapXML = soapXML + '<urn1:solutionprovider><![CDATA[' + updateAcct.get('Solution_Provider__c') + ']]></urn1:solutionprovider>';
        if (updateAcct.get('Solution_Provider_Type__c') != null)
            soapXML = soapXML + '<urn1:sptype><![CDATA[' + updateAcct.get('Solution_Provider_Type__c') + ']]></urn1:sptype>';
        if (updateAcct.get('Solution_Provider_Program_Level__c') != null)
            soapXML = soapXML + '<urn1:solutionproviderprogramlevel><![CDATA[' + updateAcct.get('Solution_Provider_Program_Level__c') + ']]></urn1:solutionproviderprogramlevel>';


        soapXML = soapXML + '<urn1:keyMapping>';
        soapXML = soapXML + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
        soapXML = soapXML + '<urn2:remoteKey>' + updateAcct.get('Id') + '</urn2:remoteKey>';
        soapXML = soapXML + '</urn1:keyMapping>';
        if (updateAcct.get('Enterprise_ID__c') != null) {
            soapXML = soapXML + '<urn1:keyMapping>';
            soapXML = soapXML + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML = soapXML + '<urn2:remoteKey>' + updateAcct.get('Enterprise_ID__c') + '</urn2:remoteKey>';
            soapXML = soapXML + '</urn1:keyMapping>';
        }
        soapXML = soapXML + '</urn1:ACCOUNTS__Create>';
        soapXML = soapXML + '</urn:ACCOUNTS>';
        soapXML = soapXML + '<urn:reposInfo>';
        soapXML = soapXML + '<urn3:dataLang>English [US]</urn3:dataLang>';
        soapXML = soapXML + '<urn3:repositoryName>ZCustomer</urn3:repositoryName>';
        soapXML = soapXML + '<urn3:serverName>' + System.Label.MDM_Server_Name + '</urn3:serverName>';
        soapXML = soapXML + '</urn:reposInfo>';
        soapXML = soapXML + '<urn:configurationParameters>';
        soapXML = soapXML + '<urn2:checkoutAsNew>NONE</urn2:checkoutAsNew>';
        soapXML = soapXML + '</urn:configurationParameters>';
        soapXML = soapXML + '</urn:createACCOUNTS>';
        soapXML = soapXML + '</soapenv:Body>';
        soapXML = soapXML + '</soapenv:Envelope>';

        system.debug('insert soapXML=' + soapXML);
        return soapXML;
    }

    public static String getUpdateSOAPXML(Map < String, String > updateAcct, Map < Id, String > userId_pmfKey_map, String remoteKey, String remoteKeyValue) {
        System.debug('************************' + updateAcct);
        system.debug('updateAcct.get(Sales_Volume__c)=' + updateAcct.get('Sales_Volume__c'));
        String soapXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ACCOUNTVi" xmlns:urn1="urn:com.sap.mdm.ws.beans.account" xmlns:urn2="urn:com.sap.mdm.ws.beans" xmlns:urn3="urn:com.sap.mdm.core.beans">';
        soapXML = soapXML + '<soapenv:Header/>';
        soapXML = soapXML + '<soapenv:Body>';
        soapXML = soapXML + '<urn:updateACCOUNTS>';
        soapXML = soapXML + '<urn:ACCOUNTS>';
        soapXML = soapXML + '<urn1:ACCOUNTS__Update>';
        if (updateAcct.get('Enterprise_ID__c') != null)
            soapXML = soapXML + '<urn1:caaccountid>' + updateAcct.get('Enterprise_ID__c') + '</urn1:caaccountid>';
        if (updateAcct.get('Enterprise_Account_Name__c') != null)
            soapXML = soapXML + '<urn1:caaccountname><![CDATA[' + updateAcct.get('Enterprise_Account_Name__c') + ']]></urn1:caaccountname>';
        if (updateAcct.get('GU_DUNS_NUMBER__c') != null)
            soapXML = soapXML + '<urn1:globalparentnumber><![CDATA[' + updateAcct.get('GU_DUNS_NUMBER__c') + ']]></urn1:globalparentnumber>';
        if (updateAcct.get('GU_NAME__c') != null)
            soapXML = soapXML + '<urn1:globalparentname><![CDATA[' + updateAcct.get('GU_NAME__c') + ']]></urn1:globalparentname>';
        if (updateAcct.get('Segment__c') != null)
            soapXML = soapXML + '<urn1:segment><![CDATA[' + updateAcct.get('Segment__c') + ']]></urn1:segment>';
        if (updateAcct.get('GEO__c') != null)
            soapXML = soapXML + '<urn1:geo><![CDATA[' + updateAcct.get('GEO__c') + ']]></urn1:geo>';
        if (updateAcct.get('Sales_Area__c') != null)
            soapXML = soapXML + '<urn1:operatingarea><![CDATA[' + updateAcct.get('Sales_Area__c') + ']]></urn1:operatingarea>';
        if (updateAcct.get('Sales_Region__c') != null)
            soapXML = soapXML + '<urn1:salesregion><![CDATA[' + updateAcct.get('Sales_Region__c') + ']]></urn1:salesregion>';
        if (updateAcct.get('REGION_COUNTRY__C') != null)
            soapXML = soapXML + '<urn1:territory><![CDATA[' + updateAcct.get('REGION_COUNTRY__C') + ']]></urn1:territory>';

        if (updateAcct.get('OwnerId') != null && userId_pmfKey_map.get(updateAcct.get('OwnerId')) != null)
            soapXML = soapXML + '<urn1:accountowner><![CDATA[' + userId_pmfKey_map.get(updateAcct.get('OwnerId')) + ']]></urn1:accountowner>';

        if (updateAcct.get('Account_Type1__c') != null)
            soapXML = soapXML + '<urn1:accounttype1><![CDATA[' + updateAcct.get('Account_Type1__c') + ']]></urn1:accounttype1>';
        if (updateAcct.get('Account_Type__c') != null)
            soapXML = soapXML + '<urn1:accounttype2><![CDATA[' + updateAcct.get('Account_Type__c') + ']]></urn1:accounttype2>';
        if (updateAcct.get('Account_Status__c') != null)
            soapXML = soapXML + '<urn1:accountstatus><![CDATA[' + updateAcct.get('Account_Status__c') + ']]></urn1:accountstatus>';
        if (updateAcct.get('Coverage_Model__c') != null)
            soapXML = soapXML + '<urn1:coveragemodel><![CDATA[' + updateAcct.get('Coverage_Model__c') + ']]></urn1:coveragemodel>';
        if (updateAcct.get('Sales_Volume__c') != null)
            soapXML = soapXML + '<urn1:salesvolume><![CDATA[' + updateAcct.get('Sales_Volume__c') + ']]></urn1:salesvolume>';
        if (updateAcct.get('NumberOfEmployees') != null)
            soapXML = soapXML + '<urn1:employees><![CDATA[' + updateAcct.get('NumberOfEmployees') + ']]></urn1:employees>';
        if (updateAcct.get('Sic') != null)
            soapXML = soapXML + '<urn1:siccode><![CDATA[' + updateAcct.get('Sic') + ']]></urn1:siccode>';
        if (updateAcct.get('SicDesc') != null)
            soapXML = soapXML + '<urn1:sicdesc><![CDATA[' + updateAcct.get('SicDesc') + ']]></urn1:sicdesc>';
        if (updateAcct.get('CreatedDate') != null)
            soapXML = soapXML + '<urn1:createddate><![CDATA[' + updateAcct.get('CreatedDate') + ']]></urn1:createddate>';
        if (updateAcct.get('CreatedById') != null)
            soapXML = soapXML + '<urn1:createdbyid><![CDATA[' + updateAcct.get('CreatedById') + ']]></urn1:createdbyid>';
        if (updateAcct.get('LastModifiedDate') != null)
            soapXML = soapXML + '<urn1:lastmodifieddate><![CDATA[' + updateAcct.get('LastModifiedDate') + ']]></urn1:lastmodifieddate>';
        if (updateAcct.get('LastModifiedById') != null)
            soapXML = soapXML + '<urn1:lastmodifiedbyid><![CDATA[' + updateAcct.get('LastModifiedById') + ']]></urn1:lastmodifiedbyid>';
        if (updateAcct.get('IsDeleted') != null)
            soapXML = soapXML + '<urn1:isdeleted><![CDATA[' + updateAcct.get('IsDeleted') + ']]></urn1:isdeleted>';
        if (updateAcct.get('RecordTypeId') != null)
            soapXML = soapXML + '<urn1:recordtypeid><![CDATA[' + updateAcct.get('RecordTypeId') + ']]></urn1:recordtypeid>';
        if (updateAcct.get('Id') != null)
            soapXML = soapXML + '<urn1:sfdcaccountid><![CDATA[' + updateAcct.get('Id') + ']]></urn1:sfdcaccountid>';
        if (updateAcct.get('Billingstate') != null)
            soapXML = soapXML + '<urn1:physicalstate><![CDATA[' + updateAcct.get('Billingstate') + ']]></urn1:physicalstate>';
        if (updateAcct.get('BillingStreet') != null)
            soapXML = soapXML + '<urn1:physicalstreet><![CDATA[' + updateAcct.get('BillingStreet') + ']]></urn1:physicalstreet>';
        if (updateAcct.get('BillingPostalCode') != null)
            soapXML = soapXML + '<urn1:physicalzip><![CDATA[' + updateAcct.get('BillingPostalCode') + ']]></urn1:physicalzip>';
        if (updateAcct.get('Billingcountry') != null)
            soapXML = soapXML + '<urn1:physicalcountry><![CDATA[' + updateAcct.get('Billingcountry') + ']]></urn1:physicalcountry>';
        if (updateAcct.get('Global_Parent_Segment__c') != null)
            soapXML = soapXML + '<urn1:globalparentsegment><![CDATA[' + updateAcct.get('Global_Parent_Segment__c') + ']]></urn1:globalparentsegment>';
        if (updateAcct.get('Name') != null)
            soapXML = soapXML + '<urn1:accountname><![CDATA[' + updateAcct.get('Name') + ']]></urn1:accountname>';
        if (updateAcct.get('Country_Picklist__c') != null)
            soapXML = soapXML + '<urn1:countrypicklist><![CDATA[' + updateAcct.get('Country_Picklist__c') + ']]></urn1:countrypicklist>';
        if (updateAcct.get('billingcity') != null)
            soapXML = soapXML + '<urn1:physicalcity><![CDATA[' + updateAcct.get('billingcity') + ']]></urn1:physicalcity>';
        if (updateAcct.get('Is_Primary_Account__c') != null)
            soapXML = soapXML + '<urn1:splitprimaryaccount><![CDATA[' + updateAcct.get('Is_Primary_Account__c') + ']]></urn1:splitprimaryaccount>';
        if (updateAcct.get('Global_Parent_SIC_2_digit__c') != null)
            soapXML = soapXML + '<urn1:globalparentsic2Digit><![CDATA[' + updateAcct.get('Global_Parent_SIC_2_digit__c') + ']]></urn1:globalparentsic2Digit>';
        if (updateAcct.get('Global_Parent_SIC_4_digit__c') != null)
            soapXML = soapXML + '<urn1:globalparentsic4Digit><![CDATA[' + updateAcct.get('Global_Parent_SIC_4_digit__c') + ']]></urn1:globalparentsic4Digit>';
        if (updateAcct.get('Global_Parent_Industry__c') != null)
            soapXML = soapXML + '<urn1:globalparentindustry><![CDATA[' + updateAcct.get('Global_Parent_Industry__c') + ']]></urn1:globalparentindustry>';
        if (updateAcct.get('RecordType') != null)
            soapXML = soapXML + '<urn1:accountrecordtype><![CDATA[' + updateAcct.get('RecordType') + ']]></urn1:accountrecordtype>';
        if (updateAcct.get('Customer_Category__c') != null)
            soapXML = soapXML + '<urn1:accounttype><![CDATA[' + updateAcct.get('Customer_Category__c') + ']]></urn1:accounttype>';
        if (updateAcct.get('Website') != null)
            soapXML = soapXML + '<urn1:website><![CDATA[' + updateAcct.get('Website') + ']]></urn1:website>';
        if (updateAcct.get('Alliance__c') != null)
            soapXML = soapXML + '<urn1:alliance><![CDATA[' + updateAcct.get('Alliance__c') + ']]></urn1:alliance>';
        if (updateAcct.get('Alliance_Type__c') != null)
            soapXML = soapXML + '<urn1:alliancetype><![CDATA[' + updateAcct.get('Alliance_Type__c') + ']]></urn1:alliancetype>';
        if (updateAcct.get('Alliance_Program_Level__c') != null)
            soapXML = soapXML + '<urn1:allianceprogramlevel><![CDATA[' + updateAcct.get('Alliance_Program_Level__c') + ']]></urn1:allianceprogramlevel>';
        if (updateAcct.get('CPMS_ID__c') != null)
            soapXML = soapXML + '<urn1:cpmshqid><![CDATA[' + updateAcct.get('CPMS_ID__c') + ']]></urn1:cpmshqid>';
        if (updateAcct.get('Velocity_Seller__c') != null)
            soapXML = soapXML + '<urn1:datamanagement><![CDATA[' + updateAcct.get('Velocity_Seller__c') + ']]></urn1:datamanagement>';
        if (updateAcct.get('Velocity_Seller_Type__c') != null)
            soapXML = soapXML + '<urn1:dmtype><![CDATA[' + updateAcct.get('Velocity_Seller_Type__c') + ']]></urn1:dmtype>';
        if (updateAcct.get('Velocity_Seller_Program_Level__c') != null)
            soapXML = soapXML + '<urn1:dmprogramlevel><![CDATA[' + updateAcct.get('Velocity_Seller_Program_Level__c') + ']]></urn1:dmprogramlevel>';
        if (updateAcct.get('rtm__c') != null)
            soapXML = soapXML + '<urn1:routetomarket><![CDATA[' + updateAcct.get('rtm__c') + ']]></urn1:routetomarket>';
        if (updateAcct.get('Service_Provider__c') != null)
            soapXML = soapXML + '<urn1:serviceprovider><![CDATA[' + updateAcct.get('Service_Provider__c') + ']]></urn1:serviceprovider>';
        if (updateAcct.get('Service_Provider_Type__c') != null)
            soapXML = soapXML + '<urn1:serviceprovidertype><![CDATA[' + updateAcct.get('Service_Provider_Type__c') + ']]></urn1:serviceprovidertype>';
        if (updateAcct.get('Service_Provider_Program_level__c') != null)
            soapXML = soapXML + '<urn1:spprogramlevel><![CDATA[' + updateAcct.get('Service_Provider_Program_level__c') + ']]></urn1:spprogramlevel>';
        if (updateAcct.get('Solution_Provider__c') != null)
            soapXML = soapXML + '<urn1:solutionprovider><![CDATA[' + updateAcct.get('Solution_Provider__c') + ']]></urn1:solutionprovider>';
        if (updateAcct.get('Solution_Provider_Type__c') != null)
            soapXML = soapXML + '<urn1:sptype><![CDATA[' + updateAcct.get('Solution_Provider_Type__c') + ']]></urn1:sptype>';
        if (updateAcct.get('Solution_Provider_Program_Level__c') != null)
            soapXML = soapXML + '<urn1:solutionproviderprogramlevel><![CDATA[' + updateAcct.get('Solution_Provider_Program_Level__c') + ']]></urn1:solutionproviderprogramlevel>';


        if (updateAcct.get('Enterprise_ID__c') != null) {
            soapXML = soapXML + '<urn1:keyMapping>';
            soapXML = soapXML + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML = soapXML + '<urn2:remoteKey>' + updateAcct.get('Enterprise_ID__c') + '</urn2:remoteKey>';
            soapXML = soapXML + '</urn1:keyMapping>';
        }

        soapXML = soapXML + '<urn1:recordIdentification>';

        if ((remotekey != null && remotekeyvalue != null)) {
            soapXML = soapXML + '<urn1:keyMapping>';
            soapXML = soapXML + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML = soapXML + '<urn2:remoteKey>' + remotekeyvalue + '</urn2:remoteKey>';
            soapXML = soapXML + '</urn1:keyMapping>';
        } else {
            soapXML = soapXML + '<urn1:keyMapping>';
            soapXML = soapXML + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML = soapXML + '<urn2:remoteKey>' + updateAcct.get('Id') + '</urn2:remoteKey>';
            soapXML = soapXML + '</urn1:keyMapping>';
        }
        soapXML = soapXML + '</urn1:recordIdentification>';
        soapXML = soapXML + '</urn1:ACCOUNTS__Update>';
        soapXML = soapXML + '</urn:ACCOUNTS>';
        soapXML = soapXML + '<urn:reposInfo>';
        soapXML = soapXML + '<urn3:dataLang>English [US]</urn3:dataLang>';
        soapXML = soapXML + '<urn3:repositoryName>ZCustomer</urn3:repositoryName>';
        soapXML = soapXML + '<urn3:serverName>' + System.Label.MDM_Server_Name + '</urn3:serverName>';
        soapXML = soapXML + '</urn:reposInfo>';
        soapXML = soapXML + '<urn:configurationParameters><urn2:applyNullValuesToMdm>true</urn2:applyNullValuesToMdm></urn:configurationParameters>';
        soapXML = soapXML + '</urn:updateACCOUNTS>';
        soapXML = soapXML + '</soapenv:Body>';
        soapXML = soapXML + '</soapenv:Envelope>';


        system.debug('update soapXML=' + soapXML);
        return soapXML;
    }

    @
    Future(callout = true)
    public static void callMDMWebserviceForSingleRequest(Map < String, String > updateAcct, Map < Id, String > userId_pmfKey_map) {
        String respXML = '<?xml version="1.0" encoding="utf-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SOAP-ENV:Body xmlns:rpl="urn:ACCOUNTVi">    <rpl:updateVT_ACCOUNTSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans" xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base"' +
            ' xmlns:rn4="urn:com.sap.mdm.ws.beans.account" xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>OK</rn1:status><rn1:description>Record was updated</rn1:description>' +
            '<rn1:dataObject>6486</rn1:dataObject></rn1:ExecutionStatus></rpl:Response></rpl:updateVT_ACCOUNTSResponse>  </SOAP-ENV:Body></SOAP-ENV:Envelope>';

        Map < String, String > respDetails = null;
        String status = null;
        String data = null;
        String error = null;
        boolean isExists = false;
        String remoteKey = null;
        String remoteKeyValue = null;
        respDetails = accountExists(updateAcct.get('Id'), updateAcct.get('Enterprise_ID__c'));
        if (respDetails != null) {
            status = respDetails.get('STATUS');
            data = respDetails.get('DATA');
            error = respDetails.get('ERROR');
            if (respDetails.get('caaccountid') != null) {
                remoteKey = 'caaccountid';
                remoteKeyValue = respDetails.get('caaccountid');
            }
            if (respDetails.get('sfdcaccountid') != null) {
                remoteKey = 'sfdcaccountid';
                remoteKeyValue = respDetails.get('sfdcaccountid');
            }
            if (status == 'OK') {
                if (data.indexOf('1..') != -1) {
                    isExists = true;
                }
                if (isExists) {

                    String soapXML = getUpdateSOAPXML(updateAcct, userId_pmfKey_map, remotekey, remotekeyvalue);
                    String respBody = '';
                    if (!Test.isRunningTest()) {
                        respBody = callWebService(soapXML, updateAcct.get('Enterprise_ID__c'), updateAcct.get('Id'));
                    } else {
                        respBody = respXML;
                    }
                    if (respBody != null) {
                        respDetails = parseResponseXML(respBody);
                        status = respDetails.get('STATUS');
                        data = respDetails.get('DATA');
                        error = respDetails.get('ERROR');
                    }
                } else {
                    String soapXML = getInsertSOAPXML(updateAcct, userId_pmfKey_map);
                    String respBody = '';
                    if (!Test.isRunningTest()) {
                        respBody = callWebService(soapXML, updateAcct.get('Enterprise_ID__c'), updateAcct.get('Id'));
                    } else {
                        respBody = respXML;
                    }
                    if (respBody != null) {
                        respDetails = parseResponseXML(respBody);
                        status = respDetails.get('STATUS');
                        data = respDetails.get('DATA');
                        error = respDetails.get('ERROR');
                    }
                }
            } else {
                sendEmail(error, System.Label.MDM_Server_Name + ' - Search Failed - ' + updateAcct.get('Enterprise_ID__c'));
            }
        }
        //if(updateAcct.get('DUNS_NUMBER__c') != null){
        if (updateAcct.get('GU_DUNS_NUMBER__c') != null) {
            String dunsResp = '';
            dunsResp = callEAIService(updateAcct.get('GU_DUNS_NUMBER__c'), updateAcct.get('Id'));
            System.debug('____dunsResp' + dunsResp);
        }
    }


    public static void callMDMWebserviceRequest(Map < String, String > updateAcct, Map < Id, String > userId_pmfKey_map) {
        String respXML = '<?xml version="1.0" encoding="utf-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SOAP-ENV:Body xmlns:rpl="urn:ACCOUNTVi">    <rpl:updateVT_ACCOUNTSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans" xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base"' +
            ' xmlns:rn4="urn:com.sap.mdm.ws.beans.account" xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>OK</rn1:status><rn1:description>Record was updated</rn1:description>' +
            '<rn1:dataObject>6486</rn1:dataObject></rn1:ExecutionStatus></rpl:Response></rpl:updateVT_ACCOUNTSResponse>  </SOAP-ENV:Body></SOAP-ENV:Envelope>';
        Map < String, String > respDetails = null;
        String status = null;
        String data = null;
        String error = null;
        boolean isExists = false;
        String remoteKey = null;
        String remoteKeyValue = null;
        respDetails = accountExists(updateAcct.get('Id'), updateAcct.get('Enterprise_ID__c'));
        if (respDetails != null) {
            status = respDetails.get('STATUS');
            data = respDetails.get('DATA');
            error = respDetails.get('ERROR');
            if (respDetails.get('caaccountid') != null) {
                remoteKey = 'caaccountid';
                remoteKeyValue = respDetails.get('caaccountid');
            }
            if (respDetails.get('sfdcaccountid') != null) {
                remoteKey = 'sfdcaccountid';
                remoteKeyValue = respDetails.get('sfdcaccountid');
            }
            if (status == 'OK') {
                if (data.indexOf('1..') != -1) {
                    isExists = true;
                }
                if (isExists) {

                    String soapXML = getUpdateSOAPXML(updateAcct, userId_pmfKey_map, remotekey, remotekeyvalue);
                    String respBody = '';
                    if (!Test.isRunningTest()) {
                        respBody = callWebService(soapXML, updateAcct.get('Enterprise_ID__c'), updateAcct.get('Id'));
                    } else {
                        respBody = respXML;
                    }
                    if (respBody != null) {
                        respDetails = parseResponseXML(respBody);
                        status = respDetails.get('STATUS');
                        data = respDetails.get('DATA');
                        error = respDetails.get('ERROR');
                    }
                } else {
                    String soapXML = getInsertSOAPXML(updateAcct, userId_pmfKey_map);
                    String respBody = '';
                    if (!Test.isRunningTest()) {
                        respBody = callWebService(soapXML, updateAcct.get('Enterprise_ID__c'), updateAcct.get('Id'));
                    } else {
                        respBody = respXML;
                    }
                    if (respBody != null) {
                        respDetails = parseResponseXML(respBody);
                        status = respDetails.get('STATUS');
                        data = respDetails.get('DATA');
                        error = respDetails.get('ERROR');
                    }
                }
            } else {
                sendEmail(error, System.Label.MDM_Server_Name + ' - Search Failed - ' + updateAcct.get('Enterprise_ID__c'));
            }
        }
        //if(updateAcct.get('DUNS_NUMBER__c') != null){
        if (updateAcct.get('GU_DUNS_NUMBER__c') != null) {
            String dunsResp = '';
            dunsResp = callEAIService(updateAcct.get('GU_DUNS_NUMBER__c'), updateAcct.get('Id'));
        }
    }

    /*public Map<String,String> isAnyValidFieldUpdated(Account oldAcct, Account newAcct) {
        Map<String,String> acctMap = new Map<String,String>();
        if(oldAcct.Enterprise_ID__c != newAcct.Enterprise_ID__c) {
             acctMap.put('Enterprise_ID__c',newAcct.Enterprise_ID__c);
        }
        if(oldAcct.Enterprise_Account_Name__c != newAcct.Enterprise_Account_Name__c) 
        {
            String acctName = newAcct.Enterprise_Account_Name__c;
            if(acctName.length() > 60)
                acctName = acctName.substring(0, 60);
            acctMap.put('Enterprise_Account_Name__c',acctName);
        }
        if(oldAcct.GU_DUNS_NUMBER__c != newAcct.GU_DUNS_NUMBER__c) {
            acctMap.put('GU_DUNS_NUMBER__c',newAcct.GU_DUNS_NUMBER__c != null ? newAcct.GU_DUNS_NUMBER__c : '');
        }
        if(oldAcct.GU_NAME__c != newAcct.GU_NAME__c) {
            acctMap.put('GU_NAME__c',newAcct.GU_NAME__c != null ? newAcct.GU_NAME__c : '');
        }
        if(oldAcct.Segment__c != newAcct.Segment__c) {
            acctMap.put('Segment__c',newAcct.Segment__c != null ? newAcct.Segment__c : '' );
        }
        if(oldAcct.GEO__c != newAcct.GEO__c) {
            acctMap.put('GEO__c',newAcct.GEO__c != null ? newAcct.GEO__c : '');
        }
        if(oldAcct.Sales_Area__c != newAcct.Sales_Area__c) {
            acctMap.put('Sales_Area__c',newAcct.Sales_Area__c != null ? newAcct.Sales_Area__c : '');
        }
        if(oldAcct.Sales_Region__c != newAcct.Sales_Region__c) {
            acctMap.put('Sales_Region__c',newAcct.Sales_Region__c != null ? newAcct.Sales_Region__c : '');
        }
        if(oldAcct.Country_ISO_code__c != newAcct.Country_ISO_code__c) {
            acctMap.put('Country_ISO_code__c',newAcct.Country_ISO_code__c != null ? newAcct.Country_ISO_code__c : '');
        }
        if(oldAcct.OwnerId != newAcct.OwnerId) {
            acctMap.put('OwnerId',newAcct.OwnerId != null ? newAcct.OwnerId : '');
        }
        if(oldAcct.Account_Type1__c != newAcct.Account_Type1__c) {
            acctMap.put('Account_Type1__c',newAcct.Account_Type1__c != null ? newAcct.Account_Type1__c : '');
        }
        if(oldAcct.Account_Type__c != newAcct.Account_Type__c) {
            acctMap.put('Account_Type__c',newAcct.Account_Type__c != null ? newAcct.Account_Type__c : '');
        }
        if(oldAcct.Account_Status__c != newAcct.Account_Status__c) {
            acctMap.put('Account_Status__c',newAcct.Account_Status__c != null ? newAcct.Account_Status__c : '');
        }
        if(oldAcct.Coverage_Model__c != newAcct.Coverage_Model__c) {
            acctMap.put('Coverage_Model__c',newAcct.Coverage_Model__c != null ? newAcct.Coverage_Model__c : '');
        }
        if(oldAcct.Sales_Volume__c != newAcct.Sales_Volume__c) {
            acctMap.put('Sales_Volume__c',newAcct.Sales_Volume__c != null ? String.valueOf(newAcct.Sales_Volume__c) : '');
        }
        if(oldAcct.NumberOfEmployees != newAcct.NumberOfEmployees) {
            acctMap.put('NumberOfEmployees',newAcct.NumberOfEmployees != null ? String.valueOf(newAcct.NumberOfEmployees) : '');
        }
        if(oldAcct.Sic != newAcct.Sic) {
            acctMap.put('Sic',newAcct.Sic != null ? newAcct.Sic : '');
        }
        if(oldAcct.SicDesc != newAcct.SicDesc) {
            acctMap.put('SicDesc',newAcct.SicDesc != null ? newAcct.SicDesc : '');
        }
        if(oldAcct.SLED_Area__c != newAcct.SLED_Area__c) {
            acctMap.put('SLED_Area__c',newAcct.SLED_Area__c != null ? newAcct.SLED_Area__c : '');
        }
        if(oldAcct.IsDeleted != newAcct.IsDeleted) {
            acctMap.put('IsDeleted',newAcct.IsDeleted ? 'TRUE' : 'FALSE');
        }
        if(oldAcct.RecordTypeId != newAcct.RecordTypeId) {
            acctMap.put('RecordTypeId',newAcct.RecordTypeId != null ? newAcct.RecordTypeId : '');
        }
        if(oldAcct.Billingstate != newAcct.Billingstate) {
            acctMap.put('Billingstate',newAcct.Billingstate != null ? newAcct.Billingstate : '');
        }
        if(oldAcct.BillingStreet != newAcct.BillingStreet) {
            acctMap.put('BillingStreet',newAcct.BillingStreet != null ? newAcct.BillingStreet : '');
        }
        if(oldAcct.BillingPostalCode != newAcct.BillingPostalCode) {
            acctMap.put('BillingPostalCode',newAcct.BillingPostalCode != null ? newAcct.BillingPostalCode : '');
        }
        if(oldAcct.Billingcountry != newAcct.Billingcountry) {
            acctMap.put('Billingcountry',newAcct.Billingcountry != null ? newAcct.Billingcountry : '');
        }
        acctMap.put('Id',newAcct.Id);
        acctMap.put('CreatedById',newAcct.CreatedById);
        acctMap.put('CreatedDate',getValidDateFormat(newAcct.CreatedDate));
        acctMap.put('LastModifiedById',newAcct.LastModifiedById);
        acctMap.put('LastModifiedDate',getValidDateFormat(newAcct.LastModifiedDate));
        return acctMap;
    }*/

    public static void sendEmail(String errorMessage, String subject) {
        try {
            List < String > toList = new List < String > ();
            toList.add(System.Label.MDM_Email_Address);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toList);
            email.setSubject(subject);
            email.setPlainTextBody(errorMessage);
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                email
            });
        } catch (Exception e) {

        }
    }

    @
    isTest(SeeAllData = true)
    public static void AccountChangesPushToMDM_Test() {

        RecordType[] recacc = [select Id from Recordtype where IsActive = true and SObjectType = 'Account'
            and Name in ('Account Team Covered Account')
        ];
        Account oldAcct = new Account(Name = 'TestAcc1', RecordTypeId = recacc[0].Id, Enterprise_Id__c = 'ZZ00005', Enterprise_Account_Name__c = 'Test Acct Name',
            GU_DUNS_NUMBER__c = '12345678', GU_NAME__c = 'Test GU Name', GEO__c = 'EMEA',
            Sales_Area__c = 'E-EMEA', Sales_Region__c = 'CA SA', Country_ISO_code__c = 'AO', Account_Type1__c = 'Enterprise Account',
            Account_Type__c = 'SLED', Sales_Volume__c = 12.0, NumberOfEmployees = 200, Sic = 'Test Sic', SicDesc = 'Test Sic Desc',
            SLED_Area__c = 'Test Sled', Billingstate = 'state local', BillingStreet = 'street local', BillingPostalCode = '1213123',
            Billingcountry = 'country local', Account_Status__c = 'Approved');

        //Account oldAcct = [Select Id,RecordTypeId,Enterprise_Id__c,CreatedById,CreatedDate,LastModifiedById,LastModifiedDate, Segment__c = 'Large Existing',, Coverage_Model__c = 'Account Team' from Account where Id = :acc.Id];
        Account updateAcct = new Account(Name = 'TestAcc12');
        updateAcct.Enterprise_Account_Name__c = 'Test Acct Name Updated';
        updateAcct.GU_DUNS_NUMBER__c = '98765432';
        updateAcct.RecordTypeId = recacc[0].Id;
        updateAcct.GU_NAME__c = 'Test Updated';
       // updateAcct.Segment__c = 'Large New';
        updateAcct.GEO__c = 'NA';
        updateAcct.Sales_Area__c = 'SOUTH';
        updateAcct.Sales_Region__c = 'SO_ATLANTA';
        updateAcct.Country_ISO_code__c = 'US';
        updateAcct.Account_Type1__c = 'Reseller Account';
        updateAcct.Account_Type__c = 'Federal';
        updateAcct.Coverage_Model__c = Label.CovModelVal2;
        updateAcct.Sales_Volume__c = 14.0;
        updateAcct.NumberOfEmployees = 1000;
        updateAcct.Sic = 'Sic Updated';
        updateAcct.SicDesc = 'Sic Desc Updated';
        updateAcct.SLED_Area__c = 'SLED Updates';
        updateAcct.Billingstate = 'local state';
        updateAcct.BillingStreet = 'local street';
        updateAcct.BillingPostalCode = '676786';
        updateAcct.Billingcountry = 'local country';

        Set < Id > userIds = new Set < Id > ();
        userIds.add(Userinfo.getUserId());
        List < User > usersList = [Select PMFKey__c from User where Id IN: userIds];
        Map < Id, String > userId_pmfKey_map = new Map < Id, String > ();
        for (User userObj: usersList) {
            userId_pmfKey_map.put(userObj.Id, userObj.PMFKey__c);
        }
        AccountChangesPushToMDM testObj = new AccountChangesPushToMDM();
        Map < String, String > insertMap = testObj.createMapFromObject(oldAcct);
        AccountChangesPushToMDM.getSearchSOAPXML('NA00001', updateAcct.Id);
        AccountChangesPushToMDM.accountExists('NA00001', updateAcct.Id);
        AccountChangesPushToMDM.getInsertSOAPXML(insertMap, userId_pmfKey_map);
        //Map<String,String> updateMap = testObj.isAnyValidFieldUpdated(oldAcct,updateAcct);
        AccountChangesPushToMDM.getUpdateSOAPXML(insertMap, userId_pmfKey_map, null, null);
        String respXML = '<?xml version="1.0" encoding="utf-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SOAP-ENV:Body xmlns:rpl="urn:ACCOUNTVi">    <rpl:updateVT_ACCOUNTSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans" xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base"' +
            ' xmlns:rn4="urn:com.sap.mdm.ws.beans.account" xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>OK</rn1:status><rn1:description>Record was updated</rn1:description>' +
            '<rn1:dataObject>6486</rn1:dataObject></rn1:ExecutionStatus></rpl:Response></rpl:updateVT_ACCOUNTSResponse>  </SOAP-ENV:Body></SOAP-ENV:Envelope>';
        AccountChangesPushToMDM.parseResponseXML(respXML);
        try {
            AccountChangesPushToMDM.callWebService('test', 'test', 'test');
        } catch (Exception e) {

        }
        insert oldAcct;
        Map < Id, Account > oldMap = new Map < Id, Account > ();
        Map < Id, Account > newMap = new Map < Id, Account > ();
        oldMap.put(oldAcct.Id, oldAcct);
        newMap.put(oldAcct.Id, oldAcct);
        testObj.pushAccountUpdatesToMDM(oldMap, newMap);
        delete oldAcct;
    }

}