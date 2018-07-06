@IsTest
public class KB_SiteMapTest{
     @IsTest
     static void get_articles_with_0() {

        Test.startTest();
        ApexPages.currentPage().getParameters().put('index','0');
        //PageReference pageRef = Page.KBSiteMapPage;
        //pageRef.getParameters().put('index','0');
        KB_SiteMap kbsite=new KB_SiteMap();
        kbsite.getArticles();
        Test.stopTest();

        //System.assertEquals(UserInfo.getUserId(), currentUser.Id);
     }  

     @IsTest
     static void get_articles_with_1() {

        Test.startTest();
        ApexPages.currentPage().getParameters().put('index','1');
        //PageReference pageRef = Page.KBSiteMapPage;
        //pageRef.getParameters().put('index','0');
        KB_SiteMap kbsite=new KB_SiteMap();
        kbsite.getArticles();
        Test.stopTest();


     }  
    @IsTest
     static void get_articles_with_2() {

        Test.startTest();
        ApexPages.currentPage().getParameters().put('index','2');
        //PageReference pageRef = Page.KBSiteMapPage;
        //pageRef.getParameters().put('index','0');
        KB_SiteMap kbsite=new KB_SiteMap();
        kbsite.getArticles();
        Test.stopTest();

     }
     /*
     @IsTest
     static void get_articles_with_minus_1() {

        Test.startTest();
        ApexPages.currentPage().getParameters().put('index','-1');
        //PageReference pageRef = Page.KBSiteMapPage;
        //pageRef.getParameters().put('index','0');
        KB_SiteMap kbsite=new KB_SiteMap();
        kbsite.getArticles();
        Test.stopTest();
     }  */
     @IsTest
     static void get_articles_with_null() {

        Test.startTest();
        KB_SiteMap kbsite=new KB_SiteMap();
        kbsite.getArticles();
        Test.stopTest();

     }
     @IsTest
     static void get_articles_count() {

        Test.startTest();
        KB_SiteMap kbsite=new KB_SiteMap();
        kbsite.getArticlesCount();
        Test.stopTest();

     }
}