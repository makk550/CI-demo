trigger SterlingQuoteProcessor on scpq__SciQuote__c (before update,after update) 
{ 
if(userinfo.getuserid()=='00530000003rQuJ') return;
System.debug('Sterling Quote Trigger Process Started----------------------');
Static Integer MAX_APPROVERS_SIZE = 10;
if(trigger.isbefore){
    System.debug('++++++++++++In trigger..APAC+++++++++++++++');

    if(SystemIdUtility.skipSterlingQuoteProcessor)
        return;   
    Set<Id> quoteIdsToProcess = new Set<Id>();
    List<Deal_Desk_Review__c> ddrBucket = new List<Deal_Desk_Review__c>();
    List<String> namesOfDDRsToUpdate = new List<String>();
    List<Id> ddrIds = new List<Id>();
    Set<Id> approvedQuotes = new Set<Id>(); // This set will hold the IDs of newly approved quotes
    List<Quote_Approval_History__c> qahRecords = new List<Quote_Approval_History__c>();
    Map<Id,Set<Id>> ApproverIdsMap = new Map<Id,Set<Id>>();
    //This map holds the IDs of quotes which has to be auto-approved 
    Map<Id,boolean> AutoApprovalMap = new Map<Id,boolean>();
    //This map holds the IDs of quotes as keys and CPQ Quote Creator Ids as values 
    Map<Id,Id> SQIdAndCPQQuoteCreatorIdMap = new Map<Id,Id>();
    Map<String,Id> CPQQuoteCreatorNameAndSQIdMap = new Map<String,Id>();    
    Boolean precheckNotLightDDR=true;
    
    List<TAP_Rules__c> tapRulesList = new List<TAP_Rules__c>
                                    ([SELECT Id, Name, Discount_From__c, 
                                        Discount_To__c,
                                        Solution_Sales_Leader__c, 
                                         Net_Term__c, 
                                         License_Type__c, 
                                        Is_Auto_Approved__c, 
                                        TermFrom__c, 
                                        Deal_Size__c, 
                                        Medium_Touch_Acqusition_Indirect_Medi__c, 
                                        Quote_Base_Criteria__c, 
                                        Deal_Desk_Director_as_Approvers__c, 
                                        Include_Deal_Desk_Director_as_Approvers__c,
                                        Term_To__c, 
                                        Deal_Value_per_Annum_From__c, 
                                        Deal_Value_per_Annum_To__c, 
                                        Realization_From__c, 
                                        Realization_To__c, Region__c, Commissionable_Area__c, 
                                        Opp_Owner_s_Manager__c,
                                        Education_Discount_Threshold__c,Services_Discount_Threshold__c,
                                        Deal_Desk_Approver_SaaS__c,
                                        Bus_Transaction_Type__c,//Added As part of Education QQ
                                        Is_Legal_Approval__c,
                                        Is_SR_DD_Approval__c,
                                        Is_VP_CPM_Approval__c,
                                        Net_Term_Sr_DD_Approval__c,
                                        Royalty_Product__c,
                                        Source__c,Special_Metric__c,
                                        Approver_Level__c,L4_Approval__c,
                                        (select Id, Name, Approver__c, Type__c ,BU__c,Geo__c,Sales_Region__c
                                            from TAP_Approvers__r)
                                      FROM TAP_Rules__c ]);
                                      
         List<TAP_Approvers__c> DealDeskApprovers = [Select Id, Name,  Segment__c,
                                 Region__c, Approver__c, Area__c, Territory__c, Sub_Territory__c,//Added for Education QQ 
                                 Type__c, TAP_Rules__c FROM TAP_Approvers__c ];
                                                  
                   
                   
                   
                   
                                                

    Set<Id> SQIdSet = new Set<Id>();
    Set<Id> ProcessInstanceIdSet = new Set<Id>();
    for(scpq__SciQuote__c sQuote : Trigger.new)  
    {
        if(sQuote.L1_Approval__c==true&&Trigger.oldmap.get(sQuote.Id).L1_Approval__c==true)
        sQuote.L1_Approval__c=false;
         if(sQuote.L2_Approval__c==true&&Trigger.oldmap.get(sQuote.Id).L2_Approval__c==true)
        sQuote.L2_Approval__c=false;
         if(sQuote.L3_Approval__c==true&&Trigger.oldmap.get(sQuote.Id).L3_Approval__c==true)
        sQuote.L3_Approval__c=false;
         if(sQuote.L4_Approval__c==true&&Trigger.oldmap.get(sQuote.Id).L4_Approval__c==true)
        sQuote.L4_Approval__c=false;
         if(sQuote.L5_Approval__c==true&&Trigger.oldmap.get(sQuote.Id).L5_Approval__c==true)
        sQuote.L5_Approval__c=false;
        System.debug('+++D+++ ' + sQuote.CA_Total_Total_Disc_Off_List__c); 
        if(sQuote.CA_Approval_Id__c!=null && (sQuote.CA_Approval_Id__c).length()==18){
            ProcessInstanceIdSet.add(sQuote.CA_Approval_Id__c);
            SQIdSet.add(sQuote.Id);
        }    
        if(trigger.newMap.get(sQuote.Id).Created_User_Email__c != null){
            CPQQuoteCreatorNameAndSQIdMap.put(trigger.newMap.get(sQuote.Id).Created_User_Email__c,sQuote.Id);
        }
    } 
     List<User> usersList=new List<User>();
    if(CPQQuoteCreatorNameAndSQIdMap.size()>0)
       usersList = [select Id,UserName from user where UserName IN: CPQQuoteCreatorNameAndSQIdMap.keySet()];
    
    for(User u:userslist){
        if(CPQQuoteCreatorNameAndSQIdMap.containsKey(u.UserName)){
        //----Use this map to assign User Id to CPQ Quote Creator lookup field------------
            SQIdAndCPQQuoteCreatorIdMap.put(CPQQuoteCreatorNameAndSQIdMap.get(u.UserName),u.Id);
        }        
    }   
    
    Map<Id,String> SQIdAndCommentsMap = new Map<Id,String>();
   
    //----CODE TO POPULATE APPROVAL COMMENTS--------------------
    try{
        List<ProcessInstance> PIList;
        System.debug('+++++++++SQIdSet++++++++++'+SQIdSet);
        System.debug('+++++++++ProcessInstanceIdSet++++++++++'+ProcessInstanceIdSet);
        if(ProcessInstanceIdSet != null && SQIdSet != null && ProcessInstanceIdSet.size()>0 && SQIdSet.size()>0){
            PIList = [SELECT Id,TargetObjectId, (SELECT Id, StepStatus, Comments FROM Steps where Comments!=null) FROM ProcessInstance where ID IN: ProcessInstanceIdSet AND TargetObjectId IN: SQIdSet ORDER BY CreatedDate DESC];
        }
        
        System.debug('+++++++++++PIList++++++++++++'+PIList);
        if(PIList!=null && PIList.size()>0){
            for(ProcessInstance p:PIList){
                System.debug('+++++++p.Steps++++++'+p.Steps);
                for(ProcessInstanceStep s:p.Steps){
                    if(!SQIdAndCommentsMap.containsKey(p.TargetObjectId)){
                        SQIdAndCommentsMap.put(p.TargetObjectId,s.comments);
                    }else{
                        if(SQIdAndCommentsMap.get(p.TargetObjectId)!=null){
                            SQIdAndCommentsMap.put(p.TargetObjectId,SQIdAndCommentsMap.get(p.TargetObjectId)+';'+s.comments);
                        }
                    }
                }
                System.debug('+++++++SQIdAndCommentsMap++++++'+SQIdAndCommentsMap);
            }
        }
    }catch(Exception e){
    } 
    List<QuickQuoteAnalysisAutomation__c> quoteAnalysisList = new List<QuickQuoteAnalysisAutomation__c>();
  Map<Id,QuickQuoteAnalysisAutomation__c> quoteIdandAnalysisRecMap = new Map<Id,QuickQuoteAnalysisAutomation__c>();
    for(scpq__SciQuote__c sQuote : Trigger.new)
    {
      
        QuickQuoteAnalysisAutomation__c qqaa = new QuickQuoteAnalysisAutomation__c();
    
    System.debug('+++ status: ' + trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C + '-----> ' + sQuote.CA_CPQ_QUOTE_STATUS__C);
        System.debug('+++ OutboundStatus: ' + trigger.oldMap.get(sQuote.Id).Oubound_Status__c + '-----> ' + sQuote.Oubound_Status__c);
        
        if(SQIdAndCommentsMap.containsKey(sQuote.Id) && SQIdAndCommentsMap.get(sQuote.Id)!=null){
                sQuote.Approval_Comments__c = SQIdAndCommentsMap.get(sQuote.Id);
        }
    
    qqaa.QuoteCPQStatusNew__c = sQuote.CA_CPQ_QUOTE_STATUS__C;
    qqaa.QuoteCPQStatusOld__c = trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C;
    qqaa.QuoteCreatedDate__c = squote.CreatedDate;
    qqaa.QuoteID__c = sQuote.Id;
    qqaa.Renewal_Area__c = squote.CA_Commissionable_Area__c;
        qqaa.IsthisanAgileCentralTransaction__c = squote.Is_this_an_Agile_Central_Transaction__c;
        qqaa.Quote_Type__c = squote.CA_Quote_Type__c;
        qqaa.OpportunityID__c = squote.scpq__OpportunityId__c;
    qqaa.OpportunityNumber__c = squote.Opportunity_Number__c;
    qqaa.Transaction_Type__c = squote.CA_Direct_Indirect__c;
    qqaa.CPQ_Quote_Number__c = squote.CA_CPQ_Quote_Number__c;
        qqaa.Primary_Quote__c = squote.CA_Primary_Flag__c;
    qqaa.Using_Quick_Contract__c = squote.CA_Using_Quick_Contract__c;
        if((sQuote.CA_CPQ_QUOTE_STATUS__C!=trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C)&& trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C!=null
          && ((qqaa.Quote_Type__c=='Renewal' && qqaa.Renewal_Area__c!=null && qqaa.Renewal_Area__c=='Medium Touch Agile Central') ||
      ((qqaa.Quote_Type__c=='New Product' ||qqaa.Quote_Type__c=='Combined' ||qqaa.Quote_Type__c=='Services') && qqaa.IsthisanAgileCentralTransaction__c!=null
       && (qqaa.IsthisanAgileCentralTransaction__c=='Yes–Light DDR'||
          qqaa.IsthisanAgileCentralTransaction__c=='Yes-Standard DDR'||qqaa.IsthisanAgileCentralTransaction__c=='Yes-Standard QQ'||
      qqaa.IsthisanAgileCentralTransaction__c!='No')))){
            qqaa.ShouldInsertRecord__c = true;
      quoteIdandAnalysisRecMap.put(qqaa.QuoteID__c,qqaa);
        }
            

        if(sQuote.CA_CPQ_QUOTE_STATUS__C == 'Request Approval' && trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C == 'Draft'){
            system.debug('TestQuoterID:'+sQuote.Id);
            quoteIdsToProcess.add(sQuote.Id);
            sQuote.Quick_Quote_Qualified__c='';
            sQuote.Pricing_Status__c='';
           system.debug('===========quoteIdsToProcess========'+quoteIdsToProcess);
            if(SQIdAndCPQQuoteCreatorIdMap.containsKey(sQuote.Id))
                    sQuote.CPQ_Quote_Creator_Id__c= SQIdAndCPQQuoteCreatorIdMap.get(sQuote.id);
        }            
        else if(sQuote.CA_CPQ_QUOTE_STATUS__C == 'Approved' && trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C != 'Approved')
        {   
            
            
            approvedQuotes.add(sQuote.Id);
            qahRecords.add(autoCreateDDR.createQuoteApprovalHistory(sQuote));
            
        }
        
        else if(sQuote.CA_CPQ_QUOTE_STATUS__C == 'Draft' && trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C == 'Request Approval')
        {
           
            System.debug('+++++ In Request Approval to Draft Method +++++++++');
            //sQuote.CA_CPQ_Quote_Status__c = 'Request Approval';
        }
        else if(sQuote.CA_CPQ_QUOTE_STATUS__C == 'Draft' && trigger.oldMap.get(sQuote.Id).CA_CPQ_QUOTE_STATUS__C != 'Draft')
        {
            ApprovalByPass.updateRecallStatus(sQuote.Id);
        
            //quotesToUpdate.add(new scpq__SciQuote__c(Id=sQuote.Id, Auto_Approved__c=false));
            sQuote.Auto_Approved__c = false;
            //CLearing All Approval Flags
            sQuote.L1_Approval__c= false;
            sQuote.L1_Rejection__c = false;
            sQuote.L2_Approval__c = false;
            sQuote.L2_Rejection__c= false;
            sQuote.L3_Approval__c = false;
            sQuote.L3_Rejection__c = false;
            sQuote.L4_Approval__c=false;
            sQuote.L4_Rejection__c =false;
            sQuote.L5_Approval__c=false;
            sQuote.L5_Rejection__c =false;
            //----Clearing all the approvers when status equals DRAFT-----
            sQuote.CA_Approval_Id__c = NULL;
            sQuote.Approver1__c = null;
            sQuote.Approver2__c = null;
            sQuote.Approver3__c = null;
            sQuote.Approver4__c = null;
            sQuote.Approver5__c = null;
            sQuote.Approver6__c = null;
            sQuote.Approver7__c = null;
            sQuote.Approver8__c = null;
            sQuote.Approver9__c = null;
            sQuote.Approver10__c = null;
            
            sQuote.Oubound_Status__c  = null;    
            
            sQuote.Has_Pending_Approvers__c = false;   
            sQuote.Pending_Approver1__c = null;
            sQuote.Pending_Approver2__c = null;
            sQuote.Pending_Approver3__c = null;
            sQuote.Pending_Approver4__c = null;
            sQuote.Pending_Approver5__c = null;
            sQuote.Pending_Approver6__c = null;
            sQuote.Pending_Approver7__c = null;
            sQuote.Pending_Approver8__c = null;
            sQuote.Pending_Approver9__c = null;
            sQuote.Pending_Approver10__c = null;
            
            
        }
           }
         Map<Id, scpq__SciQuote__c> idToQuoteMap = new Map<Id, scpq__SciQuote__c>();
  if(quoteIdsToProcess.size()>0){
      idToQuoteMap = new Map<Id, scpq__SciQuote__c>
                                    ([SELECT Id,
                                             CA_Payment_Schedule__c,Is_this_an_Agile_Central_Transaction__c,Ramp_Bridge_Order__c,Ramp_Indicator__c,
                                             scpq__OpportunityId__r.Account.Segment__c,L4_Approval__c,L4_Approver__c,L4_Rejection__c,
                                             scpq__OpportunityId__r.Rpt_Area__c,
                                             scpq__OpportunityId__r.CloseDate,
                                             scpq__OpportunityId__r.StageName,
                                             scpq__OpportunityId__r.OwnerId,
                                             //scpq__OpportunityId__r.Ent_Comm_AccountId__c,
                                             scpq__OpportunityId__r.AccountId,
                                             scpq__OpportunityId__r.Opportunity_Number__c,
                                             scpq__OpportunityId__r.Amount,
                                             scpq__OpportunityId__r.CurrencyIsoCode,
                                             scpq__OpportunityId__r.Rpt_Territory_Country__c,
                                             scpq__OpportunityId__r.Type,
                                             scpq__OpportunityId__r.Opportunity_Type__c,
                                             scpq__OpportunityId__r.Rpt_Country__c,
                                             scpq__OpportunityId__r.Rpt_Region__c,
                                             scpq__OpportunityId__r.Source__c,
                                             scpq__OpportunityId__r.Deal_Approval_Status__c,
                                           CA_AC_Non_Renewal_data_only__c,
                                             (select Id,Name,
                                                 Business_Unit__c,Effective_Date__c,End_Date__c, 
                                                 Bus_Transaction_Type__c,
                                                 CA_Pricing_Group__c,
                                                 License_Type__c,
                                                 Quick_Quote__c,
                                                 AutoCalc_Stated_Renewal__c,        
                                                 Auth_Use_Model__c,
                                                 Total_Discount_off_Volume_GSA_Price__c,
                                                 Total_Disc_off_List__c,
                                                 Royalty_Product__c,//Added for Education QQ project
                                                 Payment_Method__c,
                                                 Delivery_Method__c,Ramp_Pricing__c,  
                                                 Product_Material__r.Name,
                                                 Stated_Renewal_Fee__c,Material_Status__c,
                                                 Total_Quantity__c,
                                                 Target_Disc_Percent__c,
                                                 Floor_Disc_Percent__c,
                                                 Sales_Mgmt_Approval_Percent__c,
                                                 Level_of_Approval_Required__c,
                                              	Product_Swap__c
                                              FROM Quote_Products_Reporting__r),
                                             (select CA_Total_Total_Disc_Off_List__c,
                                                 CA_Total_Total_Disc_Off_Vol_GSA_Price__c,
                                                 CA_Effective_Date__c,
                                                 CA_Contract_End_Date__c,
                                                 Approval_Date__c,
                                                 CA_Total_List_License_Subs_Fee__c,
                                                 CA_Total_List_Maintenance_Price__c
                                              FROM Quote_Approval_Histories__r)
                                      FROM scpq__SciQuote__c 
                                      WHERE Id IN :quoteIdsToProcess]);
    }
      Map<String, Decimal> isoCodeToConversionRate = new Map<String, Decimal>();
    for(CurrencyType ct : [SELECT IsoCode, ConversionRate FROM CurrencyType])
        isoCodeToConversionRate.put(ct.IsoCode, ct.ConversionRate);
    
    DDR_Rules__c ddrRules = [SELECT New_Product_Using_Quick_Contract_Rule__c,Agile_RenewalPricing_Group_and_Term_Rule__c,Renewal_Pricing_Group__c,
                                    New_Product_Account_Segment_Rule__c, New_Product_Account_Segment__c,RenewalGroup_Term_in_months_is_less_than__c,
                                    New_Product_CPQ_Quote_Type_Rule__c, New_Product_CPQ_Quote_Type__c,
                                    New_Product_LA_Quote_Total_Rule__c, New_Product_Max_Quote_Total_For_LA__c,
                                    New_Product_EMEA_Quote_Total_Rule__c, New_Product_Max_Quote_Total_For_EMEA__c,
                                    New_Product_NA_Quote_Total_Rule__c, New_Product_Max_Quote_Total_For_NA__c,
                                    New_Product_Pricing_Group_Term_Rule__c, New_Product_Pricing_Group__c, New_Product_Pricing_Group_Term__c,
                                    New_Product_Term_Rule__c, New_Product_Maximum_Contract_Term__c,
                                    New_Product_Net_Payment_Term_Rule__c, New_Product_Net_Payment_Terms__c,
                                    New_Product_Payment_Schedule_Rule__c, New_Product_Payment_Schedule__c,
                                    New_Product_LT_Combo_Rule_1__c, New_Product_LT1_for_LT_Combo_1__c, New_Product_LT2_for_LT_Combo_1__c, New_Product_BTT_for_LT_Combo_1__c,
                                    New_Product_LT_Combo_Rule_2__c, New_Product_LT1_for_LT_Combo_2__c, New_Product_LT2_for_LT_Combo_2__c, New_Product_BTT_for_LT_Combo_2__c,
                                    New_Product_LT_Combo_Rule_3__c, New_Product_LT1_for_LT_Combo_3__c, New_Product_LT2_for_LT_Combo_3__c, New_Product_BTT_for_LT_Combo_3__c,
                                    New_Product_BTT_for_LT_Combo_4__c,New_Product_LT1_for_LT_Combo_4__c,New_Product_LT2_for_LT_Combo_4__c,New_Product_LT_Combo_Rule_4__c,
                                    New_Product_PS_and_LT_Rule__c, New_Product_PS_for_PS_and_LT__c, New_Product_LT_for_PS_and_LT__c, New_Product_BTT_for_PS_and_LT__c,
                                    New_Product_PS_and_LT_2_Rule__c, New_Product_PS_for_PS_and_LT_2__c, New_Product_LT_for_PS_and_LT_2__c, New_Product_BTT_for_PS_and_LT_2__c,
                                    New_Product_Quick_Quote_Line_Item_Rule__c,EMEA_Agile_Quote_Rule__c,
                                    New_Product_Auto_Calc_State_Renewal_Rule__c, New_Product_ACSR_LT_Exceptions__c, New_Product_ACSR_BTT_Exceptions__c,
                                    NA1_Quote_Total_Per_Annum_Rule__c,NA_Quote_Total_per_annum_is_greater_than__c,
                                    Agile_NP_Pricing_Group_Term_Rule__c,PGroup_Term_in_months_is_less_than__c,Agile_NP__c,AgileNP__c,
                                    AgileContract_Term_Rule__c,AgileContract_Term_In_Years_greater_than__c,
                                    Agile_New_product_term_12__c,Agile_New_product_term_24__c,Agile_New_product_term_36__c,
                                    Agile_Payment_Schedule_Rule__c,Agile1_Payment_Schedule_is__c,Agile_Payment_Schedule_is__c,
                                    New_Product_Auth_Use_Model_Rule__c, New_Product_Auth_Use_Model__c,
                                    Agile_Renewal_TERM_12__c,Agile_Renewal_TERM_24__c,Agile_Renewal_Term_36__c,
                                    Renewal_Using_Quick_Contract_Rule__c,LA_Agile_Quote_Rules__c,APJ_Agile_Quote_Rule__c,
                                    Renewal_LA_Quote_Total_Annum_Rule__c, Renewal_Max_Quote_Total_Annum_For_LA__c,
                                    Renewal_EMEA_Quote_Total_Annum_Rule__c, Renewal_Max_Quote_Total_Annum_For_EMEA__c,
                                    Renewal_NA_Quote_Total_Annum_Rule__c, Renewal_Max_Quote_Total_Annum_For_NA__c,
                                    Renewal_Term_Rule__c, Renewal_Maximum_Contract_Term__c,
                                    Renewal_Net_Payment_Term_Rule__c, Renewal_Net_Payment_Terms__c,
                                    Renewal_Business_Transaction_Type_Rule__c, Renewal_Business_Transaction_Type__c,
                                    Renewal2_Using_Quick_Contract_Rule__c,
                                    Renewal2_LA_Quote_Total_Annum_Rule__c, Renewal2_Max_Quote_Total_Annum_For_LA__c,
                                    Renewal2_EMEA_Quote_Total_Annum_Rule__c, Renewal2_Max_Quote_Total_Annum_For_EMEA__c,
                                    Renewal2_NA_Quote_Total_Annum_Rule__c, Renewal2_Max_Quote_Total_Annum_For_NA__c,
                                    Renewal2_Term_Rule__c, Renewal2_Maximum_Contract_Term__c,
                                    Renewal2_Net_Payment_Term_Rule__c, Renewal2_Net_Payment_Terms__c,
                                    Renewal2_Business_Transaction_Type_Rule__c, Renewal2_Business_Transaction_Type__c,
                                    Renewal3_Using_Quick_Contract_Rule__c,
                                    Renewal3_Business_Transaction_Type_Rule__c, Renewal3_Business_Transaction_Type__c,
                                    Renewal3_Net_Payment_Term_Rule__c, Renewal3_Net_Payment_Terms__c,Renewal5_Business_Transaction_Type__c,
                                    Renewal4_Using_Quick_Contract_Rule__c,
                                    Renewal_Term_GT_36_Rule__c,//Added for Education QQ  
                                    Renewal_Term_GT_36__c,                                  
                                    Renewal_QuoteTotal_Annum_GT300K_NA_Rule__c,
                                    Renewal_Quote_Total_Annum_GT_300K_NA__c,
                                    New_Product_CA_Education_Combo_Rule__c,
                                    New_Product_CAEducation_With_PM_Rule__c,
                                    New_Product_CAEducation_PMethod_With_PM__c,
                                    CA_Education_Public_Sector_Rule__c,
                                    CA_Education_Pricing_Group__c,
                                    CA_Education_Bus_Trans_Type__c,
                                    Renewal4_Business_Transaction_Type__c,
                                    NON_CA_Education_Bus_Trans_Types__c,
                                    Renewal_APJ_Quote_Total_Annum_Rule__c, //Added for APAC
                                    Renewal2_APJ_Quote_Total_Annum_Rule__c,
                                    Renewal_Max_Quote_Total_Annum_For_APJ__c,
                                    Renewal2_Max_Quote_Total_Annum_For_APJ__c,
                                    New_Product_Morethan_1_SKUs__c,New_Product_Quote_Term__c,
                                    New_Product_Quote_Term2__c,New_Product_Quote_Type__c,
                                    New_Product_Stated_Renewal_Fee__c,New_Product_Stated_Renewal_Fee_Input__c,
                                    New_Product_Term_Input1__c,New_Product_Term_Input2__c,
                                    New_Product_Net_Term_Input__c,New_Product_Net_Payment_Term__c,
                                    New_Product_Number_of_Users__c,New_Product_UserCount_Input__c,
                                    New_Product_Payment_Schedule_Input_1__c,New_Product_Payment_Schedule_Input_2__c,
                                    New_Product_Payment_Schedule_Input_3__c,New_Product_License_Type_Input_1__c,
                                    New_Product_License_Type_Input_2__c,New_Product_License_Type_Input_3__c,
                                    New_Product_Payment_Schedule_1__c,New_Product_Payment_Schedule_2__c,
                                    New_Product_Payment_Schedule_3__c ,
                                    Renewal3_NA_Qcuote_Total_Annum_Rule__c ,
                                    Renewal3_Max_Quote_Total_Annum_For_NA__c ,
                                    Renewal3_EMEA_Rule__c ,
                                    Renewal3_LA_Rule__c ,
                                    Renewal3_APJ_Rule__c ,
                                    Renewal3_Term_Rule__c ,
                                    Renewal3_Maximum_Contract_Term__c ,
                                    Renewal4_Term_Rule__c ,
                                    Renewal4_Maximum_Contract_Term__c,
                                    New_Product_IndirectAdvantageSKUs__c,
                             		Renewal_Product_Swap_Rule__c,
                             		NewProduct_Product_Swap_Rule__c,
                             		PSCAN_Quote_Total_Rule__c,
                             		Renewal_Max_Quote_Total_Annum_For_PSCAN__c,
                             		Renewal_PSCAN_Quote_Total_Annum_Rule__c,
                             		New_Product_Max_Quote_Total_For_PSCAN__c,
                                    Ramp_Bridge_Order__c,Agile_NP_PG_Bus_Trans_and_Term_12_Rule__c,
                                 Agile_New_Product_Term_Less_Than_12__c,Agile_NP_PG_Not_SaaS__c,Agile_New_Product_term_rule_months__c,
                                 Agile_NP_Bus_Trans_Not_Dist_Capc__c,Agile_NP_Bus_Tran_Not_12_24_36__c,
                                 Agile_NP_Pricing_Not_12_24_36__c,Renewal_Bus_Trans_When_Not_12_24_36__c,
                                 Renewal_Ramp_Indicator_Rule__c,Agile_Renewal_Term_rule_3_years__c,Renewal_Agile_Quick_Contract__c                           
                             FROM DDR_Rules__c 
                             LIMIT 1];
                                      
    //List<scpq__SciQuote__c> quotesToUpdate = new List<scpq__SciQuote__c>();
    //List<Approval.Processsubmitrequest> submitRequests = new List<Approval.Processsubmitrequest>();
    System.debug('+++++++idToQuoteMap+++++++'+idToQuoteMap.values());
  
  
    for(scpq__SciQuote__c q : idToQuoteMap.values())
    {
     System.debug('===========AutoApproved======================');
        System.debug('==================q.Quote_Approval_Histories__r============='+q.Quote_Approval_Histories__r);
      
        
            boolean preCheckBreak = true;
            boolean autoApproveQuote = false;
            boolean preCheck = false;
        scpq__SciQuote__c sQt = Trigger.newMap.get(q.id);

        if(!q.Quote_Approval_Histories__r.isEmpty()){
            preCheck=AutoCreateDDR.preDDRCheck(sQt,idToQuoteMap.get(sQt.id));
       if(sQt.CA_Quote_Type__c=='New Product'||sQt.CA_Quote_Type__c=='Combined'){
            System.debug('=========Check New product Or Combined=======');
           if(preCheck){
                If(sQt.CA_DDR_Name__c==''||sQt.CA_DDR_Name__c==null){
                      ddrBucket.add(AutoCreateDDR.createDDR(sQt, idToQuoteMap.get(sQt.id)));
                }else{
                    system.debug('%%%%%'+sQt.CA_DDR_Name__c);
                      precheckNotLightDDR=false;
                    namesOfDDRsToUpdate.add(sQt.CA_DDR_Name__c);
                    sQt.Oubound_Status__c = 'Deal Desk';
                    sQt.Last_Updated_from_SFDC__c = true;
                  }
                  preCheckBreak=false;
               sQt.Quick_Quote_Qualified__c='No';
               quoteIdsToProcess.remove(q.Id);
                     
            }
         }
          
       autoApproveQuote = AutoCreateDDR.quoteShouldBeAutoApproved(Trigger.newMap.get(q.Id), q.Quote_Approval_Histories__r[0]);
        }
        boolean DDRisRequired = false;    
        if(autoApproveQuote == true&&preCheckBreak)
        {
            System.debug('===========AutoApproved======================');
            DDRisRequired = AutoCreateDDR.quoteRequiresDDR(sQt, idToQuoteMap.get(sQt.id), isoCodeToConversionRate, ddrRules);
            if(DDRisRequired){
                sQt.Quick_Quote_Qualified__c='No';
            }else if(!DDRisRequired){
               sQt.Quick_Quote_Qualified__c='yes';
 
            }
            
            // Add the quote to the list of quotes which will have a Quote_Approval_History record generated
            qahRecords.add(autoCreateDDR.createQuoteApprovalHistory(Trigger.newMap.get(q.Id)));
            
            // Add the ID of the quote to the list of newly approved quotes.
            // All quotes in this list will have there old history purged. 
            approvedQuotes.add(q.Id);
            

            
            scpq__SciQuote__c sQuote = Trigger.newMap.get(q.ID);
            sQuote.Auto_Approved__c = true;
            sQuote.Oubound_Status__c = 'Approved';
            sQuote.Last_Updated_from_SFDC__c = true;
            //qahRecords.add(autoCreateDDR.createQuoteApprovalHistory(sQuote));
            System.debug('===========sQuote======================'+sQuote);

            /*
            Approval.Processsubmitrequest sReq = new Approval.Processsubmitrequest();
            sReq.setObjectId(q.Id);
            sReq.setComments('System Auto Approval: Submit');
            submitRequests.add(sReq);
            */
            quoteIdsToProcess.remove(q.Id);
            
        }
    
    QuickQuoteAnalysisAutomation__c qqaa = new QuickQuoteAnalysisAutomation__c();
    if(quoteIdandAnalysisRecMap.containsKey(q.id)){
      qqaa = quoteIdandAnalysisRecMap.get(q.id);
      
      if(preCheckBreak==false){
        qqaa = AutoCreateDDR.quoteAnalysispreDDRCheck(sQt,idToQuoteMap.get(sQt.id), qqaa);
        qqaa.QuoteRequiresDDR__c = true;
        qqaa.QuotePreCheckRule__c = preCheck;
      }
      if(preCheckBreak==true && autoApproveQuote == true){
        qqaa.QuoteAutoApproveFlag__c = autoApproveQuote;
      }

      qqaa.Quick_Quote_Qualified_Flag__c = sQt.Quick_Quote_Qualified__c;
	  if(preCheckBreak==true && DDRisRequired==false){
		  qqaa.Using_Quick_Contract_Final__c = true;
	  }
	  else{
		  qqaa.Using_Quick_Contract_Final__c = false;
	  }
      
            
      quoteIdandAnalysisRecMap.put(q.id,qqaa);
    }
      
    
    }
    
  
    System.debug('==================DDr Rules========'+ddrRules);
    List<Deal_Desk_Review__c> lightTouchDDrBucket = new List<Deal_Desk_Review__c>();
     Set<Id> ApproverIds;
     Map<id,set<id>> l1approvermap=new Map<id,set<id>>();
     Map<id,set<id>> l3approvermap=new Map<id,set<id>>();
     Map<id,set<id>> l4approvermap=new Map<id,set<id>>();
     Map<id,set<id>> l5approvermap=new Map<id,set<id>>();
     map<id,set<id>> DDRapprovermap=new Map<id,set<id>>();
     Map<id,string> buLevelApprover=new Map<id,String>();
    System.debug('++++quoteIdsToProcess:'+ quoteIdsToProcess);
    list<TAP_Approver__c> tapapproverslist=new list<TAP_Approver__c>();
    //Quick Quote added by pmf key patsa27
    for(Tap_rules__c tr:tapRulesList)       
    {
        for(TAP_Approver__c user:tr.TAP_Approvers__r)
        {
             tapapproverslist.add(user);
        }
    }
  /*
   * from here start the process for Quote ID
   */ 
    for(Id sQuoteId : quoteIdsToProcess)
    {
        Boolean checkForNew=false;
        scpq__SciQuote__c sQuote = Trigger.newMap.get(sQuoteId);
        boolean DDRisRequired = AutoCreateDDR.quoteRequiresDDR(sQuote, idToQuoteMap.get(sQuoteId), isoCodeToConversionRate, ddrRules);
        System.debug('===DDRisRequired==='+DDRisRequired);
        system.debug('AutocreateDDR'+DDRisRequired);
         Deal_Desk_Review__c lightddr =AutoCreateDDR.createDDR(sQuote, idToQuoteMap.get(sQuoteId));
            lightddr.Light_Touch__c=true;
        boolean preCheck=AutoCreateDDR.preDDRCheck(sQuote,idToQuoteMap.get(sQuoteId));
        boolean renewalQuoteCheck=true;
    QuickQuoteAnalysisAutomation__c qqaa = new QuickQuoteAnalysisAutomation__c();
    if(quoteIdandAnalysisRecMap.containsKey(sQuoteId)){
      qqaa=quoteIdandAnalysisRecMap.get(sQuoteId);
      qqaa.TAP_Approver_ID__c = '';
      qqaa.TAP_Rule_ID__c='';
    }
        /*
          1. Pre-check for new product or combined product.
          2.if not meet pre-check create DDR for combined Quotes.
         */      
        if(sQuote.CA_Quote_Type__c=='New Product'||sQuote.CA_Quote_Type__c=='Combined'){
            System.debug('=========Check New product Or Combined=======');
              if(preCheck){
                If(sQuote.CA_DDR_Name__c==''||sQuote.CA_DDR_Name__c==null){
                      ddrBucket.add(AutoCreateDDR.createDDR(sQuote, idToQuoteMap.get(sQuoteId)));
                }else{
                    system.debug('%%%%%'+sQuote.CA_DDR_Name__c);
                        precheckNotLightDDR=false;
                    namesOfDDRsToUpdate.add(sQuote.CA_DDR_Name__c);
                    sQuote.Oubound_Status__c = 'Deal Desk';
                    sQuote.Last_Updated_from_SFDC__c = true;
                  }
                  sQuote.Quick_Quote_Qualified__c='No';
                                   
            }else{
            if(sQuote.CA_Quote_Type__c=='Combined'){ 
               If(sQuote.CA_DDR_Name__c==''||sQuote.CA_DDR_Name__c==null){
                     ddrBucket.add(AutoCreateDDR.createDDR(sQuote, idToQuoteMap.get(sQuoteId)));
                }else{
                        system.debug('%%%%%'+sQuote.CA_DDR_Name__c);
                        precheckNotLightDDR=false;
                        namesOfDDRsToUpdate.add(sQuote.CA_DDR_Name__c);
                        sQuote.Oubound_Status__c = 'Deal Desk';
                        sQuote.Last_Updated_from_SFDC__c = true;
                   }
                sQuote.Quick_Quote_Qualified__c='No';
                }
                checkForNew=true;
            }
               
               
            }
        /*
         * Check DDR for Renewal and Services.if DDR meet create DDR.
         * For renewal if DDR is create and then break it here.won't move for TAP process
         */
        if(DDRisRequired){
            if(sQuote.CA_Quote_Type__c=='Renewal'){
                      sQuote.Quick_Quote_Qualified__c='No';
                If(sQuote.CA_DDR_Name__c==''||sQuote.CA_DDR_Name__c==null){
                     ddrBucket.add(AutoCreateDDR.createDDR(sQuote, idToQuoteMap.get(sQuoteId)));
                }else{
                    system.debug('%%%%%'+sQuote.CA_DDR_Name__c);
                      precheckNotLightDDR=false;
                    namesOfDDRsToUpdate.add(sQuote.CA_DDR_Name__c);
                    sQuote.Oubound_Status__c = 'Deal Desk';
                    sQuote.Last_Updated_from_SFDC__c = true;
                }
               renewalQuoteCheck=false;  
            }else if(sQuote.CA_Quote_Type__c=='Services'){
               If(sQuote.CA_DDR_Name__c==''||sQuote.CA_DDR_Name__c==null){
                     ddrBucket.add(AutoCreateDDR.createDDR(sQuote, idToQuoteMap.get(sQuoteId)));
                }else{
                    system.debug('%%%%%'+sQuote.CA_DDR_Name__c);
                      precheckNotLightDDR=false;
                    namesOfDDRsToUpdate.add(sQuote.CA_DDR_Name__c);
                    sQuote.Oubound_Status__c = 'Deal Desk';
                    sQuote.Last_Updated_from_SFDC__c = true;
                }  
                sQuote.Quick_Quote_Qualified__c='No';
            }
        }
        
          
        /*
         * From here its process the Tap process and stamp the Quick Quote flag
         * 
         */
        if((sQuote.CA_Quote_Type__c=='New Product'&&checkForNew)||(sQuote.CA_Quote_Type__c=='Renewal'&&renewalQuoteCheck)||sQuote.CA_Quote_Type__c=='Direct Registration'){
                System.debug('======Check QuoteType its New Or Renewal======= ');
              // Clear DDR Name
                  //sQuote.CA_DDR_Name__c = NULL;

            if(DDRisRequired==false){
                System.debug('====DDR is Not Required====');
                    sQuote.Quick_Quote_Qualified__c='yes';
            }else if(DDRisRequired==true){
              System.debug('======DDR is Required====');
                sQuote.Quick_Quote_Qualified__c='No'; 
            }
          
            //quotesToUpdate.add(new scpq__SciQuote__c(Id=sQuoteId, CA_DDR_Name__c=NULL));
            //Clearing Approval ID field before processing TAP Rules
        
            // TAP process goes here
            System.debug('++++++++TAP Rules process started++++++++++++');
                        
            TAPRulesUtility TRU = new TAPRulesUtility();
            Map<string,set<Id>> levelAprroversMap=new Map<string,set<Id>>();//Added for Pricing Project By Yedra01
            levelAprroversMap = TRU.ValidateTAPRules(sQuote,idToQuoteMap.get(sQuoteId).Quote_Products_Reporting__r,tapRulesList,DealDeskApprovers,isoCodeToConversionRate,idToQuoteMap.get(sQuoteId).scpq__OpportunityId__r);
            System.debug('++++Map of Approvers++++:'+levelAprroversMap);
            //Added for Pricing Project By Yedra01            
            if(levelAprroversMap.size()>0&&!levelAprroversMap.keyset().contains('Auto')){ 
                System.debug('=================levelAprroversMap.keyset().contain=================='+levelAprroversMap.keyset().contains('Auto'));
            if(levelAprroversMap.get('BU Users')!=null)
            {
                System.debug('===================levelAprroversMap.get==============='+levelAprroversMap.get('BU Users'));
                string buapprovers='';
                System.debug('==============Enter the approver============'+tapapproverslist);
                for(TAP_Approver__c user:tapapproverslist)
                {
                    if(levelAprroversMap.get('BU Users').contains(user.id)){
            buapprovers+=user.Approver__c+'@@@'+user.BU__c+';';
            qqaa.TAP_Approver_ID__c+=String.valueOf(user.Approver__c)  + ';';
          }
                        
          
                        
                }
                 
                if(buapprovers!='')             
                buLevelApprover.put(sQuoteId,buapprovers);
            }
            if(levelAprroversMap.get('unanimous')!=null)
            ApproverIds =levelAprroversMap.get('unanimous');
            if(levelAprroversMap.get('L2')!=null)
            ApproverIds =levelAprroversMap.get('L2');
            if(levelAprroversMap.keyset().contains('L1'))
            l1approvermap.put(sQuoteId,levelAprroversMap.get('L1'));
             if(levelAprroversMap.keyset().contains('L3'))
            l3approvermap.put(sQuoteId,levelAprroversMap.get('L3'));
            if(levelAprroversMap.keyset().contains('L4'))
            l4approvermap.put(sQuoteId,levelAprroversMap.get('L4'));
            if(levelAprroversMap.keyset().contains('L5'))
            l5approvermap.put(sQuoteId,levelAprroversMap.get('L5'));
            
            }
      
      if(levelAprroversMap.size()>0){
        qqaa.TAP_Rule_Block__c = true;
        
        Set<id> approveridset = new set<Id>();
          system.debug('---level approver map size----'+levelAprroversMap.size()+'-----map-------'+levelAprroversMap);
        for(String approverLevel:levelAprroversMap.keyset()){
          approveridset = levelAprroversMap.get(approverLevel);
          for(Id approverId:approveridset){
              if(!approverLevel.contains('BU Users'))
                  qqaa.TAP_Approver_ID__c += String.valueOf(approverId) + ';';
          }
        }
	if(TAPRulesUtility.TAP_RULE_ID_LIST.size()>0){
		for(string ruleId : TAPRulesUtility.TAP_RULE_ID_LIST){
		    qqaa.TAP_Rule_ID__c+=String.valueOf(ruleId) + ';';
			
		}
	  }
      }
            
         if(levelAprroversMap.keyset().contains('DDR'))
            DDRapprovermap.put(sQuoteId,levelAprroversMap.get('DDR'));
            //ended for Pricing Project By Yedra01
            if(ApproverIds != null && ApproverIds.size() > 0 && !ApproverIdsMap.containsKey(sQuoteId)&&!levelAprroversMap.keyset().contains('Auto'))
            {
                ApproverIdsMap.put(sQuoteId,ApproverIds);
                qqaa.QuoteAutoApproveFlag__c = true;
                System.debug('++++++++Approval Ids Added++++++++++++' + ApproverIds);              
            }
            else if(!levelAprroversMap.keyset().contains('DDR'))
            {
                if(TapRulesUtility.AutoRunDDR == true)
                {

                        if(sQuote.CA_DDR_Name__c == NULL || sQuote.CA_DDR_Name__c == '')
                        {
                            ddrBucket.add(autoCreateDDR.createDDR(sQuote, idToQuoteMap.get(sQuoteId)));
                                 
                        }
                        else
                        {
                            namesOfDDRsToUpdate.add(sQuote.CA_DDR_Name__c);
                            sQuote.Oubound_Status__c = 'Deal Desk';
                            sQuote.Last_Updated_from_SFDC__c = true;
                        }                   
                }
                else
                {
                    if(levelAprroversMap.size()>0&&levelAprroversMap.keyset().contains('Auto')&&!levelAprroversMap.keyset().contains('DDR')){ //added by potab02                     
						qqaa.QuoteAutoApproveFlag__c = true;
                        AutoApprovalMap.put(sQuoteId,true);
                        System.debug('++++++++Auto Approved Quote++++++++++++' + AutoApprovalMap);
                    }
                }
            }
          if(quoteIdandAnalysisRecMap.containsKey(sQuoteId)){
      quoteIdandAnalysisRecMap.put(sQuoteId,qqaa);
    }
        }
    

    if(quoteIdandAnalysisRecMap.containsKey(sQuoteId)){
      qqaa = quoteIdandAnalysisRecMap.get(sQuoteId);      
      qqaa.QuotePreCheckRule__c = preCheck;
      if(preCheck==true){
        qqaa = AutoCreateDDR.quoteAnalysispreDDRCheck(sQuote,idToQuoteMap.get(sQuoteId), qqaa);
      }
      if(preCheck==true||(preCheck==false&&DDRisRequired==true))
        qqaa.QuoteRequiresDDR__c = true;
      else
        qqaa.QuoteRequiresDDR__c = false;
      
      qqaa.Quick_Quote_Qualified_Flag__c = sQuote.Quick_Quote_Qualified__c;
	  
	  if(preCheck==false&&DDRisRequired==false)
		  qqaa.Using_Quick_Contract_Final__c = true;
	  else
		  qqaa.Using_Quick_Contract_Final__c = false;
	  
      if(preCheck==false&&DDRisRequired==true){
        qqaa = AutoCreateDDR.quoteAnalysisRequiresDDR(sQuote, idToQuoteMap.get(sQuoteId), isoCodeToConversionRate, ddrRules,qqaa);
      }
            qqaa.Quote_Outbound_Status__c = squote.Oubound_Status__c;
      quoteIdandAnalysisRecMap.put(sQuoteId,qqaa);
    }
            
        }
    System.debug('AutoApprovalMap================'+AutoApprovalMap);
    System.debug('==============ApproverIdsMap================'+ApproverIdsMap);
    if( (AutoApprovalMap != null && AutoApprovalMap.keySet().size() > 0) ||
        (ApproverIdsMap != null && ApproverIdsMap.keySet().size() > 0 ) ||
      (l1approvermap != null && l1approvermap.size()>0) ||(l4approvermap!=null&&l4approvermap.size()>0)||(l5approvermap!=null&&l5approvermap.size()>0)|| (l3approvermap !=null && l3approvermap.size()>0) ||(DDRapprovermap!=null && DDRapprovermap.size()>0)//added by potab02
      ){
        
            Map<Id,String> ApproverIdAndNameMap = new Map<Id,String>();
            
            if(ApproverIds!=null&&ApproverIds.size()>0){
                List<User> users= [select Id,Name from user where Id IN: ApproverIds];
                for(User u:users){
                    ApproverIdAndNameMap.put(u.Id,u.Name);
                }
            }
          System.debug('===========ApproverIdAndNameMap============'+ApproverIdAndNameMap);
            
            System.debug('+++++++ApproverIdsMap+++++'+ApproverIdsMap);
             Set<Id> SQRecIdSet = new Set<Id>();
            if((ApproverIdsMap != null && ApproverIdsMap.keySet().size()>0) ||(l4approvermap!=null&&l4approvermap.size()>0)||(l5approvermap!=null&&l5approvermap.size()>0)||
               (l1approvermap != null && l1approvermap.size()>0) || (l3approvermap !=null && l3approvermap.size()>0) ||(DDRapprovermap!=null && DDRapprovermap.size()>0)//added by potab02
              ){
               System.debug('===========enter into Approvals============'+l1approvermap);
                for(scpq__SciQuote__c s:Trigger.New){
                    
                    if(l1approvermap.size()>0&&l1approvermap.get(s.Id)!=null&&l1approvermap.get(s.Id).size()>0){
                        System.debug('===========Enter Into L1 Approver=========='+l1approvermap);
                    Id l1user=new List<Id> (l1approvermap.get(s.Id)).get(0);
                    s.L1_Approver__c=l1user;
                    SQRecIdSet.add(s.Id);
                    }
                    if(l3approvermap.size()>0&&l3approvermap.get(s.Id)!=null&&l3approvermap.get(s.Id).size()>0){
                        System.debug('==========l3approvermap==========='+l3approvermap);
                    list<Id> l3userList=new List<Id> (l3approvermap.get(s.Id));
                    if(l3userList.size()>0){
                    id l3user= l3userList[0];
                    s.L3_Approver__c=l3user;
                    }
                    }
                    //Quick Quote added by patsa27
                     if(l4approvermap.size()>0&&l4approvermap.get(s.Id)!=null&&l4approvermap.get(s.Id).size()>0){
                        System.debug('==========l3approvermap==========='+l4approvermap);
                    list<Id> l4userList=new List<Id> (l4approvermap.get(s.Id));
                    if(l4userList.size()>0){
                    id l4user= l4userList[0];
                    s.L4_Approver__c=l4user;
                     SQRecIdSet.add(s.Id);

                    }
                    }
                    //Quick Quote added by patsa27
                    if(l5approvermap.size()>0&&l5approvermap.get(s.Id)!=null&&l5approvermap.get(s.Id).size()>0){
                        System.debug('==========l3approvermap==========='+l5approvermap);
                    list<Id> l5userList=new List<Id> (l5approvermap.get(s.Id));
                    if(l5userList.size()>0){
                    id l5user= l5userList[0];
                    s.L5_Approver__c=l5user;
                     SQRecIdSet.add(s.Id);

                    }
                    }
                     if(DDRapprovermap.size()>0&&DDRapprovermap.get(s.Id)!=null&&DDRapprovermap.get(s.Id).size()>0){
                         System.debug('========DDRapprovermap============='+DDRapprovermap);
                    list<Id> l3userList=new List<Id> (DDRapprovermap.get(s.Id));
                    if(l3userList.size()>0){
                    id l3user= l3userList[0];
                    s.Deal_Desk_Approver__c=l3user;
                    SQRecIdSet.add(s.Id);
                    }
                    }
                    
                    if(buLevelApprover!=null&&buLevelApprover.get(s.Id)!=null)
                        System.debug('===========buLevelApprover============'+buLevelApprover);
                    s.BU_and_Users__c=buLevelApprover.get(s.Id);
                    if(ApproverIdsMap.containsKey(s.Id)){
                       
                        Integer i = 0;
                        Id anyOneApproverId;
                        s.Set_of_Approvers__c = ' ';
                        System.debug('++++++ApproverIdsMap.get(s.Id)+++++++'+ApproverIdsMap.get(s.Id));
                        for(Id ids:ApproverIdsMap.get(s.Id)){
                            System.debug('++++++++ids++++++'+ids);
                            
                            i++;
                            String str = 'Approver'+i+'__c';              
                            s.put(str,ids);            
                            anyOneApproverId = ids;
                            if(ApproverIdAndNameMap.containsKey(ids) && ApproverIdAndNameMap.get(ids)!=null){
                                if(s.Set_of_Approvers__c!=' '){
                                    s.Set_of_Approvers__c = s.Set_of_Approvers__c+' , '+ApproverIdAndNameMap.get(ids);
                                }else
                                    s.Set_of_Approvers__c = ApproverIdAndNameMap.get(ids);
                                
                            }
                            
                        }
                        
                        if(i<MAX_APPROVERS_SIZE){
                            for(Integer j=i+1;j<=MAX_APPROVERS_SIZE;j++){
                                String str = 'Approver'+j+'__c';              
                                s.put(str,anyOneApproverId);
                            }
                        }
                        SQRecIdSet.add(s.Id);
                    }
                    
                }
                
              }
        
         
      TAPRulesUtility.updateApproverId(SQRecIdSet,AutoApprovalMap.keySet()); 
       Integer numQuery=Limits.getQueries();
        System.debug('=======numQuery========='+numQuery);

    }
    set<Id> QuoteId=new Set<id>();
    for(scpq__SciQuote__c strQ:Trigger.new){
        if(strQ.CA_CPQ_QUOTE_STATUS__C=='Approved')
             QuoteId.add(strQ.id);   
    }
       Map<Id, scpq__SciQuote__c> valuesQuoteMap = new Map<Id, scpq__SciQuote__c>();
    if(QuoteId.size()>0){
       valuesQuoteMap = new Map<Id, scpq__SciQuote__c>
                                    ([SELECT Id,Pricing_Status__c,CA_DDR_Name__c,Quick_Quote_Qualified__c,Last_Updated_from_SFDC__c,
                                             CA_Payment_Schedule__c,Is_this_an_Agile_Central_Transaction__c,Ramp_Bridge_Order__c,Ramp_Indicator__c,
                                             scpq__OpportunityId__r.Account.Segment__c,L4_Approval__c,L4_Approver__c,L4_Rejection__c,Oubound_Status__c,
                                             scpq__OpportunityId__r.Rpt_Area__c,
                                             scpq__OpportunityId__r.CloseDate,
                                             scpq__OpportunityId__r.StageName,
                                             scpq__OpportunityId__r.OwnerId,
                                             //scpq__OpportunityId__r.Ent_Comm_AccountId__c,
                                             scpq__OpportunityId__r.AccountId,
                                             scpq__OpportunityId__r.Opportunity_Number__c,
                                             scpq__OpportunityId__r.Amount,
                                             scpq__OpportunityId__r.CurrencyIsoCode,
                                             scpq__OpportunityId__r.Rpt_Territory_Country__c,
                                             scpq__OpportunityId__r.Type,
                                             scpq__OpportunityId__r.Opportunity_Type__c,
                                             scpq__OpportunityId__r.Rpt_Country__c,
                                             scpq__OpportunityId__r.Rpt_Region__c,
                                             scpq__OpportunityId__r.Source__c,CA_AC_Non_Renewal_data_only__c,
                                             scpq__OpportunityId__r.Deal_Approval_Status__c from scpq__SciQuote__c where id=:QuoteId]);
    }
  for(scpq__SciQuote__c sqout :Trigger.new){
                   
        if(sqout.CA_CPQ_QUOTE_STATUS__C == 'Approved' && trigger.oldMap.get(sqout.Id).CA_CPQ_QUOTE_STATUS__C != 'Approved'){

                        sqout.Pricing_Status__c='Tap Approved';
                        Deal_Desk_Review__c delDesk=AutoCreateDDR.createDDR(sqout,valuesQuoteMap.get(sqout.id));
                        delDesk.Light_Touch__c=true;
                if(sqout.Pricing_Status__c=='Tap Approved'){
                      if(sqout.Is_this_an_Agile_Central_Transaction__c=='Yes - Light DDR'||sqout.Is_this_an_Agile_Central_Transaction__c.contains('Light DDR')){
                          if(sqout.CA_Quote_Type__c=='New Product'&&sqout.Quick_Quote_Qualified__c=='yes'){               
                              if(sqout.CA_DDR_Name__c == NULL || sqout.CA_DDR_Name__c == '')
                                {
                                    system.debug('%%%%');
                                   lightTouchDDrBucket.add(delDesk);
                                }else
                                 {
                                        system.debug('%%%%%'+sqout.CA_DDR_Name__c);
                                        namesOfDDRsToUpdate.add(sqout.CA_DDR_Name__c);
                                        sqout.Oubound_Status__c = 'Deal Desk';
                                        sqout.Last_Updated_from_SFDC__c = true;
                                  }
                          }else if((sqout.CA_Quote_Type__c=='New Product'&&sqout.Quick_Quote_Qualified__c=='No')||(sqout.CA_Quote_Type__c=='Renewal'&&sqout.Quick_Quote_Qualified__c=='No')){
                                 if(sqout.CA_DDR_Name__c == NULL || sqout.CA_DDR_Name__c == '')
                                 {
                                    system.debug('%%%%');
                                    ddrBucket.add(autoCreateDDR.createDDR(sqout, valuesQuoteMap.get(sqout.id)));
                               }else
                                 {
                                    system.debug('%%%%%'+sqout.CA_DDR_Name__c);
                                    namesOfDDRsToUpdate.add(sqout.CA_DDR_Name__c);
                                     precheckNotLightDDR=false;
                                    sqout.Oubound_Status__c = 'Deal Desk';
                                    sqout.Last_Updated_from_SFDC__c = true;
                                 }
                              
                          }else if((sqout.CA_Quote_Type__c=='Renewal'&&sqout.Quick_Quote_Qualified__c=='yes')||(sqout.CA_Quote_Type__c=='Direct Registration'&&sqout.Quick_Quote_Qualified__c=='yes')){
                                      sqout.Oubound_Status__c='Approved'; 
                              
                          }
                            
                              
                        }else if(!sqout.Is_this_an_Agile_Central_Transaction__c.contains('Light DDR')){
                            if(sqout.Quick_Quote_Qualified__c=='No'){        
                                if(sqout.CA_DDR_Name__c == NULL || sqout.CA_DDR_Name__c == '')
                                 {
                                    system.debug('%%%%');
                                    ddrBucket.add(autoCreateDDR.createDDR(sqout, valuesQuoteMap.get(sqout.id)));
                               }else
                                 {
                                    system.debug('%%%%%'+sqout.CA_DDR_Name__c);
                                    namesOfDDRsToUpdate.add(sqout.CA_DDR_Name__c);
                                    sqout.Oubound_Status__c = 'Deal Desk';
                                    sqout.Last_Updated_from_SFDC__c = true;
                                 }
                            }else if(sqout.Quick_Quote_Qualified__c=='yes'){
                                sqout.Oubound_Status__c='Approved';
                            }
                            
                        }
                        
                    }
                
                
            }else if(sqout.Oubound_Status__c == 'Rejected' && trigger.oldMap.get(sqout.Id).Oubound_Status__c != 'Rejected'){
                
                    sqout.Pricing_Status__c='Rejected';

               
            }
      
      
      QuickQuoteAnalysisAutomation__c qqaa = new QuickQuoteAnalysisAutomation__c();
      if(quoteIdandAnalysisRecMap.containsKey(sqout.id)){
        qqaa = quoteIdandAnalysisRecMap.get(sqout.id);      
        qqaa.Quick_Quote_Qualified_Flag__c = sqout.Quick_Quote_Qualified__c;
        qqaa.Quote_Outbound_Status__c = sqout.Oubound_Status__c;
        quoteIdandAnalysisRecMap.put(sqout.id,qqaa);
      }
            
        } 
   //end to optimize
   set<string> lightddrs=new set<string>();
    for(scpq__SciQuote__c soq:trigger.new){
         lightddrs.add(soq.Is_this_an_Agile_Central_Transaction__c);        
    }
    system.debug('=========namesOfDDRsToUpdate=====&&&'+namesOfDDRsToUpdate);
    List<Deal_Desk_Review__c> ddrUpdateBucket = new List<Deal_Desk_Review__c>();
  if(namesOfDDRsToUpdate!=null&&namesOfDDRsToUpdate.size()>0){
    for(Deal_Desk_Review__c ddr : [SELECT Id,Light_Touch__c,Deal_Desk_Status__c FROM Deal_Desk_Review__c WHERE Name IN :namesOfDDRsToUpdate])
    {
        system.debug('=====lightddrs===='+lightddrs);
     if(lightddrs!=null&&lightddrs.size()>0&&precheckNotLightDDR){
        if(lightddrs.contains('Yes - Light DDR')){
            ddr.Light_Touch__c=true;
        }else if(!lightddrs.contains('Yes - Light DDR')){
            ddr.Light_Touch__c=false;
        }
     }else{
        ddr.Light_Touch__c=false; 
     }
     ddr.Deal_Desk_Status__c = 'Updated – DD';
         
        //ddrBucket.add(ddr);
        ddrUpdateBucket.add(ddr);
    }
   }
    
    if(ddrUpdateBucket!=null&&ddrUpdateBucket.size()>0)
        update ddrUpdateBucket;
    
    //upsert ddrBucket;
    //List<Id> ddrIds = new List<Id>();
  if(ddrBucket.size()>0){
        for(Database.Saveresult sr : Database.insert(ddrBucket))
        {
            ddrIds.add(sr.getId());
        }
  }
  
  if(lightTouchDDrBucket.size()>0){
        for(Database.Saveresult sr : Database.insert(lightTouchDDrBucket))
        {
            ddrIds.add(sr.getId());
        }
  }
            System.debug('======looking into ddr =========');
  if(ddrIds!=null&&ddrIds.size()>0){
    for(Deal_Desk_Review__c ddr : [SELECT Name, Sterling_Quote__c FROM Deal_Desk_Review__c WHERE Id IN :ddrIds])
    {
        System.debug('======Enter into ddr =========');
        scpq__SciQuote__c sQuote = Trigger.newMap.get(ddr.Sterling_Quote__c);
        sQuote.CA_DDR_Name__c = ddr.Name;
        sQuote.Oubound_Status__c = 'Deal Desk';
        sQuote.Last_Updated_from_SFDC__c = true;
       System.debug('======Enter into ddr ========='+sQuote);

    }
  }  
    delete [select Id From Quote_Approval_History__c WHERE Sterling_Quote__c IN :approvedQuotes];
    insert qahRecords;  
    //update quotesToUpdate;
    for(QuickQuoteAnalysisAutomation__c qqaa:quoteIdandAnalysisRecMap.values()){
        if(qqaa.ShouldInsertRecord__c==true)
      quoteAnalysisList.add(qqaa);
  }
    
  if(quoteAnalysisList!=null && quoteAnalysisList.size()>0)
    insert quoteAnalysisList;
  
    }

         
     
    if(Trigger.isafter){
         set<id> reminderToSQuotes=new set<id>();
         set<id> useridset=new set<id>();
         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
         for(scpq__SciQuote__c sQuote : Trigger.new)
         {     
      //Send Reminders who is not Approved
        if(sQuote.Reminder_alert_temp__c!=null&&trigger.oldMap.get(sQuote.Id).Reminder_alert_temp__c!=sQuote.Reminder_alert_temp__c){
        if(sQuote.Reminder_alert_temp__c=='L1 For 2 days'||sQuote.Reminder_alert_temp__c=='L1 for 3 days')
        useridset.add(sQuote.l1_approver__c);
        if(sQuote.Reminder_alert_temp__c=='L3 Reminder')
        useridset.add(sQuote.l3_approver__c);
        if(sQuote.Reminder_alert_temp__c=='L2 Reminder')
        {
            if(sQuote.Approver1__c!= null)
               useridset.add(sQuote.Approver1__c);
            if(sQuote.Approver2__c!= null)
            useridset.add(sQuote.Approver2__c);
            if(sQuote.Approver3__c!= null)
            useridset.add(sQuote.Approver3__c);
            if(sQuote.Approver4__c!= null)
            useridset.add(sQuote.Approver4__c);
            if(sQuote.Approver5__c!= null)
            useridset.add(sQuote.Approver5__c);
            if(sQuote.Approver6__c!= null)
            useridset.add(sQuote.Approver6__c);
            if(sQuote.Approver7__c!= null)
            useridset.add(sQuote.Approver7__c);
            if(sQuote.Approver8__c!= null)
            useridset.add(sQuote.Approver8__c);
            if(sQuote.Approver9__c!= null)
            useridset.add(sQuote.Approver9__c);
            if(sQuote.Approver10__c!= null)
            useridset.add(sQuote.Approver10__c);
            
        }
        reminderToSQuotes.add(sQuote.Id);
        }
    }
   Map<id,ProcessInstance> pendingApproversList=new Map<id,ProcessInstance>();
   for(ProcessInstance p:[SELECT Id,targetobjectid,(SELECT Id,OriginalActorId,StepStatus, Comments FROM StepsAndWorkitems where StepStatus='Pending'  order By createddate desc)
   FROM ProcessInstance where targetobjectid in:reminderToSQuotes order By createddate desc]){
   if(pendingApproversList.get(p.targetobjectid)==null)
       pendingApproversList.put(p.targetobjectid,p);
   }
   
   if(pendingApproversList.size()>0)
   for(ProcessInstance p:pendingApproversList.values()){
    if(p.StepsAndWorkitems.size()>0){
        for(ProcessInstanceHistory SW:p.StepsAndWorkitems){
            if(useridset.contains(SW.OriginalActorId)){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(SW.OriginalActorId);
            mail.setTemplateId(Label.SQUoteLevelsTemplate);
            mail.setWhatId(p.targetobjectid);
            mail.setSaveAsActivity(false);
            mails.add(mail);
            }
        }
    }
 }
   if(mails.size()>0)
      Messaging.sendEmail(mails);
    
    }
    system.debug('----No of SOQL Queries----'+Limits.getQueries());
}