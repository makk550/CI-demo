trigger TaskTrigger on Task (before insert,after insert,after update) {

    if(Trigger.isBefore){
    
           try{
            final Task tsk = Trigger.new[0];
            final ID whatId = tsk.whatId;
            boolean isupdated = false;
            
            Schema.DescribeSObjectResult r = Apttus__APTS_Agreement__c.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            
            List<Apttus__APTS_Agreement__c> agrList;
            
            if(whatId != null) {
                if(string.valueof(whatId).substring(0,3) == keyPrefix)
                    agrList = [Select Id, CA_NDA_Flag__c, Apttus__IsLocked__c, Is_Agreement_Generated__c, Apttus__Status_Category__c,Apttus__Status__c from Apttus__APTS_Agreement__c where Id =: whatId];
            }    
            
            
            if(agrList != null) {
                if(tsk.subject.contains('Email') && tsk.subject.contains('sent for review')){
                    agrList[0].Apttus__Status__c = Label.Internal_Review;
                    isupdated = true;
                }
                
                if(tsk.subject.contains('Generated Agreement') || tsk.subject.contains('Imported Offline Document')){
                    agrList[0].Is_Agreement_Generated__c = true;
                    isupdated = true;
                }
                
                if(tsk.subject.contains('Regenerated Agreement')){
                    
                    if(agrList[0].CA_NDA_Flag__c == Label.Standard_NDA) {
                       agrList[0].Apttus__Status_Category__c = Label.Approved;
                       agrList[0].Apttus__Status__c = Label.Approved;
                       agrList[0].Apttus__IsLocked__c = true;
                       Approval.lock(agrList[0]);
                       isupdated = true;
                    }
                }
            }
            
            if(isupdated)
                update agrList;
        } catch(Exception e) {
            system.debug('Error Message::'+e.getMessage());
        }
        
    }
    
    
    //US133772 begins, to update lead fields on upsert of tasks - added by BAJPI01
    if(trigger.isAfter){
        if(Trigger.isInsert||Trigger.isUpdate){
            Set<id> LeadIds = new Set<id>(); //set of lead ids in the tasks being updated/inserted
            List<Lead> leadlist = new List<Lead>(); //list of lead records
            List<Task> completedtasklist = new List<Task>(); //list of completed tasks
            List<Task> opentasklist = new List<Task>(); //list of open tasks
            Map<Id,Task> opentaskmap = new Map<Id,Task>(); //open task map, storing the most recently modified task against the lead id
            Map<Id,Task> closedtaskmap = new Map<Id,Task>(); //closed task map, storing the most recently modified task against the lead id
            Set<id> closedopenleadids = new Set<Id>();
            List<Lead> closedopenleadlist = new List<Lead>();
            for(Task t : trigger.new){
                if(t.whoid!=null){
                    String leadornot =t.whoid;
                    String key = leadornot.substring(0,3);
                    if(key.equalsIgnoreCase('00Q')){ //if the whoid in task record is equal to a lead id, add to the set
                        LeadIds.add(t.whoid);
                        if(Trigger.isUpdate){
                            if((t.Status=='Completed'&&Trigger.oldmap.get(t.id).status!='Completed')){
                                closedopenleadids.add(t.whoid);
                            } 
                        }
                        
                    }
                }
            }
            if(LeadIds.size()>0){ //if the leadid size is greater than zero, or in other words, if the tasks updated/inserted belong to a lead, then query
                leadlist = [select id,Next_Sales_Activity__c,Next_Sales_Activity_Date__c,Last_Sales_Activity__c,Last_Sales_Activity_Date__c from lead where id in: leadids];
                completedtasklist = [select subject,activitydate,status,whoid,lastmodifieddate from task where whoid in: leadids and status='Completed' order by lastmodifieddate desc];
                opentasklist = [select subject,activitydate,status,whoid,lastmodifieddate from task where whoid in: leadids and status NOT IN ('Completed','Closed') order by lastmodifieddate desc];
            }
            if(completedtasklist.size()>0){ //if the completedtasklist has completed tasks
                for(task t:completedtasklist){ //iterate through the list
                    if(closedtaskmap.get(t.whoid)!=null){ //if the map has a value
                        Task temp = closedtaskmap.get(t.whoid); //get the value
                        if(temp.LastModifiedDate>t.LastModifiedDate) //compare the last modified date and add accordingly
                            closedtaskmap.put(t.whoid,temp);
                        else
                            closedtaskmap.put(t.whoid,t);
                    }
                    else{
                        closedtaskmap.put(t.whoid,t);
                    }
                }
            }
            if(opentasklist.size()>0){ //if the completedtasklist has open tasks
                for(task t:opentasklist){ //iterate through the list
                    if(opentaskmap.get(t.whoid)!=null){ //if the map has a value
                        Task temp = opentaskmap.get(t.whoid); //get the value
                        if(temp.LastModifiedDate>t.LastModifiedDate) //compare the last modified date and add accordingly
                            opentaskmap.put(t.whoid,temp);
                        else
                            opentaskmap.put(t.whoid,t);
                    }
                    else{
                        opentaskmap.put(t.whoid,t);
                    }
                }
            }
            
            if(closedtaskmap.size()>0){ //if the map has leadid and task values
                for(lead l:leadlist){ //iterate through the leadlist
                    if(closedtaskmap.get(l.id)!=null){ //if the given lead id has tasks
                        Task temp = closedtaskmap.get(l.id); //get the task and update values
                        l.Last_Sales_Activity__c = temp.subject;
                        l.Last_Sales_Activity_Date__c = Date.valueOf(temp.lastmodifieddate);
                        //Date.valueOf(temp.lastmodifieddate);
                    }
                }
            }
            
            if(leadlist.size()>0&&closedopenleadids.size()>0){
                for(lead l:leadlist){
                    if(closedopenleadids.contains(l.id)){
                        l.Next_Sales_Activity__c = null;
                        l.Next_Sales_Activity_Date__c = null;
                    }
                }
            }
            
            
            if(opentaskmap.size()>0){ //if the map has leadid and task values
                for(lead l:leadlist){ //iterate through the leadlist
                    if(opentaskmap.get(l.id)!=null){ //if the given lead id has tasks
                        Task temp= opentaskmap.get(l.id); //get the task and update values
                        l.Next_Sales_Activity__c = temp.subject;
                        l.Next_Sales_Activity_Date__c = temp.activitydate;
                    }
                }
            }
            
            
            
            if(leadlist.size()>0){
                /*for(lead l:leadlist){ //if the closed task was the one that was most recently open, change the next sales activity fields to null
                    if(l.Last_Sales_Activity__c==l.Next_Sales_Activity__c && l.Last_Sales_Activity_Date__c==l.Next_Sales_Activity_Date__c){
                        l.Next_Sales_Activity__c = null;
                        l.Next_Sales_Activity_Date__c = null;
                    }
                }*/
                try{
                    update leadlist;
                }
                catch(exception e){
                    system.debug('exception is '+e);
                }
            }
        }
    }
    //US133772 ends - BAJPI01
    
    
    
}