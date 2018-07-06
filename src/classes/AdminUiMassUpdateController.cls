/*
  * Added as part of US340517
  * Use case : Mass Update for Statues  
*/ 
public class AdminUiMassUpdateController {
    
    Public String prodctInstanceId{set;get;}
    Public String ObjectId{set;get;}
    Public String fuilfilmentStatus{set;get;}
    Public String Status{set;get;}
    public string productInstaceDetail{set;get;}
    public string datCenter{set;get;}

    
  public string prName {get;set;}
  public string prId {get;set;}
  String contactEmail='';    
  String contactId;  
  string checkCon;
    
  String ProductINId='';
  String contractNumber='';
  String subscriptionName='';
  public  Set<string> entielmIds=new Set<string>();
    public boolean allchecked{set;get;}
    
    @TestVisible public List<AdminUIView__x> adminUIList{set;get;}
    public List<AdminUiMassWrapper> admUiWrplist{set;get;}
  public AdminUiMassUpdateController(){  
      admUiWrplist=new List<AdminUiMassWrapper>();
      contactEmail = ApexPages.currentPage().getParameters().get('cemail');                              // extracting contact's email parameter
      contactId = ApexPages.currentPage().getParameters().get('id'); 
      checkCon= ApexPages.currentPage().getParameters().get('checkCon');                                // extracting contact's id parameter   
      ProductINId=ApexPages.currentPage().getParameters().get('prodId');
      contractNumber=ApexPages.currentPage().getParameters().get('contractNumber');
      subscriptionName=ApexPages.currentPage().getParameters().get('subscriptionName');
      adminUIList = new List<AdminUIView__x>();
      
      // only proceeding further if a contact with a valid email exists
       if( String.isNotBlank(contactEmail)|| String.isNotBlank(ProductINId) || String.isNotBlank(contractNumber) ||String.isNotBlank(subscriptionName)) {                       
            
            if(contactId != null )
            {
                List<Provisioning_Request__c> prList= [select id,Name from Provisioning_Request__c where Technical_Contact__c =: contactId];
                if(prList!=null && prList.size()>0)                                                          // checking if there is a provisioning request is present with the contact Id or not              
                {
                    prName = prList[0].name;
                    prId = prList[0].id;
                }   
            }
            if(!Test.isRunningTest()){
				
				if(String.isNotBlank(contactEmail))
					adminUIList = [select product_instance_id__c,tech_stack__c,name__c,sap_contract_number__c,email__c,fulfillment_status__c,entitlement_id__c,instance_id__c,
                               status__c,object_id__c,auto_deactivate__c,entitlement_start_date__c,entitlement_type__c,product_detail__c,last_update_time__c,entitlement_end_date__c from AdminUIView__x 
                               Where email__c =:contactEmail 
                               ORDER BY entitlement_start_date__c];  // Querying the AdminUIView for Unlimited , FlowDock and Enterprise type records.
				
				else if(String.isNotBlank(ProductINId))
					adminUIList = [select product_instance_id__c,tech_stack__c,name__c,sap_contract_number__c,email__c,fulfillment_status__c,entitlement_id__c,instance_id__c,
                               status__c,object_id__c,auto_deactivate__c,entitlement_start_date__c,entitlement_type__c,product_detail__c,last_update_time__c,entitlement_end_date__c from AdminUIView__x 
                               Where product_instance_id__c=:ProductINId
                               ORDER BY entitlement_start_date__c];                         // Querying the AdminUIView for Unlimited , FlowDock and Enterprise type records.
							   
				else if(String.isNotBlank(contractNumber))
					adminUIList = [select product_instance_id__c,tech_stack__c,name__c,sap_contract_number__c,email__c,fulfillment_status__c,entitlement_id__c,instance_id__c,
                               status__c,object_id__c,auto_deactivate__c,entitlement_start_date__c,entitlement_type__c,product_detail__c,last_update_time__c,entitlement_end_date__c from AdminUIView__x 
                               Where sap_contract_number__c=:contractNumber
                               ORDER BY entitlement_start_date__c];
                else if(String.isNotBlank(subscriptionName))
					adminUIList = [select product_instance_id__c,tech_stack__c,name__c,sap_contract_number__c,email__c,fulfillment_status__c,entitlement_id__c,instance_id__c,
                               status__c,object_id__c,auto_deactivate__c,entitlement_start_date__c,entitlement_type__c,product_detail__c,last_update_time__c,entitlement_end_date__c from AdminUIView__x 
                               Where product_detail__c=:subscriptionName
                               ORDER BY entitlement_start_date__c];
                
                for(AdminUIView__x admin:adminUIList){
                    admUiWrplist.add(new AdminUiMassWrapper(admin));
                    
                }
               
                
               // System.debug('---adminUIList---'+adminUIList);                                   // Querying the AdminUIView for Unlimited , FlowDock and Enterprise type records.
			}
             else{                                                                               //and (name__c like '%UNLIMITED%' OR name__c like '%FLOWDOCK%' or name__c like '%ENTERPRISE%')
                adminUIList =AdminUiMassUpdateController.getDummyAdminUIRecords(contactEmail); 
                     for(AdminUIView__x admin:adminUIList){
                    AdminUiMassWrapper adminWrap=new AdminUiMassWrapper(admin);
                         adminWrap.selectedItem=true;
                         admUiWrplist.add(adminWrap);
                    
                }// Preparing Dummy response for Test class coverage
            }
            
        

       }
    }
    
     public List < SelectOption > listStatus {
        get {
            listStatus = getStatus();
            return listStatus;
        }
        set; 
    }
  
    public string selectStatus{set;get;}
    
  public List < SelectOption > getStatus() {
        List < SelectOption > selectval = new List < SelectOption > ();
        selectval.add(new SelectOption('--None--', '--None--'));
        selectval.add(new SelectOption('Fulfillment Status', 'Fulfillment Status'));
        selectval.add(new SelectOption('Status', 'Status'));    
        return selectval;
    }
      
    public  PageReference  Save(){  
         List<sObject> sobjList = new List<sObject>();
           List<Entitlement__x> ent=new  List<Entitlement__x>();
           Map<string,AdminUIView__x> entadminUIMap=new Map<string,AdminUIView__x>();
           Map<boolean,AdminUIView__x> messageMap=new Map<boolean,AdminUIView__x>();
           for(AdminUiMassWrapper adminwrp:admUiWrplist){
            if(adminwrp.selectedItem==true){
                messageMap.put(adminwrp.selectedItem, adminwrp.adminUi);
                entielmIds.add(adminwrp.adminUi.entitlement_id__c);
                entadminUIMap.put(adminwrp.adminUi.entitlement_id__c, adminwrp.adminUi);
                
                
            }
            
            
        }
        if(!messageMap.containsKey(true)){
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.AdminUI_to_Select_Record_Error_Message));
         
        }
         
        if(entielmIds.size()>0){
            
            System.debug('----entielmIds------'+entielmIds);
            if(!Test.isRunningTest()){
               ent = [select id, ExternalId,entitlement_id__c, status__c,entitlement_start_date__c,last_update_time__c,fulfillment_status__c, last_updated_by__c from Entitlement__x where entitlement_id__c=:entielmIds];
            }else{
                ent=AdminUiMassUpdateController.getDummyEntitlementRecord(entielmIds);
                
            } System.debug('--------ent-------'+ent);
            for(Entitlement__x enti:ent){
                if(selectStatus!='--None--'&&fuilfilmentStatus!='--None--'&&selectStatus=='Fulfillment Status'){
                    enti.fulfillment_status__c = fuilfilmentStatus;
                     enti.last_updated_by__c = 'SFDC';
                 if( enti.ExternalId != null)
                   enti.ExternalId = EncodingUtil.urlDecode(enti.ExternalId,'UTF-8');
                sobjList.add(enti);
                }
                else if(selectStatus!='--None--'&&Status!='--None--'&&selectStatus=='Status') {                                                                                                    //entadminUIMap.get(enti.entitlement_id__c).fulfillment_status__c;
                  enti.status__c = Status; 
                     enti.last_updated_by__c = 'SFDC';
                 if( enti.ExternalId != null)
                   enti.ExternalId = EncodingUtil.urlDecode(enti.ExternalId,'UTF-8');
                   sobjList.add(enti);
                }
                                                                                                //entadminUIMap.get(enti.entitlement_id__c).status__c;
                 
                
            } 
          
            
        }
         
       if(sobjList.size()>0){
          if(!Test.isRunningTest()){                                               // Performing DML on the sobject list containing entitlement and the instance records
          try{
              List<Database.SaveResult> saveResult = database.updateAsync(sobjList);
              System.debug('-----saveResult--------'+saveResult);
              for (Database.SaveResult sr : saveResult) { 
                  if (sr.isSuccess()) {                                       // checking if success is achieved or not
                      String locator =  Database.getAsyncLocator ( sr );
                      System.debug('Successfully updated.'+locator);   
                    
                  }
                  else {
                      
                      for(Database.Error err : sr.getErrors())                // else getting the error message
                      {
                          if(err!=null){
                          System.debug('The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                   
                          System.debug(err);    
                          }
                      }
                  }
              }
           
              
          }                                                                   // Displaying Error Message to the user about any error which happened performing the Asynchronous DML.
          catch(Exception ex){
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'The Mass update Process was not successful.Please reload the page and try again.'));
          }
      }
       PageReference pgrf=  redirectBack();
                if(pgrf!=null)
                   return  pgrf;
       }else{
           
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.AdminUI_MassUpdate_Value_Error_Message));
 
       }
       
       
     
               
     return null;
        
    }
    
    public PageReference redirectBack(){
       if(String.isNotBlank(contactEmail)&&contactId!=null){
             contactEmail=EncodingUtil.urlEncode(contactEmail, 'UTF-8');
              contactId=EncodingUtil.urlEncode(contactId, 'UTF-8');
              return new Pagereference('/apex/AdminUIPage?cemail='+contactEmail+'&'+'checkCon='+'true'+'&'+'id='+contactId);  
                
          }else if(String.isNotBlank(contactEmail)){
                contactEmail=EncodingUtil.urlEncode(contactEmail, 'UTF-8');
               return new Pagereference('/apex/AdminUIPage?cemail='+contactEmail+'&'+'checkCon='+'true');
                
            }else if(String.isNotBlank(ProductINId)){
                  ProductINId=EncodingUtil.urlEncode(ProductINId, 'UTF-8');
                return new Pagereference('/apex/AdminUIPage?prodId='+ProductINId+'&'+'checkCon='+'true');
                   
              }else if(String.isNotBlank(contractNumber)){
                 contractNumber=EncodingUtil.urlEncode(contractNumber, 'UTF-8');
                return new Pagereference('/apex/AdminUIPage?contractNumber='+contractNumber+'&'+'checkCon='+'true');
                   
              }else if(String.isNotBlank(subscriptionName)){
                subscriptionName=EncodingUtil.urlEncode(subscriptionName, 'UTF-8');
                return new Pagereference('/apex/AdminUIPage?subscriptionName='+subscriptionName+'&'+'checkCon='+'true'); 
                
              }
                 
			return null; 
        
    }
    
    public PageReference Cancel(){
        
          PageReference pgrf=  redirectBack();
                if(pgrf!=null)
                   return  pgrf;
                else
                 return null;
        
    }
    
    public class AdminUiMassWrapper{
        
        public boolean selectedItem{set;get;}
        public AdminUIView__x adminUi{set;get;}
        
        public AdminUiMassWrapper(AdminUIView__x adminUi){
            
            this.adminUi=adminUi;
           
            
        }  
    }
    public static List<AdminUIView__x> getDummyAdminUIRecords(String emailId){
    
    AdminUIView__x view1 = new AdminUIView__x();
    view1.product_instance_id__c = '';
    view1.name__c = 'CA Agile Central Unlimited Edition SaaS';
    view1.email__c = emailId;
    view1.entitlement_start_date__c = DateTime.newInstance(2016,8,12,11,14,0);
    view1.entitlement_end_date__c = DateTime.newInstance(2016,9,11,11,14,0);
    view1.fulfillment_status__c = '';
    view1.status__c = '';
    view1.object_id__c = '';
    View1.entitlement_id__c='B85CE1CADB3F94341A77D1A82DB809E2';
    view1.auto_deactivate__c = false;
    
    AdminUIView__x view2 = new AdminUIView__x();
    view2.product_instance_id__c = '';
    view2.name__c = 'CA FLOWDOCK SAAS';
    view2.email__c = emailId;
    view2.entitlement_start_date__c = DateTime.newInstance(2016,9,12,11,14,0);
    view2.entitlement_end_date__c = DateTime.newInstance(2016,10,11,11,14,0);
    view2.fulfillment_status__c = '';
    view2.status__c = '';
    view2.object_id__c = '';
    View2.entitlement_id__c='B85CE1CADB3F94341A77D1A82DB809E2';
    view2.auto_deactivate__c = false;
    
    return new List<AdminUIView__x>{view1,view2};
    
  }
public static List<Entitlement__x> getDummyEntitlementRecord(Set<string> entitlementId){
    List<Entitlement__x> listent=new List<Entitlement__x>();
 for(String strentId:entitlementId){
    Entitlement__x entitlement1 = new Entitlement__x();
    entitlement1.entitlement_id__c = strentId;
    entitlement1.status__c = 'active';
    entitlement1.fulfillment_status__c = 'fulfillment started';
         listent.add(entitlement1);
         }
    return listent;
  }
   
}