trigger CRMSFDC71_EventStarEndDateCalculation on Event (before insert, before update) {

    //List<Event> lstNew = Trigger.new;
    //List<Event> lstOld = Trigger.old;
    //for(Integer i = 0; i <lstNew.size(); i++)
    //{
    //    if(Trigger.isInsert){
    //        if(lstNew[i].StartDateTime!=null && lstNew[i].EndDateTime!=null){
    //        if( lstNew[i].Start_Date_Time__c == null)
    //                lstNew[i].Start_Date_Time__c = lstNew[i].StartDateTime;
    //        if(lstNew[i].End_Date__c == null )
    //                lstNew[i].End_Date__c = lstNew[i].EndDateTime;
             
    //        if(lstNew[i].IsAllDayEvent)
    //                    lstNew[i].Duration_Hours__c=8;
    //        else{
    //                    Decimal starttime=lstNew[i].Start_Date_Time__c.getTime();                        
    //                    Decimal endtime=lstNew[i].End_Date__c.getTime();
    //                    Decimal diff=(endtime-starttime)/3600000;
    //                    //lstNew[i].addError('time='+lstNew[i].End_Date__c.getTime()+'end '+lstNew[i].Start_Date_Time__c.getTime()+ 'diff'+(endtime-starttime)/3600000);
    //                    //lstNew[i].Duration_Hours__c=diff.round(system.roundingmode.CEILING);                        
    //        }
    //      // lstNew[i].Actual_Time_Spent_Hours__c=lstNew[i].Duration_Hours__c;

    //    }
    //    }
    //    if(Trigger.isUpdate){
    //    if(lstNew[i].StartDateTime!=null && lstNew[i].EndDateTime!=null){

    //    //if((lstNew[i].Actual_Time_Spent_Hours__c== null && lstOld[i].Actual_Time_Spent_Hours__c== null) ||( lstOld[i].Actual_Time_Spent_Hours__c != lstNew[i].Actual_Time_Spent_Hours__c))
    //        //changeTime=true;
    //        if( lstNew[i].Start_Date_Time__c == null)  
    //            lstNew[i].Start_Date_Time__c = lstNew[i].StartDateTime;                 
    //        else if( lstOld[i].StartDateTime == lstNew[i].Start_Date_Time__c)
    //            lstNew[i].Start_Date_Time__c = lstNew[i].StartDateTime;               
    //        if(lstNew[i].End_Date__c == null ) 
    //            lstNew[i].End_Date__c = lstNew[i].EndDateTime;          
    //        else if( lstOld[i].EndDateTime == lstNew[i].End_Date__c)
    //            lstNew[i].End_Date__c = lstNew[i].EndDateTime;
           
    //       if(lstNew[i].IsAllDayEvent)
    //                    lstNew[i].Duration_Hours__c=8;
    //                else{
    //                    Decimal starttime=lstNew[i].Start_Date_Time__c.getTime();                        
    //                    Decimal endtime=lstNew[i].End_Date__c.getTime();
    //                    Decimal diff=(endtime-starttime)/3600000;
    //                    //lstNew[i].addError('time='+lstNew[i].End_Date__c.getTime()+'end '+lstNew[i].Start_Date_Time__c.getTime()+ 'diff'+(endtime-starttime)/3600000);
    //                    lstNew[i].Duration_Hours__c=diff.round(system.roundingmode.CEILING);
                        
    //                }
  
    //               //if(lstOld[i].Actual_Time_Spent_Hours__c ==lstOld[i].Duration_Hours__c)//!= lstNew[i].Actual_Time_Spent_Hours__c)
    //                   //lstNew[i].Actual_Time_Spent_Hours__c=lstNew[i].Duration_Hours__c;
                       
    //               //if(lstNew[i].Actual_Time_Spent_Hours__c !=lstOld[i].Duration_Hours__c && !lstNew[i].Actual_time_changed_manually__c)//!= lstNew[i].Actual_Time_Spent_Hours__c)
    //               //         lstNew[i].Actual_time_changed_manually__c=  
    //           //      else if(!lstNew[i].Actual_time_changed_manually__c)
    //            //          lstNew[i].Actual_Time_Spent_Hours__c=lstNew[i].Duration_Hours__c;
           
    //       }
       
    //    }
    //}  

}