trigger TPCLogic on Case (before Update) {

    if(Trigger.isBefore && Trigger.isUpdate){
        
        if( ! UtilityFalgs.isTPCLogicExecuted) {
        
        Map<String,String> tpcTeams = new Map<String,String>();
        Map<Id,List<Id>> userOwners = new Map<Id,List<Id>>();
        Map<Id,List<Id>> queueOwners= new Map<Id,List<Id>>();
       
        for(Case newCase : Trigger.new){
        
           //System.debug('newCase======###'+newCase.Case_Type__c);
           if(newCase.Case_Type__c != 'Case Concern' && newCase.Case_Type__c != System.Label.ProactiveCaseType){ 
            
                if(String.valueOf(newCase.ownerId).subString(0,3) == '005'){
                    //userOwners.put(newCase.ownerId,newCase.Id);
                    List<Id> values = userOwners.get(newCase.ownerId);
                    if(values == NULL){
                        values = new List<Id>();
                        userOwners.put(newCase.ownerId,values);
                    }
                    values.add(newCase.Id);
                }
                else{
                    List<Id> values = userOwners.get(newCase.ownerId);
                    if(values == NULL){
                        values = new List<Id>();
                        queueOwners.put(newCase.ownerId,values);
                    }
                    values.add(newCase.Id);
                }
            }    
        }
        
        if(!userOwners.isEmpty()){
            for(User caseOwner : [select id,contact.TPC_Team__c from User where Id IN : userOwners.keySet()]){
                for(Id caseId : userOwners.get(caseOwner.id)){
                    Trigger.newMap.get(caseId).TPC_Team__C = caseOwner.contact.TPC_Team__c;
                }
            }
        }
        
        if(!queueOwners.isEmpty()){
            Map<String,Id> queueNames = new Map<String,Id>();
            for(Group grp : [select Id,name from Group where Id IN : queueOwners.keySet() and Type = 'Queue']){
                queueNames.put(grp.name,grp.Id);
            }
            
            Map<String,Id> queueNameTPCTeamMap = new Map<String,Id>();
            
            /* for(TPC_Team__c tpcTeam : [select id,name from TPC_Team__c where name IN : queueNames.keySet()]){
                if(queueOwners.containsKey(queueNames.get(tpcTeam.Name))){
                    for(Id caseId : queueOwners.get(queueNames.get(tpcTeam.Name))){
                        Trigger.newMap.get(caseId).TPC_Team__C = tpcTeam.Id;
                    }
                }
            }
            
            */
            
            for(TPC_Team__c tpcTeam : [select id,name from TPC_Team__c where name IN : queueNames.keySet()]){
                queueNameTPCTeamMap.put(tpcTeam.name,tpcTeam.Id);
            }
            
            Set<String> AllQueueNames= new Set<String>();
            AllQueueNames.addAll(queueNames.keySet());
            Set<String> TPCQueueNames = new Set<String>();
            TPCQueueNames.addAll(queueNameTPCTeamMap.keySet());
            
            AllQueueNames.retainAll(TPCQueueNames);
            for(String queueName : queueNames.keySet()){
                if(!AllQueueNames.contains(queueName))
                    queueNameTPCTeamMap.put(queueName,NULL);
            }
            
            for(String queueName : queueNameTPCTeamMap.keySet()){
                if(queueOwners.containsKey(queueNames.get(queueName))){
                    for(Id caseId : queueOwners.get(queueNames.get(queueName))){
                        Trigger.newMap.get(caseId).TPC_Team__C = queueNameTPCTeamMap.get(queueName );
                    }
                }
            }
            
        }
            UtilityFalgs.isTPCLogicExecuted = true;
    } //if(isTPCLogicExecuted)
    }
    
}