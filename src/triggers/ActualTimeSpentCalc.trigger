trigger ActualTimeSpentCalc on Event (after insert, after update) 
{
   //List<Event> lstUpdateEvents = new List<Event>();
   //List<Event> lstUpdateRequest = new List<Event>();
    
   //for(Event eve:trigger.new)
   //{     
   //if(trigger.isInsert){
   //            if(eve.IsAllDayEvent){
   //            Event temp_eve1=new Event(id=eve.id,Actual_Time_Spent_Hours__c=8);
   //            lstUpdateEvents.add(temp_eve1);
   //            }
   //         else if(eve.StartDateTime <> null && eve.EndDateTime <> null) {      
   //            Decimal starttime=eve.StartDateTime.getTime();                        
   //            Decimal endtime=eve.EndDateTime.getTime();
   //            Decimal diff=(endtime-starttime)/3600000;
   //            diff=diff.round(system.roundingmode.CEILING);
   //            if (diff > 160)
   //              diff = 160;
   //            Event temp_eve2=new Event(id=eve.id,Actual_Time_Spent_Hours__c=diff);
   //            lstUpdateEvents.add(temp_eve2);
   //            }
   //   if(eve.Start_Date_Time__c <> null && eve.End_Date__c <> null){
   //      Decimal reqstarttime=eve.Start_Date_Time__c.getTime();
   //      Decimal reqendtime=eve.End_Date__c.getTime();
   //      Decimal reqdiff=(reqendtime-reqstarttime)/3600000;
   //      reqdiff = reqdiff.round(system.roundingmode.CEILING);
   //      if (reqdiff > 160)
   //         reqdiff = 160;
   //      Event temp_eve3=new Event(id=eve.id,Duration_Hours__c=reqdiff);
   //      lstUpdateRequest.add(temp_eve3);
   //      }
   //}
   
   //if(trigger.isUpdate){  
   //    if(eve.EndDateTime <> trigger.oldMap.get(eve.id).EndDateTime || eve.StartDateTime <> trigger.oldMap.get(eve.id).StartDateTime)   
   //     {  
   //         if(eve.IsAllDayEvent){
   //            Event temp_eve1=new Event(id=eve.id,Actual_Time_Spent_Hours__c=8);
   //            lstUpdateEvents.add(temp_eve1);
   //            }
   //         else {      
   //            Decimal starttime=eve.StartDateTime.getTime();                        
   //            Decimal endtime=eve.EndDateTime.getTime();
   //            Decimal diff=(endtime-starttime)/3600000;
   //            diff = diff.round(system.roundingmode.CEILING);
   //            if (diff > 160)
   //               diff = 160;
   //            Event temp_eve2=new Event(id=eve.id,Actual_Time_Spent_Hours__c=diff);
   //            lstUpdateEvents.add(temp_eve2);
   //            }
   //     }       

   // }
   // }
    
   // if(lstUpdateEvents.size() > 0)
   //         update lstUpdateEvents; 
   //         update lstUpdateRequest;
}