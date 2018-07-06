/*
SFDC CRM 7.1 req - 644  
req description - Have system auto generate the overlay codes based on a “lookup” table that concatenatess 
the quota code, territory (combo of territory and quota code would equal overlay code.

Class overview - class called from trigger - CA_TAQ_OverlayCodesMapping on Insert/update of TAQ ORG 
Approved records auto populate the overlay codes for Quota 1, Quota 2 and Quota 3 
by referencing the Overlay code mapping table custom object.

This requirement is for NA only and works for certain plan types (stored in overlay codes object)
Developed by Heena - Accenture IDC on 3 Sept 2010
*/
public class CA_TAQ_Org_OverlayMapping{}
//* FY13 - FUNCTIONALITY MOVED ON TO TAQ ORG QUOTA APPROVED OBJECT. - TADKR01
  
/*
public class CA_TAQ_Org_OverlayMapping{

    public void Org_Approved_overlayMapping (List<TAQ_Organization_Approved__c> TAQList){
        boolean isSetQuota1= false;
        boolean isSetQuota2= false;
        boolean isSetQuota3= false;
        boolean isBUEmptyQuota1= false;
        boolean isBUEmptyQuota2= false;
        boolean isBUEmptyQuota3= false;
        //query all the overlay code rules in the system
        List<Overlay_codes__c> overlaycodes= [Select  Quota_Type__c, Quota_Territory_Country__c, Quota_BU__c, Plan_Type__c,  Name, Id  From Overlay_Codes__c ];
        //if NA TAQ records with requested plan type exist find the matching overlay codes
        for(TAQ_Organization_Approved__c TAQ_org:TAQList){
            isSetQuota1= false;
            isSetQuota2= false;
            isSetQuota3= false;
            isBUEmptyQuota1= false;
            isBUEmptyQuota2= false;
            isBUEmptyQuota3= false;
         
            //if there exist any overlay rules in the system process the TAQ records
            if(overlaycodes!=null){
                for(Overlay_codes__c overlaycode:overlaycodes){
        
                    //checking for Quota 1 fields with Current overlay code rule only if flag is not true
                    if(!isSetQuota1) {                        
                        if((TAQ_org.Quota1_Territory_Country__c==overlaycode.Quota_Territory_Country__c && overlaycode.Quota_Territory_Country__c !=null)
                        && (TAQ_org.Quota1_Type__c==overlaycode.Quota_Type__c&& overlaycode.Quota_Type__c!=null)
                        && overlaycode.Plan_Type__c.contains(TAQ_org.Plan_Type__c)){              
                            TAQ_org.Overlay1_Code_NA__c=overlaycode.name;                            
                            isSetQuota1= true; 
                        }   
                        else if((TAQ_org.Quota1_Territory_Country__c==overlaycode.Quota_Territory_Country__c  && overlaycode.Quota_Territory_Country__c !=null)
                        && (TAQ_org.Quota1_Type__c==overlaycode.Quota_Type__c  && overlaycode.Quota_Type__c!=null)
                        && (overlaycode.Quota_BU__c==null || overlaycode.Quota_BU__c=='') 
                        && overlaycode.Plan_Type__c.contains(TAQ_org.Plan_Type__c)){                
                            TAQ_org.Overlay1_Code_NA__c=overlaycode.name; 
                            isBUEmptyQuota1= true; 
                        } 
                        else if(!isBUEmptyQuota1) 
                            TAQ_org.Overlay1_Code_NA__c=null;
                    }
                    
                    //checking for Quota 2 fields with Current overlay code rule only if flag is not true
                    if(!isSetQuota2) {  
                        if((TAQ_org.Quota2_Territory_Country__c==overlaycode.Quota_Territory_Country__c && overlaycode.Quota_Territory_Country__c !=null)
                         && (TAQ_org.Quota2_Type__c==overlaycode.Quota_Type__c && overlaycode.Quota_Type__c!=null)
                         && (overlaycode.Quota_BU__c!=null && TAQ_org.Quota2_BU__c==overlaycode.Quota_BU__c ) 
                         && overlaycode.Plan_Type__c.contains(TAQ_org.Plan_Type__c)){
                            TAQ_org.Overlay2_Code_NA__c=overlaycode.name;  
                            isSetQuota2= true;  
                        }   
                        else if ((TAQ_org.Quota2_Territory_Country__c==overlaycode.Quota_Territory_Country__c && overlaycode.Quota_Territory_Country__c !=null)
                         && (TAQ_org.Quota2_Type__c==overlaycode.Quota_Type__c && overlaycode.Quota_Type__c!=null)
                         && (overlaycode.Quota_BU__c==null || overlaycode.Quota_BU__c=='')// && TAQ_org.Quota2_BU__c==overlaycode.Quota_BU__c  
                         && overlaycode.Plan_Type__c.contains(TAQ_org.Plan_Type__c)){
                            TAQ_org.Overlay2_Code_NA__c=overlaycode.name;  
                            isBUEmptyQuota2= true; 
                        }
                        else if(!isBUEmptyQuota2)
                            TAQ_org.Overlay2_Code_NA__c=null;
                    }
                    
                    //checking for Quota 3 fields with Current overlay code rule only if flag is not true
                    if(!isSetQuota3) {
                        if((TAQ_org.Quota3_Territory_Country__c==overlaycode.Quota_Territory_Country__c && overlaycode.Quota_Territory_Country__c !=null)
                        && (TAQ_org.Quota3_Type__c==overlaycode.Quota_Type__c && overlaycode.Quota_Type__c!=null)
                        && (TAQ_org.Quota3_BU__c==overlaycode.Quota_BU__c && overlaycode.Quota_BU__c!=null)
                        && overlaycode.Plan_Type__c.contains(TAQ_org.Plan_Type__c)){
                            TAQ_org.Overlay3_Code_NA__c=overlaycode.name;
                            isSetQuota3= true;                           
                        }
                        else if((TAQ_org.Quota3_Territory_Country__c==overlaycode.Quota_Territory_Country__c && overlaycode.Quota_Territory_Country__c !=null)
                        && (TAQ_org.Quota3_Type__c==overlaycode.Quota_Type__c && overlaycode.Quota_Type__c!=null)
                        && (overlaycode.Quota_BU__c==null || overlaycode.Quota_BU__c=='')// && TAQ_org.Quota3_BU__c==overlaycode.Quota_BU__c 
                        && overlaycode.Plan_Type__c.contains(TAQ_org.Plan_Type__c)){
                            TAQ_org.Overlay3_Code_NA__c=overlaycode.name;
                            isBUEmptyQuota3= true; 
                        }
                        else if(!isBUEmptyQuota3) 
                            TAQ_org.Overlay3_Code_NA__c=null;
                    }
                    //no need to loop further if all three overlay codes are set
                    if(isSetQuota1 && isSetQuota2 && isSetQuota3 )
                    break;
                }           
            }
        }
    }
    
     FY 13.
    @isTest
    private static void CA_TAQ_Org_OverlayMapping_Class_test() {
        List<Overlay_codes__c > testoverlaycodes = new List<Overlay_codes__c >();
        testoverlaycodes.add(New Overlay_codes__c(Quota_Type__c = 'test Type', Quota_Territory_Country__c= 'test Territory1', Quota_BU__c = 'test BU', Plan_Type__c='test plan type', Name= 'test overlay1'));
        testoverlaycodes.add(New Overlay_codes__c(Quota_Type__c = 'test Type', Quota_Territory_Country__c= 'test Territory2', Plan_Type__c='test plan type', Name= 'test overlay2'));
        insert testoverlaycodes;  
        TAQ_Organization_Approved__c TAQ_orgTemp1 = new TAQ_Organization_Approved__c(region__c='NA',Plan_Type__c='test plan type',
        Quota3_Type__c='test Type',Quota3_Territory_Country__c='test Territory1',Quota3_BU__c='test BU',
        Quota2_Type__c='test Type',Quota2_Territory_Country__c='test Territory1',Quota2_BU__c='test BU');            
        insert TAQ_orgTemp1;
        TAQ_orgTemp1.Quota2_Type__c='test Type'; 
        TAQ_orgTemp1.Quota2_Territory_Country__c='test Territory2'; 
        TAQ_orgTemp1.Quota2_BU__c='test BU'; 
        TAQ_orgTemp1.Quota3_Type__c='test Type'; 
        TAQ_orgTemp1.Quota3_Territory_Country__c='test Territory2'; 
        TAQ_orgTemp1.Quota3_BU__c='test BU'; 
        TAQ_orgTemp1.Quota1_Type__c='test Type'; 
        TAQ_orgTemp1.Quota1_Territory_Country__c='test Territory2'; 
        
        update TAQ_orgTemp1;
    } 
}*/