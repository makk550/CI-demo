/**************************************************************************************************
* Utility class to provide methods for webservice call.
* 
*Version Date         Owner                         Description
****************************************************************************************************
* 1.0    11/03/2015   Deepa Raman                   Class created to provide helper methods during EAI webservice callout.
**************************************************************************************************/

public with sharing class WebServiceUtilityClass {


    //public static Map<Id,List<Account>> accountIdToAccountListMap = new Map<Id,List<Account>>();
    public static Map<Id,Account> accountMap = new Map<Id,Account>();
    public static Map<Id,List<Contact>> accountIdToFirstContactListMap = new Map<Id,List<Contact>>();
    public static Map<Id,List<TAQ_Account_Team_Approved__c>> accIdToTAQAccTeamApprovedListMap = new Map<Id,List<TAQ_Account_Team_Approved__c>>();
    public static Schema.SObjectType passedObjectType ;
    public static Map< Id, User> contactIdToUserMap = new Map<Id, User>();  //Map to store user record details against Contact ID to get Profile Name.
    public static Map< String, User> PMFKeyToUserMap = new Map<String,User>();  //Map to store user record details against PMF Key to get User details.Used for Field team/people 
    public static Map<Id,List<TAQ_Account__c>> accIdToTAQAccountListMap = new Map<Id,List<TAQ_Account__c>>();
    public static Set <ID> accountInsertIdSet = new Set <ID> ();
    public static Set <ID> accountUpdateIdSet = new Set <ID> ();
    public static Set <ID> TAQAccountTeamApprovedSet = new Set <ID> ();
    public static String triggerType = '';        //Has values either as Partner_Account_Insert_Trigger/Partner_Account_Update_Trigger/Direct_Account_Trigger to indicate the type payload
    public static Map< String, TAQ_Organization_Approved__c> PMFKeyToTaqOrgApprovedMap = new Map<String, TAQ_Organization_Approved__c>();
    public static Integer taqAccountServiceCalled =0;
    
    public static Boolean taqAccountInsertServCalled =false;
    public static Boolean taqAccountUpdateServCalled =false;
    
    /***    Constructor...  ***/
    public WebServiceUtilityClass() {
        
    }
    
    
    //Method to get the DateTime feilds in required format  -- MANAR08
    public static String getValidDateFormat(DateTime dateObj) {
        if (dateObj != null)
            return dateObj.format('yyyyMMdd HH:mm:ss');
        return '';
    }
    
    
    /**
    *  Method to 
    1. Form Upsert XML.
    2. Webservice callout to EAI.
    3. Update 'Sent to EAI' flag to True on successful Webservice callout response.
    **/
    public static void callEAIWebserviceBulkRequest(Map<Id, List<sObject>> accountIdTosObjectListMap) {

        String sObjectUpsertResponse = null;
        String sObjectUpsertRequestXML = '';
        Set<id> processRecordsIds = new  Set<id>();
        
      
      
        //Call method to form XML
        if ( !accountIdTosObjectListMap.keyset().isEmpty() ) {

            String type;
            for(List<sObject> lst: accountIdTosObjectListMap.values())
            for(sobject s:lst)processRecordsIds.add(s.id);
            type = accountIdTosObjectListMap.values()[0][0].getsObjectType().getDescribe().getName();
            sObjectUpsertRequestXML = getUpsertRequestXMLForEAI(accountIdTosObjectListMap );     
       
        
            //Call Webservice callout method to send requestXML     
            if (!Test.isRunningTest()) 
            {
                if(System.isBatch())
                EAIWebServiceCallout(sObjectUpsertRequestXML,processRecordsIds,type);
                else 
                EAIWebServiceCalloutTrigger(sObjectUpsertRequestXML,processRecordsIds,type);

            } 
            taqAccountServiceCalled ++;
        }
        
       
    }
    
    
    
    /**
    * Method to collect all required details and generate EAI request XML  
        Call from TAQ Account Trigger
        Call from Standard account Trigger
        Call from TAQ Account Batch
        Call from Standard Account Batch
    **/
    public static string getUpsertRequestXMLForEAI (Map<ID,List<SObject>> accIdToSobjectMap) {
        
        /** Variable declaration  **/
        String header = '';     //Variable to store header of XML
        String footer = '';     //Variable to store footer of XML
        String xmlBody = '';    //Variable to concatenated XML body
        String accountStr = '';     //Variable to details related to one account
        String contactXMLStr = '';  //Variable to contact section details
        String contactAddressXMLStr = '';
        String customerStr = '' ;   //Variable to Customer section details
        String fieldPeopleStr = ''; //Variable to fieldPeople section details
        String fieldTeamStr = '';       //Variable to fieldteam section details 
        String partnerRelationStr = ''; //Variable to partner relationship section details
        String triggerTypeStr = '';
        Boolean bInsertAccount = False;
        Boolean bUpdateAccount = False;        
        String upsertXML = '' ; //String to store final request XML
        Map < ID, List<ID> >  accIdToATMIdMap = new Map < ID, List<ID> > ();    //Map to store Account Team Members against account Id.               
        List <Contact> contactList = new List <Contact>();  
        Set <ID> UserIdSet = new Set <ID>();  // Store Owner ID to get PMF Key     
        Set <String> pmfKeySet = new Set <String>();  // Store pmfKey of TAQ Account team approved  
        
        //XML header formation       
        header = '<?xml version="1.0" encoding="utf-8"?>' +
                    '<accountUpsertRequest>' +
                        '<accounts>' ;
        
  
            
        /** Collect all prerequisites for XML formation     **/
        
        //If XML formation is called from other than account, call method to query account details  
        List<List<Sobject>> objectRecList = accIdToSobjectMap.Values();
        system.debug('#####getUpsertRequestXMLForEAI xvnv-'+accIdToSobjectMap);
        
        passedObjectType =  objectRecList[0][0].getsObjectType();
        system.debug('#####-passedObjectType-'+passedObjectType);
        
        // FOR Account Trigger and Account Batch , The parameter has necessary information  accIdToSobjectMap
        // For Partner Account Trigger, Gather account, contact, TAQ account team approved in trigger execution
        //When batch class is executed for TAQ account, gather account 
        if(passedObjectType == TAQ_Account__c.sObjectType && System.isBatch())
         {        
            getAccountMap(accIdToSobjectMap.KeySet()); 
                        
         } 
        
        Map<Id,Account> accountDetailMap = new Map<Id,Account> ();
        //Form Map<accId,account> XML iteration
        if(passedObjectType == Account.sObjectType)
        {       
            triggerType = 'Account_Trigger';   
            for(Id accId : accIdToSobjectMap.KeySet()){
                Account acc = new Account () ;
                acc = (Account)accIdToSobjectMap.get(accId)[0] ;    
                accountMap.put(acc.id,acc);                
            }                     
        }else 
        {
            triggerType = 'Partner_Account_Trigger';
        }
        
        //XML Footer formation                      
        footer =        '</accounts>' +  
                        '<triggerType>' + triggerType +'</triggerType> '+      
                        '</accountUpsertRequest>'; 
                                
        if(!System.isBatch())
        {         
            accountDetailMap = getAccountDetailMap(accIdToSobjectMap.KeySet());
            
            if(passedObjectType == TAQ_Account__c.sObjectType && !TAQAccountTeamApprovedSet.isEmpty())
                getTAQAccountIdSet(TAQAccountTeamApprovedSet); // TAQAccountTeamApprovedSet is collected in TAQ Account trigger
        }
        
        /** XML content generation  **/
        
        for(Id accId : accIdToSobjectMap.KeySet()){
            
            if(!accountMap.isEmpty() && accountMap.containsKey(accId))
            {
                Account acc = new Account();
                acc = accountMap.get(accId) ;
                system.debug('##### Iteration for account-'+acc );
                // Populate values for Account section
                accountStr = xmlBody + '<account>' ;           
                    
                    if(acc.Enterprise_ID__c != null)
                        accountStr = accountStr + '<caAccountId>' + acc.Enterprise_ID__c + '</caAccountId>'; 
                    
                    if(acc.Enterprise_Account_Name__c != null)
                        accountStr = accountStr + '<caAccountName>' + PartnerProfileUtil.encodeXmlString(acc.Enterprise_Account_Name__c) + '</caAccountName>'; 
                    
                    if(acc.GU_DUNS_NUMBER__c != null)
                        accountStr = accountStr + '<globalParentNumber>' + PartnerProfileUtil.encodeXmlString(acc.GU_DUNS_NUMBER__c) + '</globalParentNumber>'; 
                    
                    if(acc.GU_NAME__c != null)
                        accountStr = accountStr + '<globalParentName>' + PartnerProfileUtil.encodeXmlString(acc.GU_NAME__c) + '</globalParentName>';
                    
                    if(acc.Segment__c != null)
                        accountStr = accountStr + '<segment>' + acc.Segment__c + '</segment>'; 
        
                    if(acc.GEO__c != null)
                        accountStr = accountStr + '<geo>' + PartnerProfileUtil.encodeXmlString(acc.GEO__c) + '</geo>'; 
        
                    if(acc.Sales_Area__c != null)
                        accountStr = accountStr + '<operatingArea>' + PartnerProfileUtil.encodeXmlString(acc.Sales_Area__c) + '</operatingArea>'; 
        
                    if(acc.Sales_Region__c != null)
                        accountStr = accountStr + '<salesRegion>' + acc.Sales_Region__c + '</salesRegion>'; 
                
                    if(acc.REGION_COUNTRY__C != null)
                        accountStr = accountStr + '<territory>' + acc.REGION_COUNTRY__C + '</territory>'; 
                     
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).Owner.pmfkey__c !=null)
                    {                    
                        accountStr = accountStr + '<accountOwner>' + accountDetailMap.get(accId).Owner.pmfkey__c + '</accountOwner>';
                    
                    }else if(acc.Owner.pmfkey__c != null)
                    {
                        accountStr = accountStr + '<accountOwner>' + acc.Owner.pmfkey__c + '</accountOwner>';  
                    }
                    
                    if(acc.Account_Type1__c != null)
                        accountStr = accountStr + '<accountType1>' + acc.Account_Type1__c + '</accountType1>'; 
        
                    if(acc.Account_Type__c != null)
                        accountStr = accountStr + '<accountType2>' + acc.Account_Type__c + '</accountType2>'; 
        
                    if(acc.Account_Status__c != null)
                        accountStr = accountStr + '<accountStatus>' + acc.Account_Status__c + '</accountStatus>';  
        
                    if(acc.Coverage_Model__c != null)
                        accountStr = accountStr + '<coverageModel>' + acc.Coverage_Model__c + '</coverageModel>'; 
                    
                    if(acc.Sales_Volume__c != null)
                        accountStr = accountStr + '<salesVolume>' + acc.Sales_Volume__c.toPlainString() + '</salesVolume>';
        
                    if(acc.NumberOfEmployees != null)
                        accountStr = accountStr + '<employees>' + acc.NumberOfEmployees + '</employees>'; 
        
                    if(acc.Sic != null)
                        accountStr = accountStr + '<sicCode>' + PartnerProfileUtil.encodeXmlString(acc.Sic) + '</sicCode>'; 
        
                    if(acc.SicDesc != null)
                        accountStr = accountStr + '<sicDesc>' + PartnerProfileUtil.encodeXmlString(acc.SicDesc) + '</sicDesc>'; 
    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).CreatedDate !=null)
                    {                        
                        accountStr = accountStr + '<createdDate>' + getValidDateFormat(accountDetailMap.get(accId).CreatedDate) + '</createdDate>';
                    }else if(acc.CreatedDate != null){                 
                        accountStr = accountStr + '<createdDate>' + getValidDateFormat(acc.CreatedDate) + '</createdDate>';
                    }
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).CreatedBy.pmfkey__c !=null)
                    {
                        accountStr = accountStr + '<createdById>' + accountDetailMap.get(accId).CreatedBy.pmfkey__c + '</createdById>'; 
                    }else if(acc.CreatedBy.pmfkey__c != null)
                    {
                        accountStr = accountStr + '<createdById>' + acc.CreatedBy.pmfkey__c + '</createdById>'; 
                    }   
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).LastModifiedDate !=null)
                    {
                        accountStr = accountStr + '<lastModifiedDate>' + getValidDateFormat(accountDetailMap.get(accId).LastModifiedDate) + '</lastModifiedDate>';
                    }else if(acc.LastModifiedDate!= null)
                    {
                        accountStr = accountStr + '<lastModifiedDate>' + getValidDateFormat(acc.LastModifiedDate) + '</lastModifiedDate>';
                    }
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).LastModifiedBy.pmfkey__c !=null)
                    {
                        accountStr = accountStr + '<lastModifiedById>' + accountDetailMap.get(accId).LastModifiedBy.pmfkey__c + '</lastModifiedById>'; 
                    }else if(acc.LastModifiedBy.pmfkey__c != null)
                    {
                        accountStr = accountStr + '<lastModifiedById>' + acc.LastModifiedBy.pmfkey__c + '</lastModifiedById>'; 
                    }        
                    
                    accountStr = accountStr + '<isDeleted>' + acc.IsDeleted + '</isDeleted>'; 
        
                    accountStr = accountStr + '<recordTypeId>' + acc.RecordTypeId + '</recordTypeId>'; 
        
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).Account_18_digit_ID__c !=null){
                        accountStr = accountStr + '<sfdcAccountId>' + accountDetailMap.get(accId).Account_18_digit_ID__c + '</sfdcAccountId>';
                    }else if(acc.Account_18_digit_ID__c != null)
                    {
                        accountStr = accountStr + '<sfdcAccountId>' + acc.Account_18_digit_ID__c + '</sfdcAccountId>'; 
                    }
                    //   <accountName>Fujitsu Technology Services (EMEA)</accountName>
                     accountStr = accountStr + '<accountName>' + PartnerProfileUtil.encodeXmlString(acc.Name) + '</accountName>'; 
                     
                    
                    if(acc.Billingstate != null)
                        accountStr = accountStr + '<physicalState>' + PartnerProfileUtil.encodeXmlString(acc.Billingstate) + '</physicalState>'; 
        
                    if(acc.BillingStreet != null)
                        accountStr = accountStr + '<physicalStreet>' + PartnerProfileUtil.encodeXmlString(acc.BillingStreet) + '</physicalStreet>'; 
                    
                     if(acc.billingcity != null)
                        accountStr = accountStr + '<physicalCity>' + PartnerProfileUtil.encodeXmlString(acc.billingcity)+ '</physicalCity>'; 
                        
                    if(acc.BillingPostalCode != null)
                        accountStr = accountStr + '<physicalZip>' + acc.BillingPostalCode + '</physicalZip>'; 
        
                    if(acc.Billingcountry != null)
                        accountStr = accountStr + '<physicalCountry>' + PartnerProfileUtil.encodeXmlString(acc.Billingcountry) + '</physicalCountry>'; 
        
                    if(acc.Global_Parent_Segment__c != null)
                        accountStr = accountStr + '<globalParentSegment>' + acc.Global_Parent_Segment__c + '</globalParentSegment>'; 
        
                   
        
                    if(acc.Country_Picklist__c != null)
                        accountStr = accountStr + '<countryPickList>' + acc.Country_Picklist__c + '</countryPickList>'; //No mapping
        
                   
        
                    if(acc.Is_Primary_Account__c != null)
                        accountStr = accountStr + '<splitPrimaryAccount>' + acc.Is_Primary_Account__c + '</splitPrimaryAccount>'; 
    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).Global_Parent_SIC_2_digit__c !=null)
                    {
                        accountStr = accountStr + '<globalParentSic2Digit>' + PartnerProfileUtil.encodeXmlString(accountDetailMap.get(accId).Global_Parent_SIC_2_digit__c) + '</globalParentSic2Digit>';
                    }else if(acc.Global_Parent_SIC_2_digit__c != null)
                    {
                        accountStr = accountStr + '<globalParentSic2Digit>' + PartnerProfileUtil.encodeXmlString(acc.Global_Parent_SIC_2_digit__c) + '</globalParentSic2Digit>'; 
                    }
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).Global_Parent_SIC_4_digit__c !=null)
                    {
                        accountStr = accountStr + '<globalParentSic4Digit>' + PartnerProfileUtil.encodeXmlString(accountDetailMap.get(accId).Global_Parent_SIC_4_digit__c) + '</globalParentSic4Digit>';
                    }else if(acc.Global_Parent_SIC_4_digit__c != null)
                    {
                        accountStr = accountStr + '<globalParentSic4Digit>' + PartnerProfileUtil.encodeXmlString(acc.Global_Parent_SIC_4_digit__c) + '</globalParentSic4Digit>'; 
                    }
                    
                    if(acc.Global_Parent_Industry__c != null)
                        accountStr = accountStr + '<globalParentIndustry>' + PartnerProfileUtil.encodeXmlString(acc.Global_Parent_Industry__c) + '</globalParentIndustry>'; 
                    
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).RecordType.Name !=null)
                    {                    
                        accountStr = accountStr + '<accountRecordType>' + accountDetailMap.get(accId).RecordType.Name + '</accountRecordType>';
                    
                    }else if(acc.RecordType.Name!= null)
                    {
                        accountStr = accountStr + '<accountRecordType>' + acc.RecordType.Name+ '</accountRecordType>'; 
                    }
                    
                    if(acc.Customer_Category__c != null)
                        accountStr = accountStr + '<accountType>' + acc.Customer_Category__c + '</accountType>'; 
                    
                    if(acc.Website != null)
                        accountStr = accountStr + '<webSite><![CDATA['+ acc.Website +']]></webSite>'; 
                    
                    if(acc.Alliance__c != null)
                        accountStr = accountStr + '<alliance>' + acc.Alliance__c + '</alliance>'; 
                    
                    if(acc.Alliance_Type__c != null)
                        accountStr = accountStr + '<allianceType>' + acc.Alliance_Type__c + '</allianceType>'; 
                    
                    if(acc.Alliance_Program_Level__c != null)
                        accountStr = accountStr + '<allianceProgramLevel>' + acc.Alliance_Program_Level__c + '</allianceProgramLevel>'; 
                    
                    if(acc.CPMS_ID__c != null)
                        accountStr = accountStr + '<cpmsHqId>' + acc.CPMS_ID__c + '</cpmsHqId>'; 
                    
                    if(acc.Velocity_Seller__c != null)
                        accountStr = accountStr + '<dataManagement>' + acc.Velocity_Seller__c + '</dataManagement>'; 
                    
                    if(acc.Velocity_Seller_Type__c != null)
                        accountStr = accountStr + '<dmType>' + acc.Velocity_Seller_Type__c + '</dmType>'; 
                    
                    if(acc.Velocity_Seller_Program_Level__c != null)
                        accountStr = accountStr + '<dmProgramLevel>' + acc.Velocity_Seller_Program_Level__c + '</dmProgramLevel>'; 
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).rtm__c !=null)
                    {
                        accountStr = accountStr + '<routeToMarket>' + accountDetailMap.get(accId).rtm__c + '</routeToMarket>';
                    }else if(acc.rtm__c != null)
                    {
                        accountStr = accountStr + '<routeToMarket>' + acc.rtm__c + '</routeToMarket>'; 
                    }
                    
                    if(acc.Service_Provider__c != null)
                        accountStr = accountStr + '<serviceProvider>' + acc.Service_Provider__c + '</serviceProvider>'; 
                    
                    if(acc.Service_Provider_Type__c != null)
                        accountStr = accountStr + '<serviceProviderType>' + acc.Service_Provider_Type__c + '</serviceProviderType>'; 
                    
                    if(acc.Service_Provider_Program_level__c != null)
                        accountStr = accountStr + '<spProgramLevel>' + acc.Service_Provider_Program_level__c + '</spProgramLevel>'; 
                    
                    if(acc.Solution_Provider__c != null)
                        accountStr = accountStr + '<solutionProvider>' + acc.Solution_Provider__c + '</solutionProvider>'; 
                    
                    if(acc.Solution_Provider_Type__c != null)
                        accountStr = accountStr + '<spType>' + acc.Solution_Provider_Type__c + '</spType>'; 
                    
                    if(acc.Solution_Provider_Program_Level__c != null)
                        accountStr = accountStr + '<solutionProviderProgramLevel>' + acc.Solution_Provider_Program_Level__c + '</solutionProviderProgramLevel>'; 
                    
                    if(acc.Alliance_CAM_PMFKey__c != null)
                        accountStr = accountStr + '<alliancePMFKey>' + acc.Alliance_CAM_PMFKey__c + '</alliancePMFKey>';                
                    
                    if(acc.Velocity_Seller_CAM_PMFKey__c != null)
                        accountStr = accountStr + '<dmPMFKey>' + acc.Velocity_Seller_CAM_PMFKey__c + '</dmPMFKey>'; 
    
                    if(acc.Service_Provider_CAM_PMFKey__c != null)
                        accountStr = accountStr + '<serviceProviderPMFKey>' + acc.Service_Provider_CAM_PMFKey__c + '</serviceProviderPMFKey>'; 
    
                    if(acc.Solution_Provider_CAM_PMFKey__c != null)
                        accountStr = accountStr + '<solutionProviderPMFKey>' + acc.Solution_Provider_CAM_PMFKey__c + '</solutionProviderPMFKey>';
                        
                    if(acc.Solution_Provider_CAM_PMFKey__c != null)
                        accountStr = accountStr + '<phone>' + acc.Phone + '</phone>';  // Check in the query
                    
                    if(accountDetailMap.containsKey(accId) && accountDetailMap.get(accId).Account_18_digit_ID__c !=null)
                    {
                        accountStr = accountStr + '<sfdcId>' + accountDetailMap.get(accId).Account_18_digit_ID__c + '</sfdcId>';
                    }else if(acc.Account_18_digit_ID__c != null)
                    {
                        accountStr = accountStr + '<sfdcId>' + acc.Account_18_digit_ID__c + '</sfdcId>'; 
                    } 
                    
                    if(accIdToTAQAccountListMap.get(accId)!= null && passedObjectType == TAQ_Account__c.sObjectType)
                    {
                        accountStr = accountStr + '<taqAccountId>' + accIdToTAQAccountListMap.get(accId)[0].id + '</taqAccountId>'; 
                    }              

                //Populate Values for Contacts section.
               system.debug('###### accountIdToFirstContactListMap--'+ accountIdToFirstContactListMap.Values());
               system.debug('###### accountInsertIdSet--'+ accountInsertIdSet);
               system.debug('###### accIdToTAQAccTeamApprovedListMap--'+ accIdToTAQAccTeamApprovedListMap);
                if(!accountIdToFirstContactListMap.isEmpty() && accountIdToFirstContactListMap.containskey(accId) && accountInsertIdSet.contains(acc.id))
                {               
                    system.debug('#####  Contact Iteration for account-'+accountIdToFirstContactListMap.get(accId));
                    if(!accountIdToFirstContactListMap.get(accId).isempty()) 
                    {
                        
                    contactList = accountIdToFirstContactListMap.get(acc.id); 
                    
                    contactXMLStr = '';
                        for(Contact cont : contactList){
    
                            contactXMLStr = contactXMLStr + '<contact>';
                            
                           
                                
                            if(cont.FirstName!= null)                                  
                                  contactXMLStr = contactXMLStr +'<firstName>'+cont.FirstName+'</firstName>';
                                  
                            if(cont.LastName != null)                            
                                   contactXMLStr = contactXMLStr +'<lastName>'+cont.LastName+'</lastName>';
                            
                             if(cont.Email != null)
                                contactXMLStr = contactXMLStr +'<emailAddress>'+cont.Email+'</emailAddress>';
                                                         
                            if(cont.Phone != null)
                                contactXMLStr = contactXMLStr + '<phone>'+cont.Phone+'</phone>';  
                                
                             if(cont.Fax != null)
                                contactXMLStr = contactXMLStr +'<fax>' + cont.Fax +'</fax>' ;                                                              
                              
                            if(cont.Functional_Role__c != null)
                                contactXMLStr = contactXMLStr + '<jobFunction>'+cont.Functional_Role__c+'</jobFunction>';
                            
                            if(contactIdToUserMap.containsKey(cont.Id)  && contactIdToUserMap.get(cont.Id).Profile.Name != Null)
                                 contactXMLStr = contactXMLStr + '<userProfile>'+ contactIdToUserMap.get(cont.Id).Profile.Name +'</userProfile>';
                                                                                          
                           
                                                           
                            contactXMLStr = contactXMLStr +'<sfdcId>' +cont.Contact_18_Digit_ID__c+'</sfdcId>' +  
                                                            +'</contact>' ;             
                        }//EOF contact loop         
                   
                    
                   
                    contactAddressXMLStr = ' <contactAddresses>' ;
                        for(Contact cont : contactList){
                            
                            contactAddressXMLStr = contactAddressXMLStr + '<contactAddress>';
                            if(cont.MailingStreet != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<street>' + PartnerProfileUtil.encodeXmlString(cont.MailingStreet)+'</street>' ;
                                
                            if(cont.MailingCity != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<city>' +PartnerProfileUtil.encodeXmlString(cont.MailingCity) +'</city>' ;
                                
                             if(cont.MailingState != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<region>' +PartnerProfileUtil.encodeXmlString(cont.MailingState) +'</region>' ;
                             
                             if(cont.MailingPostalCode != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<postalCode>' + cont.MailingPostalCode +'</postalCode>' ;
                                
                             if(cont.Country_Picklist__c != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<country>' +cont.Country_Picklist__c +'</country>' ;
                             
                             contactAddressXMLStr  = contactAddressXMLStr + ' <addressType>Mailing</addressType> </contactAddress>';
                             
                             contactAddressXMLStr = contactAddressXMLStr + '<contactAddress>';
                            if(cont.OTHERSTREET != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<street>' + PartnerProfileUtil.encodeXmlString(cont.OTHERSTREET)+'</street>' ;
                                
                            if(cont.OTHERCITY != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<city>' + PartnerProfileUtil.encodeXmlString(cont.OTHERCITY) +'</city>' ;
                                
                             if(cont.OTHERSTATE != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<region>' + cont.OTHERSTATE +'</region>' ;
                             
                             if(cont.OTHERPOSTALCODE != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<postalCode>' +cont.OTHERPOSTALCODE +'</postalCode>' ;
                                
                             if(cont.Country_Picklist__c != null)
                                contactAddressXMLStr  = contactAddressXMLStr +'<country>' +cont.Country_Picklist__c +'</country>' ;
                             
                             contactAddressXMLStr  = contactAddressXMLStr + ' <addressType>Other</addressType> </contactAddress> </contactAddresses>';
                                
                                
                                
                        
                        }
                    }
                }
            
                //Populate field people section 
                if(passedObjectType == TAQ_Account__c.sObjectType && accountInsertIdSet.contains(acc.id) && accIdToTAQAccTeamApprovedListMap.containsKey(accId))
                {
    
                        List<TAQ_Account_Team_Approved__c> atmList = accIdToTAQAccTeamApprovedListMap.get(accId);
        
                        //fieldPeopleStr = fieldPeopleStr + '<fieldPeople>' ;
                        //For each ATM of that account, get TAQ_Organization_Approved__c details
                        for(TAQ_Account_Team_Approved__c atm : atmList)
                        {
                            
                            if(PMFKeyToTaqOrgApprovedMap.containsKey(atm.PMFKey__c))
                            {    
                                fieldPeopleStr = fieldPeopleStr + '<fieldPeopleRecord>' ;
                                TAQ_Organization_Approved__c taqOrgAppr = PMFKeyToTaqOrgApprovedMap.get(atm.PMFKey__c);
                                
                                if(taqOrgAppr.PMFKey__c != null)
                                     fieldPeopleStr = fieldPeopleStr + '<pmfKey>' + taqOrgAppr.PMFKey__c + '</pmfKey>' ;
                                /*     
                                if(taqOrgAppr.Employee_Name__c != null)
                                     fieldPeopleStr = fieldPeopleStr + '<firstName>' + taqOrgAppr.Employee_Name__c + '</firstName>' ;
                                 */    
                                if(taqOrgAppr.Employee_Name__c != null)
                                     fieldPeopleStr = fieldPeopleStr + '<employeeName>' + taqOrgAppr.Employee_Name__c + '</employeeName>' ;
                                
                                if(taqOrgAppr.Employee_Status__c != Null)  
                                    fieldPeopleStr = fieldPeopleStr +'<status>' +  taqOrgAppr.Employee_Status__c  + '</status>' ;
                                
                                if(atm.Partner_Account_Relationship__c != null)                                    
                                 fieldPeopleStr = fieldPeopleStr + '<fieldTeamNames>' + atm.Partner_Account_Relationship__c + '</fieldTeamNames>';   
                                 
                                 fieldPeopleStr = fieldPeopleStr + '</fieldPeopleRecord>' ;  
                                                 
                            }   
                            
                                        
                            
                                                         
                                                                       
                        }
                         if(fieldPeopleStr != '') fieldPeopleStr = '<fieldPeople>' +  fieldPeopleStr + '</fieldPeople>';  
                        //fieldPeopleStr = fieldPeopleStr + '</fieldPeople>' ;
                        
                                     
                        
                       
                } 
                            
                            //Concatenate all strings to form XML 
                xmlBody =  accountStr + contactXMLStr + contactAddressXMLStr + fieldPeopleStr + fieldTeamStr + '</account>';
            }
        } //EOF Account loop
                            
        return header + xmlBody + footer ;
    }
    
    
    /**
    * Method to get account fields required for parnerrelationship section
    **/
    public static void getAccountMap (Set<ID> accIDSet) {
        
        for(Account a :[SELECT ID, Name, Enterprise_ID__c, Enterprise_Account_Name__c, Agreement_Number__c,Service_Provider_Type__c, Contract_Start_Date__c, Contract_End_Date__c, Service_Provider_Program_level__c, Region_Country__c, Account_18_digit_ID__c,
                        BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry, GU_DUNS_NUMBER__c, GU_NAME__c, Segment__c, GEO__c, Sales_Area__c, Sales_Region__c, OwnerId, Account_Type1__c, Account_Type__c, Account_Status__c, Coverage_Model__c, Sales_Volume__c, NumberOfEmployees, 
                        Sic, SicDesc, CreatedDate, CreatedBy.pmfkey__c, LastModifiedDate, LastModifiedBy.pmfkey__c, IsDeleted, RecordTypeId, Global_Parent_Segment__c, Country_Picklist__c, Is_Primary_Account__c, Global_Parent_SIC_2_digit__c, Global_Parent_SIC_4_digit__c, Global_Parent_Industry__c, RecordType.Name, Customer_Category__c,
                        Website, Alliance__c, Alliance_Type__c, Alliance_Program_Level__c, CPMS_ID__c, Velocity_Seller__c, Velocity_Seller_Type__c, Velocity_Seller_Program_Level__c, rtm__c, Service_Provider__c, Solution_Provider__c,Solution_Provider_Type__c, Solution_Provider_Program_Level__c,
                        Alliance_CAM_PMFKey__c, Velocity_Seller_CAM_PMFKey__c, Service_Provider_CAM_PMFKey__c, Solution_Provider_CAM_PMFKey__c, Owner.pmfkey__c, Phone                  
                        FROM Account WHERE ID IN : accIDSet])
        {
            accountMap.put(a.id,a);             
        }
        system.debug('##### Query from WebServiceUtilityClass --'+Limits.getQueries());
    }
           

    /**
    * Method to form get Account Owner and Recordtype name for a account when executed from trigger.
    **/
    public static Map<Id,Account> getAccountDetailMap(Set<ID> accIDSet){
        Map<Id,Account> accoundIdMap = new Map<Id,Account>();
        system.debug('##### Inside getAccountOwner');
        //Query to get Account Owner and Recordtype name for a account.
               
        for(Account a : [SELECT id, RecordType.Name, Owner.pmfkey__c, CreatedDate, CreatedBy.pmfkey__c, LastModifiedDate, LastModifiedBy.pmfkey__c, Account_18_digit_ID__c, Global_Parent_SIC_2_digit__c, Global_Parent_SIC_4_digit__c, RTM__c   FROM Account WHERE Id IN: accIDSet]){
            
            accoundIdMap.put(a.id,a);
            
        }
 
        system.debug('##### Inside getAccountOwner--'+accoundIdMap);
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
        return accoundIdMap;
    }
    
    
    public static void getAccountIdToContactListMap(Set<ID> AccountIdSet){

        Set <ID> contactIdSet = new Set <ID> ();
        
        if( !AccountIdSet.isEmpty() ) {
            system.debug('##### Inside contact 1-'+AccountIdSet);
            for(Contact c : [SELECT Id, FirstName, LastName, AccountId,Contact_18_Digit_ID__c, Email, Phone, Functional_Role__c, Salutation, Fax, MailingStreet, MailingCity, MailingState, MailingPostalCode, Country_Picklist__c,
                             OTHERSTREET, OTHERCITY, OTHERSTATE, OTHERPOSTALCODE, LastModifiedDate 
                             FROM Contact where AccountId IN: AccountIdSet ORDER BY CreatedDate asc ] ){
                system.debug('##### contact rec-'+accountIDToFirstContactListMap);
                if(accountIDToFirstContactListMap.containsKey(c.AccountId)){
                    //Do not add the later contacts, as we need only the first create Contact of an Account.
                } else {
                    accountIDToFirstContactListMap.put(c.AccountId,new List<sObject>{c}); //Add only the first created Contact.
                    contactIdSet.add(c.Id);
                }
            }
        }
        system.debug('##### accountIDToFirstContactListMap-'+accountIDToFirstContactListMap);
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
        
        if( !contactIdSet.isEmpty() ) {
            getContactProfile(contactIdSet); //Call method to get Profile name for each contact.
        }        

    }
    
    

    public static void getContactProfile(Set<ID> contactIdSet){
        
        for(User u : [SELECT id, Profile.Name, ContactId FROM User WHERE ContactId != Null AND ContactId IN: contactIdSet])
        {
            contactIdToUserMap.put(u.ContactId, u);
        }   
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
    }
        
        
        
    public static void getAcccountToTAQApprovedMap(Set<ID> TAQAccTeamAppIDSet){
        
        if( !TAQAccTeamAppIDSet.isEmpty() ) 
        {
            for(TAQ_Account_Team_Approved__c accTeam :[SELECT ID, TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c, PMFKey__c, Partner_Account_Relationship__c
                                                       FROM TAQ_Account_Team_Approved__c WHERE ID IN : TAQAccTeamAppIDSet]){
                if(accIdToTAQAccTeamApprovedListMap.containsKey(accTeam.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c))
                {
                    accIdToTAQAccTeamApprovedListMap.get(accTeam.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c).add(accTeam);
                } else 
                {
                    accIdToTAQAccTeamApprovedListMap.put(accTeam.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c,new List<TAQ_Account_Team_Approved__c>{accTeam});
                }
                
                
            }
        }
        system.debug('###### accIdToTAQAccTeamApprovedListMap--'+ accIdToTAQAccTeamApprovedListMap);
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());

    } 
    
    

    
    @future(Callout=true)
    public static void EAIWebServiceCalloutTrigger(String requestXML,Set<id>records, String type)
    {
        EAIWebServiceCallout(requestXML,records,type);
    }    
        

    /**
    * Generic Webservice Callout Method to EAI
    * 
    **/   
    public static void EAIWebServiceCallout(String requestXML,Set<id>records, String type) {
        
        String query = 'Select id,Error_Sending_To_EAI__c from '+type +' where id in :records';
        List<Sobject> processRecords = Database.Query(query);
        System.debug('query '+query);
        System.debug('processRecords__ '+processRecords);
        List<Sobject> sobjectToupdate = new List<Sobject>();
  
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml');
        req.setHeader('consumerApp', 'SFDC'); 
        //req.setHeader('Content-Encoding','gzip');
        //req.setHeader('Accept-Encoding','gzip');
        //req.setHeader('Content-Length', '2048');
        //req.setHeader('Host', System.Label.MDM_Host); // qf1ce.ca.com
        //req.setHeader('Connection', 'keep-alive');
        //String encodedb64usernamepassword = System.Label.MDM_Authorization_Key; //c2ZkY191c2VyOiRlY3VyMXR5
        //String authorizationHeader = 'Basic ' + encodedb64usernamepassword;
        //req.setHeader('Authorization', authorizationHeader);
        //req.setEndpoint(System.Label.PartnerProfileAccountSearch);        //End Point URL to EAIhttps://eaisvcseqqa.ca.com/mdm/accounts/upsert/r.v1?consumerApp=SFDC,PartnerProfileAccountUpsert
        req.setEndpoint(System.Label.PartnerProfileAccountUpsert);
        //req.setCompressed(true);        //Send Compressed XML
        req.setBody(requestXML);
        req.setTimeout(120000);
        Http http = new Http();
        String respBody = null;
        
        system.debug('##### Request XML sent to EAI--'+requestXML);
        //In case of exception try sending the request 4 times.
        try {
            HTTPResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                respBody = res.getBody();
                System.debug('##### Responsebody ' + respBody);
            } else {

            }
        } catch (Exception e1) {
            system.debug('##### Exception in Attempt 1 -'+e1);
            try {
                HTTPResponse res = http.send(req);
                if (res.getStatusCode() == 200) {
                    respBody = res.getBody();
                    System.debug('##### Responsebody ' + respBody);
                } else {

                }
            } catch (Exception e2) {
                system.debug('##### Exception in Attempt 2 -'+e2);
                try {
                    HTTPResponse res = http.send(req);
                    if (res.getStatusCode() == 200) {
                        respBody = res.getBody();
                        System.debug('##### Responsebody ' + respBody);
                    } else {
    
                    }
                } catch (Exception e3) {
                   system.debug('##### Exception in Attempt 3 -'+e3);
                }               
               
            }
        }
        
        if(respBody != null ){
            //updateErrorSendingToEAIFlag(processRecords, type,False);
            
            for(sObject sObj : processRecords){
                sObj.put('Error_Sending_To_EAI__c',False) ;
                sobjectToupdate.add(sObj);
            }
                        
        }else {
            for(sObject sObj : processRecords){
                sObj.put('Error_Sending_To_EAI__c',True) ;
                sobjectToupdate.add(sObj);
            }
        }
        System.debug('sobjectToupdate__ '+sobjectToupdate);
        if(!sobjectToupdate.isEmpty())
        {
            BooleanUtils.skipAccTrigger = true;
            SystemIdUtility.skipTAQAccount = True ;
            SystemIdUtility.skipTAQ_Account= True; 
            BooleanUtils.skipAccTrigger = true;
            Database.update(sobjectToupdate);
            
        }
    }
        

    /**
    * Method to get TAQ_Account_c id using Taq Account team approved id.
    **/
    public static void getTAQAccountIdSet(Set<ID> TAQAccTeamAppIDSet){
        system.debug('##### getTAQAccountIdSet-'+TAQAccTeamAppIDSet );
        Set<Id> TAQAccountIdSet = new Set<Id>();
        if( !TAQAccTeamAppIDSet.isEmpty() ) {
            for(TAQ_Account_Team_Approved__c accTeam :[SELECT ID, TAQ_Account_Approved__r.TAQ_Account__c FROM TAQ_Account_Team_Approved__c WHERE ID IN : TAQAccTeamAppIDSet]){
                TAQAccountIdSet.add(accTeam.TAQ_Account_Approved__r.TAQ_Account__c);
                system.debug('##### TAQ_Account__c -'+ accTeam.TAQ_Account_Approved__r.TAQ_Account__c );
            }
        }
        system.debug('##### call getTAQAccTeamAppListMap -'+TAQAccountIdSet );
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
        
        if(!TAQAccountIdSet.isEmpty())
            getTAQAccTeamAppListMap(TAQAccountIdSet);
    }
    
    
    
    /**
    * Method to get TAQ_Account_Team_Approved__c details
    **/
    public static void getTAQAccTeamAppListMap(Set<Id> TAQAccIdSet){
        
        Set<String> taqOrgPmfKey = new Set<String> ();
        
        for(TAQ_Account_Team_Approved__c tata :[SELECT ID, TAQ_Account_Approved__r.TAQ_Account__c, TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c, PMFKey__c, Partner_Account_Relationship__c FROM TAQ_Account_Team_Approved__c WHERE TAQ_Account_Approved__r.TAQ_Account__c IN : TAQAccIdSet]){
            system.debug('##### tata-'+tata);
            if(accIdToTAQAccTeamApprovedListMap.containsKey(tata.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c)){
                accIdToTAQAccTeamApprovedListMap.get(tata.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c).add(tata);
            } else {
                accIdToTAQAccTeamApprovedListMap.put(tata.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c,new List<TAQ_Account_Team_Approved__c>{tata});
            }
            
            //Taq Org record is required only on account creation
            if(accountInsertIdSet.contains(tata.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c))
                taqOrgPmfKey.add(tata.PMFKey__c);
        }
        system.debug('##### accIdToTAQAccTeamApprovedListMap-'+accIdToTAQAccTeamApprovedListMap );
        system.debug('###### taqOrgPmfKey -'+taqOrgPmfKey);
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
        
        if(!taqOrgPmfKey.isEmpty())
            getTAQOrganization(taqOrgPmfKey);        
    } 
     
     
     
   /**
    * Method to get TAQ_Account_Team_Approved__c details
    **/
    public static void getTAQOrganization(Set<String> pmfKeySet){
        Set<ID> tOrgIdSet = new Set<Id>();
        system.debug('##### inside getTAQOrganization-'+pmfKeySet);
        
        for(TAQ_Organization__c tOrg :[SELECT ID, PMFKey__c FROM TAQ_Organization__c WHERE PMFKey__c IN : pmfKeySet ORDER BY CreatedDate asc]){
            tOrgIdSet.add(tOrg.Id);
        }
        
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
        if(!tOrgIdSet.isEmpty()){
            //Call method to form map<pmfkey,EmployeeName>
            getTAQOrganizationApproved(tOrgIdSet);
        }
    } 
     


    public static void getTAQOrganizationApproved(Set<ID> tOrgIdSet){
        
        List<String> employeeStatusList = new List<String> {'Active', 'Open', 'Leave of Absence'};
        for(TAQ_Organization_Approved__c  tOrgApp :[SELECT ID, PMFKey__c, TAQ_Organization__c, Employee_Name__c, Employee_Status__c, Is_Latest_Record__c, Position_ID_Status__c  FROM TAQ_Organization_Approved__c 
                                                    WHERE TAQ_Organization__c IN: tOrgIdSet  AND Is_Latest_Record__c = True AND Employee_Status__c  IN : employeeStatusList  AND Position_ID_Status__c != 'Closed' ORDER BY CreatedDate asc]){
            
            if(PMFKeyToTaqOrgApprovedMap.containsKey(tOrgApp.PMFKey__c)){
            
            } else {
                PMFKeyToTaqOrgApprovedMap.put(tOrgApp.PMFKey__c ,tOrgApp);
            }
        }       
        system.debug('##### Query from WebServiceUtilityClass--'+Limits.getQueries());
        system.debug('###### PMFKeyToTaqOrgApprovedMap--'+ PMFKeyToTaqOrgApprovedMap);
    }
}