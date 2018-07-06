/*
* Uses Test Class = OpportunityCreateOverrideExtensionTest 
* Coverage = 82%.
* Updated by BAJPI01
*/  

public with sharing class  OpportunityCreateOverrideExtension {
    
    @TestVisible static final string STERLING_QUOTE = 'STERLING_QUOTE';
    @TestVisible static final string SALESFORCE_CPQ_QUOTE = 'SALESFORCE_CPQ_QUOTE';
    
    @TestVisible private static String PAGE_WARN_ERROR_WIN_LOSS_100_STAGE = Label.OPP_WIN_LOSS_100_STAGE_ERROR;
    @TestVisible private static String PAGE_WARN_ERROR_Rally_Referral_Activity = 'Activities performed by partner are required when the Sales Milestone is ' + Label.Opp_Stage_Closed_Won +'.';
    
    @TestVisible private static set<String> INFLUENCER_STAGE = new set<String>{
        Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                
    @TestVisible private static set<String> DECISION_MAKER_STAGE = new set<String>{
        Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                            
                            
    @TestVisible private static set<String> PROCUREMENT_SIGNER_STAGE = new set<String>{
        Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                        
    @TestVisible private static set<String> ECONOMIC_BUYER_STAGE = new set<String>{
        Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                    
   @TestVisible private static set<String> CHAMPION_STAGE = new set<String>{
        Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                
   @TestVisible private static set<String> SPONSOR_STAGE = new set<String>{
        Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                            
   @TestVisible private static set<String> OCR_REQUIRED = new set<String>{
        Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                        
                                                                                        
   @TestVisible private static set<String> IDENTIFIED_PAIN_STAGE = new set<String>{
        Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                    
   @TestVisible private static set<String> METRICS_STAGE = new set<String>{
        Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                
   @TestVisible private static set<String> DECISION_CRITERIA_STAGE = new set<String>{
        Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                            
   @TestVisible private static set<String> DECISION_PROCESS_STAGE = new set<String>{
        Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                                        
   @TestVisible private static set<String> COMPETITOR_REQUIRED = new set<String>{
        Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                                                    
   @TestVisible private static set<String> PAPER_PROCESS_STAGE = new set<String>{
        Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                                                                
                                                                                                                                                                
   @TestVisible private static set<String> WIN_LOSS_REQUIRED = new set<String>{
        Label.Opp_Stage_Closed_Won,label.Opp_Stage_Closed_Lost
            };
                                                                                                                                                                            
   @TestVisible private static set<String> ORDER_NUMBER = new set<String>{
        Label.Opp_Stage_Closed_Won
            };
                                                                                                                                                                                        
   @TestVisible private static set<String> SERVICES_STAGE = new set<String>{
        Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                                                                                                    
   @TestVisible private static set<String> START_END_DATE_STAGE = new set<String>{
        Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                                                                                                                
   @TestVisible private static set<String> START_END_DATE_STAGE_OPP_TYPE = new set<String>{
        'Education w/Support','Services','Services w/Education','Services w/Education & Support','Services w/Support','Standalone Education','Support'
            };
                                                                                                                                                                                                                            
   @TestVisible private static set<String> QUOTE_INFORMATION_STAGE = new set<String>{
         Label.Opp_Stage_20_Percent,Label.Opp_Stage_40_Percent,Label.Opp_Stage_60_Percent,Label.Opp_Stage_80_Percent,Label.Opp_Stage_Closed_Won
            };
                                                                                                                                                                                                                                        
    @TestVisible  
    RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
    @TestVisible
    private string steelBrickRecType;
    @TestVisible  
    RecordTypes_Setting__c newOppRec = RecordTypes_Setting__c.getValues('New Opportunity');  //to get details from custom setting for New Opportunity Record Type 
    @TestVisible
    private string newOppRecType;  //stores the record type id of New Opportunity Record type. 
    @TestVisible
    RecordTypes_Setting__c preOppRec = RecordTypes_Setting__c.getValues('Pre Opportunity'); //to get details of the custom setting for Pre Opportunity Record Type
    @TestVisible
    private string preOppRecType;  
    @TestVisible
    private RecordTypes_Setting__c entlSync = RecordTypes_Setting__c.getValues('Entitlement_Sync');   //to get details from custom setting for Entitlement Sync Record Type 
    @TestVisible
    private string entlSyncRecType;    //stores rec type id of Entitlement Rec Type
    
    
    @TestVisible
    private Boolean eligibilityChanged;    //boolean to indicate if eligibility changed or not
    @TestVisible
    private Boolean isSaleforceCPQRep;    //boolean to indicate if the logged in user has access to quote eligibility fields or not,
    //is done with the help of a permission set.
    //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling,change the flag name from isAgileCentralRep to isSaleforceCPQRep. More products will be added.
    @TestVisible
    private Boolean needSalesforceCPQRoute;
    
    @TestVisible
    private RecordTypes_Setting__c priceBookRec = RecordTypes_Setting__c.getValues('Standard Price Book');  //to get details from custom setting for Standard Price Book
    @TestVisible
    private string priceBookRecValue;  //stores the standard pricebook ID.
    @TestVisible
    private RecordTypes_Setting__c CApriceBookRec = RecordTypes_Setting__c.getValues('CA Product List');  //to get details from custom setting for CA Price Book
    @TestVisible
    private string CApriceBookRecValue;  //stores the CA PriceBook Id.
    @TestVisible
    private ID sbPrimaryQuoteId;    //primaryquote Id for SteelBrick Quote
    
    @TestVisible
    private SBQQ__Quote__c sbQuote;    //quote details
    @TestVisible
    private String oldRecTypeId;      //old record type ID of opportunity
    @TestVisible
    private string prevQuoteRouteSelection;  //previous value of Agile Central or FDE Deal field.
    @TestVisible
    private string oldCurrencyValue;  //previous value of currency.
    
    @TestVisible
    private List<PermissionSetAssignment> permSetID;  //permission set for Steel Brick Eligibility Permission Set.
    
    @TestVisible
    private Date dateOppCreated = date.newinstance(2017, 11, 03);  //created date of opp, to be used in eligibility check along with renewal opp type.
    @TestVisible
    private Date ActualCreatedDate;
    
    @TestVisible
    private Boolean isRenewalOpp;  //Boolean set to true if opportunity type contains renewal, only for changestage page, to be used in eligibilty case.
    
    public Boolean ocrsRequired {
        get {
            return  isOCRRequired || opp.StageName == Label.Opp_Stage_10_Percent 
                || opp.StageName == label.Opp_Stage_Closed_Lost;
        }
    }
    
    public boolean isOCRRequired { get {
        return OCR_REQUIRED.contains(opp.StageName);}
                                 }
    /*
    public boolean isInfluencerRequired { get {
        return INFLUENCER_STAGE.contains(opp.StageName);}
                                        }
    
    public boolean isDecisionMakerRequired { get {
        return DECISION_MAKER_STAGE.contains(opp.StageName) ;}
                                           }
    */
    
    //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team                                    
    public boolean isOnboardingContactRequired { get{
        system.debug('----stage----'+opp.StageName+'----label----'+Label.Opp_Stage_Closed_Won);
        system.debug('----boolean-----'+hasNewBusinessTypeProduct+'====contract------'+opp.Contract_Type__c);
        return (opp.StageName == Label.Opp_Stage_Closed_Won && hasNewBusinessTypeProduct && (opp.Contract_Type__c == Label.Opp_Contract_Type_ELA || opp.Contract_Type__c == Label.Opp_Contract_Type_New_License || opp.Contract_Type__c == Label.Opp_Contract_Type_SAAS || opp.Contract_Type__c == Label.Opp_Contract_Type_MSP)
        );}
    }
    
    public boolean isIdentifiedPainRequired { get {
        return IDENTIFIED_PAIN_STAGE.contains(opp.StageName);}
                                            }
    
    public boolean isMetricsRequired { get {
        return METRICS_STAGE.contains(opp.StageName);}
                                     }
    
    public boolean isDecisionCriteriaRequired{ get{
        return DECISION_CRITERIA_STAGE.contains(opp.StageName);}
                                              
                                             }
    /*
    public boolean isProcurementSignerRequired { get {
        return PROCUREMENT_SIGNER_STAGE.contains(opp.StageName) ;}
                                               }
    */
    public boolean isDecisionProcessRequired{ get{
        return DECISION_PROCESS_STAGE.contains(opp.StageName);}
                                             
                                            }
    
    public boolean isPaperProcessRequired{ get{
        return PAPER_PROCESS_STAGE.contains(opp.StageName);}
                                          
                                         }
    /*
    public boolean isSponsorRequired { get {
        return SPONSOR_STAGE.contains(opp.StageName);}
                                     }
    */
    
    
    public boolean isEconomicBuyerRequired { get {
        return ECONOMIC_BUYER_STAGE.contains(opp.StageName);}
                                           }
    
    public boolean isChampionRequired { get {
        return CHAMPION_STAGE.contains(opp.StageName);}
                                      }
    
    public boolean isPrimaryCompetitorRequired{ get{
        return COMPETITOR_REQUIRED.contains(opp.StageName);}
                                               
                                              }
    
    public boolean isWinLossRequired{ get{
        return WIN_LOSS_REQUIRED.contains(opp.StageName);}
                                     
                                    }
    
    public Boolean isServicesRequired{ get{
        return SERVICES_STAGE.contains(opp.StageName);}
                                      
                                     }
    
    public boolean isOrderNumberRequired{ get{
        return (ORDER_NUMBER.contains(opp.StageName));}
                                         
                                        }
    
    public boolean isContractsigned{ get{
        return (ORDER_NUMBER.contains(opp.StageName));}
                                    
                                   }
    
    public boolean isQuoteInfoRequired{ 
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, adding another flag check. Only display when it's "1 Tier" or "Direct" 
        get{
            return (isSaleforceCPQRep && needSalesforceCPQRoute);
        }                                    
    }
    
    //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, if it's partner opp, and only "1 Tier", display different message. 
    public string SalesforceCPQRouteLabel{
        get{
            if (opp.Type == '1 Tier')
            {
                return Label.Salesforce_CPQ_quote_route_with_partner_Label;
            }
            else 
            {
                return Label.Salesforce_CPQ_quote_route_Label;
            }
        }
    }
    
    public boolean isServiceProviderRequired{ get{
        return (opp.Cloud_Platform__c == null && opp.Type == 'xSP');}
                                            }
    
    //Start & End Date Required or not US311083/US326189 - Opportunity Requires Start/End Date by BAJPI01
    public boolean isStartEndDateRequired{ get{
        Boolean startEndDateReqOrNot;
        Boolean opptype=true;
        for(String s:START_END_DATE_STAGE_OPP_TYPE){
            if(opp.Opportunity_Type__c!=null && opp.Opportunity_Type__c==s)
                opptype=false;
        }
        system.debug('---opptype----'+opptype);
        if(START_END_DATE_STAGE.contains(opp.StageName) && opptype)
            startEndDateReqOrNot = true;
        else
            startEndDateReqOrNot = false;
        
        system.debug('---startEndDateReqOrNot----'+startEndDateReqOrNot);
        return startEndDateReqOrNot;
    }
                                         }
    //Start & End Date Required or not US311083/US326189 - Opportunity Requires Start/End Date by BAJPI01
    
    public Boolean productexists{
        get{
            Boolean exists = false;
            //BAJPI01 for start/end date hide or not - check prod bus type - starts here
            if(isChangeStagePage||isServicesChildOppCreationPage){
                if(opplineitemlist!=null && opplineitemlist.size()>0){
                    for(OpportunityLineItem oli:opplineitemlist){
                        if(BusType.contains(oli.Business_Type__c)){
                            exists = true;
                            break;
                        }
                    }
                }
            }
            return exists;
            
            
            //BAJPI01 for start/end date hide or not - check prod bus type - starts here
        }
    }
    
    public string winloss,competitor;
    
    public boolean renderType {get; set;}        
    @TestVisible private ApexPages.Standardcontroller standardController;
    @TestVisible private Opportunity opp;
    @TestVisible private ID parentoppId;
    @TestVisible private ID contactID;
    @TestVisible private string contractvalue;
    @TestVisible private string contractno;
    @TestVisible private string projectno;
    @TestVisible private string accountid;
    @TestVisible private List<OpportunityLineItem> opplineitemlist;
    @TestVisible private boolean hasNewBusinessTypeProduct=false;
    @TestVisible private string CAService;
    @TestVisible private Services_Request__c serreq;
    @TestVisible private Boolean isChangeStagePage = false;
    @TestVisible private Boolean isOppCreationPage = false;
    @TestVisible private Boolean isServicesChildOppCreationPage = false;
    @TestVisible private List<OpportunityContactRole> existingOppContactRoles;
    @TestVisible private List<OpportunityContactRole> oppContactList;
    @TestVisible private Set<OpportunityContactRole> updateOppContactSet;
    @TestVisible private Set<String> BusType = new Set<String>{'Capacity','Renewal','Upgrade','New','MF Capacity'}; //BAJPI01 to make start/end date visible and req or not.
        @TestVisible private Boolean lineItemexists = false;
    
    Id InfluencerContactId;
    public OpportunityContactRole Influencer {get;set;}
    public OpportunityContactRole DecisionMaker {get;set;}
    public OpportunityContactRole ProcurementSigner {get;set;}
    public OpportunityContactRole Sponsor {get;set;}
    public OpportunityContactRole EconomicBuyer {get;set;}
    public OpportunityContactRole Champion {get;set;}
    public OpportunityContactRole OnboardingContact {get;set;}
    public Boolean currencyedit{get;set;}
    public boolean runornot; //added by SAMTU01 - US261375
    public boolean isFormRendered{get;set;}
    public Boolean isStage0Opp          { get; set; }       // added by GORSO02
    public Boolean showQualifiedByMsg   { get; set; }       // added by GORSO02
    public Boolean showRejectedByMsg    { get; set; }       // added by GORSO02
    public Boolean showCloseDate        { get; set; }       // added by GORSO02
    public Boolean showClosedReason     { get; set; }       // added by GORSO02
    
    public OpportunityCreateOverrideExtension(ApexPages.StandardController controller){
        system.debug('--entered---');
        String pageURL = ApexPages.currentPage().getUrl();
        if(pageURL.containsIgnoreCase('OpportunityCreateOverride') && (ApexPages.currentPage().getParameters().get('accId')==null||ApexPages.currentPage().getParameters().get('accId')=='')
           && pageURL.containsIgnoreCase('conId')){
               isFormRendered = false;
               ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'You do not have access to the account. Please use a different contact to create/edit an opportunity.'));
           }
        else{
            
            if(sbRecType!=null)
                steelBrickRecType = sbRecType.RecordType_Id__c;
            if(newOppRec!=null)
                newOppRecType = newOppRec.RecordType_Id__c;
            if(preOppRec!=null)
                preOppRecType = preOppRec.RecordType_Id__c;
            if(entlSync!=null)
                entlSyncRecType = entlSync.RecordType_Id__c;    
            if(priceBookRec!=null)
                priceBookRecValue = priceBookRec.RecordType_Id__c;  //get the record type id for the standard pricebook entry
            if(CApriceBookRec!=null)
                CApriceBookRecValue = CApriceBookRec.RecordType_Id__c;  //get the record type id for the CA pricebook entry
            
            eligibilityChanged = false;
            isSaleforceCPQRep = false;
            permSetID = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() 
                         AND PermissionSet.Name = 'CASteelBrickCPQUser'];
            
            if(permSetID!=null && permSetID.size()==1)
                isSaleforceCPQRep = true; 
            
            isFormRendered = true;
            System.debug('Inside Constructor');
            standardController = controller;
            System.debug('pageURL:'+pageURL);
            if(pageURL.containsIgnoreCase('ChangeStage')){
                isChangeStagePage = true;
            }
            if(pageURL.containsIgnoreCase('OpportunityCreateOverride')&&!pageURL.containsIgnoreCase('contrnum')){
                isOppCreationPage = true;
            }
            if(pageURL.containsIgnoreCase('OpportunityCreateOverride')&&pageURL.containsIgnoreCase('contrnum')){
                system.debug('child page');
                isServicesChildOppCreationPage = true;
            }
            
            opp = (Opportunity)standardController.getRecord();
            
            //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, display Saleforce CPQ checkbox if no type selected yet, Direct or "1 Tier"
            //other scenarios will be routed to sterling directly. 
            needSalesforceCPQRoute = (opp.Type == null || opp.Type == 'Direct' || opp.Type == '1 Tier');    

            if(isOppCreationPage){
                contactID = ApexPages.currentPage().getParameters().get('conId');
                opp.accountId = ApexPages.currentPage().getParameters().get('accId');
                opp.OwnerId = UserInfo.getUserId();
                
            }
            if(isChangeStagePage){
                CAService = opp.Will_CA_Services_Be_Used__c;
                opplineitemlist = [select id,opportunityid,Business_Type__c,Offerings_Family__c from OpportunityLineItem where OpportunityId=:opp.id];
                if(opplineitemlist.size()>0){
                    lineItemexists = true;
                    currencyedit = false;

                    //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team
                    for(OpportunityLineItem o : opplineitemlist)
                    {
                        if (o.Business_Type__c == 'New' && o.Offerings_Family__c == null) //new product, no including "offering"
                        {
                            hasNewBusinessTypeProduct = true;
                            break;
                        }
                    }
                }                    
                else 
                {
                    currencyedit = true;
                    //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team
                    hasNewBusinessTypeProduct = false;
                }
                
                oldRecTypeId = String.valueOf(opp.RecordTypeId).substring(0,15);
                
                //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
                prevQuoteRouteSelection = '';
                if (opp.Salesforce_CPQ_Eligibility_Route__c)
                {
                    prevQuoteRouteSelection = SALESFORCE_CPQ_QUOTE;
                }
                else
                {   
                    prevQuoteRouteSelection = STERLING_QUOTE;
                }
                
                oldCurrencyValue = opp.CurrencyIsoCode;
                if(opp.SBQQ__PrimaryQuote__c!=null)
                    sbQuote = [select id,SBQQ__Primary__c from SBQQ__Quote__c where id=:opp.SBQQ__PrimaryQuote__c limit 1];
                
                
                if(String.isNotBlank(opp.Opportunity_Type__c) && opp.Opportunity_Type__c.containsIgnoreCase('Renewal'))
                    isRenewalOpp = true;
                else
                    isRenewalOpp = false;
                
                ActualCreatedDate = Date.valueOf(opp.CreatedDate);
                
            }
            
            if(isServicesChildOppCreationPage){
                parentoppId = ApexPages.currentPage().getParameters().get('oppId');           
                opp.AccountId = ApexPages.currentPage().getParameters().get('accId');
                if(ApexPages.currentPage().getParameters().get('contrnum')!=null&&ApexPages.currentPage().getParameters().get('contrnum')!=''){
                    contractno = ApexPages.currentPage().getParameters().get('contrnum');    
                }
                if(ApexPages.currentPage().getParameters().get('contrval')!=null&&ApexPages.currentPage().getParameters().get('contrval')!=''){
                    contractvalue = ApexPages.currentPage().getParameters().get('contrval');
                }
                if(ApexPages.currentPage().getParameters().get('projno')!=null&&ApexPages.currentPage().getParameters().get('projno')!=''){
                    projectno = ApexPages.currentPage().getParameters().get('projno');
                }
                
                opp.OwnerId = UserInfo.getUserId();
                
            }
            winloss = opp.ReasonField__c;
            competitor = opp.Competitor__c;
            init();
        }
    }
    
    
    public void init(){
        System.debug('Inside Init Method');
        showCloseDate = true;
        showClosedReason = false;               // Boolean to show the closed reason if opp converted to closed
        // Start of Changes for Converting Stage 0  to Stage 1
        isStage0Opp = false;
        if(opp.RecordTypeId != null && String.valueOf(opp.RecordTypeId).containsIgnoreCase(preOppRecType)) {
            isStage0Opp = true;
            showCloseDate = false;
        }
        
        showQualifiedByMsg = false;
        showRejectedByMsg = false;
        updateOppContactSet = new Set<OpportunityContactRole>();
        
        if(isChangeStagePage){
            if(Opp.type != null && (Opp.type.equalsIgnoreCase('1 Tier')||Opp.type.equalsIgnoreCase('2 tier')||Opp.type.equalsIgnoreCase('xSP'))){   
                renderType=true;
            }else renderType=false;
            
            Influencer = new OpportunityContactRole(Role = 'Influencer',IsPrimary=false,OpportunityId = opp.Id);
            DecisionMaker = new OpportunityContactRole(Role = 'Decision Maker',IsPrimary=false,OpportunityId = opp.Id);
            ProcurementSigner = new OpportunityContactRole(Role = 'Procurement/Signer',IsPrimary=false,OpportunityId = opp.Id);
            Sponsor = new OpportunityContactRole(Role = 'Executive Sponsor',IsPrimary=false,OpportunityId = opp.Id);            
            EconomicBuyer = new OpportunityContactRole(Role = 'Economic Buyer',IsPrimary=false,OpportunityId = opp.Id);
            Champion = new OpportunityContactRole(Role = 'Champion',IsPrimary=false,OpportunityId = opp.Id);
            OnboardingContact = new OpportunityContactRole(Role = 'Onboarding Contact',IsPrimary=false,OpportunityId = opp.Id);
            
            existingOppContactRoles = [select ContactId,Role,OpportunityId,IsPrimary from OpportunityContactRole where OpportunityId=:opp.Id];
            System.debug('Opp Type:'+opp.Type);
            
            if(existingOppContactRoles.size()>0 && existingOppContactRoles!=null){
                
                for(OpportunityContactRole temp:existingOppContactRoles){
                    if(temp.Role=='Influencer')
                        Influencer = temp;
                    if(temp.Role == 'Decision Maker')
                        DecisionMaker = temp;
                    if(temp.Role == 'Procurement/Signer')
                        ProcurementSigner = temp;
                    if(temp.Role == 'Executive Sponsor')
                        Sponsor = temp; 
                    if(temp.Role == 'Economic Buyer')
                        EconomicBuyer = temp; 
                    if(temp.Role == 'Champion')
                        Champion = temp; 
                    if(temp.Role == 'Onboarding Contact')
                        OnboardingContact = temp;
                }
            }
        }
        if(isOppCreationPage||isServicesChildOppCreationPage){
            system.debug('----contact id----'+contactid);
            if(contactID!=null)
                Influencer = new OpportunityContactRole(Role = 'Influencer',IsPrimary=true,ContactId = contactID);
            else
                Influencer = new OpportunityContactRole(Role = 'Influencer',IsPrimary=false,ContactId = contactID);
            DecisionMaker = new OpportunityContactRole(Role = 'Decision Maker',IsPrimary=false);
            ProcurementSigner = new OpportunityContactRole(Role = 'Procurement/Signer',IsPrimary=false);
            Sponsor = new OpportunityContactRole(Role = 'Executive Sponsor',IsPrimary=false);
            EconomicBuyer = new OpportunityContactRole(Role = 'Economic Buyer',IsPrimary=false);
            Champion = new OpportunityContactRole(Role = 'Champion',IsPrimary=false);
            OnboardingContact = new OpportunityContactRole(Role = 'Onboarding Contact',IsPrimary=false);
        }
        oppContactList = new List<OpportunityContactRole>{Influencer,DecisionMaker,ProcurementSigner,Sponsor,EconomicBuyer,Champion,OnboardingContact};
            System.debug('oppContactList:'+oppContactList);    
    }
    
    // Changes for New Stage 0 Opportunity. Removal of fields from the page layout, and addition of new fields
    public void onRecordTypeChange() {
        
        if(String.valueOf(opp.RecordTypeId).containsIgnoreCase(preOppRecType)) {
            opp.StageName = label.Stage_0_Name;               // Default Stage to Not Contacted
            isStage0Opp = true;
            opp.Type = label.SalesPlay_Opp_Type;
            opp.Salesforce_CPQ_Eligibility_Route__c = false; // CPQ Quote checkbox should be unchecked for Stage 0
            opp.CloseDate = Date.today().addMonths(3);       // for Stage 0 Opportunity the close date will be 3 months from creation date. Blank the close date is the opp goes to next stage.
        }
        else {
            opp.StageName = '';
            isStage0Opp = false;
            opp.CloseDate = null;
        }
        //showClosedReason = ( opp.StageName.equalsIgnoreCase(Label.OPP_STAGE_CLOSED) && isStage0Opp == true ) ? true : false;
        validateRequiredFields();
    }
    
    /*
    public void onQualifiedChange() {
        showQualifiedByMsg = (opp.Qualified_By__c != null) ? true : false;
        validateRequiredFields();
    }
    
    public void onRejectedChange() {
        showRejectedByMsg = (opp.RejectedBy__c != null) ? true : false;
        validateRequiredFields();
    }
    */
    public void onStageNameChange() {
        
        // Start of Changes - when opportunity is closed in Stage 0
        showClosedReason = ( opp.StageName.equalsIgnoreCase(Label.OPP_STAGE_CLOSED) && isStage0Opp == true ) ? true : false;
        
        // Start of Changes for Converting Stage 0  to Stage 1
        if(opp.StageName !=null && opp.StageName.equalsIgnoreCase(Label.Opp_Stage_10_Percent) && isStage0Opp == true) {
            showCloseDate = true;
            opp.CloseDate = null;
        }
        else if(opp.StageName !=null && !opp.StageName.equalsIgnoreCase(Label.Opp_Stage_10_Percent) && isStage0Opp == true){
            showCloseDate = false;
            opp.CloseDate = Date.today().addMonths(3);
        }
        // End of Changes for Converting Stage 0  to Stage 1
        if(isOppCreationPage||isServicesChildOppCreationPage){
            
            oppContactList[0].ContactId = contactID;
            opp.ReasonField__c = null;
            opp.Competitor__c = null;
            opp.Will_CA_Services_Be_Used__c = null;
            opp.No_CA_Service_Reason__c = null;
        }
        
        if(isChangeStagePage){
            opp.ReasonField__c = winloss;
            opp.Competitor__c = competitor;
        }
        
        System.debug('Inside onStageNameChange Method');
        validateRequiredFields();
    }
    
    public void onAccountChange() {
        // Populate the country on opportunity from the Accounts country.
        opp.Country__c = [SELECT Id, Country_Picklist__c FROM Account WHERE Id =: opp.AccountId].Country_Picklist__c;
    }
    
    public void onTypeChange()
    {
        System.debug('Inside onTypeChange Method');
        if(Opp.type!=null && (Opp.type.equalsIgnoreCase('1 Tier')||Opp.type.equalsIgnoreCase('2 tier')||Opp.type.equalsIgnoreCase('xSP'))){   
            renderType=true;
        }else renderType=false;
        
        if (Opp.type!=null && Opp.type!='Direct' && Opp.type!='1 Tier')
        {
            opp.Salesforce_CPQ_Eligibility_Route__c = false;
        }
        
        if(isOppCreationPage||isServicesChildOppCreationPage){
            
            oppContactList[0].ContactId = contactID;     
            opp.ReasonField__c = null;
            opp.Competitor__c = null;
        }
        
        if(isChangeStagePage){
            opp.ReasonField__c = winloss;
            opp.Competitor__c = competitor;
        }
        
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, display Saleforce CPQ checkbox if it's create page, or change page (only Direct or "1 Tier")
        //other scenarios will be routed to sterling directly. 
        needSalesforceCPQRoute = (opp.Type == null || opp.Type == 'Direct' || opp.Type == '1 Tier');

        validateRequiredFields();
    }
    
    public void onCurrencyChange(){
        List<SBQQ__Quote__c> quotelist = new List<SBQQ__Quote__c>();
        if(oldRecTypeId==steelBrickRecType){
            quotelist = [select id from SBQQ__Quote__c where SBQQ__Opportunity2__c=:opp.id];
            if(quotelist!=null && quotelist.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Currency cannot be changed for this Opportunity, as it has quotes tied to it. Please create a new Opportunity.'));
                opp.CurrencyIsoCode = oldCurrencyValue;
            }
        }        
    }
    
    public void onServiceChange(){
        
        validateRequiredFields();
        
    }
    
    
    public PageReference onCancel(){
        System.debug('in cancel method');
        if(isOppCreationPage){
            if(contactId != null)
                return new PageReference('/'+contactId);
            else
                return new PageReference('/home/home.jsp');
        }
        else if(isServicesChildOppCreationPage){
            return new PageReference('/'+parentoppId);
        }
        else
            return new PageReference('/'+opp.Id);
    }
    public PageReference onSave(){
        System.debug('Inside onSave method');
        validateRequiredFields();
        if(System.Label.Deal_Reg_history_Logic_Value=='True'){
            DealRegHistoryFlag.delRegDeleteFlag=true;
            DealRegHistoryChangesTensor.dealReghistroyObjSource(opp);
        }
        if(ApexPages.hasMessages(ApexPages.Severity.INFO)) {
            
            return null;
            
        }
        else{
            if(isOppCreationPage||isServicesChildOppCreationPage){
                
                performUpdates();
            }
            else
                updateOpportunity();
            return ApexPages.hasMessages() ? null : new PageReference('/'+opp.Id);
        }  
    }
    
    public PageReference onSave_AddProducts(){
        validateRequiredFields();
        if(ApexPages.hasMessages(ApexPages.Severity.ERROR) || ApexPages.hasMessages(ApexPages.Severity.INFO)) {
            return null;
        }
        else{
            performUpdates();
            return ApexPages.hasMessages() ? null : new PageReference('/apex/OpplineItempage?oppid='+opp.Id+'&producttype=Product&retURL='+opp.Id);
        }  
    }
    
    public PageReference onSave_AddOfferings(){
        validateRequiredFields();
        if(ApexPages.hasMessages(ApexPages.Severity.ERROR) || ApexPages.hasMessages(ApexPages.Severity.INFO)) return null;
        else{
            performUpdates();
            return ApexPages.hasMessages() ? null : new PageReference('/apex/addofferingspage?oppid='+opp.Id+'&retURL='+opp.Id);
        }  
    }
    
    public PageReference onSave_AttachContractProduct(){
        validateRequiredFields();
        if(ApexPages.hasMessages(ApexPages.Severity.ERROR) || ApexPages.hasMessages(ApexPages.Severity.INFO)) return null;
        else{
            performUpdates();
            return ApexPages.hasMessages() ? null : new PageReference('/apex/Renewal_AddOppProduct?id='+opp.Id+'&retURL='+opp.Id);
        }  
    }
    
    public PageReference onSave_AddMainframeCapacity(){
        validateRequiredFields();
        if(ApexPages.hasMessages(ApexPages.Severity.ERROR) || ApexPages.hasMessages(ApexPages.Severity.INFO)) return null;
        else{
            performUpdates();
            return ApexPages.hasMessages() ? null : new PageReference('/apex/renewal_addMainFrameProducts?oppid='+opp.Id+'&producttype=Renewal&retURL='+opp.Id);
        }  
    }
    
    @TestVisible private void performUpdates(){
        Set<id> oppidset=new Set<id>();     //added by SAMTU01 - US261375
        try{
            Boolean isPrimarySelected = false;
            List<OpportunityContactRole> insertList = new List<OpportunityContactRole>();
            for(OpportunityContactRole temp:oppContactList){
                if(temp.ContactId !=null){
                    if(temp.IsPrimary == true){
                        isPrimarySelected = true;
                    }
                    insertList.add(temp);    
                }
            }
            System.debug('isPrimarySelected:'+isPrimarySelected);
            
            if(isOCRRequired){
                if(isPrimarySelected == false && insertList != null && insertList.size() > 0){
                    throw new IsPrimaryException('Please specify the Primary Contact');
                }
            }
            
            if(isServicesChildOppCreationPage){
                opp.SAP_Contract_Number__c = contractno;
                opp.SAP_Contract_Balance__c = contractvalue;
                opp.Project_Number__c = projectno;
                opp.Opportunity__c = parentoppId;
                
            }
            
            //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, if user select "Direct" or "1 Tier" first, check "Salesforce CPQ" checkbox, and then change to 
            //'2 Tier' or 'xSP' or "OEM", the checkbox will be hidden, so set this flag to false. 
            if (opp.Type != 'Direct' && opp.Type != '1 Tier')
            {
                opp.Salesforce_CPQ_Eligibility_Route__c = false; 
            }

            if(opp.RecordTypeId != entlSyncRecType && opp.RecordTypeId != preOppRecType){
                //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
                if(opp.Salesforce_CPQ_Eligibility_Route__c){
                    opp.RecordTypeId = steelBrickRecType;    //changing to steelbrick record ID
                    opp.PriceBook2Id = priceBookRecValue;    //changing pricebook ID to standard ID.
                }
                else 
                {
                    opp.RecordTypeId = newOppRecType;    //changing to sterling quote/new Opp record ID
                    opp.PriceBook2Id = CApriceBookRecValue;
                }

            }
            
            String campId = ApexPages.currentPage().getParameters().get('campId');
            opp.CampaignId = (campId != null) ? campId : null;
            
            Database.SaveResult sr = Database.insert(opp,true);
            
            // Insert a Campaign Influence record if Campaign Id is present
            /* To be uncommented when Campaign Influence part is confirmed
            if(campId != null) {
                CampaignInfluence newCampInfluence = new CampaignInfluence(CampaignId = campId, ContactId = contactID, OpportunityId = opp.Id, ModelId = System.label.SP_CampaignInfluenceModelId, Influence= 100);
                insert newCampInfluence;
            }
            */
            for(OpportunityContactRole temp:insertList){
                temp.OpportunityId = opp.Id;
            }
            if(sr.isSuccess()){
                upsert insertList;
                runornot = shouldIRun.canIRun(); //added by SAMTU01 - US261375
                oppidset.add(opp.Id);       
                
                if(runornot==true){
                    system.debug('---calling opp update----');
                    PrimaryPartner.updateOpportunity(oppidset); 
                }  //added by SAMTU01 - US261375 - ends here.
            }
        }
        catch(Exception ex){
            if(!ApexPages.hasMessages(ApexPages.Severity.ERROR))
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
        }
    }
    
    @TestVisible private void updateOpportunity(){
        Boolean updateSBQuote = false;
        Boolean eligibilityChanged = false;
        Boolean sbRecordType = false;
        List<GroupMember> userInOppAdminGroup = [select Id from GroupMember 
                                                 where groupid = :label.Opportunity_Admin_Edit_For_Closed_Opps_Id AND UserOrGroupId = :UserInfo.getUserId()];
        
        //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, if user select "Direct" or "1 Tier" first, check "Salesforce CPQ" checkbox, and then change to 
        //'2 Tier' or 'xSP' or "OEM", the checkbox will be hidden, so set this flag to false. 
        if (opp.Type != 'Direct' && opp.Type != '1 Tier')
        {
            opp.Salesforce_CPQ_Eligibility_Route__c = false; 
        }
        
        if(userInOppAdminGroup.size() == 0 && opp.CloseDate.daysbetween(System.Date.Today())>=14){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Opportunity close date cannot be more than 14 days in the past.');
            ApexPages.addMessage(msg);
        }else if(userInOppAdminGroup.size() != 0 && opp.CloseDate.daysbetween(System.Date.Today())>=14 && opp.StageName == label.Opp_Stage_Closed_Lost){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Opportunity close date cannot be more than 14 days in the past.');
            ApexPages.addMessage(msg);
        }
        else{
            List<OpportunityContactRole> deleteList = new List<OpportunityContactRole>();
            List<OpportunityContactRole> updateOppContactList = new List<OpportunityContactRole>();
            try{
                Boolean isPrimarySelected = false;
                Set<OpportunityContactRole> updateOppContactSet = new Set<OpportunityContactRole>();
                for(OpportunityContactRole temp:oppContactList){
                    if(temp.ContactId !=null){
                        if(temp.isPrimary == true){
                            isPrimarySelected = true;
                        }
                        updateOppContactSet.add(temp);    
                    }
                }
                if(isOCRRequired){
                    if(isPrimarySelected == false && updateOppContactSet != null && updateOppContactSet.size() > 0){
                        throw new IsPrimaryException('Please specify the Primary Contact');
                    }
                }
                
                System.debug('updateOppContactSet:'+updateOppContactSet);
                System.debug('opp--'+opp);
                
                for(OpportunityContactRole temp : existingOppContactRoles){
                    if(!updateOppContactSet.contains(temp)){
                        deleteList.add(temp);
                    }
                }
                
                if(updateOppContactList.size() == 0 || updateOppContactList == null){
                    updateOppContactList.addAll(updateOppContactSet);
                    upsert updateOppContactList;
                }
                system.debug('-----date------'+dateOppCreated+'-------------'+ActualCreatedDate);
                system.debug('----flag------'+isRenewalOpp);
               //sunji03 - US466294 - Tensor H2 Eligibility criteria for SFDC CPQ vs Sterling, change to one checkbox for "Saleforce CPQ" only.
                if(isRenewalOpp==false ||(isRenewalOpp==true && ActualCreatedDate>=dateOppCreated)){
                    if (!opp.Salesforce_CPQ_Eligibility_Route__c && prevQuoteRouteSelection == SALESFORCE_CPQ_QUOTE)
                    {
                        eligibilityChanged = true;
                        sbRecordType = false;
                    }
                    else if (opp.Salesforce_CPQ_Eligibility_Route__c &&  prevQuoteRouteSelection == STERLING_QUOTE)
                    {
                        eligibilityChanged = true;
                        sbRecordType = true;
                    }
                    else if(!opp.Salesforce_CPQ_Eligibility_Route__c && oldRecTypeId!=steelBrickRecType){ 
                        eligibilityChanged = false;
                        sbRecordType = false;
                    }
                }

                if(opp.RecordTypeId != entlSyncRecType){
                    if(sbRecordType==true){
                        opp.RecordTypeId = steelBrickRecType;    //changing to steelbrick record ID
                        opp.PriceBook2Id = priceBookRecValue;    //changing pricebook ID to standard ID.
                    }
                    else if(sbRecordType==false){
                        if(eligibilityChanged == true){
                            system.debug('---entered non SB type, no change---');
                            opp.RecordTypeId = newOppRecType;        //changing to sterling quote/new Opp record ID
                            opp.PriceBook2Id = CApriceBookRecValue;  //changing pricebook ID to standard ID.
                            opp.SBQQ__PrimaryQuote__c = null;
                        }
                    }
                }
             
                if(eligibilityChanged==false){
                    Database.SaveResult sr = Database.update(opp,true);
                    if(deleteList != null && deleteList.size() > 0)
                        delete deleteList;
                }
                else if(eligibilityChanged==true){
                    if(sbRecordType==false){
                        system.debug('----eligibility changed to New Opp------');
                        if(lineItemexists==true){
                            system.debug('---line item exist----');
                            if(sbQuote!=null && sbQuote.SBQQ__Primary__c==true){
                                system.debug('---primary quote----');
                                sbQuote.SBQQ__Primary__c = false;
                                Database.SaveResult sr = Database.update(sbQuote,true);
                                if(sr.isSuccess()){
                                    system.debug('-----opp update----');
                                    Database.SaveResult oppSr = Database.update(opp,true);
                                    if(oppSr.isSuccess()){
                                        if(deleteList != null && deleteList.size() > 0)
                                            delete deleteList;
                                    }
                                }
                            }
                            else{
                                Database.DeleteResult[] results = Database.delete(oppLineItemList,true);
                                Database.SaveResult oppSr = Database.update(opp,true);
                                if(oppSr.isSuccess()){
                                    if(deleteList != null && deleteList.size() > 0)
                                        delete deleteList;
                                }
                            }
                        }
                        else{
                            if(sbQuote!=null && sbQuote.SBQQ__Primary__c==true){
                                sbQuote.SBQQ__Primary__c = false;
                                Database.SaveResult sr = Database.update(sbQuote,true);
                                if(sr.isSuccess()){
                                    Database.SaveResult oppSr = Database.update(opp,true);
                                    if(oppSr.isSuccess()){
                                        if(deleteList != null && deleteList.size() > 0)
                                            delete deleteList;
                                    }
                                }
                            }
                            else{
                                Database.SaveResult oppSr = Database.update(opp,true);
                                if(oppSr.isSuccess()){
                                    if(deleteList != null && deleteList.size() > 0)
                                        delete deleteList;
                                }
                            }
                        }
                    }
                    else if(sbRecordType==true){
                        system.debug('---SB Rec type----');
                        if(lineItemexists==true){
                            system.debug('---line item exist----');
                            Boolean deletesuccess = false;
                            Database.DeleteResult[] results = Database.delete(oppLineItemList,true);
                            for(Database.DeleteResult dr : results){
                                if(dr.isSuccess())
                                    deletesuccess = true;
                                else
                                    deletesuccess = false;
                            }
                            if(deletesuccess==true){
                                system.debug('----opp update-----');
                                Database.SaveResult sr = Database.update(opp,true);
                                if(sr.isSuccess()){
                                    
                                    if(deleteList != null && deleteList.size() > 0)
                                        delete deleteList;
                                }
                            }
                        }
                        else{
                            system.debug('---only opp update----');
                            Database.SaveResult sr = Database.update(opp,true);
                            if(sr.isSuccess()){
                                
                                if(deleteList != null && deleteList.size() > 0)
                                    delete deleteList;
                            }
                        }
                    }
                }   
            }
            catch(Exception ex){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            }
        }
    }
    
    @TestVisible private void validateRequiredFields() {
        System.debug('Inside validateRequiredFields Method');
        System.debug('ocrsRequired:'+ocrsRequired);
        
        //GORSO02 - Stage 0 Opportunity Validations
        if(showClosedReason && opp.ClosedReason__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_STAGE0_CLOSED_ERROR));
        if(isStage0Opp && opp.BUDriver__c == null && !isChangeStagePage)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_STAGE0_BU_ERROR));
        /*
        if(showQualifiedByMsg && opp.QualifiedDate__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_STAGE0_QUALIFIED_ERROR));
        if(showRejectedByMsg && opp.RejectedReason__c == null)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_STAGE0_REJECTED_ERROR));
        */
    
        /****** 20% ****/
        //if(isInfluencerRequired && (Influencer == null || Influencer.ContactId == null)){
        //    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.OPP_INFLUENCER_ERROR)); 
        //}
        /****** 20% ****/
        
        
        
        //Start & End Date Required or not US311083 - Opportunity Requires Start/End Date by BAJPI01
        if(isStartEndDateRequired && (opp.Start_Date__c == null || opp.End_Date__c == null)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_START_END_DATE_ERROR));
        }
        if(opp.start_date__c!=null && opp.End_Date__c!=null){
            if(opp.Start_Date__c>=opp.End_Date__c)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Start Date cannot be greater than or equal to End Date.'));
        }
        //Start & End Date Required or not US311083 - Opportunity Requires Start/End Date by BAJPI01
        
        
        /****** 40% ****/
        //if(isDecisionMakerRequired && (DecisionMaker == null ||  DecisionMaker.ContactId == null)){
        //    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_DECISION_MAKER_ERROR));
        //}
        
        //is CA services required - 40%
        if(isServicesRequired && opp.Will_CA_Services_Be_Used__c == null){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_CA_SERVICE_ERROR));
        }
        if(opp.Will_CA_Services_Be_Used__c == 'No' && (opp.No_CA_Service_Reason__c==null||opp.No_CA_Service_Reason__c=='')){
            system.debug('entered services messages');
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'No CA Services Reason is required when Will CA Services Be Used? is set to No'));
        }
        

        if(isIdentifiedPainRequired && String.isBlank(opp.Identified_Pain__c)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_IDENTIFIED_PAIN_ERROR));
        }
        if(isMetricsRequired && String.isBlank(opp.Metrics__c)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_METRICS_ERROR));
        }
        if(isDecisionCriteriaRequired && String.isBlank(opp.Decision_Criteria__c)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_DECISION_CRITERIA_ERROR));
        }
        
        /****** 40% ****/
        
        
        
        /****** 60% ****/       
        if(isDecisionProcessRequired && String.isBlank(opp.Decision_Process__c)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_DECISION_CRITERIA_ERROR));
        }
        //if(isProcurementSignerRequired && (ProcurementSigner == null || ProcurementSigner.ContactId == null )){
        //    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_PROCUREMENT_STAGE_ERROR));
        //}
        
        if(isEconomicBuyerRequired && (EconomicBuyer == null || EconomicBuyer.ContactId == null)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_ECONOMIC_BUYER_STAGE_ERROR)); 
        }
        
        if(isChampionRequired && (Champion == null || Champion.ContactId == null)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_CHAMPION_STAGE_ERROR)); 
        }
        // Primary Competitor Required
        if(isPrimaryCompetitorRequired && opp.Competitor__c == null){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_COMPETITOR_STAGE_ERROR));
        }
        /****** 60% ****/
        
        
        
        
        /****** 80% ****/
        //if(isSponsorRequired && (Sponsor == null || Sponsor.ContactId == null)){
        //    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_SPONSOR_STAGE_ERROR));
        //}
        if(isPaperProcessRequired && String.isBlank(opp.Paper_Process__c)){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_PAPER_PROCESS_ERROR));
        }
        /****** 80% ****/
       
        // Win-Loss Reason Required
        if(isWinLossRequired && opp.ReasonField__c == null){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.OPP_WIN_LOSS_STAGE_ERROR));
        }
        
        //sunji03 - US408939 - Onboarding Contact Required at 100% for Customer Success Team
        if (isChangeStagePage)
        {
            system.debug('OnboardingContact is ' + OnboardingContact);
           if(isOnboardingContactRequired && (opp.Onboarding_Contact_Language__c == null || opp.Purchase_Reason__c == '' || opp.Purchase_Reason__c == null 
            || OnboardingContact == null || (OnboardingContact != null && OnboardingContact.ContactId == null))) //before contact role is saved, but populated on UI, new contact role object has has ContactId. 
            {
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Opp_Change_Stage_OnboardingContact_Error_Message));
            }
        }
        
        // Service Platform Provider
        if(opp.Cloud_Platform__c == null && opp.Type == 'xSP'){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Service Platform Provider value is required.'));
        }
        // Partner 
        if(opp.Reseller__c == null && (opp.Type == '1 Tier' || opp.Type == '2 Tier')){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Partner account is required.'));
        }
        // Distributor
        if(opp.Distributor_6__c == null && (opp.Type == '2 Tier')){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Distributor account is required.'));
        }
        
        
    }
    
    public class IsPrimaryException extends Exception {}
}