public class UserSkillUpdateSite {

private final User_Skills__c USK;
public User_Skills__c user_skills {get;set;}
public String topsid {get;set;}
public List<String> siteList {get;set;}
public List<SiteListWrapper> siteWrapperList {get;set;}
private Apexpages.StandardController controller;

public UserSkillUpdateSite (ApexPages.StandardController std) {
 this.controller = std;
 USK= (User_Skills__c)std.getRecord();
 siteWrapperList = new List<SiteListWrapper>();
 siteList  = new List<String>();
 topsid = '';
 user_skills = USK;
 user_skills.Tops_Site_ID__c = [select Tops_Site_ID__c from User_Skills__c where id =:usk.id].Tops_Site_ID__c;
 topsid = user_skills.Tops_Site_ID__c ;
 if(topsid!= null && topsid.length() >0){
 siteList= topsid.split(';');
 for(String site : siteList) {
 siteWrapperList.add(new SiteListWrapper(site));
 }
 }
 else
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'This User is not associated with any Sites '));
 } 

public PageReference updateResult() {

    String topsidUpd = '';
    List<SiteListWrapper> sw1 = new List<SiteListWrapper>();
    for(SiteListWrapper sw : siteWrapperList)
    {
        if(sw.checkbox == true){
        sw1.add(sw);
        topsidUpd+=sw.site+';';
        }
    }
    siteWrapperList = new List<SiteListWrapper>(); 
    siteWrapperList.addall(sw1);     
    usk.Tops_Site_ID__c = topsidUpd.removeend(';');    
    update usk;
    
    return Controller.Save();
    
}

 public class SiteListWrapper{
  public String site {get;set;}
  public boolean checkbox {get;set;}

 
  public SiteListWrapper(String site){
  this.site = site;
  checkbox=true;
  }
 }
 
}