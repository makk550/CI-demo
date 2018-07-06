/*
AccessRequest - is the controller for ApprovalPage VF.
Used to grant/reject access to the user, and also to create
a service desk ticket (by the approver, incase the solution provided isn't valid for that scenario
or if approver feels there is a better way to provide access than the ones provided).
After approve/reject/creation of SD ticket, the access request is updated and status is changed accordingly.
A chatter post follows, notifying the concerned people.
Added by BAJPI01 on 26/6/2016
*/

public with sharing class accessRequest {

Public String SharedThrough{get;set;}
Public String ReasonDetail {get;set;}
Public String Reason{get;set;}
Public List<Sobject> solutions;
//Public Static SolutionWrapper selectSolution = new SolutionWrapper();
Public List<SolutionWrapper> selectSolutionList = new List<SolutionWrapper>(); //why was this list static - piyush
//selectSolutionList = new List<SolutionWrapper>();
Public List<SolutionWrapper> solnList = new List<SolutionWrapper>();
public List<String> SharedToList = new List<String>();
Public Access_Request__c accReq;
Public processURL pURL;
Public Boolean ShowButtons {get;set;}
public String SolutionDetail {get;set;}
public String approverComments {get;set;}
public String SDapproverComments {get;set;}
public Integer role{get;set;}
Public String rejectComment{get;set;}
public boolean solutionExists{get;set;}
public string accReqType {get;set;}
public List <MetadataService.FolderShare> ShareDetails = new List<MetadataService.FolderShare>();
public String FolderDevName, MetadataSessionId,uname,sandboxname;
public Id FolderId;
List <Folder> FolderName = new List <Folder>();
    
   public accessRequest(ApexPages.StandardController stdController) {
    
        this.accReq = (Access_Request__c)stdController.getRecord();
       system.debug('');
        pURL = new processURL(accReq.Access_for_URL__c);
        ShowButtons = FALSE;
        role=0;
       if(accReq.Type__c=='Create Service Desk Ticket'){
           solutionExists = False;
       }
       else{
           solutionExists = True;
       }
       if(pURL.Key=='01Z'){
            FolderId = [Select FolderId from Dashboard where Id =: pURL.RecordId].FolderId;
       		FolderName = [Select developername from folder where id =:FolderId];
        	FolderDevName = FolderName[0].DeveloperName;
           	//if(!Test.isRunningTest())
            dashboardsharedetails(FolderDevName);
       }
       else if(pURL.Key=='00O'){
            FolderId = [Select OwnerId from Report where Id =: pURL.RecordId].OwnerId;
        	FolderName = [Select developername from folder where id =:FolderId];
        	FolderDevName = FolderName[0].DeveloperName;
           	//if(!Test.isRunningTest())
            reportsharedetails(FolderDevName);
       }
            
   } 
   public void SolutionSelected(){
        //selectSolutionList = new List<SolutionWrapper>();
        System.debug('RS'+Reason+SharedThrough);
        system.debug('solnList>>'+solnList);
        system.debug('solnList count>>'+solnList.size());
        for(SolutionWrapper a : solnList)
        {
        if(a.selected){
            system.debug('solutionwrapper instance>>'+a);
            SolutionWrapper sw = new SolutionWrapper();
            sw.Reason = a.Reason;
            sw.AccessLevel = a.AccessLevel;
            sw.SharedThrough = a.SharedThrough;
            sw.SharedWith = a.SharedWith;
            SharedToList.add(sw.SharedWith);
            if(SolutionDetail == null || SolutionDetail=='')
             SolutionDetail =  a.SharedWith;
            else 
             SolutionDetail = SolutionDetail +';'+ a.SharedWith;
            if(ReasonDetail == null || ReasonDetail=='')
             ReasonDetail =  a.Reason;
            else 
             ReasonDetail = ReasonDetail +';'+ a.Reason;
            selectSolutionList.add(a);
        }
       
     }
       
    }
   public List<SolutionWrapper> getSolutionsList(){
            solnList.clear();
            system.debug('solnList.size() in get list>>'+solnList.size());     
            List<ObjectPermissions>  objPerm;
       		UserRole urole;
       		Map<Id, Territory> idToTerritoryMap;
            AggregateResult[] AReqList = [Select SharedTo__c, Count(Id)frequency from SharedTo__c Group By SharedTo__c];  
           
            if(accReq.Access_for_URL__c!=null && accReq.Mirror__c!=null){
            system.debug('Entered url/mirror');
            solutionExists=True;    
            PermissionSet pSet = [Select Id from PermissionSet where ProfileId =: accReq.Mirror__r.ProfileId];
            objPerm = [Select PermissionsModifyAllRecords,PermissionsViewAllRecords from ObjectPermissions where SobjectType =:pURL.ObjectName and ParentId =: pSet.Id];
               
               
               if(objPerm.size() > 0){
                
                    if (objPerm[0].PermissionsModifyAllRecords == TRUE)
                        solnList.add(new SolutionWrapper('Profile','ModifyAll',accReq.Mirror__r.ProfileId,AReqList ));
                    else if (objPerm[0].PermissionsViewAllRecords == TRUE)
                        solnList.add(new SolutionWrapper('Profile','ViewAll',accReq.Mirror__r.ProfileId,AReqList ));
            
                }
               
                
                
            List<PermissionSetAssignment> pSetAgn = [Select Id,PermissionSetId,AssigneeId from PermissionSetAssignment where AssigneeId =: accReq.Mirror__r.Id and PermissionSetId!=:pSet.Id];
            Set<Id> permSet = new Set<Id>();
            
            for(PermissionSetAssignment psa : pSetAgn)
                permSet.add(psa.PermissionSetId);
               
            objPerm = [Select ParentId,PermissionsModifyAllRecords,PermissionsViewAllRecords from ObjectPermissions where SobjectType =:pURL.ObjectName and ParentId in :permSet];
             
            for(ObjectPermissions op : objPerm){  
             
              
                if(op.PermissionsModifyAllRecords == TRUE)
                     solnList.add(new SolutionWrapper('Permission Set','ModifyAll',op.ParentId,AReqList ));
                else if (op.PermissionsViewAllRecords == TRUE)
                     solnList.add(new SolutionWrapper('Permission Set','ViewAll',op.ParentId,AReqList ));
                    
               }
            
                if(pURL.key=='01Z'||pURL.key=='00O'){
                   SolutionWhyList swl = new SolutionWhyList(ShareDetails);
                   solnList.addAll(swl.Wrapsolutions(AReqList)); 
                }   
                else{    
            	SolutionWhyList swl = new SolutionWhyList(pURL.RecordId, accReq.Mirror__c,pURL.Key);
                solnList.addAll(swl.Wrapsolutions(AReqList));
                }
            
            }
       
       		else if(accReq.Mirror__c!=null && accReq.Access_for_URL__c==null)
			{
                solutionExists=True;
				//adding user role to solnList
				urole = [SELECT Id,Name FROM UserRole WHERE Id IN (SELECT UserRoleId FROM User WHERE Id =: accReq.Mirror__r.Id)];
				solnList.add(new SolutionWrapper('Role',urole.Id,AReqList ));
				
				//adding user profile to solnList
				solnList.add(new SolutionWrapper('Profile',accReq.Mirror__r.ProfileId,AReqList));
				
				//adding user territories to solnList
				List<UserTerritory> myList = [SELECT Id, UserId, TerritoryId FROM UserTerritory WHERE UserId =: accReq.Mirror__r.Id];
				List<Id> territoryIdList = new List<Id>();
				territoryIdList.addAll(SolutionWhyList.TerritoryList(accReq.Mirror__r.Id));
                system.debug('territory list'+territoryIdList);
				
                if(!territoryIdList.isEmpty()){
				idToTerritoryMap = new Map<Id, Territory>([SELECT Id, Name FROM Territory WHERE Id IN : territoryIdList]);
                }
                if (idToTerritoryMap != null && !(idToTerritoryMap.isEmpty()))
				{
					for(Territory mirrorterritory: idToTerritoryMap.values()){
					solnList.add(new SolutionWrapper(AReqList,'Territory',mirrorterritory.id,mirrorterritory.name));
					}					
				}
				
			}
       		else{
                system.debug('Entered No Solution Area');
           		solutionExists=False;
       		}
                      
            solnList.sort();
            system.debug('solnList.size()>>'+solnList.size());
            return  solnList;
            
     }
   public PageReference territoryApproval(){
     
     //SolutionSelected();
     System.debug('SelectedSolution'+selectSolutionList.size());
       if(selectSolutionList.size()>0)
       {
     System.debug('SelectedSolution values'+selectSolutionList);
     
     //approveRequest(accReq.Id,SolutionDetail);
    
     return  toRequestPage(); 
       }
       else{
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select one or more solutions to grant access'));
           //return new PageReference('/apex/ApprovalPage?scontrolCaching=1&id='+accReq.Id);
           return null;
       }
     
     }
    public PageReference GrantAccess(){
        string UserID='';
        SolutionSelected();
     
        System.debug('SelectedSolution'+selectSolutionList.size()); 
        //System.debug('SelectedSolution values'+selectSolutionList);
		
		if(selectSolutionList.size()>0)
		{
        User u = [Select UserRoleId, Id, ProfileId,username from User where Id =: accReq.Request_For__c];
        for(SolutionWrapper selectSolution : selectSolutionList){
            
            SharedToList.add(selectSolution.SharedThrough);
            if(selectSolution.Reason== 'User'){
                if(pURL.Key=='01Z'){
                    try{
                        
                        if(u.username.substringAfterLast('.com')!=null){
                            sandboxname=u.username.substringAfterLast('.com');
                            uname=u.username.removeEnd('.'+sandboxname);
                        }
                        else
                        {
                          uname=u.Username;  
                        }
                        MetadataSessionId = UserInfo.getSessionId();
                        updateDashboardShareDetails(FolderDevName,selectSolution.AccessLevel,uname,MetadataSessionId);
                    }
                    catch(Exception e){
                    system.debug('Exception occured>'+e);
                	}
                }
                else if(pURL.Key=='00O'){
                    try{
                         if(u.username.substringAfterLast('.com')!=null){
                            sandboxname=u.username.substringAfterLast('.com');
                            uname=u.username.removeEnd('.'+sandboxname);
                        }
                        else
                        {
                          uname=u.Username;  
                        }
                        MetadataSessionId = UserInfo.getSessionId();
                        updateReportShareDetails(FolderDevName,selectSolution.AccessLevel,uname,MetadataSessionId);
                    }
                    catch(Exception e){
                    system.debug('Exception occured>'+e);
                	}
                }
            }
            else if(selectSolution.Reason== 'Manual Sharing'){
             
                Sobject mirrorShare = pURL.mapObj.get(pURL.SharedObjectName).newSObject();
             
                mirrorShare.put('UserOrGroupId',accReq.Request_For__c);
             
                if(pURL.CustomObj){
                
                     mirrorShare.put('AccessLevel',selectSolution.AccessLevel);
                     mirrorShare.put('ParentId',pURL.RecordId);
                     
                }
                else
                {
                
                    mirrorShare.put(pURL.ObjectName+'AccessLevel',selectSolution.AccessLevel);
                    mirrorShare.put(pURL.ObjectName+'Id',pURL.RecordId);
                    
                    if(pURL.ObjectName == 'Account'){
                         Sobject sharedrecord = [Select OpportunityAccessLevel from AccountShare where AccountId =: pURL.RecordId and UserOrGroupId =: accReq.Mirror__c ];
                         mirrorShare.put('OpportunityAccessLevel',sharedrecord.get('OpportunityAccessLevel'));
                    }
                    
                }
                system.debug('mirrorShare for 169>>'+mirrorShare);
                try{
                    insert mirrorShare;
                }
                catch(Exception e){
                    system.debug('Exception occured>'+e);
                }
                
                
             
            }
        
            else if(selectSolution.Reason== 'Owner'){
            
                insertGrpMember(selectSolution.SharedThrough,accReq.Request_For__c);
               
            
            }
        
            else if (selectSolution.Reason.contains('Rule') || selectSolution.Reason.contains('Sharing')){
            System.debug('Entered');
              
              /*  if(role>0)
                {   
                    system.debug('entered role'+role);
                    continue;
                }
                else{*/
                if(selectSolution.SharedThrough.startswith('00E')){
                
                    u.UserRoleId = selectSolution.SharedThrough; 
                    try{
             //update u;
            UpdateUserRole(u.UserRoleId,u.id) ;
                        role=role+1;
            system.debug('role'+role);
          }
          catch(Exception e){
            system.debug('Exception occured>'+e);
          }
                    
                    
                }
                else if(selectSolution.SharedThrough.startswith('00G')){
                    
                    insertGrpMember(selectSolution.SharedThrough,accReq.Request_For__c);
                
                    
               

            }
            
         // }
       }
         
            else if(selectSolution.Reason.contains('Team')){
                
                Map <String, Schema.SObjectField> fieldMap;
                schema.describefieldresult dfield; 
                Integer looprun = 1;
                String query = 'SELECT ';
                
                Sobject TeamMember = pURL.mapObj.get(pURL.ObjectName+'TeamMember').newSObject();
                
                fieldMap = pURL.mapObj.get(pURL.ObjectName+'TeamMember').getDescribe().fields.getMap();  
                       
                
                for(Schema.SObjectField sfield: fieldMap.Values()) {
                    
                    If (looprun != 1)
                         query += ', ';
                    
                    dfield = sfield.getDescribe();
                    query += dfield.getname();
                    looprun++;
                    
                }
                system.debug('selectSolution.SharedThrough.containsIgnoreCase'+selectSolution.SharedWith);
                if(selectSolution.SharedWith.containsIgnoreCase('user:')){
                    integer index=selectSolution.SharedWith.indexOf('User: '); 
                    system.debug('index>'+index);
                    string username = selectSolution.SharedWith.substring(6) ;
                    system.debug('username>'+username);
                    List<User> usr = [select id from user where name =:username limit 1];
                    if(usr.size() >0) UserID = usr[0].id;
                }
                query += ' FROM '+pURL.ObjectName+'TeamMember where '+pURL.ObjectName+'Id = \''+pURL.RecordId+'\' and UserId = \''+UserID+'\'';   // removed accReq.Mirror__c put UserID
                
                System.debug('Query'+query);
                
                List<Sobject> sharedTeamrecord = Database.query(query);
            
                
                TeamMember.put(pURL.ObjectName+'Id',pURL.RecordId);
                if(sharedTeamrecord.size() >0) TeamMember.put('TeamMemberRole',sharedTeamrecord[0].get('TeamMemberRole'));
                else TeamMember.put('TeamMemberRole','Manually Added Team Member'); // to be provided from Business
                TeamMember.put('UserId',accReq.Request_For__c);
                
                try{
                    insert TeamMember;
                }
                catch(Exception e){
                    system.debug('Exception occured>'+e);
                }
                
                
                Sobject ObjShare = pURL.mapObj.get(pURL.SharedObjectName).newSObject() ;
                
                fieldMap = pURL.mapObj.get(pURL.SharedObjectName).getDescribe().fields.getMap();  
                
           
                looprun = 1;
                query = 'SELECT ';
                for(Schema.SObjectField sfield: fieldMap.Values()) {
                    
                    If (looprun != 1)
                         query += ', ';
                    
                    dfield = sfield.getDescribe();
                    query += dfield.getname();
                    looprun++;
                    
                }
            
                query += ' FROM '+pURL.SharedObjectName+' where '+pURL.ObjectName+'Id = \''+pURL.RecordId+'\' and UserOrGroupId = \''+UserID+'\''; //removed 'accReq.Mirror__c' put 'UserID'
                
                System.debug('Query'+query);
                
                List<Sobject> sharedrecord = Database.query(query);
                       
                ObjShare.put(pURL.ObjectName+'Id',pURL.RecordId);
                if(sharedrecord.size() >0) ObjShare.put(pURL.ObjectName+'AccessLevel',sharedrecord[0].get(pURL.ObjectName+'AccessLevel'));
                else ObjShare.put(pURL.ObjectName+'AccessLevel','Read');//To be decided 
                ObjShare.put('UserOrGroupId',accReq.Request_For__c);
                
                if(pURL.ObjectName == 'Account')
                    if(sharedrecord.size() >0) ObjShare.put('OpportunityAccessLevel',sharedrecord[0].get('OpportunityAccessLevel'));
                    else ObjShare.put('OpportunityAccessLevel','Read');
                try{
                    insert ObjShare;
                }
                catch(Exception e){
                    system.debug('Exception occured>'+e);
                }
               
               
            }
          
            else if(selectSolution.Reason == 'Profile'){
            
                u.ProfileId = selectSolution.SharedThrough;
                    try{
                        Update u;
                    }
                    catch(Exception e){
                        system.debug('Exception occured>'+e);
                    }               
                
               
            }
            
            else if(selectSolution.Reason == 'Permission Set'){
            
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.PermissionSetId = selectSolution.SharedThrough; 
                psa.AssigneeId = accReq.Request_For__c;
                try{
                    insert psa;
                }
                catch(Exception e){
                    system.debug('Exception occured>'+e);
                }
                
               
            }
            
            else if(selectSolution.Reason.contains('Role')){
            
                u.UserRoleId = selectSolution.SharedThrough; 
                    try{
                        Update u;
                    }
                    catch(Exception e){
                        system.debug('Exception occured>'+e);
                    }
                
               
            }
            
            else if(selectSolution.SharedThrough.startswith('00G')){
               
                GroupMember GM = new GroupMember();
                GM.GroupId = selectSolution.SharedThrough;
                GM.UserOrGroupId = accReq.Request_For__c;
                try{
                    insert GM;
                }
                catch(Exception e){
                    system.debug('Exception occured>'+e);
                }
                
                    
               
            }
         
        }        
        system.debug('accReq.Id'+accReq.Id+'Solution Details >>'+SolutionDetail);
        
        approveRequest(accReq.Id,SolutionDetail,SharedToList);
      	return  new PageReference('/'+Label.Access_Request_Redirect);  //samap01 -US345637 
        //return  toRequestPage();
        //return selectSolutionList;
       // return null;
		}
		else{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select one or more solutions to grant access'));
            return null;
		}
    }
  
   public PageReference toRequestPage(){
        
        system.debug('Inside redirect');
        return new PageReference('/'+Label.Access_Request_Redirect);
    }
    @future
   public static void UpdateUserRole(String RoleID,String UserID ){
     User u = [Select UserRoleId, Id, ProfileId from User where Id =:UserID];  
       u.UserRoleId = RoleID;
       try{
           update u;
       }
       catch(exception e){
           system.debug('Exception Occured '+e); 
       }
   }
   @future
   public static void approveRequest(String requestId,String SolutionDetail,List<String> SharedToList ){
    
     // Approving the records
         system.debug('future call Approve method');
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Approve');
         
         ProcessInstanceWorkitem wt = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: requestId limit 1];  
         
          if(wt != NULL)
          {
             req.setWorkitemId(wt.Id);
             Approval.ProcessResult result =  Approval.process(req);
          }
         
         Access_Request__c request = [Select Id, RecordTypeId,Access_Granted_Through__c  from  Access_Request__c where Id =:requestId];
         request.RecordTypeId = Schema.SObjectType.Access_Request__c.getRecordTypeInfosByName().get('AfterApproval').getRecordTypeId();
         request.SharedTo__c = SolutionDetail;
         request.Access_Granted_Through__c = SolutionDetail;
         request.Approver__c = UserInfo.getuserId();
         request.Status__c= 'Approved and Access Granted';
         system.debug('request>>'+request);
                    try{
                        update(request);
                    }
                    catch(Exception e){
                        system.debug('Exception pccured>'+e);
                    }
         
            system.debug('Access Request '+SharedToList);
            //list<String> SolutionDetailList = new List<String>();
            list<SharedTo__c> SharedToStringList = new List<SharedTo__c>();
            //SolutionDetailList = SharedToList.split(';');
            for(string str :SharedToList ){
                SharedTo__c shareDetail = new SharedTo__c();
                shareDetail.SharedTo__c = str;
                SharedToStringList.add(shareDetail);
            }
            try{
                insert SharedToStringList   ;
            }
            catch(exception e){
                system.debug('Exception Occured : e>'+SharedToList);
            }
     
     }
    
    
    public PageReference approveManually(){
      system.debug('***approverComments'+approverComments);		
       if(approverComments==''||approverComments==null){
           system.debug('approverComments'+approverComments);
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please give an approval reason.'));
           return null;
       }
       else
       {
           Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
           req.setAction('Approve');
           
           ProcessInstanceWorkitem wt = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: accReq.Id limit 1];  
           
           if(wt != NULL)
           {
                req.setWorkitemId(wt.Id);
                Approval.ProcessResult result =  Approval.process(req);
           }
           
       
       	 Access_Request__c request = [Select Id, Access_Granted_Through__c,Approver__c,Status__c  from  Access_Request__c where Id =:accReq.Id];
         request.RecordTypeId = Schema.SObjectType.Access_Request__c.getRecordTypeInfosByName().get('AfterApproval').getRecordTypeId();
		 request.Access_Granted_Through__c = approverComments;
         request.Approver__c = UserInfo.getuserId();
		 request.Status__c = 'Approved and Access Granted';
     
         system.debug('request>>'+request);
                    try{
                        update(request);
                    }
                    catch(Exception e){
                        system.debug('Exception pccured>'+e);
                    }
       return  new PageReference('/'+Label.Access_Request_Redirect);
       }
    }
    
   public PageReference reject(){
      		
       if(rejectComment==''||rejectComment==null){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please give a rejection reason.'));
           return null;
       }
       else
       {
           Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
           req.setAction('Reject');
           
           ProcessInstanceWorkitem wt = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: accReq.Id limit 1];  
           
           if(wt != NULL)
           {
                req.setWorkitemId(wt.Id);
                Approval.ProcessResult result =  Approval.process(req);
           }
           
       
       	 Access_Request__c request = [Select Id, Access_Denied_Reason__c  from  Access_Request__c where Id =:accReq.Id];
         request.Access_Denied_Reason__c = rejectComment;
     
         system.debug('request>>'+request);
                    try{
                        update(request);
                    }
                    catch(Exception e){
                        system.debug('Exception pccured>'+e);
                    }
       return  new PageReference('/'+accReq.Id);
       }
    }
   @future
   public static void insertGrpMember(string grpId,string userORgrpID){
                GroupMember GM = new GroupMember();
                GM.GroupId = grpId;
                GM.UserOrGroupId = userORgrpID;
                system.debug('GM through owner mirrorShare'+GM);
                try{
                    insert GM;
                }
                catch(Exception e){
                    system.debug('Exception pccured>'+e);
                }
                
      }
   
   public PageReference createSDTicket(){
        string details;
        if(accReq.Description__c != null)
         details = accReq.Description__c + SDapproverComments;
        else  details = SDapproverComments;
       User u = [select Id, phone from User where Id = :UserInfo.getUserId()];
        String SDTicket =  NSDIntegrator.createIncident('386', '746',details, accReq.Request_For__r.name, UserInfo.getName(), 'SFDC Access Request',accReq.Request_For__r.Email,accReq.Request_For__r.Phone,accReq.Id,accReq.Name, UserInfo.getUserEmail(), u.Phone); 
         system.debug('to accessRequest Again SDTicket>'+SDTicket);
         ApproveAccessRequestFuture.approverSDRequest(accReq.Id,SDapproverComments,SDTicket);
         
         
         return toRequestPage();
         
       }
   public PageReference cancel(){
           
            return  new PageReference('/home/home.jsp');
    }
    
   public void dashboardsharedetails(String FolderDevName){
           MetadataService.MetadataPort service = new MetadataService.MetadataPort();
           List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
           service.SessionHeader = new MetadataService.SessionHeader_element();
           service.SessionHeader.sessionId = UserInfo.getSessionId();
       		List<MetadataService.DashboardFolder> folder = new List<MetadataService.DashboardFolder>();
           
           MetadataService.ListMetadataQuery queryDashboardFolder = new MetadataService.ListMetadataQuery();
           queryDashboardFolder.type_x = 'DashboardFolder';
           queries.add(queryDashboardFolder);
			if(!Test.isRunningTest())       
           MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 36);
       		
           List<String> folderNames = new List<String>();
           
           folderNames.add(FolderDevName);
       		if(!Test.isRunningTest()){
           folder = (List<MetadataService.DashboardFolder>)service.readMetadata('DashboardFolder', folderNames).getRecords();
       		//system.debug('folder: '+folder);
           ShareDetails.addAll(folder[0].folderShares);
       		//system.debug('foldershares'+folder[0].folderShares);
           }
    }
    
    
    public void reportsharedetails(String FolderDevName){
           MetadataService.MetadataPort service = new MetadataService.MetadataPort();
           List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
           service.SessionHeader = new MetadataService.SessionHeader_element();
           service.SessionHeader.sessionId = UserInfo.getSessionId();
        	List<MetadataService.ReportFolder> folder = new List<MetadataService.ReportFolder>();
           
           MetadataService.ListMetadataQuery queryReportFolder = new MetadataService.ListMetadataQuery();
           queryReportFolder.type_x = 'ReportFolder';
           queries.add(queryReportFolder); 
        	if(!Test.isRunningTest())
           MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 36);
           List<String> folderNames = new List<String>();
           
           folderNames.add(FolderDevName);
           if(!Test.isRunningTest()){
           folder = (List<MetadataService.ReportFolder>)service.readMetadata('ReportFolder', folderNames).getRecords();
           system.debug('folder'+ folder);
           system.debug('foldershares'+folder[0].folderShares);
           ShareDetails.addAll(folder[0].folderShares);
           }
    }
    
    
    @future(callout=true)
    public static void updateReportShareDetails(String FolderDevName, string AccessLevel, string userEmail, string sessionid){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();  
        List<String> folderNames = new List<String>();
        List<MetadataService.ReportFolder> rfa = new List<MetadataService.ReportFolder>();
        folderNames.add(FolderDevName);
        
        if(!Test.isRunningTest()){
        	rfa = (List<MetadataService.ReportFolder>) service.readMetadata('ReportFolder', folderNames).getRecords();
        
        	System.debug('rfa==='+ rfa);
            System.debug('rfa.folderShares======'+ rfa[0].folderShares);
        }
        MetadataService.FolderShare folderShareService = new MetadataService.FolderShare();
        folderShareService.accessLevel = AccessLevel;
        folderShareService.sharedTo = userEmail;
        folderShareService.sharedToType = 'User';
        if(!Test.isRunningTest()){
        rfa[0].FolderShares.add(folderShareService);
        
        List<MetadataService.SaveResult> results = service.updateMetadata(rfa);
    	}
    }
    
    @future(callout=true)
    public static void updateDashboardShareDetails(String FolderDevName, string AccessLevel, string userEmail, string sessionid){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = sessionid;  
        List<String> folderNames = new List<String>();
        List<MetadataService.DashboardFolder> dfa = new List<MetadataService.DashboardFolder>();
        folderNames.add(FolderDevName);
        
        if(!Test.isRunningTest()){
        	dfa = (List<MetadataService.DashboardFolder>) service.readMetadata('DashboardFolder', folderNames).getRecords();
        
        	System.debug('dfa==='+ dfa);
        	System.debug('dfa.folderShares======'+ dfa[0].folderShares);
        }
        MetadataService.FolderShare folderShareService = new MetadataService.FolderShare();
        folderShareService.accessLevel = AccessLevel;
        folderShareService.sharedTo = userEmail;
        folderShareService.sharedToType = 'User';
        
        if(!Test.isRunningTest())
        {
        	dfa[0].FolderShares.add(folderShareService);
        	List<MetadataService.SaveResult> results = service.updateMetadata(dfa);
        }
    }
}