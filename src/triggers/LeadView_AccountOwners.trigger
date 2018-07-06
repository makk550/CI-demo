trigger LeadView_AccountOwners on Lead (before insert, before update) 
{
  //Initialize variables
  String CAGlobalLeadrecordTypeName = 'CA Global Lead';
  
  Set<String> EAIDSet = new Set<String>();
  Map<String,Id> accountEAIDMap = new Map<String,Id>();
   //Collect available Lead Record Types.
  Schema.DescribeSObjectResult leadRTDescribe = Schema.SObjectType.Lead;    
  Map<String,Schema.RecordTypeInfo> leadRecTypeMap = leadRTDescribe.getRecordTypeInfosByName(); 
  Id CAGlobalLeadRecordTypeId = leadRecTypeMap.get(CAGlobalLeadrecordTypeName).getRecordTypeId();
    
  RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('CA Indirect Lead');
  Id CAIndLeadRecTypeId = rec.RecordType_Id__c; // record type id for CA Indirect Lead

  
  System.debug('****CAIndLeadRecTypeId****' + CAIndLeadRecTypeId);
  //Collect list of EAID from incoming Leads 
  if(Trigger.isBefore && Trigger.isInsert)
  {
      for(Integer s=0; s<Trigger.size; s++)
      {
        if(Trigger.new[s].RecordTypeId == CAGlobalLeadRecordTypeId && Trigger.new[s].EAID__c != null)
        EAIDSet.add(Trigger.new[s].EAID__c);
        if(Trigger.new[s].RecordTypeId == CAIndLeadRecTypeId)
           Trigger.new[s].RTM__c='Solution Provider'; 
      }
  }
  
  else if(Trigger.isBefore && Trigger.isUpdate)
  {
      for(Integer s=0; s<Trigger.size; s++)
      {
        //System.Debug('Trigger.new[s].EAID__c => '+Trigger.new[s].EAID__c);
        //System.Debug('Trigger.old[s].EAID__c => '+Trigger.old[s].EAID__c);
        
        //Had to comment the below line Since the Recursive workflow field update affects the trigger execution.
        //if(Trigger.new[s].RecordTypeId == CAGlobalLeadRecordTypeId && Trigger.new[s].EAID__c != null && ((Trigger.new[s].EAID__c != Trigger.old[s].EAID__c) || (Trigger.new[s].RecordTypeId != Trigger.old[s].RecordTypeId)))
        if(Trigger.new[s].RecordTypeId == CAGlobalLeadRecordTypeId && Trigger.new[s].EAID__c != null)
        EAIDSet.add(Trigger.new[s].EAID__c);
        
         if(Trigger.new[s].RecordTypeId == CAIndLeadRecTypeId && Trigger.old[s].RTM__c != Trigger.new[s].RTM__c)
           Trigger.new[s].RTM__c='Solution Provider';
      } 
  }
  
  //Using "EAID's" collect the corresponding AccountId's
  if(Trigger.isBefore)
  {
      if(EAIDSet.size() != 0)
      {
          for(Account acc : [SELECT Id, Enterprise_ID__c FROM Account WHERE Enterprise_ID__c IN : EAIDSet])
          {
            accountEAIDMap.put(acc.Enterprise_ID__c, acc.Id);
          }
      }
      
      //Populate AccountId on Lead records.
      //Nullify "Commercial_Account__c" field if no match found.
      //if(accountEAIDMap.size() != 0)
     // {
        for(Lead l : Trigger.new)
        {
            //if(accountEAIDMap.get(l.EAID__c) != null && l.RecordTypeId == CAGlobalLeadRecordTypeId) l.Commercial_Account__c = accountEAIDMap.get(l.EAID__c);
            //else if(l.RecordTypeId == CAGlobalLeadRecordTypeId) l.Commercial_Account__c = null;----commented by Jagadeesh Kureti
        }
    // }
  }
  /***********/
  /**populating Email addresses for Email Notification**/
  /**Added by prmr2 team 24/11/2010 */
  List<Lead> lst=Trigger.new;
  List<Lead> lstCAIn=new List<Lead>();
  for(Lead l:lst)
  {
    
  if(!SystemIdUtility.IsDeal_RegistrationRecordType(l.recordTypeId))
  lstCAIn.add(l);
  }
  DealReg_ApproversOnLead objEmail = new DealReg_ApproversOnLead();
  if(lstCAIn.size() > 0)
  {
  objEmail.populateEmailFields(lstCAIn);
  }
  /***********/
  /***Update Is Partner User Owner flag,
  @Balasaheb Wani
  @release 2.1 
  */
  LeadOwnerPartner objLdOwner =new LeadOwnerPartner();
  objLdOwner.updateIsPartnerUserOwner(lst);
  /*****
  @release 2.1 Ends  
  */
  
  /* Release: Nov 2014
     Auth: Mari Ganesan
     Des: Autopopulating Location fields
     */
  
  Set<id> leadaccids = new set<id>();
  
  for(lead a: Trigger.new) leadaccids.add(a.Commercial_Account__c);
  
  if(leadaccids.size()>0)
  {
  System.debug('---in account loop---');
  Map<Id,Account> newAccts = new Map<id,Account>([select id,GEO__c,Sales_Area__c,Sales_Region__c,Region_Country__c,Country_Picklist__c,BillingState from Account where id in :leadaccids]);
  for(lead a:Trigger.new) 
  {
      if(Trigger.isInsert || ((Trigger.newMap.get(a.id)).Commercial_Account__c!=null && (Trigger.oldMap.get(a.id)).Commercial_Account__c !=(Trigger.newMap.get(a.id)).Commercial_Account__c))
      {
          if(newAccts.get(a.Commercial_Account__c)!=null)
          {
          account acct =newAccts.get(a.Commercial_Account__c);
          a.GEO__c = acct.GEO__c;
          a.MKT_Territory__c = acct.Sales_Area__c;
          a.Sales_Territory__c=acct.Sales_Region__c;
          a.Country__c=acct.Region_Country__c;
          a.Country_Picklist__c=acct.Country_Picklist__c;
          a.State__c=acct.BillingState;//Modified by SAMTU01-
          }
      }
      else if(((Trigger.newMap.get(a.id)).Commercial_Account__c==null && (Trigger.oldMap.get(a.id)).Commercial_Account__c !=(Trigger.newMap.get(a.id)).Commercial_Account__c))
      {
      
          a.GEO__c = null;
          a.MKT_Territory__c = null;
          a.Sales_Territory__c=null;
          a.Country__c=null;
          a.Country_Picklist__c=null;
          a.State__c=null;//Modified by SAMTU01-
      }
  }
  }
      
}