trigger AccountOppOwnersUpdate on Account (before Update,after Update) 
{
     
       if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
       if(SystemIdUtility.isneeded)
        return;
    /*
        The conditions are:
         If
         -   Account should be of Record Type Enterprise
         -   And Account Owner is changed
         -   Exist Opportunity owned by OLD Account Owner
        Then 
                    Update Opportunity which are owned by the OLD account owner to NEW account owner.
        //PRM Srprint 4 changes               
                    
         If
         -   Account is of Record Type Reseller/Distributor.
         -   And CAM for Route is changed.
         -   Exists opporunities related to the account.
        Then   
            Add new CAM to opportunity sales team.
            IF Solution provider CAM is changed
            -  Update the ownership of leads if there exists reseller leads owned by old CAM.
            -  Share the leads if there exists reseller leads created by partner.
                        
    */
  
  //try {      
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Account Team Covered Account');
    Id recEnterpriseId = rec.RecordType_Id__c; // record type id for enterprise accounts
    
    RecordTypes_Setting__c resellerRec = RecordTypes_Setting__c.getValues('Reseller/Distributor Account');
    Id recResellerId = resellerRec.RecordType_Id__c; // record type id for Reseller/Distributor accounts.

   //PRM Srprint 4 changes start.
    Map<Id,Map<String,Map<String,String>>> childOpps = new Map<Id,Map<String,Map<String,String>>> ();
    Map<Id,Map<String,Map<String,String>>> childLeads = new Map<Id,Map<String,Map<String,String>>> ();

            Map<Id,String> mapOldAllianceCAM = new Map<Id,String>();
            Map<Id,String> mapnewAllianceCAM= new Map<Id,String>();
            Map<Id,String> mapoldSolnProvCAM= new Map<Id,String>();
            Map<Id,String> mapnewSolnProvCAM= new Map<Id,String>();
            Map<Id,String> mapoldServProvCAM= new Map<Id,String>();
            Map<Id,String> mapnewServProvCAM= new Map<Id,String>();

    
    Set<String> oldPmfKeys  = new Set<String>();
    Set<String> newPmfKeys  = new Set<String>();
   //PRM Sprint 4 changes End.

    Map<id,id> mapAccountOwner = new Map<id,id>();
    integer i=0;
    
    if(SystemIdUtility.mapAccountsOld == null && Trigger.isAfter && Trigger.isUpdate) //In case the Before Trigger is not Executed- i.e the Lead Conversion Created this record
            SystemIdUtility.mapAccountsOld = Trigger.oldMap;    
    
    for(account acc : trigger.new)
        {
        //  System.debug('____aaa____'+acc.recordtypeid);
        //  System.debug('____bbb____'+recEnterpriseId);
        //  System.debug('____bbb____'+SystemIdUtility.mapAccountsOld);
        //  System.debug('____bbb____'+SystemIdUtility.mapAccountsOld.get(acc.id));
        //  System.debug('____bbb____'+SystemIdUtility.mapAccountsOld.get(acc.id).ownerid);
        //  System.debug('____bbb____'+acc.ownerid);
            
            
            if(acc.recordtypeid == (recEnterpriseId) && SystemIdUtility.mapAccountsOld != NULL &&  SystemIdUtility.mapAccountsOld.get(acc.id)!=null && SystemIdUtility.mapAccountsOld.get(acc.id).ownerid != acc.ownerid )
            {      
              System.debug('______map___'+acc.Id);
                 mapAccountOwner.put(acc.id,SystemIdUtility.mapAccountsOld.get(acc.id).ownerid);                 
            }
                
            //PRM Srprint 4 changes start.                                  
            if(acc.RecordTypeId == recResellerId ){          
               Map<String,String> pmfKeys = new Map<String,String> ();
               Map<String,Map<String,String>> routes = new Map<String,Map<String,String>> ();                  
               
               String oldAllianceCAM;
               String newAllianceCAM;
               String oldSolnProvCAM;
               String newSolnProvCAM;
               String oldServProvCAM;
               String newServProvCAM;
               
               if(Trigger.oldMap.get(acc.Id).Alliance_CAM_PMFKey__c!=null)
                  oldAllianceCAM = Trigger.oldMap.get(acc.Id).Alliance_CAM_PMFKey__c.toUpperCase();
               if(acc.Alliance_CAM_PMFKey__c!=null)
                  newAllianceCAM = acc.Alliance_CAM_PMFKey__c.toUpperCase();  
               if(Trigger.oldMap.get(acc.Id).Solution_Provider_CAM_PMFKey__c!=null)
                  oldSolnProvCAM =Trigger.oldMap.get(acc.Id).Solution_Provider_CAM_PMFKey__c.toUpperCase();
               if(acc.Solution_Provider_CAM_PMFKey__c!=null)
                  newSolnProvCAM = acc.Solution_Provider_CAM_PMFKey__c.toUpperCase();
               if(Trigger.oldMap.get(acc.Id).Service_Provider_CAM_PMFKey__c!=null)
                  oldServProvCAM =Trigger.oldMap.get(acc.Id).Service_Provider_CAM_PMFKey__c.toUpperCase();
               if(acc.Service_Provider_CAM_PMFKey__c!=null)
                  newServProvCAM=acc.Service_Provider_CAM_PMFKey__c.toUpperCase();       
                  
                        mapOldAllianceCAM.put(acc.Id,OldAllianceCAM);
                        mapnewAllianceCAM.put(acc.Id,newAllianceCAM);
                        mapoldSolnProvCAM.put(acc.Id,oldSolnProvCAM);
                        mapnewSolnProvCAM.put(acc.Id,newSolnProvCAM);
                        mapoldServProvCAM.put(acc.Id,oldServProvCAM);
                        mapnewServProvCAM.put(acc.Id,newServProvCAM);               
               
               if(oldSolnProvCAM!= newSolnProvCAM){         
                     pmfKeys.put(oldSolnProvCAM,newSolnProvCAM);
                     routes.put('Solution Provider',pmfKeys); 
                     if(newSolnProvCAM!=null)
                       newPmfKeys.add(newSolnProvCAM);
                     if(oldSolnProvCAM!=null){
                       oldPmfKeys.add(oldSolnProvCAM);                    
                       childLeads.put(acc.Id,routes);
                     }
                                                    
               }
                          
               if(oldAllianceCAM!= newAllianceCAM){
                     pmfKeys.put(oldAllianceCAM,newAllianceCAM);
                     routes.put('Alliance',pmfKeys);
                     if(oldAllianceCAM!=null)
                       oldPmfKeys.add(oldAllianceCAM);
                     if(newAllianceCAM!=null)
                       newPmfKeys.add(newAllianceCAM);          
               }
                  
               if(oldServProvCAM!= newServProvCAM){ 
                     pmfKeys.put(oldServProvCAM,newServProvCAM);
                     routes.put('Service Provider',pmfKeys); 
                     if(oldServProvCAM!=null)   
                        oldPmfKeys.add(oldServProvCAM);
                     if(newServProvCAM!=null)
                     newPmfKeys.add(newServProvCAM);                   
               }     
             
       
               if(routes.size()>0){             
                  childOpps.put(acc.Id,routes);
                  //if(routes.containsKey('Solution Provider')){
                    // childLeads.put(acc.Id,routes);                     
                  //}                           
              }
            }                    
          //PRM Sprint 4 changes End.             
                
        }
      List<string> lstOppIds= new List<string>();
      Map<string,string> mapOppOwner = new Map<string,string>();
      List<opportunity> lstOpp = new List<opportunity>();
             System.debug('_____ddD______'+mapAccountOwner.keyset());
      for(opportunity opp:[Select id, accountId, name, account.ownerId, probability, ownerId, account.LastModifiedBy.Title, Opportunity_Type__c from Opportunity where AccountId in : mapAccountOwner.keyset() and probability > 0 and probability < 100 and LastModifiedBy.Title != : AccountOwnerTransferSynchronizer.INTEGRATION_ACCOUNT_TITLE ])
           {
               System.debug(Opp+'<---Opportunity_______Opportunity Name----->'+Opp.name);
               if(opp.ownerId == SystemIdUtility.mapAccountsOld.get(opp.accountId).ownerid && opp.probability > 0 && opp.probability < 100 && opp.account.LastModifiedBy.Title != AccountOwnerTransferSynchronizer.INTEGRATION_ACCOUNT_TITLE)
               {   
                   // if(opp.ownerid == SystemIdUtility.mapAccountsOld.get(opp.accountid).ownerid)
                   if(opp.ownerid == SystemIdUtility.mapAccountsOld.get(opp.accountid).ownerid && (opp.Opportunity_Type__c == null || !opp.Opportunity_Type__c.startsWith('Renewal')))   
                   {  
                         opp.ownerid = trigger.newmap.get(opp.accountid).ownerid;
                         lstOppIds.add(opp.id);
                         lstOpp.add(opp);//, opp.account.ownerId);
                         mapOppOwner.put(opp.id, opp.ownerid);
                         System.debug(mapOppOwner+'<---mapOppOwner___After*******____lstOpp----->'+lstOpp);
                   }   
              }
           }

    if(lstOpp.size() + Limits.getDMLRows() < Limits.getLimitDMLRows())
        {
                  system.debug('---lstOpp' + lstOpp);
       
           // List<opportunity> lstOpp = new List<opportunity>();
           //  for(string oppid:lstOppIds)
           //      lstOpp.add(new Opportunity(id=oppid, ownerId=mapOppOwner.get(oppid)));
              database.update(lstOpp,false);
           System.debug('---lstOpp____After********' + lstOpp);   
        }
    else
        AccountTeamsProcessor.updateOpportunities(lstOppIds, mapOppOwner); 
        
     if(childLeads.size()>0)
     {
        //Update leads.
        UpdateChildOwnership updtChld = new UpdateChildOwnership();
        updtChld.UpdateChild(childLeads,oldPmfKeys,newPmfKeys);      
     } 
  
     /*
     vasantha
     if(childOpps.size()>0)
     {
       //Update Opportunities. 
      CreatePartnerOpptySalesTeam oppSalesTeam = new CreatePartnerOpptySalesTeam();   
      oppSalesTeam.updateOpportunitySalesTeam(childOpps,oldPmfKeys,newPmfKeys);   
     }*/
     if(childOpps.size()>0)
     {
       //Update Opportunities. 
      CreatePartnerOpptySalesTeam oppSalesTeam = new CreatePartnerOpptySalesTeam();   
      //oppSalesTeam.updateOpportunitySalesTeam1(mapOld,mapNew,oldPmfKeys,newPmfKeys);   
      CreatePartnerOpptySalesTeam.updateOpportunitySalesTeam1(mapOldAllianceCAM,mapnewAllianceCAM,mapoldSolnProvCAM,mapnewSolnProvCAM,mapoldServProvCAM,mapnewServProvCAM,oldPmfKeys,newPmfKeys);
      //CreatePartnerOpptySalesTeam.updateOpportunitySalesTeam1(mapOld,mapNew,oldPmfKeys,newPmfKeys);   
     }
        
// }
//  catch (Exception ex) {
//    System.debug(ex.getMessage());
//  }  
}