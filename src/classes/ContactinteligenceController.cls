public class ContactinteligenceController {
 
    Public Contact Con{get;set;}
    Public Contact_Relationship__c conrelation{get;set;}
    public list<Contact> Currentconlist{get;set;}
    public list<Contact> duplicateconlist{get;set;}
     
    public string confname{get;set;}
    public string conlname{get;set;}
    public string conmail{get;set;}
    public string conacc{get;set;}
    public string Url{get;set;} 
    Public list<duplicatewrapper> Dupconlist{get;set;}
    Public list<duplicatewrapper> Dupconlist2{get;set;}
    Map<id,list<Contact_Relationship__c>> allContactsMap = new Map<id,list<Contact_Relationship__c>>();
    public string conid{get;set;}
    public Boolean hasduplicates{get;set;}
    public Boolean hascon{get;set;}
    public Boolean nocon{get;set;}
    public String contactSelected{get;set;}
    public Id RecordTypeId {get;set;}
    public string domname{get;set;}
    public string retdomname{get;set;}
    public string currentuserProfileid{get;set;}
    Public list<Profile> servicecloudprofiles{get;set;}
    public Boolean serviceclouduser=false;
     public string relationtype{get;set;}
    public string conRole{get;set;}
    public string StrengthOfR{get;set;}
    public Boolean consexists{get;set;}
    
    public Boolean accname{get;set;}
    public Boolean firname{get;set;}
    public Boolean latname{get;set;}

    

    
    Set<string> Scprofileset;
     String servicecloudprofilenames = Label.CI_servicecloudprofiles;
        String[] SCprofilelist = servicecloudprofilenames.split(';');
   // public ContactinteligenceController(){}
    
    public ContactinteligenceController(ApexPages.StandardController controller) {
        Con=new contact();
        conrelation=new Contact_Relationship__c();
        retdomname=System.URL.getSalesforceBaseURL().getHost();
        RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('New').getRecordTypeId();
       
        
        domname= System.URL.getSalesforceBaseURL().getHost().replace('-c','-uniqueentry');
        system.debug('domname----/'+domname);
        currentuserProfileid=userinfo.getProfileId();
        Scprofileset=New Set<string>();
        Scprofileset.addAll(SCprofilelist);
        system.debug('profile list----'+Scprofileset);
        servicecloudprofiles=[select id,Name from Profile where name IN:Scprofileset];
        system.debug('servicecloudprofiles----/'+servicecloudprofiles);
        for(Profile p:servicecloudprofiles){
            if(p.id==currentuserProfileid){
                serviceclouduser=True;
                conrelation.CARelationshipType__c='Customer Success';
                conrelation.StrengthOfRelationship__c='1 - Have met the individual. They would likely take my call';
                conrelation.Contact_Role__c='Tech/Sys Admin';
            }
            
        }
        system.debug('serviceclouduser-----'+serviceclouduser);
        hascon=False;
        duplicateconlist=new list<Contact>();
        Dupconlist=New List<duplicatewrapper>();
        Dupconlist2=New List<duplicatewrapper>();
    }
    
    public PageReference SearchContact(){
         system.debug('hasduplicates---'+hasduplicates);
         system.debug('hascon---'+hascon);
          if(hasduplicates !=null){
            consexists=true;
            nocon=false;
              
        }else{
            nocon=true;
            consexists=false;
        }
        Dupconlist2=New List<duplicatewrapper>();
        try {
            Dupconlist2=searchforduplicatecons();
            System.debug('Dupconlist2========'+Dupconlist2);
        }
        catch (System.NullPointerException e) {
            system.debug('line number'+e.getLineNumber()+' Message'+e.getMessage());
        }
      system.debug('hascon---'+hascon);
        if(Dupconlist2==Null ){
            system.debug('hascon---');
            nocon=true;
            hascon=false;
            
        }else{
           
            nocon=False;
        }
            System.debug('Dupconlist2-------------------------'+Dupconlist2);   
            return null;
    }
    
    
    
   Public list<duplicatewrapper> searchforduplicatecons(){
        Dupconlist=New List<duplicatewrapper>();
     
        system.debug('in FirstName--'+con.FirstName);
        system.debug('in Accountid--'+con.Accountid);
        if(con.FirstName!= Null && con.FirstName!='' && con.Email != Null){
            system.debug('in FirstName con list');
            Currentconlist=[select id,Name,FirstName,LastName,Email,Account.name,Accountid,(select id,Name from Contact_Relationship_Maps__r where createdbyid=:Userinfo.getUserId()) from Contact where Email=:con.Email And FirstName  Like: con.FirstName+'%' ];
            if(Currentconlist.size()>0){
                 accname=true;
                firname=true;
                latname=true;
                
            }
        }else if(con.LastName !=Null && con.LastName!=''  && con.Email != Null){
            Currentconlist=[select id,Name,FirstName,LastName,Email,Account.name,Accountid,(select id,Name from Contact_Relationship_Maps__r where createdbyid=:Userinfo.getUserId()) from Contact where Email=:con.Email And  LastName Like:con.LastName+'%'];
            system.debug('in Lastname conlist');
            if(Currentconlist.size()>0){
                accname=true;
                firname=true;
                latname=true;
            }
        }else if(con.Accountid!= Null  && con.Email != Null){
            Currentconlist=[select id,Name,FirstName,LastName,Email,Account.name,Accountid,(select id,Name from Contact_Relationship_Maps__r where createdbyid=:Userinfo.getUserId()) from Contact where Email=:con.Email And Accountid =: con.Accountid];
            system.debug('in Account con list');
            if(Currentconlist.size()>0){
                 accname=true;
                firname=true;
                latname=true;
            }
        }else{
           system.debug('in else con list');
           Currentconlist=[select id,Name,FirstName,LastName,Email,Account.name,Accountid,(select id,Name from Contact_Relationship_Maps__r where createdbyid=:Userinfo.getUserId()) from Contact where Email=:con.Email ];
          if(Currentconlist.size()>0){
                 accname=true;
                firname=true;
                latname=true;
            }
        }
        system.debug('Currentconlist----'+Currentconlist);
         duplicateconlist=new list<Contact>();
        if(Currentconlist.size()>0){
            system.debug('entered in if condition');
            for(Contact co:Currentconlist){
               if(co.Email ==con.Email){
                   system.debug('entered in email condition');
                   duplicateconlist.add(co);
                   for(Contact_Relationship__c cr:co.Contact_Relationship_Maps__r){
               
                        allContactsMap.put(co.Id,new List<Contact_Relationship__c>{cr});
                   }
                }
            }
        }
          
        system.debug('duplicateconlist----'+duplicateconlist.size());
        system.debug('duplicateconlist----'+duplicateconlist);
       if(Dupconlist.size()>0){
        Dupconlist.clear();
           consexists=true;
       }
        if(duplicateconlist.size()>0){
            for(Contact co:duplicateconlist){
                duplicatewrapper  dupcon= new duplicatewrapper();
                dupcon.con=co;
                // dupcon.crblist=allContactsMap.get(co.Id);
                dupcon.isselected=False;
                if(allContactsMap!=null && !allContactsMap.isEmpty() && allContactsMap.get(co.Id)!=null){
                    system.debug('entered if condition in allContactsMap');
                    for(Contact_Relationship__c crl:allContactsMap.get(co.Id)){
                        system.debug('entered for in allContactsMap');
                        dupcon.crid=crl.Id;
                        dupcon.crblist1 +=crl.Name+',';
                    }
                    dupcon.crblist1= dupcon.crblist1.removeStartIgnoreCase('null');
                    dupcon.crblist1= dupcon.crblist1.removeEnd(',');
            }
            Dupconlist.add(dupcon);
        }
            if(Dupconlist.size()>0){
                accname=true;
                firname=true;
                latname=true;  
            }else{
                 accname=false;
                firname=false;
                latname=false; 
                
            }
        hasduplicates=true;
            
        return Dupconlist;
    }else
    {
       hasduplicates=False;
       return null;
    }
    }
    public void validateAccountSearch(){
        system.debug('---Entered validate search---');
        //conid=apexpages.currentpage().getparameters().get('select') ;
        system.debug('conid---'+conid);
        contactSelected=conid;
        hascon=true;
        for(Profile p:servicecloudprofiles){
            if(p.id==currentuserProfileid){
                serviceclouduser=True;
            }
        }
    }
    public Void getrelationshipvalues(){
        relationtype=conrelation.CARelationshipType__c;
        conRole=conrelation.Contact_Role__c;
        StrengthOfR=conrelation.StrengthOfRelationship__c;
        system.debug('relationtype--'+relationtype +'conRole '+conRole+'StrengthOfR  '+StrengthOfR);
        
    }
    
    public PageReference nextPage() {
        //conid=apexpages.currentpage().getparameters().get('select') ;
        system.debug('---'+contactSelected);
        system.debug('CARelationshipType__c--'+conrelation.CARelationshipType__c);
        system.debug('StrengthOfRelationship__c--'+conrelation.StrengthOfRelationship__c);
        system.debug('Contact_Role__c--'+conrelation.Contact_Role__c);
        try{
            if(contactSelected == Null || contactSelected ==''){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Contact Name to Associate');            
            ApexPages.addMessage(msg);
            return null;
            }else if( relationtype==Null || relationtype=='' || relationtype=='--None--'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Contact Relationship Type');            
                ApexPages.addMessage(msg);
                return null;
            }else if(StrengthOfR=='' || StrengthOfR==Null || StrengthOfR=='--None--'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Strength Of Relationship');            
                ApexPages.addMessage(msg);
                return null;
            }else if(conRole=='--None--' || conRole==Null || conRole==''){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Contact Role');            
                ApexPages.addMessage(msg);
                return null;
            }else{
              
                 conrelation.Contact__c=contactSelected;
          conrelation.CA_User__c=userinfo.getuserid();
             // conrelation.LastName__c=con.LastName;
             // conrelation.Emails__c=con.Email;
             // conrelation.FirstName__c=con.FirstName;
              Insert conrelation;
              
                System.debug('conrelation==ID=== '+conrelation.Id);
                PageReference relationPage = new PageReference('/'+contactSelected);
                relationPage.setRedirect(true);
                return relationPage;
            }
          
            } catch (Dmlexception e) {
               ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You already have a Contact Relationship with the same Contact');            
                ApexPages.addMessage(msg);
                return null;
        }  
        return Null;
    }  
    
    public PageReference createnewcon() {
        //conid=apexpages.currentpage().getparameters().get('select') ;
        system.debug('serviceclouduser-----'+serviceclouduser);
        system.debug('contactSelected-----'+contactSelected);
        if(serviceclouduser && contactSelected!= Null){
            conrelation.Contact__c=contactSelected;
           // conrelation.Emails__c=con.Email;
            conrelation.CA_User__c=userinfo.getuserid();
            insert conrelation;
            system.debug('conrelation id-----'+conrelation.Id);
        }
        system.debug('-RecordTypeId--'+RecordTypeId);
        string retURL='https://'+ retdomname +'/apex/newcontactCI';
        if(con.FirstName != null && con.LastName!=null && con.Accountid != null){
            system.debug('in first if');
            Url='https://'+ domname +'/003/e?nooverride=1&'+system.label.CI_ContatactrelationType+'='+conrelation.CARelationshipType__c+'&'+system.label.CI_ContactRole+'='+conrelation.Contact_Role__c+'&'+system.label.CI_StrengthOfRelationship+'='+conrelation.StrengthOfRelationship__c+'&con15='+con.Email+'&name_lastcon2='+con.LastName+'&'+system.label.CI_ThroughDupeCheck+'=1&retURL='+retURL;   
        }else if(con.LastName!=null && con.Email != null){
            system.debug('in 2 if');
           Url='https://'+ domname +'/003/e?nooverride=1&'+system.label.CI_ContatactrelationType+'='+conrelation.CARelationshipType__c+'&'+system.label.CI_ContactRole+'='+conrelation.Contact_Role__c+'&'+system.label.CI_StrengthOfRelationship+'='+conrelation.StrengthOfRelationship__c+'&con15='+con.Email+'&name_lastcon2='+con.LastName+'&'+system.label.CI_ThroughDupeCheck+'=1&retURL='+retURL;   
        }else{
            system.debug('in 3 if');
            Url='https://'+ domname +'/003/e?nooverride=1&'+system.label.CI_ContatactrelationType+'='+conrelation.CARelationshipType__c+'&'+system.label.CI_ContactRole+'='+conrelation.Contact_Role__c+'&'+system.label.CI_StrengthOfRelationship+'='+conrelation.StrengthOfRelationship__c+'&con15='+con.Email+'&'+system.label.CI_ThroughDupeCheck+'=1&retURL='+retURL;   
        }
        PageReference pg = new PageReference(Url);
        pg.setRedirect(true);
        return pg;
    } 
    
    public PageReference ifserviceclouduser(){
        currentuserProfileid=userinfo.getProfileId();
        servicecloudprofiles=[select id,Name from Profile where name IN:Scprofileset];
        system.debug('servicecloudprofiles----/'+servicecloudprofiles);
        List<CI_Profiles__c> allprofiles=CI_Profiles__c.getAll().values();
        
        Set<string> salesprofilename=new Set<string>();
        Boolean salesclouduser=false;
         List<Profile> salescloudprofiles=new List<Profile>();
        
        for(CI_Profiles__c CIprofile:allprofiles){
          if(CIprofile.Name.containsIgnorecase('Sales')){             
            salesprofilename.add(CIprofile.Profile_Name__c);   
          }    
        }
       if(salesprofilename.size()>0) 
         salescloudprofiles=[select id,Name from Profile where name IN:salesprofilename];      
        
        for(Profile p:salescloudprofiles){
            if(p.id==currentuserProfileid){
                salesclouduser=true;
                break;
            }
        }
        
        for(Profile p:servicecloudprofiles){
            if(p.id==currentuserProfileid){
                serviceclouduser=True;
            }
        }
        if(serviceclouduser==True){
            system.debug('service cloud user');
            // string   strUrl='https://'+ domname +'/apex/uniqueContact?ent=Contact&RecordType=' + RecordTypeId + '&00NV0000001Es8f='+conrelation.CARelationshipType__c+'&00NV0000001Es8k='+conrelation.StrengthOfRelationship__c+'&00NV0000001Es8z='+conrelation.Contact_Role__c;
            string   strUrl='https://'+ domname +'/003/e?nooverride=1&'+system.label.CI_ContatactrelationType+'='+conrelation.CARelationshipType__c+'&'+system.label.CI_StrengthOfRelationship+'='+conrelation.StrengthOfRelationship__c+'&'+system.label.CI_ThroughDupeCheck+'=True'+'&'+system.label.CI_ContactRole+'='+conrelation.Contact_Role__c;   
            PageReference pg = new PageReference(strUrl);
            pg.setRedirect(true);
            return pg;
        }else if(salesclouduser==True){
             return null;
            
        }else{
            string   strUrl='https://'+ domname +'/apex/uniqueContact'; 
            PageReference pg = new PageReference(strUrl);
            pg.setRedirect(true);
            return pg;  
        }
       
    }
    
    public PageReference back(){
        string cancelURL='https://'+ retdomname +'/003/o';
        PageReference pg = new PageReference(cancelURL);
        pg.setRedirect(true);
        return pg;
    }
    
    /*  @RemoteAction
    public static List<String> findSearchResult( string ProductStr) {
    
        
        
       String soql = ''; 
        
       
        soql = 'SELECT id, Name, Email,LastName,FirstName,Account.Name FROM Contact WHERE ';
        
        soql += '(Email' + ' LIKE \'%' + ProductStr + '%\'' +')ORDER BY NAME';
        
        system.debug('##### QUERY :- '+ soql);
        
        List<Contact>  contactlist = new List<Contact>();
    List<String> searchlist=new List<String>();
        try {
            contactlist = Database.query(soql);
            system.debug('##### contactlist :- '+ contactlist.size());
            for(Contact  p: contactlist ){
                searchlist.add(p.Email);
            }
            
            system.debug('####-'+searchlist.size()) ;
            
        }
        catch (QueryException e) {
            system.debug('##### QueryException :- '+ e);
            return null;
        }
        
        return searchlist;      
    
    }*/
    
    
     
   public class duplicatewrapper{
   
       public contact con{get;set;}
         public List<Contact_Relationship__c> crblist{get;set;}
         public id crid{get;set;}
         public string crblist1{get;set;}
          Public Boolean isselected{get;set;}
       public string emailid{get;set;}
       public string AccountName{get;set;}
       
     public duplicatewrapper(){
    
        this.con=con;
        this.isselected=false;
       
    }
  
   
   }
   
   

}