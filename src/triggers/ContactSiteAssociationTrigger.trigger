trigger ContactSiteAssociationTrigger on Contacts_Site_Association__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
		TriggerFactory.createHandler(Contacts_Site_Association__c.sObjectType);
}