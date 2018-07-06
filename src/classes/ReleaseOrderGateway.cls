/**
 * Class ReleaseOrderGateway
 *
 * Provides finder methods for accessing data in the Release_Order__c object.
 */
public without sharing class ReleaseOrderGateway
{   
    public static Map<Id, Release_Order__c> getEduReqReleaseOrders(Map<Id, Release_Order__c> rNew, Map<Id, Release_Order__c> rOld)
    {
         Set<Id> releaseOrders = new Set<Id>();
    
         for(Id roId : rNew.keySet())
            if(rOld.get(roId).SAP_Order_Status__c != rNew.get(roId).SAP_Order_Status__c && ( rNew.get(roId).SAP_Order_Status__c == 'In Review' || rNew.get(roId).SAP_Order_Status__c == 'Insufficient fund' || rNew.get(roId).SAP_Order_Status__c == 'Approved') )
                   releaseOrders.add(roId);
                   
         return New Map<Id, Release_Order__c>(               [SELECT Id,
                                                                     (SELECT Id, 
                                                                         Release_Order__c,
                                                                         Product_Material__c
                                                                      FROM Education_Burn_Order_Line_Items__r),
                                                                     (SELECT Education_Burn_Order_Line_Item__c, 
                                                                             Education_Request_Status__c 
                                                                      FROM Education_Requests__r),
                                                                     Sterling_Quote__c,
                                                                     Sterling_Quote__r.scpq__OpportunityId__c,
                                                                     Sterling_Quote__r.scpq__OpportunityId__r.AccountId,
                                                                     Sterling_Quote__r.scpq__OpportunityId__r.OwnerId
                                                              FROM Release_Order__c
                                                              WHERE Id IN :releaseOrders]);
                                                                  //AND Id Not In (SELECT Release_Order__c FROM Education_Request__c WHERE Release_Order__c IN :approvedReleaseOrders)]);                 
    }
    
    public static List<Education_Request__c> educationRequestsFor(Release_Order__c ro)
    {
        List<Education_Request__c> EDU_Requests = new List<Education_Request__c>();
        Set<Id> releaseOrderLinesWithEducationRequests = new Set<Id>();
        
        for(Education_Request__c eduReq : ro.Education_Requests__r)
            releaseOrderLinesWithEducationRequests.add(eduReq.Education_Burn_Order_Line_Item__c);
        
        
        if(ro.SAP_Order_Status__c == 'In Review' || ro.SAP_Order_Status__c == 'Insufficient fund')
        {
            for(Release_Order_Line_Item__c rol : ro.Education_Burn_Order_Line_Items__r)
            {
                if(!releaseOrderLinesWithEducationRequests.contains(rol.Id))
                {
                    Education_Request__c EDU_Request = new Education_Request__c(Transaction_Type__c = 'Burn Order', Education_Request_Status__c='New');
                    
                    EDU_Request.Education_Burn_Order_Line_Item__c = rol.Id;
                    EDU_Request.Course_Code__c = rol.Product_Material__c;
                    EDU_Request.Release_Order__c = ro.Id;
                    EDU_Request.CPQ_Quote__c = ro.Sterling_Quote__c;
                    EDU_Request.Opportunity_Name__c = ro.Sterling_Quote__r.scpq__OpportunityId__c;
                    EDU_Request.Account__c = ro.Sterling_Quote__r.scpq__OpportunityId__r.AccountId;
                    EDU_Request.Opportunity_Owner__c = ro.Sterling_Quote__r.scpq__OpportunityId__r.OwnerId;
                    
                    EDU_Requests.add(EDU_Request);
                }
            }
        }
        else if(ro.SAP_Order_Status__c == 'Approved')
        {
            for(Education_Request__c eduReq : ro.Education_Requests__r)
            {
                if(eduReq.Education_Request_Status__c == 'Pending Approval')
                {
                    eduReq.Education_Request_Status__c = 'Ready for Registration';
                    EDU_Requests.add(eduReq);
                }
            }
        }
        
        return EDU_Requests;
    }
}