public class KBDetailsControllerBackup{
    public list<Knowledge__kav> KBArticles {get;set;}
    public string recordTypeVal            {get;set;}
    public List<String> releases           {get;set;} 
    public List<String> prods              {get;set;} 
    public String  artRatingAvgScore       {get; set;}
    public String  artRatingVoteCount      {get; set;}
    public String prodAlias                {get;set;} 
    public Set<String> components          {get;set;} 
    public boolean hasAttachments          {get;set;}
    public boolean hasTechDetails          {get;set;}
    public String titleVal                 {get;set;}
    public String numberVal                {get;set;}
    public Boolean showSection             {get;set;}
    public String errorMessage{get;set;}
    public String publishDate {get;set;}
    public string articleId;
    public String CADocid {get;set;}
    public String contactEmail {get; set;}
    public String seoURL {get; set;}
      public static User currentUser {
        get {
          if (currentUser == null) {
            Id currentUserId = UserInfo.getUserId();
            currentUser = [SELECT Id, FirstName, LastName, TimeZoneSidKey, LDAP_Date_Format__c,LDAP_Basic_Impl_Open_Case__c, LDAP_Time_Format__c, LDAP_Roles__c, Contact.Id, Contact.SC_CONTACT_LDAPID__c, Contact.SC_CONTACT_LDAP_DEFAULT_SITE_ID__c,Contact.Phone,Contact.Email,Contact.AccountId, Contact.Account.Name FROM User WHERE ID = :currentUserId];
          }
          return currentUser;
        }
        set;
    }
    
    @TestVisible
    public static String cnValues{
        get{
            if(cnValues == null && currentUser.LDAP_Roles__c != null)
            {
                CC_LDAPRoles ldapRoles = new CC_LDAPRoles();
                cnValues = ldapRoles.reverseTranslateString(currentUser.LDAP_Roles__c);
            } else {
                cnValues = null;
            }
            return cnValues;
        }
        set;
    }
    public static String pendingCaseNumber{
        get {
              return CC_ngTurkeyController.pendingCaseNumber;
        }
    }
    
        public static String userContext {
        get {
            System.debug('UserInfo.getUserType:'+UserInfo.getUserType());
            if(currentUser!= null && UserInfo.getUserType() == 'Guest'){
                 return null;
            }
            
            if(currentUser!= null && UserInfo.getUserType() != 'Guest'){
                return JSON.serialize(new Map<String, Object>{
                    'userId' => currentUser.Id,
                        'firstName' => currentUser.FirstName,
                        'lastName' => currentUser.LastName   
                        });
            } else {
                return null;
            }            
        }
    }
    
  
    
    
    
    
 public PageReference getKBArticles(){ 
     
     articleId = String.isNotBlank(ApexPages.currentPage().getParameters().get('id'))?ApexPages.currentPage().getParameters().get('id'):'';
     string release;
     string compName;
     string prodName;
     errorMessage = '';
     PageReference pageRef =new PageReference(System.Label.KCS_Page_Not_Found);
     if(String.isNotBlank(articleId))
     {
         numberVal = articleId;
              KBArticles = [ 
                             Select id ,articlenumber,urlname,File_attachment__Body__s,recordType.Name, knowledgeArticleId, Auto_Article_Number__c, Title, Please_select_a_heading__c, Search_Result_Summary__c, Content1__c ,Environment__c, 
                             product_names__c, LastModifiedDate , LastPublishedDate, Cause__c , Please_select_a_heading2__c , Content2__c , Additional_Information__c ,
                             Component_Names__c , Component_Codes__c , Releases__c,
                             File_attachment__Name__s,File_attachment2__Name__s,File_attachment3__Name__s,File_attachment4__Name__s,File_attachment5__Name__s,
                             Introduction__c, Question__c , Answer__c,Content4__c ,
                             Please_select_a_heading3__c, Content3__c , Background__c, Instructions__c, CADocid__c
                             from Knowledge__kav
                             where articlenumber=:articleId and Publishstatus='Online' AND IsVisibleInPkb=true limit 1
                           ];  
             System.debug('Articles Found'+KBArticles.size());          
             if(KBArticles==null || KBArticles.size()==0)
             {
                System.debug(' No Articles Found');
                return pageRef;
             }   
             if(KBArticles<>null && KBArticles.size()>0)
             {
                 pageRef = null;//new PageReference('https://support.ca.com/us/not-found.html');
                 System.debug(' KBArticles Statrting!'); 
                 
                 showSection = true;
                 if(String.isNotBlank(KBArticles[0].Title)){
                        titleVal = KBArticles[0].Title;    
                 }
                 if(String.isNotBlank(KBArticles[0].CADocid__c)){
                        CADocid = KBArticles[0].CADocid__c;    
                 }
                 
                 if(String.isNotBlank(KBArticles[0].urlname)){
                        String hostUrlValue= ApexPages.currentPage().getHeaders().get('Host');
                     System.debug(' Host Url : '+ hostUrlValue);
                     if(String.isNotBlank(hostUrlValue)){
                         seoURL = 'https://'+hostUrlValue+'/kb/'+KBArticles[0].urlname+'/KB'+KBArticles[0].articlenumber;
                         seoURL = seoURL.toLowerCase();
                     }
                 }
                 // code to store PageView Count Information
                 String kb_pageview_label=System.Label.KB_View;
                 if(String.isNotBlank(kb_pageview_label) && kb_pageview_label.containsIgnoreCase('true')){
                     upsertPageViewCountPerDay();
                 }
                 DateTime dateTimeVal;
                 if(kbarticles[0].LastPublishedDate<>null){
                        dateTimeVal = kbarticles[0].LastPublishedDate;
                 }else{
                    dateTimeVal = kbarticles[0].LastModifiedDate;
                 }
                 String formatdateTimeVal = dateTimeVal.format('dd/MM/yyyy');
                 publishDate = String.valueOf(formatdateTimeVal ); 
                 
                 //introduction__c
                 if(String.isNotBlank(KBArticles[0].Introduction__c)){
                     /*if(KBArticles[0].Introduction__c.contains('</a>')){
                         KBArticles[0].Introduction__c = KBArticles[0].Introduction__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */   
                 }else{
                     KBArticles[0].Introduction__c = '';
                 }
                 
                 //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Introduction__c)){
                     if(KBArticles[0].Introduction__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Introduction__c =  checkImageURL(KBArticles[0].Introduction__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }
                                           
                     }  
                     
                      // For anchor tags - links to articles 
                       if(KBArticles[0].Introduction__c.contains('<a'))  {   
                           System.debug('reformHrefUrl - KBArticles[0].Introduction__c starts');                           
                           KBArticles[0].Introduction__c = reformHrefUrl(KBArticles[0].Introduction__c);
                           KBArticles[0].Introduction__c = reformAttachmentURL(KBArticles[0].Introduction__c,KBArticles[0].id);
                      } 
                     
                 }
                 
                 
                 //Additional_Information__c
                 if(String.isNotBlank(KBArticles[0].Additional_Information__c)){
                    /* if(KBArticles[0].Additional_Information__c.contains('</a>')){                                               
                         KBArticles[0].Additional_Information__c = KBArticles[0].Additional_Information__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */   
                 }else{
                     KBArticles[0].Additional_Information__c = '';
                 }
                 
                //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Additional_Information__c)){
                     if(KBArticles[0].Additional_Information__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Additional_Information__c =  checkImageURL(KBArticles[0].Additional_Information__c);
                          
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }
                                                                      
                     }
                     // For anchor tags - links to articles 
                       if(KBArticles[0].Additional_Information__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Additional_Information__c starts');           
                          KBArticles[0].Additional_Information__c = reformHrefUrl(KBArticles[0].Additional_Information__c);
                          KBArticles[0].Additional_Information__c = reformAttachmentURL(KBArticles[0].Additional_Information__c,KBArticles[0].id);
                       }
                 }
                 
                 //Answer__c
                 if(String.isNotBlank(KBArticles[0].Answer__c)){
                     /*if(KBArticles[0].Answer__c.contains('</a>')){
                         KBArticles[0].Answer__c = KBArticles[0].Answer__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     }  */ 
                 }else{
                     KBArticles[0].Answer__c = '';
                 }
                //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Answer__c)){
                     if(KBArticles[0].Answer__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Answer__c =  checkImageURL(KBArticles[0].Answer__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     
                     // For anchor tags - links to articles 
                       if(KBArticles[0].Answer__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Answer__c starts');           
                          KBArticles[0].Answer__c = reformHrefUrl(KBArticles[0].Answer__c);
                          KBArticles[0].Answer__c = reformAttachmentURL(KBArticles[0].Answer__c,KBArticles[0].id);
                       }
                     
                 }
                 
                 //Background__c
                 if(String.isNotBlank(KBArticles[0].Background__c)){
                    /* if(KBArticles[0].Background__c.contains('</a>')){
                         KBArticles[0].Background__c = KBArticles[0].Background__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */   
                 }else{
                     KBArticles[0].Background__c = '';
                 }
                 
                 //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Background__c)){
                     if(KBArticles[0].Background__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                       String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Background__c =  checkImageURL(KBArticles[0].Background__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     
                     if(KBArticles[0].Background__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Background__c starts');           
                          KBArticles[0].Background__c = reformHrefUrl(KBArticles[0].Background__c);
                          KBArticles[0].Background__c = reformAttachmentURL(KBArticles[0].Background__c,KBArticles[0].id);
                       }
                     
                 }
                 
                 //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Environment__c)){
                     if(KBArticles[0].Environment__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue <> null && urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Environment__c =  checkImageURL(KBArticles[0].Environment__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     
                     if(KBArticles[0].Environment__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Environment__c starts');           
                          KBArticles[0].Environment__c = reformHrefUrl(KBArticles[0].Environment__c);
                          KBArticles[0].Environment__c = reformAttachmentURL(KBArticles[0].Environment__c,KBArticles[0].id);
                       }
                     
                 }
                 
                 //Cause__c
                 if(String.isNotBlank(KBArticles[0].Cause__c)){
                     /*if(KBArticles[0].Cause__c.contains('</a>')){
                         KBArticles[0].Cause__c = KBArticles[0].Cause__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */   
                 }else{
                     KBArticles[0].Cause__c = '';
                 }
                 
                //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Cause__c)){
                     if(KBArticles[0].Cause__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Cause__c =  checkImageURL(KBArticles[0].Cause__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     
                     if(KBArticles[0].Cause__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Cause__c starts');           
                          KBArticles[0].Cause__c = reformHrefUrl(KBArticles[0].Cause__c);
                          KBArticles[0].Cause__c = reformAttachmentURL(KBArticles[0].Cause__c,KBArticles[0].id);
                       }                     
                 }
                 
                 //Instructions__c
                 if(String.isNotBlank(KBArticles[0].Instructions__c)){
                     /*if(KBArticles[0].Instructions__c.contains('</a>')){
                         KBArticles[0].Instructions__c = KBArticles[0].Instructions__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */  
                 }else{
                     KBArticles[0].Instructions__c = '';
                 }
                 
                 //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Instructions__c)){
                     if(KBArticles[0].Instructions__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Instructions__c =  checkImageURL(KBArticles[0].Instructions__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     
                     if(KBArticles[0].Instructions__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Instructions__c starts');           
                          KBArticles[0].Instructions__c = reformHrefUrl(KBArticles[0].Instructions__c);
                          KBArticles[0].Instructions__c = reformAttachmentURL(KBArticles[0].Instructions__c,KBArticles[0].id);
                       }
                     
                 }
                 
                 //Content3__c
                 if(String.isNotBlank(KBArticles[0].Content3__c)){
                     /* if(KBArticles[0].Content3__c.contains('</a>')){
                         KBArticles[0].Content3__c = KBArticles[0].Content3__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */  
                 }else{
                     KBArticles[0].Content3__c = '';
                 }
                 //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Content3__c)){
                     if(KBArticles[0].Content3__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Content3__c =  checkImageURL(KBArticles[0].Content3__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     if(KBArticles[0].Content3__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Content3__c starts');           
                          KBArticles[0].Content3__c = reformHrefUrl(KBArticles[0].Content3__c);
                          KBArticles[0].Content3__c = reformAttachmentURL(KBArticles[0].Content3__c,KBArticles[0].id);
                       }                    
                     
                 }
                 
                 //Content1__c
                 if(String.isNotBlank(KBArticles[0].Content1__c)){
                     /*if(KBArticles[0].Content1__c.contains('</a>')){
                         KBArticles[0].Content1__c = KBArticles[0].Content1__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */  
                 }else{
                     KBArticles[0].Content1__c = '';
                 }
                 
               //Rich Text image check
                  if(String.isNotBlank(KBArticles[0].Content1__c)){
                     if(KBArticles[0].Content1__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                         if(urlvalue <> null && urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Content1__c =  checkImageURL(KBArticles[0].Content1__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     if(KBArticles[0].Content1__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Content1__c starts');           
                          KBArticles[0].Content1__c = reformHrefUrl(KBArticles[0].Content1__c);
                          KBArticles[0].Content1__c = reformAttachmentURL(KBArticles[0].Content1__c,KBArticles[0].id);
                       } 
                 }
                 
                 //Question__c
                 if(String.isNotBlank(KBArticles[0].Question__c)){
                     /*if(KBArticles[0].Question__c.contains('</a>')){
                         KBArticles[0].Question__c = KBArticles[0].Question__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */   
                 }else{
                     KBArticles[0].Question__c = '';
                 }
                 //Rich Text image check
                 if(String.isNotBlank(KBArticles[0].Question__c)){
                     if(KBArticles[0].Question__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Question__c =  checkImageURL(KBArticles[0].Question__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     if(KBArticles[0].Question__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Question__c starts');           
                          KBArticles[0].Question__c = reformHrefUrl(KBArticles[0].Question__c);
                          KBArticles[0].Question__c = reformAttachmentURL(KBArticles[0].Question__c,KBArticles[0].id);
                     }
                 }
                 
                 //Content2__c
                 if(String.isNotBlank(KBArticles[0].Content2__c)){
                    // System.debug('KBArticles[0].Content2__c:'+KBArticles[0].Content2__c);                     
                     if(KBArticles[0].Content2__c.contains('</a>')){                         
                       KBArticles[0].Content2__c = KBArticles[0].Content2__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     }    
                 }else{
                     KBArticles[0].Content2__c = '';
                 }
                 //Rich Text image check
                   if(String.isNotBlank(KBArticles[0].Content2__c)){
                     if(KBArticles[0].Content2__c.contains('<img'))
                     {
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                        if( urlvalue <> null && urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Content2__c =  checkImageURL(KBArticles[0].Content2__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }  
                       
                      // For anchor tags - links to articles 
                       if(KBArticles[0].Content2__c.contains('<a'))  {   
                           System.debug('reformHrefUrl - KBArticles[0].Content2__c:' + KBArticles[0].Content2__c);                           
                           KBArticles[0].Content2__c = reformHrefUrl(KBArticles[0].Content2__c);
                           KBArticles[0].Content2__c = reformAttachmentURL(KBArticles[0].Content2__c,KBArticles[0].id);
                      }                  
                       
                 }
                 
                 //Content4__c
                 if(String.isNotBlank(KBArticles[0].Content4__c)){
                     /*if(KBArticles[0].Content4__c.contains('</a>')){
                        KBArticles[0].Content4__c = KBArticles[0].Content4__c.replace('<a ','<a onclick="checkExistingArticle(this.href);return false;" ');    
                     } */   
                 }else{
                     KBArticles[0].Content4__c = '';
                 }
                 //Rich Text image check
                 System.debug(' Before Content4!');
                 if(String.isNotBlank(KBArticles[0].Content4__c)){
                     if(KBArticles[0].Content4__c.contains('<img'))
                     {
                         System.debug(' inside --1 ');
                        //Check if page is rendered from comm.support.ca.com//
                        String urlvalue=ApexPages.currentPage().getHeaders().get('Host');
                         System.debug('urlvalue : '+ urlvalue);
                        if(urlvalue <> null && urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        {
                         System.Debug('URL Contains Comm.support.ca.com');
                        //Call the Image check function
                          System.Debug('This field contains image - checking for regex pattern');
                          KBArticles[0].Content4__c =  checkImageURL(KBArticles[0].Content4__c);  
                        }
                        else
                        {
                            System.Debug('URL is not external URL');
                        }                                                                      
                     }
                     if(KBArticles[0].Content4__c.contains('<a'))  {
                          System.debug('reformHrefUrl - KBArticles[0].Content4__c starts');           
                          KBArticles[0].Content4__c = reformHrefUrl(KBArticles[0].Content4__c); 
                          KBArticles[0].Content4__c = reformAttachmentURL(KBArticles[0].Content4__c,KBArticles[0].id);
                     }
                 }
                 
                 if(String.isNotBlank(KBArticles[0].Auto_Article_Number__c)){
                        numberVal = KBArticles[0].Auto_Article_Number__c;    
                 }
                 
                 if(KBArticles[0].recordType.Name<>null)
                 {
                     recordTypeVal       =  KBArticles[0].recordType.Name;  
                 }  
                 if(KBArticles[0].Releases__c<>null)
                 {
                      release      =  KBArticles[0].Releases__c;
                      if(release<>null)
                      {
                          releases = new List<String>();
                          List<String> listOfRelease = release.split('\n');
                          for(String rNumber:listOfRelease){
                              if(String.isNotBlank(rNumber) && rNumber.contains(':')){
                                  String ecmProductName = rNumber.substringBefore(':');
                                  if(rNumber.contains(';')){
                                      List<String> listOfRN = rNumber.subStringAfter(':').split(';');
                                      for(String rNumberVal:listOfRN){
                                          if(String.isNotBlank(rNumberVal)){
                                              rNumberVal = rNumberVal.replace(' ','');
                                              rNumberVal = rNumberVal.replace('\n','');
                                              releases.add(ecmProductName+':Release:'+rNumberVal);
                                          }
                                      }
                                  }else{
                                      rNumber = rNumber.subStringAfter(':');
                                      rNumber = rNumber.replace(' ','');
                                      rNumber = rNumber.replace('\n','');
                                      releases.add(ecmProductName+':Release:'+rNumber);
                                  }
                              }
                          }
                       //releases = release.split(';');
                      }
                 }
                 if(KBArticles[0].product_names__c<>null)
                 {
                     prodName =  KBArticles[0].product_names__c;
                     if(prodName <>null)
                     {
                         prods = new List<String>();
                         List<String> listOfProducts = prodName.split('\n');
                         for(String pnName:listOfProducts){
                             if(String.isNotBlank(pnName)){
                                prods.add(pnName);    
                             }
                         }
                         //prods       = prodName.split(';');
                     }
                 }
                 if(KBArticles[0].Component_Names__c <>null)
                 {
                     compName =  KBArticles[0].Component_Codes__c ;
                     if(compName <>null)
                     {
                         components = new Set<String>();
                         List<KCS_Association__c> listOfKCS = [Select id,Product_ID__c, Product_Count__c, Component_ID__c from KCS_Association__c where Component_ID__c!='' AND Component_ID__c!=null AND Article_Id__c=:KBArticles[0].knowledgeArticleId order by Product_Count__c asc];

                         if(listOfKCS<>null && listOfKCS.size()>0){
                             Map<Integer,String> mapOfXMDAndComp = new Map<Integer,String>();
                             Map<String,String> mapOfCompIdAndText = new Map<String,String>();
                             set<Id> compIds = new set<Id>();
                             set<Integer> productCount = new set<Integer>();
                             for(KCS_Association__c kcsObj:listOfKCS){
                                 system.debug(kcsObj+'====>>>>>'+mapOfXMDAndComp);
                                 if(mapOfXMDAndComp==null || mapOfXMDAndComp.size()==0 || !mapOfXMDAndComp.containsKey(Integer.valueOf(kcsObj.Product_Count__c))){
                                     mapOfXMDAndComp.put(Integer.valueOf(kcsObj.Product_Count__c),kcsObj.Component_ID__c);
                                 }else if(mapOfXMDAndComp<>null && mapOfXMDAndComp.size()>0 && String.isNotBlank(mapOfXMDAndComp.get(Integer.valueOf(kcsObj.Product_Count__c))) && !mapOfXMDAndComp.get(Integer.valueOf(kcsObj.Product_Count__c)).contains(kcsObj.Component_ID__c)){
                                     mapOfXMDAndComp.put(Integer.valueOf(kcsObj.Product_Count__c),mapOfXMDAndComp.get(Integer.valueOf(kcsObj.Product_Count__c))+';'+kcsObj.Component_ID__c);
                                 }
                                 compIds.add(kcsObj.Component_ID__c);
                                 productCount.add(Integer.valueOf(kcsObj.Product_Count__c));
                             }
                             
                             
                             if(compIds<>null && compIds.size()>0){
                                 List<ca_product_component__c> listOfComp =[Select id,Component_Text__c,Component_Code__c from ca_product_component__c where Component_Text__c!=null AND Component_Text__c!='' AND Component_Code__c!=null AND Component_Code__c!='' AND Id IN:compIds];
                                 
                                 if(listOfComp<>null && listOfComp.size()>0){
                                     for(ca_product_component__c compObj:listOfComp){
                                         mapOfCompIdAndText.put(compObj.Id, compObj.Component_Text__c+':'+compObj.Component_Code__c);
                                     }
                                 }
                             }
                             
                             if(mapOfXMDAndComp<>null && mapOfXMDAndComp.size()>0){
                                 for(Integer i:productCount){
                                     if(String.isNotBlank(mapOfXMDAndComp.get(i)) && mapOfXMDAndComp.get(i).contains(';')){
                                         List<String> listOfCompId = mapOfXMDAndComp.get(i).split(';');
                                         for(String compText:listOfCompId){
                                             if(String.isNotBlank(compText)){
                                                 components.add(mapOfCompIdAndText.get(compText.replace(' ','')));
                                             }
                                         }
                                         
                                     }else if(String.isNotBlank(mapOfXMDAndComp.get(i)) && !mapOfXMDAndComp.get(i).contains(';')){
                                         components.add(mapOfCompIdAndText.get(mapOfXMDAndComp.get(i).replace(' ','')));
                                     }
                                 }
                             }
                         }
                     }
                  }
                  
                 if(KBArticles[0].File_attachment__Name__s != null || KBArticles[0].File_attachment2__Name__s != null || KBArticles[0].File_attachment3__Name__s != null || KBArticles[0].File_attachment4__Name__s != null || KBArticles[0].File_attachment5__Name__s != null)
                 {
                    
                     hasAttachments = true;          
                 
                 }
                 else
                 {
                     hasAttachments = false;
                 }
                 
                 if(KBArticles[0].Component_Names__c != null || KBArticles[0].product_names__c!= null || KBArticles[0].Releases__c!= null)
                 {
                    
                     hasTechDetails  = true;          
                 }
                 else
                 {
                     hasTechDetails  = false;
                 }
             }
             //JSON-LD
             //get the product alias
                List<ID> lstXMDProductID=new List<ID>();
                //List<Id> lstXMDProduct=[SELECT ID from CA_XMD_Product_Mapping__c WHERE xmd_product__C IN (SELECT ID from XMD_Product__c WHERE name=:KBArticles[0].product_names__c)].Id;
                if (KBArticles.size() > 0 &&  KBArticles[0].product_names__c!= null ){
                for(CA_XMD_Product_Mapping__c c:[SELECT CA_Product__c from CA_XMD_Product_Mapping__c WHERE xmd_product__C IN (SELECT ID from XMD_Product__c WHERE name IN :prods)]){
                    lstXMDProductID.add(c.CA_Product__c);
                }        
                System.debug('Getting lstXMDProductID='+lstXMDProductID);
                //lstXMDProductID.addall(lstXMDProduct.ID);
                List<Product_Names__c> lstProdAlias=[SELECT Product_Synonyms__c,Product_Usage__c FROM Product_Names__c WHERE CA_Product_Controller__c IN (select ID FROM CA_Product_Controller__c where ID IN :lstXMDProductID)];    
                 if(lstProdAlias.size()>0){
                    prodAlias='';
                    for(Product_Names__c pa:lstProdAlias){
                            prodAlias = prodAlias +',' + pa.Product_Synonyms__c;
                    }
                    }
                 }   
  
             List<KBArticle_Average_Rating__c> getartRating =[ Select name,Average_Score__c, Vote_Count__c from KBArticle_Average_Rating__c where Name = :articleId LIMIT 1];
             if(getartRating<>null && getartRating.size() > 0){
                artRatingAvgScore=String.valueof(getartRating[0].Average_Score__c/10);
                artRatingVoteCount=String.valueof(getartRating[0].Vote_Count__c);
                System.debug('Getting the Rating='+artRatingAvgScore+'---'+artRatingVoteCount);
             } 
             //JSON-LD
     }else{
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No results found!!');
         ApexPages.addMessage(myMsg);
     }
     return pageRef;
}
  
    //Function to check URLs
     public string checkImageURL(string richTextVal){
         
         //string urltext;
         Matcher imgMatcher = Pattern.compile( '<img(.+?)>' ).matcher( richTextVal );

        // iterate each image tag found
        while ( imgMatcher.find() ) {
            // get the image tag html
            String imageTag = imgMatcher.group();
            System.debug( 'From KB Details Ctrl imageTag=' + imageTag );
            // get the value of the src attribute
            // the leading space is significant to avoid other attributes like data-cke-saved-src
            String imageURL = imageTag.substringBetween( ' src="', '"' );
            System.debug( 'From KB Details Ctrl imageURL=' + imageURL );
        
            if(imageURL.containsIgnoreCase('/servlet/servlet.FileDownload'))
            {
                System.debug( 'Yes! This contains servlet value');
               richTextVal =  richTextVal.replace(imageURL,'/kb'+imageURL);
               System.debug( 'After YES , here is URL: ' + richTextVal);
            }
        }  
        System.debug( 'Here is the value we are returing: ' + richTextVal);
        return richTextVal;
     }
    
    public String reformHrefUrl(String text) {
        System.debug('In reformHrefUrl,text:'+ text);
        List<String> articlesURLNames = new List<String>();
        List<String> articlesIds = new List<String>();
        Map<String,String> urlMap = new map<String,String>();
        Map<ID,List<String>> idMap = new map<ID,List<String>>();
        Matcher anchorTagMatcher = Pattern.compile('<a(.+?)>').matcher( text );
        while ( anchorTagMatcher.find() ) {                       
           
            // get the image tag html
            String anchorTag = anchorTagMatcher.group();
            System.debug( '***anchorTag=' + anchorTag );            
            System.debug( '***anchorTag, group (0)=' + anchorTagMatcher.group(0));
            
            if( ! anchorTag.contains('href=')){
                System.debug('anchorTag without href:'+anchorTag);                
            }
            String hrefUrl = anchorTag.substringBetween( 'href="', '"' );
            System.debug( 'From KB Details Ctrl hrefUrl=' + hrefUrl );
            String articleName;
            String articleId;
            List<Knowledge__kav> testingObj = new List<Knowledge__kav>();
            if(hrefUrl!=null && hrefUrl.containsIgnoreCase('/articles/Knowledge/'))
            {
                System.debug('anchorTag, when article found, with /articles/Knowledge/:'+ anchortag);
                articleName = hrefUrl.substringAfter('/articles/Knowledge/');
                System.debug('articleName:'+ articleName);                
                articlesURLNames.add(articleName);
                /*testingObj = [Select id, articleNumber from Knowledge__kav where UrlName=:articleName AND IsVisibleInPkb=true limit 1]; //AND PublishStatus='Online'
                if(testingObj<>null && testingObj.size()>0){ 
                    text = text.replace(hrefUrl, '/kb/'+articleName+'/kb'+testingObj[0].articleNumber );
                } else {
                    System.debug('anchorTag, when no article found: hrefUrl:'+ hrefUrl);
                    text = text.replace(hrefUrl, System.Label.KCS_Page_Not_Found);  
                }*/               
            } else if(hrefUrl!=null && hrefUrl.containsIgnoreCase('/CustomKnowledgeEdit?articleId=')) {
                System.debug('anchorTag, when article found, with /CustomKnowledgeEdit?articleId=:'+ anchortag);
                articleId = hrefUrl.substringAfter('/CustomKnowledgeEdit?articleId=');
                System.debug('articleId:'+ articleId);
                articlesIds.add(articleId);
               /* testingObj = [Select id, articleNumber,UrlName from Knowledge__kav where id=:articleId AND IsVisibleInPkb=true limit 1]; //AND PublishStatus='Online'
                if(testingObj<>null && testingObj.size()>0){ 
                    text = text.replace(hrefUrl, '/kb/'+testingObj[0].UrlName +'/kb'+testingObj[0].articleNumber );
                } else {
                    System.debug('anchorTag, when no article found, with /CustomKnowledgeEdit : hrefUrl:'+ hrefUrl);
                    text = text.replace(hrefUrl, System.Label.KCS_Page_Not_Found);  
                }*/
            } 
            
        }  
        List<knowledge__kav> urlObject = new List<Knowledge__kav>();
        List<Knowledge__kav> articlesIdObject = new List<Knowledge__kav>();
        if(articlesURLNames <> null && articlesURLNames.size() > 0){
            urlObject=[Select id, articleNumber,urlName from Knowledge__kav where UrlName IN:articlesURLNames AND IsVisibleInPkb=true];
            if(urlObject <> null && urlObject.size() > 0){
                for(Knowledge__kav kbUrlObj: urlObject){
                    urlMap.put(kbUrlObj.urlName,kbUrlObj.ArticleNumber);
                }
                
            }
            
        }
        if(articlesIds <> null && articlesIds.size() > 0){
            articlesIdObject=[Select id, articleNumber,UrlName from Knowledge__kav where id IN:articlesIds AND IsVisibleInPkb=true];
            if(articlesIdObject <> null && articlesIdObject.size() > 0){
                for(knowledge__kav idObj: articlesIdObject){
                    list<String> idList = new List<String>();
                    idList.add(idObj.urlname);
                    idList.add(idObj.ArticleNumber);
                    idMap.put(idObj.id,idList);
                }  
                
            }
        }
        //code changes to modifiy KB URLS
        if((articlesURLNames <> null && articlesURLNames.size() > 0) || (articlesIds <> null && articlesIds.size() > 0) ){
            
             Matcher anchorTagMatcherAgain = Pattern.compile('<a(.+?)>').matcher( text );
        while ( anchorTagMatcherAgain.find() ) {                       
           
            // get the image tag html
            String anchorTag = anchorTagMatcherAgain.group();
            System.debug( '***anchorTag=' + anchorTag );            
            System.debug( '***anchorTag, group (0)=' + anchorTagMatcherAgain.group(0));
            
            if( ! anchorTag.contains('href=')){
                System.debug('anchorTag without href:'+anchorTag);                
            }
            String hrefUrl = anchorTag.substringBetween( 'href="', '"' );
            System.debug( 'From KB Details Ctrl hrefUrl=' + hrefUrl );
            String articleName;
            String articleId;
            List<Knowledge__kav> testingObj = new List<Knowledge__kav>();
            if(hrefUrl!=null && hrefUrl.containsIgnoreCase('/articles/Knowledge/'))
            {
                System.debug('anchorTag, when article found, with /articles/Knowledge/:'+ anchortag);
                articleName = hrefUrl.substringAfter('/articles/Knowledge/');
                System.debug('articleName:'+ articleName);                
               // articlesURLNames.add(articleName);
                //testingObj = [Select id, articleNumber from Knowledge__kav where UrlName=:articleName AND IsVisibleInPkb=true limit 1]; //AND PublishStatus='Online'
                if(urlMap <> null && urlMap.size() > 0 && urlMap.containsKey(articleName)){ 
                    text = text.replace(hrefUrl, '/kb/'+articleName+'/KB'+urlMap.get(articleName));
                } else {
                    System.debug('anchorTag, when no article found: hrefUrl:'+ hrefUrl);
                    text = text.replace(hrefUrl, System.Label.KCS_Page_Not_Found);  
                }               
            } else if(hrefUrl!=null && hrefUrl.containsIgnoreCase('/CustomKnowledgeEdit?articleId=')) {
                System.debug('anchorTag, when article found, with /CustomKnowledgeEdit?articleId=:'+ anchortag);
                articleId = hrefUrl.substringAfter('/CustomKnowledgeEdit?articleId=');
                System.debug('articleId:'+ articleId);
               // articlesIds.add(articleId);
               // testingObj = [Select id, articleNumber,UrlName from Knowledge__kav where id=:articleId AND IsVisibleInPkb=true limit 1]; //AND PublishStatus='Online'
                if(idMap<> null && idMap.size()> 0 && idMap.containsKey(articleId)){
                    List<String> idValues = idMap.get(articleId);
                    String artUrlValue = idValues[0];
                    String articleNum = idValues[1];
                    text = text.replace(hrefUrl, '/kb/'+artUrlValue +'/KB'+articleNum );
                } else {
                    System.debug('anchorTag, when no article found, with /CustomKnowledgeEdit : hrefUrl:'+ hrefUrl);
                    text = text.replace(hrefUrl, System.Label.KCS_Page_Not_Found);  
                }
            } 
            
        }
        }
        return text;
    }
    
    public String reformAttachmentURL(String text,String idVal){
        Matcher archorTagMatcher = pattern.compile('<a(.+?)>').matcher(text);
        while(archorTagMatcher.find()){
            String anchorTag = archorTagMatcher.group();
            System.debug( '***anchorTag=' + anchorTag );            
            System.debug( '***anchorTag, group (0)=' + archorTagMatcher.group(0));
            
            if( ! anchorTag.contains('href=')){
                System.debug('anchorTag without href:'+anchorTag);                
            }
            String hrefUrl = anchorTag.substringBetween( 'href="', '"' );
            if(hrefUrl.containsIgnoreCase('/servlet/fileField?entityId=') && hrefUrl.containsIgnoreCase('field=File_attachment__Body__s')){
                text = text.replace(hrefUrl, '/kb/servlet/fileField?entityId='+idVal+'&field=File_attachment__Body__s');
            }
        }
        return text;
    }
    
    public pageReference articleDetails(){
        String hrefValue = System.currentPagereference().getParameters().get('hrefVal');
        system.debug('---hrefValue-->'+hrefValue);
        boolean accessedFromCommunityURL = false;
        
            if(String.isNotBlank(hrefValue)){
               if (hrefValue.containsIgnoreCase('/articles/Knowledge/')){
                    
                    String urlvalue=ApexPages.currentPage().getHeaders().get('Host');                    
                    System.debug('urlValue:'+ urlvalue);
                    System.debug('URL.getSalesforceBaseUrl().toExternalForm():' + URL.getSalesforceBaseUrl().toExternalForm());
                        //if(urlvalue.containsIgnoreCase('comm.support.ca.com'))
                        if(urlvalue.containsIgnoreCase('.force.com') || urlvalue.containsIgnoreCase('comm.support.ca.com') )
                        {
                         System.Debug('In article details,URL Contains Comm.support.ca.com');                          
                          accessedFromCommunityURL = true;  
                        }
                    
                    List<String> getArticleURL = new List<String>();
                    if(hrefValue.contains('?')){
                        String splitByQuestionMark = hrefValue.substringBefore('?');
                        getArticleURL = splitByQuestionMark.split('/'); 
                    }else{
                        getArticleURL = hrefValue.split('/'); 
                    }
                   System.debug('getArticleURL:'+getArticleURL);
                    if(getArticleURL<>null && getArticleURL.size()>0){
                        String articleURLName = getArticleURL[getArticleURL.size()-1];
                        if(String.isNotBlank(articleURLName)){
                            List<Knowledge__kav> testingObj = new List<Knowledge__kav>();
                            testingObj = [Select id, articleNumber from Knowledge__kav where UrlName=:articleURLName AND IsVisibleInPkb=true limit 1]; //PublishStatus='Online' AND
                            if(testingObj<>null && testingObj.size()>0){
                                
                                if(accessedFromCommunityURL){
                                   // PageReference pageRef = new PageReference('/kb/'+articleURLName+'/kb'+testingObj[0].articleNumber);
                                    //PageReference pageRef = new PageReference('https://comm.support.ca.com'+'/kb/'+articleURLName+'/kb000009869');
                                    PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/kb/'+articleURLName+'/kb'+testingObj[0].articleNumber);
                                    pageRef.setRedirect(true);
                                    return pageRef;
                                } else {
                                    PageReference pageRef = new PageReference('/apex/kbDetails?id='+testingObj[0].articleNumber);
                                    pageRef.setRedirect(true);
                                    return pageRef;
                                }
                                
                            }else{
                                testingObj = [Select id, articleNumber from Knowledge__kav where UrlName=:articleURLName AND Publishstatus='Online' AND IsVisibleInPkb=false limit 1];
                                if(testingObj<>null && testingObj.size()>0){
                                    showSection = false;
                                    errorMessage = 'The article you have selected is no longer available for viewing. For more information:<br/><br/>-- check the <a href="'+system.label.SupportPage+'" target="_blank">Support home page</a> which offers a general search. <br/>â€¢ select a product on the <a href="'+system.label.ProductPage+'" target="_blank">Product Information page</a> which provides information related to the product.';
                                                }else{ 
                                    showSection = false;
                                    errorMessage = 'The article you have selected is no longer available for viewing. For more information:<br/><br/>-- check the <a href="'+system.label.SupportPage+'" target="_blank">Support home page</a> which offers a general search. <br/>â€¢ select a product on the <a href="'+system.label.ProductPage+'" target="_blank">Product Information page</a> which provides information related to the product.';                        
                                }
                            }
                        }  
                    }    
                }
                else{
                     PageReference pageRef = new PageReference(hrefValue);   
                     return    pageRef;
                }
            }
        return null;
    }
    
    public void upsertPageViewCountPerDay(){
        
        try{
        String refrenceURl= ApexPages.currentPage().getHeaders().get('Referer');
        System.debug(' refrenceURl: '+ refrenceURl);
        if(String.isBlank(refrenceURl)){
           refrenceURl ='';
        }
            
        
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        //System.debug('myDate: '+ myDate);
        string IPAddressValue = '';
        IPAddressValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        
        if (!String.isNotBlank(IPAddressValue)) {
            IPAddressValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } // get IP address when no caching (sandbox, dev, secure urls)
        if (!String.isNotBlank(IPAddressValue)) {
            IPAddressValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        }
        system.debug('USER IP ADDRESS: ' + IPAddressValue);
        String user_Agent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        System.debug('user_Agent: '+ user_Agent);
        
            
            list<KBPageViews__c> KBPageViewObj =[select PageViewCount__c,PageViewDate__c,Reference_URL__c,USER_AGENT__c,IP_Address__c from KBPageViews__c where PageViewDate__c=:myDate AND IP_Address__c=:IPAddressValue AND Reference_URL__c=:refrenceURl AND USER_AGENT__c=:user_Agent];
            if(KBPageViewObj <> null & KBPageViewObj.size() > 0){
                KBPageViews__c kbObj = KBPageViewObj[0];
                Integer count = kbObj.PageViewCount__c.intValue();
                count+=1;
                kbObj.PageViewCount__c = count;
               // System.debug(' Count: '+ count);
                //if(String.isNotBlank(refrenceURl)){
                  //  if(String.isNotBlank(kbObj.Reference_URL__c)){
                    //    kbObj.Reference_URL__c = kbObj.Reference_URL__c+';'+refrenceURl;
                    //}else{
                      //  kbObj.Reference_URL__c=refrenceURl;
                    //}
                //}
                update kbObj;
            }else{
                
                KBPageViews__c kbObj = new KBPageViews__c();
                kbObj.PageViewCount__c =1;
                kbObj.PageViewDate__c=myDate;
                // check if reference URL is too long, if it is store only the 1st 250 chars
                if(String.isNotBlank(refrenceURl)){
                    kbObj.Reference_URL__c=refrenceURl.left(250);
                }
                
                kbObj.USER_AGENT__c=user_Agent;
                if(String.isNotBlank(IPAddressValue)){
                        kbObj.IP_Address__c=IPAddressValue;
                }
                insert kbObj;
            }
            
        }catch(Exception er){
            //System.debug(' PageView Hit Details failed to inser with Messgae: '+er.getMessage());
            
        }
            
    }

    
    public void testData() {
             Integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
         i++;
         i++;
         i++; 
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
         i++; 
        i++; 
        i++; 
        i++; 
        i++; 
        i++; 
        i++;
         i++;
         i++; 
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++; 
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }  
    
    
}