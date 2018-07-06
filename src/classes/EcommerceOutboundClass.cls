/************************************************************************************************
* Modified By 		 Date           User Story      Details
* SAMAP01       	02/07/2018      US450545 		GPOC: For the existing integrations from EAI to and from SFDC
* SAMAP01			02/22/2018		US458714 		Replace the basic authentication by token based authentication
* SAMAP01			02/22/2018		US450556		GPOC: Revised Technical Implementation, Flow to Support CAT webservice initiating provisioning process
* SAMAP01       	04/10/2018      US474603 		GPOC : Verify LDAP Account Exists for contact
* **********************************************************************************************/
global class EcommerceOutboundClass {
    public static Layer7UtilCallout service=new Layer7UtilCallout(); //SAMAP01
    public static CC_Layer7Service layer7service = new CC_Layer7Service();  //  US474603
    public static string stroldrequeststatus = '';
    @future (callout=true)  
    public static void SendPocUpdate(String pocid, String useremail,String oldrequeststatus) {
        System.debug('SendPocUpdate called');
        String currentuseremail = useremail;
        stroldrequeststatus =oldrequeststatus; 
        
        
        Trial_Request__c poc = [Select Id, Name, Request_Status__c,POC_Number__c,Request_Type__c,Business_Unit__c,
                                Start_Date__c,End_Date__c,Opportunity_ID__c,Account_Name2__c,POC_SAAS_Type__c,account__r.Name ,
                                Acc_Area__c,AccountId__c,account__r.Phone,Acc_Region__c,CreatedBy.name,
                                Contact__r.firstname,Contact__r.lastName,Contact_Phone__c,Contact_Email__c,
                                Contact__r.Country_Picklist__c,Contact__r.MailingCity,Contact__r.MailingCountry,
                                Contact__r.MailingPostalCode,Contact__r.MailingState,Contact__r.MailingStreet,Contact__r.Contact_Phone_Number_Extension__c,
                                Contact_2__r.firstname,Contact_2__r.lastName,Contact_2__r.Phone,Contact_2__r.Email,
                                Contact_2__r.Country_Picklist__c,Contact_2__r.MailingCity,Contact_2__r.MailingCountry,
                                Contact_2__r.MailingPostalCode,Contact_2__r.MailingState,Contact_2__r.MailingStreet,Contact_2__r.Contact_Phone_Number_Extension__c,
                                Contact_3__r.firstname,Contact_3__r.lastName,Contact_3__r.Phone,Contact_3__r.Email,
                                Contact_3__r.Country_Picklist__c,Contact_3__r.MailingCity,Contact_3__r.MailingCountry,
                                Contact_3__r.MailingPostalCode,Contact_3__r.MailingState,Contact_3__r.MailingStreet,Contact_3__r.Contact_Phone_Number_Extension__c,
                                tempsiteid__c, Site_Association__c from Trial_Request__c where Id=:pocid];
        Site_Association__c site = [select SAP_Site_ID__c,Name,Street__c,City__c,Region__c,Country_Picklist__c,SC_TOPS_ID__c,Postal_Code__c,
                                    DUNS_Number__c,Phone__c,Site_Status__c
                                    from Site_Association__c where Id= :poc.Site_Association__c];
        
        
        
           
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        

//req.setEndpoint('https://eaisvcqafs.ca.com/orders/r.v1');
//req.setEndpoint('https://eapidev.ca.com/gpoc/orchestrator');
//Payload sample   // <?xml version="1.0" encoding="UTF-8" standalone="yes"?> <order><id>null</id><caOrderId>24002</caOrderId><action>CANCEL</action><cancelDate>2018-02-08</cancelDate></order>

        
        // use the Org Id
        system.debug('-----org id---'+UserInfo.getOrganizationId());
        if(UserInfo.getOrganizationId()=='00D300000006yn4') {  //production Instance then use Production ENDPOINT
            req.setEndpoint(System.Label.GPOC_EAIEndPointProd);
        }else { 
            req.setEndpoint(System.Label.GPOC_EAIEndPointQA);  //else QA Endpoint
        }
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        
        req.setTimeout(30000);
        req.setMethod('POST');
        string payload =createXMLPayload(poc,site);  
        
        System.debug('EcommerceOutboundClass payload=' + payload);        
        
        req.setBody(payload);        
        
        try {
            System.debug('EcommerceOutboundClass before calling outbound');            
            //  res = http.send(req); //samap01 -US458714 
            // string responsefromservice  = callLayer7Service(req);
            string  responsefromservice=service.processLayer7Services(req);
            // System.debug('SendPocUpdate res=' + res.getStatusCode());
            System.debug('SendPocUpdate responsefromservice=' + responsefromservice);
            if(responsefromservice != null && responsefromservice!='')
            {
                ParseXMLResponse(responsefromservice,poc,currentuseremail);  
            } 
            else
            {
                System.debug('No response received responsefromservice=' + responsefromservice);
            }
            
        } catch(System.CalloutException e) {
            System.debug('SendPocUpdate Callout error: '+ e);
            System.debug('SendPocUpdate error=' + res.toString());
          
            poc.Request_Status__c = stroldrequeststatus;
            update poc;
            //}
            sendemail( '<html><body>Hi <BR>' + 'Error occured while contacting Layer 7 for POC request ' + poc.name + ' <br><br>' + e.getMessage() +'<br>Please open a service desk ticket',currentuseremail);
            
        }
        
        System.debug('EcommerceOutboundClass success');
        
        
    }
    
     
     //Get LDAP Id - US474603
    @future (callout=true)  
    public static void  UpdateLdapId(string pocid)
    {
        Map<Id,string> contactids = new  Map<Id,string>();
        Map<Id,boolean>contactldap = new  Map<Id,boolean>();
      Trial_Request__c    poctr =[select Contact__r.Id, Contact_2__r.Id, Contact_3__r.id,Contact1_Has_LdapId__c,Contact2_Has_LdapId__C,Contact3_Has_LdapId__C,
                                  Contact__r.SC_CONTACT_LDAPID__c,Contact_2__r.SC_CONTACT_LDAPID__c,Contact_3__r.SC_CONTACT_LDAPID__c,
                                   Contact__r.Email,Contact_2__r.Email,Contact_3__r.Email
                       from trial_request__c where  Id=:pocid];
		If(poctr != null)
        {
            
            if(poctr.Contact__r.Id != null &&  poctr.Contact__r.SC_CONTACT_LDAPID__c==null)
            {
                
                contactids.put(poctr.Contact__r.id,poctr.Contact__r.Email) ;
                if(poctr.Contact__r.Email != null)
                {
                    String ldapid = layer7service.getLDAPID(poctr.Contact__r.Email);  
                    if(ldapid != null && ldapid != '')
                    {
                        poctr.Contact1_Has_LdapId__c =true ;
                    }
                    else{
                        poctr.Contact1_Has_LdapId__c =false ;
                    }
                }
                else{
                    poctr.Contact1_Has_LdapId__c =false ;
                }
                
            }
            else{
                if(poctr.Contact__r.Id != null &&  String.isNotBlank(poctr.Contact__r.SC_CONTACT_LDAPID__c)){
                    poctr.Contact1_Has_LdapId__c =true ;
                }
            }
            if(poctr.Contact_2__r.Id != null && poctr.Contact_2__r.SC_CONTACT_LDAPID__c ==null)
            {
            	   contactids.put(poctr.Contact_2__r.id,poctr.Contact_2__r.Email) ;
                 if(poctr.Contact_2__r.Email != null)
                {
                    String ldapid = layer7service.getLDAPID(poctr.Contact_2__r.Email);  
                    if(ldapid != null && ldapid != '')
                    {
                        poctr.Contact2_Has_LdapId__C =true ;
                    }
                    else{
                        poctr.Contact2_Has_LdapId__C =false ;
                    }
                }
                else{
                    poctr.Contact2_Has_LdapId__C =false ;
                }
            }
            else{
                if(poctr.Contact_2__r.Id != null &&  String.isNotBlank(poctr.Contact_2__r.SC_CONTACT_LDAPID__c)){
                    poctr.Contact2_Has_LdapId__C =true ;
                }
            }
            if(poctr.Contact_3__r.Id != null &&  poctr.Contact_3__r.SC_CONTACT_LDAPID__c ==null)
            {
               contactids.put(poctr.Contact_3__r.id,poctr.Contact_3__r.Email) ;
                     if(poctr.Contact_3__r.Email != null)
                {
                    String ldapid = layer7service.getLDAPID(poctr.Contact_3__r.Email);  
                    if(ldapid != null && ldapid != '')
                    {
                        poctr.Contact3_Has_LdapId__C =true ;
                    }
                    else{
                        poctr.Contact3_Has_LdapId__c =false ;
                    }
                }
                else{
                    poctr.Contact3_Has_LdapId__c =false ;
                }
            }
            else{
                if(poctr.Contact_3__r.Id != null &&  String.isNotBlank(poctr.Contact_3__r.SC_CONTACT_LDAPID__c)){
                    poctr.Contact3_Has_LdapId__c =true ;
                }
            }            
        }
     
        SystemIdUtility.skipOpportunityTriggers =true;  //avoid the triggers firing again
        System.debug('samap01 update ldap details' +poctr );
        update poctr ;
        //return ldapid;
    }
      
    
    //dom xml for the payload
    public static string createXMLPayload(Trial_Request__c poc,Site_Association__c site)
    {
        System.debug('samap01 createXMLPayload entered');
        String payload = '';
        String strPocId = poc.Name;
        String[] arrPocId = strPocId.split('POC - ');
        
        String strEndDate = string.Valueof(poc.End_Date__c);
        String[] arrEndDate =  strEndDate.split(' ');
        
        String strCancelDate = string.Valueof(system.today());
        String[] arrCancelDate =  strCancelDate.split(' ');    
        String strpayloadaction ='';
        Set<Id> materialIds= new Set<Id>();
        map<id,string> mapprodrelease = new map<id,string>();
        map<id,string> mapprodgenlevel = new map<id,string>();
        map<id,boolean> mapprodlicenseonly = new map<id,boolean>();
        boolean isoptiontype =false;
           string GPOC_UIM_TopsCodes = System.label.GPOC_UIM_TopsCodes ;
       
        List<Product_Release__c > prodrelease = new  List<Product_Release__c >();
        try{
            List<pocMaterial__c> tPocProductMaterials = [Select Id, quantity__c, Product_Material__r.Id, Product_Material__r.Material_Text__c,
                                                         Product_Material__r.platform_category__C,Product_Material__r.isappliance__C,
                                                         Product__r.Id, Product__r.Name , Product_Material__r.Descriptor__c,Product_Material__r.SAP_Product_Mapping__c
                                                         from pocMaterial__c where POC_Request__c=:poc.id  ]; 
            for(pocMaterial__c pmat : tPocProductMaterials)
            {
                materialIds.add(pmat.Product_Material__r.Id);
            }
            
            if(materialIds.size() >0)
            {
                prodrelease = [select Product_Material__c , Product_Release__c ,Has_Entitlement__c,(select Product_Service_Pack__c from Product_Service_Pack__r)
                               from Product_Release__c where GA_level__c=0 and  Product_Material__c in : materialIds ] ; 
            }
            for(Product_Release__c pocrelease : prodrelease)
            {
                mapprodrelease.put(pocrelease.Product_Material__c, pocrelease.Product_Release__c);
                mapprodlicenseonly.put(pocrelease.Product_Material__c,pocrelease.Has_Entitlement__c);
                for(Product_Service_Pack__c psc : pocrelease.Product_Service_Pack__r )
                    mapprodgenlevel.put(pocrelease.Product_Material__c ,psc.Product_Service_Pack__c );
            }
            
            if(poc.Request_Status__c == 'Request Approved')
            {
                strpayloadaction ='CREATE';
            }
            else if(poc.Request_Status__c == 'Cancelled')
            {
                strpayloadaction ='CANCEL';
            }
            else if(poc.Request_Status__c == 'Extension Approved')
            {
                strpayloadaction ='EXTEND';
            }
            else
            {
                strpayloadaction ='UPDATE';
            }
            DOM.Document doc = new DOM.Document();
            dom.XmlNode order = doc.createRootElement('order', null, null);
            system.debug('samap01 root element created');
            if(poc.tempsiteid__c != null)
            {
                dom.XmlNode body1= order.addChildElement('id', null, null).addTextNode(poc.tempsiteid__c);
            }
            else
            {
                dom.XmlNode body1= order.addChildElement('id', null, null);
            }
           // System.debug('samap01 body1'+ body1.getText());
            if(poc.POC_Number__c != null)
            {
                dom.XmlNode body2= order.addChildElement('caOrderId', null, null).addTextNode(poc.POC_Number__c);
            }
            else
            {
                dom.XmlNode body2= order.addChildElement('caOrderId', null, null);
            }
            //System.debug('samap01 body2');
            dom.XmlNode body3= order.addChildElement('status', null, null).addTextNode(poc.Request_Status__c);
            dom.XmlNode body4= order.addChildElement('action', null, null).addTextNode(strpayloadaction);
            dom.XmlNode body5= order.addChildElement('name', null, null).addTextNode(poc.Name);
            dom.XmlNode body6= order.addChildElement('internalSfdcId', null, null).addTextNode(poc.Id);
            dom.XmlNode body7= order.addChildElement('createdBy', null, null).addTextNode(poc.CreatedBy.name);
            dom.XmlNode body8= order.addChildElement('requestType', null, null).addTextNode(poc.Request_Type__c);
            
            string startdate = string.valueOfGmt(poc.Start_Date__c);
            string enddate = string.valueOfGmt(poc.End_Date__c);
             dom.XmlNode body10= order.addChildElement('startDate', null, null).addTextNode(startdate);
             dom.XmlNode body11=  order.addChildElement('endDate', null, null).addTextNode(enddate);
            /*if(poc.Request_Type__c == 'POC SaaS Request')
            {
                dom.XmlNode body9= order.addChildElement('saasType', null, null).addTextNode(poc.POC_SAAS_Type__c);
                
            }*/
             
            if(poc.tempsiteid__c != null)
            {
                dom.XmlNode body12= order.addChildElement('tempsiteid', null, null).addTextNode(poc.tempsiteid__c);
            }
            else
            {
                dom.XmlNode body12= order.addChildElement('tempsiteid', null, null);
            }
            
            //opportunity
            
            dom.XmlNode body13= order.addChildElement('opportunity', null, null);
            body13.addChildElement('id', null, null).addTextNode(poc.Opportunity_ID__c);
            if(poc.Acc_Area__c !=null)
            {
                body13.addChildElement('area', null, null).addTextNode(poc.Acc_Area__c);
            }
            else
            {
                body13.addChildElement('area', null, null) ;
            }
            //system.debug('samap01 opportunity');
            //account
            dom.XmlNode body14= order.addChildElement('account', null, null);
            string accname = poc.Account_Name2__c;
            body14.addChildElement('name', null, null).addTextNode(string.valueOf(poc.account__r.Name));
            body14.addChildElement('id', null, null).addTextNode(poc.AccountId__c);
            if(poc.account__r.Phone !=null)
            {
                body14.addChildElement('phone', null, null).addTextNode(poc.account__r.Phone);
            }
            else
            {
                body14.addChildElement('phone', null, null);
            }
            if(poc.Acc_Region__c !=null)
            {
                body14.addChildElement('geo', null, null).addTextNode(poc.Acc_Region__c);            }
            else
            {
                body14.addChildElement('geo', null, null);
            }
            //system.debug('samap01 account');
            
            //contacts
            dom.XmlNode contacts= order.addChildElement('contacts', null, null);
            dom.XmlNode contact= contacts.addChildElement('contact', null, null);            
            contact.addChildElement('contactType', null, null).addTextNode('primary');
            contact.addChildElement('email', null, null).addTextNode(poc.Contact_Email__c);
            if(poc.Contact__r.firstname !=null)
            {
                contact.addChildElement('firstName', null, null).addTextNode(poc.Contact__r.firstname);
            }
            else
            {
                contact.addChildElement('firstName', null, null) ;
            }
            if(poc.Contact__r.lastName!= null)
            {
                contact.addChildElement('lastName', null, null).addTextNode(poc.Contact__r.lastName); 
            }
            else
            {
                contact.addChildElement('lastName', null, null);
            }
           // system.debug('samap01 contact 1');
            dom.XmlNode telephone =   contact.addChildElement('telephone', null, null);
            telephone.addChildElement('number', null, null).addTextNode(poc.Contact_Phone__c);
            if(poc.Contact__r.Contact_Phone_Number_Extension__c !=null)
            {
                telephone.addChildElement('extension', null, null).addTextNode(poc.Contact__r.Contact_Phone_Number_Extension__c); 
            }
            else
            {
                telephone.addChildElement('extension', null, null);
            }
            
            
           // dom.XmlNode addresses = contact.addChildElement('addresses', null, null);
            dom.XmlNode address = contact.addChildElement('address', null, null);
            address.addChildElement('type', null, null).addTextNode('WORK');
            if(poc.Contact__r.MailingStreet != null)
            {
                address.addChildElement('street', null, null).addTextNode(poc.Contact__r.MailingStreet);
            }
            else
            {
                address.addChildElement('street', null, null);
            }
            if(poc.Contact__r.MailingCity != null)
            {
                address.addChildElement('city', null, null).addTextNode(poc.Contact__r.MailingCity);
            }
            else
            {
                address.addChildElement('city', null, null);
            }
            if(poc.Contact__r.MailingState !=null)
            {
                address.addChildElement('region', null, null).addTextNode(poc.Contact__r.MailingState);
            }
            else
            {
                address.addChildElement('region', null, null);
            }
            
          //  address.addChildElement('regionName', null, null).addTextNode(poc.Contact__r.MailingStreet);  //CHECK THIS ONE
            if(poc.Contact__r.MailingPostalCode!=null)
            {
                address.addChildElement('postalCode', null, null).addTextNode(poc.Contact__r.MailingPostalCode);
            }
            else
            {
                address.addChildElement('postalCode', null, null); 
            }
            
            if(poc.Contact__r.MailingCountry!= null)
            {
                address.addChildElement('country', null, null).addTextNode(poc.Contact__r.MailingCountry);
            }
            else
            {
                address.addChildElement('country', null, null);
            }
            
            //system.debug('samap01 Contact_2__r');
            if(poc.Contact_2__r.lastName !=null && poc.Contact_2__r.lastName !='')
            {
                dom.XmlNode Contact_2= contacts.addChildElement('contact', null, null);            
                Contact_2.addChildElement('contactType', null, null).addTextNode('secondary');
                Contact_2.addChildElement('email', null, null).addTextNode(poc.Contact_2__r.Email);
                if(poc.Contact_2__r.firstname!=null)
                {
                    Contact_2.addChildElement('firstName', null, null).addTextNode(poc.Contact_2__r.firstname);
                }
                else
                {
                    Contact_2.addChildElement('firstName', null, null);
                }
                
                if(poc.Contact_2__r.lastName!=null)
                {
                    Contact_2.addChildElement('lastName', null, null).addTextNode(poc.Contact_2__r.lastName);
                }
                else
                {
                    Contact_2.addChildElement('lastName', null, null);
                }
                
                dom.XmlNode telephone2 =   Contact_2.addChildElement('telephone', null, null);
                if(poc.Contact_2__r.Phone!=null)
                {
                    telephone2.addChildElement('number', null, null).addTextNode(poc.Contact_2__r.Phone);
                }
                else
                {
                    telephone2.addChildElement('number', null, null);  
                }
                if(poc.Contact_2__r.Contact_Phone_Number_Extension__c!=null)
                {
                    telephone2.addChildElement('extension', null, null).addTextNode(poc.Contact_2__r.Contact_Phone_Number_Extension__c);   
                }
                else
                {
                    telephone2.addChildElement('extension', null, null);  
                }
                
                
               // dom.XmlNode addresses2 = Contact_2.addChildElement('addresses', null, null);
                dom.XmlNode address2 = Contact_2.addChildElement('address', null, null);
                address2.addChildElement('type', null, null).addTextNode('WORK');
                if(poc.Contact_2__r.MailingStreet !=null)
                {
                    address2.addChildElement('street', null, null).addTextNode(poc.Contact_2__r.MailingStreet);
                }
                else
                {
                    address2.addChildElement('street', null, null);   
                }
                if(poc.Contact_2__r.MailingCity !=null)
                {
                    address2.addChildElement('city', null, null).addTextNode(poc.Contact_2__r.MailingCity);
                }
                else
                {
                    address2.addChildElement('city', null, null) ;
                }
                if(poc.Contact_2__r.MailingState!=null )
                {
                    address2.addChildElement('region', null, null).addTextNode(poc.Contact_2__r.MailingState);
                }
                else
                {
                    address2.addChildElement('region', null, null); 
                }
             
                if(poc.Contact_2__r.MailingPostalCode !=null)
                {
                    address2.addChildElement('postalCode', null, null).addTextNode(poc.Contact_2__r.MailingPostalCode);     
                }
                else
                {
                    address2.addChildElement('postalCode', null, null); 
                }
                if(poc.Contact_2__r.MailingCountry !=null)
                {
                    address2.addChildElement('country', null, null).addTextNode(poc.Contact_2__r.MailingCountry);                     
                }
                else
                {
                    address2.addChildElement('country', null, null); 
                }
                
            }
            
            
            if(poc.Contact_3__r.lastName !=null && poc.Contact_3__r.lastName !='')
            {
                dom.XmlNode Contact_3= contacts.addChildElement('contact', null, null);            
                Contact_3.addChildElement('contactType', null, null).addTextNode('Tertiary');
                Contact_3.addChildElement('email', null, null).addTextNode(poc.Contact_3__r.Email);
                if(poc.Contact_3__r.firstname !=null)
                {
                    Contact_3.addChildElement('firstName', null, null).addTextNode(poc.Contact_3__r.firstname); 
                }
                else
                {
                    Contact_3.addChildElement('firstName', null, null) ;
                }
                if(poc.Contact_3__r.lastName!=null)
                {
                    Contact_3.addChildElement('lastName', null, null).addTextNode(poc.Contact_3__r.lastName);  
                }
                else
                {
                    Contact_3.addChildElement('lastName', null, null);
                    
                }
                
                dom.XmlNode telephone3 =   Contact_3.addChildElement('telephone', null, null);
                if(poc.Contact_3__r.Phone!=null)
                {
                    telephone3.addChildElement('number', null, null).addTextNode(poc.Contact_3__r.Phone);
                }
                else
                {
                    telephone3.addChildElement('number', null, null);  
                }
                if(poc.Contact_3__r.Contact_Phone_Number_Extension__c!=null)
                {
                    telephone3.addChildElement('extension', null, null).addTextNode(poc.Contact_3__r.Contact_Phone_Number_Extension__c);   
                }
                else
                {
                    telephone3.addChildElement('extension', null, null);  
                }
                
               // dom.XmlNode addresses3 = Contact_3.addChildElement('addresses', null, null);
                dom.XmlNode address3 = Contact_3.addChildElement('address', null, null);
                address3.addChildElement('type', null, null).addTextNode('WORK');
                if(poc.Contact_3__r.MailingStreet !=null)
                {
                    address3.addChildElement('street', null, null).addTextNode(poc.Contact_3__r.MailingStreet);
                }
                else
                {
                    address3.addChildElement('street', null, null);   
                }
                if(poc.Contact_3__r.MailingCity !=null)
                {
                    address3.addChildElement('city', null, null).addTextNode(poc.Contact_3__r.MailingCity);
                }
                else
                {
                    address3.addChildElement('city', null, null) ;
                }
                if(poc.Contact_3__r.MailingState!=null )
                {
                    address3.addChildElement('region', null, null).addTextNode(poc.Contact_3__r.MailingState);
                }
                else
                {
                    address3.addChildElement('region', null, null); 
                }
                /*if(poc.Contact_3__r.MailingStreet !=null)
                {
                    address3.addChildElement('regionName', null, null).addTextNode(poc.Contact_3__r.MailingStreet);  //CHECK THIS ONE
                }
                else
                {
                    address3.addChildElement('regionName', null, null);  //CHECK THIS ONE
                }*/
                if(poc.Contact_3__r.MailingPostalCode !=null)
                {
                    address3.addChildElement('postalCode', null, null).addTextNode(poc.Contact_3__r.MailingPostalCode);     
                }
                else
                {
                    address3.addChildElement('postalCode', null, null); 
                }
                if(poc.Contact_3__r.MailingCountry !=null)
                {
                    address3.addChildElement('country', null, null).addTextNode(poc.Contact_3__r.MailingCountry);                     
                }
                else
                {
                    address3.addChildElement('country', null, null); 
                }
            }
            //CONTACTS
            
            //site
            dom.XmlNode sites= order.addChildElement('site', null, null);
            if(site.City__c!=null)
            {
                sites.addChildElement('city', null, null).addTextNode(site.City__c);   
            }
            else
            {
                sites.addChildElement('city', null, null);
            }
            if(site.Country_Picklist__c!=null)
            {
                sites.addChildElement('country', null, null).addTextNode(site.Country_Picklist__c);
            }
            else
            {
                sites.addChildElement('country', null, null);
            }
             if(site.Region__c !=null)
            {
                sites.addChildElement('region', null, null).addTextNode(site.Region__c);
            }
            else
            {
                sites.addChildElement('region', null, null);
            }
            if(site.DUNS_Number__c!=null)
            {
                sites.addChildElement('dunsNumber', null, null).addTextNode(site.DUNS_Number__c);    
            }
            else
            {
                sites.addChildElement('dunsNumber', null, null);
            }
            if(site.SC_TOPS_ID__c!=null)
            {
            sites.addChildElement('id', null, null).addTextNode(site.SC_TOPS_ID__c);
            }
            else 
            {
             sites.addChildElement('id', null, null).addTextNode('99999');//Sending static value as this is mandatory for OB1 system   
            }
            if(site.Phone__c!=null)
            {
                sites.addChildElement('primaryTelephone', null, null).addTextNode(site.Phone__c);  
            }
            else
            {
                sites.addChildElement('primaryTelephone', null, null);
            }
            
            sites.addChildElement('name', null, null).addTextNode(site.Name);
            if(site.Postal_Code__c !=null)
            {
                sites.addChildElement('postalCode', null, null).addTextNode(site.Postal_Code__c);     
            }
            else
            {
                sites.addChildElement('postalCode', null, null); 
            }
            if(site.Site_Status__c !=null)
            {
                sites.addChildElement('status', null, null).addTextNode(site.Site_Status__c);      
            }
            else
            {
                sites.addChildElement('status', null, null) ;       
            }
            if(site.Street__c !=null)
            {
                sites.addChildElement('street', null, null).addTextNode(site.Street__c);    
            }
            else
            {
                sites.addChildElement('street', null, null);
            }
            
            //sites
            
            //lineItems
            dom.XmlNode lineItems= order.addChildElement('lineItems', null, null);
            for(pocMaterial__c material : tPocProductMaterials)
            {
                string strtype = '';
                if(mapprodlicenseonly.size() >0)
                isoptiontype =   mapprodlicenseonly.get(material.id);                
                dom.XmlNode lineItem= lineItems.addChildElement('lineItem', null, null);
                lineItem.addChildElement('id', null, null).addTextNode(material.id);
                  dom.XmlNode materials=   lineItem.addChildElement('material', null, null);
                materials.addChildElement('name', null, null).addTextNode(material.Product_Material__r.Material_Text__c);
                payload += '<material><name>'+material.Product_Material__r.Material_Text__c+'</name> ';
                if(poc.Request_Type__c =='POC MultiType Request')//SAAS, MAINFRAME, APPLIANCE, SOFTWARE
                {
                    if(GPOC_UIM_TopsCodes.containsIgnoreCase(material.Product_Material__r.SAP_Product_Mapping__c))
                    {
                        materials.addChildElement('requestType', null, null).addTextNode('HYBRID');
                        strtype = 'HYBRID';
                    }
                   else  if(material.Product_Material__r.isappliance__C == true )
                    {
                        materials.addChildElement('requestType', null, null).addTextNode('APPLIANCE');
                        
                    }
                    else if(material.Product_Material__r.platform_category__C =='SAAS')
                    {
                        materials.addChildElement('requestType', null, null).addTextNode('SAAS');
                        
                    }
                    //else if(material.Product_Material__r.platform_category__C =='Mainframe')
                    else if(poc.Business_Unit__c =='Mainframe')                        
                    {
                        if(isoptiontype==true)
                        {
                         materials.addChildElement('requestType', null, null).addTextNode('OPTION');   
                        } 
                        else
                        {
                            materials.addChildElement('requestType', null, null).addTextNode('SOFTWARE');
                              strtype = 'SOFTWARE';
                        }
                        
                    }
                    else
                    {
                       
                        materials.addChildElement('requestType', null, null).addTextNode('SOFTWARE');
                        strtype = 'SOFTWARE';
                    }
                    
                }
                
                if(material.Product_Material__r.Descriptor__c !=null)
                {
                    materials.addChildElement('description', null, null).addTextNode(material.Product_Material__r.Descriptor__c); 
                }
                else
                {
                    materials.addChildElement('description', null, null);
                }
                
                materials.addChildElement('id', null, null).addTextNode(material.Product_Material__r.SAP_Product_Mapping__c);  // 
                
                //  payload += '<id source="SAP">'+material.Product_Material__r.SAP_Product_Mapping__c+'</id></material>';
                //  
                if(poc.Request_Type__c == 'POC Software Request' ||  strtype == 'SOFTWARE' || strtype == 'HYBRID' ||  poc.Request_Type__c == 'POC Hybrid SaaS Request' )  
                {
                    
                  
                    //System.debug('samap01 poc.Request_Type__c'+poc.Request_Type__c);
                    string prelease = mapprodrelease.get(material.id);
                    string strgenlevel = mapprodgenlevel.get(material.id);
                    //US483691
                    if(GPOC_UIM_TopsCodes.containsIgnoreCase(material.Product_Material__r.SAP_Product_Mapping__c))
                    	{
                      	   prelease ='99.0';
                        }
                 
                    if(!String.isBlank(prelease))
                    {
                        materials.addChildElement('version', null, null).addTextNode(prelease);  
                    }
                    else
                    {
                        materials.addChildElement('version', null, null) ;
                    }
                    
                    if(!String.isBlank(strgenlevel))
                    {
                        materials.addChildElement('genLevel', null, null).addTextNode(strgenlevel);    
                    }
                    else
                    {
                        materials.addChildElement('genLevel', null, null);      
                    }
                    
                    
                    // payload +='<requiresLicense>true</requiresLicense>';   //find logic
                } 
                if(poc.Request_Type__c == 'POC Option Type Request')
                {
                    materials.addChildElement('requiresLicense', null, null).addTextNode('true');   
                    //   payload +='<requiresLicense>true</requiresLicense>';   //find logic
                } 
                else
                {
                    materials.addChildElement('requiresLicense', null, null).addTextNode('false');   
                    
                }
                
            }
            
            if(poc.Request_Status__c  == 'Cancelled')
            {
                //if( arrCancelDate[0])  --null check
                dom.XmlNode body17= order.addChildElement('cancelDate', null, null).addTextNode( arrCancelDate[0] );
                payload += '<cancelDate>' + arrCancelDate[0] + '</cancelDate>';  
                
            }
            else if(poc.Request_Status__c  == 'Extension Approved')
            {
                dom.XmlNode body18= order.addChildElement('extendDate', null, null).addTextNode( arrEndDate[0] );
                
            }
            
            
            payload = doc.toXmlString();
            System.debug('samap01 createXMLPayload end -payload' +  payload);
            return payload;
        }
        catch(exception ex)
        {
            system.debug('samaop01 createxml error '+ex);
            poc.Request_Status__c = stroldrequeststatus;
            update poc;
            
            return payload;
            
        }
        
        
    }
    public static void sendemail( string body,string currentuseremail)
    {
        //samap01 - put in error logging and send email on error 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String currentuseremail= UserInfo.getUserEmail();
        string  L2SupportDL = System.Label.L2Support;
        String[] toAddresses = new String[] {L2SupportDL,currentuseremail}; //Team-GIS-Cavalry@ca.com
            mail.setToAddresses(toAddresses);
        mail.setSubject('GPOC Error connecting to Layer 7 ' );
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //samap01
        
    }
    //this method checks the error code and sends emails
    // XmlStreamReader reader = new XmlStreamReader(str)
    public static void ParseXMLResponse(string response, Trial_Request__c poc,string currentuseremail )
    {
        System.debug('ParseXMLResponse');
        
        String errorcode;
        String errormsg;
        XmlStreamReader xmlResponse = new XmlStreamReader(response);
        try{
            if(xmlResponse != null)
            {
                System.debug('EcommerceOutboundClass - xmlresponse' + xmlresponse);
                
                while(xmlResponse.hasNext()) {
                    
                    if (xmlResponse.getEventType() == XmlTag.END_ELEMENT) {
                        if ('order' == xmlResponse.getLocalName()) {
                            break;  
                        }
                    }
                    if (xmlResponse.getEventType() == XmlTag.START_ELEMENT) {
                        if ('error' == xmlResponse.getLocalName()) {
                            errorcode = getValueFromXMLTag(xmlResponse);
                           // System.debug(xmlResponse.getAttributeValue(null, 'code'));
                        }
                    }
                    xmlResponse.next();
                } 
                
                if(errorcode == 'QT_1005' || errorcode == 'QT_1004')
                {
                    System.debug('samap01 send email with Parse http errormsg '+ errormsg );
                    IF(poc.Request_Status__c == 'Extension Approved')
                    {
                        poc.Request_Status__c ='Extension for Approval';
                        update poc;
                    }
                    sendemail( '<html><body>Hi <br> ' + ' Error occured while contacting Layer 7 for POC request.<br> Error Message: '+  errormsg +' <br> GPOC request number: ' + poc.name + '<br> Oppportunity Id:' + poc.Opportunity_ID__c +' <br><br><br>Please open a service desk ticket<br><br> - SFDC Team' ,currentuseremail );
                    
                }
                
                
            }
        }
        catch(exception ex)
        {
            system.debug('samap01 '+ ex);
            // poc.Request_Status__c = stroldrequeststatus;
            //update poc;
        }
        
    }
    
    public static string getValueFromXMLTag(XMLStreamReader reader) {
        String DataValue;
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                DataValue = reader.getText();
            }
            reader.next();
        }
        return DataValue;
    }
    // samap01- 2/22
   
    

}