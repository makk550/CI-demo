//updates lead information based on Commericial account, Volume Customer and Account Contact Selected By the User 
//executes when a lead is updated and any of the above fields is changed
// Up to 4 SOQL Queries
trigger Lead_UpdateFields_Existing on Lead (before update) {
    
    DealReg_RejectionReasonMandatoryOnDeal classVar= new DealReg_RejectionReasonMandatoryOnDeal();// declaring the variable for trigger class.
    //DealReg_PopulateResellerInfo DealVar = new DealReg_PopulateResellerInfo(); // added by Jon 11/10

    //update lead country with country picklist
    for (Lead ld : Trigger.new) {
        if (ld.Country_Picklist__c != null && ld.Country_Picklist__c.length()>1) 
        {
            ld.Country = ld.Country_Picklist__c.substring(0,2);
        }       
    }   
    
    List<Lead> leadsToAssignPartners=new  List<Lead>();
    set<Id> commAccIds = new set<Id>();
    set<Id> volCustIds = new set<Id>();
    set<Id> accContIds = new set<Id>(); 
    set<ID> leadOwnerIds=new set<Id>(); 
    set<string> cpmsContactIdList=new Set<string>();
    List<Volume_Customer__c> vcList = new List<Volume_Customer__c>();
    List<Contact> accContList = new List<Contact>();
    List<Account> commAccList = new List<Account>(); 
    List<User> leadOwnerList = new List<User>();     
    
    try {
        for(Lead ld:Trigger.New) {  
            //if it is indirect lead not generated by CPMS
            if(SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId) && ld.Reseller_Initiated__c==false)
            {       
                Lead oldLead=Trigger.oldMap.get(ld.Id); 
                //update company name based on comericial account if Commercial account is changed                
                if(ld.Commercial_Account__c != null && ld.Commercial_Account__c!=oldLead.Commercial_Account__c)
                {
                    commAccIds.add(ld.Commercial_Account__c);
                }
                //update company name based on Volume Customer account if Volume Customer account is changed   
                if(ld.Volume_Customer__c != null && ld.Volume_Customer__c!=oldLead.Volume_Customer__c)
                {
                    volCustIds.add(ld.Volume_Customer__c);  
                }
                //update contact info  based on Account Contact if changed
                if(ld.Account_Contact__c != null && ld.Account_Contact__c!=oldLead.Account_Contact__c)
                {
                    accContIds.add(ld.Account_Contact__c);  
                } 
                //update lead owner pmf key if the owner is changed
                if(ld.ownerId!=oldLead.ownerId)
                {
                    string ownerIdString=ld.OwnerId;
                    if(ownerIdString.startsWith('005'))
                    {
                        leadOwnerIds.add(ld.OwnerId);
                    }
                }                 
                //Clear Reseller info in pullback
                if(ld.status!=oldlead.Status && ld.status!=null)
                {
                    if(ld.status.equalsIgnoreCase('Pulled Back'))
                    {
                        ld.status='Re-Direct Inquiry';
                        ld.Reseller__c=null;
                        ld.Reseller_Contact_Name__c=null;
                        leadsToAssignPartners.add(ld);
                    }
                }
            }
        }
        if(commAccIds.size() > 0)
            commAccList = [Select Id,Name from Account where Id in :commAccIds];
            
        if(volCustIds.size() > 0)
            vcList = [Select Id,Account__r.Name from Volume_Customer__c where Id in :volCustIds and Account__c !=null];
            
        if(accContIds.size() > 0 || cpmsContactIdList.size()>0)
            accContList = [Select c.Name,c.FirstName,c.LastName,c.Email,c.MailingCity, c.MailingCountry, c.MailingPostalCode, c.MailingState, 
            c.MailingStreet,AccountId from Contact c where c.Id in :accContIds or c.CPMS_Contact_ID__c in:cpmsContactIdList];
        if(leadOwnerIds.size()>0 )
        {
            leadOwnerList=[Select Id,PMFKey__c from User 
            where Id in:leadOwnerIds and IsActive=true];
        }
        //re assign pulled back leads
        if(leadsToAssignPartners.size()>0)
        {
            AutoPartnerAssignment apAssignCls = new AutoPartnerAssignment(leadsToAssignPartners);
            apAssignCls.processLeads();   
        }
        
        for(Lead ld:Trigger.New) {          
            if(SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId) && ld.Reseller_Initiated__c==false)
            {   
                Lead oldLead=Trigger.oldMap.get(ld.Id);
                if(ld.Commercial_Account__c!=null && ld.Commercial_Account__c!=oldLead.Commercial_Account__c)
                {                        
                    for(integer i = 0;i<commAccList.size();i++)
                    {                       
                        if(ld.Commercial_Account__c == commAccList.get(i).Id) 
                        {
                            ld.Company = commAccList.get(i).Name;                       
                            break;  
                        }                                                    
                    }    
                }   
                if(ld.Volume_Customer__c!=null && ld.Volume_Customer__c!=oldLead.Volume_Customer__c)
                {    
                    for(integer j = 0;j<vcList.size();j++)
                    {                       
                        if(ld.Volume_Customer__c == vcList.get(j).Id)
                        {
                            ld.Company = vcList.get(j).Account__r.Name;                     
                            break;                                  
                        }                         
                    } 
                } 
                if(ld.Account_Contact__c!=null && ld.Account_Contact__c!=oldLead.Account_Contact__c)
                {         
                    for(integer k=0;k<accContList.size();k++)
                    {                       
                        if(ld.Account_Contact__c == accContList.get(k).Id)
                        {
                            ld.FirstName= accContList.get(k).FirstName;
                            ld.LastName= accContList.get(k).LastName;
                            ld.Email = accContList.get(k).Email; 
                            ld.Street = accContList.get(k).MailingStreet;
                            ld.State = accContList.get(k).MailingState;
                            ld.City = accContList.get(k).MailingCity;
                            ld.Country = accContList.get(k).MailingCountry;
                            ld.PostalCode = accContList.get(k).MailingPostalCode;
                            break;  
                        }                       
                    }   
                }
                //update lead owner pmf key if the owner is changed
                if(ld.ownerId!=oldLead.ownerId)
                {
                    string ownerIdString=ld.OwnerId;
                    if(ownerIdString.startsWith('005'))
                    {
                        for(User user:leadOwnerList)
                        {
                            if(user.ID==ld.OwnerId && user.PMFKey__c!=null)
                            {
                                ld.Lead_Owner_PMF__c=user.PMFKey__c;
                                break;
                            }                       
                        }
                    }
                }    
            }                               
        }   
    }
    catch(Exception ex) {
        
    }
    
       //Siddharth(Deal Reg R2): trigger to check that the rejection reason is mandatory once a Deal is rejected 
      classVar.validateRejectionReason(Trigger.old,Trigger.new);
      //DealVar.populateReseller(Trigger.new); // added by Jon 11/10
}