@isTest(SeeAllData=true)
private class Accreditation_Test 
{
    static testMethod void validateAccreditationFieldUpdateLogic()
    {
        // insert account
        Account acc = new Account(name='test account', RecordTypeId=SystemIdUtility.getAccountTeamAcctRecordTypeId());
        insert acc;
        
        // insert contact
        Contact c= new Contact(firstName='test', lastName='contact', accountId=acc.Id);
        insert c;
        
        // insert product
        Product2 prod = new Product2(Name='test product', CSU2__c='test CSU2', Product_Group__c='test product group');
        insert prod;
        
        // insert product material
        Product_Material__c pm = new Product_Material__c(Name='p123', Product__c=prod.Id, Material_Text__c='test material text');
        insert pm;
        
        // insert accreditations
        List<Accreditation__c> accreds = new List<Accreditation__c>();
        
        for(Integer i=0; i<201; i++)    
        	accreds.add(new Accreditation__c(Course_Number__c='p123'));
        
        insert accreds;
        
        // assert all the accreditations were inserted and processed properly
        System.assertEquals(201, [SELECT Count() FROM Accreditation__c WHERE (Id IN :accreds) 
                                  					and Product_Material__c = :pm.Id 
                                  					and Product__c = :pm.Material_Text__c
                                 					and CSU2__c = :prod.CSU2__c
                                 					and Product_Group_MPL__c = :prod.Product_Group__c]);
        
        // test and assert the course not found case
        for(Accreditation__c accred : accreds)
            accred.course_number__c='Not a Course Number';
        
        update accreds;
        
        System.assertEquals(201, [SELECT Count() FROM Accreditation__c WHERE (Id IN :accreds) 
                                  					and Product_Material__c = null
                                  					and Product__c = null
                                 					and CSU2__c = null
                                 					and Product_Group_MPL__c = null]);
	}
    
}