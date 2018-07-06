/*
 * This class is used to send updates to CSM when Incident is updated. 
 * It keeps track of which fields to send and contains boolean member variables 
 * Depending on true or false , the field value will be sent to CSM via HTTP callout
 * This class is used to maintain which field to send because callout is made within future method from trigger
 * The future method cannot keep track of Trigger Old values.
*/
public class IncidentUpdateRequest {
  
  public Boolean severity ; 
  public Boolean priority ; 
  public Boolean dueDate ; 
  public Boolean label; 
  public Boolean description; 
  public Boolean status; 
  
  public IncidentUpdateRequest (){
     severity = false; 
     priority = false; 
     dueDate = false; 
     label = false; 
     description = false; 
     status = false;  
  
  }
  
}