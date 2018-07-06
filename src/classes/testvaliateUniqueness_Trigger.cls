@isTest(seeAllData = true)
public class testvaliateUniqueness_Trigger {
    public static testMethod void testMeth_POC() {
        POC_Escalation_Matrix__c  poc_record = new POC_Escalation_Matrix__c (Region__c= 'NA',Area1__c='NA_HQ', Business_Unit__c='Application Delivery',POC_Approver_Email__c='test1234@ca.com',POC_Escalation_Manager__c=Userinfo.getUserID());
        insert poc_record;
    }}