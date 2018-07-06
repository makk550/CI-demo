@istest
public class agileUpdInvLOETrigTest {

static testMethod void testUpdateInvLOETriggers() {
 Agile_Estimation_Factor__c agEstFact= new Agile_Estimation_Factor__c(Type__c='Configuration',Complexity__c='High');
 insert agEstFact;
 
 Agile_Requirements__c agReq = new Agile_Requirements__c(Process_Step__c='Test'); 
 insert agReq;

 Agile_Application_Inventory__c agAppInv = new Agile_Application_Inventory__c(Type__c='Configuration',Complexity__c='High',
                                                Design_LOE__c=1,Estimated_Build_Unit_Test_LOE__c=2,Estimated_SIT_LOE__c=3,
                                                Override_Estimated_LOE__c=false,Agile_Requirement__c=agReq.id);
 insert agAppInv;
 }
}