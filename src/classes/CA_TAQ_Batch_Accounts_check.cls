/** Global Class to check the missing Account Team Members for Account
* WORK IN PROGRESS............
**/
global class CA_TAQ_Batch_Accounts_check{
}

/*
global class CA_TAQ_Batch_Accounts_check implements Database.Batchable<sObject>{
    public String query;
    public String email;
    Id toUserId;
    Id fromUserId;

    global database.querylocator start(Database.BatchableContext BC){
    
        return Database.getQueryLocator(query);
    
    }

    public TAQ_Account__c getPMFKeys(TAQ_Account__c ta){
    
        Set<String> stpmfky=new Set<String>();
        Set<String> stPosids=new Set<String>();
        if(ta.Account_Owner_PMF_Key__c<>null){
                if(ta.Account_Owner_PMF_Key__c.length()==7)
                    stpmfky.add(ta.Account_Owner_PMF_Key__c.toUpperCase());
                else
                    stPosids.add(ta.Account_Owner_PMF_Key__c);  
            }

            if(ta.CSA_PMF_key__c<>null){
                if(ta.CSA_PMF_key__c.length()==7)
                    stpmfky.add(ta.CSA_PMF_key__c.toUpperCase());
                else
                    stPosids.add(ta.CSA_PMF_key__c);
            }
            
            if(ta.Sales_Director_PMF_Key__c<>null){
                if(ta.Sales_Director_PMF_Key__c.length()==7)
                    stpmfky.add(ta.Sales_Director_PMF_Key__c.toUpperCase());
                else
                    stPosids.add(ta.Sales_Director_PMF_Key__c);
                
            }
                 
        
            if(ta.SS_MF_PMFKey__c<>null){
                if(ta.SS_MF_PMFKey__c.length()==7)
                    stpmfky.add(ta.SS_MF_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.SS_MF_PMFKey__c);
            }
                
            
            if(ta.SS_PPM_PMFKey__c<>null){
                if(ta.SS_PPM_PMFKey__c.length()==7)
                    stpmfky.add(ta.SS_PPM_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.SS_PPM_PMFKey__c);
            }
        
            if(ta.SS_SEC_PMFKey__c<>null){
                if(ta.SS_SEC_PMFKey__c.length()==7)
                    stpmfky.add(ta.SS_SEC_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.SS_SEC_PMFKey__c);
            }
        
            if(ta.SS_SA_PMFKey__c<>null){
                if(ta.SS_SA_PMFKey__c.length()==7)
                    stpmfky.add(ta.SS_SA_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.SS_SA_PMFKey__c);
            }
        
            if(ta.SS_VSA_PMFKey__c<>null){
                if(ta.SS_VSA_PMFKey__c.length()==7)
                    stpmfky.add(ta.SS_VSA_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.SS_VSA_PMFKey__c);
            }
            
            if(ta.GPS_PMFKey__c<>null){
                if(ta.GPS_PMFKey__c.length()==7)
                    stpmfky.add(ta.GPS_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.GPS_PMFKey__c);
            }
                         
            if(ta.SAM_PMFKey__c<>null){
                if(ta.SAM_PMFKey__c.length()==7)
                    stpmfky.add(ta.SAM_PMFKey__c.toUpperCase());
                else
                    stPosids.add(ta.SAM_PMFKey__c);
            }
                
            List<User> aeses=new List<User>();
            /** Query the Manager pmf key for the corresponding position id form org
            *   and then query User object based on both pmfkey and manager pmf key
            ** /
            if(stPosids.size()>0)
                for(TAQ_Organization__c t:[select Position_Id__c,Manager_PMF_Key__c from TAQ_Organization__c where Position_Id__c in :stPosids]){ //and id ='a1A30000000oPtx']){
              
                    system.debug('POSITION ID ::::::'+t.Position_Id__c);
                    system.debug('MANAGER FOR THIS POSITION:::::'+t.Manager_PMF_Key__c); 
                    if(t.Position_Id__c==ta.Account_Owner_PMF_Key__c && t.Manager_PMF_Key__c<>null)  
                        ta.Account_Owner_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.Sales_Director_PMF_Key__c && t.Manager_PMF_Key__c<>null)  
                        ta.Sales_Director_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.GPS_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.GPS_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.CSA_PMF_key__c && t.Manager_PMF_Key__c<>null)  
                        ta.CSA_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.SS_PPM_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.SS_PPM_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.SS_MF_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.SS_MF_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.SAM_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.SAM_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.SS_VSA_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.SS_VSA_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.SS_SEC_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.SS_SEC_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    if(t.Position_Id__c==ta.SS_SA_PMFKey__c && t.Manager_PMF_Key__c<>null)  
                        ta.SS_SA_Manager_PMFKey__c=t.Manager_PMF_Key__c.toUpperCase();    
                    
                }
    
        return ta;
    }


    global void execute(Database.BatchableContext BC, List<sObject> scope){
    
        Map<Account,Set<String>> acctmap=new Map<Account,Set<String>>();
        
        for(sObject s : scope){

            Account a = (Account)s;
            List<AccountTeamMember> lstAtm=new List<AccountTeamMember>();
            List<TAQ_Account__c> lstTa=new List<TAQ_Account__c>();
            Set<String> stpmfky=new Set<String>();
            Set<String> stPosids=new Set<String>();
            Set<String> aeseKeys=new Set<String>();
            Set<Id> AllUsrids=new Set<Id>();
            Integer TeamCnt=0;
            set<String> aeseSet=new set<String>();
            Map<String,TAQ_Organization__c> MapTa=new Map<String,TAQ_Organization__c>();
            Map<String,User> MapUsr=new Map<String,User>();
            lstAtm.clear();
            lstTa.clear();
            
            lstAtm=a.AccountTeamMembers;
            lstTa=a.TAQAccounts__r;
            String StdAccPmfkey;
            String TAQAccPmfkey;
            Id TAQAccOwid;
            
            system.debug('DBG:Current Account Id executing..'+a.id);
            system.debug('DBG: No of TAQ Accounts..'+lstTa.size());
            system.debug('DBG: No to Std Acc team Mems..'+lstAtm.size());
            
            /** Get the pmf key in to corresponding sets for all pmfkeys entered
            *   If its a position id take it in stPosids set 
            *   If its a PMFKey take it in stpmfkey set 
            * //
            
            if(a.owner != null && a.owner.PMFKey__c != null && a.owner.PMFKey__c.trim() != '') StdAccPmfkey=a.owner.PMFKey__c.toUpperCase();
            
            
            if(lstTa[0].Account_Owner_PMF_Key__c<>null){
                if(lstTa[0].Account_Owner_PMF_Key__c.length()==7){
                    stpmfky.add(lstTa[0].Account_Owner_PMF_Key__c.toUpperCase());
                    TAQAccPmfkey=lstTa[0].Account_Owner_PMF_Key__c.toUpperCase();
                }
                else
                    stPosids.add(lstTa[0].Account_Owner_PMF_Key__c);  
            }

            if(lstTa[0].CSA_PMF_key__c<>null){
                if(lstTa[0].CSA_PMF_key__c.length()==7)
                    stpmfky.add(lstTa[0].CSA_PMF_key__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].CSA_PMF_key__c);
            }
            
            if(lstTa[0].Sales_Director_PMF_Key__c<>null){
                if(lstTa[0].Sales_Director_PMF_Key__c.length()==7)
                    stpmfky.add(lstTa[0].Sales_Director_PMF_Key__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].Sales_Director_PMF_Key__c);
                
            }
                 
        
            if(lstTa[0].SS_MF_PMFKey__c<>null){
                if(lstTa[0].SS_MF_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].SS_MF_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].SS_MF_PMFKey__c);
            }
                
            
            if(lstTa[0].SS_PPM_PMFKey__c<>null){
                if(lstTa[0].SS_PPM_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].SS_PPM_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].SS_PPM_PMFKey__c);
            }
        
            if(lstTa[0].SS_SEC_PMFKey__c<>null){
                if(lstTa[0].SS_SEC_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].SS_SEC_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].SS_SEC_PMFKey__c);
            }
        
            if(lstTa[0].SS_SA_PMFKey__c<>null){
                if(lstTa[0].SS_SA_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].SS_SA_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].SS_SA_PMFKey__c);
            }
        
            if(lstTa[0].SS_VSA_PMFKey__c<>null){
                if(lstTa[0].SS_VSA_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].SS_VSA_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].SS_VSA_PMFKey__c);
            }
            
            if(lstTa[0].GPS_PMFKey__c<>null){
                if(lstTa[0].GPS_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].GPS_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].GPS_PMFKey__c);
            }
                         
            if(lstTa[0].SAM_PMFKey__c<>null){
                if(lstTa[0].SAM_PMFKey__c.length()==7)
                    stpmfky.add(lstTa[0].SAM_PMFKey__c.toUpperCase());
                else
                    stPosids.add(lstTa[0].SAM_PMFKey__c);
            }
                
            List<User> aeses=new List<User>();
//           /** Query the Manager pmf key for the corresponding position id form org
//           *   and then query User object based on both pmfkey and manager pmf key
//            **
            if(stPosids.size()>0)
                for(TAQ_Organization__c t:[select Position_Id__c,Manager_PMF_Key__c from TAQ_Organization__c where Position_Id__c in :stPosids]){
              
                    if(t.Position_Id__c==lstTa[0].Account_Owner_PMF_Key__c)  
                        TAQAccPmfkey=t.Manager_PMF_Key__c.toUpperCase();    
                    
                    stpmfky.add(t.Manager_PMF_Key__c.toUpperCase());
                    MapTa.put(t.Position_Id__c,t);
                }
    
//            /** While Querying from user object add all the user ids
//            *   to a set called AllUsrids to compare with Std Account Team Members
//            **
            if(stpmfky.size()>0)
                for(User u:[select id,name,PMFKey__c,AE_SE_PMFKey__c from User where PMFKey__c in:stpmfky and isActive=true]){
                    if(TAQAccPmfkey==u.PMFKey__c.toUpperCase())
                        TAQAccOwid=u.id;
                        
                    MapUsr.put(u.PMFKey__c.toUpperCase(),u);
                    AllUsrids.add(u.id);
                }
            
    //        /** AE/SE checking -- For Account owner and all SS roles check whether
    //        *   they have AE/SE's and if they have take them in a set.
    //        *
            
        //    /** If its a pmf key take the AESE pmfkey directly else 
       //     *   if its a position id take it from manager if there is an AESE pmfkey
       //     *
            if(lstTa[0].Account_Owner_PMF_Key__c<>null && lstTa[0].Account_Owner_PMF_Key__c.length()==7 && MapUsr.containsKey(lstTa[0].Account_Owner_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(lstTa[0].Account_Owner_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(lstTa[0].Account_Owner_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            else if(lstTa[0].Account_Owner_PMF_Key__c<>null && lstTa[0].Account_Owner_PMF_Key__c.length()<>7 && MapTa.containsKey(lstTa[0].Account_Owner_PMF_Key__c) && MapUsr.containsKey(MapTa.get(lstTa[0].Account_Owner_PMF_Key__c).Manager_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(MapTa.get(lstTa[0].Account_Owner_PMF_Key__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(MapTa.get(lstTa[0].Account_Owner_PMF_Key__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            
            if(lstTa[0].SS_MF_PMFKey__c<>null && lstTa[0].SS_MF_PMFKey__c.length()==7 && MapUsr.containsKey(lstTa[0].SS_MF_PMFKey__c.toUpperCase())){
                if (MapUsr.get(lstTa[0].SS_MF_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(lstTa[0].SS_MF_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            else if(lstTa[0].SS_MF_PMFKey__c<>null && lstTa[0].SS_MF_PMFKey__c.length()<>7 && MapTa.containsKey(lstTa[0].SS_MF_PMFKey__c) && MapUsr.containsKey(MapTa.get(lstTa[0].SS_MF_PMFKey__c).Manager_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(MapTa.get(lstTa[0].SS_MF_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(MapTa.get(lstTa[0].SS_MF_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            
            if(lstTa[0].SS_SEC_PMFKey__c<>null && lstTa[0].SS_SEC_PMFKey__c.length()==7 && MapUsr.containsKey(lstTa[0].SS_SEC_PMFKey__c.toUpperCase())){
                if (MapUsr.get(lstTa[0].SS_SEC_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(lstTa[0].SS_SEC_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            else if(lstTa[0].SS_SEC_PMFKey__c<>null && lstTa[0].SS_SEC_PMFKey__c.length()<>7 && MapTa.containsKey(lstTa[0].SS_SEC_PMFKey__c) && MapUsr.containsKey(MapTa.get(lstTa[0].SS_SEC_PMFKey__c).Manager_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(MapTa.get(lstTa[0].SS_SEC_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(MapTa.get(lstTa[0].SS_SEC_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            
            if(lstTa[0].SS_PPM_PMFKey__c<>null && lstTa[0].SS_PPM_PMFKey__c.length()==7 && MapUsr.containsKey(lstTa[0].SS_PPM_PMFKey__c.toUpperCase())){
                if (MapUsr.get(lstTa[0].SS_PPM_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(lstTa[0].SS_PPM_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            else if(lstTa[0].SS_PPM_PMFKey__c<>null && lstTa[0].SS_PPM_PMFKey__c.length()<>7 && MapTa.containsKey(lstTa[0].SS_PPM_PMFKey__c) && MapUsr.containsKey(MapTa.get(lstTa[0].SS_PPM_PMFKey__c).Manager_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(MapTa.get(lstTa[0].SS_PPM_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(MapTa.get(lstTa[0].SS_PPM_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            
            if(lstTa[0].SS_SA_PMFKey__c<>null && lstTa[0].SS_SA_PMFKey__c.length()==7 && MapUsr.containsKey(lstTa[0].SS_SA_PMFKey__c.toUpperCase())){
                if (MapUsr.get(lstTa[0].SS_SA_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(lstTa[0].SS_SA_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            else if(lstTa[0].SS_SA_PMFKey__c<>null && lstTa[0].SS_SA_PMFKey__c.length()<>7 && MapTa.containsKey(lstTa[0].SS_SA_PMFKey__c) && MapUsr.containsKey(MapTa.get(lstTa[0].SS_SA_PMFKey__c).Manager_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(MapTa.get(lstTa[0].SS_SA_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(MapTa.get(lstTa[0].SS_SA_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            
            if(lstTa[0].SS_VSA_PMFKey__c<>null && lstTa[0].SS_VSA_PMFKey__c.length()==7 && MapUsr.containsKey(lstTa[0].SS_VSA_PMFKey__c.toUpperCase())){
                if (MapUsr.get(lstTa[0].SS_VSA_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(lstTa[0].SS_VSA_PMFKey__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            else if(lstTa[0].SS_VSA_PMFKey__c<>null && lstTa[0].SS_VSA_PMFKey__c.length()<>7 && MapTa.containsKey(lstTa[0].SS_VSA_PMFKey__c) && MapUsr.containsKey(MapTa.get(lstTa[0].SS_VSA_PMFKey__c).Manager_PMF_Key__c.toUpperCase())){
                if (MapUsr.get(MapTa.get(lstTa[0].SS_VSA_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c<>null) {
                    aeseKeys.add(MapUsr.get(MapTa.get(lstTa[0].SS_VSA_PMFKey__c).Manager_PMF_Key__c.toUpperCase()).AE_SE_PMFKey__c.toUpperCase());
                }
            }
            
            system.debug('AESES USER IDS ..'+aeseKeys);
            
       //     /** Next query the user object for the ids of all existing AESES
       //     *   And add it to the AllUsrids set.
       //     **
            List<User> aeseUsrs=[SELECT id from User WHERE PMFKey__c IN :aeseKeys and isActive=true];
            for(Integer k=0;k<aeseUsrs.size();k++)
                AllUsrids.add(aeseUsrs[k].id);
            
       //     /** Now the set AllUsrids have the complete list of userids
       //     *   including AE/SE's. This set, we will use to compare it with
       //     *   the Std Account Team members
            
            
            Integer cnt=0;       
            List<Id> lstUserids=new List<Id>();
            lstUserids.addAll(AllUsrids);
            
        //    /** If the Std Acc Team members size and AllUsrids set size 
        //    *   is different then directly call the corresponding methods 
        //    *   to do the Adjustment
            
            
         //   /** Else If the Std Acc Team members size and AllUsrids set size 
         //   *   is same then do a Member By Member comparision check to 
         //   *   cross verify both Std Acc team members and TAQ Acc Team members
         //   *   If any differences find then call the corresponding methods 
         //   *   to do the Adjustment
            
            system.debug('STD TEAM MEMBERS SIZE....'+lstAtm.size());
            system.debug('CALICULATED TEAM SIZE....'+lstUserids.size());
            system.debug('DBG:LIST OF USER IDS..'+lstUserids);
            system.debug('DBG:LIST OF ACC TEAM MEMBERS..'+lstAtm);
            
            if(lstAtm.size()<>lstUserids.size()){
                CA_TAQ_AddTeamMem objta=new CA_TAQ_AddTeamMem();
                objta.deleteMembers(lstTa[0], a);
                objta.addMembers(lstTa[0], a);
            }
            else if(lstAtm.size()==lstUserids.size()){
                
                for(integer l=0;l<lstUserids.size();l++){
                    for(integer m=0;m<lstAtm.size();m++){
                        if(lstUserids[l]==lstAtm[m].userid)
                            cnt++;
                    
                    }
                }
                system.debug('COUNT OF TEAM MEM CHECK....'+cnt);
                if(cnt<>lstUserids.size()){
                    CA_TAQ_AddTeamMem objta=new CA_TAQ_AddTeamMem();
                    CA_TAQ_AddTeamMem.isflag=true;
                    CA_TAQ_AddTeamMem.isflag2=true;
                    
                    objta.deleteMembers(lstTa[0], a);
                    objta.addMembers(lstTa[0], a);                
                }
            }
            
            system.debug('STD ACC pmf key..'+StdAccPmfkey);
            system.debug('TAQ ACC pmf key..'+TAQAccPmfkey);
            system.debug('TAQ Acc user id..'+TAQAccOwid);
            
            if(StdAccPmfkey<>TAQAccPmfkey && TAQAccOwid<>null){  
                TAQOrgAdmin.inFutureContext=true; 
                a.ownerid=TAQAccOwid;
                update a;
            }
          //  /** Query from the TAQ Account to find out if there are any split
          //  *   Accounts and for each and every split account call the AddTeamMembers
          //  *   method to add the split account team members to std Account.
          //  *
            
            system.debug('TAQ ACCOUNT ENTERPRISE ID:::'+lstTa[0].Enterprise_Id__c);
            if(lstTa[0].Enterprise_Id__c<>null){
                List<TAQ_Account__c> LstSplitTa=new List<TAQ_Account__c>();
                LstSplitTa=[Select Account_Owner_PMF_Key__c,CSA_PMF_key__c,
                               Sales_Director_PMF_Key__c,SS_MF_PMFKey__c,
                               Account_Owner_Manager_PMFKey__c,
                               Sales_Director_Manager_PMFKey__c, 
                               GPS_Manager_PMFKey__c,
                               CSA_Manager_PMFKey__c,
                               SS_PPM_Manager_PMFKey__c,
                               SS_MF_Manager_PMFKey__c,
                               SAM_Manager_PMFKey__c,
                               SS_VSA_Manager_PMFKey__c,
                               SS_SEC_Manager_PMFKey__c,
                               SS_SA_Manager_PMFKey__c,
                               Regional_Alliance_Director_PMF_Key__c,
                               SS_PPM_PMFKey__c,SS_SA_PMFKey__c,SS_SEC_PMFKey__c,
                               SS_VSA_PMFKey__c,GPS_PMFKey__c,
                               SAM_PMFKey__c from TAQ_Account__c where
                               Is_Primary_Account__c=false                                 
                               and (Approval_Status__c='Approved' or Approval_Status__c='Migrated') 
                               and Process_Step__c<>'Account Release' 
                               and Process_Step__c<>'Account Merge'
                               and Enterprise_Id__c=:lstTa[0].Enterprise_Id__c];//and enterprise_id__c='NA00029']; 
                
                for(integer t=0;t<LstSplitTa.size();t++){
                    TAQ_Account__c thisAcc=getPMFKeys(LstSplitTa[t]);
                    CA_TAQ_AddTeamMem.isflag=true;
                    CA_TAQ_AddTeamMem objta=new CA_TAQ_AddTeamMem();
                    objta.addMembers(thisAcc, a);  
                }               
                
            }
                           
        }
    }

//    /** Sending mail to the specified email id after finishing the batch job
    
    global void finish(Database.BatchableContext BC){
        
   //     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   //     mail.setToAddresses(new String[] {email});
    //    mail.setReplyTo('durgaprasad.ayinala@accenture.com');
     //   mail.setSenderDisplayName('Batch Processing');
     //   mail.setSubject('Batch Process Completed');

     //   mail.setPlainTextBody('Batch Process has completed');
      //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //
    }
}*/