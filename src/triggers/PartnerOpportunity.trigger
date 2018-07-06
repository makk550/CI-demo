/*********************************************************************************************
* Modified By  Date             User Story      Details
* SAMAP01       24/8/2017       US384301        Optimize to avoid Apex Heap Size error
* SAMAP01       29/08/2017      US329774        ERWIN :Partner opp owner -Code commented
* ********************************************************************************************/
trigger PartnerOpportunity on Opportunity(before update, before insert, after insert, after update) {
    Map<Id,List<String>> id_addEmails_map = new Map<Id,List<String>>();     //jaina04
    Set<Id> ExpirationDateModifiedAfterApproval = new Set<Id>();         //JAINA04
    Set<Id> oppIdsForResubmissionRejectionEmail = new Set<Id>();       //JAINA04
    Set<Id> oppIdsForResubmissionModifyingEmail = new Set<Id>();       //JAINA04
    List<String> addEmails = null;         //jaina04

    if (SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
        return;
    
    //code to skip opp triggers if update is because of Amount update. - BAJPI01
    Boolean isAmountUpdate = false;
    if(Trigger.isUpdate){
        for(Opportunity opp:trigger.new){
            if(opp.Amount!=trigger.oldMap.get(opp.Id).Amount){
                isAmountUpdate=true;
            }
            else{
                isAmountUpdate = false;
            }
        }
        if(isAmountUpdate==true)
            return;
    }   
    //code to skip opp triggers if update is because of Amount update - BAJPI01
    
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
    Id dealRegOppRecordTypeID = rec.RecordType_Id__c;
    
    rec = RecordTypes_Setting__c.getValues('New Opportunity');
    Id newOppRecordTypeID;
    if(rec!=null)
        newOppRecordTypeID = rec.RecordType_Id__c;

    RecordTypes_Setting__c preOppRec = RecordTypes_Setting__c.getValues('Pre Opportunity');
    string preOppRecType;
    if(preOppRec!=null)
        preOppRecType = preOppRec.RecordType_Id__c;
    
    RecordTypes_Setting__c sbRecType = RecordTypes_Setting__c.getValues('SB_Record_Type');
    string steelBrickRecType;
    if(sbRecType!=null)
        steelBrickRecType = sbRecType.RecordType_Id__c;
    
    RecordTypes_Setting__c entlSync = RecordTypes_Setting__c.getValues('Entitlement_Sync');
    string entlSyncRecType;
    if(entlSync!=null)
        entlSyncRecType = entlSync.RecordType_Id__c;
    
    
    Set < Id > accId = new Set < Id > ();
    List < Opportunity > lstOpp = new List < Opportunity > ();
    List < Opportunity > lstOppPer = new List < Opportunity > ();
    List < Opportunity > lstOpp_Source = new List < Opportunity > ();
    Map < Id, Id > Lead_OppMap = new Map < Id, Id > ();
    Map < Id, Opportunity > OppID_OppMap = new Map < Id, Opportunity > ();
    set < ID > ids = new set < ID > ();
    ExternalSharingHelper sharingHelper = new ExternalSharingHelper();
    /*PartnerAccount Start*/
    Set < Id > partnerAccId = new Set < Id > ();
    List < OpportunityShare > lstOS = new List < OpportunityShare > ();
    List < OpportunityTeamMember > lstOTM = new List < OpportunityTeamMember > ();
    List < AccountShare > lstAS = new List < AccountShare > ();
    /*PartnerAccount End*/
    Set < Id > newOppIds = new Set < Id > ();
    //boolean Layer7Opp = false;
     
    
    //sales team
    set < id > s_accountid_otm = new Set < id > ();
    set < id > s_Distributor_6_otm = new Set < id > ();
    set < id > s_Reseller_otm = new Set < id > ();
    set < id > s_Partner_otm = new Set < id > ();
    set < id > s_Partner_1_otm = new Set < id > ();
    set < id > s_Alliance_Partner_2_otm = new Set < id > ();
    Set < ID > s_serviceProviderClient_otm = new Set < ID > ();
    Map < string, id > mPmfkeyToUserId = new Map < string, id > ();
    Map < id, List < TAQ_Account_Team_Approved__c >> mapAccountIdToPMFkey = new Map < id, List < TAQ_Account_Team_Approved__c >> ();
    map < string, string > m_accountlookup_taqrole = new Map < String, String > {
        'account' => '%', 'account_servprov' => 'PARTN SERVPROV', 'Distributor_6' => 'PARTN SOLPROV',
            'Reseller' => 'PARTN SOLPROV', 'Partner' => 'PARTN SERVPROV', 'Partner_1' => 'PARTN ALLIANCE', 'Service_Provider_Client' => '%', 'Reseller_DM' => 'PARTN DM'
            };
                Map < ID, Account > m_account = new Map < ID, Account > ();
    set < id > s_oppidsforotm = new set < id > ();
    Map < id, user > mUser = new Map < id, user > ();
    Set < String > setpmf = new set < String > ();
    
    //p = 0; //SAMAP01
    
    Map < Id, User > user_IdMap = new Map < Id, User > ();

    //SAMAP01 -US384301 - Get only current user
    User currentuser = Opportunity_ContactRole_Class.currentuserinfo(UserInfo.getUserId());
  
    
    if (Trigger.isUpdate && Trigger.isAfter){
        
        for(Opportunity opp: Trigger.new){
            System.debug('ResubmissionProducts__c  ' + opp.ResubmissionProducts__c);
            String tempuser = userInfo.getUserType(); 
            System.debug('Is partner User? ' + tempuser); 
            if(opp.Additional_Emails__c != null) {
                if(opp.Additional_Emails__c.indexOf(',') != -1) {
                    opp.Additional_Emails__c.addError('Please seperate multiple email addresses by semicolon (;)');
                } else if(opp.Additional_Emails__c.indexOf(';') != -1) {
                    addEmails = new List<String>();
                    addEmails = opp.Additional_Emails__c.split(';');
                    id_addEmails_map.put(opp.Id,addEmails);
                    system.debug('asfd-->' + addEmails);
                    for(String tempEmail : addEmails) {
                        if(!Pattern.matches('[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})',tempEmail.trim())) {
                            opp.Additional_Emails__c.addError('Please enter the email addresses in valid format');
                            break;
                        }
                    } 
                } else if(opp.Additional_Emails__c.length() > 0) {
                    addEmails = new List<String>();
                    addEmails.add(opp.Additional_Emails__c);
                    id_addEmails_map.put(opp.Id,addEmails);
                    if(!Pattern.matches('[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})',opp.Additional_Emails__c))
                        opp.Additional_Emails__c.addError('Please enter the email addresses in valid format'); 
                }
            }
            system.debug('Deal Reg Expiration Date(New)'+Trigger.newMap.get(opp.Id).Deal_Expiration_Date__c);
            system.debug('Deal Reg Expiration Date(Old)'+Trigger.oldMap.get(opp.Id).Deal_Expiration_Date__c);
            system.debug('Deal Reg Status(Old)'+Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c);
            system.debug('Deal Reg Status(New)'+Trigger.NewMap.get(opp.Id).Deal_Registration_Status__c);
            system.debug('Deal Reg Initially Approved(Old)'+Trigger.oldMap.get(opp.Id).Deal_Reg_Initially_Approved__c);
            system.debug('Deal Reg Initially Approved(New)'+Trigger.NewMap.get(opp.Id).Deal_Reg_Initially_Approved__c);
            
            system.debug('opp deal resubmit auto approve from reject(old) ' + Trigger.oldMap.get(opp.Id).Deal_Resubmit_Auto_Approve_From_Reject__c );
            system.debug('opp deal resubmit auto approve from reject(New) ' + Trigger.newMap.get(opp.Id).Deal_Resubmit_Auto_Approve_From_Reject__c );
            Boolean temp2foronemail = checkrunoncev2.runOnce();
            System.debug('tempforonemail ' + temp2foronemail);
            if(Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Rejected' && opp.Deal_Reg_Initially_Approved__c == true ){
                oppIdsForResubmissionRejectionEmail.add(opp.Id);    
                System.debug('Resubmission Added into Set-----> Rejected ');
                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
            }
            if(opp.Deal_Registration_Status__c == 'Sale Approved' && Trigger.newMap.get(opp.Id).Deal_Expiration_Date__c > Trigger.oldMap.get(opp.Id).Deal_Expiration_Date__c && temp2foronemail ==TRUE){
                ExpirationDateModifiedAfterApproval.add(opp.Id);
                System.debug('Expiration Date modified for deal Reg Opp ID ' + opp.Id );
                System.debug('Old Expiration Date ' + Trigger.oldMap.get(opp.Id).Deal_Expiration_Date__c + ' , New Expiration Date : '+ Trigger.newMap.get(opp.Id).Deal_Expiration_Date__c );
            }
             if(((Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying') || (Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying') || (Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'New' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying')) && tempuser != 'PowerPartner' && checkrunoncev3.runOnce()) {
                
                
                oppIdsForResubmissionModifyingEmail.add(opp.Id); 
                //tempforonemail = Checkrunonce.runOnce();
                System.debug('Is partner User? ' + tempuser);                            
                System.debug('Resubmission Added into Set-----> Internal User Modifying the Approved Deal');
                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                System.debug('Usertype of Last Modified '+ opp.LastModifiedBy.UserType);
                 
                 
            }
            
            String tempuserId = opp.LastModifiedById;
            list<User> tempaccountidofuser = new List<User>();
            System.debug('Last modified User ID ' + tempuserId);
            // User temp1 = [select Id from User where Id = :UserInfo.getUserId()];
            // User tempuser = [Select Is_Partner_User__c from User where id=: UserInfo.getUserId()];
            
            Boolean tempforonemail = false;
            System.debug('tempforonemail ' + tempforonemail);
            System.debug('ResubmissionProducts__c  ' + opp.ResubmissionProducts__c);
            system.debug('opp resubmission products old map ' + Trigger.oldMap.get(opp.Id).ResubmissionProducts__c);
            system.debug('opp resubmission products new map ' + Trigger.newMap.get(opp.Id).ResubmissionProducts__c);
            system.debug('Naman partner Opp Deal Reg Eligible Products(old)' + Trigger.oldMap.get(opp.Id).DR_Added_Eligible_Products__c);
            system.debug('Naman Partner Opp Deal Reg Eligible Products(New)' + Trigger.newMap.get(opp.Id).DR_Added_Eligible_Products__c);
            String tempold = '';
            String tempnew= '';
            List<String> Lold = new List<String>();
            List<String> Lnew = new List<String>();
            if(Trigger.oldMap.get(opp.Id).DR_Added_Eligible_Products__c != null && Trigger.newMap.get(opp.Id).DR_Added_Eligible_Products__c != null){
                if (Trigger.oldMap.get(opp.Id).DR_Added_Eligible_Products__c .endsWith(','))     
                {       
                    tempold = Trigger.oldMap.get(opp.Id).DR_Added_Eligible_Products__c.SubString(0,Trigger.oldMap.get(opp.Id).DR_Added_Eligible_Products__c.length()-1);       
                } 
                if (Trigger.newMap.get(opp.Id).DR_Added_Eligible_Products__c .endsWith(','))     
                {       
                    tempnew = Trigger.newMap.get(opp.Id).DR_Added_Eligible_Products__c.SubString(0,Trigger.newMap.get(opp.Id).DR_Added_Eligible_Products__c.length()-1);       
                }
                for(String key :tempold.split(',') ){
                    Lold.add(key);
                }
                for(String key :tempnew.split(',') ){
                    Lnew.add(key);
                }
                
            }
            
            PRM_Email_Notifications p = new PRM_Email_Notifications();
            if(ExpirationDateModifiedAfterApproval.contains(opp.Id)){
                try{
                    System.debug('email will be sent as Expiration Date is modified after Sale Approved');
                    p.sendEmailByUserLocale('Deal Registration', opp.Id, 'Approved-ModifyExpDate', id_addEmails_map.get(opp.Id));
                    
                }  
                catch(Exception e){
                    //Do Nothing
                }
            }
            if(oppIdsForResubmissionModifyingEmail.contains(opp.Id)){
                try{
                    System.debug('Deals modifying after the initial approval');
                    p.sendEmailByUserLocale('Deal Registration', opp.Id, 'Deal Resubmission - Modifying', id_addEmails_map.get(opp.Id));                        
                }catch(Exception e){
                    //do nothing
                }
            }            
            if(oppIdsForResubmissionRejectionEmail.contains(opp.Id) ){
                try{
                    System.debug('Deals Rejected after resubmission');
                    p.sendEmailByUserLocale('Deal Registration', opp.Id, 'Deal Resubmission - Rejected', id_addEmails_map.get(opp.Id));                    
                }catch(Exception e){
                    //do nothing
                }
            }
        }

        //Added for 3186 
        if(trigger.new[0].isdeletePartner__c && !trigger.oldMap.get(trigger.new[0].id).isdeletePartner__c) {
            system.debug('Partner Opportunity Trigger before trigger.new[0] call');
            OpportunityDeleteOverride oppDel = new OpportunityDeleteOverride();
            oppDel.deleteOpp(trigger.new[0].id);
            
        }
    }
    if (Trigger.isBefore) {
        system.debug('Entered 194');
        for (Opportunity opp: Trigger.new) //3258
            if (opp.recordtypeid == newOppRecordTypeID) {
                system.debug('Entered 197');
                //samap01 - US344674 - ACL Load issue
                if ( currentUser != null && currentUser.Is_Partner_User__c == true && opp.source__c == 'Partner' && (opp.Type == '1 Tier' || opp.Type == '2 Tier'  || opp.Type == 'xSP')) { //edited by SAMTU01 - US270100
                    system.debug('Entered 199');
                    opp.Partner_Engagement__c = 'Incremental';
                    
                }
            }
        if(currentUser != null && currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled){
            set<string> oppCloseDateModified = new set<string>();
            set<string> oppCloseDateModifiedID = new set<string>();
            for (Opportunity opp: Trigger.new) {
                //Added for AR 4013 
                if(trigger.isUpdate)system.debug('hi1 in for loop '+opp.Deal_Registration_Program__c+' old close date '+trigger.oldMap.get(opp.id).closeDate+' new close date '+opp.closeDate);
                if(opp.Deal_Registration_Program__c != null && opp.closeDate != trigger.oldMap.get(opp.id).closeDate && trigger.oldMap.get(opp.id).closeDate != null){
                    oppCloseDateModified.add(opp.Deal_Registration_Program__c);
                    oppCloseDateModifiedID.add(opp.id);
                    system.debug('hi1');
                }
                if (opp.id != null && opp.Source__c == null)
                    ids.add(opp.id);           
            }
            if(oppCloseDateModified.size()>0){
                system.debug('hi2'+oppCloseDateModifiedID);
                Map<string,deal_registration_program__c> idProgMap = new Map<string,deal_registration_program__c>([select id,End_Date__c,Finance_Approver_Email__c,Expiry_Days__c from Deal_Registration_Program__c where id in: oppCloseDateModified]);
                system.debug('hi3 prog map'+idProgMap);
                for (Opportunity opp: Trigger.new) {
                    system.debug('hi4');
                    if(oppCloseDateModifiedID.contains(opp.id)){
                        if(opp.CloseDate <= system.today() || opp.CloseDate > (idProgMap.get(opp.Deal_Registration_Program__c).End_Date__c.addDays(Integer.valueOf(idProgMap.get(opp.Deal_Registration_Program__c).Expiry_Days__c)))){
                            system.debug('hi7');
                            opp.addError('The opportunity close date must be greater than todays date and less Deal Program End Date + expiry days.');
                        }
                        system.debug('hi5 expiry days' +idProgMap.get(opp.Deal_Registration_Program__c).Expiry_Days__c+' end date '+idProgMap.get(opp.Deal_Registration_Program__c).End_Date__c+' after adding days '+idProgMap.get(opp.Deal_Registration_Program__c).End_Date__c.addDays(Integer.valueOf(idProgMap.get(opp.Deal_Registration_Program__c).Expiry_Days__c)));
                        if(opp.CloseDate > system.today() && opp.CloseDate < (idProgMap.get(opp.Deal_Registration_Program__c).End_Date__c.addDays(Integer.valueOf(idProgMap.get(opp.Deal_Registration_Program__c).Expiry_Days__c)))){
                            system.debug('hi6');
                            if(trigger.oldMap.get(opp.id).CloseDate <= system.today() || trigger.oldMap.get(opp.id).CloseDate >= (idProgMap.get(opp.Deal_Registration_Program__c).End_Date__c.addDays(Integer.valueOf(idProgMap.get(opp.Deal_Registration_Program__c).Expiry_Days__c)))){
                                system.debug('hi8');
                                opp.isClosedDateFireDealReg__c = false;
                            }
                        }
                    }
                }
            } // AR 4013 ends here 
            
        }
        system.debug('hi');
        system.debug('ids -->' + ids);
        
        if (ids.size() > 0) {
            List < Lead > objLead = [Select l.ConvertedOpportunityId, l.Id from Lead l where l.ConvertedOpportunityId in : ids];
            for (Lead oLead: objLead) {
                Lead_OppMap.put(oLead.ConvertedOpportunityId, oLead.ConvertedOpportunityId);
                system.debug(Lead_OppMap.get(oLead.ConvertedOpportunityId));
            }
        }
        
        for (Opportunity opp: Trigger.new) {
            //when lead is converted to Opportunity                          
            if (Lead_OppMap.size() > 0 && opp.Source__c == null) {
                if (opp.id == Lead_OppMap.get(opp.id))
                    opp.Source__c = 'Lead';
            } else if (currentUser != null && currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled && opp.Source__c == null && opp.RecordTypeId != dealRegOppRecordTypeID) {
                opp.Source__c = 'Partner';
            } else if (opp.RecordTypeId == dealRegOppRecordTypeID && opp.Source__c == null) {
                opp.Source__c = 'Deal Registration'; // to fill source field.
            } else if(opp.RecordTypeId == preOppRecType && opp.Source__c == null) {
                opp.Source__c = 'Direct';
            } else if (opp.Source__c == null) {
                opp.Source__c = 'CA Internal';
            }
            
            //edited by Dorel - Lead Distribution project
            if (( opp.recordtypeid  == newOppRecordTypeID ) &&  // Is this a new opportunity
                ( opp.source__c     == 'Lead' ))                // Is this opp converted from a Lead
            {
                if(opp.Type!=Null){
                if(opp.Type.equalsIgnoreCase('1 Tier')) opp.Transaction_Type_Test__c = 'Resell without a distributor';
                if(opp.Type.equalsIgnoreCase('2 Tier')) opp.Transaction_Type_Test__c = 'Resell with a distributor';
                if(opp.Type.equalsIgnoreCase('xSP'))    opp.Transaction_Type_Test__c = 'Service Provider/Licensee';                    
            
                }    
            }
                
            
            lstOpp_Source.add(opp);
        }
        //amasa03
        //Rally Referral Partner Changes -Lead Management Flow -stamping Referral Date and Referral Partner account to Site Accosiation Record
        if (Trigger.isUpdate){
            List<Site_Association__c> updatesiteassSoldList = new List<Site_Association__c>();
            for (Integer i = 0; i < Trigger.new.size(); i++) {
                if (Trigger.new[i].ARRTotal__c  > 0 && Trigger.new[i].Referral_Site_Association__c != null && Trigger.new[i].StageName == Label.Opp_Stage_Closed_Won && Trigger.new[i].Has_Primary_Quote__c == true &&  Trigger.new[i].Referral_Approval_Status__c == 'Approved' && Trigger.old[i].Referral_Approval_Status__c != Trigger.new[i].Referral_Approval_Status__c){
                    System.debug('After Approval --> '+Trigger.new[i]);
                    System.debug('After Approval old --> '+Trigger.old[i]);
                    //scpq__SciQuote__c  SterlingQuote = new scpq__SciQuote__c();
                    if(Trigger.new[i].Referral_Partner_Account__c != null && Trigger.new[i].Referral_Date__c != null && Trigger.new[i].IsReferral_UpSellUpdate__c == false){
                        System.debug('Lead Management Flow');
                        Site_Association__c siteAcc = new Site_Association__c(id = Trigger.new[i].Referral_Site_Association__c);
                        siteAcc.Referral_Partner_Account__c =Trigger.new[i].Referral_Partner_Account__c;
                        siteAcc.Referral_Date__c =Trigger.new[i].Referral_Date__c;
                        updatesiteassSoldList.add(siteAcc);
                        System.debug('Lead Management Flow  --> '+siteAcc);
                        
                    }
                    
                }
                
            }
            if(updatesiteassSoldList.size() > 0){
                update updatesiteassSoldList;
            }
            
        }
    }
    
    
    // Oct R2014 - Changed the entry condition
    if ((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore) {
        Set < Id > OppId = new Set < Id > ();
        
        if (Trigger.isUpdate)
        {
            for (Opportunity opp: Trigger.new) {
                if (opp.Reseller_Contact__c == null ) {
                    if(opp.Type == 'xSP' && (opp.source__c == 'Partner' ||opp.source__c == 'Deal Registration')){
                        //do nothing
                    }else{
                        if(currentUser != null)   //samap01 - US384301
                            opp.Reseller_Contact__c = currentUser.ContactId;
                    }
                    
                }
                //US384301- samap01- Code optimization //ponse01
                if(trigger.oldMap.get(opp.Id).Deal_Registration_Status__c =='Deal Submitted to CA' && trigger.NewMap.get(opp.Id).Deal_Registration_Status__c =='Sale Approved'){
                    opp.Recordtypeid=newOppRecordTypeID;
                }
            }
        }
        
      
        if (currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled) {
            //Opportunity owner Assignment only for partner Opportunities.
            // US384301 - SAMAP01 -Code optimization --start
            for (Opportunity opp: Trigger.new) {
                if (opp.RecordTypeId == newOppRecordTypeID)
                    ids.add(opp.id);
            }
            if (ids.size() > 0) {
                system.debug('OppId -->' + ids);
                Map < Id, Id > mapOppAccount = new Map < Id, Id > ();
                Map < Id, Id > mapOppPartner = new Map < Id, Id > ();
                Map < Id, Account > mapAccount = new Map < Id, Account > ();
                Map < Id, Account > mapPartnerAccount = new Map < Id, Account > ();
                Map<String, User> user_pmfMap = new Map<String, User>(); 
                Set <Id> accountids = new Set<Id>();
                List<Account> listOfAccounts = new List<Account>();
                String[]  partnerpmfkeys = new String[]{}; //samap01
                for (Opportunity opp: Trigger.new) {
                    accId.add(opp.AccountId);
                    mapOppAccount.put(opp.Id, opp.AccountId);
                    partnerAccId.add(opp.Reseller__c);
                    mapOppPartner.put(opp.Id, opp.Reseller__c);
                    accountids.add(opp.AccountId);
                    accountids.add(opp.Reseller__c);
                }
                System.debug('samap01 -mapOppAccount'+mapOppAccount);
                System.debug('samap01 -mapOppPartner'+mapOppPartner);
                System.debug('samap01 -accountids'+accountids);
                System.debug('samap01 -partnerAccId'+partnerAccId);
                
                //Get accounts
                if(accountids != null && accountids.size()>0) 
                {
                    
                    listOfAccounts = Opportunity_ContactRole_Class.accountslist(accountids);
                   /* listOfAccounts  =[SELECT Id, Name, OwnerId, Segment__c, RecordType.Name, Solution_Provider_CAM_PMFKey__c, Service_Provider_CAM_PMFKey__c,
                      Velocity_Seller_CAM_PMFKey__c,Account.Coverage_Model__c , Alliance_CAM_PMFKey__c from Account where Id in : accountids];*/
                     if(listOfAccounts !=null && listOfAccounts.size()>0   )
                {
                    for (Account Acc: listOfAccounts) {
                        if(accId!= null && accId.contains(Acc.id))
                        {
                              mapAccount.put(Acc.Id, Acc); 
                        }                  
                     
                        if(partnerAccId != null && partnerAccId.contains(Acc.id))
                        {
                            mapPartnerAccount.put(Acc.Id, Acc);
                            if( Acc.Solution_Provider_CAM_PMFKey__c != null)  
                            {
                                partnerpmfkeys.add(Acc.Solution_Provider_CAM_PMFKey__c); 
                                System.Debug('partner pmfkey'+Acc.Solution_Provider_CAM_PMFKey__c );
                            }
                        }
                        
                    }
                }
                 System.debug('samap01 -mapAccount'+mapAccount);
                 System.debug('samap01 -mapPartnerAccount'+mapPartnerAccount);
                
                IF(partnerpmfkeys != null && partnerpmfkeys.size()>0)
                {
                   /* List<User> partneruserlst = [Select id,UserType, ContactId, Is_Partner_User__c, IsPortalEnabled, AccountId,
                                      contact.Account.Solution_Provider_CAM_PMFKey__c, PMFKey__c, Title from user   
                                      where Isactive=true AND usertype NOT IN ('CSPLitePortal','CsnOnly')  and PMFKey__c IN : partnerpmfkeys];*/
                    for(User objCS : Opportunity_ContactRole_Class.partneruserlist(partnerpmfkeys) )
                   //for(User objCS : partneruserlst )
                        user_pmfMap.put(objCS.PMFKey__c, objCS);
                }
                   System.debug('user_pmfMap' +user_pmfMap);
                }
               
               
          
                List < Opportunity > finalilst = new List < Opportunity > ();
                for (Opportunity opp: Trigger.new) {
                    Account tempAccount = new Account();
                    tempAccount = mapAccount.get(mapOppAccount.get(opp.Id));
                    Account tempPartnerAccount = new Account();
                    tempPartnerAccount = mapPartnerAccount.get(mapOppPartner.get(opp.Id));
                    system.debug('mapOppPartner.get(opp.Id) --> ' + mapOppPartner.get(opp.Id));
                    
                    system.debug('tempPartnerAccount --> ' + tempPartnerAccount);
                    
                    // Oct R2014 - Changed condition to below two if
                    if (trigger.isInsert || trigger.oldMap.get(opp.Id).AccountId != trigger.newMap.get(opp.Id).AccountId) {
                        System.debug('Trigger insert fired');
                        if (tempAccount != null && tempAccount.Coverage_Model__c == 'Account Team') {
                            system.debug('tempAccount.Id - > ' + tempAccount.Id);
                            system.debug('tempAccount.RecordType.Name - > ' + tempAccount.RecordType.Name);
                            system.debug('tempAccount.OwnerId - > ' + tempAccount.OwnerId);
                            opp.OwnerId = tempAccount.OwnerId;
                        } // Oct R2014 - Changed condition to below if
                        else {
                            if (mapPartnerAccount.size() > 0) {
                                System.debug('mappartneracccount has values');
                                if (tempPartnerAccount != null && tempPartnerAccount.Solution_Provider_CAM_PMFKey__c != null) {
                                    user uDM;
                                    if (user_pmfMap != null && user_pmfMap.get(tempPartnerAccount.Solution_Provider_CAM_PMFKey__c) != null){
                                        System.debug('samap01 user_pmfMap' +user_pmfMap);
                                        uDM = user_pmfMap.get(tempPartnerAccount.Solution_Provider_CAM_PMFKey__c);
                                        opp.OwnerId = uDM.Id; 
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
  
    
    
    if (Trigger.isAfter && Trigger.isInsert && (currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled)) {
        
        for (Opportunity opp: Trigger.new) {
            {
                
                System.debug('Comment inside PartnerOpp in AfterInsert. Opp Owner id: ' + opp.OwnerId);
                System.debug('Comment inside PartnerOpp in AfterInsert. currentUser id: ' + currentUser.Id);
                addOppTeamMember(currentUser.Id, opp.Id, 'Partner');
                
                system.debug('partnerOpportunity - isAfter and isUpdate');
                
                fetchSalesTeamfromTAQ(opp);
                addOppTeamMember(opp.OwnerId, opp.Id, 'Owner');
                //sales team from TAQ - start
                System.debug('In PartnerOpportunity - AccountId is:' + opp.AccountId);
                if (opp.AccountId != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.AccountId, '');
                }
                if (opp.Reseller_Contact__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Reseller_Contact__c, '');
                }
                if (opp.End_User_Contact__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.End_User_Contact__c, '');
                    
                }
                if (opp.Service_Provider_Client__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Service_Provider_Client__c, '');
                    
                }
                if (opp.Reseller__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Reseller__c, 'TAQ-PARTN SOLPROV');
                }
                if (opp.Partner_1__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Partner_1__c, 'TAQ-PARTN ALLIANCE');
                    
                    
                }
                
                
                if (opp.Alliance_Partner_2__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Alliance_Partner_2__c, 'TAQ-PARTN ALLIANCE');
                    
                }
                
                if (opp.Distributor_6__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Distributor_6__c, 'TAQ-PARTN SOLPROV');
                    
                }
                if (opp.partner__c != null) {
                    addlistOpportunityTeamMemberfromTAQ(opp.id, opp.Partner__c, 'TAQ-PARTN SERVPROV');
                }
            }
            //sales team from TAQ - end
        }
        
        //Insert users into Opportunity Sales Team
        try {
            if (lstOTM.size() > 0) //Common for All Opp Team additions
            {
                //Ar 3785
                opportunityteamMember otmOwner = new opportunityteamMember();
                for(opportunityteamMember oppTeamMem : lstOTM){
                    if(oppTeamMem.TeamMemberRole =='Owner'){
                        otmOwner.TeamMemberRole = 'Owner';
                        otmOwner.OpportunityId  = oppTeamMem.OpportunityId;
                        otmOwner.UserId = oppTeamMem.UserId;
                    }
                }//Ar 3785 ends
                System.debug('inside insert--' + lstOTM);
                Database.SaveResult[] MySaveResult = Database.insert(lstOTM, false);
                
                for (integer i = 0; i < MySaveResult.size(); i++) {
                    database.SaveResult sr = MySaveResult[i];
                    System.debug('____sr____in partner opporutnity***** ' + sr);
                }
                for (OpportunityTeamMember ot: lstOTM)
                    system.debug('ot.id-' + ot.id);
                if(otmOwner.UserId != null) upsert otmOwner; //Ar 3785
                lstOTM = new List < OpportunityTeamMember > ();
                
            }
            if (lstOS.size() > 0) //Common for All Opp Team additions
            {
                
                system.debug('Debug for shares 1' + lstOS);
                Database.saveResult[] MySaveResult1 = Database.insert(lstOS, false);
                for (integer i = 0; i < MySaveResult1.size(); i++) {
                    database.saveResult sr1 = MySaveResult1[i];
                    System.debug('____sr1____in partner opporutnity***** ' + sr1);
                }
                lstOS = new List < OpportunityShare > ();
                
            }
            
            
            
            
        } catch (Exception ex) {
            System.debug('*****Exception ***' + ex);
        }
    }
    
    
    public void addOppTeamMember(id userid, id oppid, string teamrole) {
        
        System.debug('_____Inside addOppTeamMember in partner opporutnity***** ____');
        
        set < id > suserid = new set < id > ();
        if (suserid.contains(userid) <> true) {
            OpportunityTeamMember otm = new OpportunityTeamMember();
            otm.TeamMemberRole = teamrole;
            otm.OpportunityId = oppid;
            otm.UserId = userid;
            lstOTM.add(otm);
            
            OpportunityShare os = new OpportunityShare();
            os.OpportunityId = oppid;
            os.UserOrGroupId = userid;
            os.OpportunityAccessLevel = 'edit';
            lstOS.add(os);
        }
        System.debug('_____lstOTM size____' + lstOTM.size());
        System.debug('_____lstOS size____' + lstOS.size());
        System.debug('_____lstOS ____' + lstOTM);
        System.debug('_____lstOS ____' + lstOS);
    }
    
    
    public void fetchSalesTeamfromTAQ(Opportunity opp) {
        {
            //Sales Team from Account Lookups -start
            if (opp.AccountId != null)
                s_accountid_otm.add(opp.AccountId);
            
            if (opp.Reseller__c != null)
                s_Reseller_otm.add(opp.Reseller__c);
            
            if (opp.Partner_1__c != null)
                s_Partner_1_otm.add(opp.Partner_1__c);
            
            if (opp.Alliance_Partner_2__c != null)
                s_Alliance_Partner_2_otm.add(opp.Alliance_Partner_2__c);
            
            if (opp.Distributor_6__c != null)
                s_Distributor_6_otm.add(opp.Distributor_6__c);
            
            if (opp.partner__c != null)
                s_Partner_otm.add(opp.partner__c);
            
            if (opp.Service_Provider_Client__c != null)
                s_serviceProviderClient_otm.add(opp.Service_Provider_Client__c);
            
            if ((opp.AccountId != null) ||
                (opp.Reseller__c != null) ||
                (opp.Partner_1__c != null) ||
                (opp.Alliance_Partner_2__c != null) ||
                (opp.Distributor_6__c != null) ||
                (opp.partner__c != null) ||
                (opp.Service_Provider_Client__c != null)
               ) {
                   s_oppidsforotm.add(opp.id); //lst of all opps where sales team needs to be added 
               }
            //Sales Team from Account Lookups -end
            
            System.debug('___999___' + (s_accountid_otm.size() + s_Distributor_6_otm.size() + s_Reseller_otm.size() + s_Alliance_Partner_2_otm.size() + s_Partner_1_otm.size() + s_Partner_otm.size() + s_serviceProviderClient_otm.size()));
            if ((s_accountid_otm.size() + s_Distributor_6_otm.size() + s_Reseller_otm.size() + s_Alliance_Partner_2_otm.size() + s_Partner_1_otm.size() + s_Partner_otm.size() + s_serviceProviderClient_otm.size()) > 0) //No processing if no relevant account id
            {
                System.debug('------*****************-----' + s_accountid_otm);
                
                Set < string > spmfkey_temp;
                mapAccountIdToPMFkey = new Map < id, List < TAQ_Account_Team_Approved__c >> ();
                //SOQL  - Get the TAQ Account Team records for all the Account lookups
                System.debug('------*****************-----' + s_serviceProviderClient_otm);
                System.debug('------*****************-----' + s_Distributor_6_otm);
                System.debug('------*****************-----' + s_Partner_1_otm);
                System.debug('------*****************-----' + s_Alliance_Partner_2_otm);
                System.debug('------*****************-----' + s_Partner_otm);
                System.debug('------*****************-----' + s_Reseller_otm);
                System.debug('------*****************-----' + m_accountlookup_taqrole);
                
                m_account = new Map < ID, Account > ([Select Solution_Provider__c, Velocity_Seller__c, Service_Provider__c, Alliance__c
                                                      from Account Where Id in : s_accountid_otm
                                                      or Id IN: s_Reseller_otm
                                                     ]);
                
                System.debug('____11aa_Din partner opporutnity***** ___' + s_accountid_otm);

                list<TAQ_Account_Team_Approved__c> taqteamapr=new list<TAQ_Account_Team_Approved__c>();
                if(s_accountid_otm.size()>0){
                    taqteamapr=[select TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.RecordType.Name, id, PMFKey__c, taq_Role__c, TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c from TAQ_Account_Team_Approved__c
                                where
                                TAQ_Account_Approved__r.TAQ_Account__c <> null AND
                                TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c <> null AND(
                                    (
                                        TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_accountid_otm AND(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.RecordType.Name in ('SMB', 'Account Team Covered Account', 'Territory Covered Account') OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.RecordType.Name = 'Reseller/Distributor Account'
                                                                                                                                                                                                                                                                                AND(
                                                                                                                                                                                                                                                                                    (TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.Service_Provider__c = True and TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.Velocity_Seller__c = False AND Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('account_servprov'))) //Added Condition for Service Provider Partners
                                                                                                                                                                                                                                                                                    OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.Velocity_Seller__c = True AND TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.Service_Provider__c = False AND Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Reseller_DM'))) //Added Condition for DM
                                                                                                                                                                                                                                                                                    OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.Service_Provider__c = True AND TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.Velocity_Seller__c = True and(Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('account_servprov')) OR Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Reseller_DM')))) //Added Condition for Hybrid DM, Serv Provider  
                                                                                                                                                                                                                                                                                ) //End of AND
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                               ))
                                    )
                                    
                                    OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_serviceProviderClient_otm AND TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__r.RecordType.Name in ('SMB', 'Account Team Covered Account', 'Territory Covered Account')) OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_Distributor_6_otm AND Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Distributor_6'))) OR(
                                        TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_Reseller_otm AND(
                                            Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Reseller')) or Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Reseller_DM'))
                                        )
                                    ) OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_Partner_1_otm AND Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Partner_1'))) OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_Alliance_Partner_2_otm AND Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Partner_1'))) OR(TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c in : s_Partner_otm AND Partner_Role__c INCLUDES(: m_accountlookup_taqrole.get('Partner')))
                                )
                                AND
                                TAQ_Account_Approved__r.Is_Latest_Record__c = true
                               ];
                }
                if(taqteamapr.size()>0){
                    for (TAQ_Account_Team_Approved__c atm: taqteamapr) {
                        System.debug(atm.id + '____into this loop' + atm.pmfkey__c);
                        mapAccountIdtoPMFkey = getmapAccountIdtoPMFkey(atm, mapAccountIdtoPMFkey);
                        setpmf.add(atm.pmfkey__c.toUpperCase());
                    }
                }
                mPmfkeyToUserId = new Map < String, id > ();
            }
        }
        
    }
    
    
    public Map < id, List < TAQ_Account_Team_Approved__c >> getmapAccountIdtoPMFkey(TAQ_Account_Team_Approved__c atm, Map < id, List < TAQ_Account_Team_Approved__c >> mAccountToPMFkeyMatch) {
        List < TAQ_Account_Team_Approved__c > listPmfkey_temp = mapAccountIdtoPMFkey.get(atm.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c);
        if (listPmfkey_temp == null) {
            listPmfkey_temp = new List < TAQ_Account_Team_Approved__c > ();
        }
        listPmfkey_temp.add(atm);
        mapAccountIdtoPMFkey.put(atm.TAQ_Account_Approved__r.TAQ_Account__r.View_Acc_Record__c, listPmfkey_temp);
        return mapAccountIdtoPMFkey;
    }
    
    public void addlistOpportunityTeamMemberfromTAQ(id oppid, id accountid, String role) {
        List < TAQ_Account_Team_Approved__c > listPmfkey_temp = mapAccountIdtoPMFkey.get(accountid);
        System.debug('PartnerOppertunity___xxx___' + mapAccountIdtoPMFkey);
        System.debug('____1 if____' + listPmfkey_temp);
        System.debug('____2 if____' + accountid);
        system.debug('>>>>>>>>____set' + setpmf);
        set < id > setuid = new set < id > ();
        if (setpmf.size() > 0) //Sales Team + Quote Request
        {
            //SOQL - Retrieve user id for the TAQ Account Team PMFkey 
            mUser = new Map < id, User > ([select id, name, pmfkey__c from user where pmfkey__c in : setpmf and pmfkey__c <> null and isActive = true]);  
            for (user u: mUser.values())
                mPmfkeyToUserId.put(u.pmfkey__c.touppercase(), u.id);
        }
        if (listPmfkey_temp <> null && listPmfkey_temp.size() > 0) {
            for (TAQ_Account_Team_Approved__c taqatm: listPmfkey_temp) {
                System.debug('____for___');
                if (mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()) <> null) {
                    System.debug('___meth call');
                    
                    Opportunity Opp = (Opportunity) Trigger.newMap.get(oppid);
                    if (Opp.Reseller__c == accountid || Opp.Distributor_6__c == accountid) {
                        If(
                            ((opp.Type == '1 Tier' || opp.Type == '2 Tier' || opp.Type == 'Direct' || opp.Type == 'xSP' || opp.Type == 'Direct') && (taqatm.taq_role__c == 'TAQ-PARTN SOLPROV' || taqatm.taq_role__c == 'TAQ-PARTN SERVPROV' || taqatm.taq_role__c == 'TAQ-PARTN ALLIANCE')))//edited by SAMTU01 - US270100
                            addOppTeamMember(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()), oppid, taqatm.taq_role__c);
                        
                        Else
                            if ( Opp.Type != '1 Tier' && Opp.Type != '2 Tier' && Opp.Type != 'Direct' && Opp.Type != 'xSP' && opp.Type != 'Direct')//edited by SAMTU01 - US270100
                            addOppTeamMember(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()), oppid, taqatm.taq_role__c);
                    }
                    Else
                        addOppTeamMember(mPmfkeyToUserId.get(taqatm.pmfkey__c.toUpperCase()), oppid, taqatm.taq_role__c);
                    
                }
            }
        }
        
    }
    
    system.debug('tempAccount.Id - > ' + UserInfo.getUserId());
       //AR 3159 and AR3157 by YEDRA01 
    Set < id > OppAccIds = new Set < id > ();
    List < account > accList = new List < account > ();
    set < id > oppids = new set < id > ();
    Map < id, account > idAccountMap = new Map < id, account > ();
    for (opportunity opp: trigger.new) {
        OppAccIds.add(opp.accountId);
        if (trigger.isupdate)
            oppids.add(opp.id);
    }
    if (OppAccIds != null && OppAccIds.size() > 0) 
      //  accList = [select id, Sales_Area__c,Sales_Region__c,Region_Country__c from account where id in : OppAccIds];
    accList = Opportunity_ContactRole_Class.accountslist(OppAccIds);
    for (Account acc: accList) {
        idAccountMap.put(acc.id, acc);
    }
    //samap01 
   
    map < id, Integer > PERcount = new map < id, Integer > ();
    list<Partner_Engagement_Program__c> partnerEP=new list<Partner_Engagement_Program__c>();
    if(oppids.size()>0){
     // SAMAP01-US384301   partnerEP=[select id, Parent_Opportunity__c from Partner_Engagement_Program__c where Parent_Opportunity__c in : oppids limit 50000];
       partnerEP =  Opportunity_ContactRole_Class.partneropplist(oppids);
    }
    if(partnerEP.size()>0){
        for (Partner_Engagement_Program__c per: partnerEP)
            if (PERcount.get(per.Parent_Opportunity__c) != null) {
                integer cou = 0;
                cou = PERcount.get(per.Parent_Opportunity__c) + 1;
                PERcount.put(per.Parent_Opportunity__c, cou);
            } else {
                PERcount.put(per.Parent_Opportunity__c, 1);
            }
    }
    if ((trigger.isbefore && trigger.isinsert) || (trigger.isafter && trigger.isupdate))
        for (opportunity opp: Trigger.new) {
            system.debug('got');
            system.debug('user type'+currentUser.UserType);
            system.debug('portal'+currentUser.IsPortalEnabled);
            if (currentUser.UserType != 'PowerPartner' && !currentUser.IsPortalEnabled) {
                if (trigger.isinsert) {
					system.debug('opp.recordtypeid---------------'+opp.RecordTypeId);
                    if (idAccountMap != null && idAccountMap.get(opp.AccountId) != null && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_SA)&& (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_MIDIS) && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_MIDISCEN)&&(idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_RUSSIA)&&(idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_SEE) && (idAccountMap.get(opp.AccountId).Region_Country__c != 'ISRAEL') && opp.Opportunity_Type__c != 'Renewal' && opp.RecordTypeId!=label.PER_Validation_recordtype) {
                        system.debug('opportunity values :' + opp);
                        system.debug('got it' + opp.Partner_Engagement__c);
                        if ((opp.type == 'Direct' || opp.type == '1 tier' || opp.type == '2 tier') && opp.Partner_Engagement__c != null && opp.Partner_Engagement__c != '' && opp.Partner_Engagement__c != 'None') {
                            opp.adderror('For 1 Tier and 2 Tier Opportunities, the Partner engagement cannot be changed. Please create a Partner Engagement request');
                            system.debug('got' + opp.Partner_Engagement__c);
                        }
                        
                        
                        system.debug('type'+opp.type);
                        system.debug('Skip PER Validation'+opp.SkipPERValidation__c);
                        system.debug('Sales Region'+idAccountMap.get(opp.AccountId).Sales_Region__c);
                        system.debug('trans type'+opp.Opportunity_Type__c);
                        system.debug('Sales region 2'+opp.account.Sales_Region__c);
                        
                        if ((opp.type == '1 Tier' || opp.type == '2 Tier') && !opp.SkipPERValidation__c && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_SA) && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_MIDIS) && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_MIDISCEN)&&(idAccountMap.get(opp.AccountId).Sales_Region__c !=label.FY19_Salesregion_RUSSIA)&&(idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_SEE) && (idAccountMap.get(opp.AccountId).Region_Country__c != 'ISRAEL')  && (opp.SBQQ__AmendedContract__c==null && opp.SBQQ__RenewedContract__c==null) ) {
                            opp.adderror('For 1 Tier and 2 Tier Transactions :The Partner must create  the Opportunity from the Partner Portal.<br/> If this is a Collaborative or Fulfillment Opportunity  then it  must be created as Direct with Partner Engagement Request.', false);
                        }
                    }
                }
                if (trigger.isupdate) {
                    //system.debug('sales region-------'+idAccountMap.get(opp.AccountId).Sales_Region__c);
                    system.debug('opp type__C---------------'+opp.Opportunity_Type__c);
					system.debug('opp.recordtypeid---------------'+opp.RecordTypeId);
                    if (idAccountMap != null && idAccountMap.get(opp.AccountId) != null && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_SA) && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_MIDIS) && (idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_MIDISCEN)&&(idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_RUSSIA)&&(idAccountMap.get(opp.AccountId).Sales_Region__c != label.FY19_Salesregion_SEE) && (idAccountMap.get(opp.AccountId).Region_Country__c != 'ISRAEL') && opp.Opportunity_Type__c != 'Renewal' && opp.Recordtypeid!=label.PER_Validation_recordtype) {
                        system.debug('opportunity values :' + opp);
                        date d = Date.newInstance(2015, 7, 11);
                        System.debug(opp.createddate + '@@' + d);
                        if (opp.createddate > d)
                            system.debug('creted later');
                        else
                            system.debug('creted Before');
                        
                        system.debug('type'+opp.type);
                        system.debug('opp.Partner_Engagement__c-------'+opp.Partner_Engagement__c);
                        system.debug('opp.SkipPERValidation__c-------'+opp.SkipPERValidation__c);
                        system.debug('opp.Source__c-------'+opp.Source__c);
                        
                        if (PERcount.get(opp.id) != null && PERcount.get(opp.id) > 0) {
                            
                            
                            
                            if ((opp.type == 'Direct' || opp.type == '1 Tier' || opp.type == '2 Tier') && (opp.Partner_Engagement__c == 'Collaborative' || opp.Partner_Engagement__c == 'Fulfillment-Only' || opp.Partner_Engagement__c == 'Pending') && (opp.Reseller__c != trigger.oldmap.get(opp.id).Reseller__c || opp.Reseller_Contact__c != trigger.oldmap.get(opp.id).Reseller_Contact__c) && !opp.SkipPERValidation__c)
                                opp.adderror('Partner & Partner Contact cannot be modified when a Partner Engagement is Pending or Approved .');
                            if ((opp.type == 'Direct' || opp.type == '1 Tier' || opp.type == '2 Tier') && (opp.Partner_Engagement__c == 'Collaborative' || opp.Partner_Engagement__c == 'Fulfillment-Only' || opp.Partner_Engagement__c == 'Pending') && (opp.Distributor_6__c != trigger.oldmap.get(opp.id).Distributor_6__c || opp.Distributor_Contact__c != trigger.oldmap.get(opp.id).Distributor_Contact__c) && !opp.SkipPERValidation__c)
                                opp.adderror('Distributor & Distributor Contact cannot be modified when a Partner Engagement is Pending or Approved.');
                            
                            if (opp.Partner_Engagement__c != trigger.oldmap.get(opp.id).Partner_Engagement__c && (opp.type == '1 tier' || opp.type == '2 tier' || opp.type == 'Direct') && !opp.SkipPERValidation__c)
                                opp.adderror('Partner Engagement cannot be modified. A Partner Engagement request is already pending approval or approved.');
                            
                            if (opp.type != trigger.oldmap.get(opp.id).type && (trigger.oldmap.get(opp.id).type == 'Direct') && (opp.type == '1 tier' || opp.type == '2 tier') && !opp.SkipPERValidation__c && opp.Partner_Engagement__c == null)
                                opp.adderror('Transaction Type cannot be changed from direct to 1 tier or 2 tier. Please create a Partner Engagement request');
                            //system.debug('trigger.oldmap.get(opp.id).type+opp.type'+trigger.oldmap.get(opp.id).type+' '+opp.type+' '+opp.SkipPERValidation__c    );
                            
                            
                            if (opp.type != trigger.oldmap.get(opp.id).type && (trigger.oldmap.get(opp.id).type == 'Direct') && (opp.type == '1 tier' || opp.type == '2 tier') && !opp.SkipPERValidation__c && opp.Partner_Engagement__c != null)
                                opp.adderror('Transaction Type cannot be changed.Partner Engagement Request already Approved or Pending approval.');
                            
                            else if (opp.type != trigger.oldmap.get(opp.id).type && ((trigger.oldmap.get(opp.id).type == '1 tier' || trigger.oldmap.get(opp.id).type == '2 tier')) && !opp.SkipPERValidation__c)
                                opp.adderror('The Transaction Type cannot be modified. A Partner Engagement Request is already Approved or Pending Approval.');
                            else if (opp.type != trigger.oldmap.get(opp.id).type && (trigger.oldmap.get(opp.id).type == '1 tier' && opp.type == '2 tier') && !opp.SkipPERValidation__c)
                                opp.adderror('The Transaction Type cannot be modified. A Partner Engagement Request is already Approved or Pending Approval.');
                            else if (opp.type != trigger.oldmap.get(opp.id).type && (trigger.oldmap.get(opp.id).type == '2 tier' && opp.type == '1 tier') && !opp.SkipPERValidation__c)
                                opp.adderror('The Transaction Type cannot be modified. A Partner Engagement Request is already Approved or Pending Approval.');
                            else if (opp.type != trigger.oldmap.get(opp.id).type && (opp.type == '1 tier' || opp.type == '2 tier')&& opp.Source__c != 'Lead' && !opp.SkipPERValidation__c)
                                opp.addError('For 1 Tier and 2 Tier Transactions :The Partner must create  the Opportunity from the Partner Portal.<br/> If this is a Collaborative or Fulfillment Opportunity  then it  must be created as Direct with Partner Engagement Request.', false);
                            
                        } else if (opp.type != trigger.oldmap.get(opp.id).type && (opp.type == '1 tier' || opp.type == '2 tier') && opp.Source__c != 'Lead' && !opp.SkipPERValidation__c && opp.createddate > d)
                            opp.addError('For 1 Tier and 2 Tier Transactions :The Partner must create  the Opportunity from the Partner Portal.<br/> If this is a Collaborative or Fulfillment Opportunity  then it  must be created as Direct with Partner Engagement Request.', false);
                        else if (opp.type != trigger.oldmap.get(opp.id).type && (opp.type == '1 tier' || opp.type == '2 tier') && trigger.oldmap.get(opp.id).type == 'Direct' && !opp.SkipPERValidation__c && opp.createddate < d)
                            opp.addError('For 1 Tier and 2 Tier Transactions :The Partner must create  the Opportunity from the Partner Portal.<br/> If this is a Collaborative or Fulfillment Opportunity  then it  must be created as Direct with Partner Engagement Request.', false);
                        
                    }
                    
                }
            }
        }
    
    //Added for AR : 3729
    if ((trigger.isbefore) && (trigger.isupdate) && !Opportunity_ContactRole_Class.userIsBypass) {
        
        /*Moved code from Opportunity_ContactRole trigger to reduce number of queries. Inactivated the Trigger*/
        if (Trigger.isInsert) {
            for (Opportunity o: Trigger.new)
                Opportunity_ContactRole_Class.insertedOpps.add(o.Id);
            
            System.debug('+1 ' + Opportunity_ContactRole_Class.insertedOpps);
        } else {
            Integer fyMonth = Opportunity_ContactRole_Class.fymonth;
            Integer fyYear = System.today().year();
            
            
            Set < Id > updatedOpps = new Set < Id > ();
            for (Opportunity o: Trigger.new) {
                if (o.createddate == o.lastmodifieddate) return;
                Integer closemonth = o.closedate.month();
                Integer closeyear = o.closedate.year();
                if ((o.Probability >= 20 && o.Probability != 100) || (o.Probability == 100 && ((closemonth >= fymonth && closeyear == fyyear) || (closemonth < fymonth && closeyear == fyyear + 1))) && !Opportunity_ContactRole_Class.insertedOpps.contains(o.Id))
                    updatedOpps.add(o.Id);
            }
            System.debug('upadted opps valid: ' + updatedOpps);
            
            if (!updatedOpps.isEmpty()) {
                Set < Id > oppsWithPrimaryContact = new Set < Id > ();
                for (OpportunityContactRole ocr: [SELECT OpportunityId
                                                  FROM OpportunityContactRole
                                                  WHERE IsPrimary = true
                                                  AND OpportunityId In: updatedOpps
                                                 ]) {
                                                     oppsWithPrimaryContact.add(ocr.OpportunityId);
                                                     System.debug('Ocr Opp Id: ' + ocr.OpportunityId);
                                                 }
                
                for (Opportunity o: Trigger.new) {
                    Integer closemonth = o.closedate.month();
                    Integer closeyear = o.closedate.year();
                    System.debug('oppsWithPrimaryContact : ' + oppsWithPrimaryContact);
                    if ((o.Probability >= 20 && o.Probability != 100 && o.SBQQ__Renewal__c == false)|| (o.Probability >= 30 && o.Probability != 100) || (o.Probability == 100 && ((closemonth >= fymonth && closeyear == fyyear) || (closemonth < fymonth && closeyear == fyyear + 1))) && !Opportunity_ContactRole_Class.insertedOpps.contains(o.Id)){  
                        if (!oppsWithPrimaryContact.contains(o.Id)) {
                            //if (currentUser.UserType != 'PowerPartner' && !currentUser.IsPortalEnabled) { //Removed for AR3730
                            if(o.SkipPERValidation__c == trigger.oldMap.get(o.id).SkipPERValidation__c && OpportunityHandler.renewalToOppConversion != true) { //Added for AR 3851 //Modified by SAMTU01 - US149780
                                System.debug('Opp checking with ' + o.Id);
                                o.addError('No Primary Contact Exists. Please go to the Contact Role and select a primary contact');
                            }
                            //}
                            
                        }
                    }
                    
                    
                }
                
                System.debug('+2 ' + Opportunity_ContactRole_Class.insertedOpps);
            }
        }
    }
    
    //ponse01 ----start-----------------------------------
    
    list<Opportunitylineitem> opllist= new list<Opportunitylineitem>();
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        string prodstr;
        list<string> prodstring = new list<string>();
        set<id> oppliset= new set<id>();
        id prodlineitemid;
        string refined;
        for(opportunity op:Trigger.New){
            system.debug('---Deal_Approval_Status__c-------'+op.Deal_Approval_Status__c);
            if(op.Deal_Approval_Status__c=='Deal Rejected'){
                system.debug('---Deal Rejected-------');
                
                if(op.DR_Added_Eligible_Products__c!=null && op.DR_Added_Eligible_Products__c!= ''){
                    system.debug('---DR_Added_Eligible_Products__c-------');
                    
                    prodstr=op.DR_Added_Eligible_Products__c;
                    
                }
            }
        }
        
        
        if(prodstr!= null){
            prodstring=prodstr.split(',');
            for(string sr:prodstring){
                system.debug('sr----'+sr);
                refined= sr.removeEnd('|YES');
                system.debug('sr-rem----'+refined);
                prodlineitemid=Id.valueOf(refined);
                system.debug('prodlineitemid----'+prodlineitemid);
                oppliset.add(prodlineitemid);
                system.debug('oppliset----'+oppliset);
            }
        }
        
        system.debug('oppliset----'+oppliset.size());
        if(oppliset.size()>0){
            opllist=[select id,opportunity.DR_Added_Eligible_Products__c ,RejectedByCA__c from Opportunitylineitem where id IN:oppliset and RejectedByCA__c!=true];
            system.debug('opllist---------'+opllist);
        }
        system.debug('opllist---------'+opllist.size());
        if(opllist.size()>0){
            list<Opportunitylineitem> opllist1=new list<Opportunitylineitem>();
            for(Opportunitylineitem oplli:opllist){
                if(oplli.opportunity.DR_Added_Eligible_Products__c!= null){
                    oplli.RejectedByCA__c=true;
                    opllist1.add(oplli);
                }  
            }
            system.debug('opllist1---------'+opllist1);
            system.debug('opllist1---------'+opllist1.size());
            if(opllist1.size()>0 && Booleanclass.intiallyfired==false){
                update opllist1;
                Booleanclass.intiallyfired=true;
            }
            
        }
         //JAINA04 Starts
        if(currentUser != null && currentUser.UserType == 'PowerPartner' && currentUser.IsPortalEnabled){
            
            Set<Id> oppid = new Set<Id>();
            for(opportunity op:Trigger.New){
                if((Trigger.oldMap.get(op.id).Type != Trigger.newMap.get(op.id).Type || Trigger.oldMap.get(op.id).What_is_your_Role__c != Trigger.newMap.get(op.id).What_is_your_Role__c || Trigger.oldMap.get(op.id).AccountId != Trigger.newMap.get(op.id).AccountId) && (op.source__c == 'Partner' ||op.source__c == 'Deal Registration')){
                    oppid.add(op.id);
                }               
                
            }
            if(oppid.size()>0){
                list<opportunitylineitem> opplineitem = [select id from opportunitylineitem where opportunityId IN:oppid ];
                try{
                        delete opplineitem;
                        
                    }
                    catch(Exception e){
                        System.debug('Exception is -----' + e);
                    }
            }
            
            
        }
        
        //Jaina04 Ends
    }
   
    //ponse01 ----end-----
    
}