trigger OpportunityTrigger on Opportunity(after delete, after insert, after update, before delete, before insert, before update)
{
    RecordTypes_Setting__c newOppRec = RecordTypes_Setting__c.getValues('New Opportunity');
    string newOppRecType;
    if(newOppRec!=null)
        newOppRecType = newOppRec.RecordType_Id__c;

    RecordTypes_Setting__c preOppRec = RecordTypes_Setting__c.getValues('Pre Opportunity');
    string preOppRecType;
    if(preOppRec!=null)
        preOppRecType = preOppRec.RecordType_Id__c;
    
    Map<Id,List<String>> id_addEmails_map = new Map<Id,List<String>>();    //jaina04
    List<String> addEmails = null;      //jaina04
    Set<Id> oppIdsForResubmissionModifyingEmail = new Set<Id>();       //JAINA04
    
    public boolean runornot;
    if(SystemIdUtility.skipOpportunityTriggers || SystemIdUtility.skipOpportunityTriggersIntegration)
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
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Opportunity opp : trigger.new) {
            if(opp.StageName == Label.Opp_Stage_10_Percent && trigger.oldMap.get(opp.Id).RecordTypeId == preOppRecType)
                opp.RecordTypeId = newOppRecType;
            else if(opp.StageName == Label.OPP_STAGE_MARKET_NURTURE)
                opp.DateofClosedNurture__c = Date.today();
        }
    }
    
    TriggerFactory.createHandler(Opportunity.sObjectType);
       
    if(Trigger.isAfter&&Trigger.isUpdate )
    {
        
        Set<Id> oppids=new Set<Id>{};
            for(Opportunity o1:Trigger.new)
            
        {
            system.debug('Transaction Type old' + Trigger.oldMap.get(o1.id).Type);
            system.debug('Transaction Type New' + Trigger.newMap.get(o1.id).Type);
            system.debug('what is your role old' + Trigger.oldMap.get(o1.id).What_is_your_Role__c);
            system.debug('what is your role New' + Trigger.newMap.get(o1.id).What_is_your_Role__c);
            system.debug('Account name old' + Trigger.oldMap.get(o1.id).AccountId);
            system.debug('Account name New' + Trigger.newMap.get(o1.id).AccountId);
            system.debug('End User Contact old' + Trigger.oldMap.get(o1.id).End_User_Contact__c);
            system.debug('End User Contact New' + Trigger.newMap.get(o1.id).End_User_Contact__c);
            system.debug('Currency ISO code old' + Trigger.oldMap.get(o1.id).CurrencyIsoCode);
            system.debug('Currency ISO code New' + Trigger.newMap.get(o1.id).CurrencyIsoCode);
            //Jaina04 US360340 Starts

            //JAINA04 US360340 Ends
            if((Trigger.oldMap.get(o1.id).Type!=Trigger.newMap.get(o1.id).Type)||(Trigger.oldMap.get(o1.id).AccountId!=Trigger.newMap.get(o1.id).AccountId)||
               (Trigger.oldMap.get(o1.id).Contract_Type__c!=Trigger.newMap.get(o1.id).Contract_Type__c)||
               (Trigger.oldMap.get(o1.id).Partner_Engagement_Phase__c!=Trigger.newMap.get(o1.id).Partner_Engagement_Phase__c)||
               (Trigger.oldMap.get(o1.id).Reseller__c!=Trigger.newMap.get(o1.id).Reseller__c)||
               (Trigger.oldMap.get(o1.id).Distributor_6__c!=Trigger.newMap.get(o1.id).Distributor_6__c)||
               (Trigger.oldMap.get(o1.id).Partner_1__c!=Trigger.newMap.get(o1.id).Partner_1__c)||
               (Trigger.oldMap.get(o1.id).Partner_Engagement_Phase_2__c!=Trigger.newMap.get(o1.id).Partner_Engagement_Phase_2__c)||
               (Trigger.oldMap.get(o1.id).Alliance_Partner_2__c!=Trigger.newMap.get(o1.id).Alliance_Partner_2__c)||
               (Trigger.oldMap.get(o1.id).Technology_Partner__c!=Trigger.newMap.get(o1.id).Technology_Partner__c)||
               (Trigger.oldMap.get(o1.id).PrimaryPartner4__r.RecordType.Name!=Trigger.newMap.get(o1.id).PrimaryPartner4__r.RecordType.Name)||
               (Trigger.oldMap.get(o1.id).Account.Coverage_Model__c!=Trigger.newMap.get(o1.id).Account.Coverage_Model__c)||
               (Trigger.oldMap.get(o1.id).Account.Account_Type__c!=Trigger.newMap.get(o1.id).Account.Account_Type__c))
            {
                oppids.add(o1.id);
            }
            
            
        }
        if(oppids.size()!=0)
        {
            runornot = shouldIRun.canIRun();
            if(runornot==true){
                system.debug('calling after update primary-----------------');
                
                PrimaryPartner.updateOpportunity(oppids);
            }
            
            
        }
    } 
    //Jaina04 Starts
    /*
    if(Trigger.isAfter&&(Trigger.isUpdate)){   
        for (Opportunity opp: Trigger.new) {
            System.debug('ResubmissionProducts__c  ' + opp.ResubmissionProducts__c);
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
            
            String tempuserId = opp.LastModifiedById;
            list<User> tempaccountidofuser = new List<User>();
            System.debug('Last modified User ID ' + tempuserId);
            // User temp1 = [select Id from User where Id = :UserInfo.getUserId()];
            // if(userInfo.getUserType() == 'Power')
            //User tempuser = [Select Is_Partner_User__c from User where id=: UserInfo.getUserId()];
            String tempuser = userInfo.getUserType();
            System.debug('Is partner User? ' + tempuser);  
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
            system.debug('opportunity Trigger old DR Eligible size '+ Lold.size());
            system.debug('opportunity Trigger New DR Eligible size '+ Lnew.size());
            system.debug('opportunity trigger Deal Reg Expiration Date(New)'+Trigger.newMap.get(opp.Id).Deal_Expiration_Date__c);
            system.debug('opportunity trigger Deal Reg Expiration Date(Old)'+Trigger.oldMap.get(opp.Id).Deal_Expiration_Date__c);
            system.debug('opportunity trigger Deal Reg Status(Old)'+Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c);
            system.debug('opportunity trigger Deal Reg Status(New)'+Trigger.NewMap.get(opp.Id).Deal_Registration_Status__c);
            system.debug('opportunity trigger Deal Reg Initially Approved(Old)'+Trigger.oldMap.get(opp.Id).Deal_Reg_Initially_Approved__c);
            system.debug('opportunity trigger Deal Reg Initially Approved(New)'+Trigger.NewMap.get(opp.Id).Deal_Reg_Initially_Approved__c);
            system.debug('opportunity trigger opp deal resubmit auto approve from reject(old) ' + Trigger.oldMap.get(opp.Id).Deal_Resubmit_Auto_Approve_From_Reject__c );
            system.debug('opportunity trigger opp deal resubmit auto approve from reject(New) ' + Trigger.newMap.get(opp.Id).Deal_Resubmit_Auto_Approve_From_Reject__c );
            System.debug('Is partner User? ' + tempuser);  
            
            //    if((Trigger.newMap.get(opp.Id).DR_Added_Eligible_Products__c != Trigger.oldMap.get(opp.Id).DR_Added_Eligible_Products__c) && Lnew.size()>=Lold.size() ){
            System.debug('Naman partner opp : DR Added Eligible Products '+  opp.DR_Added_Eligible_Products__c);
            if(((Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Sale Approved' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying') || (Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying') || (Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c == 'New' && Trigger.newMap.get(opp.Id).Deal_Registration_Status__c == 'Modifying')) && tempuser != 'PowerPartner' && checkrunoncev3.runOnce()) {
                oppIdsForResubmissionModifyingEmail.add(opp.Id); 
                //tempforonemail = Checkrunonce.runOnce();
                System.debug('Is partner User? ' + tempuser);                            
                System.debug('Resubmission Added into Set-----> Internal User Modifying the Approved Deal');
                System.debug('Deal Reg Old Status '+ Trigger.oldMap.get(opp.Id).Deal_Registration_Status__c + 'Deal Reg New Status ' + Trigger.newMap.get(opp.Id).Deal_Registration_Status__c);
                System.debug('Usertype of Last Modified '+ opp.LastModifiedBy.UserType);
                
                
            }
            //}
            PRM_Email_Notifications p = new PRM_Email_Notifications();
            if(oppIdsForResubmissionModifyingEmail.contains(opp.Id)){
                try{
                    System.debug('Deals modifying after the initial approval');
                    p.sendEmailByUserLocale('Deal Registration', opp.Id, 'Deal Resubmission - Modifying', id_addEmails_map.get(opp.Id));                        
                }catch(Exception e){
                    //do nothing
                }
            }
        }
    }
    */
}