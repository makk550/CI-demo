public with sharing class TAQ_AddTeamMember_Ext {
   
   
    public List<TAQ_Account_Team__c> accteamlist{get;set;} 
    public Id accid {get;set;}
    public Id delid {get;set;}
    public string err {get;set;}
    public boolean isnonPartner {get;set;}
    public List<TAQ_Account__c> taqAccList = new List<TAQ_Account__c>();//added by sunil
     public List<TAQ_Account__c> taqAccListFilter = new List<TAQ_Account__c>();//added by sunil
    
    
    public pagereference deletemem()
    {
        if(delid <> null)
           delete new taq_account_team__c(id=delid);
            
         return null;   
    }

    public TAQ_AddTeamMember_Ext(ApexPages.StandardController controller) 
    {
        
         //do not show other fileds otherthan Role & PMF Key for Partner & Other Record Types / GSP Account
        TAQ_Account_Team__c objTaTm = (TAQ_Account_Team__c)controller.getRecord();
        TAQ_Account__c taqacc = [Select id, RecordType.Name from TAQ_Account__c where id=:objTaTm.TAQ_Account__c limit 1];
        isnonPartner = (taqacc.RecordType.Name.contains('Partner') <> true ); 

        
       
        // end render part by Rao 
        
        
        TAQ_Account_Team__c tatm = (TAQ_Account_Team__c)controller.getRecord();
        if(tatm!=null)
        {
           accid = tatm.Taq_account__c;//[Select id, TAQ_Account__c from TAQ_Account_Team__c where id =: tatm.id].Taq_account__c;   
           accteamlist = [SELECT Id,Is_Account_Owner__c,Role__c,Partner_Role__c,PMFKey__c,Primary_Secondary__c,Percentage__c,Effective_Date__c from TAQ_Account_Team__c WHERE TAQ_Account__c=:accid ORDER BY CreatedDate ASC];
           if(accteamlist.size()==0)
           {
              accteamlist = new List<TAQ_Account_Team__c>();
              for(Integer i=0;i<3;i++)
              {
                accteamlist.add(new TAQ_Account_Team__c(TAQ_Account__c=accid));
              }
              
           }
        }
        taqAccList = [select Name,segment__c,RecordTypeId from TAQ_Account__c where id=:accid ];//added by sunil
        //for loop added by sunil
        for(TAQ_Account__c taq:taqAccList){
        //sunji03 - FY19 Account segment change
        //if(taq.Segment__c != Label.SegmentVal1 && taq.RecordTypeId=='01230000000cogU'){
        if(taq.Segment__c != Label.SegmentVal1 && taq.Segment__c != Label.SegmentVal4 && taq.RecordTypeId=='01230000000cogU'){
        taqAccListFilter.add(taq);//added by sunil
        
        
        }
        
        
        
        }
    }
    
    public void addMoreRows(){
        accteamlist.add(new TAQ_Account_Team__c(TAQ_Account__c=accid));
        accteamlist.add(new TAQ_Account_Team__c(TAQ_Account__c=accid));
        accteamlist.add(new TAQ_Account_Team__c(TAQ_Account__c=accid));
        
    }
    
    public void deleteRows()
    {
      if(accteamlist[accteamlist.size()-1].Id!=null)
      {
        accteamlist[accteamlist.size()-1].PMFKey__c='asdas01';
        accteamlist[accteamlist.size()-1].Effective_date__c=System.today();
        accteamlist.remove(accteamlist.size()-1);
      } 
        
    }
    
    public boolean saveteam()
    {
    try
     {  
       integer countowner =0;  
       set<string> s = new set<string>();
       integer vindex =0;
       List<taq_account_team__c> lsttatm = new List<taq_account_team__c>();
       for(taq_account_team__c tatm:accteamlist)
       {
           if(tatm.role__c <> null ||tatm.Primary_Secondary__c != null || tatm.Is_Account_Owner__c !=false || tatm.Percentage__c  <> null || tatm.PMFKey__c  <> null ||tatm.Effective_Date__c  <> null)
           {
               lsttatm.add(tatm);
           }
       }

        decimal primary_sum = 0;
        integer primary_count = 0;
        


       for(TAQ_Account_Team__c t:lsttatm)
       {
           if(t.Is_Account_Owner__c)
               countowner ++;
           if(t.pmfkey__c == null)
           {
                Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR,'Please enter PMFkey'));
                return false;
           }
               
           if(t.pmfkey__c <> null && s.contains(t.pmfkey__c.toUpperCase()) ) // && (isnonPartner) 
           {
                Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR,'Duplicate PMFkey ('+t.pmfkey__c + ') Values Not Allowed'));
                return false;
           }
           if(t.pmfkey__c <> null)
               s.add(t.pmfkey__c.toUpperCase());
               
           if(isnonPartner && t.Primary_Secondary__c == 'Primary') 
           {
               primary_count ++;
               if(t.Percentage__c <> null)
                   primary_sum += t.Percentage__c;   
           }    
       }
    /*   if(countowner == 0 &&  isnonPartner && taqAccListFilter.size()==0)// added by sunil
       {
           Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR,'Please select an account owner!'));
           return false;
       }
       */
            
       
  
       
       if(primary_sum <> 100 && primary_count > 0 && isnonPartner )
       {
           Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR,'Please ensure that the sum of Primary Percentage is 100!'));
           return false;
       }   
       
       if(countowner > 1 && taqAccListFilter.size()==0)// added by sunil
       {
           Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR,'Please select only one account owner!'));
           return false;
       }
        if(lsttatm.size() > 0)
            upsert lsttatm;           
        else
            return false;    
     }
     catch(DMLexception e)
     {
        // Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR,e.getDmlMessage()));
        for (Integer i = 0; i < e.getNumDml(); i++) {
               Apexpages.addMessage(new ApexPages.Message(APEXPAGES.SEVERITY.ERROR, e.getDmlMessage(i)));
           }
        return false;
     }  
     return true;
     }
    
    
    public Pagereference  saveRows()
    {
      if(saveteam())
      {
      
       TAQ_Account__c t= [Select Approval_Status__c FROM TAQ_Account__c where id=:accid];
       t.Approval_Status__c = 'Saved - Not Approved';
       
       update t;
       
            return new PageReference('/'+accid);
      }
      
      return null;
    }
    
    public Pagereference saveSubmitRows()
    {
     if(saveteam() == false)
         return null;
     TAQ_Account__c t= [Select Process_Step__c, Approval_Process_Status__c, Approval_Status__c, View_Acc_Record__c FROM TAQ_Account__c where id=:accid];
     if(t.Process_Step__c.contains('Add') || t.Process_step__c.contains('Update'))
     {
         if(t.Process_Step__c.contains('Add') && t.View_Acc_Record__c <> null)
         {
            t.Process_Step__c = 'Account Update'; 
         }
         
         t.Approval_Process_Status__c = 'Send For Approval';
         
         Update t;
         
     }
     return new PageReference('/'+accid);
            
    }
    
    public PageReference goBack(){
        return new PageReference('/'+accid);
    }
   
   @isTest(SeeAllData=true)
     static void test_AddteamMember(){
        
        TAQ_Account__c newacc=new TAQ_Account__c();
        newacc.name='test acc';
        newacc.Enterprise_Account_Name__c='test acc name';
        newacc.Reseller_ID__c='test id';
        newacc.Reseller_Name__c='test res';
        newacc.Region__c='EMEA';
        newacc.Area__c='testa';
        newacc.Territory__c='testt';
        newacc.Country__c='testc';
        newacc.Account_Type__c='test type';
        newacc.Industry_Vertical__c='test ind';
        newacc.Stock_Ticker__c='test tick';
        newacc.Comments__c='testcom';
        newacc.ownerid=userinfo.getuserid();    
        newacc.Sell_To_Education__c = 100;
        newacc.Sell_To_Mainframe_Capacity__c = 100;
        newacc.Sell_To_Mainframe_Time__c = 100;
        newacc.Sell_To_Product__c = 100;
        newacc.Sell_To_Services__c = 100;
        
        
        newacc.Enterprise_Id__c='EA0520';
        insert newacc;
        
           TAQ_Account_Team__c t = new TAQ_Account_Team__c();
        t.Is_Account_Owner__c = true;
        t.Percentage__c = 22;
        t.PMFKey__c = 'tadkr01';
        Date d1 = System.today();
        t.Effective_Date__c = d1.toStartOfMonth();
        t.TAQ_Account__c = newacc.Id;
        t.role__c = 'asd';
        t.primary_secondary__c = 'secondary';
        
        insert t;
        newacc.Approval_Process_Status__c='Approved';
        try{
        update newacc;               
        ApexPages.StandardController c=new ApexPages.StandardController(t);
        TAQ_AddTeamMember_Ext tstovr=new TAQ_AddTeamMember_Ext(c); 
        
        tstovr.addMoreRows();
        tstovr.deleteRows();
        tstovr.addMoreRows();
        
        tstovr.accteamlist[0].Effective_Date__c = d1.toStartOfMonth();
         tstovr.accteamlist[0].Is_Account_Owner__c = false;
          tstovr.accteamlist[0].PMFKey__c = 'anssa01';
          tstovr.accteamlist[0].percentage__c = 21;
          tstovr.saveRows();
           tstovr.addMoreRows();
            tstovr.accteamlist[0].Effective_Date__c = d1.toStartOfMonth();
         tstovr.accteamlist[0].Is_Account_Owner__c = false;
          tstovr.accteamlist[0].PMFKey__c = 'morle04';
          tstovr.accteamlist[0].percentage__c = 21;
          tstovr.saveSubmitRows();
           tstovr.addMoreRows();
           tstovr.accteamlist[0].Effective_Date__c = d1.toStartOfMonth();
         tstovr.accteamlist[0].Is_Account_Owner__c = true;
          tstovr.accteamlist[0].PMFKey__c = 'danjo10';
          tstovr.accteamlist[0].percentage__c = 21;
            tstovr.accteamlist[1].Effective_Date__c = d1.toStartOfMonth();
         tstovr.accteamlist[1].Is_Account_Owner__c = false;
          tstovr.accteamlist[1].PMFKey__c = 'danva01';
          tstovr.accteamlist[1].percentage__c = 21;
          tstovr.saveteam();
          tstovr.delid = t.Id;
          tstovr.deletemem();
           tstovr.addMoreRows();
         
          tstovr.accteamlist[0].Effective_Date__c = d1.toStartOfMonth();
          tstovr.accteamlist[0].Is_Account_Owner__c = true;
          tstovr.accteamlist[0].PMFKey__c = 'danjo10';
          tstovr.accteamlist[0].percentage__c = 21;
       
          tstovr.accteamlist[1].Effective_Date__c = d1.toStartOfMonth();
          tstovr.accteamlist[1].Is_Account_Owner__c = false;
          tstovr.accteamlist[1].PMFKey__c = 'danva01';
          tstovr.accteamlist[1].percentage__c = 21;
          tstovr.saveteam();        
          tstovr.deleterows();
          
           tstovr.goBack();
         }
          catch(Exception e){
            System.debug('Exception' + e);
         }  
      
    }
   
   
}