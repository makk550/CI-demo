public class AccountTeamsProcessor {

         @future
         public static void updateOpportunities(List<string> lstOppIds, map<string,string> mapOppOwner)
         {
             List<opportunity> lstOpp = new List<opportunity>();
             for(string oppid:lstOppIds)
                 lstOpp.add(new Opportunity(id=oppid, ownerId=mapOppOwner.get(oppid)));
              update   lstOpp;
         
         }

         @future
         public static void updateAccounts(List<string> accids, List<string> Customer_Category, List<string> ownerId, List<string> GEO, List<string> Sales_Area, List<string> Sales_Region,List<string> Region_Country)
         {
                     List<account> accUpdate = new List<account>();
                     integer i=0;
                     for(string accid:accids)
                     {
                         accUpdate.add(new account(id= accid,Customer_Category__c = Customer_Category[i],  ownerId = ownerId[i], GEO__c = geo[i], Sales_Area__c = Sales_area[i], Sales_Region__c = sales_region[i],Region_Country__c = region_country[i])); 
                         i++;
                     }
                     
                     update accUpdate;
         
         }
         
            
         @future
         public static void processTeams(Set<String> parentIds, Map<string,string> MapParent) 
         {
                          Id vId = null;
                          List<accountTeamMember> lstAll = [Select a.UserId, a.TeamMemberRole, a.Id, a.AccountId, a.AccountAccessLevel From AccountTeamMember a where accountid in  : parentIds AND a.user.IsActive = true  order by accountid];
                          Map<id, List<AccountTeamMember>> mATM = new map<id, list<AccountTeamMember>>{};
                          List<accountTeamMember> lsttemp = new List<accountTeamMember>();
                          For(accountTeamMember tr: lstAll) //MAPPING THE ACCOUNT TEAM MEMBERS WITH THE ACC ID
                            {
                                if(vId != tr.accountid && vId != null)
                                  {
                                        mATM.put(vId, lsttemp);
                                        lsttemp = new  List<accountTeamMember>();
                                  }  
                                  lsttemp.add(tr);
                                  vId = tr.accountid;
                            }
                          If(lsttemp.size() > 0)
                                mATM.put(vId, lsttemp);
                          Integer i=0;
                          lstAll = new List<accountTeamMember>();   //Refresh List
                          lsttemp = new List<accountTeamMember>();  //Refresh List
                          
                          For(string accid:  MapParent.keySet())    //COPY ACC TEAM MEMBERS
                          {
                              string parentid = MapParent.get(accid);
                              if(parentId != null)
                              {
                              lstTemp = mATM.get(parentId);
                              if(lstTemp !=null && lstTemp.size() >0)
                                  for(AccountTeamMember a : lstTemp)
                                      {
                                         lstAll.add( new AccountTeamMember(UserId = a.UserId,TeamMemberRole = a.TeamMemberRole, AccountId =accId));
                                      }
                              }        
                          }
                         if(lstAll.size() > 0)
                             insert lstAll;
         }        
         
         @istest
         public static void testThis()
         {
            //Profile p = [SELECT Id FROM profile WHERE name='Standard User' LIMIT 1];
            User user = [Select Id from User u where u.IsActive = true and UserType = 'Standard' and User.Profile.Name = '1.0 CA Sys Admin Commit & PR' LIMIT 1];

             //RecordType[] recacc = [select Id from Recordtype where IsActive=true and SObjectType='Account' and Name in ('Account Team Covered Account')]; //Commented THAAN04_PRM5.5Release
             //account acc = new account(name='test', RecordTypeId = recacc[0].Id, OwnerId = user.Id);
             
             //Added this to get Reseller/Distributor Account record type ID as Reseller__c Account can be only of this type
             account acc = new account(name='test', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Reseller/Distributor Account').getRecordTypeId(),OwnerId = user.Id);
             insert acc;
             //account acc = [Select id,Customer_Category__c, ownerId, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c from account where RecordTypeId=:recacc[0].Id limit 1]; 
             
             account smbacc = new account(name='test', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SMB').getRecordTypeId(),BillingStreet = 'Arlington', BillingCountry = 'US', BillingCity = 'VA');
             insert smbacc;

             
             if(acc  != null)
                 AccountTeamsProcessor.updateAccounts(new List<string>{acc.Id}, new List<string>{acc.Customer_Category__C}, new List<string>{acc.ownerId}, new List<string>{acc.GEO__c}, new List<string>{acc.Sales_Area__c}, new List<string>{acc.Sales_Region__c},new List<string>{acc.Region_Country__c});
             List<string> lstOppIds= new List<string>();
             Map<string,string> mapOppOwner = new Map<string,string>(); 
            
            Id recId_opp = [Select id from Recordtype where name like '%new opp%' and SobjectType ='Opportunity'].Id;
            Opportunity opp = new Opportunity(recordtypeid=recId_opp, name='test Opp', StageName ='10%- Initial Request',closedate = Date.today().addDays(30), amount=100);
            opp.AccountId = smbacc.Id;
            opp.Reseller__c= acc.Id;
            opp.OwnerId = user.Id;
            insert opp; 
             //Opportunity opp = [Select id, accountId, account.ownerid from opportunity where  accountId != null and account.RecordTypeId=:recacc[0].Id limit 1 ];
             
             if(opp !=null)
             {
                User usr = [Select id from user where isactive = true and UserType = 'Standard' and User.Profile.Name = '1.0 CA Sys Admin Commit & PR' and id <> : opp.account.ownerId limit 1];
                Account acc1 = [select id, ownerId from account where id =:   opp.AccountId];
                acc1.ownerid = usr.id;
                update acc1;
                lstOppIds.add(opp.id);
                mapOppOwner.put( opp.id, usr.id);
                AccountTeamsProcessor.updateOpportunities(lstOppIds, mapOppOwner);  
              }
              
              Set<String> parentIds = new Set<String>();
              Map<string,string> mapParent = new Map<string,string>();
              List<AccountTeamMember> teamMembers = [Select Id, AccountId from AccountTeamMember LIMIT 5];
              for(AccountTeamMember tempATM : teamMembers) {
                parentIds.add(tempATM.AccountId);
                mapParent.put(tempATM.AccountId,tempATM.Id);
              }
              AccountTeamsProcessor.processTeams(parentIds, mapParent);  
        }        
}