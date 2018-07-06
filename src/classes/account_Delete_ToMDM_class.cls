public with sharing class account_Delete_ToMDM_class{
    public void pushAccountDeleteChangesToMDM(List<Account> AccDelRec)
    {
        //List<Account> AccDelRec= [Select id,Enterprise_ID__c from Account where Id IN :newList]; 
        List<String> EntIds = new List<String>();
        for(Account a : AccDelRec){
            EntIds.add(a.Enterprise_ID__c);
        } 
        callAccountDeleteWebService(EntIds);
        //System.debug('in class--account='+newList);
        System.debug('in class--query ='+AccDelRec);
    }
    @Future(callout=true)
    public static void callAccountDeleteWebService(List<String> lst) {
        String respXML = '<?xml version="1.0" encoding="utf-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
        '<SOAP-ENV:Body xmlns:rpl="urn:ACCOUNTVi">    <rpl:updateVT_ACCOUNTSResponse xmlns:rn0="java:sap/standard" xmlns:rn1="urn:com.sap.mdm.ws.beans" xmlns:rn2="http://schemas.xmlsoap.org/soap/encoding/" xmlns:rn3="urn:com.sap.mdm.core.base"'+
        ' xmlns:rn4="urn:com.sap.mdm.ws.beans.account" xmlns:rn5="urn:com.sap.mdm.core.beans"><rpl:Response><rn1:ExecutionStatus><rn1:status>OK</rn1:status><rn1:description>Record was updated</rn1:description>'+
        '<rn1:dataObject>6486</rn1:dataObject></rn1:ExecutionStatus></rpl:Response></rpl:updateVT_ACCOUNTSResponse>  </SOAP-ENV:Body></SOAP-ENV:Envelope>';
        Map<String,String> respDetails = null;
        String status = null;
        String data = null;
        String error = null;
         
            String soapXML = getDeleteSOAPXML(lst);
            String respBody = '';
            if(!Test.isRunningTest()) {
                respBody = AccountChangesPushToMDM.callWebService(soapXML,lst[0],lst[0]);
                system.debug('response data 2nd call'+respBody);
            } else {
                respBody = respXML;
            }
            if(respBody != null) {
                respDetails =AccountChangesPushToMDM.parseResponseXML(respBody);
                status = respDetails.get('STATUS');
                data = respDetails.get('DATA');
                error = respDetails.get('ERROR');
            }
        
    }   
    public static String getDeleteSOAPXML(List<String> accList) {
        String soapXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ACCOUNTVi" xmlns:urn1="urn:com.sap.mdm.ws.beans.account" xmlns:urn2="urn:com.sap.mdm.ws.beans" xmlns:urn3="urn:com.sap.mdm.core.beans">';
        soapXML = soapXML + '<soapenv:Header/>';
        soapXML = soapXML + '<soapenv:Body>';
        soapXML = soapXML + '<urn:updateACCOUNTS>';
        soapXML = soapXML + '<urn:ACCOUNTS>';
        for(String acc : accList){
            soapXML = soapXML + '<urn1:ACCOUNTS__Update>';
            soapXML = soapXML + '<urn1:caaccountid>'+acc+'</urn1:caaccountid>';
            soapXML = soapXML + '<urn1:isdeleted>true</urn1:isdeleted>';
            soapXML = soapXML + '<urn1:recordIdentification>';
            soapXML = soapXML + '<urn1:keyMapping>';
            soapXML = soapXML + '<urn2:remoteSystem>SFDC</urn2:remoteSystem>';
            soapXML = soapXML + '<urn2:remoteKey>'+acc+'</urn2:remoteKey>';
            soapXML = soapXML + '</urn1:keyMapping>';
            soapXML = soapXML + '</urn1:recordIdentification>';
            soapXML = soapXML + '</urn1:ACCOUNTS__Update>';
        }
        soapXML = soapXML + '</urn:ACCOUNTS>';
        soapXML = soapXML + '<urn:reposInfo>';
        soapXML = soapXML + '<urn3:dataLang>English [US]</urn3:dataLang>';
        soapXML = soapXML + '<urn3:repositoryName>ZCustomer</urn3:repositoryName>';
        soapXML = soapXML + '<urn3:serverName>'+System.Label.MDM_Server_Name+'</urn3:serverName>';
        soapXML = soapXML + '</urn:reposInfo>';
        soapXML = soapXML + '<urn:configurationParameters><urn2:applyNullValuesToMdm>true</urn2:applyNullValuesToMdm></urn:configurationParameters>';
        soapXML = soapXML + '</urn:updateACCOUNTS>';
        soapXML = soapXML + '</soapenv:Body>';
        soapXML = soapXML + '</soapenv:Envelope>';
        
        return soapXML;

    }  
}