/******************************************************************
 * Changed by	Changed Date 		User story			Description
 * SAMAP01		18/04/2019			US474603			GPOC : Verify LDAP Account Exists for contact
 * *****************************************************************/
public with sharing class ChangePOCRequestStatusController {
    
    private ApexPages.StandardController ext;
    private Map<String, List<String>> allowedValues =  new Map<String, List<String>>();
    private final Trial_Request__c tr;
    List <GroupMember> lstMemberOfQueueOrAssociatedGroups;
    List <GroupMember> lstMemberOfPublicGroups;
    List <GroupMember> lstMemberOfSpecQueue;
    set<string> setMemberOfPocApproversEmail = new set<string>();
    private String newStatus = null;
    public String oldStatus{get; set;}
    public string AccountArea{get; set;}
    public string BusinessUnit{get; set;}
    public string Region{get; set;}
    public string queueoruser{get ; set;}
    public ID specificPOCGroup{get; set;}
    
    // Constructor
    public ChangePOCRequestStatusController(ApexPages.StandardController sc)
    {
        // VINU: AR:3705 & 3671- POC Eligible Approvers and Including new values
        Id PublicGroupPOCValidpprovers = Label.POC_Valid_Approvers_Public_group;
        string searchText = Label.POC_Public_groups;
        string strpocgroup = '%'+searchText+'%';
        // Getting list of names from Queues and Public groups
        Map<Id, Group> groupMap = new Map<Id, Group>([Select Id, Name From Group Where Type = 'Queue' OR Type = 'Regular']);
        List<GroupMember> groupMembers = new list<GroupMember>();                                  
        /*Empty and Null check to aviod null pointer exceptions & Using groupMap as a key to query list of records from groupmemer*/
        if(groupMap!= null && groupMap.size()> 0) {
           groupMembers = [Select GroupId, UserOrGroupId 
                           From GroupMember 
                           Where GroupId In :groupMap.keySet() 
                           AND (group.name like:strpocgroup 
                           OR group.name=:PublicGroupPOCValidpprovers)]; }
        
        List<GroupMember> LstPOCAdminValidApprovers = new list<GroupMember>();                                  
        if(groupMap!= null && groupMap.size()> 0) {
         LstPOCAdminValidApprovers = [Select GroupId, UserOrGroupId 
                                      From GroupMember 
                                      Where GroupId=:PublicGroupPOCValidpprovers]; 
        }
           //system.debug('LstPOCAdminValidApprovers:'+LstPOCAdminValidApprovers);
           //system.debug('groupMembers :'+groupMembers );
        
        Set<Id> userOrGroupIds = new Set<Id>();
        /*Empty & Null check to avoid the Null pointer exceptions*/
        if(groupMembers!= null && groupMembers.size()>0) {
            for (GroupMember member : groupMembers) {
                if(member.UserOrGroupId == userinfo.getuserid()){                
                   userOrGroupIds.add(member.UserOrGroupId);
                }
            }
        }
        //system.debug('userOrGroupIds :'+userOrGroupIds );
        
        set<id> SetPOCAdminValidApprovers = new set<id>();
        /*Empty & Null check to avoid the Null pointer exceptions*/
        if(LstPOCAdminValidApprovers!= null && LstPOCAdminValidApprovers.size()>0) {
            for (GroupMember AdminPocmember : LstPOCAdminValidApprovers) {
                if(AdminPocmember.UserOrGroupId == userinfo.getuserid()){
                    //system.debug('Comparison:'+AdminPocmember.UserOrGroupId == userinfo.getuserid());
                    SetPOCAdminValidApprovers.add(AdminPocmember.UserOrGroupId);
                }
            }
        }
        //system.debug('22222userOrGroupIds :'+SetPOCAdminValidApprovers );        
        
        /* Query to get the list of records from Trail Request (POc Request) object for the selected record from Custom VF*/
        ext = sc;     
        tr =[select Name,Owner_Name__c,User_Owner_Name__c,Acc_Area__c,Business_Unit__c,Acc_Region__c,request_status__c, id ,Contact_2__c,
             		Contact_3__c, 	Contact1_Has_LdapId__c,Contact2_Has_LdapId__c,Contact3_Has_LdapId__c 	// US474603
             from trial_request__c 
             where id =:ApexPages.currentPage().getParameters().get('id')];
        if(tr !=null)
        {
            string errmessage='';
               IF(tr.Contact1_Has_LdapId__c != null && tr.Contact1_Has_LdapId__c  ==false )
        {
            errmessage ='Primary Contact,';
        }
           string contact2 = tr.Contact_2__c;
            
            system.debug('samap01 tr.Contact_2__c'+ contact2);
        if(tr.Contact2_Has_LdapId__c != null && tr.Contact2_Has_LdapId__c ==false && string.isNotBlank(contact2)  )
        {
            errmessage +='Secondary Contact,';
            
        }
  			string contact3 = tr.Contact_3__c;            
            System.debug('samap01 contact3 '+contact3);
         if(tr.Contact3_Has_LdapId__c != null && tr.Contact3_Has_LdapId__c ==false && string.isNotBlank(contact3))
        {
            errmessage +=' Tertiary Contact.';
        }
            
          if(errmessage.length() >0 )  
          {
              string message = 'Ldap account does not exist for ' + errmessage + ' Please create the ldap account/s or use the contacts with the Ldap account available';
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING , message));
              return;
          }
        }
     
        
        //system.debug('TrailReq:'+tr.Owner_Name__c);
        //system.debug('TrailReqsss:'+tr.User_Owner_Name__c);
        
        /*Logic to identify the users for a specific POC queues or POC public groups*/
        Boolean specificPOCcheck = false; 
        Boolean POCAppExistanceCheck = false;
        string strpublicgroup;
        string strusergroup;
        
        /*Empty & Null check to avoid the Null pointer exceptions*/
        if(tr.request_status__c!= null && tr.Acc_Area__c!= null && tr.Business_Unit__c!= null && tr.Acc_Region__c!= null)
        {
            //System.debug('Valuesnotnull'+tr);
            oldStatus = tr.request_status__c;
            AccountArea = tr.Acc_Area__c;
            BusinessUnit = tr.Business_Unit__c;
            Region = tr.Acc_Region__c;       
            List<GroupMember> LstPublicGroups;
            List<GroupMember> LstPublicGroups2;
            
            // To get the Owner name from the Public Group / Queue 
            if(tr.Owner_Name__c != null){
                 //system.debug('Owner_Name__c:'+tr.Owner_Name__c);
                 specificPOCGroup = tr.Owner_Name__c;
                 //System.debug('Owner_Name__ccccccccccc:'+specificPOCGroup);                         
                 LstPublicGroups = [Select GroupId, UserOrGroupId 
                                   From GroupMember 
                                   Where GroupId=:specificPOCGroup ];  
            
            /*Empty & Null check to avoid the Null pointer exceptions*/
            if(LstPublicGroups!=null && LstPublicGroups.size()>0) {
                 //strpublicgroup = LstPublicGroups[0].GroupId;     
                 strpublicgroup = LstPublicGroups[0].UserOrGroupId;     
                 //system.debug('CheckSpecGroup'+strpublicgroup);     
                 set<id> Memberid = new set<id>();
                 for(GroupMember empid:[Select GroupId, UserOrGroupId From GroupMember Where GroupId=:strpublicgroup]) {
                     if(empid!= null)
                        Memberid.add(empid.UserOrGroupId); }
                 //system.debug('Memberid'+Memberid);                 
                 specificPOCcheck = Memberid.contains(userinfo.getuserid());
                 //system.debug('specificPOCcheck'+specificPOCcheck); 
                 } 
            }            
            
            /*To get the Public group name / queue name from queue/ public groups*/
            else if (tr.User_Owner_Name__c!= null) {
                 specificPOCGroup = tr.User_Owner_Name__c;
                 //System.debug('User_Owner_Name__ccccc3c:'+specificPOCGroup);  
                 LstPublicGroups2 = [Select GroupId, UserOrGroupId 
                                    From GroupMember                             
                                    Where UserOrGroupId=:specificPOCGroup ];     
            
            /*Empty & Null check to avoid the Null pointer exceptions*/    
            if(LstPublicGroups2!=null && LstPublicGroups2.size()>0) {
                 strusergroup = LstPublicGroups2[0].UserOrGroupId;     
                 //system.debug('CheckSpecGrou23p'+strusergroup);      
                 set<id> Memberid = new set<id>();
                 for(GroupMember empid:[Select GroupId, UserOrGroupId From GroupMember Where GroupId=:strusergroup]) {
                     if(empid!= null)
                        Memberid.add(empid.UserOrGroupId); }
                 //system.debug('Membesrid2'+Memberid);                 
                 specificPOCcheck = Memberid.contains(userinfo.getuserid());
                 //system.debug('specifidcPOCcheck2'+specificPOCcheck); 
                 } 
            }  
                       
            /* Building dynamic email address to verify email existance in POC Approvers object */
            string LoggedInUserFirstName = userinfo.getFirstName();
            LoggedInUserFirstName = LoggedInUserFirstName.replaceAll( '\\s+', '');            
            //System.debug('ReplaceLoggedInUserFirstName :' + LoggedInUserFirstName );     
            
            string LoggedInUserLastName = userinfo.getLastName();
            LoggedInUserLastName = LoggedInUserLastName.replaceAll( '\\s+', '');            
            //System.debug('ReplaceLoggedInUserLastName  :' + LoggedInUserLastName );     
            
            string AddDot = '.';
            string cacom = '@ca.com';     
            string Lowerstringemail;
            string BuildEmailcacom = LoggedInUserFirstName+AddDot+LoggedInUserLastName+cacom;
            BuildEmailcacom = BuildEmailcacom.trim(); 
            Lowerstringemail = BuildEmailcacom.toLowerCase();
            
            //system.debug('BuildEmail:'+Lowerstringemail );
            //Dynamic Email Logic ends here.
            
            
            /*Checking whether the user email matches with the loggedin user according to the AccountArea,BusinessUnit,Region */    
            List<POC_Escalation_Matrix__c> lstMemberOfPocApprovers = [SELECT owner.Email, POC_Escalation_Manager__c,POC_Approver_Email__c 
                                                                      FROM POC_Escalation_Matrix__c 
                                                                      WHERE Area1__c =: AccountArea
                                                                      AND Business_Unit__c =: BusinessUnit 
                                                                      AND Region__c =: Region]; 
            
            /*Empty & Null check to avoid the Null pointer exceptions*/
            if(lstMemberOfPocApprovers.size() > 0 && lstMemberOfPocApprovers!= null) {
                 //system.debug('lstMemberOfPocApprovers:'+lstMemberOfPocApprovers);           
                 for(String lstMOPA: lstMemberOfPocApprovers[0].POC_Approver_Email__c.split(',')) {              
                    setMemberOfPocApproversEmail.add(lstMOPA.trim().toLowerCase());
                    //system.debug('POC_Email:'+setMemberOfPocApproversEmail); 
                 }             
                // Allha02 	US149582 Escalation manager able to approve     
                POCAppExistanceCheck = (setMemberOfPocApproversEmail.contains(Lowerstringemail) || (lstMemberOfPocApprovers[0].POC_Escalation_Manager__c == UserInfo.getUserId()) );  }
                    //system.debug('TestLoggedInUser'+POCAppExistanceCheck);  
            }
            // Logic ends here      
        
        allowedValues.put('Approval Denied', new List<String>{'Cancelled'});            
        allowedValues.put('Extension Approved', new List<String>{'Extension for Approval','Cancelled','POC Executed'});
        allowedValues.put('Pending DDR  Review', new List<String>{'DDR Request Approved','Cancelled','Complete'});
        allowedValues.put('DDR Request Approved', new List<String>{'Complete','On Hold','Cancelled','POC Executed'});     
        allowedValues.put('On Hold', new List<String>{'Request for Approval','Cancelled','POC Executed'});
        allowedValues.put('Not Approved', new List<String>{'Cancelled','On Hold'});
        allowedValues.put('In Process', new List<String>{'Cancelled','Ordered'});
        allowedValues.put('Available', new List<String>{'Ordered','Cancelled'});
        allowedValues.put('Ordered', new List<String>{'Complete','Cancelled'});
        allowedValues.put('Complete', new List<String>{'POC Executed','Extension for Approval','Cancelled'});         
        allowedValues.put('New', new List<String>{'Request for Approval','Cancelled','On Hold','Complete'});
        //system.debug('userOrGroupIdsssize'+userOrGroupIds.size());
        //system.debug('userOrGroupIdsss'+userOrGroupIds);
        
        /*Checking whether the logged in user is eligible to approve POC Requests from the below 3 criteria's*/
        //system.debug('testAdmin'+SetPOCAdminValidApprovers);
        /*If the owner field contains Queue or Pulic group*/        
        if(tr.Owner_Name__c != null){
            If( (SetPOCAdminValidApprovers!= null && SetPOCAdminValidApprovers.size()> 0) || specificPOCcheck || POCAppExistanceCheck ){
               allowedValues.put('Request for Approval', new List<String>{'On Hold','Request Approved','Approval Denied','Cancelled'});
               allowedValues.put('Extension for Approval', new List<String>{'Extension Approved','Approval Denied','Cancelled'});     
            }
            else { 
               allowedValues.put('Request for Approval', new List<String>{'Cancelled','On Hold'}); 
               allowedValues.put('Extension for Approval', new List<String>{'Cancelled'});
            } 
        }
        /*If the owner field contains individual user*/
        else if(tr.User_Owner_Name__c!= null) {
            If((userOrGroupIds!= null && userOrGroupIds.size() > 0) || specificPOCcheck ||   POCAppExistanceCheck ){
               allowedValues.put('Request for Approval', new List<String>{'On Hold','Request Approved','Approval Denied','Cancelled'});
               allowedValues.put('Extension for Approval', new List<String>{'Extension Approved','Approval Denied','Cancelled'});     
            }
            else {
               allowedValues.put('Request for Approval', new List<String>{'Cancelled','On Hold'}); 
               allowedValues.put('Extension for Approval', new List<String>{'Cancelled'});
            }             
        }
        /*Logic Ends here*/
        
        allowedValues.put('Request Approved', new List<String>{'Cancelled'});              
        allowedValues.put('Terms Denied', new List<String>{'Cancelled'});
        allowedValues.put('Pending Entitlement', new List<String>{'Cancelled'});
        allowedValues.put('Pending Fulfillment', new List<String>{'Cancelled'});
        allowedValues.put('Pending Unknown', new List<String>{'Cancelled'});
    }
    
    public String getnewStatus() {
        return newStatus; }
    
    public void setnewStatus(String newVal) {
        newStatus= newVal; }
    
    public List<SelectOption> getavailableValues() {
        
        List<SelectOption> options = new List<SelectOption>();
        if(allowedValues.get(oldStatus)==null)
            options.add(new SelectOption('---None---','---None---'));
        else {
            for(String s: allowedValues.get(oldStatus))       
                options.add(new SelectOption(s,s)); }        
        //System.debug('Available Picklist Map'+allowedValues);
        //System.debug('Available Next Picklist'+options);
        return options;
    }         
    
    public PageReference doSave() {      
        if(!Schema.sObjectType.Trial_Request__c.fields.Request_Status__c.isUpdateable() || !Trial_Request__c.sObjectType.getDescribe().isUpdateable() ) {
            tr.Request_Status__c.addError('You do not have access to perform that opperation');
            return null; }
        if(newStatus != null && newStatus !='---None---') {
            tr.Request_Status__c = newStatus;             
            try {
                update tr;
                return ext.view();  }
            catch(exception e)  { 
                ApexPages.addMessages(e); }
            tr.Request_Status__c = oldStatus;               
        } return null; }
    
    public PageReference doCancel() {
        return ext.view(); }            
}