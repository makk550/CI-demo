public class MyPage_Controller {
public PageReference saveMethod()
    {
 		PageReference pgref = Page.MyPage_2;
        pgref.setRedirect(false);
        return pgref;
    }
}