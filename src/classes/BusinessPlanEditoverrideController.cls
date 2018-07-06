public class BusinessPlanEditoverrideController {
    public Id userid {get; set;}
    public String isUserHaveEditPer{get; set;}
	public BusinessPlanEditoverrideController(ApexPages.StandardController controller){  
        userid =userinfo.getUserId();
        List<GroupMember> groupmembers =[select id,group.Name,UserOrGroupId from GroupMember where group.Name='BP_EDIT_Permission' and Group.Type = 'Regular' and UserOrGroupId =:userid];
        if(groupmembers.size() > 0){
            isUserHaveEditPer ='YES';
        }else{
            isUserHaveEditPer ='NO';
        }
	}
}