@isTest
private class testVOppPipelineReportHelper_4_7Momentum {

    static testMethod void myUnitTestRegion() 
    {
       VOppPipelineReportHelper_4_7Momentum core = new VOppPipelineReportHelper_4_7Momentum();
       List<String> regionlst = new List<String>();
       List<OppPipelineBean> bean = new List<OppPipelineBean>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       regionlst.add('NA');
       regionlst.add('EMEA');
       
       //Start Insert Test Data
       List<Pipeline_Report__c> pipeLst = new List<Pipeline_Report__c>();
       List<Pipeline_Report_Mapping__c> pipeLstMap = new List<Pipeline_Report_Mapping__c>();
    
       Pipeline_Report_Mapping__c p = new Pipeline_Report_Mapping__c();
       p.OwnerId = users[0].Id;
       p.Data_Pull_Date__c = 20090402;
       p.Report_Name__c = '4.7';
	   p.Milestone__c = '30%'; 
	   p.Opt_beginning_qtr__c =200; 
	   p.X30_Milestone__c = 201;
	   p.X50_Milestone__c = 202;
	   p.X70_Milestone__c = 203;
	   p.X90_Milestone__c = 204;
	   p.X100_Milestone__c = 205;
	   p.Lost_Milestone__c = 206;            
       pipeLstMap.add(p);                  
       
       Pipeline_Report_Mapping__c p1 = new Pipeline_Report_Mapping__c();
       p1.OwnerId = users[0].Id;
       p1.Data_Pull_Date__c = 20090402;
       p1.Report_Name__c = '4.7';
	   p1.Milestone__c = '100'; 
	   p1.Opt_beginning_qtr__c =200; 
	   p1.X30_Milestone__c = 201;
	   p1.X50_Milestone__c = 202;
	   p1.X70_Milestone__c = 203;
	   p1.X90_Milestone__c = 204;
	   p1.X100_Milestone__c = 205;
	   p1.Lost_Milestone__c = 206;            
       pipeLstMap.add(p1);
    
       Pipeline_Report__c pdt = new Pipeline_Report__c();
       pdt.OwnerId = users[0].Id;
       pdt.Data_Pull_Date__c = 20090402;
       pdt.Report_Name__c = 'DatePull';
       pipeLst.add(pdt);                          
       insert pipeLst;
       insert pipeLstMap;
       // End Insert Test Data
       Test.startTest();
       System.runAs(users[0]) 
       {
           core.getDateItems();
           core.selectedDate = 'Thu, Apr 2, 09';
           core.setSelectedDate(core.selectedDate);
           core.populateData();           
       }
       Test.stopTest();
    }
}