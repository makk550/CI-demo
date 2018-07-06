trigger accountInheritFromParent_bibuaiau on Account (before insert,before update, after insert, after update) 
{
     if(SystemIdUtility.skipAccount == true)
        return;
     if(SystemIdUtility.skipAccountOnMIPSUpdate)//---variable set in ContractsInvalidation class and Account_MIPSupdate class
        return;
    /*
       Record type = Commercial, parent Record Type = Enterprise
       bi/bu/au of parents  3.  The Account Type will be inherited from the parent Enterprise Account â€“ Medium Complexity - Development 
       bi/bu/au of parents  4.  The Account Owner will change to the owner of the parent Enterprise Account â€“ Medium Complexity - Development
       ai/au                5.  The Account Team will be inherited from the Parent Enterprise Account â€“ Medium Complexity - Development
       bi/bu/ au of parents 6.  For NA, the Territory will change to the Territory of the parent Enterprise Account. The initial 7.0 account loads will be configured for this. 
    */
   
    Set<id> accids= new set<id>();
    Set<id> parentaccids = new set<id>();
   // Schema.DescribeSObjectResult accountRTDescribe = Schema.SObjectType.Account;    
   //  Map<String,Schema.RecordTypeInfo> accountRecTypeMap = accountRTDescribe.getRecordTypeInfosByName(); 
    List<AccountTeamMember> lstUpsertList = new List<accountTeamMember>();
    
    //Id recCommercialId = accountRecTypeMap.get('Commercial Account').getRecordTypeId(); //record type id for comm accounts
    //Id recEnterpriseId = accountRecTypeMap.get('CA Enterprise Account').getRecordTypeId(); // record type id for enterprise accounts
    
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Commercial Account');
    id recid = rec.RecordType_Id__c;
    Id recCommercialId =  rec.RecordType_Id__c; //record type id for comm accounts
    rec = RecordTypes_Setting__c.getValues('CA Enterprise Account');
    Id recEnterpriseId = rec.RecordType_Id__c; // record type id for enterprise accounts
    
    
    if(Trigger.isInsert)
    { 
        
        for(Account acc:Trigger.new)
         {
              if(acc.recordtypeid == recCommercialId)
                  {
                      accids.add(acc.id);
                      if(acc.parentid != null)
                          parentaccids.add(acc.parentid);  
                 }   
         }
            
        if(accids.size() > 0) // IF ONE OR MORE COMMERCIAL ACCOUNTS ARE INSERTED
         {    Map<ID, Account> m = new Map<ID, Account>([Select id, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c, Customer_Category__c, OwnerId from Account Where Id in : parentaccids and recordtypeid =: recenterpriseid]);
              if(m.size() > 0) //IF ONE OR MORE PARENTS ARE OF ENTERPRISE RECORD TYPE)
                  {
                      if(Trigger.isBefore)
                      {
                          for(account acc: trigger.New) //COPY ACC TYPE, OWNER, TERRITORY FIELDS
                          {
                             if(acc.recordtypeId == recCommercialId)
                                {
                                      // Update the Account Type, Owner with values in parent
                                      // If the Parent account Region = NA or Region = PS/CAN then the 4 territory (Region, Area, Territory and Country) fields also need to be copied down
                                        if(acc.parentId != null && m.get(acc.parentId) != null)
                                             {
                                                 acc.Customer_Category__c = m.get(acc.parentId).Customer_Category__c;
                                                 acc.ownerId = m.get(acc.parentId).ownerId;
                                                 //sunji03 - FY19, PS/CAN GEO is added, add it to the condition.
                                                 if(m.get(acc.parentId).GEO__c == 'NA' || m.get(acc.parentId).GEO__c == 'PS/CAN')
                                                 {
                                                     acc.GEO__c= m.get(acc.parentId).GEO__c;
                                                     acc.Sales_Area__c= m.get(acc.parentId).Sales_Area__c;
                                                     acc.Sales_Region__c= m.get(acc.parentId).Sales_Region__c;
                                                     acc.Region_Country__c= m.get(acc.parentId).Region_Country__c;
                                                 }
                                             }
                                }     
                          }
                      
                      }
                      else if(Trigger.isAfter) //COPY ACC TEAM MEMBERS
                      {    
 
                          List<accountTeamMember> lstAll = [Select a.UserId, a.TeamMemberRole, a.Id, a.AccountId, a.AccountAccessLevel From AccountTeamMember a where accountid in  : m.keySet() AND a.user.IsActive = true  order by accountid];
                      
                          SET<string> parentIds = new SET<string>{};
                            
                          Map<string,string> mapparent = new map<string,string>{};
                          for(account acc: trigger.New) //COPY ACC TEAM MEMBERS
                              {
                                  if(m.get(acc.id) != null)  //the parent should be of Enterprise Type
                                        {  mapparent.put(acc.id,acc.parentId);
                                            parentIds.add(acc.parentId);
                                        }    
                              }
                          if(lstAll.size() > 0 && mapparent.keySet().size() > 0 && mapparent.size() > 0)
                              AccountTeamsProcessor.processTeams(parentIds,mapparent);
                  
               }
           }  
        }       
    }
    else if(Trigger.isUpdate) //IF AN ENTERPRISE ACCOUNT IS UPDATED, DO UPDATIONS IN ITS CHILD COMMERCIAL ACCOUNTS FOR ACC TYPE, OWNER
    {
        if(Trigger.isAfter)
        {    
            List<id> commaccIds = new List<id>();
            Set<id> parentEntIds = new Set<id>();
            //Check if there is a change in Account Type, Owner 
            //If territory is/was NA or PS/CAN, check changes for (Region, Area, Territory and Country) fields
            for(Integer i=0; i<trigger.new.size(); i++)
                {
                    if(trigger.new[i].recordTypeId == recEnterpriseId)
                      {      
                        //sunji03 - FY19, PS/CAN GEO is added, add it to the condition.
                          if(trigger.new[i].Customer_Category__c != trigger.Old[i].Customer_Category__c ||
                             trigger.new[i].ownerId != trigger.Old[i].ownerId  ||
                             (
                                 (trigger.new[i].Geo__c == 'NA' || trigger.new[i].Geo__c == 'PS/CAN' ) &&
                                 (
                                     trigger.new[i].Geo__c != trigger.Old[i].Geo__c ||
                                     trigger.new[i].Sales_Area__c != trigger.Old[i].Sales_Area__c ||
                                     trigger.new[i].Sales_Region__c != trigger.Old[i].Sales_Region__c ||
                                     trigger.new[i].Region_Country__c != trigger.Old[i].Region_Country__c 
                                
                                 )
                             ) 
                          )
                          {
                            parentaccids.add(trigger.New[i].Id);  
                          }
                      }
                    if(trigger.new[i].recordTypeId == recCommercialId)
                       {
                           if(trigger.new[i].parentId != trigger.old[i].parentId && trigger.new[i].parentId != null)
                               {
                                   commaccIds.add(trigger.new[i].Id);
                                   parentEntIds.add(trigger.new[i].parentId);
                               }
                       }
                      
                }
               
               if(parentaccIds.size() > 0)
               {
                  
                   List<account> lstAll = [Select id, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c, Customer_Category__c, OwnerId,ParentId from Account Where parentId in : parentaccids and recordtypeid =: recCommercialId]; 
                   Map<id, List<Account>> mAcc = new map<id, list<Account>>{};
                   List<Account> lsttemp = new List<Account>();
                   Id vId = null;
                   for(Account acc: lstAll) //MAPPING THE CHILD ACCs WITH THE ACC ID
                         {
                                if(vId != acc.parentId && vId != null)
                                        {
                                                mAcc.put(vId, lsttemp);
                                                lsttemp = new  List<Account>();
                                        }  
                                        lsttemp.add(acc);
                                        vId = acc.parentId ;
                         }
                   if(lsttemp.size() > 0)
                         mAcc.put(vId, lsttemp);  
                   List<string> lstUpdateAccountIds = new List<string>();
                   List<string> Customer_Category = new List<string>();
                   List<string> ownerId = new List<string>();
                   List<string> GEO = new List<string>();
                   List<string> Sales_Area = new List<string>();
                   List<string> Sales_Region = new List<string>();
                   List<string> Region_Country = new List<string>();

                   
                   lstAll = new List<Account>();
                   for(Account pAcc: Trigger.New)
                       {
                           if(macc.get(pAcc.id) != null && macc.get(pAcc.id).size() > 0)
                           {
                               for(account a:mAcc.get(pAcc.Id))
                                  {
                                      boolean accChanged = false;
                                      if(pAcc.Customer_Category__c != a.Customer_Category__c)
                                         {
                                              a.Customer_Category__c = pAcc.Customer_Category__c;
                                              accChanged = true;
                                         }
                                      if(pAcc.ownerId != a.ownerId)
                                         {
                                              a.ownerId = pAcc.ownerId;
                                              accChanged = true;
                                         }

                                       //sunji03 - FY19, PS/CAN GEO is added, add it to the condition. 
                                       if(pAcc.Geo__c == 'NA' || pAcc.Geo__c == 'PS/CAN')
                                         {
                                             if(pAcc.GEO__c!= a.GEO__c)
                                             {
                                                  a.GEO__c= pAcc.GEO__c;
                                                  accChanged = true;
                                             }
                                             if(pAcc.Sales_Area__c!= a.Sales_Area__c)
                                             {
                                                  a.Sales_Area__c= pAcc.Sales_Area__c;
                                                  accChanged = true;
                                             }
                                             if(pAcc.Sales_Region__c != a.Sales_Region__c)
                                             {
                                                  a.Sales_Region__c= pAcc.Sales_Region__c;
                                                  accChanged = true;
                                             }
                                             if(pAcc.Region_Country__c!= a.Region_Country__c)
                                             {
                                                  a.Region_Country__c= pAcc.Region_Country__c;
                                                  accChanged = true;
                                             }
                                        }   
                                     if(accChanged)
                                       {  
                                           lstUpdateAccountIds.add(a.id);
                                           Customer_Category.add(a.Customer_Category__c);
                                           ownerId.add(a.ownerId);
                                           GEO.add(a.GEO__c);
                                           Sales_Area.add(a.Sales_Area__c);
                                           Sales_Region.add(a.Sales_Region__c);
                                           Region_Country.add(a.Region_Country__c);
                                       
                                       }
                                  }
                           }
                       
                       }   
                        try{
                         if(lstUpdateAccountIds.size() > 0)
                             AccountTeamsProcessor.updateAccounts(lstUpdateAccountIds, Customer_Category, ownerId, GEO, Sales_Area, Sales_Region,Region_Country);
                          }
                         catch(exception ex)
                           {
                           
                           }       
                         
                 }
                 if(commaccids.size() > 0 && parentEntIds.size() > 0)
                 {
                         List<accountTeamMember> lstAll = [Select a.UserId, a.TeamMemberRole, a.Id, a.AccountId, a.AccountAccessLevel From AccountTeamMember a where accountid in  : parentEntIds and a.account.recordtypeId =: recEnterpriseId AND a.User.IsActive = true order by accountid];
                          
                          SET<string> parentIds = new SET<string>{};
                          Map<string,string> mapparent = new map<string,string>{};
                          for(account acc: trigger.New) //COPY ACC TEAM MEMBERS
                          {
                              if(parentEntIds.contains(acc.parentid) )  //the parent should be of Enterprise Type
                                   {   mapparent.put(acc.id,acc.parentId);
                                       parentIds.add(acc.parentId);
                                   }    
                          }
                          if(lstAll.size() > 0 && mapparent.keySet().size() > 0 && mapparent.size() > 0)
                                 AccountTeamsProcessor.processTeams(parentIds,mapparent);        
                      }
                 
            } //END OF AFTER UPDATE
            else if(Trigger.isBefore)
            {
            
                 system.debug('IN BEFORE UPDATE >>>SS::');
                         
                 Set<id> parentEntIds = new Set<id>();
                 Set<id> accCommIds = new Set<id>();
                 
                 for(Integer i=0; i< trigger.new.size(); i++)
                     {
                         if(trigger.new[i].parentId != trigger.old[i].parentId && trigger.new[i].parentId != null && trigger.new[i].recordtypeId == recCommercialId)
                             {
                                parentEntIds.add(trigger.new[i].parentId);                 
                                accCommIds.add(trigger.new[i].id);    
                             }
                     }
                     system.debug('orig parents >>>>::' + parentEntIds.size());
                     if(parentEntIds.size() > 0)
                     {    
                     Map<ID, Account> m = new Map<ID, Account>([Select id, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c, Customer_Category__c, OwnerId from Account Where Id in : parentEntids and recordtypeid =: recenterpriseid]);
                     system.debug('changed parents >>>>::' + m.size());
                     
                     if(m.size() > 0) //IF ONE OR MORE PARENTS ARE OF ENTERPRISE RECORD TYPE)
                      {
                          List<Account> lstAll = new List<Account>();
                           
                          for(account a: trigger.New) //COPY ACC TYPE, OWNER, TERRITORY FIELDS
                          {
                           system.debug('inside loop::');
                    
                             if(a.recordtypeId == recCommercialId && accCommIds.contains(a.id))
                                {
                                      // Update the Account Type, Owner with values in parent
                                      // If the Parent account Region = NA or PS/CAN then the 4 territory (Region, Area, Territory and Country) fields also need to be copied down
                                        if(a.parentId != null && m.get(a.parentId) != null)
                                             {
                                                  Account pAcc = m.get(a.parentId);  
                                                  if(pAcc.Customer_Category__c != a.Customer_Category__c)
                                                     {
                                                          a.Customer_Category__c = pAcc.Customer_Category__c;
                                                     }
                                                  if(pAcc.ownerId != a.ownerId)
                                                     {
                                                          a.ownerId = pAcc.ownerId;
                                                     }
                                                  //sunji03 - FY19, PS/CAN GEO is added, add it to the condition.
                                                   if(pAcc.Geo__c == 'NA' || pAcc.Geo__c == 'PS/CAN')
                                                     {
                                                         if(pAcc.GEO__c!= a.GEO__c)
                                                         {
                                                              a.GEO__c= pAcc.GEO__c;
                                                         }
                                                         if(pAcc.Sales_Area__c!= a.Sales_Area__c)
                                                         {
                                                              a.Sales_Area__c= pAcc.Sales_Area__c;
                                                         }
                                                         if(pAcc.Sales_Region__c != a.Sales_Region__c)
                                                         {
                                                              a.Sales_Region__c= pAcc.Sales_Region__c;
                                                         }
                                                         if(pAcc.Region_Country__c!= a.Region_Country__c)
                                                         {
                                                              a.Region_Country__c= pAcc.Region_Country__c;
                                                         }
                                                    }   
                                                 
                                             }
                                }     
                          }
                          
                      }
                     
                     }
            
            }//END OF BEFORE UPDATE  
    }
    
  }