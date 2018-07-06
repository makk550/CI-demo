trigger SLO_Calculation on Task (before insert) {

if(Label.Integration_UserProfileIds.contains(userinfo.getProfileId().substring(0,15))){
 
  Set<Id> caseIdsToUpdSev= new Set<Id>();
  Id SupportRecType;
  String conMilli='60000';

  RecordType[] supportRt = [Select id from RecordType where name like '%Support Callback%' and SobjectType ='Task'];
  if(supportRt <> null && supportRt.size() > 0)
     SupportRecType = supportRt[0].id;
        
  for(Task t: Trigger.New)
  {
   if(t.status!='Completed' && t.status!='Closed' && t.whatid != null && t.RecordTypeId == SupportRecType && (String.ValueOf(t.WhatId).startsWith('500')))
       caseIdsToUpdSev.add(t.whatid);   
  }  
  
  
          
  if(caseIdsToUpdSev!=null && caseIdsToUpdSev.size()>0){
  
     DateTime targTime=System.now();
             
     Map<id,Case> caseMap = new Map<id,Case>([Select id, OwnerId, Severity__c,BusinessHoursId from Case Where id in : caseIdsToUpdSev and Status!='Closed']);
     for(Task t: Trigger.New){
            
        if( t.RecordTypeId == SupportRecType && t.WhatId!=null && caseMap.get(t.WhatId)!=null){
           
           if(t.CreatedDate!=null)
              targTime=t.CreatedDate;
          
           if(caseMap.get(t.WhatId).Severity__c=='1' && SLO_Milestones__c.getValues('Severity1')!=null){
            t.Due_Date_SLO__c=targTime.addMinutes(Integer.Valueof(SLO_Milestones__c.getValues('Severity1').Due_Date_SLO__c));
            t.SLO1_Milestone1__c=targTime.addMinutes(Integer.Valueof(SLO_Milestones__c.getValues('Severity1').SLO_Milestone_1__c));
            t.SLO2_Milestone2__c=targTime.addMinutes(Integer.Valueof(SLO_Milestones__c.getValues('Severity1').SLO_Milestone_2__c));
            t.SLO3_Milestone3__c=targTime.addMinutes(Integer.Valueof(SLO_Milestones__c.getValues('Severity1').SLO_Milestone_3__c));
            t.SLO4_Milestone4__c=targTime.addMinutes(Integer.Valueof(SLO_Milestones__c.getValues('Severity1').SLO_Milestone_4__c));         
        }  
        else if(caseMap.get(t.WhatId).Severity__c=='2' && caseMap.get(t.WhatId).BusinessHoursId!=null && SLO_Milestones__c.getValues('Severity2')!=null){

            t.Due_Date_SLO__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity2').Due_Date_SLO__c)*long.Valueof(conMilli)));
            t.SLO1_Milestone1__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity2').SLO_Milestone_1__c)*long.Valueof(conMilli)));
            t.SLO2_Milestone2__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity2').SLO_Milestone_2__c)*long.Valueof(conMilli)));//old value:4800000
            t.SLO3_Milestone3__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity2').SLO_Milestone_3__c)*long.Valueof(conMilli)));
            t.SLO4_Milestone4__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity2').SLO_Milestone_4__c)*long.Valueof(conMilli)));//old Value:6900000
        }  
        else if(caseMap.get(t.WhatId).Severity__c=='3' && caseMap.get(t.WhatId).BusinessHoursId!=null && SLO_Milestones__c.getValues('Severity3')!=null){

            t.Due_Date_SLO__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity3').Due_Date_SLO__c)*long.Valueof(conMilli)));
            t.SLO1_Milestone1__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity3').SLO_Milestone_1__c)*long.Valueof(conMilli)));
            t.SLO2_Milestone2__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity3').SLO_Milestone_2__c)*long.Valueof(conMilli)));
            t.SLO3_Milestone3__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity3').SLO_Milestone_3__c)*long.Valueof(conMilli)));
            t.SLO4_Milestone4__c=BusinessHours.addGmt(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity3').SLO_Milestone_4__c)*long.Valueof(conMilli)));// old value: 14100000
        }          
        else if(caseMap.get(t.WhatId).Severity__c=='4' && caseMap.get(t.WhatId).BusinessHoursId!=null && SLO_Milestones__c.getValues('Severity4')!=null){

            t.Due_Date_SLO__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity4').Due_Date_SLO__c)*long.Valueof(conMilli)));
            t.SLO1_Milestone1__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity4').SLO_Milestone_1__c)*long.Valueof(conMilli))); //43200000
            t.SLO2_Milestone2__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity4').SLO_Milestone_2__c)*long.Valueof(conMilli))); //64800000
            t.SLO3_Milestone3__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity4').SLO_Milestone_3__c)*long.Valueof(conMilli))); //77760000
            t.SLO4_Milestone4__c=BusinessHours.add(caseMap.get(t.WhatId).BusinessHoursId,targTime,(long.Valueof(SLO_Milestones__c.getValues('Severity4').SLO_Milestone_4__c)*long.Valueof(conMilli))); // 85500000                         
        } 
     }    
   }
  }
 }           
}