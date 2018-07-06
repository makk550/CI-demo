@isTest(seeAllData=true)
public class Usage_Data_Test{
    
    private static Account createAccount(){
        
        Account acc=new account(name='test account',Solution_Provider_Program_Level__c='Member',Billingstreet='s',Billingcity='c',Billingstate='US',Solution_Provider__c = true,GU_DUNS_NUMBER__c='791312069',GU_NAME__c='test tree');
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Team Covered Account').getRecordTypeId();
        insert acc;
        return acc;
    }
    
    @isTest
    static void testControllerWithNoParameters(){
    
        Test.startTest();
        
            Test.setCurrentPage(Page.Usage_Data);
            UsageData_Ctrl controller = new UsageData_Ctrl();
            
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
        
        	for(Apexpages.Message msg:msgs){
                if (msg.getDetail().contains('There is no instance ID associated') || msg.getDetail().contains('There is no Product instance ID associated')){
                	b = true;    
                } 
            }
        Test.stopTest();
        system.assertEquals(true,b);
    }
    
    @isTest
    static void testControllerWithParameters(){
        
        Test.startTest();
            Account testAccount = createAccount();
        
            PageReference pageRef = Page.Usage_Data;
            pageRef.getParameters().put('accName',testAccount.Name);
            pageRef.getParameters().put('instance','I0040238039000050nXhtzvwX7jQNmozrdRFDbm');
            pageRef.getParameters().put('prod_instance','34879');
        
            Test.setCurrentPage(pageRef);
            
            UsageData_Ctrl controller = new UsageData_Ctrl();
            
            controller.externalData();
            controller.redirectBack();
                    
        Test.stopTest();
    
    }
    
}