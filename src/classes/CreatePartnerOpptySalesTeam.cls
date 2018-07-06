/*
  This class has been written to Add CAM's to opportunities sales Team upon CAM for Route is changed.
  
   If Solution provider CAM is changed
   -  There exists opportunities with Reseller Account.
   Then
     Add the New CAM to Opportunity sales Team. 
     
   If Service provider CAM is changed
   -  There exists opportunities with Service Provider Partner Account.
   Then
     Add the New CAM to Opportunity sales Team.
     
   If Alliance CAM is changed
   -  There exists opportunities with Alliance Partner  Account.
   Then
      Add the New CAM to Opportunity sales Team.
   
*/

public class CreatePartnerOpptySalesTeam {
    
public void updateOpportunitySalesTeam (Map<Id,Map<String,Map<String,String>>> accntsMap,set<String> oldPmfKeys, set<String> newPmfKeys)
{
}
@future     
public static void updateOpportunitySalesTeam1(Map<Id,String> mapOldAllianceCAM,Map<Id,String> mapnewAllianceCAM,Map<Id,String> mapoldSolnProvCAM,Map<Id,String> mapnewSolnProvCAM,Map<Id,String> mapoldServProvCAM,Map<Id,String> mapnewServProvCAM,set<String> oldPmfKeys, set<String> newPmfKeys){

    Map<Id,Map<String,Map<String,String>>> accntsMap = new Map<Id,Map<String,Map<String,String>>> ();
        for(Id acc : mapOldAllianceCAM.keySet())
        {
        //  System.debug('____aaa____'+acc.recordtypeid);
        //  System.debug('____bbb____'+recEnterpriseId);
        //  System.debug('____bbb____'+SystemIdUtility.mapAccountsOld);
        //  System.debug('____bbb____'+SystemIdUtility.mapAccountsOld.get(acc.id));
        //  System.debug('____bbb____'+SystemIdUtility.mapAccountsOld.get(acc.id).ownerid);
        //  System.debug('____bbb____'+acc.ownerid);
            
                
            //PRM Srprint 4 changes start.                                  

               Map<String,String> pmfKeys = new Map<String,String> ();
               Map<String,Map<String,String>> routes = new Map<String,Map<String,String>> ();                  
               
               String oldAllianceCAM = mapoldAllianceCAM.get(acc);
               String newAllianceCAM = mapnewAllianceCAM.get(acc);
               String oldSolnProvCAM =  mapoldSolnProvCAM.get(acc);
               String newSolnProvCAM =  mapnewSolnProvCAM.get(acc);
               String oldServProvCAM =  mapoldServProvCAM.get(acc);
               String newServProvCAM =  mapnewServProvCAM.get(acc);
               
/*               if(oldMap.get(acc.Id).Alliance_CAM_PMFKey__c!=null)
                  oldAllianceCAM = oldMap.get(acc.Id).Alliance_CAM_PMFKey__c.toUpperCase();
               if(acc.Alliance_CAM_PMFKey__c!=null)
                  newAllianceCAM = acc.Alliance_CAM_PMFKey__c.toUpperCase();  
               if(oldMap.get(acc.Id).Solution_Provider_CAM_PMFKey__c!=null)
                  oldSolnProvCAM =oldMap.get(acc.Id).Solution_Provider_CAM_PMFKey__c.toUpperCase();
               if(acc.Solution_Provider_CAM_PMFKey__c!=null)
                  newSolnProvCAM = acc.Solution_Provider_CAM_PMFKey__c.toUpperCase();
               if(oldMap.get(acc.Id).Service_Provider_CAM_PMFKey__c!=null)
                  oldServProvCAM =oldMap.get(acc.Id).Service_Provider_CAM_PMFKey__c.toUpperCase();
               if(acc.Service_Provider_CAM_PMFKey__c!=null)
                  newServProvCAM=acc.Service_Provider_CAM_PMFKey__c.toUpperCase();       
                    
  */             
               if(oldSolnProvCAM!= newSolnProvCAM){         
                     pmfKeys.put(oldSolnProvCAM,newSolnProvCAM);
                     routes.put('Solution Provider',pmfKeys); 
                     if(newSolnProvCAM!=null)
                       newPmfKeys.add(newSolnProvCAM);
                     if(oldSolnProvCAM!=null){
                       oldPmfKeys.add(oldSolnProvCAM);                    
                       //childLeads.put(acc.Id,routes);
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
                  accntsMap.put(acc,routes);
                  //if(routes.containsKey('Solution Provider')){
                    // childLeads.put(acc.Id,routes);                     
                  //}                           
              }
                    
          //PRM Sprint 4 changes End.             
                
        }

     
                
        //get the userid's corresponding to PMF key.            
        Map<String,Id> oldUsrIds = new Map<String,Id>();
        if(oldPmfKeys!=null && oldPmfKeys.size()>0){
            List<User> oldUsr= [select id,pmfkey__c from user where PMFKey__c in:oldPmfKeys];
            for(User u: oldUsr){
             oldUsrIds.put(u.pmfkey__c,u.id); 
            }
        } 
       Map<String,Id> newUsrIds = new Map<String,Id>();
       if(newPmfKeys!=null && newPmfKeys.size()>0){
          List<User> newUsr= [select id,pmfkey__c from user where PMFKey__c in:newPmfKeys];
          for(User u: newUsr){
           newUsrIds.put(u.pmfkey__c,u.id); 
          }
       }
       System.debug('old User Ids ****'+oldUsrIds + 'new User Ids ****' + newUsrIds);
       //get the list opportunites.
      Opportunity[] opportunity = [select id,OwnerId,Name,Partner_1__c,Partner__c,Reseller__c,Service_Provider_CAM_PMFKey__c,
                                  Alliance_CAM_PMFKey__c,CAM_PMFKey__c,StageName, Owner.pmfkey__c  from Opportunity where 
                                  Reseller__c in : accntsMap.keySet() or Partner__c in : accntsMap.keySet() or Partner_1__c in : accntsMap.keySet()];
        
      System.debug('opportunitys ****'+opportunity);            
      List<OpportunityTeamMember> newOppTeamMembers = new List<OpportunityTeamMember>();
      Map<String,Map<String,String>> delOppTeamMembers = new Map<String,Map<String,String>>();
      
      List<String> OppDetails = new List<String>();
      List<String> userDetails = new List<String>();
      List<String> roleDetails = new List<String>();
      Set<Id> usrsToDel  = new Set<Id>();
      List<Id> oppTeamIdsTodel  = new List<Id>();
        
      for(Opportunity Opp : opportunity){
          
          Map<String,Map<String,String>> alliancePartnMap =  accntsMap.get(opp.Partner_1__c);      
          Map<String,Map<String,String>> servProvMap =  accntsMap.get(opp.Partner__c);     
          Map<String,Map<String,String>> solnProvMap =  accntsMap.get(opp.Reseller__c); 
          
          Map<String,String> usrLst =  new Map<String,String>();
          
          System.debug('****Maps:'+alliancePartnMap+servProvMap+solnProvMap);
          //If allianace CAM is changed,get the related reseller and alliance opoortunites and update the sales team.
          if(alliancePartnMap!=null && alliancePartnMap.containsKey('Alliance')){
            
            Map<String,String> alliancePmfKys = alliancePartnMap.get('Alliance');
            String oldPmfKey;
            String newPmfKey;
                    
            for(String pmfKey : alliancePmfKys.keySet()) {
                oldPmfKey = pmfKey;
             }
             newPmfKey = alliancePmfKys.get(oldPmfKey);
             Id oldUsrId = oldUsrIds.get(oldPmfKey);
             Id newUsrId=newUsrIds.get(newPmfKey);
              
            if(newUsrId!=null){ 
               OpportunityTeamMember oppTeam = new OpportunityTeamMember(OpportunityId=Opp.Id,TeamMemberRole = 'TAQ-PARTN ALLIANCE',UserId = newUsrId);
               newOppTeamMembers.add(oppTeam);  
            }               
            if(oldUsrId!=null && opp.Service_Provider_CAM_PMFKey__c!=oldPmfKey && opp.CAM_PMFKey__c!=oldPmfKey){    
               usrLst.put('TAQ-PARTN ALLIANCE',oldUsrId);
               usrsToDel.add(oldUsrId);
            }                           
          }
          
          if(solnProvMap!=null && solnProvMap.containsKey('Alliance')){
            
            Map<String,String> alliancePmfKys = solnProvMap.get('Alliance');
            String oldPmfKey;
            String newPmfKey;
                    
            for(String pmfKey : alliancePmfKys.keySet()) {
                oldPmfKey = pmfKey;
            }
            newPmfKey = alliancePmfKys.get(oldPmfKey);
            Id oldUsrId = oldUsrIds.get(oldPmfKey);
            Id newUsrId = newUsrIds.get(newPmfKey);
            if(newUsrId!=null){
               OpportunityTeamMember oppTeam = new OpportunityTeamMember(OpportunityId=Opp.Id,TeamMemberRole = 'TAQ-PARTN ALLIANCE',UserId = newUsrId);
               newOppTeamMembers.add(oppTeam);  
            }   
            
            
            if(oldUsrId!=null && opp.Service_Provider_CAM_PMFKey__c!=oldPmfKey && opp.CAM_PMFKey__c!=oldPmfKey && opp.Alliance_CAM_PMFKey__c!=oldPmfKey){   
               usrLst.put('TAQ-PARTN ALLIANCE',oldUsrId);
               usrsToDel.add(oldUsrId);
            }                   
          }
                                            
          if(servProvMap!=null && servProvMap.containsKey('Service Provider')){
            
            Map<String,String> servProvPmfKys = servProvMap.get('Service Provider');
            String oldPmfKey;
            String newPmfKey;
        
            for(String pmfKey : servProvPmfKys.keySet()) {
                oldPmfKey = pmfKey;
             }
            newPmfKey = servProvPmfKys.get(oldPmfKey);
            Id oldUsrId = oldUsrIds.get(oldPmfKey);
            Id newUsrId=newUsrIds.get(newPmfKey);
            
            if(newUsrId!=null){
               OpportunityTeamMember oppTeam = new OpportunityTeamMember(OpportunityId=Opp.Id,TeamMemberRole = 'TAQ-PARTN SERPROV',UserId = newUsrId);
               newOppTeamMembers.add(oppTeam);  
            }
                        
            if(oldUsrId!=null && opp.Alliance_CAM_PMFKey__c!=oldPmfKey && opp.CAM_PMFKey__c!=oldPmfKey){    
               usrLst.put('TAQ-PARTN SERPROV',oldUsrId);
               usrsToDel.add(oldUsrId);
            }
          }  
          
          if(solnProvMap!=null && solnProvMap.containsKey('Service Provider')){
            
            Map<String,String> servProvPmfKys = solnProvMap.get('Service Provider');
            String oldPmfKey;
            String newPmfKey;
        
            for(String pmfKey : servProvPmfKys.keySet()) {
                oldPmfKey = pmfKey;
             }
            newPmfKey = servProvPmfKys.get(oldPmfKey);
            Id oldUsrId = oldUsrIds.get(oldPmfKey);
            Id newUsrId=newUsrIds.get(newPmfKey);
            
            if(newUsrId!=null){
               OpportunityTeamMember oppTeam = new OpportunityTeamMember(OpportunityId=Opp.Id,TeamMemberRole = 'TAQ-PARTN SERPROV',UserId = newUsrId);
               newOppTeamMembers.add(oppTeam);  
            }
            
            if(oldUsrId!=null && opp.Alliance_CAM_PMFKey__c!=oldPmfKey && opp.CAM_PMFKey__c!=oldPmfKey && opp.Service_Provider_CAM_PMFKey__c!=oldPmfKey){   
               usrLst.put('TAQ-PARTN SERPROV',oldUsrId);
               usrsToDel.add(oldUsrId);
            }
          } 
          
          //If Solution provider CAM is changed,get the related reseller and Solution provider opoortunites and update the sales team.
          if(solnProvMap!=null && solnProvMap.containsKey('Solution Provider')){            
            Map<String,String> solnProvPmfKys = solnProvMap.get('Solution Provider');
            String oldPmfKey;
            String newPmfKey;
                    
            for(String pmfKey : solnProvPmfKys.keySet()) {
                oldPmfKey = pmfKey;                          
             }
          
            newPmfKey = solnProvPmfKys.get(oldPmfKey);
            Id oldUsrId = oldUsrIds.get(oldPmfKey);
            Id newUsrId=newUsrIds.get(newPmfKey);
            
            if(newUsrId!=null){
               OpportunityTeamMember oppTeam = new OpportunityTeamMember(OpportunityId=Opp.Id,TeamMemberRole = 'TAQ-PARTN SOLPROV',UserId = newUsrId);
               newOppTeamMembers.add(oppTeam);  
            }           
            if(oldUsrId!=null && opp.Service_Provider_CAM_PMFKey__c!=oldPmfKey && opp.Alliance_CAM_PMFKey__c!=oldPmfKey){   
               usrLst.put('TAQ-PARTN SOLPROV',oldUsrId);
               usrsToDel.add(oldUsrId);
            }
            
          }                   
          delOppTeamMembers.put(opp.id,usrLst);           
      }
      
     
      if(delOppTeamMembers.size()>0){
        
        OpportunityTeamMember[] oppTeams = [Select Id,TeamMemberRole,UserId,OpportunityId from OpportunityTeamMember where 
                                             UserId in :usrsToDel and OpportunityId in:delOppTeamMembers.keySet()];
       for(OpportunityTeamMember oppTeamMem : oppTeams){
        
          Map<String,String> usrLst = delOppTeamMembers.get(oppTeamMem.OpportunityId);        
          if(usrLst!=null && usrLst.containsKey(oppTeamMem.TeamMemberRole) && oppTeamMem.UserId==usrLst.get(oppTeamMem.TeamMemberRole)){        
            oppTeamIdsTodel.add(oppTeamMem.Id);
          }
       }    
      }
      
      if(oppTeamIdsTodel.size()>0){
        
        if(Limits.getDMLRows() + oppTeamIdsTodel.size()< Limits.getLimitDMLRows())
           Database.delete(oppTeamIdsTodel, false);
        else  
          deleteTeamMember(oppTeamIdsTodel);
      }
      
      if(newOppTeamMembers.size()>0){
         
         if(Limits.getDMLRows() + newOppTeamMembers.size()< Limits.getLimitDMLRows())
         {
            Database.insert(newOppTeamMembers, false);       
         }else{
            for(OpportunityTeamMember OppTeemMember :newOppTeamMembers)
            {
               OppDetails.add(OppTeemMember.OpportunityId);
               userDetails.add(OppTeemMember.UserId);
               roleDetails.add(OppTeemMember.TeamMemberRole);
            }
             //updateTeamMember(OppDetails,userDetails,roleDetails);                      
             //Vasantha begin
             List<OpportunityTeamMember> TeamMemberList = new List<OpportunityTeamMember>();
                for(Integer i=0 ; i< OppDetails.size();i++){          
                    TeamMemberList.add(new OpportunityTeamMember( OpportunityId=OppDetails.get(i),UserId= userDetails.get(i),TeamMemberRole=roleDetails.get(i)));
                }
                if(TeamMemberList.size() >0)
                    Database.insert(TeamMemberList, false);
             
             //Vasantha  end
         }      
       }        
    }
          
//////////////////////Vasantha     
@future 
 public static void updateTeamMember(List<String> lOpp,List<String> luser,List<String> lRole)
 {
    List<OpportunityTeamMember> TeamMemberList = new List<OpportunityTeamMember>();
    for(Integer i=0 ; i< lOpp.size();i++){          
        TeamMemberList.add(new OpportunityTeamMember( OpportunityId=lOpp.get(i),UserId= luser.get(i),TeamMemberRole=lRole.get(i)));
    }
    if(TeamMemberList.size() >0)
        Database.insert(TeamMemberList, false);
 }
       
 @future
 public static void deleteTeamMember(List<Id> teamMemIds){
     Database.delete(teamMemIds, false);
    
 }      
       
  /*
     This method is to create Partner user if the account is created through On boarding process.
     Partner user would be created after population of CPMS ID in account Record.
     
     Fetch the Partner user information from partner Registration record and then create partner Contact and Partner User. 
          
  
  **/     
  
  public void createPartner(set<Id> partnAcc){
   system.debug('##### partnAcc-'+partnAcc);
   List<Partner_Registration__c> partnReg = [select Name,TAQ_Account__c,TAQ_Account__r.View_Acc_Record__c,TAQ_Account__r.Alliance__c,TAQ_Account__r.Service_Provider__c,TAQ_Account__r.Solution_Provider__c,TAQ_Account__r.Velocity_Seller__c,Salutation__c,First_Name__c,TAQ_Account__r.Name,
                                         Last_Name__c,Email_Address__c,Alias_Screen_Name__c,Job_Title__c,Country__c,Address_1__c,
                                         Address_2__c,City__c,State_Province__c,Postal_Code__c,Phone__c,Functional_Role__c,Preferred_Currency__c,
                                         Preferred_language__c,Company_business_model__c,Program_specialty_interest__c,TAQ_Account__r.DM_Only_Account__c,
                                         sell_or_recommended_CA_solutions__c,CA_Solutions_and_Products__c from Partner_Registration__c where 
                                         TAQ_Account__r.View_Acc_Record__c in: partnAcc ]; 
 
 
    system.debug('##### partnReg  List-'+partnReg );
    List<Contact> contacts = new List<Contact>();
        List<User> Users = new List<User>();
        Set<String> emailAdd = new Set<String>();
    
    for(Partner_Registration__c prtnReg : partnReg){
   
        system.debug('##### Inside partner reg-');     
        Contact con = new Contact(Salutation=prtnReg.Salutation__c,FirstName=prtnReg.First_Name__c,LastName=prtnReg.Last_Name__c,
                            AccountId= prtnReg.TAQ_Account__r.View_Acc_Record__c,Email=prtnReg.Email_Address__c,Job_Title__c=prtnReg.Job_Title__c,
                            Country_Picklist__c=prtnReg.Country__c,MailingStreet=prtnReg.Address_1__c,OtherStreet=prtnReg.Address_2__c,
                            Mailing_City_Local__c=prtnReg.City__c,Mailing_State_Prov_Local__c=prtnReg.State_Province__c,
                            Mailing_Postal_Code_Local__c=prtnReg.Postal_Code__c,Phone=prtnReg.Phone__C,Portal_Champion__c=true,
                            Functional_Role__c=prtnReg.Functional_Role__c,Language_Preference__c=prtnReg.Preferred_language__c,
                            User_key__c=prtnReg.name,
                            CurrencyIsoCode=(prtnReg.Preferred_Currency__c != null && Currency_Codes__c.getValues(prtnReg.Preferred_Currency__c)!=null ? Currency_Codes__c.getValues(prtnReg.Preferred_Currency__c).Currency_Code__c:'USD')
                           
                            );
                 
         System.debug('********con-'+con);   
         
         
        Contacts.add(con);
        emailAdd.add(prtnReg.Email_Address__c);
    }
    
    Set<Id> accountIdSet = new Set<Id>();       //Added - Account ID Set - PR04659 : Manikandan Raju
    
    if(Contacts.size()>0){
      system.debug('##### Creating contacts  .');
      Database.SaveResult[] contResult = Database.insert(contacts,False);
       system.debug('##### Creating contacts  .');
      for(integer i=0; i<contResult.size(); i++){
         
         if(contResult[i].isSuccess()){
          
            //PR04659 - Collect Account Id Set for newly created Accounts alone to create Account Id to Contact List Map : Manikandan Raju - Start
            system.debug('##### Collect newly created contacts .');
            if( WebServiceUtilityClass.accountInsertIdSet.contains(Contacts[i].AccountId) ){
                accountIdSet.add(Contacts[i].AccountId);
            }
             system.debug('##### accountIdSet  .'+accountIdSet);
            //PR04659 - Collect Account Id Set to create Account Id to Contact List Map : Manikandan Raju - End
            
          string localeval =(Contacts[i].Language_Preference__c!=null && Language_Keys__c.getValues(Contacts[i].Language_Preference__c)!=null ? Language_Keys__c.getValues(Contacts[i].Language_Preference__c).Language_Key__c:'en_US');
          string country = (contacts[i].country_picklist__c <> null? contacts[i].country_picklist__c.substring(0,2):'US');
          string val; 
          
          string locale = localeval.substring(0,2);
          if(locale == 'es')
            {
                if(country == 'mx' || country == 'ar' || country == 'cl' || country == 'co' || country == 'pe' || country == 've' )
                    val =  locale + '_' + country;
                else
                    val =  locale + '_' + 'es';
            }
            else if (locale == 'fr')
            {
                if(country == 'ca' || country == 'ch' || country == 'fr')
                    val =  locale + '_' + country;
                else
                    val =  locale + '_' + 'fr'; 
            }
            else if (locale == 'de')
            {
                if(country == 'ch' || country == 'at' || country == 'de')
                    val =  locale + '_' + country;
                else
                    val =  locale + '_' + 'de'; 
            }
            else if (locale == 'en')
            {
                if(country == 'gb' || country == 'us' || country == 'za' || country == 'au' || country == 'be' || country == 'hk'  || country == 'in'  || country == 'ae' || country == 'sg' || country == 'ca' || country == 'il' || country == 'se' )
                    val =  locale + '_' + country;
                else
                    val =  locale + '_' + 'us'; 
            }
            else if (locale == 'pt')
            {
                    val =  locale + '_' + 'br';
            }
            else if (locale == 'ja')
            {
                    val =  locale + '_' + 'jp';
            }
            else if (locale == 'zh')
            {
                    val =  locale + '_' + 'cn';
            }            
            else if(locale == 'fr' || locale == 'de' || locale == 'it' || locale == 'ro')
            {
                    val =  locale + '_' + locale ;
            }
              

              
          User usr = new User(Alias = (Contacts[i].FirstName.length()<8 ? Contacts[i].FirstName :Contacts[i].FirstName.substring(0, 7)),Email= Contacts[i].Email ,isActive=false,FirstName=Contacts[i].FirstName,ContactId=Contacts[i].id,                                  
                         LastName=Contacts[i].LastName, ProfileId = ((partnReg[i].Company_business_model__c == System.Label.POB_partner_referral &&  partnReg[i].TAQ_Account__r.Alliance__c == False && partnReg[i].TAQ_Account__r.Service_Provider__c == False && partnReg[i].TAQ_Account__r.Solution_Provider__c == False && partnReg[i].TAQ_Account__r.Velocity_Seller__c == False) ? System.label.POB_Referral_DefaultProfile:System.label.POB_DefaultProfile),Username = Contacts[i].Email,localesidkey=(Contacts[i].Language_Preference__c !=null && Language_Keys__c.getValues(Contacts[i].Language_Preference__c)!=null ? Language_Keys__c.getValues(Contacts[i].Language_Preference__c).Language_Key__c:'en_US'),
                         EmailEncodingKey='UTF-8',TimeZoneSidKey='America/Los_Angeles',LanguageLocaleKey=(Contacts[i].Language_Preference__c!=null && Language_Keys__c.getValues(Contacts[i].Language_Preference__c)!=null ? Language_Keys__c.getValues(Contacts[i].Language_Preference__c).Language_Key__c:'en_US'),
                         DefaultCurrencyIsoCode=Contacts[i].CurrencyIsoCode,
                         Street=Contacts[i].MailingStreet,City=Contacts[i].Mailing_City_Local__c,State=Contacts[i].Mailing_State_Prov_Local__c,
                         PostalCode=Contacts[i].Mailing_Postal_Code_Local__c,Country=Contacts[i].Country_Picklist__c,Phone=Contacts[i].Phone,
                         CompanyName=partnReg[i].TAQ_Account__r.Name,Is_Admin_for_Partner_Finder_Profile__c=true,PortalRole='Executive',
                         Education_Access__c = (partnReg[i].TAQ_Account__r.DM_Only_Account__c == 'True' ? False:True), 
                         //LDAP_LOCALE_KEY__c=(Language_Keys__c.getValues(Contacts[i].Language_Preference__c)!=null ? Language_Keys__c.getValues(Contacts[i].Language_Preference__c).Language_Key__c:'en_US')
                         LDAP_LOCALE_KEY__c = val
                         //con.Language_Preference__c
                         );
            Users.add(usr);
            //en_US
         
         
         System.debug('************Usr Details********'+ Usr); 
         }
         
         else{           
             System.debug('***************Errors********'+ contResult[i].getErrors()[0]);                                       
         }            
      }
        
         
       // if(!accountIdSet.isEmpty())
       //     WebServiceUtilityClass.getAccountIdToContactListMap(accountIdSet);    //PR04659 - Call Webservice Utility method to create Account Id to Contact List Map : Manikandan Raju
    
        if(Users.size()>0){
        
         Database.SaveResult[] usrResult = Database.insert(Users,False);
         
         for(Database.SaveResult res : usrResult){
         
           if(!res.isSuccess()){
              
              System.debug('***************Errors********'+ res.getErrors()[0] + UserInfo.getUserId());              
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              mail.setSenderDisplayName('CA Support Team');
              mail.setTargetObjectId(UserInfo.getUserId());
              mail.setSubject('User Creation Failed');
              mail.setHtmlBody('Your Request for Partner user creation falied with below exception:<b> ' + res.getErrors()[0] +' </b>.<p>'+
                               'Please enable the partner by going to the respective contact.');
              mail.setSaveAsActivity(False);               
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
           }                        
         }       
        }   
        
         
        if(!accountIdSet.isEmpty())
            WebServiceUtilityClass.getAccountIdToContactListMap(accountIdSet);    //PR04659 - Call Webservice Utility method to create Account Id to Contact List Map : Manikandan Raju
              
    }
    
     //Below code is to deactivate Ideation users if exists in the system.
      
        if(emailAdd.size()>0){
            
             //verify there exists Ideation users with the given  
              List<Id> ideationUsers = new List<Id>();
             User[] ideationUsrs = [select Id,IsPortalEnabled,IsActive  from user where UserType = 'PowerCustomerSuccess' and 
                                    email in:emailAdd and IsPortalEnabled=true and IsActive=True];
                
             System.debug('--ideationUsrs----'+ideationUsrs);                       
             if(ideationUsrs!=null){
                for(User usr :ideationUsrs){                    
                    ideationUsers.add(usr.Id);                     
                }                               
             }
             
             //deactivate Ideation users .
             //Executing in future as operation on setup object is not permitted after update on a non-setup object. 
             if(ideationUsers!=null && ideationUsers.size()>0)                                                         
                updateIdeationUsers(ideationUsers);
                
        }
                         
      SystemIdUtility.isAccntUpdated=True;          
  
  }
  
    
  public void sendNotification(Map<Id,set<String>> cams){
    
    Map<String,String> EmailIds = new Map<String,String>();
    Set<String> pmfkeys = new Set<String>(); 
    
    for(set<String> pmfKeySet: cams.values() ){         
       for(String pmfKey: pmfKeySet){
           pmfkeys.add(pmfKey);     
       }            
    }   
    List<User> userList = [select Id,email,PMFKey__c from user where PMFKey__c in: pmfkeys];    
     for(User usr: userList){
        EmailIds.put(usr.PMFKey__c,usr.email);
     }      
    
    for(ID id: cams.keySet()){
                
        set<String> camPmfKeys = cams.get(id);
        List<String> camEmails = new List<String>();
        
        if(camPmfKeys!=null){
          for(String pmfKey: camPmfKeys){           
            if(EmailIds.get(pmfKey)!=null)
             camEmails.add(EmailIds.get(pmfKey));
          } 
          
          System.debug('****Email IDS:' + camEmails);
          if(camEmails!=null && camEmails.size()>0 )
            PRM_Email_Notifications.sendEmailByCapability('On-Boarding',id,userInfo.getlocale(),'Partner Account Approval',camEmails);  
        }
        
           
    }
  
  }
  
  /*
     This method is written to notify Partner Champion on account address change.
  */
   public void notifyPartChmapionAddChange(set<Id> ids){
    
    List<Contact> contacts = [select Email,Language_Preference__c from contact where Account.Id in:ids and Portal_Champion__c=True];
            
     System.debug('Hello************************'+contacts);        
    for(Contact con: contacts){
                
        if(con.email!=null){
            
            String langCode = Language_Keys__c.getValues(con.Language_Preference__c)!=null ? Language_Keys__c.getValues(con.Language_Preference__c).Language_Key__c:'en_US';
        
            PRM_Email_Notifications.sendEmailByCapability('Partner Locator',con.Id,langCode,'Company Address Change');
        }
        
    }
    
    SystemIdUtility.hasPrtnChampNotifiedOnAddChanage=true;
    
   }
   
   
   @future
 public static void updateIdeationUsers(List<Id> ideationUsrs)
 {
    List<User> usrs = new List<User>();
    
    for(Id id:ideationUsrs){
        
        User u = new User(Id=id);
        u.IsActive=false; 
        u.IsPortalEnabled =false;
        usrs.add(u);
    }
    
    if(usrs!=null && usrs.size()>0)
       database.update(usrs,False);     
 }
  
  
 }