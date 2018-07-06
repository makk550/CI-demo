//Adding this class to handle all the static variables, that can be used in Task triggers
public class TaskGateway{

    public static boolean skipForNewtaskTypes = false;
    
   
    
    public static Map<String, Id> recTypeNameIdMap = new Map<String,Id>();
    public static List<RecordType> recTypes = [select id,name,SobjectType from RecordType where 
                                                          (name like '%Support Callback%' and SobjectType ='Task')
                                                         OR (name ='Customer Success Activity')
                                                         OR ( name = 'Saas Ops Incident' and SobjectType ='External_RnD__c')];
     public static Id SupportRecTypeId;
     public static Id customerSuccessRecTypeId;
     public static Id saasOpsRecTypeId;
     
    static{
            
        for(RecordType recType : recTypes){
            recTypeNameIdMap.put(recType.SobjectType+';'+recType.Name , recType.Id);
        }
        SupportRecTypeId = recTypeNameIdMap.get('Task;Support Callback');
        customerSuccessRecTypeId = recTypeNameIdMap.get('Task;Customer Success Activity');  
        saasOpsRecTypeId = recTypeNameIdMap.get('External_RnD__c;Saas Ops Incident'); 
    }
                                                         
    //System.debug('recTypeNameIdMap:'+recTypeNameIdMap);

   /* public static Id SupportRecTypeId = [Select id from RecordType where name like '%Support Callback%' and SobjectType ='Task'].Id;
    public static Id customerSuccessRecTypeId = [Select id from RecordType where name ='Customer Success Activity'].Id;  
    public static RecordType[] saasOpsRecType= [Select id from RecordType where name = 'Saas Ops Incident' and SobjectType ='External_RnD__c'];*/
    public static RecordType[] supportRecType = [Select id,Name from RecordType where name like '%Support%' and SobjectType ='Task'];
    public static Profile currentUserProfile = [select name from Profile where id =:UserInfo.getProfileId()];
    public static String currentUserPMFKey = [select pmfkey__c from User where Id = : UserInfo.getUserId() ].pmfkey__c;
    public static String restorationTaskRecTypeId = System.label.Restoration_Task_RecordTypeID;//US217005 - Restoration task recordtype Id

    //US152151 
    @InvocableMethod
    public static void sendNotificationonEmailTask(List<Task> taskList){
        System.debug('In TaskGateway, sendNotificationonEmailTask');
        List<Id> caseIdList = new List<Id>();
        Map<Id,String> caseIdUpdateTextMap = new Map<Id,String>();

        for(Task taskRec: taskList){
            if(taskRec.WhatId!=null &&  String.valueOf(taskRec.WhatId).startsWith('500')){
                        caseIdList.add(taskRec.WhatId);
                        caseIdUpdateTextMap.put(taskRec.WhatId,taskRec.Description);                
                    }
        }

        if(caseIdList!= null && caseIdList.size()>0){
            UtilityFalgs.sendNotificationToCaseOwnerandTeamMemebers(caseIdList,caseIdUpdateTextMap,null);
        }       
    }
    //This can be used in AutoAssign Trigger.
    /*public static List<User_Skills__c> getUserSkillList(Set<Id> setOwnerIds){
        List<User_Skills__c> listUS=[SELECT Id,component_code__c, User__c, Maximum_Total_Cases__c, Maximum_Cases_Per_Day__c, Maximum_Severity1_Cases__c, 
                    Cases_Assigned__c,Severity_1_cases_assigned__c, Cases_assigned_perday__c FROM User_Skills__c where User__c in:setOwnerIds];

        return listUS;
    }*/

    /*
    //public static Id SupportRecTypeId = TaskGateway.getSupportCallBackRecordTypeId();
    //public static Id customerSuccessRecTypeId = TaskGateway.getCustomerSuccessRecordTypeId();
    public static Id getSupportCallBackRecordTypeId(){
        RecordType[] supportRt = [Select id from RecordType where name like '%Support Callback%' and SobjectType ='Task'];
        Id supRecTypeId;
        if(supportRt <> null && supportRt.size() > 0)
                    supRecTypeId = supportRt[0].id;
                System.debug('In TaskGateway supRecTypeId:'+supRecTypeId);  
                return  supRecTypeId;
    }

    public static Id getCustomerSuccessRecordTypeId() {
        RecordType[] rt = [Select id from RecordType where name ='Customer Success Activity'];
        Id recId;
        if(rt <> null && rt.size() > 0)
                    recId = rt[0].id;
                return recId;
    }*/

}