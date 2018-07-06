/**************************************************************************************************
* Test class to provide coverage for WebServiceUtilityClass
* 
*Version Date         Owner                         Description
****************************************************************************************************
* 1.0    24/03/2015   Deepa Raman                   PR04659 - ISTP Partner Profile Wave 1. Test class for WebServiceUtilityClass
**************************************************************************************************/


@isTest(SeeAllData=true)
private class Test_WebServiceUtilityClass {

    static List<TAQ_Account__c> partnerTaqAccountList  = new List <TAQ_Account__c>();
    static List<Account> DirectAccountList = new List<Account>();
    
    //Static TestDataPartnerProfilePartnerProfile TestDataPartnerProfile = new TestDataPartnerProfilePartnerProfile ();


    //Method to cover Direct accounts account.
    static testmethod void test_TAQAccountEAIMDMSync(){
        Test.startTest();
        DirectAccountList = TestDataPartnerProfile.insertDirectAccount();
        Account DirectAccount1 = DirectAccountList[0];
        
        Map<Id,List<sobject>> accIdListMap = new Map<Id,List<sobject>>();
        accIdListMap.put(DirectAccount1.id,new List<sobject>{DirectAccount1});
        
        WebServiceUtilityClass.callEAIWebserviceBulkRequest(accIdListMap);   
        Test.stopTest();     
    }
    
   
    
    //Method to cover TAQ account.
    static testmethod void test_PartnerAccountEAIMDMSync(){
        Test.startTest();
        DirectAccountList = TestDataPartnerProfile.insertDirectAccount();
        Account DirectAccount1 = DirectAccountList[0];
        
        partnerTaqAccountList = TestDataPartnerProfile.insertPartnerAccount();
        TAQ_Account__c partnerTaqAccount1 = partnerTaqAccountList[0];
        
        //Create contact        
        List<Contact> contactList = TestDataPartnerProfile.insertContact(DirectAccount1.Id);

        List<TAQ_Account_Approved__c> newTaqApprovedAccList = TestDataPartnerProfile.insertTAQAccApp(partnerTaqAccount1.id);
        
        List<TAQ_Account_Team_Approved__c> newTaqTeamApprList = TestDataPartnerProfile.insertTAQAccTeamApp(newTaqApprovedAccList[0].id);
                
        List<TAQ_Organization__c> taqOrgList = TestDataPartnerProfile.insertTAQOrganization() ;
        SYSTEM.DEBUG('#########taqOrgList[0] -'+ taqOrgList[0]);
        
        List<TAQ_Organization_Approved__c> taqOrgApprovedList = TestDataPartnerProfile.insertTAQOrganizationApp(taqOrgList[0].id) ;
        SYSTEM.DEBUG('#########taqOrgApprovedList [0] -'+ taqOrgApprovedList [0]);                              
        
        Set<ID> TAQAccTeamAppIDSet = new Set<ID> {newTaqApprovedAccList[0].id};
        
        
        WebServiceUtilityClass.getAccountMap(new Set<ID>{DirectAccount1.id}); 
        WebServiceUtilityClass.getAccountIdToContactListMap(new Set<ID>{DirectAccount1.id});

        WebServiceUtilityClass.getTAQAccountIdSet(TAQAccTeamAppIDSet); 
        WebServiceUtilityClass.accountInsertIdSet = new Set<ID>{DirectAccount1.id};
        WebServiceUtilityClass.getTAQAccTeamAppListMap(new Set<ID>{partnerTaqAccount1.id});
        
        WebServiceUtilityClass.getAcccountToTAQApprovedMap(TAQAccTeamAppIDSet);
                
        Map<Id,List<sobject>> accIdListMap = new Map<Id,List<sobject>>();
        accIdListMap.put(DirectAccount1.id,new List<sobject>{partnerTaqAccount1 });
        
        WebServiceUtilityClass.accIdToTAQAccTeamApprovedListMap.put(DirectAccount1.id,new List<sObject>{newTaqTeamApprList[0]});
        WebServiceUtilityClass.getTAQOrganization(new Set<string>{taqOrgList[0].PMFKey__c});
        WebServiceUtilityClass.getTAQOrganizationApproved(new Set<ID>{taqOrgList[0].id});
        SYSTEM.DEBUG('#########taqOrgList[0] -'+ taqOrgList[0]);
        WebServiceUtilityClass.PMFKeyToTaqOrgApprovedMap.put(taqOrgList[0].PMFKey__c, taqOrgApprovedList[0]);
        
        WebServiceUtilityClass.callEAIWebserviceBulkRequest(accIdListMap);
         
                
        String respXML = '<?xml version="1.0" encoding="utf-8"?><accountupsertrequest><accounts><account><caaccountid>CA1234</caaccountid><caaccountname>test</caaccountname>';
        WebServiceUtilityClass.EAIWebServiceCallout(respXML,new Set<ID>{partnerTaqAccount1.id},'TAQ_Account__c'); 
        WebServiceUtilityClass.EAIWebServiceCalloutTrigger(respXML,new Set<ID>{partnerTaqAccount1.id},'TAQ_Account__c'); 
        Test.stopTest();
    }   
}