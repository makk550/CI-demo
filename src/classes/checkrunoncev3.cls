public class checkrunoncev3 {

// Created by Jaina04
 public static boolean renewaltoOpp= true;        
    public static boolean runOnce(){
    
    if(renewaltoOpp){
     renewaltoOpp=false; //Sets to false while the trigger is fired for the first time
     return true;
    }else{
        return renewaltoOpp;
    }
    }
 


}