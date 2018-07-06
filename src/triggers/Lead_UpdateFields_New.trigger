//updates lead information based on Commericial account, Volume Customer and Account Contact Selected By the User
// Up to 6 SOQL Queries + 5 Soql Calls from AutoPartnerAssignment
trigger Lead_UpdateFields_New on Lead (before insert) { 
    
     DealReg_ApproversOnLead leadVar = new DealReg_ApproversOnLead();
   
       //update lead country with country picklist
    for (Lead ld : Trigger.new) {
        if (ld.Country_Picklist__c != null && ld.Country_Picklist__c.length()>1) 
        {
            ld.Country = ld.Country_Picklist__c.substring(0,2);
        }       
    }   
    
    //assign lead to partner
    List<Lead> leadsToAssignPartners=new  List<Lead>(); 
    for(Lead ld:Trigger.new)
    {
        //auto assign indirect lead if a reseller is not already assigned to a lead 
        if(SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId) && ld.Reseller_Initiated__c==false && ld.Reseller__c==null)
        {
            leadsToAssignPartners.add(ld);
        }
    }     
    if(leadsToAssignPartners.size()>0)
    {
        AutoPartnerAssignment apAssignCls = new AutoPartnerAssignment(leadsToAssignPartners);
        apAssignCls.processLeads();       
    }  
    
    
    //update lead fields    
    set<Id> commAccIds = new set<Id>();
    set<Id> volCustIds = new set<Id>();
    set<Id> accContIds = new set<Id>();
    set<Id> leadOwnerIdList= new set<Id>();
    set<string> leadOwnerPMFKeys=new set<string> ();
    Set<string> CIDBContactIdList=new Set<string>();
    Set<string> SAPSiteIdList=new Set<string>();
    Set<string> TopsSiteIdList=new Set<string>();
    set<string> cpmsContactIdList=new Set<string>();
    
    
    List<Volume_Customer__c> vcList = new List<Volume_Customer__c>();
    List<Contact> accContList = new List<Contact>();
    List<Account> commAccList = new List<Account>();   
    List<User> leadOwnerList = new List<User>();     
    
    try {
        for(Lead ld:Trigger.New) 
        {  
            if(SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId))
            {     
                if(ld.Reseller_Initiated__c==false)
                {
                    //we will update the company name on the lead if the commericial account is populated 
                    if(ld.Commercial_Account__c != null)
                    {
                        commAccIds.add(ld.Commercial_Account__c);
                    }
                    //we will update the company name with aggregate account name if volume customer is populated 
                    if(ld.Volume_Customer__c != null)
                    {
                        volCustIds.add(ld.Volume_Customer__c);  
                    }
                    //we will update the Name, address and email fields on the lead if Account Contact is populated 
                    if(ld.Account_Contact__c != null )
                    {
                        accContIds.add(ld.Account_Contact__c);                     
                    }  
                    //we will update Lead Account Contact if there is a cidb contact Id and account contact is null
                    if(ld.CIDB_Contact_ID__c!=null && ld.Account_Contact__c==null)
                    {
                        CIDBContactIdList.add(ld.CIDB_Contact_ID__c);
                    }
                    //we update lead owner pmf key  (should happen after partner assignment)                
                    string ownerIdString=ld.OwnerId;
                    if(ownerIdString.startsWith('005'))
                    {
                        leadOwnerIdList.add(ld.OwnerId);
                    }
                    
                }  
                else
                {
                    //we will update the lead owner if  the Lead Owner PMF key is populated
                    if(ld.Lead_Owner_PMF__c!=null)
                    {
                        leadOwnerPMFKeys.add(ld.Lead_Owner_PMF__c);
                    }
                }                
            }
        }
        
        //get Accounts, Contacts, Volume Customers and Users necessary for the field Update
        //SOQL #1
        if(commAccIds.size() > 0)
            commAccList = [Select Id,Name from Account where Id in :commAccIds];
        //SOQL #2,3    
        if(volCustIds.size() > 0)
            vcList = [Select Id,Account__r.Name from Volume_Customer__c where Id in :volCustIds and Account__c !=null];
        //SOQL #4     
        if(accContIds.size() > 0 || CIDBContactIdList.size()>0 || cpmsContactIdList.size()>0)
            accContList = [Select c.Name,c.FirstName,c.LastName,c.Email,c.MailingCity, c.MailingCountry, c.MailingPostalCode, 
            c.MailingState, c.MailingStreet,c.CIDB_Contact_ID__c, c.AccountId,c.Volume_Customer__c 
            from Contact c where c.Id in :accContIds or c.CIDB_Contact_ID__c in:CIDBContactIdList];
        //SOQL #5 
        if(leadOwnerPMFKeys.size()>0 || leadOwnerIdList.size()>0 )
        {
            leadOwnerList=[Select Id,PMFKey__c from User 
            where (PMFKey__c in:leadOwnerPMFKeys or Id in:leadOwnerIdList) and IsActive=true];
        }
        
        for(Lead ld:Trigger.New) {
            if(SystemIdUtility.IsIndirectLeadRecordType(ld.recordTypeId))
            {   
                if(ld.Reseller_Initiated__c==false)
                {
                    //update company name with commericial account name
                    if(ld.Commercial_Account__c!=null)
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
                    //update company name with Agregate account Name
                    if(ld.Volume_Customer__c!=null)
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
                    //update Contact information with Account Contact
                    if(ld.Account_Contact__c!=null)
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
                    //update Account Contact if CIDB id is supplied
                    if(ld.CIDB_Contact_ID__c!=null && ld.Account_Contact__c==null)
                    {
                        for(Contact con:accContList)
                        {
                            if(con.CIDB_Contact_ID__c==ld.CIDB_Contact_ID__c)
                            {
                                ld.Account_Contact__c=con.Id;
                                //update Volume Customer or Commericial Account Id both are null
                                if(ld.Volume_Customer__c==null && ld.Commercial_Account__c==null)
                                {
                                    if(con.Volume_Customer__c!=null)
                                    {
                                        ld.Volume_Customer__c=con.Volume_Customer__c;
                                    }
                                    else if(con.AccountId!=null)
                                    {
                                        ld.Commercial_Account__c=con.AccountId;
                                    }                                                                   
                                }
                                break;
                            }
                        }
                    }
                    //update lead owner pmf key with current lead owner pmf key                 
                    string ownerIdString=ld.OwnerId;
                    if(ownerIdString.startsWith('005')   )//&& ld.Lead_Owner_PMF__c == null
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
                else
                {
                    //update lead owner with pmf key
                    if(ld.Lead_Owner_PMF__c!=null)
                    {
                        for(User user:leadOwnerList)
                        {
                            if(user.PMFKey__c==ld.Lead_Owner_PMF__c)
                            {
                                ld.ownerId=user.Id;
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
   
       /* Call this method on DealReg_ApproversOnLead class to populate the  
    CAM and CAM manager as approvers on the Lead page for the approval process*/
      /******* prmr2******/
  List<Lead> lstDR=new List<Lead>();
  for(Lead l:Trigger.new)
  {
  if(SystemIdUtility.IsDeal_RegistrationRecordType(l.recordTypeId))
  lstDR.add(l);
  }
  if(lstDR.size() > 0)
  {
    leadVar.populateApprovers(lstDR);
    leadVar.populateEmailFields(lstDR);
  }
  /******* prmr2******/
}