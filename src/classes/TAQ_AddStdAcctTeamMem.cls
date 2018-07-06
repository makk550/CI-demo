public class TAQ_AddStdAcctTeamMem {

    public void AddAccountTeam(List<TAQ_Account__c> taqAccRec,List<TAQ_Account_Team__c> tatm)
    {
        
        //Set<Id> TAQAcctIds = new Set<Id>();
        Set<Id> TAQAcctIds = (new Map<Id,TAQ_Account__c>(taqAccRec)).keySet();
        /*for(TAQ_Account_Team__c t: tatm)
        {
            TAQAcctIds.add(t.TAQ_Account__c);
        }*/
       //  List<TAQ_Account__c> taqAccRec = [SELECT View_Acc_Record__c from TAQ_Account__c where Id in: TAQAcctIds];
        
        Map<TAQ_Account_Team__c,Id>  TATvsTA = new Map<TAQ_Account_team__c,Id>();
        for(TAQ_Account_Team__c at:tatm)
        {
           TATvsTA.put(at,at.TAQ_Account__c);
        }
        
        Set<Id> StdAcctIds = new Set<Id>();
        Map<TAQ_Account__c,Id>  TAvsACC = new Map<TAQ_Account__c,Id>();
        List<Account> a1 = new List<account>();//=[select id from Account where id in:StdAcctIds];
        for(TAQ_Account__c t: taqAccRec){
         if(t.View_Acc_Record__c!=null){
            StdAcctIds.add(t.View_Acc_Record__c);
            a1.add(new account(id = t.View_Acc_Record__c));
            TAvsACC.put(t,t.View_Acc_Record__c);
         }   
        }
         
         
         /*for(Id aid:StdAcctIds) 
             a1.add(new account(id =aid));
             */

         if(a1.size()>0)
         {
            deleteMembers(a1);
            
            addMembers(TATvsTA,TAvsACC);
         }    
    }
    
  //  public void addMembers(TAQ_Account_Team__c ta,Account a){
    public void addMembers(Map<TAQ_Account_Team__c,Id> tat, Map<TAQ_Account__c,Id> ta){
        List<AccountTeamMember> actlist=new List<AccountTeamMember>();
        List<String> aeseKeys = new List<String>();
        Set<String> userkeyset=new Set<String>();
        Set<String> stpmfkey=new set<String>();
        Set<Id> userIDs = new Set<Id>();
        Set<Id> stUsrids=new set<Id>();
        
        
        for(TAQ_Account_Team__c t: tat.keySet()){
            if(t.PMFKey__c != null && t.PMFKey__c.length()==7)
                 stpmfkey.add(t.PMFKey__c.toUpperCase());
            else
                 userIDs.add(t.User__c);
        }
        
        
   ///     if(ta.PMFKey__c != null && ta.PMFKey__c.length()==7)
   ///         stpmfkey.add(ta.PMFKey__c.toUpperCase());
            
         Map<String,User> userMap = new Map<String,User>();
         Map<String,User> userIDMap = new Map<String,User>();
         
          /** Loop through the query and insert values in to a map **/
          for(User u:[SELECT PMFKey__c,id,AE_SE_PMFKey__c from User WHERE (PMFKey__c in :stpmfkey OR Id in: userIDs) and isActive=true ]) {
              userMap.put(u.PMFKey__c.toUpperCase(),u);
              userIDMap.put(u.Id,u);
              stUsrids.add(u.id);    
          }
       
         userkeyset=userMap.keyset();    
       for(TAQ_Account_Team__c t: tat.keySet()){  
         if(t.PMFKey__c<>null && userkeyset.contains(t.PMFKey__c.toUpperCase())){
            AccountTeamMember Teammemberad=new AccountTeamMember();
         //   Teammemberad.AccountId=a.id;
         TAQ_Account__c compRec = new TAQ_Account__c();
         for(TAQ_Account__c eachAcc: ta.keySet()){
            if(eachAcc.Id==t.TAQ_Account__c){
                compRec = eachAcc;
            }
            
         }
         
         
            Teammemberad.AccountId = ta.get(compRec); 
            Teammemberad.UserId=userMap.get(t.PMFKey__c.toUpperCase()).id;
            Teammemberad.TeamMemberRole = t.TAQ_Role__c;
            actlist.add(Teammemberad);
        }
        else if(t.User__c!= null && stUsrids.contains(t.User__c)){
             AccountTeamMember Teammemberad=new AccountTeamMember();
          TAQ_Account__c compRec = new TAQ_Account__c();
         
         for(TAQ_Account__c eachAcc: ta.keySet()){
            if(eachAcc.Id==t.TAQ_Account__c){
                compRec = eachAcc;
            }
            
         }
          Teammemberad.AccountId = ta.get(compRec);
          Teammemberad.UserId=userIDMap.get(t.User__c).id;
          Teammemberad.TeamMemberRole = t.TAQ_Role__c;
            actlist.add(Teammemberad);
        }
      }
         system.debug('**********actlist*************' + actlist);
        if(actlist.size()>0)
                insert actlist;//insert account team members
         /** Account Sharing Code **/ 
            /**start by yedra01 coding**/
          Map<id,set<id>> accountownermap=new map<id,set<id>>();
           set<id> accids=new set<id>();
        for(Integer newcnt=0;newcnt<actlist.size();newcnt++)
         {
            accids.add(actlist[newcnt].Accountid);            
         }
         for(Accountshare as1:[select accountid,userorgroupid from Accountshare where id in:accids ])
         {
             if(accountownermap.get(as1.accountid)!=null)
             {
             set<id> tempid=new set<id>();
             tempid=accountownermap.get(as1.accountid);
             tempid.add(as1.userorgroupid);
             accountownermap.put(as1.accountid,tempid);
             }
             else
             {
             set<id> tempid=new set<id>();             
             tempid.add(as1.userorgroupid);
             accountownermap.put(as1.accountid,tempid);
             }
         }
         system.debug('Radhika'+accountownermap+'@'+actlist+'#'+accids);
         /**end by yedra01 coding**/
          List<AccountShare> newShare = new List<AccountShare>();   
          Set<AccountShare> tmSet=new Set<AccountShare>();
             
         for(Integer newcnt=0;newcnt<actlist.size();newcnt++)
         {
             
             if(accountownermap.size()>0)//added by yedra01
             {
             if(accountownermap.get(actlist[newcnt].Accountid)!=null)//added by yedra01
             {
             if(!accountownermap.get(actlist[newcnt].Accountid).contains(actlist[newcnt].UserId))//added by yedra01
             {
              AccountShare ash=new AccountShare();
                ash.UserOrGroupId=actlist[newcnt].UserId;
                ash.AccountId=actlist[newcnt].Accountid;
                ash.AccountAccessLevel='Edit';
                ash.OpportunityAccessLevel='Read';
                    
                if(!tmSet.contains(ash)){
                  newShare.add(ash);    
                  tmSet.addAll(newShare);
                }   
              }
              }              
              else//added by yedra01
              {
                    AccountShare ash=new AccountShare();
                ash.UserOrGroupId=actlist[newcnt].UserId;
                ash.AccountId=actlist[newcnt].Accountid;
                ash.AccountAccessLevel='Edit';
                ash.OpportunityAccessLevel='Read';
                    
                if(!tmSet.contains(ash)){
                  newShare.add(ash);    
                  tmSet.addAll(newShare);
                }   
              }  
              }
              else//added by yedra01
              {
                   AccountShare ash=new AccountShare();
                ash.UserOrGroupId=actlist[newcnt].UserId;
                ash.AccountId=actlist[newcnt].Accountid;
                ash.AccountAccessLevel='Edit';
                ash.OpportunityAccessLevel='Read';
                    
                if(!tmSet.contains(ash)){
                  newShare.add(ash);    
                  tmSet.addAll(newShare);
                }   
              }               
         }  
         
          Database.SaveResult[] lsr;
            if(newShare.size()>0)
                lsr = Database.insert(newShare,false);
            
            if(lsr <> null)
                for(Database.SaveResult sr : lsr){
                    if(!sr.isSuccess()){
                    // Get the first save result error.
                    Database.Error err = sr.getErrors()[0];
                    system.debug('___Exception-insert failed with message: '+err.getMessage()+ 'for '+sr);
                    }
            }      
        
    }
    
    public void deleteMembers(List<Account> a){
        /*List<Id> accId = new List<id>();
        for(Account acc:a){
            accid.add(acc.Id);
        }*/
        
          Set<Id> accId = (new Map<Id,Account>(a)).keySet();
        
        List<AccountTeamMember> lteam = [select AccountId,UserId,TeamMemberRole from AccountTeamMember where AccountId in: accId and TeamMemberRole like 'TAQ-%'];
        delete lteam;
    }
   
   @istest
   static void testMeth(){
            Account acc1 = new Account();
            acc1.Name = 'idc test acc';
            acc1.BillingState = 'NY';
            acc1.BillingStreet='Arlington';
            acc1.BillingCity='NY';
            acc1.BillingCountry='US';
            insert acc1;
            Account acc2 = new Account();
            acc2.Name = 'idc test acc2';
            acc2.BillingState = 'NY';
            acc2.BillingStreet='Arlington';
            acc2.BillingCity='NY';
            acc2.BillingCountry='US';
            insert acc2;
           TAQ_Account__c newacc5=new TAQ_Account__c();
            
            newacc5.name='test acc';
            newacc5.View_Acc_Record__c=acc1.id;
            newacc5.Enterprise_Id__c='EA0520';
            newacc5.Enterprise_Account_Name__c='idc test acc';
          
            newacc5.Region__c='EMEA';
            newacc5.Area__c='testa';
            newacc5.Territory__c='testt';
            newacc5.Country__c='testc';
            newacc5.Account_Type__c='test type';
            newacc5.Industry_Vertical__c='test ind';
            newacc5.Stock_Ticker__c='test tick';
            newacc5.Comments__c='testcom';
            newacc5.Area_for_Data_Load__c='testa';
            newacc5.Territory_For_Data_Load__c='nordics';
            newacc5.Country_for_Data_Load__c='United States';
            newacc5.Approval_Process_Status__c='Migrated';
            newacc5.Sell_To_Education__c = 100;
            newacc5.Sell_To_Mainframe_Capacity__c = 100;
            newacc5.Sell_To_Mainframe_Time__c = 100;
            newacc5.Sell_To_Product__c = 100;
            newacc5.Sell_To_Services__c = 100;
                     
            insert newacc5;
            TAQ_Account__c newacc6=new TAQ_Account__c();
           
            newacc6.name='test acc6';
            newacc6.View_Acc_Record__c=acc2.id;
            newacc6.Enterprise_Id__c='EA0520';
            newacc6.Enterprise_Account_Name__c='idc test acc';
          
            newacc6.Region__c='EMEA';
            newacc6.Area__c='testa';
            newacc6.Territory__c='testt';
            newacc6.Country__c='testc';
            newacc6.Account_Type__c='test type';
            newacc6.Industry_Vertical__c='test ind';
            newacc6.Stock_Ticker__c='test tick';
            newacc6.Comments__c='testcom';
            newacc6.Area_for_Data_Load__c='testa';
            newacc6.Territory_For_Data_Load__c='nordics';
            newacc6.Country_for_Data_Load__c='United States';
            newacc6.Approval_Process_Status__c='Migrated';
            newacc6.Sell_To_Education__c = 100;
            newacc6.Sell_To_Mainframe_Capacity__c = 100;
            newacc6.Sell_To_Mainframe_Time__c = 100;
            newacc6.Sell_To_Product__c = 100;
            newacc6.Sell_To_Services__c = 100;
                   
            insert newacc6;
      List<TAQ_Account__c> taqAccs = [SELECT Id,View_Acc_Record__c from TAQ_Account__c  LIMIT 2];
      TAQ_Account_Team__c tat1 = new TAQ_Account_Team__c();
        tat1.Is_Account_Owner__c = true;
        tat1.Role__c = 'MF SS';
        tat1.PMFKey__c = 'VINPA01';
        tat1.TAQ_Account__c = taqAccs[0].Id;
        tat1.Effective_Date__c = system.today().tostartofmonth();
        tat1.Primary_Secondary__c = 'Secondary';
        tat1.Percentage__c = 100;
        insert tat1;
        List<TAQ_Account_Team__c> actL = new List<TAQ_Account_team__c>();
        actL.add(tat1);
        
        TAQ_AddStdAcctTeamMem obj = new TAQ_AddStdAcctTeamMem();
        obj.AddAccountTeam(taqAccs,actL);
   }
   
}