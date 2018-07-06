@isTest
private class PartnerLeadDistributionBatch_Test {
    
    @testsetup
    static void createLead(){
        
        SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Group grp=new Group(Type = 'Queue',Name = 'Partner Lead Distribution');
        insert grp;  
        QueueSobject mappingObject = new QueueSobject(QueueId = grp.Id, SobjectType = 'Lead');
        System.runAs(new User(Id = UserInfo.getUserId()))
        {insert mappingObject;}
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        // id res = accRecType.get('CA Enterprise Account').getRecordTypeId();
        account a = new account(name ='Test Account', recordtypeid =res);
        
        a.Region_Country__c='xxx';
        
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'USA';
        a.GEO__c= 'NA';
        a.Sales_Area__c= 'America';
        a.Sales_Region__c= 'America';
        a.Segment__c='xxx';
        
        insert a;
        system.assertNotEquals(null, a.id, 'Account not inserted');
        
        
        Schema.DescribeSObjectResult leadresult = Schema.SObjectType.Lead;        
        Map<String,Schema.RecordTypeInfo> leadRecType = leadresult.getRecordTypeInfosByName(); 
        Id CaIndirectLeadrecType = leadRecType.get('CA Indirect Lead').getRecordTypeId();
        
        RecordTypes_Setting__c rec = new RecordTypes_Setting__c();
        rec.SObject_Name__c = 'Lead';
        rec.RecordType_Id__c = String.valueOf(CaIndirectLeadrecType);
        rec.Name = 'CA Indirect Lead';
        insert rec;
        
        List<Lead> lstLead = new List<Lead>();       
        for(Integer i = 0 ; i<2 ; i++) {
            lead ld=new Lead(lastName = 'testLName'+i ,
                             Company = 'Salesforce',
                             RecordTypeId=CaIndirectLeadrecType,
                             EAID__c='L098704', 
                             Commercial_Account__c=a.id, 
                             mkto71_Lead_Score__c=45, 
                             CSU_Driver__c='API Gateway',
                             OwnerId=grp.id);
            
            lstLead.add(ld);
        }
        insert lstLead ;
    }
    
    static testMethod void testMethod1() 
    {
        
        Test.startTest();
        
        PartnerLeadDistributionBatch obj = new PartnerLeadDistributionBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}