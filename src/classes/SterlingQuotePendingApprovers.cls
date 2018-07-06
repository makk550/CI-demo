public class SterlingQuotePendingApprovers implements Schedulable{
    Static Integer MAX_APPROVERS_SIZE = 10;
   public void execute(SchedulableContext SC) {
      Date TwoDaysPriorDate = System.Today()-2;//2
      Date ThreeDaysPriorDate = System.Today()-3;//3
      System.debug('++++++++ThreeDaysPriorDate++++++++'+ThreeDaysPriorDate);
      System.debug('++++++++TwoDaysPriorDate++++++++'+TwoDaysPriorDate);
      List<ProcessInstance> PIList = [select id,TargetObjectId from ProcessInstance where Status=:'Pending' AND CreatedDate>=:ThreeDaysPriorDate AND CreatedDate<:TwoDaysPriorDate];
     
    System.debug('+++++PIList+++++'+PIList);
    Set<Id> ProcessInstanceIdSet = new Set<Id>();
    for(ProcessInstance PI:PIList){
        ProcessInstanceIdSet.add(PI.Id);
    }
    Map<Id,List<Id>> SQIdAndPendingUserIdsMap = new Map<Id,List<Id>>();
    //List<scpq__SciQuote__c> SQList = [select Id from scpq__SciQuote__c where CA_Approval_Id__c IN: ProcessInstanceIdSet];
    List<scpq__SciQuote__c> SQList =[Select c.Id, (Select Id, IsPending, ProcessInstanceId, TargetObjectId, StepStatus, OriginalActorId, ActorId, RemindersSent, Comments, IsDeleted, CreatedDate, CreatedById, SystemModstamp From ProcessSteps where ProcessInstanceId IN: ProcessInstanceIdSet ORDER BY CreatedDate DESC) 
                      From scpq__SciQuote__c c where CA_Approval_Id__c IN: ProcessInstanceIdSet];

          if (SQList.size()>0)
          {
              for(Integer i=0;i<SQList.size();i++){
                  scpq__SciQuote__c cs=SQList[i];
             //String commentsStr='';
                 System.debug('+++++++cs.ProcessSteps+++++++'+cs.ProcessSteps);
                 for (ProcessInstanceHistory ps : cs.ProcessSteps)
                 {
                     if(ps.StepStatus=='Pending'){
                         System.debug('++++++ps.ActorId+++++++'+ps.ActorId);
                         if(!SQIdAndPendingUserIdsMap.containsKey(SQList[i].Id)){
                             SQIdAndPendingUserIdsMap.put(SQList[i].Id,new List<Id>());
                             SQIdAndPendingUserIdsMap.get(SQList[i].Id).add(ps.ActorId);
                         }else
                             SQIdAndPendingUserIdsMap.get(SQList[i].Id).add(ps.ActorId);
                         
                     }
                    //commentsStr+='\nComment from user ' + ps.ActorId + ' : ' + ps.comments;
                    
                 }
                 System.debug('++++++SQIdAndPendingUserIdsMap+++++++'+SQIdAndPendingUserIdsMap);
              }
             
          } 
          for(scpq__SciQuote__c s:SQList){
                Integer i = 0;
                Id anyOneApproverId;
                if(SQIdAndPendingUserIdsMap !=null && SQIdAndPendingUserIdsMap.get(s.Id).size()>0){
                    for(Id ids:SQIdAndPendingUserIdsMap.get(s.Id)){
                        //s.Set_of_Approvers__c = ' ';
                        i++;
                        String str = 'Pending_'+'Approver'+i+'__c';              
                        s.put(str,ids);            
                        anyOneApproverId = ids;
                    }
                    
                    if(i<MAX_APPROVERS_SIZE){
                        for(Integer j=i+1;j<=MAX_APPROVERS_SIZE;j++){
                            String str = 'Pending_'+'Approver'+j+'__c';              
                            s.put(str,anyOneApproverId);
                        }
                    }
                    s.Has_Pending_Approvers__c = true;
                }
          }  
          update  SQList; 
   }
}