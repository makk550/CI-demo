//SEERA02 - AR2092

public with sharing class BPHistory {

private Business_Plan_New__c prevBP,latestBP; 
private Attachment prevBPAttachment;

public BPHistory (Business_Plan_New__c BP){
    latestBP = new Business_Plan_New__c();
    latestBP = BP;
    prevBP = [Select Id, Status__c, Name, Alliance_Program_Level__c,Service_Provider_Program_Level__c,Solution_Provider_Program_Level__c from Business_Plan_New__c where Id =:latestBP.Id]; 
}

//SAMAP01 US239334    public void createBPHistory(Set<String> delPGSoln,Set<String> addedPGSoln,Map<String,List<BP_Training_Contact__c>> delTrainingContactMap,Map<String,List<BP_Training_Contact__c>> addedTrainingContactMap, List<BusinessPlanControllerExtension.ProductGroup> AddedPGs,List<BP_Solutions__c> solnList){  
    public void createBPHistory(Set<String> delPGSoln,Set<String> addedPGSoln,Map<String,List<BP_Training_Contact__c>> delTrainingContactMap,Map<String,List<BP_Training_Contact__c>> addedTrainingContactMap, List<BusinessPlanControllerExtension.ProductGroup> AddedPGs,List<BP_Solutions__c> solnList, boolean IsGeoAccount){
         
         List<BP_History_Lineitem__c> BPHLFinal = new List<BP_History_Lineitem__c>();
         String fieldLabel,ResourcefieldLabel,fieldLabelTotal;
         Map<String,Schema.SobjectType> ObjectMap = Schema.getGlobalDescribe();
         
         Schema.SobjectType objectName = ObjectMap.get('Business_Plan_New__c');
         Map<String, Schema.SObjectField> fieldMap = objectName.getDescribe().fields.getMap();
         
         Schema.SobjectType SolnobjectName = ObjectMap.get('BP_Solutions__c');
         Map<String, Schema.SObjectField> SolnfieldMap = SolnobjectName.getDescribe().fields.getMap();
         
         Schema.SobjectType ResourceObjectName = ObjectMap.get('BP_Training_contact__c');
         Map<String, Schema.SObjectField> ResourcefieldMap = ResourceObjectName.getDescribe().fields.getMap();
         
            
        List<BP_History_Lineitem__c> BPHLList = new List<BP_History_Lineitem__c>();
           
            
           if(prevBP.Status__c == 'Modifying' || prevBP.Status__c == 'CA & Partner Approved' || prevBP.Status__c == 'CA Rejected' ||prevBP.Status__c == 'Partner Rejected' || prevBP.Status__c == 'Recalled')
           {
                System.debug('Entered1');
                if(latestBP.Alliance_Program_Level__c != prevBP.Alliance_Program_Level__c) {
                        
                        BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                        fieldLabel = fieldMap.get('Alliance_Program_Level__c').getDescribe().getLabel();
                        BPHL.Tab_Name__c = 'Profile Tab';
                        if(latestBP.Alliance_Program_Level__c == null) {
                            BPHL.Operation__c = 'Removed';
                            BPHL.ChangeText__c = fieldLabel+' </b>'+System.Now();
                        }
                        else if(prevBP.Alliance_Program_Level__c == null){
                            BPHL.Operation__c = 'Added';
                            BPHL.ChangeText__c = fieldLabel+' <b>'+latestBP.Alliance_Program_Level__c+' on </b>'+System.Now();
                        }
                        else{
                            BPHL.Operation__c = 'Changed';
                            BPHL.ChangeText__c = fieldLabel+' from <b>'+prevBP.Alliance_Program_Level__c+'</b> to <b>'+latestBP.Alliance_Program_Level__c+' on </b>'+System.Now();
                        }
                        System.debug('Entered2'+BPHL);
                        BPHLList.add(BPHL);
                }
                if(latestBP.Service_Provider_Program_Level__c != prevBP.Service_Provider_Program_Level__c){
                    
                        BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                        fieldLabel = fieldMap.get('Service_Provider_Program_Level__c').getDescribe().getLabel();
                        BPHL.Tab_Name__c = 'Profile Tab';
                        if(latestBP.Service_Provider_Program_Level__c == null) {
                            BPHL.Operation__c = 'Removed';
                            BPHL.ChangeText__c = fieldLabel+' <b>'+System.Now();
                        }
                        else if(prevBP.Service_Provider_Program_Level__c == null){
                            BPHL.Operation__c = 'Added';
                            BPHL.ChangeText__c = fieldLabel+' <b>'+latestBP.Service_Provider_Program_Level__c+' </b>'+System.Now();
                        }
                        else{
                            BPHL.Operation__c = 'Changed';
                            BPHL.ChangeText__c = fieldLabel+' from <b>'+prevBP.Service_Provider_Program_Level__c+'</b> to <b>'+latestBP.Service_Provider_Program_Level__c+' on </b>'+System.Now();                        }
                        System.debug('Entered3'+BPHL);
                        BPHLList.add(BPHL);
                
                }
                if(latestBP.Solution_Provider_Program_Level__c != prevBP.Solution_Provider_Program_Level__c){
                        
                        BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                        fieldLabel = fieldMap.get('Solution_Provider_Program_Level__c').getDescribe().getLabel();
                        BPHL.Tab_Name__c = 'Profile Tab';
                        if(latestBP.Solution_Provider_Program_Level__c == null) {
                            BPHL.Operation__c = 'Removed';
                            BPHL.ChangeText__c = fieldLabel+' </b>'+System.Now();
                        }
                        else if(prevBP.Solution_Provider_Program_Level__c == null){
                            BPHL.Operation__c = 'Added';
                            BPHL.ChangeText__c = fieldLabel+' <b>'+latestBP.Solution_Provider_Program_Level__c+' </b>'+System.Now();
                        }
                        else{
                            BPHL.Operation__c = 'Changed';
                            BPHL.ChangeText__c = fieldLabel+' from <b>'+prevBP.Solution_Provider_Program_Level__c+'</b> to <b>'+latestBP.Solution_Provider_Program_Level__c+' on </b>'+System.Now();
                        }
                        System.debug('Entered4'+BPHL);
                        BPHLList.add(BPHL);
                }
                
               if(IsGeoAccount) //SAMAP01 - US239334
               {
                   fieldLabel = Label.BP_Business_Unit;
               }
               else
               {
                   fieldLabel = SolnfieldMap.get('Product_Group__c').getDescribe().getLabel();
               }
             
                if(delPGSoln.size() > 0){
                    
                    for(String PG : delPGSoln){
                      BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                     
                      BPHL.Tab_Name__c = 'Solution Tab';
                      BPHL.Operation__c = 'Removed';
                      BPHL.ChangeText__c = fieldLabel+'<b> '+PG+' </b>'+System.Now();
                      
                      BPHLList.add(BPHL);
                    }
                    
                }
                 if(addedPGSoln.size() > 0){
                    
                     for(String PG : addedPGSoln){
                        BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                     
                          BPHL.Tab_Name__c = 'Solution Tab';
                          BPHL.Operation__c = 'Added';
                          BPHL.ChangeText__c = fieldLabel+'<b> '+PG+' </b>'+System.Now();
                          
                          BPHLList.add(BPHL);
                     }  
                }
                 if(delTrainingContactMap.size() > 0){
                    System.debug('DelTC');
                    
                    for(String PG : delTrainingContactMap.keySet()){
                        
                        for(BP_Training_Contact__c resource : delTrainingContactMap.get(PG)){
                            BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                              
                              BPHL.Tab_Name__c = 'Resource Tab';
                              BPHL.Operation__c = 'Removed';
                              BPHL.ChangeText__c = fieldLabel+'<b> '+PG+'</b> - ';
                              ResourcefieldLabel = ResourcefieldMap.get('resource_type__c').getDescribe().getLabel();
                              BPHL.ChangeText__c += ResourcefieldLabel+'<b> '+resource.resource_type__c+' </b>'+System.Now();
                              
                              if(resource.test_contact_name__c != null){
                                  ResourcefieldLabel = ResourcefieldMap.get('test_contact_name__c').getDescribe().getLabel();
                                  BPHL.ChangeText__c +=' - '+ResourcefieldLabel+'<b> '+resource.test_contact_name__c+' </b>'+System.Now();
                              }
                              BPHLList.add(BPHL);
                        }
                    }
                }
                 if(addedTrainingContactMap.size() > 0){
                    System.debug('AddTC');
                    
                    for(String PG : addedTrainingContactMap.keySet()){
                    
                        for(BP_Training_Contact__c resource : addedTrainingContactMap.get(PG)){
                            BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                              
                              BPHL.Tab_Name__c = 'Resource Tab';
                              BPHL.Operation__c = 'Added';
                              BPHL.ChangeText__c = fieldLabel+'<b> '+PG+'</b>';
                              ResourcefieldLabel = ResourcefieldMap.get('resource_type__c').getDescribe().getLabel();
                              BPHL.ChangeText__c += ' - '+ResourcefieldLabel+'<b> '+resource.resource_type__c+' on </b>'+System.Now();
                              
                              if(resource.test_contact_name__c != null){
                                  ResourcefieldLabel = ResourcefieldMap.get('test_contact_name__c').getDescribe().getLabel();
                                  BPHL.ChangeText__c +=' - '+ResourcefieldLabel+'<b> '+resource.test_contact_name__c+' on </b>'+System.Now();
                              }
                              
                              BPHLList.add(BPHL);
                         }  
                    }
                }
                
                 if(AddedPGs.size() > 0){
                    
                    system.debug('Enterresourcechange');
                    
                    Map<Id,BP_Training_Contact__c> resourcesMap = new Map<Id,BP_Training_Contact__c>();
                    
                    for(BusinessPlanControllerExtension.ProductGroup PG: AddedPGs){
                        
                        for(BP_Training_Contact__c resource : PG.myBPTrainingContacts){
                            if(resource.Id != null)
                                resourcesMap.put(resource.Id,resource);
                        }
                     }
                    List<BP_Training_Contact__c> prevResource = [Select Id,Test_Contact_Name__c,resource_type__c,BP_Solutions__r.Product_Group__c from BP_Training_Contact__c where Id in :resourcesMap.keySet()];
                    
                    System.debug('prevResource'+prevResource);
                    System.debug('resourcesMap'+resourcesMap);
                        
                    for(BP_Training_Contact__c bptc : prevResource){
                        
                            if(bptc.Test_Contact_Name__c != resourcesMap.get(bptc.Id).test_contact_name__c){
                            
                                BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                              system.debug('Enterresourcechange1');
                                  BPHL.Tab_Name__c = 'Resource Tab';
                                  BPHL.Operation__c = 'Changed';
                                  BPHL.ChangeText__c = fieldLabel+'<b> '+bptc.BP_Solutions__r.Product_Group__c+' </b>'+System.Now();
                                  ResourcefieldLabel = ResourcefieldMap.get('resource_type__c').getDescribe().getLabel();
                                  BPHL.ChangeText__c += ' - '+ResourcefieldLabel+'<b> '+bptc.resource_type__c+' </b>'+System.Now();
                                  
                                  ResourcefieldLabel = ResourcefieldMap.get('test_contact_name__c').getDescribe().getLabel();
                                  BPHL.ChangeText__c +=' - '+ResourcefieldLabel+' from <b> '+bptc.test_contact_name__c+'</b> to <b>'+resourcesMap.get(bptc.Id).test_contact_name__c+' </b>'+System.Now();
                              
                                BPHLList.add(BPHL);
                              }
                                
                     }
                            
                    }
                
                if(solnList.size() > 0){
                
                    
                    Map<String,BP_Solutions__c> solnMap = new Map<String,BP_Solutions__c>();
                    
                    for(BusinessPlanControllerExtension.ProductGroup PG: AddedPGs){ 
                            
                            if(PG.PNCVTotal != PG.PNCVTotalInitial){
                                 BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                           
                            fieldLabelTotal = 'Product Total Annual';
                            BPHL.Tab_Name__c = 'BookingTarget Tab';
                            BPHL.Operation__c = 'Changed';
                            BPHL.ChangeText__c = fieldLabel+'<b> '+PG.myPG+' </b>';
                            BPHL.ChangeText__c +=fieldLabelTotal+' from <b>'+PG.PNCVTotalInitial+'</b> to <b>'+PG.PNCVTotal+' </b>'+System.Now();
                            
                            BPHLList.add(BPHL);
                           }
                            if(PG.SNCVTotal != PG.SNCVTotalInitial){
                                 BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                           
                            fieldLabelTotal = 'Services Total Annual';
                            BPHL.Tab_Name__c = 'BookingTarget Tab';
                            BPHL.Operation__c = 'Changed';
                            BPHL.ChangeText__c = fieldLabel+'<b> '+PG.myPG+' </b>'+System.Now();
                            BPHL.ChangeText__c +=fieldLabelTotal+' from <b>'+PG.SNCVTotalInitial+'</b> to <b>'+PG.SNCVTotal+' </b>'+System.Now();
                            
                            BPHLList.add(BPHL);
                          }
                            if(PG.ENCVTotal != PG.ENCVTotalInitial){
                                 BP_History_Lineitem__c BPHL = new BP_History_Lineitem__c();
                           
                            fieldLabelTotal = 'Education Total Annual';
                            BPHL.Tab_Name__c = 'BookingTarget Tab';
                            BPHL.Operation__c = 'Changed';
                            BPHL.ChangeText__c = fieldLabel+'<b> '+PG.myPG+' </b>'+System.Now();
                            BPHL.ChangeText__c +=fieldLabelTotal+' from <b>'+PG.ENCVTotalInitial+'</b> to <b>'+PG.ENCVTotal+' </b>'+System.Now();
                            
                            BPHLList.add(BPHL); 
                            }
                        }
                    }
                
                }
                
                
                if(BPHLList.size() > 0){
                    
                                        
                    List<BP_History_Activities__c> prevBPHA = [select id,to_attachment_Id__c,to_attachment_Name__c from BP_History_Activities__c where BP_History_Activities__c.Business_Plan__c =:latestBP.Id order by CreatedDate DESC limit 1];
                                
                    if(prevBP.Status__c == 'Modifying' && prevBPHA.size() !=0){
                        
                        for(BP_History_Lineitem__c bphl :BPHLList){
                            bphl.BP_History_Activity__c = prevBPHA[0].Id;
                            BPHLFinal.add(bphl);
                        }
                    }
                    
                    else {        
                                            
                    BP_History_Activities__c BPH = new BP_History_Activities__c();
                    BPH.Business_Plan__c = latestBP.Id;
                    BPH.Modified_User__c = UserInfo.getUserId();
                        
                    insert BPH;
                    
                    if(prevBPHA.size() !=0 ){
                        BPH.from_attachment_Id__c = prevBPHA[0].to_attachment_Id__c;
                        BPH.from_attachment_Name__c = prevBPHA[0].to_attachment_Name__c ;
                    }
                    else{                       
                        List<Attachment> initialBPAttachment = [select id,Name from Attachment where ParentId =:BPH.Business_Plan__c and Description = 'Business Plan Approval Process Generated Attachments - Do not change Description'];       
                        System.debug('initialBPAttachment:'+initialBPAttachment);
                        if(initialBPAttachment.size() > 0){
                        BPH.from_attachment_Id__c = initialBPAttachment[0].Id;
                        BPH.from_attachment_Name__c = initialBPAttachment[0].Name;
                        }
                    }
                    update BPH;

                    for(BP_History_Lineitem__c bphl :BPHLList){
                            bphl.BP_History_Activity__c = BPH.Id;
                            BPHLFinal.add(bphl);
                    }
                    System.debug(BPHLList);
                    System.debug(BPHLFinal);
                    }
                    
                    if(BPHLFinal.size() > 0)
                        insert BPHLFinal; 
           }       
       
       }        
 
}