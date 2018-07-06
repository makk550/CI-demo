public class AutoLeadConversion {

//----------------------------- class parameters ----------------------------------------------//

// map containing the lead id & a account id for opportunity
public Map<Id,Id> accountIdMap = new Map<Id,Id>();
// map containing the lead id & a contact id for opportunity
public Map<Id,Id> contactIdMap = new Map<Id,Id>(); 
// map containing the lead id & a owner id for opportunity
public Map<Id,Id> ownerIdMap = new Map<Id,Id>();
// map containing the name for the opportunity
public Map<Id,Id> oppNameMap = new Map<Id,String>();
// set containing the Account Ids to find reseller owner
public set<Id> resellerIds = new set<Id>();
// a List of leads
public List<Lead> aggAcctLdList = new List<Lead>();
// List of contact records
public List<Contact> contDetList = new List<Contact>(); 
// List of Volume_Customer__c records
public List<Volume_Customer__c> vcList = new List<Volume_Customer__c>();

// constructor for the class
public AutoLeadConversion() { 

} 

//**********************Auto_Lead_Convert trigger METHODS ************************************//

/*
* Function to process the data of leads that need to be converted 
* 
* @param leadList the list of leads that need to be processed
*
*/ 
public void setupData(List<Lead> leadList) {
 system.debug('SystemIdUtility.isLeadUpdate1 inside auto convert'+SystemIdUtility.isLeadUpdate1);
List<Lead> contLdList = new List<Lead>(); 

// identify account & contact to associate with the opportunity
for(Lead ld:leadList)
{

// check if commercial acct id exists
if(ld.Commercial_Account__c != null) 
{
//populate accountIdMap with commercial acct id
System.debug('ld.Commercial_Account__c is : '+ld.Commercial_Account__c);
accountIdMap.put(ld.Id,ld.Commercial_Account__c); 
System.debug('accountIdMap is : '+accountIdMap);
}
else if(ld.BU__c != null && ld.BU__c.equalsIgnoreCase('RMDM') || ld.BU__c.equalsIgnoreCase('ISBU'))
{
// else add the lead to aggAcctLdList that contains the list of leads to which agg. accounts need to be found
aggAcctLdList.add(ld); 
}
//add the contact to the contLdList 
contLdList.add(ld);

// check the lead owner type
checkLeadOwnerType(ld); 
    
}

// Find aggregate account & then the contact
populateAcctAndContact(aggAcctLdList,contLdList);

// identify the reseller Owner Ids
identifyResellerOwnerDetails(leadList);
 system.debug('SystemIdUtility.isLeadUpdate1 before lead convert'+SystemIdUtility.isLeadUpdate1);
// convert Lead
convertLead(leadList); 
}

/*
* Function to identify the Account for volume leads and the contact for all leads
* whose Account Contact is Null.This function contains 3 SOQLs.
* 
* 
* @param aggAcctLdList the list of leads for which the aggregate account need to be found
* @param contLdList the list of leads for which the opp. contact need to be found
*/ 
private void populateAcctAndContact(List<Lead> aggAcctLdList,List<Lead> contLdList) {

// set to store the lead email ids
set<String> leadEmailIds = new set<String>(); 
// List to store the contact details
List<Contact> contList = new List<Contact>();
// set of Account Contact ids
set<Id> acctContIds = new set<Id>();


//******** Step 2: validate the existing contacts and also 
// find the account from the contacts object using the Lead Email ********// 
for(Lead l:aggAcctLdList) {
if(l.Email != null)
{
leadEmailIds.add(l.Email);
} 
}
// add the email ids whose contact need to be found
for(Lead l:contLdList) {
if(l.Account_Contact__c != null)
{
acctContIds.add(l.Account_Contact__c);
}
if(l.Email != null)
{
leadEmailIds.add(l.Email);
}
}

System.debug(logginglevel.Debug,'1 contList content is : '+contLdList+','+acctContIds+','+leadEmailIds);

if(leadEmailIds.size() > 0 || acctContIds.size() > 0) {
// SOQL #2,#3
contList = [Select c.Id,c.AccountId,c.Email,c.Account.Aggregate_Account__c,c.Account.RecordTypeId,c.Account.Customer_Category__c
from Contact c
where (c.Email in :leadEmailIds
or c.Id in :acctContIds) 
and (c.Account.RecordTypeId = :SystemIdUtility.getSMBAcctRecordTypeId())
limit 1000];

System.debug(logginglevel.Debug,'2 contList content is : '+contList); 

for(integer j=0;j<aggAcctLdList.size();j++) 
{
// only if the accountId map doesnt contain the record already
if(!accountIdMap.containsKey(aggAcctLdList.get(j).Id))
{
if(aggAcctLdList.get(j).Email != null)
{
for(integer k=0;k<contList.size();k++) {
// pickup only aggregate account contact

if(aggAcctLdList.get(j).Email == contList.get(k).Email && contList.get(k).Account.Aggregate_Account__c == 'Yes')
{
System.debug(logginglevel.Debug,'Found an account from contact');
// add the account id to the map
accountIdMap.put(aggAcctLdList.get(j).Id,contList.get(k).AccountId);
if(!contactIdMap.containsKey(aggAcctLdList.get(j).Id))
{ 
System.debug(logginglevel.Debug,'Found a contact');
// only if the account id matches ..
if(contList.get(k).AccountId == accountIdMap.get(aggAcctLdList.get(j).Id))
contactIdMap.put(aggAcctLdList.get(j).Id,contList.get(k).Id);
}
// break the inner loop since the agg. account is found
break; 
}
}
}
}
} 
System.debug(logginglevel.Debug,'contLdList is : '+contLdList);
// populate the contact map for the remaining leads
for(integer a = 0;a<contLdList.size();a++) 
{
// check if the contact has already been identified for the lead
if(!contactIdMap.containsKey(contLdList.get(a).Id))
{
String accIdFromMap = (accountIdMap.get(contLdList.get(a).Id)) != null ? accountIdMap.get(contLdList.get(a).Id):null;
if(accIdFromMap != null)
{
for(integer b = 0;b<contList.size();b++) {
if(contList.get(b).AccountId == accIdFromMap)
{
contactIdMap.put(contLdList.get(a).Id,contList.get(b).Id); 

// break the inner loop since the contact is found
break; 
} 
}
}
}
}
}

System.debug(logginglevel.Debug,'contactIdMap is : '+contactIdMap+' , accIdFromMap is : '+accountIdMap);

}



/*
* Function to check the LeadOwnerType.The function updates the ownerIdMap if the lead owner
* is a OwnerQueue and the lead is an NA. Otherwise the fn updates the resellerIds that contains
* a list of reseller ids whose owner needs to be lookedup from the Accounts object
* 
* @param lead
*
*/ 
private void checkLeadOwnerType(Lead ld) {

String ownId = ld.OwnerId; 

// if this is a NA volume lead
//sunji03 - FY19 PS/CAN is added.
if((ld.GEO__c == 'NA' || ld.GEO__c == 'PS/CAN') && ld.BU__c != null && (ld.BU__c.equalsIgnoreCase('RMDM') || ld.BU__c.equalsIgnoreCase('ISBU'))){
// if the lead owner is a queue, get the system id from the systemIdUtility class
if(ownId.startsWith('00G'))
{
ownerIdMap.put(ld.Id,SystemIdUtility.getLeadQueueOwnerId());
}
else
{
// put the Id of the lead owner
ownerIdMap.put(ld.Id,ld.OwnerId);
} 
}
resellerIds.add(ld.Reseller__c); 
} 

/*
* Function to identify the resellerOwners.The function updates the ownerIdMap with the owner 
* id for each lead.The opportunity name also is identified in this function.
* 
* @param leadList
*
*/ 
private void identifyResellerOwnerDetails(List<Lead> leadList){
// SOQL #4 to identify the reseller owner ids
List<Account> resellerList = [Select Id,Name,OwnerId from Account where Id in :resellerIds limit 1000];

// iterate through each lead to finalize the opp. owner id 
for(Lead lead:leadList) {
for(integer z=0;z<resellerList.size();z++)
{
if(resellerList.get(z).Id == lead.Reseller__c)
{
// set the opportunity Name
if(lead.Reseller_Deal_Reg_IQ_Name__c != null && lead.Reseller_Deal_Reg_IQ_Name__c != '')
{ 
oppNameMap.put(lead.Id,lead.Reseller_Deal_Reg_IQ_Name__c); 
}
else
{
String ncvDriver = (lead.MKT_Solution_Set__c != null && lead.MKT_Solution_Set__c != '') ? '-'+lead.MKT_Solution_Set__c : '';
String mktBU = (lead.MKT_BU_Category__c != null && lead.MKT_BU_Category__c != '') ? '-'+lead.MKT_BU_Category__c : ''; 
oppNameMap.put(lead.Id,resellerList.get(z).Name+mktBU+ncvDriver); 
} 
if(!ownerIdMap.containsKey(lead.Id))
{
ownerIdMap.put(lead.Id,resellerList.get(z).OwnerId);
}
// break from the inner loop
break;
}
} 
} 
}

//ADDED BY MOHAMMAD AFZAL 06-02-2010, CR:189443448 
List<User> ownersList = new List<User>();
public Map<String,Id> ownerPMFMap = new Map<String,Id>(); 
private void initOwnerIds(List<Lead> leadList){
List<String> pmfKeys = new List<String>();
for(Lead ld:leadList){
    if(ld.Lead_owner_pmf__c!=null)
        pmfKeys.add(ld.Lead_owner_pmf__c);
}
if(!pmfKeys.isEmpty()){
ownersList = [select Id,PMFKEY__c from user where PMFKEY__c in : pmfKeys];
}

for(User usr: ownersList){
if(!ownerPMFMap.containsKey(usr.PMFKEY__c)){
ownerPMFMap.put(usr.PMFKEY__c, usr.Id);
}
}
}

/*
* Function to convert the leads into opportunities. 
* The convertLead database method accepts up to 100 LeadConvert objects
* 
* @param leadList
*
*/ 
private void convertLead(List<Lead> leadList){

     system.debug('SystemIdUtility.isLeadUpdate1 inside convert lead'+SystemIdUtility.isLeadUpdate1);
    //ADDED BY MOHAMMAD AFZAL 06-02-2010, CR:189443448 
    initOwnerIds(leadList);
    
    Database.LeadConvertResult[] ldConvertResult;
    List<Lead> ldsWithError = new List<Lead>();
    
    //** Logic to convert the lead **//
    try { 
        Database.LeadConvert[] leadsToConvert = new Database.LeadConvert[0];
        Database.LeadConvert converter;
        // Set the opportunity Name .. 
        for(integer z=0;z<leadList.size();z++) {
            converter = new Database.LeadConvert();
            converter.setLeadId(leadList.get(z).id);
            // set the account id, if available
            System.debug(logginglevel.Debug,'accountIdMap is :'+accountIdMap);
            System.debug(logginglevel.Debug,'lead id : '+leadList.get(z).id); 
    
            if(accountIdMap.containsKey(leadList.get(z).id))
            { 
                converter.setAccountId(accountIdMap.get(leadList.get(z).id)); 
                System.debug('accountId is :'+accountIdMap.get(leadList.get(z).id));
            }
            // set the contact id if available
            if(contactIdMap.containsKey(leadList.get(z).id))
                converter.setContactId(contactIdMap.get(leadList.get(z).id));
            // set the owner id
            //ADDED BY MOHAMMAD AFZAL 06-15-2009
            //START
            if(leadList.get(z).Lead_owner_pmf__c!=null){
                //COMMENTED BY MOHAMMAD AFZAL 06-02-2009, CR:189443448 
                //string strCARepId = [Select ID from User where PMFKEY__c=:leadList.get(z).Lead_owner_pmf__c limit 1].ID;
                //converter.setOwnerId(strCARepId);
                converter.setOwnerId(ownerPMFMap.get(leadList.get(z).Lead_owner_pmf__c));
            }
            else if(ownerIdMap.containsKey(leadList.get(z).id)){
                converter.setOwnerId(ownerIdMap.get(leadList.get(z).id));
            }
            //END

            
            //BY MOHAMMAD AFZAL 4th Nov 2009, CR # 13754500
            string strNewOppName = ''; 

            //re-writing the above lines to avoid null exception-- Saba CR:189478365
            if(leadList.get(z) != null)
            {
                if(leadList.get(z).Company!=null)
                {
                    if(leadList.get(z).Deal_Program__c!=null)
                        strNewOppName = leadList.get(z).Company + ' - ' + leadList.get(z).Deal_Program__c;
                    else
                        strNewOppName = leadList.get(z).Company;
                }
                else
                {
                    if(leadList.get(z).Deal_Program__c!=null)
                        strNewOppName = leadList.get(z).Deal_Program__c; 
                }
            }
            
            converter.setOpportunityName(strNewOppName);

            //heena changes begin PRM  R2: setting lead status to converted for deal Reg leads and MQL otherwise
            LeadStatus convertStatus;
 
                convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true
                    and  MasterLabel like 'C%'];                

            //heena changes end PRM R2     
            converter.setConvertedStatus(convertStatus.MasterLabel);
            leadsToConvert.add(converter);
        }
        //convert all the leads .. 
        System.debug(logginglevel.Debug,'Leads to be converted is : '+leadsToConvert);
        system.debug('SystemIdUtility.isLeadUpdate1 inside 11'+SystemIdUtility.isLeadUpdate1);
        ldConvertResult = Database.ConvertLead(leadsToConvert, false);// setting as opt_allOrNoneparameter to false as the process shouldn't stop    
        system.debug('SystemIdUtility.isLeadUpdate1 inside 22'+SystemIdUtility.isLeadUpdate1);   
    }
    catch(Exception ex){ 
        System.debug(logginglevel.Debug,'Exception occured during lead conversion : '+ex);
    } 
         Set<String> oppids= new Set<String>();
         List<String> convertedLeads= new List<String>();
        // capture the leads that were not converted 
        system.debug('SystemIdUtility.isLeadUpdate1 inside 12'+SystemIdUtility.isLeadUpdate1);
    for(integer j = 0;j<ldConvertResult.size();j++)
    {
        if(!ldConvertResult[j].isSuccess()) 
        { 
            for(integer i =0;i<leadList.size();i++)
            {
                if(leadList.get(i).Id == ldConvertResult[j].getLeadId())
                {
                    System.debug(logginglevel.Debug,'Exception in lead conversion : '+ldConvertResult[j].getErrors().get(0));
                    leadList.get(i).addError(ldConvertResult[j].getErrors().get(0).getMessage());
                    // leadList.get(i).addError(ldConvertResult[j].getErrors());
                }
            }
        }    //heena changes begin for lead- oppty mapping 
        else{       
            if(ldConvertResult[j].getOpportunityId()!=null)
              {
                  convertedLeads.add(ldConvertResult[j].getLeadId());
                  oppids.add(ldConvertResult[j].getOpportunityId());
              } 
        }
    } system.debug('SystemIdUtility.isLeadUpdate1'+SystemIdUtility.isLeadUpdate1);   
    if(oppids.size()>0)
    {
        //added by Heena to avoid calling the function again via Lead Trigger
        system.debug('SystemIdUtility.isLeadUpdate1 inside '+SystemIdUtility.isLeadUpdate1);
        if(SystemIdUtility.isLeadUpdate1 != true)  {      
            SystemIdUtility.isLeadUpdate1 = true;
        //Heena changes end
        system.debug('calling future method for Lead-Oppty mapping');
        FutureProcessor.UpdateOpportunity_OnLeadConversion(convertedLeads, oppids);   
        }
    }
     //heena changes end for lead- oppty mapping 
} 

//**********************Update_OpportunityOnLeadConversion_Trigger METHODS ************************************//
/*
* Parent function to process the leads and the converted opps. and update the Volume_Account__c,Commercial_Account__c 
* & Account_Contact__c fields on opportunity 
* 
* @param ldList,oppList
* @returns list of updated opportunities
*/ 
public List<Opportunity> updateAccountDetails(List<Opportunity> oppList,List<Lead> ldList) {
List<Contact> contDetailsList = new List<Contact>();
    set<Id> contactIds = new set<Id>();
for(integer i = 0;i < ldList.size();i++) {
for(integer j = 0;j<oppList.size();j++) {
        if(oppList.get(j).Id == ldList.get(i).ConvertedOpportunityId )
        
        {
            // update the Account Contact with converted contact id
            if(oppList.get(j).Account_Contact__c != ldList.get(i).ConvertedContactId)
            {
            oppList.get(j).Account_Contact__c = ldList.get(i).ConvertedContactId;
            } 
        
            // populate the commercial account
            if(ldList.get(i).BU__c != null && ldList.get(i).BU__c.equalsIgnoreCase('Value'))
            {
                if(oppList.get(j).Ent_Comm_Account__c == null) 
                {
                    oppList.get(j).Ent_Comm_Account__c = oppList.get(j).AccountId; 
                } 
            }
			if(ldList.get(i).BU__c != null && (ldList.get(i).BU__c.equalsIgnoreCase('RMDM') || ldList.get(i).BU__c.equalsIgnoreCase('ISBU')))
            {
                // add the account contact id to a set
                contactIds.add(ldList.get(i).ConvertedContactId);
			}				
        }
    }

}
// find the contact details
contDetailsList = retrieveContactDetails(contactIds);

System.debug(logginglevel.Debug,'1 : The oppList is :'+oppList); 


// return the final updated opp. list 
return oppList;
}

/*
* Function to update the opportunity with Aggregate Account & also to update the contacts
* The convertLead database method accepts up to 100 LeadConvert objects
* 
* @param ldList,oppList
* @return oppList:opportunity list
*/ 
private List<Opportunity> updateVolCustAndContact(List<Lead> ldList,List<Opportunity> oppList){

try
{
if(contDetList.size() > 0)
// upsert contacts with the agg. account & volume customer values
upsert contDetList;
}
catch(DmlException dmlEx) {
// catch any DML exception during the upsert call 
} 
return oppList;
}
 

/*
* Function to query the contact object to get the contact details 
* Function contains 1 SOQL 
* @param contIds
* @@return a contact list
*
*/ 
private List<Contact> retrieveContactDetails(set<Id> contIds) {
contDetList = [Select c.AccountId, c.Volume_Customer__c, c.Id from Contact c where c.Id in :contIds limit 1000];

return contDetList; 

}

    @isTest(SeeAllData=true)
    public static void AutoLeadConversion_Test(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Enterprise_ID__c = '1234';
        acc.BillingStreet = 'Arlington';
        acc.BillingCountry = 'US';
        acc.BillingCity = 'VA';
        insert acc;
        contact c = new contact(lastname ='test contact', email ='abc@cde.com', accountid = acc.id);
        insert c;
        
        
        
        List<Lead> objLeads = new List<Lead>();
        
        Lead objLead = new Lead();
        objLead.LastName = 'test';
        objLead.Company = 'test';
        objLead.Commercial_Account__c = acc.Id;
        objLead.GEO__c = 'EMEA';
        objLead.Email = 'abc@cde.com';
        objLead.Opportunity_Deal_Type__c = 'IND-RMDM';
        
        insert objLead;
        objLeads.add(objLead);
        
        
        
        objLead = new Lead();
        objLead.LastName = 'test';
        objLead.Company = 'test';
        objLead.GEO__c = 'NA';
        objLead.Commercial_Account__c = acc.Id;
        insert objLead;
        objLeads.add(objLead);
        
        
        
        AutoLeadConversion objleadConvert = new AutoLeadConversion();
        objleadConvert.setupData(objLeads);
        objleadConvert.populateAcctAndContact(objLeads,objLeads);
        objleadConvert.checkLeadOwnerType(objLead);
        objleadConvert.identifyResellerOwnerDetails(objLeads);
        objleadConvert.convertLead(objLeads);
    }
}