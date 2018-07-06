trigger QuoteEducationRequest on scpq__SciQuote__c (before update) 
{
if(userinfo.getuserid()=='00530000003rQuJAAU') return;
    List<Education_Request__c> EDU_Requests = new List<Education_Request__c>();
    Set<Id> approvedQuotes = new Set<Id>();
    Set<Id> reviewQuotes = new Set<Id>();
    
    for(scpq__SciQuote__c sq : Trigger.new)
    {
        if(Trigger.oldMap.get(sq.Id).CA_SAP_Status__c != sq.CA_SAP_Status__c && sq.CA_Quote_Type__c=='Direct Registration')
        {
            if(sq.CA_SAP_Status__c == 'In Review')
                reviewQuotes.add(sq.Id);
        
            if(sq.CA_SAP_Status__c == 'Approved')
                approvedQuotes.add(sq.Id);
        }
    }
              
    /*          
    List<Quote_Product_Report__c> newEduLines = [SELECT Id,
                                                  Sterling_Quote__c,
                                                  Product_Material__c,
                                                  Sterling_Quote__r.scpq__OpportunityId__c,
                                                  Sterling_Quote__r.scpq__OpportunityId__r.AccountId,
                                                  Sterling_Quote__r.scpq__OpportunityId__r.OwnerId
                                                  FROM Quote_Product_Report__c
                                                  WHERE Sterling_Quote__c IN :reviewQuotes
                                                      AND Id Not In (SELECT Quote_Product_Line_Item__c FROM Education_Request__c WHERE CPQ_Quote__c IN :reviewQuotes)  ];
    */
    
                                                      
    List<Quote_Product_Report__c> lines = [SELECT Id,
                                                  Sterling_Quote__c,
                                                  Product_Material__c,
                                                  Sterling_Quote__r.scpq__OpportunityId__c,
                                                  Sterling_Quote__r.scpq__OpportunityId__r.AccountId,
                                                  Sterling_Quote__r.scpq__OpportunityId__r.OwnerId,
                                                  (SELECT Education_Request_Status__c FROM Education_Requests__r)
                                                  FROM Quote_Product_Report__c
                                                  WHERE Sterling_Quote__c IN :reviewQuotes
                                                     OR Sterling_Quote__c IN :approvedQuotes ];                                                  
                                                 
                                                  
    for(Quote_Product_Report__c line : lines)
    {
        if(reviewQuotes.contains(line.Sterling_Quote__c) && line.Education_Requests__r.isEmpty())
        {
            Education_Request__c EDU_Request = new Education_Request__c(Transaction_Type__c = 'Direct Registration', Education_Request_Status__c='New');
            
            EDU_Request.Quote_Product_Line_Item__c = line.Id;
            EDU_Request.CPQ_Quote__c = line.Sterling_Quote__c;
            EDU_Request.Course_Code__c = line.Product_Material__c;
            EDU_Request.Opportunity_Name__c = line.Sterling_Quote__r.scpq__OpportunityId__c;
            EDU_Request.Account__c = line.Sterling_Quote__r.scpq__OpportunityId__r.AccountId;
            EDU_Request.Opportunity_Owner__c = line.Sterling_Quote__r.scpq__OpportunityId__r.OwnerId;
            
            EDU_Requests.add(EDU_Request);
        }
        
        if(approvedQuotes.contains(line.Sterling_Quote__c))
        {
            if(line.Education_Requests__r.isEmpty()) {
                Education_Request__c EDU_Request = new Education_Request__c(Transaction_Type__c = 'Direct Registration', Education_Request_Status__c='Ready for Registration');
                
                EDU_Request.Quote_Product_Line_Item__c = line.Id;
                EDU_Request.CPQ_Quote__c = line.Sterling_Quote__c;
                EDU_Request.Course_Code__c = line.Product_Material__c;
                EDU_Request.Opportunity_Name__c = line.Sterling_Quote__r.scpq__OpportunityId__c;
                EDU_Request.Account__c = line.Sterling_Quote__r.scpq__OpportunityId__r.AccountId;
                EDU_Request.Opportunity_Owner__c = line.Sterling_Quote__r.scpq__OpportunityId__r.OwnerId;
                
                EDU_Requests.add(EDU_Request);
            }
            else {
                for(Education_Request__c EDU_Request : line.Education_Requests__r)
                {
                    //if(EDU_Request.Education_Request_Status__c == 'Pending Approval')
                    //{
                        EDU_Request.Education_Request_Status__c = 'Ready for Registration';
                        EDU_Requests.add(EDU_Request);
                    //}
                }    
            } 
        }
        
    }
    
    upsert EDU_Requests;
}