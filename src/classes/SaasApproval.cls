global class SaasApproval{
    public static boolean showApprovalButton{set;get;}
    public SaaSApproval(ApexPages.StandardController controller) {
        showApprovalButton = false;
        Set<Id> UserIdSet = new Set<Id>();
        group g = [SELECT (select userOrGroupId from groupMembers)            
            FROM group  WHERE name= 'Approve SaaS'];            
            for (GroupMember gm : g.groupMembers){            
                UserIdSet.add(gm.userOrGroupId);            
            } 
        if(UserIdSet.contains(UserInfo.getUserId())){
            showApprovalButton = true;
        }
        System.debug('*** SKG: showApprovalButton ***'+showApprovalButton );
    }
    }