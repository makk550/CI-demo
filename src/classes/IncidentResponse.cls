/*
 * This class is used to parse Json Response of creating Incident in CSM
 * Structure of this class is same as JSON Create Incident Response
*/
public class IncidentResponse{  
  public string assigneeCompany ; 
  public string assigneeGroup ; 
  public string assigneeGroupId ;
  public string category ;
  public string subCategory ;
  public string ciType ;
  public string closedBy ;
  public string createdBy ; 
  public string impactedUserContactPhone ;
  public string impactedUserFirstName ;
  public string impactedUserId ;
  public string impactedUserLastName ;
  public string impactedUserLocation ;
  public string impactedUserOrganization ;
  public string incidentId ;
  public string incidentType ;
  public string reportedBy ;
  public string resolution ;
  public string resolutionFixType ;
  public string resolvedBy ;
  public string source ;
  public string templateId ;
  public string tenantId ;
  public string updatedBy ;
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
}