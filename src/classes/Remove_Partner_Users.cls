public class Remove_Partner_Users
{

    @future
    public static void callTrigger(Set<Id> GroupMemberDelList) 
    {
        delete [Select id from GroupMember where id in :GroupMemberDelList];
    }

    @future
    public static void callTriggerInsert(Set<String> checkNowSet) 
    {
        QueueCust__c que = QueueCust__c.getvalues('Common Partner Lead Pool');
        List<GroupMember> GroupMemberList = new List<GroupMember>();
        for(user u: [Select id ,Related_Partner_Account__c from User where Related_Partner_Account__c IN : checkNowSet ])
        {
            GroupMember gm = new GroupMember();
            GM.GroupId =  que.Queue_ID__c;
            GM.UserOrGroupId = u.id;
            GroupMemberList.add(gm);
        }
            
        if(GroupMemberList!=null && !GroupMemberList.isEmpty())
        {
            try{
                insert GroupMemberList;
            } catch(Exception e){
                system.debug('Error while inserting :' + e.getMessage());
            }
        }
    }
}