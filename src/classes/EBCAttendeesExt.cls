public class EBCAttendeesExt {

    public Account account{get;set;}
    public string accountId {set; get;}
    public string contactIds {set; get;}
    public string visitId {set; get;}
    public Contact newContact {set; get;}
    public string errMsg {set; get;}
    public List<Contact> lstContacts;
    
    
    //code for additiong pagination
    
    private integer counter=0;  //keeps track of the offset
    private integer recordsToDisplay=200; //number of records to display 
    public integer TotalCont; //used to show user the total number of contacts
    
    public Integer getTotalNumberOfContacts() 
    {
    TotalCont = [select count() from Contact where AccountId=:account.id]; 
    
    return TotalCont;
    }

    
    public Integer getPageNumber() {
    return counter/recordsToDisplay + 1;
    }

   public Integer getTotalPages() {
  if (math.mod(getTotalNumberOfContacts(), recordsToDisplay) > 0) {
     return getTotalNumberOfContacts()/recordsToDisplay + 1;
  } else {
     return (getTotalNumberOfContacts()/recordsToDisplay);
  }
}
   
public EBCAttendeesExt(ApexPages.StandardController controller) {
        this.account = (Account)controller.getRecord();
        accountId = ApexPages.currentPage().getParameters().get('id');
        contactIds = ApexPages.currentPage().getParameters().get('contactIds');
        visitId = ApexPages.currentPage().getParameters().get('VisitId');
        lstContacts = new List<Contact>();
    }

    public List<Contact> getlstContacts(){
        lstContacts = [Select Id, Name, Email, Phone, Title from Contact where AccountId=:accountId order by Name limit : recordsToDisplay offset : counter ];
        return lstContacts;     
    }   
    
    
   //
public PageReference Beginning() { 
      counter = 0;
      return null;
}
 
public PageReference Previous() { 
  counter -= recordsToDisplay;
  return null;
}

public PageReference Next() { 
  counter += recordsToDisplay;
  return null;
}

public PageReference End() { 
  counter = TotalCont - math.mod(TotalCont, recordsToDisplay);
  return null;
}
//
public Boolean getDisablePrevious() { 
  //this will disable the previous and beginning buttons
  if (counter>0) return false; else return true;
}

public Boolean getDisableNext() { 
  //this will disable the next and end buttons
  if (counter + recordsToDisplay < TotalCont) return false; else return true;
}

  

   //
    public PageReference initPage(){
        accountId = ApexPages.currentPage().getParameters().get('id');
        contactIds = ApexPages.currentPage().getParameters().get('contactIds');
        visitId = ApexPages.currentPage().getParameters().get('VisitId');
        newContact = new Contact();
        return null;
    }

    public PageReference createContact(){
        try{
            newContact.AccountId = accountId;
            insert newContact;
            newContact = null;
            newContact = new Contact();
        }catch(Exception ex){
            errMsg = ex + '';
            ApexPages.addMessages(ex);
        }
        return null;
    }

    
}