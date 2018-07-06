public class KB_redirecttokcs{
    
    public list<Knowledge__kav> KBArticles   {get;set;}
    String pagenotfoundurl= System.Label.siteURL + 'kb_redirecttokcs?legacyid=1234', newurl;
        //'https://support.ca.com/us/not-found.html',newurl;    
    
    public PageReference redirectTopage(){
           String old_kbid=ApexPages.currentPage().getParameters().get('legacyid');
           KBArticles =  [Select id,urlname ,ArticleNumber from Knowledge__kav where publishStatus='Online' AND IsVisibleInPkb = TRUE AND  CADocid__c=:old_kbid];
           if(KBArticles<>null && KBArticles.size()>0){
               newUrl= System.Label.siteURL+KBArticles[0].urlname.toLowerCase()+'/kb'+KBArticles[0].articlenumber; 
           }else{
               newUrl=pagenotfoundurl;
           } 
           PageReference pageRef = new PageReference('/kb_redirecttokcs?legacyid=1234');
             pageRef.setRedirect(true);
        return pageRef;
    }
}