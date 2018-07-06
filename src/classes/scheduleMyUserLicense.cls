global class scheduleMyUserLicense implements Schedulable{


    global void execute(SchedulableContext SC) {

    licenseThreshold lT = new licenseThreshold();
    lT.thresholdCheck();
    
    if(licenseThreshold.thresholdReached>0)
             lT.send();
     
   }
  }