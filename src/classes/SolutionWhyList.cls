public with sharing class SolutionWhyList {
 

 Public static String rawData = ''; 
 PageReference pr;
 public static Integer firstpos, lastpos, RowIndex, ColIndex;
 List<String> elementList;
 List<List<String>> WhyList, UniqueWhyList;
 Set<List<String>> removeDuplicates;
 public List<SolutionWrapper> solnWhyList = new List<SolutionWrapper>();
 static List <MetadataService.FolderShare> ShareDetails = new List<MetadataService.FolderShare>();
 public String FolderDevName, AccessLevel;
 public String sharedToName;
 Id recId;
 public List <User> userrecid = new List<User>();
 public Territory terrecid;
 public UserRole rolerecid;
 public Group grouprecid;
  
 
 public SolutionWhyList(List <MetadataService.FolderShare> FolderShareDetails){
      UniqueWhyList = new List<List<String>>();
	  removeDuplicates = new Set<List<String>>(); 
	  whyList = new LIst<List<String>>();
     if(FolderShareDetails.size()>0&&FolderShareDetails!=null){
         ShareDetails.addAll(FolderShareDetails);
     }
      getSharedList();
 }   
    
    
 public SolutionWhyList (String RecordId,String MirrorId,String key){
 	
 	UniqueWhyList = new List<List<String>>();
	removeDuplicates = new Set<List<String>>(); 
	whyList = new LIst<List<String>>();    
    
    if(key != '00O' && key !='01Z'){
    	
 
	   try {
		    pr = new PageReference('/setup/own/entitywhylist.jsp?id='+RecordId+'&uid='+MirrorId);
		    rawData = pr.getContent().toString();
		    //System.debug('Raw'+rawData);
		    getWhylist(); 
	    }
	    catch(VisualforceException excep){
	    	//System.debug('Mirror doesnt have access'+rawdata);
	    }
    }
  }

public void getSharedList(){
	 
	
    if(ShareDetails.size()>0&&ShareDetails!=null){
     
        for(MetadataService.FolderShare share :ShareDetails)
    	{
			if(share.sharedToType!=null){
			if(share.sharedToType!='PartnerUser'&&share.sharedToType!='CustomerPortalUser')
			{
            elementList = new List<String>();
            if(share.sharedToType=='Role'||share.sharedToType=='RolesAndSubordinates'||share.sharedToType=='RolesAndSubordinatesInternal'||share.sharedToType=='PortalRole'||share.sharedToType=='PortalRoleAndSubordinates'){
				rolerecid = [Select id,name from UserRole where DeveloperName =: share.sharedTo];
                elementList.add(rolerecid.id);
                elementList.add('Role');
                elementList.add(share.sharedToType+' : '+ rolerecid.Name);
                elementList.add(share.accessLevel);
				elementList.add('Dashboard');
                Whylist.add(elementList);
			}
			else if(share.sharedToType=='Group'){
				grouprecid = [Select id,name from Group where DeveloperName =: share.sharedTo];
                elementList.add(grouprecid.id);
                elementList.add('Group');
                elementList.add(share.sharedToType+' : '+ grouprecid.Name);
                elementList.add(share.accessLevel);       	
				elementList.add('Dashboard');
                Whylist.add(elementList);
			}
			else if(share.sharedToType=='Territory'||share.sharedToType=='TerritoryAndSubordinates'){
				terrecid = [Select id,name from Territory where DeveloperName =: share.sharedTo];
                elementList.add(terrecid.id);
                elementList.add('Territory');
                elementList.add(share.sharedToType+' : '+ terrecid.Name);
                elementList.add(share.accessLevel);
				elementList.add('Dashboard');
                Whylist.add(elementList);
			}
            else if(share.sharedToType=='User'){
                string uname = share.sharedTo +'%';
                userrecid = [Select id,name from User where username like :uname];
                if(userrecid.size()>0){
                    for(User u: userrecid){
                elementList.add(u.id);
                elementList.add('User');
                elementList.add(share.sharedToType+' : '+ u.Name);
                elementList.add(share.accessLevel);
				elementList.add('Dashboard');
                Whylist.add(elementList);
                 }
                }
            	}
                    
            
            }
       
        }
		else{
			elementList = new List<String>();
			elementList.add(' ');
			elementList.add('Mirror doesnt have access to this entity. Please select an appropriate Mirror user ');
			elementList.add(' ');
			elementList.add(' ');
			elementList.add(' ');
                                
			Whylist.add(elementList);
			System.debug('Its here');
		}
		}
        
    }
    else{
    
        elementList = new List<String>();
        elementList.add(' ');
        elementList.add('Mirror doesnt have access to this entity. Please select an appropriate Mirror user ');
        elementList.add(' ');
        elementList.add(' ');
        elementList.add(' ');
                                
        Whylist.add(elementList);
        System.debug('Its here');
    
    }
    removeDuplicates.addALL(WhyList);
    UniqueWhyList.addAll(removeDuplicates);
}


public void getWhylist (){
    
    if(!rawData.contains('No records to display'))
    {
        firstpos= rawData.indexOf('Shared With');
        firstpos = lastpos = rawData.indexOf('Access Level',firstpos);
            
        while (rawData.substring(lastpos+5, lastpos+13)!='</table>')
            
        {
            
            elementList = new List<String>();
            //.debug(rawData.substring(firstpos+5, firstpos+13));
            firstpos= rawData.indexOf('<a href=',lastpos);
            
            firstpos= rawData.indexOf('0',firstpos);
            lastpos = rawData.indexOf('">',firstpos);
            elementList.add(rawData.substring(firstpos, lastpos));
            
            firstpos = lastpos +2;
            lastpos = rawData.indexOf('</a>',firstpos);
            elementList.add(rawData.substring(firstpos, lastpos));
            
            firstpos= rawData.indexOf('dataCell  ">',lastpos);
            lastpos = rawData.indexOf('</td>', firstpos);
            string linkinText = rawData.substring(firstpos+12, lastpos);
            
            if(linkinText.containsIgnoreCase('<a href="')){
                integer firstposH,lastposH;
                //.debug('linkinText>'+linkinText);
                firstposH= rawData.indexOf('">',firstpos+12);
                lastposH = rawData.indexOf('</a>',firstposH);
                //system.debug('rawData.substring(firstpos, lastpos)'+rawData.substring(firstposH+2, lastposH));
                elementList.add(rawData.substring(firstposH+2, lastposH));
                }
            else
            
            elementList.add(rawData.substring(firstpos+12, lastpos));
            //system.debug('elementList>3'+elementList);
            firstpos= rawData.indexOf('dataCell  ">',lastpos);
            lastpos = rawData.indexOf('</td>', firstpos);
           // elementList.add(rawData.substring(firstpos+12, lastpos));
            
            firstpos= rawData.indexOf('dataCell  ">',lastpos);
            lastpos = rawData.indexOf('</td>', firstpos);
            elementList.add(rawData.substring(firstpos+12, lastpos));
                  
             elementList.add(' ');       
            lastpos = rawData.indexOf('</tr>', lastpos+1);
            
            Whylist.add(elementList);
            //System.debug('Lastpos'+rawData.substring(lastpos+5, lastpos+13));
            
        //System.debug ('WhyList'+WhyList);
        //System.debug('Raw'+rawData);
       }
    
    }
    else{
    
        elementList = new List<String>();
        elementList.add(' ');
        elementList.add('Mirror doesnt have access to this entity. Please select an appropriate Mirror user ');
        elementList.add(' ');
        elementList.add(' ');
        elementList.add(' ');
                                
        Whylist.add(elementList);
        //System.debug('Its here');
    
    }
    removeDuplicates.addALL(WhyList);
    UniqueWhyList.addAll(removeDuplicates);
    
}

public List<SolutionWrapper> Wrapsolutions (AggregateResult[] AReqList){


for(List<String> lst : UniqueWhyList)


    if((lst.get(2) == 'Owner' && lst.get(0).startswith('00G')))
        solnWhyList.add(new SolutionWrapper(lst.get(0),lst.get(1),lst.get(2),lst.get(3),AReqList ));
        
    else if(lst.get(4) == 'Report' || lst.get(4) == 'Dashboard'){

    	solnWhyList.add(new SolutionWrapper(lst.get(0),lst.get(2),lst.get(1),lst.get(3),AReqList ));
    }  
    else if(lst.get(2)!= 'Administrator' && lst.get(2)!= 'Owner')
        solnWhyList.add(new SolutionWrapper(lst.get(0),lst.get(1),lst.get(2),lst.get(3),AReqList ));
    //system.debug('solnWhyList'+solnWhyList);
return solnWhyList;

}
    
public static List<Id> TerritoryList(String MirrorId){
	
	string TerritoryRawData ='';
	
	try {
		    PageReference pr = new PageReference('/'+MirrorId+'?noredirect=1&isUserEntityOverride=1');
		    TerritoryRawData = pr.getContent().toString();
		    System.debug('Raw'+TerritoryRawData);
		    //getWhylist(); 
	    }
	    catch(VisualforceException excep){
	    	//System.debug('Mirror doesnt have access'+TerritoryRawData);
		}
	
    List<Id> terridlist = new List<Id>();
    /*if(!TerritoryRawData.contains('No records to display'))
    {*/	
        system.debug('Entered 243');
        firstpos = lastpos = TerritoryRawData.indexOf('Active in Territory');
    	system.debug('firstpos'+firstpos);
    	
		if(firstpos==-1)
		{
		Id terrid;
		//terrid='';                           
        terridlist.add(terrid);
        return terridlist;
		}
		else{
        system.debug('string'+TerritoryRawData.substring(firstpos, firstpos+10));    
        while (TerritoryRawData.substring(lastpos+5, lastpos+13)!='</table>')
            
        {
            //system.debug('Entered 259');
            Id terrid;
            //.debug(TerritoryRawData.substring(firstpos+5, firstpos+13));
            firstpos= TerritoryRawData.indexOf('<a href=',lastpos);
            //system.debug('substring'+TerritoryRawData.substring(firstpos, firstpos+10));
            
            firstpos= TerritoryRawData.indexOf('0',firstpos);
            lastpos = TerritoryRawData.indexOf('">',firstpos);
            //system.debug('substring'+TerritoryRawData.substring(firstpos, lastpos));
            terrid = Id.valueOf(TerritoryRawData.substring(firstpos, lastpos));
            
            firstpos = lastpos +2;
            //system.debug('substring'+TerritoryRawData.substring(firstpos, firstpos+10));
            lastpos = TerritoryRawData.indexOf('</a>',firstpos);
            //system.debug('substring'+TerritoryRawData.substring(firstpos, lastpos));
            
            lastpos = TerritoryRawData.indexOf('</tr>', lastpos);
			

            terridlist.add(terrid);
       }
	   return terridlist;
    
    }

    
}

    
 /*
    public static void dashboardsharedetails(String FolderDevName){
           MetadataService.MetadataPort service = new MetadataService.MetadataPort();
           List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
           service.SessionHeader = new MetadataService.SessionHeader_element();
           service.SessionHeader.sessionId = UserInfo.getSessionId();
           
           MetadataService.ListMetadataQuery queryDashboardFolder = new MetadataService.ListMetadataQuery();
           queryDashboardFolder.type_x = 'DashboardFolder';
           queries.add(queryDashboardFolder);       
           MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 36);
           List<String> folderNames = new List<String>();
           
           folderNames.add(FolderDevName);
           
           List<MetadataService.DashboardFolder> folder = 
               (List<MetadataService.DashboardFolder>) 
               service.readMetadata('DashboardFolder', folderNames).getRecords();
           
           system.debug('folder'+ folder);
           system.debug('foldershares'+folder[0].folderShares);
           ShareDetails.addAll(folder[0].folderShares);
    }    
   */ 

}