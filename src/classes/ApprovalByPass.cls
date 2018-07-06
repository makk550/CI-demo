global class ApprovalByPass {
    public static boolean showApprovalBypassButton{set;get;}
        
    public ApprovalByPass(ApexPages.StandardController controller) {
        
        showApprovalBypassButton = false;
        Set<Id> UserIdSet = new Set<Id>();
        group g = [SELECT (select userOrGroupId from groupMembers)            
            FROM group  WHERE name= 'Approval ByPass' LIMIT 1];            
            for (GroupMember gm : g.groupMembers){            
                UserIdSet.add(gm.userOrGroupId);            
            } 
        if(UserIdSet.contains(UserInfo.getUserId())){
            showApprovalBypassButton = true;
        }
        System.debug('+++++showApprovalBypassButton+++++++'+showApprovalBypassButton);
    }
    
    webservice static void updateStatus(Id recId){
        if(test.isRunningTest()) return;
        try{
            ProcessInstance PI =  [SELECT Id,Status FROM ProcessInstance where TargetObjectId =: recId AND Status=:'Pending' LIMIT 1];
            ProcessInstanceWorkitem prosInsWrkItms =  [SELECT Id, ProcessInstance.Id, ProcessInstance.Status, Actor.Id, Actor.Name, Actor.Type FROM ProcessInstanceWorkitem where ProcessInstance.Id=:PI.Id LIMIT 1];
            System.debug('+++++++prosInsWrkItms++++++'+prosInsWrkItms);
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Approved');
            req.setAction('Approve');               
            req.setWorkitemId(prosInsWrkItms.Id);  
            Approval.ProcessResult result2 =  Approval.process(req);   
        }catch(Exception e){
            /*scpq__SciQuote__c SQ = [select Oubound_Status__c from scpq__SciQuote__c where Id=:recId];
            SQ.Oubound_Status__c = 'Approved';
            update SQ;*/
        }
    }
    
    webservice static void updateRecallStatus(Id recId){
        try{
            ProcessInstance PI =  [SELECT Id,Status FROM ProcessInstance where TargetObjectId =: recId AND Status=:'Pending' LIMIT 1];
            ProcessInstanceWorkitem prosInsWrkItms =  [SELECT Id, ProcessInstance.Id, ProcessInstance.Status, Actor.Id, Actor.Name, Actor.Type FROM ProcessInstanceWorkitem where ProcessInstance.Id=:PI.Id LIMIT 1];
            System.debug('+++++++prosInsWrkItms++++++'+prosInsWrkItms);
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments('Recalled');
            req.setAction('Removed');               
            req.setWorkitemId(prosInsWrkItms.Id);  
            Approval.ProcessResult result2 =  Approval.process(req);   
        }catch(Exception e){
            
        }
    }

}