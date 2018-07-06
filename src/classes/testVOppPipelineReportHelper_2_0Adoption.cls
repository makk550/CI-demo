@isTest
private class testVOppPipelineReportHelper_2_0Adoption {

    public static testMethod void myUnitTestRegion() {
       
       VOppPipelineReportHelper_2_0Adoption adoption = new VOppPipelineReportHelper_2_0Adoption();
       List<String> regionlst = new List<String>();
       List<OppPipelineBean> bean = new List<OppPipelineBean>();
       List<OppPipelineBean> beanShortClose = new List<OppPipelineBean>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       regionlst.add('NA');
       regionlst.add('EMEA');
       //regionlst.add('APJ');
       
       //Start Insert Test Data
       List<Pipeline_Report__c> pipeLst = new List<Pipeline_Report__c>();
       List<Pipeline_Report_Mapping__c> pipeLstMap = new List<Pipeline_Report_Mapping__c>();
       for(String r : regionlst)
       {
        Pipeline_Report__c pipe = new Pipeline_Report__c();
        pipe.OwnerId = users[0].Id;
        pipe.Data_Pull_Date__c = 20090402;
        pipe.Report_Name__c = '2.1';
        pipe.Region__c = r;
        pipe.Active_Login__c = 23;
        pipe.Inactive_Login__c = 12;
        pipe.No_Login__c = 2;
        pipeLst.add(pipe);          
       }
       
       for(String r : regionlst)
       {
        Pipeline_Report__c pipe = new Pipeline_Report__c();
        pipe.OwnerId = users[0].Id;
        pipe.Data_Pull_Date__c = 20090402;
        pipe.Report_Name__c = '2.1';
        pipe.Region__c = r;
        pipe.Active_Login__c = 27;
        pipe.Inactive_Login__c = 33;
        pipe.No_Login__c = 37;
        pipeLst.add(pipe);          
       }
       
       Integer count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '3.1.4';
            pipe.Region__c = r;
            if(r=='NA')
             pipe.Area__c = 'CANADA';   
            else
             pipe.Area__c = 'France';
            if(r=='NA')
             pipe.Territory_Country__c = 'CANADA';  
            else
             pipe.Territory_Country__c = 'France';
            pipe.Active_Pipeline__c = 2000*count; 
            pipe.Critical_Pipeline__c =20*count;
            pipe.Stalled_Pipeline__c = 2*count;            
            pipeLst.add(pipe);          
           }
            count++;    
       }while(count < 3);
       
       count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '2.5';
            pipe.Region__c = r;
            if(r=='NA')
             pipe.Area__c = 'CANADA';   
            else
             pipe.Area__c = 'France';
            if(r=='NA')
             pipe.Territory_Country__c = 'CANADA';  
            else
             pipe.Territory_Country__c = 'France';
            pipe.Stalled_Pipeline__c = 200*count;            
            pipeLst.add(pipe);          
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
            pipemap.Report_Name__c = '2.6';
            pipemap.Region__c = r;
            if(r=='NA')
             pipemap.Area__c = 'CANADA';   
            else
             pipemap.Area__c = 'France';
            if(r=='NA')
             pipemap.Territory_Country__c = 'CANADA';  
            else
             pipemap.Territory_Country__c = 'France';
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
            pipemap.Report_Name__c = '2.7';
            pipemap.Region__c = r;
            if(r=='NA')
             pipemap.Area__c = 'CANADA';   
            else
             pipemap.Area__c = 'France';
            if(r=='NA')
             pipemap.Territory_Country__c = 'CANADA';  
            else
             pipemap.Territory_Country__c = 'France';
            pipemap.Account_Name__c = 'Test Account';
            pipemap.Account_Owner__c = 'Test Account Owner';
            pipemap.Total_Pipeline_Amount_1__c =  200*count;
            pipeLstMap.add(pipemap);          
           }
            count++;    
       }while(count < 3);
       
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
           adoption.getDateItems();
           adoption.getAreaItems();
           adoption.getRegionItems();
           adoption.getTerritoryItems();
           adoption.getFieldItems();
           adoption.populateFieldList();
           adoption.selectedDate = 'Thu, Apr 2, 09';
           //adoption.selectedDate = 'Mon, May 4, 09';
           adoption.selectedField = 'Region';
           adoption.getRegionItems();
           adoption.selectedRegion = regionlst;
           adoption.setSelectedRegion(adoption.selectedRegion);
           adoption.populateFieldList();
           adoption.populateData();
           bean = adoption.getOppPipeLineAdoptionADAM();
           for(OppPipelineBean b : bean)
           {
               System.debug(b.getRegion());
               System.debug(b.getTotalActiveLoginPipelines());
               System.debug(b.getTotalInactiveLoginPipelines());
               System.debug(b.getTotalNoLoginPipelines());
               System.debug(b.getTotalLoginPipelines());
               System.debug(b.getPercentNotActivePipelines());
           }
           beanShortClose = adoption.getOppShortClosePipeLineBeanForRegion();
           for(OppPipelineBean b1 : beanShortClose)
           {
               System.debug(b1.getRegion());
               System.debug(b1.getTotal75Q1PricePipelines());
               System.debug(b1.getTotal75Q2PricePipelines());
               System.debug(b1.getTotal75Q3PricePipelines());
               System.debug(b1.getTotal75Q4PricePipelines());
               System.debug(b1.getTotal7Q1PricePipelines());
               System.debug(b1.getTotal7Q2PricePipelines());
               System.debug(b1.getTotal7Q3PricePipelines());
               System.debug(b1.getTotal7Q4PricePipelines());
           }
           bean.clear();
       }
       Test.stopTest();                                
    }
    public static testMethod void myUnitTestArea() {
       
       VOppPipelineReportHelper_2_0Adoption adoption = new VOppPipelineReportHelper_2_0Adoption();
       List<String> arealst = new List<String>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       arealst.add('Canada');
       arealst.add('Brazil');
       
       Test.startTest();
       System.runAs(users[0]) 
       {
           adoption.getDateItems();
           adoption.getAreaItems();
           adoption.getRegionItems();
           adoption.getTerritoryItems();
           adoption.selectedDate = 'Thu, Apr 2, 09';
           adoption.selectedField = 'Area';
           adoption.selectedArea = arealst;
           adoption.populateFieldList();
           adoption.populateData();
       }
       Test.stopTest();                                
    }
    
    public static testMethod void myUnitTestTerritory() {
       
       VOppPipelineReportHelper_2_0Adoption adoption = new VOppPipelineReportHelper_2_0Adoption();
       List<String> territorylst = new List<String>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       territorylst.add('Australia');
       territorylst.add('CANADA');
       Test.startTest();
       System.runAs(users[0]) 
       {
           adoption.getDateItems();
           adoption.getAreaItems();
           adoption.getRegionItems();
           adoption.getTerritoryItems();
           adoption.selectedDate = 'Thu, Apr 2, 09';
           adoption.selectedField = 'Territory';
           adoption.getTerritoryItems();
           adoption.selectedTerritory = territorylst; 
           adoption.populateFieldList();
           adoption.populateData();
       }
       Test.stopTest();                                
    }
}