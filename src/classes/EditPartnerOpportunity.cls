Public class  EditPartnerOpportunity {
    private final Opportunity Opp;
    public string endUserAccountName{get;set;}
    public string distributorAccName{get;set;}
    public string hdnDistiAccountId {get;set;}   
    public string hdndistName{get;set;}
    public string endUserContact{get;set;}
    public string hdnAccountId{get;set;}
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
    public Id currentUserId{get;set;}
    public String cloneY {get;set;}
    //public boolean hdnModified {get; set;}
    //public Id oppDisAcctId {get;set;}
    public string resellbutorAccName{get;set;}
    public string hdnresellAccountId{get;set;}

    public EditPartnerOpportunity(ApexPages.StandardController controller) {
       this.Opp= (Opportunity)controller.getrecord();
       cloneY = System.currentPageReference().getParameters().get('clone');
       SelectOption option = null;
       dealRegPrmNames = new List<Selectoption>();
       option = new SelectOption('--None--','--None--');
       dealRegPrmNames.add(option);
       Account userAccount = null;
       
       //oppDisAcctId = Opp.Distributor_6__c;
     
      User currentUser = [Select Id,UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode 
                                                                From User WHERE Id = :UserInfo.getUserId() LIMIT 1];                                                                
      
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
            if(userAccount.Customer_Category__c != 'Reseller'){
                isPartner = false;            
            }
        }
        currentUserId = currentUser.Id;
        if(userAccount <> null){
            ResellerID = UserInfo.getUserId();
            ResellerAccountID = currentUser.AccountId;
            ResellerContactID = currentUser.ContactId;
            solutionProviderCamPmfKey = userAccount.Solution_Provider_CAM_PMFKey__c;
            velocitySellerCamPmfKey = userAccount.Velocity_Seller_CAM_PMFKey__c;          
        }
                
    }
    
    public PageReference UpdateOpportunity() {

        PageReference p = null; 
        
        try 
        {   
             Id oppId = null;
             //if((Opp.AccountId != '' || Opp.AccountId != null)  && (hdnAccountId == null || hdnAccountID == ''))
             if(((String)Opp.AccountId != '' || (String)Opp.AccountId != null)  && (hdnAccountId == null || hdnAccountID == ''))
                hdnAccountID = (Id)Opp.AccountId; //Assigning for edit 001Q000000XAwn8IAD
             
            if((hdnAccountId == '' || hdnAccountId == null)  && (Opp.Account.Name == '' || Opp.Account.Name == null ) ){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Account Name');            
                ApexPages.addMessage(msg);
                
                return null;
            }           
            else
            {
             
               if(hdnAccountId!= null && hdnAccountId!= '')            
                  Opp.AccountId = (Id)hdnAccountId;                     

               if(hdnDistiAccountId != null && hdnDistiAccountId != '')                       
               {
              
                   Opp.Distributor_6__c = (Id)hdnDistiAccountId;  
                 
                   System.debug('adfadfaf' + hdnDistiAccountId);  
               }
               else{ 
                           
                   Opp.Distributor_6__c = null;
               }
                
               if(hdnContactID != null && hdnContactID != '')                       
                   Opp.Distributor_Contact__c = (Id) hdnContactID;   
               else
                Opp.Distributor_Contact__c = null;                 
                if( hdnresellAccountId != null && hdnresellAccountId !='' )
                    Opp.Reseller__c = hdnresellAccountId;                 
                else
                    Opp.Reseller__c = null;
              RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('New Opportunity');
              Id NewOppRecordTypeID = rec.RecordType_Id__c;   
              Opp.RecordTypeId =   NewOppRecordTypeID;
                User Usr = new User();//3258
               Usr = [SELECT  Id,Is_Partner_User__c FROM User WHERE Id = : UserInfo.getUserId()];
              if ( opp.recordtypeid == newOppRecordTypeID ){
                 if(usr.Is_Partner_User__c == true && opp.source__c == 'Partner'){
                      opp.Partner_Engagement__c = 'Incremental';

                        }
                        } 

              if(Opp.id == null)
              {
                     Opp.StageName = Label.Opp_Stage_10_Percent;
                     // Closedate will be populated when the record is inserted
                     Opp.CloseDate = Date.today() + 1;
              }
              Opp.Site_ID__c = '9999998';
            
              if((Opp.Reseller__c !=null || Opp.Reseller__c !='')  && (Opp.type != 'Direct'))
                  Opp.Reseller__c = ResellerAccountID;
                    
                if(cloneY == '1')
                {
                    Opportunity newOppClone = opp.clone(false,true);
                    newOppClone.Name = opp.Name;
                    insert newOppClone;                    
                    oppId = newOppClone.id;
                }
                else
                {
                    upsert Opp;//,false);
                    oppId = Opp.id;//result.getId();
                }
                List<OpportunityShare> lstOS=new List<OpportunityShare>();
                List <OpportunityTeamMember> lstOTM = new List <OpportunityTeamMember>();
                                                                           
                      OpportunityTeamMember otm = new OpportunityTeamMember();
                      otm.TeamMemberRole = 'Channel Account Manager';
                      otm.OpportunityId = oppid;
                      otm.UserId = currentUserId;
                      lstOTM.add(otm);
                  
                      OpportunityShare os =new OpportunityShare ();
                      os.OpportunityId=oppid;
                      os.UserOrGroupId=currentUserId;
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
                
                //insert products for clone
                if(cloneY == '1')
                {
                    List<OpportunityLineItem> oppLineItems = [Select Id,OpportunityId, Partner_Sales_Price__c, PricebookEntryId from OpportunityLineItem where OpportunityId =: Opp.id];
                    for(OpportunityLineItem tempLineItem : oppLineItems) 
                    { 
                        System.debug ('hi ' + Opp.id);
                        OpportunityLineItem newOpplineClone = tempLineItem.clone(false,true);
                        newOpplineClone.OpportunityId = oppId;
                        insert newOpplineClone;                                            

                     } 
                }
                p = new Pagereference('/'+oppid);                
            }
        } catch (Dmlexception e) {
               
                ApexPages.addMessages(e);
                return null;
        }
        return p;
    }    
    
    @isTest(SeeAllData=true)
    public static void EditPartnerOpportunity_Test(){
        
        try{
         RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('New Opportunity');
         Id newOppRecordTypeID = rec.RecordType_Id__c; 
                                                            
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
        
        if(partnerUser <> null){
            System.RunAs(partnerUser){  
                //Create a Deal Registration Opportunity
                Opportunity objOpp = new Opportunity();
                objOpp.Name = 'NewPartnerOpportunity';
                objOpp.RecordTypeId =   newOppRecordTypeID;
                objOpp.CloseDate = Date.today() + 1;
                objOpp.Initiated_By__c = 'Partner';                
                objOpp.StageName = Label.Opp_Stage_10_Percent;
                objOpp.Site_ID__c = '9999998';

                ApexPages.StandardController stdCtrl = new ApexPages.StandardController(objOpp);
                EditPartnerOpportunity objDealReg = new EditPartnerOpportunity(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;                
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.RecordTypeId = newOppRecordTypeID;
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new EditPartnerOpportunity(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestnewOpp';
                objOpp.RecordTypeId = newOppRecordTypeID;
                
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new EditPartnerOpportunity(stdCtrl);
                objDealReg.hdnAccountId = smbAccount.Id;
                objDealReg.hdnContactId = smbContact.Id;
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestnewOpp1';
                objOpp.RecordTypeId = newOppRecordTypeID;
                
                
                stdCtrl = new ApexPages.StandardController(objOpp);
                objDealReg = new EditPartnerOpportunity(stdCtrl);
                objDealReg.hdnContactId = smbContact.Id;                
                objDealReg.UpdateOpportunity();
                
                objOpp = new Opportunity();
                objOpp.Name = 'TestNewOpp2';
                objOpp.RecordTypeId = newOppRecordTypeID;
                objOpp.Deal_Registration_Status__c = 'New';                     
                objOpp.CloseDate =  Date.today() + 1;                                
                insert objOpp;
                    
            }
        }
        
        }
        catch(Exception e){
            
            System.debug('Exception in test class'+e);
        }
    }
}