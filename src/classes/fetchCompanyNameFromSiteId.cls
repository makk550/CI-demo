@RestResource(urlMapping='/fetchCompanyName/*')
global class fetchCompanyNameFromSiteId{
    
    public static responsePayload responsePayloadObj;
    public static getContactDetails getContactDetailsObj;
    
    global class requestPayload{
        global List<siteId> siteId;
        //global String userId;
        //global String addressFlag;
    }
    
    global class siteId{
        global String siteId;
    }
    
    global class responsePayload{
        global getContactDetails fetchCompanyNameResponsePayload;
    }
    
    global class getContactDetails{
        global List<contact> companyName;
        global String message;
    }
    
    global class contact{
        /*global String siteId;
        global String firstName;
        global String lastName;
        */
        global String companyName;
        global String siteId;
        /*global String postalAddress1;
        global String postalAddress2;
        global String city;
        global String state;
        global String country;
        global String zipCode; */
    }
    
    @HttpPost
    global static void callFetchCompanyNameFromSiteId(requestPayload fetchCompanyNameRequestPayload){
        System.debug('fetchCompanyNameRequestPayload:'+fetchCompanyNameRequestPayload);
        String jsonRequest = JSON.serialize(fetchCompanyNameRequestPayload);
        System.debug('jsonRequest:'+jsonRequest);
        RestResponse restResponse = RestContext.response;
        responsePayloadObj = new responsePayload();
        getContactDetailsObj =  new getContactDetails();
        String jsonResponse = null;
        if(fetchCompanyNameRequestPayload<>null){
            Set<String> setOfSiteAssociationIds = new Set<String>();
            Set<String> setOfRemovedSiteIds = new Set<String>();
            
            if(fetchCompanyNameRequestPayload.siteId<>null && fetchCompanyNameRequestPayload.siteId.size()>0){
               for(Integer i=0;i<fetchCompanyNameRequestPayload.siteId.size();i++){
                   if(String.isNotBlank(fetchCompanyNameRequestPayload.siteId[i].siteId)){
                       Integer siteNumber = Integer.valueOf(fetchCompanyNameRequestPayload.siteId[i].siteId);
                       if(siteNumber>8000000 && siteNumber<8888887){
                           system.debug('PROJET SITE ASSOCIATION');
                       }else{
                           setOfSiteAssociationIds.add(fetchCompanyNameRequestPayload.siteId[i].siteId);
                           setOfRemovedSiteIds.add(fetchCompanyNameRequestPayload.siteId[i].siteId);
                       }
                   }
                }
               
               if(setOfSiteAssociationIds<>null && setOfSiteAssociationIds.size()>0){//String.isNotBlank(fetchCompanyNameRequestPayload.userId) &&
                  //List<Contacts_Site_Association__c> listOfContactDetail = [Select SC_CSA_SITE__r.SC_TOPS_ID__c, SC_CSA_SITE__r.Name, SC_CSA_CONTACTS__r.FirstName, SC_CSA_CONTACTS__r.LastName, SC_CSA_CONTACTS__r.MailingAddress, SC_CSA_CONTACTS__r.OtherAddress from Contacts_Site_Association__c where SC_CSA_SITE__r.SC_TOPS_ID__c IN:setOfSiteAssociationIds AND SC_CSA_CONTACTS__c<>null AND SC_CSA_CONTACTS__r.SC_CONTACT_LDAPID__c<>null AND SC_CSA_CONTACTS__r.SC_CONTACT_LDAPID__c =:fetchCompanyNameRequestPayload.userId];    
                  List<Site_Association__c> listOfContactDetail = [Select Name, SC_TOPS_ID__c from Site_Association__c where SC_TOPS_ID__c<>null AND SC_TOPS_ID__c<>'' AND SC_TOPS_ID__c IN:setOfSiteAssociationIds];
                   
                  if(listOfContactDetail<>null && listOfContactDetail.size()>0){
                      contact contactResponseObj;
                      List<contact> listOfContactResponse = new List<contact>();
                      for(Site_Association__c siteObj:listOfContactDetail){
                          if(setOfRemovedSiteIds.contains(siteObj.SC_TOPS_ID__c)){
                              setOfRemovedSiteIds.remove(siteObj.SC_TOPS_ID__c);
                          }
                          if(String.isNotBlank(siteObj.Name)){
                              contactResponseObj = new contact();
                              contactResponseObj.companyName = siteObj.Name;
                              contactResponseObj.siteId = siteObj.SC_TOPS_ID__c;
                              listOfContactResponse.add(contactResponseObj);
                          }
                      }
                      
                      if(listOfContactResponse<>null && setOfRemovedSiteIds<>null && listOfContactResponse.size()>0 && setOfRemovedSiteIds.size()>0){
                          for(String removedSiteId:setOfRemovedSiteIds){
                              contactResponseObj = new contact(); 
                              contactResponseObj.siteId = removedSiteId;
                              listOfContactResponse.add(contactResponseObj);
                          }
                      }
                      
                      if(listOfContactResponse<>null && listOfContactResponse.size()>0){
                          getContactDetailsObj.message = 'Success';
                          getContactDetailsObj.companyName = listOfContactResponse;
                          responsePayloadObj.fetchCompanyNameResponsePayload = getContactDetailsObj;
                          jsonResponse = JSON.serialize(responsePayloadObj);
                          restResponse.responseBody = blob.valueOf(jsonResponse);
                          return; 
                      }
                      
                      
                      /*if(String.isNotBlank(fetchCompanyNameRequestPayload.addressFlag)){
                           contact contactResponseObj;
                           List<contact> listOfContactResponse = new List<contact>();
                          if(fetchCompanyNameRequestPayload.addressFlag.equalsIgnoreCase('Y')){
                              for(Contacts_Site_Association__c contactVal:listOfContactDetail){
                                  if(setOfRemovedSiteIds.contains(contactVal.SC_CSA_SITE__r.SC_TOPS_ID__c)){
                                    setOfRemovedSiteIds.remove(contactVal.SC_CSA_SITE__r.SC_TOPS_ID__c);    
                                  }
                                  contactResponseObj = new contact(); 
                                  contactResponseObj.firstName = String.isNotBlank(contactVal.SC_CSA_CONTACTS__r.FirstName)?contactVal.SC_CSA_CONTACTS__r.FirstName:'';
                                  contactResponseObj.lastName = String.isNotBlank(contactVal.SC_CSA_CONTACTS__r.LastName)?contactVal.SC_CSA_CONTACTS__r.LastName:'';
                                  contactResponseObj.companyName = String.isNotBlank(contactVal.SC_CSA_SITE__r.Name)?contactVal.SC_CSA_SITE__r.Name:'';
                                  contactResponseObj.siteId= contactVal.SC_CSA_SITE__r.SC_TOPS_ID__c;
                                  
                                  System.Address contactMailingAddress = String.isNotBlank(String.valueOf(contactVal.SC_CSA_CONTACTS__r.MailingAddress))?contactVal.SC_CSA_CONTACTS__r.MailingAddress:null;
                                  String streetValue = String.isNotBlank(String.valueOf(contactMailingAddress)) && String.isNotBlank(contactMailingAddress.getStreet())?contactMailingAddress.getStreet():'';
                                  String cityValue = String.isNotBlank(String.valueOf(contactMailingAddress)) && String.isNotBlank(contactMailingAddress.getCity())?contactMailingAddress.getCity():'';
                                  String postalCodeValue = String.isNotBlank(String.valueOf(contactMailingAddress)) && String.isNotBlank(contactMailingAddress.postalcode)?contactMailingAddress.postalcode:'';
                                  String countryValue = String.isNotBlank(String.valueOf(contactMailingAddress)) && String.isNotBlank(contactMailingAddress.getCountry())?contactMailingAddress.getCountry():'';
                                  String stateValue = String.isNotBlank(String.valueOf(contactMailingAddress)) && String.isNotBlank(contactMailingAddress.getState())?contactMailingAddress.getState():'';
                                  String postalAddress = streetValue+' '+cityValue+', '+stateValue+' '+postalCodeValue+' '+countryValue;
                                  String removeWhiteSpace = postalAddress.deleteWhitespace();
                                  contactResponseObj.postalAddress1 = String.isNotBlank(removeWhiteSpace) && (removeWhiteSpace.indexOf(',')<>0)?postalAddress:removeWhiteSpace.remove(',');
                                  contactResponseObj.city = cityValue;
                                  contactResponseObj.state = stateValue;
                                  contactResponseObj.country = countryValue;
                                  contactResponseObj.zipCode = postalCodeValue;
                                  removeWhiteSpace = '';
                                  System.Address contactOtherMailingAddress = String.isNotBlank(String.valueOf(contactVal.SC_CSA_CONTACTS__r.OtherAddress))?contactVal.SC_CSA_CONTACTS__r.OtherAddress:null;
                                  String otherStreetValue = String.isNotBlank(String.valueOf(contactOtherMailingAddress)) && String.isNotBlank(contactOtherMailingAddress.getStreet())?contactOtherMailingAddress.getStreet():'';
                                  String otherCityValue = String.isNotBlank(String.valueOf(contactOtherMailingAddress)) && String.isNotBlank(contactOtherMailingAddress.getCity())?contactOtherMailingAddress.getCity():'';
                                  String otherPostalCodeValue = String.isNotBlank(String.valueOf(contactOtherMailingAddress)) && String.isNotBlank(contactOtherMailingAddress.postalcode)?contactOtherMailingAddress.postalcode:'';
                                  String otherCountryValue = String.isNotBlank(String.valueOf(contactOtherMailingAddress)) && String.isNotBlank(contactOtherMailingAddress.getCountry())?contactOtherMailingAddress.getCountry():'';
                                  String otherStateValue = String.isNotBlank(String.valueOf(contactOtherMailingAddress)) && String.isNotBlank(contactOtherMailingAddress.getState())?contactOtherMailingAddress.getState():'';
                                  String otherPostalAddress = otherStreetValue+' '+otherCityValue+', '+otherPostalCodeValue+' '+otherCountryValue+' '+otherStateValue;
                                  removeWhiteSpace = otherPostalAddress.deleteWhitespace();                                
                                  contactResponseObj.postalAddress2 = String.isNotBlank(removeWhiteSpace) && (removeWhiteSpace.indexOf(',')<>0)?otherPostalAddress:removeWhiteSpace.remove(',');
                                  listOfContactResponse.add(contactResponseObj);                                  
                              }
                          }else if(fetchCompanyNameRequestPayload.addressFlag.equalsIgnoreCase('N')){
                              for(Contacts_Site_Association__c contactVal:listOfContactDetail){
                                  if(setOfRemovedSiteIds.contains(contactVal.SC_CSA_SITE__r.SC_TOPS_ID__c)){
                                    setOfRemovedSiteIds.remove(contactVal.SC_CSA_SITE__r.SC_TOPS_ID__c);    
                                  }
                                  contactResponseObj = new contact(); 
                                  contactResponseObj.firstName = String.isNotBlank(contactVal.SC_CSA_CONTACTS__r.FirstName)?contactVal.SC_CSA_CONTACTS__r.FirstName:'';
                                  contactResponseObj.lastName = String.isNotBlank(contactVal.SC_CSA_CONTACTS__r.LastName)?contactVal.SC_CSA_CONTACTS__r.LastName:'';
                                  contactResponseObj.companyName = String.isNotBlank(contactVal.SC_CSA_SITE__r.Name)?contactVal.SC_CSA_SITE__r.Name:'';  
                                  contactResponseObj.siteId = contactVal.SC_CSA_SITE__r.SC_TOPS_ID__c;
                                  listOfContactResponse.add(contactResponseObj);   
                              }
                          }
                          
                          if(setOfRemovedSiteIds<>null && setOfRemovedSiteIds.size()>0){
                              for(String siteNotFound:setOfRemovedSiteIds){
                                  contactResponseObj = new contact(); 
                                  contactResponseObj.siteId = String.isNotBlank(siteNotFound)?siteNotFound:'';
                                  listOfContactResponse.add(contactResponseObj);
                              }
                          }
                          getContactDetailsObj.message = 'Success';
                          getContactDetailsObj.contact =  listOfContactResponse; 
                          responsePayloadObj.fetchCompanyNameResponsePayload = getContactDetailsObj;
                          jsonResponse = JSON.serialize(responsePayloadObj);
                          restResponse.responseBody = blob.valueOf(jsonResponse);
                          return;                       
                      }else{
                          getContactDetailsObj.message = 'Please pass Y or N for address flag';
                          responsePayloadObj.fetchCompanyNameResponsePayload = getContactDetailsObj;
                          jsonResponse = JSON.serialize(responsePayloadObj);
                          restResponse.responseBody = blob.valueOf(jsonResponse);
                          return;
                      }*/
                      
                  }else{
                      getContactDetailsObj.message = 'No contact records found for Sites: '+setOfSiteAssociationIds;
                      responsePayloadObj.fetchCompanyNameResponsePayload = getContactDetailsObj;
                      jsonResponse = JSON.serialize(responsePayloadObj);
                      restResponse.responseBody = blob.valueOf(jsonResponse);
                      return;
                  } 
               } 
            }else{
               getContactDetailsObj.message = 'Please enter the valid site Id';
               responsePayloadObj.fetchCompanyNameResponsePayload = getContactDetailsObj;
               jsonResponse = JSON.serialize(responsePayloadObj);
               restResponse.responseBody = blob.valueOf(jsonResponse);
               return;
            }
        }else{
            getContactDetailsObj.message = 'Please enter the valid request payload';
            responsePayloadObj.fetchCompanyNameResponsePayload = getContactDetailsObj;
            jsonResponse = JSON.serialize(responsePayloadObj);
            restResponse.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        
    }
}