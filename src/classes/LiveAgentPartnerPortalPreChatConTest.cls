@isTest
private class LiveAgentPartnerPortalPreChatConTest {
	 public static testMethod void  testController(){
         LiveAgentPartnerPortalPreChatController lgp = new LiveAgentPartnerPortalPreChatController();
         lgp.pageLanguage();
         lgp.pageLanguage('en-us');
     }
}