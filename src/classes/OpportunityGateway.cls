/**
 * Class OpportunityGateway
 *
 * Provides finder methods for accessing data in the Opportunity object.
 */
public class OpportunityGateway
{
    private static string recordtypeIdSMBAccount = (RecordTypes_Setting__c.getValues('SMB') <> null ? RecordTypes_Setting__c.getValues('SMB').RecordType_Id__c : '');
    private static string recordtypeIdNewOpp = (RecordTypes_Setting__c.getValues('New Opportunity') <> null ? RecordTypes_Setting__c.getValues('New Opportunity').RecordType_Id__c : '');
    private static string recordtypeIdAcquisition = (RecordTypes_Setting__c.getValues('Acquisition') <> null ? RecordTypes_Setting__c.getValues('Acquisition').RecordType_Id__c : '');
    private static string recordtypeIdQuoteRequest = (RecordTypes_Setting__c.getValues('Quote Request') <> null ? RecordTypes_Setting__c.getValues('Quote Request').RecordType_Id__c : '');
  

    public static Set<Id> s_IdsForDealDesk = new Set<Id>();
    public static Set<Id> s_IdsForQuoteRequest = new Set<Id>();
    public static set<id> s_oppidsforotm = new set<id>();  
    public static List<OpportunityShare> lstOS=new List<OpportunityShare>();
    public static List <OpportunityTeamMember> lstOTM = new List <OpportunityTeamMember>();
    public static Map<string,id> mPmfkeyToUserId = new Map<string,id>();
    public static List<Deal_Desk_Review__c> lst_dealDesk = new List<Deal_Desk_Review__c>(); //Deal_Desk_Review__c
    public static List<Quote_Request__c> lst_QuoteRequest = new List<Quote_Request__c>(); //OppUpdateQuoteRequestTrigger
    public static List<OpportunityLineItem> lst_OppLi = new List<OpportunityLineItem>();//chajo30 US407405
    public static List<SBQQ__Quote__c> steelbricklist;      //PATSA27 - for Send To SAP
    public static List<ROI_Request__c> listROIFinal;        //moving from Partner Opportunity trigger to gateway and handler.
    public static Set<Id> sbQuoteUpdSubscSet = new Set<Id>();

    
    private static Map<id,user> mUser = new Map<id, user>();    
    //UpdateOpportunityUSDCurrencyExchange - start
    private static Set<string> currencyCodeList=new Set<string>();
    private static Date maxCloseDate=null;
    private static Date MinCloseDate=null;  
    public static List<DatedConversionRate> conversionRates = new List<DatedConversionRate>();
    //UpdateOpportunityUSDCurrencyExchange - end
    
    //US487512 & US489475- PORAS01
    public static Map<Id,List<String>> concessionAndContractFlagVal = new Map<Id,List<String>>();
    //US487512 & US489475- PORAS01 - End
    
    //BAJPI01 - as part of US461190
    public Static Map<Id,Set<OpportunityContactRole>> oppAndContactRoles = new Map<Id,Set<OpportunityContactRole>>();
    //BAJPI01 - as part of US461190
       
    private static Set<ID> s_serviceProviderClient_otm =new Set<ID>();
    
    private static map<string,string> m_accountlookup_taqrole = new Map<String, String>{'account' => '%' , 'account_servprov' => 'PARTN SERVPROV' ,'Distributor_6' => 'PARTN SOLPROV', 
        'Reseller' => 'PARTN SOLPROV', 'Partner' => 'PARTN SERVPROV', 'Partner_1' => 'PARTN ALLIANCE' , 'Service_Provider_Client' => '%','Reseller_DM' => 'PARTN DM'};
    
  private static Map<id,List<TAQ_Account_Team_Approved__c>> mapAccountIdToPMFkey = new Map<id,List<TAQ_Account_Team_Approved__c>>();
    
  private static Set<ID> s_oppidsDDRQuoteRequest=new Set<ID>();
    
  private static List<OpportunityContactRole> onboardingContactList = new List<OpportunityContactRole>(); 
    
    //BAJPI01 - as part of US461190
    private static List<OpportunityContactRole> oppContactRoleList = new List<OpportunityContactRole>();
    private static Set<String> oppContactRoleSet = new Set<String>{'Economic Buyer','Champion','Onboarding Contact'};
    //BAJPI01 - as part of US461190
    
    public static integer classexecuted =0; 
     
    
    public static Map<id,List<id>> OppRelatedOppsMap = new Map<id,List<id>>();// merha02
    public static Map<id,List<String>> oppBU=new Map<id,List<String>>();
    

    /**
    * Loads the values of the Ids for each operation in each set before thse execution begins for After Triggers
    *
    */
    public static void loadOpportunityBulkValues()
    {
         System.debug('___!11___');
         List<Opportunity> listopp;
        Map<id,Opportunity> oldMap;
        
       
        if(Trigger.isUpdate){
           listopp=trigger.new;
           oldMap=(Map<id,opportunity>)trigger.oldMap; 
        }
        
        if(Trigger.isUpdate&&Trigger.isBefore){
            updateSalesforceCPQcontractFlag(listopp,oldMap);
            fetchOppContactRoles(listOpp);
        }
            
        
        system.debug('----class----'+classexecuted);
        if(classexecuted == 0)
            classexecuted ++;
        else
            return; 
        
        List<Opportunity> lstTrigger;
        if(trigger.isDelete)
            lstTrigger = trigger.Old;
        else
            lstTrigger = trigger.New;   
        
        System.debug('___!22___');
        set<id> setuid = new set<id>();
         
         //Begin chajo30 for US314232
        Map<Id, String> ownerPMFMap = new Map<Id, String>();
        Map<Id, String> dsrPMFMap = new Map<Id, String>();
        List<String> pmfForTAQList = new List<String>();
        Set<Id> oppsToSetOpportunityOwnerOrgSet = new Set<Id>();
        Set<Id> roiReqOppIdSet = new Set<Id>();
        Map<String, TAQ_Organization_Approved__c> taqOrgApprovedMap = new Map<String, TAQ_Organization_Approved__c>();
         //end  chajo30 for US314232   

        System.debug('___!33___');
        for(Opportunity opp: lstTrigger)
        {
            
            Opportunity oldOpp;
            if(Trigger.isUpdate)
                oldOpp = (Opportunity)Trigger.OldMap.get(opp.id);



            //UpdateOpportunityUSDCurrencyExchange
             if(Trigger.isBefore && (Trigger.isInsert || (Trigger.isUpdate &&  (opp.CloseDate<>oldOpp.CloseDate || opp.CurrencyIsoCode<>oldOpp.CurrencyIsoCode))))
             {
                currencyCodeList.add(opp.CurrencyIsoCode);
                if(maxCloseDate==null)
                {
                    maxCloseDate=opp.CloseDate;
                    MinCloseDate=opp.CloseDate;  
                }
                else
                {
                    if(opp.CloseDate>maxCloseDate)
                    {
                        maxCloseDate=opp.CloseDate;
                    }
                    else if(opp.CloseDate<MinCloseDate)
                    {
                        MinCloseDate=opp.CloseDate; 
                    }
                }
            }
                
            if(trigger.isUpdate && (opp.OwnerId!=oldOpp.OwnerId || opp.CloseDate!=oldOpp.CloseDate || opp.Amount!=oldOpp.Amount || opp.StageName!=oldOpp.StageName || opp.Type!=oldOpp.Type)) //OppUpdateDealDeskTrigger
            { 
                s_oppidsDDRQuoteRequest.add(opp.id);
                setuid.add(opp.OwnerId);
            }   

            //Sales Team from Account Lookups -start
            if(opp.Service_Provider_Client__c != null && opp.Add_Enterprise_Members__c == true)
                s_serviceProviderClient_otm.add(opp.Service_Provider_Client__c);
            //Sales Team from Account Lookups -end
           
          
        
        }

        //sunji03 -- move Tenser WFR on opportunity to trigger: set owners according to region. 
        if (Trigger.isBefore && Trigger.isInsert)
        {
            //sunji03 - only get renewal owner labels and query account names when there is AT LEAST one SF CPQ renewal in the opportunities, for efficiency. 
            boolean hasSFCPQRenewal = false;
            Set<User> renewalOwnerList;
            Map<Id,Account> accMap;
            Map<Id,string> productInstanceIdMap = new Map<id,string>();
            //sunji03 US479979  - SF CPQ Renewal Owner Rules (NA) : set to original opportunity's owner
            List<Contract> renewedContractList; 
            Map<id,id> originalOppOwnerIdMap = new Map<id,id>();
            
           // added Expiring ARR as part of CPQ backlog
            Decimal expiringArr;
            Map<Id,List<SBQQ__Subscription__c>> ListofMapSub=new   Map<Id,List<SBQQ__Subscription__c>>();
          // Ended Expiring ARR
            
            for(Opportunity opp: lstTrigger){
                if (opp.SBQQ__Renewal__c != null && opp.SBQQ__Renewal__c == true)
                {
                    hasSFCPQRenewal = true;
                    break;
                }
            }

            if (hasSFCPQRenewal)
            {
                List<string> renewalOwnerLabels = new List<string>();
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_ANDEAN_SOUTH);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_Andean_North_and_Central);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_APJ);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_Brazil);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_EMEA);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_Mexico);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_NA_HQ);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_Default);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_PSCAN_HQ);
                renewalOwnerLabels.add(Label.Opp_SFCPQ_Renewal_Owner_NA_Default);

                renewalOwnerList = new Set<User>([select Id,Name from User where name in: renewalOwnerLabels and isactive = true and UserType = 'Standard']);

                List<Id> accountId = new List<id>();
                
                List<Id> renewaledContractId = new List<id>();
                for(Opportunity opp:lstTrigger){
                   if (opp.SBQQ__Renewal__c != null && opp.SBQQ__Renewal__c == true)
                   {
                       //Only add when it's renewal opp
                       accountId.add(opp.AccountId);
                   }
                   if (opp.SBQQ__Renewal__c != null && opp.SBQQ__Renewal__c == true && opp.SBQQ__RenewedContract__c != null)
                   {
                    renewaledContractId.add(opp.SBQQ__RenewedContract__c);
                   }
                }
                if (accountId.size() > 0)
                {
                    accMap = new Map<Id,Account>([select Id,Name from Account where id in:accountId]);
                }

                List<SBQQ__Subscription__c> subscriptionList;

                if (renewaledContractId.size() > 0)
                {
                    //sunji03 US479979  - SF CPQ Renewal Owner Rules (NA) : set to original opportunity's owner     
                    renewedContractList = new List<Contract>([Select id, SBQQ__Opportunity__r.Owner.id from contract where id in:renewaledContractId and SBQQ__Opportunity__r.Owner.isActive = true]);  
                    for(Contract con : renewedContractList){        
                        originalOppOwnerIdMap.put(con.id,con.SBQQ__Opportunity__r.Owner.id);        
                    } 
                    
                    subscriptionList = new List<SBQQ__Subscription__c>([select SBQQ__Contract__c,Expiring_ARR__c, Instance_Id__c from SBQQ__Subscription__c where SBQQ__Contract__c in: renewaledContractId]);

                    if (subscriptionList != null && subscriptionList.size() > 0)
                    {
                        // added Expiring ARR as part of CPQ backlog
                        List<SBQQ__Subscription__c> listsub;
                        for (SBQQ__Subscription__c s:subscriptionList)
                        {
                             if(!ListofMapSub.containsKey(s.SBQQ__Contract__c)){
                                listsub=new List<SBQQ__Subscription__c>();
                                listsub.add(s);
                                ListofMapSub.put(s.SBQQ__Contract__c,listsub);
                              }else{
                                  if(listsub!=null)
                                    listsub.add(s);
                                }
                            // Ended Expiring ARR
                            if (s.Instance_Id__c !=null && s.Instance_Id__c !='')
                            {
                                if (!productInstanceIdMap.containsKey(s.SBQQ__Contract__c))
                                {
                                    productInstanceIdMap.put(s.SBQQ__Contract__c,s.Instance_Id__c);
                                }
                            }
                        }
                    }
                }
            }
            
              // added Expiring ARR as part of CPQ backlog
          Map<Id,Decimal> expiringamontMap=new  Map<Id,Decimal>();
            for(Id contractId:ListofMapSub.keySet()){
                Decimal expirval=0.00;
                for(SBQQ__Subscription__c subrecord:ListofMapSub.get(contractId)){
                     expirval+=subrecord.Expiring_ARR__c;
                    expiringamontMap.put(contractId,expirval);
                    
                  }
                
                
              }
             // Ended Expiring ARR

            for(Opportunity opp: lstTrigger){
               if (opp.SBQQ__Renewal__c != null && opp.SBQQ__Renewal__c == true)
               {
                   // added Expiring ARR as part of CPQ backlog
                     opp.Expiring_ARR__c=expiringamontMap.get(opp.SBQQ__RenewedContract__c);
                    // Ended Expiring ARR
                    if (renewalOwnerList.Size() > 0)
                    {
                        if (opp.Rpt_Region__c == 'APJ')
                        {
                            opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_APJ);
                        }
                        else if (opp.Rpt_Region__c == 'NA')
                        {
                             //sunji03 US479979  - SF CPQ Renewal Owner Rules (NA) : set to original opportunity's owner
                            boolean originalOppOwnerFound = false;
                            if (renewedContractList.size() > 0)
                            {
                               for (Contract c :renewedContractList)
                               {
                                    if (c.id == opp.SBQQ__RenewedContract__c)
                                    {
                                         id originalOppOwnerId =  originalOppOwnerIdMap.get(c.id);
                                           if (originalOppOwnerId != null)
                                           {
                                                opp.OwnerId = originalOppOwnerId;
                                                originalOppOwnerFound = true;
                                           }
                                    }
                               }
                            }

                            if (!originalOppOwnerFound)
                            {
                                opp.OwnerId  = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_NA_Default);
                            }
                        }
                        else if (opp.Rpt_Region__c == 'LA')
                        {
                            if (opp.Rpt_Territory_Country__c == 'ANDEAN - SOUTH') 
                            {
                                opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_ANDEAN_SOUTH);
                            }
                            else if (opp.Rpt_Territory_Country__c == 'ANDEAN - NORTH' || opp.Rpt_Territory_Country__c == 'ANDEAN - CENTRAL') 
                            {
                                opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_Andean_North_and_Central);
                            }
                            else if (opp.Rpt_Area__c == 'BRAZIL') 
                            {
                                opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_Brazil);
                            }
                            else if (opp.Rpt_Area__c == 'MEXICO')
                            {
                                opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_Mexico);
                            }
                            else 
                            {
                                opp.OwnerId = getSFCPQRenewalOwnerID(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_Default);
                            }
                        }
                        else if (opp.Rpt_Region__c  == 'EMEA')
                        {
                            opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_EMEA);
                        }
                        else if (opp.Rpt_Region__c  == 'PS/CAN')
                        {
                            //sunji03 - FY19, when public sector and Canada is in NA, it's using Opp_SFCPQ_Renewal_Owner_NA_HQ, so assign to Opp_SFCPQ_Renewal_Owner_PSCAN_HQ
                            opp.OwnerId = getSFCPQRenewalOwnerIDWithDefault(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_PSCAN_HQ);
                        }
                        else //No region
                        {
                            opp.OwnerId = getSFCPQRenewalOwnerID(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_Default);
                        }
                    }

                    opp.StageName = Label.Opp_Stage_20_Percent;
                    string productInstanceId = '';

                    if (accMap != null && accMap.Size() > 0)
                    {
                        opp.Name = 'CPQ Renwl-' + accMap.get(opp.AccountId).Name + '-' +  string.valueof(opp.CloseDate);
                    }
                    else
                    {
                        opp.Name = 'CPQ Renwl-' + string.valueof(opp.CloseDate);
                    }
                    if (productInstanceIdMap != null && productInstanceIdMap.size() > 0)
                    {
                        productInstanceId = productInstanceIdMap.get(opp.SBQQ__RenewedContract__c);
                    }
           
                    if (productInstanceId != '')
                    {
                        opp.Name += '-PID' + productInstanceId;
                    }
                    opp.Inside_Outside__c = 'Outside';      
                    opp.RoadmapToPlan__c = true;
                    opp.Contract_Type__c = 'SAAS';  //should be SAAS and not SaaS.
                    if(opp.Reseller__c!=null)
                        opp.Type = '1 Tier';
                    else if(opp.Reseller__c==null)
                        opp.Type = 'Direct';
                    //opp.route__c = 'Direct';
                    opp.Business_type__c = 'Medium Touch';
                    opp.New_Deal_Term_months__c = integer.valueof(Label.Opp_SFCPQ_Renewal_Month_Term);
                }
                else //not renewal
                {
                    if (opp.SBQQ__AmendedContract__c != null) //Amendment 
                    {
                        opp.Inside_Outside__c = 'Outside';      
                        //opp.RoadmapToPlan__c = true;
                        opp.Contract_Type__c = 'SAAS';  //should be SAAS and not SaaS.
                        //opp.route__c = 'Direct';
                        if(opp.Reseller__c!=null)
                            opp.Type = '1 Tier';
                        else if(opp.Reseller__c==null)
                            opp.Type = 'Direct';
                    }
                }
            }
        } //end of sunji03 
        
        //begin chajo30 US407405
        if(Trigger.isBefore && Trigger.isUpdate){

            Set<Id> oppIds = new Set<Id>();
            List<Opportunity> listOpps = new List<Opportunity>();
            Map<Id, Date> oppLineItemDateMap = new Map<Id,Date>();
            Map<Id, List<OpportunityLineItem>> mapopli = new Map<Id, List<OpportunityLineItem>>();
            
             // added Expiring ARR as part of CPQ backlog
              Decimal expiringArr;
              Set<Id> renewaledContractId=new Set<Id>();
              Map<Id,List<SBQQ__Subscription__c>> ListofMapSub=new   Map<Id,List<SBQQ__Subscription__c>>();
              List<SBQQ__Subscription__c> subscriptionList;
            // Ended Expiring ARR    
            
                
            RecordTypes_Setting__c newOppRec = RecordTypes_Setting__c.getValues('New Opportunity');  //to get details from custom setting for New Opportunity Record Type 
            string newOppRecType;   //stores the record type id of New Opportunity Record type. 
    
            if(newOppRec!=null)
                newOppRecType = newOppRec.RecordType_Id__c; 

            for(Opportunity opp: lstTrigger){
                if(opp.Opportunity_Type__c!=null && opp.Opportunity_Type__c.contains('Renewal') && opp.RecordTypeId==newOppRecType && opp.Expiration_Reason__c==null)
                    oppIds.add(opp.id);
                 // added Expiring ARR as part of CPQ backlog
                 if (opp.SBQQ__Renewal__c != null && opp.SBQQ__Renewal__c == true && opp.SBQQ__RenewedContract__c != null)
                   {
                    renewaledContractId.add(opp.SBQQ__RenewedContract__c);
                   }
                //Ended Expiring ARR
                System.debug('===enter ex reason for opp id');
            }
            
                    // added Expiring ARR as part of CPQ backlog
         If(renewaledContractId.size()>0)
            subscriptionList = new List<SBQQ__Subscription__c>([select SBQQ__Contract__c,Expiring_ARR__c, Instance_Id__c from SBQQ__Subscription__c where SBQQ__Contract__c in: renewaledContractId]);
                  if (subscriptionList != null && subscriptionList.size() > 0)
                    {
                        List<SBQQ__Subscription__c> listsub;
                        for (SBQQ__Subscription__c s:subscriptionList)
                        {
                            if(!ListofMapSub.containsKey(s.SBQQ__Contract__c)){
                                listsub=new List<SBQQ__Subscription__c>();
                                listsub.add(s);
                                ListofMapSub.put(s.SBQQ__Contract__c,listsub);
                              }else{
                                  if(listsub!=null)
                                    listsub.add(s);
                              }
                        }
                    }
             
           Map<Id,Decimal> expiringamontMap=new  Map<Id,Decimal>();
            for(Id contractId:ListofMapSub.keySet()){
                Decimal expirval=0.00;
                for(SBQQ__Subscription__c subrecord:ListofMapSub.get(contractId)){
                     expirval+=subrecord.Expiring_ARR__c;
                    expiringamontMap.put(contractId,expirval);
                    
                  }
                
                
              }
            // Ended Expiring ARR
        
            if(lst_OppLi == null && oppIds.size()>0) {
                lst_OppLi = [Select Id, Active_Contract_Product__c,Active_Contract_Product__r.Dismantle_Date__c,
                    OpportunityId from OpportunityLineItem where OpportunityId in: oppIds and Active_Contract_Product__c!=null ORDER BY 
                    Active_Contract_Product__r.Dismantle_Date__c DESC];
            }

            List<id> oppId = new List<id>();

            System.debug('***listOppLI ---'+lst_OppLi );
            //ADDED BY SAMTU01 - US302066
            for(OpportunityLineItem opplst : lst_OppLi){
                if(opplst.Active_Contract_Product__c!=null)
                    oppLineItemDateMap.put(opplst.OpportunityId,opplst.Active_Contract_Product__r.Dismantle_Date__c);
            }    
            
                    
            
            System.debug('***oppLineItemDateMap---'+oppLineItemDateMap);
            for(Opportunity opps:lstTrigger){
                if(opps.Opportunity_Type__c!=null && opps.Opportunity_Type__c.contains('Renewal'))
                    listOpps.add(opps);
                    oppId.add(opps.Id);
                 // added Expiring ARR as part of CPQ backlog
                 if (opps.SBQQ__Renewal__c != null && opps.SBQQ__Renewal__c == true)
                 {
                   opps.Expiring_ARR__c=expiringamontMap.get(opps.SBQQ__RenewedContract__c);
                 }
                // ended Expiring ARR
                
            }        
            
            
            
            
            
            //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team

            for(Opportunity opps:lstTrigger){
               
               boolean hasonboardingContact = false;

               if (onboardingContactList.Size() > 0)
                {
                    for (OpportunityContactRole r:onboardingContactList )
                    {
                        if (r.OpportunityId == opps.id)
                        {
                            hasonboardingContact = true;
                            break;
                        }
                    }
                    
                }

                system.debug('hasonboardingContact is ' + hasonboardingContact);
                system.debug('ARR_New_Product__c is ' + opps.ARR_New_Product__c);

                //ARR_New_Product__c field has the products with business type of "New", there should be at least 1 product in the opportunity with business type of "New"
                if (
                    (!hasonboardingContact || opps.Onboarding_Contact_Language__c == null || opps.Purchase_Reason__c == '' || opps.Purchase_Reason__c == null)
                    && opps.StageName == Label.Opp_Stage_Closed_Won && opps.ARR_New_Product__c > 0 &&
                    opps.CloseDate > date.newInstance(Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.left(4)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.mid(4,2)),Integer.valueOf(Label.MEDDPICC_VALIDATION_DATE.right(2)))
                    && (opps.Contract_Type__c == Label.Opp_Contract_Type_ELA || opps.Contract_Type__c == Label.Opp_Contract_Type_New_License || 
                    opps.Contract_Type__c == Label.Opp_Contract_Type_SAAS || opps.Contract_Type__c == Label.Opp_Contract_Type_MSP)
                    ) 
                {
                    if (hasonboardingContact)
                    {
                        opps.addError(Label.Opp_OnboardingContact_Error_Message);
                    }
                    else 
                    {
                        opps.addError(Label.Opp_OnboardingContact_Error_Message + ' ' + Label.Opp_OnboardingContact_Location_Error_Message);
                    }
                }

            }   
            //end of sunji03

            for(Opportunity oppty:listOpps){ 
                  System.debug('==Out oppLineItemDateMap'+oppLineItemDateMap.size());
                if(oppLineItemDateMap.size()>0){
                    System.debug('==enter oppLineItemDateMap');
                    DateTime createddate = Datetime.newInstance(2017, 6, 16); //Modified by SAMTU01 - US386137
                    if(oppty.CreatedDate > createddate && oppty.CloseDate + 1 > oppLineItemDateMap.get(oppty.id) && oppty.Expiration_Reason__c==null && OpportunityHandler.renewalToOppConversion != true){ //Modified by SAMTU01 - US386137
                                        System.debug('===enter ex reason for Error Message');
                        oppty.addError('Please select Expiration reason field in Renewals Information section');    
                    }
                }       
            } //ADDED BY SAMTU01 - US302066 --ends here
        }
        //end chajo30 
        
        //moving from Partner Opportunity trigger to gateway and handler.
        if(Trigger.isBefore && Trigger.isUpdate){
            Opportunity oldOpp;
            for(Opportunity opp: lstTrigger){
                
                oldOpp = (Opportunity)Trigger.OldMap.get(opp.id);
                
                if ((opp.StageName == Label.Opp_Stage_Closed_Won && oldOpp.StageName != Label.Opp_Stage_Closed_Won) 
                || (opp.StageName == Label.Opp_Stage_Closed_Lost && oldOpp.StageName != Label.Opp_Stage_Closed_Lost)) 
                    roiReqOppIdSet.add(opp.id);
            }

            if(roiReqOppIdSet!=null && roiReqOppIdSet.size()>0 && listROIFinal==null){
                listROIFinal = new List<ROI_Request__c>();
                listROIFinal = [select id, Request_Status__c from ROI_Request__c where Oppty_Name__c in : roiReqOppIdSet 
                                and Request_Status__c != 'Closed'];
                
                if(listROIFinal!=null && listROIFinal.size()>0){
                    for (ROI_Request__c recROI: listROIFinal) {
                        recROI.Request_Status__c = 'Closed';
                    }
                }
            }            
        }
        //moving from Partner Opportunity trigger to gateway and handler.
        
        System.debug('___!66___');

        
        if(currencyCodeList.size()>0)
        {
            //get Dated Conversion Rates
            conversionRates=[Select StartDate, NextStartDate, LastModifiedDate, IsoCode, ConversionRate 
            From DatedConversionRate where IsoCode in:currencyCodeList and StartDate<=:MinCloseDate and NextStartDate>:maxCloseDate];
        }
              System.debug('___!77___');  
        
        Set<String> setpmf = new set<String>(); 
    
        //Sales Team From TAQ - Start
    
    System.debug('___999___'+ s_serviceProviderClient_otm.size());
        if(s_serviceProviderClient_otm.size() > 0  ) //No processing if no relevant account id
        {
            System.debug('------*****************-----'+s_serviceProviderClient_otm);
            
            Set<string> spmfkey_temp;
            mapAccountIdToPMFkey = new Map<id,List<TAQ_Account_Team_Approved__c>>();
            //SOQL  - Get the TAQ Account Team records for all the Account lookups
            
      System.debug('------*****************-----'+s_serviceProviderClient_otm);
            System.debug('------*****************-----'+m_accountlookup_taqrole);

                
            for(TAQ_Account_Team_Approved__c atm: [select TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.RecordType.Name , id,PMFKey__c,taq_Role__c, TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c from TAQ_Account_Team_Approved__c
            where 
            TAQ_Account_Approved__r.TAQ_Account__c <> null AND
            TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c <> null AND
            (
                
        TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_serviceProviderClient_otm AND TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.RecordType.Name in ('SMB','Account Team Covered Account','Territory Covered Account') 

            )
            AND            
            TAQ_Account_Approved__r.Is_Latest_Record__c = true])
            {
                System.debug(atm.id+'____into this loop' + atm.pmfkey__c);
                 mapAccountIdtoPMFkey = getmapAccountIdtoPMFkey(atm,mapAccountIdtoPMFkey);      
                 setpmf.add(atm.pmfkey__c.toUpperCase());   
            }
             mPmfkeyToUserId = new Map<String,id>();
          }
          
          system.debug('>>>>>>>>____set' + setpmf);
          
        if(setpmf.size() > 0 || setuid.size() > 0) //Sales Team + Quote Request
             {
                //SOQL - Retrieve user id for the TAQ Account Team PMFkey   
                 mUser = new Map<id,User>([select id,name, pmfkey__c from user where ((pmfkey__c in : setpmf ) OR id in: setuid) and pmfkey__c <> null and isActive = true ]); //
                 for(user u:mUser.values())
                    mPmfkeyToUserId.put(u.pmfkey__c.touppercase(), u.id);
             }  
         //Sales Team from TAQ - end
    
    if(s_oppidsDDRQuoteRequest.size() > 0)
        {
            for (Deal_Desk_Review__c dd:[SELECT Id, Name,Opportunity_Name__c FROM Deal_Desk_Review__c WHERE Opportunity_Name__c in :s_oppidsDDRQuoteRequest])
            {    
                //get the parent opportunity
                Opportunity opp= (Opportunity) Trigger.newMap.get(dd.Opportunity_Name__c);            
                dd.Opportunity_Owner__c = opp.OwnerId;
                dd.Oppty_Close_Date__c = opp.CloseDate;
                dd.Oppty_Amount__c  = opp.Amount;
                dd.Sales_Milestone__c  = opp.StageName;
                dd.Type__c = opp.Type;
                if(!addedIds.contains(dd.id))
                {
                lst_dealDesk.add(dd);
                addedIds.add(dd.id);
                }
             }
             
            //OppUpdateQuoteRequestTrigger  
            for (Quote_Request__c qreq:[SELECT Id, Name,Opportunity_Name__c FROM Quote_Request__c WHERE Opportunity_Name__c in :s_oppidsDDRQuoteRequest])
            {     
                //get the parent opportunity
                Opportunity opp= (Opportunity)Trigger.newMap.get(qreq.Opportunity_Name__c);  
                Opportunity oppOld= (Opportunity)Trigger.oldMap.get(qreq.Opportunity_Name__c);  
                
                User ownr = mUser.get(opp.OwnerId);
                qreq.Oppty_Owner__c = opp.OwnerId;
                qreq.Opportunity_Owner__c = (ownr <> null ? ownr.Name:'');
                qreq.Opportunity_Close_Date__c = opp.CloseDate;
                qreq.Opportunity_Amount__c  = opp.Amount;
                qreq.Sales_Milestone__c  = opp.StageName;
                qreq.Type__c = opp.Type;

                if(oppOld.IsClosed==true && opp.IsClosed==false)
                {
                    if(recordtypeIdQuoteRequest <> null && recordtypeIdQuoteRequest <> '' )
                        qreq.RecordTypeId = recordtypeIdQuoteRequest;
                    qreq.Request_Status__c = 'Updated';
                }
               if(!addedIds.contains(qreq.id) )
               {     
                lst_QuoteRequest.add(qreq);
                addedIds.add(qreq.id);
               }        
            }   
        
        
        
        }   
            
   }
   
    public static void loadSbQuoteOpportunityBulkAfterUpdate(){
        
        if(Trigger.isUpdate && Trigger.IsAfter){
            for (Opportunity opp : (List<Opportunity>) Trigger.new)
            {
                //If Opportunity is contracted, find source subscriptions, update Quote Group Id field to support amendments with Groups
                Opportunity oldOpp = (Opportunity) Trigger.oldMap.get(opp.Id);
                
                //If Contract was just contracted
                if ( !oldOpp.SBQQ__Contracted__c && opp.SBQQ__Contracted__c && opp.SBQQ__PrimaryQuote__c!=null )
                {
                    sbQuoteUpdSubscSet.add(opp.SBQQ__PrimaryQuote__c);
                }
            }
            if(sbQuoteUpdSubscSet!=null && sbQuoteUpdSubscSet.size()>0){
                 if (System.isFuture() || System.isBatch())
                    updateSubscriptionGroupIdsNow(sbQuoteUpdSubscSet);
                else
                    updateSubscriptionGroupIdsFuture(sbQuoteUpdSubscSet);
            }
        }
        
        
    }
    
   Private Static Set<id> addedIds = new Set<id>();
   
   //sunji03 - utility to get renewal opp owner
   private static Id getSFCPQRenewalOwnerID(Set<User> renewalOwnerList, string label)
   {
        Id ownerId;
        for (User u:renewalOwnerList)
        {
            if (u.Name == label)
            {
               ownerId = u.Id;
               break;
            }
        }
        return ownerId;
   }//end of sunji03
    
    private static Id getSFCPQRenewalOwnerIDWithDefault(Set<User> renewalOwnerList, string userLabel)       
   {        
        Id ownerId = getSFCPQRenewalOwnerID(renewalOwnerList,userLabel);        
         if (ownerId == null)       
        {       
          ownerId = getSFCPQRenewalOwnerID(renewalOwnerList,Label.Opp_SFCPQ_Renewal_Owner_Default);     
        }       
          return ownerId;       
  } 
    
   public static Map<id,List<TAQ_Account_Team_Approved__c>> getmapAccountIdtoPMFkey(TAQ_Account_Team_Approved__c atm, Map<id,List<TAQ_Account_Team_Approved__c>> mAccountToPMFkeyMatch)
    {     
        List<TAQ_Account_Team_Approved__c>  listPmfkey_temp = mapAccountIdtoPMFkey.get(atm.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c);
          if(listPmfkey_temp == null) { listPmfkey_temp = new List<TAQ_Account_Team_Approved__c>();}
          listPmfkey_temp.add(atm);
          mapAccountIdtoPMFkey.put(atm.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c, listPmfkey_temp);
          return mapAccountIdtoPMFkey;
    }
   
  //Method used mAccountToPMFkeyMatch, mPmfkeyToUserId from outside 
    public static void addlistOpportunityTeamMemberfromTAQ(id oppid, id accountid, String role)
    {   

        List<TAQ_Account_Team_Approved__c>  listPmfkey_temp = mapAccountIdtoPMFkey.get(accountid);
        System.debug('___xxx___'+mapAccountIdtoPMFkey);
        System.debug('____1 if____'+listPmfkey_temp);
        System.debug('____2 if____'+accountid);
        if(listPmfkey_temp <> null && listPmfkey_temp.size() > 0) 
        {  
             for(TAQ_Account_Team_Approved__c  taqatm : listPmfkey_temp)
            {   
            //   System.debug('____for___');
                 if(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()) <> null)  
                 {                                  
               //    System.debug('___meth call');
                 Opportunity Opp = (Opportunity)Trigger.newMap.get(oppid);
               if (Opp.Reseller__c == accountid || Opp.Distributor_6__c == accountid)
               {  

                     If ((opp.Type == '1 Tier' || opp.Type == '2 Tier' || opp.Type == 'Direct' || opp.Type == 'xSP' || opp.Type == 'Direct') && (taqatm.taq_role__c == 'TAQ-PARTN SOLPROV' || taqatm.taq_role__c == 'TAQ-PARTN SERVPROV' || taqatm.taq_role__c == 'TAQ-PARTN ALLIANCE'))
                        addOppTeamMember(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()), oppid, taqatm.taq_role__c); 
                     Else if (Opp.Type != '1 Tier' && Opp.Type != '2 Tier' && Opp.Type != 'Direct' && Opp.Type != 'xSP' && opp.Type != 'Direct') 
                        addOppTeamMember(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()), oppid, taqatm.taq_role__c);   
                     //System.debug('_____Inside addOppTeamMember**************************** ____'+Opp.Type+taqatm.taq_role__c+taqatm.pmfkey__c);
                }
                Else
                {
                 addOppTeamMember(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()), oppid, taqatm.taq_role__c); 
                  }   
                 }
          }
        }
    
    } 
   
  public static map<id, set<id>> mapOppIdsSalesTeamUserId = new map<id, set<id>>();
   
  public static void addOppTeamMember(id userid, id oppid, string teamrole)
  {
    
    System.debug('_____Inside addOppTeamMember**************************** ____');
          set<id> suserid = mapOppIdsSalesTeamUserId.get(oppid);
          if(suserid == null ){ suserid = new set<id>();}
          if(suserid.contains(userid) <> true)
          { 
          
          OpportunityTeamMember otm = new OpportunityTeamMember();
          otm.TeamMemberRole = teamrole;
          otm.OpportunityId = oppid;
          otm.UserId = userid;
          otm.OpportunityAccessLevel='edit';
          lstOTM.add(otm);
          
          System.debug('--inoppGateway=='+lstOTM);
      
          OpportunityShare os =new OpportunityShare ();
          os.RowCause = 'Team';
          os.OpportunityId=oppid;
          os.UserOrGroupId=userid;
          os.OpportunityAccessLevel='edit';
          lstOS.add(os);
         } 
         System.debug('_____lstOTM size____'+lstOTM.size());
         System.debug('_____lstOS size____'+lstOS.size());
  }
 

public static List<FeedItem> addFeedToList(List<FeedItem> lstfeed, id parentid, string chattermessage)
    {
        FeedItem renChatterPost = new FeedItem();
        renChatterPost.ParentId = parentid;
        renChatterPost.body = chattermessage;
        lstfeed.add(renChatterPost);
        return lstfeed;
    }


    //PATSA27 - for Send To SAP
    public static void updateSalesforceCPQcontractFlag(List<opportunity> listopp,Map<id,opportunity> mapopp){
        System.debug('===========entermethod');
        Map<id,Opportunity> oppMap=new Map<id,Opportunity>();
        RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
        string steelBrickRecType;
        if(sbRecType!=null)
            steelBrickRecType = sbRecType.RecordType_Id__c;
        Map<id,string> mapstage=new Map<id,String>();
        if(listopp!=null&&mapopp!=null){
            for(Opportunity opp:listopp){
                System.debug('======opp.RecordType.Name'+opp.RecordTypeId);
                System.debug('======opp.RecordType.Name'+opp.StageName);
                
                if(opp.RecordTypeId ==steelBrickRecType){
                    mapstage.put(opp.id, opp.StageName);
                    System.debug('enter into Uncheck-----'+opp.StageName);
                    System.debug('enter into Uncheck-----'+mapopp.get(opp.id).StageName);
                    if(opp.StageName==Label.Opp_Stage_Closed_Won && mapopp.get(opp.id).StageName!=Label.Opp_Stage_Closed_Won){
                        oppMap.put(opp.id,opp);
                    }else if(mapopp.get(opp.id).StageName==Label.Opp_Stage_Closed_Won && opp.StageName!=Label.Opp_Stage_Closed_Won){
                        System.debug('enter into Uncheck-----'+opp.StageName);
                        oppMap.put(opp.id,opp);  
                        
                    }
                }
                
            }
            
            if(oppMap.size()>0){
                if(steelbricklist==null){
                    system.debug('--entered to query quotes---');
                    steelbricklist = new List<SBQQ__Quote__c>();
                    //US487512 & US489475- PORAS01 - Added "Concession_offered_due_to_a_prior_deal__c" & "Isthisdeallinkedtootherdeals__c" in SBQQ__Quote__c Query
                    for(SBQQ__Quote__c sbquote :[SELECT id,SBQQ__Opportunity2__c,Salesforce_CPQ_Quote_Signed__c,Concession_offered_due_to_a_prior_deal__c
                                                 //,Isthisdeallinkedtootherdeals__c
                                                 FROM SBQQ__Quote__c 
                                                 WHERE SBQQ__Opportunity2__c=:oppMap.keySet() 
                                                 AND SBQQ__Primary__c=true]){
                        if(oppMap.get(sbquote.SBQQ__Opportunity2__c).StageName==Label.Opp_Stage_Closed_Won){
                            //US487512 & US489475 - PORAS01 - Setting value for Map to get Concession_offered_due_to_a_prior_deal__c & Isthisdeallinkedtootherdeals__c value in OppHandler
                            List<String> concessionAndContractFlagValList = new List<String>();
                            concessionAndContractFlagValList.add(sbquote.Concession_offered_due_to_a_prior_deal__c);
                            //concessionAndContractFlagValList.add(sbquote.Isthisdeallinkedtootherdeals__c);
                            concessionAndContractFlagVal.put(sbquote.SBQQ__Opportunity2__c,concessionAndContractFlagValList);
                            //US487512 & US489475- PORAS01 - End      
                            sbquote.Salesforce_CPQ_Quote_Signed__c=true;
                            System.debug('==========enter 1000');
                        }
                        else if(oppMap.get(sbquote.SBQQ__Opportunity2__c).StageName!=Label.Opp_Stage_Closed_Won){
                            sbquote.Salesforce_CPQ_Quote_Signed__c=false;
                            System.debug('========enter not 1000');
                        }
                        
                        steelbricklist.add(sbquote);
                    }
                }                
            }
            
        }  
        
    }
    //PATSA27 - for Send To SAP
    
    @future(callout=true)
    public static void updateSubscriptionGroupIdsFuture(Set<Id> tempquoteIds){
        updateSubscriptionGroupIdsNow(tempquoteIds);
    }
    public static void updateSubscriptionGroupIdsNow(Set<Id> quoteId)
    { 
        //Get unique
        List <SBQQ__QuoteLine__c> quoteLines = new List <SBQQ__QuoteLine__c>([select id, SBQQ__UpgradedSubscription__c, Quote_Group_Id__c, SBQQ__Quote__c
            from SBQQ__QuoteLine__c where SBQQ__Quote__c IN : quoteId and SBQQ__UpgradedSubscription__c != null]);
        
        if ( quoteLines.size() > 0 )
        {
            Set <Id> upgradedSubIds = new Set <Id>();
            Map <Id, Id> subscriptionGroupMap = new Map <Id, Id>();
            
            for (SBQQ__QuoteLine__c ql : quoteLines)
            {
                if ( !upgradedSubIds.contains(ql.SBQQ__UpgradedSubscription__c) )
                {
                    upgradedSubIds.add(ql.SBQQ__UpgradedSubscription__c);
                }
                
                subscriptionGroupMap.put(ql.SBQQ__UpgradedSubscription__c, ql.Quote_Group_Id__c);
            }
        
            List <SBQQ__Subscription__c> subscriptions = new List <SBQQ__Subscription__c>([select id, Quote_Group_Id__c
                from SBQQ__Subscription__c where id in :upgradedSubIds]);
                
            for (SBQQ__Subscription__c sub : subscriptions)
            {
                sub.Quote_Group_Id__c = subscriptionGroupMap.get(sub.id);
            }
            
            update subscriptions;
            
            
            List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>([select id, Opportunity_Contracted__c from SBQQ__Quote__c where id IN:
                                                                        quoteId]);
            for(SBQQ__Quote__c quote:quoteList){
                quote.Opportunity_Contracted__c = true;
            }
            
            if(quoteList!=null && quoteList.size()>0)
                update quoteList;
            
        }
    }   
    
    public static void fetchOppContactRoles(List<opportunity> listopp){
        
        Set<Id> tempIdSet = new Set<id>();
        Map<id,id> oppAccMap = new Map<id,id>(); // map of opp and its account -- merha02
        
        if(listopp!=null && listopp.size()>0){
            for(Opportunity opp:listOpp){
                oppAccMap.put(opp.id,opp.AccountId);
                tempIdSet.add(opp.id);
            }
        }
        
        //BAJPI01 - as part of US461190
        oppContactRoleList = [select OpportunityId,Id,Role,IsPrimary,ContactId from OpportunityContactRole 
                              where (Role IN:oppContactRoleSet or Isprimary=true) AND OpportunityId IN:tempIdSet];
        
        //BAJPI01 - as part of US461190 
        Map<Id,Id> PrimaryContactMap = new Map<Id,Id>(); // map of opp and its primary contact --- merha02
        
        if(oppContactRoleList.size()>0){
            for(OpportunityContactRole ocr:oppContactRoleList){
                if(ocr.IsPrimary){
                    PrimaryContactMap.put(ocr.OpportunityId,ocr.ContactId); 
                }
                if(oppContactRoleSet.contains(ocr.Role)){
                    //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team
                    if(ocr.Role=='Onboarding Contact')
                        onboardingContactList.add(ocr);
                    //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team
                    
                    //BAJPI01 - as part of US461190
                    if(ocr.Role=='Economic Buyer'||ocr.Role=='Champion'){
                        if(oppAndContactRoles.containsKey(ocr.OpportunityId))
                            oppAndContactRoles.get(ocr.OpportunityId).add(ocr);
                        else{
                            oppAndContactRoles.put(ocr.OpportunityId,new Set<OpportunityContactRole>{ocr});
                        }
                    }
                    //BAJPI01 - as part of US461190
                }
            }
        }
        
        //merha02--- WaterMark Solution ----start
            System.debug('------oppAccMap-----'+oppAccMap);
            System.debug('--PrimaryContactMap---'+PrimaryContactMap);
            if(PrimaryContactMap!=null && PrimaryContactMap.size()>0){
                
                List<Opportunity> WaterMarkOpps=[select id,AccountId,(select ContactId from OpportunityContactRoles where IsPrimary=true and ContactId IN: PrimaryContactMap.values() and ContactId!=null) from Opportunity where AccountId IN:oppAccMap.values()];
                
                Set<Id> opportunityIds=new Set<Id>(); 
                System.debug('-------WaterMarkOpps------'+WaterMarkOpps);
                if(WaterMarkOpps!=null && WaterMarkOpps.size()>0){
                    Map<id,id> OppsPrimaryContactMap= new Map<id,id>();
                    Map<id,id>  OppsAccountsMap=new Map<id,id>();
                    
                    for(Opportunity opty : WaterMarkOpps){
                        OppsAccountsMap.put(opty.id,opty.AccountId);
                        List<OpportunityContactRole> contacts=opty.OpportunityContactRoles;
                        if(contacts!=null && contacts.size()>0){
                            for(OpportunityContactRole ocr : contacts){
                                
                                if(ocr.ContactId!=null){
                                    opportunityIds.add(opty.id);
                                    OppsPrimaryContactMap.put(opty.id,ocr.ContactId);
                                }
                            }
                        }
                    }
                    
                    System.debug('--------opportunityIds-----'+opportunityIds);
                    if(opportunityIds!=null && opportunityIds.size()>0){
                        List<opportunityLineItem> OliList=[select Id,Opportunityid,Business_Unit__c from opportunityLineItem where OpportunityId IN: opportunityIds]; 
                        if(OliList!=null && OliList.size()>0){
                            for(OpportunityLineItem oli : OliList){
                                if(oppBU.containsKey(oli.Opportunityid)){
                                    oppBU.get(oli.Opportunityid).add(oli.Business_Unit__c);
                                }
                                else{
                                    oppBU.put(oli.Opportunityid, new List<String>{oli.Business_Unit__c});
                                }
                            }
                            
                            System.debug('-----oppBU----'+oppBU);
                            
                            if(opportunityIds!=null && opportunityIds.size()>0 && tempIdSet!=null && tempIdSet.size()>0){
                                for(Id o : tempIdSet){
                                System.debug('-----initial opportunities-----'+o);
                                
                                    for(Id opId : opportunityIds){
                                        
                                        if(o!=opId){
                                            Id AccountId1=OppsAccountsMap.get(o);
                                            Id AccountId2=OppsAccountsMap.get(opId);
                                            System.debug('-----Accounts-----'+AccountId1+AccountId2);
                                            if(AccountId1 == AccountId2){
                                                Id PcCon1 = OppsPrimaryContactMap.get(o);
                                                Id PcCon2 = OppsPrimaryContactMap.get(opId);
                                                System.debug('-----Primary Contacts-----'+PcCon1+PcCon2);
                                                if(PcCon1==PcCon2){
                                                    if(OppRelatedOppsMap.containsKey(o)){
                                                        OppRelatedOppsMap.get(o).add(opId);
                                                    }
                                                    else{
                                                        OppRelatedOppsMap.put(o,new List<id>{opId});
                                                    }
                                                }
                                                
                                            }
                                        }
                                        System.debug('---OppRelatedOppsMap--'+OppRelatedOppsMap);
                                    }
                                
                            }
                            }
                        }
                    }
                }
            }
            // merha02---end
        
    }
    
}