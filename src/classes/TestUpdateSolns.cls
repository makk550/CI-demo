@isTest
private class TestUpdateSolns {

 private static testmethod void testProdAllignmentPL()
 {
    RecordTypes_Setting__c rec1 = new RecordTypes_Setting__c(Name = 'SMB', SObject_Name__c = 'Account', RecordType_Id__c = '01230000001L55jAAC');
    insert rec1;
    
    RecordTypes_Setting__c rec2 = new RecordTypes_Setting__c(Name = 'Territory Covered Account', SObject_Name__c = 'Account', RecordType_Id__c = '01230000001L55o');
    insert rec2;

    RecordTypes_Setting__c rec3 = new RecordTypes_Setting__c(Name = 'Account Team Covered Account', SObject_Name__c = 'Account', RecordType_Id__c = '01230000001L55e');
    insert rec3;
    
    RecordTypes_Setting__c rec4 = new RecordTypes_Setting__c(Name = 'Reseller/Distributor Account', SObject_Name__c = 'Account', RecordType_Id__c = '01230000000GaFd');
    insert rec4;
    
    RecordTypes_Setting__c Opprec1 = new RecordTypes_Setting__c(Name = 'New Opportunity', SObject_Name__c = 'Opportunity', RecordType_Id__c = '01230000000cohD');
    insert Opprec1;
    
    RecordTypes_Setting__c Opprec2 = new RecordTypes_Setting__c(Name = 'Acquisition', SObject_Name__c = 'Opportunity', RecordType_Id__c = '012300000013vtw');
    insert Opprec2;
    
    RecordTypes_Setting__c Opprec3 = new RecordTypes_Setting__c(Name = 'Deal Registration', SObject_Name__c = 'Opportunity', RecordType_Id__c = '01230000000yspg');
    insert Opprec3;
    
    RecordTypes_Setting__c Opprec4 = new RecordTypes_Setting__c(Name = 'Partner Opportunity', SObject_Name__c = 'Opportunity', RecordType_Id__c = '01230000001L5hW');
    insert Opprec4;
  
    RecordTypes_Setting__c rec5 = new RecordTypes_Setting__c(Name = 'Commercial Account', SObject_Name__c = 'Account', RecordType_Id__c = '01230000000GaFY');
    insert rec5;
    
    RecordTypes_Setting__c rec6 = new RecordTypes_Setting__c(Name = 'CA Enterprise Account', SObject_Name__c = 'Account', RecordType_Id__c = '01230000000DNfM');
    insert rec6;
    
    //Insert Account
    Account acc = new Account();
    acc.Name = 'Partner test acc';
    acc.BillingState = 'NY';
    acc.Region_Country__c = 'JP';
    acc.Alliance__c = true;
    acc.Alliance_Program_Level__c = 'Advanced';
    acc.Service_Provider__c = true;
    acc.Service_Provider_Program_level__c = 'Advanced';
    acc.Solution_Provider__c = true;
    acc.Solution_Provider_Program_Level__c = 'Advanced';
    acc.Velocity_Seller__c = true;
    acc.Velocity_Seller_Program_Level__c = 'Advanced';
    acc.Commercial_Id__c = 'asdf';
    acc.BillingStreet='Street';
    acc.BillingCountry='US';
    acc.BillingCity='New York';
    insert acc;
    
    Account acc1 = new Account();
    acc1.Name = 'Partner test acc111';
    acc1.BillingState = 'NY';
    acc1.Region_Country__c = 'IN';
    acc1.Alliance__c = true;
    acc1.Alliance_Program_Level__c = 'Premier';
    acc1.Service_Provider__c = true;
    acc1.Service_Provider_Program_level__c = 'Premier';
    acc1.Solution_Provider__c = true;
    acc1.Solution_Provider_Program_Level__c = 'Premier';
    acc1.Velocity_Seller__c = true;
    acc1.Velocity_Seller_Program_Level__c = 'Advanced';
    acc1.Commercial_Id__c = 'asdf';
    acc1.BillingStreet='Street';
    acc1.BillingCountry='US';
    acc1.BillingCity='New York';
    insert acc1;
    
    //create new product
    Product2 newProduct=new Product2();     
    newProduct.IsActive=true;
    newProduct.Name='test Product';
    newProduct.PRODUCT_BASE_NAME_C__c='test Product';
    newProduct.PRODUCT_SUBTYPE_C__c ='NEW';
    newProduct.Product_Group__c = 'Clarity';
    insert newProduct;
    
    Product2 newProduct1=new Product2();     
    newProduct1.IsActive=true;
    newProduct1.Name='test Product';
    newProduct1.PRODUCT_BASE_NAME_C__c='test Product111';
    newProduct1.PRODUCT_SUBTYPE_C__c ='NEW';
    newProduct1.Product_Group__c = 'Agile Vision';
    insert newProduct1;
    
    User[] users = [select id from user where ContactId = null and isactive = true and PMFKey__c != null  limit 1];

    Contact testContact = new Contact();
    testContact.FirstName = 'test';
    testContact.LastName = 'contact';
    testContact.AccountId = acc.Id;
    testContact.email = 'testca@ca.com';
    testContact.OwnerId = '00530000006bR89AAE';
    testContact.RTM__c = 'Other';
    insert testContact;
    
    Route_To_Market__c rtm = new Route_To_Market__c();
    rtm.Account__c = acc.Id;
    rtm.RTM__c = 'Other';
    insert rtm;
        
    ///for After Insert Trigger
    Product_Alignment__c  objPAl0 = new Product_Alignment__c(Product_Group_MPL__c='TestSiteMinder',Related_Account__c=acc.id,Partner_Approved__c=true,Authorized_Agreement__c=true,Route_To_Market__c=rtm.id,Product_Group__c='Clarity',Product__c=newProduct.id);
    Product_Alignment__c  objPAl1 = new Product_Alignment__c(Product_Group_MPL__c='TestSiteMinder',Related_Account__c=acc.id,Partner_Approved__c=true,Authorized_Agreement__c=true,Route_To_Market__c=rtm.id,Product_Group__c='Agile Vision',Product__c=newProduct1.id);
    Product_Alignment__c  objPAl2 = new Product_Alignment__c(Product_Group_MPL__c='TestSiteMinder',Related_Account__c=acc1.id,Partner_Approved__c=true,Authorized_Agreement__c=true,Route_To_Market__c=rtm.id,Product_Group__c='Agile Vision',Product__c=newProduct1.id);
    insert objPAl0;
    insert objPAl1;
    insert objPAl2;
    
    //insert Partner_Location__c
    Partner_Location__c sobj = new Partner_Location__c();
        sobj.Name = 'test';
        sobj.Account__c = acc.id;
        sobj.Latitude__c = 5.5;
        sobj.Longitude__c = 4.4;
        sobj.Street__c = '123 Main';
        sobj.City__c = 'New York';
        sobj.State_Province__c = 'NY';
        sobj.Postal_Code__c = '10001';
        sobj.Country__c = 'UNITED STATES';
        sobj.Point_of_Contact_Email__c = 'testca@ca.com';
        //sobj.Route_To_Market__c = 'Alliance';
        insert sobj;
    
 }
}