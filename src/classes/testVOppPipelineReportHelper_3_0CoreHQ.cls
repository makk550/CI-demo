@isTest
private class testVOppPipelineReportHelper_3_0CoreHQ {

    public static testMethod void myUnitTestRegion() {
       
       VOppPipelineReportHelper_3_0CoreHQ core = new VOppPipelineReportHelper_3_0CoreHQ();
       List<String> regionlst = new List<String>();
       List<OppPipelineBean> bean = new List<OppPipelineBean>();
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
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '3.1.4HQ';
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
            pipe.Active_Pipeline__c = 2000*count; 
            pipe.Critical_Pipeline__c =20*count;
            pipe.Stalled_Pipeline__c = 2*count;
            pipe.Pipeline_Exception_OK_Amount__c =2000*count; 
            pipe.Pipeline_Exception_OK_Count__c = 25*count;
            pipe.Pipeline_Exception_Stuck_Amount__c =1000*count; 
            pipe.Pipeline_Exception_Stuck_Count__c =23*count;
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
            pipe.Report_Name__c = '3.1.4HQ';
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
            pipe.Active_Pipeline__c = 2000*count; 
            pipe.Critical_Pipeline__c =20*count;
            pipe.Stalled_Pipeline__c = 2*count;
            pipe.Pipeline_Exception_OK_Amount__c =2000*count; 
            pipe.Pipeline_Exception_OK_Count__c = 25*count;
            pipe.Pipeline_Exception_Stuck_Amount__c =1000*count; 
            pipe.Pipeline_Exception_Stuck_Count__c =23*count;
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
            pipe.Report_Name__c = '3.1.4HQ';
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
            pipe.Active_Pipeline__c = 2000*count; 
            pipe.Critical_Pipeline__c =20*count;
            pipe.Stalled_Pipeline__c = 2*count;
            pipe.Pipeline_Exception_OK_Amount__c =2000*count; 
            pipe.Pipeline_Exception_OK_Count__c = 25*count;
            pipe.Pipeline_Exception_Stuck_Amount__c =1000*count; 
            pipe.Pipeline_Exception_Stuck_Count__c =23*count;
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
            pipe.Report_Name__c = '3.1.4HQ';
            pipe.Region__c = r;
            if(r=='NA')
             pipe.Area__c = 'CANADA';   
            else
             pipe.Area__c = 'France';
            if(r=='NA')
             pipe.Territory_Country__c = 'CANADA';  
            else
             pipe.Territory_Country__c = 'France';
            pipe.Business_Unit__c = 'INFRASTRUCTURE MANAGEMENT';
            pipe.NCV_Driver_6__c = 'INFRASTRUCTURE MANAGEMENT OTHER';
            pipe.Active_Pipeline__c = 2000*count; 
            pipe.Critical_Pipeline__c =20*count;
            pipe.Stalled_Pipeline__c = 2*count;
            pipe.Pipeline_Exception_OK_Amount__c =2000*count; 
            pipe.Pipeline_Exception_OK_Count__c = 25*count;
            pipe.Pipeline_Exception_Stuck_Amount__c =1000*count; 
            pipe.Pipeline_Exception_Stuck_Count__c =23*count;
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
            pipemap.Report_Name__c = '3.3HQ';
            pipemap.Region__c = r;
            if(r=='NA')
             pipemap.Area__c = 'CANADA';   
            else
             pipemap.Area__c = 'France';
            if(r=='NA')
             pipemap.Territory_Country__c = 'CANADA';  
            else
             pipemap.Territory_Country__c = 'France';
            pipemap.Total_Pipeline_Amount_1__c = 10*count;
            pipemap.Total_Pipeline_Amount_2__c = 20*count;
            pipemap.Total_Pipeline_Amount_3__c = 30*count;
            pipemap.Total_Pipeline_Amount_4__c = 40*count;
            pipemap.Total_Pipeline_Amount_5__c = 50*count;
            pipemap.Total_Pipeline_Amount_6__c = 60*count;   
            pipeLstMap.add(pipemap);          
           }
            count++;    
        }while(count < 3);   
       
       
        Pipeline_Report_Mapping__c pipemap1 = new Pipeline_Report_Mapping__c();
        pipemap1.OwnerId = users[0].Id;
        pipemap1.Data_Pull_Date__c = 20090402;
        pipemap1.Report_Name__c = '3.4HQ';
        pipemap1.Business_Unit__c = 'INFRASTRUCTURE MANAGEMENT';
        pipemap1.NCV_Driver_6__c = 'INFRASTRUCTURE MANAGEMENT OTHER';
        pipemap1.Average_cycle_days__c = 150; 
        pipeLstMap.add(pipemap1);
        
        Pipeline_Report_Mapping__c pipemap2 = new Pipeline_Report_Mapping__c();
        pipemap2.OwnerId = users[0].Id;
        pipemap2.Data_Pull_Date__c = 20090402;
        pipemap2.Report_Name__c = '3.4HQ';
        pipemap2.Business_Unit__c = 'AUTOMATION';
        pipemap2.NCV_Driver_6__c = 'AUTOMATION OTHER';
        pipemap2.Average_cycle_days__c = 150; 
        pipeLstMap.add(pipemap2); 
        
            
              
       insert pipeLstMap;

       count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '3.5.7SumHQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
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
            pipe.Report_Name__c = '3.5.7CountHQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
            pipeLst.add(pipe);          
           }
            count++;    
       }while(count < 3);
       
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '3.6.8HQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
            pipeLst.add(pipe);          
           }
            count++;    
       }while(count < 3);       
       
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
           core.selectedDate = 'Thu, Apr 2, 09';
           core.selectedField = 'Region';
           core.getRegionItems();          
           core.selectedRegion = regionlst;
           core.setSelectedDate(core.selectedDate);
           core.setSelectedRegion(core.selectedRegion);
           core.populateFieldList();
           core.populateData();
           bean = core.getOppPipeLineBeanForRegion();
           for(OppPipelineBean b : bean)
           {
            System.debug(b.getRegion());
            System.debug(b.getTotalPriceQualiPipelines());
            System.debug(b.getTotalPriceActivePipelines());
            System.debug(b.getTotalPriceStalledPipelines());
            System.debug(b.getTotalPriceCriticalPipelines());
            System.debug(b.getPercentNotActivePipelines());
           }
       }
       Test.stopTest();                                
    }
    
    public static testMethod void myUnitTestRegionAging() {
       
       VOppPipelineReportHelper_3_0CoreHQAging core = new VOppPipelineReportHelper_3_0CoreHQAging();
       List<String> regionlst = new List<String>();
       List<String> arealst = new List<String>();
       List<User> users = new List<User>();
       users.add(new User(id=userinfo.getUserId()));
       //  [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       regionlst.add('NA');
       regionlst.add('EMEA');
       
       arealst.add('CANADA');
       arealst.add('France');
       
       
       //Start Insert Test Data
       List<Pipeline_Report__c> pipeLst = new List<Pipeline_Report__c>();
       

       Integer count = 1;
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '3.5.7SumHQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
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
            pipe.Report_Name__c = '3.5.7SumHQ';
            pipe.Region__c = r;
            if(r=='NA')
             pipe.Area__c = 'CANADA';   
            else
             pipe.Area__c = 'France';
            if(r=='NA')
             pipe.Territory_Country__c = 'CANADA';  
            else
             pipe.Territory_Country__c = 'France';
            pipe.Business_Unit__c = 'INFRASTRUCTURE MANAGEMENT';
            pipe.NCV_Driver_6__c = 'INFRASTRUCTURE MANAGEMENT OTHER';
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
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
            pipe.Report_Name__c = '3.5.7SumHQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
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
            pipe.Report_Name__c = '3.5.7CountHQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
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
            pipe.Report_Name__c = '3.5.7CountHQ';
            pipe.Region__c = r;
            if(r=='NA')
             pipe.Area__c = 'CANADA';   
            else
             pipe.Area__c = 'France';
            if(r=='NA')
             pipe.Territory_Country__c = 'CANADA';  
            else
             pipe.Territory_Country__c = 'France';
            pipe.Business_Unit__c = 'INFRASTRUCTURE MANAGEMENT';
            pipe.NCV_Driver_6__c = 'INFRASTRUCTURE MANAGEMENT OTHER';
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
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
            pipe.Report_Name__c = '3.5.7CountHQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
            pipeLst.add(pipe);          
           }
            count++;    
       }while(count < 3);
       
       do
       {
           for(String r : regionlst)
           {
            Pipeline_Report__c pipe = new Pipeline_Report__c();
            pipe.OwnerId = users[0].Id;
            pipe.Data_Pull_Date__c = 20090402;
            pipe.Report_Name__c = '3.6.8HQ';
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
            pipe.SM_30__c = 200*count;
            pipe.SM_50__c = 100*count; 
            pipe.SM_70__c = 200*count;
            pipe.SM_90__c = 125*count;
            pipe.SM_Won__c = 137*count;
            pipeLst.add(pipe);          
           }
            count++;    
       }while(count < 3);       
       
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
           core.selectedDate = 'Thu, Apr 2, 09';
           core.selectedField = 'Region';
           core.getRegionItems();          
           core.selectedRegion = regionlst;
           core.setSelectedDate(core.selectedDate);
           core.setSelectedRegion(core.selectedRegion);
           core.populateFieldList();
           core.populateData();
           
           core.selectedField = 'Area';
           core.getAreaItems();
           core.selectedArea = arealst;
           core.setSelectedDate(core.selectedDate);
           core.setSelectedArea(core.selectedArea);
           core.populateFieldList();
           core.populateData();
           core.selectedField = 'Territory';
           List<string> terr = new List<string>();
           terr.add('CANADA');
           core.setSelectedTerritory(terr);
           core.populateFieldList();
           core.populateData();
           core.getOppPipeLineBeanForAvgAgeRegion();
           core.getOppPipeLineBeanForAvgPriceRegion();
           core.getOppPipeLineBeanForAvgPriceBU();
           core.getShowDataTable();
           core.getShowRegionList();
           core.getShowAreaList();
           core.getShowTerritoryList();
           core.getSelectedColumn();
           core.getMonthFirstPull();
           
            
             
           
       }
       Test.stopTest();                               
    }
    
    /*public static testMethod void myUnitTestArea() {
       
       VOppPipelineReportHelper_3_0Core core = new VOppPipelineReportHelper_3_0Core();
       List<String> arealst = new List<String>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       arealst.add('CANADA');
       arealst.add('France');
       
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
           core.selectedField = 'Area';
           core.getAreaItems();
           core.selectedArea = arealst;
           core.setSelectedDate(core.selectedDate);
           core.setSelectedRegion(core.selectedArea);
           core.populateFieldList();
           core.populateData();
       }
       Test.stopTest();                                
    }
    
    public static testMethod void myUnitTestTerritory() {
       
       VOppPipelineReportHelper_3_0Core core = new VOppPipelineReportHelper_3_0Core();
       List<String> territorylst = new List<String>();
       User[] users = [Select u.Id from User u where u.isactive = true and u.Profile.Name = '1.0 CA Sys Admin Commit & PR' limit 1];
       territorylst.add('CANADA');
       territorylst.add('France');
       
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
           core.selectedField = 'Territory';
           core.getTerritoryItems();
           core.selectedTerritory = territorylst; 
           core.populateFieldList();
           core.populateData();
       }
       Test.stopTest();                                
    }*/
}