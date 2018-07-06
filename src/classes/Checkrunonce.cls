/*
 * This class is created to stop the partneropportunity trigger calling itself recursively,
 * when renewal is converted to an opportunity, It converts at 20% with US149780 
 * Author: SAMTU01
*/
public class Checkrunonce {
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