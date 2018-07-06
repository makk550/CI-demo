trigger Lead_Share on Lead (after insert, after update,before insert,before update) {
    
    List<LeadShare> leadShareLst =new List<LeadShare>();
    Set<String> rtmPMF =new Set<String>();  
    Map<ID,Lead> leadMap = new Map<ID,Lead> ();
    Map<String,String> userMap = new Map<String,String> ();
    
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('CA Indirect Lead');
    Id recIndirectLeadId = rec.RecordType_Id__c; // record type id for CA Indirect Lead

    //Declaration begin - CA POP
    Id CAGlobalLeadRecTypeId;
    List<Lead> lstCAPOPLeads = new List<Lead>();
    //set<Id> partnerIDs = new set<Id>();
    set<Id> partnerLeadChampionIDs = new set<Id>();
    set<Id> camapignIDs = new set<Id>();
    set<Id> partneraccIDs = new set<Id>();
       
    map <Id,User> leadPartnerUser = new map<id,User>();
    map <Id,Campaign> leadPartnerCamapaign = new map<id,Campaign>();
    map <Id,Account> leadPartnerAccount = new map<id,Account>();
    //Declaration end - CA POP
    
    RecordTypes_Setting__c rec1 = RecordTypes_Setting__c.getValues('CA Global Lead');
    if(rec1 <> null)
        CAGlobalLeadRecTypeId = rec1.RecordType_Id__c; // record type id for CA Global Lead to assign CA POP Leads
    system.debug('out Side ISBeforeInsert Trigger');
    //To process only CA POP leads before insert and before update
        system.debug('In Side ISBeforeInsert Trigger');
    
    if(Trigger.isbefore && Trigger.isupdate) {
        try{    
            for(Integer s=0; s<Trigger.size; s++){
                system.debug(Trigger.old[s]+' Trigger Old Vs New Values for CAPOP'+ Trigger.new[s]);
                if(Trigger.new[s].LeadSource == 'CA POP'){
                    lstCAPOPLeads.add(Trigger.new[s]);
                    //if(Trigger.new[s].PartnerUser_ID__c <> '' && Trigger.new[s].PartnerUser_ID__c <> null && Trigger.new[s].PartnerUser_ID__c <> Trigger.old[s].PartnerUser_ID__c)
                        //partnerIDs.add(Trigger.new[s].PartnerUser_ID__c);//all CA POP Partner IDs
                    if(Trigger.new[s].Campaign_ID__c <> '' && Trigger.new[s].Campaign_ID__c <> null)
                        if(Trigger.old[s].CA_Campaign_Id__c == null || Trigger.new[s].CA_Campaign_Id__c <> Trigger.old[s].CA_Campaign_Id__c)
                            camapignIDs.add(Trigger.new[s].Campaign_ID__c);//all CA POP Partner IDs
                    if(Trigger.new[s].PartnerAccount_ID__c <> '' && Trigger.new[s].PartnerAccount_ID__c <> null)
                        if(Trigger.old[s].PartnerAccount__c == null || Trigger.new[s].PartnerAccount__c <> Trigger.old[s].PartnerAccount__c)
                            partnerAccIDs.add(Trigger.new[s].PartnerAccount_ID__c);//all CA POP PartnerAccount IDs 
                }
            }
            if(partnerAccIDs <> null){  
                for(Account acc:[select id, GEO__c, Sales_Area__c, Sales_Region__c, Region_Country__c, Country_Picklist__c,Lead_Champion__c from Account where id = : partnerAccIDs limit : limits.getLimitQueryRows()])
                    if(!leadPartnerAccount.containskey(acc.id)) {
                        leadPartnerAccount.put(acc.id,acc);
                        partnerLeadChampionIDs.add(acc.Lead_Champion__c);
                    }
                        System.debug('____^^^^^^'+partnerLeadChampionIDs);
            }
            
            //Get LeadChampion User from Partner Account
            if(partnerLeadChampionIDs <> null){ 
                for(User usr:[select id, name,IsActive,ContactID from User where id =: partnerLeadChampionIDs and IsActive = true limit : limits.getLimitQueryRows()])
                    if(!leadPartnerUser.containskey(usr.id))
                        leadPartnerUser.put(usr.id,usr);
            }
            //Commented to assign Owner as LeadChampion Instead Partner User from CA POP
            /*if(partnerIDs <> null){ 
                for(User usr:[select id, name,IsActive,ContactID from User where ContactID =: partnerIDs and IsActive = true limit : limits.getLimitQueryRows()])
                    if(!leadPartnerUser.containskey(usr.ContactID))
                        leadPartnerUser.put(usr.ContactID,usr);
            }*/
    
            if(camapignIDs <> null){    
                for(Campaign camp: [select Primary_CSU__c, Primary_Driver__c from Campaign where id =: camapignIDs limit : limits.getLimitQueryRows()])
                    if(!leadPartnerCamapaign.containskey(camp.id))
                        leadPartnerCamapaign.put(camp.id,camp);
            }
            
            //Assign lead information for CAPOP leads
            if(lstCAPOPLeads <> null){
                //Get CAPOP Queue ID of Lead Object
                ID CAPOPQueueId;
                ID UnAssignedQueueId;
                List<QueueSobject> CAPOPQueueList = [Select QueueId, Queue.Name from QueueSobject where SobjectType = 'Lead' AND (Queue.Name = 'Lead_CAPOP' OR Queue.Name = 'Unassigned Leads') limit : limits.getLimitQueryRows()];
                //QueueSobject UnAssignedQueueList = [Select QueueId from QueueSobject where SobjectType = 'Lead' AND  limit : limits.getLimitQueryRows()];
                if(CAPOPQueueList.size() > 0) {
                    if(CAPOPQueueList[0].Queue.Name == 'Lead_CAPOP')
                        CAPOPQueueId = CAPOPQueueList[0].QueueId;
                    else if(CAPOPQueueList[1].Queue.Name == 'Unassigned Leads') 
                        UnAssignedQueueId = CAPOPQueueList[1].QueueId;
                }
                for(Lead leadrec:lstCAPOPLeads){
                    //Assign CA Globa Lead as record type
                    leadRec.RecordTypeId = CAGlobalLeadRecTypeId;
                    
                    //assign Geo, Operating Area, Sales Region, Territory and Country values of Partner to associated Lead  
                    if(leadPartnerAccount.get(leadrec.PartnerAccount_ID__c) <> null && (leadRec.PartnerAccount_ID__c <> '' && leadRec.PartnerAccount_ID__c <> null)){
                        leadRec.PartnerAccount__c = leadrec.PartnerAccount_ID__c;
                        leadRec.Reseller__c = leadrec.PartnerAccount_ID__c;
                        leadRec.GEO__c = leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Geo__c;
                        leadRec.MKT_Territory__c = leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Sales_Area__c;
                        leadRec.Sales_Territory__c = leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Sales_Region__c;
                        leadRec.Country__c = leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Region_Country__c;
                        leadRec.Country_Picklist__c = leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Country_Picklist__c;
                        //leadRec.OwnerId = '00G30000002cnBH';
                        //if(leadRec.OwnerId == UnAssignedQueueId) {
                        System.debug('_____%%%%%%%'+leadRec.CAPOPUpdatingFirstTime__c);    
                        if(leadRec.CAPOPUpdatingFirstTime__c == false) {
                            leadRec.CAPOPUpdatingFirstTime__c = true;
                            System.debug('_____*******$$$$$$$'+leadRec.CAPOPUpdatingFirstTime__c);    
                            if(leadPartnerUser.get(leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Lead_Champion__c) <> null) 
                                leadRec.OwnerId = leadPartnerAccount.get(leadrec.PartnerAccount_ID__c).Lead_Champion__c;
                                //leadRec.OwnerId = queue.id;//Testing Purpose
                            else
                                leadRec.OwnerId = CAPOPQueueId;
                        }
                        //}           
                    }
                    
                    //If Partner User Active -> assign Partner as Owner Id, else Assign to CA POP Queue
                    //System.debug(leadPartnerUser+'_______CAPOPLEADREC***************'+leadrec.recordtypeId);
                    /*if(leadPartnerUser.get(leadRec.PartnerUser_ID__c) <> null && (leadRec.PartnerUser_ID__c <> '' && leadRec.PartnerUser_ID__c <> null)) 
                        leadRec.Ownerid = leadPartnerUser.get(leadRec.PartnerUser_ID__c).id;
                    else if(CAPOPQueueList <> null)
                        leadRec.OwnerId = CAPOPQueueList.QueueId;*/
                        
                    //Assign Campaign related information GBU and GBU Driver for Campaign associated Leads
                    if(leadPartnerCamapaign.get(leadRec.Campaign_ID__c) <> null && (leadRec.Campaign_ID__c <> '' && leadRec.Campaign_ID__c <> null)){
                        leadRec.CA_Campaign_Id__c = leadRec.Campaign_ID__c;
                        leadRec.CSU__c = leadPartnerCamapaign.get(leadRec.Campaign_ID__c).Primary_CSU__c;
                        leadRec.CSU_Driver__c = leadPartnerCamapaign.get(leadRec.Campaign_ID__c).Primary_Driver__c;
                    }
                    
                    //Assign Lead Status
                    /*if(leadRec.LeadStatus_Custom__c <> '' && leadRec.LeadStatus_Custom__c <> null)
                        leadRec.Status=leadRec.LeadStatus_Custom__c;*/
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception occured for CA POP lead record'+ex);
        }
    }
       
  if(trigger.isafter)
  {
    for(Lead lead:Trigger.New) {
        
         if(lead.RecordTypeId == recIndirectLeadId ){
            
            System.debug('********'+lead.RTM__c + lead.CAM_PMFKey__c);   
                           
            if(lead.Reseller__c!=null && lead.RTM__c!=null && lead.CAM_PMFKey__c==null && lead.Is_Lead_Owner_Partner__c==true)
               lead.addError('There Is No CAM Associated With the reseller Account Please contact System Administrator.');
                            
            if(Trigger.isInsert){
                    
                if(lead.RTM__c != null && lead.CAM_PMFKey__c!=null){
                    leadMap.put(lead.Id,lead);
                    rtmPMF.add(lead.CAM_PMFKey__c.toUpperCase());
                }
                    
            }
            if(Trigger.isUpdate){
               /* if(lead.Reseller__c!=null && lead.RTM__c!=null && lead.CAM_PMFKey__c==null)
                    lead.addError('There Is No CAM Associated With the reseller Account Please contact System Administrator.');
               */   
                if(lead.RTM__c != null && Trigger.oldMap.get(lead.Id).CAM_PMFKey__c != lead.CAM_PMFKey__c 
                   && lead.CAM_PMFKey__c!=null ){
                    leadMap.put(lead.Id,lead);
                    rtmPMF.add(lead.CAM_PMFKey__c.toUpperCase());   
                }                    
            }
        }
    }
    
    if(rtmPMF.size()>0){
        List<User> usr= [select id,pmfkey__c from user where PMFKey__c in:rtmPMF];
        for(User u: usr)
            userMap.put(u.pmfkey__c,u.id);
    }
    if(leadMap.size()>0 && userMap.size()>0){
            System.debug('*****userMap****'+userMap+ '*****leadMap****'+ leadMap);
            List<Lead> LeadRecords = leadMap.values();
            for(Lead LeadRec : LeadRecords ){
                LeadShare leadShr = new LeadShare();
                leadShr.LeadAccessLevel='Edit';
                leadShr.LeadId=LeadRec.Id;
                if(LeadRec.RTM__c != null && LeadRec.CAM_PMFKey__c!=null &&
                        userMap.get(LeadRec.CAM_PMFKey__c.toUpperCase())!=null)
                {
                  leadShr.UserOrGroupId=userMap.get(LeadRec.CAM_PMFKey__c.toUpperCase());
                }
                if(leadShr.UserOrGroupId!=null)
                    leadShareLst.add(leadShr);
            }    
    }
       
    if(leadShareLst.size()>0){
       if(Limits.getDMLRows() +  leadShareLst.size() < Limits.getLimitDMLRows())
       {
         try {
                database.insert(leadShareLst,false);
            } catch (System.DmlException e) {
                System.debug('error in sharing lead record.'+e);
            }
            
       }else{             
         Map<string,string> mLeadShare = new Map<string, string>();
         for(LeadShare ls:leadShareLst)
            mLeadShare.put(ls.LeadId,ls.UserOrGroupId);
            UpdateChildOwnership.Lead_Share(mLeadShare);        
       }
    }    
    }    
        
}