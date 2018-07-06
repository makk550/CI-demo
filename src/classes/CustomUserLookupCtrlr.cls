public with sharing class CustomUserLookupCtrlr {
    
    public String endUserName { get; set; }
    public String account {get;set;}
    public String usrTypeSelected {get;set;}
    
    public List<User> results{get;set;}
    public transient boolean showResults{get;set;}
    public boolean showSearch{get;set;}
    
    public CustomUserLookupCtrlr() {
        
        showResults = false;
        
        showSearch = true;
        
        endUserName = ApexPages.currentPage().getParameters().get('uName');
        account     = ApexPages.currentPage().getParameters().get('aName');
        usrTypeSelected = ApexPages.currentPage().getParameters().get('uType');
        system.debug('usrTypeSelected + usrTypeSelected '+usrTypeSelected+' + '+usrTypeSelected);
        system.debug('endUserName>>'+endUserName);
        system.debug('account>>'+account);
    }

    public PageReference SearchAccounts()
    {  
       string strUserName ='';
       string strUserType ='';
       results = null;
       showResults = false;
       
       if(endUserName != null)
       strUserName = String.escapeSingleQuotes(endUserName.trim());
       strUserName = '%'+strUserName+'%';
       if(usrTypeSelected != null)
       strUserType = String.escapeSingleQuotes(usrTypeSelected.trim());
       
       
       String usrType ='PowerPartner';
       String groupName = label.Business_Plan_Partner_Team_ID_Label;
        System.debug('account in SearchAccounts'+ account);
        System.debug('strUserType  in SearchAccounts'+  strUserType );
        
        List<GroupMember> grpMembers =new List<GroupMember>();
        grpMembers = [Select UserOrGroupId From GroupMember Where GroupId =: groupName];
        List<string> newUserList = new List<string>();
        List<User> userAddOns = new List<User>();
        for(GroupMember gp:grpMembers ){
            newUserList.add(gp.UserOrGroupId);
        }
        if(account != null && (strUserType == 'Partner User' ||strUserType == '' ||strUserType == null))
        results =[select Name, Email from User where Name like :strUserName and Contact.AccountId =:account and userType =:usrType and IsActive = true limit 1000];
        if(account != null && strUserType == 'User')
        results =[select Name, Email from User where Name like :strUserName and id in :newUserList limit 1000];
        system.debug('results>>'+results);
        if(results != null && results.size()>0)
            showResults = true;
         else
            showResults =false;
        
        
        return null;
    }
    
    public PageReference showSearchScreen()
    {
      
      showSearch = true;    
      showResults = false;      
      return null;  
    }
     
    public String formatName(String Name)
    {
        return String.escapeSingleQuotes(Name);
    }

}