public class BudgetUtil {

    /*
    * the max number of DMl operations allowed in one chunk
    */
    public static Integer SFDC_MAX_OPERATIONS = 200;
    
    /*
    * Updates the budgets in chunks of 200 at a time. this ensures limits are not exceeded
    * if number of budgets are more than allowed apex limits, it throws an exception.
    */
    
    //Sid: Addd for CR- 1446: list of the currency conversion table.
    public static List<CurrencyType> listOfCurrency = [Select c.IsoCode, c.IsActive, c.Id,c.ConversionRate From CurrencyType c];
    public static Map<String,Decimal> mapOfConvesion = new Map<String,Decimal>();
    
    public static void updateList(List<SFDC_Budget__c> budgetList) {
        System.debug(Limits.getLimitDMLRows());
        if (budgetList.size() + Limits.getDMLRows()
                            > Limits.getLimitDMLRows()) {
                
            throw new LimitException('Attempting to perform a DML operations on too many sobjects at a time. Please reduce the batch size.');
        
        }else{
            List<SFDC_Budget__c> tmp = new List<SFDC_Budget__c>();
            
            for (SFDC_Budget__c b : budgetList){
                tmp.add(b);
                if (tmp.size() == SFDC_MAX_OPERATIONS){
                    update tmp;
                    tmp.clear();
                }
            }
            if (tmp.size() > 0){
                update tmp;
                tmp.clear();
            }       
            budgetList.clear();
        }
                
    }

    /*
     * Creates and returns list of budget objects which has the updated amount and the last refresh time
     * for changes in Fund request
     */ 
    public static List<SFDC_Budget__c> getBudgetList(Set<Id> budgetSet) {
        List<SFDC_Budget__c> budgetList = new List<SFDC_Budget__c>();
        // if(firstRun){
            //Sid: Added for CR- 1446 to calculate budget based on local currency.     
            for (CurrencyType thisCurrency : listOfCurrency) {
                 mapOfConvesion.put(thisCurrency.IsoCode,thisCurrency.ConversionRate);
              } 
            
            List<SFDC_MDF__c> existingFundRequests = new List<SFDC_MDF__c>();
            for (List<SFDC_MDF__c> tmp : [Select Id,Status__c,CurrencyIsoCode,Total_Claim_Amount__c, CA_Share_inc_tax__c,
                Approved__c, Budget__c From SFDC_MDF__c Where Budget__c In :budgetSet And Status__c<>'Cancelled' 
                And Status__c<>'Expired' And Status__c<>'Rejected']){
                existingFundRequests.addAll(tmp);
            }
            
            List<SFDC_MDF_Claim__c> existingFundClaims = new List<SFDC_MDF_Claim__c>();
            for (List<SFDC_MDF_Claim__c> tmp : [Select Id,CurrencyIsoCode,CA_Reimbursement__c,Status__c,Budget__c, 
                Fund_Request_Status__c From SFDC_MDF_Claim__c Where Budget__c In :budgetSet And Status__c in ('Approved','Paid')])
            {
                existingFundClaims.addAll(tmp);
            }
    
            //recalculate amount
            Map<Id, SFDC_Budget__c> budgetMap = new Map<Id, SFDC_Budget__c>();
            Map<Id, SFDC_Budget__c> initBudgetMap = new Map<Id, SFDC_Budget__c>();
            // SFDC_Budget__c budget = new SFDC_Budget__c();
            for(Id budgetId: budgetset){
                SFDC_Budget__c budget = new SFDC_Budget__c(Id = budgetId, Approved_Requests__c = 0,Closed_Requests__c=0,
                      Approved_Claims__c = 0, Paid_Claims__c =0,Available_Budget2__c=0, Last_Refresh_Date__c = datetime.now());
                initBudgetMap.put(budgetId, budget);
            }
    
            for (SFDC_MDF__c fundRequest : existingFundRequests) {       
                /*Decimal amount = (fundRequest.CA_Share_inc_tax__c)/(mapOfConvesion.get(fundRequest.CurrencyIsoCode));
                Decimal amountClosed = (fundRequest.Total_Claim_Amount__c)/(mapOfConvesion.get(fundRequest.CurrencyIsoCode));*/
                Decimal amount = fundRequest.CA_Share_inc_tax__c;
                Decimal amountClosed = fundRequest.Total_Claim_Amount__c;
                if (amount != null) {
                    Id budgetId = fundRequest.Budget__c;
                    SFDC_Budget__c requestBudget = budgetMap.get(budgetId);
                    if (requestBudget == null) {
                        requestBudget = initBudgetMap.get(budgetId);
                        budgetMap.put(budgetId, requestBudget);
                        //once in map-remove from set
                        budgetSet.remove(budgetId); 
                    } 
                    if(fundRequest.Status__c=='Approved')
                        requestBudget.Approved_Requests__c += amount;
                    else if(fundRequest.Status__c=='Draft' || fundRequest.Status__c=='Submitted' || fundRequest.Status__c=='Recalled' ||
                            fundRequest.Status__c=='In Process' || fundRequest.Status__c=='Sent To Finance' || fundRequest.Status__c=='PO Clearance Obtained')
                        requestBudget.Available_Budget2__c += amount;
                    else if (fundRequest.Status__c=='Closed')
                        if(amountClosed != null)
                            requestBudget.Closed_Requests__c += amountClosed;
                    System.debug('budget-----------'+ requestBudget);
                    System.debug('+++++++++++++++++ CA_Share_inc_tax__c +++'+fundRequest.CA_Share_inc_tax__c);
                    System.debug('+++++++++++++++++ Available_Budget2__c +++'+requestBudget.Available_Budget2__c);
                }
            }
    
            for (SFDC_MDF_Claim__c fundClaim : existingFundClaims) {
                //Decimal amount = (fundClaim.CA_Reimbursement__c)/(mapOfConvesion.get(fundClaim.CurrencyIsoCode));
                Decimal amount = fundClaim.CA_Reimbursement__c;
                if (amount != null) {
                    Id budgetId = fundClaim.Budget__c;
                    SFDC_Budget__c claimBudget = budgetMap.get(budgetId);
                    if (claimBudget == null) {
                        claimBudget = initBudgetMap.get(budgetId);
                        budgetMap.put(budgetId, claimBudget);
                        //once in map-remove from set
                        budgetSet.remove(budgetId); 
                    }
                   if(fundClaim.Fund_Request_Status__c != 'Closed' && fundClaim.Status__c == 'Approved')
                            claimBudget.Approved_Claims__c += amount;
                   if(fundClaim.Status__c == 'Paid')
                            claimBudget.Paid_Claims__c += amount;             
                }
            }
    
    
            //now the ones still in the set have no FundRequest
            if (! budgetSet.isEmpty()) {
                for (Id budgetId : budgetSet) {
                    SFDC_Budget__c emptyBudget = initBudgetMap.get(budgetId);
                    budgetList.add(emptyBudget);
                    System.debug('Entering the loop2---------------'+ emptyBudget);
                }
            }
            if (! budgetMap.isEmpty()) {
                budgetList.addAll(budgetMap.values());
                
            }
        // }
        return budgetList;
    }
  
    /*  -- On API version change : removing this test class ---
    public static testMethod void BudgetUtil_test() {
    	Set<Id> budSet = new Set<Id>();
    	List<SFDC_Budget__c> budList = [Select Id from SFDC_Budget__c LIMIT 10];
    	for(SFDC_Budget__c temp : budList) {
    		budSet.add(temp.Id);
    	}
    	BudgetUtil.getBudgetList(budSet);
    	BudgetUtil.updateList(budList);
    }         
    */
/*
    
     * Creates and returns list of budget objects which has the updated amount and the last refresh time
     * for changes in Fund claim
     
    public static List<SFDC_Budget__c> getBudgetListForFundClaim(Set<Id> budgetSet) {
        
        //Sid: Added for CR- 1446: To create map for storing the multiple currency.        
        for (CurrencyType thisCurrency : listOfCurrency) {
             mapOfConvesion.put(thisCurrency.IsoCode,thisCurrency.ConversionRate);
        }
        
        List<SFDC_MDF_Claim__c> existingFundClaims = new List<SFDC_MDF_Claim__c>();
        //Changed Amount__c to CA_Reimbursement__c
        for (List<SFDC_MDF_Claim__c> tmp : [Select Id,CurrencyIsoCode,CA_Reimbursement__c, Budget__c From SFDC_MDF_Claim__c 
            Where Budget__c In :budgetSet And Approved__c = true])
        {
            existingFundClaims.addAll(tmp);
        }
        
        //recalculate amount
        Map<Id, SFDC_Budget__c> budgetMap = new Map<Id, SFDC_Budget__c>();
        for (SFDC_MDF_Claim__c fundClaim : existingFundClaims) {
            //Sid: Changed Amount__c to CA_Reimbursement__c
            //Sid: Changed Ammount calculartion formula to consider multiple currency.
            Decimal amount = (fundClaim.CA_Reimbursement__c)/(mapOfConvesion.get(fundClaim.CurrencyIsoCode));
            if (amount != null) {
                Id budgetId = fundClaim.Budget__c;
                SFDC_Budget__c budget = budgetMap.get(budgetId);
                if (budget == null) {
                    budget = new SFDC_Budget__c(Id = budgetId, Approved_Claims__c = 0, Last_Refresh_Date__c = datetime.now());
                    budgetMap.put(budgetId, budget);
                    //once in map-remove from set
                    budgetSet.remove(budgetId); 
                }
                budget.Approved_Claims__c += amount;
            }
        }
        //now the ones still in the set have no fundClaim
        List<SFDC_Budget__c> budgetList = new List<SFDC_Budget__c>();
        if (! budgetSet.isEmpty()) {
            for (Id budgetId : budgetSet) {
                SFDC_Budget__c budget = new SFDC_Budget__c(Id = budgetId, Approved_Claims__c = 0, Last_Refresh_Date__c = datetime.now());
                budgetList.add(budget);
            }
        }
        if (! budgetMap.isEmpty()) {
            budgetList.addAll(budgetMap.values());
        }
        return budgetList;  
    }  */
        
    public class LimitException extends Exception {} 
}