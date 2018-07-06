public class LighteningCBRCertificationController {
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public String contactID {get;set;}
    public Map<String,String> certAccountMap {get;set;} 
    public Boolean showButtons{get;set;}
    
    public LighteningCBRCertificationController(){
        showButtons=false;
        List<PermissionSetAssignment> permissionSetValue = [select Id from PermissionSetAssignment where PermissionSet.Name='FTKCertifiedPermissionSet' and Assignee.Id=:userinfo.getUserId()];
        if(permissionSetValue<>null && permissionSetValue.size()>0){
            showButtons = true;    
        }
    }
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
               // size = 900;
                size = integer.valueof(system.label.Cert_PageLimit);
                //string queryString = 'Select Name, Type, BillingCity, BillingState, BillingCountry from Account order by Name';
                string mymainquery ='SELECT Id,SFDC_ID__c,FTK_Certified__c,Employee_Name__c,Employee_Type__c,badge__c,ca_product_code__c,ca_product_description__c,ca_product_name__c,certified__c,certified_status_code__c,certified_status_text__c,completion_percentage__c,ldap_id__c,modify_date__c,previous_status_code__c,previous_status_text__c,resource_type__c,status_reason__c,valid_from__c,valid_to__c FROM CBR_Certifications_LPAC__c';  
                string varquery ='where  certified__c= \'Yes\' OR (certified__c=\'No\' and certified_status_code__c IN (700,800)) order BY ldap_id__c';
                 mymainquery  =  mymainquery + ' '+ varquery;
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(mymainquery));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
                certAccountMap = new Map<String,String>();
            }
            return setCon;
        }set;
    }
    
    Public List<CBR_Certifications_LPAC__c> getcbrcertlist(){
        List<CBR_Certifications_LPAC__c> cbrList = new List<CBR_Certifications_LPAC__c>();
        for(CBR_Certifications_LPAC__c cbr : (List<CBR_Certifications_LPAC__c>)setCon.getRecords())
            cbrList.add(cbr);
        // US197109 - Identify the Certified Entry line's company / organization
        fetchAccountName(cbrList); 
        return cbrList;
    }
    
    public pageReference refresh() {
        setCon = null;
        getcbrcertlist();
        setCon.setPageNumber(1);
        return null;
    }
    Public PageReference displayRecord(){
        PageReference newPage=new PageReference('/' + contactID);
        newPage.getParameters().put('nooverride', '1');       
        return newPage;
        
    }
    
    //US197109 - Identify the Certified Entry line's company / organization
    public void fetchAccountName(List<CBR_Certifications_LPAC__c> certificationsList){
       /*
        List<Id> internalUserIDList = new List<Id>();
        List<Id> partnerUserIDList = new List<Id>();
        List<Id> contactIDList = new List<Id>();
        
        for(CBR_Certifications_LPAC__c rec:certificationsList){
            if(rec.Employee_Type__c != null && rec.Employee_Type__c.contains('Engineer')){
                internalUserIDList.add(rec.SFDC_ID__c);
            }
            else if(rec.Employee_Type__c != null && rec.Employee_Type__c.contains('Partner Support')){
                partnerUserIDList.add(rec.SFDC_ID__c);
            }
            else if(rec.Employee_Type__c != null && rec.Employee_Type__c.contains('Customer')){
                contactIDList.add(rec.SFDC_ID__c);
            }   
        }
        
        Map<Id,User>  partnerUserMap = new Map<Id,User>([select id, Name, Contact.Account.Name from User where id IN :partnerUserIDList]);
        Map<Id,Contact> contactMap = new Map<Id,Contact> ([select id,Name,SC_CONTACT_LDAPID__c,Account.Name from Contact where id IN  :contactIDList]);
        String accountName = '';
        
        for(CBR_Certifications_LPAC__c rec:certificationsList){
            if(rec.Employee_Type__c != null && rec.Employee_Type__c.contains('Engineer')){
                accountName = System.Label.CA_Technologies;
            }
            else if( rec.Employee_Type__c != null && rec.Employee_Type__c.contains('Partner Support') ){
                if(partnerUserMap.containsKey(rec.SFDC_ID__c) ){ 
                    accountName = partnerUserMap.get(rec.SFDC_ID__c).Contact.Account.Name ;
                    if(accountName == null) accountName = System.Label.Company_Not_Available;
                }           
            }
            else if(rec.Employee_Type__c != null && rec.Employee_Type__c.contains('Customer') ){
                System.debug('Enetered3');
                if( contactMap.containsKey(rec.SFDC_ID__c) ){
                    accountName = contactMap.get(rec.SFDC_ID__c).Account.Name;
                    if(accountName == null) accountName = System.Label.Company_Not_Available;
                }
            }
            certAccountMap.put(rec.ldap_id__c,accountName );
            accountName = System.Label.Company_Not_Available; 
        
        }  */ 

            List<Id> userIDList = new List<Id>();
            List<String> contactIDList = new List<String>();
        
            for(CBR_Certifications_LPAC__c rec:certificationsList){
                    if(rec.SFDC_ID__c!= null && rec.ldap_id__c.isNumeric()){
                            contactIDList.add(rec.ldap_id__c);
                    }
                    else if(rec.SFDC_ID__c!= null &&rec.ldap_id__c.isAlphaNumeric()){
                            userIDList.add(rec.SFDC_ID__c);  
                    }
            }
            
            List<Contact> contactList =  [select id,AccountId,Account.Name,SC_CONTACT_LDAPID__c  from Contact where SC_CONTACT_LDAPID__c IN :contactIDList];
            Map<String,Contact> contactLdapIDMap = new Map <String,Contact>();
            for(Contact c : contactList){
                contactLdapIDMap.put(c.SC_CONTACT_LDAPID__c,c);
            }

            String accountName = '';

            for(CBR_Certifications_LPAC__c rec:certificationsList){
                    if(rec.SFDC_ID__c!= null && rec.ldap_id__c.isNumeric()){
                            if( contactLdapIDMap.containsKey(rec.ldap_id__c) &&  contactLdapIDMap.get(rec.ldap_id__c).AccountId != null){
                                accountName = contactLdapIDMap.get(rec.ldap_id__c).Account.Name;
                                if(accountName == null) accountName = System.Label.Company_Not_Available;
                            }
                            else{
                                accountName = System.Label.Company_Not_Available;
                            }                            
                    }
                    else if(rec.SFDC_ID__c!= null && rec.ldap_id__c.isAlphaNumeric()){
                            accountName = System.Label.CA_Technologies;
                    }
                    certAccountMap.put(rec.ldap_id__c,accountName );   
                    accountName = System.Label.Company_Not_Available;  
            } 
    }
    
    public PageReference saveFTKCertified(){
        String CBRId = ApexPages.CurrentPage().getParameters().get('cbrIdval');
        String checkboxValue = ApexPages.CurrentPage().getParameters().get('checkedOrNot');
        String urlVal = ApexPages.CurrentPage().getParameters().get('urlValue');
        
        CBR_Certifications_LPAC__c cbrObj = [Select FTK_Certified__c from CBR_Certifications_LPAC__c where Id=:CBRId];
        if(checkboxValue == 'false'){
            cbrObj.FTK_Certified__c = false;    
        }else{
            cbrObj.FTK_Certified__c = true;  
        }
        update cbrObj; 
        PageReference newPage=new PageReference(urlVal);
        return newPage;
    }

}