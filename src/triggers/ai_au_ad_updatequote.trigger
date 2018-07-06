trigger ai_au_ad_updatequote on QuoteLineItem (after delete, after insert, before update,after update, before delete, before insert) {
    
    System.debug('Inside ai_au_ad_updatequote----------------');
    Set<String> businessUnit1 = new Set<String>();
    Set<String> rtm1 = new Set<String>();
    Set<String> area1 = new Set<String>();
    Set<String> country1 = new Set<String>();
    Set<String> region1 = new Set<String>();
    Set<String> teritory1 = new Set<String>();
    
    
    Set<Id> oppIds = new Set<Id>();
    
    Set<Id> quoteIds = new Set<Id>();   
                                                           
    Map<Id,Quote_Approval_Rule_Matrix__c> id_rule_map = new Map<Id,Quote_Approval_Rule_Matrix__c>();
    
   
    
    if( Trigger.isBefore && !Trigger.isDelete ){
        for(QuoteLineItem qli: Trigger.new) {
             if( qli.totalPrice != null ){
                qli.Adjusted_Unit_Cost__c = qli.totalPrice/qli.Quantity;
                 System.debug('Test ends : ' + qli.Adjusted_Unit_Cost__c); 
             }
        }
    }
    if(  Trigger.isBefore && Trigger.isUpdate){
         for(QuoteLineItem qli: Trigger.new) {  
            if(qli.Is_Co_Term_LineItem__c == false ){
                qli.MSRP_Unit_Cost__c = qli.UnitPrice;
                qli.MSRP_total__c = qli.MSRP_Unit_Cost__c * qli.Quantity; 
            }
           
         } 
    }
      if(  Trigger.isBefore && Trigger.isInsert){
         for(QuoteLineItem qli: Trigger.new) {  
            if(qli.Is_Co_Term_LineItem__c == false ){
                qli.Avg_discount_value__c = qli.Discount_1__c;
                //qli.MSRP_total__c = qli.MSRP_Unit_Cost__c * qli.Quantity; 
            }
           
         } 
    }
    if(Trigger.isInsert || Trigger.isUpdate) {
        for(QuoteLineItem temp : Trigger.new) {
            quoteIds.add(temp.QuoteId);
        }
    } else if(Trigger.isDelete) {
        if( Trigger.isBefore){
            System.debug('entered in before delete');
            Set<Id> qliIds= new Set<Id>();
            for(QuoteLineItem temp : Trigger.old) {
             System.debug('entered in before delete loop');
                qliIds.add(temp.id);
            }
            List<Co_Term__c> cotermList1 = [select id from Co_Term__c where Quote_Line_Item__r.id in:qliIds ];
             System.debug('deleting...' + cotermList1);
            delete cotermList1;
        }
        for(QuoteLineItem temp : Trigger.old) {
            quoteIds.add(temp.QuoteId);
        }
    }
    
    
    List<Quote> quoteList = [Select OpportunityId, Approval_Status__c, status, TotalPrice,CoTermLineCount__c from Quote where Id IN :quoteIds];
    for(Quote temp : quoteList) {
        oppIds.add(temp.OpportunityId);
    }

     
    
    Map<Id,String> qid_CSU_map = new Map<Id,String>();
    Map<Id,List<QuoteLineItem>> quoteId_listLineItems_Map = new Map<Id,List<QuoteLineItem>>();
    List<QuoteLineItem> quoteLineItemsList = [Select QuoteId, UnitPrice, Quantity, Additional_Discount__c, Business_Unit__c, Discount_1__c from QuoteLineItem where QuoteId IN :quoteIds];
    
    List<QuoteLineItem> tempList = null;
    for(QuoteLineItem temp : quoteLineItemsList) {
        if(qid_CSU_map.get(temp.QuoteId) == null) {
            
            //added by vinay
            businessUnit1.add(temp.Business_Unit__c);
            qid_CSU_map.put(temp.QuoteId,temp.Business_Unit__c);
        }
        if(quoteId_listLineItems_Map.get(temp.QuoteId) != null) {
            quoteId_listLineItems_Map.get(temp.QuoteId).add(temp);
        } else {
            tempList = new List<QuoteLineItem>();
            tempList.add(temp);
            quoteId_listLineItems_Map.put(temp.QuoteId,tempList);
        }
    }
    
    Quote tempObj = null;
    for(Quote tempQuote : quoteList) {
        if(quoteId_listLineItems_Map.get(tempQuote.Id) != null)
            tempQuote.Weighted_Average_Additional_Discount__c = QuoteApprovalRulesUtility.getWeightedAverage(quoteId_listLineItems_Map.get(tempQuote.Id));
    }
    
    //List<QuoteLineItem> qLineItemsList = [Select ]
    List<Opportunity> oppsList = [Select Rpt_Region__c, Rpt_Area__c, Rpt_Territory_Country__c, Rpt_Country__c, Reseller__r.Alliance__c, Reseller__r.Solution_Provider__c, Reseller__r.Service_Provider__c, Reseller__r.Velocity_Seller__c, Reseller__r.GEO__c,
                                 Reseller__r.Sales_Area__c,Reseller__r.Country_Picklist__c, Reseller__r.Sales_Region__c, Reseller__r.Region_Country__c from Opportunity where Id IN :oppIds];
    Map<Id,Opportunity> id_opp_map = new Map<Id,Opportunity>();
    for(Opportunity temp : oppsList) {
        id_opp_map.put(temp.Id,temp);
    }
    
    Map<Id,Opportunity> qId_opp_map = new Map<Id,Opportunity>();
    
    for(Quote temp : quoteList) {
        Opportunity opp = id_opp_map.get(temp.OpportunityId);
        area1.add(opp.Rpt_Area__c); 
        country1.add(opp.Rpt_Country__c); 
        region1.add(opp.Rpt_Region__c); 
        teritory1.add(opp.Rpt_Territory_Country__c);
        
        qId_opp_map.put(temp.Id,id_opp_map.get(temp.OpportunityId));
    }
    
    //PRM5 - added order by Additional Discount From and Amount From . So that code picks the first rule with less additional discount.

    List<Quote_Approval_Rule_Matrix__c> approvalRulesList = [Select Name, q.Line_Manager_Approval_Required__c, q.Territory_Region__c,q.Territory_Country__c, q.Country__c, q.Area__c, q.RTM__c,q.SReviewer_1__c, q.SReviewer_2__c, q.Approver__c, 
                                                                    q.Product_Group__c, q.Amount_To__c, q.FReviewer_1__c, q.FReviewer_2__c,
                                                                    q.Amount_From__c, q.Additional_Discount_To__c, q.Additional_Discount_From__c,
                                                                    q.FReviewer_3__c, q.FReviewer_4__c, q.FReviewer_5__c 
                                                                    From Quote_Approval_Rule_Matrix__c q
                                                                    where Territory_Region__c IN :region1 AND
                                                                    Area__c IN :area1 AND
                                                                    Territory_Country__c IN :teritory1 AND
                                                                    Country__c IN : country1 order by q.Additional_Discount_From__c,q.Amount_From__c];
    
     for(Quote_Approval_Rule_Matrix__c temp : approvalRulesList) {
        id_rule_map.put(temp.Id,temp);
    }
       

    Boolean isCoTermQuote;
    isCoTermQuote = false;
    List<Quote> updateQuoteList = new List<Quote>();
  
    //PRM5 - used aggregate functions to check if the quote has just coterm line items or a mixture of quote and coterm line items.
    AggregateResult[] groupedResults  = [Select QuoteId,COUNT(ID) cotermcount from QuoteLineItem where QuoteId IN :quoteIds and Is_Co_Term_LineItem__c = true and Additional_Discount__c = 0 group by QuoteId];

    Map<Id,Integer> mapIsCotermCount = new Map<Id,Integer>();

    for (AggregateResult ar : groupedResults)  {
 
     mapIsCotermCount.put((Id)ar.get('QuoteId') , (Integer)ar.get('cotermcount'));

    }

    for(Quote tempQuote : quoteList) {
        if(quoteId_listLineItems_Map.get(tempQuote.Id) != null) {
            tempQuote.Weighted_Average_Additional_Discount__c = QuoteApprovalRulesUtility.getWeightedAverage(quoteId_listLineItems_Map.get(tempQuote.Id));
            tempQuote.Total_Price__c = QuoteApprovalRulesUtility.getTotalPrice(quoteId_listLineItems_Map.get(tempQuote.Id));
                       
          //PRM 5 - Setting a flag isCoTermQuote , if the quote has just coterm line items.             
          if(mapIsCotermCount!= null )
           if(mapIsCotermCount.get(tempQuote.Id) == quoteId_listLineItems_Map.get(tempQuote.Id).size())
             {
                isCoTermQuote = true;                
             }
        } else {
            tempQuote.Weighted_Average_Additional_Discount__c = 0;
            tempQuote.Total_Price__c = 0;
        }   
          
      
        //PRM 5 - isCoTermQuote  , a boolean field is added as an extra parameter

        Id ruleId = QuoteApprovalRulesUtility.isEligible(tempQuote,approvalRulesList,qid_CSU_map,qId_opp_map,isCoTermQuote);
        System.debug('SKG ruleId from Utility call - ' + ruleId);        

        if(tempQuote.Approval_Status__c == 'Approved' || tempQuote.status == 'Approved')
        {
            tempQuote.Approval_Status__c = 'Modified';
            tempQuote.status = 'Modified';
        }

        if(ruleId != null) {
            Quote_Approval_Rule_Matrix__c ruleObject = id_rule_map.get(ruleId);
            tempQuote.Is_Eligible_for_Approval__c = true;
            tempQuote.Line_Manager_Approval_Required__c = ruleObject.Line_Manager_Approval_Required__c;
            tempQuote.Sales_Approver__c = ruleObject.Approver__c;
            tempQuote.Sales_Reviewer1__c = ruleObject.SReviewer_1__c;
            tempQuote.Sales_Reviewer2__c = ruleObject.SReviewer_2__c;
            tempQuote.Finance_Reviewer1__c = ruleObject.FReviewer_1__c;
            tempQuote.Finance_Reviewer2__c = ruleObject.FReviewer_2__c;
            tempQuote.Finance_Reviewer3__c = ruleObject.FReviewer_3__c;
            tempQuote.Finance_Reviewer4__c = ruleObject.FReviewer_4__c;
            tempQuote.Finance_Reviewer5__c = ruleObject.FReviewer_5__c;
        } else {

            if(isCoTermQuote == true)                
               tempQuote.Is_Eligible_for_Approval__c = true;
            else
                tempQuote.Is_Eligible_for_Approval__c = false;
            tempQuote.Sales_Approver__c = null;
            tempQuote.Sales_Reviewer1__c = null;
            tempQuote.Sales_Reviewer2__c = null;
            tempQuote.Finance_Reviewer1__c = null;
            tempQuote.Finance_Reviewer2__c = null;
            tempQuote.Finance_Reviewer3__c = null;
            tempQuote.Finance_Reviewer4__c = null;
            tempQuote.Finance_Reviewer5__c = null;
        }
        updateQuoteList.add(tempQuote);
        System.debug('SKG Eligible at the end - ' + tempQuote.Is_Eligible_for_Approval__c);
    }
    
    if(updateQuoteList.size() > 0)
        update updateQuoteList;
        
}