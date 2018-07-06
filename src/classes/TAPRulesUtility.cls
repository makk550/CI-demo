public class TAPRulesUtility{
/**  
main method : this method does the below steps:
      1. Check the quote base criteria 
                     |
                     |
       Satisfied     |    not satisfied
         a.Check TAP |     a. get the Special appover information from quote base criteria table and update the status
            rules    |     information on Sterling quote object.
         information |     b. initiate the approver process.
*/
public Map<String,Boolean> quoteIdMap{get;set;}
public static final String MAX_DISCOUNT = 'MaxDiscount';
public static final String MAX_SERVICES_DISCOUNT = 'MaxServicesDiscount';
public static final String MAX_EDUCATION_DISCOUNT = 'MaxEducationDiscount';
public static final String PERPETUAL = 'Perpetual';
public static final String IS_NIMSOFT_SERVICES_EXISTS = 'IsNimsoftServicesExixts';
public static final String IS_NIMSOFT_EDUCATION_EXISTS = 'IsNimsoftEducationExixts';
public static final String PENDING_PRICING_APPROVAL = 'Pending Pricing Approval';
public static final String DD_TYPE_VAL = 'Deal Desk Director';
public static final String DD_TYPE_VAL_NE = 'Nimsoft Education';
public static final String DD_TYPE_VAL_NS = 'Nimsoft Services';
public static List<string> TAP_RULE_ID_LIST = new List<string>();

//Added for Education QQ
public static final String DD_TYPE_VAL_SR = 'Sr Deal Desk Director';
public static final String DD_TYPE_VAL_VPCPM = 'VP/CPM';
public static final String DD_TYPE_VAL_LEGAL = 'Legal';
public static final String DD_TYPE_VAL_EDU = 'CA Education';
public static final String DDMGR_TYPE_VAL = 'Deal Desk Director/Manager';
public static final String DDSM_TYPE_VAL = 'Deal Desk Director/Special Metric'; //merha02
public Boolean isCAEducationQuote = false;

//changes by potab02

Map<String,Map<String,Decimal>> discountValuesMapOfProductLineItems = new Map<String,Map<String,Decimal>>();
Boolean isAutoApprove = false;
Boolean isL1ApprovalRequired = false;
Boolean isL2ApprovalRequired = false;
Boolean isL3ApprovalRequired = false;
Boolean isL4ApprovalRequired=false;
Boolean isL5ApprovalRequired=false;
Boolean isAgileL1Aprroval=false;

List<Quote_Product_Report__c>   L2ApproverProductList = new List<Quote_Product_Report__c>();
Map<String,Decimal> ValuesMap = new Map<String,Decimal>();
public List<TAP_Approvers__c> TAPApprovers1 = null;
public Map<String,Decimal> resultedValueMap = null;
public Map<String,String> htftFlagValueMap = null; //Education QQ project
public static Boolean AutoRunDDR;
//---------------CODE START--------------------
public Map<string,set<Id>> ValidateTAPRules(  scpq__SciQuote__c quote, 
                               List<Quote_Product_Report__c> productLineItems, 
                               List<TAP_Rules__c> ruleList,
                               List<TAP_Approvers__c> TAPApprovers,
                               Map<String, Decimal> isoCodeToConversionRate, Opportunity Opp ){
                               
    System.debug('++++++Method started for ValidateTAPRules++++' );
    TAPApprovers1 = TAPApprovers ;
    Set<Id> userIds = new Set<Id>();
    Map<string,set<Id>> userslevelMap=new Map<string,set<Id>>();
    resultedValueMap = getcalculatedValuesForTAPRules( productLineItems,isoCodeToConversionRate  );
    htftFlagValueMap = getHTFTFlagsValuesForTAPRules(productLineItems); //Education QQ project
    
    System.debug('++++++calculated values from product line items++++++'+ resultedValueMap );
    System.debug('++++++htftFlagValueMap calculated values from product line items++++++'+ htftFlagValueMap );
    String quoteBaseCriteriaId=  this.checkQuoteBaseCriteria(quote,productLineItems,Opp);
    System.debug('++++++Quote Base criteria Id:+++++++++'+  quoteBaseCriteriaId);
    
    TAP_Rules__c rule = null;
    
    if(quoteBaseCriteriaId != null && quoteBaseCriteriaId.length() > 0)
    {
        Quote_Base_Criteria__c QBC = [select Id, Name, Transaction_Type__c,Region__c,Quote_Type__c,Pricing_Group__c from Quote_Base_Criteria__c where Id =:QuoteBaseCriteriaId];
        System.debug('+++++++Entered in TAP Rule Section+++++++');
        System.debug('+++Opportunity Type+++:'+Opp.Type);
        System.debug('+++Quote Product Type+++:'+quote.CA_Quote_Type__c);
        System.debug(QBC.Quote_Type__c);
        //Added for Pricing Project  
        if(((Opp.Type =='Direct' || Opp.Type =='xSP') && (QBC.Transaction_Type__c.contains('Direct')) ||QBC.Transaction_Type__c.contains('xSP')) && 
           (quote.CA_Quote_Type__c == 'New Product' && (quote.CA_Quote_Type__c == QBC.Quote_Type__c) && (QBC.Pricing_Group__c=='Distributed'||QBC.Pricing_Group__c=='SAAS'||QBC.Pricing_Group__c=='Mainframe')))
        { //change by potab02 
            //For Pricing Project by Yedra01
            Map<String,TAP_Rules__c> rules = new Map<String,TAP_Rules__c>();
            rules = this.checkRulesForNewProducts(quote, productLineItems, ruleList,Opp,QBC);
       for(TAP_Rules__c tapRule:rules.values()){
         TAP_RULE_ID_LIST.add(tapRule.id);
        
         }
            System.debug('+++++Rules Found are+++++:'+rules);
                for(String level:rules.keyset())
                {
                    userIds=new set<id>();
                    if(level=='L1'||level=='L3'||level=='L4'||level=='L5'){
                    userIds = this.getApproversforNewProducts(rules.get(level),quote);
                    System.debug('+++L1 or L3 or L4 Approvers++++:'+userIds);
                    userslevelMap.put(level,userIds);
                    }
                }
                if(rules.get('L2')!=null)
                {
                    System.debug('++++L2 Approvers required!++++');
                    set<TAP_Approver__c> TAPuserIds=new set<TAP_Approver__c>();
                    userIds=new set<id>();
                    TAPuserIds = this.getApproversforNewProductsforL2(rules.get('L2'));
                    System.debug('===============TAPuserIds============='+TAPuserIds);
                    set<id> buUsers=new set<id>();
                    System.debug('++++L2 Products List:'+L2ApproverProductList);
                    for(Quote_Product_Report__c QPL:L2ApproverProductList)
                    {                       
                        for(TAP_Approver__c TA:TAPuserIds){
                            if(QPL.Business_Unit__c==TA.BU__c&&quote.Region__c==TA.GEO__c){
                                System.debug('++++L2 Approvers+++++:'+TA.Approver__c);
                                if(TA.Sales_Region__c!=null){
                                if(TA.Sales_Region__c == quote.Territory__c){
                                    userIds.add(TA.Approver__c);    
                                    buUsers.add(TA.id);  
                                    }
                                }
                                else
                                {
                                    userIds.add(TA.Approver__c);    
                                    buUsers.add(TA.id);  
                                }                       
                            }
                            
                        }
                        
                    }
                    System.debug('UserIds:'+userIds);
                    userslevelMap.put('L2',userIds);
                    userslevelMap.put('BU Users',buUsers);
                }
                 if(rules.get('Auto')!=null)
                 userslevelMap.put('Auto',new set<id>());
                 if(rules.get('DDR')!=null){
                    AutoRunDDR = true;
                    userslevelMap.put('DDR',DDRapprover);
                    }
                
        }
        else {
            boolean isauto=false;
            rule  = this.checkRules( quoteBaseCriteriaId ,quote, productLineItems, ruleList,isoCodeToConversionRate,Opp);
             
            if(rule != null)
            {
                TAP_RULE_ID_LIST.add(rule.id);      
            System.debug('++++++++TAP Rule Record++++++++'+rule);
            System.debug('+++++++Entered into Get the Approvers Information:+++++++');
            userIds = this.getApproverIds( rule , quote,isoCodeToConversionRate,productLineItems);
            System.debug('+++++++Approver IDs+++++++'+ userIds);
                if(userIds.size()<=0){
                if(rule.Is_Auto_Approved__c==true)
                  isauto=true;  
                }
            }
            else
            {
            System.debug('+++++++No Rule matches+++++++');
            // getting special approver information from custom label and adding to approvers list
            // user name: 'Jean Schultz' and PMF key : SUSJE01
            if(Opp.Type == '1 Tier')
                 AutoRunDDR = true;
            else 
                userIds.add(Label.Special_Approver_Id);
            }
            if(isauto==true)
             userslevelMap.put('Auto',new set<id>());
             else
            userslevelMap.put('unanimous',userIds);
          }
    }
    else
    {
        System.debug('+++++++No Quote base criteria Maches+++++++');
        // getting special approver information from custom label and adding to approvers list
        // user name: 'Jean Schultz' and PMF key : SUSJE01
        if(Opp.Type == '1 Tier')
                 AutoRunDDR = true;
        else 
                userIds.add(Label.Special_Approver_Id);
        userslevelMap.put('unanimous',userIds);
    }
 return userslevelMap ;
}
set<id> DDRapprover=new set<id>();
//added by potab02   
private Map<String,TAP_Rules__c> checkRulesForNewProducts(scpq__SciQuote__c quote,List<Quote_Product_Report__c> productLineItems,List<TAP_Rules__c> ruleList, 
                                                    Opportunity Opp,Quote_Base_Criteria__c QBC )
{
    
    Map<String,Tap_Rules__c> rules = new Map<String,Tap_Rules__c>(); 
   
    
    
    for(Quote_Product_Report__c product: productLineItems)
    {
     
       
        System.Debug(product.Level_of_Approval_Required__c+'@@');
        if(product.Level_of_Approval_Required__c!='No Level'){
        if(product.Level_of_Approval_Required__c=='Auto Approve')
        isAutoApprove = true;
        else if(product.Level_of_Approval_Required__c=='L1'){
                if(quote.Is_this_an_Agile_Central_Transaction__c=='No')
                    isL1ApprovalRequired=true;
                else if(quote.Is_this_an_Agile_Central_Transaction__c!='No')
                        isAgileL1Aprroval=true;
              system.debug('-----L1-Agile Approver Required----'+isAgileL1Aprroval);

        }
        else if(product.Level_of_Approval_Required__c=='L2')
        {
        isL2ApprovalRequired=true;
        //isL1ApprovalRequired=true;
        if(quote.Is_this_an_Agile_Central_Transaction__c=='No')
          isL1ApprovalRequired=true;
         else if(quote.Is_this_an_Agile_Central_Transaction__c!='No')
           isAgileL1Aprroval=true;
       
       L2ApproverProductList.add(product);
        }
        else if(product.Level_of_Approval_Required__c=='L3'){
        isL3ApprovalRequired=true;
        isL2ApprovalRequired=true;
        //isL1ApprovalRequired=true;
         if(quote.Is_this_an_Agile_Central_Transaction__c=='No')
             isL1ApprovalRequired=true;
         else if(quote.Is_this_an_Agile_Central_Transaction__c!='No')
             isAgileL1Aprroval=true;
            
        L2ApproverProductList.add(product);
         }     
        }
      
      }
    //Quick Quote added by patsa27
    //sunji03 FY19 PS/CAN GEO is added
     if((quote.Agile_Central_Clauses__c.contains('ELA')&&quote.CA_Quote_Type__c=='New product')||(quote.Agile_Central_Clauses__c.containsIgnoreCase('Lighthouse SaaS')&&quote.CA_Quote_Type__c=='New product')||(quote.Ramp_Indicator__c==true&&quote.CA_Quote_Type__c=='New product'&&quote.Is_this_an_Agile_Central_Transaction__c!='No')){
         if(quote.Region__c=='NA' ||quote.Region__c == 'PS/CAN'){  
            if(quote.Level_Four_and_Five_Approvals__c=='L4'){
                isAutoApprove=false;
                if(!isAgileL1Aprroval)
                  isL4ApprovalRequired=true;
            }
         }
         if(quote.Region__c=='LA'||quote.Region__c=='APJ'||quote.Region__c=='EMEA'){
            if(quote.Level_five_approval__c=='L5'){
                isAutoApprove=false;
                if(!isAgileL1Aprroval)
                  isL5ApprovalRequired=true;
            }
         }

       }
        
        Boolean netterm=false;
         System.debug('++++++Modified Flag values++++:'+isAutoApprove+':'+isL1ApprovalRequired+':'+isL2ApprovalRequired+':'+isL3ApprovalRequired+':'+isAgileL1Aprroval);
         for(TAP_Rules__c rule: ruleList){
             //Quick Quote added by patsa27
            System.debug('===================RulesList============'+ruleList);
              if(isL4ApprovalRequired == true&&rule.Approver_Level__c=='L4_Approver'){
                     rules.put('L4',rule);
                     System.debug('=========L4Approver=========='+rules);
                       if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){
                           
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                   }
                 }
             if(isL5ApprovalRequired == true&&rule.Approver_Level__c=='L5_Approver'){
                     rules.put('L5',rule);
                     System.debug('=========L4Approver=========='+rules);
                       if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){
                           
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                   }
                 }
             if(rule.Quote_Base_Criteria__c == QBC.Id && rule.Region__c == QBC.Region__c){
                
                
                 if(isL1ApprovalRequired == true && rule.Approver_Level__c == 'L1_Approver'){
                  
                    rules.put('L1',rule);
                     if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){
                    
        
               
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                }
                 }
                  if(isAgileL1Aprroval == true && rule.Approver_Level__c == 'Rally_Approver'){
                  
                    rules.put('L1',rule);
                     if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){
                    
        
               
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                }
                 }
                 if(isL3ApprovalRequired == true && rule.Approver_Level__c == 'L3_Approver'&&quote.Quick_Quote_Qualified__c=='Yes'){
               
                    rules.put('L3',rule);
                       if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){
                           
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                   }
                 }
                 if(isL2ApprovalRequired == true && rule.Approver_Level__c == 'L2_Approver'){
                
                    rules.put('L2',rule);
                       if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){
                                   
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                }
                 }
                 
               if(isAgileL1Aprroval==false&&isL1ApprovalRequired == false&&isL2ApprovalRequired == false&&isL3ApprovalRequired == false&&isAutoApprove==true&&rule.Is_Auto_Approved__c==true){
               
                 rules.put('Auto',new TAP_Rules__c());
                   if( rule.Net_Term__c != quote.Net_Payment_Terms__c && rule.Deal_Desk_Director_as_Approvers__c){                  
        
               
                      ID approverId1 =  getApprover(rule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         DDRapprover.add( approverId1 );
                         netterm=true;
                     }               
                }
                 }
            }
                        
            
         }
       
        
         
         if(netterm==true)
         rules.put('DDR',new TAP_Rules__c());
    return rules;
}    
//Added for Pricing Project    
private Set<Id> getApproversforNewProducts(TAP_Rules__c rule,scpq__SciQuote__c quote){
    Set<Id> userIds = new Set<Id>();
    System.debug('+++Quote Territory+++:'+quote.Territory__c);
       for(TAP_Approver__c user:rule.TAP_Approvers__r)
       { 
        System.debug('++++User Sales Region+++:'+user.Sales_Region__c);  
         if(rule.Approver_Level__c == 'L1_Approver' && user.Sales_Region__c == quote.Territory__c)  
            userIds.add(user.Approver__c);
      System.debug('++++User Sales solution+++:');  
         if(rule.Approver_Level__c == 'Rally_Approver' &&quote.Region__c==user.Geo__c)  
            userIds.add(user.Approver__c);
         if(rule.Approver_Level__c == 'L3_Approver')
            userIds.add(user.Approver__c);
        if(rule.Approver_Level__c=='L4_Approver'){
            userIds.add(user.Approver__c);
               System.debug('=============userIdsforL4==========='+userIds);}
            if(rule.Approver_Level__c == 'L5_Approver')
            userIds.add(user.Approver__c);
        }
   
        
    System.debug('Users from getApproversforNewProducts:'+userIds);
    return userIds;
}
//Added By Yedra01 for Pricing Project
   
private Set<TAP_Approver__c> getApproversforNewProductsforL2 (TAP_Rules__c rule){
    Set<TAP_Approver__c> userIds = new Set<TAP_Approver__c>();
   
       for(TAP_Approver__c user:rule.TAP_Approvers__r)
       {
           System.debug('======================user=========='+user);
         userIds.add(user);
       }
    System.debug('Users from getApproversforNewProductsforL2:'+userIds);
    return userIds;
}
private String checkQuoteBaseCriteria( scpq__SciQuote__c quote, 
                                       List<Quote_Product_Report__c> productLineItems, Opportunity Opp){

    System.debug('++++++++quote+++++++++++'+quote);
    System.debug('++++++++quote.CA_Commissionable_Area__c+++++++++++'+quote.CA_Commissionable_Area__c);
    System.debug('++++++++quote.scpq__OpportunityId__c+++++++++++'+quote.scpq__OpportunityId__c);
    System.debug('++++++++quote.Region__c+++++++++++'+quote.Region__c);
    
    Set<String> pricingGroups = new Set<String>();
    String pricingGroup = null;
    Boolean isSpecialApporverRequired = false;
    List<Quote_Base_Criteria__c> quoteBaseCriteriaList = null;
    String quoteBaseCriteriaId = null;
     // changed to include the Direct Registration Quote type
    if(( quote.CA_Quote_Type__c == 'New Product')||(quote.CA_Quote_Type__c == 'Direct Registration')){
        
        if( productLineItems != null ){
            for( Quote_Product_Report__c productLineItem: productLineItems){
                if( !pricingGroups.contains(productLineItem.CA_Pricing_Group__c) ){
                    pricingGroups.add(productLineItem.CA_Pricing_Group__c);
                }
            }
           if(pricingGroups != null && pricingGroups.size() > 0  ){
                if(pricingGroups.contains('SaaS') && pricingGroups.size() > 1 ){
                   Set<String> pricingGroups_SAAS = new Set<String>();
                    for( Quote_Product_Report__c productLineItem: productLineItems){
                        if( !pricingGroups_SAAS.contains(productLineItem.CA_Pricing_Group__c) && 
                             productLineItem.Bus_Transaction_Type__c != 'Services' &&
                             productLineItem.Bus_Transaction_Type__c != 'Education'  ){
                             
                            pricingGroups_SAAS.add(productLineItem.CA_Pricing_Group__c);
                        }
                    }
                    
                    if( pricingGroups_SAAS != null && pricingGroups_SAAS.size() > 0 ){
                            for( String str : pricingGroups_SAAS ){
                                pricingGroup = str;                        
                            }
                    }else{
                        isSpecialApporverRequired = true;
                    }
                    
                
                }else{
                    if( pricingGroups.size() == 1){
                        for( String str : pricingGroups ){
                            pricingGroup = str;                        
                        }
                    }else{
                        isSpecialApporverRequired = true;
                    }
                
                
                }
                
            }
            
           System.debug('+++++++pricingGroup++++++'+pricingGroup);
            
        }
        // check quote is eligible for process or not.
        if(quote.CA_Quote_Type__c == 'Direct Registration')
            quote.CA_Quote_Type__c = 'New Product';
            
        if( !isSpecialApporverRequired ){
        System.debug('+++Queryparam+++'+quote.CA_Quote_Type__c+quote.Region__c+pricingGroup+Opp.Type);
            quoteBaseCriteriaList = [ select id, Name from Quote_Base_Criteria__c qbc 
                                                  where qbc.Quote_Type__c =: quote.CA_Quote_Type__c AND 
                                                  qbc.Region__c includes (:quote.Region__c) AND qbc.Pricing_Group__c =:pricingGroup AND qbc.Transaction_Type__c includes (:Opp.Type) ];
        }                                           
    }else if( quote.CA_Quote_Type__c == 'Renewal'){
        
         quoteBaseCriteriaList = [ select id, Name from Quote_Base_Criteria__c qbc 
                                                  where qbc.Quote_Type__c =: quote.CA_Quote_Type__c AND 
                                                  qbc.Commissionable_Area__c includes (:quote.CA_Commissionable_Area__c) AND  
                                                  qbc.Region__c includes (:quote.Region__c)];
    
    }
    
    if(quoteBaseCriteriaList != null && quoteBaseCriteriaList.size() > 0  ){
        System.debug('++++++++quoteBaseCriteriaList.get(0).id+++++++++++++'+ quoteBaseCriteriaList.get(0).id);
        System.debug('++++++++quoteBaseCriteriaList.get(0).Name+++++++++++++'+ quoteBaseCriteriaList.get(0).Name);
        quoteBaseCriteriaId = quoteBaseCriteriaList.get(0).id;        
    }
    return quoteBaseCriteriaId;
}


 public static decimal getMonthsBetween(date startDate, date endDate) 
  {
    decimal n = 0.0;
           
    if( startDate.month()== endDate.month() && startDate.year()== endDate.year() )
    {
       n =  decimal.valueOf((startDate.daysBetween(endDate) + 1 )) / decimal.valueOf(date.daysInMonth(startDate.year(),startDate.month()));
    }
    else
    {
       Integer monthsBetween = startDate.monthsBetween(endDate)-1;
            
       decimal firstMonth = decimal.valueOf(date.daysInMonth(startDate.year() , startDate.month())-startDate.day()+1) 
                                    / decimal.valueOf(date.daysInMonth(startDate.year(), startDate.month()));
            
       decimal lastMonth =  decimal.valueOf(endDate.toStartOfMonth().daysBetween(endDate)+1)  
                                    / decimal.valueOf(date.daysInMonth(endDate.year(), endDate.month()));
            
       n =  firstMonth + monthsBetween + lastMonth;         
    }   
    
    return n.setScale(2, roundingMode.HALF_UP);    
  }
  

private TAP_Rules__c checkRules( String QuoteBaseCriteriaId, 
                         scpq__SciQuote__c quote, List<Quote_Product_Report__c> productLineItems,
                         List<TAP_Rules__c> ruleList, Map<String, Decimal> isoCodeToConversionRate, Opportunity Opp){

   //List<TAP_Rules__c> ruleList = [select id from TAP_Rules__c where Quote_Base_Criteria__c = :QuoteBaseCriteriaId];
    
    TAP_Rules__c finalRule = null;
    Decimal dealTermDuration = null;
    Decimal dealTermVal_Month = 0;
    Decimal dealTermVal = 0;
    Decimal dealTermVal_Converted = 0;
    
    //calculate the deal term value for a given quote.
     if(quote != null && quote.CA_Effective_Date__c != null && quote.CA_Contract_End_Date__c != null ){         
          dealTermDuration = getMonthsBetween(quote.CA_Effective_Date__c, quote.CA_Contract_End_Date__c);
          System.debug('++++++++dealTermDuration++++++++++'+dealTermDuration);
     }
    // calculate the deal value per annum.
     if( dealTermDuration != null && quote != null && quote.CA_CPQ_Quote_Total__c != null && quote.CA_CPQ_Quote_Total__c != 0){
        
        System.debug('Total Quote Value'+ quote.CA_CPQ_Quote_Total__c);
       
        dealTermVal_Converted = quote.CA_CPQ_Quote_Total__c/ isoCodeToConversionRate.get(quote.CurrencyIsoCode);
        dealTermVal_Month = dealTermVal_Converted/dealTermDuration;
        System.debug('Total Quote Value After Converted'+ dealTermVal_Converted);
       
        // calculating one year deal term value.
        dealTermVal = dealTermVal_Month*12;
        //But CA Education Quote consider Quote TOTAL value
        if(isCAEducationQuote)
            dealTermVal = dealTermVal_Converted;
            
        System.debug('++++++++dealTermval++++++++++'+dealTermVal );
     }
   
    // Iterating the TAP rules and identifiing the exact match.        
    for(TAP_Rules__c rule : ruleList){
    
        if( rule.Quote_Base_Criteria__c == QuoteBaseCriteriaId){
            // changed the following if condition to include the Direct REgistration Quote type
            if(( quote.CA_Quote_Type__c == 'New Product')||( quote.CA_Quote_Type__c == 'Direct Registration')){
            // changed the following if condition to include the Direct REgistration Quote type
            if((isCAEducationQuote)||( quote.CA_Quote_Type__c == 'Direct Registration')){
                
                System.debug('++++ isCAEducationQuote ++++'+isCAEducationQuote);   
                
                if(dealTermVal != null && dealTermVal >= rule.Deal_Value_per_Annum_From__c && dealTermVal <= rule.Deal_Value_per_Annum_To__c) {
                    System.debug('++++ CAEducationQuote dealTermVal ++++'+dealTermVal);
                    System.debug('++++ CAEducationQuote rule.Deal_Value_per_Annum_From__c ++++'+rule.Deal_Value_per_Annum_From__c);
                    System.debug('++++ CAEducationQuote rule.Deal_Value_per_Annum_To__c ++++'+rule.Deal_Value_per_Annum_To__c);  
                    if(dealTermDuration != null && dealTermDuration >= rule.TermFrom__c && dealTermDuration <= rule.Term_To__c){
                        System.debug('++++ CAEducationQuote dealTermDuration ++++'+dealTermDuration);
                        System.debug('++++ CAEducationQuote rule.TermFrom__c ++++'+rule.TermFrom__c);
                        System.debug('++++ CAEducationQuote rule.Term_To__c ++++'+rule.Term_To__c);  
                     if( resultedValueMap.containsKey(MAX_DISCOUNT) && resultedValueMap.get(MAX_DISCOUNT) >= rule.Discount_From__c &&
                               resultedValueMap.get(MAX_DISCOUNT) <= rule.Discount_To__c) {
                               System.debug( '+++++++Max Discount value+++++' +resultedValueMap.get(MAX_DISCOUNT) );
                               System.debug('++++ CAEducationQuote rule.Discount_From__c ++++'+rule.Discount_From__c);
                               System.debug('++++ CAEducationQuote rule.Discount_To__c ++++'+rule.Discount_To__c); 
                               if( isRegionExits(rule.Region__c, quote.Region__c)){
                                   System.debug('Inside Rule Check CAEducationQuote >>>'+rule.Name);
                                   return rule;
                            }
                        }
                    }
                }
                        
             }else if( resultedValueMap.containsKey(MAX_DISCOUNT) && 
                       resultedValueMap.get(MAX_DISCOUNT) >= rule.Discount_From__c &&
                       resultedValueMap.get(MAX_DISCOUNT) <= rule.Discount_To__c){
                       System.debug( '+++++++Max Discount value+++++' +resultedValueMap.get(MAX_DISCOUNT) );
                       if( isRegionExits(rule.Region__c, quote.Region__c)){
                       
                           if(Opp.Type == '1 Tier'){
                               if(rule.Source__c == true && (Opp.Source__c == 'Deal Registration' || Opp.Deal_Approval_Status__c == 'Approved and Merged'))
                                   return rule;system.debug('deal reg'+Opp.Source__c+Opp.Deal_Approval_Status__c+rule.source__c+rule.id);
                               if(rule.Source__c == false && (Opp.Source__c != 'Deal Registration' || Opp.Deal_Approval_Status__c != 'Approved and Merged'))
                                   return rule;system.debug('Deal reg false'+Opp.Source__c+Opp.Deal_Approval_Status__c+rule.source__c+rule.id);
                           }
                           else
                               return rule;
              }
             
            }
            }else if( quote.CA_Quote_Type__c == 'Renewal' ){
                System.debug('+++++++++++++checking for renewal TAP Rules');
                if( quote.CA_Commissionable_Area__c == 'Medium Touch Clarity SaaS'){
                    System.debug('This is a Medium Touch Clarity SaaS deal');
                    if( resultedValueMap.containsKey(MAX_DISCOUNT) && resultedValueMap.get(MAX_DISCOUNT) >= rule.Discount_From__c &&
                        resultedValueMap.get(MAX_DISCOUNT) <= rule.Discount_To__c) {
                         if( dealTermDuration != null && dealTermDuration >= rule.TermFrom__c &&
                             dealTermDuration <= rule.Term_To__c){
                             if( isRegionExits(rule.Region__c, quote.Region__c)){
                                    if( isCommitionanleAreaExits( rule.Commissionable_Area__c, 
                                                                  quote.CA_Commissionable_Area__c)){
                                         if( quote.CA_Realization_Rate__c != null && quote.CA_Realization_Rate__c >= rule.Realization_From__c && 
                                            quote.CA_Realization_Rate__c <= rule.Realization_To__c){
                            
                                         System.debug('Medium Touch Clarity SaaS Tap Rule:'+rule.Name);                           
                                         return rule;
                                        }
                                    }        
                                }
                         }
                    }
                
               } else{
                     System.debug('Inside Rule Check 1 >>>'+dealTermVal);
                     System.debug('Inside Rule Check 1 >>>'+rule.Deal_Value_per_Annum_From__c);
                     
                     if( dealTermVal != null && dealTermVal >= rule.Deal_Value_per_Annum_From__c &&
                         dealTermVal <= rule.Deal_Value_per_Annum_To__c) {
                            System.debug('Inside Rule Check 2 >>>');
                            System.debug('Inside Rule Check 2 >>>'+dealTermDuration);
                            System.debug('Inside Rule Check 2 >>>'+rule.TermFrom__c);
                        if( dealTermDuration != null && dealTermDuration >= rule.TermFrom__c &&
                             dealTermDuration <= rule.Term_To__c){
                                System.debug('Inside Rule Check 3 >>>');
                                System.debug('Inside Rule Check 3 >>>'+quote.CA_Realization_Rate__c);
                                System.debug('Inside Rule Check 3 >>>'+rule.Realization_From__c);
                            if( quote.CA_Realization_Rate__c != null && quote.CA_Realization_Rate__c >= rule.Realization_From__c && 
                                quote.CA_Realization_Rate__c <= rule.Realization_To__c){
                                    System.debug('Inside Rule Check 4 >>>');
                                    System.debug('Inside Rule Check 4 >>>'+isRegionExits(rule.Region__c, quote.Region__c));
                                if( isRegionExits(rule.Region__c, quote.Region__c)){
                                    System.debug('Inside Rule Check 5 >>>');
                                    System.debug('Inside Rule Check 5 >>>'+rule.Commissionable_Area__c);
                                    System.debug('Inside Rule Check 5 >>>'+quote.CA_Commissionable_Area__c);
                                    if( isCommitionanleAreaExits( rule.Commissionable_Area__c, 
                                                                  quote.CA_Commissionable_Area__c)){
                                         System.debug('Inside Rule Check 6 >>>');
                                         System.debug('Inside Rule Check 6 >>>'+rule.Name);
                                         return rule;
                                    }                                     
                                }
                            }                 
                        }
                    }
                }
            } }        
        }    
    
    
  return null;     
}

public Boolean isCommitionanleAreaExits( String rule_Comm_Area, String quote_Comm_Area){

    String[] commitionableAreas = null;
    
    Boolean flag = false;
    
    if( rule_Comm_Area != null ){
         commitionableAreas = rule_Comm_Area.split(';');
    }
    
    if( commitionableAreas != null ){
        for( String comm_Area : commitionableAreas ){
            if( quote_Comm_Area != null && comm_Area  != null && comm_Area.equalsIgnoreCase( quote_Comm_Area )  ){
                flag = true;
                return flag;
            }
        
        }
    
    }

return flag ;
}

public Boolean isRegionExits( String rule_region, String quote_region ){

    String[] regions= null;
    
    Boolean flag = false;
    
    if( rule_region != null ){
         regions= rule_region.split(';');
    }
    
    if( regions != null ){
        for( String region: regions){
            if( quote_region != null && region != null && region.equalsIgnoreCase( quote_region )  ){
                flag = true;
                return flag;
            }
        
        }
    
    }

return flag ;
}


public ID getApprover(Id id, String segment, String region, String area, String territory, String type ){// YEDRA01 for AR3217 added id extra

    if( TAPApprovers1 != null ){
      
        for( TAP_Approvers__c TAPApprover_temp : TAPApprovers1){             

         System.debug('+++++Fetching '+'type'+' Approvers+++++++');
             System.debug('++++region++++'+TAPApprover_temp.Region__c);
             System.debug('++++Account Segment++'+TAPApprover_temp.Segment__c);
             System.debug('++++Sales Area+++'+TAPApprover_temp.Area__c);
             System.debug('+++++Territory++++'+TAPApprover_temp.Territory__c);
             System.debug('++++++Type++++'+TAPApprover_temp.Type__c);
             
            if( String.isEmpty( TAPApprover_temp.Segment__c )|| TAPApprover_temp.Segment__c == segment){
                if( String.isEmpty(TAPApprover_temp.Region__c) || TAPApprover_temp.Region__c == region){
                    if( String.isEmpty(TAPApprover_temp.Territory__c) || TAPApprover_temp.Territory__c == territory){
                        if(String.isEmpty(TAPApprover_temp.Area__c) || TAPApprover_temp.Area__c == area){
                            if( String.isEmpty(TAPApprover_temp.Type__c) || TAPApprover_temp.Type__c == type){
                                
                                 if(String.isEmpty(TAPApprover_temp.TAP_Rules__c))//YEDRA01 for AR3217 
                                        {//YEDRA01 for AR3217 
                                            System.debug('+++++++TAP RUles on the Approver i EMPTY++++++++');
                                             System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                             if( TAPApprover_temp != null)
                                                return TAPApprover_temp.Approver__c;   
                                                //YEDRA01 for AR3217  Start                                     
                                        }                                    
                                        else 
                                        {
                                            System.debug('+++++++TAP RUles on TAPAPProver++++++++'+TAPApprover_temp.TAP_Rules__c);
                                            String rules = TAPApprover_temp.TAP_Rules__c;
                                            System.debug('+++++++rules.contains(id)++++++++'+rules.contains(id));
                                            System.debug('+++++++id++++++++'+id);
                                            System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                            if(rules.contains(id))
                                            {
                                                 System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                                 if( TAPApprover_temp != null)
                                                    return TAPApprover_temp.Approver__c;                                            
                                            }
                                        }   //YEDRA01 for AR3217 end
                            }
                        }
                    }
                }
            }           
        }
    }
    return null;

}

public ID getApproverFY15(Id id, String segment, String region, String area, String territory, String subTerritory, String approverType ){// YEDRA01 for AR3217 added id extra

    if( TAPApprovers1 != null ){
      
            for( TAP_Approvers__c TAPApprover_temp : TAPApprovers1){             
    
                 System.debug('+++++Fetching '+approverType+' Approvers+++++++');
                 System.debug('++++region++++'+TAPApprover_temp.Region__c);
                 System.debug('++++Account Segment++'+TAPApprover_temp.Segment__c);
                 System.debug('++++Sales Area+++'+TAPApprover_temp.Area__c);
                 System.debug('+++++Territory++++'+TAPApprover_temp.Territory__c);
                 System.debug('+++++Sub Territory++++'+TAPApprover_temp.Sub_Territory__c);
                 System.debug('++++++Type++++'+TAPApprover_temp.Type__c);
                 
                if(String.isEmpty( TAPApprover_temp.Segment__c )|| TAPApprover_temp.Segment__c == segment){//Check Segment
                    if(String.isEmpty(TAPApprover_temp.Region__c) || TAPApprover_temp.Region__c == region){//Check GEO
                        if(String.isEmpty(TAPApprover_temp.Area__c) || TAPApprover_temp.Area__c == area){//Check Operating Area
                            if(String.isEmpty(TAPApprover_temp.Territory__c) || TAPApprover_temp.Territory__c == territory){//Checking Sales Region
                                if(String.isEmpty(TAPApprover_temp.Sub_Territory__c) || TAPApprover_temp.Sub_Territory__c == subTerritory){//Checking Sub Territory
                                    if(String.isEmpty(TAPApprover_temp.Type__c) || TAPApprover_temp.Type__c == approverType){//Checking the Approver Type
                                    
                                      if(String.isEmpty(TAPApprover_temp.TAP_Rules__c))////YEDRA01 for AR3217
                                        {//YEDRA01 for AR3217
                                            System.debug('+++++++TAP RUles on the Approver i EMPTY++++++++');
                                             System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                             if( TAPApprover_temp != null)
                                                return TAPApprover_temp.Approver__c;   
                                                //YEDRA01 for AR3217 start                                     
                                        }
                                        else  
                                        {
                                            System.debug('+++++++TAP RUles on TAPAPProver++++++++'+TAPApprover_temp.TAP_Rules__c);
                                            String rules = TAPApprover_temp.TAP_Rules__c;
                                            System.debug('+++++++rules.contains(id)++++++++'+rules.contains(id));
                                            System.debug('+++++++id++++++++'+id);
                                            System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                            if(rules.contains(id))
                                            {
                                                 System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                                 if( TAPApprover_temp != null)
                                                    return TAPApprover_temp.Approver__c;                                            
                                            }
                                        }    //YEDRA01 for AR3217 End                        
                                }
                            }
                        }
                    }
                }           
            }
        }
    }
    
    return null;    
}

public ID getVPCPMApprover( ID id, String segment, String region, String area, String territory, String subTerritory, String approverType ){

    System.debug('+++++ In getVPCPMApprover +++++++');
    if( TAPApprovers1 != null ){
      
            for( TAP_Approvers__c TAPApprover_temp : TAPApprovers1){             
    
                 System.debug('+++++Fetching '+approverType+' Approvers+++++++');
                 System.debug('++++region++++'+TAPApprover_temp.Region__c);
                 System.debug('++++Account Segment++'+TAPApprover_temp.Segment__c);
                 System.debug('++++Sales Area+++'+TAPApprover_temp.Area__c);
                 System.debug('+++++Territory++++'+TAPApprover_temp.Territory__c);
                 System.debug('+++++Sub Territory++++'+TAPApprover_temp.Sub_Territory__c);
                 System.debug('++++++Type++++'+TAPApprover_temp.Type__c);
                 
                if(String.isEmpty( TAPApprover_temp.Segment__c )|| TAPApprover_temp.Segment__c == segment){//Check Segment
                    if(String.isEmpty(TAPApprover_temp.Region__c) || TAPApprover_temp.Region__c == region){//Check GEO
                        if(String.isEmpty(TAPApprover_temp.Area__c) || TAPApprover_temp.Area__c == area){//Check Operating Area
                            if(String.isEmpty(TAPApprover_temp.Territory__c) || TAPApprover_temp.Territory__c == territory){//Checking Sales Region
                                if(String.isEmpty(TAPApprover_temp.Sub_Territory__c) || TAPApprover_temp.Sub_Territory__c == subTerritory){//Checking Sub Territory
                                    if(String.isEmpty(TAPApprover_temp.Type__c) || TAPApprover_temp.Type__c == approverType){//Checking the Approver Type
                                        if(String.isEmpty(TAPApprover_temp.TAP_Rules__c))
                                        {
                                            System.debug('+++++++TAP RUles on the Approver i EMPTY++++++++');
                                             System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                             if( TAPApprover_temp != null)
                                                return TAPApprover_temp.Approver__c;                                        
                                        }
                                        else
                                        {
                                            System.debug('+++++++TAP RUles on TAPAPProver++++++++'+TAPApprover_temp.TAP_Rules__c);
                                            String rules = TAPApprover_temp.TAP_Rules__c;
                                            System.debug('+++++++rules.contains(id)++++++++'+rules.contains(id));
                                            System.debug('+++++++id++++++++'+id);
                                            System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                            if(rules.contains(id))
                                            {
                                                 System.debug('+++++++Deal Desk Approver record++++++++'+TAPApprover_temp );
                                                 if( TAPApprover_temp != null)
                                                    return TAPApprover_temp.Approver__c;                                            
                                            }
                                        }
                                }
                            }
                        }
                    }
                }           
            }
        }
    }
    
    return null;    
}


public Map<String,String> getHTFTFlagsValuesForTAPRules(List<Quote_Product_Report__c> QPRLines){
       
       Map<String,String> htftFlagsMap = new Map<String,String>(); 
             
       for(Quote_Product_Report__c QPR:QPRLines){           
            if(QPR.Bus_Transaction_Type__c == 'Time - Product Migration'){
                htftFlagsMap.put('Migration_UPDATE', 'TRUE');
            }           
            if(QPR.Royalty_Product__c){
                htftFlagsMap.put('Royalty', 'TRUE');
            }
           //merha02
            if(QPR.Auth_Use_Model__c == 'Special Metric'){
                htftFlagsMap.put('Special_Metric', 'TRUE');
            }
       }  
       return htftFlagsMap;                                 
}


public Map<String,Decimal> getcalculatedValuesForTAPRules(List<Quote_Product_Report__c> QPRLines,  
                                                Map<String, Decimal> isoCodeToConversionRate){
    Decimal MaxDiscount = 0;
    Decimal MaxServicesDiscount = 0;
    Decimal MaxEducationDiscount = 0;
    ValuesMap.put(PERPETUAL, 0);
    
    for(Quote_Product_Report__c QPR:QPRLines){      
        //changes by potab02
       /* if(QPR.Target_Disc_Percent__c!='N/A' && QPR.Floor_Disc_Percent__c!='N/A' && QPR.Sales_Mgmt_Approval_Percent__c!='N/A'){
            Map<String,Decimal> discountsMap = new Map<String,Decimal>();
            discountsMap.put('Target Discount Percent', Decimal.valueOf(QPR.Target_Disc_Percent__c));
            discountsMap.put('Floor Discount Percent', Decimal.valueOf(QPR.Floor_Disc_Percent__c));
            discountsMap.put('Sales Management Percent', Decimal.valueOf(QPR.Sales_Mgmt_Approval_Percent__c));
            
            discountValuesMapOfProductLineItems.put(QPR.Name,discountsMap); 

        } */
        
        //Modification done for Education QQ PR04433
        System.debug('+++CAEducation QPR.CA_Pricing_Group__c +++'+QPR.CA_Pricing_Group__c);
        System.debug('+++CAEducation QPR.Bus_Transaction_Type__c +++'+QPR.Bus_Transaction_Type__c);
        
         if(QPR.CA_Pricing_Group__c == 'Education' && QPR.Bus_Transaction_Type__c == 'Education'){//CA Education Quotes
             
             isCAEducationQuote = true;
             
             if(QPR.Total_Discount_off_Volume_GSA_Price__c != null && QPR.Total_Discount_off_Volume_GSA_Price__c != 0){
                System.debug('+++inside CAEducation Calculation 1+++');                     
                if(QPR.Total_Discount_off_Volume_GSA_Price__c > MaxDiscount){
                    MaxDiscount = QPR.Total_Discount_off_Volume_GSA_Price__c;
                }
             }else if(QPR.Total_Disc_off_List__c != null && QPR.Total_Disc_off_List__c != 0){
                System.debug('+++inside CAEducation Calculation 2+++');                 
                if(QPR.Total_Disc_off_List__c > MaxDiscount){
                    MaxDiscount = QPR.Total_Disc_off_List__c;
                }
             } 
             
         }else{
            
            
             if( QPR.Bus_Transaction_Type__c != 'Services' && QPR.Bus_Transaction_Type__c != 'Education' && 
                QPR.Total_Discount_off_Volume_GSA_Price__c!=null && QPR.Total_Discount_off_Volume_GSA_Price__c!=0){
                if(QPR.Total_Discount_off_Volume_GSA_Price__c > MaxDiscount){
                    MaxDiscount = QPR.Total_Discount_off_Volume_GSA_Price__c;
                }           
             }else if( QPR.Bus_Transaction_Type__c != 'Services' && QPR.Bus_Transaction_Type__c != 'Education' &&
                        QPR.Total_Disc_off_List__c!=null && QPR.Total_Disc_off_List__c!=0){
                if(QPR.Total_Disc_off_List__c > MaxDiscount){
                    MaxDiscount = QPR.Total_Disc_off_List__c;
                }           
            }  
                  
            if(QPR.Bus_Transaction_Type__c == 'Services'){
                ValuesMap.put(IS_NIMSOFT_SERVICES_EXISTS,1);
                if(QPR.Total_Disc_off_List__c !=null && QPR.Total_Disc_off_List__c !=0){
                    if(QPR.Total_Disc_off_List__c > MaxServicesDiscount){
                        MaxServicesDiscount = QPR.Total_Disc_off_List__c;
                    }
                }
            }else if(QPR.Bus_Transaction_Type__c == 'Education'){
                ValuesMap.put(IS_NIMSOFT_EDUCATION_EXISTS,1);
                if(QPR.Total_Disc_off_List__c !=null && QPR.Total_Disc_off_List__c !=0){
                    if(QPR.Total_Disc_off_List__c > MaxEducationDiscount){
                        MaxEducationDiscount = QPR.Total_Disc_off_List__c;
                    }
                }
            }        
            if(QPR.License_Type__c == 'Perpetual' && ValuesMap.get(PERPETUAL)==0){
                ValuesMap.put(PERPETUAL,1);
            }
            
         } //Other than CAEducation Quotes
   
    } 
    
    ValuesMap.put( MAX_DISCOUNT, MaxDiscount);
    ValuesMap.put( MAX_SERVICES_DISCOUNT, MaxServicesDiscount);
    ValuesMap.put( MAX_EDUCATION_DISCOUNT, MaxEducationDiscount);
    
    System.debug('+++++ValuesMap+++++++'+ValuesMap);
    
    return ValuesMap;
}

private Set<Id> getApproverIds( TAP_Rules__c finalRule, scpq__SciQuote__c quote, Map<String, Decimal> isoCodeToConversionRate,List<Quote_Product_Report__c> productLineItems ){
    
    Decimal dealTermDuration = null;
    Decimal dealTermVal_Month = 0;
    Decimal dealTermVal = 0;
    Decimal  dealTermVal_Converted = 0;
    Set<ID> userIds = new Set<ID>();    
    Boolean isEducationRequired = true;
    Boolean isServicesRequired = true;
    
    List<TAP_Approver__c> TAPApprovers = finalRule.TAP_Approvers__r;
    
    
    //calculate the deal term value for a given quote.
     if(quote != null && quote.CA_Effective_Date__c != null && quote.CA_Contract_End_Date__c != null ){
          //dealTermDuration =  quote.CA_Effective_Date__c.monthsBetween( quote.CA_Contract_End_Date__c); Changed by allha02 for AR3321
          dealTermDuration = getMonthsBetween(quote.CA_Effective_Date__c, quote.CA_Contract_End_Date__c);
     }
    // calculate the deal vale per annum.
     if( dealTermDuration != null && quote != null && quote.CA_CPQ_Quote_Total__c != null && quote.CA_CPQ_Quote_Total__c != 0){
        System.debug('Total Quote Value'+ quote.CA_CPQ_Quote_Total__c);
        dealTermVal_Converted = quote.CA_CPQ_Quote_Total__c/ isoCodeToConversionRate.get(quote.CurrencyIsoCode);
        dealTermVal_Month = dealTermVal_Converted/dealTermDuration;
        System.debug('Total Quote Value After Converted'+ dealTermVal_Converted);
       
        // calculating one year deal term value.
        dealTermVal = dealTermVal_Month*12;
     }
     //Changed to include the Direct Registration Quote Type)
    if((quote.CA_Quote_Type__c == 'New Product')||(  quote.CA_Quote_Type__c == 'Direct Registration')){
        if(quote.CA_Quote_Type__c == 'New Product'&&quote.Is_this_an_Agile_Central_Transaction__c!='No'&&quote.Is_this_an_Agile_Central_Transaction__c!=null){
            for(Quote_Product_Report__c qpl:productLineItems){
            if(quote.Agile_Central_Clauses__c.ContainsIgnoreCase('ELA')&&finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Deal_Desk_Director_as_Approvers__c){
                Id approverId=getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_EDU);
                if( approverId != null ){
                    userIds.add( approverId );
                 }   
            }
            if(quote.Agile_Central_Clauses__c.containsIgnoreCase('Lighthouse SaaS')&&finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Deal_Desk_Director_as_Approvers__c){
                Id approverId=getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_EDU);
                if( approverId != null ){
                    userIds.add( approverId );
                 }   
            }
            if(qpl.Ramp_Pricing__c=='Yes'&&finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Deal_Desk_Director_as_Approvers__c){
                
                Id approverId=getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_EDU);
                if( approverId != null ){
                    userIds.add( approverId );
                 }   
            }
        }
    }
        
        //Changed to include the Direct Registration Quote Type)
        if((isCAEducationQuote)||(  quote.CA_Quote_Type__c == 'Direct Registration')){  
            
                //Get CA Education Deal Desk Approvals for Sales Approval
                if(!finalRule.Is_Auto_Approved__c){
                     ID approverId =  getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_EDU);// YEDRA01 for AR3217 added id extra 
                     if( approverId != null ){
                         userIds.add( approverId );
                     }   
                }
                
                // checking the NET TERMS condition 
                System.debug('Net Terms value'+quote.Net_Payment_Terms__c);
                System.debug('Net Terms rule value'+finalRule.Net_Term__c);
                System.debug('Net Terms rule check box'+finalRule.Deal_Desk_Director_as_Approvers__c);
                System.debug('Net Terms rule for SR DDR check box'+finalRule.Net_Term_Sr_DD_Approval__c);
        
                if( finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Net_Term_Sr_DD_Approval__c){//CA Education New Products
                    
                    System.debug('+++quote.Account_Segment__c+++'+quote.Account_Segment__c);
                    System.debug('+++quote.Region__c+++'+quote.Region__c);
                    System.debug('+++quote.SalesArea__c+++'+quote.SalesArea__c);
                    System.debug('+++quote.Territory__c+++'+quote.Territory__c);
                    System.debug('+++quote.Sub_Territory__c+++'+quote.Sub_Territory__c);
               
                     ID approverId1 =  getApproverFY15(finalRule.Id, quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_SR); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         userIds.add( approverId1 );
                     }               
                }
                
        }else{
       
         if( finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Deal_Desk_Director_as_Approvers__c){
             System.debug('+++++Net terms+++++++');
             System.debug('+++++Net terms+++region++++'+quote.Region__c);
             System.debug('+++++Net terms+++++Account Segment++'+quote.Account_Segment__c);
             System.debug('+++++Net terms++++Sales Area+++'+quote.SalesArea__c);
             System.debug('+++++Net terms+++Territory++++'+quote.Territory__c);
             System.debug('+++++Net terms+++DD_TYPE_VAL++++'+DD_TYPE_VAL);
             ID approverId =  getApprover(finalRule.Id,quote.Account_Segment__c,quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
             if( approverId != null ){
                 userIds.add( approverId );
             }
             
         }
        //checking deal term value and licence type.
         if( resultedValueMap.containsKey(PERPETUAL) && resultedValueMap.get(PERPETUAL) == 1 &&
             dealTermDuration != null && dealTermDuration >= finalRule.TermFrom__c && dealTermDuration <= finalRule.Term_To__c && finalRule.Include_Deal_Desk_Director_as_Approvers__c){
                 System.debug('+++++Deal terms+++++++');
                 System.debug('+++++Deal terms++ Perpetual+++++'+resultedValueMap.get(PERPETUAL));
                  System.debug('+++++Deal terms+++rule term from++++'+finalRule.TermFrom__c);
                  System.debug('+++++Deal terms+++rule term to++++'+finalRule.Term_To__c);
                 System.debug('+++++Deal terms+++dealTermDuration ++++'+dealTermDuration );
                 
                 
              ID approverId =  getApprover(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
             if( approverId != null ){
                 userIds.add( approverId );
             }
          
         }
         if( resultedValueMap.containsKey(IS_NIMSOFT_SERVICES_EXISTS) && 
             resultedValueMap.get(IS_NIMSOFT_SERVICES_EXISTS) == 1 &&              
             resultedValueMap.get(MAX_SERVICES_DISCOUNT) > finalRule.Services_Discount_Threshold__c){
                 System.debug('+++++Nimsoft Services AND >20+++++++');
                 
                     isServicesRequired = false;
                     
                     ID approverId =  getApprover(finalRule.Id, quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId != null ){
                         userIds.add( approverId );
                     } 
                     
                     ID approverId1 =  getApprover(finalRule.Id, null,quote.Region__c, null, null,DD_TYPE_VAL_NS); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         userIds.add( approverId1 );
                     }
                 
                 
                 
            // need to get the approvers information 
         }
         if( resultedValueMap.containsKey(IS_NIMSOFT_EDUCATION_EXISTS) && 
             resultedValueMap.get(IS_NIMSOFT_EDUCATION_EXISTS) == 1 &&
             resultedValueMap.get(MAX_EDUCATION_DISCOUNT) > finalRule.Education_Discount_Threshold__c){
                 System.debug('+++++Nimsoft Education AND >20+++++++');  
                 
                     isEducationRequired = false;
                 
                     ID approverId =  getApprover(finalRule.Id, null,quote.Region__c, null, null,DD_TYPE_VAL_NE); // YEDRA01 for AR3217 added id extra
                     if( approverId != null ){
                         userIds.add( approverId );
                     }
                     
                     ID approverId1 =  getApprover(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         userIds.add( approverId1 );
                     }                      
                 
                 
                 // need to get the approvers information
             
         }
        }   
        
    }else if( quote.CA_Quote_Type__c == 'Renewal'){
        
    System.debug('++++In TAP Renewal+++++');
    System.debug('++++Final Rule+++++'+finalRule);
    
    //sunji03 FY19 PS/CAN GEO is added
    if((finalRule.Commissionable_Area__c == 'High Touch Fast Track' || finalRule.Commissionable_Area__c == 'Medium Touch Clarity SaaS'||(finalRule.Commissionable_Area__c=='Medium Touch Agile Central'||finalRule.Commissionable_Area__c.contains('Agile Central')))&& (finalRule.Region__c == 'NA' || finalRule.Region__c == 'PS/CAN')){
            
            System.debug('++++ In TAP Renewal for NA-HTFT +++++');
            
            System.debug('+++quote.Account_Segment__c+++'+quote.Account_Segment__c);
            System.debug('+++quote.Region__c+++'+quote.Region__c);
            System.debug('+++quote.SalesArea__c+++'+quote.SalesArea__c);
            System.debug('+++quote.Territory__c+++'+quote.Territory__c);
            System.debug('+++quote.Sub_Territory__c+++'+quote.Sub_Territory__c);        
            
                        
            //Check and fetch Sr Deal Desk Approvers
            if(finalRule.Is_SR_DD_Approval__c){
                 System.debug('+++finalRule.Is_SR_DD_Approval__c+++'+finalRule.Is_SR_DD_Approval__c);           
                 ID approverId1 =  getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_SR);// YEDRA01 for AR3217 added id extra 
                 if( approverId1 != null ){
                     userIds.add( approverId1 );                     
                 } 
            } 
            //Check and Fetch VP,CPM Approvers
            if(finalRule.Is_VP_CPM_Approval__c){
                 System.debug('+++finalRule.Is_VP_CPM_Approval__c+++'+finalRule.Is_VP_CPM_Approval__c); 
                 ID approverId1 =  getVPCPMApprover( finalRule.ID, quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_VPCPM); 
                 if( approverId1 != null ){
                     userIds.add( approverId1 );
                 } 
            }
            //Check and Fetch Legal Approvers
            if(finalRule.Is_Legal_Approval__c){
                 System.debug('+++finalRule.Is_Legal_Approval__c+++'+finalRule.Is_Legal_Approval__c); 
                 ID approverId1 =  getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_LEGAL); // YEDRA01 for AR3217 added id extra
                 if( approverId1 != null ){
                     userIds.add( approverId1 );
                 } 
            }
            //Check and Fetch Sr Deal Desk Approvers for NET Terms
            if(finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Net_Term_Sr_DD_Approval__c){
                 System.debug('+++finalRule.Net_Term_Sr_DD_Approval__c+++'+finalRule.Net_Term_Sr_DD_Approval__c);
                 ID approverId1 =  getApproverFY15(finalRule.Id, quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DD_TYPE_VAL_SR); // YEDRA01 for AR3217 added id extra
                 if( approverId1 != null ){
                     userIds.add( approverId1 );
                 } 
            }
            //Check and Fetch Deal Desk Approvers for Royalty product
            if(finalRule.Royalty_Product__c){
                 System.debug('+++finalRule.Royalty_Product__c+++'+finalRule.Royalty_Product__c);
                 //Checking the Royalty Product
                  System.debug('+++Royalty+++'+htftFlagValueMap.containsKey('Royalty')+' '+htftFlagValueMap.get('Royalty'));
                  if( htftFlagValueMap.containsKey('Royalty') && htftFlagValueMap.get('Royalty') == 'TRUE') {
                         ID approverId1 =  getApproverFY15(finalRule.Id, quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DDMGR_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                         if( approverId1 != null ){
                             userIds.add( approverId1 );
                         } 
                  }              
            }
            //Check and Fetch Deal Desk Approvers for Migration/Upgrade 
            if(finalRule.Bus_Transaction_Type__c){
                
                 System.debug('+++Bus_Transaction_Type__c+++'+htftFlagValueMap.containsKey('Migration_UPDATE')+' '+htftFlagValueMap.get('Migration_UPDATE'));
                 if( htftFlagValueMap.containsKey('Migration_UPDATE') && htftFlagValueMap.get('Migration_UPDATE') == 'TRUE') {
                     ID approverId1 =  getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c, quote.Sub_Territory__c, DDMGR_TYPE_VAL); // YEDRA01 for AR3217 added id extra
                     if( approverId1 != null ){
                         userIds.add( approverId1 );
                     } 
                 }
            }
      
        }else{          
        // checking the net terms condition 
         if( finalRule.Net_Term__c != quote.Net_Payment_Terms__c && finalRule.Deal_Desk_Director_as_Approvers__c &&
             finalRule.Deal_Desk_Director_as_Approvers__c){
             ID approverId =  getApprover(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
             if( approverId != null ){
             userIds.add( approverId );
             }            
         }
        }
        
        //merha02
    if(finalRule.Commissionable_Area__c == 'High Touch Fast Track' || finalRule.Commissionable_Area__c == 'Medium Touch Clarity SaaS'||
           finalRule.Commissionable_Area__c=='Medium Touch Agile Central'||finalRule.Commissionable_Area__c=='Medium Touch Nimsoft SaaS'|| 
           finalRule.Commissionable_Area__c=='Medium Touch;Acquisition;Indirect Medium Touch' || 
           finalRule.Commissionable_Area__c=='Medium Touch;Indirect Medium Touch;Medium Touch Nimsoft SaaS'|| 
           finalRule.Commissionable_Area__c == 'Acquisition'){
      // To fetch approver for Special Metric
          if(finalRule.Special_Metric__c){
                System.debug('-----Special Metric Line Items------');
                if(htftFlagValueMap!=null && htftFlagValueMap.size()>0){
                    if( htftFlagValueMap.containsKey('Special_Metric') && htftFlagValueMap.get('Special_Metric') == 'TRUE') {
                     ID approverId1 =  getApproverFY15(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, 
                                                       quote.Territory__c, quote.Sub_Territory__c, DDSM_TYPE_VAL);
                     if( approverId1 != null ){
                         userIds.add( approverId1 );
                     } 
                 }
                }
                 
            }      
    }
            
    }//End of Renewal
    
    // This is to pull the Deal desk approver for SaaS. Quote type might be "New Product" Or "Renewal".
     if( finalRule.Deal_Desk_Approver_SaaS__c){
             ID approverId =  getApprover(finalRule.Id,quote.Account_Segment__c, quote.Region__c, quote.SalesArea__c, quote.Territory__c,DD_TYPE_VAL); // YEDRA01 for AR3217 added id extra
             if( approverId != null ){
                 userIds.add( approverId );
             }            
     } 
    
    //Fetch TAP approvers directly attached to the TAP Rules
    if( TAPApprovers != null ){
        System.Debug('+++++TAP Approvers Information'+TAPApprovers); 
        System.debug('NimSoft services value'+resultedValueMap.get(IS_NIMSOFT_SERVICES_EXISTS));   
        for(TAP_Approver__c approver : TAPApprovers){            
            //Id, Name, Approver__c, Type__c
            if( approver.Type__c == 'Financial'){
                System.debug('+++++Financial TAP Approver record Id+++++'+approver.Id);
                userIds.add(approver.Approver__c);
            }else if( approver.Type__c == 'Nimsoft Services' && resultedValueMap.containsKey(IS_NIMSOFT_SERVICES_EXISTS)
                     && (resultedValueMap.get(IS_NIMSOFT_SERVICES_EXISTS) == 1) && isServicesRequired){
                 System.debug('+++++Nimsoft Services TAP Approver record Id+++++'+approver.Id);
                 userIds.add(approver.Approver__c);
            }else if( approver.Type__c == 'Education Services' && resultedValueMap.containsKey(IS_NIMSOFT_EDUCATION_EXISTS) && isEducationRequired){
                 System.debug('+++++Education Services TAP Approver record Id+++++'+approver.Id);
                 userIds.add(approver.Approver__c);
            }
            
        }
    }
    
     if( finalRule.Opp_Owner_s_Manager__c ){
    
    scpq__SciQuote__c quoteList = [Select scpq__OpportunityId__r.Owner.Id from scpq__SciQuote__c where Id =: quote.Id];
 
     User u = [select managerId from user where id =: quoteList.scpq__OpportunityId__r.Owner.Id limit 1];
   
    if(u != null && u.managerId != null ){
        userIds.add(u.managerId);
        System.debug('+++++Opp Owner Manager Id+++++'+u.managerId);
    }
    }
    //
return userIds;
}

@future
public static void updateApproverId(Set<Id> SQRecIdSet, Set<Id> AutoApprovedQuotes){
    System.debug('-------SQRecIdSet-------'+SQRecIdSet);
    System.debug('-------AutoApprovedQuotes-------'+AutoApprovedQuotes);
    Map<Id,Id> RecAndApprovalIdmap = new Map<Id,Id>();
    Map<Id,Id> RecAndNewWorkItemIdMap = new Map<Id,Id>();
    Map<Id,Id> SQRecIdAndProcessIdMap = new map<Id,Id>();
    List<ProcessInstance> PIList = [select id,TargetObjectId from ProcessInstance where Status=:'Pending' AND TargetObjectId IN: SQRecIdSet];
   System.debug('Future method started');
    if(PIList != null && PIList.size()>0){
        for(ProcessInstance pi:PIList){
            if(!SQRecIdAndProcessIdMap.containsKey(pi.TargetObjectId)){
                SQRecIdAndProcessIdMap.put(pi.TargetObjectId,pi.Id);
            }
        }
    }
System.debug('Process Instance list'+PIList );
System.debug(' SQRecIdAndProcessIdMap '+ SQRecIdAndProcessIdMap);
    //--------NEED TO ADD REQUIRED CONDITIONS AND REMOVE TRY BLOCK------------------
    List<scpq__SciQuote__c> SQListToBeUpdated;
    
        if(SQRecIdSet != null && SQRecIdSet.size() > 0){
           System.debug( 'SQRecIdSet  is iterated' + SQRecIdSet );
            for(Id i:SQRecIdSet){
                if(  !SQRecIdAndProcessIdMap.containsKey(i)){
                    System.debug( 'Approval process' + i);
                    Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
                    submitRequest.setObjectId(i);        
                    Approval.ProcessResult result = Approval.process(submitRequest);        
                    RecAndApprovalIdmap.put(result.getEntityId(),result.getInstanceId());
                }       
            }
        }else{
            SQRecIdSet = new Set<Id>();
        }
        
        //-----Adding auto-approval records to the SQRecIdSet-----------------
        if(AutoApprovedQuotes != null){
           
            SQRecIdSet.addAll(AutoApprovedQuotes);
        }
        System.debug('TO Be auto Approved quotes++++++++++++'+ AutoApprovedQuotes );
        if(SQRecIdSet != null)
            SQListToBeUpdated = [select Id,CA_Approval_Id__c,Pricing_Status__c,Oubound_Status__c,CA_DDR_Name__c,CA_CPQ_Quote_Number__c,Last_Updated_from_SFDC__c,Auto_Approved__c from scpq__SciQuote__c where Id IN: SQRecIdSet];
           
        System.debug('SQListToBeUpdated ++++++++++++'+ SQListToBeUpdated );
        for(scpq__SciQuote__c sq:SQListToBeUpdated){  
            if(RecAndApprovalIdmap != null && RecAndApprovalIdmap.containsKey(sq.Id)){
                sq.CA_Approval_Id__c = RecAndApprovalIdmap.get(sq.Id);
                sq.Oubound_Status__c = PENDING_PRICING_APPROVAL; 
                sq.Last_Updated_from_SFDC__c = true; 
                    System.debug('Pending Pricing Approval++++++++++++');
            }
            if(AutoApprovedQuotes != null && AutoApprovedQuotes.contains(sq.Id)){
                sq.Oubound_Status__c = 'Approved';
                sq.Last_Updated_from_SFDC__c = true;
                sq.Auto_Approved__c = true;
                System.debug('Auto Apporved++++++++++++');
            }
                  
           
        }
        
    
        SystemIdUtility.skipSterlingQuoteProcessor = true;
        update SQListToBeUpdated;
        //updating the status on cpq point to point
     if(!test.isRunningTest())
      System.enqueuejob(new  QuoteUpdateToLayer7callout(SQListToBeUpdated));
    
}

//-------------CODE END----------------------------


}