@isTest(SeeAllData = true)
public class PRM_ChannelManagerTest {
public static testmethod void TestGetChannelManager(){
     //test.starttest();
     User testUser = [Select Id, name from User where name = 'CA-Hybrid NA' LIMIT 1];
    System.debug(' testUser is ' + testUser);
     System.runAs(testUser) {
        PRM_ChannelManager pcm = new PRM_ChannelManager();
         
         if (pcm != null && pcm.alliancePAMName != null)
         {        
            System.assert(pcm.alliancePAMName.length() > 0);
         }
         if (pcm != null && pcm.solutionProviderPAMName != null)
         {
         	System.assert(pcm.solutionProviderPAMName.length() > 0);
         }
         if (pcm != null && pcm.serviceProviderPAMName != null)
         {
         	System.assert(pcm.serviceProviderPAMName.length() > 0);
         }
         
         System.assertEquals(pcm.AllRTMContainsPARTNorBlank, true);
        
 		 System.assertEquals(pcm.AccntTeamMemebers.size(), 0);
                 
         string phone = prm_channelManager.FormatPhone('6312458759');
         System.assertEquals(phone, '631-245-8759');
         
         phone = prm_channelManager.FormatPhone('');
         System.assertEquals(phone, '');
         
         phone = prm_channelManager.FormatPhone('1 631 342 2181');
         System.assertEquals(phone, '631-342-2181');
         
         phone = prm_channelManager.FormatPhone('1800 631 342 2181');
         System.assertEquals(phone, '1800 631 342 2181');
          
         pcm.alliancePAMEmail = 'test@ca.com';
         System.assertEquals(pcm.alliancePAMEmail, 'test@ca.com');
         pcm.alliancePAMName = 'test';
         System.assertEquals(pcm.alliancePAMName, 'test');
         pcm.alliancePAMPHone = '6313422181';
         System.assertEquals(pcm.alliancePAMPHone, '6313422181');
         
          pcm.solutionProviderPAMEmail = 'test@ca.com';
         System.assertEquals(pcm.solutionProviderPAMEmail, 'test@ca.com');
         pcm.solutionProviderPAMName = 'test';
         System.assertEquals(pcm.solutionProviderPAMName, 'test');
         pcm.solutionProviderPAMPhone = '6313422181';
         System.assertEquals(pcm.solutionProviderPAMPhone, '6313422181');
         
             pcm.serviceProviderPAMEmail = 'test@ca.com';
         System.assertEquals(pcm.serviceProviderPAMEmail, 'test@ca.com');
         pcm.serviceProviderPAMName = 'test';
         System.assertEquals(pcm.serviceProviderPAMName, 'test');
         pcm.serviceProviderPAMPhone = '6313422181';
         System.assertEquals(pcm.serviceProviderPAMPhone, '6313422181');
         
     }
    //test.stoptest();
   }
}