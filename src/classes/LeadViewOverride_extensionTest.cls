@isTest(seealldata=true)
public class LeadViewOverride_extensionTest {
    public static LeadViewOverride_extension ext;
    public static Lead ld;
    public static PageReference pref;
    public static User partnerUser1;
    
    static{
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner User with Funds Mgmt'];
        
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';
        ac.Account_Type__c='Reseller';
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getResellerDistRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        ac.Velocity_Seller_CAM_PMFKey__c='NAPMFS';
        
        
        ac.Solution_Provider_CAM_PMFKey__c='BOYAL01';
        ac.Solution_Provider__c=true;
        
        ac.Country_Picklist__c='US - UNITED STATES';
        ac.Solution_Provider_Type__c='Reseller';
        ac.Solution_Provider_Program_Level__c='Global';
        ac.Solution_Provider_Designation__c='Partner of Franchisee';
        insert ac;
        
        
        Contact contactacct =[SELECT AccountId,ID,Account.Account_Type__c FROM Contact WHERE Is_Partner_Acc__c = 'true' and Account.Account_Type__c='Reseller' LIMIT 1];
        Contact con = new Contact();        
        con.LastName='trail';
        con.FirstName='try';
        con.Active_User__c=true;
        con.email='trytest@gg.com';
        con.Country_Picklist__c='DZ - ALGERIA';        
        con.AccountId=contactacct.AccountId;
        
        insert con;
        
        partnerUser1 = new User(alias = 'test123', email='test1234@noemail.com',
                                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
                                ContactId = con.Id,
                                timezonesidkey='America/Los_Angeles', username='testersd@noemail.com',FirstName='partne');
        insert partnerUser1;
        
        system.runAs(partnerUser1){
            
            Contact_Relationship__c  contactReal=new Contact_Relationship__c (Contact__c =con.id,CA_User__c=partnerUser1.id,StrengthOfRelationship__c='0 - Non scored',active__c=true);
            insert contactReal;
        }
    }
    
    public static void init(){
        ld = new Lead();
        ld.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('CA Global Lead').getRecordTypeId();
        ld.LastName = 'TestLead';
        ld.Company = 'ABC';
        ld.Status = 'New';
        ld.Partnerleadprocessed__c = true;
        insert ld;
        
        pref = Page.LeadViewOverride;
        pref.getParameters().put('id',ld.id);
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController con = new ApexPages.StandardController(ld);
        ext = new LeadViewOverride_extension(con);        
    }
    
       
    
    @isTest
    public static void testController2(){
		init();
        ext.LeadId = null;
		ext.leadRec.Partnerleadprocessed__c = false;
		Test.startTest();
		ext.Marketing_Nurture();        
    }
    
    @isTest
    public static void testController(){
        init();
        
        Test.startTest();
        ext.Marketing_Nurture();
        ext.partnerProfile = false;
        ext.selectedStatusReason = 'Test';
        ext.ispowerpartner = true;
        ext.covertIndirect();
        ext.closePopup();
        ext.showPopup();
        Test.stopTest();
        
    }
}