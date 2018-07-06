@isTest
public class KCSCaseIssueArchival_Test {
 private static List<knowledge__kav> listKnowledgeObj;
     private static testMethod void method1(){
        Test.startTest();
        List<RecordType> listOfRecord = [Select id, Name from RecordType where Name='Case / Issue' limit 1];
        listKnowledgeObj = new List<knowledge__kav>();
        knowledge__kav knowledgeObj1 = new knowledge__kav();
        knowledgeObj1.Title = 'test111';
        knowledgeObj1.UrlName = 'testing1111';
        knowledgeObj1.Summary = '<p><br /><a href="docops.ca.com/ca-cross-enterprise-application-performance-management/10-3/en/installing/preparing-for-installation/configure-ca-sysview-for-db2-for-use-with-ca-cross-enterprise-apm" target="_blank">Configure CA SYSVIEW for DB2 for Use with CA Cross-Enterprise APM</a></p>';
        knowledgeObj1.Request_Type__c = 'active';
        knowledgeObj1.ValidationStatus='Not Validated';
        knowledgeObj1.Content3__c='UEsDBBQAAAAIAHK8k0rt8lwFyAEAAHIHAAALAAAAdXBncmFkZS50eHSdlF1vqkAQhu9Pcv7D3GmN2bNwPB/G9MIqrfYDrGDLBQmhMlYSCnZZ+/HvuyzURNuaqcRkFvaZ12czhBv+HwyDmaCv2eRs2h9aP3/EuEgyDFeRXEJ1MRbEd0EuonmKATi6tnplawu+wZtsH148pmE3gKtkLvIiX0hwry/BRfGEQvVy1jq01Ti81Ty89feeVvUzAxiemL9sr9dl/B8R5d9gDU4VMAwS6c5ssqti6bIKptoqlKrLON2AcfLJGKe6Mk5VvRzbM59soGn62TROddYwVbs/9v92yNqapmtrnKqt4Vpb4XchvuB8LRGSrEAhVZE5OCNoOqNwkCaYyTao5TjOhF7Y0QPqheO9rqrVEFOUeJpG9/p2IGYqadPQt25QFEmeHcFTlK6xgCZvQ6drGmYbGv65Oxh5ffdiMnUm1tQbW25oW7eNcmtqXauq4D/qrvyCNo56W8rrVRyp4nhQoFQlrEXhuMqH5yUK3N0wup3PY07dMqes73zobEdt7+1PGzqDMk4vPhfTWzQ1v4ryvwry98fEekKwEPmDGkndtOloFmp7Lt8fVFi+rLGdYIiyeDN+9VCP6avBjErt+q2p4I/jbtT/s3Oy3htQSwECPwAUAAAACAByvJNK7fJcBcgBAAByBwAACwAkAAAAAAAAACAAAAAAAAAAdXBncmFkZS50eHQKACAAAAAAAAEAGAATfTvhVLnSAZMcZIpPudIBVQD2Njm50gFQSwUGAAAAAAEAAQBdAAAA8QEAAAAA';
        knowledgeObj1.Background__c='<a></a>';
        knowledgeObj1.Environment__c='<p>&nbsp;</p><p>Locate the custom page OID from the URL being used.</p> <p>Example (<a href="https://rally1.rallydev.com/#/46759508590d/custom/62605882109">https://rally1.rallydev.com/#/46759508590d/custom/<strong>62605882109</strong></a>)</p> <p>Log into Splunk and run the following query to determine the number of events that occur on a custom page. &nbsp;</p> <p>(Custom page OID) sourcetype="beacon-spans" componentHierarchy="DashboardContainer" eventDescription="component ready"</p> <p>&nbsp;</p>';
        knowledgeObj1.Instructions__c='<p>Every system (LPAR) is shown in a different color in the GUI.DCI gives every LPAR a randomized color. To get a more friendly picture to you it is possible to change the color. Every changes you do, do in the custom folder of the USS filesystem to DCI only. Please make sure that you are using the correct path for your changes. So please change the route.xml for this:</p> <p>&nbsp;</p> <p><img src="http://case-archive.s3.amazonaws.com/KnowledgeArchival/BestPractices/EmbeddedImages/TEC1874937_Embeded/Routes file.png" alt="Routes file.png" width="419" height="239" /></p> <p>Now you are prepared for doing changes in the config.xml that is stored in the custom folder.</p> <p>&nbsp;</p> <p>This is an example to change the color of C111.LPA3.SYS3 (The first entry is the CPC-Name, the second is the LPAR name and the tird is the SYSID).</p> <p><img src="http://case-archive.s3.amazonaws.com/KnowledgeArchival/BestPractices/EmbeddedImages/TEC1874937_Embeded/C111 - Original color.png" alt="C111 - Original color.png" width="1912" height="934" /></p> <p>To change the color you have to generate this little config.xml in the custom folder</p> <p><img src="http://case-archive.s3.amazonaws.com/KnowledgeArchival/BestPractices/EmbeddedImages/TEC1874937_Embeded/Config file.png" alt="Config file.png" width="363" height="378" /></p> <p>Define the ID for the color change. In this case:</p> <p>&lt;ID&gt;C111.LPA3.SYA3&lt;/ID&gt;</p> <p>&nbsp;</p> <p>Then the color you want to use:</p> <p>&lt;COLOR/&gt;#FF897C&lt;/COLOR&gt;</p> <p>&nbsp;</p> <p>Then the GUI looks like:</p> <p><img src="http://case-archive.s3.amazonaws.com/KnowledgeArchival/BestPractices/EmbeddedImages/TEC1874937_Embeded/C111 - New color.png" alt="C111 - New color.png" width="1915" height="944" /></p> <p>&nbsp;</p> <p>&nbsp;</p> <p>&nbsp;</p>';
        knowledgeObj1.Additional_Information__c = 'p>&nbsp;</p> <a></a><p><img alt="User-added image" height="241" src="https://ca--FSB1--c.cs79.content.force.com/servlet/rtaImage?eid=ka01h0000004Hsa&amp;feoid=00N0c00000B92wR&amp;refid=0EM1h0000008d60" width="500"></img> </p>p>&nbsp;</p>';
        knowledgeObj1.RecordTypeId = listOfRecord[0].Id;
        knowledgeObj1.Component_Names__c = 'CA PPM: CLARITY ON DEMAND ODMNTR';
        knowledgeObj1.Component_Codes__c = 'CA PPM: ODMNTR';
        knowledgeObj1.Releases__c = 'CA PPM: 1; 1.0; 1.02';
        knowledgeObj1.Product_Names__c = 'CA PPM: CA PPM_CLARITY ON DEMAND';
        knowledgeObj1.Content1__c='Issue';
        knowledgeObj1.Content2__c = 'Resolution';
        knowledgeObj1.CreatedById = '0050c00000D1f3LAAR';
        knowledgeObj1.Language = 'en_US';
        knowledgeObj1.File_attachment__ContentType__s = 'text/plain';
        knowledgeObj1.File_attachment__Name__s = 'Penguins.jpg';
        knowledgeObj1.File_attachment__Body__s = Blob.valueof('UEsDBBQAAAAIAHK8k0rt8lwFyAEAAHIHAAALAAAAdXBncmFkZS50eHSdlF1vqkAQhu9Pcv7D3GmN2bNwPB/G9MIqrfYDrGDLBQmhMlYSCnZZ+/HvuyzURNuaqcRkFvaZ12czhBv+HwyDmaCv2eRs2h9aP3/EuEgyDFeRXEJ1MRbEd0EuonmKATi6tnplawu+wZtsH148pmE3gKtkLvIiX0hwry/BRfGEQvVy1jq01Ti81Ty89feeVvUzAxiemL9sr9dl/B8R5d9gDU4VMAwS6c5ssqti6bIKptoqlKrLON2AcfLJGKe6Mk5VvRzbM59soGn62TROddYwVbs/9v92yNqapmtrnKqt4Vpb4XchvuB8LRGSrEAhVZE5OCNoOqNwkCaYyTao5TjOhF7Y0QPqheO9rqrVEFOUeJpG9/p2IGYqadPQt25QFEmeHcFTlK6xgCZvQ6drGmYbGv65Oxh5ffdiMnUm1tQbW25oW7eNcmtqXauq4D/qrvyCNo56W8rrVRyp4nhQoFQlrEXhuMqH5yUK3N0wup3PY07dMqes73zobEdt7+1PGzqDMk4vPhfTWzQ1v4ryvwry98fEekKwEPmDGkndtOloFmp7Lt8fVFi+rLGdYIiyeDN+9VCP6avBjErt+q2p4I/jbtT/s3Oy3htQSwECPwAUAAAACAByvJNK7fJcBcgBAAByBwAACwAkAAAAAAAAACAAAAAAAAAAdXBncmFkZS50eHQKACAAAAAAAAEAGAATfTvhVLnSAZMcZIpPudIBVQD2Njm50gFQSwUGAAAAAAEAAQBdAAAA8QEAAAAA'); 
        listKnowledgeObj.add(knowledgeObj1);
        
        insert listKnowledgeObj;
       
         knowledgeObj1 = [SELECT KnowledgeArticleId,ArticleNumber,Cause__c,Auto_Article_Numbers__c,Legacy_Source__c,Keywords__c,Legacy_Approval_History__c,VersionNumber,CADocid__c,CMS_IDs__c,PublishStatus,Notes__c,CreatedById,CreatedDate,LastModifiedById,LastModifiedDate,LastPublishedDate,Legacy_Current_Author__c,File_attachment__Body__s,File_attachment__Name__s,File_attachment__ContentType__s,Content2__c,Content1__c,Product_Names__c,Additional_Information__c,RecordTypeId,Component_Names__c,Component_Codes__c,Releases__c,Title,UrlName,Summary,Request_Type__c,ValidationStatus,Background__c,Content3__c,Environment__c,Instructions__c FROM knowledge__kav WHERE Id = :listKnowledgeObj[0].Id];
         System.debug('ArticleNumber: '+knowledgeObj1.ArticleNumber);
         System.debug('KnowledgeArticleId: '+knowledgeObj1.KnowledgeArticleId);
         listKnowledgeObj.remove(0);
         KbManagement.PublishingService.publishArticle(knowledgeObj1.KnowledgeArticleId, true);
         KbManagement.PublishingService.archiveOnlineArticle(knowledgeObj1.KnowledgeArticleId,null);
         
         listKnowledgeObj.add(knowledgeObj1);
         
         AWS_credentials__c credentials=new AWS_credentials__c();
         credentials.Name='Case Archival';
         credentials.Key__c='AKIAIXRMUKP2XKCSHNBA';
         credentials.Secret__c='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';
         insert credentials;

         KCSCaseIssueArchival cia= new KCSCaseIssueArchival();
         cia.generateXMLDocument(listKnowledgeObj[0]);
         
         
         Test.stopTest(); 
     }
}