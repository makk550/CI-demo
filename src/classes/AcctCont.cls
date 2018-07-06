public class AcctCont{
public String acName{set;get;}
public List<Contact> cont{set;get;}
public void Submit(){
cont=[Select Id,Name,Email,Phone,Account.Id from Contact where Name=:acName];
}
}