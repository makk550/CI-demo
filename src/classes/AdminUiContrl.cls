public class AdminUiContrl{
    
  public Map<Id,AdminUIWrapper> helperMap{get;set;}
  public List<AdminUIWrapper> listAdmin{get;set;} 
  public string prName {get;set;}
  public string prId {get;set;}
  String contactEmail='';    
  String contactId='';  
  string checkCon;
    
  String ProductINId='';
  String contractNumber='';
  String subscriptionName='';
    
  @TestVisible List<AdminUIView__x> adminUIList;
  public AdminUiContrl(){
             
      contactEmail = ApexPages.currentPage().getParameters().get('cemail');                              // extracting contact's email parameter
      contactId = ApexPages.currentPage().getParameters().get('id'); 
      System.debug('-------contactId'+contactId);
      checkCon= ApexPages.currentPage().getParameters().get('checkCon');                                // extracting contact's id parameter   
      ProductINId=ApexPages.currentPage().getParameters().get('prodId');
      contractNumber=ApexPages.currentPage().getParameters().get('contractNumber');
      subscriptionName=ApexPages.currentPage().getParameters().get('subscriptionName');
      adminUIList = new List<AdminUIView__x>();
      
      // only proceeding further if a contact with a valid email exists
       if( contactEmail != null || String.isNotBlank(ProductINId) || String.isNotBlank(contractNumber) ||String.isNotBlank(subscriptionName)) {                       
            
            listAdmin=new List<AdminUIWrapper>();
            helperMap = new Map<Id,AdminUIWrapper>();
            AdminUIWrapper tempWrapper;
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
                system.debug('contactEmail'+contactEmail);
                         //Added as part of US340517  
                if(String.isNotBlank(contactEmail))
                    
                    adminUIList = [select product_instance_id__c,tech_stack__c,name__c,sap_contract_number__c,email__c,fulfillment_status__c,entitlement_id__c,instance_id__c,
                               status__c,object_id__c,auto_deactivate__c,entitlement_type__c,entitlement_start_date__c,product_detail__c,last_update_time__c,entitlement_end_date__c from AdminUIView__x 
                               Where email__c =:contactEmail 
                               ORDER BY entitlement_start_date__c];  // Querying the AdminUIView for Unlimited , FlowDock and Enterprise type records.
                
                else if(String.isNotBlank(ProductINId))
                    adminUIList = [select product_instance_id__c,tech_stack__c,name__c,sap_contract_number__c,email__c,fulfillment_status__c,entitlement_id__c,instance_id__c,
                               status__c,object_id__c,auto_deactivate__c,entitlement_type__c,entitlement_start_date__c,product_detail__c,last_update_time__c,entitlement_end_date__c from AdminUIView__x 
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
               
                
               // System.debug('---adminUIList---'+adminUIList);                                   // Querying the AdminUIView for Unlimited , FlowDock and Enterprise type records.
            }
            else{                                                                               //and (name__c like '%UNLIMITED%' OR name__c like '%FLOWDOCK%' or name__c like '%ENTERPRISE%')
                adminUIList = AdminUiContrl.getDummyAdminUIRecords(contactEmail);                    // Preparing Dummy response for Test class coverage
            }
            
          
          
          for(AdminUIView__x eachRec : adminUIList){                                           // Preparing a wrapper out of the AdminUI records queried
            
            tempWrapper = new AdminUIWrapper();
            tempWrapper.adminRecordId = eachRec.Id;
            tempWrapper.adminRecord = eachRec;
            tempWrapper.isEdit = false;
            listAdmin.add(tempWrapper);
            helperMap.put(tempWrapper.adminRecordId,tempWrapper);   
          
          }
      }
  }  
  
        //Added as part of US340517  
  public Pagereference massAction(){
        if(String.isNotBlank(contactEmail)&&contactId!=null){
           contactEmail=EncodingUtil.urlEncode(contactEmail, 'UTF-8');
              contactId=EncodingUtil.urlEncode(contactId, 'UTF-8');
          return new Pagereference('/apex/AdminUiMassUpdatePage?cemail='+contactEmail+'&'+'id='+contactId);
      }
      else if(String.isNotBlank(contactEmail)){
             contactEmail=EncodingUtil.urlEncode(contactEmail, 'UTF-8');
           return new Pagereference('/apex/AdminUiMassUpdatePage?cemail='+contactEmail);
      }
      else if(String.isNotBlank(ProductINId)){
            ProductINId=EncodingUtil.urlEncode(ProductINId, 'UTF-8');
           return new Pagereference('/apex/AdminUiMassUpdatePage?prodId='+ProductINId);
      }
      else if(String.isNotBlank(contractNumber)){
           contractNumber=EncodingUtil.urlEncode(contractNumber, 'UTF-8');
           return new Pagereference('/apex/AdminUiMassUpdatePage?contractNumber='+contractNumber);
      }
      else if(String.isNotBlank(subscriptionName)){
           contractNumber=EncodingUtil.urlEncode(subscriptionName, 'UTF-8');
           return new Pagereference('/apex/AdminUiMassUpdatePage?subscriptionName='+subscriptionName);
      }
      else
         return null;
    }
  // Action method which gets called when the User clicks on Save after completion of edit of a record. 
  public void save(){
      Id adminRecordToSave = Apexpages.currentPage().getParameters().get('recordIdtosave');           // extracting the parameter being passed as to which record is to be edited
      
      AdminUIWrapper recordToBeSaved = helperMap.get(adminRecordToSave);                              // getting the record
      
      List<sObject> sobjList = new List<sObject>();
      
      Entitlement__x ent;
      Instance__x inst;
      
      if(!Test.isRunningTest()){
        // Querying the Entitlement External Object to store the Fulfillment status,Status and Last Updated By values.
        ent = [select id, ExternalId,entitlement_id__c,entitlement_start_date__c,last_update_time__c, status__c,fulfillment_status__c, last_updated_by__c from Entitlement__x where entitlement_id__c=:recordToBeSaved.adminRecord.entitlement_id__c];
        
        // Querying the Instance External Object to store the Product Instance Id,Object Id and Last Updated By values.
        inst = [Select id, ExternalId,tech_stack__c,instance_id__c,product_detail__c, product_instance_id__c, object_id__c, last_updated_by__c,sap_update__c from Instance__x where instance_id__c =: recordToBeSaved.adminRecord.instance_id__c];
        
      }
      else{
        
        ent = AdminUiContrl.getDummyEntitlementRecord(recordToBeSaved.adminRecord.entitlement_id__c);      //  Dummy Entitlement and Instance Object responses for test classes 
        inst = AdminUiContrl.getDummyInstanceRecord(recordToBeSaved.adminRecord.instance_id__c) ;          // 
      }
      
      
      ent.fulfillment_status__c = recordToBeSaved.adminRecord.fulfillment_status__c;                                                                                           // Updating the Entitlement record with the Fulfillment Status,Status,Last Updated By values
      ent.status__c = recordToBeSaved.adminRecord.status__c;
      ent.last_updated_by__c = 'SFDC';
     
      if(recordToBeSaved.adminRecord.product_instance_id__c!=null )                              // Updating the Instance record with the product instance id , object id only if they are not null.
      {
          inst.product_instance_id__c = recordToBeSaved.adminRecord.product_instance_id__c;
          if(recordToBeSaved.adminRecord.product_instance_id__c != inst.product_instance_id__c)
          {              
            //US497132 - updating sap status to zero when product instance id is updated
             inst.sap_update__c = false;
         
          }
            
      }
      
      if(recordToBeSaved.adminRecord.object_id__c!=null)
          inst.object_id__c = recordToBeSaved.adminRecord.object_id__c;
        if(recordToBeSaved.adminRecord.tech_stack__c!=null)
          inst.tech_stack__c = recordToBeSaved.adminRecord.tech_stack__c;      //Added as part of US340517  
       if(recordToBeSaved.adminRecord.product_detail__c!=null)
          inst.product_detail__c=recordToBeSaved.adminRecord.product_detail__c;   //Added as part of US340517  
                                                                                               // Updating the Instance record with the last updated by only if the product instance id and object id were populated.
      if(recordToBeSaved.adminRecord.product_instance_id__c!=null && recordToBeSaved.adminRecord.object_id__c!=null)
          inst.last_updated_by__c = 'SFDC';
       System.debug( ent.ExternalId);
       
      if( ent.ExternalId != null)
          ent.ExternalId = EncodingUtil.urlDecode(ent.ExternalId,'UTF-8');
          
      System.debug( ent.ExternalId);
      sobjList.add(ent);
      sobjList.add(inst);
      
      
      
      
      
      if(!Test.isRunningTest()){                                               // Performing DML on the sobject list containing entitlement and the instance records
          try{
              List<Database.SaveResult> saveResult = database.updateAsync(sobjList);
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
              ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'The edit Process was not successful.Please reload the page and try again.'));
          }
      }
      
      recordToBeSaved.isEdit = false;                                        // rolling back the isedit boolean variable of the wrapper record to false.
  }
  // Action method which gets called when the User clicks on Edit for a AdminUI record.  
  public void edit(){
        
      Id adminRecordToEdit = Apexpages.currentPage().getParameters().get('recordIdtoEdit');
      AdminUIWrapper recordToBeEdited = helperMap.get(adminRecordToEdit);
      recordToBeEdited.isEdit = true;
    
  }
  // Method to redirect back to the Contact Detail Page
  public PageReference redirectBack(){
      System.debug('----contactId--'+contactId);
            System.debug('----checkCon--'+checkCon);
               //Added as part of US340517  
      if(String.isNotBlank(contactId)&&contactId!=null){
          System.debug('-------enter contact blcok');
          return new PageReference('/'+contactId);
      }
     if(checkCon=='true')
          return new PageReference('/apex/AdminUI_Standalone');
     return null;    
  }  
  
  // Wrapper class to store individual record edit status 
  public class  AdminUIWrapper{
        
      public Id adminRecordId{get;set;}
      public AdminUIView__x adminRecord{get;set;}
      public Boolean isEdit{get;set;}
      
      public AdminUIWrapper(){
          
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
  public static Entitlement__x getDummyEntitlementRecord(String entitlementId){
    
    Entitlement__x entitlement1 = new Entitlement__x();
    entitlement1.entitlement_id__c = entitlementId;
    entitlement1.status__c = 'active';
    entitlement1.fulfillment_status__c = 'fulfillment started';
    return entitlement1;
  }
  public static Instance__x getDummyInstanceRecord(String instanceId){
    
    Instance__x instance1 = new Instance__x();
    instance1.instance_id__c = instanceId;
    instance1.object_id__c = 'OBJ001';
    instance1.product_instance_id__c = 'PROD001';
    return instance1;
  }
}