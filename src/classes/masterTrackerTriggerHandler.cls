/*
* Test Class - MasterTrackerTestClass
* Coverage - 92%
*/
public class masterTrackerTriggerHandler implements ITrigger{
    
    public Static Map<String,Schema.SobjectType> ObjectMap = Schema.getGlobalDescribe();
    public Static Set<wrapperRecord> wrapRecSet;
	
    
    public void bulkBefore(){
        
    }
    
    public void bulkAfter(){
        
        Map <id,MasterTracker__c> newMap = (Map<id,MasterTracker__c>)trigger.newMap;
        Map <id,MasterTracker__c> oldMap = (Map<id,MasterTracker__c>)trigger.oldMap;
        
        List<MasterTracker__c> trackerListTrigger = new List<MasterTracker__c>();
        
        if(Trigger.isInsert||Trigger.isUpdate){
            trackerListTrigger = (List<MasterTracker__c>)trigger.new;
        }
        else if(Trigger.isDelete){
            trackerListTrigger = (List<MasterTracker__c>)trigger.old;
        }
        
		if(trackerListTrigger.size()>0)
	        conflictEmailAlertMethod(trackerListTrigger,newMap,oldMap);
        
        system.debug('Asit passing maps to handler : NewMap '+ newMap +' OldMap '+ oldMap);
        wrapRecSet = new Set<wrapperRecord>();
        wrapRecSet = onCcDlChangeTrigEmailAlert(newMap, oldMap);
    }
    
    public void beforeInsert(SObject so){
        
        MasterTracker__c mt = (MasterTracker__c)so;
        //setting the required in changeset field to true or false. Currently,
        //its false only when it's an existing page layout
        if(mt.Type__c=='Page Layout' && mt.NeworExisting__c=='Existing')
            mt.RequiredInChangeSet__c=false;
        else
            mt.RequiredInChangeSet__c=true;
        
        //defaulting conflict to No on insert
        mt.Conflict__c = 'No';
        
        //defaulting data added to tracker to today's date. - US380988 - BAJPI01
        mt.DateAddedtoTracker__c = System.today();
        //defaulting data added to tracker to today's date. - US380988 - BAJPI01
        
        //converting dev box name to lower case
        if(String.isNotBlank(mt.DevBoxName__c))
            mt.DevBoxName__c = mt.DevBoxName__c.toLowerCase();
        
        //converting user story to upper case
        if(String.isNotBlank(mt.Story_Req_SD__c))
            mt.Story_Req_SD__c = mt.Story_Req_SD__c.toUpperCase();
        
        //adding record type of data load
        if(mt.Type_of_Change__c=='Code/Config')
            mt.RecordTypeId = Schema.SObjectType.MasterTracker__c.getRecordTypeInfosByName().get('Code/Config').getRecordTypeId();
        else if(mt.Type_of_Change__c=='Date Load')
            mt.RecordTypeId = Schema.SObjectType.MasterTracker__c.getRecordTypeInfosByName().get('Date Load').getRecordTypeId();
        
        //adding errors for following conditions
        checkforInsertErrors(mt);
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        system.debug('----before update-----');
        MasterTracker__c mt = (MasterTracker__c)so;
        
        if(mt.Type_of_Change__c == 'Code/Config'){
            if(mt.ReleaseName__c==null){
                mt.AddError('Release Name cannot be blank.');
            }
            if(String.isBlank(mt.ComponentLabelName__c)){
                mt.AddError('Component Label Name cannot be blank.');
            }
            if(String.isBlank(mt.ComponentAPIName__c)){
                mt.AddError('Component API Name cannot be blank.');
            }
        }
        else if(mt.Type_of_Change__c  == 'Data Load'){
            if(mt.ReleaseName__c==null){
                mt.AddError('Release Name cannot be blank.');
            }    
        }
        
    }
    
    public void beforeDelete(SObject so){
        
    }
    
    public void afterInsert(SObject so){
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so){
        
    }
    
    public void afterDelete(SObject so){
        
    }
    
    public void andFinally(){
        if(Trigger.isAfter){
            if(wrapRecSet !=null && wrapRecSet.size()>0){
                system.debug('Asit set is not empty triggering emails');
                sendEmails(wrapRecSet);
            }
        }
        
    }
    
    public static Set<wrapperRecord> onCcDlChangeTrigEmailAlert(Map<Id,MasterTracker__c> newMtRecMap, Map<Id,MasterTracker__c> oldMtRecMap){
        system.debug('Asit in Handler');
        
        List<Master_Tracker_Email_Alert_Settings__c> trackerEmailSettingsList = Master_Tracker_Email_Alert_Settings__c.getAll().Values();
        Map<String,Master_Tracker_Email_Alert_Settings__c> trackerEmailSettingsMap = new Map<String,Master_Tracker_Email_Alert_Settings__c>();
        if(trackerEmailSettingsList!=null && trackerEmailSettingsList.size()>0){
            for(Master_Tracker_Email_Alert_Settings__c mtEmail:trackerEmailSettingsList){
                String key = mtEmail.Object_Name__c.ToUpperCase()+mtEmail.Type__c.ToUpperCase();
                trackerEmailSettingsMap.put(key,mtEmail);
            }
        }
        
        system.debug('BeforeTrigger: '+trigger.isBefore+ ' AfterTrigger ' + trigger.isAfter+ ' insert '+trigger.isInsert+' delete '+trigger.isDelete+' update '+trigger.isUpdate);
        Set<wrapperRecord> wrapRecSet = new Set<wrapperRecord>();         
        if(trigger.isDelete && trigger.isAfter && newMtRecMap == null && oldMtRecMap !=null){
            System.debug('Checking delete');
            newMtRecMap = oldMtRecMap;
        }
        if(newMtRecMap !=null && newMtRecMap.size()>0){
            System.debug('Checking delete in actual logic');
            for(MasterTracker__c mt : newMtRecMap.values()){
                if(mt.id != null){
                    system.debug('newMap are not null ' + newMtRecMap);
                    if(mt.Type_of_Change__c == 'Code/Config'){
                        if(String.isNotBlank(mt.ObjectName__c) && trackerEmailSettingsMap!=null && trackerEmailSettingsMap.size()>0){
                            String key = mt.ObjectName__c.ToUpperCase()+mt.Type__c.ToUpperCase();
                            system.debug('----key-----'+key);
                            if(trackerEmailSettingsMap.containsKey(key)){
                                
                                Master_Tracker_Email_Alert_Settings__c mtEmail = trackerEmailSettingsMap.get(key);
                                system.debug('---found custom setting----'+mtEmail);
                                if(mt.Type__c != 'Custom Field'){
                                    if(trigger.isInsert || trigger.isUpdate){
                                        wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'added',mt.BSA__c,mt.Developer__c));
                                        system.debug('Record Added in Wrapper Record');
                                    }
                                    else if(trigger.isDelete){
                                        wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c, mt.Type_of_Change__c,'removed',mt.BSA__c,mt.Developer__c));
                                        system.debug('Record Added in Wrapper Record');
                                    }
                                }
                                else{
                                    if(mtEmail.Custom_Field_API__c!='All'){
                                        mtEmail.Custom_Field_API__c = mtEmail.Custom_Field_API__c.ToUpperCase();
                                        Set<String> fieldVal = new Set<String>(mtEmail.Custom_Field_API__c.split(','));
                                        system.debug('---field set----'+fieldVal);
                                        if(fieldVal.contains(mt.ComponentAPIName__c.ToUpperCase())){
                                            if(trigger.isInsert || trigger.isUpdate){
                                                wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'added',mt.BSA__c,mt.Developer__c));
                                                system.debug('Record Added in Wrapper Record');
                                            }
                                            else if(trigger.isDelete){
                                                wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c, mt.Type_of_Change__c,'removed',mt.BSA__c,mt.Developer__c));
                                                system.debug('Record Added in Wrapper Record');
                                            }                                                     
                                        }
                                        else{
                                            if(trigger.isUpdate && oldMtRecMap != null && oldMtRecMap.size()>0){
                                                system.debug('oldMap are not null ' + oldMtRecMap);
                                                if(fieldVal.contains(oldMtRecMap.get(mt.id).ComponentAPIName__c)){
                                                    wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'removed',mt.BSA__c,mt.Developer__c));
                                                }
                                            }
                                        }
                                    }
                                    else if(mtEmail.Custom_Field_API__c=='All'){
                                        if(trigger.isInsert || trigger.isUpdate){
                                            wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'added',mt.BSA__c,mt.Developer__c));
                                            system.debug('Record Added in Wrapper Record');
                                        }
                                        else if(trigger.isDelete){
                                            wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'removed',mt.BSA__c,mt.Developer__c));
                                            system.debug('Record Added in Wrapper Record');
                                        }
                                    }
                                }
                            }                               
                        }
                    }
                    else if(mt.Type_of_Change__c == 'Data Load'){
                        if(mt.ObjectName__c != null && mt.ObjectName__c != '' && mt.ObjectName__c != 'null'){
                            if(Master_Tracker_Data_Load_Email_Alert__c.getValues(mt.ObjectName__c.toLowerCase()) !=null){
                                if(mt.ObjectName__c == Master_Tracker_Data_Load_Email_Alert__c.getValues(mt.ObjectName__c.toLowerCase()).Name){
                                    if(trigger.isInsert || trigger.isUpdate){
                                        wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'added',mt.BSA__c,null));
                                        system.debug('Record Added in Wrapper Record');
                                    }
                                    else if(trigger.isDelete){
                                        wrapRecSet.add(new wrapperRecord(mt.ComponentAPIName__c,mt.ComponentLabelName__c,mt.ObjectName__c,mt.Story_Req_SD__c,mt.Type_of_Change__c, 'removed',mt.BSA__c,null));
                                        system.debug('Record Added in Wrapper Record');
                                    }                                
                                }    
                            }                            
                        }
                    }
                } 
            }                
        }
        
        system.debug('Asit Wrapper Record ' + wrapRecSet);
        return wrapRecSet;
    }
    
    
    public class wrapperRecord{
        
        public String compApiName;
        public String compLabelName;
        public String objectName;
        public String userStory;
        public String typeOfChange;
        public String addOrRemove;
        public ID bsaRes;
        public ID devRes;
        
        public wrapperRecord(String compApiName, String compLabelName, String objectName, String userStory,String typeOfChange, String addOrRemove, ID BSA, ID Dev){            
            this.compApiName = CompApiName;
            this.compLabelName = CompLabelName;
            this.objectName = objectName;
            this.userStory = userStory;
            this.typeOfChange = typeOfChange;
            this.addOrRemove = addOrRemove;
            this.bsaRes = bsa;
            this.devRes = dev;
        }
    }
    
    public static void sendEmails(Set<wrapperRecord> wrapRecSet){
        
        Set<Id> devBsaIdSet = new Set<Id>();
        if(wrapRecSet != null && wrapRecSet.size()>0){
            for(wrapperRecord wr : wrapRecSet){
                if(wr.typeOfChange == 'Code/Config'){
                    devBsaIdSet.add(wr.bsaRes);
                    devBsaIdSet.add(wr.devRes);
                }
                else if(wr.typeOfChange == 'Data Load'){
                    devBsaIdSet.add(wr.bsaRes);
                }
            }           
        }
        if(devBsaIdSet.size()>0){
            masterTrackerEmailClass.populateUserEmail(devBsaIdSet);
        }
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        if(wrapRecSet != null && wrapRecSet.size()>0){
            for(wrapperRecord wr : wrapRecSet){
                List<String> codeConfigEmails = new List<String>(SYSTEM.Label.Code_Config_Email.split(';'));
                codeConfigEmails.add(UserInfo.getUserEmail());
                List<String> dataLoadEmails = new List<String>(SYSTEM.Label.Data_Load_Email.split(';'));
                dataLoadEmails.add(UserInfo.getUserEmail());
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSubject(masterTrackerEmailClass.ChangeAlertEmailSubject(wr.typeOfChange, wr.addOrRemove));
                message.setHtmlBody(masterTrackerEmailClass.ChangeAlertEmailBody(wr.compApiName, wr.compLabelName, wr.objectName, wr.userStory, wr.typeOfChange, wr.addOrRemove));
                if(wr.typeOfChange == 'Code/Config'){
                    if(masterTrackerEmailClass.userAndEmailMap!=null && masterTrackerEmailClass.userAndEmailMap.size()>0){
                        if(masterTrackerEmailClass.userAndEmailMap.containsKey(wr.bsaRes))
                            codeConfigEmails.add(masterTrackerEmailClass.userAndEmailMap.get(wr.bsaRes));
                        if(masterTrackerEmailClass.userAndEmailMap.containsKey(wr.devRes))
                            codeConfigEmails.add(masterTrackerEmailClass.userAndEmailMap.get(wr.devRes));
                    }
                    
                    message.setToAddresses(codeConfigEmails); 
                }
                else if(wr.typeOfChange == 'Data Load'){
                    if(masterTrackerEmailClass.userAndEmailMap!=null && masterTrackerEmailClass.userAndEmailMap.size()>0){
                        if(masterTrackerEmailClass.userAndEmailMap.containsKey(wr.bsaRes))
                            codeConfigEmails.add(masterTrackerEmailClass.userAndEmailMap.get(wr.bsaRes));
                    }
                    message.setToAddresses(dataLoadEmails); 
                }
                messages.add(message);            
            }
            
            if(messages!=null && messages.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }      
        
    }
    
    public static void checkforInsertErrors(MasterTracker__c mt){
        
        if(String.isBlank(mt.Type_of_Change__c)){
            mt.addError('Type of Change cannot be blank.');
        }
        else if(String.isNotBlank(mt.Type_of_Change__c)){
            if(mt.Type_of_Change__c == 'Code/Config'){
                if(mt.ReleaseName__c==null){
                    mt.addError('Release Name cannot be blank.');
                }
                if(String.isBlank(mt.Story_Req_SD__c)){
                    mt.addError('UserStory/Req/CR # cannot be blank.');
                }
                if(String.isBlank(mt.DevBoxName__c) ){
                    mt.addError('DevBox Name cannot be blank.');
                }
                if(String.isBlank(mt.NeworExisting__c)){
                    mt.addError('Please indicate if the component is New or Existing.');
                }
                if(String.isBlank(mt.Type__c)){
                    mt.addError('Component Type cannot be blank.');
                }
                if(String.isBlank(mt.ComponentLabelName__c)){
                    mt.addError('Component Label Name cannot be blank.');
                }
                if(String.isBlank(mt.ComponentAPIName__c)){
                    mt.addError('Component API Name cannot be blank.');
                }
                if(mt.Type__c!=null && (mt.Type__c=='Custom Object' ||mt.Type__c=='Custom Field' ||mt.Type__c=='Record Type'
                                        ||mt.Type__c=='Page Layout' ||mt.Type__c=='Validation Rule' ||mt.Type__c=='Button or Link' || mt.Type__c=='Custom Setting'
                                        ||mt.Type__c=='Custom Metadata Type' ||mt.Type__c=='Field Set' ||mt.Type__c=='Workflow Rule' ||mt.Type__c=='Workflow Email Alert'
                                        ||mt.Type__c=='Workflow Field Update' ||mt.Type__c=='Flow Definition' ||mt.Type__c=='Email Template' ||mt.Type__c=='Apex Trigger'
                                        ||mt.Type__c=='Approval Process' ||mt.Type__c=='Dashboard' ||mt.Type__c=='Document' 
                                        ||mt.Type__c=='List View' ||mt.Type__c=='Report') 
                   && String.isBlank(mt.ObjectName__c)){
                       mt.addError('Object/Folder Name cannot be blank.');
                   }
                if((mt.Type__c=='Custom Object' ||mt.Type__c=='Custom Field' ||mt.Type__c=='Record Type'||mt.Type__c=='Page Layout' ||
                    mt.Type__c=='Validation Rule' ||mt.Type__c=='Button or Link' || mt.Type__c=='Custom Setting'||mt.Type__c=='Custom Metadata Type'
                    ||mt.Type__c=='Field Set' ||mt.Type__c=='Workflow Rule' ||mt.Type__c=='Workflow Email Alert'||mt.Type__c=='Workflow Field Update'
                    ||mt.Type__c=='Flow Definition' ||mt.Type__c=='Apex Trigger'||mt.Type__c=='Approval Process' ||
                    mt.Type__c=='List View') && String.isNotBlank(mt.ObjectName__c)){
                        if(ObjectMap!=null && ObjectMap.size()>0){
                            Schema.SobjectType objectName = ObjectMap.get(mt.ObjectName__c);
                            system.debug('---objectname-----'+objectName);
                            if(objectName==null)
                                mt.addError('Please enter API Name of the Object.');
                        }                        
                    }
                if(mt.BSA__c==null){
                    mt.addError('BSA Resource cannot be blank.');                    
                }
                if(mt.Developer__c==null){
                    mt.addError('Developer Resource cannot be blank.');
                }
            }
            else if(mt.Type_of_Change__c == 'Data Load'){
                if(mt.ReleaseName__c==null){
                    mt.addError('Release Name cannot be blank.');
                }
                if(String.isBlank(mt.Story_Req_SD__c)){
                    mt.addError('UserStory/Req/CR # cannot be blank.');
                }
                if(String.isBlank(mt.Type__c)){
                    mt.addError('Type cannot be blank.');
                }
                if(mt.Type__c!=null && mt.Type__c!='Custom Object'){
                    mt.addError('Type can only be Custom Object for Data Load changes');
                }
                if(mt.Type__c!=null && mt.Type__c=='Custom Object' && String.isBlank(mt.ObjectName__c)){
                    mt.addError('Object/Folder Name cannot be blank.');
                }
                if(mt.Type__c=='Custom Object' && String.isNotBlank(mt.ObjectName__c)){
                    if(ObjectMap!=null && ObjectMap.size()>0){
                        Schema.SobjectType objectName = ObjectMap.get(mt.ObjectName__c);
                        system.debug('---objectname-----'+objectName);
                        if(objectName==null)
                            mt.addError('Please enter API Name of the Object.');
                    }                        
                }
                if(mt.BSA__c==null){
                    mt.addError('BSA Resource cannot be blank.');                    
                }                       
            }            
        }
    }
    
    public static void conflictEmailAlertMethod(List<MasterTracker__c> mtRecList,Map<Id,MasterTracker__c> newMtRecMap, Map<Id,MasterTracker__c> oldMtRecMap){
        
        Set<Id> mtRecordId = new Set<Id>();         //to store the id of the records that are getting inserted/updated
        List<String> apiNameList = new List<String>();      //to store the api names of the components from the records that are getting inserted/updated
        List<String> compType = new List<String>();         //to store the type of the components from the records that are getting inserted/updated
    	List<String> oldApiNameList = new List<String>();       //to store the api names of the components from the records that are getting deleted
    	List<String> oldCompType = new List<String>();          //to store the type of the components from the records that are getting deleted
        List<MasterTracker__c> conflictingMtRecords = new List<MasterTracker__c>();     //conflicting record list - updated with value yes for conflict.
        List<MasterTracker__c> trackerRecordList = new List<MasterTracker__c>();        //fetched from the conflictsMap that is created.
        List<MasterTracker__c> copyOfTrackerRecordList = new List<MasterTracker__c>();      //copy of trackerRecordList, to iterate over.   
        Set<MasterTracker__c> conflictingMtRecordsSet = new Set<MasterTracker__c>();    //conflicting record set.
        Set<MasterTracker__c> nonConflictingMtRecordsSet = new Set<MasterTracker__c>(); //non - conflicting record set - that change from Yes to No.
        Set<MasterTracker__c> allMtRecords = new Set<MasterTracker__c>();               //all records, new and existing - used to form the map.
        List<MasterTracker__c> newMtRecords = new List<MasterTracker__c>();             //records that are newly inserted/updated.
        Map<String,List<MasterTracker__c>> conflictsMap = new Map<String,List<MasterTracker__c>>(); //conflicts map - unique key, master tracker combination.
        List<MasterTracker__c> existingMtRecords = new List<MasterTracker__c>();    //existing tracker records, apart from the newlyinserted/updated records.
        
        string key;                                 //key - creates a unique combination to create the map, conflictsMap.
        Boolean conflictExists;                     //to check if tracker records have conflict or not, for a common key having more than 1 item in the list for the map, conflictsMap.
        Set<String> userStories = new Set<String>();        //to store the user stories that have conflict, for a given key.
        String componentApiName;                                //component API having conflict.
        String componentLabelName;                              //component Label having conflict.
        Set<id> userids = new Set<id>();                        //id of devs/bsas. used to fetch emailid from user object.
        List<String> userEmails = new List<String>();           //email id of users.
        Map<id,User> userEmailMap;
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        if(Trigger.isInsert){
            for(MasterTracker__c mt:mtRecList){
                mtRecordId.add(mt.id);
                apiNameList.add(mt.ComponentAPIName__c);
                compType.add(mt.Type__c);
            }
        }
        
        if(trigger.isUpdate && oldMtRecMap!=null && oldMtRecMap.size()>0){
            for(MasterTracker__c mt:mtRecList){
                if(mt.DevBoxName__c!=oldMtRecMap.get(mt.Id).DevBoxName__c || mt.InFSB1__c!=oldMtRecMap.get(mt.Id).InFSB1__c || 
                   mt.InFSB2__c!=oldMtRecMap.get(mt.Id).InFSB2__c || mt.InFSB3__c!=oldMtRecMap.get(mt.Id).InFSB3__c || 
                   mt.InFSB4__c!=oldMtRecMap.get(mt.Id).InFSB4__c || mt.InFSB5__c!=oldMtRecMap.get(mt.Id).InFSB5__c ||
                   mt.ComponentAPIName__c!=oldMtRecMap.get(mt.Id).ComponentAPIName__c || mt.Type__c!=oldMtRecMap.get(mt.Id).Type__c||
                   mt.ObjectName__c!=oldMtRecMap.get(mt.Id).ObjectName__c){
                       mtRecordId.add(mt.id);
                       apiNameList.add(mt.ComponentAPIName__c);
                       compType.add(mt.Type__c);
                       compType.add(oldMtRecMap.get(mt.Id).Type__c);
                       apiNameList.add(oldMtRecMap.get(mt.Id).ComponentAPIName__c);
                   }
            }
        }
        
        if(trigger.isDelete){
            for(MasterTracker__c mt:mtRecList){
                oldApiNameList.add(mt.ComponentAPIName__c);
                oldCompType.add(mt.Type__c);
            }
        }
        
        if(mtRecordId!=null && mtRecordId.size()>0){
            newMtRecords = [select id,DevBoxName__c,InFSB1__c,InFSB2__c,InFSB3__c,InFSB4__c,InFSB5__c,NeworExisting__c,
                            Type__c,ComponentLabelName__c,ComponentAPIName__c,ObjectName__c,BSA__c,Developer__c,Story_Req_SD__c,
                            Release_Date__c,Conflict__c,Type_of_Change__c from MasterTracker__c where id IN : mtRecordId];
            
            existingMtRecords = [select id,DevBoxName__c,InFSB1__c,InFSB2__c,InFSB3__c,InFSB4__c,InFSB5__c,NeworExisting__c,
                                 Type__c,ComponentLabelName__c,ComponentAPIName__c,ObjectName__c,BSA__c,Developer__c,Story_Req_SD__c,
                                 Release_Date__c,Conflict__c,Type_of_Change__c from MasterTracker__c where Release_Date__c>=:system.today() and
                                 id NOT IN : mtRecordId and ComponentAPIName__c IN :apiNameList and Type__c IN : compType];
            
        }
        
        if(oldApiNameList!=null && oldApiNameList.size()>0){
            existingMtRecords = [select id,DevBoxName__c,InFSB1__c,InFSB2__c,InFSB3__c,InFSB4__c,InFSB5__c,NeworExisting__c,
                                 Type__c,ComponentLabelName__c,ComponentAPIName__c,ObjectName__c,BSA__c,Developer__c,Story_Req_SD__c,
                                 Release_Date__c,Conflict__c,Type_of_Change__c from MasterTracker__c where Release_Date__c>=:system.today() and
                                 ComponentAPIName__c IN :oldApiNameList and Type__c IN : oldCompType];
        }
        
        
        if(newMtRecords!=null && newMtRecords.size()>0)
            allMtRecords.addAll(newMtRecords);
        if(existingMtRecords!=null && existingMtRecords.size()>0)
            allMtRecords.addAll(existingMtRecords);
        
        system.debug('------size of items-----'+allMtRecords.size());
        
        
        if(allMtRecords!=null && allMtRecords.size()>0){
            
            //Forming a map of unique key and records. The key is a combination of API Name, Type of Component
            //and/or Object/Folder name, as the case maybe.
            for(MasterTracker__c mt:allMtRecords){
                if(mt.Type_of_Change__c=='Code/Config'){
                    userids.add(mt.BSA__c);
                    userids.add(mt.Developer__c);
                    if(mt.Type__c=='Custom Object'||mt.Type__c=='Custom Field'||mt.Type__c=='Page Layout'||mt.Type__c=='Record Type'||
                       mt.Type__c=='Button or Link'||mt.Type__c=='Validation Rule'||mt.Type__c=='Custom Setting'||
                       mt.Type__c=='Field Set'||mt.Type__c=='Workflow Rule'||mt.Type__c=='Flow Definition'||mt.Type__c=='Email Template'){
                           system.debug('---object in conflict---');
                           key = mt.ComponentAPIName__c+mt.Type__c+mt.ObjectName__c;
                           if(String.isNotBlank(key))
                               key = key.toLowerCase();
                           
                           if(conflictsMap.get(key)!=null){
                               conflictsMap.get(key).add(mt);
                           }
                           else{
                               List<MasterTracker__c> tracklist = new List<MasterTracker__c>();
                               tracklist.add(mt);
                               conflictsMap.put(key,tracklist);
                           }
                       }
                    else{
                        system.debug('---non object conflict----');
                        key = mt.ComponentAPIName__c+mt.Type__c;
                        if(String.isNotBlank(key))
                            key = key.toLowerCase();
                        
                        if(conflictsMap.get(key)!=null){
                            conflictsMap.get(key).add(mt);
                        }
                        else{
                            List<MasterTracker__c> tracklist = new List<MasterTracker__c>();
                            tracklist.add(mt);
                            conflictsMap.put(key,tracklist);
                        }
                    }
                }  
            }
            
            //querying the emails of the users.
            if(userids!=null && userids.size()>0){
                userEmailMap = new Map<id,User>([select id,email from user where id IN:userids]);
            }
            
            //iterating over the conflicts map, and assigning the conflict variable to true/false,
            //depending on the box they are in.
            system.debug('---conflict map size-----'+conflictsMap.size());
            if(conflictsMap!=null && conflictsMap.size()>0){
                system.debug('---entered conflict map---');
                for(String mapkey:conflictsMap.keySet()){
                    
                    trackerRecordList = conflictsMap.get(mapkey);
                    
                    
                    //for key-value pair, where value has only 1 record, it means there is no conflict.
                    if(trackerRecordList.size()==1){
                        system.debug('---size 1 in conflict----');
                        if(trackerRecordList[0].Conflict__c=='Yes'){
                            trackerRecordList[0].Conflict__c='No';
                            conflictingMtRecordsSet.add(trackerRecordList[0]);
                            if(userEmailMap!=null && userEmailMap.size()>0){
                                if(userEmailMap.containsKey(trackerRecordList[0].BSA__c)){
                                    userEmails.add(userEmailMap.get(trackerRecordList[0].BSA__c).email);
                                }
                                if(userEmailMap.containsKey(trackerRecordList[0].Developer__c)){
                                    userEmails.add(userEmailMap.get(trackerRecordList[0].Developer__c).email);
                                } 
                            }
                            
                            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                            message.setSubject(masterTrackerEmailClass.conflictRemovedEmailSubject());
                            message.setHtmlBody(masterTrackerEmailClass.conflictRemovedEmailBody(trackerRecordList[0].ComponentAPIName__c, trackerRecordList[0].ComponentLabelName__c, trackerRecordList[0].Story_Req_SD__c));
                            message.setToAddresses(userEmails);
                            messages.add(message);
                        }
                    }
                    
                    //comparing conflict for key-value pair, where value has more than 1 record.
                    else if(trackerRecordList.size()>1){
                        system.debug('---size greater than 1---');
                        copyOfTrackerRecordList.clear();
                        copyOfTrackerRecordList.addAll(trackerRecordList);
                        
                        for(MasterTracker__c mt:trackerRecordList){
                            conflictExists = false;
                            for(MasterTracker__c copyMt:copyOfTrackerRecordList){
                                if(mt.id!=copyMt.id){
                                    
                                    conflictExists=true;
                                    mt.Conflict__c='Yes';
                                    
                                    userStories.add(mt.Story_Req_SD__c);
                                    userStories.add(copyMt.Story_Req_SD__c);
                                    
                                    if(userEmailMap!=null && userEmailMap.size()>0){
                                        if(userEmailMap.containsKey(mt.BSA__c)){
                                            userEmails.add(userEmailMap.get(mt.BSA__c).email);
                                        }
                                        if(userEmailMap.containsKey(mt.Developer__c)){
                                            userEmails.add(userEmailMap.get(mt.Developer__c).email);
                                        }   
                                    }                                         
                                }
                            }
                            if(conflictExists==true){
                                conflictingMtRecordsSet.add(mt);
                                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                message.setSubject(masterTrackerEmailClass.conflictEmailSubject());
                                message.setHtmlBody(masterTrackerEmailClass.conflictEmailBody(mt.ComponentAPIName__c, mt.ComponentLabelName__c, userStories));
                                message.setToAddresses(userEmails);
                                messages.add(message); 
                            }
                            else if(conflictExists==false){
                                if(mt.Conflict__c=='Yes'){
                                    mt.Conflict__c='No';
                                    conflictingMtRecordsSet.add(mt);
                                    if(userEmailMap!=null && userEmailMap.size()>0){
                                        if(userEmailMap.containsKey(mt.BSA__c)){
                                            userEmails.add(userEmailMap.get(mt.BSA__c).email);
                                        }
                                        if(userEmailMap.containsKey(mt.Developer__c)){
                                            userEmails.add(userEmailMap.get(mt.Developer__c).email);
                                        } 
                                    }
                                    
                                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                    message.setSubject(masterTrackerEmailClass.conflictRemovedEmailSubject());
                                    message.setHtmlBody(masterTrackerEmailClass.conflictRemovedEmailBody(mt.ComponentAPIName__c, mt.ComponentLabelName__c, mt.Story_Req_SD__c));
                                    message.setToAddresses(userEmails);
                                    messages.add(message);
                                }
                            }
                            
                            userStories.clear();
                            userEmails.clear();
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        if(conflictingMtRecordsSet!=null && conflictingMtRecordsSet.size()>0){
            conflictingMtRecords.addAll(conflictingMtRecordsSet);
        }
        if(conflictingMtRecords!=null && conflictingMtRecords.size()>0){
            update conflictingMtRecords;
        }
        if(messages!=null && messages.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }   
    }
    
}