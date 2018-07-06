@isTest
private class testVOppPipelineReportHelper_4_0Momentum {

    public static testMethod void myUnitTestRegion() {
    
       VOppPipelineReportHelper_4_0Momentum core = new VOppPipelineReportHelper_4_0Momentum();
       List<String> regionlst = new List<String>();
       List<OppPipelineBean> bean = new List<OppPipelineBean>();
       List<OppPipelineBean> beanLost = new List<OppPipelineBean>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       regionlst.add('NA');
       regionlst.add('EMEA');
       
       //Start Insert Test Data
       List<Pipeline_Report__c> pipeLst = new List<Pipeline_Report__c>();
       List<Pipeline_Report_Mapping__c> pipeLstMap = new List<Pipeline_Report_Mapping__c>();
    
       Integer count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report_Mapping__c pipemap = new Pipeline_Report_Mapping__c();
            pipemap.OwnerId = users[0].Id;
            pipemap.Data_Pull_Date__c = 20090402;
            pipemap.Report_Name__c = '4.1.2';
            pipemap.Region__c = r;
            if(r=='NA')
             pipemap.Area__c = 'CANADA';   
            else
             pipemap.Area__c = 'France';
            if(r=='NA')
             pipemap.Territory_Country__c = 'CANADA';  
            else
             pipemap.Territory_Country__c = 'France';
            pipemap.Business_Unit__c = 'Application Performance Management';
            pipemap.NCV_Driver_6__c = 'Customer Experience Manager';
            pipemap.Q1_Opp_Count__c = 2*count;  
			pipemap.Q1_Opp_Amount__c = 200*count;
			pipemap.Q2_Opp_Count__c = 4*count;
			pipemap.Q2_Opp_Amount__c = 400*count;
			pipemap.Q3_Opp_Count__c =  6*count;
			pipemap.Q3_Opp_Amount__c = 600*count;
			pipemap.Q4_Opp_Count__c = 8*count;
			pipemap.Q4_Opp_Amount__c = 800*count;            
            pipeLstMap.add(pipemap);                  
           }
            count++;    
       }while(count < 3);
       
       count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report_Mapping__c pipemap = new Pipeline_Report_Mapping__c();
            pipemap.OwnerId = users[0].Id;
            pipemap.Data_Pull_Date__c = 20090402;
            pipemap.Report_Name__c = '4.1.2';
            pipemap.Region__c = r;
            if(r=='NA')
             pipemap.Area__c = 'CANADA';   
            else
             pipemap.Area__c = 'France';
            if(r=='NA')
             pipemap.Territory_Country__c = 'CANADA';  
            else
             pipemap.Territory_Country__c = 'France';
            pipemap.Business_Unit__c = 'AUTOMATION';
            pipemap.NCV_Driver_6__c = 'AUTOMATION OTHER';
            pipemap.Q1_Opp_Count__c = 2*count;  
			pipemap.Q1_Opp_Amount__c = 200*count;
			pipemap.Q2_Opp_Count__c = 4*count;
			pipemap.Q2_Opp_Amount__c = 400*count;
			pipemap.Q3_Opp_Count__c =  6*count;
			pipemap.Q3_Opp_Amount__c = 600*count;
			pipemap.Q4_Opp_Count__c = 8*count;
			pipemap.Q4_Opp_Amount__c = 800*count;            
            pipeLstMap.add(pipemap);                  
           }
            count++;    
       }while(count < 3);
       
       count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report_Mapping__c pipemap = new Pipeline_Report_Mapping__c();
            pipemap.OwnerId = users[0].Id;
            pipemap.Data_Pull_Date__c = 20090402;
            pipemap.Report_Name__c = '4.5';
            pipemap.Region__c = r;
            if(r=='NA')
             pipemap.Area__c = 'CANADA';   
            else
             pipemap.Area__c = 'France';
            if(r=='NA')
             pipemap.Territory_Country__c = 'CANADA';  
            else
             pipemap.Territory_Country__c = 'France';
            pipemap.Business_Unit__c = 'AUTOMATION';
            pipemap.NCV_Driver_6__c = 'AUTOMATION OTHER';
            pipemap.Q1_Opp_Count__c = 2*count;  
			pipemap.Q1_Opp_Amount__c = 200*count;
			pipemap.Q2_Opp_Count__c = 4*count;
			pipemap.Q2_Opp_Amount__c = 400*count;
			pipemap.Q3_Opp_Count__c =  6*count;
			pipemap.Q3_Opp_Amount__c = 600*count;
			pipemap.Q4_Opp_Count__c = 8*count;
			pipemap.Q4_Opp_Amount__c = 800*count;            
            pipeLstMap.add(pipemap);                  
           }
            count++;    
       }while(count < 3);
       
       Pipeline_Report_Mapping__c pipemap1 = new Pipeline_Report_Mapping__c();
       pipemap1.OwnerId = users[0].Id;
       pipemap1.Data_Pull_Date__c = 20090402;
	   pipemap1.Report_Name__c = '4.6';
	   pipemap1.Region__c = 'NA';
       if(pipemap1.Region__c=='NA')
        pipemap1.Area__c = 'CANADA';   
       else
        pipemap1.Area__c = 'France';
       if(pipemap1.Region__c=='NA')
        pipemap1.Territory_Country__c = 'CANADA';  
       else
        pipemap1.Territory_Country__c = 'France';
	   pipemap1.APPLICATION_PERFORMANCE_MANAGEMENT__c = 2000; 
	   pipemap1.AUTOMATION__c = 100;
	   pipemap1.BUSINESS_GOVERNANCE__c = 200; 
	   pipemap1.INFRASTRUCTURE_MANAGEMENT__c = 300; 
	   pipemap1.IT_GOVERNANCE__c = 200;
	   pipemap1.SECURITY__c = 108;
	   pipemap1.SERVICE_MANAGEMENT__c = 106; 
	   pipemap1.MAINFRAME__c = 221;
	   pipemap1.Win_Loss_Reason__c = '30%';
		
	   pipeLstMap.add(pipemap1);
       
       Pipeline_Report_Mapping__c pipemap2 = new Pipeline_Report_Mapping__c();
       pipemap2.OwnerId = users[0].Id;
       pipemap2.Data_Pull_Date__c = 20090402;
	   pipemap2.Report_Name__c = '4.6';
	   pipemap2.Region__c = 'NA';
       if(pipemap2.Region__c=='NA')
        pipemap2.Area__c = 'CANADA';   
       else
        pipemap2.Area__c = 'France';
       if(pipemap2.Region__c=='NA')
        pipemap2.Territory_Country__c = 'CANADA';  
       else
        pipemap2.Territory_Country__c = 'France';
	   pipemap2.APPLICATION_PERFORMANCE_MANAGEMENT__c = 2000; 
	   pipemap2.AUTOMATION__c = 100;
	   pipemap2.BUSINESS_GOVERNANCE__c = 200; 
	   pipemap2.INFRASTRUCTURE_MANAGEMENT__c = 300; 
	   pipemap2.IT_GOVERNANCE__c = 200;
	   pipemap2.SECURITY__c = 108;
	   pipemap2.SERVICE_MANAGEMENT__c = 106; 
	   pipemap2.MAINFRAME__c = 221;
	   pipemap2.Win_Loss_Reason__c = 'Duplicate';
		
	   pipeLstMap.add(pipemap2);
       
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
           core.getAreaItems();
           core.getRegionItems();
           core.getTerritoryItems();
           core.getFieldItems();
           core.populateFieldList();
           core.selectedDate = 'Thu, Apr 2, 09';
           core.selectedField = 'Region';
           core.getRegionItems();          
           core.selectedRegion = regionlst;
           core.setSelectedDate(core.selectedDate);
           core.setSelectedRegion(core.selectedRegion);
           core.populateFieldList();
           core.populateData();
           bean = core.getOppNewPipeLineBeanForBU();
           beanLost = core.getOppLostPipeLineBeanForRegion();
           for(OppPipelineBean b : bean)
           {
            System.debug(b.getRegion());
            System.debug(b.getTotalPriceQualiPipelines());
            System.debug(b.getTotalPriceActivePipelines());
            System.debug(b.getTotalPriceStalledPipelines());
            System.debug(b.getTotalPriceCriticalPipelines());
            System.debug(b.getPercentNotActivePipelines());
           }
           for(OppPipelineBean b1 : beanLost)
           {
            System.debug(b1.getRegion());
            System.debug(b1.getTotalQ1PricePipelines());
            System.debug(b1.getTotalQ2PricePipelines());
            System.debug(b1.getTotalQ3PricePipelines());
            System.debug(b1.getTotalQ4PricePipelines());
            System.debug(b1.getTotalQ1CountPipelines());
            System.debug(b1.getTotalQ2CountPipelines());
            System.debug(b1.getTotalQ3CountPipelines());
            System.debug(b1.getTotalQ4CountPipelines());            
           }
       }
       Test.stopTest();    
       
       	
    }
}