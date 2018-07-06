public class AccountCont{

    public PageReference Submit() {
        return null;
    }

public List<Account> accRec{set;get;}
public void Submit(List<Id> recId){
accRec=[Select Id,Name,Industry,(Select Id,FirstName,LastName from Contacts) from Account where id=:recId];
}
}