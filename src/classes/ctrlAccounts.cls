public class ctrlAccounts {

public id vid{get;set;}
public list<account> lstacc1 {get;set;}
public list<account> lstacc2 {get;set;}
public list<account> lstacc3 {get;set;}
public list<account> lstacc4 {get;set;}
public list<account> lstacc5 {get;set;}
public list<account> lstacc6 {get;set;}
public list<account> lstacc7 {get;set;}
public list<id> lstid;

public account acc{get;set;}

public ctrlAccounts()
{
    setValues();
}

    public void setValues()
    {
         if(ApexPages.currentPage().getParameters().get('id') != null)
               vId=ApexPages.currentPage().getParameters().get('id');
         else      
            vId = '001Q0000008aQtC'; // to test
        acc = [Select a.Customer_Category__c, a.parent.parent.parent.parent.parent.parentId, a.parent.parent.parent.parent.parentId, a.parent.parent.parent.parentId, a.Name,
                a.parent.parent.parentId, a.parent.parentId, a.parentId, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c From Account a 
                where a.id =: vId Order by Name];
        if(acc.parent.parent.parent.parent.parent.parentId != null)
            vId = acc.parent.parent.parent.parent.parent.parentId;
        else if(acc.parent.parent.parent.parent.parentId != null)
            vId = acc.parent.parent.parent.parent.parentId;            
        else if(acc.parent.parent.parent.parentId != null)
            vId = acc.parent.parent.parent.parentId;
        else if(acc.parent.parent.parentId != null)
            vId = acc.parent.parent.parentId;
        else if(acc.parent.parentId != null)
            vId = acc.parent.parentId;
        else if(acc.parentId != null)
            vId = acc.parentId;
                 
        lstacc1  = [Select  a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where id=: vId Order by Name];
        lstacc2  = [Select a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where parentId=: vId Order by Name];
        lstacc3  = [Select a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where parent.parentId=: vId Order by Name];
        lstacc4  = [Select a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where parent.parent.parentId=: vId Order by Name];
        lstacc5  = [Select a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where parent.parent.parent.parentId=: vId Order by Name];
        lstacc6  = [Select a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where parent.parent.parent.parent.parentId=: vId Order by Name];               
        lstacc7  = [Select a.Customer_Category__c, a.RecordType.Name, a.Enterprise_ID__c, a.Commercial_ID__c, a.Name, a.Country_Picklist__c, a.id, a.parentId  From Account a 
                where  parent.parent.parent.parent.parent.parentId=: vId Order by Name];               
        

    }


}