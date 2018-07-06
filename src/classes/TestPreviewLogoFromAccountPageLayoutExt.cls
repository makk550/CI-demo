@IsTest
private with sharing class TestPreviewLogoFromAccountPageLayoutExt {
    private static testmethod void testNoRecord1(){
        Contact cntct = new Contact(lastname='test123');    
        
        PreviewLogoFromAccountPageLayoutExt controller = new PreviewLogoFromAccountPageLayoutExt(
            new ApexPages.StandardController(cntct));
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(true,controller.errorOccurred);
        System.assertEquals(PreviewLogoFromAccountPageLayoutExt.NO_RECORD_ERROR,controller.error);
        System.assertEquals(null,controller.logoRecordID);
        System.assertEquals(null,controller.logoAttachmentID);
    }

    private static testmethod void testNoRecord2(){
        Account testAccount = new Account(name='test123',Commercial_Id__c = 'asdf');    
        
        PreviewLogoFromAccountPageLayoutExt controller = new PreviewLogoFromAccountPageLayoutExt(
            new ApexPages.StandardController(testAccount));
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(true,controller.errorOccurred);
        System.assertEquals(PreviewLogoFromAccountPageLayoutExt.NO_RECORD_ERROR,controller.error);
        System.assertEquals(null,controller.logoRecordID);
        System.assertEquals(null,controller.logoAttachmentID);
    }

    private static Blob generateRandomBlob(){
        System.assert(true);
        return EncodingUtil.base64Decode(''+System.currentTimeMillis()+Math.roundToLong(Math.random()*10000));  
    }

    private static testmethod void testWithRecord(){
        Logo__c logo = new Logo__c();
        logo.name = 'test.txt';
        insert logo; 
        Attachment attach = new Attachment(
            Body=generateRandomBlob(),
            ContentType='txt',
            IsPrivate=false,
            Name='test.txt',
            ParentID=logo.id);
        insert attach;
        Account testAccount = new Account(name='test123',logo__c = logo.id,Commercial_Id__c='asdf',BillingStreet = 'Arlington',BillingCountry = 'US',BillingCity = 'VA');
        insert testAccount; 
        
        PreviewLogoFromAccountPageLayoutExt controller = new PreviewLogoFromAccountPageLayoutExt(
            new ApexPages.StandardController(testAccount));
        System.assertEquals(null,controller.doOnLoad());
        System.assertEquals(false,controller.errorOccurred);
        System.assertEquals(null,controller.error);
        System.assertEquals(logo.id,controller.logoRecordID);
        System.assertEquals(attach.id,controller.logoAttachmentID);
    }
}