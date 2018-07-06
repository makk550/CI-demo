/*
 * Test Class = masterTrackerTestClass
 * Updated by - BAJPI01
 * Coverage = 100%
*/ 
public class masterTrackerEmailClass {
    
    public static Map<Id,string> userAndEmailMap = new Map<Id,String>();
    
    public static string conflictEmailSubject(){
        String subject = 'SFDC Master Tracker : Possible Conflict in Components';
        return subject;
    }
    
    public static string conflictRemovedEmailSubject(){
        String subject = 'SFDC Master Tracker : Conflict in Components Removed';
        return subject;
    }
    
    public static string conflictEmailBody(String compApiName, String compLabelName, Set<String> userStories){
        string body;
        string ustories = '';
        for(String s:userStories){
            ustories += (ustories==''?'':',')+s;
        }
        body = 'Hello All,<br/><p>There is a possible conflict in the component.</p><p>Component API Name: '+compApiName+'<br/>';
        body = body+'Component Label Name: '+compLabelName+'<br/>User Stories: '+ustories+'<br/></p>';
        body = body + '<p>Please review the changes, if needed.</p><p>Thanks,<br/>Salesforce</p>';
        return body;
    }
    
    public static string conflictRemovedEmailBody(String compApiName, String compLabelName, String userStory){
        string body;
        body = 'Hello All,<br/><p>The conflict in the component has been removed.</p><p>Component API Name: '+compApiName+'<br/>';
        body = body+'Component Label Name: '+compLabelName+'<br/>User Story: '+userStory+'<br/></p>';
        body = body + '<p>Thanks,<br/>Salesforce</p>';
        return body;
    }
    
    //Asit*    
    public static string ChangeAlertEmailSubject(String typeOfChange, String addOrRemove){
        String subject = 'SFDC Master Tracker : SOX Alert - '+typeOfChange+' Change '+addOrRemove;
        return subject;
    }
    
    public static string ChangeAlertEmailBody(String compApiName, String compLabelName, String objectName, String userStory, String typeOfChange, String addOrRemove){
        string body;
        body = 'Hello All,<br/><p>Following '+typeOfChange+' change has been '+addOrRemove+' to the Master Tracker.<br/>Please review if they ';
        body = body+'fall under SOX Compliance.</p><p>';
        if(typeOfChange=='Code/Config')
	        body = body+ 'Component API Names: '+compApiName+'<br/>Component Label Name: '+compLabelName;
        body = body+'<br/>Object Name: '+objectName+'<br/>User Story#: '+userStory+'<br/></p>';
        body = body + '<p>Thanks,<br/>Salesforce</p>';
        return body;
    }
    //Asit#
    
    
    public static void populateUserEmail(Set<Id> userIdSet){

        List<User> userList = [select id,email from user where id IN:userIdSet AND isActive=true];
        if(userList!=null && userList.size()>0){
            for(User u:userList){
                userAndEmailMap.put(u.id,u.email);
            }
        }
        
    }
}