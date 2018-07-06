@isTest
private class testVOppPipelineReportHelper_1_0Core {

    public static testMethod void myUnitTestRegion() {
       
       VOppPipelineReportHelper_1_0Core core = new VOppPipelineReportHelper_1_0Core();
       List<OppPipelineBean> bean = new List<OppPipelineBean>();
       List<String> regionlst = new List<String>();
       
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       regionlst.add('NA');
       regionlst.add('LA');
       
       System.debug('Print User ID: '+users[0].Id);

       //Start Insert Test Data
       List<Pipeline_Report__c> pipeLst = new List<Pipeline_Report__c>();
       for(String r : regionlst)
       {
        Pipeline_Report__c pipe = new Pipeline_Report__c();
        pipe.OwnerId = users[0].Id;
        pipe.Data_Pull_Date__c = 20090402;
        pipe.Report_Name__c = '1.0 Core';
        pipe.Region__c = r;
        if(r=='NA')
         pipe.Area__c = 'CANADA';   
        else
         pipe.Area__c = 'France';
        if(r=='NA')
         pipe.Territory_Country__c = 'CANADA';  
        else
         pipe.Territory_Country__c = 'France';
        pipe.Business_Unit__c = 'Application Performance Management';
        pipe.NCV_Driver_6__c = 'Customer Experience Manager';
        pipe.Qualified_Pipeline_Amount__c = 12459;
        pipe.Qualified_Pipeline_Count__c = 50;
        pipe.Closed_Pipeline_Amount__c = 2000;
        pipe.Closed_Pipeline_Count__c = 2;
        pipe.Target__c = 20;
        
        pipeLst.add(pipe);          
       }
       
       for(String r : regionlst)
       {
        Pipeline_Report__c pipe = new Pipeline_Report__c();
        pipe.OwnerId = users[0].Id;
        pipe.Data_Pull_Date__c = 20090402;
        pipe.Report_Name__c = '1.0 Core';
        pipe.Region__c = r;
        if(r=='NA')
         pipe.Area__c = 'CANADA';   
        else
         pipe.Area__c = 'France';
        if(r=='NA')
         pipe.Territory_Country__c = 'CANADA';  
        else
         pipe.Territory_Country__c = 'France';
        pipe.Business_Unit__c = 'AUTOMATION';
        pipe.NCV_Driver_6__c = 'AUTOMATION OTHER';
        pipe.Qualified_Pipeline_Amount__c = 3000;
        pipe.Qualified_Pipeline_Count__c = 50;
        pipe.Closed_Pipeline_Amount__c = 2121;
        pipe.Closed_Pipeline_Count__c = 2;
        pipe.Target__c = 20;
        
        pipeLst.add(pipe);          
       }
       
       Pipeline_Report__c pdt = new Pipeline_Report__c();
       pdt.OwnerId = users[0].Id;
       pdt.Data_Pull_Date__c = 20090402;
       pdt.Report_Name__c = 'DatePull';
       pipeLst.add(pdt);                          
       insert pipeLst;
       
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
           core.selectedDate = 'Mon, May 4, 09';
           core.selectedField = 'Region';
           core.getRegionItems();
           core.selectedRegion = regionlst;
           core.setSelectedDate(core.selectedDate);
           core.setSelectedRegion(core.selectedRegion);
           core.populateFieldList();
           core.populateData();
           bean = core.getOppPipeLineBean();
           for(OppPipelineBean b : bean)
           {
               System.debug(b.getRegion());
               System.debug(b.getTotalPriceQualiPipelines());
               System.debug(b.getTotalPriceClosedWonPipelines());
               System.debug(b.getTotalPricePipelines());
               System.debug(b.getTotalQualiPipelines());
               System.debug(b.getTotalClosedWonPipelines());
               System.debug(b.getTotalPipelines());
               System.debug(b.getTotalPriceCommitPipelines());
               System.debug(b.getTotalPriceTargetPipelines());
               System.debug(b.getPercentCommitBudgetPipelines());
               System.debug(b.getPercentBudgetWonPipelines());
               System.debug(b.getPercentCommitWonPipelines());          
           }
           bean.clear();
           bean = core.getOppPipeLineBeanForBU();
           for(OppPipelineBean b : bean)
           {
               System.debug(b.getBu());
               System.debug(b.getNcv());
               System.debug(b.getTotalPriceQualiPipelines());
               System.debug(b.getTotalPriceClosedWonPipelines());
               System.debug(b.getTotalPricePipelines());
               System.debug(b.getTotalQualiPipelines());
               System.debug(b.getTotalClosedWonPipelines());
               System.debug(b.getTotalPipelines());
               System.debug(b.getTotalPriceTargetPipelines());     
               System.debug(b.getPercentBudgetWonPipelines());      
           }
       }
       Test.stopTest();                                
    }
    
    public static testMethod void myUnitTestArea() {
       
       VOppPipelineReportHelper_1_0Core core = new VOppPipelineReportHelper_1_0Core();
       List<String> arealst = new List<String>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       
       arealst.add('Canada');
       arealst.add('Brazil');
       
       Test.startTest();
       System.runAs(users[0]) 
       {
           core.getDateItems();
           core.getAreaItems();
           core.getRegionItems();
           core.getTerritoryItems();
           core.selectedDate = 'Thu, Apr 2, 09';
           core.selectedField = 'Area';
           core.getAreaItems();
           core.selectedArea = arealst;
           core.populateFieldList();
           core.populateData();
       }
       Test.stopTest();                                
    }
    
    public static testMethod void myUnitTestTerritory() {
       
       VOppPipelineReportHelper_1_0Core core = new VOppPipelineReportHelper_1_0Core();
       List<String> territorylst = new List<String>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       territorylst.add('Australia');
       territorylst.add('CANADA');
       Test.startTest();
       System.runAs(users[0]) 
       {
           core.getDateItems();
           core.getAreaItems();
           core.getRegionItems();
           core.getTerritoryItems();
           core.selectedDate = 'Thu, Apr 2, 09';
           core.selectedField = 'Territory';
           core.getTerritoryItems();
           core.selectedTerritory = territorylst; 
           core.populateFieldList();
           core.populateData();
       }
       Test.stopTest();                                
    }
    
    public static testMethod void myUnitTestMainHelper() {
    
    VOppPipelineMainHelper main = new VOppPipelineMainHelper();
    main.getSelectedTabName();
    }
}