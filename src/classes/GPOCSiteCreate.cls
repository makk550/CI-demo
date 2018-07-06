global class GPOCSiteCreate {


    /*
     * Inner Class for web service integration. 
     * An instance of this class to be passed as parameter to the web service.
     */
    global class SiteInputData{
        webservice String siteName =null ;
        webservice String name2  =null; 
        webservice String street =null ;
        webservice String street2 =null; 
        webservice String street3 =null; 
        webservice String city =null ;
        webservice String state =null ;
        webservice String postalCode =null ;
        webservice String country =null; 
        webservice String phone =null ;
        webservice String preferredLanguage='ENGLISH';
   
    }
   
    global class SiteOutputData{
        webservice String siteId;
          webservice String message ;
    }
    
    
    
     webservice static SiteOutputData createSite(SiteInputData si)
    {
 

//Instantiate the response classes.
        SiteOutputData so = new SiteOutputData();
        Site_Association__c siteRecord = new Site_Association__c();
        String siteId =null; 

// response variables.
        so.message  = null;
        so.siteId   = '';

        if ( StringUtils.isBlank(si.siteName) ) 
        {
            so.message = 'Name is required field for creating site.';
            return so;
        }

         if ( StringUtils.isBlank(si.city ) ) 
        {
            so.message = 'City is required field for creating site.';
            return so;
        }
        if ( StringUtils.isBlank(si.country) )
        {
            so.message = 'Country cannot be blank.';
            return so;
        }
       
        if ((StringUtils.equalsIgnoreCase('US - UNITED STATES', si.country) ||
            StringUtils.equalsIgnoreCase('CA - CANADA', si.country)||
            StringUtils.equalsIgnoreCase('IN - INDIA', si.country)||
            StringUtils.equalsIgnoreCase('AU - AUSTRALIA', si.country)||
            StringUtils.equalsIgnoreCase('AR - ARGENTINA', si.country)||
            StringUtils.equalsIgnoreCase('BR - BRAZIL', si.country))&& StringUtils.isBlank(si.state))
        {
            so.message = 'State is required for the selected country';
            return so;
        }

        siteRecord.Name =si.siteName ;
        siteRecord.Name2__c =si.name2 ;
        siteRecord.Street__c =si.street ;
        siteRecord.Street2__c =si.street2 ;
        siteRecord.Street3__c =si.street3 ;
        siteRecord.City__c =si.city ;
        siteRecord.State__c =si.state ;
        siteRecord.Postal_Code__c =si.postalCode ;
        siteRecord.Country_picklist__c =si.country ;
        siteRecord.Phone__c =si.phone ;
         siteRecord.Is_Blocked_to_Sales__c = true;
        if(StringUtils.isNotBlank(si.preferredLanguage) )
            siteRecord.SC_SITE_Preferred_Language__c =si.preferredLanguage ;
        else
            siteRecord.SC_SITE_Preferred_Language__c ='ENGLISH' ;
        siteRecord.SC_SITE_Source__c = 'GPOC';
        
          
        
        insert siteRecord;
       
        if (siteRecord.Id != null)
        {
            siteId =getCreatedSiteID(siteRecord.Id);  
         
            if(siteId.equals('-1')){
                so.message = 'Failed  to get the site Id ';
                so.siteId ='';
                
            }   
            else{
                so.siteId=siteId  ;
                so.message = 'Site created successfully ';
            }       
                         
        }        
        else
        {
            so.message = 'Failed to create a site ';
            so.siteId='';
            return so;            
        }
        
    
        return so;     
    }
    
    
      public static String getCreatedSiteID(string recordId)
    {
        Site_Association__c[] site_list =[ SELECT  SC_TOPS_ID__c FROM    Site_Association__c WHERE   Id = :recordId   limit 1]  ;
      
        if (site_list.size() == 1)
        {
              return site_list[0].SC_TOPS_ID__c;
        }
        else
        {
           return '-1' ;
        }
    }
    
   
    
    
     
}