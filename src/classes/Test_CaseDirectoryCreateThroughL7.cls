@isTest
public class Test_CaseDirectoryCreateThroughL7 {
   
    private static testMethod void testParseValuesFromRequestPayload(){
        Test.startTest();
        String reqpayLoad = '{"oldPath" : "/0879878/01098005/","newPath" : "/105246/"}';
        CaseDirectoryCreateThroughL7.parseValuesFromRequestPayLoad(reqpayLoad);
        Test.stopTest();
    }
    private static testMethod void testInsertCaseComment()
    {
        Test.startTest();
        Test_SetupData.createTestData();
        Case caseDetails = [select CaseNumber from Case where Id=:Test_SetupData.caseNumberId];
        System.debug('case number--'+caseDetails.CaseNumber);
        CaseDirectoryCreateThroughL7.caseNum = caseDetails.CaseNumber;
        CaseDirectoryCreateThroughL7.oldSiteId = Test_SetupData.siteIdNumber;
        CaseDirectoryCreateThroughL7.newSiteId = Test_SetupData.caSiteId;
		CaseComment comment = new CaseComment();
        comment.ParentID = Test_SetupData.caseNumberId;
        comment.CommentBody = 'Site has been changed on this case and Case Attachments have been moved from ('+CaseDirectoryCreateThroughL7.oldSiteId.replaceFirst( '^0+', '') +') to ('+CaseDirectoryCreateThroughL7.newSiteId.replaceFirst( '^0+', '') +')';  
        comment.IsPublished = true;
        CaseDirectoryCreateThroughL7.insertCaseComment();
        Test.stopTest();
    }
    private static testMethod void testUpdateSFTPLinks()
    {
        Test.startTest();
        Test_SetupData.createTestData();
        Case caseDetails = [select CaseNumber from Case where Id=:Test_SetupData.caseNumberId];
        CaseDirectoryCreateThroughL7.caseNum = caseDetails.CaseNumber;
        CaseDirectoryCreateThroughL7.oldSiteId = Test_SetupData.siteIdNumber;
        CaseDirectoryCreateThroughL7.newSiteId = Test_SetupData.caSiteId;
        SFTP_File_Attachments__c sftpRec =  new SFTP_File_Attachments__c();
        sftpRec.case_number__c = caseDetails.CaseNumber;
		sftpRec.File_Name__c = 'sample.jpg';
		sftpRec.Attachment_Link__c = System.label.CFTP_SFTPRec_BaseUrl+'/'+CaseDirectoryCreateThroughL7.oldSiteId+'/'+CaseDirectoryCreateThroughL7.caseNum+'/files_from_ca/'+'sample.jpg';
		insert sftpRec;
        CaseDirectoryCreateThroughL7.updateSFTPLinks();
        Test.stopTest();
    }
    private static testMethod void testCreateCaseDirectory(){
        List<String> sitefolderChangeList = new List<String>(); 
        Test.startTest();
        Test_SetupData.createTestData();
        System.debug(Test_SetupData.caseNumberId);
        Id caseId = CC_TestUtils.fakeId(Case.SObjectType);
        System.debug('caseid----'+caseId);
        Case caseDetails = [select CaseNumber,Tops_Support_Site_ID__c from Case where Id=:Test_SetupData.caseNumberId];
        System.debug('case num:'+caseDetails.CaseNumber+'site id:'+caseDetails.Tops_Support_Site_ID__c);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('caseNumber',caseDetails.CaseNumber);  
        gen.writeStringField('siteId',caseDetails.Tops_Support_Site_ID__c); //CC_Utils.padSiteIdforGS(c.Site_Id__c)
        sitefolderChangeList.add(gen.getAsString());
        CaseDirectoryCreateThroughL7.createOrMoveCaseDirectory(sitefolderChangeList,'CreateCase');
        Test.stopTest();
    }
    private static testMethod void testMoveCaseDirectory(){
        List<String> sitefolderChangeList = new List<String>(); 
        Test.startTest();
        Test_SetupData.createTestData();
        System.debug(Test_SetupData.caseNumberId);
        Id caseId = CC_TestUtils.fakeId(Case.SObjectType);
        System.debug('caseid----'+caseId);
        Case caseDetails = [select CaseNumber,Tops_Support_Site_ID__c from Case where Id=:Test_SetupData.caseNumberId];
        System.debug('case num:'+caseDetails.CaseNumber+'site id:'+caseDetails.Tops_Support_Site_ID__c);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('oldPath','/'+caseDetails.Tops_Support_Site_ID__c+'/'+caseDetails.CaseNumber+'/');  
        gen.writeStringField('newPath','/'+Test_SetupData.siteIdNumber+'/'); 
        sitefolderChangeList.add(gen.getAsString());
        Test.setMock(HttpCalloutMock.class, new caseDirectoryCreateMock());
        CaseDirectoryCreateThroughL7.createOrMoveCaseDirectory(sitefolderChangeList,'MoveCaseDirectory');
        Test.stopTest();
    }
}