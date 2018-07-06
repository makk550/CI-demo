/*
 * This class is used to create Json Request for creating Incident in CSM
 * Structure of this class is same as JSON Create Incident Request
*/
public class IncidentRequest{

   public String description ; 
   public String severity ;
   public String label ;
   public String priority ;   
   public cProperty customproperties ;
   
   public class cProperty {
    public List<fieldProperty> property ;
    public  cProperty (List<fieldProperty> iProperty){
    	property = iProperty.Clone();
    }
   }
    public class fieldproperty{
      public string name ; 
      public string value ;
    }
   //paramerized constructor 
   public IncidentRequest(String iDescription, String iSeverity,String iSubject,String iPriority,cProperty iCustomproperties) {
  	    if(iDescription!=null){ 
        	description = iDescription;
  	    }
  	    else {
  	    	description = '';
  	    }
        severity = iSeverity;
        label = iSubject;
        priority = iPriority;
        customproperties = iCustomproperties;
   }
}