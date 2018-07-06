public with sharing class SiteAssociationChangesPushToMDM {
    
    public static final integer MAX_COUNT = 500;
    public void pushSiteAssociationChangesToMDM(Map<Id,Site_Association__c> newMap) {
        List<Id> eligibleIds = new List<Id>();
        Map<String,String> accSiteMap = new Map<String,String>();
        String dmUserIds = System.Label.DataMigration_Users;
        String[] users = dmUserIds.split(';');
        Set<String> usersSet = new Set<String>();
        for(String userId : users) {
            usersSet.add(userId);
        }
        for(Id siteAssocId : newMap.keySet()) {
            Site_Association__c newSiteAssoc = newMap.get(siteAssocId);
            if(newSiteAssoc.Site_Status__c == 'Approved' && !usersSet.contains(newSiteAssoc.LastModifiedById) && newSiteAssoc.Enterprise_ID_F__c!=null) {
                eligibleIds.add(siteAssocId);
                accSiteMap.put(siteAssocId,newSiteAssoc.Enterprise_ID__c);
            }
        }
        
        if(eligibleIds.size() == 1) {
            Set<Id> userIds = new Set<Id>();
            for(Id tempId : eligibleIds) {
                userIds.add(newMap.get(tempId).LastModifiedById);
            }
            callAccountSiteAssociationWebService(eligibleIds,userIds,accSiteMap.get(eligibleIds[0]));
         }
        if(eligibleIds.size() > 1) {
            Set<Id> userIds = new Set<Id>();
            for(Id tempId : eligibleIds) {
                userIds.add(newMap.get(tempId).LastModifiedById);
            }
            integer tCount = eligibleIds.size();
            if(tCount > MAX_COUNT) {
                integer nCount = tCount/MAX_COUNT;
                integer temp = 0;
                while(temp <= nCount && temp*MAX_COUNT != tCount) {
                    callSiteAssociationWebService(getSubList(temp, eligibleIds),userIds);
                    temp = temp + 1;
                }
            } else {
                    callSiteAssociationWebService(eligibleIds,userIds);
            }
        }
    }
    
    public void pushSiteAssociationInsertsToMDM(Map<Id,Site_Association__c> newMap) {
        List<Id> eligibleIds = new List<Id>();
        String dmUserIds = System.Label.DataMigration_Users;
        String[] users = dmUserIds.split(';');
        Set<String> usersSet = new Set<String>();
        for(String userId : users) {
            usersSet.add(userId);
        }
        for(Id siteAssocId : newMap.keySet()) {
            Site_Association__c newSiteAssoc = newMap.get(siteAssocId);
            if(!usersSet.contains(newSiteAssoc.CreatedById) ) {
                eligibleIds.add(siteAssocId);
            }
        }
        if(eligibleIds.size() > 0) {
            Set<Id> userIds = new Set<Id>();
            for(Id tempId : eligibleIds) {
                userIds.add(newMap.get(tempId).CreatedById);
            }
            integer tCount = eligibleIds.size();
            if(tCount > MAX_COUNT) {
                integer nCount = tCount/MAX_COUNT;
                integer temp = 0;
                while(temp <= nCount && temp*MAX_COUNT != tCount) {
                    callSiteAssociationWebService_insert(getSubList(temp, eligibleIds),userIds);
                    temp = temp + 1;
                }
            } else {
                    callSiteAssociationWebService_insert(eligibleIds,userIds);
            }
        }
    }
    
    
    public List<Id> getSubList(integer nCount, List<Id> eligibleIds) {
        List<Id> subSet = new List<Id>();
        integer tSize = eligibleIds.size();
        integer starting = nCount*MAX_COUNT;
        integer ending = (nCount+1)*MAX_COUNT;
        if(ending > tSize)
            ending = tSize; 
        while(starting < ending) {
            subSet.add(eligibleIds.get(starting));
            starting = starting + 1;
        }
        return subSet;
    }
    
    public static List<String> parseResponseXML(String respBody) {
        List<String> errors = new List<String>();
        XmlStreamReader reader = new XmlStreamReader(respBody);
        while(reader.hasNext()) {
            String error = '';
            if(reader.getEventType() == XmlTag.START_ELEMENT) {
                if('text' == reader.getLocalName()) {
                    if(reader.hasNext())
                        reader.next();
                    if(reader.getEventType() == XmlTag.CHARACTERS) {
                        error = reader.getText();
                        errors.add(error);
                    }   
                }
            }
            reader.next();
        }
        return errors;
    }
    
    @Future(callout=true)
    public static void callSiteAssociationWebService(List<Id> eligibleIds, Set<Id> userIds) {
        callSiteAssociationWebService_inner(eligibleIds, userIds);
    }
    
    @Future(callout=true)
    public static void callAccountSiteAssociationWebService(List<Id> eligibleIds, Set<Id> userIds, String accid) {
        Map<Id,Account> accMap = new Map<Id,Account>([select id,FromSARecord__c,Account_Status__c,Enterprise_ID__c,Enterprise_Account_Name__c,GU_DUNS_NUMBER__c,GU_NAME__c,Segment__c,GEO__c,Sales_Area__c,Sales_Region__c,REGION_COUNTRY__C,OwnerId,Account_Type1__c,Account_Type__c,Coverage_Model__c,Sales_Volume__c,NumberOfEmployees,Sic,SicDesc,SLED_Area__c,CreatedById,CreatedDate,LastModifiedById,IsDeleted,LastModifiedDate,RecordTypeId,Billingstate,BillingStreet,BillingPostalCode,Billingcountry,Global_Parent_Segment__c,Name,Country_Picklist__c,billingcity,Is_Primary_Account__c,Global_Parent_SIC_2_digit__c,Global_Parent_SIC_4_digit__c,Global_Parent_Industry__c,Customer_Category__c,Website,Alliance__c,Alliance_Type__c,Alliance_Program_Level__c,CPMS_ID__c,Velocity_Seller__c,Velocity_Seller_Type__c,Velocity_Seller_Program_Level__c,rtm__c,Service_Provider__c,Service_Provider_Type__c,Service_Provider_Program_level__c,Solution_Provider__c,Solution_Provider_Type__c,Solution_Provider_Program_Level__c from Account where id=:accid]);
        AccountChangesPushToMDM obj = new AccountChangesPushToMDM();
        obj.pushAccountInsertToMDM(null,accMap);
        callSiteAssociationWebService_inner(eligibleIds, userIds);
    }
    
    public static void callSiteAssociationWebService_inner(List<Id> eligibleIds, Set<Id> userIds) {
        String status = null;
        String data = null;
        String error = null;
         String transactionInsert ='update';
        List<String> errors = null;
        Map<Id,String> id_pmfKey_map = new Map<Id,String>();
        List<User> usersList = [Select PMFKey__c,Id from User where Id IN :userIds];
        for(User userObj : usersList) {
            id_pmfKey_map.put(userObj.Id,userObj.PMFKey__c);
        }
        List<Site_Association__c> siteAssocList = [Select System__c,SAP_Site_ID__c,Enterprise_ID_F__c,LastModifiedById,LastModifiedDate,Id from Site_Association__c where Id IN :eligibleIds];
        String soapXML = getUpdateSOAPXML(siteAssocList,id_pmfKey_map);
        String respBody = '';
        if(!Test.isRunningTest()) {
            respBody = callWebService(soapXML,transactionInsert);
        } else {
            respBody = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:xs="http://www.w3.org/2001/XMLSchema"'+
            ' xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
            '<SOAP-ENV:Body xmlns:rpl="urn:SITEACCOUNTVi"><rpl:updateCUSTOMERSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans"'+
            ' xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base" xmlns:rn4="urn:com.sap.mdm.ws.beans.siteaccount"'+
            ' xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>Fault</rn1:status><rn1:description>Record update '+
            'unsuccessful, see the faults list</rn1:description><rn1:fault><rn1:severity>Error</rn1:severity><rn1:text>Specified key ""ZZ00001"" of the '+
            'remote system ""BW"" could not be identified in table ""VT_ACCOUNTS"" as the value for the field ""ACCOUNT_ID"".</rn1:text></rn1:fault>'+
            '</rn1:ExecutionStatus></rpl:Response></rpl:updateCUSTOMERSResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        }
      
        System.Debug('respBody=' + respBody); 
      
        if(respBody != null) {
            errors = parseResponseXML(respBody);
            if(errors.size() > 0) {
                String errorsStr = '';
                for(String err : errors) {
                    errorsStr = errorsStr + err + '\n';
                }
                sendEmail(errorsStr,System.Label.MDM_Server_Name + ' - Update Failed');
            }
        }
    }
    
    @future(callout=true)
    public static void callSiteAssociationWebService_insert(List<Id> eligibleIds, Set<Id> userIds) {
        String status = null;
        String data = null;
        String error = null;
        String transactionInsert ='insert';
        List<String> errors = null;
        Map<Id,String> id_pmfKey_map = new Map<Id,String>();
        List<User> usersList = [Select PMFKey__c,Id from User where Id IN :userIds];
        for(User userObj : usersList) {
            id_pmfKey_map.put(userObj.Id,userObj.PMFKey__c);
        }
        List<Site_Association__c> siteAssocList = [Select System__c,SAP_Site_ID__c,name,name2__c,street__c,street2__c,street3__c,city__c,postal_code__c,phone__c,confidence_code__c,CreatedById,Enterprise_ID_F__c,Id,State__c,Country_picklist__c from Site_Association__c where Id IN :eligibleIds];
        String soapXML = getInsertSOAPXML(siteAssocList,id_pmfKey_map);
        String respBody = '';
        if(!Test.isRunningTest()) {
            respBody = callWebService(soapXML,transactionInsert);
        } else {
            respBody = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:xs="http://www.w3.org/2001/XMLSchema"'+
            ' xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
            '<SOAP-ENV:Body xmlns:rpl="urn:SITEACCOUNTVi"><rpl:updateCUSTOMERSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans"'+
            ' xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base" xmlns:rn4="urn:com.sap.mdm.ws.beans.siteaccount"'+
            ' xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>Fault</rn1:status><rn1:description>Record update '+
            'unsuccessful, see the faults list</rn1:description><rn1:fault><rn1:severity>Error</rn1:severity><rn1:text>Specified key ""ZZ00001"" of the '+
            'remote system ""BW"" could not be identified in table ""VT_ACCOUNTS"" as the value for the field ""ACCOUNT_ID"".</rn1:text></rn1:fault>'+
            '</rn1:ExecutionStatus></rpl:Response></rpl:updateCUSTOMERSResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        }
      
        System.Debug('respBody=' + respBody); 
      
        if(respBody != null) {
            errors = parseResponseXML(respBody);
            if(errors.size() > 0) {
                String errorsStr = '';
                for(String err : errors) {
                    errorsStr = errorsStr + err + '\n';
                }
                sendEmail(errorsStr,System.Label.MDM_Server_Name + ' - Insert Failed');
            }
        }
    }
    
    public static String callWebService(String soapXML ,String transactionInsert) {
        String respBody = null;
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml; charset=utf-8');
        req.setHeader('Content-Length','2048');
        req.setHeader('Host',System.Label.MDM_Host);
        req.setHeader('Connection','keep-alive');
        String encodedb64usernamepassword = System.Label.MDM_Authorization_Key;
        String authorizationHeader = 'Basic ' + encodedb64usernamepassword;
        req.setHeader('Authorization', authorizationHeader);
        //req.setEndpoint('https://df1ce.ca.com/SITE_SUPPORT/HTTPSBasic?style=document');
        
        //this code is addeds to differnetiate the end points between SiteCreate and SiteUpdate
        
        if(transactionInsert.equalsIgnoreCase('insert'))
            req.setEndpoint(System.Label.MDM_Site_Insert_End_Point_URL);
         else
            req.setEndpoint(System.Label.MDM_Site_End_Point_URL);
        //end of code
        
        System.debug('Request---------------->'+soapXML);
        req.setBody(soapXML);   
        req.setTimeout(60000); // timeout in milliseconds           
        Http http = new Http();
        try {
            HTTPResponse res = http.send(req);
            system.debug('Response--------------->'+res.getBody());
            if(res.getStatusCode() == 200) {
                respBody = res.getBody();
            } else {
                sendEmail(res.getStatus(),System.Label.MDM_Server_Name + ' - Update Failed');
            }
        } catch (Exception e) {
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 200) {
                respBody = res.getBody();
            } else {
                sendEmail(res.getStatus(),System.Label.MDM_Server_Name + ' - Update Failed');
            }
        }                  
        return respBody;
    }
    
    public static String getUpdateSOAPXML(List<Site_Association__c> siteAssocList, Map<Id,String> id_pmfKey_map) {
        String soapXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:SITEACCOUNTVi" xmlns:urn1="urn:com.sap.mdm.ws.beans.siteaccount" xmlns:urn2="urn:com.sap.mdm.ws.beans" xmlns:urn3="urn:com.sap.mdm.core.beans">';
        soapXML = soapXML + '<soapenv:Header/>';
        soapXML = soapXML + '<soapenv:Body>';
        soapXML = soapXML + '<urn:updateCUSTOMERS>';
        soapXML = soapXML + '<urn:CUSTOMERS>';
        for(Site_Association__c updateObj : siteAssocList) {
            String pmfKey = id_pmfKey_map.get(updateObj.LastModifiedById);
            soapXML = soapXML + getInnerUpdateXML(updateObj,pmfkey);
        }
        soapXML = soapXML + '</urn:CUSTOMERS>';
        soapXML = soapXML + '<urn:reposInfo>';
        soapXML = soapXML + '<urn3:dataLang>English [US]</urn3:dataLang>';
        soapXML = soapXML + '<urn3:repositoryName>ZCustomer</urn3:repositoryName>';
        soapXML = soapXML + '<urn3:serverName>'+System.Label.MDM_Server_Name+'</urn3:serverName>';
        soapXML = soapXML + '</urn:reposInfo>';
        soapXML = soapXML + '<urn:configurationParameters>';
        soapXML = soapXML + '<urn2:applyNullValuesToMdm>1</urn2:applyNullValuesToMdm>';
        soapXML = soapXML + '</urn:configurationParameters>';
        soapXML = soapXML + '</urn:updateCUSTOMERS>';
        soapXML = soapXML + '</soapenv:Body>';
        soapXML = soapXML + '</soapenv:Envelope>';
        return soapXML;
    }
    
    public static String getInsertSOAPXML(List<Site_Association__c> siteAssocList, Map<Id,String> id_pmfKey_map) {
        String mdmInstance = System.Label.MDMInstance;
    //  system.debug('mdm instance --------------'+mdmInstance);
        String soapXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:SITE_SUPPORTVi" xmlns:urn1="urn:com.sap.mdm.ws.beans.site_support" xmlns:urn2="urn:com.sap.mdm.ws.beans" xmlns:urn3="urn:com.sap.mdm.core.beans">';
        soapXML = soapXML + '<soapenv:Header/>';
        soapXML = soapXML + '<soapenv:Body>';
        soapXML = soapXML + '<urn:createCUSTOMERS>';
        soapXML = soapXML + '<urn:CUSTOMERS>';
        for(Site_Association__c insertObj : siteAssocList) {

            String pmfKey = id_pmfKey_map.get(insertObj.CreatedById);
            soapXML = soapXML + getInnerInsertXML(insertObj,pmfkey);
        }
        soapXML = soapXML + '</urn:CUSTOMERS>';
        soapXML = soapXML + '<urn:reposInfo>';
        soapXML = soapXML + '<urn3:dataLang>English [US]</urn3:dataLang>';
        soapXML = soapXML + '<urn3:repositoryName>ZCustomer</urn3:repositoryName>';
        soapXML = soapXML + '<urn3:serverName>'+mdmInstance+'</urn3:serverName>';
        soapXML = soapXML + '</urn:reposInfo>';
        soapXML = soapXML + '<urn:configurationParameters>';
        soapXML = soapXML + '<urn2:checkoutAsNew>None</urn2:checkoutAsNew>';
        soapXML = soapXML + '</urn:configurationParameters>';
        soapXML = soapXML + '</urn:createCUSTOMERS>';
        soapXML = soapXML + '</soapenv:Body>';
        soapXML = soapXML + '</soapenv:Envelope>';
        return soapXML;
    }

    
    
    public static String getSiteId(String siteId, String sys) {
        if(sys == 'S')
            return padLeft(siteId);
        return siteId;  
    }
    
    public static String getInnerUpdateXML(Site_Association__c updateObj, String pmfkey) {
        String soapXML1 = '';
        soapXML1 = soapXML1 + '<urn1:CUSTOMERS__Update>';
        soapXML1 = soapXML1 + '<urn1:sMLASTMODIFIEDBYID>'+pmfkey+'</urn1:sMLASTMODIFIEDBYID>';
        soapXML1 = soapXML1 + '<urn1:sMLASTMODIFIEDDATE>'+getValidDateFormat(updateObj.LastModifiedDate)+'</urn1:sMLASTMODIFIEDDATE>';
        soapXML1 = soapXML1 + '<urn1:sFDCID>'+updateObj.Id+'</urn1:sFDCID>';
        //soapXML1 = soapXML1 + '<urn1:aCCOUNT_ID>';
        soapXML1 = soapXML1 + '<urn1:caaccountid>';
        soapXML1 = soapXML1 + '<urn1:recordIdentification>';
        if(updateObj.Enterprise_ID_F__c != null) {
            soapXML1 = soapXML1 + '<urn2:keyMapping>';
            //soapXML1 = soapXML1 + '<urn2:remoteSystem>SAP BI</urn2:remoteSystem>';
            soapXML1 = soapXML1 + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML1 = soapXML1 + '<urn2:remoteKey>'+updateObj.Enterprise_ID_F__c+'</urn2:remoteKey>';
            soapXML1 = soapXML1 + '</urn2:keyMapping>';            
        } else {
            soapXML1 = soapXML1 + '<urn2:internalID></urn2:internalID>';
        }
        soapXML1 = soapXML1 + '</urn1:recordIdentification>';
        //soapXML1 = soapXML1 + '</urn1:aCCOUNT_ID>';
        soapXML1 = soapXML1 + '</urn1:caaccountid>';
        soapXML1 = soapXML1 + '<urn1:recordIdentification>';
        soapXML1 = soapXML1 + '<urn1:uniqueConstraint1>';
        if(updateObj.SAP_Site_ID__c != null)
            soapXML1 = soapXML1 + '<urn1:cUST_ID>'+getSiteId(updateObj.SAP_Site_ID__c,updateObj.System__c)+'</urn1:cUST_ID>';
        else
            soapXML1 = soapXML1 + '<urn1:cUST_ID></urn1:cUST_ID>';  
        soapXML1 = soapXML1 + '<urn1:sYSTEM>';
        if(updateObj.System__c != null)
            soapXML1 = soapXML1 + '<urn2:internalID>'+(updateObj.System__c == 'S'? '2' : '5')+'</urn2:internalID>';
        else
            soapXML1 = soapXML1 + '<urn2:internalID></urn2:internalID>';    
        soapXML1 = soapXML1 + '</urn1:sYSTEM>';
        soapXML1 = soapXML1 + '</urn1:uniqueConstraint1>';
        soapXML1 = soapXML1 + '</urn1:recordIdentification>';
        soapXML1 = soapXML1 + '</urn1:CUSTOMERS__Update>';
        return soapXML1;
    } 
    
    public static String getInnerInsertXML(Site_Association__c insertObj, String pmfkey) {
        String soapXML1 = '';
        soapXML1 = soapXML1 + '<urn1:CUSTOMERS__Create>';
        if(insertObj.SAP_Site_ID__c != null)
            soapXML1 = soapXML1 + '<urn1:cUST_ID>'+getSiteId(insertObj.SAP_Site_ID__c,insertObj.System__c)+'</urn1:cUST_ID>';
        else
            soapXML1 = soapXML1 + '<urn1:cUST_ID></urn1:cUST_ID>'; 
     //   if(insertObj.SC_TOPS_ID__c != null)
       //     soapXML1 = soapXML1 + '<urn1:external_ID>'+getSiteId(insertObj.SC_TOPS_ID__c,insertObj.System__c)+'</urn1:cUST_ID>';
       // else
         //   soapXML1 = soapXML1 + '<urn1:external_ID></urn1:external_ID>';    
        
        soapXML1 = soapXML1 + '<urn1:nAME_1>'+insertObj.Name+'</urn1:nAME_1>';
         if(insertObj.Name2__c != null)
              soapXML1 = soapXML1 + '<urn1:nAME_2>'+insertObj.Name2__c+'</urn1:nAME_2>';
        else
           soapXML1 = soapXML1 + '<urn1:nAME_2></urn1:nAME_2>';
       
         if(insertObj.Street__c != null)
              soapXML1 = soapXML1 + '<urn1:sTREET>'+insertObj.Street__c+'</urn1:sTREET>';
        else
           soapXML1 = soapXML1 + '<urn1:sTREET></urn1:sTREET>';
      
        
         if(insertObj.Street2__c != null)
              soapXML1 = soapXML1 + '<urn1:sTREET_2>'+insertObj.Street2__c+'</urn1:sTREET_2>';
        else
           soapXML1 = soapXML1 + '<urn1:sTREET_2></urn1:sTREET_2>';
           
        if(insertObj.Street3__c != null)
              soapXML1 = soapXML1 + '<urn1:sTREET_3>'+insertObj.Street3__c+'</urn1:sTREET_3>';
        else
           soapXML1 = soapXML1 + '<urn1:sTREET_3></urn1:sTREET_3>';

        if(insertObj.City__c != null)
              soapXML1 = soapXML1 + '<urn1:cITY1>'+insertObj.City__c+'</urn1:cITY1>';
        else
           soapXML1 = soapXML1 + '<urn1:cITY1></urn1:cITY1>';

       
        
          if(insertObj.Postal_Code__c != null)
              soapXML1 = soapXML1 + '<urn1:pSTLZ>'+insertObj.Postal_Code__c+'</urn1:pSTLZ>';
        else
           soapXML1 = soapXML1 + '<urn1:pSTLZ></urn1:pSTLZ>';
        
        
         if(insertObj.Phone__c != null)
              soapXML1 = soapXML1 + '<urn1:tELF1>'+insertObj.Phone__c+'</urn1:tELF1>';
        else
           soapXML1 = soapXML1 + '<urn1:tELF1></urn1:tELF1>';
        

        soapXML1 = soapXML1 + '<urn1:sFDCID>'+insertObj.Id+'</urn1:sFDCID>';
        
        soapXML1 = soapXML1 + '<urn1:sYSTEM>';
        soapXML1 = soapXML1 + '<urn1:displayValue>SC</urn1:displayValue>';
        soapXML1 = soapXML1 + '<urn1:recordIdentification>';
        soapXML1 = soapXML1 + '<urn2:internalID>6</urn2:internalID>';  
        soapXML1 = soapXML1 + '</urn1:recordIdentification>';  
        soapXML1 = soapXML1 + '</urn1:sYSTEM>';
        
        
        soapXML1 = soapXML1 + '<urn1:caaccountid>';
        soapXML1 = soapXML1 + '<urn1:recordIdentification>';
        if(insertObj.Enterprise_ID_F__c != null) {
            soapXML1 = soapXML1 + '<urn2:keyMapping>';
            soapXML1 = soapXML1 + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML1 = soapXML1 + '<urn2:remoteKey>'+insertObj.Enterprise_ID_F__c+'</urn2:remoteKey>';
            soapXML1 = soapXML1 + '</urn2:keyMapping>';            
        } else {
            soapXML1 = soapXML1 + '<urn2:internalID></urn2:internalID>';
        }
        soapXML1 = soapXML1 + '</urn1:recordIdentification>';
        soapXML1 = soapXML1 + '</urn1:caaccountid>';
       if(insertObj.country_picklist__c != null && insertObj.State__c != null){ 
        soapXML1 = soapXML1 + '<urn1:rEGION>';
        soapXML1 = soapXML1 + '<urn1:recordIdentification>';
        soapXML1 = soapXML1 + '<urn2:keyMapping>';
        soapXML1 = soapXML1 + '<urn2:remoteSystem>SAP MDM</urn2:remoteSystem>';
        //if(insertObj.country_picklist__c != null && insertObj.State__c != null)
            soapXML1 = soapXML1 + '<urn2:remoteKey>'+insertObj.State__c.toUpperCase()+', '+insertObj.country_picklist__c.substring(0,2)+'</urn2:remoteKey>';
        //else
          //  soapXML1 = soapXML1 + '<urn2:remoteKey></urn2:remoteKey>';
        soapXML1 = soapXML1 + '</urn2:keyMapping>';
        soapXML1 = soapXML1 + '</urn1:recordIdentification>';
        soapXML1 = soapXML1 + '</urn1:rEGION>';
       } 
        soapXML1 = soapXML1 + '<urn1:lAND1>';
        soapXML1 = soapXML1 + '<urn1:recordIdentification>';
        soapXML1 = soapXML1 + '<urn2:keyMapping>';
        soapXML1 = soapXML1 + '<urn2:remoteSystem>SAP MDM</urn2:remoteSystem>';
        if(insertObj.country_picklist__c != null)
            soapXML1 = soapXML1 + '<urn2:remoteKey>'+insertObj.country_picklist__c.substring(0,2)+'</urn2:remoteKey>';
        else
            soapXML1 = soapXML1 + '<urn2:remoteKey></urn2:remoteKey>';
        soapXML1 = soapXML1 + '</urn2:keyMapping>';
        soapXML1 = soapXML1 + '</urn1:recordIdentification>';
        soapXML1 = soapXML1 + '</urn1:lAND1>';
        
        //added for incorporating legacy code changes
        soapXML1 = soapXML1 + '<urn1:lEGACY_ID>';
        if(insertObj.SAP_Site_ID__c != null)
            soapXML1 = soapXML1 + '<urn1:lEGACY_ID>'+getSiteId(insertObj.SAP_Site_ID__c,insertObj.System__c)+'</urn1:lEGACY_ID>';
        else
            soapXML1 = soapXML1 + '<urn1:lEGACY_ID></urn1:lEGACY_ID>';   
            soapXML1 = soapXML1 + '<urn1:isvalid>true</urn1:isvalid>'; 
            soapXML1 = soapXML1 + '<urn1:recordIdentification>';
            soapXML1 = soapXML1 + '<urn2:keyMapping>';
            soapXML1 = soapXML1 + '<urn2:remoteSystem>SAP MDM</urn2:remoteSystem>';
            soapXML1 = soapXML1 + '<urn2:remoteKey>SC</urn2:remoteKey>';
            soapXML1 = soapXML1 + '</urn2:keyMapping>';
            soapXML1 = soapXML1 + '</urn1:recordIdentification>';
            soapXML1 = soapXML1 + '</urn1:lEGACY_ID>';
              
        
        //end of code changes for legacy code
        
        
        soapXML1 = soapXML1 + '</urn1:CUSTOMERS__Create>';
        return soapXML1;
    }
    
    public static String padLeft(String str) {
        integer nZeros = 10 - str.length();
        String zeros = '';
        for(integer i=0;i<nZeros;i++) {
            zeros = zeros + '0';
        }
        str = zeros + str;
        return str;
    }
    
    public static String getValidDateFormat(DateTime dateObj) {
        if(dateObj != null)
            return dateObj.format('yyyyMMdd HH:mm:ss');
        return '';  
    }
    
    public static void sendEmail(String errorMessage, String subject) {
        try {
            List<String> toList = new List<String>();
            toList.add(System.Label.MDM_Email_Address);
            toList.add('majsa02@ca.com');
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toList);
            email.setSubject(subject);
            email.setPlainTextBody(errorMessage);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        } catch(Exception e) {
            
        }
    }
    
    @isTest(SeeAllData=true)
    public static void SiteAssociationChangesPushToMDM_test() {
        ID ResellerRecTypeId= SystemIdUtility.getResellerDistRecordTypeId();
        ID SMBRecTypeId= SystemIdUtility.getSMBAcctRecordTypeId();
        Account resellerAcct = new Account(RecordTypeId= ResellerRecTypeId,Name='Test_Acc2',Customer_Category__c='Enterprise',Enterprise_Id__c='101',Enterprise_Account_Name__c='E_Acc1',GEO__c='NA',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');        
        insert resellerAcct;                
        
        Account smbAcct = new Account(RecordTypeId= SMBRecTypeId, Name='Test_Acc1',BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');        
        insert smbAcct;
    
        
       /*Account newAcc = new Account(name='test', RecordTypeId = SystemIdUtility.getSMBAcctRecordTypeId(), Enterprise_ID__c = 'ZZ00001',Commercial_Id__c = 'test');
        insert newAcc;*/
        Site_Association__c newSite = new Site_Association__c(Site_Status__c = 'Approved',Country_picklist__c='US-UnitedStates', SAP_Site_ID__c = '999999' , System__c = 'S', Enterprise_ID__c = smbAcct.Id);
        insert newSite; 
        //List<Site_Association__c> siteAssocList = [Select Id, Site_Status__c, LastModifiedDate, LastModifiedById, Enterprise_ID_F__c, SAP_Site_ID__c, System__c from Site_Association__c where Site_Status__c ='Approved' LIMIT 10];
        Map<Id, Site_Association__c> siteAssocMap = new Map<Id, Site_Association__c>();
        //for(Site_Association__c siteObj : siteAssocList) {
            siteAssocMap.put(newSite.Id, newSite);
        //}
        SiteAssociationChangesPushToMDM classObj = new SiteAssociationChangesPushToMDM();
        classObj.pushSiteAssociationChangesToMDM(siteAssocMap);
        List<Id> eligibleIds = new List<Id>();
        Set<Id> userIds = null;
        String dmUserIds = System.Label.DataMigration_Users;
        String[] users = dmUserIds.split(';');
        Set<String> usersSet = new Set<String>();
        for(String userId : users) {
            usersSet.add(userId);
        }
        for(Id siteAssocId : siteAssocMap.keySet()) {
            Site_Association__c newSiteAssoc = siteAssocMap.get(siteAssocId);
            if(newSiteAssoc.Site_Status__c == 'Approved' && !usersSet.contains(newSiteAssoc.LastModifiedById) ) {
                eligibleIds.add(siteAssocId);
            }
        }
        if(eligibleIds.size() > 0) {
            userIds = new Set<Id>();
            for(Id tempId : eligibleIds) {
                userIds.add(siteAssocMap.get(tempId).LastModifiedById);
            }
        }
        classObj.getSubList(1,eligibleIds);
        SiteAssociationChangesPushToMDM.callSiteAssociationWebService_inner(eligibleIds,userIds);
        SiteAssociationChangesPushToMDM.callSiteAssociationWebService_insert(eligibleIds,userIds);
        try {
            SiteAssociationChangesPushToMDM.callWebService('test','update');
             SiteAssociationChangesPushToMDM.callWebService('test','insert');
        } catch(Exception e) {
            
        }           
    } 
}