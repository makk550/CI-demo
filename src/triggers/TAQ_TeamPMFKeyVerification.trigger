trigger TAQ_TeamPMFKeyVerification on TAQ_Account_Team__c (before insert, before update) {  
   
   if(SystemIdUtility.skipTAQ_AccountTeam) //Global Setting defined in Custom Settings to make the Trigger not execute for either a specific user or all the org
        return;
    
   //FY13 PMFkey Validation
   
   Set<String> bufferedPMFKeys = new Set<String>();
   Set<Id> TAQ_AccountIDs = new Set<Id>();
   
   
   
   //FY13 - Sum of Primary Split Percentage should be equal to 100% - TADKR01
     Map<Id,Map<String,Decimal>> percCheck = new Map<Id,Map<String,Decimal>>();
     Map<Id,RecordType> recTypeMap = new Map<Id,RecordType>();
    
  
 //FY13 - Account Owners
 Set<String> setPMFkeys = new Set<String>();  
   
   
   
   // Collecting all PMF Keys in the execution.
   for(TAQ_Account_Team__c eachRec: Trigger.new)
   {
    //PMFkey validation - start
     if(eachRec.PMFKey__c!=null){ 
       eachRec.PMFKey__c = eachRec.PMFKey__c.toUpperCase();  
       bufferedPMFKeys.add(eachRec.PMFKey__c.toUpperCase());
       TAQ_AccountIDs.add(eachRec.TAQ_Account__c);
     }
    //PMFkey validation - end
    
    
    //Add PMFkeys for Populate User on TAQ Account Team
    if((Trigger.isInsert || ( Trigger.isUpdate && eachRec.PMFKey__c <> Trigger.oldMap.get(eachRec.id).PMFKey__c)) &&  eachRec.PMFKey__c <> null )
        setPMFkeys.add(eachRec.PMFKey__c.ToUpperCase());
    }
   
   
   Map<id,TAQ_Account__c> mapAccList = new Map<id,TAQ_Account__c>([SELECT Id,Region__c, RecordType.Name from TAQ_Account__c WHERE Id in: TAQ_AccountIDs]);
   
  
   
 
 
  List<TAQ_Organization__c> pmfvsnames = [SELECT PMFKey__c,Employee_Name__c from TAQ_Organization__c WHERE PMFKey__c in: bufferedPMFKeys];
  Map<String,String> pmfHolderMap = new Map<String,String>();
  
  // Pushing PMFs and Names into Map.
  for(TAQ_Organization__c eachRec: pmfvsnames){
    pmfHolderMap.put(eachRec.PMFKey__c.toUpperCase(),eachRec.Employee_Name__c);
  } 


//Validating a valid PMF key:
//Check 1 : Validate the saze should be 7 (for PMFkeys) or more (for Position Ids)
//Check 2 : Validate that a Valid Employee TAQ Org Record exists for Regional Accounts - excluded the check for EMEA - they do not have employees managed in TAQ
   System.debug('_____eee_______'+percCheck.keyset());
  for(TAQ_Account_Team__c t:trigger.new)
  {
       try{
             
            if(t.PMFKey__c.length() < 7)
            {
              t.PMFKey__c.addError('Please Enter a valid PMF Key with 7 Characters. Provided PMFKey is:'+t.PMFKey__c);
            }
            else if(((pmfHolderMap.get(t.PMFKey__c.toUpperCase())==null) || pmfHolderMap.get(t.PMFKey__c.toUpperCase())=='') && (t.PMFKey__c.length() == 7))
            {
               if(mapAccList.containsKey(t.TAQ_Account__c))
               {          
                  if(mapAccList.get(t.TAQ_Account__c).region__c !='EMEA' && mapAccList.get(t.TAQ_Account__c).recordType.Name.contains('Regional'))
                  { 
                    t.PMFKey__c.addError('No employee exists in TAQ Organization with the provided PMFKey - '+t.PMFKey__c+'. Please enter a valid PMFKey.');
                  }
               }    
            }
       }
       catch(Exception e)
       {
           t.PMFKey__c.addError('Problem exists with PMF Key. Kindly Verify.');  
       }
   
       
  
  }
 
      
  
  
   
  
   //START - FY13 1.1 - UPDATING THE USER FIELD WITH ACCOUNT OWNER/ACCOUNT OWNER MANAGER PMF KEY.
 //  try{       
          
     
      System.debug('_____SETPMF_____'+setPMFKeys);
     List<TAQ_Organization_Approved__c> orgApprRec = [SELECT Process_Step__c,Position_Id__c,PMFKey__c,Manager_PMFKey__c,
                                                         Manager_Org__r.Process_Step__c,    Manager_Org__r.PMFKey__c,   Manager_Org__r.Manager_PMF_Key__c,     Manager_Org__c,
                                                         Manager_Org__r.Manager_Org__r.Process_Step__c,         
                                                         Manager_Org__r.Manager_Org__r.Manager_PMF_Key__c,  
                                                         Manager_Org__r.Manager_Org__r.PMFKey__c,       
                                                         Manager_Org__r.Manager_Org__c,
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Process_Step__c,          
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_PMF_Key__c,   
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFKey__c,        
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__c,
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Process_Step__c,       
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_PMF_Key__c,    
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFKey__c,     
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__c,
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Process_Step__c,        
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_PMF_Key__c,     
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFKey__c,      
                                                         Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__c
                                                         from TAQ_Organization_Approved__c where (Position_Id__c in: setPMFkeys OR PMFKey__c in: setPMFkeys) 
                                                         and Is_Latest_Record__c =: true and Process_Step__c != 'Term / Transfer'];
     
      Map<String,TAQ_Organization_Approved__c> OrgPMFMap = new Map<String,TAQ_Organization_Approved__c>();
      
      for(TAQ_Organization_Approved__c toa: orgApprRec)
      {
        if(toa.Position_Id__c <> null)
            OrgPMFMap.put(toa.Position_Id__c.toUpperCase() ,toa);
      
        if(toa.PMFKey__c <> null)
              OrgPMFMap.put(toa.PMFKey__c.toUpperCase(),toa);
        if(toa.manager_PMFKey__c <> null)     
            OrgPMFMap.put(toa.manager_PMFKey__c.toUpperCase(),toa);
        if(toa.Manager_Org__r.PMFkey__c <> null)
            OrgPMFMap.put(toa.Manager_Org__r.PMFkey__c.toUpperCase(),toa);
        if(toa.Manager_Org__r.PMFkey__c <> null)
            OrgPMFMap.put(toa.Manager_Org__r.PMFkey__c.toUpperCase(),toa);
       
        if(toa.Manager_Org__r.Manager_Org__r.PMFkey__c <> null)
            OrgPMFMap.put(toa.Manager_Org__r.Manager_Org__r.PMFkey__c.toUpperCase(),toa);
        if(toa.Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFkey__c <> null)  
            OrgPMFMap.put(toa.Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFkey__c.toUpperCase(),toa);
        if(toa.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFkey__c <> null)
            OrgPMFMap.put(toa.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.Manager_Org__r.PMFkey__c.toUpperCase(),toa);
   //      setPMFkeys.add(toa.Manager_PMFKey__c);
      }
      
      List<User> userRec = [SELECT Id,isActive,PMFKey__c from User where PMFKey__c in: OrgPMFMap.keyset() AND PMFKey__c <> null];
      
      Map<String,User> userPMFMap = new Map<String,User>();
      
      for(User u: userRec)
      {
         userPMFMap.put(u.PMFKey__c.ToUpperCase(),u);
      }
    
     for(TAQ_Account_Team__c t: trigger.new)
     {
        system.debug('t.pmfkey__c----------' + t.pmfkey__c);
     // if(t.pmfkey__c <> null )
     //     system.debug('setPMFkeys.contains(t.pmfkey__c.toUppperCase())----------' + setPMFkeys.contains(t.pmfkey__c.toUppperCase()));
        
        if(t.pmfkey__c <> null && setPMFkeys.contains(t.pmfkey__c.toUpperCase()))
         {
             t.User__c = NULL;
             System.debug('____PMF2____'+OrgPMFMap.keyset());
             if(t.PMFKey__c != NULL && OrgPMFMap.containsKey(t.PMFKey__c.toUpperCase()))
             {
                
            
                try{                
                    if(userPMFMap.containsKey(t.PMFKey__c.toUpperCase()))
                    {
                        t.User__c = userPMFMap.get(t.PMFKey__c.toUpperCase()).Id;
                         System.debug('____PMF3____'+userPMFMap.get(t.PMFKey__c.toUpperCase()));
                   //     System.debug('____PMF3A____'+t.User__c.toUpperCase());
                    }
                    else 
                    {
                        
                        TAQ_Organization_Approved__c toa;
                        TAQ_Organization__c toMgr ;
                        TAQ_Organization__c toMgrMgr;
                        TAQ_Organization__c toMgrMgrMgr;
                        TAQ_Organization__c toMgrMgrMgrMgr;
                        
                        toa =   orgPMFMap.get(t.PMFKey__c.toUpperCase());
                        if(toa <> null)
                            toMgr = toa.manager_org__r;
                        if(toMgr <> null)
                           toMgrMgr =toMgr.manager_org__r;
                        if(toMgrMgr <> null)
                            toMgrMgrMgr = toMgrMgr.manager_org__r;
                        if(toMgrMgrMgr <> null)
                             toMgrMgrMgrMgr =  toMgrMgrMgr.manager_org__r;
                        
                        if((toMgr <> null && toMgr.PMFKey__c <> null &&  userPMFMap.containsKey(toMgr.PMFKey__c.toUpperCase()) && toMgr.Process_Step__c != 'Term / Transfer')  || (toMgr == null && toa.Manager_PMFKey__c <> null && userPMFMap.containsKey(toa.Manager_PMFKey__c.toUpperCase()) && userPMFMap.get(toa.Manager_PMFKey__c.toUpperCase()).isActive)){
                                t.User__c = (toMgr <> null && toMgr.PMFKey__c <> null &&  userPMFMap.containsKey(toMgr.PMFKey__c.toUpperCase()) ?userPMFMap.get(toMgr.PMFKey__c.toUpperCase()).Id:userPMFMap.get(toa.Manager_PMFKey__c.toUpperCase()).Id);
                                
                                System.debug('____PMF4____'+userPMFMap.containsKey(t.PMFKey__c.toUpperCase()));
                        }
                        else if((toMgrMgr <> null && toMgrMgr.PMFKey__c <> null && userPMFMap.containsKey(toMgrMgr.PMFKey__c.toUpperCase()) && toMgrMgr.Process_Step__c != 'Term / Transfer')|| (toMgrMgr == null && toMgr.Manager_PMF_Key__c <> null && userPMFMap.containsKey(toMgr.Manager_PMF_Key__c.toUpperCase()) && userPMFMap.get(toMgr.Manager_PMF_Key__c.toUpperCase()).isActive)){
                               t.User__c = toMgrMgr <> null && toMgrMgr.PMFKey__c <> null && userPMFMap.containsKey(toMgrMgr.PMFKey__c.toUpperCase())?userPMFMap.get(toMgrMgr.PMFKey__c.toUpperCase()).Id:userPMFMap.get(toMgr.Manager_PMF_Key__c.toUpperCase()).Id;
                               System.debug('____PMF5____'+userPMFMap.containsKey(t.PMFKey__c.toUpperCase()));
                        }
                        else if((toMgrMgrMgr <> null && toMgrMgrMgr.PMFKey__c <> null && userPMFMap.containsKey(toMgrMgrMgr.PMFKey__c.toUpperCase()) && toMgrMgrMgr.Process_Step__c != 'Term / Transfer')|| (toMgrMgrMgr == null && toMgrMgr.Manager_PMF_Key__c <> null &&  userPMFMap.containsKey(toMgrMgr.Manager_PMF_Key__c.toUpperCase()) && userPMFMap.get(toMgrMgr.Manager_PMF_Key__c.toUpperCase()).isActive)){
                               t.User__c = toMgrMgrMgr <> null && toMgrMgrMgr.PMFKey__c <> null && userPMFMap.containsKey(toMgrMgrMgr.PMFKey__c.toUpperCase())?userPMFMap.get(toMgrMgrMgr.PMFKey__c.toUpperCase()).Id:userPMFMap.get(toMgrMgr.Manager_PMF_Key__c.toUpperCase()).Id;
                                System.debug('____PMF6____'+userPMFMap.containsKey(t.PMFKey__c.toUpperCase()));
                        }
                        else if((toMgrMgrMgrMgr <> null && toMgrMgrMgrMgr.PMFKey__c <> null &&  userPMFMap.containsKey(toMgrMgrMgrMgr.PMFKey__c.toUpperCase()) && toMgrMgrMgrMgr.Process_Step__c != 'Term / Transfer')|| (toMgrMgrMgrMgr == null && toMgrMgrMgr.Manager_PMF_Key__c <> null && userPMFMap.containsKey(toMgrMgrMgr.Manager_PMF_Key__c.toUpperCase()) && userPMFMap.get(toMgrMgrMgr.Manager_PMF_Key__c.toUpperCase()).isActive)){
                               t.User__c = toMgrMgrMgrMgr <> null && toMgrMgrMgrMgr.PMFKey__c <> null &&  userPMFMap.containsKey(toMgrMgrMgrMgr.PMFKey__c.toUpperCase())?userPMFMap.get(toMgrMgrMgrMgr.PMFKey__c.toUpperCase()).Id:userPMFMap.get(toMgrMgrMgr.Manager_PMF_Key__c.toUpperCase()).Id;
                               System.debug('____PMF7____'+userPMFMap.containsKey(t.PMFKey__c.toUpperCase()));
                        }
                        
                    }
               }catch(Exception e){
                    System.debug('_____Exception while assigning user field on TAT record__'+e.getMessage());
                }   
                   
     
               }  
         }
      }
      
      
  //  }catch(Exception e){
  //      System.debug('___Exception while assigning user field value for taq account team record___'+e.getMessage());
  //  }     
  }