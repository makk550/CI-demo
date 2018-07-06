@isTest (SeeAllData = true)
public class TestCalloutToCSM{
   
  private static User adminUser ;  
  
  static testmethod void testCreateExternalRequest () {
    
     Profile adminProfile = [select Id from Profile where Name = '1.0 CA Sys Admin Commit & PR Non-SSO']; 
     adminUser = [select Id from User where IsActive = true AND  ProfileId = :adminProfile.Id limit 1] ;  
     system.runAs(adminUser){     
        Test.StartTest();
        // querying case here as inserting account , site ,  case and then Task results in Too many SOQL exception 
        Case testCase = [select Id from Case where Status ='Open' and
                                                   Site_Association__c !=null and 
                                                   CA_Product_Controller__c!=null and 
                                                   CA_Product_Component__c!=null and 
                                                   contactId !=null and
                                                   Reason!=null and
                                                   Category__c !=null  limit 1
                        ];
        RecordType[] recordtypeList = [select id from RecordType where Name = 'Saas Ops Incident' limit 1];                 
        
        External_RnD__c externalRequest = new External_RnD__c();
        externalRequest.Subject__c = 'test';
        externalRequest.Severity__c = '1';
        externalRequest.Priority__c = 'High';
        externalRequest.SaaS_Description__c = 'test';
        externalRequest.Due_Date__c =  system.today();
        externalRequest.SaaS_Type__c = 'SaaS Ops Incident';
        externalRequest.case__c = testCase.Id;
        externalRequest.recordtypeid = recordtypeList[0].Id;
        externalRequest.Reference_ID__c = '300-512';
        insert externalRequest;
        
        externalRequest.Subject__c = 'updated';
        externalRequest.Reference_ID__c = '300-512';
        update externalRequest;
        
        External_Request_Comments__c comment = new External_Request_Comments__c();
        comment.ParentId__c = externalRequest.Id;
        comment.Comments__c = 'test comment' ;
        insert comment;
        
        Attachment testAttachment = new Attachment();
        testAttachment.Body = Blob.valueOf('Test Data'); 
        testAttachment.ParentId = externalRequest.Id;
        testAttachment.Name = 'Test Attachment';
        insert testAttachment;
        
        
        Test.StopTest();
     }   
  }
  static testmethod void testUpdateExternalRequest () {
    Test.StartTest();
        // querying case here as inserting account , site ,  case and then Task results in Too many SOQL exception 
        Case testCase = [select Id from Case where Status ='Open' and
                                                   Site_Association__c !=null and 
                                                   CA_Product_Controller__c!=null and 
                                                   CA_Product_Component__c!=null and 
                                                   contactId !=null and
                                                   Reason!=null and
                                                   Category__c !=null  limit 1
                        ];
        RecordType[] recordtypeList = [select id from RecordType where Name = 'Saas Ops Incident' limit 1];  
        External_RnD__c externalRequest = new External_RnD__c();
        externalRequest.Subject__c = 'test';
        externalRequest.Severity__c = '1';
        externalRequest.Priority__c = 'High';
        externalRequest.SaaS_Description__c = 'test';
        externalRequest.Due_Date__c =  system.today();
        externalRequest.SaaS_Type__c = 'SaaS Ops Incident';
        externalRequest.case__c = testCase.Id;
        externalRequest.recordtypeid = recordtypeList[0].Id;
        externalRequest.Reference_ID__c = '300-512';
        insert externalRequest;
       
        externalRequest.Priority__c = 'Low';
        externalRequest.Reference_ID__c = '300-512';
        update externalRequest;
        
   
        Test.StopTest();
  }
   static testmethod void testCancelExternalRequest () {
      Test.StartTest();
        // querying case here as inserting account , site ,  case and then Task results in Too many SOQL exception 
        Case testCase = [select Id from Case where Status ='Open' and
                                                   Site_Association__c !=null and 
                                                   CA_Product_Controller__c!=null and 
                                                   CA_Product_Component__c!=null and 
                                                   contactId !=null and
                                                   Reason!=null and
                                                   Category__c !=null  limit 1
                        ];
        RecordType[] recordtypeList = [select id from RecordType where Name = 'Saas Ops Incident' limit 1];  
        External_RnD__c externalRequest = new External_RnD__c();
        externalRequest.Subject__c = 'test';
        externalRequest.Severity__c = '1';
        externalRequest.Priority__c = 'High';
        externalRequest.SaaS_Description__c = 'test';
        externalRequest.Due_Date__c =  system.today();
        externalRequest.SaaS_Type__c = 'SaaS Ops Incident';
        externalRequest.case__c = testCase.Id; 
        externalRequest.recordtypeid = recordtypeList[0].Id; 
        externalRequest.Reference_ID__c = '300-512';
        insert externalRequest;
       
        externalRequest.SaaS_Incident_Status__c = 'Cancelled';
        externalRequest.Reference_ID__c = '300-512';
        update externalRequest;
       
     Test.StopTest();
   }
   static testmethod void testResponse () {  
        
        String res = '{"assigneeCompany":"CA Technologies","assigneeGroup":"SaaS Service Ops","assigneeGroupId":"96","createdBy":"scintegration@rwcats.com","customField":null,"customproperties":{ "property":[ { "name":"siteAssociation__c","value":"test SA","dataType":null,"description":null,"defaultValue":null,"possibleValues":null,"isCustomproperty":null}]},"incidentId":"300-520","incidentType":null,"reportedBy":"Integration, Service Cloud"}'; 
        IncidentResponse incident = (IncidentResponse)JSON.deserialize(res, IncidentResponse.class);
        AttachmentRequest attachReq = new AttachmentRequest();
        attachReq.contentType  = 'text/JSON';
   }
}