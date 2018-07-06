public with sharing class DE_ConverLead_cls {

    public Lead leadrec {get; set;}

     public Lead leadlst{get;set;}
    public boolean flag{get;set;}
    public boolean flag1{get;set;}
    public boolean flag2{get;set;}
    public boolean flag3{get;set;}
    public boolean flag4{get;set;}
    public boolean flag5{get;set;}
    
    public boolean flag7{get;set;}
    public lead lds{get;set;}
       public ID ConId{get;set;}
    
     
   
    public List<Account> leadCAAccountIDExists {get; set;}
     public List<opportunity> opplst {get; set;}
    
    public boolean IsSendEmailChecked {get; set; }
    public String endUserAccountName { get; set; }
     
    public string hdnAccountId{get;set;}
    public boolean isOpportunityCreate {get;set;}
    public boolean ExistingContact{get;set;}
    public boolean setSendNotificationEmail {get; set; }
    public String opprName { get; set; } 
    public String selctedConvertedStatus { get; set; }
    public Task taskrec { get; set; }
    public ID OppId { get; set; }
    
    public static String splChar = '-';
    public boolean isLeadOwnerActive;
    public boolean isConvertLeadBlock { get; set;}
    public boolean isContactBlock {get; set;}
    public List<SelectOption> contactPickList {get; set;}    
    public String selectedContact {get; set;}
    public String selectedPartner {get; set;}
    public Contact contact;

    
    public DE_ConverLead_CLS(ApexPages.StandardController controller) {
        
       
        
         
//stdCtrl = controller;
// Below flags are used to display following fields on the lead convert page  depending on the required condition in the controller 

//flag 1 = reseller 
//flag 2 = Partner Opportunity Owner
//flag 3 = Distributor
//flag 4 = Distributor Opportunity Owner
//flag 5 = Service Provider Platform
//flag 7 = Service Provider Client 

    lds = new lead();    
    
       leadlst = new Lead();
            
        
        flag1 = false;
          flag2 = false;
            flag3 = false;
              flag4 = false;
                flag5 = false;
            
                  flag7 = false;
       
           
        
     isConvertLeadBlock = true;
     isContactBlock = false;
    
        isLeadOwnerActive = false;
        IsSendEmailChecked = false;
        //hdnAccountId = '001f000000ZhX3E';
          List<Lead> leadreclist = [select id, lastname,Service_Provider_Clients__c, firstname, name, email, ownerid, company, Country_Picklist__c, EAID__c, Commercial_Account__c,PartnerAccount__c, Commercial_Account__r.Name, IsConverted from lead where id =:(id)controller.getRecord().id LIMIT 1];
        if(leadreclist.size() > 0) {
            leadrec = leadreclist[0];
            opprName = leadrec.company + DE_ConverLead_cls.splChar;
            System.debug('leadrec^^^^^'+leadrec.Commercial_Account__c);
            if(leadrec.Commercial_Account__c <> null) { //&& leadrec.Commercial_Account__c <> '')
                leadCAAccountIDExists = [Select id, name from Account where id =: leadrec.Commercial_Account__c LIMIT 1];
                if(leadCAAccountIDExists.size() > 0) {
                    endUserAccountName = leadrec.Commercial_Account__r.Name;
                    hdnAccountId = leadrec.Commercial_Account__c;
                    lds.Service_Provider_Clients__c=leadrec.Service_Provider_Clients__c;
                }    
            }
            lds.reseller__c = leadrec.PartnerAccount__c;
        }
            
        taskrec = new Task();
    }
    
       private ApexPages.StandardController stdCtrl;  
   

        
            
    
    
    public pagereference CheckIsConverted() {
        PageReference pageref;
        if(leadrec.IsConverted)
            pageref = new PageReference('/p/lead/ViewConvertedLead/d?id='+leadrec.id);
        else {
            pageref = null;
        }
        return pageref;
    }
    
    public List<SelectOption> getConvertedStatusList() { 
        List<SelectOption> sellist = new List<SelectOption>();
        sellist.add(new SelectOption('Converted','Converted'));
        return sellist;
    }
    
    public pageReference cancelMeth(){
        pageReference p = new PageReference('/'+leadrec.id);
        return p;  
    }
    
    public id createContact(){
         contact = new Contact();
        contact.lastName = leadrec.lastname;
        contact.firstname = leadrec.firstname;
        contact.accountid = hdnAccountId;
        contact.email = leadrec.email;
        contact.country_picklist__c = leadrec.country_picklist__c;
        insert contact;
        return contact.id;
    }
    
      
 //AR 3595 -kumma13-Controlling the Display on the VF page 

  public void hideSectionOnChange()
    {
    
     if(leadlst.Transaction_Type__c == '2 Tier')                          
            { 
              flag1 = true;
              flag2 = true;
              flag3 = true;
              flag4 = true;
              flag7 = false;
              flag5 = false;
            
             }
       
         else if(leadlst.Transaction_Type__c == '1 tier')                         
            { 
            flag1 = true;
            flag2 = true;
            flag3 = false;
            flag4 = false;
            flag5 = false;
           flag7 = false;
           
             }
         else if(leadlst.Transaction_Type__c == 'xSP')                          
            {   
             flag1 = false;
             flag2 = false;
            
             flag3 = false;
             flag4 = false;
        
              flag5 = true;
              flag7 = true;
             
             }
         else if(leadlst.Transaction_Type__c == 'Direct')                         
            { 
             flag1 = false;
            flag2 = false;
            flag3 = false;
            flag4 = false;
            flag5 = false;
          
             flag7 = false;
             }
          
          else if(leadlst.Transaction_Type__c == 'OEM')                         
            { 
            flag1 = true;
            flag2 = true;
            flag3 = false;
            flag4 = false;
            flag5 = false;
  
             flag7 = false;
             }
          else if (leadlst.Transaction_Type__c == 'ERWIN')                         
            {
          flag1 = true;
              flag2 = true;
              flag3 = true;
              flag4 = true;
              flag7 = false;
              flag5 = false;
            
             }
        else{
            flag1 = true;
            flag2 = true;
            flag3 = true;
            flag4 = true;
            flag5 = true;
 
           flag7 = true;
        }
    }
        
        
           
   //AR 3595 -Adding Validation error 

    public pagereference checkContacts(){
    
    if(leadlst.Transaction_Type__c =='1 Tier' && lds.Reseller__c == null)
    {
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Partner is required field');
            ApexPages.addMessage(myMsg);
            return null;
    }
      else if((leadlst.Transaction_Type__c =='2 Tier' || leadlst.Transaction_Type__c =='ERWIN') && (lds.Distributor__c == null || lds.Reseller__c == null)) 
        {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Partner and distributor are required field');
                ApexPages.addMessage(myMsg);
                return null;
        }
        else if(leadlst.Transaction_Type__c =='xSP' && (lds.Service_Provider_Platform__c == null))
        {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Service provider platform is required');
                ApexPages.addMessage(myMsg);
                     return null;
              }
      
        
        else
        
        {
             if(hdnAccountId !=null && leadrec.ownerid != null){
                 List<Contact> contactList;
                 if( leadrec.firstname!= null && leadrec.firstname != '' )
                    contactList = [select id, name from contact where (name like :'%'+leadrec.lastname+'%' OR name like :'%'+leadrec.firstname+'%') AND Account.id = :hdnAccountId];
                 else
                      contactList = [select id, name from contact where name like :'%'+leadrec.lastname+'%' AND Account.id = :hdnAccountId];
                if( (null != contactList && contactList.size() > 0)){
                
                    isConvertLeadBlock = false;
                    isContactBlock = true;
                    contactPickList = new List<SelectOption>();
                    contactPickList.add( new SelectOption('0', '--None--'));
                    contactPickList.add( new SelectOption('1', 'Create new contact : '+leadrec.name));
                    for(Contact cont :contactList ){
                      
                        contactPickList.add( new SelectOption( cont.id, 'Attach to Existing : '+cont.name));
                    }
                return NULL;
                }else{
                //return null;
                     return ConvertLeadRecord_1();
                  
                  /*if(!ldConvertResult_Boolean){
                     Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,ldConvertResult_Error));
                     return null;
                  }
                  else{
                    pageReference p = new PageReference('/'+hdnAccountId);
                    return p; 
                  }*/
                     
                }
             }else{
                Apexpages.addMessage(new Apexpages.message(APEXPAGES.SEVERITY.ERROR,'Please enter all mandatory values'));
                return null;
             }
        }
       }

    public pagereference ConvertLeadRecord_1(){
        List<LiveChatTranscript> livechattransList = [SELECT ContactId,Id,LeadId FROM LiveChatTranscript WHERE LeadId =:leadrec.id];//US232643
        pageReference p;
        Id NewopportunityID;
        string leadownerid = leadrec.ownerid;

        if(leadownerid.substring(0,3) == '00G') 
            isLeadOwnerActive = true;
        else {
            //Is Lead Owner Active
            List<User> LeadOwner = [select id, name, IsActive from User where id =: leadrec.ownerid LIMIT 1];
            if(LeadOwner.size() > 0) 
                isLeadOwnerActive = LeadOwner[0].IsActive;
        }
        
        if(isLeadOwnerActive) {
            Database.LeadConvert lc = new database.LeadConvert();
            Database.LeadConvert[] leadsToConvert = new Database.LeadConvert[0];
            transient  Database.LeadConvertResult[] ldConvertResult;
    
            lc.setLeadId(leadrec.id);
            lc.setSendNotificationEmail(setSendNotificationEmail);
            lc.setDoNotCreateOpportunity(isOpportunityCreate);
    
            if(isOpportunityCreate) opprName = '';
            if(hdnAccountId != null && hdnAccountId != '') 
                lc.setAccountId(hdnAccountId);
    
            if( !isContactBlock ){
               lc.setContactId(createContact());
            }
            else{
           
               if( selectedContact.contains('1')){
                   lc.setContactId(createContact());
               }else{
                   lc.setContactId(selectedContact);
                   conId=lc.getContactId();
                   ExistingContact=false;
               }
            }
            

                lc.setOwnerId(Userinfo.getUserId());
                lc.isSendNotificationEmail();
                if(opprName != '') 
                    lc.setOpportunityname(opprName);
                LeadStatus convertStatus;
                convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true and  MasterLabel like 'C%'];
                lc.setConvertedStatus(convertStatus.MasterLabel);
                System.debug('*************B4 convert***********'+lc);
                leadsToConvert.add(lc);
                ldConvertResult = Database.ConvertLead(leadsToConvert,false);
                System.debug('*************After convert***********'+ldConvertResult);
                if(ldConvertResult[0].isSuccess()){
                    OppId = ldConvertResult[0].getOpportunityId();
                    System.debug('________Oppty'+OppId);               
                    Opportunity Opp;
                    if(OppId<>null){
                        Opp = [select id, reseller__c,Transaction_Type__c,Reseller_Contact__c,Distributor_6__c,End_User_Contact__c,Distributor_Contact__c,Service_Provider_Client__c,Referral_Approval_Status__c,LeadSource,Referral_Partner__c,Referral_Partner_Account__c,Referral_Date__c,Cloud_Platform__c,(Select Id,Role,ContactId,IsPrimary from OpportunityContactRoles ) from Opportunity where id =: OppId];
                        system.debug('TestDebug'+Opp);
                        system.debug('contact role '+opp.OpportunityContactRoles);
                    }
                   if (Opp!= null ) 

                   {
                    opp.reseller__c = lds.reseller__c;
                    opp.Distributor_6__c=lds.Distributor__c;
                    opp.Distributor_Contact__c=lds.Distributor_Contact__c;
                    opp.Service_Provider_Client__c=lds.Service_Provider_Clients__c;
                    opp.Cloud_Platform__c =lds.Service_Provider_Platform__c;
                    opp.Reseller_Contact__c=lds.Reseller_Contact_Name__c;
                    opp.End_User_Contact__c=lds.Account_Contact__c;
                    opp.Type=leadlst.Transaction_Type__c;
                    opp.lead_id__c = leadrec.id;
                    
                    //AR 3903 Start ALLHA02
                     if(opp.OpportunityContactRoles.size()>0){
                           for(OpportunityContactRole crole :opp.OpportunityContactRoles){
                               if(crole.Role==null || crole.role=='')
                                   crole.Role='Influencer';
                           }
                       } 
                       System.debug('Before update contact role'+opp.OpportunityContactRoles);//
                    update  opp.OpportunityContactRoles;
                       //AR3903 End
                     //amasa03
                     System.debug('Referral-1');
                    if(opp.LeadSource == 'Partner Referral' && opp.Referral_Partner__c != null && opp.Referral_Partner_Account__c != null && opp.Referral_Date__c != null){
                            opp.Referral_Approval_Status__c = 'Sales Accepted';
                            //sending email to referral user  when lead is converted.
                             String Referral_LeadCC = Label.Referral_Lead_additonal_reciepants;
                            String[] arrCCList = Referral_LeadCC.split(';');
                            List<Messaging.SingleEmailMessage> allemails = new List<Messaging.SingleEmailMessage>();
                             Messaging.singleEmailMessage emailRequestNA = new Messaging.singleEmailMessage();
                            emailRequestNA.setUseSignature(false);
                            emailRequestNA.setTemplateId(Label.Referral_Lead_accept_Email);
                            emailRequestNA.setTargetObjectId(opp.Referral_Partner__c);
                            emailRequestNA.setWhatId(leadrec.id);
                            emailRequestNA.saveAsActivity = false;
                            if(arrCCList.size() > 0){
                                emailRequestNA.setCcAddresses(arrCCList);
                            }
                            
                            emailRequestNA.setSenderDisplayName('CApartners@ca.com');
                            allemails.add(emailRequestNA);
                             Messaging.SendEmailResult [] emailResultNA =  Messaging.sendEmail(allemails);
                            System.debug('Referral-2');
                    }
                    if(leadlst.Transaction_Type__c == 'Direct')
                    {
                      opp.Partner_Engagement__c=leadlst.Partner_Engagement__c;  
                    }
                    else{
                        opp.Partner_Engagement__c = 'Incremental';
                    }
                    
                    update Opp;
                    NewopportunityID = opp.Id;//AR3867
                   system.debug('CheckingOpp'+Opp);
                    
                    //AR 3595 -Adding Partner and Distributor Contacts To Opportunity Team 
                    
                    if((opp.Type == '1 Tier' || opp.Type == 'OEM') && lds.Reseller_Contact_Name__c != NULL){
                        Contact ResellerName = [Select Name from Contact where Id =: lds.Reseller_Contact_Name__c];
                        List<User> OppuserId = [Select Id from User where Name =: ResellerName.Name and ISACTIVE = true];
                        if(OppuserId.size() > 0){
                            OpportunityTeamMember oppTeam = new OpportunityTeamMember();
                            oppTeam.OpportunityId = opp.Id;
                            oppTeam.TeamMemberRole = 'Partner';
                            oppTeam.UserId = OppuserId[0].Id;
                            insert oppTeam;
                            OpportunityShare os =new OpportunityShare ();
                            os.OpportunityId=opp.Id;
                            os.UserOrGroupId=OppuserId[0].Id;
                            os.OpportunityAccessLevel='edit';
                            insert os;
                        }
                    }
                    else{
                        if(opp.Type == '2 Tier' || opp.Type == 'ERWIN'){
                            List<OpportunityTeamMember> oppTeamlist = new List<OpportunityTeamMember>();
                            List<OpportunityShare> oslist =new List<OpportunityShare>();
                            if(lds.Reseller_Contact_Name__c != NULL){
                                Contact ResellerName = [Select Name from Contact where Id =: lds.Reseller_Contact_Name__c];
                                List<User> OppuserId = [Select Id from User where Name =: ResellerName.Name and ISACTIVE = true];
                                if(OppuserId.Size() > 0){
                                    OpportunityTeamMember oppTeam1 = new OpportunityTeamMember();
                                    oppTeam1.OpportunityId = opp.Id;
                                    oppTeam1.TeamMemberRole = 'Partner';
                                    oppTeam1.UserId = OppuserId[0].Id;
                                    oppTeamlist.add(oppTeam1);
                                    OpportunityShare os1 =new OpportunityShare ();
                                    os1.OpportunityId=opp.Id;
                                    os1.UserOrGroupId=OppuserId[0].Id;
                                    os1.OpportunityAccessLevel='edit';
                                    oslist.add(os1);
                                }
                                
                            }
                            if(lds.Distributor_Contact__c != NULL){
                                Contact ResellerName1 = [Select Name from Contact where Id =: lds.Distributor_Contact__c];
                                List<User> OppuserId1 = [Select Id from User where Name =: ResellerName1.Name and ISACTIVE = true];
                                if(OppuserId1.size() > 0){
                                    OpportunityTeamMember oppTeam2 = new OpportunityTeamMember();
                                    oppTeam2.OpportunityId = opp.Id;
                                    oppTeam2.TeamMemberRole = 'Partner';
                                    oppTeam2.UserId = OppuserId1[0].Id;
                                    oppTeamlist.add(oppTeam2);
                                    OpportunityShare os2 =new OpportunityShare ();
                                    os2.OpportunityId=opp.Id;
                                    os2.UserOrGroupId=OppuserId1[0].Id;
                                    os2.OpportunityAccessLevel='edit';
                                    oslist.add(os2);
                                }
                                    
                            }
                            if(oppTeamlist.size() > 0){
                                insert oppTeamlist;
                            }
                            if(oslist.size() > 0){
                                insert oslist;
                            }
                        
                        }
                   
                    }
                   }
                    //Insert Task
                    taskrec.OwnerId =  Userinfo.getUserId();
                    taskrec.WhatId = OppId;
                    insert taskrec;
                    
                    /*US232643 - Start*/
                   if(livechattransList!=null && livechattransList.size()>0)
                        {
                            for(LiveChatTranscript l: livechattransList)
                                l.ContactId = ldConvertResult[0].getContactId();
                            update livechattransList;
                        }
                 /*US232643 - End*/
                PageReference pt;
                    if(NewopportunityID<>null){
                        //Navigate to Opportunity Page AR3867 AMASA03
                        p = new PageReference('/'+NewopportunityID);
                        return p;
                    }else{
                        if (ExistingContact==false)
                        {
                          pt = new PageReference('/'+ConId);
                           return pt;
                        }
                        else
                        {
                        p = new PageReference('/'+contact.Id);
                        return p;
                        }
                    }
                    return null;
                }     
                else {
                    //Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, ldConvertResult[0].getErrors()[0].getMessage());
                    Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'You do not have the required permission.  To continue, please contact Operations to grant \"Edit\" permissions on the selected Account.');
                    Apexpages.addMessage(error);
                    return null;
                }
        }
        else { //Add Pagemessage Lead Owner Inactive change Leadowner Active before convert.
            Apexpages.Message error = new Apexpages.Message(ApexPages.Severity.Error, 'Lead Owner is inactive change Leadowner before convert');
            Apexpages.addMessage(error);
            return null;
        }    
    }
    public void switchBlock(){
        System.debug('________I am here');
        isConvertLeadBlock = true;
        isContactBlock = false;
    }
}