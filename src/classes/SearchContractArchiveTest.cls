@isTest
private class SearchContractArchiveTest {

    static testmethod void testCallout(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SearchContractArchiveTestMockResponse');
        mock.setStatusCode(200);
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result = SearchContractArchiveController.getResource('https://s3.amazonaws.com/soap');
        System.assertEquals('MockResponseSent',result.getBody());
    }
    
    // With Custom Setting data
    static testmethod void testSearch(){
    // Create a Custom Setting record
        AWS_credentials__c credentials = new AWS_credentials__c();
        credentials.Name = 'Contract Archival';
        credentials.key__c = 'AKIAJVNZUD4UDKZB2OPA';
        credentials.secret__c = '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';
        insert credentials;
            
        String filename = 'TestFile';
        SearchContractArchiveController.search(filename);
    }

    // Without Custom Setting data
    static testmethod void testSearchWithoutData(){
        String filename = 'TestFile';
        SearchContractArchiveController.search(filename);
    }

}