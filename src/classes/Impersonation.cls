public class Impersonation{

    @TestVisible
    public String email { get ; set; }   
    //public String load { get { return 'cso.enterprise@gmail.com';} set; }   
    public static String samlResponse;// { get; set; } 
    //public Boolean shouldRedirect {public get; private set;}
    public static String impersonateAuditID;// { get; set; } 
    @TestVisible
    public static String welcomemsg { 
        get { return 'You are in Impersonation.'; } 
        set { welcomemsg=value;} 
    }     
    //public static String relaystate { get{ return 'https://profile-qa.ca.com/us/register/ssoauthenticate.aspx?returnURL=https://support-qa.ca.com';} set; } 
    //public static String samlPostURL { get { return 'https://samlgwsm-qa.ca.com/affwebservices/public/saml2assertionconsumer';} set ;}
    @TestVisible
    public Impersonation(){
        system.debug('In Constructor');
        email = ApexPages.currentPage().getParameters().get('email');
        //impersonate();
    }
    // Service class for API Gateway callouts
      @TestVisible
      private CC_Layer7Service.I l7Svc {
        get {
          if (l7Svc == null) {
            l7Svc = new CC_Layer7Service();
          }  
          return l7Svc;
        } set;
      }
    @TestVisible
    public PageReference impersonate(){
         //email='cso.basic@gmail.com';
         System.debug('email='+email);
         if(validate()) {
            //get the ldap id
             String ldapid = l7Svc.getLDAPID(email);
             //ldapid  = ldapid  + '@';
             System.debug('response data='+ldapid);
             if (String.isBlank(ldapid)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Email address is not found and user cannot be impersonated'));
                    welcomemsg='Impersonation Failed!';
                    return null;
             }
             //submit to l7 to get the saml response
             //samlResponse = l7Svc.getSAMLResponse(ldapid + '@ca.com'); 
             samlResponse = l7Svc.getSAMLResponse(email); 
             System.debug('samlResponse='+samlResponse);
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'OK to Launch Support Portal'));
             ImpersonateAudit__c impaudit=new ImpersonateAudit__c(Impersonator__c=UserInfo.getUserId(),starttime__c=System.now(), impersonatee__c=email);
             insert impaudit;
             impersonateAuditID=impaudit.ID;

              PageReference rPost = new PageReference(Label.Impersonation_samlPostURL);
              rPost.getParameters().put('SAMLResponse',samlResponse);
              rPost.getParameters().put('RelayState',Label.Impersonation_relaystate);
              rPost.setRedirect(true);
              //shouldRedirect = true;
              welcomemsg='You are in Impersonation!';
              return rPost;
         }
         //else     
          return null;  
    }
    @TestVisible
    public boolean validate(){
         System.debug('email='+email);
         if (String.isBlank(email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Enter Email ID'));
            return false;
          }
         else if (email.contains('@ca.com')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'CA Employees cannot be impersonated'));
            return false;
         }
         /*else if (!validateEmail(email)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a valid Email ID.'));
            return false;
         }*/
         return true;
    }
    @TestVisible
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
    
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }

}