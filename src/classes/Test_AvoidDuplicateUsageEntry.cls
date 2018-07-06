@isTest(SeeAllData=true)
private class Test_AvoidDuplicateUsageEntry {

 static testMethod void Test_AvoidDuplicateUsageEntry1() {
 
Product2 prod = new Product2(name='test prod', family='Product',Market_Focus_Area__c='RMDM');
            insert prod;
RFP__c rfp = new RFP__c(Due_Date__c= datetime.now());
    insert rfp;

  
    Response__C resp = new Response__C(Product_Search__c=prod.name,BU_Search__c = prod.Market_Focus_Area__c,ProductResp__c=prod.id);
    insert resp;
    
    List<Question__c> qlist = new List<Question__c>();
    
    // Trigger Test: Create a duplicate usage entry
    Question__c u = new Question__c();
    u.Override_Warning__c = false;
    u.Question__c = 'Test Question';
    u.Original_Response__c = false;
    u.Response__c =resp.id ;
    u.RFP__c = rfp.id;
    qlist.add(u);
    
    Question__c u1 = new Question__c();
    u1.Override_Warning__c = false;
    u1.Question__c = 'Test Question';
    u1.Original_Response__c = false;
    u1.Response__c =resp.id ;
    u1.RFP__c = rfp.id;
    qlist.add(u1);
    
    insert qlist;
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        
        User usr = new User(Alias = 'testign', Email='test123_000@ca.com', 
        EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='test123_000@ca.com');
        insert usr;
        
    test.starttest();
    System.runas(usr){
    Question__c u2 = new Question__c();
    u2.Override_Warning__c = false;
    u2.Question__c = 'Test Question';
    u2.Original_Response__c = false;
    u2.Response__c =resp.id ;
    u2.RFP__c = rfp.id;
    insert u2;
    }
    
    
    test.stoptest();
    
    
    }
    }