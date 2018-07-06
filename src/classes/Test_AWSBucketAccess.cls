/*
Created By: Tarun Sharma
Created On: 04/22/2016
Purpose: Test Class for AWS Bucket Access
Modified By:
*/
@isTest
public class Test_AWSBucketAccess{
    private static testMethod void testAWSBucketAccess(){
        createTestData();
        test.startTest();
        awsBucketAccessMockResult();
        awsBucketAccessLayer7MockResult();
        awsBucketAccessEmailMockResult();
        test.stopTest();
    }
    
    private static void createTestData(){
        AWS_Credentials__c awsCredentials = new AWS_Credentials__c();
        awsCredentials.Name = 'Case Archival';
        awsCredentials.Secret__c = 'nZOOCL0j+NDww7rfrjA0WDzkx+g9a5OTA+YHaZ/w';
        awsCredentials.Key__c = 'AKIAIXRMUKP2XKCSHNBA';
        insert awsCredentials;
    }
    
    private static void awsBucketAccessMockResult(){
        Test.setMock(HttpCalloutMock.class, new  AWSBucketAccess_MockResponse());
        AWSBucketAccess AWSBucketAccessObj = new AWSBucketAccess();
        AWSBucketAccessObj.AWSBucketAccessMethod('NIMSOFT/0000-00131072/caseDetails_00131072','','');
        AWSBucketAccessObj.AWSBucketAccessMethod('/RelatedXMLs/activityHistory.xml','NIMSOFT','00110361');
    }
    
    private static void awsBucketAccessLayer7MockResult(){
        Test.setMock(HttpCalloutMock.class, new  AWSBucketAccess_MockResponse());
        AWSBucketAccess AWSBucketAccessObj = new AWSBucketAccess();
        AWSBucketAccessObj.AWSBucketAccessMethod('Layer7/00000_caseDetails_00040377','','');
        AWSBucketAccessObj.AWSBucketAccessMethod('/RelatedXMLs/00000_ActivityHistory_00040377.xml','Layer7','00000_caseDetails_00040377');
    }
    
    private static void awsBucketAccessEmailMockResult(){
        Test.setMock(HttpCalloutMock.class, new  AWSBucketAccess_MockResponse());
        AWSBucketAccess AWSBucketAccessObj = new AWSBucketAccess();
        AWSBucketAccessObj.AWSBucketAccessMethod('Layer7/00000_caseDetails_00040377.xml','','');
        AWSBucketAccessObj.AWSBucketAccessMethod('/RelatedXMLs/00000_ActivityHistory_00040377.xml','EMAIL','00000_caseDetails_00040377');
    }
}