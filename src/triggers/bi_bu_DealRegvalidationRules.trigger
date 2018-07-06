trigger bi_bu_DealRegvalidationRules on Opportunity (before insert, before update) {
      
        

      if(SystemIdUtility.skipOpportunityTriggers)
                return;
                
         //List <Opportunity> oppDelete = New List<Opportunity>();
         set<Id> oppDelete = new set<Id>();
         set<Id> oppMergeIds = new set<Id>();
         Set<Id> partnerAccounts = new Set<Id>();
         Set<String> spCAMUserPMFKeys = new Set<String>();
         Map<Id,Id> spAcc_Opp_Map = new Map<Id,Id>();
         Map<String,Id> spPMFKEY_Opp_Map = new Map<String,Id>();
         Set<Id> newParentOpp = new Set<Id>();
         Set<Id> endUserNewOppAccounts = new Set<Id>();
         Map<Id,Id> endUser_NewOppMap = new Map<Id,Id>();
         Set<Id> oppIdsForSubmissionEmail = new Set<Id>();     
         Set<Id> oppIdsForApprovalEmail = new Set<Id>();
         Set<Id> oppIdsForRejectionEmail = new Set<Id>();
         Set<Id> oppIdsForRecallEmail = new Set<Id>();   //added by vasantha for PRM5.5
         Set<Id> oppIdsForResubmissionEmail = new Set<Id>();                //JAINA04
         Set<Id> oppIdsForResubmissionApprovalEmail = new Set<Id>();        //JAINA04
         Set<Id> oppIdsForResubmissionRecallEmail = new Set<Id>();          //JAINA04
         //Set<Id> oppIdsForResubmissionRejectionEmail = new Set<Id>();       //JAINA04
        // Set<Id> oppIdsForResubmissionModifyingEmail = new Set<Id>();       //JAINA04
         //Set<Id> ExpirationDateModifiedAfterApproval = new Set<Id>();       //JAINA04
         Set<Id> oppIdsForDealWonByAnother = new Set<Id>();
         Set<Id> oppIdsForDealLost = new Set<Id>();
         Set<Id> oppIdsForDealWon = new Set<Id>();
         Map<Id,List<String>> id_addEmails_map = new Map<Id,List<String>>();
         List<String> addEmails = null;
         Set<Id> dealPrgm = new Set<Id>();
         Map<Id,Id> dealProgram_OppMap = new Map<Id,Id>();
         Map<Id,Deal_Registration_Program__c> opp_DealMap = new Map<Id, Deal_Registration_Program__c>();
         
         List<OpportunityTeamMember> salesTeamList = new List<OpportunityTeamMember>();
         OpportunityTeamMember salesTeamMember;
         List<OpportunityShare> lstOS = new List<OpportunityShare>();
      
         RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Deal Registration');
         Id dealRegOppRecordTypeID;
    	 if(rec!=null)
    		dealRegOppRecordTypeID = rec.RecordType_Id__c;
         
         rec = RecordTypes_Setting__c.getValues('New Opportunity');
    	 Id newOppRecordTypeID;
    	 if(rec!=null)
         	newOppRecordTypeID = rec.RecordType_Id__c;
       
         List <Opportunity> oppMerge = New List<Opportunity>();
         set <Id> oppToMergeIds = new Set<id>();
         map <Id,Opportunity> oppToMergeMap = new Map<Id,Opportunity>();
         
        

       

       DealProgramEligibility dealPrmEligible = new DealProgramEligibility();
       
         //if(oppDeal.size() > 0 )
         {
            for(Opportunity opp: Trigger.new)       
           {
            system.debug('************' + opp.RecordTypeId + '################' + dealRegOppRecordTypeID);
            if(opp.Opportunity_Merge__c != null && opp.RecordTypeId == dealRegOppRecordTypeID)
             {
               system.debug('opp.Id, Opportunity_Merge__c --> ' + opp.Id + ' , ' + opp.Opportunity_Merge__c);
               oppToMergeIds.add(opp.Opportunity_Merge__c);               
             }         
           }       
          }
    
       List<Opportunity> oppsToMerge =new List<Opportunity>();
       if(oppToMergeIds.size() > 0 )
       {
       oppsToMerge = [select Id,Reseller__c,Type,Sales_Milestone_Search__c,StageName,Opportunity_Type__c,CloseDate,RecordTypeId,Source__c,Deal_Registration_Submitted_Date__c,Deal_Expiration_Date__c,Reseller_Contact__c,Deal_Approval_Status__c,Deal_Registration_Status__c,End_User_Contact__c,End_User_Contact_Title__c ,End_User_Contact_Phone__c ,End_User_Contact_Mobile__c,End_User_Contact_Fax__c,Partner_Engagement__c,Reason__c,Other_Fulfillment_Only_Reason__c,Deal_Registration_Program__c,Deal_Program__c,Registering_on_behalf_of_Partner__c ,Additional_Deal_Registration_Information__c,Deal_Account_Name__c from Opportunity where Id =:oppToMergeIds ];
        system.debug('oppsToMerge --> ' + oppsToMerge );               
       }
       
       boolean flag = false;
       String errMsg = ''; 

       if(oppsToMerge.size() > 0 )
       {
         for(Opportunity oppMer : oppsToMerge ){           
           oppToMergeMap.put(oppMer.Id,oppMer);
          }
             errMsg = '';
           for(Opportunity opp: Trigger.new)
           {
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null && oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller__c !=  opp.Reseller__c)
           {
             flag = true;              
             //errMsg = errMsg  + 'Opportunity To Merge partners do not match' ;
             //opp.addError(
             errMsg = errMsg  + 'Opportunity To Merge partners do not match <br>';
            
           }
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null &&  oppToMergeMap.get(opp.Opportunity_Merge__c).Source__c == 'Deal Registration')              
           {
              flag = true;              
              //opp.addError(
              errMsg = errMsg  + 'Opportunity To Merge Source should not be Deal Registration <br>';
            
           }
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null &&  oppToMergeMap.get(opp.Opportunity_Merge__c).RecordTypeId != newOppRecordTypeID)           
           {
              flag = true;
              //opp.addError(
              errMsg = errMsg  + 'Opportunity To Merge Record Type should be NewOpportunity <br>';
                          system.debug(errMsg);
           }
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null &&  oppToMergeMap.get(opp.Opportunity_Merge__c).StageName == Label.Opp_Stage_Closed_Lost ||  oppToMergeMap.get(opp.Opportunity_Merge__c).StageName == Label.Opp_Stage_Closed_Won)   
           {
              flag = true;
              //opp.addError(
              errMsg = errMsg  + 'Opportunity To Merge Sales Milestone can not be closed- lost or Closed - Won. <br>';
                          system.debug(oppToMergeMap.get(opp.Opportunity_Merge__c).StageName);
            }
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null &&  oppToMergeMap.get(opp.Opportunity_Merge__c).CloseDate <   Date.today())
           {
              flag = true;
              //opp.addError(
              errMsg = errMsg  + 'Opportunity To Merge close date can not be past <br>';
           }
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null &&  oppToMergeMap.get(opp.Opportunity_Merge__c).Type <> '1 Tier' &&  oppToMergeMap.get(opp.Opportunity_Merge__c).Type <> '2 Tier' ) //edited by SAMTU01 - US270100
           {
              flag = true;
              //opp.addError(
              errMsg = errMsg  + 'Opportunity To Merge should be of type 1 Tier or 2 Tier or DM <br>';
              
           }
           if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null && oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Approval_Status__c == 'Approved and Merged')   
           {
              flag = true;
              //opp.addError(
              
              system.debug('**********' + oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Approval_Status__c);
              errMsg = errMsg  + 'Opportunity To Merge has an alreday been used for merge. <br>';
           }    
             if(errMsg != '')         
                opp.addError(errMsg);
           }           
       }
       
       
       for(Opportunity opp: Trigger.new){
       
        if(Trigger.isUpdate){      

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
            System.debug('-------------source'+opp.Source__c);
            if(opp.Source__c == 'Deal Registration' || opp.Source__c == 'Deal Reg') {
                System.debug('-------------source');
                        
                if(Trigger.newMap.get(opp.Id).Reseller_Sales_Milestone__c == Label.Opp_Stage_Closed_Lost) {
                    if(Trigger.newMap.get(opp.Id).Reseller_Win_Loss_Reason__c != Trigger.oldMap.get(opp.Id).Reseller_Win_Loss_Reason__c ) {
                        if(Trigger.newMap.get(opp.Id).Reseller_Win_Loss_Reason__c == 'Closed By Another Reseller') {
                            System.debug('----->121212');
                            oppIdsForDealWonByAnother.add(opp.Id);                      
                        }
                    }
                }
                if(Trigger.oldMap.get(opp.Id).Reseller_Sales_Milestone__c <> Trigger.newMap.get(opp.Id).Reseller_Sales_Milestone__c) {
                    if(Trigger.newMap.get(opp.Id).Reseller_Sales_Milestone__c == Label.Opp_Stage_Closed_Lost) {
                        System.debug('----->33423434534534');
                        if(Trigger.newMap.get(opp.Id).Reseller_Win_Loss_Reason__c == 'Closed By Another Reseller') {
                            oppIdsForDealWonByAnother.add(opp.Id);                      
                        }
                        oppIdsForDealLost.add(opp.Id);
                    } else if (Trigger.newMap.get(opp.Id).Reseller_Sales_Milestone__c == Label.Opp_Stage_Closed_Won) {
                        oppIdsForDealWon.add(opp.Id);
                    } 
                }
                //If Deal Registration Program is changed 
                if(Trigger.newMap.get(opp.Id).Deal_Registration_Program__c <> Trigger.oldMap.get(opp.Id).Deal_Registration_Program__c   && Trigger.newMap.get(opp.Id).RecordTypeId == dealRegOppRecordTypeID){
                    if(opp.Deal_Registration_Program__c != null){
                        if(opp.Type != '2 Tier'){
                            if(dealPrmEligible.isValidDealRegistrationProgram(opp.Reseller__c,opp.Deal_Registration_Program__c,opp.AccountId,opp.id)){
                                dealPrgm.add(opp.Deal_Registration_Program__c);
                                dealProgram_OppMap.put(opp.Deal_Registration_Program__c, opp.Id);   
                           }
                       }
                       if(opp.Type == '2 Tier'){
                            if(dealPrmEligible.isValidDealRegistrationProgram(opp.Distributor_6__c,opp.Deal_Registration_Program__c,opp.AccountId,opp.id)){
                                dealPrgm.add(opp.Deal_Registration_Program__c);
                                dealProgram_OppMap.put(opp.Deal_Registration_Program__c, opp.Id);   
                           }
                       }
                    }
                    else{
                       // Never Happen now Need to test.
                       // opp.Deal_Registration_Program__c.addError('The Deal Registration Program selected is not eligible for the Partner.');
                    }
                }
            }
          } 
       }
  
       if(dealProgram_OppMap.size() >0)
       {        
            List<Deal_Registration_Program__c> dealProgram = [SELECT Program_Manager__r.Email,Partner_Friendly_Name__c,End_Date__c, 
                                                                       First_Approver__c,Expiry_Days__c FROM Deal_Registration_Program__c 
                                                                       WHERE Id IN :dealPrgm];  
           
              for(Deal_Registration_Program__c dProgram : dealProgram){
                 opp_DealMap.put(dealProgram_OppMap.get(dProgram.Id), dProgram);
              }                                                                          
       }
       
         system.debug('opp_DealMap--> ' + opp_DealMap);    
        for(Opportunity opp: Trigger.new) {
             if(opp.RecordTypeId == dealRegOppRecordTypeID)
             { 
                 if(opp.Source__c == null)
                 {
                   opp.Source__c = 'Deal Registration';       // to fill source field.
                   opp.Initiated_By__c = 'Partner';
                   if(opp.StageName == 'Deal Reg - New')
                       opp.Deal_Registration_Status__c = 'New';
                 } 
              }
        
            if(Trigger.isUpdate){
                 if(opp.RecordTypeId == dealRegOppRecordTypeID){
                    System.debug('inside deal rejection ----'+opp.RecordTypeId);
                    if(opp.Deal_Registration_Status__c =='Deal Rejected') {
                        System.debug('inside deal rejection if ----'+opp.Deal_Registration_Status__c);
                        if(opp.Deal_Rejection_Reason__c =='Other') { 
                            if(opp.Deal_Registration_Rejection_Reason_Other__c ==null) {
                                System.debug('inside deal rejection if other----'+opp.Deal_Rejection_Reason__c); 
                                opp.Deal_Registration_Rejection_Reason_Other__c.addError('Please specify the Other Rejection Reason.'); 
                            }
                        } 
                        else if(opp.Deal_Rejection_Reason__c==null) {
                            System.debug('inside deal rejection if no reason----'+opp.Deal_Rejection_Reason__c); 
                            opp.Deal_Rejection_Reason__c.addError('Rejection Reason cannot be blank, when Deal Approval Status is Rejected.');
                        }               
                    }               
                    
                    if(opp_DealMap.size() > 0){
                        if(opp_DealMap.get(opp.Id) <> null){
                            opp.Deal_Registration_Program__c = opp_DealMap.get(opp.Id).Id;
                            //if(opp_DealMap.get(opp.Id).Program_Manager__r.Email <> null)
                             //   opp.Program_Manager_Email__c = opp_DealMap.get(opp.Id).Program_Manager__r.Email;    
                                opp.Deal_Program__c = opp_DealMap.get(opp.Id).Partner_Friendly_Name__c;  
                            if(opp_DealMap.get(opp.Id).Expiry_Days__c <> null){
                                if(opp.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(opp_DealMap.get(opp.Id).Expiry_Days__c)) < opp_DealMap.get(opp.Id).End_Date__c)
                                    opp.Deal_Expiration_Date__c = opp.Deal_Registration_Submitted_Date__c.addDays(Integer.valueOf(opp_DealMap.get(opp.Id).Expiry_Days__c));
                                else 
                                    opp.Deal_Expiration_Date__c = opp_DealMap.get(opp.Id).End_Date__c;
                            }      

                        }   
                    }
                    
                    //if(Trigger.newMap.get(opp.Id).Deal_Registration_Status__c <> Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c)
                     {                
                        if(Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c != 'Deal Submitted to CA' && 
                             Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA' && opp.Deal_Reg_Initially_Approved__c == false && opp.ResubmissionProducts__c == null  )  
                        {
                             oppIdsForSubmissionEmail.add(opp.Id);                                             
                             //DealRegPDFGenerator dpdf=new DealRegPDFGenerator(opp);                         
                        }
                          system.debug('products changed after approval(old) ' + Trigger.oldMap.get(opp.Id).Products_Changed_After_Approval__c);		                        
                        system.debug('products changed after approval(New) ' + Trigger.newMap.get(opp.Id).Products_Changed_After_Approval__c);		
                        system.debug('Opp deal intially approved(old) ' + Trigger.oldMap.get(opp.Id).Deal_Reg_Initially_Approved__c);		
                        system.debug('Opp deal intially approved(New) ' + Trigger.newMap.get(opp.Id).Deal_Reg_Initially_Approved__c);		
                        system.debug('opp Resubmission value(old)' + Trigger.oldMap.get(opp.Id).Resubmission__c);		
                        system.debug('opp Resubmission value(New)' + Trigger.newMap.get(opp.Id).Resubmission__c);		
                        system.debug('opp resubmission products(old) ' + Trigger.oldMap.get(opp.Id).ResubmissionProducts__c);		
                        system.debug('opp resubmission products new map ' + Trigger.newMap.get(opp.Id).ResubmissionProducts__c);		
                        system.debug('opp deal registration only  ' + opp.Deal_Registration_Status__c);		
                        system.debug('opp deal resubmit auto approve from reject(old) ' + Trigger.oldMap.get(opp.Id).Deal_Resubmit_Auto_Approve_From_Reject__c );		
                        system.debug('opp deal resubmit auto approve from reject(New) ' + Trigger.newMap.get(opp.Id).Deal_Resubmit_Auto_Approve_From_Reject__c );		
                        system.debug('old deal reg status ' + Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c);		
                        system.debug('new deal reg status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                        
                        //JAINA04 Code Starts
                        if(opp.Deal_Reg_Initially_Approved__c == true){
                        if((Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying' || Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'New') && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA' && opp.ResubmissionProducts__c !=null){
                          oppIdsForResubmissionEmail.add(opp.Id);
                          System.debug('Resubmission Added into Set-----> Sent to CA for Approval/Reject');
                          System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                        }
                            /*
                        if(Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Rejected' && Trigger.newMap.get(opp.Id).Products_Changed_After_Approval__c == true){
                                oppIdsForResubmissionRejectionEmail.add(opp.Id);    
                                System.debug('Resubmission Added into Set-----> Rejected ');
                                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                            }
							*/
                            if(Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA' && (Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved' || Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Awaiting Approval') && opp.Resubmission__c == true ){
                                oppIdsForResubmissionApprovalEmail.add(opp.Id);  
                                System.debug('Resubmission Added into Set-----> Approved ');
                                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                            }
                          if(Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'New' && opp.ResubmissionProducts__c !=null){
                                oppIdsForResubmissionRecallEmail.add(opp.Id);     
                                System.debug('Resubmission Added into Set-----> Recalled');
                                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                            }
                                 /*
                                String tempuserId = opp.LastModifiedById;
                                //list<User> tempaccountidofuser = new List<User>();
                                System.debug('Last modified User ID ' + tempuserId);
                                User temp1 = [select Id from User where Id = :UserInfo.getUserId()];
                                User tempuser = [Select Is_Partner_User__c from User where id=: temp1.Id];
                                System.debug('Is partner User? ' + tempuser.Is_Partner_User__c);  
                                Boolean tempforonemail = Checkrunonce.runOnce();
                                System.debug('tempforonemail ' + tempforonemail);
                                System.debug('ResubmissionProducts__c  ' + opp.ResubmissionProducts__c);
                                system.debug('opp resubmission products old map ' + Trigger.oldMap.get(opp.Id).ResubmissionProducts__c);
                                system.debug('opp resubmission products new map ' + Trigger.newMap.get(opp.Id).ResubmissionProducts__c);
                            */
                            /*
                         if(((Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying') || (Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying') ) && tempuser.Is_Partner_User__c != TRUE && tempforonemail == True ){
                                oppIdsForResubmissionModifyingEmail.add(opp.Id); 
                                System.debug('Is partner User? ' + tempuser.Is_Partner_User__c);                            
                                System.debug('Resubmission Added into Set-----> Internal User Modifying the Approved Deal');
                                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                                System.debug('Usertype of Last Modified '+ opp.LastModifiedBy.UserType);
                                
                            
                           }
							*/
     
                            
                        }
                    
                       //JAINA04 Code Ends
                       
                        //added by vasantha for PRM5.5
                        system.debug('Deal registartion Status New Map ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                        system.debug('Deal Resubmitted for Approval : ' + oppIdsForResubmissionEmail);
                        
                         if(opp.Deal_Reg_Initially_Approved__c != true){
                        if((Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved'||
                            Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Rejected' || Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Awaiting Approval') &&
                            (Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Awaiting Approval' || 
                             Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Submitted to CA')) 
                            {
                                system.debug('Deal registartion Status Old Map ' + Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c);
                                   system.debug('Deal registartion Status New Map ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);  
                                                                
                               if(opp.Opportunity_Merge__c != null  && (Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved')) 
                               {                               
                                     oppMergeIds.add(opp.Id);                                    
                               }
                               else
                               {
                                    system.debug('hi -->' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                                      if((Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Rejected') && opp.Deal_Reg_Initially_Approved__c != true)
                                        oppIdsForRejectionEmail.add(opp.Id);
                        		  else if((Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved'||Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Awaiting Approval') && opp.Products_Changed_After_Approval__c == false && opp.Deal_Resubmit_Auto_Approve_From_Reject__c == false){  
                                         oppIdsForApprovalEmail.add(opp.Id);
                                         system.debug('Deal registartion Status Old Map ' + Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c);
                                         system.debug('Deal registartion Status New Map ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                                         system.debug('oppIdsForApprovalEmail  ' +oppIdsForApprovalEmail);
                                   }
                                    system.debug('oppIdsForRejectionEmail -->' + oppIdsForRejectionEmail);
                                    //old functionality (Begin)
                                    opp.RecordTypeId = newOppRecordTypeID;    
                                    //Added by Vikas for PRM6 quickhits
                                    opp.campaignid = opp.Campaign_Name__c;                                    
                                    newParentOpp.add(opp.Id);
                                    //Add Partner to the Sales Team  
                                    //if(opp.Partner_User_Internal__c != opp.ownerID)            //Added for 3785 :SINJY02                      
                                     addOppTeamMember(opp.Partner_User_Internal__c,opp.Id,'Partner',opp.ownerID);                                
                                    //Add Partner Accounts to a List
                                    partnerAccounts.add(opp.Reseller__c);
                                    endUserNewOppAccounts.add(opp.AccountId);
                                    spAcc_Opp_Map.put(opp.Reseller__c,opp.Id);
                                    endUser_NewOppMap.put(opp.AccountId,opp.Id);
                                    //old functionality (end)                                
                                }                                
                            }  
                            
                        }
                     }
                 }
                     ///////else
                    if(Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c != 'Deal Recalled' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Deal Recalled' && opp.Deal_Reg_Initially_Approved__c == true)
                        {
                           Trigger.newMap.get(opp.Id).Deal_Approval_Status__c = 'Deal Recalled';
                           oppIdsForRecallEmail.add(opp.Id);
                        }     
            }
            

        }              
            
       
        //Get Solution Provider CAM for the Partner Accounts
        Map<Id,String> acct_geo_map = new Map<Id,String>();
        if(partnerAccounts.size() > 0){
            List<Account> spCAM = [SELECT Id, Solution_Provider_CAM_PMFKey__c,GEO__c FROM Account WHERE Id IN :partnerAccounts];
            for(Account pAccount :spCAM){
                acct_geo_map.put(pAccount.Id,pAccount.GEO__c);
                if(pAccount.Solution_Provider_CAM_PMFKey__c != null) {
                    spCAMUserPMFKeys.add(pAccount.Solution_Provider_CAM_PMFKey__c);
                    spPMFKEY_Opp_Map.put(pAccount.Solution_Provider_CAM_PMFKey__c,spAcc_Opp_Map.get(pAccount.Id));
                }
            }
        }
        PRM_Email_Notifications p = new PRM_Email_Notifications();
        for(Opportunity oppTemp : Trigger.New) {
            if(oppIdsForSubmissionEmail.contains(oppTemp.Id)) {
                try {
                    system.debug('1234 -->' + id_addEmails_map);
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Submit for Approval', id_addEmails_map.get(oppTemp.Id));
                } catch (Exception e) {
                    //do nothing
                }
            }
               //added by vasantha for PRM5.5
            if(oppIdsForRecallEmail.contains(oppTemp.Id)) {
                try {
                    system.debug('Rejected Emails -->' + oppIdsForRecallEmail);
                    SystemIdUtility.skipOpportunityTriggers = true;
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Deal Recalled', id_addEmails_map.get(oppTemp.Id));
                } catch (Exception e) {
                    //do nothing
                }
            }     
            if(oppIdsForApprovalEmail.contains(oppTemp.Id)) {
                try {                
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Approved-Deal Certificate', id_addEmails_map.get(oppTemp.Id));
                } catch (Exception e) {
                    //do nothing
                }
            }
            if(oppIdsForRejectionEmail.contains(oppTemp.Id)) {
                try {
                    system.debug('1234 -->' + id_addEmails_map);
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Rejected', id_addEmails_map.get(oppTemp.Id));
                } catch (Exception e) {
                    //do nothing
                }
                
            }
            if(oppIdsForDealWonByAnother.contains(oppTemp.Id)) {
                try {
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Deal Won By Another Partner', id_addEmails_map.get(oppTemp.Id));
                    
                } catch (Exception e) {
                    //do nothing
                }
                
            }
            if(oppIdsForDealLost.contains(oppTemp.Id)) {
                try {
                    System.debug('^^^^^^^^^^^^^^^^^^^ deal lost');
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Deal Lost', id_addEmails_map.get(oppTemp.Id));
                } catch (Exception e) {
                    //do nothing
                }
                
            }
            if(oppIdsForDealWon.contains(oppTemp.Id)) {
                try {
                    System.debug('^^^^^^^^^^^^^^^^^^^ deal won');
                    p.sendEmailByUserLocale('Deal Registration',oppTemp.Id,'Deal Won', id_addEmails_map.get(oppTemp.Id));
                } catch (Exception e) {
                    //do nothing
                }
                
            }
            //JAINA04 Code Starts
            if(oppIdsForResubmissionEmail.contains(oppTemp.Id) ){
                try{
                    System.debug('Resubmitted For Approval' + oppIdsForResubmissionEmail);
                    System.debug('Deals Resubmitted to CA for Approval');
                    p.sendEmailByUserLocale('Deal Registration', oppTemp.Id, 'Deal Resubmission - Submit for Approval', id_addEmails_map.get(oppTemp.Id));                    
                }catch(Exception e){
                    //do nothing
                }
            }
              if(oppIdsForResubmissionApprovalEmail.contains(oppTemp.Id) ){
                try{
                    System.debug('Deals Approved after resubmission');
                    p.sendEmailByUserLocale('Deal Registration', oppTemp.Id, 'Deal Resubmission - Approved', id_addEmails_map.get(oppTemp.Id));                    
                }catch(Exception e){
                    //do nothing
                }
            }
             if(oppIdsForResubmissionRecallEmail.contains(oppTemp.Id) ){
                try{
                    System.debug('Deals Recalled after resubmission');
                    p.sendEmailByUserLocale('Deal Registration', oppTemp.Id, 'Deal Resubmission - Recall', id_addEmails_map.get(oppTemp.Id));                    
                }catch(Exception e){
                    //do nothing
                }
            }
            /*
            if(oppIdsForResubmissionRejectionEmail.contains(oppTemp.Id) ){
                try{
                    System.debug('Deals Rejected after resubmission');
                    p.sendEmailByUserLocale('Deal Registration', oppTemp.Id, 'Deal Resubmission - Rejected', id_addEmails_map.get(oppTemp.Id));                    
                }catch(Exception e){
                    //do nothing
                }
            }
			*/
            /*
            if(oppIdsForResubmissionModifyingEmail.contains(oppTemp.Id)){
                try{
                    System.debug('Deals modifying after the initial approval');
                    p.sendEmailByUserLocale('Deal Registration', oppTemp.Id, 'Deal Resubmission - Modifying', id_addEmails_map.get(oppTemp.Id));                        
                }catch(Exception e){
                    //do nothing
                }
			}
			*/
             //JAINA04 Code Ends
                
            /*
            if(ExpirationDateModifiedAfterApproval.contains(oppTemp.Id)){
                try{
                    System.debug('email will be sent as Expiration Date is modified after Sale Approved');
                    p.sendEmailByUserLocale('Deal Registration', oppTemp.Id, 'Approved-ModifyExpDate', id_addEmails_map.get(oppTemp.Id));
                        
                }  
                catch(Exception e){
                    //Do Nothing
                }
            }
            */
        }
        
        //Get Users associated to the solution provider CAM PMF Key
        if(spCAMUserPMFKeys.size() >0){
            System.debug('spCAMUserPMFKeys -----'+spCAMUserPMFKeys);
            List<User> spCAMUsers = [SELECT Id, PMFKey__c FROM User WHERE PMFKey__c IN : spCAMUserPMFKeys and isActive = true];
            System.debug('spCAMUsers -----'+spCAMUsers.size());
            //Add the Users to the salesTeam List
            for(User spCAMUser :spCAMUsers){ 
              for (opportunity oppTemp : trigger.new){   //Added for 3785 :SINJY02       
                  //if(spCAMUser.Id != oppTemp.ownerID){
                     addOppTeamMember(spCAMUser.Id,spPMFKEY_Opp_Map.get(spCAMUser.PMFKey__c),'Partner',oppTemp.ownerID);
                  //}           
              }
               
            }
        }
        try{
            //Get End User Account owners for Account Team Covered and Territory Team Covered
            if(endUserNewOppAccounts.size() >0)
            {
                List<Account> endUserNewOppAccs = [SELECT Id, OwnerId,RecordType.Name FROM Account WHERE Id IN :endUserNewOppAccounts AND owner.isactive = true ];
                for(Account endUserNewOppAcc : endUserNewOppAccs)
                {
                    if(endUserNewOppAcc.RecordType.Name == 'Account Team Covered Account' || endUserNewOppAcc.RecordType.Name == 'Territory Covered Account')
                    {
                        if(endUser_NewOppMap.get(endUserNewOppAcc.Id) <> null && endUser_NewOppMap.get(endUserNewOppAcc.Id) <> null )
                        {
                            for (opportunity oppTemp : trigger.new){   //Added for 3785 :SINJY02       
                                  //if(endUserNewOppAcc.OwnerId != oppTemp.ownerID)          //Added for 3785 :SINJY02  
                                    addOppTeamMember(endUserNewOppAcc.OwnerId, endUser_NewOppMap.get(endUserNewOppAcc.Id), 'Partner',oppTemp.ownerID);
                              }
                            
                        }
                    }
                }
            }
            
            if(oppMergeIds != null && oppMergeIds.size() > 0)
               updateOpportunityMerge(oppMergeIds);
               
            //Insert users into Opportunity Sales Team
            if(salesTeamList != null && salesTeamList.size() > 0)
                //database.upsert(salesTeamList, false); commented by Abinav
                upsert(salesTeamList);
            
            system.debug('*****************lstOS +lstOS.size()' + lstOS+' '+lstOS.size());
             Database.upsertResult[] srList=new list<Database.upsertResult>() ;
             if(lstOS != null ){
             system.debug('agay');
            if(lstOS.isEmpty()==false){
                //database.upsert(lstOS, false);   
                system.debug('agay2');              
              //srList = database.upsert(lstOS, false); commented by Abinav
              upsert(lstOS);                
            }
            }
                for (Database.upsertResult sr : srList) {
        if (sr.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
            System.debug('Successfully inserted account. Account ID: ' + sr.getId());
        }
        else {
            // Operation failed, so get all errors                
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
            }
        }
    }
                
                
        }
        catch(Exception ex){
            System.Debug(ex.getMessage());
        }  
        
      private void addOppTeamMember(id userid, id oppid, string teamrole ,id OppOwnerID)
      {
         OpportunityTeamMember otm = new OpportunityTeamMember();
          if(userid == OppOwnerID) otm.TeamMemberRole = 'Owner'; //added for 3785:Sinjy02
          else otm.TeamMemberRole = teamrole;
          otm.OpportunityId = oppid;
          otm.UserId = userid;
          salesTeamList.add(otm);
          system.debug('in addOppTeamMember ');
          OpportunityShare os =new OpportunityShare ();
          os.OpportunityId=oppid;
          os.UserOrGroupId=userid;
          os.OpportunityAccessLevel='Edit';
          lstOS.add(os);
           system.debug('in addOppTeamMember _ End');
      }
     
      private void updateOpportunityMerge(Set<Id> updateMergeIds)
      {
        system.debug('Entered');
        List <Opportunity> oppDeal = New List<Opportunity>();
        oppDeal = [select Id,First_Approver__c,Second_Approver__c,Third_Approver__c,Reseller_Estimated_Value__c,Deal_program_Formula__c,Reseller_Product_Name__c,Name,Account.Name,Opportunity_Merge__c,Reseller__c,Type,Sales_Milestone_Search__c,StageName,Opportunity_Type__c,CloseDate,RecordTypeId,Source__c,Deal_Registration_Submitted_Date__c,Deal_Expiration_Date__c,Reseller_Contact__c,Deal_Approval_Status__c,Deal_Registration_Status__c,End_User_Contact__c,End_User_Contact_Title__c ,End_User_Contact_Phone__c ,End_User_Contact_Mobile__c,End_User_Contact_Fax__c,Partner_Engagement__c,Reason__c,Other_Fulfillment_Only_Reason__c,Deal_Registration_Program__c,Deal_Program__c,Registering_on_behalf_of_Partner__c ,Additional_Deal_Registration_Information__c,Deal_Account_Name__c from Opportunity where Id =:updateMergeIds ];
        system.debug('oppDeal --> ' + oppDeal );   
        set<Id> Contactids = new set<Id>();
         if(oppDeal.size() > 0 )
         {
            for(Opportunity opp: oppDeal)       
           {
            if(opp.Opportunity_Merge__c != null)
             {
               if(opp.Reseller_Contact__c != null)
                  Contactids.add(opp.Reseller_Contact__c);
               system.debug('opp.Id, Opportunity_Merge__c --> ' + opp.Id + ' , ' + opp.Opportunity_Merge__c);
               oppToMergeIds.add(opp.Opportunity_Merge__c);               
             }         
           }       
          }
       
       //List<Opportunity> oppsToMerge =new List<Opportunity>();
       if(oppToMergeIds!= null){
       oppsToMerge = [select Id,First_Approver__c,Second_Approver__c,Third_Approver__c,Reseller_Estimated_Value__c,Reseller_Product_Name__c,Deal_Registration_Name__c,Reseller__c,Type,Sales_Milestone_Search__c,StageName,Opportunity_Type__c,CloseDate,RecordTypeId,Source__c,Deal_Registration_Submitted_Date__c,Deal_Expiration_Date__c,Reseller_Contact__c,Deal_Approval_Status__c,Deal_Registration_Status__c,End_User_Contact__c,End_User_Contact_Title__c ,End_User_Contact_Phone__c ,End_User_Contact_Mobile__c,End_User_Contact_Fax__c,Partner_Engagement__c,Reason__c,Other_Fulfillment_Only_Reason__c,Deal_Registration_Program__c,Deal_Program__c,Registering_on_behalf_of_Partner__c ,Additional_Deal_Registration_Information__c,Deal_Account_Name__c from Opportunity where Id =:oppToMergeIds ];
        }
        system.debug('oppsToMerge --> ' + oppsToMerge );               
       set<Id> dealProgForMerge = new set<Id>();       
       Map<Id,Deal_Registration_Program__c> dealProgram_OppMergeMap = new Map<Id,Deal_Registration_Program__c>();
       Map<Id,Id> contactUsrMap = new Map<Id,Id>();

       if(oppsToMerge.size() > 0 )
       {
         for(Opportunity oppMer : oppsToMerge ){           
           oppToMergeMap.put(oppMer.Id,oppMer);
           if(oppMer.Reseller_Contact__c != null)           
              Contactids.add(oppMer.Reseller_Contact__c);
           dealProgForMerge.add(oppMer.Deal_Registration_Program__c);

          }         
       }

       if(Contactids.size() > 0 )
       {
         system.debug(Contactids);
         for(User usr : [select Id,Contact.Id from User where Contact.Id IN : Contactids]){
             contactUsrMap.put(usr.Contact.Id,usr.Id);
          }
       }

       if(dealProgForMerge.size() > 0)
       {
            List<Deal_Registration_Program__c> dealProgram = [SELECT Id,Partner_Friendly_Name__c FROM Deal_Registration_Program__c 
                                                                       WHERE Id IN :dealProgForMerge];  
              for(Deal_Registration_Program__c dProgram : dealProgram){
                 dealProgram_OppMergeMap.put(dProgram.Id, dProgram);
              }                                                                                                                                                        
       }
        if(oppDeal.size()>0){
        for(Opportunity opp: oppDeal)
       {   
            if(oppToMergeMap != null && oppToMergeMap.get(opp.Opportunity_Merge__c) != null ){
                 oppToMergeMap.get(opp.Opportunity_Merge__c).End_User_Contact__c = opp.End_User_Contact__c; 
                 oppToMergeMap.get(opp.Opportunity_Merge__c).End_User_Contact_Title__c = oppToMergeMap.get(opp.Opportunity_Merge__c).End_User_Contact_Title__c ;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).End_User_Contact_Phone__c = opp.End_User_Contact_Phone__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).End_User_Contact_Mobile__c= opp.End_User_Contact_Mobile__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).End_User_Contact_Fax__c= opp.End_User_Contact_Fax__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Partner_Engagement__c= opp.Partner_Engagement__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Reason__c= opp.Reason__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Other_Fulfillment_Only_Reason__c= opp.Other_Fulfillment_Only_Reason__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Registration_Program__c= opp.Deal_Registration_Program__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Registering_on_behalf_of_Partner__c = opp.Registering_on_behalf_of_Partner__c ;

                 oppToMergeMap.get(opp.Opportunity_Merge__c).Additional_Deal_Registration_Information__c = opp.Additional_Deal_Registration_Information__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Registration_Status__c = 'Sale Approved';
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Approval_Status__c = 'Approved and Merged';
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Registration_Submitted_Date__c= opp.Deal_Registration_Submitted_Date__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Expiration_Date__c= opp.Deal_Expiration_Date__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Registration_Name__c = opp.Name;

                 oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller_Estimated_Value__c= opp.Reseller_Estimated_Value__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller_Product_Name__c= opp.Reseller_Product_Name__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Account_Name__c= opp.Account.Name;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).First_Approver__c = opp.First_Approver__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Second_Approver__c= opp.Second_Approver__c;
                 oppToMergeMap.get(opp.Opportunity_Merge__c).Third_Approver__c= opp.Third_Approver__c;

                            
                 //if(dealProgram_OppMergeMap.size() > 0)                                         
                     oppToMergeMap.get(opp.Opportunity_Merge__c).Deal_Program__c= opp.Deal_program_Formula__c;

                 //if(oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller_Contact__c != opp.Reseller_Contact__c)
                 {
                
                    if(oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller_Contact__c != null )
                       if(contactUsrMap.size() > 0 )
                              addOppTeamMember(contactUsrMap.get(oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller_Contact__c),oppToMergeMap.get(opp.Opportunity_Merge__c).Id,'Partner',oppToMergeMap.get(opp.Opportunity_Merge__c).OwnerID);
                         oppToMergeMap.get(opp.Opportunity_Merge__c).Reseller_Contact__c = opp.Reseller_Contact__c;          
                       if(opp.Reseller_Contact__c != null)                    
                       {
                          system.debug('hi');
                          system.debug('opp.Reseller_Contact__c --> ' + opp.Reseller_Contact__c);
                              addOppTeamMember(contactUsrMap.get(opp.Reseller_Contact__c),oppToMergeMap.get(opp.Opportunity_Merge__c).Id,'Partner',oppToMergeMap.get(opp.Opportunity_Merge__c).OwnerID);                                            
                       }
                              
                  }      
               if(oppToMergeMap.get(opp.Opportunity_Merge__c) != null)
               { 
                 oppMerge.add(oppToMergeMap.get(opp.Opportunity_Merge__c) );
               }               
               oppDelete.add(opp.Id);
          }
       }
       }       
         if(oppMerge.size() > 0 )            
         {
            update oppMerge;
            if(oppDelete.size() > 0  && oppDelete != null)
           {
            CreatePartnerUserDataOnUserUpdate.DeleteDealRegAfterMerge(oppDelete);
           }
         }
      }
    }