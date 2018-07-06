global class kb_UrlRewriter implements Site.UrlRewriter {
    global PageReference mapRequestUrl(PageReference kburl){
        
         String url = kburl.getUrl();
        String newUrl;
        url = url.toLowerCase();
        //String kbid; //=url.substring(url.length()-9,url.length());
        //String s=url.substring(url.length()-9,url.length());
        
        integer i=url.indexof('/',2)+3;
        String kbid=url.substring(i,i+9);
        if (kbid.IsNumeric()){
            newUrl = '/kbDetails?id='+kbid;
        }else{
            System.debug('url='+url);
            newUrl=url;            
        }
        
         System.debug('newUrl:'+newUrl);
        return new PageReference(newUrl);   
    }
    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls){ 
            return null;  
    }
}