/*
 * Test Class = Contact_Relationship_RelatedList_Test
 * Coverage = 92%
 * Updated by - PATSA27
*/ 

public class Contact_Relationship_RelatedList {
    private List<Contact_Relationship__c> CR;
    private Contact cntact;
    public string listurl{get;set;}
    public string crContactName{get;set;}
    public string crUserName{get;set;} 
    public Contact_Relationship_RelatedList(ApexPages.StandardController controller) {
        this.cntact= (Contact)controller.getRecord();
        listurl = Label.ContactRelationshipList;
        crContactName = Label.ContactRelationshipContactName;
        crUserName = Label.ContactRelationshipUserName;
    }
    public List<Contact_Relationship__c> getCR()
    {
        Contact con = [Select id, Account.id FROM Contact where id = :cntact.id];
        if (con.Account == null){
         return null;
         }
         else{
        CR = [Select CA_User__c, CA_User_Name__c, CARelationshipType__c, Strength__c, StrengthOfRelationship__c, Contact_Role__c, Primary_Contact_Owner__c, Active__c, LastActivityDate, CreatedDate,(SELECT Id, Name FROM Attachments),(SELECT Id, Title FROM Notes) from Contact_Relationship__c where Contact__c = :con.id Order by Primary_Contact_Owner__c DESC, CreatedDate DESC];
        return CR;
        }
    }
    
    
       
    
}