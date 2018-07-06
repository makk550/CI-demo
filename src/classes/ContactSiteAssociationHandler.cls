/*************************************************************************\
       @ Author      :
       @ Date        : 16/04/14
       @ Test File   : 
       @ Description : Trigger Handler for the Case SObject. This class implements the ITrigger.
                       interface to help ensure the trigger code is bulkified and all in one place.
       
@ Audit Trial : Repeating block for each change to the code
       @ Last Modified By   :     
       @ Last Modified On   :   
       @ Last Modified Reason     :   
          
 @Last Modified on **** by *** to ******

****************************************************************************/

public without sharing class ContactSiteAssociationHandler implements ITrigger{

   /*
    * Member variables
    */
    private List<Contact> contactList = new List<Contact>();
/**
   * bulkBefore
   *
   * This method is called prior to execution of a BEFORE trigger. Use this to cache
   * any data required into maps prior execution of the trigger.
*/
    public void bulkBefore()
    {        
        ContactSiteAssociationGateway.loadContactSiteAssociationBulkBefore(Trigger.New);
    }

  public void bulkAfter()
  {
  
       
  } 
  public void beforeInsert(SObject so)
  {
    Contacts_Site_Association__c contactSiteAssociation = (Contacts_Site_Association__c)so;
    if(ContactSiteAssociationGateway.getMatch(contactSiteAssociation)){
        contactSiteAssociation.addError('You Cannot have duplicate Contact Site Association Record');
    } 
    if(ContactSiteAssociationGateway.contactMap!=null && ContactSiteAssociationGateway.contactMap.containsKey(contactSiteAssociation.SC_CSA_CONTACTS__c)&& ContactSiteAssociationGateway.siteAssociationMap!=null && ContactSiteAssociationGateway.siteAssociationMap.containsKey(contactSiteAssociation.SC_CSA_SITE__c) ){
        Contact contact = ContactSiteAssociationGateway.contactMap.get(contactSiteAssociation.SC_CSA_CONTACTS__c);
        if(contact.AccountId ==null){
            contact.AccountId = ContactSiteAssociationGateway.siteAssociationMap.get(contactSiteAssociation.SC_CSA_SITE__c).Enterprise_ID__c;
            contactList.add(contact);
        }
    }
    
  }
  public void beforeUpdate(SObject oldSo, SObject so)
  {
    Contacts_Site_Association__c contactSiteAssociation = (Contacts_Site_Association__c)so;
    Contacts_Site_Association__c contactSiteAssociationOld = (Contacts_Site_Association__c)oldSo;
    if(contactSiteAssociationOld.SC_CSA_CONTACTS__c!=contactSiteAssociation.SC_CSA_CONTACTS__c || contactSiteAssociationOld.SC_CSA_SITE__c!=contactSiteAssociation.SC_CSA_SITE__c){
	    if(ContactSiteAssociationGateway.getMatch(contactSiteAssociation)){
	        contactSiteAssociation.addError('You Cannot have duplicate Contact Site Association Record');
	    } 
    }    
  }

  /**
     * beforeDelete
     *
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger.
     */
  public void beforeDelete(SObject so)
  {  
 
  }
  public void afterInsert(SObject so)
  {

                                      
         
         
   
   
  }
  public void afterUpdate(SObject oldSo, SObject so)
  {
   
    
  
          
       
      
    
  }
  public void afterDelete(SObject so)
  {
    
  }

 /**
   * andFinally
   *
   * This method is called once all records have been processed by the trigger. Use this
   * method to accomplish any final operations such as creation or updates of other records.
 */
    public void andFinally()
    {
        if(contactList!=null && contactList.Size()>0){
            update contactList; 
        }
      
    }



}