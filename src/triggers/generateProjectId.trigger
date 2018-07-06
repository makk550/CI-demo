trigger generateProjectId on Project_Site_Association__c(after insert){
    
    if(!userInfo.getUserId().contains(system.Label.SeviceCloudRestApi)) 
        return ;
    
    List<Project_Site_Association__c> projectSiteObj = [Select id, Project_ID__c from Project_Site_Association__c where (Project_ID__c!='' OR Project_ID__c!=null) AND Project_ID__c!=: '0' AND Project_ID__c>=:System.Label.ProjectIdStartingNumber order by Project_ID__c desc limit 1];
    system.debug(projectSiteObj);
    
    if(projectSiteObj<>null && projectSiteObj.size()>0){
        Integer projectIdVal = Integer.valueOf(projectSiteObj[0].Project_ID__c); 
        
        List<Project_Site_Association__c> listOfProjectSite = new List<Project_Site_Association__c>();
        for(Project_Site_Association__c newProjectSiteRecord:Trigger.New){
            if(newProjectSiteRecord.Project_ID__c=='0'){
                Project_Site_Association__c projectObj = new Project_Site_Association__c(Id=newProjectSiteRecord.Id);
                ++projectIdVal;
                projectObj.Project_ID__c = String.valueOf(projectIdVal);
                projectObj.Site_Association__c = newProjectSiteRecord.Site_Association__c;
                listOfProjectSite.add(projectObj);
            }
        }
        if(listOfProjectSite<>null && listOfProjectSite.size()>0){
            try{
                Database.update(listOfProjectSite);
            }catch(DMLException e){system.debug('******Update****failed******');}
        }
    }else{
        List<Project_Site_Association__c> listOfProjectSite = new List<Project_Site_Association__c>();
        for(Project_Site_Association__c newProjectSiteRecord:Trigger.New){
            if(newProjectSiteRecord.Project_ID__c=='0'){
                Project_Site_Association__c projectObj = new Project_Site_Association__c(Id=newProjectSiteRecord.Id);
                projectObj.Project_ID__c = System.Label.ProjectIdStartingNumber;
                projectObj.Site_Association__c = newProjectSiteRecord.Site_Association__c;
                listOfProjectSite.add(projectObj);
            }
        }
        if(listOfProjectSite<>null && listOfProjectSite.size()>0){
            try{
                Database.update(listOfProjectSite);
            }catch(DMLException e){system.debug('******Update****failed******');}
        }
    }
}