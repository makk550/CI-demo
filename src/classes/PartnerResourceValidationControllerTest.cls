@isTest
public class PartnerResourceValidationControllerTest {
    
    @isTest(seeAllData=true)
    static void testPrvController(){
    	
	        Partner_Resource_Validation__c prv = new Partner_Resource_Validation__c();	        
	        ApexPages.StandardController sc = new ApexPages.standardController(prv);
	        PartnerResourceValidationController ctrlr = new PartnerResourceValidationController(sc);
        
	        //Insert a Partner Account with record typr Reseller/DistributionLayout
	        Id recordTypeId ;
	        List<RecordType> recTypeList  = [select id from RecordType where name = 'Reseller/Distributor Account'];
	        if(!recTypeList.isEmpty()){
	            recordTypeId = recTypeList[0].Id;
	        }
	        
	        Account a = new Account(name='test account',recordtypeid = recordTypeId);
	        a.customer_Category__c= 'AAM';
	        a.Commercial_Account_Name__c='test 11111114'  ;
	        a.Commercial_ID__c= 'test 11111115';
	        a.Country_Picklist__c= 'JP - JAPAN';
	        a.GEO__c= 'JAPAN';
	        a.Sales_Area__c= 'JAPAN';
	        a.Sales_Region__c= 'JAPAN';
	        a.Billingstate= 'A';
	        a.Billingcity= 'B';
	        a.Billingstreet= 'C';
	        insert a;
	        
	        Contact c = new Contact(FirstName = 'testContact',LastName = 'test', AccountId = a.id);
	        insert c;
	         
	        prv.Partner__c = a.Id;
	        prv.Partner_Resource__c = c.Id;	        
	        
	        List<SelectOption> vtypeList = ctrlr.getValidationTypes();
	        prv.Validation_Type__c = String.valueOf(vtypeList[0].getValue());
            ctrlr.getvtypeDesc();
	        
	        List<SelectOption> pgList = ctrlr.getProductGroups(); 
	        if(pgList.size()>1)        	
	        	prv.Product_Group__c = String.valueOf(pgList[1].getValue());
	        
	        System.debug('prv.Validation_Type__c:'+prv.Validation_Type__c);
	        System.debug('prv.Product_Group__c:'+prv.Product_Group__c);
	        
	        ctrlr.populateValidationCode();
	        ctrlr.performValidations();
	        PartnerResourceValidationController.populateLDAPID(prv);        
	        ctrlr.Save();	
        	
        	ctrlr.resetPG();
        	ctrlr.Save();
        
    	}    	
}