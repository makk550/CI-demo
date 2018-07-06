public class TAQ_matchQuotaTypeValue {
  
   public void matchQuotaTypeCallidus(List<TAQ_Org_Quota_Approved__c> quotaApprList){
	   
	    Map<Id,String> plantypeMap = new Map<Id,String>();
	          
	     Set<Id> orgApprId = new Set<Id>();
	     for(TAQ_Org_Quota_Approved__c eachRec: quotaApprList)
           orgApprId.add(eachRec.TAQ_Organization_Approved__c);
	     
	     List<TAQ_Organization_Approved__c> taqOrgApprRec = [SELECT Id,Plan_Type__c from TAQ_Organization_Approved__c where Id in: orgApprId];
	     for(TAQ_Organization_Approved__c eachRec: taqOrgApprRec)
	          plantypeMap.put(eachRec.Id,eachRec.Plan_Type__c);
	     	           
	     Set<String> quotaTypeList = new Set<String>();
	     for(TAQ_Org_Quota_Approved__c eachRec: quotaApprList)
	     	  quotaTypeList.add(eachRec.Quota_Type__c);
	     	  
	     List<TAQ_Quota_Type__c> quotatypeRecs = [SELECT Quota_Type_Callidus__c,Quota_Type__c,Plan_type__c from TAQ_Quota_Type__c
													     where (Quota_Type__c in: quotaTypeList OR Quota_Type__c = NULL) AND 
													   		   (plan_type__c in: plantypeMap.values() OR Plan_Type__c = NULL)
													     ORDER BY Plan_Type__c  DESC nulls last,
													              Quota_Type__c DESC nulls last];
	     
	     for(TAQ_Org_Quota_Approved__c quotaRec: quotaApprList){
	     	String qAppr_quotatype = quotaRec.Quota_Type__c == NULL? 'NULL': quotaRec.Quota_Type__c;
	     	String qAppr_plantype = plantypeMap.containsKey(quotaRec.taq_organization_Approved__c)?(plantypeMap.get(quotaRec.taq_organization_Approved__c)!=NULL?plantypeMap.get(quotaRec.taq_organization_Approved__c):'NULL'):'NULL';
	     	Boolean valAssigned = false;
	     	quotaRec.Quota_Type_Callidus__c = NULL;
	     	for(TAQ_Quota_Type__c qtype: quotatypeRecs){
		     	   String qObj_quotatype = qtype.Quota_Type__c == NULL? 'NULL': qtype.Quota_Type__c; 
		     	   String qObj_plantype = qtype.Plan_Type__c == NULL? 'NULL': qtype.Plan_Type__c; 
		     	  
		     	   if((qObj_plantype.contains(qAppr_plantype) || qObj_plantype == 'NULL') &&
		     	  	  (qObj_quotatype == qAppr_quotatype || qObj_quotatype == 'NULL') && valAssigned == false){
		     	  	   	  quotaRec.Quota_Type_Callidus__c = qtype.Quota_Type_Callidus__c; 
		     	  	  	  valAssigned = true;
	     	  	   }
	     	}
	     }
	}
}