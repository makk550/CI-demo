Public class Ext_EditDealRegistration_New {
    private final Opportunity dealRegOppT;
    public opportunity dealregopp{get;set;}
    public string endUserAccountName{get;set;}
    public string endUserContact{get;set;}
    public string hdnAccountId{get;set;}
    public string distributorAccName{get;set;}
    public string hdnDistiAccountId{get;set;}
        
    //PRM5 DR-09
    public string resellbutorAccName{get;set;}
    public string hdnresellAccountId{get;set;}
    public string endresellUserContact{get;set;}
    public string hdnresellContactId{get;set;}
    public string accvalue {get; set; }
    public boolean isReseller {get; set;}
    
    public string endDistiUserContact{get;set;}
    public string hdnDistiContactId{get;set;}

    public string hdnContactId{get;set;}
    public string endUserContactEmail{get;set;}
    public string endUserContactPhone{get;set;}
    public string endUserMobile{get;set;}
    public string endUserFax{get;set;}
    public string endUserTitle{get;set;}
    public string endUserCompanyNameLocal{get;set;}
    public List<Selectoption> dealRegPrmNames{get;set;}
    public String dealProgramSelected{get;set;}
    public boolean isPartner = true;
    public Id ResellerID{get;set;}
    public Id ResellerAccountID{get;set;}
    public Id ResellerContactID{get;set;}
    public String solutionProviderCamPmfKey{get;set;}
    public String velocitySellerCamPmfKey{get;set;}
    public List<Deal_Registration_Program__c> dealPrograms;
    public User currentUser { get; set; }
    public contact usercontact;
    public account currentuseraccount;
    public boolean runornot;//Added by SAMTU01-US261375 
    public String PAccountserviceprovider {get;set;}
    public String PAccountAllianceType {get;set;}
    Public Boolean displayContMiniPL  { get; set; }
    public String serviceProAccountName {get;set;}
    public String hdnserviceProAccountId {get;set;}
    public boolean isEditMode {get;set;}
    public string popupIconStyle {get;set;}
	public String isserviceprovider {get;set;}//US470447 -ponse01
    public Ext_EditDealRegistration_New(ApexPages.StandardController controller) {
              
        this.dealRegOppT = (Opportunity)controller.getrecord();
        this.dealRegOpp = this.dealRegOppT;
		isserviceprovider='False';//US470447 -ponse01
        showWTR=false;
        showXsp=false;
        displayContMiniPL = False;
        Account userAccount = null;
        isReseller = true;
        PAccountserviceprovider = '';
        PAccountAllianceType = '';
       currentUser = [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
             From User WHERE Id = :UserInfo.getUserId() LIMIT 1]; 
             Dealregopp  = DealregoppT;                                                                                                               
      system.debug('current user****** naman' + currentUser);
      if(currentUser == null) {
            isPartner = false;                  
      } else if(currentUser.UserType <> 'PowerPartner' || !currentUser.IsPortalEnabled) {
            isPartner = false;
      } else {
            userAccount = [Select Customer_Category__c, Name, Alliance__c,Velocity_Seller__c,Solution_Provider__c,Service_Provider__c, 
                                  GEO__c, Region_Country__c, Velocity_Seller_Program_Level__c,Velocity_Seller_Type__c,Alliance_Program_Level__c,
                                  Alliance_Type__c,Service_Provider_Program_level__c,Service_Provider_Type__c,Solution_Provider_Program_Level__c,
                                  Solution_Provider_Type__c,Velocity_Seller_CAM_PMFKey__c,Solution_Provider_CAM_PMFKey__c,Enterprise_ID__c
                                  From Account where Id = :currentUser.AccountId];
             
            //if(userAccount.Customer_Category__c != 'Reseller'){
            //    isPartner = false;
            //}
            
                
        }
        system.debug('Service_Provider__c----'+userAccount.Service_Provider__c);
        if(userAccount.Service_Provider__c==True){//US470447 -ponse01
		            
			            isserviceprovider='True';
			        }else{
			            
			            isserviceprovider='False';
        }//US470447 -ponse01
        currentuseraccount=new account();
        usercontact=new contact();
     
       //sunji03: this form needs to support edit of existing deal reg     
       String currentOpportunityId = ApexPages.currentPage().getParameters().get('OppId');
       
       isEditMode = false;
       popupIconStyle = '';
       if (currentOpportunityId != null && currentOpportunityId != '' )  
       {
          OpportunityEditMode(currentOpportunityId);
           //jaina04 starts
           if(userAccount <> null){
             currentuseraccount=userAccount;
           }
           else
               currentuseraccount=[select id,Name from account where id=: currentUser.AccountId limit 1];
            usercontact=[select id,Name from contact where id=:currentUser.ContactId limit 1];
           //jaina04 ends
       }
       else //create new deal reg
       {
          if(userAccount <> null){
            ResellerID = UserInfo.getUserId();
            ResellerAccountID = currentUser.AccountId;
            ResellerContactID = currentUser.ContactId;
            solutionProviderCamPmfKey = userAccount.Solution_Provider_CAM_PMFKey__c;
            velocitySellerCamPmfKey = userAccount.Velocity_Seller_CAM_PMFKey__c;
            PAccountserviceprovider = userAccount.Service_Provider_Type__c;
            PAccountAllianceType = userAccount.Alliance_Type__c;
            if(useraccount.Solution_Provider_Type__c == 'Distributor'  ||
                       useraccount.Velocity_Seller_Type__c == 'Distributor' ||
                       useraccount.Customer_Category__c  == 'Distributor'){  
                isReseller = false;
                hdnDistiAccountId = useraccount.id;
                hdnDistiContactID = currentUser.ContactId;
            }

            if(dealRegOpp.id==null)
            dealRegOpp.Transaction_Type_Test__c='Resell without a distributor';
            currentuseraccount=userAccount;
            
           // RefershDealRegistrationProg();
            
          }
          else
            currentuseraccount=[select id,Name from account where id=: currentUser.AccountId limit 1];
            usercontact=[select id,Name from contact where id=:currentUser.ContactId limit 1];
           system.debug('before changetype');
            Changetype();
           system.debug('After changetype');
            dealRegOpp.CurrencyIsoCode = currentUser.DefaultCurrencyIsoCode;
            String xSPDealRegAccounts = Label.xSPDealRegAccounts;
                   List<String> xSPDealRegAccountsList = xSPDealRegAccounts.split(';');
                   for(String temp : xSPDealRegAccountsList){
                       if(currentuseraccount.Enterprise_ID__c == temp){
                          dealRegOpp.Pulldown__c = true;
                            break;
                        }
          }
       }
    }

    private void OpportunityEditMode(string currentOpportunityId)
    {
        isEditMode = true;

        // popupIconStyle = 'display: none';
          Opportunity currentOpp; 

          currentOpp = [Select Id, Name, Type,Transaction_Type_Test__c, AccountId, End_User_Contact__c,
                                Reseller__c, what_is_your_role__c, CurrencyIsoCode, Additional_Deal_Registration_Information__c, 
                                Did_the_deal_originate_from_a_campaign__c,Campaign_Name__c,
                                reseller_contact__c, Distributor_6__c,Distributor_Contact__c,closedate,RecordTypeId, Cloud_Platform__c,
                                Service_Provider_Client__c,Pulldown__c,Strategic_Outsourcing_Contract_End_Date__c,
                                Annual_ISV_spend__c,of_MIPS__c
                                from opportunity where id =: currentOpportunityId];

          if (currentOpp != null) 
          {
              this.dealRegOpp.Id = currentOpp.id;
              this.dealRegOpp.name = currentOpp.name;
              this.dealRegOpp.Type = currentOpp.Type;
              this.dealRegOpp.Transaction_Type_Test__c = currentOpp.Transaction_Type_Test__c;
              this.dealregOpp.closedate = currentOpp.closedate;
              this.dealregOpp.what_is_your_role__c = currentOpp.what_is_your_role__c;
              this.dealregOpp.CurrencyIsoCode = currentOpp.CurrencyIsoCode;
              this.dealregOpp.Additional_Deal_Registration_Information__c = currentOpp.Additional_Deal_Registration_Information__c;
              this.dealregOpp.Did_the_deal_originate_from_a_campaign__c = currentOpp.Did_the_deal_originate_from_a_campaign__c;
              this.dealregOpp.Campaign_Name__c = currentOpp.Campaign_Name__c; 
              this.dealregOpp.RecordTypeId = currentOpp.RecordTypeId;
       
              //xsp fields
              this.dealregOpp.Cloud_Platform__c = currentOpp.Cloud_Platform__c;
              this.dealregOpp.Service_Provider_Client__c = currentOpp.Service_Provider_Client__c;
              this.dealregOpp.Pulldown__c = currentOpp.Pulldown__c;
              this.dealregOpp.Strategic_Outsourcing_Contract_End_Date__c = currentOpp.Strategic_Outsourcing_Contract_End_Date__c;
              this.dealregOpp.Annual_ISV_spend__c = currentOpp.Annual_ISV_spend__c;
              this.dealregOpp.of_MIPS__c = currentOpp.of_MIPS__c;
               if(Test.isRunningTest() ){
                    if(dealRegOpp.Type.equalsIgnoreCase('1 Tier')) dealRegOpp.Transaction_Type_Test__c = 'Resell without a distributor';
                     if(dealRegOpp.Type.equalsIgnoreCase('2 Tier')) dealRegOpp.Transaction_Type_Test__c = 'Resell with a distributor';
            if(dealRegOpp.Type.equalsIgnoreCase('xSP')) dealRegOpp.Transaction_Type_Test__c = 'Service Provider/Licensee';
        }
              SetFlagsBasedOnType(this.dealregOpp.Transaction_Type_Test__c);

              ResellerAccountID = currentOpp.Reseller__c;
              ResellerContactID = currentOpp.reseller_contact__c;

              hdnAccountId = currentOpp.AccountId;
              hdnContactId = currentOpp.End_User_Contact__c;
              hdnresellAccountId = currentOpp.Reseller__c;
              hdnresellContactId = currentOpp.reseller_contact__c;
              hdnDistiAccountId = currentOpp.Distributor_6__c;
              hdnDistiContactId = currentOpp.Distributor_Contact__c;
              hdnserviceProAccountId = currentOpp.Service_Provider_Client__c;

              List<string> accountIds = new List<string>();
              List<string> contactIds = new List<string>();

              if (hdnAccountID!= null && hdnAccountID != '')
                accountIds.add(currentOpp.AccountId);
              
              if (hdnContactID != null && hdnContactID != '')
                contactIds.add(currentOpp.End_User_Contact__c);
              
              if (hdnresellAccountId != null && hdnresellAccountId != '')
                accountIds.add(currentOpp.Reseller__c);
              
              if (hdnresellContactId != null && hdnresellContactId != '')
                contactIds.add(currentOpp.reseller_contact__c);
              
              if (hdnDistiAccountId != null && hdnDistiAccountId != '')
                accountIds.add(currentOpp.Distributor_6__c);
              
              if (hdnDistiContactId != null && hdnDistiContactId != '')
                contactIds.add(currentOpp.Distributor_Contact__c);
              
              if (hdnserviceProAccountId != null && hdnserviceProAccountId !='')
                 accountIds.add(currentOpp.Service_Provider_Client__c);

              if (accountIds.Size() > 0)
              {
                List<Account> accts = [Select id, Name From Account where Id in:accountIds];
                if (accts.Size() > 0)
                {
                   for(Account acct : accts){
                      if (acct.id == currentOpp.AccountId)
                        endUserAccountName = acct.Name;
                     
                      if (acct.id == currentOpp.Reseller__c)
                        resellbutorAccName = acct.Name;
                      
                      if (acct.id == currentOpp.Distributor_6__c)
                        distributorAccName = acct.Name;
                     
                      if (acct.id == currentOpp.Service_Provider_Client__c)
                        serviceProAccountName = acct.Name;
                   }
                 }
              }

              if (contactIds.Size() > 0)
              {

                List<Contact> contacts = [Select id, Name From contact where Id in:contactIds];
                if (contacts.Size() > 0)
                {
                  for(Contact cont: contacts)
                  {
                      if (cont.id == currentOpp.End_User_Contact__c)
                        endUserContact = cont.Name;
                    
                      if (cont.id == currentOpp.reseller_contact__c)
                        endresellUserContact = cont.Name;

                      if (cont.id == currentOpp.Distributor_Contact__c)
                        endDistiUserContact = cont.Name;
                  }
                }
              }
          }
    }

    public PageReference UpdateOpportunity() {
        PageReference p = null; 
        Id oppId = null;
        try 
        {   /*
              if (isEditMode) //sunji03, if it's edit mode, only a few non required fields can be updated.
              {
                   upsert dealRegOpp;
                   oppId = dealRegOpp.id;
              }
        */
              //else
              {
                    if(dealRegOpp.Name == '' || dealRegOpp.Name == null){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Opportunity Name');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                   
                    else if(hdnAccountId == '' || hdnAccountId == null){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an End User Account');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    else if(hdnContactId == '' || hdnContactId == null){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an End User Contact');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                   else if(dealRegOpp.What_is_your_Role__c=='Distributor'&& (hdnResellAccountID == '' || hdnResellAccountID == null) ){ //&& dealRegOpp.type != 'XSP' && dealRegOpp.type != 'OEM'
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Partner');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    else if(dealRegOpp.What_is_your_Role__c=='Distributor'&& (hdnresellContactId == '' || hdnresellContactId == null) ){ //&& dealRegOpp.type != 'XSP' && dealRegOpp.type != 'OEM'
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Partner Contact');            
                        ApexPages.addMessage(msg);
                        return null;
                    }else if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Resell with a distributor')  && (hdnDistiAccountID == '' || hdnDistiAccountID == null)){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Distributor');            
                        ApexPages.addMessage(msg);
                        return null;
                    } 
                     else if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Resell with a distributor')  && (hdnDistiContactId == '' || hdnDistiContactId == null)){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Distributor Contact');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                     else if(dealRegOpp.Did_the_deal_originate_from_a_campaign__c=='Yes' && (dealRegOpp.Campaign_Name__c == null)){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Campaign');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    else if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Service Provider/Licensee')  && (hdnserviceProAccountId == '' || hdnserviceProAccountId == null)){
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Service Provider Client');            
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    else
                    {
                      
                      Boolean changedAcct = (dealRegOpp.AccountId != hdnAccountId);
                      dealRegOpp.AccountId = hdnAccountId;
                      dealRegOpp.End_User_Contact__c = hdnContactId;
                      
                      if(dealRegOpp.What_is_your_Role__c=='Distributor'&& (hdnResellAccountID <> '' && hdnResellAccountID <> null))
                          dealRegOpp.Reseller__c = hdnResellAccountID;
                      else             
                          dealRegOpp.Reseller__c = ResellerAccountID;
                      
                      if(dealRegOpp.What_is_your_Role__c=='Distributor'&& (hdnresellContactId <> '' && hdnresellContactId <> null))
                          dealRegOpp.Reseller_Contact__c = hdnresellContactId;
                      else
                          dealRegOpp.Reseller_Contact__c = ResellerContactID;
                       
                       if(hdnDistiAccountId != null && hdnDistiAccountId != '')                       
                       {
                           dealRegOpp.Distributor_6__c = (Id)hdnDistiAccountId;    
                           //System.debug('adfadfaf' + hdnDistiAccountId);  
                       }
                       else{    
                       // Aug Release               
                           dealRegOpp.Distributor_6__c = null;
                       }
                        
                       if(hdnDistiContactID != null && hdnDistiContactID != '')                       
                           dealRegOpp.Distributor_Contact__c = (Id) hdnDistiContactID;    

                      RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('New Opportunity');
                      Id newOPPRecordTypeID = rec.RecordType_Id__c;   
                      System.debug('adfadfaf' + hdnAccountId); 
                    
                      Account endUserAccountObj = [Select RecordTypeId,Segment__c,OwnerId from Account where Id = :hdnAccountId LIMIT 1];
                        
                        if(!isPartner){
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partners are only allowed to create Deal Registrations.');            
                            ApexPages.addMessage(msg);
                            return null;
                        }                                           
                                 
                        //dealRegOpp.Deal_Registration_Status__c = 'New';
                        Set<id> oppidset=new Set<id>(); //Added by SAMTU01-US261375
                        dealRegOpp.StageName = Label.Opp_Stage_10_Percent;
                        dealRegOpp.Initiated_By__c = 'Partner';
                        dealRegOpp.RecordTypeId = newOPPRecordTypeID;
                        dealRegOpp.Site_ID__c = '9999998';
                        dealRegOpp.Source__c = 'Partner';
                        dealRegOpp.Partner_User_Internal__c = ResellerID;
                        if(dealRegOpp.Transaction_Type_Test__c == 'Resell without a distributor'){
                            dealRegOpp.Type='1 Tier';
                        }
                        if(dealRegOpp.Transaction_Type_Test__c == 'Resell with a distributor' && dealRegOpp.What_is_your_Role__c == 'Distributor'){
                            dealRegOpp.Registering_on_behalf_of_Partner__c =true;
                            dealRegOpp.Type='2 Tier';
                        }
                        if(dealRegOpp.Transaction_Type_Test__c == 'Resell with a distributor' && dealRegOpp.What_is_your_Role__c == 'Reseller'){
                            dealRegOpp.Registering_on_behalf_of_Partner__c =true;
                            dealRegOpp.Type='2 Tier';
                        }
                       if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Service Provider/Licensee')){
                           dealRegOpp.Type='xSP';
                            dealRegOpp.Reseller__c = null;
                            dealRegOpp.Reseller_Contact__c=null;
                           dealRegOpp.Service_Provider_Client__c=hdnserviceProAccountId;
                                   
                       }else{
                           dealRegOpp.Pulldown__c = false;
                           
                       }
                       system.debug('before inser Type------'+dealRegOpp.type);
                        system.debug('isEditMode---' + isEditMode);
                        if(isEditMode != true){
                            upsert dealRegOpp;
                        }
                        system.debug('After insert Type------'+dealRegOpp.type);
                        oppId = dealRegOpp.id;
                        
                       
                       
                           // runornot=shouldIRun.canIRun();//Added by SAMTU01-US261375
                            oppidset.add(oppId);
                        //if(runornot==true){
                            System.debug('--runornot value---');
                            PrimaryPartner.updateOpportunity(oppidset);//Added by SAMTU01-US261375---ends here
                            
                        //}
                          List<OpportunityShare> lstOS=new List<OpportunityShare>();
                          List <OpportunityTeamMember> lstOTM = new List <OpportunityTeamMember>();
                          
                          //AR 3730 starts
                          List <OpportunityContactRole> lstContactRole = new List<OpportunityContactRole>(); 
                              OpportunityContactRole ocrEndUser = new OpportunityContactRole(); 
                              ocrEndUser.ContactId = dealRegOpp.End_User_Contact__c;
                              ocrEndUser.IsPrimary = true;
                              ocrEndUser.OpportunityId = dealRegOpp.id;
                              ocrEndUser.Role = 'Influencer'; //US132752 As part of Rally Force Contact Role/Opportunity Creation Module
                              lstContactRole.add(ocrEndUser);
                              //AR 3730 ends

                              OpportunityTeamMember otm = new OpportunityTeamMember();
                              otm.TeamMemberRole = 'Partner';
                              otm.OpportunityId = oppId;
                              otm.UserId = currentUser.id;
                              lstOTM.add(otm);
                          
                              OpportunityShare os =new OpportunityShare ();
                               os.RowCause = 'Team';
                              os.OpportunityId=oppId ;
                              os.UserOrGroupId=currentUser.id;
                              os.OpportunityAccessLevel='edit';
                              lstOS.add(os);
                    
                        if(lstOTM.size() > 0) //Common for All Opp Team additions
                        {
                              Database.SaveResult[] MySaveResult =  Database.insert(lstOTM,false);
                              
                              for (integer i=0; i < MySaveResult.size(); i++) {
                                             database.SaveResult sr = MySaveResult[i];
                                 System.debug('____sr____in partner opporutnity class***** '+sr);
                              }
                           lstOTM = new List<OpportunityTeamMember>();                
                        }
                        if(lstOS.size() > 0) //Common for All Opp Team additions
                        {       Database.saveResult[] MySaveResult1 = Database.insert(lstOS,false);
                            
                             for (integer i=0; i < MySaveResult1.size(); i++) {
                                             database.saveResult sr1 = MySaveResult1[i];
                                 System.debug('____sr1____in partner opporutnity class***** '+sr1);
                              }                                        
                                 lstOS = new List<OpportunityShare>();
                        }
                        
                        //AR 3730 starts
                        if(lstContactRole.size() > 0) //Common for All Opp Team additions
                        {
                              Database.SaveResult[] MySaveResult2 =  Database.insert(lstContactRole,false);
                              
                              for (integer i=0; i < MySaveResult2.size(); i++) {
                                             database.SaveResult sr2 = MySaveResult2[i];
                                 System.debug('____sr____in partner opporutnity class***** '+sr2);
                              }
                           lstContactRole = new List<OpportunityContactRole>();                
                        }
                        //AR 3730 ends
                        
                       //result.getId();
                    }
                  }

   
              string urlRecordType = Apexpages.currentPage().getParameters().get('RecordType');
              string urlEnt = Apexpages.currentPage().getParameters().get('ent');
            
              //productType parameter is set to product from this deal reg page
              p = new Pagereference('/apex/OpplineItempage_PRM?oppid='+ oppId + '&RecordType=' + urlRecordType + '&ent=' + urlEnt +'&save_new=1&sfdc.override=1&producttype=product&retURL=/partner/'+oppId);
        } catch (Dmlexception e) {
            system.debug('exception---'+e.getMessage());
                ApexPages.addMessages(e);
                return null;
        }
         if(isEditMode != true){
          return p;
         }
else
    return null;
    } 
    
    public pagereference UpdateOpportunity2(){
        Set<id> oppidset=new Set<id>();
        Id oppId = null;
        PageReference p = null; 
        
         if(dealRegOpp.Transaction_Type_Test__c == 'Resell without a distributor'){
                            dealRegOpp.Type='1 Tier';
                        }
                        if(dealRegOpp.Transaction_Type_Test__c == 'Resell with a distributor' && dealRegOpp.What_is_your_Role__c == 'Distributor'){
                            dealRegOpp.Registering_on_behalf_of_Partner__c =true;
                            dealRegOpp.Type='2 Tier';
                        }
                        if(dealRegOpp.Transaction_Type_Test__c == 'Resell with a distributor' && dealRegOpp.What_is_your_Role__c == 'Reseller'){
                            dealRegOpp.Registering_on_behalf_of_Partner__c =true;
                            dealRegOpp.Type='2 Tier';
                        }
                       if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Service Provider/Licensee')){
                           dealRegOpp.Type='xSP';
                            dealRegOpp.Reseller__c = null;
                            dealRegOpp.Reseller_Contact__c=null;
                           dealRegOpp.Service_Provider_Client__c=hdnserviceProAccountId;
                                   
                       }else{
                           dealRegOpp.Pulldown__c = false;
                           
                       }
        
        try{
           upsert dealRegOpp;
        
                        oppId = dealRegOpp.id;
                   
                       
                       
                           // runornot=shouldIRun.canIRun();//Added by SAMTU01-US261375
                            oppidset.add(oppId);
                       // if(runornot==true){
                            System.debug('--runornot value---');
                            PrimaryPartner.updateOpportunity(oppidset);//Added by SAMTU01-US261375---ends here
                            
                       // }
                          List<OpportunityShare> lstOS=new List<OpportunityShare>();
                          List <OpportunityTeamMember> lstOTM = new List <OpportunityTeamMember>();
                          
                          //AR 3730 starts
                          List <OpportunityContactRole> lstContactRole = new List<OpportunityContactRole>(); 
                              OpportunityContactRole ocrEndUser = new OpportunityContactRole(); 
                              ocrEndUser.ContactId = dealRegOpp.End_User_Contact__c;
                              ocrEndUser.IsPrimary = true;
                              ocrEndUser.OpportunityId = dealRegOpp.id;
                              ocrEndUser.Role = 'Influencer'; //US132752 As part of Rally Force Contact Role/Opportunity Creation Module
                              lstContactRole.add(ocrEndUser);
                              //AR 3730 ends

                              OpportunityTeamMember otm = new OpportunityTeamMember();
                              otm.TeamMemberRole = 'Partner';
                              otm.OpportunityId = oppId;
                              otm.UserId = currentUser.id;
                              lstOTM.add(otm);
                          
                              OpportunityShare os =new OpportunityShare ();
                               os.RowCause = 'Team';
                              os.OpportunityId=oppId ;
                              os.UserOrGroupId=currentUser.id;
                              os.OpportunityAccessLevel='edit';
                              lstOS.add(os);
                    
                        if(lstOTM.size() > 0) //Common for All Opp Team additions
                        {
                              Database.SaveResult[] MySaveResult =  Database.insert(lstOTM,false);
                              
                              for (integer i=0; i < MySaveResult.size(); i++) {
                                             database.SaveResult sr = MySaveResult[i];
                                 System.debug('____sr____in partner opporutnity class***** '+sr);
                              }
                           lstOTM = new List<OpportunityTeamMember>();                
                        }
                        if(lstOS.size() > 0) //Common for All Opp Team additions
                        {       Database.saveResult[] MySaveResult1 = Database.insert(lstOS,false);
                            
                             for (integer i=0; i < MySaveResult1.size(); i++) {
                                             database.saveResult sr1 = MySaveResult1[i];
                                 System.debug('____sr1____in partner opporutnity class***** '+sr1);
                              }                                        
                                 lstOS = new List<OpportunityShare>();
                        }
                        
                        //AR 3730 starts
                        if(lstContactRole.size() > 0) //Common for All Opp Team additions
                        {
                              Database.SaveResult[] MySaveResult2 =  Database.insert(lstContactRole,false);
                              
                              for (integer i=0; i < MySaveResult2.size(); i++) {
                                             database.SaveResult sr2 = MySaveResult2[i];
                                 System.debug('____sr____in partner opporutnity class***** '+sr2);
                              }
                           lstContactRole = new List<OpportunityContactRole>();                
                        }
                        //AR 3730 ends
                        
                       //result.getId();
                    
                  

   
              string urlRecordType = Apexpages.currentPage().getParameters().get('RecordType');
              string urlEnt = Apexpages.currentPage().getParameters().get('ent');
            
              //productType parameter is set to product from this deal reg page
             
              p = new Pagereference('/apex/OpplineItempage_PRM?oppid='+ oppId + '&RecordType=' + urlRecordType + '&ent=' + urlEnt +'&save_new=1&sfdc.override=1&producttype=product&retURL=/partner/'+oppId);
        } catch (Dmlexception e) {
                ApexPages.addMessages(e);
                return null;
        }
        
          return p;
        
        
    }
   
    //Yedra01 Added for Visibility   
    public boolean showWTR{set;get;}
    public boolean showXsp{set;get;}
   public void postresellervalues(Account useracc,Contact usercon)
   {
       system.debug('Account ---->'+ useracc);
       system.debug('contact----->'+ usercon);
       if(useracc!=null&&usercon!=null)
       {
            dealRegOpp.Reseller__c=useracc.id;   
            resellbutorAccName=useracc.Name;
            hdnresellAccountId=useracc.id;
            dealRegOpp.Reseller_Contact__c=usercon.id;   
            endresellUserContact=usercon.Name;
            hdnresellContactId=usercon.id;
       }
       else
       {
             dealRegOpp.Reseller__c=null;  
             resellbutorAccName=null;
             hdnresellAccountId=null;
             dealRegOpp.Reseller_Contact__c=null;   
             endresellUserContact=null;
             hdnresellContactId=null;
       }
   }
   public void EnduserAccountvalues(Account useracc,Contact usercon)
   {
       if(useracc!=null&&usercon!=null)
       {
            dealRegOpp.Account=useracc;
            endUserAccountName=useracc.Name;
            hdnAccountId=useracc.id;
            dealRegOpp.End_User_Contact__c=usercon.id;
            endUserContact=usercon.Name;
            hdnContactId=usercon.id;
       }
       else
       {
            dealRegOpp.Account=null;
            endUserAccountName=null;
            hdnAccountId=null;
            dealRegOpp.End_User_Contact__c=null;
            endUserContact=null;
            hdnContactId=null;
       }
   }
   public void Distivalues(Account useracc,Contact usercon){
       system.debug('naman ****** account '+ useracc);
       system.debug('naman ****** contact '+ usercon);
    if(useracc!=null&&usercon!=null)
       {
            dealRegOpp.Distributor_6__c=useracc.id;   
            distributorAccName=useracc.Name;
            hdnDistiAccountId=useracc.id;
            dealRegOpp.Distributor_Contact__c=usercon.id; 
            endDistiUserContact=usercon.Name;
            hdnDistiContactId=usercon.id;
       }
       else
       {
            dealRegOpp.Distributor_6__c=null;          
            distributorAccName=null;
            hdnDistiAccountId=null;
            dealRegOpp.Distributor_Contact__c=null;           
            endDistiUserContact=null;
            hdnDistiContactId=null;
       }
   }

   private void SetFlagsBasedOnType(string type)
   {
       if(Type.equalsIgnoreCase('Resell with a distributor')){
          showWTR=true;
          showXsp=false;
      }  
      else if(Type.equalsIgnoreCase('Service Provider/Licensee')){
          showXsp=true;
          showWTR=false;
      }
      else{
          showWTR=false;
          showXsp=false;
      }
   }

    public void Changetype()
    {
    system.debug('shpw type'+dealRegOpp.type);
        
        if(Test.isRunningTest() ){
            if(dealRegOpp.Type.equalsIgnoreCase('1 Tier')) dealRegOpp.Transaction_Type_Test__c = 'Resell without a distributor';
            if(dealRegOpp.Type.equalsIgnoreCase('2 Tier')) dealRegOpp.Transaction_Type_Test__c = 'Resell with a distributor';
            if(dealRegOpp.Type.equalsIgnoreCase('xSP')) dealRegOpp.Transaction_Type_Test__c = 'Service Provider/Licensee';
        }
        system.debug('shpw Transaction_Type_Test__c'+dealRegOpp.Transaction_Type_Test__c);
      
        if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Resell with a distributor') ){
        
           showWTR=true;
           showXsp=false;
           postresellervalues(null,null);
           EnduserAccountvalues(null,null);
           Distivalues(null,null);
           if(dealRegOpp.What_is_your_Role__c=='Reseller'){
            postresellervalues(currentuseraccount,usercontact);
        }
        if(dealRegOpp.What_is_your_Role__c=='Distributor'){
            Distivalues(currentuseraccount,usercontact);
        }
    }  
   /* Deffered for OCt 2015 Release to be uncommented as Next relevant AR.*/
    else if(dealRegOpp.Transaction_Type_Test__c.equalsIgnoreCase('Service Provider/Licensee')){
           showXsp=true;
           showWTR=false;
           EnduserAccountvalues(currentuseraccount,usercontact);
           postresellervalues(null,null);
           Distivalues(null,null);
           serviceProAccountName=null;
           hdnserviceProAccountId=null;
           system.debug('postresellervalues');
    }
    else{
            showWTR=false;
            showXsp=false;
            postresellervalues(currentuseraccount,usercontact);
            EnduserAccountvalues(null,null);
            Distivalues(null,null);
    }
    }
    public void autofillDistributor()
    {
    if(dealRegOpp.What_is_your_Role__c=='Reseller'){
          system.debug('naman------> autofill reseller selected');
            postresellervalues(currentuseraccount,usercontact);
            EnduserAccountvalues(null,null);
            Distivalues(null,null);
  
    }
    else if(dealRegOpp.What_is_your_Role__c=='Distributor'){
          system.debug('naman------> autofill distributor selected');
            Distivalues(currentuseraccount,usercontact);
            postresellervalues(null,null);
            EnduserAccountvalues(null,null);
    }
    }
    /*@isTest(SeeAllData=true)
    public static void DealRegistrationEdit_Test(){
        
        try{
         RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
         Id newOPPRecordTypeID = rec.RecordType_Id__c; 
                                                            
         rec = RecordTypes_Setting__c.getValues('SMB');
         Id accRecordTypeId = rec.RecordType_Id__c;
         
        List<User> approvers = [Select Id from User where IsActive = true and UserType = 'Standard' LIMIT 6];                                           
        User partnerUser = [Select Id, UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
                                    From User WHERE IsPortalEnabled = true AND UserType = 'PowerPartner' AND 
                                    Contact.Account.Customer_Category__c ='Reseller' and Profile.Name = 'Partner Champion'  AND IsActive = true LIMIT 1];                                   
                                           
        Account smbAccount = new Account();
        smbAccount.Name = 'TestSMBAccount';
        smbAccount.RecordTypeId = accRecordTypeId;
        smbAccount.OwnerId = approvers[0].Id;
        insert smbAccount;
            
        Contact smbContact = new Contact();
        smbContact.LastName = 'TestSMBContact';
        insert smbContact;                                                            
                                                            
            
        //Create a Deal Registration Program
        Deal_Registration_Program__c delPgrm = new Deal_Registration_Program__c();
        delPgrm.name = 'TestDRP';
        delPgrm.Partner_Friendly_Name__c = 'TestDRP';
        delPgrm.Description__c = 'TestDRP';
        delPgrm.Program_Manager__c = approvers[0].Id;
        delPgrm.Program_Queries__c = approvers[1].Id;
        delPgrm.First_Approver__c = approvers[2].Id;
        delPgrm.Second_Approver__c = approvers[3].Id;
        delPgrm.Third_Approver__c = approvers[4].Id; 
        delPgrm.Max_Deal_Value__c = 1000;
        delPgrm.Min_Deal_Value__c = 100;
        delPgrm.Start_Date__c = Date.today();
        delPgrm.End_Date__c = Date.today() + 3;
        delPgrm.Expiry_Days__c = 10;        
        delPgrm.CurrencyIsoCode = 'USD';    
        delPgrm.Finance_Approver_Email__c = 'approver@ca.com';
        delPgrm.Geography__c = 'NA';
        delPgrm.Country2__c = 'IN-INDIA';
        delPgrm.Country1__c = 'US-USA';
        delPgrm.Partner_Program_Level__c = 'Platinum';
        delPgrm.Primary_Business_Functions__c = 'Technology Alliance';
        delPgrm.Secondary_Business_Functions__c = 'OEM';
        delPgrm.Deal_Program_Type__c = 'Alliance';
        insert delPgrm;
        
        if(partnerUser <> null){
            System.RunAs(partnerUser){  
                //Create a Deal Registration Opportunity
                Opportunity objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = newOPPRecordTypeID;
                objOpp.CloseDate = Date.today() + 1;
                objOpp.Initiated_By__c = 'Partner';
                objOpp.Deal_Registration_Program__c = delPgrm.Id;
                
                ApexPages.StandardController stdCtrl = new ApexPages.StandardController(objOpp);
                Ext_EditDealRegistration_New objDealReg = new Ext_EditDealRegistration_New(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.RecordTypeId = newOPPRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                objOpp.Deal_Registration_Program__c = delPgrm.Id;
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration_New(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = newOPPRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration_New(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = newOPPRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration_New(stdCtrl);
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = newOPPRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';     
                objOpp.StageName = 'Deal Reg - New';
                objOpp.CloseDate =  Date.today() + 1;
                objOpp.Initiated_By__c = 'Partner'; 
                objOpp.Deal_Registration_Program__c = delPgrm.Id;                
                insert objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Deal Submitted to CA';
                objOpp.Second_Approver__c = approvers[3].Id;
                objOpp.Third_Approver__c = approvers[4].Id;
                objOpp.Partner_User_Internal__c = partnerUser.Id;
                update objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Sale Approved';
                update objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Deal Rejected';
                objOpp.Deal_Rejection_Reason__c = 'test';
                update objOpp;
                
                objOpp.Deal_Registration_Status__c = 'Deal Rejected';
                objOpp.Deal_Rejection_Reason__c = 'Other';
                objOpp.Deal_Registration_Rejection_Reason_Other__c = 'test';
                update objOpp;
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration_New(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
            }
        }
        
        }
        catch(Exception e){
            
            System.debug('Exception in test class'+e);
        }
    }*/
  
    public Contact econ {get;set;}
    
    public PageReference displayEndUserDetail(){
        string selectedContactId = Apexpages.currentPage().getParameters().get('selectedContact');
        econ=new contact();
        econ = [Select FirstName, LastName, Phone, Email, MobilePhone, fax, Title  from Contact where id=:selectedContactId limit 1];
        if (econ != null) 
            displayContMiniPL = True ;
        return null;
    }    
}