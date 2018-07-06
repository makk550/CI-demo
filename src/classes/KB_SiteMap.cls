public class KB_SiteMap{
    
    public String siteURL{get;set;}
    public List<Knowledge__kav> listOfKav{get;set;}
    public list<String> urlValue{get;set;}
    
    public integer index {get; set;}
    public String priority;
    public String frequency;
    String productName='';
    Integer pagesize = 10000;
 
    public void getArticles(){
       siteURL = System.Label.siteURL;
 
       if(ApexPages.currentPage().getParameters().get('index') == null )
           index =0 ;
       else{
          String strIndex=ApexPages.currentPage().getParameters().get('index');
          if(strIndex.IsNumeric())
            index = Integer.Valueof(strIndex);
          else
            index=-1;       
       }
 
       if(index>=-1){
           listOfKav= getListKAVs(index * pagesize ); 
           urlValue = new List<String>();

           if (index == null || index == 0){
               priority='0.8';
               frequency='daily';
           }else if (index == 1){     
               priority='0.6';
               frequency='weekly';
           }else if (index >= 2){     
               priority='0.4';
               frequency='monthly';
           }    
           for(Knowledge__kav obj:listOfKav){
               Datetime dt = obj.LastModifiedDate;
               urlValue.add('<url><loc>'+siteURL+obj.urlname.toLowerCase()+'/kb'+obj.ArticleNumber+'</loc><lastmod>'+dt.format('YYYY-MM-dd')+'</lastmod><changefreq>'+frequency+'</changefreq><priority>'+priority+'</priority></url>');
           }
       }
       else{
            priority='0';
            frequency='';
            //urlValue='';
       }
    }
    private List<Knowledge__kav> getListKAVs(integer start){
            integer articlecount;
            List<Knowledge__kav> lstKAV=new List<Knowledge__kav>();
            List<Knowledge__kav> listTotalKAV =[Select urlname, ArticleNumber,LastModifiedDate  from Knowledge__kav where publishStatus='Online' AND IsVisibleInPkb = TRUE ORDER BY LastModifiedDate DESC ];                
            //if the return count is lessthan pagesize, take that result count only.    
            
            if (listTotalKAV.size() <= start+pagesize)
                articlecount = listTotalKAV.size();
            else
                articlecount = start + pagesize;    
                
            System.debug('Start='+start+'articlecount='+articlecount);
            for (integer i=start;i<articlecount;i++){
                  System.debug('current number='+i);
                  lstKAV.add(listTotalKAV[i]);
            }            
            return lstKAV;
    } 
    public void getArticlesCount(){
            siteURL = System.Label.siteURL;
            urlValue = new List<String>();
            integer  count= database.countQuery('select count() from Knowledge__kav where publishStatus=\'Online\' AND IsVisibleInPkb = TRUE');  
            System.debug('Artcile Count='+count);
            for(integer i=0;i<(count/pagesize)+1;i++){
               urlValue.add('<sitemap><loc>'+siteURL+'kbsitemappage?index='+i+'</loc></sitemap>');
           }
    }

}