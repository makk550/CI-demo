global class CC_UrlRewriter implements Site.UrlRewriter{
    
    global PageReference mapRequestUrl(PageReference myFriendlyUrl){
        String outageurl = 'cc_outage';  
        if(Label.CC_Outage=='Outage')
            return new PageReference(outageurl);    
        String url = myFriendlyUrl.getUrl();
         System.debug('***url:'+url);
        if(url.startsWithIgnoreCase('/casemanagement/cases')){            
            url = url.toLowerCase();
            String newUrl = url.replace('/casemanagement/cases', '/casemanagement#!/cases');  
            System.debug('newUrl:'+newUrl); 
            return new PageReference(newUrl);    
        }            
        return null;        
    }
    
    global List<PageReference> generateUrlFor(List<PageReference> mySalesforceUrls){       
        return null;        
    }
    
}