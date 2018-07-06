@isTest(seeAllData = true)
public class DealLinkgenerateControllerTest {
     public static User createPartnerUser(){        
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner User with Sales Tools'];
                
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.BillingState = 'NY';   
        ac.Customer_Category__c = 'Enterprise';   
        ac.GEO__c='NA';
        ac.Enterprise_ID__c = '1234te';       
        ac.Enterprise_Account_Name__c = 'rdName';
        ac.RecordTypeId =SystemIdUtility.getTerritoryAcctRecordTypeId();
        ac.Commercial_ID__c = 'asdf';
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id,Email='test123@noemail.com');
        insert con; 
        
        User partnerUser = new User(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8',
                                    lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                    profileid = p.Id, country='United States',IsActive =true,ContactId = con.Id,
                                    timezonesidkey='America/Los_Angeles', username='tester1234@noemail.com',firstName= 'test');
        
        try{
            insert partnerUser;
        }
        catch(exception e){
            
        }
        return partnerUser;        
    }
    static testMethod void testDealLinkgenerateController(){
        User pUser = DealLinkgenerateControllerTest.createPartnerUser();
        System.runAs(pUser){
           DealLinkgenerateController objd=new DealLinkgenerateController();
            String re=objd.getGeneratedLink();
        }
        DealLinkgenerateController obj=new DealLinkgenerateController();
            String res=obj.getGeneratedLink();
    }
}