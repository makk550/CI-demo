public class SiteUtilServicesHandler {
    public static List<SiteUtilServicesDataWrapper.Data> siteDataDetailsWrapperList{get;set;}
    public static String[] inputRequestDetails=null;
    public static SiteUtilServicesDataWrapper siteUtilDetailsWrapper {get;set;}
    public static String responseFromService {get;set;}
    
    public static String[] buildServiceInput(String topsSiteID,String caProductName,String startRecNum,String serviceName){
        try{
            if(serviceName.equalsIgnoreCase('EntitlementService')){
                inputRequestDetails=new String[3];
                inputRequestDetails[0]=topsSiteID;
                inputRequestDetails[1]=startRecNum;                                
                inputRequestDetails[2]=System.Label.SiteServicesCalloutRecordsLimit;                        
            }else if(serviceName.equalsIgnoreCase('SupportingOffering')){
                inputRequestDetails=new String[4];
                inputRequestDetails[0]=topsSiteID;                
                if(caProductName<>null){
                    inputRequestDetails[1]=caProductName;
                    inputRequestDetails[2]=''; 
                    inputRequestDetails[3]=''; 
                }else{
                    inputRequestDetails[1]='';
                    inputRequestDetails[2]=startRecNum; 
                    inputRequestDetails[3]=System.Label.SiteServicesCalloutRecordsLimit;                    
                }
            }  
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }       
        return inputRequestDetails;
    }    
    
    public static String getServiceDetails(String topsSiteID,String caProductName,String startRecNum,String serviceName){      
        try{
            if(SiteServiceOfferingsController.testFlagService){
              return null;
            }            
            inputRequestDetails=buildServiceInput(topsSiteID,caProductName,startRecNum,serviceName);                
            responseFromService=invokeService(serviceName); 
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }finally{
            if(inputRequestDetails<>null){
                inputRequestDetails=null;
            }
        }
        return responseFromService;
    }   
    
    public static String invokeService(String serviceName){
        SiteUtilServicesCallout siteUtilService=null;        
        try{
            siteUtilService= new SiteUtilServicesCallout();
            responseFromService=siteUtilService.buildServiceRequestandInvokeService(inputRequestDetails,serviceName); 
        }
        catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }finally{
            if(siteUtilService<>null){
                siteUtilService=null;
            }
        }
        return responseFromService;
    }
    
    public static List<SiteUtilServicesDataWrapper.Data> getDataWrapperList(String responseJSON){
        try{
            if(SiteServiceOfferingsController.testFlagHandler){
               siteDataDetailsWrapperList=new List<SiteUtilServicesDataWrapper.Data>();
                return siteDataDetailsWrapperList;
            }
            responseJSON=responseJSON.substringBetween('[', ']');
            responseJSON='['+responseJSON+']';
            siteDataDetailsWrapperList=(List<SiteUtilServicesDataWrapper.Data>)System.JSON.deserialize(responseJSON, List<SiteUtilServicesDataWrapper.Data>.class);
            siteDataDetailsWrapperList.sort();            
        }catch(JSONException e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }catch(Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }finally{
            if(responseJSON<>null){
                responseJSON=null;
            }
        }
        return siteDataDetailsWrapperList;
    }
    
    public static SiteUtilServicesDataWrapper getServiceResponseList(String responseJSON){
        try { 
            if(SiteServiceOfferingsController.testFlagWrapper){
               siteUtilDetailsWrapper=new SiteUtilServicesDataWrapper();
                siteUtilDetailsWrapper.status='failure';
                return siteUtilDetailsWrapper;
            }
            siteUtilDetailsWrapper=(SiteUtilServicesDataWrapper)System.JSON.deserialize(responseJSON,SiteUtilServicesDataWrapper.class);
        }catch(System.Exception e){
            throw new SiteUtilServicesCustomException(e.getMessage());
        }       
        return siteUtilDetailsWrapper;  
    } 
    
}