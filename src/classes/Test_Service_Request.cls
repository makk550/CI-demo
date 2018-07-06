@isTest
public class Test_Service_Request{
    
    static testMethod void Test_Service_Request() {
        
        testOpportunityTriggersClass.createNewOpportunity();
        Opportunity opp = [select Id from Opportunity limit 1];
        
        Service_Request src = new Service_Request(new ApexPages.StandardController(opp));        
        src.ApplySelection();                
        Service_Request src2 = new Service_Request(new ApexPages.StandardController(new Opportunity()));        
        src2.ApplySelection();
        Site_Association__c srObj1 = new Site_Association__c();
        srObj1.Name = 'test srObj1';
        srObj1.Account_Group__c = 'Z00';
        srObj1.Country_picklist__c= 'US - UNITED STATES';
        srObj1.State__c='New York';
        srObj1.City__c ='Austin';
        srObj1.SC_SITE_Source__c = 'Sales';
        srObj1.ProviSite__c = 1;
        insert srObj1;
        Site_Association__c siteAsso = [Select id from Site_Association__c LIMIT 1];                
        if(siteAsso <> null)
        {
            Services_Request__c sr = [Select id, Services_Request_Status__c from Services_Request__c where Services_Request_Status__c != 'DDR Creation' limit 1];        
            if(sr <> null){ 
                try{
                    sr.Services_Request_Status__c = 'DDR Creation';
                    sr.Ship_To__c='test';
                    sr.Ship_To_Site__c=siteAsso.Id; 
                    sr.Sold_To_Site__c=siteAsso.Id; 
                    sr.Sold_To__c='test';
                    sr.Bill_To__c='test';       
                    update sr;
                }
                catch(Exception e){}
            }
        }
    }
}