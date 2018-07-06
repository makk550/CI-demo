Public class Ext_EditDealRegistration {
    private final Opportunity dealRegOppT;
    public Opportunity dealRegOpp{set;get;}
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
    
    public Ext_EditDealRegistration(ApexPages.StandardController controller) {
        this.dealRegOppT = (Opportunity)controller.getrecord();
        this.dealRegOpp = this.dealRegOppT;
        Account userAccount = null;
        isReseller = true;
       currentUser = [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
                                                          From User WHERE Id = :UserInfo.getUserId() LIMIT 1];                                                                
       Dealregopp  = DealregoppT;
      if(currentUser == null) {
            isPartner = false;                  
      } else if(currentUser.UserType <> 'PowerPartner' || !currentUser.IsPortalEnabled) {
            isPartner = false;
      } else {
            userAccount = [Select Customer_Category__c, Name, Alliance__c,Velocity_Seller__c,Solution_Provider__c,Service_Provider__c, 
                                  GEO__c, Region_Country__c, Velocity_Seller_Program_Level__c,Velocity_Seller_Type__c,Alliance_Program_Level__c,
                                  Alliance_Type__c,Service_Provider_Program_level__c,Service_Provider_Type__c,Solution_Provider_Program_Level__c,
                                  Solution_Provider_Type__c,Velocity_Seller_CAM_PMFKey__c,Solution_Provider_CAM_PMFKey__c
                                  From Account where Id = :currentUser.AccountId];
            //if(userAccount.Customer_Category__c != 'Reseller'){
            //    isPartner = false;
            //}
        }
        
        if(userAccount <> null){
            ResellerID = UserInfo.getUserId();
            ResellerAccountID = currentUser.AccountId;
            ResellerContactID = currentUser.ContactId;
            solutionProviderCamPmfKey = userAccount.Solution_Provider_CAM_PMFKey__c;
            velocitySellerCamPmfKey = userAccount.Velocity_Seller_CAM_PMFKey__c;
            
            if(useraccount.Solution_Provider_Type__c == 'Distributor'  ||
                       useraccount.Velocity_Seller_Type__c == 'Distributor' ||
                       useraccount.Customer_Category__c  == 'Distributor'){  
                isReseller = false;
                hdnDistiAccountId = useraccount.id;
                hdnDistiContactID = currentUser.ContactId;
            }
            dealRegOpp.Type='Direct';
           // RefershDealRegistrationProg();
        }
        
        dealRegOpp.CurrencyIsoCode = currentUser.DefaultCurrencyIsoCode;
    }
    
  /*  public void RefershDealRegistrationProg()
    {
        SelectOption option = null;
        dealRegPrmNames = new List<Selectoption>();
        option = new SelectOption('--None--','--None--');
        dealRegPrmNames.add(option);
       
            DealProgramEligibility dealPrmEligible = new DealProgramEligibility();
            dealPrograms = new List<Deal_Registration_Program__c>();
            try{
                //dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(currentUser.AccountId);
                //AR 3257 - For Tier 2 transaction, populate Deal reg program based on Distributor   
                system.debug('##### Tier--'+ dealRegOpp.Type+ '--hdnDistiAccountId--'+ hdnDistiAccountId); 
                if(dealRegOpp.Type == '2 Tier' && hdnDistiAccountId <> null && hdnDistiAccountId <> ''){
                        dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(hdnDistiAccountId);
                }        
                else if(dealRegOpp.Registering_on_behalf_of_Partner__c && (hdnResellAccountID <> null && hdnResellAccountID <> '') && dealRegOpp.Type != '2 Tier')
                  dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(hdnResellAccountID);
                else
                    dealPrograms = dealPrmEligible.getEligibleDealRegistrationPrograms(currentUser.AccountId);
            }
            catch(Exception e){
                system.debug(e);
            }
            
            for(Deal_Registration_Program__c dealRegPrmRef : dealPrograms) {
             if(dealRegPrmRef.Opp_Type__c.contains(dealRegOpp.type)){
                option = new SelectOption(dealRegPrmRef.Id,dealRegPrmRef.Partner_Friendly_Name__c);
                dealRegPrmNames.add(option);
                }
                }
    } */
    
    public PageReference UpdateOpportunity() {
        PageReference p = null; 
        try 
        {   
            if(dealRegOpp.Name == '' || dealRegOpp.Name == null){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Opportunity Name');            
                ApexPages.addMessage(msg);
                return null;
            }
            else if(dealProgramSelected == '--None--') {
            
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Deal Registration Program');            
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
                        else if(dealRegOpp.Registering_on_behalf_of_Partner__c && (hdnResellAccountID == '' || hdnResellAccountID == null)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Partner');            
                ApexPages.addMessage(msg);
                return null;
            }
            else if(dealRegOpp.Registering_on_behalf_of_Partner__c && (hdnresellContactId == '' || hdnresellContactId == null)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a Partner Contact');            
                ApexPages.addMessage(msg);
                return null;
            }
            else
            {
              Id oppId = null;
              Boolean changedAcct = (dealRegOpp.AccountId != hdnAccountId);
              dealRegOpp.AccountId = hdnAccountId;
              dealRegOpp.End_User_Contact__c = hdnContactId;
              
              if(dealRegOpp.Registering_on_behalf_of_Partner__c && (hdnResellAccountID <> '' && hdnResellAccountID <> null))
                  dealRegOpp.Reseller__c = hdnResellAccountID;
              else             
                  dealRegOpp.Reseller__c = ResellerAccountID;
              
              if(dealRegOpp.Registering_on_behalf_of_Partner__c && (hdnresellContactId <> '' && hdnresellContactId <> null))
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

              RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
              Id dealRegRecordTypeID = rec.RecordType_Id__c;   
              System.debug('adfadfaf' + hdnAccountId);    
              Deal_Registration_Program__c dealProgram = new Deal_Registration_Program__c();
              for(Deal_Registration_Program__c drp: [SELECT Id,Program_Manager__r.Email,Finance_Approver_Email__c,Name, Program_Manager__c,Partner_Friendly_Name__c,End_Date__c, 
                                                                   First_Approver__c,Expiry_Days__c
                                                                   ,Opp_Type__c 
                                                                   FROM Deal_Registration_Program__c 
                                                                   WHERE Id= :dealProgramSelected LIMIT 1])
                   dealProgram =drp;//
              // Oct R2014 - Introduced Segment field
              Account endUserAccountObj = [Select RecordTypeId,Segment__c,OwnerId from Account where Id = :hdnAccountId LIMIT 1];
                
                if(!isPartner){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partners are only allowed to create Deal Registrations.');            
                    ApexPages.addMessage(msg);
                    return null;
                }                                           
                         
                dealRegOpp.Deal_Registration_Status__c = 'New';
                dealRegOpp.StageName = 'Deal Reg - New';
                dealRegOpp.Initiated_By__c = 'Partner';
                dealRegOpp.RecordTypeId = dealRegRecordTypeID;
                //dealRegOpp.Partner_Engagement__c = 'Incremental';  //SEERA02 - 3258
               if( dealRegOpp.recordtypeid == dealRegRecordTypeID){ //3258
              // if(dealRegOpp.Source__c == 'Deal registration' && (dealRegOpp.Deal_Registration_Status__c == 'Sale Approved' || dealRegOpp.Deal_Registration_Status__c == 'Sales Rejected')){    
                 dealRegOpp.Partner_Engagement__c = 'Incremental';
                                    }

                dealRegOpp.Deal_Registration_Program__c = dealProgramSelected;
                /*if(dealProgram.Finance_Approver_Email__c != null)
                    dealRegOpp.Finance_Email__c = dealProgram.Finance_Approver_Email__c; 
                if(dealProgram.Opp_Type__c != null)
                        dealRegOpp.Type = dealProgram.Opp_Type__c;
                else
                        dealRegOpp.Type = '1 Tier';*/
                dealRegOpp.Source__c = 'Deal Registration';
                /*System.debug('outside if>>>>>>>>');
                if(dealProgram.Program_Manager__r.Email <> null && dealProgram.Program_Manager__r.Email != '#N/A') {
                    System.debug('--------------email in controller'+dealProgram.Program_Manager__r.Email);
                    dealRegOpp.Program_Manager_Email__c = dealProgram.Program_Manager__r.Email;
                }*/
                
                Account reseller = [Select Geo__c from Account where Id =:dealRegOpp.Reseller__c];
                List<Deal_Reg_Approvers__c> DRAs = [Select Id, Approver__c from Deal_Reg_Approvers__c where Deal_Registration_Program__c = :dealProgram.Id and Region__c =:reseller.Geo__c];
                
                if(DRAs != null && DRAs.size() > 0){
                    dealRegOpp.First_Approver__c =  DRAs[0].Approver__c;
                }
                
                
                
                //Get
                 Account resellerAccount = null;
                 String resellervelocitySellerCamPmfKey;
                     if(dealRegOpp.Registering_on_behalf_of_Partner__c) {
                            resellerAccount = [Select Customer_Category__c, Name, Alliance__c,Velocity_Seller__c,Solution_Provider__c,Service_Provider__c, 
                                  GEO__c, Region_Country__c, Velocity_Seller_Program_Level__c,Velocity_Seller_Type__c,Alliance_Program_Level__c,
                                  Alliance_Type__c,Service_Provider_Program_level__c,Service_Provider_Type__c,Solution_Provider_Program_Level__c,
                                  Solution_Provider_Type__c,Velocity_Seller_CAM_PMFKey__c,Solution_Provider_CAM_PMFKey__c
                                  From Account where Id = :hdnResellAccountID];
                resellervelocitySellerCamPmfKey = resellerAccount.Velocity_Seller_CAM_PMFKey__c;
                }

                
                // Oct R2014 - Introduced the stat below - During insert or change of account
                if(dealRegOpp.Id == null || changedAcct)
                if(dealProgram!=null)
                if(dealProgram.Opp_Type__c!=null&&dealProgram.Opp_Type__c.contains('DM')) {
                        //System.debug('inside ------------');
                        User userObj = null;
                        if(velocitySellerCamPmfKey != null && velocitySellerCamPmfKey != '') {
                            //System.debug('velocitySellerCamPmfKey ------------'+velocitySellerCamPmfKey);
                                try {
                                    if(dealRegOpp.Registering_on_behalf_of_Partner__c && (resellervelocitySellerCamPmfKey <> null && resellervelocitySellerCamPmfKey <> ''))
                                        userObj = [Select Id from User where PMFKey__c = :resellervelocitySellerCamPmfKey and isActive = true LIMIT 1];
                                    else    
                                        userObj = [Select Id from User where PMFKey__c = :velocitySellerCamPmfKey and isActive = true LIMIT 1];
                                } catch(Exception e) {
                                        //do nothing
                                }
                        }
                        if(userObj != null) {
                           // System.debug('userObj ------------'+userObj);
                                dealRegOpp.OwnerId = userObj.Id;
                        } else if(dealProgram!=null){
                                if(dealProgram.First_Approver__c <> null) 
                                                        dealRegOpp.OwnerId = dealProgram.First_Approver__c;                             
                        }
                } else {
                // Oct R2014 - change the if statement
                          if(endUserAccountObj.RecordTypeId == SystemIdUtility.getAccountTeamAcctRecordTypeId()) {
                                if(endUserAccountObj.OwnerId != null) {
                                        dealRegOpp.OwnerId = endUserAccountObj.OwnerId;
                                } else if(dealProgram!=null){
                                        dealRegOpp.OwnerId = dealProgram.First_Approver__c;
                                }
                                
                        } // Oct R2014 - change the if statement
                        else  if(endUserAccountObj.RecordTypeId == SystemIdUtility.getTerritoryAcctRecordTypeId() || endUserAccountObj.RecordTypeId == SystemIdUtility.getSMBAcctRecordTypeId()) {
                                User userObj = null;
                                if(solutionProviderCamPmfKey != null && solutionProviderCamPmfKey != '') {
                                        try {
                                                userObj = [Select Id from User where PMFKey__c = :solutionProviderCamPmfKey and isActive = true LIMIT 1];
                                        } catch(Exception e) {
                                                //do nothing
                                        }
                                }
                                if(userObj != null) {
                                        dealRegOpp.OwnerId = userObj.Id;
                                } else if(dealProgram!=null){
                                        dealRegOpp.OwnerId = dealProgram.First_Approver__c;
                                }
                                
                        }
                } 
                //dealRegOpp.Deal_Program__c = dealProgram.Partner_Friendly_Name__c;                    
                //dealRegOpp.Deal_Program__c = dealProgram.Name;
                //dealRegOpp.Reseller__c = ResellerAccountID;
                //dealRegOpp.Reseller_Contact__c = ResellerContactID;
                dealRegOpp.Partner_User_Internal__c = ResellerID;
                
                DateTime  createdDate = Date.today();                 
                dealRegOpp.Deal_Registration_Submitted_Date__c = date.newInstance(createdDate.year(),createdDate.month(),createdDate.day());
                if(dealProgram!=null&&dealProgram.Expiry_Days__c <> null){
                    if(dealRegOpp.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(dealProgram.Expiry_Days__c)) < dealProgram.End_Date__c)
                    {
                        dealRegOpp.Deal_Expiration_Date__c = dealRegOpp.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(dealProgram.Expiry_Days__c));
                    }
                    else
                    {
                        dealRegOpp.Deal_Expiration_Date__c = dealProgram.End_Date__c;
                    }
                 }   
                //Database.Saveresult result = 
                upsert dealRegOpp;//,false);
                oppId = dealRegOpp.id;//result.getId();
                
                p = new Pagereference('/apex/OpplineItempage_PRM?oppid='+ oppId + '&producttype=Product');
            }
        } catch (Dmlexception e) {
                ApexPages.addMessages(e);
                return null;
        }
        return p;
    }    
    
    /*@isTest(SeeAllData=true)
    public static void DealRegistrationEdit_Test(){
        
        try{
         RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
         Id dealRegRecordTypeID = rec.RecordType_Id__c; 
                                                            
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
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.CloseDate = Date.today() + 1;
                objOpp.Initiated_By__c = 'Partner';
                objOpp.Deal_Registration_Program__c = delPgrm.Id;
                
                ApexPages.StandardController stdCtrl = new ApexPages.StandardController(objOpp);
                Ext_EditDealRegistration objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                objOpp.Deal_Registration_Program__c = delPgrm.Id;
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.dealProgramSelected = delPgrm.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestDealRegistration';
                objOpp.RecordTypeId = dealRegRecordTypeID;
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
                objDealReg = new Ext_EditDealRegistration(stdCtrl);
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
}