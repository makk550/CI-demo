public class SupportOfferingsFlowController {
    
    Map<String, String> offeringBusinessPrecedenceMap=new Map<String, String>();
    Map<String,String> offeringBusinessRulesMap=new Map<String,String>();
    List<Non_Contract_Offering_Business_Rules__c> nonContractOfferingList=null;
    Map<String,String> nonContractOfferingMap=new Map<String,String>();
    Map<ID,Offering_Feature__c> offeringFeaturesMap=new Map<ID,Offering_Feature__c>([SELECT ID,Type__c,Case_Severity__c,SLO_Value__c,SLO_Type__c,Unit__c,Offering_Business_Rules__r.Offering_Code__c FROM Offering_Feature__c where Offering_Business_Rules__c!=:System.label.InteralFTKId]);
    List<Offering_Feature__c> offeringFeaturesList=null;  
    Map<String, List<String>> offeringBusinessFeaturesMap = new Map<String, List<String>>();
    Map<String, Boolean> mapOfSelectSupportExperience = new Map<String, Boolean>();//US299629
    Map<String,String> contractOfferingMap=new Map<String,String>();
    Map<String,List<String>> finalMap=new Map<String,List<String>>();
    String highestPrecedenceOfferingCode=null;
    String temp=null;
    boolean isPresentinCCR=false;
    boolean isCBREnabled=false;
    Public FinalOfferingData finalOfferingData=null; 
    boolean isConfIssue=false;
    public static List<v_support_offerings__x> contractOfferingListCCR=null;
    public static List<cbr_Calculated_Certification__x> cbrCalculatedCertification=null;
    public static List<String> ldapIDList=null;
    Map<String,Map<String,String>> ldapIdsfIdNameEmpTypeMap = new Map<String,Map<String,String>>();
    String ldapIDofContact=null;
    Public Boolean isSupportExperienceEnabled = false;//US299629
    
    public class FinalOfferingData {
        public String offeringBusinessRulesID;
        public String offeringCode;
        public String offeringSource;
        public String offeringDSE;
        public Boolean isCBRQualified=false;
        public Boolean isOfferingCodeConfIssue=false;
        public Boolean isQueueJumpingField=false; //US130725
        public Boolean isRestorationFeatureAvailable = false; //US202426
        public Boolean isSelectSupportExperience = false;//US299629
    }   
    
    
    public  FinalOfferingData getAdvantageousOfferingCodeDetails(String selectedSiteId,String entitledCAProductName,String contactId,String caseSeverity){
        String caProductName=null;        
        String[] finalValues=new String[6];
        String splitSAPDSEName='';
        try{        
            if(entitledCAProductName<>null){
                caProductName=[SELECT Name from CA_Product_Controller__c where ID=:entitledCAProductName].NAME; 
            }
            
            if(contactId<>null){
                ldapIDofContact=[SELECT SC_CONTACT_LDAPID__c from Contact where ID=:contactId].SC_CONTACT_LDAPID__c;
            }
             //US299213---START
            if(String.isNotBlank(ldapIDofContact) && String.isNotBlank(caseSeverity) && ldapIDofContact.substring(0,5).isAlpha() && ldapIDofContact.substring(5,7).isNumeric() && (caseSeverity=='1' || caseSeverity=='2')){
                
                List<CBR_Certifications_LPAC__c> certificationObj = [select ca_product_name__c,certified_status_text__c, valid_to__c,valid_from__c  from CBR_Certifications_LPAC__c where ldap_id__c=:ldapIDofContact AND ca_product_name__c=:caProductName AND certified__c='Yes' and resource_type__c='Support' AND valid_to__c>=:system.today() AND valid_from__c<=:system.today() AND certified_status_text__c=:'Active'];
                
                if(certificationObj<>null && certificationObj.size()>0){
                    List<Offering_Feature__c> listOfOfferingFeature = [Select Case_Severity__c, Offering_Business_Rules__c, Offering_Business_Rules__r.Offering_Code__c from Offering_Feature__c where Offering_Business_Rules__c=:system.label.InteralFTKId AND Type__c=:System.Label.CBR limit 1];    
                    
                    if(listOfOfferingFeature<>null && listOfOfferingFeature.size()>0){
                        finalOfferingData=new finalOfferingData();
                        finalOfferingData.offeringBusinessRulesID = listOfOfferingFeature[0].Offering_Business_Rules__c;
                        finalOfferingData.offeringCode = listOfOfferingFeature[0].Offering_Business_Rules__r.Offering_Code__c;
                        finalOfferingData.isCBRQualified = true;
                    }
                }
            }else{
                //US299213---END
                contractOfferingMap=getContractOfferingsMap(selectedSiteId,caProductName); 
                isConfIssue=checkOfferingCodeConfIssue(contractOfferingMap.keySet());         
                nonContractOfferingMap=getNonContracingOfferingsMap(selectedSiteId,caProductName); 
                if(isConfIssue && nonContractOfferingMap<>null && nonContractOfferingMap.size()==0){
                    finalOfferingData=new finalOfferingData();
                    finalOfferingData.isOfferingCodeConfIssue=true;
                    finalOfferingData.offeringCode=new List<String>(contractOfferingMap.keyset())[0];                
                }else{
                    offeringBusinessFeaturesMap=getOfferingFeaturesMap(caseSeverity);
                    for(String offeringFeaturesCode :offeringBusinessFeaturesMap.keySet()){
                        isPresentinCCR=false;
                        List<String> tempList=finalMap.get(offeringFeaturesCode);
                        if(tempList==null){
                            if(contractOfferingMap.keySet().contains(offeringFeaturesCode)){
                                finalMap.put(offeringFeaturesCode,new List<String>{contractOfferingMap.get(offeringFeaturesCode)});
                                //US299629
                                if(mapOfSelectSupportExperience<>null && mapOfSelectSupportExperience.keySet().contains(offeringFeaturesCode)){
                                    isSupportExperienceEnabled = mapOfSelectSupportExperience.get(offeringFeaturesCode); 
                                }
                                //US299629
                                isPresentinCCR=true;
                            }
                            if(nonContractOfferingMap.keySet().contains(offeringFeaturesCode)){
                                if(!isPresentinCCR){
                                    //US299629
                                    if(!isSupportExperienceEnabled && mapOfSelectSupportExperience<>null && mapOfSelectSupportExperience.keySet().contains(offeringFeaturesCode)){
                                        isSupportExperienceEnabled = mapOfSelectSupportExperience.get(offeringFeaturesCode);
                                    }
                                    //US299629
                                    finalMap.put(offeringFeaturesCode,new List<String>{nonContractOfferingMap.get(offeringFeaturesCode)});
                                }                  
                            } 
                        }else{
                            tempList.add(offeringFeaturesCode);
                        }
                    }
                    system.debug('#$@$@$@'+finalMap);
                    offeringBusinessPrecedenceMap=getOfferingsPrecedenceMap(finalMap.keyset());                
                    highestPrecedenceOfferingCode=offeringBusinessPrecedenceMap.isEmpty()?null:new List<String>(offeringBusinessPrecedenceMap.keyset())[0];
                    for(String finalOfferingCode:finalMap.keySet()){
                        temp = Integer.valueOf(offeringBusinessPrecedenceMap.get(finalOfferingCode))<Integer.valueOf(offeringBusinessPrecedenceMap.get(highestPrecedenceOfferingCode))?finalOfferingCode:highestPrecedenceOfferingCode;
                    }
                    if(temp<>null){
                        highestPrecedenceOfferingCode=temp;  
                    }
                    if(highestPrecedenceOfferingCode<>null && finalMap<>null && finalMap.size()>0){  
                        finalOfferingData=new finalOfferingData();
                        finalOfferingData.offeringBusinessRulesID=offeringBusinessRulesMap.get(highestPrecedenceOfferingCode);
                        finalOfferingData.offeringCode=highestPrecedenceOfferingCode;
                        //US299629--START
                        if(isSupportExperienceEnabled){
                            finalOfferingData.isSelectSupportExperience = true;    
                        }
                        //US299629---END
                        for(String cbrOfferingCheck:offeringBusinessFeaturesMap.get(highestPrecedenceOfferingCode)){
                            if(offeringFeaturesMap.get(cbrOfferingCheck).Type__c.equals('Certified Bypass Routing')){                                               
                                finalOfferingData.isCBRQualified=isContactCeritified(ldapIDofContact,caProductName);
                            }
                            //US130725 -- Start
                            if(offeringFeaturesMap.get(cbrOfferingCheck).Type__c.equals(System.Label.queueJumpingLabel)){                                               
                                finalOfferingData.isQueueJumpingField=true;                            
                            }
                            //US130725 -- End
                            //US299629--START
                            if(offeringFeaturesMap.get(cbrOfferingCheck).Type__c.equals(System.Label.Select_Support_Experience)){
                                finalOfferingData.isSelectSupportExperience = true;    
                            }
                            //US299629---END
                            //US202426 -  check if the Sev1 restoration feature is available for the Offering
                            if(offeringFeaturesMap.get(cbrOfferingCheck).Type__c.equals(System.Label.Restoration)){
                                finalOfferingData.isRestorationFeatureAvailable=true;
                            } 
                        } 
                        splitSAPDSEName=(String)finalMap.get(highestPrecedenceOfferingCode)[0];
                        if(splitSAPDSEName<>null && splitSAPDSEName.contains('-') && !splitSAPDSEName.contains('NC')){
                            finalOfferingData.offeringSource=splitSAPDSEName.substringBefore('-');
                            finalOfferingData.offeringDSE=(splitSAPDSEName.substringAfter('-')<>null && splitSAPDSEName.substringAfter('-')<>'null')?splitSAPDSEName.substringAfter('-'):'';                   
                        }else{
                            finalOfferingData.offeringSource=splitSAPDSEName;
                            finalOfferingData.offeringDSE='';
                        }                
                    } 
                }
            }
        }catch(System.Exception e){
            
        }finally{
            if(highestPrecedenceOfferingCode<>null){
                highestPrecedenceOfferingCode=null;
            }
            if(caProductName<>null){
                caProductName=null;
            }
            if(temp<>null){
                temp=null;
            }
            if(finalMap<>null){
                finalMap=null;
            }
            if(nonContractOfferingMap<>null){
                nonContractOfferingMap=null; 
            }
            if(contractOfferingMap<>null){
                contractOfferingMap=null;
            }
            if(offeringBusinessPrecedenceMap<>null){
                offeringBusinessPrecedenceMap=null;
            }
            if(offeringBusinessFeaturesMap<>null){
                offeringBusinessFeaturesMap=null;
            }
            if(offeringBusinessRulesMap<>null){
                offeringBusinessRulesMap=null;
            }
            if(nonContractOfferingList<>null){
                nonContractOfferingList=null;
            }
            if(offeringFeaturesMap<>null){
                offeringFeaturesMap=null;
            }
            if(offeringFeaturesList<>null){
                offeringFeaturesList=null;
            }
        }
        return finalOfferingData;        
    } 
    
    public Boolean checkOfferingCodeConfIssue(Set<String> contractOfferingCodes){
        List<Offering_Business_Rules__c> offeringCodesList=[SELECT OFFERING_CODE__C FROM Offering_Business_Rules__c WHERE OFFERING_CODE__C IN:contractOfferingCodes AND Id!=:System.label.InteralFTKId ORDER BY PRECEDENCE__c];
        if(offeringCodesList.size()==0){
            isConfIssue=true;
        }
        return isConfIssue;
    }
    
    public Map<String, String> getOfferingsPrecedenceMap(Set<String> validOfferingCodes){
        List<Offering_Business_Rules__c> offeringCodePrecedenceList=[SELECT OFFERING_CODE__C,PRECEDENCE__c,ID FROM Offering_Business_Rules__c WHERE OFFERING_CODE__C IN:validOfferingCodes AND Id!=:System.label.InteralFTKId ORDER BY PRECEDENCE__c];
        for(Offering_Business_Rules__c obj : offeringCodePrecedenceList) {
            offeringBusinessPrecedenceMap.put(obj.OFFERING_CODE__C, obj.Precedence__c);
            offeringBusinessRulesMap.put(obj.OFFERING_CODE__C,obj.ID);
        }  
        return offeringBusinessPrecedenceMap;
    }
    
    
    public Map<String,String> getContractOfferingsMap(String selectedSiteId,String caProductName){
        DateTime currentDateTime = system.now();
        selectedSiteId='00000'+selectedSiteId;
        List<Contract_Support_Offerings__c> contractOfferingList =[SELECT tops_site_id__c,ca_product_name__c,offering_cd__c,offering_start_dtm__c,offering_end_dtm__c,offering_cancel_dtm__c,sap_contract_num__c,
                                                                   dse_pmf_key__c,dse_role__c,clarity_key__c,contract_line_num__c FROM Contract_Support_Offerings__c where tops_site_id__c=:selectedSiteId and ca_product_name__c=:caProductName
                                                                   and offering_start_dtm__c<=:currentDateTime AND offering_end_dtm__c>=:currentDateTime
                                                                   and ((offering_cancel_dtm__c!=null and offering_cancel_dtm__c>=:currentDateTime) or (offering_cancel_dtm__c=null))];
        for(Contract_Support_Offerings__c data : contractOfferingList){
            contractOfferingMap.put(data.offering_cd__c, data.sap_contract_num__c+'-'+data.dse_pmf_key__c);
        }
        return contractOfferingMap;
    }
    
    public Map<String,List<String>> getofferingFeaturesMap(String caseSeverity){
        offeringFeaturesList=[SELECT Offering_Business_Rules__r.Offering_Code__c,ID,Type__c FROM Offering_Feature__c WHERE Case_Severity__c=:caseSeverity AND Offering_Business_Rules__c!=:System.label.InteralFTKId ORDER BY Offering_Business_Rules__r.PRECEDENCE__c];
        for(Offering_Feature__c obj : offeringFeaturesList) {
            List<String> tempListFeatures=offeringBusinessFeaturesMap.get(obj.Offering_Business_Rules__r.Offering_Code__c);
            //US299629--START
            if(obj.Type__c.equalsIgnoreCase(System.Label.Select_Support_Experience)){
                mapOfSelectSupportExperience.put(obj.Offering_Business_Rules__r.Offering_Code__c, true);   
            }
            //US299629--END
            if(tempListFeatures==null){
                offeringBusinessFeaturesMap.put(obj.Offering_Business_Rules__r.Offering_Code__c,new List<String>{obj.ID});                      
            }else{
                tempListFeatures.add(obj.ID);
            }             
        }
        system.debug('off map:'+offeringBusinessFeaturesMap);
        return offeringBusinessFeaturesMap;
    }
    
    public Map<String, String> getNonContracingOfferingsMap(String selectedSiteId,String caProductName){
        Date todayDate=Date.today(); 
        nonContractOfferingList=[SELECT Offering_Business_Rules__r.Offering_Code__c,NAME from Non_Contract_Offering_Business_Rules__c WHERE CA_Product_Controller__r.Name=:caProductName AND Site_Association__r.SC_TOPS_ID__c=:selectedSiteId 
                                 AND Start_Date__C<=:todayDate  AND End_Date__c>=:todayDate];
        for(Non_Contract_Offering_Business_Rules__c ncrObj:nonContractOfferingList){     
            nonContractOfferingMap.put(ncrObj.Offering_Business_Rules__r.Offering_Code__c,ncrObj.NAME);
        }   
        return nonContractOfferingMap;
    }
    
    public Boolean isContactCeritified(String contactLdapId,String caProductName){
        Boolean ceritifiedByPassQualified=false;
        List<CBR_Certifications_LPAC__c> certificationObj = [select ca_product_name__c,certified_status_text__c from CBR_Certifications_LPAC__c where ldap_id__c=:contactLdapId AND ca_product_name__c=:caProductName AND certified__c='Yes' and resource_type__c='Support'];
        if(certificationObj<>null && certificationObj.size()>0){
            ceritifiedByPassQualified=true;
        }
        return ceritifiedByPassQualified;
    }
    
    /*
public void fetchExternalObjectData(){        
if(Test.isRunningTest()){
@TestVisible List<v_support_offerings__x> mockedRequests = new List<v_support_offerings__x>();
@TestVisible List<cbr_Calculated_Certification__x> cbrmockedRequests = new List<cbr_Calculated_Certification__x>();
}else{
try{ 
contractOfferingListCCR=[SELECT tops_site_id__c,ca_product_name__c,offering_cd__c,offering_start_dtm__c,offering_end_dtm__c,offering_cancel_dtm__c,sap_contract_num__c,
dse_pmf_key__c,dse_role__c,clarity_key__c,contract_line_num__c FROM v_support_offerings__x];

/*cbrCalculatedCertification=[SELECT ExternalId,badge__c,ca_product_code__c,ca_product_description__c,ca_product_name__c,certified__c,certified_status_code__c,certified_status_text__c,
completion_percentage__c,ldap_id__c,modify_date__c,previous_status_code__c,previous_status_text__c,resource_type__c,status_reason__c,valid_from__c,valid_to__c FROM cbr_Calculated_Certification__x];   
**
upsertintoTempObjects();                
}catch(System.Exception e){
e.getMessage();
}   
}       
} 

public void upsertintoTempObjects(){               
prepareLDAPIDList();
upsertintoCBRContactTemp();
upsertintoContractOfferingsTemp(); 
}*/
    
    public void upsertIntoContractOfferings(){
        try{  
            if(Test.isRunningTest()){
                @TestVisible List<v_support_offerings__x> mockedRequests = new List<v_support_offerings__x>();
            } 
            List<Contract_Support_Offerings__c> contractOfferingListCustom=new List<Contract_Support_Offerings__c>();                
            for(v_support_offerings__x[] dataList : [SELECT tops_site_id__c,ca_product_name__c,offering_cd__c,offering_start_dtm__c,offering_end_dtm__c,offering_cancel_dtm__c,sap_contract_num__c,
                                                     dse_pmf_key__c,dse_role__c,clarity_key__c,contract_line_num__c FROM v_support_offerings__x]){
                                                         for(v_support_offerings__x data : dataList){
                                                             Contract_Support_Offerings__c ccrData=new Contract_Support_Offerings__c(ca_product_name__c=data.ca_product_name__c,clarity_key__c=data.clarity_key__c,contract_line_num__c=data.contract_line_num__c,dse_pmf_key__c=data.dse_pmf_key__c,dse_role__c=data.dse_role__c,offering_cancel_dtm__c=data.offering_cancel_dtm__c,offering_cd__c=data.offering_cd__c,offering_end_dtm__c=data.offering_end_dtm__c,offering_start_dtm__c=data.offering_start_dtm__c,sap_contract_num__c=String.valueOf(data.sap_contract_num__c),tops_site_id__c=data.tops_site_id__c,claritykey_topsiteId__c=data.clarity_key__c+'-'+data.tops_site_id__c);
                                                             contractOfferingListCustom.add(ccrData);                        
                                                         }
                                                     }
            upsert contractOfferingListCustom claritykey_topsiteId__c;
        }catch(System.Exception e){
            e.getMessage();
        }
    }
    
    public void upsertIntoCBRCertifications(){
        prepareLDAPIDList();
        upsertintoCBRContactTemp();
    }
    
    public void prepareLDAPIDList(){
        ldapIDList=new List<String>();
        for(cbr_Calculated_Certification__x[] dataList:[SELECT ExternalId,badge__c,ca_product_code__c,ca_product_description__c,ca_product_name__c,certified__c,certified_status_code__c,certified_status_text__c,
                                                        completion_percentage__c,ldap_id__c,modify_date__c,previous_status_code__c,previous_status_text__c,resource_type__c,status_reason__c,valid_from__c,valid_to__c 
                                                        FROM cbr_Calculated_Certification__x where certified__c='Yes'  OR (certified__c='No' and certified_status_code__c IN (700,800))]){
                                                            for(cbr_Calculated_Certification__x cbrData:dataList){
                                                                ldapIDList.add(cbrData.ldap_id__c);
                                                            }
                                                        }   
        ldapIdsfIdNameEmpTypeMap=searchUserOrContact(ldapIdlist);
    }
    
    
    public void upsertintoContractOfferingsTemp(){        
        try{   
            List<Contract_Support_Offerings__c> contractOfferingListCustom=new List<Contract_Support_Offerings__c>();                
            for(v_support_offerings__x data : contractOfferingListCCR){
                Contract_Support_Offerings__c ccrData=new Contract_Support_Offerings__c(ca_product_name__c=data.ca_product_name__c,clarity_key__c=data.clarity_key__c,contract_line_num__c=data.contract_line_num__c,dse_pmf_key__c=data.dse_pmf_key__c,dse_role__c=data.dse_role__c,offering_cancel_dtm__c=data.offering_cancel_dtm__c,offering_cd__c=data.offering_cd__c,offering_end_dtm__c=data.offering_end_dtm__c,offering_start_dtm__c=data.offering_start_dtm__c,sap_contract_num__c=String.valueOf(data.sap_contract_num__c),tops_site_id__c=data.tops_site_id__c,claritykey_topsiteId__c=data.clarity_key__c+'-'+data.tops_site_id__c);
                contractOfferingListCustom.add(ccrData);
            }
            upsert contractOfferingListCustom claritykey_topsiteId__c;
        }catch(System.Exception e){
            e.getMessage();
        }
    }
    
    public void upsertintoCBRContactTemp(){
        try{             
            
            List<CBR_Certifications_LPAC__c> cbrCeritifcationTemp =new List<CBR_Certifications_LPAC__c>();               
            for(cbr_Calculated_Certification__x[] dataList:[SELECT ExternalId,badge__c,ca_product_code__c,ca_product_description__c,ca_product_name__c,certified__c,certified_status_code__c,certified_status_text__c,
                                                            completion_percentage__c,ldap_id__c,modify_date__c,previous_status_code__c,previous_status_text__c,resource_type__c,status_reason__c,valid_from__c,valid_to__c FROM cbr_Calculated_Certification__x
                                                            where certified__c = 'Yes'  OR (certified__c='No' and certified_status_code__c IN (700,800))]){
                                                                for(cbr_Calculated_Certification__x data:dataList){
                                                                    CBR_Certifications_LPAC__c cbrData=new CBR_Certifications_LPAC__c(badge__c=data.badge__c,ca_product_code__c=data.ca_product_code__c,ca_product_description__c=data.ca_product_description__c,ca_product_name__c=data.ca_product_name__c,certified__c=data.certified__c,certified_status_code__c=data.certified_status_code__c,certified_status_text__c=data.certified_status_text__c,completion_percentage__c=data.completion_percentage__c,ldap_id__c=data.ldap_id__c.toUpperCase(),modify_date__c=data.modify_date__c,previous_status_code__c=data.previous_status_code__c,previous_status_text__c=data.previous_status_text__c,resource_type__c=data.resource_type__c,status_reason__c=data.status_reason__c,valid_from__c=data.valid_from__c,valid_to__c=data.valid_to__c,UniqueCBRIdentifier__c=data.ExternalId);
                                                                    cbrData.SFDC_ID__c=ldapIdsfIdNameEmpTypeMap.get('salesforceID').get(cbrData.ldap_id__c);
                                                                    cbrData.Employee_Name__c = ldapIdsfIdNameEmpTypeMap.get('Name').get(cbrData.ldap_id__c);
                                                                    cbrData.Employee_Type__c = ldapIdsfIdNameEmpTypeMap.get('EmpType').get(cbrData.ldap_id__c);
                                                                    cbrCeritifcationTemp.add(cbrData);
                                                                }
                                                            }
            upsert cbrCeritifcationTemp UniqueCBRIdentifier__c;
        }catch(System.Exception e){
            e.getMessage();
        }
    }
    
    public Map<String,Map<String,String>> searchUserOrContact(List<String> ldapIdlistRef){  
        Map<String,String> ldapIdSfIdMap = new Map<String,String>();
        Map<String,String> ldapIdNameMap = new Map<String,String>();
        Map<String,String> ldapIdempTypeMap = new Map<String,String>();
        
        List<User> usersList = new List<User>();
        List<Contact> contactsList = new List<Contact>();
        Set<String> setToSearchInUserPMF = new Set<String>();
        Set<String> setToSearchInldapID = new Set<String>();
        
        for(String ldapId: ldapIdlistRef){
            Pattern pmfKeyPattern = Pattern.compile('[a-zA-Z]{5}\\d{2}');
            Matcher pmfKeyMatcher = pmfKeyPattern.matcher(ldapId);
            
            Pattern ldapIdPattern = Pattern.compile('[0-9]+');
            Matcher ldapIdMatcher = ldapIdPattern.matcher(ldapId);
            
            if(pmfKeyMatcher.matches()){
                setToSearchInUserPMF.add(ldapId);
            }
            
            else if(ldapIdMatcher.matches()){
                setToSearchInldapID.add(ldapId);
            }            
        }
        
        if(setToSearchInUserPMF !=null  && setToSearchInUserPMF.size()>0){         
            usersList = [select id,Name,PMFKey__c from User where PMFKey__c IN :setToSearchInUserPMF];          
            for(User userRec:usersList){
                ldapIdSfIdMap.put(userRec.PMFKey__c.toUpperCase(),String.valueOf(userRec.Id));
                ldapIdNameMap.put(userRec.PMFKey__c.toUpperCase(),userRec.Name);
                ldapIdempTypeMap.put(userRec.PMFKey__c.toUpperCase(), System.Label.CBRCAEmployee);// Engineer
            }
            contactsList = [select id,Name,SC_CONTACT_LDAPID__c from Contact where SC_CONTACT_LDAPID__c IN:setToSearchInUserPMF];
            String tempValue;
            for(Contact contactRec : contactsList){
                if(ldapIdSfIdMap.containsKey(contactRec.SC_CONTACT_LDAPID__c)){
                    tempValue = ldapIdempTypeMap.get(contactRec.SC_CONTACT_LDAPID__c.toUpperCase());
                    ldapIdempTypeMap.put(contactRec.SC_CONTACT_LDAPID__c.toUpperCase(), tempValue+' ; '+System.Label.CBRExternalContact); // Engineer;Customer
                }
            }
        }
        
        if(setToSearchInldapID!= null && setToSearchInldapID.size()>0){ 
            contactsList = [select id,Name,SC_CONTACT_LDAPID__c from Contact where SC_CONTACT_LDAPID__c IN :setToSearchInldapID];   
            usersList = [select id,Name,LDAP_Id__c from User where LDAP_Id__c = :setToSearchInldapID and Profile.UserLicense.Name IN ('Partner Community Login')];
            
            for(User userRec: usersList){
                ldapIdSfIdMap.put(userRec.LDAP_Id__c,String.valueOf(userRec.Id));
                ldapIdNameMap.put(userRec.LDAP_Id__c,userRec.Name);
                ldapIdempTypeMap.put(userRec.LDAP_Id__c, System.Label.CBRContractEmployee);//Partner Support
            }
            
            String tempValue;
            for(Contact contactRec : contactsList){
                if(ldapIdSfIdMap.containsKey(contactRec.SC_CONTACT_LDAPID__c)){
                    tempValue = ldapIdempTypeMap.get(contactRec.SC_CONTACT_LDAPID__c);
                    ldapIdempTypeMap.put(contactRec.SC_CONTACT_LDAPID__c, tempValue+' ; '+System.Label.CBRExternalContact); // Partner Support;Customer
                } 
                else{
                    ldapIdSfIdMap.put(contactRec.SC_CONTACT_LDAPID__c,String.valueOf(contactRec.Id));
                    ldapIdNameMap.put(contactRec.SC_CONTACT_LDAPID__c,contactRec.Name);
                    ldapIdempTypeMap.put(contactRec.SC_CONTACT_LDAPID__c,System.Label.CBRExternalContact); //Customer
                }
            }            
        }        
        ldapIdsfIdNameEmpTypeMap.put('salesforceID',ldapIdSfIdMap);
        ldapIdsfIdNameEmpTypeMap.put('Name',ldapIdNameMap);
        ldapIdsfIdNameEmpTypeMap.put('EmpType',ldapIdempTypeMap); 
        return ldapIdsfIdNameEmpTypeMap;                   
    }
}