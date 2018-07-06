public  class OppLineItemRemoteActions_PRM{
    
    public OppLineItemRemoteActions_PRM(ApexPages.Standardcontroller stdcontroller){}
    
    @RemoteAction
    public static boolean noPgmExists(String opportunityId){
        boolean noPgm = true;
        for(OpportunityLineItem oli : [select id,OpportunityId,Deal_Program_Eligibility_Status__c,Product2.Name,Deal_Registration__c from OpportunityLineItem where OpportunityId =:opportunityId]){
            if(oli.Deal_Registration__c == 'Yes'){
                noPgm = false;
                break;
            }
        }
        return noPgm;
    }
    
    @RemoteAction
    public static List<String> fetchSepPgmProdList(String opportunityId){
        List<String> sepPgmProdList = new List<String>();
        for(OpportunityLineItem oli : [select id,OpportunityId,Deal_Program_Eligibility_Status__c,Product2.Name from OpportunityLineItem where OpportunityId =:opportunityId]){
            if(oli.Deal_Program_Eligibility_Status__c == 'Separate Program'){   
                sepPgmProdList.add(oli.Product2.Name);
            }
        }
        return sepPgmProdList;    
    }
    
    @RemoteAction
    public static boolean checkBeforeReturn(List<OpportunityLineitem> lstoppoli, List<OppLineItemcontroller_PRM.ProductWrapper> selectedProducts, List<OppLineItemcontroller_PRM.ProductWrapper> searchresults){
       System.debug('lstoppoli'+lstoppoli+'selectedProducts'+selectedProducts+'searchresults'+searchresults);
        for(OpportunityLineitem dbOppLineItem : lstoppoli)
            for(OppLineItemcontroller_PRM.ProductWrapper pw : selectedProducts)
                if(pw.oppline.Id == dbOppLineItem.Id && (pw.BusinessType != dbOppLineItem.Business_Type__c || pw.oppline.Term_Month__c  != dbOppLineItem.Term_Month__c || pw.oppline.UnitPrice != dbOppLineItem.UnitPrice))
                    return true;
        return false;
    }

    @RemoteAction
    public static void executeOptoutFunc(String opportunityId){
        List<OpportunityLineItem> updateOppLineItemWithStatus = new List<OpportunityLineItem>();
        try{
            for(OpportunityLineItem oli : [select id,OpportunityId,Deal_Program_Eligibility_Status__c,Product2.Name from OpportunityLineItem where OpportunityId =:opportunityId]){
                if(oli.Deal_Program_Eligibility_Status__c == 'Separate Program'){               
                    oli.Deal_Program_Eligibility_Status__c = 'Opt Out';                
                    updateOppLineItemWithStatus.add(oli);
                }
             }
            update updateOppLineItemWithStatus;             
        }
        catch(Exception e){
            System.debug('Exception :'+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));           
        }
    }

    @RemoteAction
    public static String IsResubmissionPreWarningNeeded(String opportunityId){
        Opportunity opp = [select id,Deal_Reg_Initially_Approved__c,DR_Added_Eligible_Products__c,Deal_Registration_Status__c from Opportunity where id = :opportunityId];
        string returnString = '';
        //If it's already submitted and pending, don't pre-warning.
        if (opp.Deal_Reg_Initially_Approved__c && opp.Deal_Registration_Status__c == 'Modifying' && 
              (opp.DR_Added_Eligible_Products__c != null && opp.DR_Added_Eligible_Products__c != '' && opp.DR_Added_Eligible_Products__c.contains('|YES'))
            )
        {
          returnString = 'true';
        }
        return returnString;
    }

    @RemoteAction
    public static String NotChangeProductAndResubmitForApproval(String opportunityId){
       //sunji03 - After deal reg is approved, if user add more eligible products, and cancel on the confirmation window to abort the change.
       //DR_Added_Eligible_Products__c is in the format of "ID|YES,ID|YES,ID|NO", indicate deal program dropdown, user can change from "Yes" to "No", and from "No" back "Yes", but non-eligible can't be changed to Yes.
       
        Opportunity opp = [select id,Deal_Reg_Initially_Approved__c,DR_Added_Eligible_Products__c,Deal_Approval_status__c, Deal_Registration_Status__c from Opportunity where id = :opportunityId];

        if (opp.DR_Added_Eligible_Products__c == null)
            opp.DR_Added_Eligible_Products__c = '';

        if (opp.Deal_Reg_Initially_Approved__c && opp.DR_Added_Eligible_Products__c != '')
        {
          if (opp.DR_Added_Eligible_Products__c.endsWith(','))
          {
            opp.DR_Added_Eligible_Products__c = opp.DR_Added_Eligible_Products__c.SubString(0,opp.DR_Added_Eligible_Products__c.length()-1);
          }

          List<string> ids = opp.DR_Added_Eligible_Products__c.split(',');
 
          List<Opportunitylineitem> deleteList = new List<Opportunitylineitem>();
          for(string s : ids)
          {
            if (s.split('\\|')[1] == 'YES')
            {
              Opportunitylineitem i = new Opportunitylineitem();
              i.id = s.split('\\|')[0];
              deleteList.add(i);
            }
          }

          try
          {
              delete deleteList;
          }
          catch(exception e)
          {
              ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
              ApexPages.addMessage(msg);
          }

          for (Opportunitylineitem d:deleteList)
          {
            ids = RemoveItemFromList(ids,d.id);
          }

          opp.DR_Added_Eligible_Products__c = '';
          for(string s:ids)
          {
              opp.DR_Added_Eligible_Products__c += s + ',';
          }

          opp.ResubmissionProducts__c = GetResubmissionProductNameByID(ids);
          
          If (opp.DR_Added_Eligible_Products__c == '' || !opp.DR_Added_Eligible_Products__c.contains('|YES'))
          {
              RevertBacktoApprovedRecordTypeAndDealRegStatus(opp);
          }
          else
          {
              try{
                  update opp;
              }
              catch(exception e)
              {
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());
                  ApexPages.addMessage(msg);
            }
          }
        }

        return 'true';
    }

    private static list<string> RemoveItemFromList(List<string> ids, string idToCompare)
    {
         boolean isFound = false;
          integer itemIndex = -1;
          for(string s:ids)
          {
                itemIndex ++; 
                //format is ID|YES,ID|YES,ID|NO
                if (s.split('\\|')[0] == idToCompare) 
                {
                    isFound = true;
                    break;
                }
          }

          if (itemIndex >=0)
            ids.remove(itemIndex);
        
        return ids;
    }

    private static string GetResubmissionProductNameByID(list<string> ids)
    {
        string resubmissionProducts = '';
        List<string> prodIDs = new List<string>();
        for(string s:ids)
        {
            if (s.split('\\|')[1] == 'YES' )
            {
                prodIDs.add(s.split('\\|')[0]);
            }
        }

        for(OpportunityLineItem oli:[select Id,Deal_Registration__c,Product2.name from OpportunityLineItem where id in:prodIDs])
        {
             if(oli.Product2.name != null)
             {
                resubmissionProducts += oli.Product2.name+',';
            }
        }  

        return resubmissionProducts;
    }

@TestVisible
    private static opportunity RevertBacktoApprovedRecordTypeAndDealRegStatus(opportunity opp)
    {

        //If it's 'Modifying', "Recall" or "Reject" (Although in Reject, deal_registration_status__c is set to 'Sale Approved', Deal_Approval_status__c == 'Deal Rejected' is reliable
        if (opp.Deal_Registration_Status__c != 'Sale Approved' || (opp.Deal_Registration_Status__c == 'Sale Approved' && opp.Deal_Approval_status__c == 'Deal Rejected'))       
        { 
              string newOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();

              opp.Products_Changed_After_Approval__c = false;     

              //After deal reg is approved, it's converted to "New Opportunity" already. if further edit makes it warrant re-submission and then edit back to the values which does not warrant re-submission, revert back to the approved state.      
              if (opp.RecordTypeId != newOppRecordTypeID)     
              {       
                  opp.RecordTypeId = newOppRecordTypeID; 
              }       
              opp.Deal_Registration_Status__c = 'Sale Approved';    
              opp.Deal_Approval_status__c =  'Deal Approved'; 
              opp.Deal_Resubmit_Auto_Approve_From_Reject__c = false;
              opp.Resubmission__c= false;
              try{        
                  update opp;     
              }       
              catch(exception e)      
              {       
                  ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());     
                  ApexPages.addMessage(msg);      
              }   
              
        }      
        else //sale approved, real approval, not including rejected auto tag to approved.
        {
            try{        
                update opp;     
            }       
            catch(exception e)      
            {       
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getmessage());     
                ApexPages.addMessage(msg);      
            }     
        } 

        return opp;
    }

    @RemoteAction
    public static String updateRecordTypetoNewOpp(String opportunityId){
        try 
          {
            Opportunity opp = [select id,Deal_Expiration_Date__c,RecordTypeId from Opportunity where id = :opportunityId];
            Id newOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
            opp.RecordTypeId = newOppRecordTypeId;
            opp.Deal_Registration_Status__c='';
            opp.First_Approver__c = null;
            opp.Deal_Expiration_Date__c = null;
            opp.deal_program__c = null;
            opp.deal_registration_submitted_date__c = null;
            opp.StageName = Label.Opp_Stage_10_Percent;
            //opp.Initiated_By__c = '';
            opp.Source__c = 'Partner';  
            opp.MinMaxError__c = false;
            opp.isClosedDateFireDealReg__c = false;
            //clear out following 4 fields related to deal reg re-submission fields as it's converted to a new opportunity.
            opp.Deal_Reg_Initially_Approved__c = false; 
            opp.Products_Changed_After_Approval__c = false;
            opp.Deal_Resubmit_Auto_Approve_From_Reject__c = false;
            opp.Resubmission__c = false;
            update opp;
          }
          catch(DMLException e){
            System.debug('DMLException :'+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));           
            System.debug('Error message:'+e.getDmlMessage(0));
            string errorMsg = e.getDmlMessage(0);
            return errorMsg;
          }
          catch(Exception e1){
            System.debug('Exception :'+e1.getMessage());
            return e1.getMessage();
          }
          return 'true';
    }

    @RemoteAction 
    public static string SubmitForApproval(string opportunityId)
    {
      string returnString = '';
       try{
              Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
              req.setComments('Submitted for approval. Please approve.');
              req.setObjectId(opportunityId);
              system.debug('approval process'+req );
              Approval.ProcessResult result = Approval.process(req);
              if (!result.isSuccess())
              {
                string error = '';
                for ( Database.error strError : result.getErrors() )
                {
                    error += '<br/>' + strError.getMessage();
                }

                  System.debug('Submit for Approval failes :'+ result.getErrors() + ', opportunity id ' + opportunityId);
                  returnString = 'Submit for Approval fails, please try again or contact administrator.';
              }
              else
              {
                  system.debug('Approve Yes'+ opportunityId );   
              }
            }
            catch(Exception e){
              System.debug('Submit for Approval failes :'+e.getMessage() + ', opportunity id ' + opportunityId);
              returnString = 'Submit for Approval fails, please try again or contact administrator.';
            }
            return returnString;
    }

    @RemoteAction 
    public static string GetRecordType(string opportunityId)
    {
        string typeName = '';
        Opportunity opp = [select id,name,RecordType.Name from Opportunity where id = :opportunityId];

        if (opp != null)
        {
          typeName = opp.RecordType.Name;
        }

        return typeName;
    }


    @RemoteAction 
    public static string SetNoProgramDealregApproverAndFlag(string opportunityId)
    {
      system.debug(' opportunityId' + opportunityId);

       string geo = 'NA';
       User currentUser = [select contact.geo__c from user where id = :UserInfo.getUserId() LIMIT 1];

       if (currentUser != null)
       {
          geo = currentUser.contact.geo__c;
       }
       string firstApproverUserName = '';
       if (geo == 'NA')
       {
          firstApproverUserName = Label.NA_dealreg_no_program_approver;
       }
       else if (geo == 'EMEA')
       {
          firstApproverUserName = Label.EMEA_dealreg_no_program_approver;
       }
       else if (geo == 'LA')
       {
          firstApproverUserName = Label.LA_dealreg_no_program_approver;
       }
        else if (geo == 'APJ')
       {
          firstApproverUserName = Label.APJ_dealreg_no_program_approver;
       }
         else if (geo == 'PS/CAN')//ponse01
       {
          firstApproverUserName = Label.PS_CAN_deal_reg_approver;
       }
       string firstApproverID = '';

       system.debug('firstApproverUserName is ' + firstApproverUserName);

       list<User> users = [select id from user where username =:firstApproverUserName];
       if (users.Size() > 0)
       {
          firstApproverID = users[0].id;
       }

      system.debug('firstApproverID is ' + firstApproverID);

       try 
        {
          Opportunity opp = [select id,Deal_Expiration_Date__c,RecordTypeId from Opportunity where id =:opportunityId];  
           System.debug('===opp==========='+opp);
          opp.Has_No_Deal_Reg_Program__c = true;
          opp.First_Approver__c = firstApproverID;
          //set the status to enter approval process
          opp.New_Opportunity_Status__c = 'New';
          opp.New_Opportunity_Approval_Status__c = 'Submitted';
          opp.MinMaxError__c = false;
          opp.isClosedDateFireDealReg__c = false;

          update opp;
        }
        catch(DMLException e){
           system.debug(' sun exception');
          System.debug('DMLException :'+e.getMessage());
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));           
          System.debug('Error message:'+e.getDmlMessage(0));
          return e.getDmlMessage(0);
        }
        catch(Exception e1){
          System.debug('Exception :'+e1.getMessage());
          return e1.getMessage();
        }

        return 'true';
    }

    @RemoteAction
    public static string CheckMaxMinRuleAndSubmitForApproval(string opportunityId){

          string returnString = '';

          List<Opportunity> dealRegOppList = new List<Opportunity>([select MinMaxError__c,id,name,Deal_Registration_Status__c,Deal_Reg_Initially_Approved__c,isClosedDateFireDealReg__c from opportunity where id=:opportunityId]);
          Opportunity dealRegOpp;

          if (dealRegOppList.size() > 0)
          {
              dealRegOpp = dealRegOppList[0];
          }

          //If it's first time approval, need to check close date and max/min price, if it's already approved one, don't check close date, only check max/min price
          if (dealRegOpp.Deal_Reg_Initially_Approved__c)
          {
            
             if(!dealRegOpp.MinMaxError__c){ //no error
              returnString = SubmitForApproval(dealRegOpp.id);
            }
            else{
                returnString = Label.DealRegMinMaxPriceError;
            }   
          }    
          else
          {
            if(!dealRegOpp.MinMaxError__c && !dealRegOpp.isClosedDateFireDealReg__c){ //no error
           
              returnString = SubmitForApproval(dealRegOpp.id);
            }
            else{
              if (dealRegOpp.MinMaxError__c)
              {
                returnString = Label.DealRegMinMaxPriceError;
              }
              else if (dealRegOpp.isClosedDateFireDealReg__c)
              {
                returnString = Label.DealRegCloseDateError;
              }
            }   
          } 

          return returnString;  
    }
    
    @RemoteAction
    public static String updateRecordTypetoDealReg(String opportunityId){
          try 
          {   
            list<string> allProgsWithRank = new list<string>();
            set<string> allProgramsNumber = new set<string>();
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            Map<ID, Set<String>> oliProgNumberMap = new Map<ID, Set<String>>();
            Map<ID, Set<String>> oliProgNameMap = new Map<ID, Set<String>>();
            List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
              Opportunity opp = [select id,name,AccountId,RecordTypeId,Deal_Registration_Status__c,RecordType.Name,Deal_Registration_Program__c,Deal_Expiration_Date__c,Deal_Registration_Submitted_Date__c,
                                    Distributor_6__c,StageName,Initiated_By__c,Source__c,Partner_Engagement__c,Finance_Email__c,First_Approver__c,Type,Reseller__c,OwnerId
                                    from Opportunity where id = :opportunityId];
              oliList=[select id,OpportunityId,Deal_Program_ID__c,name,Deal_Program_Eligibility_Status__c,Product_Group__C,Product2.Name from OpportunityLineItem where OpportunityId =:opportunityId];
              Id dealRegRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Deal Registration').getRecordTypeId();
              System.debug('***opp:'+opp);
              opp.RecordTypeId = dealRegRecordTypeId;
              opp.Deal_Registration_Status__c='New';
              opp.StageName = 'Deal Reg - New';
              opp.Initiated_By__c = 'Partner';
              opp.Source__c = 'Deal Registration';
              opp.Partner_Engagement__c = 'Incremental';
              opp.New_Opportunity_Status__c = '';
              opp.New_Opportunity_Approval_status__c = '';
              opp.Has_No_Deal_Reg_Program__c = false;
              
              Deal_Registration_Program__c dealProgram = [SELECT Id,Program_Manager__r.Email, Finance_Approver_Email__c,Name, Program_Manager__c,Partner_Friendly_Name__c,End_Date__c, 
                                     Opp_Type__c,
                                                                       First_Approver__c,Deal_Program_Number__c,Expiry_Days__c FROM Deal_Registration_Program__c 
                                                                       WHERE Id= :opp.Deal_Registration_Program__c LIMIT 1];//,Opp_Type__c 3270
              System.debug('========dealProgram======='+dealProgram);
              DateTime  createdDate = Date.today();
              Opp.Deal_Registration_Submitted_Date__c = date.newInstance(createdDate.year(),createdDate.month(),createdDate.day());
               if(dealProgram.Expiry_Days__c <> null){
                    if(opp.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(dealProgram.Expiry_Days__c)) < dealProgram.End_Date__c) {
                        opp.Deal_Expiration_Date__c = Opp.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(dealProgram.Expiry_Days__c));
                    }
                    else {
                      Opp.Deal_Expiration_Date__c = dealProgram.End_Date__c;
                  } 
              } 
            
              if(dealProgram.Finance_Approver_Email__c != null) {
                opp.Finance_Email__c = dealProgram.Finance_Approver_Email__c;
              }
              
              //TODO: recheck  this logic based on mapping of behalfofPartner to Reseller/Distributor
              //xSP change
              Id geoCheckAccId;
              if(opp.Type.equalsIgnoreCase('XSP')){
                  geoCheckAccId = opp.AccountId;
              }else{
                  geoCheckAccId = Opp.Reseller__c;
              }
              Account reseller = [select Geo__c from Account where Id =:geoCheckAccId];
              System.debug('========reseller======'+reseller);
              List<Deal_Reg_Approvers__c> DRAs = [Select Id, Approver__c from Deal_Reg_Approvers__c where Deal_Registration_Program__c = :dealProgram.Id and Region__c =:reseller.Geo__c];
                            System.debug('========DRAs======'+DRAs);

              if(DRAs != null && DRAs.size() > 0){
                opp.First_Approver__c =  DRAs[0].Approver__c;
              }
              
              String solutionProviderCamPmfKey;
              String velocitySellerCamPmfKey;
              User currentUser = [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
           if(currentUser.AccountId!=null){
              System.debug('==========currentUser=='+currentUser+'=========currentUser.AccountId==='+currentUser.AccountId);
              Account userAccount = [Select Customer_Category__c, Name, Alliance__c,Velocity_Seller__c,Solution_Provider__c,Service_Provider__c, 
                                      GEO__c, Region_Country__c, Velocity_Seller_Program_Level__c,Velocity_Seller_Type__c,Alliance_Program_Level__c,
                                      Alliance_Type__c,Service_Provider_Program_level__c,Service_Provider_Type__c,Solution_Provider_Program_Level__c,
                                      Solution_Provider_Type__c,Velocity_Seller_CAM_PMFKey__c,Solution_Provider_CAM_PMFKey__c
                                      From Account where Id = :currentUser.AccountId];
              System.debug('=========userAccount======='+userAccount);
               
              solutionProviderCamPmfKey = userAccount.Solution_Provider_CAM_PMFKey__c;
              velocitySellerCamPmfKey = userAccount.Velocity_Seller_CAM_PMFKey__c;
              }  
                        
              Account resellerAccount = null;
              String resellervelocitySellerCamPmfKey;
              boolean ispartnerbehalf = false;
              
              
              if( (opp.Type =='2 Tier') || (opp.Type =='Erwin') && opp.What_is_your_Role__c == 'Distributor') { 
                    ispartnerbehalf = true; 
                    resellerAccount = [select Customer_Category__c, Name,Enterprise_ID__c, Alliance__c,Velocity_Seller__c,Solution_Provider__c,Service_Provider__c, 
                                          GEO__c, Region_Country__c, Velocity_Seller_Program_Level__c,Velocity_Seller_Type__c,Alliance_Program_Level__c,
                                          Alliance_Type__c,Service_Provider_Program_level__c,Service_Provider_Type__c,Solution_Provider_Program_Level__c,
                                          Solution_Provider_Type__c,Velocity_Seller_CAM_PMFKey__c,Solution_Provider_CAM_PMFKey__c
                                          From Account where Id = :opp.Reseller__c];
                    resellervelocitySellerCamPmfKey = resellerAccount.Velocity_Seller_CAM_PMFKey__c;
              }
              
              if(dealProgram.Opp_Type__c.contains('DM')) {
                    User userObj = null;
                    if(velocitySellerCamPmfKey != null && velocitySellerCamPmfKey != '') {
                          try {
                            if(ispartnerbehalf && (resellervelocitySellerCamPmfKey <> null && resellervelocitySellerCamPmfKey <> ''))
                                userObj = [select Id from User where PMFKey__c = :resellervelocitySellerCamPmfKey and isActive = true LIMIT 1];
                            else    
                                userObj = [select Id from User where PMFKey__c = :velocitySellerCamPmfKey and isActive = true LIMIT 1];
                          }
                          catch(Exception e) {}
                    }               
                    if(userObj != null) {               
                            opp.OwnerId = userObj.Id;
                    } 
                    else {
                        if(dealProgram.First_Approver__c <> null) 
                            opp.OwnerId = dealProgram.First_Approver__c;                             
                    }
              }
              else {
                    Account endUserAccountObj = [select RecordTypeId,Segment__c,OwnerId from Account where Id = :opp.AccountId LIMIT 1];
                    if(endUserAccountObj.RecordTypeId == SystemIdUtility.getAccountTeamAcctRecordTypeId())
                    {
                        if(endUserAccountObj.OwnerId != null) {
                            opp.OwnerId = endUserAccountObj.OwnerId;
                        }
                        else {
                            opp.OwnerId = dealProgram.First_Approver__c;
                        }
                    }
                    else if(endUserAccountObj.RecordTypeId == SystemIdUtility.getTerritoryAcctRecordTypeId() || endUserAccountObj.RecordTypeId == SystemIdUtility.getSMBAcctRecordTypeId())
                    {
                        User userObj = null;
                        if(solutionProviderCamPmfKey != null && solutionProviderCamPmfKey != '') {
                            try {
                                userObj = [Select Id from User where PMFKey__c = :solutionProviderCamPmfKey and isActive = true LIMIT 1];
                            }
                            catch(Exception e){}
                        }
                        if(userObj != null) {
                            opp.OwnerId = userObj.Id;
                        }
                        else{
                            opp.OwnerId = dealProgram.First_Approver__c;
                        }
                    }
              }
               OpportunityTeamMember otm = new OpportunityTeamMember();
               otm.TeamMemberRole = 'Owner';
               otm.OpportunityId = opp.Id;
               otm.UserId = opp.Ownerid;
               insert otm;
              //Added to give read/Write to owner
               List<OpportunityShare> lstOS=new List<OpportunityShare>();
               OpportunityShare os =new OpportunityShare ();
                      os.OpportunityId=opp.Id ;
                      os.UserOrGroupId=opp.Ownerid;
                      os.OpportunityAccessLevel='edit';
                      lstOS.add(os);
                if(lstOS.size() > 0) //Common for All Opp Team additions
                {       Database.saveResult[] MySaveResult1 = Database.insert(lstOS,false);
                    
                     for (integer i=0; i < MySaveResult1.size(); i++) {
                                     database.saveResult sr1 = MySaveResult1[i];
                         System.debug('____sr1____in partner opporutnity class***** '+sr1+lstOS);
                      }                                        
                         lstOS = new List<OpportunityShare>();
                }
             /* 
              //Added for removing team members 
            system.debug('block number 7 delete oppteammember');
            OpportunityTeamMember DeleteOppTeamMember = [ SELECT id, UserId FROM OpportunityTeamMember 
                                                                        WHERE OpportunityId = : opportunityId AND TeamMemberRole = 'Channel Account Manager' limit 1 ] ;
                                                                                
            if( DeleteOppTeamMember != null ){
            
                try{
                system.debug('block number 7 delete execute');
                    Database.Delete( DeleteOppTeamMember );
                    
                }catch( DMLException ex ){
                    trigger.new[0].adderror(ex);
                    system.debug('*** OpportunityLineItemGateway ***: Exception while deleting Opp Sales Teams --> '+ex );
        
                }
                
            } */
            
            //Ar 3333 : this part gets program details for all the multiprogram products and adds that to email 
            system.debug('oliList-----'+oliList);
            for(OpportunityLineItem oli : oliList){
                system.debug('Deal_Program_ID__c'+oli.Deal_Program_ID__c);
                if(oli.Deal_Program_ID__c != null && String.ValueOf(oli.Deal_Program_ID__c).contains(';')){ 
                    allProgsWithRank = string.valueOf(oli.Deal_Program_ID__c).split(';');
                    
                    for(string prgName:allProgsWithRank){
                         string PrgNumber = prgName.substring(0,8);
                         allProgramsNumber.add(PrgNumber);
                       if(oliProgNumberMap.get(oli.id)!=null){
                         set<string> allProgsNumber=new set<string>();
                         allProgsNumber=oliProgNumberMap.get(oli.id);
                         allProgsNumber.add(PrgNumber);
                         oliProgNumberMap.put(oli.id,allProgsNumber);
                       }
                       else
                       {
                         set<string> allProgsNumber=new set<string>();
                         allProgsNumber.add(PrgNumber);
                         oliProgNumberMap.put(oli.id,allProgsNumber);
                       }
                        
                    }
                
                }
            }
            system.debug('allProgramsNumber---'+allProgramsNumber);
              system.debug('oliProgNumberMap---'+oliProgNumberMap);
            List<Deal_Registration_Program__c> dealPrograms = [SELECT Id,
                                     opp_type__c,
                                     Program_Manager__r.Email, Finance_Approver_Email__c,Name, Program_Manager__c,Partner_Friendly_Name__c,End_Date__c, 
                                                                       First_Approver__c,Deal_Program_Number__c,Expiry_Days__c FROM Deal_Registration_Program__c 
                                                                       WHERE Deal_Program_Number__c in :allProgramsNumber];
            
              system.debug('dealPrograms----'+dealPrograms);
              //populating name map
            for(OpportunityLineItem oli : oliList){
              for(Deal_Registration_Program__c dealPgrm : dealPrograms){
                if(oli.Deal_Program_ID__c != null ){ 
                  if(oliProgNumberMap.get(oli.id).contains(dealPgrm.Deal_Program_Number__c)){
                    if(oliProgNameMap.get(oli.id)!=null){
                         set<string> allProgsName=new set<string>();
                         allProgsName=oliProgNameMap.get(oli.id);
                         allProgsName.add(dealPgrm.name);
                         oliProgNameMap.put(oli.id,allProgsName);
                       }
                       else
                       {
                         set<string> allProgsName=new set<string>();
                         allProgsName.add(dealPgrm.name);
                         oliProgNameMap.put(oli.id,allProgsName);
                       }
                  }
                }
              }
            }   
            
            String groupName = label.MultiProgResolvers_PRM_ID;
            List<User> results =[select Name, Email from User where id in ( Select UserOrGroupId From GroupMember Where GroupId =:label.MultiProgResolvers_PRM_ID)];
            String accId='';
            if(Opp.Type == '2 Tier' && Opp.Distributor_6__c != null ){
                accId = Opp.Distributor_6__c;
            }        
            else if((Opp.Type=='2 Tier' || Opp.Type=='Erwin' )&& (Opp.What_is_your_Role__c=='Reseller')&& (opp.Reseller__c <> null && opp.Reseller__c <> '') )
                accId = Opp.Reseller__c;
            else{
                accId = currentUser.AccountId;
            }
            Account eligibleAccount = [Select id,Enterprise_ID__c,Name from Account where id=:accId];
                
            for(OpportunityLineItem oli : oliList){
                if(oli.Deal_Program_ID__c != null && String.ValueOf(oli.Deal_Program_ID__c).contains(';')){ 
                  List<string> toEmailAddresses = new List<String>(); 
                  for(User usr:results){
                      toEmailAddresses.add(usr.Email);
                  }            
                    //call email template and sende email block here.
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setReplyTo('donotreply@salesforce.com'); 
                    mail.setSenderDisplayName('Salesforce Support');
                    mail.setToAddresses(toEmailAddresses);
                    mail.setSubject('Please Action: Multiple Active Programs for the same Product');
                    //mail.setHtmlBody('Hi,' + '<br/><br/>' + 'During verification of Opportunity Products for the '+ '<b>' + eligibleAccount.Enterprise_ID__c + '-'+ eligibleAccount.Name + ' </b> the application encountered more than one active Deal Registration Program for the Product, <b>'+ oli.Product2.Name + '</b> of the Product Group <b>' + oli.Product_Group__C +'</b> </b></b>Deal Program Numbers : '+ oliProgNumberMap.get(oli.id) +'</b></b></b> and Deal Program Names : '+ oliProgNameMap.get(oli.id)+'.');
                    mail.setHtmlBody('Hi,' + '<br/><br/>' + 'During verification of the Products line Items for <b>'+opp.name+'</b><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/partner/'+opp.id+'">(click here)</a> the application encountered more than one active Deal Registration Program '+ oliProgNameMap.get(oli.id)+' for <b>'+ oli.Product2.Name+'</b>.<br/><br/><br/>Please take the action to update the Deal Registration Programs accordingly to ensure the same product is not eligible on multiple programs.<br/><br/>Thanks');
                    mail.setBccSender(false);
                    email.add(mail);
                }
             }           
             try {
                    Messaging.sendEmail(email);       
             }
             catch(EmailException ex)
             {
                System.debug('########### Email not Sent-'+ex);
             }
             update opp; 
             //SINJY02 : Added for AR : 3785
               
               List<OpportunityTeamMember> OTMList = new List<OpportunityTeamMember>();
               OTMList = [select UserId,TeamMemberRole,OpportunityId from OpportunityTeamMember where OpportunityId = :opp.id];
                  List<OpportunityShare> listofOS = new List<OpportunityShare>();        
                  
                  system.debug('opp.Ownerid '+opp.Ownerid+' OTMList >'+OTMList);
                  for(OpportunityTeamMember otm1 : OTMList){
                  if(otm1.TeamMemberRole == 'Owner' && otm1.UserId != opp.Ownerid){
                      otm1.TeamMemberRole = 'Partner';
                      OpportunityShare osOld =new OpportunityShare();
                      osOld.OpportunityId = opp.Id ;
                      osOld.UserOrGroupId = otm1.UserId;
                      osOld.OpportunityAccessLevel = 'edit';
                      listofOS.add(osOld);
                      system.debug('in team'+OTMList+' otm1.UserId>'+otm1.UserId);
                  
                  }if(otm1.UserID == opp.Ownerid && otm1.TeamMemberRole != 'Owner'){
            system.debug('Owner Role Change'+otm1.UserID);
            otm1.TeamMemberRole = 'Owner';
            OpportunityShare osOld =new OpportunityShare();
                      osOld.OpportunityId = opp.Id ;
                      osOld.UserOrGroupId = otm1.UserId;
                      osOld.OpportunityAccessLevel = 'edit';
                      listofOS.add(osOld);
                  }
              }
              update OTMList; 
        //SINJY02 : Added for AR 3785
              if(!listofOS.isEmpty()) {
                 system.debug('osOld>'+listofOS);
                 insert listofOS;
                 system.debug('OS inserted');
                //Added to give read/Write to owner
                }   //SINJY02 : Added for AR 3785 : ends
              // ends here        
          }
          catch(DMLException e){
            System.debug('DMLException :'+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));           
            System.debug('Error message:'+e.getDmlMessage(0));
            string errorMsg = e.getDmlMessage(0);
            return errorMsg;
          }
          catch(Exception e1){
            System.debug('Exception :'+e1.getMessage());
            return e1.getMessage();
          } 
          
          return 'true';
          
    } // end of updateRecordType method
    
    @RemoteAction
    public static void sendEmailForMultiplePrograms(String opportunityId){
        try{
            list<string> allProgsWithRank = new list<string>();
            set<string> allProgramsNumber = new set<string>();
            //list<string> allProgsName = new list<string>();
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            Map<ID, Set<String>> oliProgNumberMap = new Map<ID, Set<String>>();
            Map<ID, Set<String>> oliProgNameMap = new Map<ID, Set<String>>();
            List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
            oliList=[select id,OpportunityId,Deal_Program_ID__c,name,RejectedByCA__c ,Deal_Program_Eligibility_Status__c,Product_Group__C,Product2.Name from OpportunityLineItem where OpportunityId =:opportunityId];
            
            for(OpportunityLineItem oli : oliList){
                if(oli.Deal_Program_ID__c != null && String.ValueOf(oli.Deal_Program_ID__c).contains(';')){ 
                    allProgsWithRank = string.valueOf(oli.Deal_Program_ID__c).split(';');
                    //allProgramsNumber = new list<string>();
                    for(string prgName:allProgsWithRank){
                         string PrgNumber = prgName.substring(0,8);
                         allProgramsNumber.add(PrgNumber);
                       if(oliProgNumberMap.get(oli.id)!=null){
                         set<string> allProgsNumber=new set<string>();
                         allProgsNumber=oliProgNumberMap.get(oli.id);
                         allProgsNumber.add(PrgNumber);
                         oliProgNumberMap.put(oli.id,allProgsNumber);
                       }
                       else
                       {
                         set<string> allProgsNumber=new set<string>();
                         allProgsNumber.add(PrgNumber);
                         oliProgNumberMap.put(oli.id,allProgsNumber);
                       }
                    }
                }
            }
            List<Deal_Registration_Program__c> dealPrograms = [SELECT Id,
                                    opp_type__c,
                                    Program_Manager__r.Email, Finance_Approver_Email__c,Name, Program_Manager__c,Partner_Friendly_Name__c,End_Date__c, 
                                                                       First_Approver__c,Deal_Program_Number__c,Expiry_Days__c FROM Deal_Registration_Program__c 
                                                                       WHERE Deal_Program_Number__c in :allProgramsNumber];
            
            //populating name map
            for(OpportunityLineItem oli : oliList){
              for(Deal_Registration_Program__c dealPgrm : dealPrograms){
                if(oli.Deal_Program_ID__c != null && String.ValueOf(oli.Deal_Program_ID__c).contains(';')){ 
                  if(oliProgNumberMap.get(oli.id).contains(dealPgrm.Deal_Program_Number__c)){
                    if(oliProgNameMap.get(oli.id)!=null){
                         set<string> allProgsName=new set<string>();
                         allProgsName=oliProgNameMap.get(oli.id);
                         allProgsName.add(oli.name);
                         oliProgNameMap.put(oli.id,allProgsName);
                       }
                       else
                       {
                         set<string> allProgsName=new set<string>();
                         allProgsName.add(oli.name);
                         oliProgNameMap.put(oli.id,allProgsName);
                       }
                    }
                  }
                }
            }                                                                      
           //Ask if there will be more than 10 email invocations for this or else implement one mail list for all Not Eligible programs and Change the langause for the mail being sent.
            Opportunity opp = [select id,name,RecordTypeId,RecordType.Name,Deal_Registration_Program__c,Deal_Expiration_Date__c,Deal_Registration_Submitted_Date__c,Distributor_6__c,
                                    StageName,What_is_your_Role__c,Initiated_By__c,Source__c,Partner_Engagement__c,Finance_Email__c,First_Approver__c,Type,Reseller__c,OwnerId
                                    from Opportunity where id = :opportunityId];
            if(opp.RecordType.Name == 'Deal Registration'){
                 Deal_Registration_Program__c dealProgram = [SELECT Id,
                                      opp_type__c,
                                      Program_Manager__r.Email, Finance_Approver_Email__c,Name, Program_Manager__c,Partner_Friendly_Name__c,End_Date__c, 
                                                                           First_Approver__c,Deal_Program_Number__c,Expiry_Days__c FROM Deal_Registration_Program__c 
                                                                           WHERE Id= :opp.Deal_Registration_Program__c LIMIT 1];//,Opp_Type__c 3270
                
                // User currentUser;
                 String accId='';
                 if(Opp.Type == '2 Tier' && Opp.Distributor_6__c != null ){
                    accId = Opp.Distributor_6__c;
                 }        
                 else if((Opp.Type=='2 Tier' || Opp.Type=='Erwin' )&& (Opp.What_is_your_Role__c=='Reseller')&& (opp.Reseller__c <> null && opp.Reseller__c <> '') )
                    accId = Opp.Reseller__c;
                 else{
                    User currentUser = [Select UserType, IsPortalEnabled, AccountId, ContactId, DefaultCurrencyIsoCode From User WHERE Id = :UserInfo.getUserId() LIMIT 1];
                    accId = currentUser.AccountId;
                 }  
                 
                 Account eligibleAccount = [Select id,Enterprise_ID__c,Name from Account where id=:accId];
                 system.debug('eligibleAccount'+eligibleAccount);
                 String groupName = label.MultiProgResolvers_PRM_ID;
                 List<User> results =[select Name, Email from User where id in ( Select UserOrGroupId From GroupMember Where GroupId =:label.MultiProgResolvers_PRM_ID)];
                  
                 for(OpportunityLineItem oli : oliList){
                   if(oli.Deal_Program_ID__c != null &&  String.ValueOf(oli.Deal_Program_ID__c).contains(';')){ 
                         List<string> toEmailAddresses = new List<String>(); 
                         for(User usr:results){
                             toEmailAddresses.add(usr.Email);
                         }        
                        //call email template and send email block here.
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setReplyTo('donotreply@salesforce.com'); 
                        mail.setSenderDisplayName('Salesforce Support');
                        mail.setToAddresses(toEmailAddresses);
                        mail.setSubject('Please Action: Multiple Active Programs for the same Product');
                        //mail.setHtmlBody('Hi,' + '<br/><br/>' + 'During verification of Opportunity Products for the '+ '<b>' + eligibleAccount.Enterprise_ID__c + '-'+ eligibleAccount.Name + ' </b> the application encountered more than one active Deal Registration Program for the Product, <b>'+ oli.Product2.Name + '</b> of the Product Group <b>' + oli.Product_Group__C +'</b> </b></b>Deal Program Numbers : '+ oliProgNumberMap.get(oli.id) +'</b></b></b> and Deal Program Names : '+ oliProgNameMap.get(oli.id)+'.');
                        mail.setHtmlBody('Hi,' + '<br/><br/>' + 'During verification of the Products line Items for <b>'+opp.name+'</b><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/partner/'+opp.id+'">(click here)</a> the application encountered more than one active Deal Registration Program '+ oliProgNameMap.get(oli.id)+' for <b>'+ oli.Product2.Name+'</b>.<br/><br/><br/>Please take the action to update the Deal Registration Programs accordingly to ensure the same product is not eligible on multiple programs.<br/><br/>Thanks');
                        mail.setBccSender(false);
                        email.add(mail);                    
                    }
                 } 
                 if(email != null){
                    try
                    {
                        Messaging.sendEmail(email);       
                    }
                    catch(EmailException ex)
                    {
                        System.debug('########### Email not Sent-'+ex);
                    }
                }
            }               
        }
        catch(Exception e){
            System.debug('Exception :'+e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,e.getMessage()));                   
        }
    }   
    
}