@isTest(SeeAllData=true)   
private class Test_CAResellContactSearchCls {
    static testMethod void testCAResellContactSearch() 
    {      
      RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('SMB');
      System.debug('__________SMB'+rec );
      Id accRecordTypeId = rec.RecordType_Id__c;
    
      List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];
                                             
      Account smbAccount = new Account();
      smbAccount.Name = 'TestSMBAccount';
      smbAccount.RecordTypeId = accRecordTypeId;
      smbAccount.OwnerId = approvers[0].Id;
      smbAccount.BillingStreet = 'Arlington';
      smbAccount.BillingCountry = 'US';
      smbAccount.BillingCity = 'VA';
      insert smbAccount;
        
      PageReference pageRef = Page.CAResellContactSearch; 
      Test.setCurrentPage(pageRef);    
      ApexPages.currentPage().getParameters().put('accId',smbAccount.Id);   
      CAResellContactSearch objSearch = new CAResellContactSearch();
     
        Account acc = [SELECT Id FROM Account WHERE RecordType.Name ='SMB' LIMIT 1];
        objSearch.firstName = 'test';
        objSearch.lastName = 'test';        
        objSearch.email = 'test@ca.com';
        objSearch.title = 'test';
        objSearch.functionalRole = 'test';
        objSearch.phone = '132345'; 
        objSearch.mobile = '123254';
        objSearch.fax = '232344';
        objSearch.endUserAccountId = smbAccount.Id;
        objSearch.CreateContact();
        objSearch.getfunctionalRoles();
        objSearch.SearchContacts();
        objSearch.showCreateContact();
    }
}