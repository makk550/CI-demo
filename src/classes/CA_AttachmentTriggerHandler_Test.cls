@isTest(SeeAllData = true)
private Class CA_AttachmentTriggerHandler_Test{
    private static testMethod void testMethod1(){
    RecordType agrRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Transaction' AND SObjectType = 'Apttus__APTS_Agreement__c'];
    RecordType ndaRec = [Select id,Name,DeveloperName,SObjectType from RecordType where RecordType.DeveloperName = 'Standard_NDA' AND SObjectType = 'Apttus__APTS_Agreement__c'];
    List<Apttus__APTS_Agreement__c> listOfAgr= new List<Apttus__APTS_Agreement__c>();
    
    Apttus__APTS_Agreement__c agr1 = new Apttus__APTS_Agreement__c();
    agr1.Name = 'Test Agreement';
    agr1.Apttus__Contract_Start_Date__c = System.today();
    //agr1.CA_Agreement_Type__c = 'Order Form' ;
    agr1.RecordTypeId = agrRec.id;
    //agr1.Tops_Site_Id_Sold_To_Id__c = site1.id;
    //agr1.CA_Opportunity__c = testOpp.id;
    listOfAgr.add(agr1);
    
    Apttus__APTS_Agreement__c agr11 = new Apttus__APTS_Agreement__c();
    agr11.Name = 'Test11 Agreement';
    agr11.Apttus__Contract_Start_Date__c = System.today();
    //agr1.CA_Agreement_Type__c = 'Order Form' ;
    agr11.RecordTypeId = ndaRec.id;
    //agr1.Tops_Site_Id_Sold_To_Id__c = site1.id;
    //agr1.CA_Opportunity__c = testOpp.id;
    agr11.CA_NDA_Flag__c = 'Standard NDA';
    agr11.CA_Is_Legacy_Contract__c = 'Yes';
    listOfAgr.add(agr11);
    
    
    insert listOfAgr;
    
    List<Attachment> listOfAtt = new List<Attachment>();
    Attachment att = new Attachment();
    att.ParentId = listOfAgr[0].id;
    att.Name = listOfAgr[0].Name;
    att.Body =  Blob.valueOf('Test Attachment Body');
    listOfAtt.add(att);
    
    Attachment att1 = new Attachment();
    att1.ParentId = listOfAgr[1].id;
    att1.Name = listOfAgr[1].Name;
    att1.Body =  Blob.valueOf('Test11 Attachment Body');
    listOfAtt.add(att1);
            
    /*Attachment att11 = new Attachment();
    att11.ParentId = listOfAgr[1].id;
    att11.Name = 'Attachment Test';
    att11.Body =  Blob.valueOf('Test1134 Attachment Body');
    listOfAtt.add(att11);*/
    insert listOfAtt ;
    
    }

    private static testMethod void TestBPAttachments(){
        //Test BP attachments
    ID accountId = TestBPDataFactory.PopulateTestAccount();
    ID bpId = TestBPDataFactory.PopulateTestBP(accountId);
    system.debug(' account id ' + accountId);
    system.debug(' bp id ' + bpId);    
    Business_plan_new__c bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
         
    System.assertEquals(bp.UserAttachmentID__c, null);
    System.assertEquals(bp.UserAttachmentName__c, null);
        
    Attachment attach = new Attachment();
         
        attach.Body = blob.valueOf('TestString');
        attach.Name = 'test1.pdf';
        attach.description = 'Business Plan Approval Process Generated Attachments - Do not change Description';
        attach.IsPrivate = false;
        attach.ParentId = bpId;
     
        insert attach;
        
        bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
        
        System.assertEquals(bp.UserAttachmentID__c,null);
        System.assertEquals(bp.UserAttachmentName__c, null);
    }

    private static testMethod void TestOneBPAttachment(){
        //Test BP attachments
    ID accountId = TestBPDataFactory.PopulateTestAccount();
    ID bpId = TestBPDataFactory.PopulateTestBP(accountId);
    system.debug(' account id ' + accountId);
    system.debug(' bp id ' + bpId);    
    Business_plan_new__c bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
         
    System.assertEquals(bp.UserAttachmentID__c, null);
    System.assertEquals(bp.UserAttachmentName__c, null);
    
    Attachment attach = new Attachment();
         
        
        
        attach = new Attachment();
         
        attach.Body = blob.valueOf('TestString');
        attach.Name = 'test2.pdf';
        attach.IsPrivate = false;
        attach.ParentId = bpId;
     
        insert attach;
        
        bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
        
        System.assertEquals(bp.UserAttachmentID__c,attach.id);
        
    }

    private static testMethod void TestMultipleBPAttachment(){
        //Test BP attachments
    ID accountId = TestBPDataFactory.PopulateTestAccount();
    ID bpId = TestBPDataFactory.PopulateTestBP(accountId);
    system.debug(' account id ' + accountId);
    system.debug(' bp id ' + bpId);    
    Business_plan_new__c bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
         
    System.assertEquals(bp.UserAttachmentID__c, null);
    System.assertEquals(bp.UserAttachmentName__c, null);
    
    list<Attachment> attachments = new list<Attachment>();

    Attachment attach = new Attachment();
         
    attach = new Attachment();
     
    attach.Body = blob.valueOf('TestString');
    attach.Name = 'test1.pdf';
    attach.IsPrivate = false;
    attach.ParentId = bpId;
 
    attachments.add(attach);

    attach = new Attachment();
     
    attach.Body = blob.valueOf('TestString');
    attach.Name = 'test2.pdf';
    attach.IsPrivate = false;
    attach.ParentId = bpId;

    attachments.add(attach);
    insert attachments;
    
    bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
    
    System.assertEquals(bp.UserAttachmentID__c,'multiple');
       System.assertEquals(bp.UserAttachmentName__c,'Click for details');
        
    }

    private static testMethod void TestDeleteBPAttachment(){
        ID accountId = TestBPDataFactory.PopulateTestAccount();
        ID bpId = TestBPDataFactory.PopulateTestBP(accountId);
        system.debug(' account id ' + accountId);
        system.debug(' bp id ' + bpId);    
        Business_plan_new__c bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
             
        System.assertEquals(bp.UserAttachmentID__c, null);
        System.assertEquals(bp.UserAttachmentName__c, null);
        
        Attachment attach = new Attachment();
             
            attach = new Attachment();
             
            attach.Body = blob.valueOf('TestString');
            attach.Name = 'test2.pdf';
            attach.IsPrivate = false;
            attach.ParentId = bpId;
         
            insert attach;
            
            delete attach;
            bp = Database.query('Select UserAttachmentID__c, UserAttachmentName__c from business_plan_new__c where id =: bpId');
            
              System.assertEquals(bp.UserAttachmentID__c, null);
    System.assertEquals(bp.UserAttachmentName__c, null);
        
    }

    private static testMethod void TestDeleteAutoPDF(){
        ID accountId = TestBPDataFactory.PopulateTestAccount();
        ID bpId = TestBPDataFactory.PopulateTestBP(accountId);  

        Attachment attach = new Attachment();
             
            attach = new Attachment();
             
            attach.Body = blob.valueOf('TestString');
            attach.Name = 'test2.pdf';
            attach.Description = 'Business Plan Approval Process Generated Attachments - Do not change Description';
            attach.IsPrivate = false;
            attach.ParentId = bpId;
         
            insert attach;
            
            try
            {
                delete attach;
            }
            catch(System.DmlException e)
            {
                 System.assertNOTequals(e.getmessage(),null); 
            }
                
    }
           
}