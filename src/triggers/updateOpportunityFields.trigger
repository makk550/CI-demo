trigger updateOpportunityFields on Opportunity_Registration__c (before delete,before insert,after update,after insert,before update) {
  Set<Id> OppIdsApproved= new Set<Id>();
  Set<Id> OppIdsRejected= new Set<Id>();
  Set<Id> OppIds = new Set<Id>();
  Map<Id,Opportunity_Registration__c> mapOppReg= new Map<Id,Opportunity_Registration__c>();
  Map<Id,Opportunity_Registration__c> mapOppRegRej= new Map<Id,Opportunity_Registration__c>();
  List<Opportunity> OppsUpdate = new   List<Opportunity>();
  set<String> fieldSet = new Set<String>();
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        for(Schema.FieldSetMember fields :Schema.SObjectType.Opportunity_Registration__c.fieldSets.getMap().get('PIR_Fields').getFields()){
          fieldSet.add(fields.getFieldPath());
        }
       for(Opportunity_Registration__c o: trigger.new){
         //if(o.Registration_Status__c == 'Modifying' && o.Second_Approver__c != null) o.Registration_Status__c = 'Second';
           if(o.Registration_Status__c == 'Rejected' || o.Registration_Status__c == 'Terminated') {
               o.isApproved__c='False';
               o.Modifying__c = 'Yes';
           }
         if((o.Registration_Status__c != 'New' && o.Registration_Status__c !='Pending Approval' && trigger.oldMap.get(o.Id).Registration_Status__c == 'Partially Approved') || o.Registration_Status__c == 'Rejected' || o.Registration_Status__c == 'Terminated'){
           for(string s: fieldSet){
            
            system.debug('test Registration_Status__c'+o.Registration_Status__c);               
             if(o.get(s) != trigger.oldMap.get(o.Id).get(s) && (trigger.oldMap.get(o.Id).get(s) != null || trigger.oldMap.get(o.Id).get(s) != '') ){
                system.debug('o.get(s)+trigger.oldMap.get(o.Id).get(s)>>'+s+' '+trigger.oldMap.get(o.Id).get(s)+' '+o.get(s));
                o.Modifying__c = 'Yes';
                o.Registration_Status__c = 'Modifying';
                o.Is_Required_Approver_1__c = true;
                if(o.Second_Approver__c != null) o.Is_Required_Approver_2__c = true;
                if(o.Third_Approver__c != null) o.Is_Required_Approver_3__c = true;
                
             }
           
           }
            //if(o.Modifying__c != 'Yes') o.Registration_Status__c = 'Pending Approval';
         }
         //if(o.Registration_Status__c == 'Second' && o.Third_Approver__c != null) o.Registration_Status__c = 'Third';
         if(o.Registration_Status__c == 'Partially Approved' &&  o.Registration_Status__c != trigger.oldMap.get(o.Id).Registration_Status__c 
         && o.isApproved__c=='True' &&  !o.Is_Required_Approver_2__c &&  !o.Is_Required_Approver_3__c){
            o.Registration_Status__c ='Approved';
            o.Modifying__c = 'Final Approved';
            system.debug('user in first ');
         }
          if(o.Registration_Status__c == 'Partially Approved' &&  o.Registration_Status__c != trigger.oldMap.get(o.Id).Registration_Status__c 
         && o.isApproved__c=='True' &&  !o.Is_Required_Approver_3__c ){
            o.Registration_Status__c ='Approved';
            o.Modifying__c = 'Final Approved';
            system.debug('user in second ');
         }
        if(o.Registration_Status__c == 'Approved' &&  o.Registration_Status__c != trigger.oldMap.get(o.Id).Registration_Status__c && o.Modifying__c == 'Final Approved'){
            o.Approved_Timestamp__c =System.today();
         }
        }
           
    }
    if(Trigger.isInsert && Trigger.isBefore)  
    {
       for(Opportunity_Registration__c oppReg: Trigger.new){
          oppReg.Registration_Status__c = 'New';
       
      }
    }
    else
    {
    if(Trigger.isInsert || Trigger.isUpdate)
    {    
          OppsUpdate.clear();
          for(Opportunity_Registration__c oppReg: Trigger.new){
             if(oppReg.Registration_Status__c == 'Partially Approved' || oppReg.Registration_Status__c == 'Approved')
             {
                   OppIdsApproved.add(oppReg.Opportunity_Name__c);
                   OppIds.add(oppReg.Opportunity_Name__c);
                   mapOppReg.put(oppReg.Opportunity_Name__c,oppReg);             

             }
             if(oppReg.Registration_Status__c == 'Rejected' || oppReg.Registration_Status__c == 'Terminated')
                OppIdsRejected.add(oppReg.Opportunity_Name__c);
                OppIds.add(oppReg.Opportunity_Name__c);
                mapOppRegRej.put(oppReg.Opportunity_Name__c,oppReg);
      }

  List<Opportunity> Opps= [SELECT Id,Alliance_Partner_2__c,Partner_Engagement_Phase__c,Partner_Engagement_Phase_2__c,JSO_Name__c,JSO_Name_2__c,Technology_Partner_Lead1__c,Field_Alliance_Lead2__c,Partner_1__c,Registration_Status__c,Field_Alliance_Leader__c,Technology_Partner__c FROM Opportunity WHERE Id = :OppIdsApproved];
  if(Opps.size() > 0)
  {
    if(mapOppReg.size() > 0)
    {   
        for(Opportunity op: Opps)
        {
            if(mapOppReg.get(op.Id).Registration_Status__c == 'Partially Approved' || mapOppReg.get(op.Id).Registration_Status__c == 'Approved')
            {
               if(mapOppReg.get(op.Id).Alliance_Partner__c != null)
               {
                  op.Partner_1__c = mapOppReg.get(op.Id).Alliance_Partner__c;
                  op.Field_Alliance_Leader__c = mapOppReg.get(op.Id).Field_Alliance_Leader__c; 
                  op.Partner_Engagement_Phase__c = mapOppReg.get(op.Id).Partner_Engagement_Phase__c;
                  op.JSO_Name__c = mapOppReg.get(op.Id).JSO_Name__c;
               }  
               if(mapOppReg.get(op.Id).Technology_Partner__c != null)               
               {
                   op.Technology_Partner__c =  mapOppReg.get(op.Id).Technology_Partner__c;
                   op.Technology_Partner_Lead1__c= mapOppReg.get(op.Id). Technology_Partner_Lead__c;
               }
               if(mapOppReg.get(op.Id).Alliance_Partner_2__c != null)               
               {
                  op.Field_Alliance_Lead2__c = mapOppReg.get(op.Id).Field_Alliance_Lead_2__c;
                  op.Alliance_Partner_2__c  = mapOppReg.get(op.Id).Alliance_Partner_2__c ;
                  op.Partner_Engagement_Phase_2__c = mapOppReg.get(op.Id).Partner_Engagement_Phase_2__c;
                  op.JSO_Name_2__c = mapOppReg.get(op.Id).JSO_Name_2__c;
               }
              op.Registration_Status__c = mapOppReg.get(op.Id).Registration_Status__c ;         
              OppsUpdate.add(op);          
            }
        }

      }    
  }
  // List<Opportunity> OppsRej= [SELECT Id,Registration_Status__c, FROM Opportunity WHERE Id = :OppIdsRejected];
  List<Opportunity> OppsRej= [select Id,Alliance_Partner_2__c,Partner_Engagement_Phase__c,Partner_Engagement_Phase_2__c,JSO_Name__c,JSO_Name_2__c,Technology_Partner_Lead1__c,Field_Alliance_Lead2__c,Partner_1__c,Registration_Status__c,Field_Alliance_Leader__c,Technology_Partner__c from Opportunity where Id =:OppIdsRejected];
  if(OppsRej.size() > 0 )
  {
      
          for(Opportunity op: OppsRej){
             if(mapOppRegRej.get(op.Id).Alliance_Partner__c == op.Partner_1__c && op.Field_Alliance_Leader__c == mapOppRegRej.get(op.Id).Field_Alliance_Leader__c && op.Partner_Engagement_Phase__c == mapOppRegRej.get(op.Id).Partner_Engagement_Phase__c)
               {
                  op.Partner_1__c = null;
                  op.Field_Alliance_Leader__c  = null;
                  op.Partner_Engagement_Phase__c = null;
                  op.JSO_Name__c = null; 
               }                   
               if(mapOppRegRej.get(op.Id).Technology_Partner__c == op.Technology_Partner__c && op.Technology_Partner_Lead1__c  == mapOppRegRej.get(op.Id).Technology_Partner_Lead__c)               
               {
                   op.Technology_Partner__c =  null;
                   op.Technology_Partner_Lead1__c=null;
               }
               
               if(mapOppRegRej.get(op.Id).Alliance_Partner_2__c == op.Alliance_Partner_2__c && op.Field_Alliance_Lead2__c ==  mapOppRegRej.get(op.Id).Field_Alliance_Lead_2__c && op.Partner_Engagement_Phase_2__c ==  mapOppRegRej.get(op.Id).Partner_Engagement_Phase_2__c)               
               {
                  op.Alliance_Partner_2__c = null;
                  op.Field_Alliance_Lead2__c =null;
                  op.Partner_Engagement_Phase_2__c = null;
                  op.JSO_Name_2__c = null; 
               }
               
                  OppsUpdate.add(op);          
           }
      }    
  
    if(OppsUpdate.size() > 0)
        update OppsUpdate; 
        
 
  Boolean TeamMemberExists = false; 
  List<OpportunityTeamMember>  AddTeamMember = new List<OpportunityTeamMember>();
  List<OpportunityShare> OppShares = new List<OpportunityShare>();     
  List<OpportunityTeamMember> OppsTeams= [SELECT Id,UserId,OpportunityId FROM OpportunityTeamMember WHERE OpportunityId = :OppIdsApproved];      
    for(Opportunity_Registration__c oppRegistration: Trigger.new){
        if(oppRegistration.Registration_Status__c == 'Approved' && Trigger.oldMap.get(oppRegistration.Id).Registration_Status__c != 'Approved'){
        for (OpportunityTeamMember OppTeamMember :OppsTeams){
             if(oppRegistration.Registration_Status__c == 'Approved' && oppRegistration.Opportunity_Name__c == OppTeamMember.OpportunityId && OppTeamMember.UserId == oppRegistration.createdById )
             {
                TeamMemberExists = true;
             }
        }
        if(!TeamMemberExists){
            
            AddTeamMember.add(new OpportunityTeamMember(UserId = oppRegistration.createdById,OpportunityId = oppRegistration.Opportunity_Name__c, TeamMemberRole = 'Global Account Director'));
             System.debug(AddTeamMember);
        }
        }
        
     } 
     
     if(AddTeamMember != null && AddTeamMember.size() > 0){
        insert AddTeamMember;
        OppShares = [Select Id, UserOrGroupId,OpportunityId, OpportunityAccessLevel from OpportunityShare where OpportunityId In :OppIdsApproved and Rowcause = 'Team' ];
     }
    
    for(Opportunity_Registration__c oppRegistration: Trigger.new){
        if(oppRegistration.Registration_Status__c == 'Approved' && Trigger.oldMap.get(oppRegistration.Id).Registration_Status__c != 'Approved')
        for (OpportunityShare OppShare : OppShares){  
            if(oppRegistration.createdById == OppShare.UserOrGroupId && oppRegistration.Opportunity_Name__c == OppShare.OpportunityId )
                OppShare.OpportunityAccessLevel = 'Edit';
        }
    }
    System.debug('OppShares'+OppShares);
    
    if(OppShares != null && OppShares.size() > 0)
        update OppShares; 

     //----PONSE01-----Start----------
     List<OpportunityTeamMember>  RemoveTeamMember = new List<OpportunityTeamMember>();
     
     List<OpportunityTeamMember> OppsTeamsterminated= [SELECT Id,UserId,OpportunityId,TeamMemberRole FROM OpportunityTeamMember WHERE OpportunityId=:OppIdsRejected And (TeamMemberRole = 'TAQ-PARTN ALLIANCE' or TeamMemberRole = 'Global Account Director' or TeamMemberRole = 'TAQ-PARTN SOLPROV' or TeamMemberRole = 'TAQ-PAD/PAM')];
     
     for(Opportunity_Registration__c oppRegistration: Trigger.new){
        if(oppRegistration.Registration_Status__c == 'Terminated' && Trigger.oldMap.get(oppRegistration.Id).Registration_Status__c != 'Terminated'){
        for (OpportunityTeamMember OppTeamMember :OppsTeamsterminated){
            system.debug('-----OppTeamMember.UserId----------'+OppTeamMember.UserId);
            system.debug('-----oppRegistration.createdById----------'+oppRegistration.createdById);
             if(oppRegistration.Registration_Status__c == 'Terminated' && oppRegistration.Opportunity_Name__c == OppTeamMember.OpportunityId )
             {
                 system.debug('--------entered--RemoveTeamMember-----------------');
                RemoveTeamMember.add(OppTeamMember);
             }
        }
        
        }
        
     }
     if(RemoveTeamMember != null && RemoveTeamMember.size() > 0){
        delete RemoveTeamMember;
    }
     //----PONSE01-----END----------

    
 } 
 }
  if(Trigger.isDelete && Trigger.isBefore)
  {
 
    OppsUpdate.clear();
    OppIdsApproved.clear();
    mapOppReg.clear();
    OppIds.clear();
    for(Opportunity_Registration__c oppReg: Trigger.old){
          if(oppReg.Registration_Status__c  == 'Partially Approved')
          {
               OppIdsApproved.add(oppReg.Opportunity_Name__c);
               OppIds.add(oppReg.Opportunity_Name__c);
               mapOppReg.put(oppReg.Opportunity_Name__c,oppReg);             
          }
     }
          system.debug('OppIdsApproved--> ' + OppIdsApproved) ; 

      List<Opportunity> Opps= [SELECT Id,Alliance_Partner_2__c,Partner_Engagement_Phase__c,Partner_Engagement_Phase_2__c,JSO_Name__c,JSO_Name_2__c,Technology_Partner_Lead1__c,Field_Alliance_Lead2__c,Partner_1__c,Registration_Status__c,Field_Alliance_Leader__c,Technology_Partner__c FROM Opportunity WHERE Id = :OppIdsApproved];
      if(Opps.size() > 0)
      {
        if(mapOppReg.size() > 0)
        {   
            for(Opportunity op: Opps)
            {
                //if(mapOppReg.get(op.Id).Registration_Status__c == 'Approved')
                {
                   if(mapOppReg.get(op.Id).Alliance_Partner__c == op.Partner_1__c && op.Field_Alliance_Leader__c == mapOppReg.get(op.Id).Field_Alliance_Leader__c && op.Partner_Engagement_Phase__c == mapOppReg.get(op.Id).Partner_Engagement_Phase__c)
                   {
                      op.Partner_1__c = null;
                      op.Field_Alliance_Leader__c  = null;
                      op.Partner_Engagement_Phase__c = null;
                   }                   
                   if(mapOppReg.get(op.Id).Technology_Partner__c == op.Technology_Partner__c && op.Technology_Partner_Lead1__c  == mapOppReg.get(op.Id).Technology_Partner_Lead__c)               
                   {
                       op.Technology_Partner__c =  null;
                       op.Technology_Partner_Lead1__c=null;
                   }
                   
                   if(mapOppReg.get(op.Id).Alliance_Partner_2__c == op.Alliance_Partner_2__c && op.Field_Alliance_Lead2__c ==  mapOppReg.get(op.Id).Field_Alliance_Lead_2__c && op.Partner_Engagement_Phase_2__c ==  mapOppReg.get(op.Id).Partner_Engagement_Phase_2__c)               
                   {
                      op.Alliance_Partner_2__c = null;
                      op.Field_Alliance_Lead2__c =null;
                      op.Partner_Engagement_Phase_2__c = null;
                   }
                   if(mapOppReg.get(op.Id).JSO_Name__c == op.JSO_Name__c )
                   {
                     op.JSO_Name__c = null; 
                   }
                   if(mapOppReg.get(op.Id).JSO_Name_2__c == op.JSO_Name_2__c )
                   {
                     op.JSO_Name_2__c = null; 
                   }
                   
                      OppsUpdate.add(op);          
               }
            }

          }    
    }

    if(OppsUpdate.size() > 0)
       update OppsUpdate;
  }
  
  
}