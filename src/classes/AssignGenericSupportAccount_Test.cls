@isTest
public class AssignGenericSupportAccount_Test {
    @isTest static void testName() {
        Site_Association__c site=new Site_Association__c(Name= 'TECH MAHINDRA LIMITED',City__c = 'Hyderabad',Country__c = 'INDIA',Enterprise_ID__c = NULL,Postal_Code__c = '500081',Region__c = 'APJ',SAP_Site_ID__c = '2055833',Street__c = 'SEZ Unit - II, Ground Floor, 1,2, & # Floors, To',System__c = 'S',Account_Group__c = 'Z001',Area__c = 'INDIA',Confidence_Code__c = 10.00000000000000,DUNS_Name__c = 'TECH MAHINDRA BPO LIMITED',DUNS_Number__c = '918523148',GU_DUNS_NUMBER__c = '918523148',GU_NAME__c = 'TECH MAHINDRA BPO LIMITED',SICCode__c = '7374',SICDesc__c = 'Data processing and preparation',Site_Status__c = 'Pending Review',State__c = '36',Territory_Country__c = 'INDIA',Country_Picklist__c = 'IN - INDIA',GP_DUNS_NUMBER__c = '918523148',GP_NAME__c = 'TECH MAHINDRA BPO LIMITED',SC_SITE_Source__c = 'MDM',SC_TOPS_ID__c = '956501');
	try{
    	insert site;
	}
	catch(Exception e){
    System.debug('---exception=-----'+e);
	}
	System.debug('-----id-----'+site.id); 
    }
}