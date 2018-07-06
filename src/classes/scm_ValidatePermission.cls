public class scm_ValidatePermission
{
    
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    //List<Account> accstoupload;
    List<objectPermission> objectPermissions{get;set;}
    List<objectPermission> errObjectPermissions{get;set;}
    List<fieldPermission> fieldPermissions{get;set;}
    List<fieldPermission> errFieldPermissions{get;set;}
    List<UserOrAdminPermission> UserOrAdminPermissions{get;set;}
    List<UserOrAdminPermission> errUserOrAdminPermissions{get;set;}
    Boolean enteredLoop ;
    
    public List<objectPermission> getObjectPermissions() {
        return objectPermissions;
    }
    public List<objectPermission> geterrObjectPermissions() {
        return errObjectPermissions;
    }
    
    public List<fieldPermission> getfieldPermissions() {
        return fieldPermissions;
    }
    public List<fieldPermission> geterrFieldPermissions() {
        return errFieldPermissions;
    }
    
    public List<UserOrAdminPermission> getUserOrAdminPermissions() {
        return UserOrAdminPermissions;
    }
    public List<UserOrAdminPermission> geterrUserOrAdminPermissions() {
        return errUserOrAdminPermissions;
    }
   
    public Pagereference ReadObjectPermissionFile()
    {
        try
        {
        nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        objectPermissions = new List<objectPermission>();
        for (Integer i=1;i<filelines.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            
            objectPermission a = new objectPermission();
            a.profileName= inputvalues[0];
            a.objectName = inputvalues[1];       
            a.permission = inputvalues[2];
            

            objectPermissions.add(a);
        }
        validateObjectPermissionFile();
        }
        catch(Exception e)
        {
            System.debug('Exception in ObjectPermissionFile '+ e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }
        return null;
    }  
    
    public PageReference validateObjectPermissionFile()
    {
        Map<String,Id> profileNametoIdMap = new Map<String,Id>();
        errObjectPermissions = new List<objectPermission>();
        Map<id,List<ObjectPermissions>> profileIdToObjPermissonListMap = new Map<id,List<ObjectPermissions>>();
        Set<String> profileNames = new Set<String>();
        Set<String> objectNames = new Set<String>();
        
        // Collect Profile name and Object Name from objectPermission list
        for(objectPermission o: objectPermissions) {
            profileNames.add(o.profileName);
            objectNames.add(o.objectName );
            
        }
        // Query all the profile using profile names
        for(Profile p: [Select id, Name from Profile where name in :profileNames])
        profileNametoIdMap.put(p.name, p.id);
        
        // Query all the permission set related to profile
        Map<id,PermissionSet> idToPermissionSetMap = new Map<id,PermissionSet>([Select id, ProfileId from PermissionSet where ProfileId in :profileNametoIdMap.values()]);
        
        // Query all the object Permissions related to profile
        for(ObjectPermissions op:[select id, parentId,SobjectType,PermissionsCreate,PermissionsEdit, PermissionsDelete,PermissionsRead,PermissionsViewAllRecords,PermissionsModifyAllRecords from ObjectPermissions where ParentId in :idToPermissionSetMap.keySet() ] )
        {
            PermissionSet p = idToPermissionSetMap.get(op.parentId);
            
            if(profileIdToObjPermissonListMap.get(p.ProfileId)== null)
            profileIdToObjPermissonListMap.put(p.ProfileId, new List<ObjectPermissions>{op});
            else
            profileIdToObjPermissonListMap.get(p.ProfileId).add(op);
            
        }
        
        
        if(!profileIdToObjPermissonListMap.isEmpty())
        {
            for(objectPermission o: objectPermissions)// From the input file 
            {
                enteredLoop = false;
                o.profileId = profileNametoIdMap.get(o.profileName);
                if(profileIdToObjPermissonListMap.get(o.profileId) != null)
                {
                for(ObjectPermissions so: profileIdToObjPermissonListMap.get(o.profileId) )
                {
                    if(o.objectName == so.SobjectType)
                    {
                        enteredLoop = true;
                        if((o.permission.contains('Read') && so.PermissionsRead == true) ||(o.permission.contains('Edit') && so.PermissionsEdit == true)||
                        (o.permission.contains('Create') && so.PermissionsCreate == true) ||(o.permission.contains('Delete') && so.PermissionsDelete == true)||
                        (o.permission.contains('ViewAll') && so.PermissionsViewAllRecords == true) ||(o.permission.contains('ModifyAll') && so.PermissionsModifyAllRecords == true))
                        System.debug('Print__'+o);
                        else
                        errObjectPermissions.add(o);
                        
                          
                    }
                }
                if(!enteredLoop)
                errObjectPermissions.add(o);
                }
                else
                 errObjectPermissions.add(o);
                
            }
        }
        
        return null;
        
        
    }
    
 
    public Pagereference ReadFieldPermissionFile()
    {
        try
        {
        nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        fieldPermissions = new List<fieldPermission>();
        for (Integer i=1;i<filelines.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            
            fieldPermission a = new fieldPermission();
            a.profileName= inputvalues[0];
            a.objectName = inputvalues[1];
            a.fieldName = inputvalues[2];       
            a.permission = inputvalues[3];
            

            fieldPermissions.add(a);
        }
        validateFieldPermissionFile();
    	}
    	catch(Exception e)
        {
            System.debug('Exception in FieldPermissionFile '+ e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }
        return null;
    }  
    
    public PageReference validateFieldPermissionFile()
    {
        Map<String,Id> profileNametoIdMap = new Map<String,Id>();
        errFieldPermissions = new List<fieldPermission>();
        Map<id,List<FieldPermissions>> profileIdToFieldPermissonListMap = new Map<id,List<FieldPermissions>>();
        Set<String> profileNames = new Set<String>();
        Set<String> objectNames = new Set<String>();
        
        for(fieldPermission o: fieldPermissions) {
            profileNames.add(o.profileName);
            objectNames.add(o.objectName );
            
        }
        
        for(Profile p: [Select id, Name from Profile where name in :profileNames])
        profileNametoIdMap.put(p.name, p.id);
        System.debug('profileNametoIdMap__'+profileNametoIdMap);
        
        Map<id,PermissionSet> idToPermissionSetMap = new Map<id,PermissionSet>([Select id, ProfileId from PermissionSet where ProfileId in :profileNametoIdMap.values()]);
        System.debug('idToPermissionSetMap__'+idToPermissionSetMap);
        
        for(FieldPermissions op:[select id, parentId,SobjectType,PermissionsEdit,PermissionsRead,field from FieldPermissions where ParentId in :idToPermissionSetMap.keySet() ] )
        {
            PermissionSet p = idToPermissionSetMap.get(op.parentId);
            
            if(profileIdToFieldPermissonListMap.get(p.ProfileId)== null)
            profileIdToFieldPermissonListMap.put(p.ProfileId, new List<FieldPermissions>{op});
            else
            profileIdToFieldPermissonListMap.get(p.ProfileId).add(op);
            
        }
        System.debug('profileIdToFieldPermissonListMap__'+profileIdToFieldPermissonListMap);
        
        if(!profileIdToFieldPermissonListMap.isEmpty())
        {
            for(fieldPermission o: fieldPermissions)
            {
                o.profileId = profileNametoIdMap.get(o.profileName);
                 enteredLoop = false;
                if(profileIdToFieldPermissonListMap.get(o.profileId)!= null)
                {
                for(FieldPermissions so: profileIdToFieldPermissonListMap.get(o.profileId) )
                {
                        //System.debug('o.objectName == so.SobjectType && o.fieldName == so.Field : '+ o.objectName +' '+so.SobjectType+' '+o.fieldName+' '+so.Field);  
                   
                    String name = o.objectName+'.'+o.fieldName;
                    if(o.objectName == so.SobjectType && name == so.Field)
                    {
                    System.debug(' In Side : o.objectName == so.SobjectType && o.fieldName == so.Field : '+ o.objectName +' '+so.SobjectType+' '+o.fieldName+' '+so.Field);     
                        System.debug(' o.permission : so.PermissionsRead : so.PermissionsEdit '+  o.permission +' '+ so.PermissionsRead +' '+ so.PermissionsEdit);      
                		 enteredLoop = true;
                        if((o.permission.contains('Read') && (so.PermissionsRead != true )) ||(o.permission.contains('Edit') && so.PermissionsEdit != true)||
                        (o.permission.contains('None') && (so.PermissionsRead == true || so.PermissionsEdit == true) ))
                        errFieldPermissions.add(o);
                        
                          
                    }
                }
                
                if(!enteredLoop)
                 errFieldPermissions.add(o);
                 }
                 else
                 errFieldPermissions.add(o);
                 
            }
        }
        
        return null;
        
        
    }

    public Pagereference ReadUserOrAdminPermissionFile()
    {
        try
        {
        nameFile=contentFile.toString();
        filelines = nameFile.split('\n');
        UserOrAdminPermissions = new List<UserOrAdminPermission>();
        for (Integer i=1;i<filelines.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            
            UserOrAdminPermission a = new UserOrAdminPermission();
            a.profileName= inputvalues[0];
            a.permissionName = inputvalues[1];
            a.permission = inputvalues[2];
            

            UserOrAdminPermissions.add(a);
        }
        validateUserOrAdminPermissionFile();
        }
    catch(Exception e)
        {
            System.debug('Exception in FieldPermissionFile '+ e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }
        return null;
    }  
    
    public PageReference validateUserOrAdminPermissionFile()
    {
        Map<String,Id> profileNametoIdMap = new Map<String,Id>();
        errUserOrAdminPermissions = new List<UserOrAdminPermission>();
        //Map<id,List<FieldPermissions>> profileIdToFieldPermissonListMap = new Map<id,List<FieldPermissions>>();
        Set<String> profileNames = new Set<String>();
        //Set<String> objectNames = new Set<String>();
        
        for(UserOrAdminPermission o: UserOrAdminPermissions) {
            profileNames.add(o.profileName);
           // objectNames.add(o.objectName );
            
        }
        
        for(Profile p: [Select id, Name from Profile where name in :profileNames])
        profileNametoIdMap.put(p.name, p.id);
        System.debug('profileNametoIdMap__'+profileNametoIdMap);
        
        Map<id,PermissionSet> idToPermissionSetMap = new Map<id,PermissionSet>([Select id, ProfileId,PermissionsViewAllData,PermissionsEmailSingle, PermissionsEmailMass,PermissionsEditTask,PermissionsEditEvent,PermissionsExportReport,PermissionsImportPersonal,
        PermissionsManageUsers,PermissionsEditPublicTemplates,PermissionsModifyAllData,PermissionsManageCases,PermissionsManageKnowledge,PermissionsTagManager,PermissionsManageSolutions ,PermissionsCustomizeApplication,PermissionsEditReadonlyFields,PermissionsRunReports,PermissionsViewSetup,
        PermissionsNewReportBuilder,PermissionsActivateContract,PermissionsImportLeads,PermissionsManageLeads,PermissionsTransferAnyLead,PermissionsEditPublicDocuments
        
        from PermissionSet where ProfileId in :profileNametoIdMap.values()]);
        System.debug('idToPermissionSetMap__'+idToPermissionSetMap);
        Map<id,PermissionSet> profileIdToPermissionSetMap = new Map<id,PermissionSet>();
        if(!idToPermissionSetMap.isEmpty())
        for(PermissionSet p: idToPermissionSetMap.values())
        profileIdToPermissionSetMap.put(p.profileId,p);
        
        
        for(UserOrAdminPermission u: UserOrAdminPermissions)
        {
                u.profileId = profileNametoIdMap.get(u.profileName);
                PermissionSet p =  profileIdToPermissionSetMap.get(u.profileId);
                String userPermissionName = u.permissionName.trim();
                String userPermission = u.permission.trim();
                System.debug('PermissionSet p : '+p +' userPermissionName : '+ userPermissionName +' userPermission : '+ userPermission);
                if(p != null)
                {
                        if(userPermissionName =='SendMail')
                        if((userPermission == 'True' && !p.PermissionsEmailSingle)||(userPermission == 'False' && p.PermissionsEmailSingle))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='MassEmail')
                        if((userPermission == 'True' && !p.PermissionsEmailMass)||(userPermission == 'False' && p.PermissionsEmailMass))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='EditTasks')
                        if((userPermission == 'True' && !p.PermissionsEditTask)||(userPermission == 'False' && p.PermissionsEditTask))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='EditEvents')
                        if((userPermission == 'True' && !p.PermissionsEditEvent)||(userPermission == 'False' && p.PermissionsEditEvent))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ExportReports')
                        if((userPermission == 'True' && !p.PermissionsExportReport)||(userPermission == 'False' && p.PermissionsExportReport))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ImportPersonalContacts')
                        if((userPermission == 'True' && !p.PermissionsImportPersonal)||(userPermission == 'False' && p.PermissionsImportPersonal))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManageUsers')
                        if((userPermission == 'True' && !p.PermissionsManageUsers)||(userPermission == 'False' && p.PermissionsManageUsers))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManagePublicTemplates')
                        if((userPermission == 'True' && !p.PermissionsEditPublicTemplates)||(userPermission == 'False' && p.PermissionsEditPublicTemplates))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ModifyAllData')
                        if((userPermission == 'True' && !p.PermissionsModifyAllData)||(userPermission == 'False' && p.PermissionsModifyAllData))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManageCases')
                        if((userPermission == 'True' && !p.PermissionsManageCases)||(userPermission == 'False' && p.PermissionsManageCases))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManageSalesforceKnowledge')
                        if((userPermission == 'True' && !p.PermissionsManageKnowledge)||(userPermission == 'False' && p.PermissionsManageKnowledge))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='TagManager')
                        if((userPermission == 'True' && !p.PermissionsTagManager)||(userPermission == 'False' && p.PermissionsTagManager))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManagePublishedSolutions')
                        if((userPermission == 'True' && !p.PermissionsManageSolutions)||(userPermission == 'False' && p.PermissionsManageSolutions))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='CustomizeApplication')
                        if((userPermission == 'True' && !p.PermissionsCustomizeApplication)||(userPermission == 'False' && p.PermissionsCustomizeApplication))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='EditReadOnlyFields')
                        if((userPermission == 'True' && !p.PermissionsEditReadonlyFields)||(userPermission == 'False' && p.PermissionsEditReadonlyFields))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='RunReports')
                        if((userPermission == 'True' && !p.PermissionsRunReports)||(userPermission == 'False' && p.PermissionsRunReports))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ViewSetupandConfiguration')
                        if((userPermission == 'True' && !p.PermissionsViewSetup)||(userPermission == 'False' && p.PermissionsViewSetup))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ReportBuilder')
                        if((userPermission == 'True' && !p.PermissionsNewReportBuilder)||(userPermission == 'False' && p.PermissionsNewReportBuilder))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ActivateContracts')
                        if((userPermission == 'True' && !p.PermissionsActivateContract)||(userPermission == 'False' && p.PermissionsActivateContract))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ImportLeads')
                        if((userPermission == 'True' && !p.PermissionsImportLeads)||(userPermission == 'False' && p.PermissionsImportLeads))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManageLeads')
                        if((userPermission == 'True' && !p.PermissionsManageLeads)||(userPermission == 'False' && p.PermissionsManageLeads))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='TransferLeads')
                        if((userPermission == 'True' && !p.PermissionsTransferAnyLead)||(userPermission == 'False' && p.PermissionsTransferAnyLead))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ViewAllData')
                        if((userPermission == 'True' && !p.PermissionsViewAllData)||(userPermission == 'False' && p.PermissionsViewAllData))
                        errUserOrAdminPermissions.add(u);
                        
                        if(userPermissionName =='ManagePublicDocuments')
                        if((userPermission == 'True' && !p.PermissionsEditPublicDocuments)||(userPermission == 'False' && p.PermissionsEditPublicDocuments))
                        errUserOrAdminPermissions.add(u);
                        
                        
                        
                }
                else
                errUserOrAdminPermissions.add(u);
                
        }
        
        return null;
        
        
    }
  
    
    public class objectPermission
    {
        public String profileName{get;set;}
        public String profileId{get;set;}
        public String objectName{get;set;}
        public String permission{get;set;}
       
        
    }  
    
    public class fieldPermission
    {
        public String profileName{get;set;}
        public String profileId{get;set;}
        public String objectName{get;set;}
        public String fieldName{get;set;}
        public String permission{get;set;}
             
    } 
    public class UserOrAdminPermission
    {
        public String profileName{get;set;}
        public String profileId{get;set;}
        public String permissionName{get;set;}
        public String permission{get;set;}
       
        
    }   
     
}