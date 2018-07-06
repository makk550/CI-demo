//5 Soql Calls
public class AutoPartnerAssignment {
    //----------------------------- class parameters ----------------------------------------------//
    List<Lead> leadsToProcess=new List<Lead>();
    public List<Account> autoAccountList_sessVar=new List<Account>();
    public set<String> accIdsForUpdate = new set<String>();
    Boolean sendEmailFlag = false;
    
    List<Indirect_BU_Partner_Assignment_Mapping__c> pamList = new List<Indirect_BU_Partner_Assignment_Mapping__c>();
    List<Account> prefAccList = new List<Account>();   
    List<Contact> contList_prefPartner = new List<Contact>();
    List<Contact> contList_autoAssign = new List<Contact>();
            
    Map<String,List<Account>> accMap_prefPartner = new Map<String,List<Account>>();
    Map<Id,Contact> contMap_prefPartner = new Map<Id,Contact>();
    Map<Id,Contact> contMap_autoAssign = new Map<Id,Contact>();    

    set<String> region = new set<String>();
    set<String> product = new set<String>();    
    set<String> ldPPartnerIds = new set<String>();    
    
    //class Constructor
    public AutoPartnerAssignment(List<lead> newLeadList)
    {
        leadsToProcess=newLeadList; 
    }
    /*
     * Assigns resellers to Leads based on pre-configured rules in the "Indirect BU Partner Assignment Mapping"
     * table. Leads are first assigned by prefered partners and then By Auto Partner Assignment
     *
     */
    public void processLeads()
    {
        try
        {
            // populate the tmp sets & lists with leads data
            for(Lead ld:leadsToProcess) {               
                if(ld.GEO__c != null && ld.BU__c != null)
                {
                    region.add(ld.GEO__c);                  
                    product.add(ld.BU__c);
                }
                // add to the preferred partner ID list
                if(ld.Preferred_Reseller__c != null)
                    ldPPartnerIds.add(ld.Preferred_Reseller__c);
                  
            }
            //SOQL #1 - retrieve the rules for the region & product combinations of all the leads       
            pamList = [Select i.MKT_NCV_Driver__c,i.Program_Level__c,i.Lead_Rating__c,i.Territory__c,i.Aligned_CAM__c, 
                        i.Auto_Assign_Partner__c, i.Auto_Assign_Preferred_Partner__c,i.Region__c,i.MKT_BU__c,i.Country__c,Lead_Region__c 
                       from Indirect_BU_Partner_Assignment_Mapping__c i 
                       where i.Region__c in :region or i.MKT_BU__c in :product];      
            
            //SOQL #2 - retrieve preferred partner Acct Ids
            prefAccList = [Select a.Reseller_Type__c,a.Id,a.Name,a.OwnerId,a.CPMS_ID__c,a.Lead_Rating__c,a.Sales_Region__c,a.NCV_Driver__c,a.Program_Level__c 
                            from Account a 
                            where a.Reseller_Type__c in :product 
                            and a.Customer_Category__c = 'Reseller' 
                            and a.Account_Status__c = 'Approved' 
                            and a.CPMS_ID__c in :ldPPartnerIds 
                            order by a.Name asc limit 1000];
                        
            //SOQL #3 - retrieve partners enabled for auto assignment         
            autoAccountList_sessVar = [Select a.Lead_Country__c,a.Lead_Territory__c,a.Reseller_Type__c,a.GEO__c,a.Id,a.Name,a.OwnerId,a.Received_Last_Lead__c,a.Lead_Rating__c,a.CPMS_ID__c,a.Sales_Region__c,a.NCV_Driver__c,a.Program_Level__c 
                            from Account a 
                            where a.Reseller_Type__c in :product 
                            and a.Customer_Category__c = 'Reseller' 
                            and a.Account_Status__c = 'Approved'
                            and a.GEO__c in :region
                            and a.CPMS_ID__c != null
                            and a.Auto_Assignment_Enabled__c = true 
                            order by a.Name asc limit 1000];
             
             // set the email alert flag if we are reaching the solution limitations(1000 Auto Assignment Enabled Partners)
             if(autoAccountList_sessVar.size() > 800)
             {
                sendEmailFlag = true;   
             }
             
            // create preffered partner IDs list
            for(Account acc:prefAccList)
            {
                // create the account map for preferred partners
                if(accMap_prefPartner.get(acc.CPMS_ID__c)==null)
                {
                    List<Account> accList=new List<Account>();
                    accList.add(acc);
                    accMap_prefPartner.put(acc.CPMS_ID__c,accList);
                }
                else
                {
                    accMap_prefPartner.get(acc.CPMS_ID__c).add(acc);
                }
            }       
            
            //SOQL # 4 - retrieve Contact Ids of preferred partners
            contList_prefPartner = [Select c.Id,c.AccountId,c.Contact_Type__c from Contact c 
                                    where c.Primary__c = true and c.AccountId in :prefAccList]; 
            
            //SOQL #5 - retrieve Contact Ids of partners enabled for auto assignment
            contList_autoAssign = [Select c.Id,c.AccountId,c.Contact_Type__c from Contact c 
                                    where c.Primary__c = true and c.AccountId in :autoAccountList_sessVar];
            
            // create the contact map for preferred partners
            for(Contact c:contList_prefPartner)
            {
                contMap_prefPartner.put(c.AccountId,c); 
            }
            
            // create the contact map for Auto assigned partners
            for(Contact c:contList_autoAssign)
            {
                contMap_autoAssign.put(c.AccountId,c); 
            }
                                
            // Iterate through each lead and assign a partner based on the partner mapping rules              
            for(Lead ld:leadsToProcess)
            {
                boolean isAssigned = false;
                Indirect_BU_Partner_Assignment_Mapping__c assignmentRule=AutoPartnerAssignment.findAssignmentRule(ld,pamList);
    
                if(assignmentRule!=null)
                {
                    // Preferred partner assignment check
                    if(assignmentRule.Auto_Assign_Preferred_Partner__c && ld.Preferred_Reseller__c != null)
                    {
                        // if the Partner Id of the lead has corresponding Accounts
                        if(accMap_prefPartner.get(ld.Preferred_Reseller__c) != null)
                        {
                            List<Account> prefPartners=accMap_prefPartner.get(ld.Preferred_Reseller__c);
                             
                            for(Account partnerAccount:prefPartners)
                            {
                                if(partnerAccount.Reseller_Type__c.equalsIgnoreCase(ld.BU__c))
                                {
                                    isAssigned = true;
                                     // call Auto Assign Preferred partner function
                                    updateLead(ld,partnerAccount,contMap_prefPartner,assignmentRule.Aligned_CAM__c);
                                    break;
                                }
                            }                        
                        }                                         
                    }
                    // Auto Assign partner if not already assigned
                    if(assignmentRule.Auto_Assign_Partner__c && !isAssigned)
                    {            
                        // call round robin based partner assignment function
                        AutoAssignPartner(ld,assignmentRule, contMap_autoAssign); 
                    }
                }  
            }
            if(sendEmailFlag == true)
            {   
                // send email
                sendEmail();
            }
            // Reset the Received_Last_Lead flag for the relevant partners
            updateAllAccounts();
        }
        catch(Exception ex)
        {
            System.debug('Failed to Assign Resellers to Leads : '+ex);
        }
    }
            
    // function to update lead assignment details
    public void updateLead(Lead ld,Account acc,Map<Id,Contact> contMap,boolean camAlignFlag){
        //find reseller contact for lead

        Contact cont;
        if(contMap.get(acc.Id)!=null)
        {        
            cont = contMap.get(acc.Id);        
        }
        if(cont != null)
        {
            ld.Reseller_Contact_Name__c = cont.Id;                
        }
        
        //update Assignment Mode
        ld.Reseller_Assignment__c = 'Auto';        
        ld.Reseller__c = acc.Id;        
        if(camAlignFlag)
            ld.OwnerId = acc.OwnerId;          
    } 
    /*
     * Finds a matching assignment rule for a lead 
     * 
     * @param ld the lead for which the rule is to be found
     * @param ruleList list of available assignment rules in the system
     *
     * @return a matching rule if found, null otherwise
     */ 
    public static Indirect_BU_Partner_Assignment_Mapping__c findAssignmentRule(Lead ld,List<Indirect_BU_Partner_Assignment_Mapping__c> ruleList)
    {
        Indirect_BU_Partner_Assignment_Mapping__c matchingRule=null;
        if(ld.GEO__c !=null && ld.BU__C!=null)
        {
            //find a matching assignment rule for the lead
            for(Indirect_BU_Partner_Assignment_Mapping__c rule:ruleList)
            {
                if(ld.GEO__c.equalsIgnoreCase(rule.Region__c) && ld.BU__C.equalsIgnoreCase(rule.MKT_BU__c))
                {
                    matchingRule=rule;
                    break;
                    // exit the for loop once a match is found
                }
            }  
        } 
        return matchingRule;
    }  
    
     /*
     * Assigns a Partner to lead based on pre-configured Auto Assignment. There are a number of filters  
     * for Auto assignment and an Partners must much all selected filters before assignment. If multiple
     * Partaners matching a lead are found, leads are distributed in a Round Robin Bases
     *
     * @param ld the lead for which a Partener is going to be assigned
     * @param pamObject the Auto Assignment rule for the lead
     * @param contMap a map conating all primary contacts related to Auto Assignment enabled Partner Accounts
     */ 
    public void AutoAssignPartner(Lead ld,Indirect_BU_Partner_Assignment_Mapping__c pamObject,Map<Id,Contact> contMap){ 
               
        integer filterCount=0;
        //check if country flag is checked
        boolean countryFlag=pamObject.Country__c;        
        if(countryFlag){filterCount++;}
        
        //check if region flag is checked
        boolean regionFlag=pamObject.Lead_Region__c;
        if(regionFlag){filterCount++;}
        
        //check if territory flag is checked
        boolean territoryFlag = pamObject.Territory__c;     
        if(territoryFlag){filterCount++;}
        
        //check if NVC Driver flag is checked
        boolean ncvDriverFlag = pamObject.MKT_NCV_Driver__c;
        if(ncvDriverFlag){filterCount++;}
        
        //check if lead rating is specified
        boolean leadRatingFlag = (pamObject.Lead_Rating__c != null) ? true:false;   
        if(leadRatingFlag){filterCount++;}
        
        //check if program level is specified     
        boolean programLevelFlag = (pamObject.Program_Level__c != null) ? true:false;
        if(programLevelFlag){filterCount++;}
        
        //check if CAM flag is checked
        boolean camAlignFlag = pamObject.Aligned_CAM__c;        
        List<Account> matchedAccs = new List<Account>();

        if(filterCount>0)
        {           
            // check each account whether a match is found
            for(Account partnerAccount:autoAccountList_sessVar)
            {
                Integer matchedFilterCount=0;  
                
                if(ld.BU__c.equalsIgnoreCase(partnerAccount.Reseller_Type__c) && ld.GEO__c.equalsIgnoreCase(partnerAccount.GEO__c))
                {               
                    //check if account matches lead country
                    if(countryFlag && ld.Country!=null && partnerAccount.Lead_Country__c!=null)
                    {
                        if(ISCountryOrStatePartOfPicklist(ld.Country,partnerAccount.Lead_Country__c))
                        {
                            matchedFilterCount++;     
                        }
                    }  
                    
                    //check if lead region matches acount region
                    if(regionFlag && ld.GEO__C!=null && partnerAccount.GEO__C!=null)
                    {
                        if(ld.GEO__C.equalsIgnoreCase(partnerAccount.GEO__C))
                        {
                            matchedFilterCount++;
                        }
                    }
                     
                    //check if lead Area/Territory matches account Area/Territory    
                    if(territoryFlag && partnerAccount.Lead_Territory__c != null && ld.MKT_Territory__c != null)            
                    {
                        if(ISMemeberOfPickList(ld.MKT_Territory__c,partnerAccount.Lead_Territory__c))
                         {
                              matchedFilterCount++;                       
                         }
                    }
                    
                    //check if lead ncv driver matches account ncv driver
                    if(ncvDriverFlag && partnerAccount.NCV_Driver__c != null && ld.MKT_Solution_Set__c != null)
                    {
                        if(ISMemeberOfPickList(ld.MKT_Solution_Set__c,partnerAccount.NCV_Driver__c))
                        {
                            matchedFilterCount++; 
                                  
                        }
                    }
                    
                    //check if lead lead-rating matches account lead-rating 
                    if(leadRatingFlag && partnerAccount.Lead_Rating__c != null && ld.Lead_Rating__c != null)
                    {
                       if(ISMemeberOfPickList(ld.Lead_Rating__c,partnerAccount.Lead_Rating__c) && ISMemeberOfPickList(ld.Lead_Rating__c,pamObject.Lead_Rating__c))
                       {
                            matchedFilterCount++;                        
                       }
                    }
                    
                    //check if account program level matches the rule program level
                    if(programLevelFlag  && partnerAccount.Program_Level__c != null)
                    {
                        if(ISMemeberOfPickList(partnerAccount.Program_Level__c,pamObject.Program_Level__c))
                        {
                            matchedFilterCount++;                              
                        }               
                    }   
                    
                    //add account to matching account list if all filters are matched
                    if(matchedFilterCount== filterCount)
                    {
                        matchedAccs.add(partnerAccount);
                    }            
                }
            }   
            
            // no matching account found, hence unable to do auto assign
            if(matchedAccs.size() == 0)
            {
                ld.Reseller_Assignment__c  = 'Unable to Auto Assign';
            }
            // 1 matching account found
            else if(matchedAccs.size() == 1)
            {
                updateAccountListSess(matchedAccs.get(0),true);
                updateLead(ld,matchedAccs.get(0),contMap,camAlignFlag);
            }
            // more than 1 matching account found
            else if(matchedAccs.size() > 1)
            {
                Account accObj = identifySingleAccount(matchedAccs);
                updateLead(ld,accObj,contMap,camAlignFlag);
            }
        }
        //the assignment rule doesn't have any filters
        else
        {
            ld.Reseller_Assignment__c  = 'Unable to Auto Assign';
        }
    }
    
    // function to update the session acc List
    private void updateAccountListSess(Account pMatchedAcc,boolean updateFlag){     
        //update Received last Lead Flag
        pMatchedAcc.Received_Last_Lead__c = updateFlag;
        //mark the account to be updated at the end of the process
        accIdsForUpdate.add(pMatchedAcc.Id);            
    }
    
    // function to identify a single partner for the lead
    private Account identifySingleAccount(List<Account> matchedAccs){
        Account tmpAcc = null;
        for(integer k=0;k<matchedAccs.size();k++)
        {
            // if a partner is found
            if(matchedAccs.get(k).Received_Last_Lead__c == false)
            {
                tmpAcc = matchedAccs.get(k);
                updateAccountListSess(tmpAcc,true);
                break;
            }
        }
        // if no partner is found
        if(tmpAcc == null)
        {
            tmpAcc = matchedAccs.get(0);
            updateAccountListSess(tmpAcc,true);
            for(integer j=1;j<matchedAccs.size();j++)
            {
                updateAccountListSess(matchedAccs.get(j),false);
            }               
        }   
        return tmpAcc;
    }
    
    // update the list of accounts
    public void updateAllAccounts(){
        List<Account> tmpAccListForUpdate = new List<Account>();
        for(integer m=0;m<autoAccountList_sessVar.size();m++)
        {
            if(accIdsForUpdate.contains(autoAccountList_sessVar.get(m).Id))
            {
                tmpAccListForUpdate.add(autoAccountList_sessVar.get(m));
            }   
        }
        if(tmpAccListForUpdate.size() > 0)
        {
            upsert tmpAccListForUpdate;
        }       
    }
            
    // function to send email alert
    public void sendEmail(){
        Messaging.SingleEmailMessage triggerMail = new Messaging.SingleEmailMessage();          
        String[] toAddresses = new String[] {'abalasubramanian@corematrix.com'}; // add the profile's email ids here later      
        triggerMail.setToAddresses(toAddresses);
        triggerMail.setSenderDisplayName('CA salesforce admin'); // get the exact display name from CA & put it here        
        triggerMail.setSubject('Auto Partner assignment to Leads alert');// get the exact subject message from CA & put it here
        triggerMail.setBccSender(false);
        triggerMail.setUseSignature(false);     
        //get the exact text content message from CA & put it here
        triggerMail.setHtmlBody('More than <b>800</b> partner records were retrieved for the auto partner assignment of the batch leads processed at '+datetime.now()+'.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { triggerMail });
    }   
    public static boolean ISCountryOrStatePartOfPicklist(string freeTextCountryOrState,string pickList)
    {
        boolean isAMatch=false;
        if(freeTextCountryOrState == null && pickList == null)
        {
            isAMatch = true;    
        }
        else if(freeTextCountryOrState!=null && pickList!=null)
        {
            string[] countryOrStateList=pickList.split(';');
            for(string countryOrState:countryOrStateList)
            {
                string[] ISOFullForms=countryOrState.split('-');
                for(string ISOFullForm:ISOFullForms)
                {
                    if(ISOFullForm.trim().equalsIgnoreCase(freeTextCountryOrState))
                    {
                        isAMatch=true;
                        break;
                    }
                }
            }
        }
        return isAMatch;
    } 
    public static boolean ISMemeberOfPickList(string entry,string picklist)
    {
        boolean isAMember=false;
        if(entry!=null && picklist!=null)
        {
            for(string picklistEntry:picklist.split(';'))
            {
                if(picklistEntry.equalsIgnoreCase(entry))
                {
                    isAMember=true;
                    break;
                }
            }
        }
        return isAMember;
    }
        
    public static testMethod void AutoPartnerAssignmentTest(){
     
    List<Lead> lstLeads = [select   BU__c, GEO__c ,Lead_Rating__c , Preferred_Reseller__c , CIDB_Campaign_Name__c, ID, OwnerID, Owner.Name, Owner.Email, FirstName, LastName, Owner.FirstName, Company, MKT_BU_Category__c, MKT_Solution_Set__c, Description from lead Where Company != null and  MKT_BU_Category__c != null and MKT_Solution_Set__c != null AND BU__c != null AND GEO__c != null AND  Preferred_Reseller__c != null limit 10  ];

    if (lstLeads.size() > 0)
    {
        AutoPartnerAssignment Obj = new AutoPartnerAssignment(lstLeads);
        
        Test.startTest(); 
        Obj.processLeads();
        Obj.sendEmail();
        AutoPartnerAssignment.ISCountryOrStatePartOfPicklist('US-AP', 'US-AP;US-VA;US-CA;US-NY' );
        AutoPartnerAssignment.ISMemeberOfPickList ('AP' , 'US;VA;ST;AB;AP');
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Received_Last_Lead__c = true; 
        acc.Customer_Category__c = 'Reseller';
        acc.Account_Status__c ='Approved';
        acc.GEO__c ='NA';
        acc.CPMS_ID__c ='1234';
        acc.Auto_Assignment_Enabled__c = true;
        acc.BillingStreet = 'Arlington';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'VA';
        acc.Reseller_Disti_Regional_ID__c = '1234';
        acc.Reseller_Distributor_Name__c = 'test';
        insert acc;
        Obj.updateAccountListSess(acc, true);
        
        Account acc1 = new Account();
        acc1.Name = 'test';
        acc1.Received_Last_Lead__c = false; 
        acc1.BillingStreet = 'Arlington';
        acc1.BillingCountry = 'US';
        acc1.BillingCity = 'VA';
        insert acc1;
        
        List<Account> lstAcc =new List<Account>();
        lstAcc.add(acc); 
        lstAcc.add(acc1);
        Obj.identifySingleAccount(lstAcc);
        Obj.updateAllAccounts();
        
        Contact cont = new Contact();
        cont.LastName ='test';
        cont.AccountId= acc.Id;
        insert cont;
        
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        contactMap.put(acc.Id,cont);
        
        obj.updateLead  (lstLeads[0],acc,contactMap,true);
       
        Test.stopTest();
    }
}//end test method     
        
 }