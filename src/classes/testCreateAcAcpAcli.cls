/*
* Test class created by MERHA02.
* Creates Active Contract,Active Contract Product,Active Contract Line Item
* without the use of seealldata = true.
* It skips account triggers.
*/ 
@isTest
public class testCreateAcAcpAcli {
    
    public static testMethod void testACLI(){
        
        testOpportunityTriggersClass.createTestData();
        Opportunity opp = [select id,Start_Date__c,End_Date__c from opportunity limit 1];
        system.assertNotEquals(null, opp.id, 'Opportunity not found.');
        
        Active_Contract__c ac = new Active_Contract__c(Name ='TestACrec');
        insert ac;
        
        Active_Contract_Product__c acp = new Active_Contract_Product__c(Name ='TestAcpRecord',Active_Contract__c= ac.id,Opportunity__c =opp.id,Dismantle_Date__c= System.today());
        insert acp;   
        
        Active_Contract_Line_Item__c acli=new Active_Contract_Line_Item__c(Name='TestAcliRecord',Contract_Product__c=acp.id);
        insert acli;
       
    }
}